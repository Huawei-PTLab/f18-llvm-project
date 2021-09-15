//=-- SMEInstrFormats.td -  AArch64 SME Instruction classes -*- tablegen -*--=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// AArch64 Scalable Matrix Extension (SME) Instruction Class Definitions.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// SME Outer Products
//===----------------------------------------------------------------------===//

class SME_5_Op_Pat<ValueType vtd, SDPatternOperator op, ValueType vt1,
                   ValueType vt2, ValueType vt3, ValueType vt4, ValueType vt5,
                   Instruction inst>
: Pat<(vtd (op vt1:$op1, vt2:$op2, vt3:$op3, vt4:$op4, vt5:$op5)),
      (inst vt1:$op1, vt2:$op2, vt3:$op3, vt4:$op4, vt5:$op5)>;

class sme_fp_outer_product_inst<bit S, bit sz, MatrixTileOperand za_ty,
                                ZPRRegOp zpr_ty, string mnemonic>
    : I<(outs za_ty:$ZAda),
        (ins PPR3bAny:$Pn, PPR3bAny:$Pm, za_ty:$_ZAda, zpr_ty:$Zn, zpr_ty:$Zm),
        mnemonic, "\t$ZAda, $Pn/m, $Pm/m, $Zn, $Zm",
        "", []>,
      Sched<[]> {
  bits<5> Zm;
  bits<3> Pm;
  bits<3> Pn;
  bits<5> Zn;
  let Inst{31-23} = 0b100000001;
  let Inst{22}    = sz;
  let Inst{21}    = 0b0;
  let Inst{20-16} = Zm;
  let Inst{15-13} = Pm;
  let Inst{12-10} = Pn;
  let Inst{9-5}   = Zn;
  let Inst{4}     = S;
  let Inst{3}     = 0b0;

  let Constraints = "$ZAda = $_ZAda";
}

class sme_outer_product_fp32<bit S, string mnemonic>
    : sme_fp_outer_product_inst<S, 0b0, TileOp32, ZPR32, mnemonic> {
  bits<2> ZAda;
  let Inst{1-0} = ZAda;
  let Inst{2}   = 0b0;
}

multiclass sme_outer_product_fp32<bit S, string mnemonic, SDPatternOperator op> {
  def NAME : sme_outer_product_fp32<S, mnemonic>;
  def : SME_5_Op_Pat<mxv16f32, op, nxv4i1, nxv4i1, mxv16f32,  nxv4f32, nxv4f32,  !cast<Instruction>(NAME)>;
}

class sme_outer_product_fp64<bit S, string mnemonic>
    : sme_fp_outer_product_inst<S, 0b1, TileOp64, ZPR64, mnemonic> {
  bits<3> ZAda;
  let Inst{2-0} = ZAda;
}

multiclass sme_outer_product_fp64<bit S, string mnemonic, SDPatternOperator op> {
  def NAME : sme_outer_product_fp64<S, mnemonic>;
  def : SME_5_Op_Pat<mxv4f64,  op, nxv2i1, nxv2i1, mxv4f64, nxv2f64, nxv2f64, !cast<Instruction>(NAME)>;
}

class sme_int_outer_product_inst<bit u0, bit u1, bit S, bit sz,
                                 MatrixTileOperand za_ty, ZPRRegOp zpr_ty,
                                 string mnemonic>
    : I<(outs za_ty:$ZAda),
        (ins PPR3bAny:$Pn, PPR3bAny:$Pm, za_ty:$_ZAda, zpr_ty:$Zn, zpr_ty:$Zm),
        mnemonic, "\t$ZAda, $Pn/m, $Pm/m, $Zn, $Zm",
        "", []>,
      Sched<[]> {
  bits<5> Zm;
  bits<3> Pm;
  bits<3> Pn;
  bits<5> Zn;
  let Inst{31-25} = 0b1010000;
  let Inst{24}    = u0;
  let Inst{23}    = 0b1;
  let Inst{22}    = sz;
  let Inst{21}    = u1;
  let Inst{20-16} = Zm;
  let Inst{15-13} = Pm;
  let Inst{12-10} = Pn;
  let Inst{9-5}   = Zn;
  let Inst{4}     = S;
  let Inst{3}     = 0b0;

  let Constraints = "$ZAda = $_ZAda";
}

class sme_int_outer_product_i32<bits<3> opc, string mnemonic>
    : sme_int_outer_product_inst<opc{2}, opc{1}, opc{0}, 0b0, TileOp32, ZPR8,
                                 mnemonic> {
  bits<2> ZAda;
  let Inst{1-0} = ZAda;
  let Inst{2}   = 0b0;
}

multiclass sme_int_outer_product_i32<bits<3> opc, string mnemonic, SDPatternOperator op> {
  def NAME : sme_int_outer_product_i32<opc, mnemonic>;
  def : SME_5_Op_Pat<mxv16i32, op, nxv16i1, nxv16i1, mxv16i32, nxv16i8, nxv16i8, !cast<Instruction>(NAME)>;
}

class sme_int_outer_product_i64<bits<3> opc, string mnemonic>
    : sme_int_outer_product_inst<opc{2}, opc{1}, opc{0}, 0b1, TileOp64, ZPR16,
                                 mnemonic> {
  bits<3> ZAda;
  let Inst{2-0} = ZAda;
}

multiclass sme_int_outer_product_i64<bits<3> opc, string mnemonic, SDPatternOperator op> {
  def NAME: sme_int_outer_product_i64<opc, mnemonic>;
  def : SME_5_Op_Pat<mxv4i64, op, nxv8i1,  nxv8i1, mxv4i64, nxv8i16, nxv8i16, !cast<Instruction>(NAME)>;
}

class sme_outer_product_widening_inst<bit op, bit S, string mnemonic>
    : I<(outs TileOp32:$ZAda),
        (ins PPR3bAny:$Pn, PPR3bAny:$Pm, TileOp32:$_ZAda, ZPR16:$Zn, ZPR16:$Zm),
        mnemonic, "\t$ZAda, $Pn/m, $Pm/m, $Zn, $Zm",
        "", []>,
      Sched<[]> {
  bits<5> Zm;
  bits<3> Pm;
  bits<3> Pn;
  bits<5> Zn;
  bits<2> ZAda;
  let Inst{31-22} = 0b1000000110;
  let Inst{21}    = op;
  let Inst{20-16} = Zm;
  let Inst{15-13} = Pm;
  let Inst{12-10} = Pn;
  let Inst{9-5}   = Zn;
  let Inst{4}     = S;
  let Inst{3-2}   = 0b00;
  let Inst{1-0}   = ZAda;

  let Constraints = "$ZAda = $_ZAda";
}

