; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme-f64,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 4 x double> @test_fmop64(<vscale x 2 x i1> %pa, <vscale x 2 x i1> %pb, <mscale x 4 x double> %r, <vscale x 2 x double> %a, <vscale x 2 x double> %b) nounwind {
; CHECK-LABEL: test_fmop64:
; CHECK-NEXT:  fmopa za0.d, p0/m, p1/m, z0.d, z1.d
; CHECK-NEXT:  fmops za0.d, p0/m, p1/m, z0.d, z1.d
; CHECK-NEXT:  ret
  %1 = call <mscale x 4 x double> @llvm.aarch64.sme.fmopa.f64(<vscale x 2 x i1> %pa, <vscale x 2 x i1> %pb, <mscale x 4 x double> %r, <vscale x 2 x double> %a, <vscale x 2 x double> %b)
  %2 = call <mscale x 4 x double> @llvm.aarch64.sme.fmops.f64(<vscale x 2 x i1> %pa, <vscale x 2 x i1> %pb, <mscale x 4 x double> %1, <vscale x 2 x double> %a, <vscale x 2 x double> %b)
  ret <mscale x 4 x double> %2
}

declare <mscale x 4 x double> @llvm.aarch64.sme.fmopa.f64(<vscale x 2 x i1>, <vscale x 2 x i1>, <mscale x 4 x double>, <vscale x 2 x double>, <vscale x 2 x double>)
declare <mscale x 4 x double> @llvm.aarch64.sme.fmops.f64(<vscale x 2 x i1>, <vscale x 2 x i1>, <mscale x 4 x double>, <vscale x 2 x double>, <vscale x 2 x double>)
