; ModuleID = 'make_kernel.<locals>.kernel'
source_filename = "<string>"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@".const.make_kernel.<locals>.kernel" = internal constant [28 x i8] c"make_kernel.<locals>.kernel\00"
@_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx = common local_unnamed_addr global ptr null
@".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx" = internal constant [241 x i8] c"missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx\00"
@PyExc_TypeError = external global i8
@".const.can't unbox array from PyObject into native value.  The object maybe of a different type" = internal constant [89 x i8] c"can't unbox array from PyObject into native value.  The object maybe of a different type\00"
@PyExc_RuntimeError = external global i8

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define noundef i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx(ptr noalias writeonly captures(none) %retptr, ptr noalias readnone captures(none) %excinfo, ptr readnone captures(none) %arg.out.0, ptr readnone captures(none) %arg.out.1, i64 %arg.out.2, i64 %arg.out.3, ptr captures(none) %arg.out.4, i64 %arg.out.5.0, i64 %arg.out.6.0, ptr readnone captures(none) %arg.x.0, ptr readnone captures(none) %arg.x.1, i64 %arg.x.2, i64 %arg.x.3, ptr readonly captures(none) %arg.x.4, i64 %arg.x.5.0, i64 %arg.x.6.0, ptr readnone captures(none) %arg.indices.0, ptr readnone captures(none) %arg.indices.1, i64 %arg.indices.2, i64 %arg.indices.3, ptr readonly captures(none) %arg.indices.4, i64 %arg.indices.5.0, i64 %arg.indices.6.0, double %arg.mul, i64 %arg.sweeps) local_unnamed_addr #0 {
B0.endif:
  %.131234.not = icmp slt i64 %arg.sweeps, 1
  %.255222.not = icmp slt i64 %arg.out.2, 1
  %or.cond = select i1 %.131234.not, i1 true, i1 %.255222.not
  br i1 %or.cond, label %B172, label %B32.endif.us.preheader

B32.endif.us.preheader:                           ; preds = %B0.endif
  %0 = add nsw i64 %arg.out.2, -1
  %xtraiter = and i64 %arg.out.2, 3
  %unroll_iter = and i64 %arg.out.2, 9223372036854775804
  br label %B32.endif.us

B32.endif.us:                                     ; preds = %B32.endif.us.preheader, %B76.B28.loopexit_crit_edge.us
  %.130227237.us = phi i64 [ %.140.us, %B76.B28.loopexit_crit_edge.us ], [ %arg.sweeps, %B32.endif.us.preheader ]
  %1 = icmp ult i64 %0, 3
  br i1 %1, label %B80.endif.endif.us.epil.preheader, label %B80.endif.endif.us.preheader

B80.endif.endif.us.preheader:                     ; preds = %B32.endif.us
  br label %B80.endif.endif.us

