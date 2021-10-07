; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s

define void @test_half(<mscale x 64 x half> %v0) nounwind {
; CHECK-LABEL: test_half:
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.h
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1h    {za0h.h[w12, 0]}, p0, [x8, x8, lsl #1]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: ptrue   p0.h
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1h    {za0h.h[w12, 0]}, p0/z, [sp, x8, lsl #1]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

  %local0 = alloca <mscale x 64 x half>, align 16
  %local1 = alloca <mscale x 64 x half>, align 16
  store volatile <mscale x 64 x half> %v0, <mscale x 64 x half>* %local0, align 16
  load volatile <mscale x 64 x half>, <mscale x 64 x half>* %local1, align 16
  ret void
}

define void @test_bfloat(<mscale x 64 x bfloat> %v0) nounwind {
; CHECK-LABEL: test_bfloat:
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.h
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1h    {za0h.h[w12, 0]}, p0, [x8, x8, lsl #1]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: ptrue   p0.h
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1h    {za0h.h[w12, 0]}, p0/z, [sp, x8, lsl #1]
; CHECK-NEXT: cbz      x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

  %local0 = alloca <mscale x 64 x bfloat>, align 16
  %local1 = alloca <mscale x 64 x bfloat>, align 16
  store volatile <mscale x 64 x bfloat> %v0, <mscale x 64 x bfloat>* %local0, align 16
  load volatile <mscale x 64 x bfloat>, <mscale x 64 x bfloat>* %local1, align 16
  ret void
}
