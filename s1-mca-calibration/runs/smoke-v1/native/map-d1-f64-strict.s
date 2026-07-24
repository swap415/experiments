_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	pushq	%r14
	pushq	%rbx
	movq	104(%rsp), %rcx
	movq	24(%rsp), %rax
	testq	%rcx, %rcx
	setle	%dl
	testq	%r8, %r8
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_16:
	vmovsd	(%rax), %xmm0
	vmovsd	%xmm0, (%rdi)
	xorl	%eax, %eax
	popq	%rbx
	popq	%r14
	vzeroupper
	retq
.LBB0_1:
	movq	80(%rsp), %rdx
	leaq	(%rax,%r8,8), %rsi
	leaq	(%rdx,%r8,8), %r9
	cmpq	%r9, %rax
	setb	%r9b
	cmpq	%rsi, %rdx
	setb	%sil
	andb	%r9b, %sil
	movabsq	$9223372036854775792, %r9
	movq	%r8, %r10
	andq	%r9, %r10
	vbroadcastsd	%xmm0, %ymm1
	orq	$12, %r9
	andq	%r8, %r9
	jmp	.LBB0_2
	.p2align	4
.LBB0_15:
	decq	%rcx
	jle	.LBB0_16
.LBB0_2:
	cmpq	$4, %r8
	setb	%r11b
	orb	%sil, %r11b
	testb	$1, %r11b
	je	.LBB0_4
	xorl	%ebx, %ebx
	jmp	.LBB0_10
	.p2align	4
.LBB0_4:
	xorl	%r11d, %r11d
	cmpq	$16, %r8
	jb	.LBB0_8
	.p2align	4
.LBB0_5:
	vmulpd	(%rax,%r11,8), %ymm1, %ymm2
	vmulpd	32(%rax,%r11,8), %ymm1, %ymm3
	vmulpd	64(%rax,%r11,8), %ymm1, %ymm4
	vmulpd	96(%rax,%r11,8), %ymm1, %ymm5
	vaddpd	(%rdx,%r11,8), %ymm2, %ymm2
	vaddpd	32(%rdx,%r11,8), %ymm3, %ymm3
	vaddpd	64(%rdx,%r11,8), %ymm4, %ymm4
	vaddpd	96(%rdx,%r11,8), %ymm5, %ymm5
	vmovupd	%ymm2, (%rax,%r11,8)
	vmovupd	%ymm3, 32(%rax,%r11,8)
	vmovupd	%ymm4, 64(%rax,%r11,8)
	vmovupd	%ymm5, 96(%rax,%r11,8)
	addq	$16, %r11
	cmpq	%r11, %r10
	jne	.LBB0_5
	cmpq	%r10, %r8
	je	.LBB0_15
	movq	%r10, %r11
	movq	%r10, %rbx
	testb	$12, %r8b
	je	.LBB0_10
	.p2align	4
.LBB0_8:
	vmulpd	(%rax,%r11,8), %ymm1, %ymm2
	vaddpd	(%rdx,%r11,8), %ymm2, %ymm2
	vmovupd	%ymm2, (%rax,%r11,8)
	addq	$4, %r11
	cmpq	%r11, %r9
	jne	.LBB0_8
	movq	%r9, %rbx
	cmpq	%r9, %r8
	je	.LBB0_15
.LBB0_10:
	movl	%r8d, %r14d
	subl	%ebx, %r14d
	movq	%rbx, %r11
	andl	$7, %r14d
	je	.LBB0_13
	movq	%rbx, %r11
	.p2align	4
.LBB0_12:
	vmulsd	(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, (%rax,%r11,8)
	incq	%r11
	decq	%r14
	jne	.LBB0_12
.LBB0_13:
	subq	%r8, %rbx
	cmpq	$-8, %rbx
	ja	.LBB0_15
	.p2align	4
.LBB0_14:
	vmulsd	(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, (%rax,%r11,8)
	vmulsd	8(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	8(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, 8(%rax,%r11,8)
	vmulsd	16(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	16(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, 16(%rax,%r11,8)
	vmulsd	24(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	24(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, 24(%rax,%r11,8)
	vmulsd	32(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	32(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, 32(%rax,%r11,8)
	vmulsd	40(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	40(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, 40(%rax,%r11,8)
	vmulsd	48(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	48(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, 48(%rax,%r11,8)
	vmulsd	56(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	56(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, 56(%rax,%r11,8)
	addq	$8, %r11
	cmpq	%r11, %r8
	jne	.LBB0_14
	jmp	.LBB0_15
.Lfunc_end0:
