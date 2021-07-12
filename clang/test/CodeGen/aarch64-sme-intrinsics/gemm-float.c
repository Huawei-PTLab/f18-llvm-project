// REQUIRES: aarch64-registered-targe
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sme -fallow-half-arguments-and-returns -S -O1 -Werror -emit-llvm -o - %s | FileCheck %s

#include <stddef.h>

#if defined(__ARM_FEATURE_SME)
#include <arm_sve.h>
#endif

int GEMM(float *matA, float *matB, float *matC, int M, int N, int K)
{
    // CHECK-LABEL: GEMM
    // CHECK: call void @llvm.aarch64.sme.start(i32 1)
    smstart();
    // CHECK: [[VSCALE:.*]] = call i64 @llvm.aarch64.sve.cntw(i32 31)
    uint64_t vscale = svcntw();
    svbool_t pn, pm, pred;
    smfloat32_t za, zb;
    svfloat32_t src1, src2;

    for (size_t i = 0; i < M; i += vscale)
    {
        // CHECK-DAG: %1 = call <vscale x 4 x i1> @llvm.aarch64.sve.whilelo.nxv4i1.i64(i64 %i.0174, i64 %conv)
        // CHECK-DAG: %2 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> %1)
        pm = svwhilelt_b32_u64(i, M);
        for (size_t j = 0; j < N; j += vscale)
        {
            // CHECK-DAG: %3 = call <vscale x 4 x i1> @llvm.aarch64.sve.whilelo.nxv4i1.i64(i64 %j.0170, i64 %conv4)
            // CHECK-DAG: %4 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> %3)
            // CHECK-DAG: %5 = call <mscale x 16 x float> @llvm.aarch64.sme.zero.mxv16f32()
            pn = svwhilelt_b32_u64(j, N);
            za = smzero_f32();
            for (size_t k = 0; k < K; k += vscale)
            {
                // CHECK-DAG: %8 = call <vscale x 4 x i1> @llvm.aarch64.sve.whilelo.nxv4i1.i64(i64 %k.0160, i64 %conv11)
                // CHECK-DAG: %9 = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> %8)
                // CHECK-DAG: %10 = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %9)
                // CHECK-DAG: %7 = call <mscale x 16 x float> @llvm.aarch64.sme.zero.mxv16f32()
                pred = svwhilelt_b32_u64(k, K);
                zb = smzero_f32();
                for (size_t t = 0; t < vscale; t++)
                {
                    if (i + t == M)
                        break;
                    // CHECK-DAG: %13 = call <mscale x 16 x float> @llvm.aarch64.sme.ld1.row.mxv16f32(<vscale x 4 x i1> %10, <mscale x 16 x float> %zb.0147, i32 %conv25, i32 0, float* %add.ptr28)
                    zb = smld1h_f32(pred, zb, t, matA + K * (i + t) + k);
                }
                for (size_t t = 0; t < vscale; t++)
                {
                    if (k + t == K)
                        break;
                    // CHECK-DAG: %14 = call <vscale x 4 x float> @llvm.aarch64.sme.mova.vec.col.nxv4f32.mxv16f32(<vscale x 4 x i1> %11, <mscale x 16 x float> %zb.0.lcssa, i32 %conv41, i32 0)
                    // CHECK-DAG: %15 = call <vscale x 4 x float> @llvm.aarch64.sve.ld1.nxv4f32(<vscale x 4 x i1> %12, float* %add.ptr46)
                    // CHECK-DAG: %16 = call <mscale x 16 x float> @llvm.aarch64.sme.fmopa.mxv16f32.nxv4f32(<vscale x 4 x i1> %11, <vscale x 4 x i1> %12, <mscale x 16 x float> %za.1154, <vscale x 4 x float> %14, <vscale x 4 x float> %15)
                    src1 = smextractv_f32_m(pm, zb, t);
                    src2 = svld1_f32(pn, matB + (k + t) * K + j);
                    za = smmopa_f32_m(pm, pn, za, src1, src2);
                }
            }
            for (size_t t = 0; t < vscale; t++)
            {
                if (i + t == M)
                    break;
                // CHECK-DAG: call void @llvm.aarch64.sme.st1.row.mxv16f32(<vscale x 4 x i1> %6, <mscale x 16 x float> %za.0.lcssa, i32 %conv67, i32 0, float* %add.ptr72)
                smst1h_f32(pn, za, t, matC + M * (i + t) + j);
            }
        }
    }
    // CHECK-DAG: call void @llvm.aarch64.sme.stop(i32 1)
    smstop();
    return 0;
}
