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

//
// SMOPA
//

smint32_t test_smmopa_s32_s8_m(svbool_t Pn, svbool_t Pm, smint32_t Za, svint8_t Zn, svint8_t Zm) {
  // CHECK-LABEL: test_smmopa_s32_s8_m
  // CHECK: %[[PN:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.smopa.mxv16i32.nxv16i8(<vscale x 16 x i1> %[[PN]], <vscale x 16 x i1> %[[PM]], <mscale x 16 x i32> %Za, <vscale x 16 x i8> %Zn, <vscale x 16 x i8> %Zm)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _s32_s8, _m,)(Pn, Pm, Za, Zn, Zm);
}

smuint32_t test_smmopa_u32_u8_m(svbool_t Pn, svbool_t Pm, smuint32_t Za, svuint8_t Zn, svuint8_t Zm) {
  // CHECK-LABEL: test_smmopa_u32_u8_m
  // CHECK: %[[PN:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.smopa.mxv16i32.nxv16i8(<vscale x 16 x i1> %[[PN]], <vscale x 16 x i1> %[[PM]], <mscale x 16 x i32> %Za, <vscale x 16 x i8> %Zn, <vscale x 16 x i8> %Zm)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _u32_u8, _m,)(Pn, Pm, Za, Zn, Zm);
}

smint64_t test_smmopa_s64_s16_m(svbool_t Pn, svbool_t Pm, smint64_t Za, svint16_t Zn, svint16_t Zm) {
  // CHECK-LABEL: test_smmopa_s64_s16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.smopa.mxv4i64.nxv8i16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 4 x i64> %Za, <vscale x 8 x i16> %Zn, <vscale x 8 x i16> %Zm)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _s64_s16, _m,)(Pn, Pm, Za, Zn, Zm);
}

smuint64_t test_smmopa_u64_u16_m(svbool_t Pn, svbool_t Pm, smuint64_t Za, svuint16_t Zn, svuint16_t Zm) {
  // CHECK-LABEL: test_smmopa_u64_u16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.smopa.mxv4i64.nxv8i16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 4 x i64> %Za, <vscale x 8 x i16> %Zn, <vscale x 8 x i16> %Zm)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _u64_u16, _m,)(Pn, Pm, Za, Zn, Zm);
}

//
// SUMOPA/USMOPA
//

smint32_t test_smmopa_s32_s8_u8_m(svbool_t Pn, svbool_t Pm, smint32_t Za, svint8_t Zn, svuint8_t Zm) {
  // CHECK-LABEL: test_smmopa_s32_s8_u8_m
  // CHECK: %[[PN:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.sumopa.mxv16i32.nxv16i8(<vscale x 16 x i1> %[[PN]], <vscale x 16 x i1> %[[PM]], <mscale x 16 x i32> %Za, <vscale x 16 x i8> %Zn, <vscale x 16 x i8> %Zm)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _s32_s8_u8, _m,)(Pn, Pm, Za, Zn, Zm);
}

smint32_t test_smmopa_s32_u8_s8_m(svbool_t Pn, svbool_t Pm, smint32_t Za, svuint8_t Zn, svint8_t Zm) {
  // CHECK-LABEL: test_smmopa_s32_u8_s8_m
  // CHECK: %[[PN:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.usmopa.mxv16i32.nxv16i8(<vscale x 16 x i1> %[[PN]], <vscale x 16 x i1> %[[PM]], <mscale x 16 x i32> %Za, <vscale x 16 x i8> %Zn, <vscale x 16 x i8> %Zm)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _s32_u8_s8, _m,)(Pn, Pm, Za, Zn, Zm);
}

smint64_t test_smmopa_s64_s16_u16_m(svbool_t Pn, svbool_t Pm, smint64_t Za, svint16_t Zn, svuint16_t Zm) {
  // CHECK-LABEL: test_smmopa_s64_s16_u16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.sumopa.mxv4i64.nxv8i16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 4 x i64> %Za, <vscale x 8 x i16> %Zn, <vscale x 8 x i16> %Zm)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _s64_s16_u16, _m,)(Pn, Pm, Za, Zn, Zm);
}

smint64_t test_smmopa_s64_u16_s16_m(svbool_t Pn, svbool_t Pm, smint64_t Za, svuint16_t Zn, svint16_t Zm) {
  // CHECK-LABEL: test_smmopa_s64_u16_s16_m
  // CHECK: %[[PN:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pn)
  // CHECK: %[[PM:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %Pm)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.usmopa.mxv4i64.nxv8i16(<vscale x 8 x i1> %[[PN]], <vscale x 8 x i1> %[[PM]], <mscale x 4 x i64> %Za, <vscale x 8 x i16> %Zn, <vscale x 8 x i16> %Zm)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmopa, _s64_u16_s16, _m,)(Pn, Pm, Za, Zn, Zm);
}
