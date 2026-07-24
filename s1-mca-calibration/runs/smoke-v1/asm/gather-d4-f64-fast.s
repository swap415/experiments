	.file	"<string>"
	.section	.ltext,"axl",@progbits
	.globl	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx,@function
_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	movq	184(%rsp), %rcx
	movq	48(%rsp), %rax
	testq	%rcx, %rcx
	setle	%dl
	testq	%r8, %r8
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_8:
	vmovsd	(%rax), %xmm0
	vmovsd	%xmm0, (%rdi)
	xorl	%eax, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	retq
.LBB0_1:
	movq	160(%rsp), %rdx
	movq	112(%rsp), %rsi
	movq	104(%rsp), %r9
	leaq	-1(%r8), %r10
	movl	%r8d, %r11d
	andl	$3, %r11d
	movabsq	$9223372036854775804, %rbx
	andq	%r8, %rbx
	jmp	.LBB0_2
	.p2align	4
.LBB0_7:
	decq	%rcx
	jle	.LBB0_8
.LBB0_2:
	xorl	%r8d, %r8d
	cmpq	$3, %r10
	jb	.LBB0_5
	.p2align	4
.LBB0_3:
	movq	(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, (%rax,%r8,8)
	movq	8(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	8(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, 8(%rax,%r8,8)
	movq	16(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	16(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, 16(%rax,%r8,8)
	movq	24(%rdx,%r8,8), %r14
	leaq	(%r9,%r14,8), %r15
	sarq	$63, %r14
	andq	%rsi, %r14
	vmovsd	(%r15,%r14,8), %xmm1
	vmovsd	24(%rax,%r8,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, 24(%rax,%r8,8)
	addq	$4, %r8
	cmpq	%r8, %rbx
	jne	.LBB0_3
	testq	%r11, %r11
	je	.LBB0_7
.LBB0_5:
	leaq	(%rdx,%r8,8), %r14
	leaq	(%rax,%r8,8), %r8
	xorl	%r15d, %r15d
	.p2align	4
.LBB0_6:
	movq	(%r14,%r15,8), %r12
	leaq	(%r9,%r12,8), %r13
	sarq	$63, %r12
	andq	%rsi, %r12
	vmovsd	(%r13,%r12,8), %xmm1
	vmovsd	(%r8,%r15,8), %xmm2
	vfmadd132sd	%xmm0, %xmm1, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vfmadd213sd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, (%r8,%r15,8)
	incq	%r15
	cmpq	%r15, %r11
	jne	.LBB0_6
	jmp	.LBB0_7
.Lfunc_end0:
	.size	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx, .Lfunc_end0-_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx

	.globl	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx,@function
_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$440, %rsp
	.cfi_def_cfa_offset 496
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rsi, %rdi
	leaq	216(%rsp), %rax
	movq	%rax, 16(%rsp)
	leaq	224(%rsp), %rax
	movq	%rax, 8(%rsp)
	leaq	232(%rsp), %rax
	movq	%rax, (%rsp)
	movabsq	$".const.make_kernel.<locals>.kernel", %rsi
	movabsq	$PyArg_UnpackTuple, %r10
	leaq	248(%rsp), %r8
	leaq	240(%rsp), %r9
	movl	$5, %edx
	movl	$5, %ecx
	xorl	%eax, %eax
	callq	*%r10
	testl	%eax, %eax
	je	.LBB1_1
	movabsq	$_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx, %rax
	cmpq	$0, (%rax)
	je	.LBB1_4
	movq	248(%rsp), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 320(%rsp)
	vmovups	%ymm0, 344(%rsp)
	movabsq	$NRT_adapt_ndarray_from_python, %rbx
	leaq	320(%rsp), %rsi
	vzeroupper
	callq	*%rbx
	testl	%eax, %eax
	jne	.LBB1_8
	cmpq	$8, 344(%rsp)
	jne	.LBB1_8
	movq	320(%rsp), %rbp
	movq	336(%rsp), %r14
	movq	352(%rsp), %r12
	movq	240(%rsp), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 256(%rsp)
	vmovups	%ymm0, 280(%rsp)
	leaq	256(%rsp), %rsi
	vzeroupper
	callq	*%rbx
	testl	%eax, %eax
	jne	.LBB1_11
	cmpq	$8, 280(%rsp)
	jne	.LBB1_11
	movq	256(%rsp), %r15
	movq	288(%rsp), %r13
	movq	296(%rsp), %rax
	movq	%rax, 152(%rsp)
	movq	232(%rsp), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 384(%rsp)
	vmovups	%ymm0, 408(%rsp)
	leaq	384(%rsp), %rsi
	vzeroupper
	callq	*%rbx
	testl	%eax, %eax
	jne	.LBB1_14
	cmpq	$8, 408(%rsp)
	jne	.LBB1_14
	movq	%r13, 192(%rsp)
	movq	%r12, 200(%rsp)
	movq	%r14, 208(%rsp)
	movq	384(%rsp), %rax
	movq	%rax, 160(%rsp)
	movq	416(%rsp), %rax
	movq	%rax, 184(%rsp)
	movq	224(%rsp), %rdi
	movabsq	$PyNumber_Float, %rax
	callq	*%rax
	movq	%rax, %r13
	movabsq	$PyFloat_AsDouble, %rax
	movq	%r13, %rdi
	callq	*%rax
	vmovsd	%xmm0, 176(%rsp)
	movabsq	$Py_DecRef, %r14
	movq	%r13, %rdi
	callq	*%r14
	movabsq	$PyErr_Occurred, %r12
	callq	*%r12
	testq	%rax, %rax
	jne	.LBB1_18
	movq	%r15, %rbx
	movq	%rbp, %r15
	movq	216(%rsp), %rdi
	movabsq	$PyNumber_Long, %rax
	callq	*%rax
	testq	%rax, %rax
	je	.LBB1_20
	movq	%rax, %rbp
	movabsq	$PyLong_AsLongLong, %rax
	movq	%rbp, %rdi
	callq	*%rax
	movq	%rax, %r13
	movq	%rbp, %rdi
	callq	*%r14
.LBB1_22:
	callq	*%r12
	testq	%rax, %rax
	movq	%r15, %rbp
	movq	%rbx, %r15
	jne	.LBB1_18
	movq	$0, 168(%rsp)
	movq	%r13, 136(%rsp)
	movq	184(%rsp), %rax
	movq	%rax, 112(%rsp)
	movq	152(%rsp), %rax
	movq	%rax, 64(%rsp)
	movq	192(%rsp), %rax
	movq	%rax, 56(%rsp)
	movq	200(%rsp), %rax
	movq	%rax, (%rsp)
	movabsq	$_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx, %rax
	leaq	168(%rsp), %rdi
	movq	208(%rsp), %r8
	vmovsd	176(%rsp), %xmm0
	callq	*%rax
	vmovsd	168(%rsp), %xmm0
	vmovsd	%xmm0, 152(%rsp)
	movabsq	$NRT_decref, %rbx
	movq	%rbp, %rdi
	callq	*%rbx
	movq	%r15, %rdi
	callq	*%rbx
	movq	160(%rsp), %rdi
	callq	*%rbx
	movabsq	$PyFloat_FromDouble, %rax
	vmovsd	152(%rsp), %xmm0
	callq	*%rax
.LBB1_2:
	addq	$440, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB1_18:
	.cfi_def_cfa_offset 496
	movabsq	$NRT_decref, %rax
	movq	160(%rsp), %rdi
	callq	*%rax
	jmp	.LBB1_15
.LBB1_4:
	movabsq	$PyExc_RuntimeError, %rdi
	movabsq	$".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx", %rsi
	jmp	.LBB1_5
.LBB1_8:
	movabsq	$PyExc_TypeError, %rdi
	movabsq	$".const.can't unbox array from PyObject into native value.  The object maybe of a different type", %rsi
.LBB1_5:
	movabsq	$PyErr_SetString, %rax
	callq	*%rax
	jmp	.LBB1_1
.LBB1_11:
	movabsq	$PyExc_TypeError, %rdi
	movabsq	$".const.can't unbox array from PyObject into native value.  The object maybe of a different type", %rsi
	movabsq	$PyErr_SetString, %rax
	callq	*%rax
	jmp	.LBB1_16
.LBB1_14:
	movabsq	$PyExc_TypeError, %rdi
	movabsq	$".const.can't unbox array from PyObject into native value.  The object maybe of a different type", %rsi
	movabsq	$PyErr_SetString, %rax
	callq	*%rax
.LBB1_15:
	movabsq	$NRT_decref, %rax
	movq	%r15, %rdi
	callq	*%rax
.LBB1_16:
	movabsq	$NRT_decref, %rax
	movq	%rbp, %rdi
	callq	*%rax
.LBB1_1:
	xorl	%eax, %eax
	jmp	.LBB1_2
.LBB1_20:
	xorl	%r13d, %r13d
	jmp	.LBB1_22
.Lfunc_end1:
	.size	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx, .Lfunc_end1-_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx
	.cfi_endproc

	.globl	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx,@function
cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx:
	subq	$152, %rsp
	vmovups	200(%rsp), %xmm1
	movq	256(%rsp), %rax
	movq	280(%rsp), %rcx
	movq	$0, 144(%rsp)
	movq	%rcx, 136(%rsp)
	movq	%rax, 112(%rsp)
	vmovups	%xmm1, 56(%rsp)
	movq	%r8, (%rsp)
	movabsq	$_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx, %rax
	leaq	144(%rsp), %rdi
	movq	%rdx, %r8
	callq	*%rax
	vmovsd	144(%rsp), %xmm0
	addq	$152, %rsp
	retq
.Lfunc_end2:
	.size	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx, .Lfunc_end2-cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx

	.weak	NRT_decref
	.p2align	4
	.type	NRT_decref,@function
NRT_decref:
	.cfi_startproc
	testq	%rdi, %rdi
	je	.LBB3_2
	#MEMBARRIER
	lock		decq	(%rdi)
	je	.LBB3_3
.LBB3_2:
	retq
.LBB3_3:
	#MEMBARRIER
	movabsq	$NRT_MemInfo_call_dtor, %rax
	jmpq	*%rax
.Lfunc_end3:
	.size	NRT_decref, .Lfunc_end3-NRT_decref
	.cfi_endproc

	.type	".const.make_kernel.<locals>.kernel",@object
	.section	.lrodata,"al",@progbits
	.p2align	4, 0x0
".const.make_kernel.<locals>.kernel":
	.asciz	"make_kernel.<locals>.kernel"
	.size	".const.make_kernel.<locals>.kernel", 28

	.type	_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx,@object
	.comm	_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx,8,8
	.type	".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx",@object
	.p2align	4, 0x0
".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx":
	.asciz	"missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx"
	.size	".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx", 241

	.type	".const.can't unbox array from PyObject into native value.  The object maybe of a different type",@object
	.p2align	4, 0x0
".const.can't unbox array from PyObject into native value.  The object maybe of a different type":
	.asciz	"can't unbox array from PyObject into native value.  The object maybe of a different type"
	.size	".const.can't unbox array from PyObject into native value.  The object maybe of a different type", 89

	.section	".note.GNU-stack","",@progbits
