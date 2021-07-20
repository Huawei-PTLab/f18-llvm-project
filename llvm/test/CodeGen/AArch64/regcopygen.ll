; RUN: llc -mtriple=aarch64-none-linux-gnu -O1 -regalloc=greedy -regalloc-csr-first-time-cost=15 -mattr=+sme,+sve < %s | FileCheck %s

; CHECK-LABEL: matrixDotOmp:
; CHECK: entry
; CHECK: cntw {{x[0-9]+}}
; CHECK: {{.LBB[0-9]+_[0-9]+}}:
; CHECK: mov {{z[0-9]+}}.s, {{p[0-9]+}}/m, {{za[0-9]+}}h.s[{{w[0-9]+}}, 0]
; CHECK: mov {{za[0-9]+h}}.s[{{w[0-9]+}}, 0], {{p[0-9]+}}/m, {{z[0-9]+}}.s
; CHECK: sub {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK: {{x[0-9]+}}, {{.LBB[0-9]+_[0-9]+}}

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-none-linux-gnu"

@M = dso_local local_unnamed_addr global i32 0, align 4
@N = dso_local local_unnamed_addr global i32 0, align 4
@K = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @matrixDotOmp(float* %matA, float* %matB, float* nocapture %matC) local_unnamed_addr #0 {
entry:
  call void @llvm.aarch64.sme.start(i32 1)
  %0 = call i64 @llvm.aarch64.sve.cntd(i32 31)
  %1 = load i32, i32* @M, align 4, !tbaa !6
  %cmp229.not = icmp eq i32 %1, 0
  br i1 %cmp229.not, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %conv228 = zext i32 %1 to i64
  %cmp18185.not = icmp eq i64 %0, 0
  %cmp51192.not = icmp eq i64 %0, 0
  %cmp69214.not = icmp eq i64 %0, 0
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.cond.cleanup7, %entry
  call void @llvm.aarch64.sme.stop(i32 1)
  ret i32 0

for.body:                                         ; preds = %for.body.lr.ph, %for.cond.cleanup7
  %conv235 = phi i64 [ %conv228, %for.body.lr.ph ], [ %conv, %for.cond.cleanup7 ]
  %i.0233 = phi i64 [ 0, %for.body.lr.ph ], [ %add110, %for.cond.cleanup7 ]
  %zc.0232 = phi <mscale x 16 x float> [ undef, %for.body.lr.ph ], [ %zc.1.lcssa, %for.cond.cleanup7 ]
  %zd.0231 = phi <mscale x 16 x float> [ undef, %for.body.lr.ph ], [ %zd.1.lcssa, %for.cond.cleanup7 ]
  %ze.0230 = phi <mscale x 16 x float> [ undef, %for.body.lr.ph ], [ %ze.1.lcssa, %for.cond.cleanup7 ]
  %2 = call <vscale x 2 x i1> @llvm.aarch64.sve.whilelo.nxv2i1.i64(i64 %i.0233, i64 %conv235)
  %3 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %2)
  %4 = load i32, i32* @N, align 4, !tbaa !6
  %cmp5217.not = icmp eq i32 %4, 0
  br i1 %cmp5217.not, label %for.cond.cleanup7, label %for.body8.preheader

for.body8.preheader:                              ; preds = %for.body
  %conv4216 = zext i32 %4 to i64
  br label %for.body8

for.cond.cleanup7:                                ; preds = %for.cond.cleanup71, %for.body
  %ze.1.lcssa = phi <mscale x 16 x float> [ %ze.0230, %for.body ], [ %ze.2.lcssa, %for.cond.cleanup71 ]
  %zd.1.lcssa = phi <mscale x 16 x float> [ %zd.0231, %for.body ], [ %zd.2.lcssa, %for.cond.cleanup71 ]
  %zc.1.lcssa = phi <mscale x 16 x float> [ %zc.0232, %for.body ], [ %zc.2.lcssa, %for.cond.cleanup71 ]
  %add110 = add i64 %i.0233, %0
  %5 = load i32, i32* @M, align 4, !tbaa !6
  %conv = zext i32 %5 to i64
  %cmp = icmp ult i64 %add110, %conv
  br i1 %cmp, label %for.body, label %for.cond.cleanup, !llvm.loop !10

