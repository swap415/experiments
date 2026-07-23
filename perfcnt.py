"""In-process perf counters via perf_event_open, hybrid-PMU aware.

Counters are opened with inherit=1, so open a PerfGroup BEFORE the first
parallel kernel call (numba spawns its thread pool lazily) and every pool
thread is counted. enable()/disable() bracket exactly the measured region,
excluding JIT compilation — the thing `perf stat` on the whole process
cannot do.

Kernel encodes hybrid PMUs by putting the PMU type in config bits 32-63
(PERF_TYPE_HARDWARE extended encoding, Linux 5.13+).
"""

import ctypes
import os
import struct

PERF_TYPE_HARDWARE = 0
PERF_COUNT_HW_CPU_CYCLES = 0
PERF_COUNT_HW_INSTRUCTIONS = 1
PERF_EVENT_IOC_ENABLE = 0x2400
PERF_EVENT_IOC_DISABLE = 0x2401
PERF_EVENT_IOC_RESET = 0x2403

_libc = ctypes.CDLL(None, use_errno=True)


def _pmu_type(name):
    with open(f"/sys/bus/event_source/devices/{name}/type") as f:
        return int(f.read())


def _perf_event_open(config, type_=PERF_TYPE_HARDWARE, inherit=True):
    # struct perf_event_attr: type u32, size u32, config u64, then
    # sample_period u64, sample_type u64, read_format u64, flags u64, ...
    # read_format 3 = TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING: lets us detect
    # and scale counter multiplexing (running < enabled).
    size = 136
    flags = (1 << 0) | (1 << 1) if inherit else (1 << 0)  # disabled | inherit
    attr = struct.pack("IIQQQQQ", type_, size, config, 0, 0, 3, flags)
    attr += b"\x00" * (size - len(attr))
    buf = ctypes.create_string_buffer(attr, size)
    fd = _libc.syscall(298, buf, 0, -1, -1, 0)  # pid=0, cpu=-1(any), group=-1
    if fd < 0:
        raise OSError(ctypes.get_errno(), os.strerror(ctypes.get_errno()))
    return fd


class PerfGroup:
    """Counts cycles and instructions per PMU (P-cores vs E-cores)."""

    EVENTS = {"cycles": PERF_COUNT_HW_CPU_CYCLES,
              "instructions": PERF_COUNT_HW_INSTRUCTIONS}
    # fp_arith_inst_retired.* raw configs (umask<<8 | 0xC7), cpu_core only.
    # Counts retired FP instructions; FMA increments by 2 per instruction,
    # so count * lanes = flops directly for FMA-dominated code.
    FP_EVENTS = {"fp_scalar_double": 0x01C7, "fp_scalar_single": 0x02C7,
                 "fp_128_double": 0x04C7, "fp_128_single": 0x08C7,
                 "fp_256_double": 0x10C7, "fp_256_single": 0x20C7}
    FP_LANES = {"fp_scalar_double": 1, "fp_scalar_single": 1,
                "fp_128_double": 2, "fp_128_single": 4,
                "fp_256_double": 4, "fp_256_single": 8}

    def __init__(self, fp=False):
        self.fds = {}
        for pmu in ("cpu_core", "cpu_atom"):
            t = _pmu_type(pmu)
            for ev, code in self.EVENTS.items():
                self.fds[f"{pmu}/{ev}"] = _perf_event_open((t << 32) | code)
        if fp:
            t = _pmu_type("cpu_core")
            for ev, cfg in self.FP_EVENTS.items():
                self.fds[f"cpu_core/{ev}"] = _perf_event_open(cfg, type_=t)

    def __enter__(self):
        for fd in self.fds.values():
            _libc.ioctl(fd, PERF_EVENT_IOC_RESET, 0)
            _libc.ioctl(fd, PERF_EVENT_IOC_ENABLE, 0)
        return self

    def __exit__(self, *exc):
        for fd in self.fds.values():
            _libc.ioctl(fd, PERF_EVENT_IOC_DISABLE, 0)
        self.counts, self.multiplexed = {}, False
        for k, fd in self.fds.items():
            val, enabled, running = struct.unpack("qqq", os.read(fd, 24))
            if running and running < enabled:  # multiplexed: scale estimate
                val = round(val * enabled / running)
                self.multiplexed = True
            self.counts[k] = val
        return False

    def flops(self):
        """Executed flops from fp_arith counters (requires fp=True)."""
        return sum(self.counts[f"cpu_core/{ev}"] * lanes
                   for ev, lanes in self.FP_LANES.items())

    def close(self):
        for fd in self.fds.values():
            os.close(fd)

    def report(self):
        c = self.counts
        lines = []
        for pmu in ("cpu_core", "cpu_atom"):
            cyc, ins = c[f"{pmu}/cycles"], c[f"{pmu}/instructions"]
            ipc = ins / cyc if cyc else 0.0
            lines.append(f"{pmu:8s} {cyc/1e9:8.3f} Gcycles  {ins/1e9:8.3f} Ginsn  ipc {ipc:4.2f}")
        return "\n".join(lines)
