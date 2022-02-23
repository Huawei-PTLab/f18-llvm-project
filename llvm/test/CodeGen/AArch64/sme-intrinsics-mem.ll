; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define dso_local void @test_ld1_st1_i8(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 256 x i8> %m, i32 %row, i32 %col, i8* readonly %addr, i64 %off) nounwind {
; CHECK-LABEL: test_ld1_st1_i8:
; CHECK:       mov w12, w0
; CHECK:       mov w13, w1
; CHECK:       ld1b {za0h.b[w12, 0]}, p0/z, [x2]
; CHECK:       ld1b {za0v.b[w13, 15]}, p1/z, [x2, x3]
; CHECK:       st1b {za0h.b[w12, 0]}, p0, [x2]
; CHECK:       st1b {za0v.b[w13, 15]}, p1, [x2, x3]
; CHECK:       ret
  %1 = getelementptr i8, i8* %addr, i64 %off ; verify reg+reg addressing mode
  %2 = call <mscale x 256 x i8> @llvm.aarch64.sme.ld1.row.mxv256i8(<vscale x 16 x i1> %pa, <mscale x 256 x i8> %m, i32 %row, i64 0, i8* %addr)
  %3 = call <mscale x 256 x i8> @llvm.aarch64.sme.ld1.col.mxv256i8(<vscale x 16 x i1> %pb, <mscale x 256 x i8> %2, i32 %col, i64 15, i8* %1)
  call void @llvm.aarch64.sme.st1.row.mxv256i8(<vscale x 16 x i1> %pa, <mscale x 256 x i8> %3, i32 %row, i64 0, i8* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv256i8(<vscale x 16 x i1> %pb, <mscale x 256 x i8> %3, i32 %col, i64 15, i8* %1)
  ret void
}

declare <mscale x 256 x i8> @llvm.aarch64.sme.ld1.row.mxv256i8(<vscale x 16 x i1>, <mscale x 256 x i8>, i32, i64, i8*)
declare <mscale x 256 x i8> @llvm.aarch64.sme.ld1.col.mxv256i8(<vscale x 16 x i1>, <mscale x 256 x i8>, i32, i64, i8*)
declare void  @llvm.aarch64.sme.st1.row.mxv256i8(<vscale x 16 x i1>, <mscale x 256 x i8>, i32, i64, i8*)
declare void  @llvm.aarch64.sme.st1.col.mxv256i8(<vscale x 16 x i1>, <mscale x 256 x i8>, i32, i64, i8*)

define dso_local void @test_ld1_st1_i16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 64 x i16> %m, i32 %row, i32 %col, i16* readonly %addr, i64 %off) nounwind {
; CHECK-LABEL: test_ld1_st1_i16:
; CHECK:       mov w12, w0
; CHECK:       mov w13, w1
; CHECK:       ld1h {za0h.h[w12, 0]}, p0/z, [x2]
; CHECK:       ld1h {za0v.h[w13, 7]}, p1/z, [x2, x3, lsl #1]
; CHECK:       st1h {za0h.h[w12, 0]}, p0, [x2]
; CHECK:       st1h {za0v.h[w13, 7]}, p1, [x2, x3, lsl #1]
; CHECK:       ret
  %1 = getelementptr i16, i16* %addr, i64 %off ; verify reg+reg addressing mode
  %2 = call <mscale x 64 x i16> @llvm.aarch64.sme.ld1.row.mxv64i16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %m, i32 %row, i64 0, i16* %addr)
  %3 = call <mscale x 64 x i16> @llvm.aarch64.sme.ld1.col.mxv64i16(<vscale x 8 x i1> %pb, <mscale x 64 x i16> %2, i32 %col, i64 7, i16* %1)
  call void @llvm.aarch64.sme.st1.row.mxv64i16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %3, i32 %row, i64 0, i16* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv64i16(<vscale x 8 x i1> %pb, <mscale x 64 x i16> %3, i32 %col, i64 7, i16* %1)
  ret void
}

declare <mscale x 64 x i16> @llvm.aarch64.sme.ld1.row.mxv64i16(<vscale x 8 x i1>, <mscale x 64 x i16>, i32, i64, i16*)
declare <mscale x 64 x i16> @llvm.aarch64.sme.ld1.col.mxv64i16(<vscale x 8 x i1>, <mscale x 64 x i16>, i32, i64, i16*)
declare void  @llvm.aarch64.sme.st1.row.mxv64i16(<vscale x 8 x i1>, <mscale x 64 x i16>, i32, i64, i16*)
declare void  @llvm.aarch64.sme.st1.col.mxv64i16(<vscale x 8 x i1>, <mscale x 64 x i16>, i32, i64, i16*)

define dso_local void @test_ld1_st1_i32(<vscale x 4 x i1> %pa, <vscale x 4 x i1> %pb, <mscale x 16 x i32> %m, i32 %row, i32 %col, i32* readonly %addr, i64 %off) nounwind {
; CHECK-LABEL: test_ld1_st1_i32:
; CHECK:       mov w12, w0
; CHECK:       mov w13, w1
; CHECK:       ld1w {za0h.s[w12, 0]}, p0/z, [x2]
; CHECK:       ld1w {za0v.s[w13, 3]}, p1/z, [x2, x3, lsl #2]
; CHECK:       st1w {za0h.s[w12, 0]}, p0, [x2]
; CHECK:       st1w {za0v.s[w13, 3]}, p1, [x2, x3, lsl #2]
; CHECK:       ret
  %1 = getelementptr i32, i32* %addr, i64 %off ; verify reg+reg addressing mode
  %2 = call <mscale x 16 x i32> @llvm.aarch64.sme.ld1.row.mxv16i32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %m, i32 %row, i64 0, i32* %addr)
  %3 = call <mscale x 16 x i32> @llvm.aarch64.sme.ld1.col.mxv16i32(<vscale x 4 x i1> %pb, <mscale x 16 x i32> %2, i32 %col, i64 3, i32* %1)
  call void @llvm.aarch64.sme.st1.row.mxv16i32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %3, i32 %row, i64 0, i32* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv16i32(<vscale x 4 x i1> %pb, <mscale x 16 x i32> %3, i32 %col, i64 3, i32* %1)
  ret void
}

declare <mscale x 16 x i32> @llvm.aarch64.sme.ld1.row.mxv16i32(<vscale x 4 x i1>, <mscale x 16 x i32>, i32, i64, i32*)
declare <mscale x 16 x i32> @llvm.aarch64.sme.ld1.col.mxv16i32(<vscale x 4 x i1>, <mscale x 16 x i32>, i32, i64, i32*)
declare void  @llvm.aarch64.sme.st1.row.mxv16i32(<vscale x 4 x i1>, <mscale x 16 x i32>, i32, i64, i32*)
declare void  @llvm.aarch64.sme.st1.col.mxv16i32(<vscale x 4 x i1>, <mscale x 16 x i32>, i32, i64, i32*)

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
  %2 = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.row.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %m, i32 %row, i64 0, i64* %addr)
  %3 = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.col.mxv4i64(<vscale x 2 x i1> %pb, <mscale x 4 x i64> %2, i32 %col, i64 1, i64* %1)
  call void @llvm.aarch64.sme.st1.row.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %3, i32 %row, i64 0, i64* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv4i64(<vscale x 2 x i1> %pb, <mscale x 4 x i64> %3, i32 %col, i64 1, i64* %1)
  ret void
}

declare <mscale x 4 x i64> @llvm.aarch64.sme.ld1.row.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i64, i64*)
declare <mscale x 4 x i64> @llvm.aarch64.sme.ld1.col.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i64, i64*)
declare void  @llvm.aarch64.sme.st1.row.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i64, i64*)
declare void  @llvm.aarch64.sme.st1.col.mxv4i64(<vscale x 2 x i1>, <mscale x 4 x i64>, i32, i64, i64*)

define dso_local void @test_ld1_st1_i128(<vscale x 1 x i1> %pa, <vscale x 1 x i1> %pb, <mscale x 1 x i128> %m, i32 %row, i32 %col, i128* readonly %addr, i64 %off) nounwind {
; CHECK-LABEL: test_ld1_st1_i128:
; CHECK:       mov w12, w0
; CHECK:       mov w13, w1
; CHECK:       ld1q {za0h.q[w12, 0]}, p0/z, [x2]
; CHECK:       ld1q {za0v.q[w13, 0]}, p1/z, [x2, x3, lsl #4]
; CHECK:       st1q {za0h.q[w12, 0]}, p0, [x2]
; CHECK:       st1q {za0v.q[w13, 0]}, p1, [x2, x3, lsl #4]
; CHECK:       ret
  %1 = getelementptr i128, i128* %addr, i64 %off ; verify reg+reg addressing mode
  %2 = call <mscale x 1 x i128> @llvm.aarch64.sme.ld1.row.mxv1i128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %m, i32 %row, i64 0, i128* %addr)
  %3 = call <mscale x 1 x i128> @llvm.aarch64.sme.ld1.col.mxv1i128(<vscale x 1 x i1> %pb, <mscale x 1 x i128> %2, i32 %col, i64 0, i128* %1)
  call void @llvm.aarch64.sme.st1.row.mxv1i128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %3, i32 %row, i64 0, i128* %addr)
  call void @llvm.aarch64.sme.st1.col.mxv1i128(<vscale x 1 x i1> %pb, <mscale x 1 x i128> %3, i32 %col, i64 0, i128* %1)
  ret void
}

declare <mscale x 1 x i128> @llvm.aarch64.sme.ld1.row.mxv1i128(<vscale x 1 x i1>, <mscale x 1 x i128>, i32, i64, i128*)
declare <mscale x 1 x i128> @llvm.aarch64.sme.ld1.col.mxv1i128(<vscale x 1 x i1>, <mscale x 1 x i128>, i32, i64, i128*)
declare void  @llvm.aarch64.sme.st1.row.mxv1i128(<vscale x 1 x i1>, <mscale x 1 x i128>, i32, i64, i128*)
declare void  @llvm.aarch64.sme.st1.col.mxv1i128(<vscale x 1 x i1>, <mscale x 1 x i128>, i32, i64, i128*)