for.body8:                                        ; preds = %for.body8.preheader, %for.cond.cleanup71
  %conv4224 = phi i64 [ %conv4, %for.cond.cleanup71 ], [ %conv4216, %for.body8.preheader ]
  %j.0221 = phi i64 [ %add107, %for.cond.cleanup71 ], [ 0, %for.body8.preheader ]
  %zc.1220 = phi <mscale x 16 x float> [ %zc.2.lcssa, %for.cond.cleanup71 ], [ %zc.0232, %for.body8.preheader ]
  %zd.1219 = phi <mscale x 16 x float> [ %zd.2.lcssa, %for.cond.cleanup71 ], [ %zd.0231, %for.body8.preheader ]
  %ze.1218 = phi <mscale x 16 x float> [ %ze.2.lcssa, %for.cond.cleanup71 ], [ %ze.0230, %for.body8.preheader ]
  %6 = call <vscale x 2 x i1> @llvm.aarch64.sve.whilelo.nxv2i1.i64(i64 %j.0221, i64 %conv4224)
  %7 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %6)
  %8 = call contract <mscale x 16 x float> @llvm.aarch64.sme.zero.mxv16f32()
  %9 = call contract <mscale x 16 x float> @llvm.aarch64.sme.zero.mxv16f32()
  %10 = load i32, i32* @K, align 4, !tbaa !6
  %cmp12199.not = icmp eq i32 %10, 0
  br i1 %cmp12199.not, label %for.cond68.preheader, label %for.body15.lr.ph

for.body15.lr.ph:                                 ; preds = %for.body8
  %conv11198 = zext i32 %10 to i64
  %add.ptr59 = getelementptr inbounds float, float* %matB, i64 %j.0221
  %11 = load i32, i32* @K, align 4, !tbaa !6
  %conv11 = zext i32 %11 to i64
  br label %for.body15

for.cond68.preheader:                             ; preds = %for.cond.cleanup53, %for.body8
  %ze.2.lcssa = phi <mscale x 16 x float> [ %ze.1218, %for.body8 ], [ %ze.3.lcssa, %for.cond.cleanup53 ]
  %zd.2.lcssa = phi <mscale x 16 x float> [ %zd.1219, %for.body8 ], [ %zd.4.lcssa, %for.cond.cleanup53 ]
  %zc.2.lcssa = phi <mscale x 16 x float> [ %zc.1220, %for.body8 ], [ %zc.3.lcssa, %for.cond.cleanup53 ]
  %zb.0.lcssa = phi <mscale x 16 x float> [ %9, %for.body8 ], [ %zb.1.lcssa, %for.cond.cleanup53 ]
  %za.0.lcssa = phi <mscale x 16 x float> [ %8, %for.body8 ], [ %za.2.lcssa, %for.cond.cleanup53 ]
  br i1 %cmp69214.not, label %for.cond.cleanup71, label %for.body72.lr.ph

for.body72.lr.ph:                                 ; preds = %for.cond68.preheader
  %add.ptr77 = getelementptr inbounds float, float* %matC, i64 %j.0221
  %12 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %7)
  br label %for.body72

