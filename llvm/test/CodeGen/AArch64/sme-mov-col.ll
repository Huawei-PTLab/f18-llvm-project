; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 256 x i8> @test_mova_coli8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %wv, <vscale x 16 x i8> %z) nounwind {
; CHECK-LABEL: test_mova_coli8:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.b[w12, 15], p0/m, z0.b
; CHECK-NEXT: ret

  %1 = call <mscale x 256 x i8> @llvm.aarch64.sme.mova.col.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %wv, i64 15, <vscale x 16 x i8> %z)
  ret <mscale x 256 x i8> %1
}

define <mscale x 64  x i16> @test_mova_coli16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %tile, i32 %wv, <vscale x 8 x i16> %z) nounwind {
; CHECK-LABEL: test_mova_coli16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.h[w12, 7], p0/m, z0.h
; CHECK-NEXT: ret

  %1 = call <mscale x 64 x i16> @llvm.aarch64.sme.mova.col.nxv8i16.mxv64i16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %tile, i32 %wv, i64 7, <vscale x 8 x i16> %z)
  ret <mscale x 64 x i16> %1
}

define <mscale x 16 x i32> @test_mova_coli32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %tile, i32 %wv, <vscale x 4 x i32> %z) nounwind {
; CHECK-LABEL: test_mova_coli32:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.s[w12, 3], p0/m, z0.s
; CHECK-NEXT: ret

  %1 = call <mscale x 16 x i32> @llvm.aarch64.sme.mova.col.nxv4i32.mxv16i32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %tile, i32 %wv, i64 3, <vscale x 4 x i32> %z)
  ret <mscale x 16 x i32> %1
}

define <mscale x 16 x float> @test_mova_colf32(<vscale x 4 x i1> %pa, <mscale x 16 x float> %tile, i32 %wv, <vscale x 4 x float> %z) nounwind {
; CHECK-LABEL: test_mova_colf32:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.s[w12, 3], p0/m, z0.s
; CHECK-NEXT: ret

  %1 = call <mscale x 16 x float> @llvm.aarch64.sme.mova.col.nxv4f32.mxv16f32(<vscale x 4 x i1> %pa, <mscale x 16 x float> %tile, i32 %wv, i64 3, <vscale x 4 x float> %z)
  ret <mscale x 16 x float> %1
}

define <mscale x 4 x i64> @test_mova_coli64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %tile, i32 %wv, <vscale x 2 x i64> %z) nounwind {
; CHECK-LABEL: test_mova_coli64:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.d[w12, 1], p0/m, z0.d
; CHECK-NEXT: ret

  %1 = call <mscale x 4 x i64> @llvm.aarch64.sme.mova.col.nxv2i64.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %tile, i32 %wv, i64 1, <vscale x 2 x i64> %z)
  ret <mscale x 4 x i64> %1
}

define <mscale x 4 x double> @test_mova_colf64(<vscale x 2 x i1> %pa, <mscale x 4 x double> %tile, i32 %wv, <vscale x 2 x double> %z) nounwind {
; CHECK-LABEL: test_mova_colf64:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.d[w12, 1], p0/m, z0.d
; CHECK-NEXT: ret

  %1 = call <mscale x 4 x double> @llvm.aarch64.sme.mova.col.nxv2f64.mxv4f64(<vscale x 2 x i1> %pa, <mscale x 4 x double> %tile, i32 %wv, i64 1, <vscale x 2 x double> %z)
  ret <mscale x 4 x double> %1
}

define <mscale x 1 x i128> @test_mova_coli128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %tile, i32 %wv, <vscale x 1 x i128> %z) nounwind {
; CHECK-LABEL: test_mova_coli128:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.q[w12, 0], p0/m, z0.q
; CHECK-NEXT: ret

  %1 = call <mscale x 1 x i128> @llvm.aarch64.sme.mova.col.nxv1i128.mxv1i128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %tile, i32 %wv, i64 0, <vscale x 1 x i128> %z)
  ret <mscale x 1 x i128> %1
}

declare <mscale x 256 x i8> @llvm.aarch64.sme.mova.col.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %wv, i64, <vscale x 16 x i8> %z)
declare <mscale x 64 x i16> @llvm.aarch64.sme.mova.col.nxv8i16.mxv64i16(<vscale x 8 x i1> %pa, <mscale x 64 x i16> %tile, i32 %wv, i64, <vscale x 8 x i16> %z)
declare <mscale x 16 x i32> @llvm.aarch64.sme.mova.col.nxv4i32.mxv16i32(<vscale x 4 x i1> %pa, <mscale x 16 x i32> %tile, i32 %wv, i64, <vscale x 4 x i32> %z)
declare <mscale x 16 x float> @llvm.aarch64.sme.mova.col.nxv4f32.mxv16f32(<vscale x 4 x i1> %pa, <mscale x 16 x float> %tile, i32 %wv, i64, <vscale x 4 x float> %z)
declare <mscale x 4 x i64> @llvm.aarch64.sme.mova.col.nxv2i64.mxv4i64(<vscale x 2 x i1> %pa, <mscale x 4 x i64> %tile, i32 %wv, i64, <vscale x 2 x i64> %z)
declare <mscale x 4 x double> @llvm.aarch64.sme.mova.col.nxv2f64.mxv4f64(<vscale x 2 x i1> %pa, <mscale x 4 x double> %tile, i32 %wv, i64, <vscale x 2 x double> %z)
declare <mscale x 1 x i128> @llvm.aarch64.sme.mova.col.nxv1i128.mxv1i128(<vscale x 1 x i1> %pa, <mscale x 1 x i128> %tile, i32 %wv, i64, <vscale x 1 x i128> %z)