multiclass sme_bf16_outer_product<bit S, string mnemonic, SDPatternOperator op> {
  def NAME: sme_outer_product_widening_inst<0b0, S, mnemonic>;
  def : SME_5_Op_Pat<mxv16f32, op, nxv8i1, nxv8i1, mxv16f32, nxv8bf16, nxv8bf16, !cast<Instruction>(NAME)>;
}

multiclass sme_f16_outer_product<bit S, string mnemonic, SDPatternOperator op> {
  def NAME: sme_outer_product_widening_inst<0b1, S, mnemonic>;
  def : SME_5_Op_Pat<mxv16f32, op, nxv8i1, nxv8i1, mxv16f32, nxv8f16,  nxv8f16,  !cast<Instruction>(NAME)>;
}

//===----------------------------------------------------------------------===//
// SME Add Vector to Tile
//===----------------------------------------------------------------------===//

class sme_add_vector_to_tile_inst<bit op, bit V, MatrixTileOperand tile_ty,
                                  ZPRRegOp zpr_ty, string mnemonic>
    : I<(outs tile_ty:$ZAda),
        (ins PPR3bAny:$Pn, PPR3bAny:$Pm, tile_ty:$_ZAda, zpr_ty:$Zn),
        mnemonic, "\t$ZAda, $Pn/m, $Pm/m, $Zn",
        "", []>, Sched<[]> {
  bits<3> Pm;
  bits<3> Pn;
  bits<5> Zn;
  let Inst{31-23} = 0b110000001;
  let Inst{22}    = op;
  let Inst{21-17} = 0b01000;
  let Inst{16}    = V;
  let Inst{15-13} = Pm;
  let Inst{12-10} = Pn;
  let Inst{9-5}   = Zn;
  let Inst{4-3}   = 0b00;

  let Constraints = "$ZAda = $_ZAda";
}

class sme_add_vector_to_tile_u32<bit V, string mnemonic>
    : sme_add_vector_to_tile_inst<0b0, V, TileOp32, ZPR32, mnemonic> {
  bits<2> ZAda;
  let Inst{2}   = 0b0;
  let Inst{1-0} = ZAda;
}

class sme_add_vector_to_tile_u64<bit V, string mnemonic>
    : sme_add_vector_to_tile_inst<0b1, V, TileOp64, ZPR64, mnemonic> {
  bits<3> ZAda;
  let Inst{2-0} = ZAda;
}

//===----------------------------------------------------------------------===//
// SME Contiguous Loads
//===----------------------------------------------------------------------===//

class sme_mem_ld_ss_base<bit Q, bit V, bits<2> msz, dag outs, dag ins,
                         string mnemonic, string argstr>
    : I<outs, ins, mnemonic, argstr, "", []>, Sched<[]> {
  bits<5> Rm;
  bits<2> Rv;
  bits<3> Pg;
  bits<5> Rn;
  let Inst{31-25} = 0b1110000;
  let Inst{24}    = Q;
  let Inst{23-22} = msz;
  let Inst{21}    = 0b0;
  let Inst{20-16} = Rm;
  let Inst{15}    = V;
  let Inst{14-13} = Rv;
  let Inst{12-10} = Pg;
  let Inst{9-5}   = Rn;
  let Inst{4}     = 0b0;

  let mayLoad = 1;
  let Constraints = "$ZAt = $_ZAt";
}

class sme_mem_ld_ss_inst<bit Q, bits<2> msz, string mnemonic,
                         MatrixTileVectorOperand tile_ty, bit is_col,
                         Operand imm_ty, RegisterOperand gpr_ty>
    : sme_mem_ld_ss_base<
        Q, is_col, msz, (outs tile_ty:$ZAt),
        (ins tile_ty:$_ZAt, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm, PPR3bAny:$Pg, GPR64sp:$Rn,
             gpr_ty:$Rm),
        mnemonic, "\t\\{$ZAt[$Rv, $imm]\\}, $Pg/z, [$Rn, $Rm]">;

multiclass sme_mem_ss_aliases_base<string mnemonic, Instruction inst,
                                   MatrixTileVectorOperand tile_ty,
                                   Operand imm_ty, RegisterOperand gpr_ty,
                                   string pg_suffix=""> {
  def : InstAlias<mnemonic # "\t$ZAt[$Rv, $imm], $Pg" # pg_suffix # ", [$Rn, $Rm]",
                  (inst tile_ty:$ZAt, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm, PPR3bAny:$Pg, GPR64sp:$Rn, gpr_ty:$Rm), 0>;
  // Default XZR offset aliases
  def : InstAlias<mnemonic # "\t\\{$ZAt[$Rv, $imm]\\}, $Pg" # pg_suffix # ", [$Rn]",
                  (inst tile_ty:$ZAt, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm, PPR3bAny:$Pg, GPR64sp:$Rn, XZR), 1>;
  def : InstAlias<mnemonic # "\t$ZAt[$Rv, $imm], $Pg" # pg_suffix # ", [$Rn]",
                  (inst tile_ty:$ZAt, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm, PPR3bAny:$Pg, GPR64sp:$Rn, XZR), 0>;
}

