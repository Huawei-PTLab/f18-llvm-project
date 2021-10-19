; This test case takes a ZAB tile and ZAS tile whose live range intersect with each other.
; And ensured during register allocation ZAB register is not split.

; RUN: llc -mattr=+sme,+sve -mtriple=aarch64-none-linux-gnu -O1 -stop-after=greedy < %s -o - 2>%t| FileCheck %s

source_filename = "gemm-10x10x10-int8.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

@.str = private unnamed_addr constant [13 x i8] c"expected:%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"result:%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @GEMM(i8* %matA, i8* %matB, i32* nocapture %matC, i32 %M, i32 %N, i32 %K) local_unnamed_addr #0 {
entry:

  ; CHECK-NOT: SMECOPY_B

  call void @llvm.aarch64.sme.start(i32 1)
  %0 = call i64 @llvm.aarch64.sve.cntw(i32 31)
  %conv = sext i32 %M to i64
  %cmp173.not = icmp eq i32 %M, 0
  br i1 %cmp173.not, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %conv4 = sext i32 %N to i64
  %cmp5169.not = icmp eq i32 %N, 0
  %conv11 = sext i32 %K to i64
  %cmp12158.not = icmp eq i32 %K, 0
  %cmp18143 = icmp eq i64 %0, 0
  %cmp31150 = icmp eq i64 %0, 0
  %cmp57163 = icmp eq i64 %0, 0
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.cond.cleanup7, %entry
  call void @llvm.aarch64.sme.stop(i32 1)
  ret i32 0

for.body:                                         ; preds = %for.body.lr.ph, %for.cond.cleanup7
  %i.0174 = phi i64 [ 0, %for.body.lr.ph ], [ %add82, %for.cond.cleanup7 ]
  %1 = call <vscale x 16 x i1> @llvm.aarch64.sve.whilelo.nxv16i1.i64(i64 %i.0174, i64 %conv)
  br i1 %cmp5169.not, label %for.cond.cleanup7, label %for.body8.lr.ph

for.body8.lr.ph:                                  ; preds = %for.body
  %cmp23145 = icmp eq i64 %i.0174, %conv
  %or.cond146 = or i1 %cmp18143, %cmp23145
  %cmp63165 = icmp eq i64 %i.0174, %conv
  %or.cond142166 = or i1 %cmp57163, %cmp63165
  br label %for.body8

for.cond.cleanup7:                                ; preds = %cleanup75, %for.body
  %add82 = add i64 %i.0174, %0
  %cmp = icmp ult i64 %add82, %conv
  br i1 %cmp, label %for.body, label %for.cond.cleanup, !llvm.loop !6

for.body8:                                        ; preds = %for.body8.lr.ph, %cleanup75
  %j.0170 = phi i64 [ 0, %for.body8.lr.ph ], [ %add78, %cleanup75 ]
  %2 = call <vscale x 16 x i1> @llvm.aarch64.sve.whilelo.nxv16i1.i64(i64 %j.0170, i64 %conv4)
  %3 = call <mscale x 16 x i32> @llvm.aarch64.sme.zero.mxv16i32()
  br i1 %cmp12158.not, label %for.cond56.preheader, label %for.body15.lr.ph

for.body15.lr.ph:                                 ; preds = %for.body8
  %add.ptr45 = getelementptr inbounds i8, i8* %matB, i64 %j.0170
  br label %for.body15

for.cond56.preheader:                             ; preds = %cleanup49, %for.body8
  %za.0.lcssa = phi <mscale x 16 x i32> [ %3, %for.body8 ], [ %za.1.lcssa, %cleanup49 ]
  br i1 %or.cond142166, label %cleanup75, label %if.end66.lr.ph

if.end66.lr.ph:                                   ; preds = %for.cond56.preheader
  %add.ptr71 = getelementptr inbounds i32, i32* %matC, i64 %j.0170
  %4 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %2)
  br label %if.end66

