; ModuleID = 'make_kernel.<locals>.kernel'
source_filename = "<string>"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@".const.make_kernel.<locals>.kernel" = internal constant [28 x i8] c"make_kernel.<locals>.kernel\00"
@_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx = common local_unnamed_addr global ptr null
@".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx" = internal constant [188 x i8] c"missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx\00"
@PyExc_TypeError = external global i8
@".const.can't unbox array from PyObject into native value.  The object maybe of a different type" = internal constant [89 x i8] c"can't unbox array from PyObject into native value.  The object maybe of a different type\00"
@PyExc_RuntimeError = external global i8

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define noundef i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr noalias writeonly captures(none) %retptr, ptr noalias readnone captures(none) %excinfo, ptr readnone captures(none) %arg.out.0, ptr readnone captures(none) %arg.out.1, i64 %arg.out.2, i64 %arg.out.3, ptr captures(none) %arg.out.4, i64 %arg.out.5.0, i64 %arg.out.6.0, ptr readnone captures(none) %arg.x.0, ptr readnone captures(none) %arg.x.1, i64 %arg.x.2, i64 %arg.x.3, ptr readonly captures(none) %arg.x.4, i64 %arg.x.5.0, i64 %arg.x.6.0, double %arg.mul, i64 %arg.sweeps) local_unnamed_addr #0 {
B0.endif:
  %.65 = load double, ptr %arg.out.4, align 8
  %.150199.not = icmp slt i64 %arg.sweeps, 1
  %.280185.not = icmp slt i64 %arg.x.2, 1
  %or.cond = select i1 %.150199.not, i1 true, i1 %.280185.not
  br i1 %or.cond, label %B156, label %B42.endif.us.preheader

B42.endif.us.preheader:                           ; preds = %B0.endif
  %0 = add nsw i64 %arg.x.2, -1
  %xtraiter = and i64 %arg.x.2, 3
  %unroll_iter = and i64 %arg.x.2, 9223372036854775804
  br label %B42.endif.us

B42.endif.us:                                     ; preds = %B42.endif.us.preheader, %B86.B38.loopexit_crit_edge.us
  %acc.4.0203.us = phi double [ %.478.us.3.lcssa, %B86.B38.loopexit_crit_edge.us ], [ %.65, %B42.endif.us.preheader ]
  %.149192202.us = phi i64 [ %.159.us, %B86.B38.loopexit_crit_edge.us ], [ %arg.sweeps, %B42.endif.us.preheader ]
  %1 = icmp ult i64 %0, 3
  br i1 %1, label %B90.endif.endif.us.epil.preheader, label %B90.endif.endif.us.preheader

B90.endif.endif.us.preheader:                     ; preds = %B42.endif.us
  br label %B90.endif.endif.us

