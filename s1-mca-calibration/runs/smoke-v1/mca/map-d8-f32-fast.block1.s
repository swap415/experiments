.text
# LLVM-MCA-BEGIN map-d8-f32-fast.block1
.LBB0_10:
	vmovss	(%rdx,%r10,4), %xmm2
	vmovss	(%rax,%r10,4), %xmm3
	vfmadd132ss	%xmm0, %xmm2, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vmovss	%xmm3, (%rax,%r10,4)
	vmovss	4(%rdx,%r10,4), %xmm2
	vmovss	4(%rax,%r10,4), %xmm3
	vfmadd132ss	%xmm0, %xmm2, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vfmadd213ss	%xmm2, %xmm0, %xmm3
	vmovss	%xmm3, 4(%rax,%r10,4)
	addq	$2, %r10
	cmpq	%r10, %r8
	jne	.LBB0_10
# LLVM-MCA-END
