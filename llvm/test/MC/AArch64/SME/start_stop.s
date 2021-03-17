// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST

smstart
// CHECK-INST: smstart
// CHECK-ENCODING: [0x7f,0x47,0x03,0xd5]

smstart za
// CHECK-INST: smstart za
// CHECK-ENCODING: [0x7f,0x45,0x03,0xd5]
smstart ZA
// CHECK-INST: smstart za
// CHECK-ENCODING: [0x7f,0x45,0x03,0xd5]

smstop
// CHECK-INST: smstop
// CHECK-ENCODING: [0x7f,0x46,0x03,0xd5]

smstop za
// CHECK-INST: smstop za
// CHECK-ENCODING: [0x7f,0x44,0x03,0xd5]
smstop ZA
// CHECK-INST: smstop za
// CHECK-ENCODING: [0x7f,0x44,0x03,0xd5]
