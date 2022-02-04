; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme-i64,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 4 x i64> @test_addha64(<mscale x 4 x i64> %tile, <vscale x 2 x i1> %pa, <vscale x 2 x i1> %pb, <vscale x 2 x i64> %z) nounwind {
; CHECK-LABEL: test_addha64:
; CHECK-NEXT: addha za0.d, p0/m, p1/m, z0.d
; CHECK-NEXT: ret

  %1 = call <mscale x 4 x i64> @llvm.aarch64.sme.addha.mxv4i64.nxv2i64(<vscale x 2 x i1> %pa, <vscale x 2 x i1> %pb, <mscale x 4 x i64> %tile, <vscale x 2 x i64> %z)
  ret <mscale x 4 x i64> %1
}

declare <mscale x 4 x i64> @llvm.aarch64.sme.addha.mxv4i64.nxv2i64(<vscale x 2 x i1> %pa, <vscale x 2 x i1> %pb, <mscale x 4 x i64> %tile, <vscale x 2 x i64> %z)
