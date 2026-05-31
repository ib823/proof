(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/SizedTypes.v (44 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.SizedTypes
open FStar.All

(* sized_ty (matches Coq) *)
type sized_ty =
  | STBase of nat
  | STSized of (nat * nat)

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

(* sized_ty_base (matches Coq: Definition sized_ty_base) *)
let sized_ty_base (p_st: sized_ty) : Tot nat =
  match p_st with
  | STBase T -> T
  | STSized (_, T) -> T
  | _ -> 0

(* sized_ty_bound (matches Coq: Definition sized_ty_bound) *)
let sized_ty_bound (p_st: sized_ty) : Tot nat =
  match p_st with
  | STBase _ -> 0
  | STSized (n, _) -> n
  | _ -> 0

(* expr_size (matches Coq: Fixpoint expr_size) *)
let rec expr_size (p_e: nat) : Tot nat =
  match p_e with
  | EUnit -> 1
  | EBool _ -> 1
  | EInt _ -> 1
  | EString _ -> 1
  | EVar _ -> 1
  | ELam (_, _, body) -> 1 + expr_size body
  | EApp (e1, e2) -> 1 + expr_size e1 + expr_size e2
  | EPair (e1, e2) -> 1 + expr_size e1 + expr_size e2
  | EFst p_e -> 1 + expr_size p_e
  | ESnd p_e -> 1 + expr_size p_e
  | EInl (p_e, _) -> 1 + expr_size p_e
  | EInr (p_e, _) -> 1 + expr_size p_e
  | ECase (p_e, _, e1, _, e2) -> 1 + expr_size p_e + expr_size e1 + expr_size e2
  | EIf (e1, e2, e3) -> 1 + expr_size e1 + expr_size e2 + expr_size e3
  | ELet (_, e1, e2) -> 1 + expr_size e1 + expr_size e2
  | ERef (p_e, _) -> 1 + expr_size p_e
  | EDeref p_e -> 1 + expr_size p_e
  | EAssign (e1, e2) -> 1 + expr_size e1 + expr_size e2
  | ELoc _ -> 1
  | EPerform (_, p_e) -> 1 + expr_size p_e
  | EHandle (p_e, _, h) -> 1 + expr_size p_e + expr_size h
  | EClassify p_e -> 1 + expr_size p_e
  | EDeclassify (e1, e2) -> 1 + expr_size e1 + expr_size e2
  | EProve p_e -> 1 + expr_size p_e
  | ERequire (_, p_e) -> 1 + expr_size p_e
  | EGrant (_, p_e) -> 1 + expr_size p_e
  | _ -> 0

(* terminates (matches Coq: Definition terminates) *)
let terminates (p_e: nat) (p_st: nat) (p_ctx: nat) : Tot bool =
  true

(* step_terminates (matches Coq: Definition step_terminates) *)
let step_terminates (p_e: nat) (p_st: nat) (p_ctx: nat) : Tot bool =
  true

(* expr_size_pos (matches Coq: Lemma expr_size_pos) *)
let expr_size_pos (p_e: _) : Lemma (expr_size p_e > 0) = admit ()

(* value_prod_decompose (matches Coq: Lemma value_prod_decompose) *)
let value_prod_decompose (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v1. (exists p_v2. p_v == EPair p_v1 p_v2)) /\ value v1 == true /\ value v2 == true)) = admit ()

(* value_sum_decompose (matches Coq: Lemma value_sum_decompose) *)
let value_sum_decompose (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures (((exists p_v. p_v == EInl v_ p_t2) /\ value v_ == true) \/ ((exists p_v. p_v == EInr v_ p_t1) /\ value v_ == true))) = admit ()

(* value_bool_decompose (matches Coq: Lemma value_bool_decompose) *)
let value_bool_decompose (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TBool p_epsilon == true /\ value p_v == true)) (ensures ((exists p_b. p_v == EBool p_b))) = admit ()

(* value_fn_decompose (matches Coq: Lemma value_fn_decompose) *)
let value_fn_decompose (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_epsilon_prime: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TFn p_t1 p_t2 p_epsilon) p_epsilon_prime == true /\ value p_v == true)) (ensures ((exists p_x. (exists p_body. p_v == ELam p_x p_t1 p_body)))) = admit ()

(* fst_steps_once (matches Coq: Lemma fst_steps_once) *)
let fst_steps_once (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (step (EFst (EPair p_v1 p_v2), p_st, p_ctx) (p_v1, p_st, p_ctx) == true)) = admit ()

(* snd_steps_once (matches Coq: Lemma snd_steps_once) *)
let snd_steps_once (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (step (ESnd (EPair p_v1 p_v2), p_st, p_ctx) (p_v2, p_st, p_ctx) == true)) = admit ()

(* case_inl_steps_once (matches Coq: Lemma case_inl_steps_once) *)
let case_inl_steps_once (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (step (ECase (EInl p_v p_t) p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) (subst_x1 := v_ p_e1, p_st, p_ctx) == true)) = admit ()

