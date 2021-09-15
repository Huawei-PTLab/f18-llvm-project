; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s

; Data fills

define void @fill_mxv1i128() {
; CHECK-LABEL: fill_mxv1i128
; CHECK-DAG:  .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-3
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG:  .cfi_offset w29, -16
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1q    { za0v.q[w12] }, p0/z, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1q    { za0v.q[w12] }, p0/z, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: mov     {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1q    { za0v.q[w12] }, p0/z, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #3
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

  %local0 = alloca <mscale x 1 x i128>, align 16
  %local1 = alloca <mscale x 1 x i128>, align 16
  %local2 = alloca <mscale x 1 x i128>, align 16

  load volatile <mscale x 1 x i128>, <mscale x 1 x i128>* %local0, align 16
  load volatile <mscale x 1 x i128>, <mscale x 1 x i128>* %local1, align 16
  load volatile <mscale x 1 x i128>, <mscale x 1 x i128>* %local2, align 16
  ret void
}

; Data spills

define void @spill_mxv1i128(<mscale x 1 x i128> %v0, <mscale x 1 x i128> %v1) {
; CHECK-LABEL: spill_mxv1i128
; CHECK-DAG: .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG: .cfi_offset w29, -16
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1q    { za0h.q[w12] }, p0, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: mov     {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1q    { za1h.q[w12] }, p0, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

  %local0 = alloca <mscale x 1 x i128>, align 16
  %local1 = alloca <mscale x 1 x i128>, align 16

  store volatile <mscale x 1 x i128> %v0, <mscale x 1 x i128>* %local0, align 16
  store volatile <mscale x 1 x i128> %v1, <mscale x 1 x i128>* %local1, align 16
  ret void
}

; Data spill/fill combine

define void @spillfill_mxv1i128(<mscale x 1 x i128> %v0) {
; CHECK-LABEL: spillfill_mxv1i128
; CHECK-DAG:  .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-DAG:  addvl   sp, sp, #-2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG:  .cfi_offset w29, -16
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1q    { za0h.q[w12] }, p0, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: mov     {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1q    { za0v.q[w12] }, p0/z, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #2
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

  %local0 = alloca <mscale x 1 x i128>, align 16
  %local1 = alloca <mscale x 1 x i128>, align 16

  store volatile <mscale x 1 x i128> %v0, <mscale x 1 x i128>* %local0, align 16
  load volatile <mscale x 1 x i128>, <mscale x 1 x i128>* %local1, align 16
  ret void
}

; Data fill with SVE

define void @fillsve(<vscale x 2 x i64> %v0, <mscale x 1 x i128> %v1) {
; CHECK-LABEL: fillsve
; CHECK-DAG: .cfi_startproc
; CHECK-NEXT: str     x29, [sp, #-16]!
; CHECK-NEXT: addvl   sp, sp, #-1
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #-1
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG:  ptrue   p0.d
; CHECK-NEXT: st1d    { z0.d }, p0, [sp]
; CHECK-NEXT: ld1d    { z0.d }, p0/z, [sp]
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: cntb    {{x[0-9]+}}
; CHECK-NEXT: madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: st1q    { za0h.q[w12] }, p0, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-DAG:  madd    {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}, sp
; CHECK-NEXT: ptrue   p0.d
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: mul     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: mov     x12, {{x[0-9]+}}
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: sub     x12, x12, #1
; CHECK-NEXT: sub     {{x[0-9]+}}, {{x[0-9]+}}, {{x[0-9]+}}
; CHECK-NEXT: ld1q    { za0v.q[w12] }, p0/z, [{{x[0-9]+}}, {{x[0-9]+}}, lsl #4]
; CHECK-NEXT: cbz     x12, {{.LBB[0-9]+_[0-9]+}}
; CHECK-NEXT: addvl   sp, sp, #1
; CHECK-NEXT: cntd    {{x[0-9]+}}
; CHECK-NEXT: asr     {{x[0-9]+}}, {{x[0-9]+}}, #1
; CHECK-NEXT: {{.LBB[0-9]+_[0-9]+}}:
; CHECK-NEXT: addvl   sp, sp, #1
; CHECK-NEXT: sub     x8, x8, #1
; CHECK-NEXT: cbz     x8, {{.LBB[0-9]+_[0-9]+}}

   %local0 = alloca <vscale x 2 x i64>
   %local1 = alloca <mscale x 1 x i128>, align 16

   store volatile <vscale x 2 x i64> %v0, <vscale x 2 x i64>* %local0
   load volatile <vscale x 2 x i64>, <vscale x 2 x i64>* %local0
   store volatile <mscale x 1 x i128> %v1, <mscale x 1 x i128>* %local1
   load volatile <mscale x 1 x i128>, <mscale x 1 x i128>* %local1
   ret void
}
