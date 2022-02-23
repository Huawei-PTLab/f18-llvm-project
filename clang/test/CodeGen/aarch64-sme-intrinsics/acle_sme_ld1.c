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


smuint8_t test_smld1h_u8(svbool_t pg, smuint8_t dest, uint32_t idx, uint8_t const *src) {
  // CHECK-LABEL: test_smld1h_u8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.ld1.row.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i64 0, i8* %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_u8,,)(pg, dest, idx, src);
}

smuint16_t test_smld1h_u16(svbool_t pg, smuint16_t dest, uint32_t idx, uint16_t const *src) {
  // CHECK-LABEL: test_smld1h_u16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.ld1.row.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i64 0, i16* %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_u16,,)(pg, dest, idx, src);
}

smuint32_t test_smld1h_u32(svbool_t pg, smuint32_t dest, uint32_t idx, uint32_t const *src) {
  // CHECK-LABEL: test_smld1h_u32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.ld1.row.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i64 0, i32* %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_u32,,)(pg, dest, idx, src);
}

smuint64_t test_smld1h_u64(svbool_t pg, smuint64_t dest, uint32_t idx, uint64_t const *src) {
  // CHECK-LABEL: test_smld1h_u64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.row.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i64 0, i64* %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_u64,,)(pg, dest, idx, src);
}

smint8_t test_smld1h_s8(svbool_t pg, smint8_t dest, uint32_t idx, int8_t const *src) {
  // CHECK-LABEL: test_smld1h_s8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.ld1.row.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i64 0, i8* %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_s8,,)(pg, dest, idx, src);
}

smint16_t test_smld1h_s16(svbool_t pg, smint16_t dest, uint32_t idx, int16_t const *src) {
  // CHECK-LABEL: test_smld1h_s16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.ld1.row.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i64 0, i16* %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_s16,,)(pg, dest, idx, src);
}

smint32_t test_smld1h_s32(svbool_t pg, smint32_t dest, uint32_t idx, int32_t const *src) {
  // CHECK-LABEL: test_smld1h_s32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.ld1.row.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i64 0, i32* %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_s32,,)(pg, dest, idx, src);
}

smint64_t test_smld1h_s64(svbool_t pg, smint64_t dest, uint32_t idx, int64_t const *src) {
  // CHECK-LABEL: test_smld1h_s64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.row.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i64 0, i64* %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_s64,,)(pg, dest, idx, src);
}

smfloat16_t test_smld1h_f16(svbool_t pg, smfloat16_t dest, uint32_t idx, float16_t const *src) {
  // CHECK-LABEL: test_smld1h_f16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x half> @llvm.aarch64.sme.ld1.row.mxv64f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %dest, i32 %idx, i64 0, half* %src)
  // CHECK: ret <mscale x 64 x half> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_f16,,)(pg, dest, idx, src);
}

smfloat32_t test_smld1h_f32(svbool_t pg, smfloat32_t dest, uint32_t idx, float32_t const *src) {
  // CHECK-LABEL: test_smld1h_f32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.ld1.row.mxv16f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %dest, i32 %idx, i64 0, float* %src)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_f32,,)(pg, dest, idx, src);
}

smfloat64_t test_smld1h_f64(svbool_t pg, smfloat64_t dest, uint32_t idx, float64_t const *src) {
  // CHECK-LABEL: test_smld1h_f64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x double> @llvm.aarch64.sme.ld1.row.mxv4f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %dest, i32 %idx, i64 0, double* %src)
  // CHECK: ret <mscale x 4 x double> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1h,_f64,,)(pg, dest, idx, src);
}

smuint8_t test_smld1v_u8(svbool_t pg, smuint8_t dest, uint32_t idx, uint8_t const *src) {
  // CHECK-LABEL: test_smld1v_u8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.ld1.col.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i64 0, i8* %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_u8,,)(pg, dest, idx, src);
}

