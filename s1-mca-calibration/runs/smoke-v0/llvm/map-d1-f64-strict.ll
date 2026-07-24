; ModuleID = 'make_kernel.<locals>.kernel'
source_filename = "<string>"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@".const.make_kernel.<locals>.kernel" = internal constant [28 x i8] c"make_kernel.<locals>.kernel\00"
@_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx = common local_unnamed_addr global ptr null
@".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx" = internal constant [188 x i8] c"missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx\00"
@PyExc_TypeError = external global i8
@".const.can't unbox array from PyObject into native value.  The object maybe of a different type" = internal constant [89 x i8] c"can't unbox array from PyObject into native value.  The object maybe of a different type\00"
@PyExc_RuntimeError = external global i8

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define noundef i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr noalias writeonly captures(none) %retptr, ptr noalias readnone captures(none) %excinfo, ptr readnone captures(none) %arg.out.0, ptr readnone captures(none) %arg.out.1, i64 %arg.out.2, i64 %arg.out.3, ptr captures(none) %arg.out.4, i64 %arg.out.5.0, i64 %arg.out.6.0, ptr readnone captures(none) %arg.x.0, ptr readnone captures(none) %arg.x.1, i64 %arg.x.2, i64 %arg.x.3, ptr readonly captures(none) %arg.x.4, i64 %arg.x.5.0, i64 %arg.x.6.0, double %arg.mul, i64 %arg.sweeps) local_unnamed_addr #0 {
B0.endif:
  %.117214.not = icmp slt i64 %arg.sweeps, 1
  %.241202.not = icmp slt i64 %arg.out.2, 1
  %or.cond = select i1 %.117214.not, i1 true, i1 %.241202.not
  br i1 %or.cond, label %B166, label %B32.endif.us.preheader

B32.endif.us.preheader:                           ; preds = %B0.endif
  %const187 = bitcast i64 9223372036854775792 to i64
  %0 = bitcast i64 %const187 to i64
  %1 = shl i64 %arg.out.2, 3
  %scevgep = getelementptr i8, ptr %arg.out.4, i64 %1
  %scevgep1 = getelementptr i8, ptr %arg.x.4, i64 %1
  %bound0 = icmp ult ptr %arg.out.4, %scevgep1
  %bound1 = icmp ult ptr %arg.x.4, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %n.vec = and i64 %arg.out.2, %0
  %broadcast.splatinsert = insertelement <4 x double> poison, double %arg.mul, i64 0
  %broadcast.splat = shufflevector <4 x double> %broadcast.splatinsert, <4 x double> poison, <4 x i32> zeroinitializer
  %const_mat = add i64 %0, 12
  %n.vec11 = and i64 %arg.out.2, %const_mat
  %broadcast.splatinsert12 = insertelement <4 x double> poison, double %arg.mul, i64 0
  %broadcast.splat13 = shufflevector <4 x double> %broadcast.splatinsert12, <4 x double> poison, <4 x i32> zeroinitializer
  br label %iter.check

iter.check:                                       ; preds = %B32.endif.us.preheader, %B76.B28.loopexit_crit_edge.us
  %.116207217.us = phi i64 [ %.126.us, %B76.B28.loopexit_crit_edge.us ], [ %arg.sweeps, %B32.endif.us.preheader ]
  %2 = icmp ult i64 %arg.out.2, 4
  %brmerge = select i1 %2, i1 true, i1 %found.conflict
  br i1 %brmerge, label %B80.endif.endif.us.preheader, label %vector.main.loop.iter.check

vector.main.loop.iter.check:                      ; preds = %iter.check
  %3 = icmp ult i64 %arg.out.2, 16
  br i1 %3, label %vec.epilog.ph, label %vector.body.preheader

vector.body.preheader:                            ; preds = %vector.main.loop.iter.check
  br label %vector.body

