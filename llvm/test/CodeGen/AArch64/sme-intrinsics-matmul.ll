; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 16 x float> @test_bfmop(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 16 x float> %r, <vscale x 8 x bfloat> %a, <vscale x 8 x bfloat> %b) nounwind {
; CHECK-LABEL: test_bfmop:
; CHECK-NEXT:  bfmopa za0.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  bfmops za0.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  ret
  %1 = call <mscale x 16 x float> @llvm.aarch64.sme.fmopa.bf16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 16 x float> %r, <vscale x 8 x bfloat> %a, <vscale x 8 x bfloat> %b)
  %2 = call <mscale x 16 x float> @llvm.aarch64.sme.fmops.bf16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 16 x float> %1, <vscale x 8 x bfloat> %a, <vscale x 8 x bfloat> %b)
  ret <mscale x 16 x float> %2
}

define <mscale x 16 x float> @test_fmop16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 16 x float> %r, <vscale x 8 x half> %a, <vscale x 8 x half> %b) nounwind {
; CHECK-LABEL: test_fmop16:
; CHECK-NEXT:  fmopa za0.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  fmops za0.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:  ret
  %1 = call <mscale x 16 x float> @llvm.aarch64.sme.fmopa.f16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 16 x float> %r, <vscale x 8 x half> %a, <vscale x 8 x half> %b)
  %2 = call <mscale x 16 x float> @llvm.aarch64.sme.fmops.f16(<vscale x 8 x i1> %pa, <vscale x 8 x i1> %pb, <mscale x 16 x float> %1, <vscale x 8 x half> %a, <vscale x 8 x half> %b)
  ret <mscale x 16 x float> %2
}

define <mscale x 16 x float> @test_fmop32(<vscale x 4 x i1> %pa, <vscale x 4 x i1> %pb, <mscale x 16 x float> %r, <vscale x 4 x float> %a, <vscale x 4 x float> %b) nounwind {
; CHECK-LABEL: test_fmop32:
; CHECK-NEXT:  fmopa za0.s, p0/m, p1/m, z0.s, z1.s
; CHECK-NEXT:  fmops za0.s, p0/m, p1/m, z0.s, z1.s
; CHECK-NEXT:  ret
  %1 = call <mscale x 16 x float> @llvm.aarch64.sme.fmopa.f32(<vscale x 4 x i1> %pa, <vscale x 4 x i1> %pb, <mscale x 16 x float> %r, <vscale x 4 x float> %a, <vscale x 4 x float> %b)
  %2 = call <mscale x 16 x float> @llvm.aarch64.sme.fmops.f32(<vscale x 4 x i1> %pa, <vscale x 4 x i1> %pb, <mscale x 16 x float> %1, <vscale x 4 x float> %a, <vscale x 4 x float> %b)
  ret <mscale x 16 x float> %2
}

define <mscale x 16 x i32> @test_smop32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b) nounwind {
; CHECK-LABEL: test_smop32:
; CHECK-NEXT:  smopa za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  smops za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  ret
  %1 = call <mscale x 16 x i32> @llvm.aarch64.sme.smopa.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  %2 = call <mscale x 16 x i32> @llvm.aarch64.sme.smops.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %1, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  ret <mscale x 16 x i32> %2
}

define <mscale x 16 x i32> @test_sumop32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b) nounwind {
; CHECK-LABEL: test_sumop32:
; CHECK-NEXT:  sumopa za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  sumops za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  ret
  %1 = call <mscale x 16 x i32> @llvm.aarch64.sme.sumopa.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  %2 = call <mscale x 16 x i32> @llvm.aarch64.sme.sumops.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %1, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  ret <mscale x 16 x i32> %2
}

define <mscale x 16 x i32> @test_usmop32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b) nounwind {
; CHECK-LABEL: test_usmop32:
; CHECK-NEXT:  usmopa za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  usmops za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  ret
  %1 = call <mscale x 16 x i32> @llvm.aarch64.sme.usmopa.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  %2 = call <mscale x 16 x i32> @llvm.aarch64.sme.usmops.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %1, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  ret <mscale x 16 x i32> %2
}

define <mscale x 16 x i32> @test_umop32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b) nounwind {
; CHECK-LABEL: test_umop32:
; CHECK-NEXT:  umopa za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  umops za0.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:  ret
  %1 = call <mscale x 16 x i32> @llvm.aarch64.sme.umopa.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %r, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  %2 = call <mscale x 16 x i32> @llvm.aarch64.sme.umops.i32(<vscale x 16 x i1> %pa, <vscale x 16 x i1> %pb, <mscale x 16 x i32> %1, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  ret <mscale x 16 x i32> %2
}

declare <mscale x 16 x float> @llvm.aarch64.sme.fmopa.bf16(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 16 x float>, <vscale x 8 x bfloat>, <vscale x 8 x bfloat>)
declare <mscale x 16 x float> @llvm.aarch64.sme.fmopa.f16(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 16 x float>, <vscale x 8 x half>, <vscale x 8 x half>)
declare <mscale x 16 x float> @llvm.aarch64.sme.fmopa.f32(<vscale x 4 x i1>, <vscale x 4 x i1>, <mscale x 16 x float>, <vscale x 4 x float>, <vscale x 4 x float>)
declare <mscale x 16 x float> @llvm.aarch64.sme.fmops.bf16(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 16 x float>, <vscale x 8 x bfloat>, <vscale x 8 x bfloat>)
declare <mscale x 16 x float> @llvm.aarch64.sme.fmops.f16(<vscale x 8 x i1>, <vscale x 8 x i1>, <mscale x 16 x float>, <vscale x 8 x half>, <vscale x 8 x half>)
declare <mscale x 16 x float> @llvm.aarch64.sme.fmops.f32(<vscale x 4 x i1>, <vscale x 4 x i1>, <mscale x 16 x float>, <vscale x 4 x float>, <vscale x 4 x float>)

declare <mscale x 16 x i32> @llvm.aarch64.sme.smopa.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.smops.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.sumopa.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.sumops.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.usmopa.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.usmops.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.umopa.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <mscale x 16 x i32> @llvm.aarch64.sme.umops.i32(<vscale x 16 x i1>, <vscale x 16 x i1>, <mscale x 16 x i32>, <vscale x 16 x i8>, <vscale x 16 x i8>)
