"""Dependency-free unit tests; run with python test_unit.py."""

import unittest

from asm_regions import extract_function, mca_region, select_static_candidate, self_loop_blocks
from pmu import parse_cpu_list


class CpuListTests(unittest.TestCase):
    def test_cpu_list(self):
        self.assertEqual(parse_cpu_list("0-2,5,8-9\n"), {0, 1, 2, 5, 8, 9})


class AssemblyTests(unittest.TestCase):
    ASM = """
    .text
    .globl foo
    .type foo,@function
foo:
    pushq %rbp
.LBB0_1:
    vfmadd213pd %ymm0, %ymm1, %ymm2
    addq $4, %rax
    cmpq %rcx, %rax
    jne .LBB0_1
    movq %rax, %rdx
    je .LBB0_2
.LBB0_2:
    retq
    .size foo, .Lfunc_end0-foo
    .globl wrapper
wrapper:
    retq
"""

    def test_extract_and_find_loop(self):
        function = extract_function(self.ASM, "foo")
        blocks = self_loop_blocks(function)
        self.assertEqual(len(blocks), 1)
        self.assertEqual(blocks[0].label, ".LBB0_1")
        self.assertEqual(blocks[0].instruction_count, 4)
        selected = select_static_candidate(blocks)
        region = mca_region(selected, "map/f64")
        self.assertIn("LLVM-MCA-BEGIN map_f64", region)
        self.assertIn("jne .LBB0_1", region)
        self.assertNotIn("%rdx", region)


if __name__ == "__main__":
    unittest.main()