vector.body:                                      ; preds = %vector.body.preheader, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.body.preheader ]
  %sunkaddr = mul i64 %index, 8
  %sunkaddr188 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr
  %wide.load = load <4 x double>, ptr %sunkaddr188, align 8, !alias.scope !0, !noalias !3
  %sunkaddr189 = mul i64 %index, 8
  %sunkaddr190 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr189
  %sunkaddr191 = getelementptr i8, ptr %sunkaddr190, i64 32
  %wide.load3 = load <4 x double>, ptr %sunkaddr191, align 8, !alias.scope !0, !noalias !3
  %sunkaddr192 = mul i64 %index, 8
  %sunkaddr193 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr192
  %sunkaddr194 = getelementptr i8, ptr %sunkaddr193, i64 64
  %wide.load4 = load <4 x double>, ptr %sunkaddr194, align 8, !alias.scope !0, !noalias !3
  %sunkaddr195 = mul i64 %index, 8
  %sunkaddr196 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr195
  %sunkaddr197 = getelementptr i8, ptr %sunkaddr196, i64 96
  %wide.load5 = load <4 x double>, ptr %sunkaddr197, align 8, !alias.scope !0, !noalias !3
  %sunkaddr198 = mul i64 %index, 8
  %sunkaddr199 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr198
  %wide.load6 = load <4 x double>, ptr %sunkaddr199, align 8, !alias.scope !3
  %sunkaddr200 = mul i64 %index, 8
  %sunkaddr201 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr200
  %sunkaddr202 = getelementptr i8, ptr %sunkaddr201, i64 32
  %wide.load7 = load <4 x double>, ptr %sunkaddr202, align 8, !alias.scope !3
  %sunkaddr203 = mul i64 %index, 8
  %sunkaddr204 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr203
  %sunkaddr205 = getelementptr i8, ptr %sunkaddr204, i64 64
  %wide.load8 = load <4 x double>, ptr %sunkaddr205, align 8, !alias.scope !3
  %sunkaddr206 = mul i64 %index, 8
  %sunkaddr207 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr206
  %sunkaddr208 = getelementptr i8, ptr %sunkaddr207, i64 96
  %wide.load9 = load <4 x double>, ptr %sunkaddr208, align 8, !alias.scope !3
  %4 = fmul <4 x double> %broadcast.splat, %wide.load
  %5 = fmul <4 x double> %broadcast.splat, %wide.load3
  %6 = fmul <4 x double> %broadcast.splat, %wide.load4
  %7 = fmul <4 x double> %broadcast.splat, %wide.load5
  %8 = fadd <4 x double> %wide.load6, %4
  %9 = fadd <4 x double> %wide.load7, %5
  %10 = fadd <4 x double> %wide.load8, %6
  %11 = fadd <4 x double> %wide.load9, %7
  store <4 x double> %8, ptr %sunkaddr188, align 8, !alias.scope !0, !noalias !3
  store <4 x double> %9, ptr %sunkaddr191, align 8, !alias.scope !0, !noalias !3
  store <4 x double> %10, ptr %sunkaddr194, align 8, !alias.scope !0, !noalias !3
  store <4 x double> %11, ptr %sunkaddr197, align 8, !alias.scope !0, !noalias !3
  %index.next = add nuw i64 %index, 16
  %12 = icmp eq i64 %n.vec, %index.next
  br i1 %12, label %middle.block, label %vector.body, !llvm.loop !5

middle.block:                                     ; preds = %vector.body
  %13 = icmp eq i64 %arg.out.2, %n.vec
  br i1 %13, label %B76.B28.loopexit_crit_edge.us, label %vec.epilog.iter.check

vec.epilog.iter.check:                            ; preds = %middle.block
  %14 = and i64 %arg.out.2, 12
  %15 = icmp eq i64 %14, 0
  br i1 %15, label %B80.endif.endif.us.preheader, label %vec.epilog.ph, !prof !8

vec.epilog.ph:                                    ; preds = %vector.main.loop.iter.check, %vec.epilog.iter.check
  %vec.epilog.resume.val = phi i64 [ %n.vec, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ]
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index14 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next17, %vec.epilog.vector.body ]
  %16 = shl i64 %index14, 3
  %scevgep37 = getelementptr i8, ptr %arg.out.4, i64 %16
  %wide.load15 = load <4 x double>, ptr %scevgep37, align 8, !alias.scope !0, !noalias !3
  %17 = shl i64 %index14, 3
  %scevgep36 = getelementptr i8, ptr %arg.x.4, i64 %17
  %wide.load16 = load <4 x double>, ptr %scevgep36, align 8, !alias.scope !3
  %18 = fmul <4 x double> %broadcast.splat13, %wide.load15
  %19 = fadd <4 x double> %wide.load16, %18
  store <4 x double> %19, ptr %scevgep37, align 8, !alias.scope !0, !noalias !3
  %index.next17 = add nuw i64 %index14, 4
  %20 = icmp eq i64 %n.vec11, %index.next17
  br i1 %20, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !llvm.loop !9

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %21 = icmp eq i64 %arg.out.2, %n.vec11
  br i1 %21, label %B76.B28.loopexit_crit_edge.us, label %B80.endif.endif.us.preheader

B80.endif.endif.us.preheader:                     ; preds = %iter.check, %vec.epilog.iter.check, %vec.epilog.middle.block
  %.247199203.us.ph = phi i64 [ 0, %iter.check ], [ %n.vec11, %vec.epilog.middle.block ], [ %n.vec, %vec.epilog.iter.check ]
  %22 = sub nsw i64 %arg.out.2, %.247199203.us.ph
  %xtraiter = and i64 %22, 7
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %B80.endif.endif.us.prol.loopexit, label %B80.endif.endif.us.prol.preheader

B80.endif.endif.us.prol.preheader:                ; preds = %B80.endif.endif.us.preheader
  br label %B80.endif.endif.us.prol

B80.endif.endif.us.prol:                          ; preds = %B80.endif.endif.us.prol.preheader, %B80.endif.endif.us.prol
  %lsr.iv = phi i64 [ %xtraiter, %B80.endif.endif.us.prol.preheader ], [ %lsr.iv.next, %B80.endif.endif.us.prol ]
  %.247199203.us.prol = phi i64 [ %.254.us.prol, %B80.endif.endif.us.prol ], [ %.247199203.us.ph, %B80.endif.endif.us.prol.preheader ]
  %23 = shl i64 %.247199203.us.prol, 3
  %scevgep39 = getelementptr i8, ptr %arg.out.4, i64 %23
  %.312.us.prol = load double, ptr %scevgep39, align 8
  %24 = shl i64 %.247199203.us.prol, 3
  %scevgep38 = getelementptr i8, ptr %arg.x.4, i64 %24
  %.346.us.prol = load double, ptr %scevgep38, align 8
  %.469.us.prol = fmul double %arg.mul, %.312.us.prol
  %.471.us.prol = fadd double %.346.us.prol, %.469.us.prol
  %.254.us.prol = add nuw i64 %.247199203.us.prol, 1
  store double %.471.us.prol, ptr %scevgep39, align 8
  %lsr.iv.next = add nsw i64 %lsr.iv, -1
  %prol.iter.cmp.not = icmp eq i64 %lsr.iv.next, 0
  br i1 %prol.iter.cmp.not, label %B80.endif.endif.us.prol.loopexit, label %B80.endif.endif.us.prol, !llvm.loop !10

B80.endif.endif.us.prol.loopexit:                 ; preds = %B80.endif.endif.us.prol, %B80.endif.endif.us.preheader
  %.247199203.us.unr = phi i64 [ %.247199203.us.ph, %B80.endif.endif.us.preheader ], [ %.254.us.prol, %B80.endif.endif.us.prol ]
  %25 = sub nsw i64 %.247199203.us.ph, %arg.out.2
  %26 = icmp ugt i64 %25, -8
  br i1 %26, label %B76.B28.loopexit_crit_edge.us, label %B80.endif.endif.us.preheader19

B80.endif.endif.us.preheader19:                   ; preds = %B80.endif.endif.us.prol.loopexit
  br label %B80.endif.endif.us

B80.endif.endif.us:                               ; preds = %B80.endif.endif.us.preheader19, %B80.endif.endif.us
  %.247199203.us = phi i64 [ %.254.us.7, %B80.endif.endif.us ], [ %.247199203.us.unr, %B80.endif.endif.us.preheader19 ]
  %sunkaddr209 = mul i64 %.247199203.us, 8
  %sunkaddr210 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr209
  %.312.us = load double, ptr %sunkaddr210, align 8
  %sunkaddr211 = mul i64 %.247199203.us, 8
  %sunkaddr212 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr211
  %.346.us = load double, ptr %sunkaddr212, align 8
  %.469.us = fmul double %arg.mul, %.312.us
  %.471.us = fadd double %.346.us, %.469.us
  store double %.471.us, ptr %sunkaddr210, align 8
  %sunkaddr213 = mul i64 %.247199203.us, 8
  %sunkaddr214 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr213
  %sunkaddr215 = getelementptr i8, ptr %sunkaddr214, i64 8
  %.312.us.1 = load double, ptr %sunkaddr215, align 8
  %sunkaddr216 = mul i64 %.247199203.us, 8
  %sunkaddr217 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr216
  %sunkaddr218 = getelementptr i8, ptr %sunkaddr217, i64 8
  %.346.us.1 = load double, ptr %sunkaddr218, align 8
  %.469.us.1 = fmul double %arg.mul, %.312.us.1
  %.471.us.1 = fadd double %.346.us.1, %.469.us.1
  store double %.471.us.1, ptr %sunkaddr215, align 8
  %sunkaddr219 = mul i64 %.247199203.us, 8
  %sunkaddr220 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr219
  %sunkaddr221 = getelementptr i8, ptr %sunkaddr220, i64 16
  %.312.us.2 = load double, ptr %sunkaddr221, align 8
  %sunkaddr222 = mul i64 %.247199203.us, 8
  %sunkaddr223 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr222
  %sunkaddr224 = getelementptr i8, ptr %sunkaddr223, i64 16
  %.346.us.2 = load double, ptr %sunkaddr224, align 8
  %.469.us.2 = fmul double %arg.mul, %.312.us.2
  %.471.us.2 = fadd double %.346.us.2, %.469.us.2
  store double %.471.us.2, ptr %sunkaddr221, align 8
  %sunkaddr225 = mul i64 %.247199203.us, 8
  %sunkaddr226 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr225
  %sunkaddr227 = getelementptr i8, ptr %sunkaddr226, i64 24
  %.312.us.3 = load double, ptr %sunkaddr227, align 8
  %sunkaddr228 = mul i64 %.247199203.us, 8
  %sunkaddr229 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr228
  %sunkaddr230 = getelementptr i8, ptr %sunkaddr229, i64 24
  %.346.us.3 = load double, ptr %sunkaddr230, align 8
  %.469.us.3 = fmul double %arg.mul, %.312.us.3
  %.471.us.3 = fadd double %.346.us.3, %.469.us.3
  store double %.471.us.3, ptr %sunkaddr227, align 8
  %sunkaddr231 = mul i64 %.247199203.us, 8
  %sunkaddr232 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr231
  %sunkaddr233 = getelementptr i8, ptr %sunkaddr232, i64 32
  %.312.us.4 = load double, ptr %sunkaddr233, align 8
  %sunkaddr234 = mul i64 %.247199203.us, 8
  %sunkaddr235 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr234
  %sunkaddr236 = getelementptr i8, ptr %sunkaddr235, i64 32
  %.346.us.4 = load double, ptr %sunkaddr236, align 8
  %.469.us.4 = fmul double %arg.mul, %.312.us.4
  %.471.us.4 = fadd double %.346.us.4, %.469.us.4
  store double %.471.us.4, ptr %sunkaddr233, align 8
  %sunkaddr237 = mul i64 %.247199203.us, 8
  %sunkaddr238 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr237
  %sunkaddr239 = getelementptr i8, ptr %sunkaddr238, i64 40
  %.312.us.5 = load double, ptr %sunkaddr239, align 8
  %sunkaddr240 = mul i64 %.247199203.us, 8
  %sunkaddr241 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr240
  %sunkaddr242 = getelementptr i8, ptr %sunkaddr241, i64 40
  %.346.us.5 = load double, ptr %sunkaddr242, align 8
  %.469.us.5 = fmul double %arg.mul, %.312.us.5
  %.471.us.5 = fadd double %.346.us.5, %.469.us.5
  store double %.471.us.5, ptr %sunkaddr239, align 8
  %sunkaddr243 = mul i64 %.247199203.us, 8
  %sunkaddr244 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr243
  %sunkaddr245 = getelementptr i8, ptr %sunkaddr244, i64 48
  %.312.us.6 = load double, ptr %sunkaddr245, align 8
  %sunkaddr246 = mul i64 %.247199203.us, 8
  %sunkaddr247 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr246
  %sunkaddr248 = getelementptr i8, ptr %sunkaddr247, i64 48
  %.346.us.6 = load double, ptr %sunkaddr248, align 8
  %.469.us.6 = fmul double %arg.mul, %.312.us.6
  %.471.us.6 = fadd double %.346.us.6, %.469.us.6
  store double %.471.us.6, ptr %sunkaddr245, align 8
  %sunkaddr249 = mul i64 %.247199203.us, 8
  %sunkaddr250 = getelementptr i8, ptr %arg.out.4, i64 %sunkaddr249
  %sunkaddr251 = getelementptr i8, ptr %sunkaddr250, i64 56
  %.312.us.7 = load double, ptr %sunkaddr251, align 8
  %sunkaddr252 = mul i64 %.247199203.us, 8
  %sunkaddr253 = getelementptr i8, ptr %arg.x.4, i64 %sunkaddr252
  %sunkaddr254 = getelementptr i8, ptr %sunkaddr253, i64 56
  %.346.us.7 = load double, ptr %sunkaddr254, align 8
  %.469.us.7 = fmul double %arg.mul, %.312.us.7
  %.471.us.7 = fadd double %.346.us.7, %.469.us.7
  %.254.us.7 = add nuw nsw i64 %.247199203.us, 8
  store double %.471.us.7, ptr %sunkaddr251, align 8
  %exitcond.not.7 = icmp eq i64 %arg.out.2, %.254.us.7
  br i1 %exitcond.not.7, label %B76.B28.loopexit_crit_edge.us, label %B80.endif.endif.us, !llvm.loop !12

B76.B28.loopexit_crit_edge.us:                    ; preds = %B80.endif.endif.us, %B80.endif.endif.us.prol.loopexit, %vec.epilog.middle.block, %middle.block
  %.126.us = add nsw i64 %.116207217.us, -1
  %.117.us = icmp sgt i64 %.116207217.us, 1
  br i1 %.117.us, label %iter.check, label %B166

B166:                                             ; preds = %B76.B28.loopexit_crit_edge.us, %B0.endif
  %.563 = load double, ptr %arg.out.4, align 8
  store double %.563, ptr %retptr, align 8
  ret i32 0
}

define ptr @_ZN7cpython8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr readnone captures(none) %py_closure, ptr %py_args, ptr readnone captures(none) %py_kws) local_unnamed_addr {
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
  br i1 %.10, label %common.ret, label %entry.endif, !prof !13

common.ret:                                       ; preds = %entry.endif.endif.endif.thread, %arg0.err, %entry, %entry.endif.endif.endif.e...endif, %entry.endif.if
  %common.ret.op = phi ptr [ null, %arg0.err ], [ null, %entry ], [ null, %entry.endif.if ], [ null, %entry.endif.endif.endif.thread ], [ %.123, %entry.endif.endif.endif.e...endif ]
  ret ptr %common.ret.op

entry.endif:                                      ; preds = %entry
  %.14 = load ptr, ptr @_ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx, align 8
  %.19 = icmp eq ptr %.14, null
  br i1 %.19, label %entry.endif.if, label %entry.endif.endif, !prof !13

entry.endif.if:                                   ; preds = %entry.endif
  call void @PyErr_SetString(ptr nonnull @PyExc_RuntimeError, ptr nonnull @".const.missing Environment: _ZN08NumbaEnv8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx")
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
  br i1 %.35, label %entry.endif.endif.endif.thread, label %entry.endif.endif.endif.endif, !prof !13

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
  br i1 %.58, label %entry.endif.endif.endif.endif.endif.thread, label %entry.endif.endif.endif.endif.endif.endif, !prof !13

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
  br i1 %.74.not, label %entry.endif.endif.endif.endif.endif.endif.endif, label %arg1.err, !prof !14

arg1.err:                                         ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.endif, %entry.endif.endif.endif.endif.endif.endif
  call void @NRT_decref(ptr %.62.fca.0.load)
  br label %arg0.err

entry.endif.endif.endif.endif.endif.endif.endif:  ; preds = %entry.endif.endif.endif.endif.endif.endif
  %.78 = load ptr, ptr %.8, align 8
  %.81 = call ptr @PyNumber_Long(ptr %.78)
  %.82.not = icmp eq ptr %.81, null
  br i1 %.82.not, label %entry.endif.endif.endif.endif.endif.endif.endif.endif, label %entry.endif.endif.endif.endif.endif.endif.endif.if, !prof !13

entry.endif.endif.endif.endif.endif.endif.endif.if: ; preds = %entry.endif.endif.endif.endif.endif.endif.endif
  %.84 = call i64 @PyLong_AsLongLong(ptr nonnull %.81)
  call void @Py_DecRef(ptr nonnull %.81)
  br label %entry.endif.endif.endif.endif.endif.endif.endif.endif

entry.endif.endif.endif.endif.endif.endif.endif.endif: ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.if, %entry.endif.endif.endif.endif.endif.endif.endif
  %.79.0 = phi i64 [ %.84, %entry.endif.endif.endif.endif.endif.endif.endif.if ], [ 0, %entry.endif.endif.endif.endif.endif.endif.endif ]
  %.89 = call ptr @PyErr_Occurred()
  %.90.not = icmp eq ptr %.89, null
  br i1 %.90.not, label %entry.endif.endif.endif.e...endif, label %arg1.err, !prof !14

entry.endif.endif.endif.e...endif:                ; preds = %entry.endif.endif.endif.endif.endif.endif.endif.endif
  store double 0.000000e+00, ptr %.94, align 8
  %.102 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr nonnull %.94, ptr nonnull poison, ptr poison, ptr poison, i64 %.39.fca.2.load, i64 poison, ptr %.39.fca.4.load, i64 poison, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %.62.fca.4.load, i64 poison, i64 poison, double %.71, i64 %.79.0) #3
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
define double @cfunc._ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx({ ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, double %.3, i64 %.4) local_unnamed_addr #2 {
entry:
  %.6 = alloca double, align 8
  store double 0.000000e+00, ptr %.6, align 8
  %extracted.nitems = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, 2
  %extracted.data = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.1, 4
  %extracted.data.1 = extractvalue { ptr, ptr, i64, i64, ptr, [1 x i64], [1 x i64] } %.2, 4
  %.14 = call i32 @_ZN8__main__11make_kernel12_3clocals_3e6kernelB2v1B38c8tJTIeFIjxB2IKSgI4CrvQClQZ6FczSBAA_3dE5ArrayIdLi1E1C7mutable7alignedE5ArrayIdLi1E1C7mutable7alignedEdx(ptr nonnull %.6, ptr nonnull poison, ptr poison, ptr poison, i64 %extracted.nitems, i64 poison, ptr %extracted.data, i64 poison, i64 poison, ptr poison, ptr poison, i64 poison, i64 poison, ptr %extracted.data.1, i64 poison, i64 poison, double %.3, i64 %.4) #3
  %.24 = load double, ptr %.6, align 8
  ret double %.24
}

; Function Attrs: noinline
define linkonce_odr void @NRT_decref(ptr %.1) local_unnamed_addr #3 {
.3:
  %.4 = icmp eq ptr %.1, null
  br i1 %.4, label %common.ret1, label %.3.endif, !prof !13

common.ret1:                                      ; preds = %.3, %.3.endif
  ret void

.3.endif:                                         ; preds = %.3
  fence release
  %0 = tail call i8 @llvm.x86.atomic.sub.cc.i64(ptr nonnull %.1, i64 1, i32 4)
  %1 = trunc i8 %0 to i1
  br i1 %1, label %.3.endif.if, label %common.ret1, !prof !13

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
!8 = !{!"branch_weights", i32 4, i32 12}
!9 = distinct !{!9, !6, !7}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !6}
!13 = !{!"branch_weights", i32 1, i32 99}
!14 = !{!"branch_weights", i32 99, i32 1}
