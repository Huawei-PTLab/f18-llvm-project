; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <vscale x 16 x i8> @test_mova_vec_rowi8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowi8:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.b, p0/m, za0h.b[w12, 15]
; CHECK-NEXT: ret

  %1 = call <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.row.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %wv, i64 15)
  ret <vscale x 16 x i8> %1
}

define <vscale x 8 x i16> @test_mova_vec_rowi16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowi16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.h, p0/m, za0h.h[w12, 7]
; CHECK-NEXT: ret

  %1 = call <vscale x 8 x i16> @llvm.aarch64.sme.mova.vec.row.nxv8i16.mxv64i16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %tile, i32 %wv, i64 7)
  ret <vscale x 8 x i16> %1
}

define <vscale x 4 x i32> @test_mova_vec_rowi32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowi32:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.s, p0/m, za0h.s[w12, 3]
; CHECK-NEXT: ret

  %1 = call <vscale x 4 x i32> @llvm.aarch64.sme.mova.vec.row.nxv4i32.mxv16i32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %tile, i32 %wv, i64 3)
  ret <vscale x 4 x i32> %1
}

define <vscale x 4 x float> @test_mova_vec_rowf32(<vscale x 4 x i1> %pa, <mscale x 16 x float> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowf32:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.s, p0/m, za0h.s[w12, 3]
; CHECK-NEXT: ret

  %1 = call <vscale x 4 x float> @llvm.aarch64.sme.mova.vec.row.nxv4f32.mxv16f32(<vscale x 4 x i1> %pa, <mscale x 16 x float> %tile, i32 %wv, i64 3)
  ret <vscale x 4 x float> %1
}

define <vscale x 2 x i64> @test_mova_vec_rowi64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %tile, i32 %wv, i32 %imm) nounwind {
; CHECK-LABEL: test_mova_vec_rowi64:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.d, p0/m, za0h.d[w12, 1]
; CHECK-NEXT: ret

  %1 = call <vscale x 2 x i64> @llvm.aarch64.sme.mova.vec.row.nxv2i64.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %tile, i32 %wv, i64 1)
  ret <vscale x 2 x i64> %1
}

define <vscale x 2 x double> @test_mova_vec_rowf64(<vscale x 2 x i1> %pa, <mscale x 4 x double> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowf64:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.d, p0/m, za0h.d[w12, 1]
; CHECK-NEXT: ret

  %1 = call <vscale x 2 x double> @llvm.aarch64.sme.mova.vec.row.nxv2f64.mxv4f64(<vscale x 2 x i1> %pa, <mscale x 4 x double> %tile, i32 %wv, i64 1)
  ret <vscale x 2 x double> %1
}

define <vscale x 1 x i128> @test_mova_vec_rowi128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowi128:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.q, p0/m, za0h.q[w12, 0]
; CHECK-NEXT: ret

  %1 = call <vscale x 1 x i128> @llvm.aarch64.sme.mova.vec.row.nxv1i128.mxv1i128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %tile, i32 %wv, i64 0)
  ret <vscale x 1 x i128> %1
}

declare <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.row.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %wv, i64)
declare <vscale x 8 x i16> @llvm.aarch64.sme.mova.vec.row.nxv8i16.mxv64i16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %tile, i32 %wv, i64)
declare <vscale x 4 x i32> @llvm.aarch64.sme.mova.vec.row.nxv4i32.mxv16i32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %tile, i32 %wv, i64)
declare <vscale x 4 x float> @llvm.aarch64.sme.mova.vec.row.nxv4f32.mxv16f32(<vscale x 4 x i1> %pa, <mscale x 16 x float> %tile, i32 %wv, i64)
declare <vscale x 2 x i64> @llvm.aarch64.sme.mova.vec.row.nxv2i64.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %tile, i32 %wv, i64)
declare <vscale x 2 x double> @llvm.aarch64.sme.mova.vec.row.nxv2f64.mxv4f64(<vscale x 2 x i1> %pa, <mscale x 4 x double> %tile, i32 %wv, i64)
declare <vscale x 1 x i128> @llvm.aarch64.sme.mova.vec.row.nxv1i128.mxv1i128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %tile, i32 %wv, i64)
