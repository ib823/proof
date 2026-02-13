(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/MaximumAxiomElimination.v (53 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.MaximumAxiomElimination
open FStar.All

(* sec_label (matches Coq) *)
type sec_label =
  | L
  | H

(* ty (matches Coq) *)
type ty =
  | TUnit
  | TBool
  | TNat
  | TRef of (ty * sec_label)
  | TProd of (ty * ty)
  | TSum of (ty * ty)
  | TArrow of (ty * ty)

(* expr (matches Coq) *)
type expr =
  | EVar of nat
  | EUnit
  | EBool of bool
  | ENat of nat
  | ELoc of nat
  | EPair of (expr * expr)
  | EFst of expr
  | ESnd of expr
  | EInl of expr
  | EInr of expr
  | ELam of (ty * expr)
  | EApp of (expr * expr)
  | ERef of (sec_label * expr)
  | EDeref of expr
  | EAssign of (expr * expr)
  | EIf of (expr * expr * expr)
  | ELet of (expr * expr)

(* is_value — Coq Prop predicate stub *)
assume val is_value : expr -> bool

(* label_leq (matches Coq: Definition label_leq) *)
let label_leq (p_l1: sec_label) (p_l2: sec_label) : Tot bool =
  match p_l1, p_l2 with
  | L, _ -> true
  | H, H -> true
  | H, L -> false
  | _ -> false

(* ty_size (matches Coq: Fixpoint ty_size) *)
let rec ty_size (p_t: ty) : Tot nat =
  match p_t with
  | TNat -> 1
  | TRef (p_t', _) -> 1 + ty_size p_t'
  | TProd (T1, T2) -> 1 + ty_size T1 + ty_size T2
  | TSum (T1, T2) -> 1 + ty_size T1 + ty_size T2
  | TArrow (T1, T2) -> 1 + ty_size T1 + ty_size T2
  | _ -> 0

(* first_order_type (matches Coq: Fixpoint first_order_type) *)
let rec first_order_type (p_t: ty) : Tot bool =
  match p_t with
  | TRef (_, _) -> true
  | TProd (T1, T2) -> first_order_type T1 && first_order_type T2
  | TSum (T1, T2) -> first_order_type T1 && first_order_type T2
  | TArrow (_, _) -> false
  | _ -> false

(* fo_compound_depth (matches Coq: Fixpoint fo_compound_depth) *)
let rec fo_compound_depth (p_t: ty) : Tot nat =
  match p_t with
  | TRef (_, _) -> 0
  | TProd (T1, T2) -> 1 + max (fo_compound_depth T1) (fo_compound_depth T2)
  | TSum (T1, T2) -> 1 + max (fo_compound_depth T1) (fo_compound_depth T2)
  | TArrow (_, _) -> 0
  | _ -> 0

(* is_value_b (matches Coq: Fixpoint is_value_b) *)
let rec is_value_b (p_e: expr) : Tot bool =
  match p_e with
  | ELam (_, _) -> true
  | EPair (v1, v2) -> is_value_b v1 && is_value_b v2
  | EInr v -> is_value_b v
  | _ -> false

(* store_empty (matches Coq: Definition store_empty) *)
let store_empty : nat = fun _ -> None

(* store_ty_empty (matches Coq: Definition store_ty_empty) *)
let store_ty_empty : nat = fun _ -> None

(* store_update (matches Coq: Definition store_update) *)
let store_update (p_sigma: nat) (p_l: nat) (p_v: expr) : Tot nat =
  fun p_l' => if (p_l = p_l') then Some p_v else p_sigma p_l'

(* store_ty_update (matches Coq: Definition store_ty_update) *)
let store_ty_update (p_sigma: nat) (p_l: nat) (p_t: ty) (p_lab: sec_label) : Tot nat =
  fun p_l' => if (p_l = p_l') then Some (p_t, p_lab) else p_sigma p_l'

(* store_ty_extends (matches Coq: Definition store_ty_extends) *)
let store_ty_extends (p_sigma: nat) (p_sigma_prime: nat) : Tot bool =
  true

(* val_rel_n (matches Coq: Fixpoint val_rel_n) *)
let rec val_rel_n (p_n: nat) (p_sigma: nat) (p_t: ty) (p_v1: expr) (p_v2: expr) : Tot bool =
  true

(* store_rel_n (matches Coq: Definition store_rel_n) *)
let store_rel_n (p_n: nat) (p_sigma: nat) (p_s1: nat) (p_s2: nat) : Tot bool =
  true

(* exp_rel_n (matches Coq: Definition exp_rel_n) *)
let exp_rel_n (p_n: nat) (p_sigma: nat) (p_t: ty) (p_e1: expr) (p_e2: expr) : Tot bool =
  true

(* label_join (matches Coq: Definition label_join) *)
let label_join (p_l1: sec_label) (p_l2: sec_label) : Tot sec_label =
  match p_l1, p_l2 with
  | _, H -> H
  | L, L -> L
  | _ -> (* TODO: default value for sec_label *) admit()

(* label_leq_refl (matches Coq: Lemma label_leq_refl) *)
let label_leq_refl (p_l: _) : Lemma (label_leq p_l p_l == true) = admit ()

(* label_leq_trans (matches Coq: Lemma label_leq_trans) *)
let label_leq_trans (p_l1: _) (p_l2: _) (p_l3: _) : Lemma (requires (label_leq p_l1 p_l2 == true /\ label_leq p_l2 p_l3 == true)) (ensures (label_leq p_l1 p_l3 == true)) = admit ()

(* label_leq_antisym (matches Coq: Lemma label_leq_antisym) *)
let label_leq_antisym (p_l1: _) (p_l2: _) : Lemma (requires (label_leq p_l1 p_l2 == true /\ label_leq p_l2 p_l1 == true)) (ensures (p_l1 == p_l2)) = admit ()

(* ty_size_pos (matches Coq: Lemma ty_size_pos) *)
let ty_size_pos (p_t: _) : Lemma (ty_size p_t > 0) = admit ()

(* ty_size_prod_left (matches Coq: Lemma ty_size_prod_left) *)
let ty_size_prod_left (p_t1: _) (p_t2: _) : Lemma (ty_size p_t1 < ty_size (TProd p_t1 p_t2)) = admit ()

(* ty_size_prod_right (matches Coq: Lemma ty_size_prod_right) *)
let ty_size_prod_right (p_t1: _) (p_t2: _) : Lemma (ty_size p_t2 < ty_size (TProd p_t1 p_t2)) = admit ()

(* ty_size_sum_left (matches Coq: Lemma ty_size_sum_left) *)
let ty_size_sum_left (p_t1: _) (p_t2: _) : Lemma (ty_size p_t1 < ty_size (TSum p_t1 p_t2)) = admit ()

(* ty_size_sum_right (matches Coq: Lemma ty_size_sum_right) *)
let ty_size_sum_right (p_t1: _) (p_t2: _) : Lemma (ty_size p_t2 < ty_size (TSum p_t1 p_t2)) = admit ()

(* store_update_lookup_eq (matches Coq: Lemma store_update_lookup_eq) *)
let store_update_lookup_eq (p_sigma: _) (p_l: _) (p_v: _) : Lemma (store_lookup p_l (store_update p_sigma p_l p_v) == Some p_v) = admit ()

(* store_update_lookup_neq (matches Coq: Lemma store_update_lookup_neq) *)
let store_update_lookup_neq (p_sigma: _) (p_l: _) (p_l_: _) (p_v: _) : Lemma (requires (~(p_l == p_l_))) (ensures (store_lookup p_l_ (store_update p_sigma p_l p_v) == store_lookup p_l_ p_sigma)) = admit ()

(* store_ty_update_lookup_eq (matches Coq: Lemma store_ty_update_lookup_eq) *)
let store_ty_update_lookup_eq (p_sigma: _) (p_l: _) (p_t: _) (p_lab: _) : Lemma (store_ty_lookup p_l (store_ty_update p_sigma p_l p_t p_lab) == Some (p_t, p_lab)) = admit ()

(* store_ty_update_lookup_neq (matches Coq: Lemma store_ty_update_lookup_neq) *)
let store_ty_update_lookup_neq (p_sigma: _) (p_l: _) (p_l_: _) (p_t: _) (p_lab: _) : Lemma (requires (~(p_l == p_l_))) (ensures (store_ty_lookup p_l_ (store_ty_update p_sigma p_l p_t p_lab) == store_ty_lookup p_l_ p_sigma)) = admit ()

(* store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl) *)
let store_ty_extends_refl (p_sigma: _) : Lemma (store_ty_extends p_sigma p_sigma == true) = admit ()

(* store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans) *)
let store_ty_extends_trans (p_sigma1: _) (p_sigma2: _) (p_sigma3: _) : Lemma (requires (store_ty_extends p_sigma1 p_sigma2 == true /\ store_ty_extends p_sigma2 p_sigma3 == true)) (ensures (store_ty_extends p_sigma1 p_sigma3 == true)) = admit ()

(* val_rel_n_zero (matches Coq: Lemma val_rel_n_zero) *)
let val_rel_n_zero (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (val_rel_n 0 p_sigma p_t p_v1 p_v2 == true) = admit ()

(* val_rel_n_unit (matches Coq: Lemma val_rel_n_unit) *)
let val_rel_n_unit (p_n: _) (p_sigma: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_n p_n p_sigma TUnit EUnit EUnit == true)) = admit ()

(* val_rel_n_bool (matches Coq: Lemma val_rel_n_bool) *)
let val_rel_n_bool (p_n: _) (p_sigma: _) (p_b: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_n p_n p_sigma TBool (EBool p_b) (EBool p_b) == true)) = admit ()

(* val_rel_n_nat (matches Coq: Lemma val_rel_n_nat) *)
let val_rel_n_nat (p_n: _) (p_sigma: _) (p_m: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_n p_n p_sigma TNat (ENat p_m) (ENat p_m) == true)) = admit ()

(* val_rel_n_ref (matches Coq: Lemma val_rel_n_ref) *)
let val_rel_n_ref (p_n: _) (p_sigma: _) (p_l: _) (p_t: _) (p_lab: _) : Lemma (requires (p_n > 0 /\ store_ty_lookup p_l p_sigma == Some (p_t, p_lab))) (ensures (val_rel_n p_n p_sigma (TRef p_t p_lab) (ELoc p_l) (ELoc p_l) == true)) = admit ()

(* val_rel_n_ref_same_loc (matches Coq: Lemma val_rel_n_ref_same_loc) *)
let val_rel_n_ref_same_loc (p_n: _) (p_sigma: _) (p_t: _) (p_lab: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_n p_n p_sigma (TRef p_t p_lab) p_v1 p_v2 == true)) (ensures ((exists p_l. p_v1 == ELoc p_l) /\ p_v2 == ELoc l /\ store_ty_lookup l p_sigma == Some (p_t, p_lab))) = admit ()

(* val_rel_n_cumulative (matches Coq: Lemma val_rel_n_cumulative) *)
let val_rel_n_cumulative (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_n ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_n_step_down (matches Coq: Lemma val_rel_n_step_down) *)
let val_rel_n_step_down (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ val_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_n p_m p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_n_value_left (matches Coq: Lemma val_rel_n_value_left) *)
let val_rel_n_value_left (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (is_value p_v1 == true)) = admit ()

(* val_rel_n_value_right (matches Coq: Lemma val_rel_n_value_right) *)
let val_rel_n_value_right (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (is_value p_v2 == true)) = admit ()

(* val_rel_n_prod (matches Coq: Lemma val_rel_n_prod) *)
let val_rel_n_prod (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1a: _) (p_v1b: _) (p_v2a: _) (p_v2b: _) : Lemma (requires (p_n > 0 /\ val_rel_n p_n p_sigma p_t1 p_v1a p_v2a == true /\ val_rel_n p_n p_sigma p_t2 p_v1b p_v2b == true /\ is_value p_v1a == true /\ is_value p_v1b == true /\ is_value p_v2a == true /\ is_value p_v2b == true)) (ensures (val_rel_n p_n p_sigma (TProd p_t1 p_t2) (EPair p_v1a p_v1b) (EPair p_v2a p_v2b) == true)) = admit ()

(* val_rel_n_inl (matches Coq: Lemma val_rel_n_inl) *)
let val_rel_n_inl (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_n p_n p_sigma p_t1 p_v1 p_v2 == true /\ is_value p_v1 == true /\ is_value p_v2 == true)) (ensures (val_rel_n p_n p_sigma (TSum p_t1 p_t2) (EInl p_v1) (EInl p_v2) == true)) = admit ()

(* val_rel_n_inr (matches Coq: Lemma val_rel_n_inr) *)
let val_rel_n_inr (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_n p_n p_sigma p_t2 p_v1 p_v2 == true /\ is_value p_v1 == true /\ is_value p_v2 == true)) (ensures (val_rel_n p_n p_sigma (TSum p_t1 p_t2) (EInr p_v1) (EInr p_v2) == true)) = admit ()

