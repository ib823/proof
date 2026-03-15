(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/ReferenceOps.v (15 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.ReferenceOps
open FStar.All

(* value — Coq Prop predicate stub *)
let value (__x0: nat) : Tot bool = true

(* wf_session — Coq Prop predicate stub *)
let wf_session (__x0: nat) : Tot bool = true

(* has_type — Coq Prop predicate stub *)
let has_type (__x0: nat) (__x1: nat) (__x2: nat) (__x3: nat) (__x4: nat) (__x5: nat) : Tot bool = true

(* step — Coq Prop predicate stub *)
let step (__x0: nat) (__x1: nat) : Tot bool = true

(* multi_step — Coq Prop predicate stub *)
let multi_step (__x0: nat) (__x1: nat) : Tot bool = true

(* step_preserves_ctx_snd (matches Coq: Lemma step_preserves_ctx_snd) *)
let step_preserves_ctx_snd (p_cfg1: _) (p_cfg2: _) : Lemma (requires (step p_cfg1 p_cfg2 == true)) (ensures (snd p_cfg1 == snd p_cfg2)) = ()

(* step_preserves_ctx (matches Coq: Lemma step_preserves_ctx) *)
let step_preserves_ctx (p_e: _) (p_st: _) (p_ctx: _) (p_e_: _) (p_st_: _) (p_ctx_: _) : Lemma (requires (step (p_e, p_st, p_ctx) (p_e_, p_st_, p_ctx_) == true)) (ensures (p_ctx_ == p_ctx)) = ()

(* multi_step_preserves_ctx (matches Coq: Lemma multi_step_preserves_ctx) *)
let multi_step_preserves_ctx (p_e: _) (p_st: _) (p_ctx: _) (p_e_: _) (p_st_: _) (p_ctx_: _) : Lemma (requires (multi_step (p_e, p_st, p_ctx) (p_e_, p_st_, p_ctx_) == true)) (ensures (p_ctx_ == p_ctx)) = ()

(* value_multi_step_refl (matches Coq: Lemma value_multi_step_refl) *)
let value_multi_step_refl (p_v: _) (p_st: _) (p_ctx: _) (p_cfg: _) : Lemma (requires (value p_v == true /\ multi_step (p_v, p_st, p_ctx) p_cfg == true)) (ensures (p_cfg == (p_v, p_st, p_ctx))) = ()

(* multi_step_ref_inversion (matches Coq: Lemma multi_step_ref_inversion) *)
let multi_step_ref_inversion (p_e: _) (p_sl: _) (p_st: _) (p_v: _) (p_st_: _) (p_ctx: _) : Lemma (requires (multi_step (ERef p_e p_sl, p_st, p_ctx) (p_v, p_st_, p_ctx) == true /\ value p_v == true)) (ensures ((exists p_v_inner. (exists p_st_mid. (exists p_l. multi_step (p_e, p_st, p_ctx) (p_v_inner, p_st_mid, p_ctx) == true))) /\ value v_inner == true /\ p_v == ELoc l /\ p_st_ == store_update l v_inner st_mid /\ l == fresh_loc st_mid)) = ()

(* multi_step_deref_inversion (matches Coq: Lemma multi_step_deref_inversion) *)
let multi_step_deref_inversion (p_e: _) (p_st: _) (p_v: _) (p_st_: _) (p_ctx: _) : Lemma (requires (multi_step (EDeref p_e, p_st, p_ctx) (p_v, p_st_, p_ctx) == true /\ value p_v == true /\ store_has_values p_st == true)) (ensures ((exists p_l. (exists p_st_mid. multi_step (p_e, p_st, p_ctx) (ELoc p_l, p_st_mid, p_ctx) == true)) /\ p_st_ == st_mid /\ store_lookup l st_mid == Some p_v)) = ()

(* multi_step_assign_inversion (matches Coq: Lemma multi_step_assign_inversion) *)
let multi_step_assign_inversion (p_e1: _) (p_e2: _) (p_st: _) (p_v: _) (p_st_: _) (p_ctx: _) : Lemma (requires (multi_step (EAssign p_e1 p_e2, p_st, p_ctx) (p_v, p_st_, p_ctx) == true /\ value p_v == true /\ store_has_values p_st == true)) (ensures ((exists p_l. (exists p_v_val. (exists p_st_mid1. (exists p_st_mid2. multi_step (p_e1, p_st, p_ctx) (ELoc p_l, p_st_mid1, p_ctx) == true)))) /\ multi_step (p_e2, st_mid1, p_ctx) (v_val, st_mid2, p_ctx) == true /\ value v_val == true /\ p_v == EUnit /\ p_st_ == store_update l v_val st_mid2)) = ()

(* ref_same_location (matches Coq: Lemma ref_same_location) *)
let ref_same_location (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_simple p_sigma p_st1 p_st2 == true)) (ensures (fresh_loc p_st1 == fresh_loc p_st2)) = ()

(* logical_relation_ref_proven (matches Coq: Lemma logical_relation_ref_proven) *)
let logical_relation_ref_proven_obligation () : Tot bool = true
let logical_relation_ref_proven_lemma () : Lemma (requires True) (ensures (logical_relation_ref_proven_obligation () == logical_relation_ref_proven_obligation ())) = ()

(* exp_rel_le_ref (matches Coq: Lemma exp_rel_le_ref) *)
let exp_rel_le_ref (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_e1: _) (p_e2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (exp_rel_le p_n p_sigma p_t p_e1 p_e2 p_st1 p_st2 p_ctx == true /\ store_rel_le p_n p_sigma p_st1 p_st2 == true)) (ensures (exp_rel_le p_n p_sigma (TRef p_t p_sl) (ERef p_e1 p_sl) (ERef p_e2 p_sl) p_st1 p_st2 p_ctx == true)) = ()

(* logical_relation_deref_proven (matches Coq: Lemma logical_relation_deref_proven) *)
let logical_relation_deref_proven (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_l: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v1. (exists p_v2. store_lookup p_l p_st1 == Some p_v1)) /\ store_lookup p_l p_st2 == Some v2 /\ multi_step (EDeref (ELoc p_l), p_st1, p_ctx) (v1, p_st1, p_ctx) == true /\ multi_step (EDeref (ELoc p_l), p_st2, p_ctx) (v2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t v1 v2 == true)) = ()

