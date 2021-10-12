; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+sme-i64,+sve -asm-verbose=0 --stop-after=finalize-isel -O1 < %s -o - 2>%t | FileCheck %s

define <mscale x 4 x i64> @test_liveincopy(<mscale x 4 x i64> %za, <mscale x 4 x i64> %zb) {
; CHECK: [[ARG1:%[0-9]+]]:mpr64 = SMECOPY_D $zad1
; CHECK: [[ARG2:%[0-9]+]]:mpr64 = SMECOPY_D [[ARG1]]
; CHECK: [[ARG3:%[0-9]+]]:mpr64 =  ADDHA_MPPZ_D %7, %7, [[ARG2]], %9

  %1 =  call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> undef)
  %2 = call <mscale x 4 x i64> @llvm.aarch64.sme.addha.mxv4i64.nxv2i64(<vscale x 2 x i1> %1, <vscale x 2 x i1> %1, <mscale x 4 x i64> %zb, <vscale x 2 x i64> undef)
  ret <mscale x 4 x i64> %2
}

declare <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1>)
declare <mscale x 4 x i64> @llvm.aarch64.sme.addha.mxv4i64.nxv2i64(<vscale x 2 x i1>, <vscale x 2 x i1>, <mscale x 4 x i64>, <vscale x 2 x i64>)
