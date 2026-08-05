	.text
	.file	"kernels.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function saxpy
.LCPI0_0:
	.quad	0x4000000000000000              # double 2
	.text
	.globl	saxpy
	.p2align	4, 0x90
	.type	saxpy,@function
saxpy:                                  # @saxpy
	.cfi_startproc
# %bb.0:
	testq	%rdx, %rdx
	jle	.LBB0_15
# %bb.1:
	cmpq	$16, %rdx
	jb	.LBB0_2
# %bb.3:
	leaq	(%rsi,%rdx,8), %rax
	cmpq	%rdi, %rax
	jbe	.LBB0_6
# %bb.4:
	leaq	(%rdi,%rdx,8), %rax
	cmpq	%rsi, %rax
	jbe	.LBB0_6
.LBB0_2:
	xorl	%eax, %eax
.LBB0_9:
	movq	%rdx, %r8
	movq	%rax, %rcx
	andq	$7, %r8
	je	.LBB0_12
# %bb.10:
	vmovsd	.LCPI0_0(%rip), %xmm0           # xmm0 = [2.0E+0,0.0E+0]
	movq	%rax, %rcx
	.p2align	4, 0x90
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	vmovsd	(%rsi,%rcx,8), %xmm1            # xmm1 = mem[0],zero
	vfmadd213sd	(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, (%rdi,%rcx,8)
	incq	%rcx
	decq	%r8
	jne	.LBB0_11
.LBB0_12:
	subq	%rdx, %rax
	cmpq	$-8, %rax
	ja	.LBB0_15
# %bb.13:
	vmovsd	.LCPI0_0(%rip), %xmm0           # xmm0 = [2.0E+0,0.0E+0]
	.p2align	4, 0x90
.LBB0_14:                               # =>This Inner Loop Header: Depth=1
	vmovsd	(%rsi,%rcx,8), %xmm1            # xmm1 = mem[0],zero
	vfmadd213sd	(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, (%rdi,%rcx,8)
	vmovsd	8(%rsi,%rcx,8), %xmm1           # xmm1 = mem[0],zero
	vfmadd213sd	8(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, 8(%rdi,%rcx,8)
	vmovsd	16(%rsi,%rcx,8), %xmm1          # xmm1 = mem[0],zero
	vfmadd213sd	16(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, 16(%rdi,%rcx,8)
	vmovsd	24(%rsi,%rcx,8), %xmm1          # xmm1 = mem[0],zero
	vfmadd213sd	24(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, 24(%rdi,%rcx,8)
	vmovsd	32(%rsi,%rcx,8), %xmm1          # xmm1 = mem[0],zero
	vfmadd213sd	32(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, 32(%rdi,%rcx,8)
	vmovsd	40(%rsi,%rcx,8), %xmm1          # xmm1 = mem[0],zero
	vfmadd213sd	40(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, 40(%rdi,%rcx,8)
	vmovsd	48(%rsi,%rcx,8), %xmm1          # xmm1 = mem[0],zero
	vfmadd213sd	48(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, 48(%rdi,%rcx,8)
	vmovsd	56(%rsi,%rcx,8), %xmm1          # xmm1 = mem[0],zero
	vfmadd213sd	56(%rdi,%rcx,8), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovsd	%xmm1, 56(%rdi,%rcx,8)
	addq	$8, %rcx
	cmpq	%rcx, %rdx
	jne	.LBB0_14
	jmp	.LBB0_15
.LBB0_6:
	movabsq	$9223372036854775792, %rax      # imm = 0x7FFFFFFFFFFFFFF0
	andq	%rdx, %rax
	xorl	%ecx, %ecx
	vbroadcastsd	.LCPI0_0(%rip), %ymm0   # ymm0 = [2.0E+0,2.0E+0,2.0E+0,2.0E+0]
	.p2align	4, 0x90
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	vmovupd	(%rsi,%rcx,8), %ymm1
	vmovupd	32(%rsi,%rcx,8), %ymm2
	vmovupd	64(%rsi,%rcx,8), %ymm3
	vmovupd	96(%rsi,%rcx,8), %ymm4
	vfmadd213pd	(%rdi,%rcx,8), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vfmadd213pd	32(%rdi,%rcx,8), %ymm0, %ymm2 # ymm2 = (ymm0 * ymm2) + mem
	vfmadd213pd	64(%rdi,%rcx,8), %ymm0, %ymm3 # ymm3 = (ymm0 * ymm3) + mem
	vfmadd213pd	96(%rdi,%rcx,8), %ymm0, %ymm4 # ymm4 = (ymm0 * ymm4) + mem
	vmovupd	%ymm1, (%rdi,%rcx,8)
	vmovupd	%ymm2, 32(%rdi,%rcx,8)
	vmovupd	%ymm3, 64(%rdi,%rcx,8)
	vmovupd	%ymm4, 96(%rdi,%rcx,8)
	addq	$16, %rcx
	cmpq	%rcx, %rax
	jne	.LBB0_7
# %bb.8:
	cmpq	%rdx, %rax
	jne	.LBB0_9
.LBB0_15:
	vzeroupper
	retq
.Lfunc_end0:
	.size	saxpy, .Lfunc_end0-saxpy
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function poly96
.LCPI1_0:
	.quad	0x3fb999999999999a              # double 0.10000000000000001
.LCPI1_1:
	.quad	0x3ff00068db8bac71              # double 1.0001
	.text
	.globl	poly96
	.p2align	4, 0x90
	.type	poly96,@function
poly96:                                 # @poly96
	.cfi_startproc
# %bb.0:
	testq	%rdx, %rdx
	jle	.LBB1_8
# %bb.1:
	xorl	%eax, %eax
	cmpq	$4, %rdx
	jb	.LBB1_6
# %bb.2:
	movq	%rdi, %rcx
	subq	%rsi, %rcx
	cmpq	$32, %rcx
	jb	.LBB1_6
# %bb.3:
	movabsq	$9223372036854775804, %rax      # imm = 0x7FFFFFFFFFFFFFFC
	andq	%rdx, %rax
	xorl	%ecx, %ecx
	vbroadcastsd	.LCPI1_0(%rip), %ymm0   # ymm0 = [1.0000000000000001E-1,1.0000000000000001E-1,1.0000000000000001E-1,1.0000000000000001E-1]
	vbroadcastsd	.LCPI1_1(%rip), %ymm1   # ymm1 = [1.0001E+0,1.0001E+0,1.0001E+0,1.0001E+0]
	.p2align	4, 0x90
.LBB1_4:                                # =>This Inner Loop Header: Depth=1
	vmovupd	(%rsi,%rcx,8), %ymm2
	vmovapd	%ymm0, %ymm3
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vfmadd213pd	%ymm1, %ymm2, %ymm3     # ymm3 = (ymm2 * ymm3) + ymm1
	vmovupd	%ymm3, (%rdi,%rcx,8)
	addq	$4, %rcx
	cmpq	%rcx, %rax
	jne	.LBB1_4
# %bb.5:
	cmpq	%rdx, %rax
	je	.LBB1_8
.LBB1_6:
	vmovsd	.LCPI1_1(%rip), %xmm0           # xmm0 = [1.0001E+0,0.0E+0]
	vmovsd	.LCPI1_0(%rip), %xmm1           # xmm1 = [1.0000000000000001E-1,0.0E+0]
	.p2align	4, 0x90
.LBB1_7:                                # =>This Inner Loop Header: Depth=1
	vmovsd	(%rsi,%rax,8), %xmm2            # xmm2 = mem[0],zero
	vmovapd	%xmm0, %xmm3
	vfmadd231sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm1) + xmm3
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vfmadd213sd	%xmm0, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm0
	vmovsd	%xmm3, (%rdi,%rax,8)
	incq	%rax
	cmpq	%rax, %rdx
	jne	.LBB1_7
.LBB1_8:
	vzeroupper
	retq
.Lfunc_end1:
	.size	poly96, .Lfunc_end1-poly96
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function poly112
.LCPI2_0:
	.quad	0x3fb999999999999a              # double 0.10000000000000001
.LCPI2_1:
	.quad	0x3ff00068db8bac71              # double 1.0001
	.text
	.globl	poly112
	.p2align	4, 0x90
	.type	poly112,@function
poly112:                                # @poly112
	.cfi_startproc
# %bb.0:
	testq	%rdx, %rdx
	jle	.LBB2_5
# %bb.1:
	xorl	%eax, %eax
	vmovsd	.LCPI2_0(%rip), %xmm0           # xmm0 = [1.0000000000000001E-1,0.0E+0]
	vmovsd	.LCPI2_1(%rip), %xmm1           # xmm1 = [1.0001E+0,0.0E+0]
	.p2align	4, 0x90
.LBB2_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
	vmovsd	(%rsi,%rax,8), %xmm2            # xmm2 = mem[0],zero
	movl	$112, %ecx
	vmovapd	%xmm0, %xmm3
	.p2align	4, 0x90
.LBB2_3:                                #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	vfmadd213sd	%xmm1, %xmm2, %xmm3     # xmm3 = (xmm2 * xmm3) + xmm1
	addl	$-16, %ecx
	jne	.LBB2_3
# %bb.4:                                #   in Loop: Header=BB2_2 Depth=1
	vmovsd	%xmm3, (%rdi,%rax,8)
	incq	%rax
	cmpq	%rdx, %rax
	jne	.LBB2_2
.LBB2_5:
	retq
.Lfunc_end2:
	.size	poly112, .Lfunc_end2-poly112
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function reduction64
.LCPI3_0:
	.quad	0x3fd3333333333333              # double 0.29999999999999999
.LCPI3_1:
	.quad	0x3ff00068db8bac71              # double 1.0001
	.text
	.globl	reduction64
	.p2align	4, 0x90
	.type	reduction64,@function
reduction64:                            # @reduction64
	.cfi_startproc
# %bb.0:
	testq	%rsi, %rsi
	jle	.LBB3_1
# %bb.2:
	cmpq	$16, %rsi
	jae	.LBB3_4
# %bb.3:
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.LBB3_7
.LBB3_1:
	vxorps	%xmm0, %xmm0, %xmm0
	retq
.LBB3_4:
	movabsq	$9223372036854775792, %rax      # imm = 0x7FFFFFFFFFFFFFF0
	andq	%rsi, %rax
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vbroadcastsd	.LCPI3_0(%rip), %ymm1   # ymm1 = [2.9999999999999999E-1,2.9999999999999999E-1,2.9999999999999999E-1,2.9999999999999999E-1]
	vbroadcastsd	.LCPI3_1(%rip), %ymm2   # ymm2 = [1.0001E+0,1.0001E+0,1.0001E+0,1.0001E+0]
	vxorpd	%xmm3, %xmm3, %xmm3
	vxorpd	%xmm4, %xmm4, %xmm4
	vxorpd	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB3_5:                                # =>This Inner Loop Header: Depth=1
	vmovupd	(%rdi,%rcx,8), %ymm9
	vmovupd	32(%rdi,%rcx,8), %ymm8
	vmovupd	64(%rdi,%rcx,8), %ymm7
	vmovupd	96(%rdi,%rcx,8), %ymm6
	vmovapd	%ymm1, %ymm13
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vmovapd	%ymm1, %ymm12
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vmovapd	%ymm1, %ymm11
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vmovapd	%ymm1, %ymm10
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vfmadd213pd	%ymm2, %ymm9, %ymm13    # ymm13 = (ymm9 * ymm13) + ymm2
	vaddpd	%ymm0, %ymm13, %ymm0
	vfmadd213pd	%ymm2, %ymm8, %ymm12    # ymm12 = (ymm8 * ymm12) + ymm2
	vaddpd	%ymm3, %ymm12, %ymm3
	vfmadd213pd	%ymm2, %ymm7, %ymm11    # ymm11 = (ymm7 * ymm11) + ymm2
	vaddpd	%ymm4, %ymm11, %ymm4
	vfmadd213pd	%ymm2, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm2
	vaddpd	%ymm5, %ymm10, %ymm5
	addq	$16, %rcx
	cmpq	%rcx, %rax
	jne	.LBB3_5
# %bb.6:
	vaddpd	%ymm0, %ymm3, %ymm0
	vaddpd	%ymm0, %ymm4, %ymm0
	vaddpd	%ymm0, %ymm5, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vaddpd	%xmm1, %xmm0, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddsd	%xmm1, %xmm0, %xmm0
	cmpq	%rsi, %rax
	je	.LBB3_9
.LBB3_7:
	vmovsd	.LCPI3_1(%rip), %xmm1           # xmm1 = [1.0001E+0,0.0E+0]
	vmovsd	.LCPI3_0(%rip), %xmm2           # xmm2 = [2.9999999999999999E-1,0.0E+0]
	.p2align	4, 0x90
.LBB3_8:                                # =>This Inner Loop Header: Depth=1
	vmovsd	(%rdi,%rax,8), %xmm3            # xmm3 = mem[0],zero
	vmovapd	%xmm1, %xmm4
	vfmadd231sd	%xmm2, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm2) + xmm4
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vfmadd213sd	%xmm1, %xmm3, %xmm4     # xmm4 = (xmm3 * xmm4) + xmm1
	vaddsd	%xmm0, %xmm4, %xmm0
	incq	%rax
	cmpq	%rax, %rsi
	jne	.LBB3_8
.LBB3_9:
	vzeroupper
	retq
.Lfunc_end3:
	.size	reduction64, .Lfunc_end3-reduction64
	.cfi_endproc
                                        # -- End function
	.globl	stencil64                       # -- Begin function stencil64
	.p2align	4, 0x90
	.type	stencil64,@function
stencil64:                              # @stencil64
	.cfi_startproc
# %bb.0:
	cmpq	$65, %rcx
	jl	.LBB4_3
# %bb.1:
	addq	$-64, %rcx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB4_2:                                # =>This Inner Loop Header: Depth=1
	vmovupd	(%rdx), %ymm0
	vmovupd	32(%rdx), %ymm1
	vmovupd	64(%rdx), %ymm2
	vmulpd	(%rsi,%rax,8), %ymm0, %ymm0
	vfmadd231pd	32(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm1 * mem) + ymm0
	vmovupd	96(%rdx), %ymm1
	vfmadd231pd	64(%rsi,%rax,8), %ymm2, %ymm0 # ymm0 = (ymm2 * mem) + ymm0
	vfmadd231pd	96(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm1 * mem) + ymm0
	vmovupd	128(%rdx), %ymm1
	vfmadd132pd	128(%rsi,%rax,8), %ymm0, %ymm1 # ymm1 = (ymm1 * mem) + ymm0
	vmovupd	160(%rdx), %ymm0
	vfmadd132pd	160(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm0 * mem) + ymm1
	vmovupd	192(%rdx), %ymm1
	vfmadd132pd	192(%rsi,%rax,8), %ymm0, %ymm1 # ymm1 = (ymm1 * mem) + ymm0
	vmovupd	224(%rdx), %ymm0
	vfmadd132pd	224(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm0 * mem) + ymm1
	vmovupd	256(%rdx), %ymm1
	vfmadd132pd	256(%rsi,%rax,8), %ymm0, %ymm1 # ymm1 = (ymm1 * mem) + ymm0
	vmovupd	288(%rdx), %ymm0
	vfmadd132pd	288(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm0 * mem) + ymm1
	vmovupd	320(%rdx), %ymm1
	vfmadd132pd	320(%rsi,%rax,8), %ymm0, %ymm1 # ymm1 = (ymm1 * mem) + ymm0
	vmovupd	352(%rdx), %ymm0
	vfmadd132pd	352(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm0 * mem) + ymm1
	vmovupd	384(%rdx), %ymm1
	vfmadd132pd	384(%rsi,%rax,8), %ymm0, %ymm1 # ymm1 = (ymm1 * mem) + ymm0
	vmovupd	416(%rdx), %ymm0
	vfmadd132pd	416(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm0 * mem) + ymm1
	vmovupd	448(%rdx), %ymm1
	vfmadd132pd	448(%rsi,%rax,8), %ymm0, %ymm1 # ymm1 = (ymm1 * mem) + ymm0
	vmovupd	480(%rdx), %ymm0
	vfmadd132pd	480(%rsi,%rax,8), %ymm1, %ymm0 # ymm0 = (ymm0 * mem) + ymm1
	vextractf128	$1, %ymm0, %xmm1
	vaddpd	%xmm1, %xmm0, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rdi,%rax,8)
	incq	%rax
	cmpq	%rax, %rcx
	jne	.LBB4_2
.LBB4_3:
	vzeroupper
	retq
.Lfunc_end4:
	.size	stencil64, .Lfunc_end4-stencil64
	.cfi_endproc
                                        # -- End function
	.globl	gather64                        # -- Begin function gather64
	.p2align	4, 0x90
	.type	gather64,@function
gather64:                               # @gather64
	.cfi_startproc
# %bb.0:
	testq	%r8, %r8
	jle	.LBB5_4
# %bb.1:
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	vmovups	(%rdx), %ymm0
	vmovups	%ymm0, (%rsp)                   # 32-byte Spill
	vmovups	32(%rdx), %ymm0
	vmovups	%ymm0, -32(%rsp)                # 32-byte Spill
	vmovups	64(%rdx), %ymm0
	vmovups	%ymm0, -64(%rsp)                # 32-byte Spill
	vmovups	96(%rdx), %ymm0
	vmovups	%ymm0, -96(%rsp)                # 32-byte Spill
	vmovdqu	128(%rdx), %ymm0
	vmovdqu	%ymm0, -128(%rsp)               # 32-byte Spill
	vmovupd	160(%rdx), %ymm5
	vmovupd	192(%rdx), %ymm6
	vmovupd	224(%rdx), %ymm7
	vmovupd	256(%rdx), %ymm8
	vmovupd	288(%rdx), %ymm9
	vmovupd	320(%rdx), %ymm10
	vmovupd	352(%rdx), %ymm11
	vmovupd	384(%rdx), %ymm12
	vmovupd	416(%rdx), %ymm13
	vmovupd	448(%rdx), %ymm14
	vmovupd	480(%rdx), %ymm15
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB5_2:                                # =>This Inner Loop Header: Depth=1
	movl	%eax, %edx
	andl	$7, %edx
	leaq	(%rsi,%rdx,8), %rdx
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm1, %xmm1, %xmm1
	vmovupd	(%rsp), %ymm2                   # 32-byte Reload
	vgatherqpd	%ymm0, (%rdx,%ymm2,8), %ymm1
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm2, %xmm2, %xmm2
	vmovupd	-32(%rsp), %ymm3                # 32-byte Reload
	vgatherqpd	%ymm0, (%rdx,%ymm3,8), %ymm2
	vmulpd	(%rcx), %ymm1, %ymm0
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vxorpd	%xmm3, %xmm3, %xmm3
	vmovupd	-64(%rsp), %ymm4                # 32-byte Reload
	vgatherqpd	%ymm1, (%rdx,%ymm4,8), %ymm3
	vfmadd132pd	32(%rcx), %ymm0, %ymm2  # ymm2 = (ymm2 * mem) + ymm0
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm1, %xmm1, %xmm1
	vmovupd	-96(%rsp), %ymm4                # 32-byte Reload
	vgatherqpd	%ymm0, (%rdx,%ymm4,8), %ymm1
	vfmadd132pd	64(%rcx), %ymm2, %ymm3  # ymm3 = (ymm3 * mem) + ymm2
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm2, %xmm2, %xmm2
	vmovupd	-128(%rsp), %ymm4               # 32-byte Reload
	vgatherqpd	%ymm0, (%rdx,%ymm4,8), %ymm2
	vfmadd132pd	96(%rcx), %ymm3, %ymm1  # ymm1 = (ymm1 * mem) + ymm3
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm3, %xmm3, %xmm3
	vgatherqpd	%ymm0, (%rdx,%ymm5,8), %ymm3
	vfmadd132pd	128(%rcx), %ymm1, %ymm2 # ymm2 = (ymm2 * mem) + ymm1
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm1, %xmm1, %xmm1
	vgatherqpd	%ymm0, (%rdx,%ymm6,8), %ymm1
	vfmadd132pd	160(%rcx), %ymm2, %ymm3 # ymm3 = (ymm3 * mem) + ymm2
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm2, %xmm2, %xmm2
	vgatherqpd	%ymm0, (%rdx,%ymm7,8), %ymm2
	vfmadd132pd	192(%rcx), %ymm3, %ymm1 # ymm1 = (ymm1 * mem) + ymm3
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm3, %xmm3, %xmm3
	vgatherqpd	%ymm0, (%rdx,%ymm8,8), %ymm3
	vfmadd132pd	224(%rcx), %ymm1, %ymm2 # ymm2 = (ymm2 * mem) + ymm1
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm1, %xmm1, %xmm1
	vgatherqpd	%ymm0, (%rdx,%ymm9,8), %ymm1
	vfmadd132pd	256(%rcx), %ymm2, %ymm3 # ymm3 = (ymm3 * mem) + ymm2
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm2, %xmm2, %xmm2
	vgatherqpd	%ymm0, (%rdx,%ymm10,8), %ymm2
	vfmadd132pd	288(%rcx), %ymm3, %ymm1 # ymm1 = (ymm1 * mem) + ymm3
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm3, %xmm3, %xmm3
	vgatherqpd	%ymm0, (%rdx,%ymm11,8), %ymm3
	vfmadd132pd	320(%rcx), %ymm1, %ymm2 # ymm2 = (ymm2 * mem) + ymm1
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm1, %xmm1, %xmm1
	vgatherqpd	%ymm0, (%rdx,%ymm12,8), %ymm1
	vfmadd132pd	352(%rcx), %ymm2, %ymm3 # ymm3 = (ymm3 * mem) + ymm2
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm2, %xmm2, %xmm2
	vgatherqpd	%ymm0, (%rdx,%ymm13,8), %ymm2
	vfmadd132pd	384(%rcx), %ymm3, %ymm1 # ymm1 = (ymm1 * mem) + ymm3
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm3, %xmm3, %xmm3
	vgatherqpd	%ymm0, (%rdx,%ymm14,8), %ymm3
	vfmadd132pd	416(%rcx), %ymm1, %ymm2 # ymm2 = (ymm2 * mem) + ymm1
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorpd	%xmm1, %xmm1, %xmm1
	vgatherqpd	%ymm0, (%rdx,%ymm15,8), %ymm1
	vfmadd132pd	448(%rcx), %ymm2, %ymm3 # ymm3 = (ymm3 * mem) + ymm2
	vfmadd132pd	480(%rcx), %ymm3, %ymm1 # ymm1 = (ymm1 * mem) + ymm3
	vextractf128	$1, %ymm1, %xmm0
	vaddpd	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rdi,%rax,8)
	incq	%rax
	cmpq	%rax, %r8
	jne	.LBB5_2
# %bb.3:
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
.LBB5_4:
	vzeroupper
	retq
.Lfunc_end5:
	.size	gather64, .Lfunc_end5-gather64
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