for.body15:                                       ; preds = %for.body15.lr.ph, %cleanup49
  %k.0160 = phi i64 [ 0, %for.body15.lr.ph ], [ %add52, %cleanup49 ]
  %za.0159 = phi <mscale x 16 x i32> [ %3, %for.body15.lr.ph ], [ %za.1.lcssa, %cleanup49 ]
  %5 = call <vscale x 16 x i1> @llvm.aarch64.sve.whilelo.nxv16i1.i64(i64 %k.0160, i64 %conv11)
  %6 = call <mscale x 256 x i8> @llvm.aarch64.sme.zero.mxv256i8()
  br i1 %or.cond146, label %for.cond30.preheader, label %if.end.lr.ph

if.end.lr.ph:                                     ; preds = %for.body15
  %add.ptr = getelementptr inbounds i8, i8* %matA, i64 %k.0160
  br label %if.end

for.cond30.preheader:                             ; preds = %if.end, %for.body15
  %zb.0.lcssa = phi <mscale x 256 x i8> [ %6, %for.body15 ], [ %7, %if.end ]
  %cmp37152 = icmp eq i64 %k.0160, %conv11
  %or.cond141153 = or i1 %cmp31150, %cmp37152
  br i1 %or.cond141153, label %cleanup49, label %if.end40

if.end:                                           ; preds = %if.end.lr.ph, %if.end
  %add149 = phi i64 [ %i.0174, %if.end.lr.ph ], [ %add, %if.end ]
  %t.0148 = phi i64 [ 0, %if.end.lr.ph ], [ %inc, %if.end ]
  %zb.0147 = phi <mscale x 256 x i8> [ %6, %if.end.lr.ph ], [ %7, %if.end ]
  %conv25 = trunc i64 %t.0148 to i32
  %mul = mul i64 %add149, %conv11
  %add.ptr28 = getelementptr inbounds i8, i8* %add.ptr, i64 %mul
  %7 = call <mscale x 256 x i8> @llvm.aarch64.sme.ld1.row.mxv256i8(<vscale x 16 x i1> %5, <mscale x 256 x i8> %zb.0147, i32 %conv25, i64 0, i8* %add.ptr28)
  %inc = add nuw i64 %t.0148, 1
  %cmp18 = icmp uge i64 %inc, %0
  %add = add i64 %inc, %i.0174
  %cmp23 = icmp eq i64 %add, %conv
  %or.cond = or i1 %cmp18, %cmp23
  br i1 %or.cond, label %for.cond30.preheader, label %if.end, !llvm.loop !9

if.end40:                                         ; preds = %for.cond30.preheader, %if.end40
  %add35156 = phi i64 [ %add35, %if.end40 ], [ %k.0160, %for.cond30.preheader ]
  %t29.0155 = phi i64 [ %inc48, %if.end40 ], [ 0, %for.cond30.preheader ]
  %za.1154 = phi <mscale x 16 x i32> [ %10, %if.end40 ], [ %za.0159, %for.cond30.preheader ]
  %conv41 = trunc i64 %t29.0155 to i32
  %8 = call <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.col.nxv16i8.mxv256i8(<vscale x 16 x i1> %1, <mscale x 256 x i8> %zb.0.lcssa, i32 %conv41, i64 0)
  %mul44 = mul i64 %add35156, %conv11
  %add.ptr46 = getelementptr inbounds i8, i8* %add.ptr45, i64 %mul44
  %9 = call <vscale x 16 x i8> @llvm.aarch64.sve.ld1.nxv16i8(<vscale x 16 x i1> %2, i8* %add.ptr46)
  %10 = call <mscale x 16 x i32> @llvm.aarch64.sme.smopa.mxv16i32.nxv16i8(<vscale x 16 x i1> %1, <vscale x 16 x i1> %2, <mscale x 16 x i32> %za.1154, <vscale x 16 x i8> %8, <vscale x 16 x i8> %9)
  %inc48 = add nuw i64 %t29.0155, 1
  %cmp31 = icmp uge i64 %inc48, %0
  %add35 = add i64 %inc48, %k.0160
  %cmp37 = icmp eq i64 %add35, %conv11
  %or.cond141 = or i1 %cmp31, %cmp37
  br i1 %or.cond141, label %cleanup49, label %if.end40, !llvm.loop !10

cleanup49:                                        ; preds = %if.end40, %for.cond30.preheader
  %za.1.lcssa = phi <mscale x 16 x i32> [ %za.0159, %for.cond30.preheader ], [ %10, %if.end40 ]
  %add52 = add i64 %k.0160, %0
  %cmp12 = icmp ult i64 %add52, %conv11
  br i1 %cmp12, label %for.body15, label %for.cond56.preheader, !llvm.loop !11