B80.endif.endif.us:                               ; preds = %B80.endif.endif.us.preheader, %B80.endif.endif.us
  %.261219223.us = phi i64 [ %.268.us.3, %B80.endif.endif.us ], [ 0, %B80.endif.endif.us.preheader ]
  %sunkaddr = mul i64 %.261219223.us, 8
  %sunkaddr65 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr
  %.326.us = load double, ptr %sunkaddr65, align 8
  %sunkaddr66 = mul i64 %.261219223.us, 8
  %sunkaddr67 = getelementptr i8, ptr %arg.indices.4, i64 %sunkaddr66
  %.360.us = load i64, ptr %sunkaddr67, align 8
  %.374.us = icmp slt i64 %.360.us, 0
  %.375.us = select i1 %.374.us, i64 %arg.x.5.0, i64 0
  %2 = getelementptr double, ptr %arg.x.4, i64 %.360.us
  %.389.us = getelementptr double, ptr %2, i64 %.375.us
  %.390.us = load double, ptr %.389.us, align 8
  %.513.us = fmul fast double %.326.us, %arg.mul
  %.515.us = fadd fast double %.390.us, %.513.us
  %.513.us.1 = fmul fast double %.515.us, %arg.mul
  %.515.us.1 = fadd fast double %.513.us.1, %.390.us
  %.513.us.2 = fmul fast double %.515.us.1, %arg.mul
  %.515.us.2 = fadd fast double %.513.us.2, %.390.us
  %.513.us.3 = fmul fast double %.515.us.2, %arg.mul
  %.515.us.3 = fadd fast double %.513.us.3, %.390.us
  store double %.515.us.3, ptr %sunkaddr65, align 8
  %sunkaddr68 = mul i64 %.261219223.us, 8
  %sunkaddr69 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr68
  %sunkaddr70 = getelementptr i8, ptr %sunkaddr69, i64 8
  %.326.us.1 = load double, ptr %sunkaddr70, align 8
  %sunkaddr71 = mul i64 %.261219223.us, 8
  %sunkaddr72 = getelementptr i8, ptr %arg.indices.4, i64 %sunkaddr71
  %sunkaddr73 = getelementptr i8, ptr %sunkaddr72, i64 8
  %.360.us.1 = load i64, ptr %sunkaddr73, align 8
  %.374.us.1 = icmp slt i64 %.360.us.1, 0
  %.375.us.1 = select i1 %.374.us.1, i64 %arg.x.5.0, i64 0
  %3 = getelementptr double, ptr %arg.x.4, i64 %.360.us.1
  %.389.us.1 = getelementptr double, ptr %3, i64 %.375.us.1
  %.390.us.1 = load double, ptr %.389.us.1, align 8
  %.513.us.12 = fmul fast double %.326.us.1, %arg.mul
  %.515.us.13 = fadd fast double %.390.us.1, %.513.us.12
  %.513.us.1.1 = fmul fast double %.515.us.13, %arg.mul
  %.515.us.1.1 = fadd fast double %.513.us.1.1, %.390.us.1
  %.513.us.2.1 = fmul fast double %.515.us.1.1, %arg.mul
  %.515.us.2.1 = fadd fast double %.513.us.2.1, %.390.us.1
  %.513.us.3.1 = fmul fast double %.515.us.2.1, %arg.mul
  %.515.us.3.1 = fadd fast double %.513.us.3.1, %.390.us.1
  store double %.515.us.3.1, ptr %sunkaddr70, align 8
  %sunkaddr74 = mul i64 %.261219223.us, 8
  %sunkaddr75 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr74
  %sunkaddr76 = getelementptr i8, ptr %sunkaddr75, i64 16
  %.326.us.2 = load double, ptr %sunkaddr76, align 8
  %sunkaddr77 = mul i64 %.261219223.us, 8
  %sunkaddr78 = getelementptr i8, ptr %arg.indices.4, i64 %sunkaddr77
  %sunkaddr79 = getelementptr i8, ptr %sunkaddr78, i64 16
  %.360.us.2 = load i64, ptr %sunkaddr79, align 8
  %.374.us.2 = icmp slt i64 %.360.us.2, 0
  %.375.us.2 = select i1 %.374.us.2, i64 %arg.x.5.0, i64 0
  %4 = getelementptr double, ptr %arg.x.4, i64 %.360.us.2
  %.389.us.2 = getelementptr double, ptr %4, i64 %.375.us.2
  %.390.us.2 = load double, ptr %.389.us.2, align 8
  %.513.us.24 = fmul fast double %.326.us.2, %arg.mul
  %.515.us.25 = fadd fast double %.390.us.2, %.513.us.24
  %.513.us.1.2 = fmul fast double %.515.us.25, %arg.mul
  %.515.us.1.2 = fadd fast double %.513.us.1.2, %.390.us.2
  %.513.us.2.2 = fmul fast double %.515.us.1.2, %arg.mul
  %.515.us.2.2 = fadd fast double %.513.us.2.2, %.390.us.2
  %.513.us.3.2 = fmul fast double %.515.us.2.2, %arg.mul
  %.515.us.3.2 = fadd fast double %.513.us.3.2, %.390.us.2
  store double %.515.us.3.2, ptr %sunkaddr76, align 8
  %sunkaddr80 = mul i64 %.261219223.us, 8
  %sunkaddr81 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr80
  %sunkaddr82 = getelementptr i8, ptr %sunkaddr81, i64 24
  %.326.us.3 = load double, ptr %sunkaddr82, align 8
  %sunkaddr83 = mul i64 %.261219223.us, 8
  %sunkaddr84 = getelementptr i8, ptr %arg.indices.4, i64 %sunkaddr83
  %sunkaddr85 = getelementptr i8, ptr %sunkaddr84, i64 24
  %.360.us.3 = load i64, ptr %sunkaddr85, align 8
  %.374.us.3 = icmp slt i64 %.360.us.3, 0
  %.375.us.3 = select i1 %.374.us.3, i64 %arg.x.5.0, i64 0
  %5 = getelementptr double, ptr %arg.x.4, i64 %.360.us.3
  %.389.us.3 = getelementptr double, ptr %5, i64 %.375.us.3
  %.390.us.3 = load double, ptr %.389.us.3, align 8
  %.513.us.36 = fmul fast double %.326.us.3, %arg.mul
  %.515.us.37 = fadd fast double %.390.us.3, %.513.us.36
  %.513.us.1.3 = fmul fast double %.515.us.37, %arg.mul
  %.515.us.1.3 = fadd fast double %.513.us.1.3, %.390.us.3
  %.513.us.2.3 = fmul fast double %.515.us.1.3, %arg.mul
  %.515.us.2.3 = fadd fast double %.513.us.2.3, %.390.us.3
  %.513.us.3.3 = fmul fast double %.515.us.2.3, %arg.mul
  %.515.us.3.3 = fadd fast double %.513.us.3.3, %.390.us.3
  %.268.us.3 = add nuw i64 %.261219223.us, 4
  store double %.515.us.3.3, ptr %sunkaddr82, align 8
  %niter.ncmp.3 = icmp eq i64 %unroll_iter, %.268.us.3
  br i1 %niter.ncmp.3, label %B76.B28.loopexit_crit_edge.us.unr-lcssa, label %B80.endif.endif.us

B76.B28.loopexit_crit_edge.us.unr-lcssa:          ; preds = %B80.endif.endif.us
  %6 = icmp eq i64 %xtraiter, 0
  br i1 %6, label %B76.B28.loopexit_crit_edge.us, label %B80.endif.endif.us.epil.preheader

B80.endif.endif.us.epil.preheader:                ; preds = %B76.B28.loopexit_crit_edge.us.unr-lcssa, %B32.endif.us
  %.261219223.us.epil.init = phi i64 [ 0, %B32.endif.us ], [ %.268.us.3, %B76.B28.loopexit_crit_edge.us.unr-lcssa ]
  %7 = shl i64 %.261219223.us.epil.init, 3
  %scevgep23 = getelementptr i8, ptr %arg.indices.4, i64 %7
  %scevgep25 = getelementptr i8, ptr %arg.out.4, i64 %7
  br label %B80.endif.endif.us.epil

B80.endif.endif.us.epil:                          ; preds = %B80.endif.endif.us.epil, %B80.endif.endif.us.epil.preheader
  %epil.iter = phi i64 [ 0, %B80.endif.endif.us.epil.preheader ], [ %epil.iter.next, %B80.endif.endif.us.epil ]
  %8 = shl i64 %epil.iter, 3
  %scevgep63 = getelementptr i8, ptr %scevgep25, i64 %8
  %.326.us.epil = load double, ptr %scevgep63, align 8
  %scevgep64 = getelementptr i8, ptr %scevgep23, i64 %8
  %.360.us.epil = load i64, ptr %scevgep64, align 8
  %.374.us.epil = icmp slt i64 %.360.us.epil, 0
  %.375.us.epil = select i1 %.374.us.epil, i64 %arg.x.5.0, i64 0
  %9 = getelementptr double, ptr %arg.x.4, i64 %.360.us.epil
  %.389.us.epil = getelementptr double, ptr %9, i64 %.375.us.epil
  %.390.us.epil = load double, ptr %.389.us.epil, align 8
  %.513.us.epil = fmul fast double %.326.us.epil, %arg.mul
  %.515.us.epil = fadd fast double %.390.us.epil, %.513.us.epil
  %.513.us.1.epil = fmul fast double %.515.us.epil, %arg.mul
  %.515.us.1.epil = fadd fast double %.513.us.1.epil, %.390.us.epil
  %.513.us.2.epil = fmul fast double %.515.us.1.epil, %arg.mul
  %.515.us.2.epil = fadd fast double %.513.us.2.epil, %.390.us.epil
  %.513.us.3.epil = fmul fast double %.515.us.2.epil, %arg.mul
  %.515.us.3.epil = fadd fast double %.513.us.3.epil, %.390.us.epil
  store double %.515.us.3.epil, ptr %scevgep63, align 8
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %xtraiter, %epil.iter.next
  br i1 %epil.iter.cmp.not, label %B76.B28.loopexit_crit_edge.us, label %B80.endif.endif.us.epil, !llvm.loop !0

B76.B28.loopexit_crit_edge.us:                    ; preds = %B80.endif.endif.us.epil, %B76.B28.loopexit_crit_edge.us.unr-lcssa
  %.140.us = add nsw i64 %.130227237.us, -1
  %.131.us = icmp sgt i64 %.130227237.us, 1
  br i1 %.131.us, label %B32.endif.us, label %B172

B172:                                             ; preds = %B76.B28.loopexit_crit_edge.us, %B0.endif
  %.612 = load double, ptr %arg.out.4, align 8
  store double %.612, ptr %retptr, align 8
  ret i32 0
}

define ptr @_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx(ptr readnone captures(none) %py_closure, ptr %py_args, ptr readnone captures(none) %py_kws) local_unnamed_addr {
entry:
  %.5 = alloca ptr, align 8
  %.6 = alloca ptr, align 8
  %.7 = alloca ptr, align 8
  %.8 = alloca ptr, align 8
  %.9 = alloca ptr, align 8
  %.10 = call i32 (ptr, ptr, i64, i64, ...) @PyArg_UnpackTuple(ptr %py_args, ptr nonnull @".const.make_kernel.<locals>.kernel", i64 5, i64 5, ptr nonnull %.5, ptr nonnull %.6, ptr nonnull %.7, ptr nonnull %.8, ptr nonnull %.9)
  %.11 = icmp eq i32 %.10, 0
  %.25 = alloca { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] }, align 8
  %.48 = alloca { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] }, align 8
  %.71 = alloca { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] }, align 8
  %.118 = alloca double, align 8
  br i1 %.11, label %common.ret, label %entry.endif, !prof !2

common.ret:                                       ; preds = %entry.endif.endif.endif.thread, %arg0.err, %entry, %entry.endif.endif.endif.e...endif.endif.endif, %entry.endif.if
  %common.ret.op = phi ptr [ null, %arg0.err ], [ null, %entry ], [ null, %entry.endif.if ], [ null, %entry.endif.endif.endif.thread ], [ %.152, %entry.endif.endif.endif.e...endif.endif.endif ]
  ret ptr %common.ret.op

entry.endif:                                      ; preds = %entry
  %.15 = load ptr, ptr @_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx, align 8
  %.20 = icmp eq ptr %.15, null
  br i1 %.20, label %entry.endif.if, label %entry.endif.endif, !prof !2

entry.endif.if:                                   ; preds = %entry.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_RuntimeError, ptr nonnull @".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx")
  br label %common.ret

entry.endif.endif:                                ; preds = %entry.endif
  %.24 = load ptr, ptr %.5, align 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %.25, i8 0, i64 56, i1 false)
  %.29 = call i32 @NRT_adapt_ndarray_from_python(ptr %.24, ptr nonnull %.25)
  %sunkaddr = getelementptr inbounds i8, ptr %.25, i64 24
  %.33 = load i64, ptr %sunkaddr, align 8
  %.34 = icmp ne i64 %.33, 8
  %.35 = icmp ne i32 %.29, 0
  %.36 = or i1 %.35, %.34
  br i1 %.36, label %entry.endif.endif.endif.thread, label %entry.endif.endif.endif.endif, !prof !2

entry.endif.endif.endif.thread:                   ; preds = %entry.endif.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_TypeError, ptr nonnull @".const.can't unbox array from PyObject into native value.  The object maybe of a different type")
  br label %common.ret

entry.endif.endif.endif.endif:                    ; preds = %entry.endif.endif
  %.40.fca.0.load = load ptr, ptr %.25, align 8
  %sunkaddr1 = getelementptr inbounds i8, ptr %.25, i64 16
  %.40.fca.2.load = load i64, ptr %sunkaddr1, align 8
  %sunkaddr2 = getelementptr inbounds i8, ptr %.25, i64 32
  %.40.fca.4.load = load ptr, ptr %sunkaddr2, align 8
  %.47 = load ptr, ptr %.6, align 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %.48, i8 0, i64 56, i1 false)
  %.52 = call i32 @NRT_adapt_ndarray_from_python(ptr %.47, ptr nonnull %.48)
  %sunkaddr3 = getelementptr inbounds i8, ptr %.48, i64 24
  %.56 = load i64, ptr %sunkaddr3, align 8
  %.57 = icmp ne i64 %.56, 8
  %.58 = icmp ne i32 %.52, 0
  %.59 = or i1 %.58, %.57
  br i1 %.59, label %entry.endif.endif.endif.endif.endif.thread, label %entry.endif.endif.endif.endif.endif.endif, !prof !2

arg0.err:                                         ; preds = %entry.endif.endif.endif.endif.endif.thread, %arg1.err
  call void @NRT_decref(ptr %.40.fca.0.load)
  br label %common.ret

entry.endif.endif.endif.endif.endif.thread:       ; preds = %entry.endif.endif.endif.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_TypeError, ptr nonnull @".const.can't unbox array from PyObject into native value.  The object maybe of a different type")
  br label %arg0.err

entry.endif.endif.endif.endif.endif.endif:        ; preds = %entry.endif.endif.endif.endif
  %.63.fca.0.load = load ptr, ptr %.48, align 8
  %sunkaddr4 = getelementptr inbounds i8, ptr %.48, i64 32
  %.63.fca.4.load = load ptr, ptr %sunkaddr4, align 8
  %sunkaddr5 = getelementptr inbounds i8, ptr %.48, i64 40
  %.63.fca.5.0.load = load i64, ptr %sunkaddr5, align 8
  %.70 = load ptr, ptr %.7, align 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %.71, i8 0, i64 56, i1 false)
  %.75 = call i32 @NRT_adapt_ndarray_from_python(ptr %.70, ptr nonnull %.71)
  %sunkaddr6 = getelementptr inbounds i8, ptr %.71, i64 24
  %.79 = load i64, ptr %sunkaddr6, align 8
  %.80 = icmp ne i64 %.79, 8
  %.81 = icmp ne i32 %.75, 0
  %.82 = or i1 %.81, %.80
  br i1 %.82, label %entry.endif.endif.endif.endif.endif.endif.endif.thread, label %entry.endif.endif.endif.endif.endif.endif.endif.endif, !prof !2

arg1.err:                                         ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.thread, %arg2.err
  call void @NRT_decref(ptr %.63.fca.0.load)
  br label %arg0.err

entry.endif.endif.endif.endif.endif.endif.endif.thread: ; preds = %entry.endif.endif.endif.endif.endif.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_TypeError, ptr nonnull @".const.can't unbox array from PyObject into native value.  The object maybe of a different type")
  br label %arg1.err

entry.endif.endif.endif.endif.endif.endif.endif.endif: ; preds = %entry.endif.endif.endif.endif.endif.endif
  %.86.fca.0.load = load ptr, ptr %.71, align 8
  %sunkaddr7 = getelementptr inbounds i8, ptr %.71, i64 32
  %.86.fca.4.load = load ptr, ptr %sunkaddr7, align 8
  %.93 = load ptr, ptr %.8, align 8
  %.94 = call ptr @PyNumber_Float(ptr %.93)
  %.95 = call double @PyFloat_AsDouble(ptr %.94)
  call void @Py_DecRef(ptr %.94)
  %.97 = call ptr @PyErr_Occurred()
  %.98.not = icmp eq ptr %.97, null
  br i1 %.98.not, label %entry.endif.endif.endif.e...endif, label %arg2.err, !prof !3

arg2.err:                                         ; preds = %entry.endif.endif.endif.e...endif.endif, %entry.endif.endif.endif.endif.endif.endif.endif.endif
  call void @NRT_decref(ptr %.86.fca.0.load)
  br label %arg1.err

entry.endif.endif.endif.e...endif:                ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.endif
  %.102 = load ptr, ptr %.9, align 8
  %.105 = call ptr @PyNumber_Long(ptr %.102)
  %.106.not = icmp eq ptr %.105, null
  br i1 %.106.not, label %entry.endif.endif.endif.e...endif.endif, label %entry.endif.endif.endif.e...endif.if, !prof !2

entry.endif.endif.endif.e...endif.if:             ; preds = %entry.endif.endif.endif.e...endif
  %.108 = call i64 @PyLong_AsLongLong(ptr nonnull %.105)
  call void @Py_DecRef(ptr nonnull %.105)
  br label %entry.endif.endif.endif.e...endif.endif

entry.endif.endif.endif.e...endif.endif:          ; preds = %entry.endif.endif.endif.e...endif.if, %entry.endif.endif.endif.e...endif
  %.103.0 = phi i64 [ %.108, %entry.endif.endif.endif.e...endif.if ], [ 0, %entry.endif.endif.endif.e...endif ]
  %.113 = call ptr @PyErr_Occurred()
  %.114.not = icmp eq ptr %.113, null
  br i1 %.114.not, label %entry.endif.endif.endif.e...endif.endif.endif, label %arg2.err, !prof !3

entry.endif.endif.endif.e...endif.endif.endif:    ; preds = %entry.endif.endif.endif.e...endif.endif
  store double 0.000000e+00, ptr %.118, align 8
  %.128 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx(ptr nonnull %.118, ptr nonnull poison, ptr poison, ptr poison, i64 %.40.fca.2.load, i64 poison, ptr %.40.fca.4.load, i64 poison, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %.63.fca.4.load, i64 %.63.fca.5.0.load, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %.86.fca.4.load, i64 poison, i64 poison, double %.95, i64 %.103.0) #3
  %.138 = load double, ptr %.118, align 8
  call void @NRT_decref(ptr %.40.fca.0.load)
  call void @NRT_decref(ptr %.63.fca.0.load)
  call void @NRT_decref(ptr %.86.fca.0.load)
  %.152 = call ptr @PyFloat_FromDouble(double %.138)
  br label %common.ret
}

declare i32 @PyArg_UnpackTuple(ptr, ptr, i64, i64, ...) local_unnamed_addr

declare void @PyErr_SetString(ptr, ptr) local_unnamed_addr

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #1

declare i32 @NRT_adapt_ndarray_from_python(ptr captures(none), ptr captures(none)) local_unnamed_addr

declare ptr @PyNumber_Float(ptr) local_unnamed_addr

declare double @PyFloat_AsDouble(ptr) local_unnamed_addr

declare void @Py_DecRef(ptr) local_unnamed_addr

declare ptr @PyErr_Occurred() local_unnamed_addr

declare ptr @PyNumber_Long(ptr) local_unnamed_addr

declare i64 @PyLong_AsLongLong(ptr) local_unnamed_addr

declare ptr @PyFloat_FromDouble(double) local_unnamed_addr

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define double @cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx({ ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.3, double %.4, i64 %.5) local_unnamed_addr #2 {
entry:
  %.7 = alloca double, align 8
  store double 0.000000e+00, ptr %.7, align 8
  %extracted.nitems = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, 2
  %extracted.data = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, 4
  %extracted.data.1 = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, 4
  %extracted.shape.1 = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, 5
  %.13 = extractvalue [1 x i64] %extracted.shape.1, 0
  %extracted.data.2 = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.3, 4
  %.17 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v6B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedE5ArrayIxLi1E1C7mutable7alignedEdx(ptr nonnull %.7, ptr nonnull poison, ptr poison, ptr poison, i64 %extracted.nitems, i64 poison, ptr %extracted.data, i64 poison, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %extracted.data.1, i64 %.13, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %extracted.data.2, i64 poison, i64 poison, double %.4, i64 %.5) #3
  %.27 = load double, ptr %.7, align 8
  ret double %.27
}

; Function Attrs: noinline
define linkonce_odr void @NRT_decref(ptr %.1) local_unnamed_addr #3 {
.3:
  %.4 = icmp eq ptr %.1, null
  br i1 %.4, label %common.ret1, label %.3.endif, !prof !2

common.ret1:                                      ; preds = %.3, %.3.endif
  ret void

.3.endif:                                         ; preds = %.3
  fence release
  %0 = tail call i8 @llvm.x86.atomic.sub.cc.i64(ptr nonnull %.1, i64 1, i32 4)
  %1 = trunc i8 %0 to i1
  br i1 %1, label %.3.endif.if, label %common.ret1, !prof !2

.3.endif.if:                                      ; preds = %.3.endif
  fence acquire
  tail call void @NRT_MemInfo_call_dtor(ptr nonnull %.1)
  ret void
}

; Function Attrs: nounwind
declare i8 @llvm.x86.atomic.sub.cc.i64(ptr, i64, i32 immarg) #4

declare void @NRT_MemInfo_call_dtor(ptr) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #5

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #1 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #2 = { nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) }
attributes #3 = { noinline }
attributes #4 = { nounwind }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable"}
!2 = !{!"branch_weights", i32 1, i32 99}
!3 = !{!"branch_weights", i32 99, i32 1}
