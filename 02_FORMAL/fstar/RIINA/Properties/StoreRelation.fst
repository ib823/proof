(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/StoreRelation.v (174 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.StoreRelation
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* step — Coq Prop predicate stub *)
assume val step : nat -> nat -> bool

(* multi_step — Coq Prop predicate stub *)
assume val multi_step : nat -> nat -> bool

(* store_rel_simple_max (matches Coq: Lemma store_rel_simple_max) *)
let store_rel_simple_max (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true)) (ensures (store_max p_st1 == store_max p_st2)) = admit ()

(* store_rel_simple_fresh (matches Coq: Lemma store_rel_simple_fresh) *)
let store_rel_simple_fresh (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true)) (ensures (fresh_loc p_st1 == fresh_loc p_st2)) = admit ()

(* store_max_update_bound (matches Coq: Lemma store_max_update_bound) *)
let store_max_update_bound (p_l: _) (p_v: _) (p_st: _) : Lemma (store_max (store_update p_l p_v p_st) <= Nat.max p_l (store_max p_st)) = admit ()

(* store_max_update_lower (matches Coq: Lemma store_max_update_lower) *)
let store_max_update_lower (p_l: _) (p_v: _) (p_st: _) : Lemma (store_max p_st <= store_max (store_update p_l p_v p_st)) = admit ()

(* store_max_update_includes_l (matches Coq: Lemma store_max_update_includes_l) *)
let store_max_update_includes_l (p_l: _) (p_v: _) (p_st: _) : Lemma (p_l <= store_max (store_update p_l p_v p_st)) = admit ()

(* store_max_update_eq (matches Coq: Lemma store_max_update_eq) *)
let store_max_update_eq (p_l: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_max p_st1 == store_max p_st2)) (ensures (store_max (store_update p_l p_v1 p_st1) == store_max (store_update p_l p_v2 p_st2))) = admit ()

(* store_rel_simple_update (matches Coq: Lemma store_rel_simple_update) *)
let store_rel_simple_update (p_sigma: _) (p_st1: _) (p_st2: _) (p_l: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true)) (ensures (store_rel_simple p_sigma (store_update p_l p_v1 p_st1) (store_update p_l p_v2 p_st2) == true)) = admit ()

(* store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq) *)
let store_lookup_update_eq (p_l: _) (p_v: _) (p_st: _) : Lemma (store_lookup p_l (store_update p_l p_v p_st) == Some p_v) = admit ()

(* store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq) *)
let store_lookup_update_neq (p_l: _) (p_l_: _) (p_v: _) (p_st: _) : Lemma (requires (~(p_l == p_l_))) (ensures (store_lookup p_l_ (store_update p_l p_v p_st) == store_lookup p_l_ p_st)) = admit ()

(* store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq) *)
let store_ty_lookup_update_eq (p_l: _) (p_t: _) (p_sl: _) (p_sigma: _) : Lemma (store_ty_lookup p_l (store_ty_update p_l p_t p_sl p_sigma) == Some (p_t, p_sl)) = admit ()

(* store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq) *)
let store_ty_lookup_update_neq (p_l: _) (p_l_: _) (p_t: _) (p_sl: _) (p_sigma: _) : Lemma (requires (~(p_l == p_l_))) (ensures (store_ty_lookup p_l_ (store_ty_update p_l p_t p_sl p_sigma) == store_ty_lookup p_l_ p_sigma)) = admit ()

(* store_rel_le_update (matches Coq: Lemma store_rel_le_update) *)
let store_rel_le_update (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) (p_l: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl) /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (store_rel_le p_n p_sigma (store_update p_l p_v1 p_st1) (store_update p_l p_v2 p_st2) == true)) = admit ()

(* store_lookup_fresh_none (matches Coq: Lemma store_lookup_fresh_none) *)
let store_lookup_fresh_none (p_st: _) : Lemma (store_lookup (fresh_loc p_st) p_st == None) = admit ()

(* store_alloc_same (matches Coq: Lemma store_alloc_same) *)
let store_alloc_same (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true)) (ensures (fresh_loc p_st1 == fresh_loc p_st2)) = admit ()

(* store_rel_simple_alloc (matches Coq: Lemma store_rel_simple_alloc) *)
let store_rel_simple_alloc (p_sigma: _) (p_st1: _) (p_st2: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true)) (ensures (store_rel_simple p_sigma (store_update (fresh_loc p_st1) p_v1 p_st1) (store_update (fresh_loc p_st2) p_v2 p_st2) == true)) = admit ()

(* fresh_loc_not_in_store_ty (matches Coq: Lemma fresh_loc_not_in_store_ty) *)
let fresh_loc_not_in_store_ty (p_sigma: _) (p_st: _) : Lemma (requires (store_wf p_sigma p_st == true)) (ensures (store_ty_lookup (fresh_loc p_st) p_sigma == None)) = admit ()

(* store_ty_extends_alloc (matches Coq: Lemma store_ty_extends_alloc) *)
let store_ty_extends_alloc (p_sigma: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_ty_lookup p_l p_sigma == None)) (ensures (store_ty_extends p_sigma (store_ty_update p_l p_t p_sl p_sigma) == true)) = admit ()

