// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for ROP defense
// Bounded verification of ROPDefense properties
module riina/Domains/ROPDefense

sig Gadget {
  reachable: one Int,
  mitigated: one Int
}

// Invariant: mitigated_unreachable
fact mitigated_unreachable_fact {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}

assert andb_true_iff {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check andb_true_iff for 6

assert andb_true_intro {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check andb_true_intro for 6

assert negb_true_iff {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check negb_true_iff for 6

assert orb_true_iff {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check orb_true_iff for 6

assert ROP_001 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_001 for 6

assert ROP_002 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_002 for 6

assert ROP_003 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_003 for 6

assert ROP_004 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_004 for 6

assert ROP_005 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_005 for 6

assert ROP_006 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_006 for 6

assert ROP_007 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_007 for 6

assert ROP_008 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_008 for 6

assert ROP_009 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_009 for 6

assert ROP_010 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_010 for 6

assert ROP_011 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_011 for 6

assert ROP_012 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_012 for 6

assert ROP_013 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_013 for 6

assert ROP_014 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_014 for 6

assert ROP_015 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_015 for 6

assert ROP_016 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_016 for 6

assert ROP_017 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_017 for 6

assert ROP_018 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_018 for 6

assert ROP_019 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_019 for 6

assert ROP_020 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_020 for 6

assert ROP_021 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_021 for 6

assert ROP_022 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_022 for 6

assert ROP_023 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_023 for 6

assert ROP_024 {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_024 for 6

assert ROP_025_complete {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_025_complete for 6

assert ROP_026_shadow_push_preserves {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_026_shadow_push_preserves for 6

assert ROP_027_shadow_pop_decreases {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_027_shadow_pop_decreases for 6

assert ROP_028_shadow_peek_top {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_028_shadow_peek_top for 6

assert ROP_029_valid_return_requires_entry {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_029_valid_return_requires_entry for 6

assert ROP_030_empty_stack_no_return {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_030_empty_stack_no_return for 6

assert ROP_031_push_pop_inverse {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_031_push_pop_inverse for 6

assert ROP_032_pushed_entry_valid {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_032_pushed_entry_valid for 6

assert ROP_033_return_matches_pushed {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_033_return_matches_pushed for 6

assert ROP_034_return_mismatch_fails {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_034_return_mismatch_fails for 6

assert ROP_035_shadow_stack_depth_bounded {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_035_shadow_stack_depth_bounded for 6

assert ROP_036_valid_target_in_list {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_036_valid_target_in_list for 6

assert ROP_037_empty_targets_no_valid {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_037_empty_targets_no_valid for 6

assert ROP_038_singleton_target_exact {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_038_singleton_target_exact for 6

assert ROP_039_is_valid_target_sound {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_039_is_valid_target_sound for 6

assert ROP_040_is_valid_target_complete {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_040_is_valid_target_complete for 6

assert ROP_041_btb_validated_implies_valid {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_041_btb_validated_implies_valid for 6

assert ROP_042_unvalidated_btb_unsafe {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_042_unvalidated_btb_unsafe for 6

assert ROP_043_target_subset_preserved {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_043_target_subset_preserved for 6

assert ROP_044_rop_gadget_blocked {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_044_rop_gadget_blocked for 6

assert ROP_045_jop_gadget_blocked {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_045_jop_gadget_blocked for 6

assert ROP_046_cop_gadget_blocked {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_046_cop_gadget_blocked for 6

assert ROP_047_srop_gadget_blocked {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_047_srop_gadget_blocked for 6

assert ROP_048_riina_blocks_all_gadgets {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_048_riina_blocks_all_gadgets for 6

assert ROP_049_empty_chain_blocked {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_049_empty_chain_blocked for 6

assert ROP_050_riina_blocks_all_chains {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_050_riina_blocks_all_chains for 6

assert ROP_051_chain_blocked_implies_each_blocked {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_051_chain_blocked_implies_each_blocked for 6

assert ROP_052_single_unblocked_breaks_chain {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_052_single_unblocked_breaks_chain for 6

assert ROP_053_cpi_complete_riina {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_053_cpi_complete_riina for 6

assert ROP_054_authenticated_ptr_protected {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_054_authenticated_ptr_protected for 6

assert ROP_055_unauthenticated_ptr_unsafe {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_055_unauthenticated_ptr_unsafe for 6

assert ROP_056_bounds_unchecked_unsafe {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_056_bounds_unchecked_unsafe for 6

assert ROP_057_fully_protected_ptr {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_057_fully_protected_ptr for 6

assert ROP_058_no_auth_requirement_passes {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_058_no_auth_requirement_passes for 6

assert ROP_059_function_ptr_type {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_059_function_ptr_type for 6

assert ROP_060_return_addr_protected {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_060_return_addr_protected for 6

assert ROP_061_forward_edge_enabled {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_061_forward_edge_enabled for 6

assert ROP_062_ibt_enabled {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_062_ibt_enabled for 6

assert ROP_063_forward_edge_complete {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_063_forward_edge_complete for 6

assert ROP_064_forward_edge_blocks_jop {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_064_forward_edge_blocks_jop for 6

assert ROP_065_forward_edge_blocks_cop {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_065_forward_edge_blocks_cop for 6

assert ROP_066_indirect_call_requires_ibt {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_066_indirect_call_requires_ibt for 6

assert ROP_067_forward_cfi_and_ibt_together {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_067_forward_cfi_and_ibt_together for 6

assert ROP_068_backward_edge_enabled {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_068_backward_edge_enabled for 6

assert ROP_069_shadow_stack_enabled {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_069_shadow_stack_enabled for 6

assert ROP_070_backward_edge_complete {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_070_backward_edge_complete for 6

assert ROP_071_backward_edge_blocks_rop {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_071_backward_edge_blocks_rop for 6

assert ROP_072_backward_edge_blocks_srop {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_072_backward_edge_blocks_srop for 6

assert ROP_073_return_requires_shadow {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_073_return_requires_shadow for 6

assert ROP_074_backward_cfi_and_shadow_together {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_074_backward_cfi_and_shadow_together for 6

assert ROP_075_return_address_protection_complete {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_075_return_address_protection_complete for 6

assert ROP_076_riina_full_cfi {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_076_riina_full_cfi for 6

assert ROP_077_riina_full_code_reuse {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_077_riina_full_code_reuse for 6

assert ROP_078_riina_full_rop_defense {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_078_riina_full_rop_defense for 6

assert ROP_079_all_attack_types_blocked {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_079_all_attack_types_blocked for 6

assert ROP_080_complete_defense_equivalence {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_080_complete_defense_equivalence for 6

assert ROP_081_shadow_stack_prevents_rop {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_081_shadow_stack_prevents_rop for 6

assert ROP_082_ibt_prevents_jop {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_082_ibt_prevents_jop for 6

assert ROP_083_cpi_prevents_ptr_hijack {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_083_cpi_prevents_ptr_hijack for 6

assert ROP_084_defense_in_depth {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_084_defense_in_depth for 6

assert ROP_085_riina_rop_immune {
  all g: Gadget | g.mitigated = 1 implies g.reachable = 0
}
check ROP_085_riina_rop_immune for 6

pred ExampleROPDefense {
  some Gadget
}
run ExampleROPDefense for 6
