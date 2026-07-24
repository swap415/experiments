_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v5B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	movq	48(%rsp), %rcx
	movq	88(%rsp), %rdx
	movq	8(%rsp), %rax
	vmovsd	(%rax), %xmm1
	testq	%rdx, %rdx
	setle	%sil
	testq	%rcx, %rcx
	setle	%r8b
	orb	%sil, %r8b
	je	.LBB0_1
.LBB0_7:
	vmovsd	%xmm1, (%rax)
	vmovsd	%xmm1, (%rdi)
	xorl	%eax, %eax
	retq
.LBB0_1:
	movq	64(%rsp), %rsi
	movabsq	$9223372036854775806, %r8
	andq	%rcx, %r8
	jmp	.LBB0_2
	.p2align	4
.LBB0_5:
	vmovsd	(%rsi,%r9,8), %xmm2
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
.LBB0_6:
	decq	%rdx
	jle	.LBB0_7
.LBB0_2:
	xorl	%r9d, %r9d
	cmpq	$1, %rcx
	je	.LBB0_5
	.p2align	4
.LBB0_3:
	vmovsd	(%rsi,%r9,8), %xmm3
	vmovsd	8(%rsi,%r9,8), %xmm2
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm3, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	vfmadd213sd	%xmm2, %xmm0, %xmm1
	addq	$2, %r9
	cmpq	%r9, %r8
	jne	.LBB0_3
	testb	$1, %cl
	jne	.LBB0_5
	jmp	.LBB0_6
.Lfunc_end0:
