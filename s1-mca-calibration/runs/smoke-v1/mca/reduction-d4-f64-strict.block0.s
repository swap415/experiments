.text
# LLVM-MCA-BEGIN reduction-d4-f64-strict.block0
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
# LLVM-MCA-END