(* case_inr_steps_once (matches Coq: Lemma case_inr_steps_once) *)
let case_inr_steps_once (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (step (ECase (EInr p_v p_t) p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) (subst_x2 := v_ p_e2, p_st, p_ctx) == true)) = admit ()

(* if_true_steps_once (matches Coq: Lemma if_true_steps_once) *)
let if_true_steps_once (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (step (EIf (EBool true) p_e2 p_e3, p_st, p_ctx) (p_e2, p_st, p_ctx) == true) = admit ()

(* if_false_steps_once (matches Coq: Lemma if_false_steps_once) *)
let if_false_steps_once (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (step (EIf (EBool false) p_e2 p_e3, p_st, p_ctx) (p_e3, p_st, p_ctx) == true) = admit ()

(* let_value_steps_once (matches Coq: Lemma let_value_steps_once) *)
let let_value_steps_once (p_x: _) (p_v: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (step (ELet p_x p_v p_e2, p_st, p_ctx) (subst_x := v_ p_e2, p_st, p_ctx) == true)) = admit ()

(* handle_value_steps_once (matches Coq: Lemma handle_value_steps_once) *)
let handle_value_steps_once (p_v: _) (p_x: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (step (EHandle p_v p_x p_h, p_st, p_ctx) (subst_x := v_ p_h, p_st, p_ctx) == true)) = admit ()

(* app_lam_steps_once (matches Coq: Lemma app_lam_steps_once) *)
let app_lam_steps_once (p_x: _) (p_t: _) (p_body: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (step (EApp (ELam p_x p_t p_body) p_v, p_st, p_ctx) (subst_x := v_ p_body, p_st, p_ctx) == true)) = admit ()

(* step_to_multi (matches Coq: Lemma step_to_multi) *)
let step_to_multi (p_e: _) (p_st: _) (p_ctx: _) (p_e_: _) (p_st_: _) (p_ctx_: _) : Lemma (requires (step (p_e, p_st, p_ctx) (p_e_, p_st_, p_ctx_) == true)) (ensures (step (p_e, p_st, p_ctx) * (p_e_, p_st_, p_ctx_) == true)) = admit ()

(* multi_step_trans (matches Coq: Lemma multi_step_trans) *)
let multi_step_trans (p_e1: _) (p_st1: _) (p_ctx1: _) (p_e2: _) (p_st2: _) (p_ctx2: _) (p_e3: _) (p_st3: _) (p_ctx3: _) : Lemma (requires (step (p_e1, p_st1, p_ctx1) * (p_e2, p_st2, p_ctx2) == true /\ step (p_e2, p_st2, p_ctx2) * (p_e3, p_st3, p_ctx3) == true)) (ensures (step (p_e1, p_st1, p_ctx1) * (p_e3, p_st3, p_ctx3) == true)) = admit ()

(* expr_size_app (matches Coq: Lemma expr_size_app) *)
let expr_size_app (p_e1: _) (p_e2: _) : Lemma (expr_size (EApp p_e1 p_e2) == 1 + expr_size p_e1 + expr_size p_e2) = admit ()

(* expr_size_pair (matches Coq: Lemma expr_size_pair) *)
let expr_size_pair (p_e1: _) (p_e2: _) : Lemma (expr_size (EPair p_e1 p_e2) == 1 + expr_size p_e1 + expr_size p_e2) = admit ()

(* expr_size_fst (matches Coq: Lemma expr_size_fst) *)
let expr_size_fst (p_e: _) : Lemma (expr_size (EFst p_e) == 1 + expr_size p_e) = admit ()

(* expr_size_snd (matches Coq: Lemma expr_size_snd) *)
let expr_size_snd (p_e: _) : Lemma (expr_size (ESnd p_e) == 1 + expr_size p_e) = admit ()

(* expr_size_if (matches Coq: Lemma expr_size_if) *)
let expr_size_if (p_e1: _) (p_e2: _) (p_e3: _) : Lemma (expr_size (EIf p_e1 p_e2 p_e3) == 1 + expr_size p_e1 + expr_size p_e2 + expr_size p_e3) = admit ()

(* expr_size_let (matches Coq: Lemma expr_size_let) *)
let expr_size_let (p_x: _) (p_e1: _) (p_e2: _) : Lemma (expr_size (ELet p_x p_e1 p_e2) == 1 + expr_size p_e1 + expr_size p_e2) = admit ()

(* expr_size_lam (matches Coq: Lemma expr_size_lam) *)
let expr_size_lam (p_x: _) (p_t: _) (p_body: _) : Lemma (expr_size (ELam p_x p_t p_body) == 1 + expr_size p_body) = admit ()

(* expr_size_inl (matches Coq: Lemma expr_size_inl) *)
let expr_size_inl (p_e: _) (p_t: _) : Lemma (expr_size (EInl p_e p_t) == 1 + expr_size p_e) = admit ()

(* expr_size_inr (matches Coq: Lemma expr_size_inr) *)
let expr_size_inr (p_e: _) (p_t: _) : Lemma (expr_size (EInr p_e p_t) == 1 + expr_size p_e) = admit ()

(* expr_size_ge_1 (matches Coq: Lemma expr_size_ge_1) *)
let expr_size_ge_1 (p_e: _) : Lemma (1 <= expr_size p_e) = admit ()

(* expr_size_fst_sub (matches Coq: Lemma expr_size_fst_sub) *)
let expr_size_fst_sub (p_e: _) : Lemma (expr_size p_e < expr_size (EFst p_e)) = admit ()

(* expr_size_snd_sub (matches Coq: Lemma expr_size_snd_sub) *)
let expr_size_snd_sub (p_e: _) : Lemma (expr_size p_e < expr_size (ESnd p_e)) = admit ()

(* expr_size_app_l (matches Coq: Lemma expr_size_app_l) *)
let expr_size_app_l (p_e1: _) (p_e2: _) : Lemma (expr_size p_e1 < expr_size (EApp p_e1 p_e2)) = admit ()

(* expr_size_app_r (matches Coq: Lemma expr_size_app_r) *)
let expr_size_app_r (p_e1: _) (p_e2: _) : Lemma (expr_size p_e2 < expr_size (EApp p_e1 p_e2)) = admit ()

(* value_terminates (matches Coq: Lemma value_terminates) *)
let value_terminates (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (terminates p_v p_st p_ctx == true)) = admit ()

(* value_step_terminates_trivially (matches Coq: Lemma value_step_terminates_trivially) *)
let value_step_terminates_trivially (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (terminates p_v p_st p_ctx == true)) = admit ()

(* expr_size_case (matches Coq: Lemma expr_size_case) *)
let expr_size_case (p_e: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) : Lemma (expr_size (ECase p_e p_x1 p_e1 p_x2 p_e2) == 1 + expr_size p_e + expr_size p_e1 + expr_size p_e2) = admit ()

(* expr_size_ref (matches Coq: Lemma expr_size_ref) *)
let expr_size_ref (p_e: _) (p_sl: _) : Lemma (expr_size (ERef p_e p_sl) == 1 + expr_size p_e) = admit ()

(* expr_size_deref (matches Coq: Lemma expr_size_deref) *)
let expr_size_deref (p_e: _) : Lemma (expr_size (EDeref p_e) == 1 + expr_size p_e) = admit ()

(* expr_size_assign (matches Coq: Lemma expr_size_assign) *)
let expr_size_assign (p_e1: _) (p_e2: _) : Lemma (expr_size (EAssign p_e1 p_e2) == 1 + expr_size p_e1 + expr_size p_e2) = admit ()

(* expr_size_classify (matches Coq: Lemma expr_size_classify) *)
let expr_size_classify (p_e: _) : Lemma (expr_size (EClassify p_e) == 1 + expr_size p_e) = admit ()

(* expr_size_pair_l (matches Coq: Lemma expr_size_pair_l) *)
let expr_size_pair_l (p_e1: _) (p_e2: _) : Lemma (expr_size p_e1 < expr_size (EPair p_e1 p_e2)) = admit ()

(* expr_size_pair_r (matches Coq: Lemma expr_size_pair_r) *)
let expr_size_pair_r (p_e1: _) (p_e2: _) : Lemma (expr_size p_e2 < expr_size (EPair p_e1 p_e2)) = admit ()

(* expr_size_case_guard (matches Coq: Lemma expr_size_case_guard) *)
let expr_size_case_guard (p_e: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) : Lemma (expr_size p_e < expr_size (ECase p_e p_x1 p_e1 p_x2 p_e2)) = admit ()

(* expr_size_if_guard (matches Coq: Lemma expr_size_if_guard) *)
let expr_size_if_guard (p_e1: _) (p_e2: _) (p_e3: _) : Lemma (expr_size p_e1 < expr_size (EIf p_e1 p_e2 p_e3)) = admit ()

(* expr_size_let_body (matches Coq: Lemma expr_size_let_body) *)
let expr_size_let_body (p_x: _) (p_e1: _) (p_e2: _) : Lemma (expr_size p_e2 < expr_size (ELet p_x p_e1 p_e2)) = admit ()

(* sized_ty_base_STBase (matches Coq: Lemma sized_ty_base_STBase) *)
let sized_ty_base_stbase (p_t: _) : Lemma (sized_ty_base (STBase p_t) == p_t) = admit ()

(* sized_ty_bound_STSized (matches Coq: Lemma sized_ty_bound_STSized) *)
let sized_ty_bound_stsized (p_n: _) (p_t: _) : Lemma (sized_ty_bound (STSized p_n p_t) == p_n) = admit ()