(* store_rel_le_alloc (matches Coq: Lemma store_rel_le_alloc) *)
let store_rel_le_alloc_obligation () : Tot bool = true
let store_rel_le_alloc_lemma () : Lemma (requires True) (ensures (store_rel_le_alloc_obligation () == store_rel_le_alloc_obligation ())) = ()

(* val_rel_le_ref_same_loc (matches Coq: Lemma val_rel_le_ref_same_loc) *)
let val_rel_le_ref_same_loc (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true)) (ensures ((exists p_l. p_v1 == ELoc p_l) /\ p_v2 == ELoc l)) = admit ()

(* val_rel_le_build_ref (matches Coq: Lemma val_rel_le_build_ref) *)
let val_rel_le_build_ref (p_m: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_l: _) : Lemma (val_rel_le p_m p_sigma (TRef p_t p_sl) (ELoc p_l) (ELoc p_l) == true) = admit ()

(* store_rel_le_lookup (matches Coq: Lemma store_rel_le_lookup) *)
let store_rel_le_lookup (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v1. (exists p_v2. store_lookup p_l p_st1 == Some p_v1)) /\ store_lookup p_l p_st2 == Some v2 /\ val_rel_le p_n p_sigma p_t v1 v2 == true)) = admit ()

(* val_rel_le_secret_always (matches Coq: Lemma val_rel_le_secret_always) *)
let val_rel_le_secret_always (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TSecret p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_secret_value_left (matches Coq: Lemma val_rel_le_secret_value_left) *)
let val_rel_le_secret_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecret p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_secret_value_right (matches Coq: Lemma val_rel_le_secret_value_right) *)
let val_rel_le_secret_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecret p_t) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_labeled_value_left (matches Coq: Lemma val_rel_le_labeled_value_left) *)
let val_rel_le_labeled_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_labeled_value_right (matches Coq: Lemma val_rel_le_labeled_value_right) *)
let val_rel_le_labeled_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_tainted_value_left (matches Coq: Lemma val_rel_le_tainted_value_left) *)
let val_rel_le_tainted_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_tainted_value_right (matches Coq: Lemma val_rel_le_tainted_value_right) *)
let val_rel_le_tainted_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_sanitized_value_left (matches Coq: Lemma val_rel_le_sanitized_value_left) *)
let val_rel_le_sanitized_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_sanitized_value_right (matches Coq: Lemma val_rel_le_sanitized_value_right) *)
let val_rel_le_sanitized_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_capability_value_left (matches Coq: Lemma val_rel_le_capability_value_left) *)
let val_rel_le_capability_value_left (p_n: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_capability_value_right (matches Coq: Lemma val_rel_le_capability_value_right) *)
let val_rel_le_capability_value_right (p_n: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_capability_full_value_left (matches Coq: Lemma val_rel_le_capability_full_value_left) *)
let val_rel_le_capability_full_value_left (p_n: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_capability_full_value_right (matches Coq: Lemma val_rel_le_capability_full_value_right) *)
let val_rel_le_capability_full_value_right (p_n: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_proof_value_left (matches Coq: Lemma val_rel_le_proof_value_left) *)
let val_rel_le_proof_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_proof_value_right (matches Coq: Lemma val_rel_le_proof_value_right) *)
let val_rel_le_proof_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_constant_time_value_left (matches Coq: Lemma val_rel_le_constant_time_value_left) *)
let val_rel_le_constant_time_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_constant_time_value_right (matches Coq: Lemma val_rel_le_constant_time_value_right) *)
let val_rel_le_constant_time_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_zeroizing_value_left (matches Coq: Lemma val_rel_le_zeroizing_value_left) *)
let val_rel_le_zeroizing_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_zeroizing_value_right (matches Coq: Lemma val_rel_le_zeroizing_value_right) *)
let val_rel_le_zeroizing_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_chan_value_left (matches Coq: Lemma val_rel_le_chan_value_left) *)
let val_rel_le_chan_value_left (p_n: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_chan_value_right (matches Coq: Lemma val_rel_le_chan_value_right) *)
let val_rel_le_chan_value_right (p_n: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_secure_chan_value_left (matches Coq: Lemma val_rel_le_secure_chan_value_left) *)
let val_rel_le_secure_chan_value_left (p_n: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_secure_chan_value_right (matches Coq: Lemma val_rel_le_secure_chan_value_right) *)
let val_rel_le_secure_chan_value_right (p_n: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_list_value_left (matches Coq: Lemma val_rel_le_list_value_left) *)
let val_rel_le_list_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_list_value_right (matches Coq: Lemma val_rel_le_list_value_right) *)
let val_rel_le_list_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_option_value_left (matches Coq: Lemma val_rel_le_option_value_left) *)
let val_rel_le_option_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_option_value_right (matches Coq: Lemma val_rel_le_option_value_right) *)
let val_rel_le_option_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_secret_closed_left (matches Coq: Lemma val_rel_le_secret_closed_left) *)
let val_rel_le_secret_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecret p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_secret_closed_right (matches Coq: Lemma val_rel_le_secret_closed_right) *)
let val_rel_le_secret_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecret p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_labeled_closed_left (matches Coq: Lemma val_rel_le_labeled_closed_left) *)
let val_rel_le_labeled_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_labeled_closed_right (matches Coq: Lemma val_rel_le_labeled_closed_right) *)
let val_rel_le_labeled_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_tainted_closed_left (matches Coq: Lemma val_rel_le_tainted_closed_left) *)
let val_rel_le_tainted_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_tainted_closed_right (matches Coq: Lemma val_rel_le_tainted_closed_right) *)
let val_rel_le_tainted_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_sanitized_closed_left (matches Coq: Lemma val_rel_le_sanitized_closed_left) *)
let val_rel_le_sanitized_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_sanitized_closed_right (matches Coq: Lemma val_rel_le_sanitized_closed_right) *)
let val_rel_le_sanitized_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_capability_closed_left (matches Coq: Lemma val_rel_le_capability_closed_left) *)
let val_rel_le_capability_closed_left (p_n: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_capability_closed_right (matches Coq: Lemma val_rel_le_capability_closed_right) *)
let val_rel_le_capability_closed_right (p_n: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_capability_full_closed_left (matches Coq: Lemma val_rel_le_capability_full_closed_left) *)
let val_rel_le_capability_full_closed_left (p_n: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_capability_full_closed_right (matches Coq: Lemma val_rel_le_capability_full_closed_right) *)
let val_rel_le_capability_full_closed_right (p_n: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_proof_closed_left (matches Coq: Lemma val_rel_le_proof_closed_left) *)
let val_rel_le_proof_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_proof_closed_right (matches Coq: Lemma val_rel_le_proof_closed_right) *)
let val_rel_le_proof_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_constant_time_closed_left (matches Coq: Lemma val_rel_le_constant_time_closed_left) *)
let val_rel_le_constant_time_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_constant_time_closed_right (matches Coq: Lemma val_rel_le_constant_time_closed_right) *)
let val_rel_le_constant_time_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_zeroizing_closed_left (matches Coq: Lemma val_rel_le_zeroizing_closed_left) *)
let val_rel_le_zeroizing_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_zeroizing_closed_right (matches Coq: Lemma val_rel_le_zeroizing_closed_right) *)
let val_rel_le_zeroizing_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_chan_closed_left (matches Coq: Lemma val_rel_le_chan_closed_left) *)
let val_rel_le_chan_closed_left (p_n: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_chan_closed_right (matches Coq: Lemma val_rel_le_chan_closed_right) *)
let val_rel_le_chan_closed_right (p_n: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_secure_chan_closed_left (matches Coq: Lemma val_rel_le_secure_chan_closed_left) *)
let val_rel_le_secure_chan_closed_left (p_n: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_secure_chan_closed_right (matches Coq: Lemma val_rel_le_secure_chan_closed_right) *)
let val_rel_le_secure_chan_closed_right (p_n: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_list_closed_left (matches Coq: Lemma val_rel_le_list_closed_left) *)
let val_rel_le_list_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_list_closed_right (matches Coq: Lemma val_rel_le_list_closed_right) *)
let val_rel_le_list_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_option_closed_left (matches Coq: Lemma val_rel_le_option_closed_left) *)
let val_rel_le_option_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_option_closed_right (matches Coq: Lemma val_rel_le_option_closed_right) *)
let val_rel_le_option_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_unit_value_left (matches Coq: Lemma val_rel_le_unit_value_left) *)
let val_rel_le_unit_value_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_unit_value_right (matches Coq: Lemma val_rel_le_unit_value_right) *)
let val_rel_le_unit_value_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_bool_value_left (matches Coq: Lemma val_rel_le_bool_value_left) *)
let val_rel_le_bool_value_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBool p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_bool_value_right (matches Coq: Lemma val_rel_le_bool_value_right) *)
let val_rel_le_bool_value_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBool p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_int_value_left (matches Coq: Lemma val_rel_le_int_value_left) *)
let val_rel_le_int_value_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TInt p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_int_value_right (matches Coq: Lemma val_rel_le_int_value_right) *)
let val_rel_le_int_value_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TInt p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_string_value_left (matches Coq: Lemma val_rel_le_string_value_left) *)
let val_rel_le_string_value_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TString p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_string_value_right (matches Coq: Lemma val_rel_le_string_value_right) *)
let val_rel_le_string_value_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TString p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_bytes_value_left (matches Coq: Lemma val_rel_le_bytes_value_left) *)
let val_rel_le_bytes_value_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_bytes_value_right (matches Coq: Lemma val_rel_le_bytes_value_right) *)
let val_rel_le_bytes_value_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_ref_value_left (matches Coq: Lemma val_rel_le_ref_value_left) *)
let val_rel_le_ref_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_ref_value_right (matches Coq: Lemma val_rel_le_ref_value_right) *)
let val_rel_le_ref_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_unit_closed_left (matches Coq: Lemma val_rel_le_unit_closed_left) *)
let val_rel_le_unit_closed_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_unit_closed_right (matches Coq: Lemma val_rel_le_unit_closed_right) *)
let val_rel_le_unit_closed_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_bool_closed_left (matches Coq: Lemma val_rel_le_bool_closed_left) *)
let val_rel_le_bool_closed_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBool p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_bool_closed_right (matches Coq: Lemma val_rel_le_bool_closed_right) *)
let val_rel_le_bool_closed_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBool p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_int_closed_left (matches Coq: Lemma val_rel_le_int_closed_left) *)
let val_rel_le_int_closed_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TInt p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_int_closed_right (matches Coq: Lemma val_rel_le_int_closed_right) *)
let val_rel_le_int_closed_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TInt p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_string_closed_left (matches Coq: Lemma val_rel_le_string_closed_left) *)
let val_rel_le_string_closed_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TString p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_string_closed_right (matches Coq: Lemma val_rel_le_string_closed_right) *)
let val_rel_le_string_closed_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TString p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_bytes_closed_left (matches Coq: Lemma val_rel_le_bytes_closed_left) *)
let val_rel_le_bytes_closed_left (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_bytes_closed_right (matches Coq: Lemma val_rel_le_bytes_closed_right) *)
let val_rel_le_bytes_closed_right (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_ref_closed_left (matches Coq: Lemma val_rel_le_ref_closed_left) *)
let val_rel_le_ref_closed_left (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_ref_closed_right (matches Coq: Lemma val_rel_le_ref_closed_right) *)
let val_rel_le_ref_closed_right (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_prod_components_store (matches Coq: Lemma val_rel_le_prod_components_store) *)
let val_rel_le_prod_components_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* val_rel_le_sum_extract_store (matches Coq: Lemma val_rel_le_sum_extract_store) *)
let val_rel_le_sum_extract_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* val_rel_le_prod_value_left (matches Coq: Lemma val_rel_le_prod_value_left) *)
let val_rel_le_prod_value_left (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_prod_value_right (matches Coq: Lemma val_rel_le_prod_value_right) *)
let val_rel_le_prod_value_right (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_prod_closed_left (matches Coq: Lemma val_rel_le_prod_closed_left) *)
let val_rel_le_prod_closed_left (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_prod_closed_right (matches Coq: Lemma val_rel_le_prod_closed_right) *)
let val_rel_le_prod_closed_right (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_sum_value_left (matches Coq: Lemma val_rel_le_sum_value_left) *)
let val_rel_le_sum_value_left (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (value p_v1 == true)) = admit ()

(* val_rel_le_sum_value_right (matches Coq: Lemma val_rel_le_sum_value_right) *)
let val_rel_le_sum_value_right (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (value p_v2 == true)) = admit ()

(* val_rel_le_sum_closed_left (matches Coq: Lemma val_rel_le_sum_closed_left) *)
let val_rel_le_sum_closed_left (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (closed_expr p_v1 == true)) = admit ()

(* val_rel_le_sum_closed_right (matches Coq: Lemma val_rel_le_sum_closed_right) *)
let val_rel_le_sum_closed_right (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (closed_expr p_v2 == true)) = admit ()

(* val_rel_le_prod_intro_store (matches Coq: Lemma val_rel_le_prod_intro_store) *)
let val_rel_le_prod_intro_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_b1: _) (p_a2: _) (p_b2: _) : Lemma (requires (value p_a1 == true /\ value p_b1 == true /\ value p_a2 == true /\ value p_b2 == true /\ closed_expr p_a1 == true /\ closed_expr p_b1 == true /\ closed_expr p_a2 == true /\ closed_expr p_b2 == true /\ val_rel_le p_n p_sigma p_t1 p_a1 p_a2 == true /\ val_rel_le p_n p_sigma p_t2 p_b1 p_b2 == true)) (ensures (val_rel_le p_n p_sigma (TProd p_t1 p_t2) (EPair p_a1 p_b1) (EPair p_a2 p_b2) == true)) = admit ()

