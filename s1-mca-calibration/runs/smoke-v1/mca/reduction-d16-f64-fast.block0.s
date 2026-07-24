.text
# LLVM-MCA-BEGIN reduction-d16-f64-fast.block0
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
# LLVM-MCA-END