for.body15:                                       ; preds = %for.body15.lr.ph, %for.cond.cleanup53
  %conv11208 = phi i64 [ %conv11198, %for.body15.lr.ph ], [ %conv11, %for.cond.cleanup53 ]
  %k.0205 = phi i64 [ 0, %for.body15.lr.ph ], [ %add65, %for.cond.cleanup53 ]
  %za.0204 = phi <mscale x 16 x float> [ %8, %for.body15.lr.ph ], [ %za.2.lcssa, %for.cond.cleanup53 ]
  %zb.0203 = phi <mscale x 16 x float> [ %9, %for.body15.lr.ph ], [ %zb.1.lcssa, %for.cond.cleanup53 ]
  %zc.2202 = phi <mscale x 16 x float> [ %zc.1220, %for.body15.lr.ph ], [ %zc.3.lcssa, %for.cond.cleanup53 ]
  %zd.2201 = phi <mscale x 16 x float> [ %zd.1219, %for.body15.lr.ph ], [ %zd.4.lcssa, %for.cond.cleanup53 ]
  %ze.2200 = phi <mscale x 16 x float> [ %ze.1218, %for.body15.lr.ph ], [ %ze.3.lcssa, %for.cond.cleanup53 ]
  br i1 %cmp18185.not, label %for.cond50.preheader, label %for.body21.lr.ph

for.body21.lr.ph:                                 ; preds = %for.body15
  %13 = call <vscale x 2 x i1> @llvm.aarch64.sve.whilelo.nxv2i1.i64(i64 %k.0205, i64 %conv11208)
  %14 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %13)
  %add.ptr = getelementptr inbounds float, float* %matA, i64 %k.0205
  %15 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %14)
  br label %for.body21

for.cond17.for.cond50.preheader_crit_edge:        ; preds = %for.body21
  %16 = trunc i64 %0 to i32
  %conv22.le = add i32 %16, -1
  %17 = call contract <mscale x 16 x float> @llvm.aarch64.sme.ld1.row.mxv16f32(<vscale x 4 x i1> %15, <mscale x 16 x float> %21, i32 %conv22.le, i64 0, float* %add.ptr24)
  br label %for.cond50.preheader

for.cond50.preheader:                             ; preds = %for.cond17.for.cond50.preheader_crit_edge, %for.body15
  %ze.3.lcssa = phi <mscale x 16 x float> [ %17, %for.cond17.for.cond50.preheader_crit_edge ], [ %ze.2200, %for.body15 ]
  %zd.3.lcssa = phi <mscale x 16 x float> [ %21, %for.cond17.for.cond50.preheader_crit_edge ], [ %zd.2201, %for.body15 ]
  %zc.3.lcssa = phi <mscale x 16 x float> [ %20, %for.cond17.for.cond50.preheader_crit_edge ], [ %zc.2202, %for.body15 ]
  %zb.1.lcssa = phi <mscale x 16 x float> [ %21, %for.cond17.for.cond50.preheader_crit_edge ], [ %zb.0203, %for.body15 ]
  %za.1.lcssa = phi <mscale x 16 x float> [ %20, %for.cond17.for.cond50.preheader_crit_edge ], [ %za.0204, %for.body15 ]
  br i1 %cmp51192.not, label %for.cond.cleanup53, label %for.body54.lr.ph

for.body54.lr.ph:                                 ; preds = %for.cond50.preheader
  %18 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %3)
  %19 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %7)
  br label %for.body54

for.body21:                                       ; preds = %for.body21.lr.ph, %for.body21
  %t.0187 = phi i64 [ 0, %for.body21.lr.ph ], [ %inc, %for.body21 ]
  %zb.1186 = phi <mscale x 16 x float> [ %zb.0203, %for.body21.lr.ph ], [ %21, %for.body21 ]
  %conv22 = trunc i64 %t.0187 to i32
  %add = add i64 %t.0187, %i.0233
  %mul = mul i64 %add, %conv11208
  %add.ptr24 = getelementptr inbounds float, float* %add.ptr, i64 %mul
  %20 = call contract <mscale x 16 x float> @llvm.aarch64.sme.ld1.row.mxv16f32(<vscale x 4 x i1> %15, <mscale x 16 x float> %zb.1186, i32 %conv22, i64 0, float* %add.ptr24)
  %21 = call contract <mscale x 16 x float> @llvm.aarch64.sme.ld1.row.mxv16f32(<vscale x 4 x i1> %15, <mscale x 16 x float> %20, i32 %conv22, i64 0, float* %add.ptr24)
  %inc = add nuw i64 %t.0187, 1
  %exitcond.not = icmp eq i64 %inc, %0
  br i1 %exitcond.not, label %for.cond17.for.cond50.preheader_crit_edge, label %for.body21, !llvm.loop !13