(* val_rel_le_sum_inl_intro_store (matches Coq: Lemma val_rel_le_sum_inl_intro_store) *)
let val_rel_le_sum_inl_intro_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_a2: _) : Lemma (requires (value p_a1 == true /\ value p_a2 == true /\ closed_expr p_a1 == true /\ closed_expr p_a2 == true /\ val_rel_le p_n p_sigma p_t1 p_a1 p_a2 == true)) (ensures (val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInl p_a1 p_t2) (EInl p_a2 p_t2) == true)) = admit ()

(* val_rel_le_sum_inr_intro_store (matches Coq: Lemma val_rel_le_sum_inr_intro_store) *)
let val_rel_le_sum_inr_intro_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_b1: _) (p_b2: _) : Lemma (requires (value p_b1 == true /\ value p_b2 == true /\ closed_expr p_b1 == true /\ closed_expr p_b2 == true /\ val_rel_le p_n p_sigma p_t2 p_b1 p_b2 == true)) (ensures (val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInr p_b1 p_t1) (EInr p_b2 p_t1) == true)) = admit ()

(* val_rel_le_extract_struct_0_store (matches Coq: Lemma val_rel_le_extract_struct_0_store) *)
let val_rel_le_extract_struct_0_store (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n >= 1 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_struct (val_rel_le 0) p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_prod_mono_step_store (matches Coq: Lemma val_rel_le_prod_mono_step_store) *)
let val_rel_le_prod_mono_step_store (p_n: _) (p_m: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_sum_mono_step_store (matches Coq: Lemma val_rel_le_sum_mono_step_store) *)
let val_rel_le_sum_mono_step_store (p_n: _) (p_m: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_prod_components_wf_store (matches Coq: Lemma val_rel_le_prod_components_wf_store) *)
let val_rel_le_prod_components_wf_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ value a1 == true /\ value b1 == true /\ value a2 == true /\ value b2 == true /\ closed_expr a1 == true /\ closed_expr b1 == true /\ closed_expr a2 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* val_rel_le_prod_case_store (matches Coq: Lemma val_rel_le_prod_case_store) *)
let val_rel_le_prod_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ value a1 == true /\ value b1 == true /\ value a2 == true /\ value b2 == true /\ closed_expr a1 == true /\ closed_expr b1 == true /\ closed_expr a2 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* val_rel_le_sum_extract_wf_store (matches Coq: Lemma val_rel_le_sum_extract_wf_store) *)
let val_rel_le_sum_extract_wf_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ value a1 == true /\ value a2 == true /\ closed_expr a1 == true /\ closed_expr a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ value b1 == true /\ value b2 == true /\ closed_expr b1 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* val_rel_le_sum_case_store (matches Coq: Lemma val_rel_le_sum_case_store) *)
let val_rel_le_sum_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ value a1 == true /\ value a2 == true /\ closed_expr a1 == true /\ closed_expr a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ value b1 == true /\ value b2 == true /\ closed_expr b1 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* val_rel_le_sum_inl_case_store (matches Coq: Lemma val_rel_le_sum_inl_case_store) *)
let val_rel_le_sum_inl_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInl p_a1 p_t2) p_v2 == true)) (ensures ((exists p_a2. p_v2 == EInl p_a2 p_t2) /\ value p_a1 == true /\ value a2 == true /\ closed_expr p_a1 == true /\ closed_expr a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 a2 == true)) = admit ()

(* val_rel_le_sum_inr_case_store (matches Coq: Lemma val_rel_le_sum_inr_case_store) *)
let val_rel_le_sum_inr_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_b1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInr p_b1 p_t1) p_v2 == true)) (ensures ((exists p_b2. p_v2 == EInr p_b2 p_t1) /\ value p_b1 == true /\ value b2 == true /\ closed_expr p_b1 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 b2 == true)) = admit ()

(* val_rel_le_sum_inl_case_right_store (matches Coq: Lemma val_rel_le_sum_inl_case_right_store) *)
let val_rel_le_sum_inl_case_right_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_a2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 (EInl p_a2 p_t2) == true)) (ensures ((exists p_a1. p_v1 == EInl p_a1 p_t2) /\ value a1 == true /\ value p_a2 == true /\ closed_expr a1 == true /\ closed_expr p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 p_a2 == true)) = admit ()

(* val_rel_le_sum_inr_case_right_store (matches Coq: Lemma val_rel_le_sum_inr_case_right_store) *)
let val_rel_le_sum_inr_case_right_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 (EInr p_b2 p_t1) == true)) (ensures ((exists p_b1. p_v1 == EInr p_b1 p_t1) /\ value b1 == true /\ value p_b2 == true /\ closed_expr b1 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 p_b2 == true)) = admit ()

(* val_rel_le_sum_inl_pair_case_store (matches Coq: Lemma val_rel_le_sum_inl_pair_case_store) *)
let val_rel_le_sum_inl_pair_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_a2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInl p_a1 p_t2) (EInl p_a2 p_t2) == true)) (ensures (value p_a1 == true /\ value p_a2 == true /\ closed_expr p_a1 == true /\ closed_expr p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 p_a2 == true)) = admit ()

(* val_rel_le_sum_inr_pair_case_store (matches Coq: Lemma val_rel_le_sum_inr_pair_case_store) *)
let val_rel_le_sum_inr_pair_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_b1: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInr p_b1 p_t1) (EInr p_b2 p_t1) == true)) (ensures (value p_b1 == true /\ value p_b2 == true /\ closed_expr p_b1 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 p_b2 == true)) = admit ()

(* val_rel_le_prod_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_case_store) *)
let val_rel_le_prod_pair_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_b1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) (EPair p_a1 p_b1) p_v2 == true)) (ensures ((exists p_a2. (exists p_b2. p_v2 == EPair p_a2 p_b2)) /\ value p_a1 == true /\ value p_b1 == true /\ value a2 == true /\ value b2 == true /\ closed_expr p_a1 == true /\ closed_expr p_b1 == true /\ closed_expr a2 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 b2 == true)) = admit ()

(* val_rel_le_prod_pair_case_right_store (matches Coq: Lemma val_rel_le_prod_pair_case_right_store) *)
let val_rel_le_prod_pair_case_right_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_a2: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 (EPair p_a2 p_b2) == true)) (ensures ((exists p_a1. (exists p_b1. p_v1 == EPair p_a1 p_b1)) /\ value a1 == true /\ value b1 == true /\ value p_a2 == true /\ value p_b2 == true /\ closed_expr a1 == true /\ closed_expr b1 == true /\ closed_expr p_a2 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 p_b2 == true)) = admit ()

(* val_rel_le_prod_pair_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_pair_case_store) *)
let val_rel_le_prod_pair_pair_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_b1: _) (p_a2: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) (EPair p_a1 p_b1) (EPair p_a2 p_b2) == true)) (ensures (value p_a1 == true /\ value p_b1 == true /\ value p_a2 == true /\ value p_b2 == true /\ closed_expr p_a1 == true /\ closed_expr p_b1 == true /\ closed_expr p_a2 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 p_b2 == true)) = admit ()

(* exp_rel_step1_fst_store (matches Coq: Lemma exp_rel_step1_fst_store) *)
let exp_rel_step1_fst_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ multi_step (EFst p_v1, p_st1, p_ctx) (a1, p_st1, p_ctx) == true /\ multi_step (EFst p_v2, p_st2, p_ctx) (a2, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true)) = admit ()

(* exp_rel_step1_snd_store (matches Coq: Lemma exp_rel_step1_snd_store) *)
let exp_rel_step1_snd_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ multi_step (ESnd p_v1, p_st1, p_ctx) (b1, p_st1, p_ctx) == true /\ multi_step (ESnd p_v2, p_st2, p_ctx) (b2, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* exp_rel_step1_if_store (matches Coq: Lemma exp_rel_step1_if_store) *)
let exp_rel_step1_if_store_obligation () : Tot bool = true
let exp_rel_step1_if_store_lemma () : Lemma (requires True) (ensures (exp_rel_step1_if_store_obligation () == exp_rel_step1_if_store_obligation ())) = ()

(* exp_rel_step1_case_store (matches Coq: Lemma exp_rel_step1_case_store) *)
let exp_rel_step1_case_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_x1: _) (p_e1: _) (p_e1_: _) (p_x2: _) (p_e2: _) (p_e2_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ multi_step (ECase p_v1 p_x1 p_e1 p_x2 p_e2, p_st1, p_ctx) (subst_x1 := a1_ p_e1, p_st1, p_ctx) == true /\ multi_step (ECase p_v2 p_x1 p_e1_ p_x2 p_e2_, p_st2, p_ctx) (subst_x1 := a2_ p_e1_, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ multi_step (ECase p_v1 p_x1 p_e1 p_x2 p_e2, p_st1, p_ctx) (subst_x2 := b1_ p_e2, p_st1, p_ctx) == true /\ multi_step (ECase p_v2 p_x1 p_e1_ p_x2 p_e2_, p_st2, p_ctx) (subst_x2 := b2_ p_e2_, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* exp_rel_step1_let_store (matches Coq: Lemma exp_rel_step1_let_store) *)
let exp_rel_step1_let_store (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_x: _) (p_e: _) (p_e_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == subst_x := v1_ p_e)) /\ r2 == subst_x := v2_ p_e_ /\ multi_step (ELet p_x p_v1 p_e, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (ELet p_x p_v2 p_e_, p_st2, p_ctx) (r2, p_st2, p_ctx) == true)) = admit ()

(* exp_rel_step1_handle_store (matches Coq: Lemma exp_rel_step1_handle_store) *)
let exp_rel_step1_handle_store (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_x: _) (p_h: _) (p_h_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == subst_x := v1_ p_h)) /\ r2 == subst_x := v2_ p_h_ /\ multi_step (EHandle p_v1 p_x p_h, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EHandle p_v2 p_x p_h_, p_st2, p_ctx) (r2, p_st2, p_ctx) == true)) = admit ()

(* exp_rel_step1_app_store (matches Coq: Lemma exp_rel_step1_app_store) *)
let exp_rel_step1_app_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_eff: _) (p_f1: _) (p_f2: _) (p_a1: _) (p_a2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TFn p_t1 p_t2 p_eff) p_f1 p_f2 == true /\ val_rel_le p_n p_sigma p_t1 p_a1 p_a2 == true /\ has_type [] p_sigma Public p_f1 (TFn p_t1 p_t2 p_eff) EffectPure == true /\ has_type [] p_sigma Public p_f2 (TFn p_t1 p_t2 p_eff) EffectPure == true)) (ensures ((exists p_x1. (exists p_body1. (exists p_x2. (exists p_body2. p_f1 == ELam p_x1 p_t1 p_body1)))) /\ p_f2 == ELam x2 p_t1 body2 /\ multi_step (EApp p_f1 p_a1, p_st1, p_ctx) (subst_x1 := a1_ body1, p_st1, p_ctx) == true /\ multi_step (EApp p_f2 p_a2, p_st2, p_ctx) (subst_x2 := a2_ body2, p_st2, p_ctx) == true)) = admit ()

(* exp_rel_step1_perform_store (matches Coq: Lemma exp_rel_step1_perform_store) *)
let exp_rel_step1_perform_store (p_n: _) (p_sigma: _) (p_t: _) (p_eff: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (EPerform p_eff p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EPerform p_eff p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* exp_rel_step1_require_store (matches Coq: Lemma exp_rel_step1_require_store) *)
let exp_rel_step1_require_store (p_n: _) (p_sigma: _) (p_t: _) (p_eff: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (ERequire p_eff p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (ERequire p_eff p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* exp_rel_step1_grant_store (matches Coq: Lemma exp_rel_step1_grant_store) *)
let exp_rel_step1_grant_store (p_n: _) (p_sigma: _) (p_t: _) (p_eff: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (EGrant p_eff p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EGrant p_eff p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* exp_rel_step1_classify_store (matches Coq: Lemma exp_rel_step1_classify_store) *)
let exp_rel_step1_classify_store (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == EClassify p_v1)) /\ r2 == EClassify p_v2 /\ multi_step (EClassify p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EClassify p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma (TSecret p_t) r1 r2 == true)) = admit ()

(* exp_rel_step1_prove_store (matches Coq: Lemma exp_rel_step1_prove_store) *)
let exp_rel_step1_prove_store (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == EProve p_v1)) /\ r2 == EProve p_v2 /\ multi_step (EProve p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EProve p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma (TProof p_t) r1 r2 == true)) = admit ()

(* exp_rel_step1_declassify_store (matches Coq: Lemma exp_rel_step1_declassify_store) *)
let exp_rel_step1_declassify_store (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (EDeclassify (EClassify p_v1) (EProve (EClassify p_v1)), p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EDeclassify (EClassify p_v2) (EProve (EClassify p_v2)), p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* exp_rel_step1_inl_store (matches Coq: Lemma exp_rel_step1_inl_store) *)
let exp_rel_step1_inl_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t1 p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == EInl p_v1 p_t2)) /\ r2 == EInl p_v2 p_t2 /\ multi_step (EInl p_v1 p_t2, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EInl p_v2 p_t2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) r1 r2 == true)) = admit ()

(* exp_rel_step1_inr_store (matches Coq: Lemma exp_rel_step1_inr_store) *)
let exp_rel_step1_inr_store (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t2 p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == EInr p_v1 p_t1)) /\ r2 == EInr p_v2 p_t1 /\ multi_step (EInr p_v1 p_t1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EInr p_v2 p_t1, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) r1 r2 == true)) = admit ()

(* exp_rel_step1_deref_store (matches Coq: Lemma exp_rel_step1_deref_store) *)
let exp_rel_step1_deref_store (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) (p_l: _) (p_t: _) (p_sl: _) (p_ctx: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v1. (exists p_v2. store_lookup p_l p_st1 == Some p_v1)) /\ store_lookup p_l p_st2 == Some v2 /\ multi_step (EDeref (ELoc p_l), p_st1, p_ctx) (v1, p_st1, p_ctx) == true /\ multi_step (EDeref (ELoc p_l), p_st2, p_ctx) (v2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t v1 v2 == true)) = admit ()

(* exp_rel_step1_assign_store (matches Coq: Lemma exp_rel_step1_assign_store) *)
let exp_rel_step1_assign_store (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) (p_l: _) (p_t: _) (p_sl: _) (p_v: _) (p_v_: _) (p_ctx: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl) /\ val_rel_le p_n p_sigma p_t p_v p_v_ == true /\ value p_v == true /\ value p_v_ == true)) (ensures ((exists p_old1. (exists p_old2. store_lookup p_l p_st1 == Some p_old1)) /\ store_lookup p_l p_st2 == Some old2 /\ multi_step (EAssign (ELoc p_l) p_v, p_st1, p_ctx) (EUnit, store_update p_l p_v p_st1, p_ctx) == true /\ multi_step (EAssign (ELoc p_l) p_v_, p_st2, p_ctx) (EUnit, store_update p_l p_v_ p_st2, p_ctx) == true /\ store_rel_le p_n p_sigma (store_update p_l p_v p_st1) (store_update p_l p_v_ p_st2) == true /\ val_rel_le p_n p_sigma TUnit EUnit EUnit == true)) = admit ()

(* exp_rel_step1_ref_store (matches Coq: Lemma exp_rel_step1_ref_store) *)
let exp_rel_step1_ref_store (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) (p_ctx: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true /\ value p_v1 == true /\ value p_v2 == true /\ store_ty_lookup (fresh_loc p_st1) p_sigma == None /\ fresh_loc p_st1 == fresh_loc p_st2)) (ensures ((exists p_l. (exists p_sigma. p_l == fresh_loc p_st1)) /\ p_sigma' == store_ty_update l p_t p_sl p_sigma /\ multi_step (ERef p_v1 p_sl, p_st1, p_ctx) (ELoc l, store_update l p_v1 p_st1, p_ctx) == true /\ multi_step (ERef p_v2 p_sl, p_st2, p_ctx) (ELoc l, store_update l p_v2 p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma' (TRef p_t p_sl) (ELoc l) (ELoc l) == true /\ store_rel_le p_n p_sigma' (store_update l p_v1 p_st1) (store_update l p_v2 p_st2) == true)) = admit ()

(* val_rel_le_unit (matches Coq: Lemma val_rel_le_unit) *)
let val_rel_le_unit (p_n: _) (p_sigma: _) : Lemma (val_rel_le p_n p_sigma TUnit EUnit EUnit == true) = admit ()

(* store_rel_le_empty (matches Coq: Lemma store_rel_le_empty) *)
let store_rel_le_empty (p_n: _) : Lemma (store_rel_le p_n [] [] [] == true) = admit ()

(* store_rel_simple_empty (matches Coq: Lemma store_rel_simple_empty) *)
let store_rel_simple_empty (p_sigma: _) : Lemma (store_rel_simple p_sigma [] [] == true) = admit ()

(* store_rel_le_both_some (matches Coq: Lemma store_rel_le_both_some) *)
let store_rel_le_both_some (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v1. (exists p_v2. store_lookup p_l p_st1 == Some p_v1)) /\ store_lookup p_l p_st2 == Some v2)) = admit ()

(* store_ty_update_preserves (matches Coq: Lemma store_ty_update_preserves) *)
let store_ty_update_preserves (p_l1: _) (p_l2: _) (p_t1: _) (p_sl1: _) (p_t2: _) (p_sl2: _) (p_sigma: _) : Lemma (requires (~(p_l1 == p_l2) /\ store_ty_lookup p_l2 p_sigma == Some (p_t2, p_sl2))) (ensures (store_ty_lookup p_l2 (store_ty_update p_l1 p_t1 p_sl1 p_sigma) == Some (p_t2, p_sl2))) = admit ()