if.end66:                                         ; preds = %if.end66.lr.ph, %if.end66
  %add61168 = phi i64 [ %i.0174, %if.end66.lr.ph ], [ %add61, %if.end66 ]
  %t55.0167 = phi i64 [ 0, %if.end66.lr.ph ], [ %inc74, %if.end66 ]
  %conv67 = trunc i64 %t55.0167 to i32
  %mul70 = mul i64 %add61168, %conv
  %add.ptr72 = getelementptr inbounds i32, i32* %add.ptr71, i64 %mul70
  call void @llvm.aarch64.sme.st1.row.mxv16i32(<vscale x 4 x i1> %4, <mscale x 16 x i32> %za.0.lcssa, i32 %conv67, i64 0, i32* %add.ptr72)
  %inc74 = add nuw i64 %t55.0167, 1
  %cmp57 = icmp uge i64 %inc74, %0
  %add61 = add i64 %inc74, %i.0174
  %cmp63 = icmp eq i64 %add61, %conv
  %or.cond142 = or i1 %cmp57, %cmp63
  br i1 %or.cond142, label %cleanup75, label %if.end66, !llvm.loop !12

cleanup75:                                        ; preds = %if.end66, %for.cond56.preheader
  %add78 = add i64 %j.0170, %0
  %cmp5 = icmp ult i64 %add78, %conv4
  br i1 %cmp5, label %for.body8, label %for.cond.cleanup7, !llvm.loop !13
}

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.aarch64.sme.start(i32) #1

; Function Attrs: nofree nosync nounwind readnone willreturn
declare i64 @llvm.aarch64.sve.cntw(i32 immarg) #2

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 16 x i1> @llvm.aarch64.sve.whilelo.nxv16i1.i64(i64, i64) #2

; Function Attrs: nofree nosync nounwind willreturn
declare <mscale x 16 x i32> @llvm.aarch64.sme.zero.mxv16i32() #1

; Function Attrs: nofree nosync nounwind willreturn
declare <mscale x 256 x i8> @llvm.aarch64.sme.zero.mxv256i8() #1

; Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
declare <mscale x 256 x i8> @llvm.aarch64.sme.ld1.row.mxv256i8(<vscale x 16 x i1>, <mscale x 256 x i8>, i32, i64, i8*) #3

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.col.nxv16i8.mxv256i8(<vscale x 16 x i1>, <mscale x 256 x i8>, i32, i64) #2

; Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
declare <vscale x 16 x i8> @llvm.aarch64.sve.ld1.nxv16i8(<vscale x 16 x i1>, i8*) #3

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <mscale x 16 x i32> @llvm.aarch64.sme.smopa.mxv16i32.nxv16i8(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>) #2

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1>) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.aarch64.sme.st1.row.mxv16i32(<vscale x 4 x i1>, <mscale x 16 x i32>, i32, i64, i32* nocapture) #4

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.aarch64.sme.stop(i32) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #5 {
entry:
  ; CHECK-NOT: SMECOPY_B

  %vla179 = alloca [100 x i8], align 1
  %vla1180 = alloca [100 x i8], align 1
  %vla2181 = alloca [100 x i32], align 4
  %vla2181204 = bitcast [100 x i32]* %vla2181 to i8*
  %vla1180.sub = getelementptr inbounds [100 x i8], [100 x i8]* %vla1180, i64 0, i64 0
  %call = call i64 @time(i64* null) #8
  %conv = trunc i64 %call to i32
  call void @srand(i32 %conv) #8
  br label %for.cond5.preheader

for.cond5.preheader:                              ; preds = %entry, %for.cond.cleanup8
  %indvars.iv214 = phi i64 [ 0, %entry ], [ %indvars.iv.next215, %for.cond.cleanup8 ]
  %0 = mul nuw nsw i64 %indvars.iv214, 10
  %arrayidx = getelementptr inbounds [100 x i8], [100 x i8]* %vla179, i64 0, i64 %0
  br label %for.body9

