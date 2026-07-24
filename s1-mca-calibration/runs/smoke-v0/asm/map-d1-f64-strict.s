	.file	"<string>"
	.section	.ltext,"axl",@progbits
	.globl	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@function
_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	pushq	%r14
	pushq	%rbx
	movq	104(%rsp), %rcx
	movq	24(%rsp), %rax
	testq	%rcx, %rcx
	setle	%dl
	testq	%r8, %r8
	setle	%sil
	orb	%dl, %sil
	je	.LBB0_1
.LBB0_16:
	vmovsd	(%rax), %xmm0
	vmovsd	%xmm0, (%rdi)
	xorl	%eax, %eax
	popq	%rbx
	popq	%r14
	vzeroupper
	retq
.LBB0_1:
	movq	80(%rsp), %rdx
	leaq	(%rax,%r8,8), %rsi
	leaq	(%rdx,%r8,8), %r9
	cmpq	%r9, %rax
	setb	%r9b
	cmpq	%rsi, %rdx
	setb	%sil
	andb	%r9b, %sil
	movabsq	$9223372036854775792, %r9
	movq	%r8, %r10
	andq	%r9, %r10
	vbroadcastsd	%xmm0, %ymm1
	orq	$12, %r9
	andq	%r8, %r9
	jmp	.LBB0_2
	.p2align	4
.LBB0_15:
	decq	%rcx
	jle	.LBB0_16
.LBB0_2:
	cmpq	$4, %r8
	setb	%r11b
	orb	%sil, %r11b
	testb	$1, %r11b
	je	.LBB0_4
	xorl	%ebx, %ebx
	jmp	.LBB0_10
	.p2align	4
.LBB0_4:
	xorl	%r11d, %r11d
	cmpq	$16, %r8
	jb	.LBB0_8
	.p2align	4
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
	cmpq	%r10, %r8
	je	.LBB0_15
	movq	%r10, %r11
	movq	%r10, %rbx
	testb	$12, %r8b
	je	.LBB0_10
	.p2align	4
.LBB0_8:
	vmulpd	(%rax,%r11,8), %ymm1, %ymm2
	vaddpd	(%rdx,%r11,8), %ymm2, %ymm2
	vmovupd	%ymm2, (%rax,%r11,8)
	addq	$4, %r11
	cmpq	%r11, %r9
	jne	.LBB0_8
	movq	%r9, %rbx
	cmpq	%r9, %r8
	je	.LBB0_15
.LBB0_10:
	movl	%r8d, %r14d
	subl	%ebx, %r14d
	movq	%rbx, %r11
	andl	$7, %r14d
	je	.LBB0_13
	movq	%rbx, %r11
	.p2align	4
.LBB0_12:
	vmulsd	(%rax,%r11,8), %xmm0, %xmm2
	vaddsd	(%rdx,%r11,8), %xmm2, %xmm2
	vmovsd	%xmm2, (%rax,%r11,8)
	incq	%r11
	decq	%r14
	jne	.LBB0_12
.LBB0_13:
	subq	%r8, %rbx
	cmpq	$-8, %rbx
	ja	.LBB0_15
	.p2align	4
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
	jmp	.LBB0_15
.Lfunc_end0:
	.size	_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, .Lfunc_end0-_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx

	.globl	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@function