smuint16_t test_smld1v_u16(svbool_t pg, smuint16_t dest, uint32_t idx, uint16_t const *src) {
  // CHECK-LABEL: test_smld1v_u16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.ld1.col.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i64 0, i16* %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_u16,,)(pg, dest, idx, src);
}

smuint32_t test_smld1v_u32(svbool_t pg, smuint32_t dest, uint32_t idx, uint32_t const *src) {
  // CHECK-LABEL: test_smld1v_u32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.ld1.col.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i64 0, i32* %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_u32,,)(pg, dest, idx, src);
}

smuint64_t test_smld1v_u64(svbool_t pg, smuint64_t dest, uint32_t idx, uint64_t const *src) {
  // CHECK-LABEL: test_smld1v_u64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.col.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i64 0, i64* %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_u64,,)(pg, dest, idx, src);
}

smint8_t test_smld1v_s8(svbool_t pg, smint8_t dest, uint32_t idx, int8_t const *src) {
  // CHECK-LABEL: test_smld1v_s8
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 256 x i8> @llvm.aarch64.sme.ld1.col.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %dest, i32 %idx, i64 0, i8* %src)
  // CHECK: ret <mscale x 256 x i8> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_s8,,)(pg, dest, idx, src);
}

smint16_t test_smld1v_s16(svbool_t pg, smint16_t dest, uint32_t idx, int16_t const *src) {
  // CHECK-LABEL: test_smld1v_s16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x i16> @llvm.aarch64.sme.ld1.col.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %dest, i32 %idx, i64 0, i16* %src)
  // CHECK: ret <mscale x 64 x i16> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_s16,,)(pg, dest, idx, src);
}

smint32_t test_smld1v_s32(svbool_t pg, smint32_t dest, uint32_t idx, int32_t const *src) {
  // CHECK-LABEL: test_smld1v_s32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x i32> @llvm.aarch64.sme.ld1.col.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %dest, i32 %idx, i64 0, i32* %src)
  // CHECK: ret <mscale x 16 x i32> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_s32,,)(pg, dest, idx, src);
}

smint64_t test_smld1v_s64(svbool_t pg, smint64_t dest, uint32_t idx, int64_t const *src) {
  // CHECK-LABEL: test_smld1v_s64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x i64> @llvm.aarch64.sme.ld1.col.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %dest, i32 %idx, i64 0, i64* %src)
  // CHECK: ret <mscale x 4 x i64> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_s64,,)(pg, dest, idx, src);
}

smfloat16_t test_smld1v_f16(svbool_t pg, smfloat16_t dest, uint32_t idx, float16_t const *src) {
  // CHECK-LABEL: test_smld1v_f16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 64 x half> @llvm.aarch64.sme.ld1.col.mxv64f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %dest, i32 %idx, i64 0, half* %src)
  // CHECK: ret <mscale x 64 x half> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_f16,,)(pg, dest, idx, src);
}

smfloat32_t test_smld1v_f32(svbool_t pg, smfloat32_t dest, uint32_t idx, float32_t const *src) {
  // CHECK-LABEL: test_smld1v_f32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 16 x float> @llvm.aarch64.sme.ld1.col.mxv16f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %dest, i32 %idx, i64 0, float* %src)
  // CHECK: ret <mscale x 16 x float> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_f32,,)(pg, dest, idx, src);
}

smfloat64_t test_smld1v_f64(svbool_t pg, smfloat64_t dest, uint32_t idx, float64_t const *src) {
  // CHECK-LABEL: test_smld1v_f64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: %[[INTRINSIC:.*]] = call <mscale x 4 x double> @llvm.aarch64.sme.ld1.col.mxv4f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %dest, i32 %idx, i64 0, double* %src)
  // CHECK: ret <mscale x 4 x double> %[[INTRINSIC]]
  return SME_ACLE_FUNC(smld1v,_f64,,)(pg, dest, idx, src);
}