for.cond.cleanup8:                                ; preds = %for.body9
  %indvars.iv.next215 = add nuw nsw i64 %indvars.iv214, 1
  %exitcond216.not = icmp eq i64 %indvars.iv.next215, 10
  br i1 %exitcond216.not, label %for.cond24.preheader.preheader, label %for.cond5.preheader, !llvm.loop !14

for.cond24.preheader.preheader:                   ; preds = %for.cond.cleanup8
  %vla2181.sub = getelementptr inbounds [100 x i32], [100 x i32]* %vla2181, i64 0, i64 0
  %vla179.sub = getelementptr inbounds [100 x i8], [100 x i8]* %vla179, i64 0, i64 0
  br label %for.cond24.preheader

for.body9:                                        ; preds = %for.cond5.preheader, %for.body9
  %indvars.iv211 = phi i64 [ 0, %for.cond5.preheader ], [ %indvars.iv.next212, %for.body9 ]
  %call10 = call i32 @rand() #8
  %rem = srem i32 %call10, 5
  %1 = trunc i32 %rem to i8
  %conv11 = add i8 %1, 1
  %arrayidx13 = getelementptr inbounds i8, i8* %arrayidx, i64 %indvars.iv211
  store i8 %conv11, i8* %arrayidx13, align 1, !tbaa !15
  %indvars.iv.next212 = add nuw nsw i64 %indvars.iv211, 1
  %exitcond213.not = icmp eq i64 %indvars.iv.next212, 10
  br i1 %exitcond213.not, label %for.cond.cleanup8, label %for.body9, !llvm.loop !18

for.cond24.preheader:                             ; preds = %for.cond24.preheader.preheader, %for.cond.cleanup27
  %indvars.iv208 = phi i64 [ 0, %for.cond24.preheader.preheader ], [ %indvars.iv.next209, %for.cond.cleanup27 ]
  %2 = mul nuw nsw i64 %indvars.iv208, 10
  %arrayidx34 = getelementptr inbounds [100 x i8], [100 x i8]* %vla1180, i64 0, i64 %2
  br label %for.body28

for.cond.cleanup27:                               ; preds = %for.body28
  %indvars.iv.next209 = add nuw nsw i64 %indvars.iv208, 1
  %exitcond210.not = icmp eq i64 %indvars.iv.next209, 10
  br i1 %exitcond210.not, label %for.cond50.preheader.preheader, label %for.cond24.preheader, !llvm.loop !19

for.cond50.preheader.preheader:                   ; preds = %for.cond.cleanup27
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(400) %vla2181204, i8 0, i64 400, i1 false)
  %call69 = call i32 @GEMM(i8* nonnull %vla179.sub, i8* nonnull %vla1180.sub, i32* nonnull %vla2181.sub, i32 10, i32 10, i32 10)
  br label %for.cond77.preheader

for.body28:                                       ; preds = %for.cond24.preheader, %for.body28
  %indvars.iv205 = phi i64 [ 0, %for.cond24.preheader ], [ %indvars.iv.next206, %for.body28 ]
  %call29 = call i32 @rand() #8
  %rem30 = srem i32 %call29, 5
  %3 = trunc i32 %rem30 to i8
  %conv32 = add i8 %3, 1
  %arrayidx36 = getelementptr inbounds i8, i8* %arrayidx34, i64 %indvars.iv205
  store i8 %conv32, i8* %arrayidx36, align 1, !tbaa !15
  %indvars.iv.next206 = add nuw nsw i64 %indvars.iv205, 1
  %exitcond207.not = icmp eq i64 %indvars.iv.next206, 10
  br i1 %exitcond207.not, label %for.cond.cleanup27, label %for.body28, !llvm.loop !20

for.cond77.preheader:                             ; preds = %for.cond50.preheader.preheader, %for.cond.cleanup80
  %indvars.iv198 = phi i64 [ 0, %for.cond50.preheader.preheader ], [ %indvars.iv.next199, %for.cond.cleanup80 ]
  %4 = mul nuw nsw i64 %indvars.iv198, 10
  %arrayidx88 = getelementptr inbounds [100 x i8], [100 x i8]* %vla179, i64 0, i64 %4
  %5 = mul nuw nsw i64 %indvars.iv198, 10
  %arrayidx103 = getelementptr inbounds [100 x i32], [100 x i32]* %vla2181, i64 0, i64 %5
  br label %for.cond82.preheader