B90.endif.endif.us:                               ; preds = %B90.endif.endif.us.preheader, %B90.endif.endif.us
  %acc.3.1188.us = phi double [ %.478.us.3.3, %B90.endif.endif.us ], [ %acc.4.0203.us, %B90.endif.endif.us.preheader ]
  %.286182186.us = phi i64 [ %.293.us.3, %B90.endif.endif.us ], [ 0, %B90.endif.endif.us.preheader ]
  %sunkaddr = mul i64 %.286182186.us, 8
  %sunkaddr36 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr
  %.353.us = load double, ptr %sunkaddr36, align 8
  %.476.us = fmul double %arg.mul, %acc.3.1188.us
  %.478.us = fadd double %.476.us, %.353.us
  %.476.us.1 = fmul double %arg.mul, %.478.us
  %.478.us.1 = fadd double %.353.us, %.476.us.1
  %.476.us.2 = fmul double %arg.mul, %.478.us.1
  %.478.us.2 = fadd double %.353.us, %.476.us.2
  %.476.us.3 = fmul double %arg.mul, %.478.us.2
  %.478.us.3 = fadd double %.353.us, %.476.us.3
  %sunkaddr37 = mul i64 %.286182186.us, 8
  %sunkaddr38 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr37
  %sunkaddr39 = getelementptr i8, ptr %sunkaddr38, i64 8
  %.353.us.1 = load double, ptr %sunkaddr39, align 8
  %.476.us.13 = fmul double %arg.mul, %.478.us.3
  %.478.us.14 = fadd double %.476.us.13, %.353.us.1
  %.476.us.1.1 = fmul double %arg.mul, %.478.us.14
  %.478.us.1.1 = fadd double %.353.us.1, %.476.us.1.1
  %.476.us.2.1 = fmul double %arg.mul, %.478.us.1.1
  %.478.us.2.1 = fadd double %.353.us.1, %.476.us.2.1
  %.476.us.3.1 = fmul double %arg.mul, %.478.us.2.1
  %.478.us.3.1 = fadd double %.353.us.1, %.476.us.3.1
  %sunkaddr40 = mul i64 %.286182186.us, 8
  %sunkaddr41 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr40
  %sunkaddr42 = getelementptr i8, ptr %sunkaddr41, i64 16
  %.353.us.2 = load double, ptr %sunkaddr42, align 8
  %.476.us.25 = fmul double %arg.mul, %.478.us.3.1
  %.478.us.26 = fadd double %.476.us.25, %.353.us.2
  %.476.us.1.2 = fmul double %arg.mul, %.478.us.26
  %.478.us.1.2 = fadd double %.353.us.2, %.476.us.1.2
  %.476.us.2.2 = fmul double %arg.mul, %.478.us.1.2
  %.478.us.2.2 = fadd double %.353.us.2, %.476.us.2.2
  %.476.us.3.2 = fmul double %arg.mul, %.478.us.2.2
  %.478.us.3.2 = fadd double %.353.us.2, %.476.us.3.2
  %sunkaddr43 = mul i64 %.286182186.us, 8
  %sunkaddr44 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr43
  %sunkaddr45 = getelementptr i8, ptr %sunkaddr44, i64 24
  %.353.us.3 = load double, ptr %sunkaddr45, align 8
  %.476.us.37 = fmul double %arg.mul, %.478.us.3.2
  %.478.us.38 = fadd double %.476.us.37, %.353.us.3
  %.476.us.1.3 = fmul double %arg.mul, %.478.us.38
  %.478.us.1.3 = fadd double %.353.us.3, %.476.us.1.3
  %.476.us.2.3 = fmul double %arg.mul, %.478.us.1.3
  %.478.us.2.3 = fadd double %.353.us.3, %.476.us.2.3
  %.476.us.3.3 = fmul double %arg.mul, %.478.us.2.3
  %.478.us.3.3 = fadd double %.353.us.3, %.476.us.3.3
  %.293.us.3 = add nuw i64 %.286182186.us, 4
  %niter.ncmp.3 = icmp eq i64 %unroll_iter, %.293.us.3
  br i1 %niter.ncmp.3, label %B86.B38.loopexit_crit_edge.us.unr-lcssa, label %B90.endif.endif.us

B86.B38.loopexit_crit_edge.us.unr-lcssa:          ; preds = %B90.endif.endif.us
  %2 = icmp eq i64 %xtraiter, 0
  br i1 %2, label %B86.B38.loopexit_crit_edge.us, label %B90.endif.endif.us.epil.preheader

B90.endif.endif.us.epil.preheader:                ; preds = %B86.B38.loopexit_crit_edge.us.unr-lcssa, %B42.endif.us
  %acc.3.1188.us.epil.init = phi double [ %acc.4.0203.us, %B42.endif.us ], [ %.478.us.3.3, %B86.B38.loopexit_crit_edge.us.unr-lcssa ]
  %.286182186.us.epil.init = phi i64 [ 0, %B42.endif.us ], [ %.293.us.3, %B86.B38.loopexit_crit_edge.us.unr-lcssa ]
  %3 = shl i64 %.286182186.us.epil.init, 3
  %scevgep16 = getelementptr i8, ptr %arg.x.4, i64 %3
  br label %B90.endif.endif.us.epil

B90.endif.endif.us.epil:                          ; preds = %B90.endif.endif.us.epil, %B90.endif.endif.us.epil.preheader
  %acc.3.1188.us.epil = phi double [ %acc.3.1188.us.epil.init, %B90.endif.endif.us.epil.preheader ], [ %.478.us.3.epil, %B90.endif.endif.us.epil ]
  %epil.iter = phi i64 [ 0, %B90.endif.endif.us.epil.preheader ], [ %epil.iter.next, %B90.endif.endif.us.epil ]
  %4 = shl i64 %epil.iter, 3
  %scevgep35 = getelementptr i8, ptr %scevgep16, i64 %4
  %.353.us.epil = load double, ptr %scevgep35, align 8
  %.476.us.epil = fmul double %arg.mul, %acc.3.1188.us.epil
  %.478.us.epil = fadd double %.476.us.epil, %.353.us.epil
  %.476.us.1.epil = fmul double %arg.mul, %.478.us.epil
  %.478.us.1.epil = fadd double %.353.us.epil, %.476.us.1.epil
  %.476.us.2.epil = fmul double %arg.mul, %.478.us.1.epil
  %.478.us.2.epil = fadd double %.353.us.epil, %.476.us.2.epil
  %.476.us.3.epil = fmul double %arg.mul, %.478.us.2.epil
  %.478.us.3.epil = fadd double %.353.us.epil, %.476.us.3.epil
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %xtraiter, %epil.iter.next
  br i1 %epil.iter.cmp.not, label %B86.B38.loopexit_crit_edge.us, label %B90.endif.endif.us.epil, !llvm.loop !0

B86.B38.loopexit_crit_edge.us:                    ; preds = %B90.endif.endif.us.epil, %B86.B38.loopexit_crit_edge.us.unr-lcssa
  %.478.us.3.lcssa = phi double [ %.478.us.3.3, %B86.B38.loopexit_crit_edge.us.unr-lcssa ], [ %.478.us.3.epil, %B90.endif.endif.us.epil ]
  %.159.us = add nsw i64 %.149192202.us, -1
  %.150.us = icmp sgt i64 %.149192202.us, 1
  br i1 %.150.us, label %B42.endif.us, label %B156

B156:                                             ; preds = %B86.B38.loopexit_crit_edge.us, %B0.endif
  %acc.4.0.lcssa = phi double [ %.65, %B0.endif ], [ %.478.us.3.lcssa, %B86.B38.loopexit_crit_edge.us ]
  store double %acc.4.0.lcssa, ptr %arg.out.4, align 8
  store double %acc.4.0.lcssa, ptr %retptr, align 8
  ret i32 0
}

define ptr @_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr readnone captures(none) %py_closure, ptr %py_args, ptr readnone captures(none) %py_kws) local_unnamed_addr {
entry:
  %.5 = alloca ptr, align 8
  %.6 = alloca ptr, align 8
  %.7 = alloca ptr, align 8
  %.8 = alloca ptr, align 8
  %.9 = call i32 (ptr, ptr, i64, i64, ...) @PyArg_UnpackTuple(ptr %py_args, ptr nonnull @".const.make_kernel.<locals>.kernel", i64 4, i64 4, ptr nonnull %.5, ptr nonnull %.6, ptr nonnull %.7, ptr nonnull %.8)
  %.10 = icmp eq i32 %.9, 0
  %.24 = alloca { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] }, align 8
  %.47 = alloca { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] }, align 8
  %.94 = alloca double, align 8
  br i1 %.10, label %common.ret, label %entry.endif, !prof !2

common.ret:                                       ; preds = %entry.endif.endif.endif.thread, %arg0.err, %entry, %entry.endif.endif.endif.e...endif, %entry.endif.if
  %common.ret.op = phi ptr [ null, %arg0.err ], [ null, %entry ], [ null, %entry.endif.if ], [ null, %entry.endif.endif.endif.thread ], [ %.123, %entry.endif.endif.endif.e...endif ]
  ret ptr %common.ret.op

entry.endif:                                      ; preds = %entry
  %.14 = load ptr, ptr @_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, align 8
  %.19 = icmp eq ptr %.14, null
  br i1 %.19, label %entry.endif.if, label %entry.endif.endif, !prof !2

entry.endif.if:                                   ; preds = %entry.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_RuntimeError, ptr nonnull @".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx")
  br label %common.ret

entry.endif.endif:                                ; preds = %entry.endif
  %.23 = load ptr, ptr %.5, align 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %.24, i8 0, i64 56, i1 false)
  %.28 = call i32 @NRT_adapt_ndarray_from_python(ptr %.23, ptr nonnull %.24)
  %sunkaddr = getelementptr inbounds i8, ptr %.24, i64 24
  %.32 = load i64, ptr %sunkaddr, align 8
  %.33 = icmp ne i64 %.32, 8
  %.34 = icmp ne i32 %.28, 0
  %.35 = or i1 %.34, %.33
  br i1 %.35, label %entry.endif.endif.endif.thread, label %entry.endif.endif.endif.endif, !prof !2

entry.endif.endif.endif.thread:                   ; preds = %entry.endif.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_TypeError, ptr nonnull @".const.can't unbox array from PyObject into native value.  The object maybe of a different type")
  br label %common.ret

entry.endif.endif.endif.endif:                    ; preds = %entry.endif.endif
  %.39.fca.0.load = load ptr, ptr %.24, align 8
  %sunkaddr1 = getelementptr inbounds i8, ptr %.24, i64 32
  %.39.fca.4.load = load ptr, ptr %sunkaddr1, align 8
  %.46 = load ptr, ptr %.6, align 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %.47, i8 0, i64 56, i1 false)
  %.51 = call i32 @NRT_adapt_ndarray_from_python(ptr %.46, ptr nonnull %.47)
  %sunkaddr2 = getelementptr inbounds i8, ptr %.47, i64 24
  %.55 = load i64, ptr %sunkaddr2, align 8
  %.56 = icmp ne i64 %.55, 8
  %.57 = icmp ne i32 %.51, 0
  %.58 = or i1 %.57, %.56
  br i1 %.58, label %entry.endif.endif.endif.endif.endif.thread, label %entry.endif.endif.endif.endif.endif.endif, !prof !2

arg0.err:                                         ; preds = %entry.endif.endif.endif.endif.endif.thread, %arg1.err
  call void @NRT_decref(ptr %.39.fca.0.load)
  br label %common.ret

entry.endif.endif.endif.endif.endif.thread:       ; preds = %entry.endif.endif.endif.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_TypeError, ptr nonnull @".const.can't unbox array from PyObject into native value.  The object maybe of a different type")
  br label %arg0.err

entry.endif.endif.endif.endif.endif.endif:        ; preds = %entry.endif.endif.endif.endif
  %.62.fca.0.load = load ptr, ptr %.47, align 8
  %sunkaddr3 = getelementptr inbounds i8, ptr %.47, i64 16
  %.62.fca.2.load = load i64, ptr %sunkaddr3, align 8
  %sunkaddr4 = getelementptr inbounds i8, ptr %.47, i64 32
  %.62.fca.4.load = load ptr, ptr %sunkaddr4, align 8
  %.69 = load ptr, ptr %.7, align 8
  %.70 = call ptr @PyNumber_Float(ptr %.69)
  %.71 = call double @PyFloat_AsDouble(ptr %.70)
  call void @Py_DecRef(ptr %.70)
  %.73 = call ptr @PyErr_Occurred()
  %.74.not = icmp eq ptr %.73, null
  br i1 %.74.not, label %entry.endif.endif.endif.endif.endif.endif.endif, label %arg1.err, !prof !3

arg1.err:                                         ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.endif, %entry.endif.endif.endif.endif.endif.endif
  call void @NRT_decref(ptr %.62.fca.0.load)
  br label %arg0.err

entry.endif.endif.endif.endif.endif.endif.endif:  ; preds = %entry.endif.endif.endif.endif.endif.endif
  %.78 = load ptr, ptr %.8, align 8
  %.81 = call ptr @PyNumber_Long(ptr %.78)
  %.82.not = icmp eq ptr %.81, null
  br i1 %.82.not, label %entry.endif.endif.endif.endif.endif.endif.endif.endif, label %entry.endif.endif.endif.endif.endif.endif.endif.if, !prof !2

entry.endif.endif.endif.endif.endif.endif.endif.if: ; preds = %entry.endif.endif.endif.endif.endif.endif.endif
  %.84 = call i64 @PyLong_AsLongLong(ptr nonnull %.81)
  call void @Py_DecRef(ptr nonnull %.81)
  br label %entry.endif.endif.endif.endif.endif.endif.endif.endif

entry.endif.endif.endif.endif.endif.endif.endif.endif: ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.if, %entry.endif.endif.endif.endif.endif.endif.endif
  %.79.0 = phi i64 [ %.84, %entry.endif.endif.endif.endif.endif.endif.endif.if ], [ 0, %entry.endif.endif.endif.endif.endif.endif.endif ]
  %.89 = call ptr @PyErr_Occurred()
  %.90.not = icmp eq ptr %.89, null
  br i1 %.90.not, label %entry.endif.endif.endif.e...endif, label %arg1.err, !prof !3

entry.endif.endif.endif.e...endif:                ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.endif
  store double 0.000000e+00, ptr %.94, align 8
  %.102 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr nonnull %.94, ptr nonnull poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %.39.fca.4.load, i64 poison, i64 poison, ptr poison, ptr poison, i64 %.62.fca.2.load, i64 poison, ptr %.62.fca.4.load, i64 poison, i64 poison, double %.71, i64 %.79.0) #3
  %.112 = load double, ptr %.94, align 8
  call void @NRT_decref(ptr %.39.fca.0.load)
  call void @NRT_decref(ptr %.62.fca.0.load)
  %.123 = call ptr @PyFloat_FromDouble(double %.112)
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
define double @cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx({ ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, double %.3, i64 %.4) local_unnamed_addr #2 {
entry:
  %.6 = alloca double, align 8
  store double 0.000000e+00, ptr %.6, align 8
  %extracted.data = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, 4
  %extracted.nitems.1 = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, 2
  %extracted.data.1 = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, 4
  %.14 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v4B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr nonnull %.6, ptr nonnull poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %extracted.data, i64 poison, i64 poison, ptr poison, ptr poison, i64 %extracted.nitems.1, i64 poison, ptr %extracted.data.1, i64 poison, i64 poison, double %.3, i64 %.4) #3
  %.24 = load double, ptr %.6, align 8
  ret double %.24
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
