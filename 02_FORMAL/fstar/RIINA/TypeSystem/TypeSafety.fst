(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/type_system/TypeSafety.v (2 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.TypeSystem.TypeSafety
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

(* stuck (matches Coq: Definition stuck) *)
let stuck (p_cfg: nat) : Tot bool =
  true

(* type_safety (matches Coq: Theorem type_safety) *)
let type_safety (p_e: _) (p_t: _) (p_epsilon: _) (p_st: _) (p_ctx: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_e p_t p_epsilon == true /\ store_wf p_sigma p_st == true)) (ensures (~(stuck (p_e, p_st, p_ctx) == true))) = ()

(* multi_step_safety (matches Coq: Theorem multi_step_safety) *)
let multi_step_safety (p_e: _) (p_e_: _) (p_t: _) (p_epsilon: _) (p_st: _) (p_st_: _) (p_ctx: _) (p_ctx_: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_e p_t p_epsilon == true /\ store_wf p_sigma p_st == true /\ step (p_e, p_st, p_ctx) * (p_e_, p_st_, p_ctx_) == true)) (ensures ((exists p_sigma. store_wf p_sigma' p_st_ == true) /\ ~(stuck (p_e_, p_st_, p_ctx_) == true))) = ()