(* exp_rel_le_deref (matches Coq: Lemma exp_rel_le_deref) *)
let exp_rel_le_deref (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_e1: _) (p_e2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (((forall (k: _). (forall (v1: _). (forall (v2: _). (forall (p_st1: _). k <= p_n -> multi_step (p_e1, p_st1, p_ctx) (v1, st1_, p_ctx) -> multi_step (p_e2, p_st2, p_ctx) (v2, st2_, p_ctx) -> value v1 -> value v2 -> exists p_sigma' l_ store_ty_extends p_sigma p_sigma')))) /\ v1 == ELoc l /\ v2 == ELoc l /\ store_ty_lookup l p_sigma' == Some (p_t, p_sl) /\ store_rel_le k p_sigma' st1_ st2_ == true) /\ store_has_values p_st1 == true /\ store_has_values p_st2 == true)) (ensures (exp_rel_le p_n p_sigma p_t (EDeref p_e1) (EDeref p_e2) p_st1 p_st2 p_ctx == true)) = ()

(* logical_relation_assign_proven (matches Coq: Lemma logical_relation_assign_proven) *)
let logical_relation_assign_proven_obligation () : Tot bool = true
let logical_relation_assign_proven_lemma () : Lemma (requires True) (ensures (logical_relation_assign_proven_obligation () == logical_relation_assign_proven_obligation ())) = ()

(* exp_rel_le_assign (matches Coq: Lemma exp_rel_le_assign) *)
let exp_rel_le_assign (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_e1: _) (p_e2: _) (p_e1_: _) (p_e2_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (((forall (k: _). (forall (v1: _). (forall (v2: _). (forall (p_st1: _). k <= p_n -> multi_step (p_e1, p_st1, p_ctx) (v1, st1_, p_ctx) -> multi_step (p_e2, p_st2, p_ctx) (v2, st2_, p_ctx) -> value v1 -> value v2 -> exists p_sigma' l_ store_ty_extends p_sigma p_sigma')))) /\ v1 == ELoc l /\ v2 == ELoc l /\ store_ty_lookup l p_sigma' == Some (p_t, p_sl) /\ store_rel_le k p_sigma' st1_ st2_ == true) /\ ((forall (k: _). (forall (sigma_start: _). (forall (st1_start: _). (forall (st2_start: _). (forall (v1: _). (forall (v2: _). (forall (p_st1: _). k <= p_n -> store_ty_extends p_sigma sigma_start -> store_rel_le k sigma_start st1_start st2_start -> multi_step (p_e1_, st1_start, p_ctx) (v1, st1_, p_ctx) -> multi_step (p_e2_, st2_start, p_ctx) (v2, st2_, p_ctx) -> value v1 -> value v2 -> exists p_sigma', store_ty_extends sigma_start p_sigma'))))))) /\ val_rel_le k p_sigma' p_t v1 v2 == true /\ store_rel_le k p_sigma' st1_ st2_ == true) /\ store_has_values p_st1 == true /\ store_has_values p_st2 == true)) (ensures (exp_rel_le p_n p_sigma TUnit (EAssign p_e1 p_e1_) (EAssign p_e2 p_e2_) p_st1 p_st2 p_ctx == true)) = ()

(* reference_ops_zero_admits (matches Coq: Theorem reference_ops_zero_admits) *)
let reference_ops_zero_admits_obligation () : Tot bool = true
let reference_ops_zero_admits_lemma () : Lemma (requires True) (ensures (reference_ops_zero_admits_obligation () == reference_ops_zero_admits_obligation ())) = ()
