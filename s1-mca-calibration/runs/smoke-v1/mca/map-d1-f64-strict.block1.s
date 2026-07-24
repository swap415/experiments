.text
# LLVM-MCA-BEGIN map-d1-f64-strict.block1
.LBB0_8:
	vmulpd	(%rax,%r11,8), %ymm1, %ymm2
	vaddpd	(%rdx,%r11,8), %ymm2, %ymm2
	vmovupd	%ymm2, (%rax,%r11,8)
	addq	$4, %r11
	cmpq	%r11, %r9
	jne	.LBB0_8
# LLVM-MCA-END
