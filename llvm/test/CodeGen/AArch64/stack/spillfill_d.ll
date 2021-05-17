; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s

; Data fills

define void @fill_mxv4i64() {
; CHECK-LABEL: fill_mxv4i64
; CHECK-DAG: addvl   sp, sp, #-3
; CHECK-DAG: madd    x8, x8, x9, sp
; CHECK-DAG: ld1d    { za0h.d[w12] }, p0/z, [x8, x8, lsl #3]
; CHECK-DAG: madd    x8, x8, x9, sp
; CHECK-DAG: ld1d    { za0h.d[w12] }, p0/z, [x8, x8, lsl #3]
; CHECK-DAG: mov x8, sp
; CHECK-DAG: ld1d    { za0h.d[w12] }, p0/z, [x8, x8, lsl #3]
; CHECK-DAG: addvl   sp, sp, #3

  %local0 = alloca <mscale x 4 x i64>, align 16
  %local1 = alloca <mscale x 4 x i64>, align 16
  %local2 = alloca <mscale x 4 x i64>, align 16

  load volatile <mscale x 4 x i64>, <mscale x 4 x i64>* %local0, align 16
  load volatile <mscale x 4 x i64>, <mscale x 4 x i64>* %local1, align 16
  load volatile <mscale x 4 x i64>, <mscale x 4 x i64>* %local2, align 16
  ret void
}

; Data fill with SVE

define void @fillsve(<vscale x 2 x i64> %v0, <mscale x 4 x i64> %v1) {
; CHECK-LABEL: fillsve
; CHECK-DAG: addvl   sp, sp, #-1
; CHECK-DAG: addvl   sp, sp, #-1
; CHECK-DAG: st1d    { z0.d }, p0, [sp]
; CHECK-DAG: ld1d    { z0.d }, p0/z, [sp]
; CHECK-DAG: st1d    { za0h.d[w12] }, p0, [x8, x8, lsl #3]
; CHECK-DAG: ld1d    { za0h.d[w12] }, p0/z, [x8, x8, lsl #3]
; CHECK-DAG: addvl   sp, sp, #1
; CHECK-DAG: addvl   sp, sp, #1

   %local0 = alloca <vscale x 2 x i64>
   %local1 = alloca <mscale x 4 x i64>, align 16

   store volatile <vscale x 2 x i64> %v0, <vscale x 2 x i64>* %local0
   load volatile <vscale x 2 x i64>, <vscale x 2 x i64>* %local0
   store volatile <mscale x 4 x i64> %v1, <mscale x 4 x i64>* %local1
   load volatile <mscale x 4 x i64>, <mscale x 4 x i64>* %local1
   ret void
}
