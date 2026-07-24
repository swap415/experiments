.text
# LLVM-MCA-BEGIN map-d1-f64-strict.block0
.LBB0_5:
	vmulpd	(%rax,%r11,8), %ymm1, %ymm2
	vmulpd	32(%rax,%r11,8), %ymm1, %ymm3
	vmulpd	64(%rax,%r11,8), %ymm1, %ymm4
	vmulpd	96(%rax,%r11,8), %ymm1, %ymm5
	vaddpd	(%rdx,%r11,8), %ymm2, %ymm2
	vaddpd	32(%rdx,%r11,8), %ymm3, %ymm3
	vaddpd	64(%rdx,%r11,8), %ymm4, %ymm4
	vaddpd	96(%rdx,%r11,8), %ymm5, %ymm5
	vmovupd	%ymm2, (%rax,%r11,8)
	vmovupd	%ymm3, 32(%rax,%r11,8)
	vmovupd	%ymm4, 64(%rax,%r11,8)
	vmovupd	%ymm5, 96(%rax,%r11,8)
	addq	$16, %r11
	cmpq	%r11, %r10
	jne	.LBB0_5
# LLVM-MCA-END
