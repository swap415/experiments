.text
# LLVM-MCA-BEGIN map-d1-f64-strict.block2
.LBB0_12:
	vmulsd	(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, (%rax,%r11,8)
	incq	%r11
	decq	%r14
	jne	.LBB0_12
# LLVM-MCA-END
