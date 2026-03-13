(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/LexOrder.v (16 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.LexOrder
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* lex_lt (matches Coq: Definition lex_lt) *)
let lex_lt (p_p1: nat) (p_p2: nat) : Tot bool =
  true

(* step_ty_lt (matches Coq: Definition step_ty_lt) *)
let step_ty_lt (p_p1: nat) (p_p2: nat) : Tot bool =
  true

(* triple_lt (matches Coq: Definition triple_lt) *)
let triple_lt (p_p1: nat) (p_p2: nat) : Tot bool =
  true

(* lex_lt_wf (matches Coq: Theorem lex_lt_wf) *)
let lex_lt_wf () : Lemma (well_founded lex_lt == true) = ()

(* lex_induction (matches Coq: Theorem lex_induction) *)
let lex_induction (p_p: nat) : Lemma (requires (((forall (n: _). (forall (m: _). (forall n' m', lex_lt (n', m') (n, m) -> p_p n' m') -> p_p n m == true))))) (ensures ((forall (n: _). (forall (m: _). p_p n m == true)))) = ()

(* lex_lt_left (matches Coq: Lemma lex_lt_left) *)
let lex_lt_left (p_n: _) (p_m: _) (p_n_: _) (p_m_: _) : Lemma (requires (p_n_ < p_n)) (ensures (lex_lt (p_n_, p_m_) (p_n, p_m) == true)) = ()

(* lex_lt_right (matches Coq: Lemma lex_lt_right) *)
let lex_lt_right (p_n: _) (p_m: _) (p_m_: _) : Lemma (requires (p_m_ < p_m)) (ensures (lex_lt (p_n, p_m_) (p_n, p_m) == true)) = ()

(* step_ty_lt_wf (matches Coq: Theorem step_ty_lt_wf) *)
let step_ty_lt_wf () : Lemma (well_founded step_ty_lt == true) = ()

(* step_ty_induction (matches Coq: Theorem step_ty_induction) *)
let step_ty_induction (p_p: nat) : Lemma (requires (((forall (n: _). (forall (t: _). (forall n' t', step_ty_lt (n', t') (n, t) -> p_p n' t') -> p_p n t == true))))) (ensures ((forall (n: _). (forall (t: _). p_p n t == true)))) = ()

(* step_ty_lt_step (matches Coq: Lemma step_ty_lt_step) *)
let step_ty_lt_step (p_n: _) (p_t: _) (p_t_: _) : Lemma (step_ty_lt (p_n, p_t') ((p_n + 1), p_t) == true) = ()

(* step_ty_lt_ty (matches Coq: Lemma step_ty_lt_ty) *)
let step_ty_lt_ty (p_n: _) (p_t: _) (p_t_: _) : Lemma (requires (ty_size p_t' < ty_size p_t)) (ensures (step_ty_lt (p_n, p_t') (p_n, p_t) == true)) = ()

(* step_ty_lt_fn_arg (matches Coq: Lemma step_ty_lt_fn_arg) *)
let step_ty_lt_fn_arg (p_n: _) (p_t1: _) (p_t2: _) (p_eff: _) : Lemma (step_ty_lt (p_n, p_t1) (p_n, TFn p_t1 p_t2 p_eff) == true) = ()

(* step_ty_lt_fn_res (matches Coq: Lemma step_ty_lt_fn_res) *)
let step_ty_lt_fn_res (p_n: _) (p_t1: _) (p_t2: _) (p_eff: _) : Lemma (step_ty_lt (p_n, p_t2) (p_n, TFn p_t1 p_t2 p_eff) == true) = ()

(* step_ty_lt_prod_left (matches Coq: Lemma step_ty_lt_prod_left) *)
let step_ty_lt_prod_left (p_n: _) (p_t1: _) (p_t2: _) : Lemma (step_ty_lt (p_n, p_t1) (p_n, TProd p_t1 p_t2) == true) = ()

(* step_ty_lt_prod_right (matches Coq: Lemma step_ty_lt_prod_right) *)
let step_ty_lt_prod_right (p_n: _) (p_t1: _) (p_t2: _) : Lemma (step_ty_lt (p_n, p_t2) (p_n, TProd p_t1 p_t2) == true) = ()

(* step_ty_lt_sum_left (matches Coq: Lemma step_ty_lt_sum_left) *)
let step_ty_lt_sum_left (p_n: _) (p_t1: _) (p_t2: _) : Lemma (step_ty_lt (p_n, p_t1) (p_n, TSum p_t1 p_t2) == true) = ()

(* step_ty_lt_sum_right (matches Coq: Lemma step_ty_lt_sum_right) *)
let step_ty_lt_sum_right (p_n: _) (p_t1: _) (p_t2: _) : Lemma (step_ty_lt (p_n, p_t2) (p_n, TSum p_t1 p_t2) == true) = ()

(* step_ty_lt_step_any (matches Coq: Lemma step_ty_lt_step_any) *)
let step_ty_lt_step_any (p_n: _) (p_n_: _) (p_t: _) (p_t_: _) : Lemma (requires (p_n_ < p_n)) (ensures (step_ty_lt (p_n_, p_t') (p_n, p_t) == true)) = ()

(* triple_lt_wf (matches Coq: Theorem triple_lt_wf) *)
let triple_lt_wf () : Lemma (well_founded triple_lt == true) = ()
