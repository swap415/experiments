.text
# LLVM-MCA-BEGIN map-d16-f64-fast.block0
.LBB0_5:
	vmovupd	(%rdx,%r10,8), %ymm2
	vmovupd	(%rax,%r10,8), %ymm3
	vfmadd132pd	%ymm1, %ymm2, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vfmadd213pd	%ymm2, %ymm1, %ymm3
	vmovupd	%ymm3, (%rax,%r10,8)
	addq	$4, %r10
	cmpq	%r10, %r9
	jne	.LBB0_5
# LLVM-MCA-END
