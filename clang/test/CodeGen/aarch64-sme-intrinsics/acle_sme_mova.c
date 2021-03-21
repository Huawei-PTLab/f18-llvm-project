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


smuint8_t test_smmovah_u8_m(svbool_t pg, smuint8_t dest, uint32_t idx, svuint8_t src) {
  // CHECK-LABEL: test_smmovah_u8_m
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.mova.row.mxv256i8.nxv16i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i32 0, <vscale x 16 x i8> %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_u8,_m,)(pg, dest, idx, src);
}

smuint16_t test_smmovah_u16_m(svbool_t pg, smuint16_t dest, uint32_t idx, svuint16_t src) {
  // CHECK-LABEL: test_smmovah_u16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.mova.row.mxv64i16.nxv8i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i32 0, <vscale x 8 x i16> %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_u16,_m,)(pg, dest, idx, src);
}

smuint32_t test_smmovah_u32_m(svbool_t pg, smuint32_t dest, uint32_t idx, svuint32_t src) {
  // CHECK-LABEL: test_smmovah_u32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.mova.row.mxv16i32.nxv4i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i32 0, <vscale x 4 x i32> %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_u32,_m,)(pg, dest, idx, src);
}

smuint64_t test_smmovah_u64_m(svbool_t pg, smuint64_t dest, uint32_t idx, svuint64_t src) {
  // CHECK-LABEL: test_smmovah_u64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.mova.row.mxv4i64.nxv2i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i32 0, <vscale x 2 x i64> %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_u64,_m,)(pg, dest, idx, src);
}

smint8_t test_smmovah_s8_m(svbool_t pg, smint8_t dest, uint32_t idx, svint8_t src) {
  // CHECK-LABEL: test_smmovah_s8_m
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.mova.row.mxv256i8.nxv16i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i32 0, <vscale x 16 x i8> %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_s8,_m,)(pg, dest, idx, src);
}

smint16_t test_smmovah_s16_m(svbool_t pg, smint16_t dest, uint32_t idx, svint16_t src) {
  // CHECK-LABEL: test_smmovah_s16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.mova.row.mxv64i16.nxv8i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i32 0, <vscale x 8 x i16> %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_s16,_m,)(pg, dest, idx, src);
}

smint32_t test_smmovah_s32_m(svbool_t pg, smint32_t dest, uint32_t idx, svint32_t src) {
  // CHECK-LABEL: test_smmovah_s32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.mova.row.mxv16i32.nxv4i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i32 0, <vscale x 4 x i32> %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_s32,_m,)(pg, dest, idx, src);
}

smint64_t test_smmovah_s64_m(svbool_t pg, smint64_t dest, uint32_t idx, svint64_t src) {
  // CHECK-LABEL: test_smmovah_s64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.mova.row.mxv4i64.nxv2i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i32 0, <vscale x 2 x i64> %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_s64,_m,)(pg, dest, idx, src);
}

smfloat16_t test_smmovah_f16_m(svbool_t pg, smfloat16_t dest, uint32_t idx, svfloat16_t src) {
  // CHECK-LABEL: test_smmovah_f16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x half> @llvm.aarch64.sme.mova.row.mxv64f16.nxv8f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %dest, i32 %idx, i32 0, <vscale x 8 x half> %src)
  // CHECK: ret <mscale x 64 x half> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_f16,_m,)(pg, dest, idx, src);
}

smfloat32_t test_smmovah_f32_m(svbool_t pg, smfloat32_t dest, uint32_t idx, svfloat32_t src) {
  // CHECK-LABEL: test_smmovah_f32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.mova.row.mxv16f32.nxv4f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %dest, i32 %idx, i32 0, <vscale x 4 x float> %src)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_f32,_m,)(pg, dest, idx, src);
}

smfloat64_t test_smmovah_f64_m(svbool_t pg, smfloat64_t dest, uint32_t idx, svfloat64_t src) {
  // CHECK-LABEL: test_smmovah_f64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x double> @llvm.aarch64.sme.mova.row.mxv4f64.nxv2f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %dest, i32 %idx, i32 0, <vscale x 2 x double> %src)
  // CHECK: ret <mscale x 4 x double> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_f64,_m,)(pg, dest, idx, src);
}