for.cond.cleanup74:                               ; preds = %for.cond.cleanup80
  %cmp111.le.le = icmp eq i32 %add97, %6
  %conv119 = zext i1 %cmp111.le.le to i32
  %call120 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i32 %conv119)
  ret i32 0

for.cond82.preheader:                             ; preds = %for.cond77.preheader, %for.cond.cleanup85
  %indvars.iv195 = phi i64 [ 0, %for.cond77.preheader ], [ %indvars.iv.next196, %for.cond.cleanup85 ]
  br label %for.body86

for.cond.cleanup80:                               ; preds = %for.cond.cleanup85
  %indvars.iv.next199 = add nuw nsw i64 %indvars.iv198, 1
  %exitcond200.not = icmp eq i64 %indvars.iv.next199, 10
  br i1 %exitcond200.not, label %for.cond.cleanup74, label %for.cond77.preheader, !llvm.loop !21

for.cond.cleanup85:                               ; preds = %for.body86
  %call101 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i32 %add97)
  %arrayidx105 = getelementptr inbounds i32, i32* %arrayidx103, i64 %indvars.iv195
  %6 = load i32, i32* %arrayidx105, align 4, !tbaa !22
  %call106 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 %6)
  %indvars.iv.next196 = add nuw nsw i64 %indvars.iv195, 1
  %exitcond197.not = icmp eq i64 %indvars.iv.next196, 10
  br i1 %exitcond197.not, label %for.cond.cleanup80, label %for.cond82.preheader, !llvm.loop !24

for.body86:                                       ; preds = %for.cond82.preheader, %for.body86
  %indvars.iv = phi i64 [ 0, %for.cond82.preheader ], [ %indvars.iv.next, %for.body86 ]
  %sum.0185 = phi i32 [ 0, %for.cond82.preheader ], [ %add97, %for.body86 ]
  %arrayidx90 = getelementptr inbounds i8, i8* %arrayidx88, i64 %indvars.iv
  %7 = load i8, i8* %arrayidx90, align 1, !tbaa !15
  %conv91 = sext i8 %7 to i32
  %8 = mul nuw nsw i64 %indvars.iv, 10
  %arrayidx93 = getelementptr inbounds [100 x i8], [100 x i8]* %vla1180, i64 0, i64 %8
  %arrayidx95 = getelementptr inbounds i8, i8* %arrayidx93, i64 %indvars.iv195
  %9 = load i8, i8* %arrayidx95, align 1, !tbaa !15
  %conv96 = sext i8 %9 to i32
  %mul = mul nsw i32 %conv96, %conv91
  %add97 = add i32 %mul, %sum.0185
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 10
  br i1 %exitcond.not, label %for.cond.cleanup85, label %for.body86, !llvm.loop !25
}

; Function Attrs: nounwind
declare dso_local void @srand(i32) local_unnamed_addr #6

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) local_unnamed_addr #6

; Function Attrs: nounwind
declare dso_local i32 @rand() local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare dso_local noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #7

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #4

attributes #0 = { nofree nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon,+sme" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind willreturn }
attributes #2 = { nofree nosync nounwind readnone willreturn }
attributes #3 = { argmemonly nofree nosync nounwind readonly willreturn }
attributes #4 = { argmemonly nofree nosync nounwind willreturn writeonly }
attributes #5 = { nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon,+sme" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon,+sme" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nofree nounwind "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon,+sme" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"branch-target-enforcement", i32 0}
!2 = !{i32 1, !"sign-return-address", i32 0}
!3 = !{i32 1, !"sign-return-address-all", i32 0}
!4 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!5 = !{!"Huawei Bisheng Compiler clang version 12.0.0 (clang-8e7ad6b63e6b flang-8e7ad6b63e6b)"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = distinct !{!9, !7, !8}
!10 = distinct !{!10, !7, !8}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = !{!16, !16, i64 0}
!16 = !{!"omnipotent char", !17, i64 0}
!17 = !{!"Simple C/C++ TBAA"}
!18 = distinct !{!18, !7, !8}
!19 = distinct !{!19, !7, !8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = !{!23, !23, i64 0}
!23 = !{!"int", !16, i64 0}
!24 = distinct !{!24, !7, !8}
!25 = distinct !{!25, !7, !8}