multiclass sme_mem_ss_aliases<string mnemonic, string inst, bit is_col,
                              string pg_suffix=""> {
  defm : sme_mem_ss_aliases_base<mnemonic # "b", !cast<Instruction>(inst # _B),
                                 !if(is_col, TileVectorOpV8, TileVectorOpH8),
                                 sme_elm_idx0_15, GPR64shifted8, pg_suffix>;
  defm : sme_mem_ss_aliases_base<mnemonic # "h", !cast<Instruction>(inst # _H),
                                 !if(is_col, TileVectorOpV16, TileVectorOpH16),
                                 sme_elm_idx0_7, GPR64shifted16, pg_suffix>;
  defm : sme_mem_ss_aliases_base<mnemonic # "w", !cast<Instruction>(inst # _S),
                                 !if(is_col, TileVectorOpV32, TileVectorOpH32),
                                 sme_elm_idx0_3, GPR64shifted32, pg_suffix>;
  defm : sme_mem_ss_aliases_base<mnemonic # "d", !cast<Instruction>(inst # _D),
                                 !if(is_col, TileVectorOpV64, TileVectorOpH64),
                                 sme_elm_idx0_1, GPR64shifted64, pg_suffix>;
  defm : sme_mem_ss_aliases_base<mnemonic # "q", !cast<Instruction>(inst # _Q),
                                 !if(is_col, TileVectorOpV128, TileVectorOpH128),
                                 sme_elm_idx0_0, GPR64shifted128, pg_suffix>;
}

multiclass sme_mem_ld_ss_aliases<string inst, bit is_col> {
  defm NAME : sme_mem_ss_aliases<"ld1", inst, is_col, "/z">;
}

multiclass sme_mem_ld_v_ss<string mnemonic, bit is_col> {
  def _B : sme_mem_ld_ss_inst<0b0, 0b00, mnemonic # "b",
                              !if(is_col, TileVectorOpV8, TileVectorOpH8),
                              is_col, sme_elm_idx0_15, GPR64shifted8> {
    bits<4> imm;
    let Inst{3-0} = imm;
  }
  def _H : sme_mem_ld_ss_inst<0b0, 0b01, mnemonic # "h",
                              !if(is_col, TileVectorOpV16, TileVectorOpH16),
                              is_col, sme_elm_idx0_7, GPR64shifted16> {
    bits<1> ZAt;
    bits<3> imm;
    let Inst{3}   = ZAt;
    let Inst{2-0} = imm;
  }
  def _S : sme_mem_ld_ss_inst<0b0, 0b10, mnemonic # "w",
                              !if(is_col, TileVectorOpV32, TileVectorOpH32),
                              is_col, sme_elm_idx0_3, GPR64shifted32> {
    bits<2> ZAt;
    bits<2> imm;
    let Inst{3-2} = ZAt;
    let Inst{1-0} = imm;
  }
  def _D : sme_mem_ld_ss_inst<0b0, 0b11, mnemonic # "d",
                              !if(is_col, TileVectorOpV64, TileVectorOpH64),
                              is_col, sme_elm_idx0_1, GPR64shifted64> {
    bits<3> ZAt;
    bits<1> imm;
    let Inst{3-1} = ZAt;
    let Inst{0}   = imm;
  }
  def _Q : sme_mem_ld_ss_inst<0b1, 0b11, mnemonic # "q",
                              !if(is_col, TileVectorOpV128, TileVectorOpH128),
                              is_col, sme_elm_idx0_0, GPR64shifted128> {
    bits<4> ZAt;
    let Inst{3-0} = ZAt;
  }

  defm : sme_mem_ld_ss_aliases<NAME, is_col>;
}

multiclass sme_mem_ld_ss<string mnemonic> {
  defm _H : sme_mem_ld_v_ss<mnemonic, /*is_col=*/0b0>;
  defm _V : sme_mem_ld_v_ss<mnemonic, /*is_col=*/0b1>;
}

//===----------------------------------------------------------------------===//
// SME Contiguous Stores
//===----------------------------------------------------------------------===//

class sme_mem_st_ss_base<bit Q, bit V, bits<2> msz, dag ins,
                         string mnemonic, string argstr>
    : I<(outs), ins, mnemonic, argstr, "", []>, Sched<[]> {
  bits<5> Rm;
  bits<2> Rv;
  bits<3> Pg;
  bits<5> Rn;
  let Inst{31-25} = 0b1110000;
  let Inst{24}    = Q;
  let Inst{23-22} = msz;
  let Inst{21}    = 0b1;
  let Inst{20-16} = Rm;
  let Inst{15}    = V;
  let Inst{14-13} = Rv;
  let Inst{12-10} = Pg;
  let Inst{9-5}   = Rn;
  let Inst{4}     = 0b0;

  let mayStore = 1;
  let hasSideEffects = 1;
}

class sme_mem_st_ss_inst<bit Q, bits<2> msz, string mnemonic,
                         MatrixTileVectorOperand tile_ty, bit is_col,
                         Operand imm_ty, RegisterOperand gpr_ty>
    : sme_mem_st_ss_base<
        Q, is_col, msz,
        (ins tile_ty:$ZAt, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm, PPR3bAny:$Pg,
             GPR64sp:$Rn, gpr_ty:$Rm),
        mnemonic, "\t\\{$ZAt[$Rv, $imm]\\}, $Pg, [$Rn, $Rm]">;

multiclass sme_mem_st_ss_aliases<string inst, bit is_col> {
  defm NAME : sme_mem_ss_aliases<"st1", inst, is_col>;
}

multiclass sme_mem_st_v_ss<string mnemonic, bit is_col> {
  def _B : sme_mem_st_ss_inst<0b0, 0b00, mnemonic # "b",
                              !if(is_col, TileVectorOpV8, TileVectorOpH8),
                              is_col, sme_elm_idx0_15, GPR64shifted8> {
    bits<4> imm;
    let Inst{3-0} = imm;
  }
  def _H : sme_mem_st_ss_inst<0b0, 0b01, mnemonic # "h",
                              !if(is_col, TileVectorOpV16, TileVectorOpH16),
                              is_col, sme_elm_idx0_7, GPR64shifted16> {
    bits<1> ZAt;
    bits<3> imm;
    let Inst{3}   = ZAt;
    let Inst{2-0} = imm;
  }
  def _S : sme_mem_st_ss_inst<0b0, 0b10, mnemonic # "w",
                              !if(is_col, TileVectorOpV32, TileVectorOpH32),
                              is_col, sme_elm_idx0_3, GPR64shifted32> {
    bits<2> ZAt;
    bits<2> imm;
    let Inst{3-2} = ZAt;
    let Inst{1-0} = imm;
  }
  def _D : sme_mem_st_ss_inst<0b0, 0b11, mnemonic # "d",
                              !if(is_col, TileVectorOpV64, TileVectorOpH64),
                              is_col, sme_elm_idx0_1, GPR64shifted64> {
    bits<3> ZAt;
    bits<1> imm;
    let Inst{3-1} = ZAt;
    let Inst{0}   = imm;
  }
  def _Q : sme_mem_st_ss_inst<0b1, 0b11, mnemonic # "q",
                              !if(is_col, TileVectorOpV128, TileVectorOpH128),
                              is_col, sme_elm_idx0_0, GPR64shifted128> {
    bits<4> ZAt;
    let Inst{3-0} = ZAt;
  }

  defm : sme_mem_st_ss_aliases<NAME, is_col>;
}

