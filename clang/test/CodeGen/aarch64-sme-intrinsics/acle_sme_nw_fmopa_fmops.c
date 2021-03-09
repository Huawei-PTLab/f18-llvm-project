// Test case for non-widening fmopa/fmops.
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


smfloat32_t test_smmopa_f32_m(svbool_t Pn, svbool_t Pm, smfloat32_t Za, svfloat32_t Zn, svfloat32_t Zm) {
  // CHECK-LABEL: test_smmopa_f32_m
  // CHECK: %[[PN:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.fmopa.mxv16f32.nxv4f32(<vscale x 4 x i1> %0, <vscale x 4 x i1> %1, <mscale x 16 x float> %Za, <vscale x 4 x float> %Zn, <vscale x 4 x float> %Zm)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return smmopa_m(Pn, Pm, Za, Zn, Zm);
}

smfloat64_t test_smmopa_f64_m(svbool_t Pn, svbool_t Pm, smfloat64_t Za, svfloat64_t Zn, svfloat64_t Zm) {
  // CHECK-LABEL: test_smmopa_f64_m
  // CHECK: %[[PN:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x double> @llvm.aarch64.sme.fmopa.mxv4f64.nxv2f64(<vscale x 2 x i1> %0, <vscale x 2 x i1> %1, <mscale x 4 x double> %Za, <vscale x 2 x double> %Zn, <vscale x 2 x double> %Zm)
  // CHECK: ret <mscale x 4 x double> %[[INTRINSIC]]
  return smmopa_m(Pn, Pm, Za, Zn, Zm);
}

smfloat32_t test_smmops_f32_m(svbool_t Pn, svbool_t Pm, smfloat32_t Za, svfloat32_t Zn, svfloat32_t Zm) {
  // CHECK-LABEL: test_smmops_f32_m
  // CHECK: %[[PN:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.fmops.mxv16f32.nxv4f32(<vscale x 4 x i1> %0, <vscale x 4 x i1> %1, <mscale x 16 x float> %Za, <vscale x 4 x float> %Zn, <vscale x 4 x float> %Zm)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return smmops_m(Pn, Pm, Za, Zn, Zm);
}

smfloat64_t test_smmops_f64_m(svbool_t Pn, svbool_t Pm, smfloat64_t Za, svfloat64_t Zn, svfloat64_t Zm) {
  // CHECK-LABEL: test_smmops_f64_m
  // CHECK: %[[PN:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x double> @llvm.aarch64.sme.fmops.mxv4f64.nxv2f64(<vscale x 2 x i1> %0, <vscale x 2 x i1> %1, <mscale x 4 x double> %Za, <vscale x 2 x double> %Zn, <vscale x 2 x double> %Zm)
  // CHECK: ret <mscale x 4 x double> %[[INTRINSIC]]
  return smmops_m(Pn, Pm, Za, Zn, Zm);
}