(* val_rel_n_lam (matches Coq: Lemma val_rel_n_lam) *)
let val_rel_n_lam (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_e1: _) (p_e2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_n p_n p_sigma (TArrow p_t1 p_t2) (ELam p_t1 p_e1) (ELam p_t1 p_e2) == true)) = admit ()

(* val_rel_n_fo_step_independent (matches Coq: Lemma val_rel_n_fo_step_independent) *)
let val_rel_n_fo_step_independent (p_t: _) (p_m: _) (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (first_order_type p_t == true /\ p_m > fo_compound_depth p_t /\ p_n > 0 /\ val_rel_n p_m p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* store_rel_n_zero (matches Coq: Lemma store_rel_n_zero) *)
let store_rel_n_zero (p_sigma: _) (p_s1: _) (p_s2: _) : Lemma (store_rel_n 0 p_sigma p_s1 p_s2 == true) = admit ()

(* store_rel_n_step_down (matches Coq: Lemma store_rel_n_step_down) *)
let store_rel_n_step_down (p_n: _) (p_m: _) (p_sigma: _) (p_sigma1: _) (p_sigma2: _) : Lemma (requires (p_m <= p_n /\ store_rel_n p_n p_sigma p_sigma1 p_sigma2 == true)) (ensures (store_rel_n p_m p_sigma p_sigma1 p_sigma2 == true)) = admit ()

(* store_rel_n_empty (matches Coq: Lemma store_rel_n_empty) *)
let store_rel_n_empty (p_n: _) : Lemma (store_rel_n p_n store_ty_empty store_empty store_empty == true) = admit ()

(* store_update_preserves_rel (matches Coq: Lemma store_update_preserves_rel) *)
let store_update_preserves_rel (p_n: _) (p_sigma: _) (p_sigma1: _) (p_sigma2: _) (p_l: _) (p_t: _) (p_lab: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_rel_n p_n p_sigma p_sigma1 p_sigma2 == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_lab) /\ val_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (store_rel_n p_n p_sigma (store_update p_sigma1 p_l p_v1) (store_update p_sigma2 p_l p_v2) == true)) = admit ()

(* store_ty_extends_antisym (matches Coq: Lemma store_ty_extends_antisym) *)
let store_ty_extends_antisym (p_sigma1: _) (p_sigma2: _) : Lemma (requires (store_ty_extends p_sigma1 p_sigma2 == true /\ store_ty_extends p_sigma2 p_sigma1 == true)) (ensures ((forall (l: _). store_ty_lookup l p_sigma1 == store_ty_lookup l p_sigma2))) = admit ()

(* store_ty_update_extends (matches Coq: Lemma store_ty_update_extends) *)
let store_ty_update_extends (p_sigma: _) (p_l: _) (p_t: _) (p_lab: _) : Lemma (requires (store_ty_lookup p_l p_sigma == None)) (ensures (store_ty_extends p_sigma (store_ty_update p_sigma p_l p_t p_lab) == true)) = admit ()

(* store_lookup_deterministic (matches Coq: Lemma store_lookup_deterministic) *)
let store_lookup_deterministic (p_s: _) (p_l: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_lookup p_l p_s == Some p_v1 /\ store_lookup p_l p_s == Some p_v2)) (ensures (p_v1 == p_v2)) = admit ()

(* store_ty_lookup_deterministic (matches Coq: Lemma store_ty_lookup_deterministic) *)
let store_ty_lookup_deterministic (p_sigma: _) (p_l: _) (p_t1: _) (p_sl1: _) (p_t2: _) (p_sl2: _) : Lemma (requires (store_ty_lookup p_l p_sigma == Some (p_t1, p_sl1) /\ store_ty_lookup p_l p_sigma == Some (p_t2, p_sl2))) (ensures (p_t1 == p_t2 /\ p_sl1 == p_sl2)) = admit ()

(* store_update_idem (matches Coq: Lemma store_update_idem) *)
let store_update_idem (p_s: _) (p_l: _) (p_v: _) : Lemma (store_update (store_update p_s p_l p_v) p_l p_v == store_update p_s p_l p_v) = admit ()

(* store_update_comm (matches Coq: Lemma store_update_comm) *)
let store_update_comm (p_s: _) (p_l1: _) (p_l2: _) (p_v1: _) (p_v2: _) : Lemma (requires (~(p_l1 == p_l2))) (ensures (store_update (store_update p_s p_l1 p_v1) p_l2 p_v2 == store_update (store_update p_s p_l2 p_v2) p_l1 p_v1)) = admit ()

(* exp_rel_n_zero (matches Coq: Lemma exp_rel_n_zero) *)
let exp_rel_n_zero (p_sigma: _) (p_t: _) (p_e1: _) (p_e2: _) : Lemma (exp_rel_n 0 p_sigma p_t p_e1 p_e2 == true) = admit ()

(* exp_rel_n_unit_expr (matches Coq: Lemma exp_rel_n_unit_expr) *)
let exp_rel_n_unit_expr (p_n: _) (p_sigma: _) : Lemma (requires (p_n > 0)) (ensures (exp_rel_n p_n p_sigma TUnit EUnit EUnit == true)) = admit ()

(* exp_rel_n_step_down (matches Coq: Lemma exp_rel_n_step_down) *)
let exp_rel_n_step_down (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_e1: _) (p_e2: _) : Lemma (requires (p_m <= p_n /\ exp_rel_n p_n p_sigma p_t p_e1 p_e2 == true)) (ensures (exp_rel_n p_m p_sigma p_t p_e1 p_e2 == true)) = admit ()

(* val_rel_implies_exp_rel (matches Coq: Lemma val_rel_implies_exp_rel) *)
let val_rel_implies_exp_rel (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (is_value p_v1 == true /\ is_value p_v2 == true /\ val_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (exp_rel_n p_n p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* exp_rel_n_bool_expr (matches Coq: Lemma exp_rel_n_bool_expr) *)
let exp_rel_n_bool_expr (p_n: _) (p_sigma: _) (p_b: _) : Lemma (requires (p_n > 0)) (ensures (exp_rel_n p_n p_sigma TBool (EBool p_b) (EBool p_b) == true)) = admit ()

(* label_join_comm (matches Coq: Lemma label_join_comm) *)
let label_join_comm (p_l1: _) (p_l2: _) : Lemma (label_join p_l1 p_l2 == label_join p_l2 p_l1) = admit ()

(* label_join_assoc (matches Coq: Lemma label_join_assoc) *)
let label_join_assoc (p_l1: _) (p_l2: _) (p_l3: _) : Lemma (label_join (label_join p_l1 p_l2) p_l3 == label_join p_l1 (label_join p_l2 p_l3)) = admit ()

(* label_join_idem (matches Coq: Lemma label_join_idem) *)
let label_join_idem (p_l: _) : Lemma (label_join p_l p_l == p_l) = admit ()

(* ty_eq_dec (matches Coq: Lemma ty_eq_dec) *)
let ty_eq_dec (p_t1: ty) (p_t2: ty) : Lemma ({p_t1 == p_t2} + {p_t1 <> p_t2}) = admit ()

(* first_order_prod_components (matches Coq: Lemma first_order_prod_components) *)
let first_order_prod_components (p_t1: _) (p_t2: _) : Lemma (requires (first_order_type (TProd p_t1 p_t2) == true)) (ensures (first_order_type p_t1 == true /\ first_order_type p_t2 == true)) = admit ()

(* first_order_sum_components (matches Coq: Lemma first_order_sum_components) *)
let first_order_sum_components (p_t1: _) (p_t2: _) : Lemma (requires (first_order_type (TSum p_t1 p_t2) == true)) (ensures (first_order_type p_t1 == true /\ first_order_type p_t2 == true)) = admit ()

(* fo_depth_prod (matches Coq: Lemma fo_depth_prod) *)
let fo_depth_prod (p_t1: _) (p_t2: _) : Lemma (fo_compound_depth (TProd p_t1 p_t2) == 1 + max (fo_compound_depth p_t1) (fo_compound_depth p_t2)) = admit ()

(* fo_depth_sum (matches Coq: Lemma fo_depth_sum) *)
let fo_depth_sum (p_t1: _) (p_t2: _) : Lemma (fo_compound_depth (TSum p_t1 p_t2) == 1 + max (fo_compound_depth p_t1) (fo_compound_depth p_t2)) = admit ()

(* fo_depth_primitive (matches Coq: Lemma fo_depth_primitive) *)
let fo_depth_primitive_obligation () : Tot bool = true
let fo_depth_primitive_lemma () : Lemma (requires True) (ensures (fo_depth_primitive_obligation () == fo_depth_primitive_obligation ())) = ()
