; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s

; Data fills

define void @fill_mxv64i16() {
; CHECK-LABEL: fill_mxv64i16
; CHECK-DAG: .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-3
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG: .cfi_offset w29, -16
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: ptrue   p0.h
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1h    {za0h.h[w12, 0]}, p0/z, [x8, x8, lsl #1]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
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
; CHECK-NEXT: ld1h    {za0h.h[w12, 0]}, p0/z, [x8, x8, lsl #1]
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
; CHECK-NEXT: addvl   sp, sp, #3
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

  %local0 = alloca <mscale x 64 x i16>, align 16
  %local1 = alloca <mscale x 64 x i16>, align 16
  %local2 = alloca <mscale x 64 x i16>, align 16

  load volatile <mscale x 64 x i16>, <mscale x 64 x i16>* %local0, align 16
  load volatile <mscale x 64 x i16>, <mscale x 64 x i16>* %local1, align 16
  load volatile <mscale x 64 x i16>, <mscale x 64 x i16>* %local2, align 16
  ret void
}

; Data spills

define void @spill_mxv64i16(<mscale x 64 x i16> %v0, <mscale x 64 x i16> %v1) {
; CHECK-LABEL: spill_mxv64i16
; CHECK-DAG: .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG: .cfi_offset w29, -16
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
; CHECK-NEXT: st1h    {za1h.h[w12, 0]}, p0, [sp, x8, lsl #1]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

  %local0 = alloca <mscale x 64 x i16>, align 16
  %local1 = alloca <mscale x 64 x i16>, align 16

  store volatile <mscale x 64 x i16> %v0, <mscale x 64 x i16>* %local0, align 16
  store volatile <mscale x 64 x i16> %v1, <mscale x 64 x i16>* %local1, align 16
  ret void
}

; Data spill/fill combine

define void @spillfill_mxv64i16(<mscale x 64 x i16> %v0) {
; CHECK-LABEL: spillfill_mxv64i16
; CHECK-DAG: .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-DAG: addvl   sp, sp, #-2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG: .cfi_offset w29, -16
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

  %local0 = alloca <mscale x 64 x i16>, align 16
  %local1 = alloca <mscale x 64 x i16>, align 16

  store volatile <mscale x 64 x i16> %v0, <mscale x 64 x i16>* %local0, align 16
  load volatile <mscale x 64 x i16>, <mscale x 64 x i16>* %local1, align 16
  ret void
}

; Data spill fill with SVE

define void @spillfillsve(<vscale x 2 x i64> %v0, <mscale x 64 x i16> %v1) {
; CHECK-LABEL: spillfillsve
; CHECK-DAG: .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: mov     x29, sp
; CHECK-NEXT: addvl   sp, sp, #-1
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-1
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG: .cfi_offset w29, -16
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-DAG:  ptrue   p0.d
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1d    { z0.d }, p0, [x29, #-1, mul vl]
; CHECK-NEXT: ld1d    { z0.d }, p0/z, [x29, #-1, mul vl]
; CHECK-NEXT: ptrue   p0.h
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1h    {za0h.h[w12, 0]}, p0, [x19, x8, lsl #1]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cnth    {{x[0-9]+}}
; CHECK-NEXT: ptrue   p0.h
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1h    {za0h.h[w12, 0]}, p0/z, [x19, x8, lsl #1]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: addvl   sp, sp, #1
; CHECK-NEXT: cnth   {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #1
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

   %local0 = alloca <vscale x 2 x i64>
   %local1 = alloca <mscale x 64 x i16>, align 16

   store volatile <vscale x 2 x i64> %v0, <vscale x 2 x i64>* %local0
   load volatile <vscale x 2 x i64>, <vscale x 2 x i64>* %local0
   store volatile <mscale x 64 x i16> %v1, <mscale x 64 x i16>* %local1
   load volatile <mscale x 64 x i16>, <mscale x 64 x i16>* %local1
   ret void
}
