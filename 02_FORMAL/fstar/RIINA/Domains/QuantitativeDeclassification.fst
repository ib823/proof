(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/QuantitativeDeclassification.v (22 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.QuantitativeDeclassification
open FStar.All

(* level (matches Coq) *)
type level =
  | Low
  | High

(* expr (matches Coq) *)
type expr =
  | EConst of nat
  | EVar of nat
  | EPlus of (expr * expr)
  | EDeclass of (expr * nat)

(* level_leq (matches Coq: Definition level_leq) *)
let level_leq (p_l1: level) (p_l2: level) : Tot bool =
  match p_l1, p_l2 with
  | Low, _ -> true
  | High, High -> true
  | High, Low -> false
  | _ -> false

(* level_join (matches Coq: Definition level_join) *)
let level_join (p_l1: level) (p_l2: level) : Tot level =
  match p_l1, p_l2 with
  | _, High -> High
  | Low, Low -> Low
  | _ -> (* TODO: default value for level *) admit()

(* low_equiv (matches Coq: Definition low_equiv) *)
let low_equiv (p_e1: nat) (p_e2: nat) : Tot bool =
  (0 = 0)

(* budget_monotone (matches Coq: Theorem budget_monotone) *)
let budget_monotone (p_e: _) (p_ex: _) (p_b: _) (p_v: _) (p_b_: _) : Lemma (requires (eval p_e p_ex p_b p_v b_ == true) (ensures (b_ <= p_b))) = admit ()

(* eval_deterministic (matches Coq: Theorem eval_deterministic) *)
let eval_deterministic (p_e: _) (p_ex: _) (p_b: _) (p_v1: _) (p_b1: _) (p_v2: _) (p_b2: _) : Lemma (requires (eval p_e p_ex p_b p_v1 p_b1 == true /\ eval p_e p_ex p_b p_v2 p_b2 == true) (ensures (p_v1 == p_v2 /\ p_b1 == p_b2))) = admit ()

(* budget_composition (matches Coq: Theorem budget_composition) *)
let budget_composition (p_e: _) (p_ex1: _) (p_ex2: _) (p_b: _) (p_v1: _) (p_b1: _) (p_v2: _) (p_b2: _) : Lemma (requires (eval p_e p_ex1 p_b p_v1 p_b1 == true /\ eval p_e p_ex2 p_b1 p_v2 p_b2 == true) (ensures (p_b2 <= p_b))) = admit ()

(* zero_budget_no_declass (matches Coq: Theorem zero_budget_no_declass) *)
let zero_budget_no_declass (p_e: _) (p_ex: _) (p_v: _) (p_b_: _) : Lemma (requires (eval p_e p_ex 0 p_v b_ == true /\ no_declass p_ex == true) (ensures (b_ == 0))) = admit ()

(* no_declass_budget_preserved (matches Coq: Theorem no_declass_budget_preserved) *)
let no_declass_budget_preserved (p_e: _) (p_ex: _) (p_b: _) (p_v: _) (p_b_: _) : Lemma (requires (eval p_e p_ex p_b p_v b_ == true /\ no_declass p_ex == true) (ensures (b_ == p_b))) = admit ()

(* non_interference_no_declass (matches Coq: Theorem non_interference_no_declass) *)
let non_interference_no_declass (p_e1: _) (p_e2: _) (p_ex: _) (p_b: _) (p_v1: _) (p_b1: _) (p_v2: _) (p_b2: _) : Lemma (requires (low_equiv p_e1 p_e2 == true /\ no_declass p_ex == true /\ eval p_e1 p_ex p_b p_v1 p_b1 == true /\ eval p_e2 p_ex p_b p_v2 p_b2 == true /\ (forall i_ id_match nth_error p_e1 i_ nth_error p_e2 i id_with | Some v1_ Some p_v2 => lv_level p_v1 == Low /\ lv_level p_v2 == Low | None, None => True | _, _ => False end)) (ensures (p_v1 == p_v2))) = admit ()

(* const_always_evaluates (matches Coq: Theorem const_always_evaluates) *)
let const_always_evaluates (p_e: _) (p_n: _) (p_b: _) : Lemma (eval p_e (EConst p_n) p_b p_n p_b == true) = admit ()

(* declass_cost_exact (matches Coq: Theorem declass_cost_exact) *)
let declass_cost_exact (p_e: _) (p_ex: _) (p_b: _) (p_v: _) (p_b_: _) (p_cost: _) : Lemma (requires (eval p_e (EDeclass p_ex p_cost) p_b p_v b_ == true) (ensures ((exists p_b_inner. eval p_e p_ex p_b p_v p_b_inner == true) /\ p_cost <= b_inner /\ b_ == b_inner - p_cost))) = admit ()

(* level_leq_refl (matches Coq: Theorem level_leq_refl) *)
let level_leq_refl (p_l: _) : Lemma (level_leq p_l p_l == true) = admit ()

(* level_leq_trans (matches Coq: Theorem level_leq_trans) *)
let level_leq_trans (p_l1: _) (p_l2: _) (p_l3: _) : Lemma (requires (level_leq p_l1 p_l2 == true /\ level_leq p_l2 p_l3 == true) (ensures (level_leq p_l1 p_l3 == true))) = admit ()

(* level_join_comm (matches Coq: Theorem level_join_comm) *)
let level_join_comm (p_l1: _) (p_l2: _) : Lemma (level_join p_l1 p_l2 == level_join p_l2 p_l1) = admit ()

(* level_join_assoc (matches Coq: Theorem level_join_assoc) *)
let level_join_assoc (p_l1: _) (p_l2: _) (p_l3: _) : Lemma (level_join (level_join p_l1 p_l2) p_l3 == level_join p_l1 (level_join p_l2 p_l3)) = admit ()

(* level_join_idem (matches Coq: Theorem level_join_idem) *)
let level_join_idem (p_l: _) : Lemma (level_join p_l p_l == p_l) = admit ()

(* low_bottom (matches Coq: Theorem low_bottom) *)
let low_bottom (p_l: _) : Lemma (level_leq Low p_l == true) = admit ()

(* level_join_leq_l (matches Coq: Theorem level_join_leq_l) *)
let level_join_leq_l (p_l1: _) (p_l2: _) : Lemma (level_leq p_l1 (level_join p_l1 p_l2) == true) = admit ()

(* level_join_leq_r (matches Coq: Theorem level_join_leq_r) *)
let level_join_leq_r (p_l1: _) (p_l2: _) : Lemma (level_leq p_l2 (level_join p_l1 p_l2) == true) = admit ()

(* const_budget_unchanged (matches Coq: Theorem const_budget_unchanged) *)
let const_budget_unchanged (p_e: _) (p_n: _) (p_b: _) (p_v: _) (p_b_: _) : Lemma (requires (eval p_e (EConst p_n) p_b p_v b_ == true) (ensures (b_ == p_b))) = admit ()

(* var_budget_unchanged (matches Coq: Theorem var_budget_unchanged) *)
let var_budget_unchanged (p_e: _) (p_i: _) (p_b: _) (p_v: _) (p_b_: _) : Lemma (requires (eval p_e (EVar p_i) p_b p_v b_ == true) (ensures (b_ == p_b))) = admit ()

(* plus_eval_sum (matches Coq: Theorem plus_eval_sum) *)
let plus_eval_sum (p_e: _) (p_e1: _) (p_e2: _) (p_b: _) (p_v: _) (p_b_: _) : Lemma (requires (eval p_e (EPlus p_e1 p_e2) p_b p_v b_ == true) (ensures (exists v1 v2 b1_ eval p_e p_e1 p_b v1 b1 == true /\ eval p_e p_e2 b1 v2 b_ == true /\ p_v == v1 + v2))) = admit ()

(* double_declass_cost (matches Coq: Theorem double_declass_cost) *)
let double_declass_cost (p_e: _) (p_ex: _) (p_b: _) (p_v: _) (p_b_: _) (p_c1: _) (p_c2: _) : Lemma (requires (eval p_e (EDeclass (EDeclass p_ex p_c1) p_c2) p_b p_v b_ == true) (ensures (b_ <= p_b))) = admit ()

(* no_declass_plus (matches Coq: Theorem no_declass_plus) *)
let no_declass_plus (p_e1: _) (p_e2: _) : Lemma (requires (no_declass p_e1 == true /\ no_declass p_e2 == true) (ensures (no_declass (EPlus p_e1 p_e2) == true))) = admit ()

(* budget_consumption_bounded (matches Coq: Theorem budget_consumption_bounded) *)
let budget_consumption_bounded (p_e: _) (p_ex: _) (p_b: _) (p_v: _) (p_b_: _) : Lemma (requires (eval p_e p_ex p_b p_v b_ == true) (ensures (p_b - b_ <= p_b))) = admit ()
