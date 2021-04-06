// REQUIRES: aarch64-registered-target
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sme -fallow-half-arguments-and-returns -S -O1 -Werror -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -DSME_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sme -fallow-half-arguments-and-returns -S -O1 -Werror -emit-llvm -o - %s | FileCheck %s

#include <arm_sve.h>

#ifdef SME_OVERLOADED_FORMS
// A simple used,unused... macro, long enough to represent any SME builtin.
#define SME_ACLE_FUNC(A1,A2_UNUSED,A3,A4_UNUSED) A1##A3
#else
#define SME_ACLE_FUNC(A1,A2,A3,A4) A1##A2##A3##A4
#endif


smuint8_t test_smldr_u8(smuint8_t dest, int32_t idx, const void *src) {
  // CHECK-LABEL: test_smldr_u8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.ldr.mxv256i8(<mscale x 256 x i8> %dest, i32 %idx, i8* %src)
  // ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smldr, _u8,,)(dest, idx, src);
}

smint8_t test_smldr_s8(smint8_t dest, int32_t idx, const void *src) {
  // CHECK-LABEL: test_smldr_s8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.ldr.mxv256i8(<mscale x 256 x i8> %dest, i32 %idx, i8* %src)
  // ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smldr, _s8,,)(dest, idx, src);
}

void test_smstr_u8(smuint8_t src, int32_t idx, void *dest) {
  // CHECK-LABEL: test_smstr_u8
  // CHECK: call void @llvm.aarch64.sme.str.mxv256i8(<mscale x 256 x i8> %src, i32 %idx, i8* %dest)
  // ret void
  return SME_ACLE_FUNC(smstr, _u8,,)(src, idx, dest);
}

void test_smstr_s8(smint8_t src, int32_t idx, void *dest) {
  // CHECK-LABEL: test_smstr_s8
  // CHECK: call void @llvm.aarch64.sme.str.mxv256i8(<mscale x 256 x i8> %src, i32 %idx, i8* %dest)
  // ret void
  return SME_ACLE_FUNC(smstr, _s8,,)(src, idx, dest);
}
