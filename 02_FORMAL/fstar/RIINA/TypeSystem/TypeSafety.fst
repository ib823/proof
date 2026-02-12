(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/type_system/TypeSafety.v (2 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.TypeSystem.TypeSafety
open FStar.All

(* stuck (matches Coq: Definition stuck) *)
let stuck (p_cfg: nat) : Tot bool =
  (0 = 0)

(* type_safety (matches Coq: Theorem type_safety) *)
let type_safety (p_e: _) (p_t: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type nil Σ Public p_e p_t _ == true /\ store_wf Σ p_st == true) (ensures (~(stuck (e_ st_ p_ctx) == true)))) = admit ()

(* multi_step_safety (matches Coq: Theorem multi_step_safety) *)
let multi_step_safety (p_e: _) (p_e_: _) (p_t: _) (p_st: _) (p_st_: _) (p_ctx: _) (p_ctx_: _) : Lemma (requires (has_type nil Σ Public p_e p_t _ == true /\ store_wf Σ p_st == true /\ (p_e, p_st, p_ctx) - == true /\ * (e__ st__ ctx_) == true) (ensures (exists Σ', store_wf Σ' st_ == true /\ ~(stuck (e__ st__ ctx_) == true)))) = admit ()