for.cond.cleanup53:                               ; preds = %for.body54, %for.cond50.preheader
  %zd.4.lcssa = phi <mscale x 16 x float> [ %zd.3.lcssa, %for.cond50.preheader ], [ %25, %for.body54 ]
  %za.2.lcssa = phi <mscale x 16 x float> [ %za.1.lcssa, %for.cond50.preheader ], [ %24, %for.body54 ]
  %add65 = add i64 %k.0205, %0
  %cmp12 = icmp ult i64 %add65, %conv11
  br i1 %cmp12, label %for.body15, label %for.cond68.preheader, !llvm.loop !14

for.body54:                                       ; preds = %for.body54.lr.ph, %for.body54
  %t49.0195 = phi i64 [ 0, %for.body54.lr.ph ], [ %inc62, %for.body54 ]
  %za.2194 = phi <mscale x 16 x float> [ %za.1.lcssa, %for.body54.lr.ph ], [ %24, %for.body54 ]
  %zd.4193 = phi <mscale x 16 x float> [ %zd.3.lcssa, %for.body54.lr.ph ], [ %25, %for.body54 ]
  %conv55 = trunc i64 %t49.0195 to i32
  %22 = call contract <vscale x 4 x float> @llvm.aarch64.sme.mova.vec.col.nxv4f32.mxv16f32(<vscale x 4 x i1> %18, <mscale x 16 x float> %zb.1.lcssa, i32 %conv55, i64 0)
  %add56 = add i64 %t49.0195, %k.0205
  %mul58 = mul i64 %add56, %conv11208
  %add.ptr60 = getelementptr inbounds float, float* %add.ptr59, i64 %mul58
  %23 = call contract <vscale x 4 x float> @llvm.aarch64.sve.ld1.nxv4f32(<vscale x 4 x i1> %19, float* %add.ptr60)
  %24 = call contract <mscale x 16 x float> @llvm.aarch64.sme.fmopa.mxv16f32.nxv4f32(<vscale x 4 x i1> %18, <vscale x 4 x i1> %19, <mscale x 16 x float> %za.2194, <vscale x 4 x float> %22, <vscale x 4 x float> %23)
  %25 = call contract <mscale x 16 x float> @llvm.aarch64.sme.fmopa.mxv16f32.nxv4f32(<vscale x 4 x i1> %18, <vscale x 4 x i1> %19, <mscale x 16 x float> %zd.4193, <vscale x 4 x float> %22, <vscale x 4 x float> %23)
  %inc62 = add nuw i64 %t49.0195, 1
  %exitcond244.not = icmp eq i64 %inc62, %0
  br i1 %exitcond244.not, label %for.cond.cleanup53, label %for.body54, !llvm.loop !15

for.cond.cleanup71:                               ; preds = %for.body72, %for.cond68.preheader
  %add107 = add i64 %j.0221, %0
  %26 = load i32, i32* @N, align 4, !tbaa !6
  %conv4 = zext i32 %26 to i64
  %cmp5 = icmp ult i64 %add107, %conv4
  br i1 %cmp5, label %for.body8, label %for.cond.cleanup7, !llvm.loop !16

