_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	movq	48(%rsp), %r10
	movq	88(%rsp), %rcx
	movq	8(%rsp), %rax
	vmovsd	(%rax), %xmm1
	testq	%rcx, %rcx
	setle	%dl
	testq	%r10, %r10
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_8:
	vmovsd	%xmm1, (%rax)
	vmovsd	%xmm1, (%rdi)
	xorl	%eax, %eax
	retq
.LBB0_1:
	movq	64(%rsp), %rdx
	leaq	-1(%r10), %rsi
	movl	%r10d, %r8d
	andl	$3, %r8d
	movabsq	$9223372036854775804, %r9
	andq	%r10, %r9
	jmp	.LBB0_2
	.p2align	4
.LBB0_7:
	decq	%rcx
	jle	.LBB0_8
.LBB0_2:
	xorl	%r10d, %r10d
	cmpq	$3, %rsi
	jb	.LBB0_5
	.p2align	4
.LBB0_3:
	vmulsd	%xmm1, %xmm0, %xmm1
	vmovsd	(%rdx,%r10,8), %xmm2
	vmovsd	8(%rdx,%r10,8), %xmm3
	vaddsd	%xmm2, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm3, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm3, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm3, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm3, %xmm1
	vmovsd	16(%rdx,%r10,8), %xmm2
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm2, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmovsd	24(%rdx,%r10,8), %xmm2
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm2, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	addq	$4, %r10
	cmpq	%r10, %r9
	jne	.LBB0_3
	testq	%r8, %r8
	je	.LBB0_7
.LBB0_5:
	leaq	(%rdx,%r10,8), %r10
	xorl	%r11d, %r11d
	.p2align	4
.LBB0_6:
	vmovsd	(%r10,%r11,8), %xmm2
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm2, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vaddsd	%xmm1, %xmm2, %xmm1
	incq	%r11
	cmpq	%r11, %r8
	jne	.LBB0_6
	jmp	.LBB0_7
.Lfunc_end0:
