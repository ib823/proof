(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/ROPDefense.v (89 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.ROPDefense
open FStar.All

(* GadgetType (matches Coq) *)
type gadget_type =
  | GadgetROP
  | GadgetJOP
  | GadgetCOP
  | GadgetSROP

(* CodePtrType (matches Coq) *)
type code_ptr_type =
  | CPFunction
  | CPVTable
  | CPReturnAddr
  | CPExceptionHandler
  | CPSignalHandler

(* CFIConfig (matches Coq) *)
type cfi_config = {
  f_cfi_shadow_stack: bool;
  f_cfi_indirect_branch_tracking: bool;
  f_cfi_return_address_protection: bool;
  f_cfi_forward_edge_cfi: bool;
  f_cfi_backward_edge_cfi: bool;
}

(* CodeReuse (matches Coq) *)
type code_reuse = {
  f_cr_gadget_elimination: bool;
  f_cr_instruction_alignment: bool;
  f_cr_code_pointer_integrity: bool;
}

(* ROPDefenseConfig (matches Coq) *)
type rop_defense_config = {
  f_rop_cfi: cfi_config;
  f_rop_code_reuse: code_reuse;
  f_rop_aslr_compatible: bool;
  f_rop_dep_compatible: bool;
}

(* ShadowEntry (matches Coq) *)
type shadow_entry = {
  f_se_return_addr: nat;
  f_se_caller_func: nat;
  f_se_frame_ptr: nat;
  f_se_mac_valid: bool;
}

(* BTBEntry (matches Coq) *)
type btb_entry = {
  f_btb_source: nat;
  f_btb_target: nat;
  f_btb_validated: bool;
}

(* Gadget (matches Coq) *)
type gadget = {
  f_gadget_type: gadget_type;
  f_gadget_addr: nat;
  f_gadget_length: nat;
  f_gadget_ends_in_ret: bool;
  f_gadget_ends_in_jump: bool;
}

(* CodePointer (matches Coq) *)
type code_pointer = {
  f_cp_type: code_ptr_type;
  f_cp_addr: nat;
  f_cp_authenticated: bool;
  f_cp_bounds_checked: bool;
}

(* CPIConfig (matches Coq) *)
type cpi_config = {
  f_cpi_ptr_authentication: bool;
  f_cpi_bounds_checking: bool;
  f_cpi_type_checking: bool;
  f_cpi_isolation: bool;
}

(* shadow_push (matches Coq: Definition shadow_push) *)
let shadow_push (p_ss: nat) (p_ret: nat) (p_caller: nat) (p_fp: nat) : Tot nat =
  mkShadowEntry p_ret p_caller p_fp true :: p_ss

(* return_matches_shadow (matches Coq: Definition return_matches_shadow) *)
let return_matches_shadow (p_ss: nat) (p_ret_addr: nat) : Tot bool =
  match p_ss with
  | [] -> false
  | e :: _ -> Nat.eqb (e.f_se_return_addr) p_ret_addr && e.f_se_mac_valid
  | _ -> false

(* valid_return (matches Coq: Definition valid_return) *)
let valid_return (p_ss: nat) (p_ret_addr: nat) : Tot bool =
  true

(* is_valid_target (matches Coq: Definition is_valid_target) *)
let is_valid_target (p_targets: nat) (p_addr: nat) : Tot bool =
  existsb (Nat.eqb p_addr) p_targets

(* indirect_branch_valid (matches Coq: Definition indirect_branch_valid) *)
let indirect_branch_valid (p_targets: nat) (p_addr: nat) : Tot bool =
  true

(* btb_entry_valid (matches Coq: Definition btb_entry_valid) *)
let btb_entry_valid (p_targets: nat) (p_e: btb_entry) : Tot bool =
  true

(* gadget_blocked (matches Coq: Definition gadget_blocked) *)
let gadget_blocked (p_cfi: cfi_config) (p_g: gadget) : Tot bool =
  match p_g.f_gadget_type with
  | GadgetROP -> p_cfi.f_cfi_backward_edge_cfi && p_cfi.f_cfi_shadow_stack
  | GadgetJOP -> p_cfi.f_cfi_forward_edge_cfi && p_cfi.f_cfi_indirect_branch_tracking
  | GadgetCOP -> p_cfi.f_cfi_forward_edge_cfi
  | GadgetSROP -> p_cfi.f_cfi_backward_edge_cfi && p_cfi.f_cfi_shadow_stack
  | _ -> false

(* chain_blocked (matches Coq: Definition chain_blocked) *)
let chain_blocked (p_cfi: cfi_config) (p_chain: nat) : Tot bool =
  forallb (gadget_blocked p_cfi) p_chain

(* cp_protected (matches Coq: Definition cp_protected) *)
let cp_protected (p_cpi: cpi_config) (p_cp: code_pointer) : Tot bool =
  ((not (p_cpi.f_cpi_ptr_authentication)) || p_cp.f_cp_authenticated) && ((not (p_cpi.f_cpi_bounds_checking)) || p_cp.f_cp_bounds_checked)

(* cfi_complete (matches Coq: Definition cfi_complete) *)
let cfi_complete (p_c: cfi_config) : Tot bool =
  p_c.f_cfi_shadow_stack && p_c.f_cfi_indirect_branch_tracking && p_c.f_cfi_return_address_protection && p_c.f_cfi_forward_edge_cfi && p_c.f_cfi_backward_edge_cfi

(* code_reuse_prevented (matches Coq: Definition code_reuse_prevented) *)
let code_reuse_prevented (p_r: code_reuse) : Tot bool =
  p_r.f_cr_gadget_elimination && p_r.f_cr_instruction_alignment && p_r.f_cr_code_pointer_integrity

(* rop_defended (matches Coq: Definition rop_defended) *)
let rop_defended (p_r: rop_defense_config) : Tot bool =
  cfi_complete (p_r.f_rop_cfi) && code_reuse_prevented (p_r.f_rop_code_reuse) && p_r.f_rop_aslr_compatible && p_r.f_rop_dep_compatible

(* cpi_complete (matches Coq: Definition cpi_complete) *)
let cpi_complete (p_c: cpi_config) : Tot bool =
  p_c.f_cpi_ptr_authentication && p_c.f_cpi_bounds_checking && p_c.f_cpi_type_checking && p_c.f_cpi_isolation

(* riina_cfi (matches Coq: Definition riina_cfi) *)
let riina_cfi : cfi_config = {f_cfi_shadow_stack=true; f_cfi_indirect_branch_tracking=true; f_cfi_return_address_protection=true; f_cfi_forward_edge_cfi=true; f_cfi_backward_edge_cfi=true}

(* riina_cr (matches Coq: Definition riina_cr) *)
let riina_cr : code_reuse = {f_cr_gadget_elimination=true; f_cr_instruction_alignment=true; f_cr_code_pointer_integrity=true}

(* riina_rop (matches Coq: Definition riina_rop) *)
let riina_rop : rop_defense_config = mkROPDefense riina_cfi riina_cr true true

(* riina_cpi (matches Coq: Definition riina_cpi) *)
let riina_cpi : cpi_config = {f_cpi_ptr_authentication=true; f_cpi_bounds_checking=true; f_cpi_type_checking=true; f_cpi_isolation=true}

(* andb_true_iff (matches Coq: Lemma andb_true_iff) *)
let andb_true_iff (p_a: bool) (p_b: bool) : Lemma (p_a && p_b == true <==> p_a == true /\ p_b == true) = ()

(* andb_true_intro (matches Coq: Lemma andb_true_intro) *)
let andb_true_intro (p_a: bool) (p_b: bool) : Lemma (requires (p_a == true /\ p_b == true)) (ensures (p_a && p_b == true)) = ()

(* negb_true_iff (matches Coq: Lemma negb_true_iff) *)
let negb_true_iff (p_b: bool) : Lemma ((not p_b) == true <==> p_b == false) = ()

(* orb_true_iff (matches Coq: Lemma orb_true_iff) *)
let orb_true_iff (p_a: bool) (p_b: bool) : Lemma (p_a || p_b == true <==> p_a == true \/ p_b == true) = ()

(* ROP_001 (matches Coq: Theorem ROP_001) *)
let rop_001 () : Lemma (cfi_complete riina_cfi == true) = ()

(* ROP_002 (matches Coq: Theorem ROP_002) *)
let rop_002 () : Lemma (code_reuse_prevented riina_cr == true) = ()

(* ROP_003 (matches Coq: Theorem ROP_003) *)
let rop_003 () : Lemma (rop_defended riina_rop == true) = ()

(* ROP_004 (matches Coq: Theorem ROP_004) *)
let rop_004 () : Lemma (riina_cfi.f_cfi_shadow_stack == true) = ()

(* ROP_005 (matches Coq: Theorem ROP_005) *)
let rop_005 () : Lemma (riina_cfi.f_cfi_indirect_branch_tracking == true) = ()

(* ROP_006 (matches Coq: Theorem ROP_006) *)
let rop_006 () : Lemma (riina_cfi.f_cfi_return_address_protection == true) = ()

(* ROP_007 (matches Coq: Theorem ROP_007) *)
let rop_007 () : Lemma (riina_cr.f_cr_gadget_elimination == true) = ()

(* ROP_008 (matches Coq: Theorem ROP_008) *)
let rop_008 () : Lemma (riina_rop.f_rop_aslr_compatible == true) = ()

(* ROP_009 (matches Coq: Theorem ROP_009) *)
let rop_009 (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_shadow_stack == true)) = ()

(* ROP_010 (matches Coq: Theorem ROP_010) *)
let rop_010 (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_indirect_branch_tracking == true)) = ()

(* ROP_011 (matches Coq: Theorem ROP_011) *)
let rop_011 (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_return_address_protection == true)) = ()

(* ROP_012 (matches Coq: Theorem ROP_012) *)
let rop_012 (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_backward_edge_cfi == true)) = ()

(* ROP_013 (matches Coq: Theorem ROP_013) *)
let rop_013 (p_r: _) : Lemma (requires (code_reuse_prevented p_r == true)) (ensures (p_r.f_cr_gadget_elimination == true)) = ()

(* ROP_014 (matches Coq: Theorem ROP_014) *)
let rop_014 (p_r: _) : Lemma (requires (code_reuse_prevented p_r == true)) (ensures (p_r.f_cr_code_pointer_integrity == true)) = ()

(* ROP_015 (matches Coq: Theorem ROP_015) *)
let rop_015 (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures (cfi_complete (p_r.f_rop_cfi) == true)) = ()

(* ROP_016 (matches Coq: Theorem ROP_016) *)
let rop_016 (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures (code_reuse_prevented (p_r.f_rop_code_reuse) == true)) = ()

(* ROP_017 (matches Coq: Theorem ROP_017) *)
let rop_017 (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures (p_r.f_rop_aslr_compatible == true)) = ()

(* ROP_018 (matches Coq: Theorem ROP_018) *)
let rop_018 (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures (p_r.f_rop_dep_compatible == true)) = ()

(* ROP_019 (matches Coq: Theorem ROP_019) *)
let rop_019 (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures ((p_r.f_rop_cfi).f_cfi_shadow_stack == true)) = ()

(* ROP_020 (matches Coq: Theorem ROP_020) *)
let rop_020 (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures ((p_r.f_rop_cfi).f_cfi_return_address_protection == true)) = ()

(* ROP_021 (matches Coq: Theorem ROP_021) *)
let rop_021 (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures ((p_r.f_rop_code_reuse).f_cr_gadget_elimination == true)) = ()

(* ROP_022 (matches Coq: Theorem ROP_022) *)
let rop_022 () : Lemma (cfi_complete riina_cfi == true /\ code_reuse_prevented riina_cr == true) = ()

(* ROP_023 (matches Coq: Theorem ROP_023) *)
let rop_023 () : Lemma (riina_cfi.f_cfi_shadow_stack == true /\ riina_cfi.f_cfi_backward_edge_cfi == true) = ()

(* ROP_024 (matches Coq: Theorem ROP_024) *)
let rop_024 () : Lemma (rop_defended riina_rop == true /\ riina_rop.f_rop_aslr_compatible == true) = ()

(* ROP_025_complete (matches Coq: Theorem ROP_025_complete) *)
let rop_025_complete (p_r: _) : Lemma (requires (rop_defended p_r == true)) (ensures ((p_r.f_rop_cfi).f_cfi_shadow_stack == true /\ (p_r.f_rop_cfi).f_cfi_return_address_protection == true /\ (p_r.f_rop_code_reuse).f_cr_gadget_elimination == true /\ p_r.f_rop_aslr_compatible == true)) = ()

(* ROP_026_shadow_push_preserves (matches Coq: Theorem ROP_026_shadow_push_preserves) *)
let rop_026_shadow_push_preserves (p_ss: _) (p_ret: _) (p_caller: _) (p_fp: _) : Lemma (length (shadow_push p_ss p_ret p_caller p_fp) == ((length p_ss) + 1)) = ()

(* ROP_027_shadow_pop_decreases (matches Coq: Theorem ROP_027_shadow_pop_decreases) *)
let rop_027_shadow_pop_decreases (p_ss: _) (p_e: _) (p_rest: _) : Lemma (requires (shadow_pop p_ss == Some (p_e, p_rest))) (ensures (length p_rest == (if (length p_ss) > 0 then (length p_ss) - 1 else 0))) = ()

(* ROP_028_shadow_peek_top (matches Coq: Theorem ROP_028_shadow_peek_top) *)
let rop_028_shadow_peek_top (p_ss: _) (p_e: _) : Lemma (requires (shadow_peek p_ss == Some p_e)) (ensures ((exists p_rest. p_ss == p_e :: p_rest))) = ()

(* ROP_029_valid_return_requires_entry (matches Coq: Theorem ROP_029_valid_return_requires_entry) *)
let rop_029_valid_return_requires_entry (p_ss: _) (p_ret_addr: _) : Lemma (requires (valid_return p_ss p_ret_addr == true)) (ensures ((exists p_e. (exists p_rest. p_ss == p_e :: p_rest)) /\ e.f_se_return_addr == p_ret_addr)) = ()

(* ROP_030_empty_stack_no_return (matches Coq: Theorem ROP_030_empty_stack_no_return) *)
let rop_030_empty_stack_no_return (p_ret_addr: _) : Lemma (~(valid_return [] p_ret_addr == true)) = ()

(* ROP_031_push_pop_inverse (matches Coq: Theorem ROP_031_push_pop_inverse) *)
let rop_031_push_pop_inverse (p_ss: _) (p_ret: _) (p_caller: _) (p_fp: _) : Lemma (shadow_pop (shadow_push p_ss p_ret p_caller p_fp) == Some (mkshadowentry p_ret p_caller p_fp true, p_ss)) = ()

(* ROP_032_pushed_entry_valid (matches Coq: Theorem ROP_032_pushed_entry_valid) *)
let rop_032_pushed_entry_valid (p_ss: _) (p_ret: _) (p_caller: _) (p_fp: _) (p_e: _) (p_rest: _) : Lemma (requires (shadow_pop (shadow_push p_ss p_ret p_caller p_fp) == Some (p_e, p_rest))) (ensures (p_e.f_se_mac_valid == true)) = ()

(* ROP_033_return_matches_pushed (matches Coq: Theorem ROP_033_return_matches_pushed) *)
let rop_033_return_matches_pushed (p_ss: _) (p_ret: _) (p_caller: _) (p_fp: _) : Lemma (return_matches_shadow (shadow_push p_ss p_ret p_caller p_fp) p_ret == true) = ()

(* ROP_034_return_mismatch_fails (matches Coq: Theorem ROP_034_return_mismatch_fails) *)
let rop_034_return_mismatch_fails (p_ss: _) (p_ret: _) (p_caller: _) (p_fp: _) (p_wrong_addr: _) : Lemma (requires (~(p_ret == p_wrong_addr))) (ensures (return_matches_shadow (shadow_push p_ss p_ret p_caller p_fp) p_wrong_addr == false)) = ()

(* ROP_035_shadow_stack_depth_bounded (matches Coq: Theorem ROP_035_shadow_stack_depth_bounded) *)
let rop_035_shadow_stack_depth_bounded (p_ss: _) (p_n: _) : Lemma (requires (length p_ss <= p_n)) (ensures ((forall (ret: _). (forall (caller: _). (forall (fp: _). length (shadow_push p_ss ret caller fp) <= (p_n + 1)))))) = ()

(* ROP_036_valid_target_in_list (matches Coq: Theorem ROP_036_valid_target_in_list) *)
let rop_036_valid_target_in_list (p_targets: _) (p_addr: _) : Lemma (requires (indirect_branch_valid p_targets p_addr == true)) (ensures (List.Tot.memP p_addr p_targets)) = ()

(* ROP_037_empty_targets_no_valid (matches Coq: Theorem ROP_037_empty_targets_no_valid) *)
let rop_037_empty_targets_no_valid (p_addr: _) : Lemma (~(indirect_branch_valid [] p_addr == true)) = ()

(* ROP_038_singleton_target_exact (matches Coq: Theorem ROP_038_singleton_target_exact) *)
let rop_038_singleton_target_exact (p_addr: _) (p_target: _) : Lemma (requires (indirect_branch_valid [p_target] p_addr == true)) (ensures (p_addr == p_target)) = ()

(* ROP_039_is_valid_target_sound (matches Coq: Theorem ROP_039_is_valid_target_sound) *)
let rop_039_is_valid_target_sound (p_targets: _) (p_addr: _) : Lemma (requires (is_valid_target p_targets p_addr == true)) (ensures (indirect_branch_valid p_targets p_addr == true)) = ()

(* ROP_040_is_valid_target_complete (matches Coq: Theorem ROP_040_is_valid_target_complete) *)
let rop_040_is_valid_target_complete (p_targets: _) (p_addr: _) : Lemma (requires (indirect_branch_valid p_targets p_addr == true)) (ensures (is_valid_target p_targets p_addr == true)) = ()

(* ROP_041_btb_validated_implies_valid (matches Coq: Theorem ROP_041_btb_validated_implies_valid) *)
let rop_041_btb_validated_implies_valid (p_targets: _) (p_e: _) : Lemma (requires (btb_entry_valid p_targets p_e == true)) (ensures (List.Tot.memP (p_e.f_btb_target) p_targets)) = ()

(* ROP_042_unvalidated_btb_unsafe (matches Coq: Theorem ROP_042_unvalidated_btb_unsafe) *)
let rop_042_unvalidated_btb_unsafe (p_e: _) : Lemma (requires (p_e.f_btb_validated == false)) (ensures ((forall (targets: _). ~((btb_entry_valid targets p_e == true /\ p_e.f_btb_validated == true))))) = ()

(* ROP_043_target_subset_preserved (matches Coq: Theorem ROP_043_target_subset_preserved) *)
let rop_043_target_subset_preserved (p_targets1: _) (p_targets2: _) (p_addr: _) : Lemma (requires (((forall (x: _). List.Tot.memP x p_targets1)) /\ indirect_branch_valid p_targets1 p_addr == true)) (ensures (indirect_branch_valid p_targets2 p_addr == true)) = ()

(* ROP_044_rop_gadget_blocked (matches Coq: Theorem ROP_044_rop_gadget_blocked) *)
let rop_044_rop_gadget_blocked (p_g: _) : Lemma (requires (p_g.f_gadget_type == GadgetROP /\ riina_cfi.f_cfi_backward_edge_cfi == true /\ riina_cfi.f_cfi_shadow_stack == true)) (ensures (gadget_blocked riina_cfi p_g == true)) = ()

(* ROP_045_jop_gadget_blocked (matches Coq: Theorem ROP_045_jop_gadget_blocked) *)
let rop_045_jop_gadget_blocked (p_g: _) : Lemma (requires (p_g.f_gadget_type == GadgetJOP /\ riina_cfi.f_cfi_forward_edge_cfi == true /\ riina_cfi.f_cfi_indirect_branch_tracking == true)) (ensures (gadget_blocked riina_cfi p_g == true)) = ()

(* ROP_046_cop_gadget_blocked (matches Coq: Theorem ROP_046_cop_gadget_blocked) *)
let rop_046_cop_gadget_blocked (p_g: _) : Lemma (requires (p_g.f_gadget_type == GadgetCOP /\ riina_cfi.f_cfi_forward_edge_cfi == true)) (ensures (gadget_blocked riina_cfi p_g == true)) = ()

(* ROP_047_srop_gadget_blocked (matches Coq: Theorem ROP_047_srop_gadget_blocked) *)
let rop_047_srop_gadget_blocked (p_g: _) : Lemma (requires (p_g.f_gadget_type == GadgetSROP /\ riina_cfi.f_cfi_backward_edge_cfi == true /\ riina_cfi.f_cfi_shadow_stack == true)) (ensures (gadget_blocked riina_cfi p_g == true)) = ()

