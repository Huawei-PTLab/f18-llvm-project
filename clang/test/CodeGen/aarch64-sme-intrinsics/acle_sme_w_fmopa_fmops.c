// Test case for widening fmopa/fmops.
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


smfloat32_t test_smmopa_f32_f16_m(svbool_t Pn, svbool_t Pm, smfloat32_t Za, svfloat16_t Zn, svfloat16_t Zm) {
  // CHECK-LABEL: test_smmopa_f32_f16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.fmopa.mxv16f32.nxv8f16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 16 x float> %Za, <vscale x 8 x half> %Zn, <vscale x 8 x half> %Zm)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa,_f32_f16,_m,)(Pn, Pm, Za, Zn, Zm);
}

smfloat32_t test_smmopa_f32_bf16_m(svbool_t Pn, svbool_t Pm, smfloat32_t Za, svbfloat16_t Zn, svbfloat16_t Zm) {
  // CHECK-LABEL: test_smmopa_f32_bf16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.fmopa.mxv16f32.nxv8bf16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 16 x float> %Za, <vscale x 8 x bfloat> %Zn, <vscale x 8 x bfloat> %Zm)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return smmopa_m(Pn, Pm, Za, Zn, Zm);
}

smfloat32_t test_smmops_f32_f16_m(svbool_t Pn, svbool_t Pm, smfloat32_t Za, svfloat16_t Zn, svfloat16_t Zm) {
  // CHECK-LABEL: test_smmops_f32_f16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.fmops.mxv16f32.nxv8f16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 16 x float> %Za, <vscale x 8 x half> %Zn, <vscale x 8 x half> %Zm)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return smmops_m(Pn, Pm, Za, Zn, Zm);
}

smfloat32_t test_smmops_f32_bf16_m(svbool_t Pn, svbool_t Pm, smfloat32_t Za, svbfloat16_t Zn, svbfloat16_t Zm) {
  // CHECK-LABEL: test_smmops_f32_bf16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.fmops.mxv16f32.nxv8bf16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 16 x float> %Za, <vscale x 8 x bfloat> %Zn, <vscale x 8 x bfloat> %Zm)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return smmops_m(Pn, Pm, Za, Zn, Zm);
}
