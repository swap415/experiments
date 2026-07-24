.text
# LLVM-MCA-BEGIN reduction-d4-f64-strict.block1
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
# LLVM-MCA-END