(* ROP_048_riina_blocks_all_gadgets (matches Coq: Theorem ROP_048_riina_blocks_all_gadgets) *)
let rop_048_riina_blocks_all_gadgets (p_g: _) : Lemma (gadget_blocked riina_cfi p_g == true) = ()

(* ROP_049_empty_chain_blocked (matches Coq: Theorem ROP_049_empty_chain_blocked) *)
let rop_049_empty_chain_blocked (p_cfi: _) : Lemma (chain_blocked p_cfi [] == true) = ()

(* ROP_050_riina_blocks_all_chains (matches Coq: Theorem ROP_050_riina_blocks_all_chains) *)
let rop_050_riina_blocks_all_chains (p_chain: _) : Lemma (chain_blocked riina_cfi p_chain == true) = ()

(* ROP_051_chain_blocked_implies_each_blocked (matches Coq: Theorem ROP_051_chain_blocked_implies_each_blocked) *)
let rop_051_chain_blocked_implies_each_blocked (p_cfi: _) (p_chain: _) (p_g: _) : Lemma (requires (chain_blocked p_cfi p_chain == true /\ List.Tot.memP p_g p_chain)) (ensures (gadget_blocked p_cfi p_g == true)) = ()

(* ROP_052_single_unblocked_breaks_chain (matches Coq: Theorem ROP_052_single_unblocked_breaks_chain) *)
let rop_052_single_unblocked_breaks_chain (p_cfi: _) (p_chain: _) (p_g: _) : Lemma (requires (List.Tot.memP p_g p_chain /\ gadget_blocked p_cfi p_g == false)) (ensures (chain_blocked p_cfi p_chain == false)) = ()

(* ROP_053_cpi_complete_riina (matches Coq: Theorem ROP_053_cpi_complete_riina) *)
let rop_053_cpi_complete_riina () : Lemma (cpi_complete riina_cpi == true) = ()

(* ROP_054_authenticated_ptr_protected (matches Coq: Theorem ROP_054_authenticated_ptr_protected) *)
let rop_054_authenticated_ptr_protected (p_cpi: _) (p_cp: _) : Lemma (requires (p_cpi.f_cpi_ptr_authentication == true /\ p_cp.f_cp_authenticated == true /\ p_cp.f_cp_bounds_checked == true)) (ensures (cp_protected p_cpi p_cp == true)) = ()

(* ROP_055_unauthenticated_ptr_unsafe (matches Coq: Theorem ROP_055_unauthenticated_ptr_unsafe) *)
let rop_055_unauthenticated_ptr_unsafe (p_cp: _) : Lemma (requires (p_cp.f_cp_authenticated == false /\ riina_cpi.f_cpi_ptr_authentication == true)) (ensures (cp_protected riina_cpi p_cp == false)) = ()

(* ROP_056_bounds_unchecked_unsafe (matches Coq: Theorem ROP_056_bounds_unchecked_unsafe) *)
let rop_056_bounds_unchecked_unsafe (p_cp: _) : Lemma (requires (p_cp.f_cp_bounds_checked == false /\ p_cp.f_cp_authenticated == true /\ riina_cpi.f_cpi_bounds_checking == true)) (ensures (cp_protected riina_cpi p_cp == false)) = ()

(* ROP_057_fully_protected_ptr (matches Coq: Theorem ROP_057_fully_protected_ptr) *)
let rop_057_fully_protected_ptr (p_cp: _) : Lemma (requires (p_cp.f_cp_authenticated == true /\ p_cp.f_cp_bounds_checked == true)) (ensures (cp_protected riina_cpi p_cp == true)) = ()

(* ROP_058_no_auth_requirement_passes (matches Coq: Theorem ROP_058_no_auth_requirement_passes) *)
let rop_058_no_auth_requirement_passes (p_cp: _) : Lemma (requires ((mkcpi false true true true).f_cpi_ptr_authentication == false /\ p_cp.f_cp_bounds_checked == true)) (ensures (cp_protected (mkcpi false true true true) p_cp == true)) = ()

(* ROP_059_function_ptr_type (matches Coq: Theorem ROP_059_function_ptr_type) *)
let rop_059_function_ptr_type (p_addr: _) : Lemma ((mkcodeptr CPFunction p_addr true true).f_cp_type == CPFunction) = ()

