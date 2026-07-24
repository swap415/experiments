_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v3B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIfLi1E1C7mutable7alignedE5ArrayIfLi1E1C7mutable7alignedEfx:
	movq	88(%rsp), %rcx
	movq	8(%rsp), %rax
	testq	%rcx, %rcx
	setle	%dl
	testq	%r8, %r8
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_12:
	vmovss	(%rax), %xmm0
	vmovss	%xmm0, (%rdi)
	xorl	%eax, %eax
	vzeroupper
	retq
.LBB0_1:
	movq	64(%rsp), %rdx
	leaq	(%rax,%r8,4), %rsi
	leaq	(%rdx,%r8,4), %r9
	cmpq	%r9, %rax
	setb	%r9b
	cmpq	%rsi, %rdx
	setb	%sil
	andb	%r9b, %sil
	movabsq	$9223372036854775800, %r9
	andq	%r8, %r9
	vbroadcastss	%xmm0, %ymm1
	jmp	.LBB0_2
	.p2align	4
.LBB0_11:
	decq	%rcx
	jle	.LBB0_12
.LBB0_2:
	cmpq	$8, %r8
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
	vmovups	(%rdx,%r10,4), %ymm2
	vmovups	(%rax,%r10,4), %ymm3
	vfmadd132ps	%ymm1, %ymm2, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vmovups	%ymm3, (%rax,%r10,4)
	addq	$8, %r10
	cmpq	%r10, %r9
	jne	.LBB0_5
	movq	%r9, %r10
	cmpq	%r9, %r8
	je	.LBB0_11
.LBB0_7:
	movq	%r10, %r11
	orq	$1, %r11
	testb	$1, %r8b
	je	.LBB0_9
	vmovss	(%rdx,%r10,4), %xmm2
	vmovss	(%rax,%r10,4), %xmm3
	vfmadd132ss	%xmm0, %xmm2, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vmovss	%xmm3, (%rax,%r10,4)
	movq	%r11, %r10
.LBB0_9:
	cmpq	%r11, %r8
	je	.LBB0_11
	.p2align	4
.LBB0_10:
	vmovss	(%rdx,%r10,4), %xmm2
	vmovss	(%rax,%r10,4), %xmm3
	vfmadd132ss	%xmm0, %xmm2, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vmovss	%xmm3, (%rax,%r10,4)
	vmovss	4(%rdx,%r10,4), %xmm2
	vmovss	4(%rax,%r10,4), %xmm3
	vfmadd132ss	%xmm0, %xmm2, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vmovss	%xmm3, 4(%rax,%r10,4)
	addq	$2, %r10
	cmpq	%r10, %r8
	jne	.LBB0_10
	jmp	.LBB0_11
.Lfunc_end0:
