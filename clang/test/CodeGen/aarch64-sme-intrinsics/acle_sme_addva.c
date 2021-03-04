// REQUIRES: aarch64-registered-target
// RUN: %clang -emit-llvm -S -target aarch64-none-linux-gnu -O1 -march=armv8-a+sve+sme -o - %s | FileCheck %s
// RUN: %clang -emit-llvm -S -DSVE_OVERLOADED_FORMS -target aarch64-none-linux-gnu -O1 -march=armv8-a+sve+sme -o - %s | FileCheck %s

#include <arm_sve.h>

#ifdef SME_OVERLOADED_FORMS
// A simple used,unused... macro, long enough to represent any SME builtin.
#define SME_ACLE_FUNC(A1,A2_UNUSED,A3,A4_UNUSED) A1##A3
#else
#define SME_ACLE_FUNC(A1,A2,A3,A4) A1##A2##A3##A4
#endif


smuint32_t test_smaddva_u32_m(svbool_t Pn, svbool_t Pm, smuint32_t Za, svuint32_t Zn) {
  // CHECK-LABEL: test_smaddva_u32_m
  // CHECK: %[[PN:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.addva.mxv16i32.nxv4i32(<vscale x 4 x i1> %[[PN]], <vscale x 4 x i1> %[[PM]], <mscale x 16 x i32> %Za, <vscale x 4 x i32> %Zn)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smaddva,_u32,_m,)(Pn, Pm, Za, Zn);
}

smuint64_t test_smaddva_u64_m(svbool_t Pn, svbool_t Pm, smuint64_t Za, svuint64_t Zn) {
  // CHECK-LABEL: test_smaddva_u64_m
  // CHECK: %[[PN:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.addva.mxv4i64.nxv2i64(<vscale x 2 x i1> %[[PN]], <vscale x 2 x i1> %[[PM]], <mscale x 4 x i64> %Za, <vscale x 2 x i64> %Zn)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smaddva,_u64,_m,)(Pn, Pm, Za, Zn);
}

smint32_t test_smaddva_s32_m(svbool_t Pn, svbool_t Pm, smint32_t Za, svint32_t Zn) {
  // CHECK-LABEL: test_smaddva_s32_m
  // CHECK: %[[PN:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.addva.mxv16i32.nxv4i32(<vscale x 4 x i1> %[[PN]], <vscale x 4 x i1> %[[PM]], <mscale x 16 x i32> %Za, <vscale x 4 x i32> %Zn)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smaddva,_s32,_m,)(Pn, Pm, Za, Zn);
}

smint64_t test_smaddva_s64_m(svbool_t Pn, svbool_t Pm, smint64_t Za, svint64_t Zn) {
  // CHECK-LABEL: test_smaddva_s64_m
  // CHECK: %[[PN:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.addva.mxv4i64.nxv2i64(<vscale x 2 x i1> %[[PN]], <vscale x 2 x i1> %[[PM]], <mscale x 4 x i64> %Za, <vscale x 2 x i64> %Zn)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smaddva,_s64,_m,)(Pn, Pm, Za, Zn);
}
