; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 64  x half> @test_mova_colf16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, <vscale x 8 x half> %z) nounwind {
; CHECK-LABEL: test_mova_colf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.h[w12, 7], p0/m, z0.h
; CHECK-NEXT: ret

  %1 = call <mscale x 64 x half> @llvm.aarch64.sme.mova.col.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64 7, <vscale x 8 x half> %z)
  ret <mscale x 64 x half> %1
}

define <mscale x 64  x half> @test_mova_rowf16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, <vscale x 8 x half> %z) nounwind {
; CHECK-LABEL: test_mova_rowf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0h.h[w12, 7], p0/m, z0.h
; CHECK-NEXT: ret

  %1 = call <mscale x 64 x half> @llvm.aarch64.sme.mova.row.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64 7, <vscale x 8 x half> %z)
  ret <mscale x 64 x half> %1

}

define <mscale x 64  x bfloat> @test_mova_colbf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, <vscale x 8 x bfloat> %z) nounwind {
; CHECK-LABEL: test_mova_colbf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0v.h[w12, 7], p0/m, z0.h
; CHECK-NEXT: ret

  %1 = call <mscale x 64 x bfloat> @llvm.aarch64.sme.mova.col.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64 7, <vscale x 8 x bfloat> %z)
  ret <mscale x 64 x bfloat> %1
}

define <mscale x 64  x bfloat> @test_mova_rowbf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, <vscale x 8 x bfloat> %z) nounwind {
; CHECK-LABEL: test_mova_rowbf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov za0h.h[w12, 7], p0/m, z0.h
; CHECK-NEXT: ret

  %1 = call <mscale x 64 x bfloat> @llvm.aarch64.sme.mova.row.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64 7, <vscale x 8 x bfloat> %z)
  ret <mscale x 64 x bfloat> %1
}

define <vscale x 8 x half> @test_mova_vec_colf16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_colf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.h, p0/m, za0v.h[w12, 7]
; CHECK-NEXT: ret

  %1 = call <vscale x 8 x half> @llvm.aarch64.sme.mova.vec.col.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64 7)
  ret <vscale x 8 x half> %1
}

define <vscale x 8 x half> @test_mova_vec_rowf16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.h, p0/m, za0h.h[w12, 7]
; CHECK-NEXT: ret

  %1 = call <vscale x 8 x half> @llvm.aarch64.sme.mova.vec.row.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64 7)
  ret <vscale x 8 x half> %1
}

define <vscale x 8 x bfloat> @test_mova_vec_colbf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_colbf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.h, p0/m, za0v.h[w12, 7]
; CHECK-NEXT: ret

  %1 = call <vscale x 8 x bfloat> @llvm.aarch64.sme.mova.vec.col.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64 7)
  ret <vscale x 8 x bfloat> %1
}

define <vscale x 8 x bfloat> @test_mova_vec_rowbf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv) nounwind {
; CHECK-LABEL: test_mova_vec_rowbf16:
; CHECK-NEXT: mov w12, w0
; CHECK-NEXT: mov z0.h, p0/m, za0h.h[w12, 7]
; CHECK-NEXT: ret

  %1 = call <vscale x 8 x bfloat> @llvm.aarch64.sme.mova.vec.row.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64 7)
  ret <vscale x 8 x bfloat> %1
}


declare <mscale x 64 x half> @llvm.aarch64.sme.mova.row.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64, <vscale x 8 x half> %z)
declare <mscale x 64 x half> @llvm.aarch64.sme.mova.col.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64, <vscale x 8 x half> %z)
declare <mscale x 64 x bfloat> @llvm.aarch64.sme.mova.row.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64, <vscale x 8 x bfloat> %z)
declare <mscale x 64 x bfloat> @llvm.aarch64.sme.mova.col.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64, <vscale x 8 x bfloat> %z)

declare <vscale x 8 x half> @llvm.aarch64.sme.mova.vec.row.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64)
declare <vscale x 8 x half> @llvm.aarch64.sme.mova.vec.col.nxv8f16.mxv64f16(<vscale x 8 x i1> %pa, <mscale x 64 x half> %tile, i32 %wv, i64)
declare <vscale x 8 x bfloat> @llvm.aarch64.sme.mova.vec.row.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64)
declare <vscale x 8 x bfloat> @llvm.aarch64.sme.mova.vec.col.nxv8bf16.mxv64bf16(<vscale x 8 x i1> %pa, <mscale x 64 x bfloat> %tile, i32 %wv, i64)

