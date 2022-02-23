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


void test_smst1h_u8(svbool_t pg, smuint8_t src, uint32_t idx, uint8_t *dest) {
  // CHECK-LABEL: test_smst1h_u8
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0, i8* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_u8,,)(pg, src, idx, dest);
}

void test_smst1h_u16(svbool_t pg, smuint16_t src, uint32_t idx, uint16_t *dest) {
  // CHECK-LABEL: test_smst1h_u16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0, i16* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_u16,,)(pg, src, idx, dest);
}

void test_smst1h_u32(svbool_t pg, smuint32_t src, uint32_t idx, uint32_t *dest) {
  // CHECK-LABEL: test_smst1h_u32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0, i32* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_u32,,)(pg, src, idx, dest);
}

void test_smst1h_u64(svbool_t pg, smuint64_t src, uint32_t idx, uint64_t *dest) {
  // CHECK-LABEL: test_smst1h_u64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0, i64* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_u64,,)(pg, src, idx, dest);
}

void test_smst1h_s8(svbool_t pg, smint8_t src, uint32_t idx, int8_t *dest) {
  // CHECK-LABEL: test_smst1h_s8
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0, i8* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_s8,,)(pg, src, idx, dest);
}

void test_smst1h_s16(svbool_t pg, smint16_t src, uint32_t idx, int16_t *dest) {
  // CHECK-LABEL: test_smst1h_s16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0, i16* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_s16,,)(pg, src, idx, dest);
}

void test_smst1h_s32(svbool_t pg, smint32_t src, uint32_t idx, int32_t *dest) {
  // CHECK-LABEL: test_smst1h_s32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0, i32* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_s32,,)(pg, src, idx, dest);
}

void test_smst1h_s64(svbool_t pg, smint64_t src, uint32_t idx, int64_t *dest) {
  // CHECK-LABEL: test_smst1h_s64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0, i64* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_s64,,)(pg, src, idx, dest);
}

void test_smst1h_f16(svbool_t pg, smfloat16_t src, uint32_t idx, float16_t *dest) {
  // CHECK-LABEL: test_smst1h_f16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv64f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %src, i32 %idx, i64 0, half* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_f16,,)(pg, src, idx, dest);
}

void test_smst1h_f32(svbool_t pg, smfloat32_t src, uint32_t idx, float32_t *dest) {
  // CHECK-LABEL: test_smst1h_f32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %src, i32 %idx, i64 0, float* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_f32,,)(pg, src, idx, dest);
}

void test_smst1h_f64(svbool_t pg, smfloat64_t src, uint32_t idx, float64_t *dest) {
  // CHECK-LABEL: test_smst1h_f64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.row.mxv4f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %src, i32 %idx, i64 0, double* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1h,_f64,,)(pg, src, idx, dest);
}

void test_smst1v_u8(svbool_t pg, smuint8_t src, uint32_t idx, uint8_t *dest) {
  // CHECK-LABEL: test_smst1v_u8
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0, i8* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_u8,,)(pg, src, idx, dest);
}

void test_smst1v_u16(svbool_t pg, smuint16_t src, uint32_t idx, uint16_t *dest) {
  // CHECK-LABEL: test_smst1v_u16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0, i16* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_u16,,)(pg, src, idx, dest);
}

void test_smst1v_u32(svbool_t pg, smuint32_t src, uint32_t idx, uint32_t *dest) {
  // CHECK-LABEL: test_smst1v_u32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0, i32* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_u32,,)(pg, src, idx, dest);
}

void test_smst1v_u64(svbool_t pg, smuint64_t src, uint32_t idx, uint64_t *dest) {
  // CHECK-LABEL: test_smst1v_u64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0, i64* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_u64,,)(pg, src, idx, dest);
}

void test_smst1v_s8(svbool_t pg, smint8_t src, uint32_t idx, int8_t *dest) {
  // CHECK-LABEL: test_smst1v_s8
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv256i8(<vscale x 16 x i1> %pg, <mscale x 256 x i8> %src, i32 %idx, i64 0, i8* %dest)
  // CHECK: ret void
   SME_ACLE_FUNC(smst1v,_s8,,)(pg, src, idx, dest);
}

void test_smst1v_s16(svbool_t pg, smint16_t src, uint32_t idx, int16_t *dest) {
  // CHECK-LABEL: test_smst1v_s16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv64i16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x i16> %src, i32 %idx, i64 0, i16* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_s16,,)(pg, src, idx, dest);
}

void test_smst1v_s32(svbool_t pg, smint32_t src, uint32_t idx, int32_t *dest) {
  // CHECK-LABEL: test_smst1v_s32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv16i32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x i32> %src, i32 %idx, i64 0, i32* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_s32,,)(pg, src, idx, dest);
}

void test_smst1v_s64(svbool_t pg, smint64_t src, uint32_t idx, int64_t *dest) {
  // CHECK-LABEL: test_smst1v_s64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv4i64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x i64> %src, i32 %idx, i64 0, i64* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_s64,,)(pg, src, idx, dest);
}

void test_smst1v_f16(svbool_t pg, smfloat16_t src, uint32_t idx, float16_t *dest) {
  // CHECK-LABEL: test_smst1v_f16
  // CHECK: %[[PG:.*]] = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv64f16(<vscale x 8 x i1> %[[PG]], <mscale x 64 x half> %src, i32 %idx, i64 0, half* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_f16,,)(pg, src, idx, dest);
}

void test_smst1v_f32(svbool_t pg, smfloat32_t src, uint32_t idx, float32_t *dest) {
  // CHECK-LABEL: test_smst1v_f32
  // CHECK: %[[PG:.*]] = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv16f32(<vscale x 4 x i1> %[[PG]], <mscale x 16 x float> %src, i32 %idx, i64 0, float* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_f32,,)(pg, src, idx, dest);
}

void test_smst1v_f64(svbool_t pg, smfloat64_t src, uint32_t idx, float64_t *dest) {
  // CHECK-LABEL: test_smst1v_f64
  // CHECK: %[[PG:.*]] = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  // CHECK: call void @llvm.aarch64.sme.st1.col.mxv4f64(<vscale x 2 x i1> %[[PG]], <mscale x 4 x double> %src, i32 %idx, i64 0, double* %dest)
  // CHECK: ret void
  SME_ACLE_FUNC(smst1v,_f64,,)(pg, src, idx, dest);
}
