; ModuleID = 'make_kernel.<locals>.kernel'
source_filename = "<string>"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@".const.make_kernel.<locals>.kernel" = internal constant [28 x i8] c"make_kernel.<locals>.kernel\00"
@_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx = common local_unnamed_addr global ptr null
@".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx" = internal constant [210 x i8] c"missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx\00"
@PyExc_TypeError = external global i8
@".const.can't unbox array from PyObject into native value.  The object maybe of a different type" = internal constant [89 x i8] c"can't unbox array from PyObject into native value.  The object maybe of a different type\00"
@PyExc_RuntimeError = external global i8

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define noundef i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr noalias writeonly captures(none) %retptr, ptr noalias readnone captures(none) %excinfo, ptr readnone captures(none) %arg.out.0, ptr readnone captures(none) %arg.out.1, i64 %arg.out.2, i64 %arg.out.3, ptr captures(none) %arg.out.4, i64 %arg.out.5.0, i64 %arg.out.6.0, ptr readnone captures(none) %arg.x.0, ptr readnone captures(none) %arg.x.1, i64 %arg.x.2, i64 %arg.x.3, ptr readonly captures(none) %arg.x.4, i64 %arg.x.5.0, i64 %arg.x.6.0, double %arg.mul, i64 %arg.sweeps) local_unnamed_addr #0 {
B0.endif:
  %.117214.not = icmp slt i64 %arg.sweeps, 1
  %.241202.not = icmp slt i64 %arg.out.2, 1
  %or.cond = select i1 %.117214.not, i1 true, i1 %.241202.not
  br i1 %or.cond, label %B166, label %B32.endif.us.preheader

B32.endif.us.preheader:                           ; preds = %B0.endif
  %0 = shl i64 %arg.out.2, 3
  %scevgep = getelementptr i8, ptr %arg.out.4, i64 %0
  %scevgep1 = getelementptr i8, ptr %arg.x.4, i64 %0
  %bound0 = icmp ult ptr %arg.out.4, %scevgep1
  %bound1 = icmp ult ptr %arg.x.4, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %n.vec = and i64 %arg.out.2, 9223372036854775804
  %broadcast.splatinsert = insertelement <4 x double> poison, double %arg.mul, i64 0
  %broadcast.splat = shufflevector <4 x double> %broadcast.splatinsert, <4 x double> poison, <4 x i32> zeroinitializer
  br label %B32.endif.us

B32.endif.us:                                     ; preds = %B32.endif.us.preheader, %B76.B28.loopexit_crit_edge.us
  %.116207217.us = phi i64 [ %.126.us, %B76.B28.loopexit_crit_edge.us ], [ %arg.sweeps, %B32.endif.us.preheader ]
  %1 = icmp ult i64 %arg.out.2, 4
  %brmerge = select i1 %1, i1 true, i1 %found.conflict
  br i1 %brmerge, label %B80.endif.endif.us.preheader, label %vector.body.preheader

vector.body.preheader:                            ; preds = %B32.endif.us
  br label %vector.body

vector.body:                                      ; preds = %vector.body.preheader, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.body.preheader ]
  %2 = shl i64 %index, 3
  %scevgep4 = getelementptr i8, ptr %arg.out.4, i64 %2
  %wide.load = load <4 x double>, ptr %scevgep4, align 8, !alias.scope !0, !noalias !3
  %3 = shl i64 %index, 3
  %scevgep3 = getelementptr i8, ptr %arg.x.4, i64 %3
  %wide.load2 = load <4 x double>, ptr %scevgep3, align 8, !alias.scope !3
  %4 = fmul fast <4 x double> %wide.load, %broadcast.splat
  %5 = fadd fast <4 x double> %4, %wide.load2
  %6 = fmul fast <4 x double> %5, %broadcast.splat
  %7 = fadd fast <4 x double> %6, %wide.load2
  %8 = fmul fast <4 x double> %7, %broadcast.splat
  %9 = fadd fast <4 x double> %8, %wide.load2
  %10 = fmul fast <4 x double> %9, %broadcast.splat
  %11 = fadd fast <4 x double> %10, %wide.load2
  %12 = fmul fast <4 x double> %11, %broadcast.splat
  %13 = fadd fast <4 x double> %12, %wide.load2
  %14 = fmul fast <4 x double> %13, %broadcast.splat
  %15 = fadd fast <4 x double> %14, %wide.load2
  %16 = fmul fast <4 x double> %15, %broadcast.splat
  %17 = fadd fast <4 x double> %16, %wide.load2
  %18 = fmul fast <4 x double> %17, %broadcast.splat
  %19 = fadd fast <4 x double> %18, %wide.load2
  %20 = fmul fast <4 x double> %19, %broadcast.splat
  %21 = fadd fast <4 x double> %20, %wide.load2
  %22 = fmul fast <4 x double> %21, %broadcast.splat
  %23 = fadd fast <4 x double> %22, %wide.load2
  %24 = fmul fast <4 x double> %23, %broadcast.splat
  %25 = fadd fast <4 x double> %24, %wide.load2
  %26 = fmul fast <4 x double> %25, %broadcast.splat
  %27 = fadd fast <4 x double> %26, %wide.load2
  %28 = fmul fast <4 x double> %27, %broadcast.splat
  %29 = fadd fast <4 x double> %28, %wide.load2
  %30 = fmul fast <4 x double> %29, %broadcast.splat
  %31 = fadd fast <4 x double> %30, %wide.load2
  %32 = fmul fast <4 x double> %31, %broadcast.splat
  %33 = fadd fast <4 x double> %32, %wide.load2
  %34 = fmul fast <4 x double> %33, %broadcast.splat
  %35 = fadd fast <4 x double> %34, %wide.load2
  store <4 x double> %35, ptr %scevgep4, align 8, !alias.scope !0, !noalias !3
  %index.next = add nuw i64 %index, 4
  %36 = icmp eq i64 %n.vec, %index.next
  br i1 %36, label %middle.block, label %vector.body, !llvm.loop !5

middle.block:                                     ; preds = %vector.body
  %37 = icmp eq i64 %arg.out.2, %n.vec
  br i1 %37, label %B76.B28.loopexit_crit_edge.us, label %B80.endif.endif.us.preheader

B80.endif.endif.us.preheader:                     ; preds = %B32.endif.us, %middle.block
  %.247199203.us.ph = phi i64 [ %n.vec, %middle.block ], [ 0, %B32.endif.us ]
  br label %B80.endif.endif.us

B80.endif.endif.us:                               ; preds = %B80.endif.endif.us.preheader, %B80.endif.endif.us
  %.247199203.us = phi i64 [ %.254.us, %B80.endif.endif.us ], [ %.247199203.us.ph, %B80.endif.endif.us.preheader ]
  %38 = shl i64 %.247199203.us, 3
  %scevgep6 = getelementptr i8, ptr %arg.out.4, i64 %38
  %.312.us = load double, ptr %scevgep6, align 8
  %39 = shl i64 %.247199203.us, 3
  %scevgep5 = getelementptr i8, ptr %arg.x.4, i64 %39
  %.346.us = load double, ptr %scevgep5, align 8
  %.469.us = fmul fast double %.312.us, %arg.mul
  %.471.us = fadd fast double %.469.us, %.346.us
  %.469.us.1 = fmul fast double %.471.us, %arg.mul
  %.471.us.1 = fadd fast double %.469.us.1, %.346.us
  %.469.us.2 = fmul fast double %.471.us.1, %arg.mul
  %.471.us.2 = fadd fast double %.469.us.2, %.346.us
  %.469.us.3 = fmul fast double %.471.us.2, %arg.mul
  %.471.us.3 = fadd fast double %.469.us.3, %.346.us
  %.469.us.4 = fmul fast double %.471.us.3, %arg.mul
  %.471.us.4 = fadd fast double %.469.us.4, %.346.us
  %.469.us.5 = fmul fast double %.471.us.4, %arg.mul
  %.471.us.5 = fadd fast double %.469.us.5, %.346.us
  %.469.us.6 = fmul fast double %.471.us.5, %arg.mul
  %.471.us.6 = fadd fast double %.469.us.6, %.346.us
  %.469.us.7 = fmul fast double %.471.us.6, %arg.mul
  %.471.us.7 = fadd fast double %.469.us.7, %.346.us
  %.469.us.8 = fmul fast double %.471.us.7, %arg.mul
  %.471.us.8 = fadd fast double %.469.us.8, %.346.us
  %.469.us.9 = fmul fast double %.471.us.8, %arg.mul
  %.471.us.9 = fadd fast double %.469.us.9, %.346.us
  %.469.us.10 = fmul fast double %.471.us.9, %arg.mul
  %.471.us.10 = fadd fast double %.469.us.10, %.346.us
  %.469.us.11 = fmul fast double %.471.us.10, %arg.mul
  %.471.us.11 = fadd fast double %.469.us.11, %.346.us
  %.469.us.12 = fmul fast double %.471.us.11, %arg.mul
  %.471.us.12 = fadd fast double %.469.us.12, %.346.us
  %.469.us.13 = fmul fast double %.471.us.12, %arg.mul
  %.471.us.13 = fadd fast double %.469.us.13, %.346.us
  %.469.us.14 = fmul fast double %.471.us.13, %arg.mul
  %.471.us.14 = fadd fast double %.469.us.14, %.346.us
  %.469.us.15 = fmul fast double %.471.us.14, %arg.mul
  %.471.us.15 = fadd fast double %.469.us.15, %.346.us
  %.254.us = add nuw nsw i64 %.247199203.us, 1
  store double %.471.us.15, ptr %scevgep6, align 8
  %exitcond.not = icmp eq i64 %arg.out.2, %.254.us
  br i1 %exitcond.not, label %B76.B28.loopexit_crit_edge.us, label %B80.endif.endif.us, !llvm.loop !8

B76.B28.loopexit_crit_edge.us:                    ; preds = %B80.endif.endif.us, %middle.block
  %.126.us = add nsw i64 %.116207217.us, -1
  %.117.us = icmp sgt i64 %.116207217.us, 1
  br i1 %.117.us, label %B32.endif.us, label %B166

B166:                                             ; preds = %B76.B28.loopexit_crit_edge.us, %B0.endif
  %.563 = load double, ptr %arg.out.4, align 8
  store double %.563, ptr %retptr, align 8
  ret i32 0
}

define ptr @_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr readnone captures(none) %py_closure, ptr %py_args, ptr readnone captures(none) %py_kws) local_unnamed_addr {
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
  br i1 %.10, label %common.ret, label %entry.endif, !prof !9

common.ret:                                       ; preds = %entry.endif.endif.endif.thread, %arg0.err, %entry, %entry.endif.endif.endif.e...endif, %entry.endif.if
  %common.ret.op = phi ptr [ null, %arg0.err ], [ null, %entry ], [ null, %entry.endif.if ], [ null, %entry.endif.endif.endif.thread ], [ %.123, %entry.endif.endif.endif.e...endif ]
  ret ptr %common.ret.op

entry.endif:                                      ; preds = %entry
  %.14 = load ptr, ptr @_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, align 8
  %.19 = icmp eq ptr %.14, null
  br i1 %.19, label %entry.endif.if, label %entry.endif.endif, !prof !9

entry.endif.if:                                   ; preds = %entry.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_RuntimeError, ptr nonnull @".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx")
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
  br i1 %.35, label %entry.endif.endif.endif.thread, label %entry.endif.endif.endif.endif, !prof !9

entry.endif.endif.endif.thread:                   ; preds = %entry.endif.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_TypeError, ptr nonnull @".const.can't unbox array from PyObject into native value.  The object maybe of a different type")
  br label %common.ret

entry.endif.endif.endif.endif:                    ; preds = %entry.endif.endif
  %.39.fca.0.load = load ptr, ptr %.24, align 8
  %sunkaddr1 = getelementptr inbounds i8, ptr %.24, i64 16
  %.39.fca.2.load = load i64, ptr %sunkaddr1, align 8
  %sunkaddr2 = getelementptr inbounds i8, ptr %.24, i64 32
  %.39.fca.4.load = load ptr, ptr %sunkaddr2, align 8
  %.46 = load ptr, ptr %.6, align 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %.47, i8 0, i64 56, i1 false)
  %.51 = call i32 @NRT_adapt_ndarray_from_python(ptr %.46, ptr nonnull %.47)
  %sunkaddr3 = getelementptr inbounds i8, ptr %.47, i64 24
  %.55 = load i64, ptr %sunkaddr3, align 8
  %.56 = icmp ne i64 %.55, 8
  %.57 = icmp ne i32 %.51, 0
  %.58 = or i1 %.57, %.56
  br i1 %.58, label %entry.endif.endif.endif.endif.endif.thread, label %entry.endif.endif.endif.endif.endif.endif, !prof !9

arg0.err:                                         ; preds = %entry.endif.endif.endif.endif.endif.thread, %arg1.err
  call void @NRT_decref(ptr %.39.fca.0.load)
  br label %common.ret

entry.endif.endif.endif.endif.endif.thread:       ; preds = %entry.endif.endif.endif.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_TypeError, ptr nonnull @".const.can't unbox array from PyObject into native value.  The object maybe of a different type")
  br label %arg0.err

entry.endif.endif.endif.endif.endif.endif:        ; preds = %entry.endif.endif.endif.endif
  %.62.fca.0.load = load ptr, ptr %.47, align 8
  %sunkaddr4 = getelementptr inbounds i8, ptr %.47, i64 32
  %.62.fca.4.load = load ptr, ptr %sunkaddr4, align 8
  %.69 = load ptr, ptr %.7, align 8
  %.70 = call ptr @PyNumber_Float(ptr %.69)
  %.71 = call double @PyFloat_AsDouble(ptr %.70)
  call void @Py_DecRef(ptr %.70)
  %.73 = call ptr @PyErr_Occurred()
  %.74.not = icmp eq ptr %.73, null
  br i1 %.74.not, label %entry.endif.endif.endif.endif.endif.endif.endif, label %arg1.err, !prof !10

arg1.err:                                         ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.endif, %entry.endif.endif.endif.endif.endif.endif
  call void @NRT_decref(ptr %.62.fca.0.load)
  br label %arg0.err

entry.endif.endif.endif.endif.endif.endif.endif:  ; preds = %entry.endif.endif.endif.endif.endif.endif
  %.78 = load ptr, ptr %.8, align 8
  %.81 = call ptr @PyNumber_Long(ptr %.78)
  %.82.not = icmp eq ptr %.81, null
  br i1 %.82.not, label %entry.endif.endif.endif.endif.endif.endif.endif.endif, label %entry.endif.endif.endif.endif.endif.endif.endif.if, !prof !9

entry.endif.endif.endif.endif.endif.endif.endif.if: ; preds = %entry.endif.endif.endif.endif.endif.endif.endif
  %.84 = call i64 @PyLong_AsLongLong(ptr nonnull %.81)
  call void @Py_DecRef(ptr nonnull %.81)
  br label %entry.endif.endif.endif.endif.endif.endif.endif.endif

entry.endif.endif.endif.endif.endif.endif.endif.endif: ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.if, %entry.endif.endif.endif.endif.endif.endif.endif
  %.79.0 = phi i64 [ %.84, %entry.endif.endif.endif.endif.endif.endif.endif.if ], [ 0, %entry.endif.endif.endif.endif.endif.endif.endif ]
  %.89 = call ptr @PyErr_Occurred()
  %.90.not = icmp eq ptr %.89, null
  br i1 %.90.not, label %entry.endif.endif.endif.e...endif, label %arg1.err, !prof !10

entry.endif.endif.endif.e...endif:                ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.endif
  store double 0.000000e+00, ptr %.94, align 8
  %.102 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr nonnull %.94, ptr nonnull poison, ptr poison, ptr poison, i64 %.39.fca.2.load, i64 poison, ptr %.39.fca.4.load, i64 poison, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %.62.fca.4.load, i64 poison, i64 poison, double %.71, i64 %.79.0) #3
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
define double @cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx({ ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, double %.3, i64 %.4) local_unnamed_addr #2 {
entry:
  %.6 = alloca double, align 8
  store double 0.000000e+00, ptr %.6, align 8
  %extracted.nitems = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, 2
  %extracted.data = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, 4
  %extracted.data.1 = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, 4
  %.14 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v2B60c8tJTIeFIjxB2IKSgI4CrvQClYb5wBbdC9XqICn1Wk1gKBZBVGsCAA_3d_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr nonnull %.6, ptr nonnull poison, ptr poison, ptr poison, i64 %extracted.nitems, i64 poison, ptr %extracted.data, i64 poison, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %extracted.data.1, i64 poison, i64 poison, double %.3, i64 %.4) #3
  %.24 = load double, ptr %.6, align 8
  ret double %.24
}

; Function Attrs: noinline
define linkonce_odr void @NRT_decref(ptr %.1) local_unnamed_addr #3 {
.3:
  %.4 = icmp eq ptr %.1, null
  br i1 %.4, label %common.ret1, label %.3.endif, !prof !9

common.ret1:                                      ; preds = %.3, %.3.endif
  ret void

.3.endif:                                         ; preds = %.3
  fence release
  %0 = tail call i8 @llvm.x86.atomic.sub.cc.i64(ptr nonnull %.1, i64 1, i32 4)
  %1 = trunc i8 %0 to i1
  br i1 %1, label %.3.endif.if, label %common.ret1, !prof !9

.3.endif.if:                                      ; preds = %.3.endif
  fence acquire
  tail call void @NRT_MemInfo_call_dtor(ptr nonnull %.1)
  ret void
}

; Function Attrs: nounwind
declare i8 @llvm.x86.atomic.sub.cc.i64(ptr, i64, i32 immarg) #4

declare void @NRT_MemInfo_call_dtor(ptr) local_unnamed_addr

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #1 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #2 = { nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) }
attributes #3 = { noinline }
attributes #4 = { nounwind }

!0 = !{!1}
!1 = distinct !{!1, !2}
!2 = distinct !{!2, !"LVerDomain"}
!3 = !{!4}
!4 = distinct !{!4, !2}
!5 = distinct !{!5, !6, !7}
!6 = !{!"llvm.loop.isvectorized", i32 1}
!7 = !{!"llvm.loop.unroll.runtime.disable"}
!8 = distinct !{!8, !6}
!9 = !{!"branch_weights", i32 1, i32 99}
!10 = !{!"branch_weights", i32 99, i32 1}
