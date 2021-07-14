; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme-f64,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; Function Attrs: nofree nounwind
define dso_local i32 @GEMM(double* %matA, double* %matB, double* nocapture %matC, i32 %M, i32 %N, i32 %K) local_unnamed_addr #0 {
entry:
  ;CHECK-LABEL: GEMM:
  ;CHECK: smstart za
  ;CHECK-DAG: cntd    x{{[0-9]+}}
  call void @llvm.aarch64.sme.start(i32 1)
  %0 = call i64 @llvm.aarch64.sve.cntd(i32 31)
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
  ;CHECK-DAG: smstop
  call void @llvm.aarch64.sme.stop(i32 1)
  ret i32 0

for.body:                                         ; preds = %for.body.lr.ph, %for.cond.cleanup7
  ; CHECK_DAG: whilelo p{{[0-9]+}}.d, x{{[0-9]+}}, x{{[0-9]+}}
  %i.0174 = phi i64 [ 0, %for.body.lr.ph ], [ %add82, %for.cond.cleanup7 ]
  %1 = call <vscale x 2 x i1> @llvm.aarch64.sve.whilelo.nxv2i1.i64(i64 %i.0174, i64 %conv)
  %2 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %1)
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
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.body8:                                        ; preds = %for.body8.lr.ph, %cleanup75
  ; CHECK-DAG: whilelo p{{[0-9]+}}.d, x{{[0-9]+}}, x{{[0-9]+}}
  ; CHECK-DAG: zero    {za{{[0-9]+}}.d}
  %j.0170 = phi i64 [ 0, %for.body8.lr.ph ], [ %add78, %cleanup75 ]
  %3 = call <vscale x 2 x i1> @llvm.aarch64.sve.whilelo.nxv2i1.i64(i64 %j.0170, i64 %conv4)
  %4 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %3)
  %5 = call <mscale x 4 x double> @llvm.aarch64.sme.zero.mxv4f64()
  br i1 %cmp12158.not, label %for.cond56.preheader, label %for.body15.lr.ph

for.body15.lr.ph:                                 ; preds = %for.body8
  %add.ptr45 = getelementptr inbounds double, double* %matB, i64 %j.0170
  br label %for.body15

for.cond56.preheader:                             ; preds = %cleanup49, %for.body8
  %za.0.lcssa = phi <mscale x 4 x double> [ %5, %for.body8 ], [ %za.1.lcssa, %cleanup49 ]
  br i1 %or.cond142166, label %cleanup75, label %if.end66.lr.ph

if.end66.lr.ph:                                   ; preds = %for.cond56.preheader
  %add.ptr71 = getelementptr inbounds double, double* %matC, i64 %j.0170
  %6 = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %4)
  br label %if.end66

for.body15:                                       ; preds = %for.body15.lr.ph, %cleanup49
  ;CHECK-DAG: zero    {za{{[0-9]+}}.d}
  %k.0160 = phi i64 [ 0, %for.body15.lr.ph ], [ %add52, %cleanup49 ]
  %za.0159 = phi <mscale x 4 x double> [ %5, %for.body15.lr.ph ], [ %za.1.lcssa, %cleanup49 ]
  %7 = call <mscale x 4 x double> @llvm.aarch64.sme.zero.mxv4f64()
  br i1 %or.cond146, label %for.cond30.preheader, label %if.end.lr.ph

if.end.lr.ph:                                     ; preds = %for.body15
  ; CHECK-DAG: whilelo p{{[0-9]+}}.d, x{{[0-9]+}}, x{{[0-9]+}}
  %8 = call <vscale x 2 x i1> @llvm.aarch64.sve.whilelo.nxv2i1.i64(i64 %k.0160, i64 %conv11)
  %9 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %8)
  %add.ptr = getelementptr inbounds double, double* %matA, i64 %k.0160
  %10 = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %9)
  br label %if.end