multiclass sme_mem_st_ss<string mnemonic> {
  defm _H : sme_mem_st_v_ss<mnemonic, /*is_col=*/0b0>;
  defm _V : sme_mem_st_v_ss<mnemonic, /*is_col=*/0b1>;
}

//===----------------------------------------------------------------------===//
// SME Save and Restore Array
//===----------------------------------------------------------------------===//

class sme_spill_fill_inst<bit isStore, dag outs, dag ins, string opcodestr>
    : I<outs, ins, opcodestr, "\t$ZAt[$Rv, $imm4], [$Rn, $offset, mul vl]", "",
        []>,
      Sched<[]> {
  bits<2> Rv;
  bits<5> Rn;
  bits<4> imm4;
  let Inst{31-22} = 0b1110000100;
  let Inst{21}    = isStore;
  let Inst{20-15} = 0b000000;
  let Inst{14-13} = Rv;
  let Inst{12-10} = 0b000;
  let Inst{9-5}   = Rn;
  let Inst{4}     = 0b0;
  let Inst{3-0}   = imm4;

  let mayLoad = !not(isStore);
  let mayStore = isStore;
  let Constraints = !if(!not(isStore), "$ZAt = $_ZAt", "");
}

multiclass sme_spill_fill<bit isStore, dag outs, dag ins, string opcodestr> {
  def NAME : sme_spill_fill_inst<isStore, outs, ins, opcodestr>;

  def : InstAlias<opcodestr # "\t$ZAt[$Rv, $imm4], [$Rn]",
                  (!cast<Instruction>(NAME) MatrixOp:$ZAt,
                   MatrixIndexGPR32Op12_15:$Rv, sme_elm_idx0_15:$imm4, GPR64sp:$Rn, 0), 1>;
}

multiclass sme_spill<string opcodestr> {
  defm NAME : sme_spill_fill<0b1, (outs),
                             (ins MatrixOp:$ZAt, MatrixIndexGPR32Op12_15:$Rv,
                                  sme_elm_idx0_15:$imm4, GPR64sp:$Rn,
                                  imm0_15:$offset),
                             opcodestr>;
}

multiclass sme_fill<string opcodestr> {
  defm NAME : sme_spill_fill<0b0, (outs MatrixOp:$ZAt),
                             (ins MatrixOp:$_ZAt, MatrixIndexGPR32Op12_15:$Rv,
                                  sme_elm_idx0_15:$imm4, GPR64sp:$Rn,
                                  imm0_15:$offset),
                             opcodestr>;
}

//===----------------------------------------------------------------------===//
// Unpredicated  instructions
//===----------------------------------------------------------------------===//

// Pseudo instructions representing unpredicated LDR and STR instructions for lowering
// ScalableMatrixType "load" and "store" instructions. Since there are no unpredicated
// instrucitons in the ISA to load and store matrices, we use LD1 and ST1 instructions.

// These get expanded to a sequence of LD1/ST1 instrucions in AArch64ExpandPseudoInsts.

multiclass unpred_load_sme<ValueType Ty, Instruction LoadInst> {
  def _fi : Pat<(Ty (load (am_sve_fi GPR64sp:$base, simm9:$offset))),
                (LoadInst GPR64sp:$base, simm9:$offset, (IMPLICIT_DEF),
                    (IMPLICIT_DEF), (IMPLICIT_DEF), (IMPLICIT_DEF))>;
}

