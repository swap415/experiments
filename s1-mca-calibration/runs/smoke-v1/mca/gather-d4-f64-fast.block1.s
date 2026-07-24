.text
# LLVM-MCA-BEGIN gather-d4-f64-fast.block1
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
# LLVM-MCA-END
