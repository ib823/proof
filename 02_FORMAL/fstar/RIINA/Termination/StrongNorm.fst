(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/StrongNorm.v (34 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.StrongNorm
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* step — Coq Prop predicate stub *)
assume val step : nat -> nat -> bool

(* multi_step — Coq Prop predicate stub *)
assume val multi_step : nat -> nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* value_strongly_normalizing (matches Coq: Theorem value_strongly_normalizing) *)
let value_strongly_normalizing (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx p_v == true)) = admit ()

(* fst_terminates_to_value (matches Coq: Lemma fst_terminates_to_value) *)
let fst_terminates_to_value (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures ((exists p_v. (exists p_st. step (EFst (EPair p_v1 p_v2), p_st, p_ctx) * (p_v, st_, ctx_) == true)) /\ value v == true /\ v == p_v1)) = admit ()

(* snd_terminates_to_value (matches Coq: Lemma snd_terminates_to_value) *)
let snd_terminates_to_value (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures ((exists p_v. (exists p_st. step (ESnd (EPair p_v1 p_v2), p_st, p_ctx) * (p_v, st_, ctx_) == true)) /\ value v == true /\ v == p_v2)) = admit ()

(* if_bool_terminates_once (matches Coq: Lemma if_bool_terminates_once) *)
let if_bool_terminates_once_obligation () : Tot bool = true
let if_bool_terminates_once_lemma () : Lemma (requires True) (ensures (if_bool_terminates_once_obligation () == if_bool_terminates_once_obligation ())) = ()

(* let_terminates_once (matches Coq: Lemma let_terminates_once) *)
let let_terminates_once (p_x: _) (p_v: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (ELet p_x p_v p_e2, p_st, p_ctx) * (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* handle_terminates_once (matches Coq: Lemma handle_terminates_once) *)
let handle_terminates_once (p_x: _) (p_v: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (EHandle p_v p_x p_h, p_st, p_ctx) * (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* app_lam_terminates_once (matches Coq: Lemma app_lam_terminates_once) *)
let app_lam_terminates_once (p_x: _) (p_t: _) (p_body: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (EApp (ELam p_x p_t p_body) p_v, p_st, p_ctx) * (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl) *)
let store_ty_extends_refl (p_sigma: _) : Lemma (store_ty_extends p_sigma p_sigma == true) = admit ()

(* SN_multi_step (matches Coq: Lemma SN_multi_step) *)
let sn_multi_step (p_cfg: _) (p_cfg_: _) : Lemma (requires (step p_cfg * p_cfg_ == true /\ (forall (e: _). (forall (st: _). (forall (ctx: _). (forall (e: _). p_cfg == (e, st, ctx))))) /\ p_cfg_ == (e_, st_, ctx_) /\ SN st ctx e == true)) (ensures (SN st_ ctx_ e_ == true)) = admit ()

(* fst_value_terminates_pair (matches Coq: Lemma fst_value_terminates_pair) *)
let fst_value_terminates_pair (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (SN p_st p_ctx (EFst (EPair p_v1 p_v2)) == true)) = admit ()

(* snd_value_SN (matches Coq: Lemma snd_value_SN) *)
let snd_value_sn (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (SN p_st p_ctx (ESnd (EPair p_v1 p_v2)) == true)) = admit ()

(* if_bool_SN (matches Coq: Lemma if_bool_SN) *)
let if_bool_sn (p_b: _) (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (SN p_st p_ctx p_e2 == true /\ SN p_st p_ctx p_e3 == true)) (ensures (SN p_st p_ctx (EIf (EBool p_b) p_e2 p_e3) == true)) = admit ()

(* let_value_SN (matches Coq: Lemma let_value_SN) *)
let let_value_sn (p_x: _) (p_v: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ SN p_st p_ctx (subst_x := v_ p_e2) == true)) (ensures (SN p_st p_ctx (ELet p_x p_v p_e2) == true)) = admit ()

(* app_lam_value_SN (matches Coq: Lemma app_lam_value_SN) *)
let app_lam_value_sn (p_x: _) (p_t: _) (p_body: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ SN p_st p_ctx (subst_x := v_ p_body) == true)) (ensures (SN p_st p_ctx (EApp (ELam p_x p_t p_body) p_v) == true)) = admit ()

(* handle_value_SN (matches Coq: Lemma handle_value_SN) *)
let handle_value_sn (p_x: _) (p_v: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ SN p_st p_ctx (subst_x := v_ p_h) == true)) (ensures (SN p_st p_ctx (EHandle p_v p_x p_h) == true)) = admit ()

(* case_inl_value_SN (matches Coq: Lemma case_inl_value_SN) *)
let case_inl_value_sn (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ SN p_st p_ctx (subst_x1 := v_ p_e1) == true)) (ensures (SN p_st p_ctx (ECase (EInl p_v p_t) p_x1 p_e1 p_x2 p_e2) == true)) = admit ()