_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
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
	movabsq	$_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, %rax
	cmpq	$0, (%rax)
	je	.LBB1_4
	movq	152(%rsp), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 160(%rsp)
	vmovups	%ymm0, 184(%rsp)
	movabsq	$NRT_adapt_ndarray_from_python, %rbx
	leaq	160(%rsp), %rsi
	vzeroupper
	callq	*%rbx
	testl	%eax, %eax
	jne	.LBB1_8
	cmpq	$8, 184(%rsp)
	jne	.LBB1_8
	movq	160(%rsp), %r13
	movq	176(%rsp), %r14
	movq	192(%rsp), %r15
	movq	144(%rsp), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 224(%rsp)
	vmovups	%ymm0, 248(%rsp)
	leaq	224(%rsp), %rsi
	vzeroupper
	callq	*%rbx
	testl	%eax, %eax
	jne	.LBB1_11
	cmpq	$8, 248(%rsp)
	jne	.LBB1_11
	movq	%r15, 120(%rsp)
	movq	%r14, 88(%rsp)
	movq	224(%rsp), %r15
	movq	256(%rsp), %rax
	movq	%rax, 112(%rsp)
	movq	136(%rsp), %rdi
	movabsq	$PyNumber_Float, %rax
	callq	*%rax
	movq	%rax, %r12
	movabsq	$PyFloat_AsDouble, %rax
	movq	%r12, %rdi
	callq	*%rax
	vmovsd	%xmm0, 104(%rsp)
	movabsq	$Py_DecRef, %rbp
	movq	%r12, %rdi
	callq	*%rbp
	movabsq	$PyErr_Occurred, %r14
	callq	*%r14
	testq	%rax, %rax
	jne	.LBB1_13
	movq	%r15, %rbx
	movq	%r13, %r15
	movq	128(%rsp), %rdi
	movabsq	$PyNumber_Long, %rax
	callq	*%rax
	testq	%rax, %rax
	je	.LBB1_16
	movq	%rax, %r13
	movabsq	$PyLong_AsLongLong, %rax
	movq	%r13, %rdi
	callq	*%rax
	movq	%rax, %r12
	movq	%r13, %rdi
	callq	*%rbp
.LBB1_18:
	callq	*%r14
	testq	%rax, %rax
	movq	%r15, %r13
	movq	%rbx, %r15
	jne	.LBB1_13
	movq	$0, 96(%rsp)
	movq	%r12, 80(%rsp)
	movq	112(%rsp), %rax
	movq	%rax, 56(%rsp)
	movq	120(%rsp), %rax
	movq	%rax, (%rsp)
	movabsq	$_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, %rax
	leaq	96(%rsp), %rdi
	movq	88(%rsp), %r8
	vmovsd	104(%rsp), %xmm0
	callq	*%rax
	vmovsd	96(%rsp), %xmm0
	vmovsd	%xmm0, 88(%rsp)
	movabsq	$NRT_decref, %rbx
	movq	%r13, %rdi
	callq	*%rbx
	movq	%r15, %rdi
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
	movq	%r15, %rdi
	callq	*%rax
	jmp	.LBB1_14
.LBB1_4:
	movabsq	$PyExc_RuntimeError, %rdi
	movabsq	$".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx", %rsi
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
	movq	%r13, %rdi
	callq	*%rax
.LBB1_1:
	xorl	%eax, %eax
	jmp	.LBB1_2
.LBB1_16:
	xorl	%r12d, %r12d
	jmp	.LBB1_18
.Lfunc_end1:
	.size	_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, .Lfunc_end1-_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.cfi_endproc

	.globl	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx
	.p2align	4
	.type	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@function
cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx:
	subq	$104, %rsp
	movq	152(%rsp), %rax
	movq	176(%rsp), %rcx
	movq	$0, 96(%rsp)
	movq	%rcx, 80(%rsp)
	movq	%rax, 56(%rsp)
	movq	%r8, (%rsp)
	movabsq	$_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, %rax
	leaq	96(%rsp), %rdi
	movq	%rdx, %r8
	callq	*%rax
	vmovsd	96(%rsp), %xmm0
	addq	$104, %rsp
	retq
.Lfunc_end2:
	.size	cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, .Lfunc_end2-cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx

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

	.type	_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,@object
	.comm	_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx,8,8
	.type	".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx",@object
	.p2align	4, 0x0
".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx":
	.asciz	"missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx"
	.size	".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx", 188

	.type	".const.can't unbox array from PyObject into native value.  The object maybe of a different type",@object
	.p2align	4, 0x0
".const.can't unbox array from PyObject into native value.  The object maybe of a different type":
	.asciz	"can't unbox array from PyObject into native value.  The object maybe of a different type"
	.size	".const.can't unbox array from PyObject into native value.  The object maybe of a different type", 89

	.section	".note.GNU-stack","",@progbits
