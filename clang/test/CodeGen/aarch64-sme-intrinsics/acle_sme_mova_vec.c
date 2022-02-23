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


svuint8_t test_smmovah_vec_u8_m(svbool_t pg, smuint8_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_u8_m
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.row.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 16 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_u8,_m,)(pg, src, idx);
}

svuint16_t test_smmovah_vec_u16_m(svbool_t pg, smuint16_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_u16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 8 x i16> @llvm.aarch64.sme.mova.vec.row.nxv8i16.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 8 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_u16,_m,)(pg, src, idx);
}

svuint32_t test_smmovah_vec_u32_m(svbool_t pg, smuint32_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_u32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 4 x i32> @llvm.aarch64.sme.mova.vec.row.nxv4i32.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 4 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_u32,_m,)(pg, src, idx);
}

svuint64_t test_smmovah_vec_u64_m(svbool_t pg, smuint64_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_u64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 2 x i64> @llvm.aarch64.sme.mova.vec.row.nxv2i64.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 2 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_u64,_m,)(pg, src, idx);
}

svint8_t test_smmovah_vec_s8_m(svbool_t pg, smint8_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_s8_m
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.row.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 16 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_s8,_m,)(pg, src, idx);
}

svint16_t test_smmovah_vec_s16_m(svbool_t pg, smint16_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_s16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 8 x i16> @llvm.aarch64.sme.mova.vec.row.nxv8i16.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 8 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_s16,_m,)(pg, src, idx);
}

svint32_t test_smmovah_vec_s32_m(svbool_t pg, smint32_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_s32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 4 x i32> @llvm.aarch64.sme.mova.vec.row.nxv4i32.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 4 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_s32,_m,)(pg, src, idx);
}

svint64_t test_smmovah_vec_s64_m(svbool_t pg, smint64_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_s64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 2 x i64> @llvm.aarch64.sme.mova.vec.row.nxv2i64.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 2 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_s64,_m,)(pg, src, idx);
}

svfloat16_t test_smmovah_vec_f16_m(svbool_t pg, smfloat16_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_f16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 8 x half> @llvm.aarch64.sme.mova.vec.row.nxv8f16.mxv64f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 8 x half> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_f16,_m,)(pg, src, idx);
}

svfloat32_t test_smmovah_vec_f32_m(svbool_t pg, smfloat32_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_f32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 4 x float> @llvm.aarch64.sme.mova.vec.row.nxv4f32.mxv16f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 4 x float> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_f32,_m,)(pg, src, idx);
}

svfloat64_t test_smmovah_vec_f64_m(svbool_t pg, smfloat64_t src, uint32_t idx) {
  // CHECK: test_smmovah_vec_f64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 2 x double> @llvm.aarch64.sme.mova.vec.row.nxv2f64.mxv4f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 2 x double> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovah,_vec_f64,_m,)(pg, src, idx);
}

svuint8_t test_smmovav_vec_u8_m(svbool_t pg, smuint8_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_u8_m
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.col.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 16 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_u8,_m,)(pg, src, idx);
}

svuint16_t test_smmovav_vec_u16_m(svbool_t pg, smuint16_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_u16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 8 x i16> @llvm.aarch64.sme.mova.vec.col.nxv8i16.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 8 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_u16,_m,)(pg, src, idx);
}

svuint32_t test_smmovav_vec_u32_m(svbool_t pg, smuint32_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_u32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 4 x i32> @llvm.aarch64.sme.mova.vec.col.nxv4i32.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 4 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_u32,_m,)(pg, src, idx);
}

svuint64_t test_smmovav_vec_u64_m(svbool_t pg, smuint64_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_u64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 2 x i64> @llvm.aarch64.sme.mova.vec.col.nxv2i64.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 2 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_u64,_m,)(pg, src, idx);
}

svint8_t test_smmovav_vec_s8_m(svbool_t pg, smint8_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_s8_m
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 16 x i8> @llvm.aarch64.sme.mova.vec.col.nxv16i8.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 16 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_s8,_m,)(pg, src, idx);
}

svint16_t test_smmovav_vec_s16_m(svbool_t pg, smint16_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_s16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 8 x i16> @llvm.aarch64.sme.mova.vec.col.nxv8i16.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 8 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_s16,_m,)(pg, src, idx);
}

svint32_t test_smmovav_vec_s32_m(svbool_t pg, smint32_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_s32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 4 x i32> @llvm.aarch64.sme.mova.vec.col.nxv4i32.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 4 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_s32,_m,)(pg, src, idx);
}

svint64_t test_smmovav_vec_s64_m(svbool_t pg, smint64_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_s64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 2 x i64> @llvm.aarch64.sme.mova.vec.col.nxv2i64.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 2 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_s64,_m,)(pg, src, idx);
}

svfloat16_t test_smmovav_vec_f16_m(svbool_t pg, smfloat16_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_f16_m
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 8 x half> @llvm.aarch64.sme.mova.vec.col.nxv8f16.mxv64f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 8 x half> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_f16,_m,)(pg, src, idx);
}

svfloat32_t test_smmovav_vec_f32_m(svbool_t pg, smfloat32_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_f32_m
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 4 x float> @llvm.aarch64.sme.mova.vec.col.nxv4f32.mxv16f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 4 x float> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_f32,_m,)(pg, src, idx);
}

svfloat64_t test_smmovav_vec_f64_m(svbool_t pg, smfloat64_t src, uint32_t idx) {
  // CHECK: test_smmovav_vec_f64_m
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <vscale x 2 x double> @llvm.aarch64.sme.mova.vec.col.nxv2f64.mxv4f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %src, i32 %idx, i64 0)
  // CHECK: ret <vscale x 2 x double> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smmovav,_vec_f64,_m,)(pg, src, idx);
}