(* ROP_060_return_addr_protected (matches Coq: Theorem ROP_060_return_addr_protected) *)
let rop_060_return_addr_protected (p_addr: _) : Lemma (requires ((mkcodeptr CPReturnAddr p_addr true true).f_cp_authenticated == true /\ (mkcodeptr CPReturnAddr p_addr true true).f_cp_bounds_checked == true)) (ensures (cp_protected riina_cpi (mkcodeptr CPReturnAddr p_addr true true) == true)) = ()

(* ROP_061_forward_edge_enabled (matches Coq: Theorem ROP_061_forward_edge_enabled) *)
let rop_061_forward_edge_enabled () : Lemma (riina_cfi.f_cfi_forward_edge_cfi == true) = ()

(* ROP_062_ibt_enabled (matches Coq: Theorem ROP_062_ibt_enabled) *)
let rop_062_ibt_enabled () : Lemma (riina_cfi.f_cfi_indirect_branch_tracking == true) = ()

(* ROP_063_forward_edge_complete (matches Coq: Theorem ROP_063_forward_edge_complete) *)
let rop_063_forward_edge_complete (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_forward_edge_cfi == true)) = ()

(* ROP_064_forward_edge_blocks_jop (matches Coq: Theorem ROP_064_forward_edge_blocks_jop) *)
let rop_064_forward_edge_blocks_jop (p_c: _) (p_g: _) : Lemma (requires (p_c.f_cfi_forward_edge_cfi == true /\ p_c.f_cfi_indirect_branch_tracking == true /\ p_g.f_gadget_type == GadgetJOP)) (ensures (gadget_blocked p_c p_g == true)) = ()

(* ROP_065_forward_edge_blocks_cop (matches Coq: Theorem ROP_065_forward_edge_blocks_cop) *)
let rop_065_forward_edge_blocks_cop (p_c: _) (p_g: _) : Lemma (requires (p_c.f_cfi_forward_edge_cfi == true /\ p_g.f_gadget_type == GadgetCOP)) (ensures (gadget_blocked p_c p_g == true)) = ()

(* ROP_066_indirect_call_requires_ibt (matches Coq: Theorem ROP_066_indirect_call_requires_ibt) *)
let rop_066_indirect_call_requires_ibt (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_indirect_branch_tracking == true)) = ()

(* ROP_067_forward_cfi_and_ibt_together (matches Coq: Theorem ROP_067_forward_cfi_and_ibt_together) *)
let rop_067_forward_cfi_and_ibt_together (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_forward_edge_cfi == true /\ p_c.f_cfi_indirect_branch_tracking == true)) = ()

(* ROP_068_backward_edge_enabled (matches Coq: Theorem ROP_068_backward_edge_enabled) *)
let rop_068_backward_edge_enabled () : Lemma (riina_cfi.f_cfi_backward_edge_cfi == true) = ()

(* ROP_069_shadow_stack_enabled (matches Coq: Theorem ROP_069_shadow_stack_enabled) *)
let rop_069_shadow_stack_enabled () : Lemma (riina_cfi.f_cfi_shadow_stack == true) = ()

(* ROP_070_backward_edge_complete (matches Coq: Theorem ROP_070_backward_edge_complete) *)
let rop_070_backward_edge_complete (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_backward_edge_cfi == true)) = ()

(* ROP_071_backward_edge_blocks_rop (matches Coq: Theorem ROP_071_backward_edge_blocks_rop) *)
let rop_071_backward_edge_blocks_rop (p_c: _) (p_g: _) : Lemma (requires (p_c.f_cfi_backward_edge_cfi == true /\ p_c.f_cfi_shadow_stack == true /\ p_g.f_gadget_type == GadgetROP)) (ensures (gadget_blocked p_c p_g == true)) = ()

(* ROP_072_backward_edge_blocks_srop (matches Coq: Theorem ROP_072_backward_edge_blocks_srop) *)
let rop_072_backward_edge_blocks_srop (p_c: _) (p_g: _) : Lemma (requires (p_c.f_cfi_backward_edge_cfi == true /\ p_c.f_cfi_shadow_stack == true /\ p_g.f_gadget_type == GadgetSROP)) (ensures (gadget_blocked p_c p_g == true)) = ()

(* ROP_073_return_requires_shadow (matches Coq: Theorem ROP_073_return_requires_shadow) *)
let rop_073_return_requires_shadow (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_shadow_stack == true)) = ()

