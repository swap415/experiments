	.file	"<string>"
	.section	.ltext,"axl",@progbits
	.globl	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@function
_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	movq	48(%rsp), %r10
	movq	88(%rsp), %rcx
	movq	8(%rsp), %rax
	vmovsd	(%rax), %xmm1
	testq	%rcx, %rcx
	setle	%dl
	testq	%r10, %r10
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_8:
	vmovsd	%xmm1, (%rax)
	vmovsd	%xmm1, (%rdi)
	xorl	%eax, %eax
	retq
.LBB0_1:
	movq	64(%rsp), %rdx
	leaq	-1(%r10), %rsi
	movl	%r10d, %r8d
	andl	$3, %r8d
	movabsq	$9223372036854775804, %r9
	andq	%r10, %r9
	jmp	.LBB0_2
	.p2align	4
.LBB0_7:
	decq	%rcx
	jle	.LBB0_8
.LBB0_2:
	xorl	%r10d, %r10d
	cmpq	$3, %rsi
	jb	.LBB0_5
	.p2align	4
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
	testq	%r8, %r8
	je	.LBB0_7
.LBB0_5:
	leaq	(%rdx,%r10,8), %r10
	xorl	%r11d, %r11d
	.p2align	4
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
	jmp	.LBB0_7
.Lfunc_end0:
	.size	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, .Lfunc_end0-_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx

	.globl	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@function
_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
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
	subq	$280, %rsp
	.cfi_def_cfa_offset 336
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rsi, %rdi
	leaq	128(%rsp), %rax
	movq	%rax, 8(%rsp)
	leaq	136(%rsp), %rax
	movq	%rax, (%rsp)
	movabsq	$".const.make_kernel.<locals>.kernel", %rsi
	movabsq	$PyArg_UnpackTuple, %r10
	leaq	152(%rsp), %r8
	leaq	144(%rsp), %r9
	movl	$4, %edx
	movl	$4, %ecx
	xorl	%eax, %eax
	callq	*%r10
	testl	%eax, %eax
	je	.LBB1_1
	movabsq	$_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, %rax
	cmpq	$0, (%rax)
	je	.LBB1_4
	movq	152(%rsp), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 224(%rsp)
	vmovups	%ymm0, 248(%rsp)
	movabsq	$NRT_adapt_ndarray_from_python, %rbx
	leaq	224(%rsp), %rsi
	vzeroupper
	callq	*%rbx
	testl	%eax, %eax
	jne	.LBB1_8
	cmpq	$8, 248(%rsp)
	jne	.LBB1_8
	movq	224(%rsp), %r12
	movq	256(%rsp), %r14
	movq	144(%rsp), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 160(%rsp)
	vmovups	%ymm0, 184(%rsp)
	leaq	160(%rsp), %rsi
	vzeroupper
	callq	*%rbx
	testl	%eax, %eax
	jne	.LBB1_11
	cmpq	$8, 184(%rsp)
	jne	.LBB1_11
	movq	%r14, 88(%rsp)
	movq	160(%rsp), %rbp
	movq	176(%rsp), %rax
	movq	%rax, 120(%rsp)
	movq	192(%rsp), %rax
	movq	%rax, 112(%rsp)
	movq	136(%rsp), %rdi
	movabsq	$PyNumber_Float, %rax
	callq	*%rax
	movq	%rax, %r15
	movabsq	$PyFloat_AsDouble, %rax
	movq	%r15, %rdi
	callq	*%rax
	vmovsd	%xmm0, 104(%rsp)
	movabsq	$Py_DecRef, %r14
	movq	%r15, %rdi
	callq	*%r14
	movabsq	$PyErr_Occurred, %r13
	callq	*%r13
	testq	%rax, %rax
	jne	.LBB1_13
	movq	%rbp, %rbx
	movq	%r12, %rbp
	movq	128(%rsp), %rdi
	movabsq	$PyNumber_Long, %rax
	callq	*%rax
	testq	%rax, %rax
	je	.LBB1_16
	movq	%rax, %r12
	movabsq	$PyLong_AsLongLong, %rax
	movq	%r12, %rdi
	callq	*%rax
	movq	%rax, %r15
	movq	%r12, %rdi
	callq	*%r14
.LBB1_18:
	callq	*%r13
	testq	%rax, %rax
	movq	%rbp, %r12
	movq	%rbx, %rbp
	jne	.LBB1_13
	movq	$0, 96(%rsp)
	movq	%r15, 80(%rsp)
	movq	112(%rsp), %rax
	movq	%rax, 56(%rsp)
	movq	120(%rsp), %rax
	movq	%rax, 40(%rsp)
	movq	88(%rsp), %rax
	movq	%rax, (%rsp)
	movabsq	$_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, %rax
	leaq	96(%rsp), %rdi
	vmovsd	104(%rsp), %xmm0
	callq	*%rax
	vmovsd	96(%rsp), %xmm0
	vmovsd	%xmm0, 88(%rsp)
	movabsq	$NRT_decref, %rbx
	movq	%r12, %rdi
	callq	*%rbx
	movq	%rbp, %rdi
	callq	*%rbx
	movabsq	$PyFloat_FromDouble, %rax
	vmovsd	88(%rsp), %xmm0
	callq	*%rax
.LBB1_2:
	addq	$280, %rsp
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
.LBB1_13:
	.cfi_def_cfa_offset 336
	movabsq	$NRT_decref, %rax
	movq	%rbp, %rdi
	callq	*%rax
	jmp	.LBB1_14
.LBB1_4:
	movabsq	$PyExc_RuntimeError, %rdi
	movabsq	$".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx", %rsi
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
.LBB1_14:
	movabsq	$NRT_decref, %rax
	movq	%r12, %rdi
	callq	*%rax
.LBB1_1:
	xorl	%eax, %eax
	jmp	.LBB1_2
.LBB1_16:
	xorl	%r15d, %r15d
	jmp	.LBB1_18
.Lfunc_end1:
	.size	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, .Lfunc_end1-_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.cfi_endproc

	.globl	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@function
cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	subq	$104, %rsp
	movq	136(%rsp), %rax
	movq	152(%rsp), %rcx
	movq	176(%rsp), %rdx
	movq	$0, 96(%rsp)
	movq	%rdx, 80(%rsp)
	movq	%rcx, 56(%rsp)
	movq	%rax, 40(%rsp)
	movq	%r8, (%rsp)
	movabsq	$_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, %rax
	leaq	96(%rsp), %rdi
	callq	*%rax
	vmovsd	96(%rsp), %xmm0
	addq	$104, %rsp
	retq
.Lfunc_end2:
	.size	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, .Lfunc_end2-cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx

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

	.type	_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@object
	.comm	_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,8,8
	.type	".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx",@object
	.p2align	4, 0x0
".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx":
	.asciz	"missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx"
	.size	".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx", 188

	.type	".const.can't unbox array from PyObject into native value.  The object maybe of a different type",@object
	.p2align	4, 0x0
".const.can't unbox array from PyObject into native value.  The object maybe of a different type":
	.asciz	"can't unbox array from PyObject into native value.  The object maybe of a different type"
	.size	".const.can't unbox array from PyObject into native value.  The object maybe of a different type", 89

	.section	".note.GNU-stack","",@progbits