(* case_inr_value_SN (matches Coq: Lemma case_inr_value_SN) *)
let case_inr_value_sn (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ SN p_st p_ctx (subst_x2 := v_ p_e2) == true)) (ensures (SN p_st p_ctx (ECase (EInr p_v p_t) p_x1 p_e1 p_x2 p_e2) == true)) = admit ()

(* classify_value_strongly_normalizing (matches Coq: Lemma classify_value_strongly_normalizing) *)
let classify_value_strongly_normalizing (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EClassify p_v) == true)) = admit ()

(* declassify_classify_SN (matches Coq: Lemma declassify_classify_SN) *)
let declassify_classify_sn (p_v: _) (p_p: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ declass_ok (EClassify p_v) p_p == true /\ SN p_st p_ctx p_v == true)) (ensures (SN p_st p_ctx (EDeclassify (EClassify p_v) p_p) == true)) = admit ()

(* fst_fst_pair_SN (matches Coq: Lemma fst_fst_pair_SN) *)
let fst_fst_pair_sn (p_a: _) (p_b: _) (p_c: _) (p_d: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_a == true /\ value p_b == true /\ value p_c == true /\ value p_d == true)) (ensures (SN p_st p_ctx (EFst (EFst (EPair (EPair p_a p_b) (EPair p_c p_d)))) == true)) = admit ()

(* perform_value_SN (matches Coq: Lemma perform_value_SN) *)
let perform_value_sn (p_eff: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EPerform p_eff p_v) == true)) = admit ()

(* require_value_SN (matches Coq: Lemma require_value_SN) *)
let require_value_sn (p_eff: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (ERequire p_eff p_v) == true)) = admit ()

(* grant_value_SN (matches Coq: Lemma grant_value_SN) *)
let grant_value_sn (p_eff: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EGrant p_eff p_v) == true)) = admit ()

(* pair_value_SN (matches Coq: Lemma pair_value_SN) *)
let pair_value_sn (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (SN p_st p_ctx (EPair p_v1 p_v2) == true)) = admit ()

(* inl_value_SN (matches Coq: Lemma inl_value_SN) *)
let inl_value_sn (p_v: _) (p_t: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EInl p_v p_t) == true)) = admit ()

(* inr_value_SN (matches Coq: Lemma inr_value_SN) *)
let inr_value_sn (p_v: _) (p_t: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EInr p_v p_t) == true)) = admit ()

(* prove_value_SN (matches Coq: Lemma prove_value_SN) *)
let prove_value_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EProve p_v) == true)) = admit ()

(* snd_snd_pair_SN (matches Coq: Lemma snd_snd_pair_SN) *)
let snd_snd_pair_sn (p_a: _) (p_b: _) (p_c: _) (p_d: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_a == true /\ value p_b == true /\ value p_c == true /\ value p_d == true)) (ensures (SN p_st p_ctx (ESnd (ESnd (EPair (EPair p_a p_b) (EPair p_c p_d)))) == true)) = admit ()

(* fst_snd_pair_SN (matches Coq: Lemma fst_snd_pair_SN) *)
let fst_snd_pair_sn (p_a: _) (p_b: _) (p_c: _) (p_d: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_a == true /\ value p_b == true /\ value p_c == true /\ value p_d == true)) (ensures (SN p_st p_ctx (EFst (ESnd (EPair (EPair p_a p_b) (EPair p_c p_d)))) == true)) = admit ()

(* snd_fst_pair_SN (matches Coq: Lemma snd_fst_pair_SN) *)
let snd_fst_pair_sn (p_a: _) (p_b: _) (p_c: _) (p_d: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_a == true /\ value p_b == true /\ value p_c == true /\ value p_d == true)) (ensures (SN p_st p_ctx (ESnd (EFst (EPair (EPair p_a p_b) (EPair p_c p_d)))) == true)) = admit ()

(* fst_fst_nested_SN (matches Coq: Lemma fst_fst_nested_SN) *)
let fst_fst_nested_sn (p_a: _) (p_b: _) (p_c: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_a == true /\ value p_b == true /\ value p_c == true)) (ensures (SN p_st p_ctx (EFst (EFst (EPair (EPair p_a p_b) p_c))) == true)) = admit ()

(* classify_classify_SN (matches Coq: Lemma classify_classify_SN) *)
let classify_classify_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EClassify (EClassify p_v)) == true)) = admit ()

(* prove_prove_SN (matches Coq: Lemma prove_prove_SN) *)
let prove_prove_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EProve (EProve p_v)) == true)) = admit ()

(* nested_pair_value_SN (matches Coq: Lemma nested_pair_value_SN) *)
let nested_pair_value_sn (p_a: _) (p_b: _) (p_c: _) (p_d: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_a == true /\ value p_b == true /\ value p_c == true /\ value p_d == true)) (ensures (SN p_st p_ctx (EPair (EPair p_a p_b) (EPair p_c p_d)) == true)) = admit ()