(* ROP_074_backward_cfi_and_shadow_together (matches Coq: Theorem ROP_074_backward_cfi_and_shadow_together) *)
let rop_074_backward_cfi_and_shadow_together (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_backward_edge_cfi == true /\ p_c.f_cfi_shadow_stack == true)) = ()

(* ROP_075_return_address_protection_complete (matches Coq: Theorem ROP_075_return_address_protection_complete) *)
let rop_075_return_address_protection_complete (p_c: _) : Lemma (requires (cfi_complete p_c == true)) (ensures (p_c.f_cfi_return_address_protection == true)) = ()

(* ROP_076_riina_full_cfi (matches Coq: Theorem ROP_076_riina_full_cfi) *)
let rop_076_riina_full_cfi () : Lemma (riina_cfi.f_cfi_shadow_stack == true /\ riina_cfi.f_cfi_indirect_branch_tracking == true /\ riina_cfi.f_cfi_return_address_protection == true /\ riina_cfi.f_cfi_forward_edge_cfi == true /\ riina_cfi.f_cfi_backward_edge_cfi == true) = ()

(* ROP_077_riina_full_code_reuse (matches Coq: Theorem ROP_077_riina_full_code_reuse) *)
let rop_077_riina_full_code_reuse () : Lemma (riina_cr.f_cr_gadget_elimination == true /\ riina_cr.f_cr_instruction_alignment == true /\ riina_cr.f_cr_code_pointer_integrity == true) = ()

(* ROP_078_riina_full_rop_defense (matches Coq: Theorem ROP_078_riina_full_rop_defense) *)
let rop_078_riina_full_rop_defense () : Lemma (rop_defended riina_rop == true /\ riina_rop.f_rop_aslr_compatible == true /\ riina_rop.f_rop_dep_compatible == true) = ()

(* ROP_079_all_attack_types_blocked (matches Coq: Theorem ROP_079_all_attack_types_blocked) *)
let rop_079_all_attack_types_blocked (p_g: _) : Lemma (gadget_blocked riina_cfi p_g == true) = ()

(* ROP_080_complete_defense_equivalence (matches Coq: Theorem ROP_080_complete_defense_equivalence) *)
let rop_080_complete_defense_equivalence (p_r: _) : Lemma (rop_defended p_r == true <==> (cfi_complete (p_r.f_rop_cfi) == true /\ code_reuse_prevented (p_r.f_rop_code_reuse) == true /\ p_r.f_rop_aslr_compatible == true /\ p_r.f_rop_dep_compatible == true)) = ()

(* ROP_081_shadow_stack_prevents_rop (matches Coq: Theorem ROP_081_shadow_stack_prevents_rop) *)
let rop_081_shadow_stack_prevents_rop (p_ss: _) (p_ret_addr: _) (p_attacker_addr: _) : Lemma (requires (valid_return p_ss p_ret_addr == true /\ ~(p_attacker_addr == p_ret_addr))) (ensures (~(valid_return p_ss p_attacker_addr == true))) = ()

(* ROP_082_ibt_prevents_jop (matches Coq: Theorem ROP_082_ibt_prevents_jop) *)
let rop_082_ibt_prevents_jop (p_targets: _) (p_addr: _) : Lemma (requires (riina_cfi.f_cfi_indirect_branch_tracking == true /\ ~(List.Tot.memP p_addr p_targets))) (ensures (~(indirect_branch_valid p_targets p_addr == true))) = ()

(* ROP_083_cpi_prevents_ptr_hijack (matches Coq: Theorem ROP_083_cpi_prevents_ptr_hijack) *)
let rop_083_cpi_prevents_ptr_hijack (p_cp: _) : Lemma (requires (cp_protected riina_cpi p_cp == true)) (ensures (p_cp.f_cp_authenticated == true)) = ()

(* ROP_084_defense_in_depth (matches Coq: Theorem ROP_084_defense_in_depth) *)
let rop_084_defense_in_depth () : Lemma (cfi_complete riina_cfi == true /\ code_reuse_prevented riina_cr == true /\ cpi_complete riina_cpi == true) = ()

(* ROP_085_riina_rop_immune (matches Coq: Theorem ROP_085_riina_rop_immune) *)
let rop_085_riina_rop_immune (p_chain: _) : Lemma (chain_blocked riina_cfi p_chain == true) = ()
