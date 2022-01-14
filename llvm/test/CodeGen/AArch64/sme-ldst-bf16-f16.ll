; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define dso_local void @test_ld1_st1_bf16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 64 x bfloat> %m, i32 %row, i32 %col, bfloat* readonly %addr, i64 %off) nounwind {
; CHECK-LABEL: test_ld1_st1_bf16:
; CHECK:       mov w[[R1:[0-9]+]], w0
; CHECK-DAG:   mov w[[R2:[0-9]+]], w1
; CHECK-DAG:   ld1h {za0h.h[w[[R1]], 0]}, p0/z, [x2]
; CHECK:       ld1h {za0v.h[w[[R2]], 7]}, p1/z, [x2, x3, lsl #1]
; CHECK:       st1h {za0h.h[w[[R1]], 0]}, p0, [x2]
; CHECK:       st1h {za0v.h[w[[R2]], 7]}, p1, [x2, x3, lsl #1]
; CHECK:       ret

  %1 = getelementptr bfloat, bfloat* %addr, i64 %off ; verify reg+reg addressing mode
  %2 = call <mscale x 64 x bfloat> @llvm.aarch64.sme.ld1.row.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %m, i32 %row, i64 0, bfloat* %addr)
  %3 = call <mscale x 64 x bfloat> @llvm.aarch64.sme.ld1.col.mxv64bf16(<vscale x 8 x i1> %pb, <mscale x 64 x bfloat> %2, i32 %col, i64 7, bfloat* %1)
  call void @llvm.aarch64.sme.st1.row.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %3, i32 %row, i64 0, bfloat* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv64bf16(<vscale x 8 x i1> %pb, <mscale x 64 x bfloat> %3, i32 %col, i64 7, bfloat* %1)
  ret void
}

declare <mscale x 64 x bfloat> @llvm.aarch64.sme.ld1.row.mxv64bf16(<vscale x 8 x i1>, <mscale x 64 x bfloat>, i32, i64, bfloat*)
declare <mscale x 64 x bfloat> @llvm.aarch64.sme.ld1.col.mxv64bf16(<vscale x 8 x i1>, <mscale x 64 x bfloat>, i32, i64, bfloat*)
declare void  @llvm.aarch64.sme.st1.row.mxv64bf16(<vscale x 8 x i1>, <mscale x 64 x bfloat>, i32, i64, bfloat*)
declare void  @llvm.aarch64.sme.st1.col.mxv64bf16(<vscale x 8 x i1>, <mscale x 64 x bfloat>, i32, i64, bfloat*)

define dso_local void @test_ld1_st1_f16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 64 x half> %m, i32 %row, i32 %col, half* readonly %addr, i64 %off) nounwind {
; CHECK-LABEL: test_ld1_st1_f16:
; CHECK:       mov w[[R1:[0-9]+]], w0
; CHECK-DAG:   mov w[[R2:[0-9]+]], w1
; CHECK-DAG:   ld1h {za0h.h[w[[R1]], 0]}, p0/z, [x2]
; CHECK:       ld1h {za0v.h[w[[R2]], 7]}, p1/z, [x2, x3, lsl #1]
; CHECK:       st1h {za0h.h[w[[R1]], 0]}, p0, [x2]
; CHECK:       st1h {za0v.h[w[[R2]], 7]}, p1, [x2, x3, lsl #1]
; CHECK:       ret

  %1 = getelementptr half, half* %addr, i64 %off ; verify reg+reg addressing mode
  %2 = call <mscale x 64 x half> @llvm.aarch64.sme.ld1.row.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %m, i32 %row, i64 0, half* %addr)
  %3 = call <mscale x 64 x half> @llvm.aarch64.sme.ld1.col.mxv64f16(<vscale x 8 x i1> %pb, <mscale x 64 x half> %2, i32 %col, i64 7, half* %1)
  call void @llvm.aarch64.sme.st1.row.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %3, i32 %row, i64 0, half* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv64f16(<vscale x 8 x i1> %pb, <mscale x 64 x half> %3, i32 %col, i64 7, half* %1)
  ret void
}

declare <mscale x 64 x half> @llvm.aarch64.sme.ld1.row.mxv64f16(<vscale x 8 x i1>, <mscale x 64 x half>, i32, i64, half*)
declare <mscale x 64 x half> @llvm.aarch64.sme.ld1.col.mxv64f16(<vscale x 8 x i1>, <mscale x 64 x half>, i32, i64, half*)
declare void  @llvm.aarch64.sme.st1.row.mxv64f16(<vscale x 8 x i1>, <mscale x 64 x half>, i32, i64, half*)
declare void  @llvm.aarch64.sme.st1.col.mxv64f16(<vscale x 8 x i1>, <mscale x 64 x half>, i32, i64, half*)
