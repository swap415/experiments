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


def _perf_event_open(config, inherit=True):
    # struct perf_event_attr: type u32, size u32, config u64, then
    # sample_period u64, sample_type u64, read_format u64, flags u64, ...
    size = 136
    flags = (1 << 0) | (1 << 1) if inherit else (1 << 0)  # disabled | inherit
    attr = struct.pack("IIQQQQQ", PERF_TYPE_HARDWARE, size, config, 0, 0, 0, flags)
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

    def __init__(self):
        self.fds = {}
        for pmu in ("cpu_core", "cpu_atom"):
            t = _pmu_type(pmu)
            for ev, code in self.EVENTS.items():
                self.fds[f"{pmu}/{ev}"] = _perf_event_open((t << 32) | code)

    def __enter__(self):
        for fd in self.fds.values():
            _libc.ioctl(fd, PERF_EVENT_IOC_RESET, 0)
            _libc.ioctl(fd, PERF_EVENT_IOC_ENABLE, 0)
        return self

    def __exit__(self, *exc):
        for fd in self.fds.values():
            _libc.ioctl(fd, PERF_EVENT_IOC_DISABLE, 0)
        self.counts = {k: struct.unpack("q", os.read(fd, 8))[0]
                       for k, fd in self.fds.items()}
        return False

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
