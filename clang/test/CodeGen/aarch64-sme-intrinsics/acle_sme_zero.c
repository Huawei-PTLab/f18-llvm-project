// REQUIRES: aarch64-registered-target
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sme -fallow-half-arguments-and-returns -S -O1 -Werror -emit-llvm -o - %s | FileCheck  %s

#include <arm_sve.h>


smuint8_t test_smzero_u8() {
  // CHECK-LABEL: test_smzero_u8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.zero.mxv256i8()
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return smzero_u8();
}

smuint16_t test_smzero_u16() {
  // CHECK-LABEL: test_smzero_u16
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.zero.mxv64i16()
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return smzero_u16();
}

smuint32_t test_smzero_u32() {
  // CHECK-LABEL: test_smzero_u32
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.zero.mxv16i32()
  // CHECK: <mscale x 16 x i32> %[[INTRINSIC]]
  return smzero_u32();
}

smuint64_t test_smzero_u64() {
  // CHECK-LABEL: test_smzero_u64
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.zero.mxv4i64()
  // CHECK: <mscale x 4 x i64> %[[INTRINSIC]]
  return smzero_u64();
}

smint8_t test_smzero_s8() {
  // CHECK-LABEL: test_smzero_s8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.zero.mxv256i8()
  // CHECK: <mscale x 256 x i8> %[[INTRINSIC]]
  return smzero_s8();
}

smint16_t test_smzero_s16() {
  // CHECK-LABEL: test_smzero_s16
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.zero.mxv64i16()
  // CHECK: <mscale x 64 x i16> %[[INTRINSIC]]
  return smzero_s16();
}

smint32_t test_smzero_s32() {
  // CHECK-LABEL: test_smzero_s32
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.zero.mxv16i32()
  // CHECK: <mscale x 16 x i32> %[[INTRINSIC]]
  return smzero_s32();
}

smint64_t test_smzero_s64() {
  // CHECK-LABEL: test_smzero_s64
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.zero.mxv4i64()
  // CHECK: <mscale x 4 x i64> %[[INTRINSIC]]
  return smzero_s64();
}

smfloat16_t test_smzero_f16() {
  // CHECK-LABEL: test_smzero_f16
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x half> @llvm.aarch64.sme.zero.mxv64f16()
  // CHECK: <mscale x 64 x half> %[[INTRINSIC]]
  return smzero_f16();
}

smbfloat16_t test_smzero_bf16() {
  // CHECK-LABEL: test_smzero_bf16
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x bfloat> @llvm.aarch64.sme.zero.mxv64bf16()
  // CHECK: <mscale x 64 x bfloat> %[[INTRINSIC]]
  return smzero_bf16();
}

smfloat32_t test_smzero_f32() {
  // CHECK-LABEL: test_smzero_f32
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.zero.mxv16f32()
  // CHECK: <mscale x 16 x float> %[[INTRINSIC]]
  return smzero_f32();
}

smfloat64_t test_smzero_f64() {
  // CHECK-LABEL: test_smzero_f64
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x double> @llvm.aarch64.sme.zero.mxv4f64()
  // CHECK: <mscale x 4 x double> %[[INTRINSIC]]
  return smzero_f64();
}
