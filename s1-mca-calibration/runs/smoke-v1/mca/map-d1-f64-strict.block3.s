.text
# LLVM-MCA-BEGIN map-d1-f64-strict.block3
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
# LLVM-MCA-END