multiclass SMEPseudoLoad<MatrixTileVectorOperand zar8ty, MatrixTileVectorOperand zar16ty, MatrixTileVectorOperand zar32ty,
                         MatrixTileVectorOperand zar64ty, MatrixTileVectorOperand zar128ty> {
  let mayLoad = 1, hasSideEffects = 0 in {
    def _B : Pseudo<(outs zar8ty:$Za),
                    (ins GPR64sp:$sp, simm9:$offset, MatrixIndexGPR32Op12_15:$Wv,
                     GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),[]>, Sched<[]>;
    def _H : Pseudo<(outs zar16ty:$Za),
                    (ins GPR64sp:$sp, simm9:$offset, MatrixIndexGPR32Op12_15:$Wv,
                     GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),[]>, Sched<[]>;
    def _W : Pseudo<(outs zar32ty:$Za),
                    (ins GPR64sp:$sp, simm9:$offset, MatrixIndexGPR32Op12_15:$Wv,
                     GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),[]>, Sched<[]>;
    def _D : Pseudo<(outs zar64ty:$Za),
                    (ins GPR64sp:$sp, simm9:$offset, MatrixIndexGPR32Op12_15:$Wv,
                     GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),[]>, Sched<[]>;
    def _Q : Pseudo<(outs zar128ty:$Za),
                    (ins GPR64sp:$sp, simm9:$offset, MatrixIndexGPR32Op12_15:$Wv,
                     GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),[]>, Sched<[]>;
  }

  defm : unpred_load_sme<mxv256i8, !cast<Instruction>(NAME # _B)>;
  defm : unpred_load_sme<mxv64i16, !cast<Instruction>(NAME # _H)>;
  defm : unpred_load_sme<mxv64f16, !cast<Instruction>(NAME # _H)>;
  defm : unpred_load_sme<mxv64bf16, !cast<Instruction>(NAME # _H)>;
  defm : unpred_load_sme<mxv16i32, !cast<Instruction>(NAME # _W)>;
  defm : unpred_load_sme<mxv16f32, !cast<Instruction>(NAME # _W)>;
  defm : unpred_load_sme<mxv4i64, !cast<Instruction>(NAME # _D)>;
  defm : unpred_load_sme<mxv4f64, !cast<Instruction>(NAME # _D)>;
  defm : unpred_load_sme<mxv1i128, !cast<Instruction>(NAME # _Q)>;
}

defm LD1H_ZaXI : SMEPseudoLoad<TileVectorOpH8, TileVectorOpH16, TileVectorOpH32, TileVectorOpH64, TileVectorOpH128>;
defm LD1V_ZaXI : SMEPseudoLoad<TileVectorOpV8, TileVectorOpV16, TileVectorOpV32, TileVectorOpV64, TileVectorOpV128>;

multiclass unpred_store_sme<ValueType Ty, Instruction StoreInst> {
  def : Pat<(store (Ty ZAZeroOperand:$Za), (am_sve_fi GPR64sp:$base, simm9:$offset)),
                (StoreInst ZAZeroOperand:$Za, GPR64sp:$base, simm9:$offset, (IMPLICIT_DEF),
                    (IMPLICIT_DEF), (IMPLICIT_DEF), (IMPLICIT_DEF))>;
}

multiclass unpred_store_sme_q<ValueType Ty, Instruction StoreInst> {
  def : Pat<(store (Ty MPR128:$Za), (am_sve_fi GPR64sp:$base, simm9:$offset)),
                (StoreInst MPR128:$Za, GPR64sp:$base, simm9:$offset, (IMPLICIT_DEF),
                    (IMPLICIT_DEF), (IMPLICIT_DEF), (IMPLICIT_DEF))>;
}

multiclass SMEPseudoStore<MatrixTileVectorOperand zar8ty, MatrixTileVectorOperand zar16ty, MatrixTileVectorOperand zar32ty,
                          MatrixTileVectorOperand zar64ty, MatrixTileVectorOperand zar128ty> {
  let mayStore = 1, hasSideEffects = 0 in {
    def _B : Pseudo<(outs), (ins zar8ty:$Za, GPR64sp:$sp, simm9:$offset,
                    MatrixIndexGPR32Op12_15:$Wv, GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),
                    []>, Sched<[]>;
    def _H : Pseudo<(outs), (ins zar16ty:$Za, GPR64sp:$sp, simm9:$offset,
                    MatrixIndexGPR32Op12_15:$Wv, GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),
                    []>, Sched<[]>;
    def _W : Pseudo<(outs), (ins zar32ty:$Za, GPR64sp:$sp, simm9:$offset,
                    MatrixIndexGPR32Op12_15:$Wv, GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),
                    []>, Sched<[]>;
    def _D : Pseudo<(outs), (ins zar64ty:$Za, GPR64sp:$sp, simm9:$offset,
                    MatrixIndexGPR32Op12_15:$Wv, GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),
                    []>, Sched<[]>;
    def _Q : Pseudo<(outs), (ins zar128ty:$Za, GPR64sp:$sp, simm9:$offset,
                    MatrixIndexGPR32Op12_15:$Wv, GPR64:$Xn, GPR64:$Xm, PPR3bAny:$Pv),
                    []>, Sched<[]>;
  }

  defm : unpred_store_sme<mxv256i8, !cast<Instruction>(NAME # _B)>;
  defm : unpred_store_sme<mxv64i16, !cast<Instruction>(NAME # _H)>;
  defm : unpred_store_sme<mxv64f16, !cast<Instruction>(NAME # _H)>;
  defm : unpred_store_sme<mxv64bf16, !cast<Instruction>(NAME # _H)>;
  defm : unpred_store_sme<mxv16i32, !cast<Instruction>(NAME # _W)>;
  defm : unpred_store_sme<mxv16f32, !cast<Instruction>(NAME # _W)>;
  defm : unpred_store_sme<mxv4i64, !cast<Instruction>(NAME # _D)>;
  defm : unpred_store_sme<mxv4f64, !cast<Instruction>(NAME # _D)>;
  defm : unpred_store_sme_q<mxv1i128, !cast<Instruction>(NAME # _Q)>;
}

defm ST1H_ZaXI : SMEPseudoStore<TileVectorOpH8, TileVectorOpH16, TileVectorOpH32, TileVectorOpH64, TileVectorOpH128>;
defm ST1V_ZaXI : SMEPseudoStore<TileVectorOpV8, TileVectorOpV16, TileVectorOpV32, TileVectorOpV64, TileVectorOpV128>;

// Pseudo instruction for prologue and epilogue generation of stack frame allocation
// for SME tiles.
multiclass SMEPseudoAlloca{
  def _B : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm), (ins GPR64sp:$Rn, simm6_32b:$imm6), []>, Sched<[]>;
  def _H : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm), (ins GPR64sp:$Rn, simm6_32b:$imm6), []>, Sched<[]>;
  def _W : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm), (ins GPR64sp:$Rn, simm6_32b:$imm6), []>, Sched<[]>;
  def _D : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm), (ins GPR64sp:$Rn, simm6_32b:$imm6), []>, Sched<[]>;
  def _Q : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm), (ins GPR64sp:$Rn, simm6_32b:$imm6), []>, Sched<[]>;
}

defm SME_ALLOCA : SMEPseudoAlloca;

// Pseudo instruction for frame index.
multiclass SMEPseudoFrameIndex{
  def _B : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm, GPR64:$Rs), (ins GPR64sp:$Rn), []>, Sched<[]>;
  def _H : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm, GPR64:$Rs), (ins GPR64sp:$Rn), []>, Sched<[]>;
  def _W : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm, GPR64:$Rs), (ins GPR64sp:$Rn), []>, Sched<[]>;
  def _D : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm, GPR64:$Rs), (ins GPR64sp:$Rn), []>, Sched<[]>;
  def _Q : Pseudo<(outs GPR64sp:$Rd, GPR64:$Rm, GPR64:$Rs), (ins GPR64sp:$Rn), []>, Sched<[]>;
}

defm SME_FI : SMEPseudoFrameIndex;

//===----------------------------------------------------------------------===//
// Move instructions
//===----------------------------------------------------------------------===//

class SME_3_Op_Imm_Pat<ValueType vtd, SDPatternOperator op, ValueType vt1,
                       ValueType vt2, ValueType vt3, Operand ImmTy,
                       Instruction inst>
: Pat<(vtd (op vt1:$Op1, vt2:$Op2, vt3:$Op3, ImmTy:$Op4)),
      (inst $Op1, $Op2, $Op3, ImmTy:$Op4)>;

class SME_4_Op_Imm_Pat<ValueType vtd, SDPatternOperator op, ValueType vt1,
                       ValueType vt2, ValueType vt3, Operand ImmTy,
                       ValueType vt4, Instruction inst>
: Pat<(vtd (op vt1:$op1, vt2:$op2, vt3:$op3, ImmTy:$op4, vt4:$op5)),
      (inst $op2, $op3, ImmTy:$op4, $op1, $op5)>;

class sme_vector_to_tile_base<bit Q, bit V, bits<2> sz, dag outs, dag ins,
                              string mnemonic, string argstr>
    : I<outs, ins, mnemonic, argstr, "", []>, Sched<[]> {
  bits<2> Rv;
  bits<3> Pg;
  bits<5> Zn;
  let Inst{31-24} = 0b11000000;
  let Inst{23-22} = sz;
  let Inst{21-17} = 0b00000;
  let Inst{16}    = Q;
  let Inst{15}    = V;
  let Inst{14-13} = Rv;
  let Inst{12-10} = Pg;
  let Inst{9-5}   = Zn;
  let Inst{4}     = 0b0;

  let Constraints = "$ZAd = $_ZAd";
}

class sme_vector_to_tile_inst<bit Q, bits<2> sz, MatrixTileVectorOperand tile_ty,
                              bit is_col, Operand imm_ty, ZPRRegOp zpr_ty,
                              string mnemonic>
    : sme_vector_to_tile_base<Q, is_col, sz, (outs tile_ty:$ZAd),
        (ins tile_ty:$_ZAd, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm, PPR3bAny:$Pg, zpr_ty:$Zn),
        mnemonic, "\t$ZAd[$Rv, $imm], $Pg/m, $Zn">;

multiclass sme_vector_to_tile_aliases<Instruction inst,
                                      MatrixTileVectorOperand tile_ty,
                                      ZPRRegOp zpr_ty, Operand imm_ty> {
  def : InstAlias<"mov\t$ZAd[$Rv, $imm], $Pg/m, $Zn",
                  (inst tile_ty:$ZAd, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm, PPR3bAny:$Pg, zpr_ty:$Zn), 1>;
}

multiclass sme_vector_v_to_tile<string mnemonic, bit is_col> {
  def _B : sme_vector_to_tile_inst<0b0, 0b00, !if(is_col, TileVectorOpV8,
                                                          TileVectorOpH8),
                                   is_col, sme_elm_idx0_15, ZPR8, mnemonic> {
    bits<4> imm;
    let Inst{3-0} = imm;
  }
  def _H : sme_vector_to_tile_inst<0b0, 0b01, !if(is_col, TileVectorOpV16,
                                                          TileVectorOpH16),
                                   is_col, sme_elm_idx0_7, ZPR16, mnemonic> {
    bits<1> ZAd;
    bits<3> imm;
    let Inst{3}   = ZAd;
    let Inst{2-0} = imm;
  }
  def _S : sme_vector_to_tile_inst<0b0, 0b10, !if(is_col, TileVectorOpV32,
                                                          TileVectorOpH32),
                                   is_col, sme_elm_idx0_3, ZPR32, mnemonic> {
    bits<2> ZAd;
    bits<2> imm;
    let Inst{3-2} = ZAd;
    let Inst{1-0} = imm;
  }
  def _D : sme_vector_to_tile_inst<0b0, 0b11, !if(is_col, TileVectorOpV64,
                                                          TileVectorOpH64),
                                   is_col, sme_elm_idx0_1, ZPR64, mnemonic> {
    bits<3> ZAd;
    bits<1> imm;
    let Inst{3-1} = ZAd;
    let Inst{0}   = imm;
  }
  def _Q : sme_vector_to_tile_inst<0b1, 0b11, !if(is_col, TileVectorOpV128,
                                                          TileVectorOpH128),
                                   is_col, sme_elm_idx0_0, ZPR128, mnemonic> {
    bits<4> ZAd;
    bits<1> imm;
    let Inst{3-0} = ZAd;
  }

  defm : sme_vector_to_tile_aliases<!cast<Instruction>(NAME # _B),
                                    !if(is_col, TileVectorOpV8,
                                                TileVectorOpH8),
                                    ZPR8, sme_elm_idx0_15>;
  defm : sme_vector_to_tile_aliases<!cast<Instruction>(NAME # _H),
                                    !if(is_col, TileVectorOpV16,
                                                TileVectorOpH16),
                                    ZPR16, sme_elm_idx0_7>;
  defm : sme_vector_to_tile_aliases<!cast<Instruction>(NAME # _S),
                                    !if(is_col, TileVectorOpV32,
                                                TileVectorOpH32),
                                    ZPR32, sme_elm_idx0_3>;
  defm : sme_vector_to_tile_aliases<!cast<Instruction>(NAME # _D),
                                    !if(is_col, TileVectorOpV64,
                                                TileVectorOpH64),
                                    ZPR64, sme_elm_idx0_1>;
  defm : sme_vector_to_tile_aliases<!cast<Instruction>(NAME # _Q),
                                    !if(is_col, TileVectorOpV128,
                                                TileVectorOpH128),
                                    ZPR128, sme_elm_idx0_0>;

  def : SME_4_Op_Imm_Pat<mxv256i8, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv16i1, mxv256i8, i32, sme_elm_idx0_15, nxv16i8, !cast<Instruction>(NAME # _B)>;
  def : SME_4_Op_Imm_Pat<mxv64i16, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv8i1, mxv64i16, i32, sme_elm_idx0_7, nxv8i16, !cast<Instruction>(NAME # _H)>;
  def : SME_4_Op_Imm_Pat<mxv64f16, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv8i1, mxv64f16, i32, sme_elm_idx0_7, nxv8f16, !cast<Instruction>(NAME # _H)>;
  def : SME_4_Op_Imm_Pat<mxv64bf16, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv8i1, mxv64bf16, i32, sme_elm_idx0_7, nxv8bf16, !cast<Instruction>(NAME # _H)>;
  def : SME_4_Op_Imm_Pat<mxv16i32, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv4i1, mxv16i32, i32, sme_elm_idx0_3, nxv4i32, !cast<Instruction>(NAME # _S)>;
  def : SME_4_Op_Imm_Pat<mxv16f32, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv4i1, mxv16f32, i32, sme_elm_idx0_3, nxv4f32, !cast<Instruction>(NAME # _S)>;
  def : SME_4_Op_Imm_Pat<mxv4i64, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv2i1, mxv4i64,  i32, sme_elm_idx0_1, nxv2i64, !cast<Instruction>(NAME # _D)>;
  def : SME_4_Op_Imm_Pat<mxv4f64, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv2i1, mxv4f64, i32, sme_elm_idx0_1, nxv2f64, !cast<Instruction>(NAME # _D)>;
  def : SME_4_Op_Imm_Pat<mxv1i128, !if(is_col, int_aarch64_sme_mova_col, int_aarch64_sme_mova_row), nxv1i1, mxv1i128, i32, sme_elm_idx0_0, nxv1i128, !cast<Instruction>(NAME # _Q)>;
}

multiclass sme_vector_to_tile<string mnemonic> {
  defm _H : sme_vector_v_to_tile<mnemonic, /*is_col=*/0b0>;
  defm _V : sme_vector_v_to_tile<mnemonic, /*is_col=*/0b1>;
}

class sme_tile_to_vector_base<bit Q, bit V, bits<2> sz, dag outs, dag ins,
                              string mnemonic, string argstr>
    : I<outs, ins, mnemonic, argstr, "", []>, Sched<[]> {
  bits<2> Rv;
  bits<3> Pg;
  bits<5> Zd;
  let Inst{31-24} = 0b11000000;
  let Inst{23-22} = sz;
  let Inst{21-17} = 0b00001;
  let Inst{16}    = Q;
  let Inst{15}    = V;
  let Inst{14-13} = Rv;
  let Inst{12-10} = Pg;
  let Inst{9}     = 0b0;
  let Inst{4-0}   = Zd;
}

class sme_tile_to_vector_inst<bit Q, bits<2> sz, ZPRRegOp zpr_ty,
                              MatrixTileVectorOperand tile_ty,
                              bit is_col, Operand imm_ty, string mnemonic>
    : sme_tile_to_vector_base<Q, is_col, sz, (outs zpr_ty:$Zd),
        (ins PPR3bAny:$Pg, tile_ty:$ZAn, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm),
        mnemonic, "\t$Zd, $Pg/m, $ZAn[$Rv, $imm]">;

multiclass sme_tile_to_vector_aliases<Instruction inst, ZPRRegOp zpr_ty,
                                      MatrixTileVectorOperand tile_ty,
                                      Operand imm_ty > {
  def : InstAlias<"mov\t$Zd, $Pg/m, $ZAn[$Rv, $imm]",
                  (inst zpr_ty:$Zd, PPR3bAny:$Pg, tile_ty:$ZAn, MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm), 1>;
}

multiclass sme_tile_to_vector_v<string mnemonic, bit is_col> {
  def _B : sme_tile_to_vector_inst<0b0, 0b00, ZPR8, !if(is_col, TileVectorOpV8,
                                                                TileVectorOpH8),
                                   is_col, sme_elm_idx0_15, mnemonic> {
    bits<4> imm;
    let Inst{8-5} = imm;
  }
  def _H : sme_tile_to_vector_inst<0b0, 0b01, ZPR16, !if(is_col, TileVectorOpV16,
                                                                 TileVectorOpH16),
                                   is_col, sme_elm_idx0_7, mnemonic> {
    bits<1> ZAn;
    bits<3> imm;
    let Inst{8}   = ZAn;
    let Inst{7-5} = imm;
  }
  def _S : sme_tile_to_vector_inst<0b0, 0b10, ZPR32, !if(is_col, TileVectorOpV32,
                                                                 TileVectorOpH32),
                                   is_col, sme_elm_idx0_3, mnemonic> {
    bits<2> ZAn;
    bits<2> imm;
    let Inst{8-7} = ZAn;
    let Inst{6-5} = imm;
  }
  def _D : sme_tile_to_vector_inst<0b0, 0b11, ZPR64, !if(is_col, TileVectorOpV64,
                                                                 TileVectorOpH64),
                                   is_col, sme_elm_idx0_1, mnemonic> {
    bits<3> ZAn;
    bits<1> imm;
    let Inst{8-6} = ZAn;
    let Inst{5}   = imm;
  }
  def _Q : sme_tile_to_vector_inst<0b1, 0b11, ZPR128, !if(is_col, TileVectorOpV128,
                                                                  TileVectorOpH128),
                                   is_col, sme_elm_idx0_0, mnemonic> {
    bits<4> ZAn;
    let Inst{8-5} = ZAn;
  }

  defm : sme_tile_to_vector_aliases<!cast<Instruction>(NAME # _B), ZPR8,
                                    !if(is_col, TileVectorOpV8,
                                                TileVectorOpH8), sme_elm_idx0_15>;
  defm : sme_tile_to_vector_aliases<!cast<Instruction>(NAME # _H), ZPR16,
                                    !if(is_col, TileVectorOpV16,
                                                TileVectorOpH16), sme_elm_idx0_7>;
  defm : sme_tile_to_vector_aliases<!cast<Instruction>(NAME # _S), ZPR32,
                                    !if(is_col, TileVectorOpV32,
                                                TileVectorOpH32), sme_elm_idx0_3>;
  defm : sme_tile_to_vector_aliases<!cast<Instruction>(NAME # _D), ZPR64,
                                    !if(is_col, TileVectorOpV64,
                                                TileVectorOpH64), sme_elm_idx0_1>;
  defm : sme_tile_to_vector_aliases<!cast<Instruction>(NAME # _Q), ZPR128,
                                    !if(is_col, TileVectorOpV128,
                                                TileVectorOpH128), sme_elm_idx0_0>;

  def : SME_3_Op_Imm_Pat<nxv16i8, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv16i1, mxv256i8, i32, sme_elm_idx0_15, !cast<Instruction>(NAME # _B)>;
  def : SME_3_Op_Imm_Pat<nxv8i16, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv8i1, mxv64i16, i32, sme_elm_idx0_7, !cast<Instruction>(NAME # _H)>;
  def : SME_3_Op_Imm_Pat<nxv8f16, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv8i1, mxv64f16, i32, sme_elm_idx0_7, !cast<Instruction>(NAME # _H)>;
  def : SME_3_Op_Imm_Pat<nxv8bf16, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv8i1, mxv64bf16, i32, sme_elm_idx0_7, !cast<Instruction>(NAME # _H)>;
  def : SME_3_Op_Imm_Pat<nxv4i32, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv4i1, mxv16i32, i32, sme_elm_idx0_3, !cast<Instruction>(NAME # _S)>;
  def : SME_3_Op_Imm_Pat<nxv4f32, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv4i1, mxv16f32, i32, sme_elm_idx0_3, !cast<Instruction>(NAME # _S)>;
  def : SME_3_Op_Imm_Pat<nxv2i64, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv2i1, mxv4i64,  i32, sme_elm_idx0_1, !cast<Instruction>(NAME # _D)>;
  def : SME_3_Op_Imm_Pat<nxv2f64, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv2i1, mxv4f64,  i32, sme_elm_idx0_1, !cast<Instruction>(NAME # _D)>;
  def : SME_3_Op_Imm_Pat<nxv1i128, !if(is_col, int_aarch64_sme_mova_vec_col, int_aarch64_sme_mova_vec_row), nxv1i1, mxv1i128, i32, sme_elm_idx0_0, !cast<Instruction>(NAME # _Q)>;
}

multiclass sme_tile_to_vector<string mnemonic> {
  defm _H : sme_tile_to_vector_v<mnemonic, /*is_col=*/0b0>;
  defm _V : sme_tile_to_vector_v<mnemonic, /*is_col=*/0b1>;
}

//===----------------------------------------------------------------------===//
// SME Zero
//===----------------------------------------------------------------------===//

class sme_zero_inst<string mnemonic>
    : I<(outs MatrixTileList:$ZAda), (ins),
        mnemonic, "\t$ZAda", "", []>, Sched<[]> {
  bits<8> imm;
  let Inst{31-8} = 0b110000000000100000000000;
  let Inst{7-0}  = imm;
  let DecoderMethod = "DecodeZeroInstruction";
}

multiclass sme_zero<string mnemonic> {
  def NAME : sme_zero_inst<mnemonic>;
}

//===----------------------------------------------------------------------===//
// SVE2 Instructions
//===----------------------------------------------------------------------===//

class sve2_int_perm_revd<string asm>
    : I<(outs ZPR128:$Zd), (ins ZPR128:$_Zd, PPR3bAny:$Pg, ZPR128:$Zn),
        asm, "\t$Zd, $Pg/m, $Zn", "", []>,
      Sched<[]> {
  bits<5> Zd;
  bits<3> Pg;
  bits<5> Zn;
  let Inst{31-24} = 0b00000101;
  let Inst{23-22} = 0b00; // size
  let Inst{21-13} = 0b101110100;
  let Inst{12-10} = Pg;
  let Inst{9-5}   = Zn;
  let Inst{4-0}   = Zd;

  let Constraints = "$Zd = $_Zd";
  let DestructiveInstType = DestructiveUnary;
  let ElementSize = ZPR128.ElementSize;
}

class sve2_clamp<string asm, bits<2> sz, bit U, ZPRRegOp zpr_ty>
    : I<(outs zpr_ty:$Zd), (ins zpr_ty:$Zn, zpr_ty:$Zm, zpr_ty:$_Zd),
        asm, "\t$Zd, $Zn, $Zm", "", []>,
      Sched<[]> {
  bits<5> Zm;
  bits<5> Zn;
  bits<5> Zd;
  let Inst{31-24} = 0b01000100;
  let Inst{23-22} = sz;
  let Inst{21}    = 0b0;
  let Inst{20-16} = Zm;
  let Inst{15-11} = 0b11000;
  let Inst{10}    = U;
  let Inst{9-5}   = Zn;
  let Inst{4-0}   = Zd;

  let Constraints = "$Zd = $_Zd";
  let DestructiveInstType = DestructiveOther;
  let ElementSize = zpr_ty.ElementSize;
}

multiclass sve2_clamp<string asm, bit U> {
  def _B : sve2_clamp<asm, 0b00, U, ZPR8>;
  def _H : sve2_clamp<asm, 0b01, U, ZPR16>;
  def _S : sve2_clamp<asm, 0b10, U, ZPR32>;
  def _D : sve2_clamp<asm, 0b11, U, ZPR64>;
}

class sve2_int_perm_sel_p<string asm, PPRRegOp ppr_ty, Operand imm_ty>
    : I<(outs PPRAny:$Pd), (ins PPRAny:$Pn, ppr_ty:$Pm,
                            MatrixIndexGPR32Op12_15:$Rv, imm_ty:$imm),
        asm, "\t$Pd, $Pn, $Pm[$Rv, $imm]", "", []>,
      Sched<[]> {
  bits<2> Rv;
  bits<4> Pn;
  bits<4> Pm;
  bits<4> Pd;
  let Inst{31-24} = 0b00100101;
  let Inst{21}    = 0b1;
  let Inst{17-16} = Rv;
  let Inst{15-14} = 0b01;
  let Inst{13-10} = Pn;
  let Inst{9}     = 0b0;
  let Inst{8-5}   = Pm;
  let Inst{4}     = 0b0;
  let Inst{3-0}   = Pd;
}

multiclass sve2_int_perm_sel_p<string asm> {
  def _B : sve2_int_perm_sel_p<asm, PPR8, sme_elm_idx0_15> {
    bits<4> imm;
    let Inst{23-22} = imm{3-2};
    let Inst{20-19} = imm{1-0};
    let Inst{18}    = 0b1;
  }
  def _H : sve2_int_perm_sel_p<asm, PPR16, sme_elm_idx0_7> {
    bits<3> imm;
    let Inst{23-22} = imm{2-1};
    let Inst{20}    = imm{0};
    let Inst{19-18} = 0b10;
  }
  def _S : sve2_int_perm_sel_p<asm, PPR32, sme_elm_idx0_3> {
    bits<2> imm;
    let Inst{23-22} = imm{1-0};
    let Inst{20-18} = 0b100;
  }
  def _D : sve2_int_perm_sel_p<asm, PPR64, sme_elm_idx0_1> {
    bits<1> imm;
    let Inst{23}    = imm;
    let Inst{22}    = 0b1;
    let Inst{20-18} = 0b000;
  }
}
