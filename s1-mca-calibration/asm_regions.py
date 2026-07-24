"""Extract candidate steady-state loop blocks from Numba native assembly."""

from __future__ import annotations

import dataclasses
import re
from collections.abc import Iterable


_LABEL = re.compile(r"^([.$A-Za-z_][\w.$]*):(?:\s*#.*)?$")
_BRANCH = re.compile(r"^(j[a-z]+)\s+([^,\s]+)", re.IGNORECASE)


@dataclasses.dataclass(frozen=True)
class LoopBlock:
    label: str
    first_line: int
    last_line: int
    instructions: tuple[str, ...]
    branch: str
    target: str
    work_score: int

    @property
    def instruction_count(self) -> int:
        return len(self.instructions)


def native_symbol(dispatcher) -> str:
    if len(dispatcher.overloads) != 1:
        raise RuntimeError(
            f"expected one compiled signature, found {len(dispatcher.overloads)}"
        )
    result = next(iter(dispatcher.overloads.values()))
    return result.fndesc.llvm_func_name


def extract_function(assembly: str, symbol: str) -> list[str]:
    """Extract one function body without relying on file position."""
    lines = assembly.splitlines()
    start = next(
        (i for i, line in enumerate(lines) if line.strip() == f"{symbol}:"), None
    )
    if start is None:
        raise ValueError(f"native symbol {symbol!r} was not found in assembly")
    end = None
    size_prefixes = (f".size\t{symbol}", f".size {symbol}")
    for i in range(start + 1, len(lines)):
        stripped = lines[i].strip()
        if stripped.startswith(size_prefixes):
            end = i
            break
        if stripped.startswith(".globl") and i > start + 1:
            end = i
            break
    if end is None:
        raise ValueError(f"could not find the end of native symbol {symbol!r}")
    return lines[start:end]


def _instruction(line: str) -> str | None:
    stripped = line.strip()
    if not stripped or stripped.startswith((".", "#")) or _LABEL.match(stripped):
        return None
    return stripped.split("#", 1)[0].rstrip() or None


def _work_score(instructions: Iterable[str]) -> int:
    score = 0
    for inst in instructions:
        mnemonic = inst.split(None, 1)[0].lower()
        if mnemonic.startswith("v"):
            score += 8
        if any(token in mnemonic for token in ("add", "sub", "mul", "div", "fma", "sqrt")):
            score += 5
        if mnemonic.startswith(("mov", "vmov", "lea")):
            score += 2
        score += 1
    return score


def self_loop_blocks(function_lines: list[str]) -> list[LoopBlock]:
    """Find basic blocks whose terminating branch targets their own label."""
    labels: list[tuple[int, str]] = []
    for i, line in enumerate(function_lines):
        match = _LABEL.match(line.strip())
        if match:
            labels.append((i, match.group(1)))

    blocks: list[LoopBlock] = []
    for pos, (start, label) in enumerate(labels):
        label_end = (
            labels[pos + 1][0] if pos + 1 < len(labels) else len(function_lines)
        )
        collected: list[str] = []
        end = label_end
        for line_index in range(start + 1, label_end):
            inst = _instruction(function_lines[line_index])
            if inst is None:
                continue
            collected.append(inst)
            mnemonic = inst.split(None, 1)[0].lower()
            if _BRANCH.match(inst) or mnemonic.startswith("ret"):
                end = line_index + 1
                break

        instructions = tuple(collected)
        if not instructions:
            continue
        branch_match = _BRANCH.match(instructions[-1])
        if not branch_match:
            continue
        branch, target = branch_match.groups()
        target = target.split("@", 1)[0]
        if target != label:
            continue
        blocks.append(
            LoopBlock(
                label=label,
                first_line=start,
                last_line=end - 1,
                instructions=instructions,
                branch=branch.lower(),
                target=target,
                work_score=_work_score(instructions),
            )
        )
    return blocks


def select_static_candidate(blocks: list[LoopBlock]) -> LoopBlock:
    if not blocks:
        raise ValueError("no single-basic-block self loop found")
    # Explicitly a static hypothesis. LBR validation is required before the
    # selected block may be called dynamically dominant.
    return max(blocks, key=lambda b: (b.work_score, b.instruction_count, -b.first_line))


def mca_region(block: LoopBlock, name: str) -> str:
    safe_name = re.sub(r"[^A-Za-z0-9_.-]", "_", name)
    body = "\n".join(f"\t{inst}" for inst in block.instructions)
    return (
        ".text\n"
        f"# LLVM-MCA-BEGIN {safe_name}\n"
        f"{block.label}:\n"
        f"{body}\n"
        "# LLVM-MCA-END\n"
    )