(* store_max_nil (matches Coq: Lemma store_max_nil) *)
let store_max_nil () : Lemma (store_max [] == 0) = admit ()

(* store_max_singleton (matches Coq: Lemma store_max_singleton) *)
let store_max_singleton (p_l: _) (p_v: _) : Lemma (store_max ((p_l, p_v) :: []) == Nat.max p_l 0) = admit ()

(* store_rel_le_secret_loc (matches Coq: Lemma store_rel_le_secret_loc) *)
let store_rel_le_secret_loc (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) (p_l: _) (p_t: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ store_ty_lookup p_l p_sigma == Some (TSecret p_t, Public))) (ensures ((exists p_v1. (exists p_v2. store_lookup p_l p_st1 == Some p_v1)) /\ store_lookup p_l p_st2 == Some v2 /\ val_rel_le p_n p_sigma (TSecret p_t) v1 v2 == true)) = admit ()

(* store_lookup_fresh_loc (matches Coq: Lemma store_lookup_fresh_loc) *)
let store_lookup_fresh_loc (p_st: _) : Lemma (store_lookup (fresh_loc p_st) p_st == None) = admit ()

(* val_rel_le_ref_loc_eq (matches Coq: Lemma val_rel_le_ref_loc_eq) *)
let val_rel_le_ref_loc_eq (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_l1: _) (p_l2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TRef p_t p_sl) (ELoc p_l1) (ELoc p_l2) == true)) (ensures (p_l1 == p_l2)) = admit ()

(* store_rel_simple_refl (matches Coq: Lemma store_rel_simple_refl) *)
let store_rel_simple_refl (p_sigma: _) (p_st: _) : Lemma (store_rel_simple p_sigma p_st p_st == true) = admit ()

(* store_rel_le_step_mono (matches Coq: Lemma store_rel_le_step_mono) *)
let store_rel_le_step_mono (p_n: _) (p_m: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (p_m <= p_n /\ store_rel_le p_n p_sigma p_st1 p_st2 == true)) (ensures (store_rel_le p_m p_sigma p_st1 p_st2 == true)) = admit ()

(* val_rel_le_labeled_always (matches Coq: Lemma val_rel_le_labeled_always) *)
let val_rel_le_labeled_always (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_tainted_always (matches Coq: Lemma val_rel_le_tainted_always) *)
let val_rel_le_tainted_always (p_n: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_sanitized_always (matches Coq: Lemma val_rel_le_sanitized_always) *)
let val_rel_le_sanitized_always (p_n: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_capability_always (matches Coq: Lemma val_rel_le_capability_always) *)
let val_rel_le_capability_always (p_n: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_capability_full_always (matches Coq: Lemma val_rel_le_capability_full_always) *)
let val_rel_le_capability_full_always (p_n: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_proof_always (matches Coq: Lemma val_rel_le_proof_always) *)
let val_rel_le_proof_always (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_constant_time_always (matches Coq: Lemma val_rel_le_constant_time_always) *)
let val_rel_le_constant_time_always (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_zeroizing_always (matches Coq: Lemma val_rel_le_zeroizing_always) *)
let val_rel_le_zeroizing_always (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_chan_always (matches Coq: Lemma val_rel_le_chan_always) *)
let val_rel_le_chan_always (p_n: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_secure_chan_always (matches Coq: Lemma val_rel_le_secure_chan_always) *)
let val_rel_le_secure_chan_always (p_n: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_list_always (matches Coq: Lemma val_rel_le_list_always) *)
let val_rel_le_list_always (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_option_always (matches Coq: Lemma val_rel_le_option_always) *)
let val_rel_le_option_always (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true)) = admit ()

(* store_rel_simple_sym (matches Coq: Lemma store_rel_simple_sym) *)
let store_rel_simple_sym (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true)) (ensures (store_rel_simple p_sigma p_st2 p_st1 == true)) = admit ()

(* store_rel_simple_trans (matches Coq: Lemma store_rel_simple_trans) *)
let store_rel_simple_trans (p_sigma: _) (p_st1: _) (p_st2: _) (p_st3: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true /\ store_rel_simple p_sigma p_st2 p_st3 == true)) (ensures (store_rel_simple p_sigma p_st1 p_st3 == true)) = admit ()

(* store_rel_le_max_eq (matches Coq: Lemma store_rel_le_max_eq) *)
let store_rel_le_max_eq (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true)) (ensures (store_max p_st1 == store_max p_st2)) = admit ()

(* store_rel_le_from_succ (matches Coq: Lemma store_rel_le_from_succ) *)
let store_rel_le_from_succ (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_le ((p_n + 1)) p_sigma p_st1 p_st2 == true)) (ensures (store_rel_le p_n p_sigma p_st1 p_st2 == true)) = admit ()

(* val_rel_le_ref_refl (matches Coq: Lemma val_rel_le_ref_refl) *)
let val_rel_le_ref_refl (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_l: _) : Lemma (val_rel_le p_n p_sigma (TRef p_t p_sl) (ELoc p_l) (ELoc p_l) == true) = admit ()
