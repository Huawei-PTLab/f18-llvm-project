; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define dso_local void @test_ld1_st1_i64(<vscale x 2 x i1> %pa, <vscale x 2 x i1> %pb, <mscale x 4 x i64> %m, i32 %row, i32 %col, i64* readonly %addr, i64 %off) nounwind {
; CHECK-LABEL: test_ld1_st1_i64:
; CHECK:       mov w12, w0
; CHECK:       mov w13, w1
; CHECK:       ld1d {za0h.d[w12, 0]}, p0/z, [x2]
; CHECK:       ld1d {za0v.d[w13, 1]}, p1/z, [x2, x3, lsl #3]
; CHECK:       st1d {za0h.d[w12, 0]}, p0, [x2]
; CHECK:       st1d {za0v.d[w13, 1]}, p1, [x2, x3, lsl #3]
; CHECK:       ret
  %1 = getelementptr i64, i64* %addr, i64 %off ; verify reg+reg addressing mode
  %2 = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.row.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %m, i32 %row, i32 0, i64* %addr)
  %3 = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.col.mxv4i64(<vscale x 2 x i1> %pb, <mscale x 4 x i64> %2, i32 %col, i32 1, i64* %1)
  call void @llvm.aarch64.sme.st1.row.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %3, i32 %row, i32 0, i64* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv4i64(<vscale x 2 x i1> %pb, <mscale x 4 x i64> %3, i32 %col, i32 1, i64* %1)
  ret void
}

declare <mscale x 4 x i64> @llvm.aarch64.sme.ld1.row.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i32, i64*)
declare <mscale x 4 x i64> @llvm.aarch64.sme.ld1.col.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i32, i64*)
declare void  @llvm.aarch64.sme.st1.row.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i32, i64*)
declare void  @llvm.aarch64.sme.st1.col.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i32, i64*)
