; RUN: llc -O0 -mtriple=aarch64-none-linux-gnu -mattr=+sme -asm-verbose=0 < %s -o - 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <mscale x 256 x i8> @store_load_i8(<mscale x 256 x i8> %tile) {
; CHECK-LABEL: store_load_i8:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].b
; CHECK-NEXT: cntb	[[CNTB:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTB]], [[CNTB]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTB]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTB]]
; CHECK-NEXT: st1b	{ za0h.b{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]]{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].b
; CHECK-NEXT: cntb	[[CNTB:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTB]], [[CNTB]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTB]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTB]]
; CHECK-NEXT: ld1b	{ za0h.b{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]]{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 256 x i8>, align 16
    store <mscale x 256 x i8> %tile, <mscale x 256 x i8>* %tile.addr, align 16
    %1 = load <mscale x 256 x i8>, <mscale x 256 x i8>* %tile.addr, align 16
    ret <mscale x 256 x i8> %1
}

define <mscale x 64 x i16> @store_load_i16(<mscale x 64 x i16> %tile) {
; CHECK-LABEL: store_load_i16:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].h
; CHECK-NEXT: cnth	[[CNTH:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTH]], [[CNTH]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTH]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTH]]
; CHECK-NEXT: st1h	{ za{{[0-1]}}h.h{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #1{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].h
; CHECK-NEXT: cnth	[[CNTH:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTH]], [[CNTH]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTH]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTH]]
; CHECK-NEXT: ld1h	{ za{{[0-1]}}h.h{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #1{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 64 x i16>, align 16
    store <mscale x 64 x i16> %tile, <mscale x 64 x i16>* %tile.addr, align 16
    %1 = load <mscale x 64 x i16>, <mscale x 64 x i16>* %tile.addr, align 16
    ret <mscale x 64 x i16> %1
}

define <mscale x 64 x half> @store_load_f16(<mscale x 64 x half> %tile) {
; CHECK-LABEL: store_load_f16:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].h
; CHECK-NEXT: cnth	[[CNTH:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTH]], [[CNTH]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTH]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTH]]
; CHECK-NEXT: st1h	{ za{{[0-1]}}h.h{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #1{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].h
; CHECK-NEXT: cnth	[[CNTH:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTH]], [[CNTH]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTH]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTH]]
; CHECK-NEXT: ld1h	{ za{{[0-1]}}h.h{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #1{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 64 x half>, align 16
    store <mscale x 64 x half> %tile, <mscale x 64 x half>* %tile.addr, align 16
    %1 = load <mscale x 64 x half>, <mscale x 64 x half>* %tile.addr, align 16
    ret <mscale x 64 x half> %1
}

define <mscale x 64 x bfloat> @store_load_bf16(<mscale x 64 x bfloat> %tile) {
; CHECK-LABEL: store_load_bf16:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].h
; CHECK-NEXT: cnth	[[CNTH:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTH]], [[CNTH]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTH]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTH]]
; CHECK-NEXT: st1h	{ za{{[0-1]}}h.h{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #1{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].h
; CHECK-NEXT: cnth	[[CNTH:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTH]], [[CNTH]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTH]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTH]]
; CHECK-NEXT: ld1h	{ za{{[0-1]}}h.h{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #1{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 64 x bfloat>, align 16
    store <mscale x 64 x bfloat> %tile, <mscale x 64 x bfloat>* %tile.addr, align 16
    %1 = load <mscale x 64 x bfloat>, <mscale x 64 x bfloat>* %tile.addr, align 16
    ret <mscale x 64 x bfloat> %1
}

define <mscale x 16 x i32> @store_load_i32(<mscale x 16 x i32> %tile) {
; CHECK-LABEL: store_load_i32:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].s
; CHECK-NEXT: cntw	[[CNTW:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTW]], [[CNTW]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTW]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTW]]
; CHECK-NEXT: st1w	{ za{{[0-1]}}h.s{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #2{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].s
; CHECK-NEXT: cntw	[[CNTB:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTB]], [[CNTB]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTB]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTB]]
; CHECK-NEXT: ld1w	{ za{{[0-1]}}h.s{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #2{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 16 x i32>, align 16
    store <mscale x 16 x i32> %tile, <mscale x 16 x i32>* %tile.addr, align 16
    %1 = load <mscale x 16 x i32>, <mscale x 16 x i32>* %tile.addr, align 16
    ret <mscale x 16 x i32> %1
}

define <mscale x 16 x float> @store_load_f32(<mscale x 16 x float> %tile) {
; CHECK-LABEL: store_load_f32:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].s
; CHECK-NEXT: cntw	[[CNTW:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTW]], [[CNTW]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTW]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTW]]
; CHECK-NEXT: st1w	{ za{{[0-1]}}h.s{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #2{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK: mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].s
; CHECK-NEXT: cntw	[[CNTW:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTW]], [[CNTW]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTW]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTW]]
; CHECK-NEXT: ld1w	{ za{{[0-1]}}h.s{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #2{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 16 x float>, align 16
    store <mscale x 16 x float> %tile, <mscale x 16 x float>* %tile.addr, align 16
    %1 = load <mscale x 16 x float>, <mscale x 16 x float>* %tile.addr, align 16
    ret <mscale x 16 x float> %1
}

define <mscale x 4 x i64> @store_load_i64(<mscale x 4 x i64> %tile) {
; CHECK-LABEL: store_load_i64:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].d
; CHECK-NEXT: cntd	[[CNTD:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTD]], [[CNTD]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTD]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTD]]
; CHECK-NEXT: st1d	{ za{{[0-1]}}h.d{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #3{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].d
; CHECK-NEXT: cntd	[[CNTD:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTD]], [[CNTD]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTD]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTD]]
; CHECK-NEXT: ld1d	{ za{{[0-1]}}h.d{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #3{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 4 x i64>, align 16
    store <mscale x 4 x i64> %tile, <mscale x 4 x i64>* %tile.addr, align 16
    %1 = load <mscale x 4 x i64>, <mscale x 4 x i64>* %tile.addr, align 16
    ret <mscale x 4 x i64> %1
}

define <mscale x 4 x double> @store_load_f64(<mscale x 4 x double> %tile) {
; CHECK-LABEL: store_load_f64:
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].d
; CHECK-NEXT: cntd	[[CNTD:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTD]], [[CNTD]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTD]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTD]]
; CHECK-NEXT: st1d	{ za{{[0-1]}}h.d{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #3{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]
; CHECK:      mov	[[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue	[[PG:p[0-7]]].d
; CHECK-NEXT: cntd	[[CNTD:x[0-9]+]]
; CHECK-NEXT: mul	[[XM:x[0-9]+]], [[CNTD]], [[CNTD]]
; CHECK-NEXT: mov	x[[V:1[2-5]]], [[CNTD]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub	x[[V]], x[[V]], #1
; CHECK-NEXT: sub	[[XM]], [[XM]], [[CNTD]]
; CHECK-NEXT: ld1d	{ za{{[0-1]}}h.d{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #3{{\]}}
; CHECK-NEXT: cbz	x[[V]], .[[LOOP]]

    %tile.addr = alloca <mscale x 4 x double>, align 16
    store <mscale x 4 x double> %tile, <mscale x 4 x double>* %tile.addr, align 16
    %1 = load <mscale x 4 x double>, <mscale x 4 x double>* %tile.addr, align 16
    ret <mscale x 4 x double> %1
}

define <mscale x 1 x i128> @store_load_i128(<mscale x 1 x i128> %tile) {
; CHECK-LABEL: store_load_i128:
; CHECK:      mov       [[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue     [[PG:p[0-7]]].d
; CHECK-NEXT: cntd      [[CNTD:x[0-9]+]]
; CHECK-NEXT: asr       [[CNTD]], [[CNTD]], #1
; CHECK-NEXT: mul       [[XM:x[0-9]+]], [[CNTD]], [[CNTD]]
; CHECK-NEXT: mov       x[[V:1[2-5]]], [[CNTD]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub       x[[V]], x[[V]], #1
; CHECK-NEXT: sub       [[XM]], [[XM]], [[CNTD]]
; CHECK-NEXT: st1q      { za0h.q{{\[}}w[[V]]{{\]}} }, [[PG]], {{\[}}[[XN]], [[XM]], lsl #4{{\]}}
; CHECK-NEXT: cbz       x[[V]], .[[LOOP]]
; CHECK:      mov       [[XN:x[0-9]+]], sp
; CHECK-NEXT: ptrue     [[PG:p[0-7]]].d
; CHECK-NEXT: cntd      [[CNTD:x[0-9]+]]
; CHECK-NEXT: asr       [[CNTD]], [[CNTD]], #1
; CHECK-NEXT: mul       [[XM:x[0-9]+]], [[CNTD]], [[CNTD]]
; CHECK-NEXT: mov       x[[V:1[2-5]]], [[CNTD]]
; CHECK-NEXT: .[[LOOP:LBB[0-9]+_[0-9]+]]:
; CHECK-NEXT: sub       x[[V]], x[[V]], #1
; CHECK-NEXT: sub       [[XM]], [[XM]], [[CNTD]]
; CHECK-NEXT: ld1q      { za0v.q{{\[}}w[[V]]{{\]}} }, [[PG]]/z, {{\[}}[[XN]], [[XM]], lsl #4{{\]}}
; CHECK-NEXT: cbz       x[[V]], .[[LOOP]]

  %tile.addr = alloca <mscale x 1 x i128>, align 16
  store <mscale x 1 x i128> %tile,  <mscale x 1 x i128>* %tile.addr, align 16
  %1 = load <mscale x 1 x i128>, <mscale x 1 x i128>* %tile.addr, align 16
  ret <mscale x 1 x i128> %1
}
