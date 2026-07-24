.text
# LLVM-MCA-BEGIN map-d16-f64-fast.block1
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
# LLVM-MCA-END