for.cond30.preheader:                             ; preds = %if.end, %for.body15
  %zb.0.lcssa = phi <mscale x 4 x double> [ %7, %for.body15 ], [ %13, %if.end ]
  %cmp37152 = icmp eq i64 %k.0160, %conv11
  %or.cond141153 = or i1 %cmp31150, %cmp37152
  br i1 %or.cond141153, label %cleanup49, label %if.end40.lr.ph

if.end40.lr.ph:                                   ; preds = %for.cond30.preheader
  %11 = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %2)
  %12 = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %4)
  br label %if.end40

if.end:                                           ; preds = %if.end.lr.ph, %if.end
  ; CHECK-DAG: ld1d    {za1h.d[w{{[0-9]+}}, 0]}, p{{[0-9]+}}/z, [x{{[0-9]+}}]
  %add149 = phi i64 [ %i.0174, %if.end.lr.ph ], [ %add, %if.end ]
  %t.0148 = phi i64 [ 0, %if.end.lr.ph ], [ %inc, %if.end ]
  %zb.0147 = phi <mscale x 4 x double> [ %7, %if.end.lr.ph ], [ %13, %if.end ]
  %conv25 = trunc i64 %t.0148 to i32
  %mul = mul i64 %add149, %conv11
  %add.ptr28 = getelementptr inbounds double, double* %add.ptr, i64 %mul
  %13 = call <mscale x 4 x double> @llvm.aarch64.sme.ld1.row.mxv4f64(<vscale x 2 x i1> %10, <mscale x 4 x double> %zb.0147, i32 %conv25, i64 0, double* %add.ptr28)
  %inc = add nuw i64 %t.0148, 1
  %cmp18 = icmp uge i64 %inc, %0
  %add = add i64 %inc, %i.0174
  %cmp23 = icmp eq i64 %add, %conv
  %or.cond = or i1 %cmp18, %cmp23
  br i1 %or.cond, label %for.cond30.preheader, label %if.end

if.end40:                                         ; preds = %if.end40.lr.ph, %if.end40
  ; CHECK-DAG: mov z{{[0-9]+}}.d, p{{[0-9]+}}/m, za{{[0-9]+}}v.d[w{{[0-9]+}}, 0]
  ; CHECK-DAG: ld1d    { z{{[0-9]+}}.d  }, p{{[0-9]+}}/z, [x{{[0-9]+}}]
  ; CHECK-DAG: fmopa   za{{[0-9]+}}.d, p{{[0-9]+}}/m, p{{[0-9]+}}/m, z{{[0-9]+}}.d, z{{[0-9]+}}.d
  %add35156 = phi i64 [ %k.0160, %if.end40.lr.ph ], [ %add35, %if.end40 ]
  %t29.0155 = phi i64 [ 0, %if.end40.lr.ph ], [ %inc48, %if.end40 ]
  %za.1154 = phi <mscale x 4 x double> [ %za.0159, %if.end40.lr.ph ], [ %16, %if.end40 ]
  %conv41 = trunc i64 %t29.0155 to i32
  %14 = call <vscale x 2 x double> @llvm.aarch64.sme.mova.vec.col.nxv2f64.mxv4f64(<vscale x 2 x i1> %11, <mscale x 4 x double> %zb.0.lcssa, i32 %conv41, i64 0)
  %mul44 = mul i64 %add35156, %conv11
  %add.ptr46 = getelementptr inbounds double, double* %add.ptr45, i64 %mul44
  %15 = call <vscale x 2 x double> @llvm.aarch64.sve.ld1.nxv2f64(<vscale x 2 x i1> %12, double* %add.ptr46)
  %16 = call <mscale x 4 x double> @llvm.aarch64.sme.fmopa.mxv4f64.nxv2f64(<vscale x 2 x i1> %11, <vscale x 2 x i1> %12, <mscale x 4 x double> %za.1154, <vscale x 2 x double> %14, <vscale x 2 x double> %15)
  %inc48 = add nuw i64 %t29.0155, 1
  %cmp31 = icmp uge i64 %inc48, %0
  %add35 = add i64 %inc48, %k.0160
  %cmp37 = icmp eq i64 %add35, %conv11
  %or.cond141 = or i1 %cmp31, %cmp37
  br i1 %or.cond141, label %cleanup49, label %if.end40

cleanup49:                                        ; preds = %if.end40, %for.cond30.preheader
  %za.1.lcssa = phi <mscale x 4 x double> [ %za.0159, %for.cond30.preheader ], [ %16, %if.end40 ]
  %add52 = add i64 %k.0160, %0
  %cmp12 = icmp ult i64 %add52, %conv11
  br i1 %cmp12, label %for.body15, label %for.cond56.preheader
if.end66:                                         ; preds = %if.end66.lr.ph, %if.end66
  ; CHECK-DAG: st1d    {za{{[0-9]+}}h.d[w{{[0-9]+}}, 0]}, p{{[0-9]+}}, [x{{[0-9]+}}]
  %add61168 = phi i64 [ %i.0174, %if.end66.lr.ph ], [ %add61, %if.end66 ]
  %t55.0167 = phi i64 [ 0, %if.end66.lr.ph ], [ %inc74, %if.end66 ]
  %conv67 = trunc i64 %t55.0167 to i32
  %mul70 = mul i64 %add61168, %conv
  %add.ptr72 = getelementptr inbounds double, double* %add.ptr71, i64 %mul70
  call void @llvm.aarch64.sme.st1.row.mxv4f64(<vscale x 2 x i1> %6, <mscale x 4 x double> %za.0.lcssa, i32 %conv67, i64 0, double* %add.ptr72)
  %inc74 = add nuw i64 %t55.0167, 1
  %cmp57 = icmp uge i64 %inc74, %0
  %add61 = add i64 %inc74, %i.0174
  %cmp63 = icmp eq i64 %add61, %conv
  %or.cond142 = or i1 %cmp57, %cmp63
  br i1 %or.cond142, label %cleanup75, label %if.end66

cleanup75:                                        ; preds = %if.end66, %for.cond56.preheader
  %add78 = add i64 %j.0170, %0
  %cmp5 = icmp ult i64 %add78, %conv4
  br i1 %cmp5, label %for.body8, label %for.cond.cleanup7
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
declare <mscale x 4 x double> @llvm.aarch64.sme.zero.mxv4f64() #1

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1>) #2

; Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
declare <mscale x 4 x double> @llvm.aarch64.sme.ld1.row.mxv4f64(<vscale x 2 x i1>, <mscale x 4 x double>, i32, i64, double*) #3

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <vscale x 2 x double> @llvm.aarch64.sme.mova.vec.col.nxv2f64.mxv4f64(<vscale x 2 x i1>, <mscale x 4 x double>, i32, i64) #2

; Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
declare <vscale x 2 x double> @llvm.aarch64.sve.ld1.nxv2f64(<vscale x 2 x i1>, double*) #3

; Function Attrs: nofree nosync nounwind readnone willreturn
declare <mscale x 4 x double> @llvm.aarch64.sme.fmopa.mxv4f64.nxv2f64(<vscale x 2 x i1>, <vscale x 2 x i1>, <mscale x 4 x double>, <vscale x 2 x double>, <vscale x 2 x double>) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.aarch64.sme.st1.row.mxv4f64(<vscale x 2 x i1>, <mscale x 4 x double>, i32, i64, double* nocapture) #4

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.aarch64.sme.stop(i32) #1

attributes #0 = { nofree nounwind "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+sme" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind willreturn }
attributes #2 = { nofree nosync nounwind readnone willreturn }
attributes #3 = { argmemonly nofree nosync nounwind readonly willreturn }
attributes #4 = { argmemonly nofree nosync nounwind willreturn writeonly }
