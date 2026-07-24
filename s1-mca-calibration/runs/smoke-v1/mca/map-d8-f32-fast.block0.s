.text
# LLVM-MCA-BEGIN map-d8-f32-fast.block0
.LBB0_5:
	vmovups	(%rdx,%r10,4), %ymm2
	vmovups	(%rax,%r10,4), %ymm3
	vfmadd132ps	%ymm1, %ymm2, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vfmadd213ps	%ymm2, %ymm1, %ymm3
	vmovups	%ymm3, (%rax,%r10,4)
	addq	$8, %r10
	cmpq	%r10, %r9
	jne	.LBB0_5
# LLVM-MCA-END
