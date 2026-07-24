_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	movq	184(%rsp), %rcx
	movq	48(%rsp), %rax
	testq	%rcx, %rcx
	setle	%dl
	testq	%r8, %r8
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_8:
	vmovsd	(%rax), %xmm0
	vmovsd	%xmm0, (%rdi)
	xorl	%eax, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	retq
.LBB0_1:
	movq	160(%rsp), %rdx
	movq	112(%rsp), %rsi
	movq	104(%rsp), %r9
	leaq	-1(%r8), %r10
	movl	%r8d, %r11d
	andl	$3, %r11d
	movabsq	$9223372036854775804, %rbx
	andq	%r8, %rbx
	jmp	.LBB0_2
	.p2align	4
.LBB0_7:
	decq	%rcx
	jle	.LBB0_8
.LBB0_2:
	xorl	%r8d, %r8d
	cmpq	$3, %r10
	jb	.LBB0_5
	.p2align	4
.LBB0_3:
	movq	(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, (%rax,%r8,8)
	movq	8(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	8(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, 8(%rax,%r8,8)
	movq	16(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	16(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, 16(%rax,%r8,8)
	movq	24(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	24(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, 24(%rax,%r8,8)
	addq	$4, %r8
	cmpq	%r8, %rbx
	jne	.LBB0_3
	testq	%r11, %r11
	je	.LBB0_7
.LBB0_5:
	leaq	(%rdx,%r8,8), %r14
	leaq	(%rax,%r8,8), %r8
	xorl	%r15d, %r15d
	.p2align	4
.LBB0_6:
	movq	(%r14,%r15,8), %r12
	leaq	(%r9,%r12,8), %r13
	sarq	$63, %r12
	andq	%rsi, %r12
	vmovsd	(%r13,%r12,8), %xmm1
	vmovsd	(%r8,%r15,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, (%r8,%r15,8)
	incq	%r15
	cmpq	%r15, %r11
	jne	.LBB0_6
	jmp	.LBB0_7
.Lfunc_end0:
