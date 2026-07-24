.text
# LLVM-MCA-BEGIN gather-d4-f64-fast.block0
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
# LLVM-MCA-END
