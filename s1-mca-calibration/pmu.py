"""Grouped Linux perf counters for a pinned x86-64 thread.

Only generic counters live here. Raw event encodings are deliberately kept
out of the portable measurement core.
"""

from __future__ import annotations

import ctypes
import fcntl
import os
import platform
import struct
from pathlib import Path


PERF_TYPE_HARDWARE = 0
PERF_COUNT_HW_CPU_CYCLES = 0
PERF_COUNT_HW_INSTRUCTIONS = 1
PERF_COUNT_HW_BRANCH_INSTRUCTIONS = 4
PERF_COUNT_HW_BRANCH_MISSES = 5
PERF_COUNT_HW_REF_CPU_CYCLES = 9

PERF_FORMAT_TOTAL_TIME_ENABLED = 1 << 0
PERF_FORMAT_TOTAL_TIME_RUNNING = 1 << 1
PERF_FORMAT_GROUP = 1 << 3

PERF_EVENT_IOC_ENABLE = 0x2400
PERF_EVENT_IOC_DISABLE = 0x2401
PERF_EVENT_IOC_RESET = 0x2403
PERF_IOC_FLAG_GROUP = 1
PERF_PMU_TYPE_SHIFT = 32

EVENTS = (
    ("cycles", PERF_COUNT_HW_CPU_CYCLES),
    ("instructions", PERF_COUNT_HW_INSTRUCTIONS),
    ("branches", PERF_COUNT_HW_BRANCH_INSTRUCTIONS),
    ("branch_misses", PERF_COUNT_HW_BRANCH_MISSES),
    ("ref_cycles", PERF_COUNT_HW_REF_CPU_CYCLES),
)

_LIBC = ctypes.CDLL(None, use_errno=True)


def _syscall_number() -> int:
    machine = platform.machine()
    if machine == "x86_64":
        return 298
    raise RuntimeError(f"perf_event_open syscall is not defined for {machine!r}")


def parse_cpu_list(spec: str) -> set[int]:
    """Parse Linux cpulist syntax such as 0-3,8,10-11."""
    cpus: set[int] = set()
    for part in spec.strip().split(","):
        if not part:
            continue
        if "-" in part:
            lo, hi = (int(x) for x in part.split("-", 1))
            cpus.update(range(lo, hi + 1))
        else:
            cpus.add(int(part))
    return cpus


def pmu_for_cpu(cpu: int) -> tuple[str, int]:
    """Return the hybrid PMU name/type associated with cpu."""
    root = Path("/sys/bus/event_source/devices")
    for name in ("cpu_core", "cpu_atom"):
        cpus_path = root / name / "cpus"
        type_path = root / name / "type"
        if cpus_path.exists() and cpu in parse_cpu_list(cpus_path.read_text()):
            return name, int(type_path.read_text())
    return "cpu", 0


def require_single_cpu(cpu: int) -> tuple[str, int]:
    affinity = os.sched_getaffinity(0)
    if affinity != {cpu}:
        raise RuntimeError(
            f"measurement process must be pinned to CPU {cpu}; affinity is "
            f"{sorted(affinity)}"
        )
    return pmu_for_cpu(cpu)


def _event_attr(config: int) -> ctypes.Array:
    # PERF_ATTR_SIZE_VER6 is sufficient for all fields used here.
    size = 120
    read_format = (
        PERF_FORMAT_TOTAL_TIME_ENABLED
        | PERF_FORMAT_TOTAL_TIME_RUNNING
        | PERF_FORMAT_GROUP
    )
    # perf_event_attr flags: disabled, exclude_kernel, exclude_hv.
    flags = (1 << 0) | (1 << 5) | (1 << 6)
    data = struct.pack(
        "=IIQQQQQ", PERF_TYPE_HARDWARE, size, config, 0, 0, read_format, flags
    )
    data += bytes(size - len(data))
    return ctypes.create_string_buffer(data, size)


def _open_event(config: int, group_fd: int) -> int:
    attr = _event_attr(config)
    fd = _LIBC.syscall(
        _syscall_number(), attr, 0, -1, group_fd, 0
    )
    if fd < 0:
        err = ctypes.get_errno()
        raise OSError(err, os.strerror(err))
    return int(fd)


class CounterGroup:
    """A grouped set of generic counters with multiplexing made visible."""

    def __init__(self, cpu: int):
        self.cpu = cpu
        self.pmu_name, pmu_type = require_single_cpu(cpu)
        prefix = pmu_type << PERF_PMU_TYPE_SHIFT if pmu_type else 0
        self.names: list[str] = []
        self.fds: list[int] = []
        try:
            for name, event in EVENTS:
                fd = _open_event(prefix | event, self.fds[0] if self.fds else -1)
                self.names.append(name)
                self.fds.append(fd)
        except BaseException:
            self.close()
            raise

    @property
    def leader(self) -> int:
        if not self.fds:
            raise RuntimeError("counter group is closed")
        return self.fds[0]

    def start(self) -> None:
        fcntl.ioctl(self.leader, PERF_EVENT_IOC_RESET, PERF_IOC_FLAG_GROUP)
        fcntl.ioctl(self.leader, PERF_EVENT_IOC_ENABLE, PERF_IOC_FLAG_GROUP)

    def stop(self) -> dict[str, int | float]:
        fcntl.ioctl(self.leader, PERF_EVENT_IOC_DISABLE, PERF_IOC_FLAG_GROUP)
        words = 3 + len(self.names)
        payload = os.read(self.leader, words * 8)
        if len(payload) != words * 8:
            raise RuntimeError(
                f"short perf group read: got {len(payload)}, expected {words * 8}"
            )
        values = struct.unpack(f"={words}Q", payload)
        nr, enabled, running, *counts = values
        if nr != len(self.names):
            raise RuntimeError(f"perf group returned {nr} events, expected {len(self.names)}")
        result: dict[str, int | float] = dict(zip(self.names, counts))
        result["time_enabled_ns"] = enabled
        result["time_running_ns"] = running
        result["running_fraction"] = running / enabled if enabled else 0.0
        return result

    def close(self) -> None:
        for fd in getattr(self, "fds", ()):
            try:
                os.close(fd)
            except OSError:
                pass
        self.fds = []


def smoke_test(cpu: int) -> dict[str, int | float]:
    """Exercise the ABI and return a small non-zero counter sample."""
    group = CounterGroup(cpu)
    try:
        group.start()
        value = 0
        for i in range(100_000):
            value ^= i
        counts = group.stop()
        if value == -1:
            raise AssertionError
        if counts["cycles"] <= 0 or counts["instructions"] <= 0:
            raise RuntimeError(f"invalid perf counts: {counts}")
        return counts
    finally:
        group.close()