for.body72:                                       ; preds = %for.body72.lr.ph, %for.body72
  %t67.0215 = phi i64 [ 0, %for.body72.lr.ph ], [ %inc104, %for.body72 ]
  %conv73 = trunc i64 %t67.0215 to i32
  %27 = load i32, i32* @M, align 4, !tbaa !6
  %conv74 = zext i32 %27 to i64
  %add75 = add i64 %t67.0215, %i.0233
  %mul76 = mul i64 %add75, %conv74
  %add.ptr78 = getelementptr inbounds float, float* %add.ptr77, i64 %mul76
  call void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1> %12, <mscale x 16 x float> %za.0.lcssa, i32 %conv73, i64 0, float* %add.ptr78)
  %28 = load i32, i32* @M, align 4, !tbaa !6
  %conv80 = zext i32 %28 to i64
  %mul82 = mul i64 %add75, %conv80
  %add.ptr84 = getelementptr inbounds float, float* %add.ptr77, i64 %mul82
  call void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1> %12, <mscale x 16 x float> %ze.2.lcssa, i32 %conv73, i64 0, float* %add.ptr84)
  %29 = load i32, i32* @M, align 4, !tbaa !6
  %conv86 = zext i32 %29 to i64
  %mul88 = mul i64 %add75, %conv86
  %add.ptr90 = getelementptr inbounds float, float* %add.ptr77, i64 %mul88
  call void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1> %12, <mscale x 16 x float> %zc.2.lcssa, i32 %conv73, i64 0, float* %add.ptr90)
  %30 = load i32, i32* @M, align 4, !tbaa !6
  %conv92 = zext i32 %30 to i64
  %mul94 = mul i64 %add75, %conv92
  %add.ptr96 = getelementptr inbounds float, float* %add.ptr77, i64 %mul94
  call void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1> %12, <mscale x 16 x float> %zb.0.lcssa, i32 %conv73, i64 0, float* %add.ptr96)
  %31 = load i32, i32* @M, align 4, !tbaa !6
  %conv98 = zext i32 %31 to i64
  %mul100 = mul i64 %add75, %conv98
  %add.ptr102 = getelementptr inbounds float, float* %add.ptr77, i64 %mul100
  call void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1> %12, <mscale x 16 x float> %zd.2.lcssa, i32 %conv73, i64 0, float* %add.ptr102)
  %inc104 = add nuw i64 %t67.0215, 1
  %exitcond245.not = icmp eq i64 %inc104, %0
  br i1 %exitcond245.not, label %for.cond.cleanup71, label %for.body72, !llvm.loop !17
}

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.aarch64.sme.start(i32) #1

; Function Attrs: nofree nosync nounwind readnone willreturn
declare i64 @llvm.aarch64.sve.cntd(i32 immarg) #2

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 2 x i1> @llvm.aarch64.sve.whilelo.nxv2i1.i64(i64, i64) #2

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1>) #2

; Function Attrs: nofree nosync nounwind willreturn
declare <mscale x 16 x float> @llvm.aarch64.sme.zero.mxv16f32() #1

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1>) #2

; Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
declare <mscale x 16 x float> @llvm.aarch64.sme.ld1.row.mxv16f32(<vscale x 4 x i1>, <mscale x 16 x float>, i32, i64, float*) #3

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 4 x float> @llvm.aarch64.sme.mova.vec.col.nxv4f32.mxv16f32(<vscale x 4 x i1>, <mscale x 16 x float>, i32, i64) #2

; Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
declare <vscale x 4 x float> @llvm.aarch64.sve.ld1.nxv4f32(<vscale x 4 x i1>, float*) #3

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <mscale x 16 x float> @llvm.aarch64.sme.fmopa.mxv16f32.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x i1>, <mscale x 16 x float>, <vscale x 4 x float>, <vscale x 4 x float>) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1>, <mscale x 16 x float>, i32, i64, float* nocapture) #4

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.aarch64.sme.stop(i32) #1

attributes #0 = { nofree nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon,+sme" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind willreturn }
attributes #2 = { nofree nosync nounwind readnone willreturn }
attributes #3 = { argmemonly nofree nosync nounwind readonly willreturn }
attributes #4 = { argmemonly nofree nosync nounwind willreturn writeonly }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"branch-target-enforcement", i32 0}
!2 = !{i32 1, !"sign-return-address", i32 0}
!3 = !{i32 1, !"sign-return-address-all", i32 0}
!4 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!5 = !{!"clang version 12.0.0 (clang-e86d9d90b6f3 flang-e86d9d90b6f3)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = distinct !{!13, !11, !12}
!14 = distinct !{!14, !11, !12}
!15 = distinct !{!15, !11, !12}
!16 = distinct !{!16, !11, !12}
!17 = distinct !{!17, !11, !12}
