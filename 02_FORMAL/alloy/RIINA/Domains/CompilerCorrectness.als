// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for compiler correctness
// Bounded verification of key properties
module riina/Domains/CompilerCorrectness

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert andb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_true_iff for 6

assert CC_001 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_001 for 6

assert CC_002 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_002 for 6

assert CC_003 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_003 for 6

assert CC_004 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_004 for 6

assert CC_005 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_005 for 6

assert CC_006 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_006 for 6

assert CC_007 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_007 for 6

assert CC_008 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_008 for 6

assert CC_009 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_009 for 6

assert CC_010 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_010 for 6

assert CC_011 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_011 for 6

assert CC_012 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_012 for 6

assert CC_013 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_013 for 6

assert CC_014 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_014 for 6

assert CC_015 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_015 for 6

assert CC_016 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_016 for 6

assert CC_017 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_017 for 6

assert CC_018 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_018 for 6

assert CC_019 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_019 for 6

assert CC_020 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_020 for 6

assert CC_021 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_021 for 6

assert CC_022 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_022 for 6

assert CC_023 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_023 for 6

assert CC_024 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_024 for 6

assert CC_025 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_025 for 6

assert CC_026 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_026 for 6

assert CC_027 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_027 for 6

assert CC_028 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_028 for 6

assert CC_029 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_029 for 6

assert CC_030_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_030_complete for 6

assert ir_value_not_step {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_value_not_step for 6

assert ir_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_preservation for 6

assert ir_multi_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_multi_preservation for 6

assert ir_pair_value_not_step {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_pair_value_not_step for 6

assert ir_bool_not_step {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_bool_not_step for 6

assert ir_step_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_step_deterministic for 6

assert ir_progress {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_progress for 6

assert ir_equiv_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_equiv_refl for 6

assert ir_equiv_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_equiv_sym for 6

assert ir_equiv_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_equiv_trans for 6

assert ir_multi_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_multi_trans for 6

assert ir_multi_pair_cong1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_multi_pair_cong1 for 6

assert ir_multi_pair_cong2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_multi_pair_cong2 for 6

assert opt_if_true_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_if_true_sound for 6

assert opt_if_false_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_if_false_sound for 6

assert opt_fst_pair_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_fst_pair_sound for 6

assert opt_snd_pair_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_snd_pair_sound for 6

assert ir_value_normal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_value_normal for 6

assert ir_value_reduces_self {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ir_value_reduces_self for 6

assert equiv_preserves_typing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check equiv_preserves_typing for 6

assert src_value_not_step {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check src_value_not_step for 6

assert src_step_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check src_step_deterministic for 6

assert src_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check src_preservation for 6

assert src_progress {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check src_progress for 6

assert compile_preserves_value {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_preserves_value for 6

assert compile_preserves_typing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_preserves_typing for 6

assert compile_forward_simulation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_forward_simulation for 6

assert compile_forward_multi_simulation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_forward_multi_simulation for 6

assert compile_value_inv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_value_inv for 6

assert compile_backward_simulation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_backward_simulation for 6

assert compile_establishes_equiv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_establishes_equiv for 6

assert equiv_preserved_forward {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check equiv_preserved_forward for 6

assert compile_terminates_equivalently {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_terminates_equivalently for 6

assert compile_type_safety {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compile_type_safety for 6

assert opt_dead_code_if_true {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_dead_code_if_true for 6

assert opt_dead_code_if_false {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_dead_code_if_false for 6

assert opt_fst_pair_typed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_fst_pair_typed for 6

assert opt_snd_pair_typed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opt_snd_pair_typed for 6

assert const_prop_bool {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check const_prop_bool for 6

assert const_prop_int {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check const_prop_int for 6

assert const_prop_unit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check const_prop_unit for 6

assert parsing_correct_prop {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check parsing_correct_prop for 6

assert optimization_relation_reflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check optimization_relation_reflexive for 6

assert optimization_relation_symmetric {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check optimization_relation_symmetric for 6

assert optimization_relation_transitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check optimization_relation_transitive for 6

assert full_pipeline_correctness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_pipeline_correctness for 6

assert full_pipeline_termination {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_pipeline_termination for 6

pred ExampleCompilerCorrectness {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCompilerCorrectness for 6