smuint8_t test_smmovav_u8_m(svbool_t pg, smuint8_t dest, uint32_t idx, svuint8_t src) {
  // CHECK-LABEL: test_smmovav_u8_m
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.mova.col.mxv256i8.nxv16i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i32 0, <vscale x 16 x i8> %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_u8,_m,)(pg, dest, idx, src);
}

smuint16_t test_smmovav_u16_m(svbool_t pg, smuint16_t dest, uint32_t idx, svuint16_t src) {
  // CHECK-LABEL: test_smmovav_u16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.mova.col.mxv64i16.nxv8i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i32 0, <vscale x 8 x i16> %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_u16,_m,)(pg, dest, idx, src);
}

smuint32_t test_smmovav_u32_m(svbool_t pg, smuint32_t dest, uint32_t idx, svuint32_t src) {
  // CHECK-LABEL: test_smmovav_u32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.mova.col.mxv16i32.nxv4i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i32 0, <vscale x 4 x i32> %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_u32,_m,)(pg, dest, idx, src);
}

smuint64_t test_smmovav_u64_m(svbool_t pg, smuint64_t dest, uint32_t idx, svuint64_t src) {
  // CHECK-LABEL: test_smmovav_u64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.mova.col.mxv4i64.nxv2i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i32 0, <vscale x 2 x i64> %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_u64,_m,)(pg, dest, idx, src);
}

smint8_t test_smmovav_s8_m(svbool_t pg, smint8_t dest, uint32_t idx, svint8_t src) {
  // CHECK-LABEL: test_smmovav_s8_m
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.mova.col.mxv256i8.nxv16i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i32 0, <vscale x 16 x i8> %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_s8,_m,)(pg, dest, idx, src);
}

smint16_t test_smmovav_s16_m(svbool_t pg, smint16_t dest, uint32_t idx, svint16_t src) {
  // CHECK-LABEL: test_smmovav_s16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.mova.col.mxv64i16.nxv8i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i32 0, <vscale x 8 x i16> %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_s16,_m,)(pg, dest, idx, src);
}

smint32_t test_smmovav_s32_m(svbool_t pg, smint32_t dest, uint32_t idx, svint32_t src) {
  // CHECK-LABEL: test_smmovav_s32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.mova.col.mxv16i32.nxv4i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i32 0, <vscale x 4 x i32> %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_s32,_m,)(pg, dest, idx, src);
}

smint64_t test_smmovav_s64_m(svbool_t pg, smint64_t dest, uint32_t idx, svint64_t src) {
  // CHECK-LABEL: test_smmovav_s64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.mova.col.mxv4i64.nxv2i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i32 0, <vscale x 2 x i64> %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_s64,_m,)(pg, dest, idx, src);
}

smfloat16_t test_smmovav_f16_m(svbool_t pg, smfloat16_t dest, uint32_t idx, svfloat16_t src) {
  // CHECK-LABEL: test_smmovav_f16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x half> @llvm.aarch64.sme.mova.col.mxv64f16.nxv8f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %dest, i32 %idx, i32 0, <vscale x 8 x half> %src)
  // CHECK: ret <mscale x 64 x half> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_f16,_m,)(pg, dest, idx, src);
}

smfloat32_t test_smmovav_f32_m(svbool_t pg, smfloat32_t dest, uint32_t idx, svfloat32_t src) {
  // CHECK-LABEL: test_smmovav_f32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.mova.col.mxv16f32.nxv4f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %dest, i32 %idx, i32 0, <vscale x 4 x float> %src)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_f32,_m,)(pg, dest, idx, src);
}

smfloat64_t test_smmovav_f64_m(svbool_t pg, smfloat64_t dest, uint32_t idx, svfloat64_t src) {
  // CHECK-LABEL: test_smmovav_f64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x double> @llvm.aarch64.sme.mova.col.mxv4f64.nxv2f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %dest, i32 %idx, i32 0, <vscale x 2 x double> %src)
  // CHECK: ret <mscale x 4 x double> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_f64,_m,)(pg, dest, idx, src);
}
