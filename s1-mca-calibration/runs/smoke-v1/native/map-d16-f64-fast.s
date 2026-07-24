_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	movq	88(%rsp), %rcx
	movq	8(%rsp), %rax
	testq	%rcx, %rcx
	setle	%dl
	testq	%r8, %r8
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_9:
	vmovsd	(%rax), %xmm0
	vmovsd	%xmm0, (%rdi)
	xorl	%eax, %eax
	vzeroupper
	retq
.LBB0_1:
	movq	64(%rsp), %rdx
	leaq	(%rax,%r8,8), %rsi
	leaq	(%rdx,%r8,8), %r9
	cmpq	%r9, %rax
	setb	%r9b
	cmpq	%rsi, %rdx
	setb	%sil
	andb	%r9b, %sil
	movabsq	$9223372036854775804, %r9
	andq	%r8, %r9
	vbroadcastsd	%xmm0, %ymm1
	jmp	.LBB0_2
	.p2align	4
.LBB0_8:
	decq	%rcx
	jle	.LBB0_9
.LBB0_2:
	cmpq	$4, %r8
	setb	%r10b
	orb	%sil, %r10b
	testb	$1, %r10b
	je	.LBB0_4
	xorl	%r10d, %r10d
	jmp	.LBB0_7
	.p2align	4
.LBB0_4:
	xorl	%r10d, %r10d
	.p2align	4
.LBB0_5:
	vmovupd	(%rdx,%r10,8), %ymm2
	vmovupd	(%rax,%r10,8), %ymm3
	vfmadd132pd	%ymm1, %ymm2, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vmovupd	%ymm3, (%rax,%r10,8)
	addq	$4, %r10
	cmpq	%r10, %r9
	jne	.LBB0_5
	movq	%r9, %r10
	cmpq	%r9, %r8
	je	.LBB0_8
	.p2align	4
.LBB0_7:
	vmovsd	(%rdx,%r10,8), %xmm2
	vmovsd	(%rax,%r10,8), %xmm3
	vfmadd132sd	%xmm0, %xmm2, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vfmadd213sd	%xmm2, %xmm0, %xmm3
	vmovsd	%xmm3, (%rax,%r10,8)
	incq	%r10
	cmpq	%r10, %r8
	jne	.LBB0_7
	jmp	.LBB0_8
.Lfunc_end0:
