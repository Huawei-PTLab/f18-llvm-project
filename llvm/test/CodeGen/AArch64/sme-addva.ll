; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 16 x i32> @test_addva32(<mscale x 16 x i32> %tile, <vscale x 4 x i1> %pa, <vscale x 4 x i1> %pb, <vscale x 4 x i32> %z) nounwind {
; CHECK-LABEL: test_addva32:
; CHECK-NEXT: addva za0.s, p0/m, p1/m, z0.s
; CHECK-NEXT: ret

  %1 = call <mscale x 16 x i32> @llvm.aarch64.sme.addva.mxv16i32.nxv4i32(<vscale x 4 x i1> %pa, <vscale x 4 x i1> %pb, <mscale x 16 x i32> %tile, <vscale x 4 x i32> %z)
  ret <mscale x 16 x i32> %1
}

declare <mscale x 16 x i32> @llvm.aarch64.sme.addva.mxv16i32.nxv4i32(<vscale x 4 x i1> %pa, <vscale x 4 x i1> %pb, <mscale x 16 x i32> %tile, <vscale x 4 x i32> %z)
