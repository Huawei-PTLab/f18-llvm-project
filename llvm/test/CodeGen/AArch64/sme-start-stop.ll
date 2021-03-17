; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -asm-verbose=0 < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

;
; SMSTART
;

define void @test_smstart() {
; CHECK-LABEL: test_smstart:
; CHECK-NEXT: .cfi_startproc
; CHECK-NEXT: smstart
; CHECK-NEXT: ret
  call void @llvm.aarch64.sme.start(i32 0)
  ret void
}

;
; SMSTART ZA
;

define void @test_smenableza() {
; CHECK-LABEL: test_smenableza:
; CHECK-NEXT: .cfi_startproc
; CHECK-NEXT: smstart za
; CHECK-NEXT: ret
  call void @llvm.aarch64.sme.start(i32 1)
  ret void
}

;
; SMSTOP
;

define void @test_smstop() {
; CHECK-LABEL: test_smstop:
; CHECK-NEXT: .cfi_startproc
; CHECK-NEXT: smstop
; CHECK-NEXT: ret
  call void @llvm.aarch64.sme.stop(i32 1)
  ret void
}

;
; SMSTOP ZA
;

define void @test_smdisableza() {
; CHECK-LABEL: test_smdisableza:
; CHECK-NEXT: .cfi_startproc
; CHECK-NEXT: smstop
; CHECK-NEXT: ret
  call void @llvm.aarch64.sme.stop(i32 0)
  ret void
}

declare void @llvm.aarch64.sme.start(i32)
declare void @llvm.aarch64.sme.stop(i32)
