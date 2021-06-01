; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme -asm-verbose=0 -O1 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; WARN-NOT: warning

define dso_local <mscale x 16 x i32> @test_fun(<vscale x 16 x i1> %Pn, <vscale x 16 x i1> %Pm, <mscale x 16 x i32> %Za, <vscale x 4 x i32> %Zn) {
; CHECK-LABEL: test_fun:
; CHECK-DAG:   addha   za0.s, p0/m, p1/m, z0.s
; CHECK-NEXT:  ret

  %1 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pn)
  %2 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pm)
  %3 = call <mscale x 16 x i32> @llvm.aarch64.sme.addha.mxv16i32.nxv4i32(<vscale x 4 x i1> %1, <vscale x 4 x i1> %2, <mscale x 16 x i32> %Za, <vscale x 4 x i32> %Zn)
  ret <mscale x 16 x i32> %3
}

declare <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.addha.mxv16i32.nxv4i32(<vscale x 4 x i1>, <vscale x 4 x i1>, <mscale x 16 x i32>, <vscale x 4 x i32>)

define dso_local <mscale x 16 x i32> @test_matrix(<mscale x 16 x i32> %Za, <mscale x 16 x i32> %Zb) {
; CHECK-LABEL: test_matrix:
; CHECK-DAG:   cntw    x12
; CHECK-DAG:   mova    z0.d, p0/m, za1h.s[w12, #0]
; CHECK-NEXT:  mova    za0h.s[w12, #0], p0/m, z0.d
; CHECK-NEXT:  sub     x12, x12, #1
; CHECK-DAG:   bl      test_fun
; CHECK-NEXT:  addha   za0.s, p0/m, p0/m, z0.s
; CHECK-NEXT:  ldr     x30, [sp], #16
; CHECK-NEXT:  ret

  %call = call <mscale x 16 x i32> @test_fun(<vscale x 16 x i1> undef, <vscale x 16 x i1> undef, <mscale x 16 x i32> %Zb, <vscale x 4 x i32> undef)
  %1 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> undef)
  %2 = call <mscale x 16 x i32> @llvm.aarch64.sme.addha.mxv16i32.nxv4i32(<vscale x 4 x i1> %1, <vscale x 4 x i1> %1, <mscale x 16 x i32> %call, <vscale x 4 x i32> undef)
  ret <mscale x 16 x i32> %2
}
