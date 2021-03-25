// REQUIRES: aarch64-registered-target
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sme -fallow-half-arguments-and-returns -S -O1 -Werror -emit-llvm -o - %s | FileCheck %s

#include <arm_sve.h>

void test_smstart() {
  // CHECK-LABEL: test_smstart
  // CHECK: call void @llvm.aarch64.sme.start(i32 1)
  // CHECK: ret void
  smstart();
}

void test_smstop() {
  // CHECK-LABEL: test_smstop
  // CHECK: call void @llvm.aarch64.sme.stop(i32 1)
  // CHECK: ret void
  smstop();
}
