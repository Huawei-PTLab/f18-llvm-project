; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme-i64,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 4 x i64> @test_smop64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b) nounwind {
; CHECK-LABEL: test_smop64:
; CHECK-NEXT:  smopa za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  smops za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  ret
  %1 = call <mscale x 4 x i64> @llvm.aarch64.sme.smopa.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  %2 = call <mscale x 4 x i64> @llvm.aarch64.sme.smops.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %1, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  ret <mscale x 4 x i64> %2
}

define <mscale x 4 x i64> @test_sumop64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b) nounwind {
; CHECK-LABEL: test_sumop64:
; CHECK-NEXT:  sumopa za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  sumops za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  ret
  %1 = call <mscale x 4 x i64> @llvm.aarch64.sme.sumopa.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  %2 = call <mscale x 4 x i64> @llvm.aarch64.sme.sumops.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %1, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  ret <mscale x 4 x i64> %2
}

define <mscale x 4 x i64> @test_usmop64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b) nounwind {
; CHECK-LABEL: test_usmop64:
; CHECK-NEXT:  usmopa za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  usmops za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  ret
  %1 = call <mscale x 4 x i64> @llvm.aarch64.sme.usmopa.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  %2 = call <mscale x 4 x i64> @llvm.aarch64.sme.usmops.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %1, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  ret <mscale x 4 x i64> %2
}

define <mscale x 4 x i64> @test_umop64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b) nounwind {
; CHECK-LABEL: test_umop64:
; CHECK-NEXT:  umopa za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  umops za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  ret
  %1 = call <mscale x 4 x i64> @llvm.aarch64.sme.umopa.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %r, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  %2 = call <mscale x 4 x i64> @llvm.aarch64.sme.umops.i64(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 4 x i64> %1, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  ret <mscale x 4 x i64> %2
}

declare <mscale x 4 x i64> @llvm.aarch64.sme.smopa.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.smops.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.sumopa.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.sumops.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.usmopa.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.usmops.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.umopa.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.umops.i64(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 4 x i64>, <vscale x 8 x i16>, <vscale x 8 x i16>)
