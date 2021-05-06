; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme,+sve -asm-verbose=0 < %s -o - 2>%t | FileCheck %s

; Data fills

define void @fill_mxv256i8() {
; CHECK-LABEL: fill_mxv256i8
; CHECK-DAG: addvl   sp, sp, #-3
; CHECK-DAG: madd    x8, x8, x9, sp
; CHECK-DAG: ld1b    { za0h.b[w12] }, p0/z, [x8, x8]
; CHECK-DAG: madd    x8, x8, x9, sp
; CHECK-DAG: ld1b    { za0h.b[w12] }, p0/z, [x8, x8]
; CHECK-DAG: mov x8, sp
; CHECK-DAG: ld1b    { za0h.b[w12] }, p0/z, [x8, x8]
; CHECK-DAG: addvl   sp, sp, #3

  %local0 = alloca <mscale x 256 x i8>, align 16
  %local1 = alloca <mscale x 256 x i8>, align 16
  %local2 = alloca <mscale x 256 x i8>, align 16

  load volatile <mscale x 256 x i8>, <mscale x 256 x i8>* %local0, align 16
  load volatile <mscale x 256 x i8>, <mscale x 256 x i8>* %local1, align 16
  load volatile <mscale x 256 x i8>, <mscale x 256 x i8>* %local2, align 16
  ret void
}

; Data spills

define void @spill_mxv256i8(<mscale x 256 x i8> %v0) {
; CHECK-LABEL: spill_mxv256i8
; CHECK-DAG: addvl   sp, sp, #-2
; CHECK-DAG: madd    x8, x8, x9, sp
; CHECK-DAG: st1b    { za0h.b[w12] }, p0, [x8, x8]
; CHECK-DAG: mov     x8, sp
; CHECK-DAG: st1b    { za0h.b[w12] }, p0, [x8, x8]
; CHECK-DAG: addvl   sp, sp, #2

  %local0 = alloca <mscale x 256 x i8>, align 16
  %local1 = alloca <mscale x 256 x i8>, align 16

  store volatile <mscale x 256 x i8> %v0, <mscale x 256 x i8>* %local0, align 16
  store volatile <mscale x 256 x i8> %v0, <mscale x 256 x i8>* %local1, align 16
  ret void
}

; Data spill/fill combine

define void @spillfill_mxv256i8(<mscale x 256 x i8> %v0) {
; CHECK-LABEL: spillfill_mxv256i8
; CHECK-DAG: addvl   sp, sp, #-2
; CHECK-DAG: madd    x8, x8, x9, sp
; CHECK-DAG: st1b    { za0h.b[w12] }, p0, [x8, x8]
; CHECK-DAG: mov     x8, sp
; CHECK-DAG: ld1b    { za0h.b[w12] }, p0/z, [x8, x8]
; CHECK-DAG: addvl   sp, sp, #2

  %local0 = alloca <mscale x 256 x i8>, align 16
  %local1 = alloca <mscale x 256 x i8>, align 16

  store volatile <mscale x 256 x i8> %v0, <mscale x 256 x i8>* %local0, align 16
  load volatile <mscale x 256 x i8>, <mscale x 256 x i8>* %local1, align 16
  ret void
}

; Data spill fill with SVE

define void @spillfillsve(<vscale x 2 x i64> %v0, <mscale x 256 x i8> %v1) {
; CHECK-LABEL: spillfillsve
; CHECK-DAG: addvl   sp, sp, #-1
; CHECK-DAG: addvl   sp, sp, #-1
; CHECK-DAG: st1d    { z0.d }, p0, [sp]
; CHECK-DAG: ld1d    { z0.d }, p0/z, [sp]
; CHECK-DAG: mov     x8, sp
; CHECK-DAG: st1b    { za0h.b[w12] }, p0, [x8, x8]
; CHECK-DAG: mov     x8, sp
; CHECK-DAG: ld1b    { za0h.b[w12] }, p0/z, [x8, x8]
; CHECK-DAG: addvl   sp, sp, #1
; CHECK-DAG: addvl   sp, sp, #1

   %local0 = alloca <vscale x 2 x i64>
   %local1 = alloca <mscale x 256 x i8>, align 16

   store volatile <vscale x 2 x i64> %v0, <vscale x 2 x i64>* %local0
   load volatile <vscale x 2 x i64>, <vscale x 2 x i64>* %local0
   store volatile <mscale x 256 x i8> %v1, <mscale x 256 x i8>* %local1
   load volatile <mscale x 256 x i8>, <mscale x 256 x i8>* %local1
   ret void
}
