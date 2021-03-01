; RUN: llvm-as < %s | llvm-dis | FileCheck %s --check-prefix=ASSEM-DISASS
; RUN: verify-uselistorder %s
; Basic smoke tests for scalable matrix types.

define <mscale x 256 x i8> @check_i8_matrix() {
; ASSEM-DISASS: %tmp = alloca <mscale x 256 x i8>
; ASSEM-DISASS: load <mscale x 256 x i8>, <mscale x 256 x i8>* %tmp
; ASSEM-DISASS: ret <mscale x 256 x i8> %1
  %tmp = alloca <mscale x 256 x i8>
  %1 = load <mscale x 256 x i8>, <mscale x 256 x i8>* %tmp
  ret <mscale x 256 x i8> %1
}

define <mscale x 64 x i16> @check_i16_matrix() {
; ASSEM-DISASS: %tmp = alloca <mscale x 64 x i16>
; ASSEM-DISASS: load <mscale x 64 x i16>, <mscale x 64 x i16>* %tmp
; ASSEM-DISASS: ret <mscale x 64 x i16> %1
  %tmp = alloca <mscale x 64 x i16>
  %1 = load <mscale x 64 x i16>, <mscale x 64 x i16>* %tmp
  ret <mscale x 64 x i16> %1
}

define <mscale x 16 x i32> @check_i32_matrix() {
; ASSEM-DISASS: %tmp = alloca <mscale x 16 x i32>
; ASSEM-DISASS: load <mscale x 16 x i32>, <mscale x 16 x i32>* %tmp
; ASSEM-DISASS: ret <mscale x 16 x i32> %1
  %tmp = alloca <mscale x 16 x i32>
  %1 = load <mscale x 16 x i32>, <mscale x 16 x i32>* %tmp
  ret <mscale x 16 x i32> %1
}

define <mscale x 4 x i64> @check_i64_matrix() {
; ASSEM-DISASS: %tmp = alloca <mscale x 4 x i64>
; ASSEM-DISASS: load <mscale x 4 x i64>, <mscale x 4 x i64>* %tmp
; ASSEM-DISASS: ret <mscale x 4 x i64> %1
  %tmp = alloca <mscale x 4 x i64>
  %1 = load <mscale x 4 x i64>, <mscale x 4 x i64>* %tmp
  ret <mscale x 4 x i64> %1
}

define <mscale x 1 x i128> @check_i128_matrix() {
; ASSEM-DISASS: %tmp = alloca <mscale x 1 x i128>
; ASSEM-DISASS: load <mscale x 1 x i128>, <mscale x 1 x i128>* %tmp
; ASSEM-DISASS: ret <mscale x 1 x i128> %1
  %tmp = alloca <mscale x 1 x i128>
  %1 = load <mscale x 1 x i128>, <mscale x 1 x i128>* %tmp
  ret <mscale x 1 x i128> %1
}

define <mscale x 16 x float> @check_float_matrix() {
; ASSEM-DISASS: %tmp = alloca <mscale x 16 x float>
; ASSEM-DISASS: load <mscale x 16 x float>, <mscale x 16 x float>* %tmp
; ASSEM-DISASS: ret <mscale x 16 x float> %1
  %tmp = alloca <mscale x 16 x float>
  %1 = load <mscale x 16 x float>, <mscale x 16 x float>* %tmp
  ret <mscale x 16 x float> %1
}

define <mscale x 4 x double> @check_double_matrix() {
; ASSEM-DISASS: %tmp = alloca <mscale x 4 x double>
; ASSEM-DISASS: load <mscale x 4 x double>, <mscale x 4 x double>* %tmp
; ASSEM-DISASS: ret <mscale x 4 x double> %1
  %tmp = alloca <mscale x 4 x double>
  %1 = load <mscale x 4 x double>, <mscale x 4 x double>* %tmp
  ret <mscale x 4 x double> %1
}
