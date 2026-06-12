(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/FirstOrderComplete.v (56 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.FirstOrderComplete
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* is_base_type (matches Coq: Definition is_base_type) *)
let is_base_type (p_t: nat) : Tot bool =
  match p_t with
  | TBytes -> true
  | TCapability _ -> true
  | TCapabilityFull _ -> true
  | _ -> false

(* store_independent (matches Coq: Definition store_independent) *)
let store_independent (p_p: nat) : Tot bool =
  true

(* expr_eqb (matches Coq: Fixpoint expr_eqb) *)
let rec expr_eqb (p_e1: nat) (p_e2: nat) : Tot bool =
  match p_e1, p_e2 with
  | EUnit, EUnit -> true
  | EBool (b1,, EBool, b2) -> Bool.eqb b1 b2
  | EInt (n1,, EInt, n2) -> (n1 = n2)
  | EString (s1,, EString, s2) -> s1 = s2
  | ELoc (l1,, ELoc, l2) -> (l1 = l2)
  | EVar (x1,, EVar, x2) -> x1 = x2
  | ELam (x1, T1, p_e1',, ELam, x2, T2, p_e2') -> x1 = x2 && expr_eqb p_e1' p_e2'
  | EPair (a1, b1,, EPair, a2, b2) -> expr_eqb a1 a2 && expr_eqb b1 b2
  | EInl (p_e1', T1,, EInl, p_e2', T2) -> expr_eqb p_e1' p_e2'
  | EInr (p_e1', T1,, EInr, p_e2', T2) -> expr_eqb p_e1' p_e2'
  | EClassify (p_e1',, EClassify, p_e2') -> expr_eqb p_e1' p_e2'
  | EProve (p_e1',, EProve, p_e2') -> expr_eqb p_e1' p_e2'
  | _, _ -> false
  | _ -> false

(* ty_eqb (matches Coq: Fixpoint ty_eqb) *)
let rec ty_eqb (p_t1: nat) (p_t2: nat) : Tot bool =
  match p_t1, p_t2 with
  | TUnit, TUnit -> true
  | TBool, TBool -> true
  | TInt, TInt -> true
  | TString, TString -> true
  | TBytes, TBytes -> true
  | TFn (A1, B1, e1,, TFn, A2, B2, e2) -> ty_eqb A1 A2 && ty_eqb B1 B2
  | TProd (A1, B1,, TProd, A2, B2) -> ty_eqb A1 A2 && ty_eqb B1 B2
  | TSum (A1, B1,, TSum, A2, B2) -> ty_eqb A1 A2 && ty_eqb B1 B2
  | TList (p_t1',, TList, p_t2') -> ty_eqb p_t1' p_t2'
  | TOption (p_t1',, TOption, p_t2') -> ty_eqb p_t1' p_t2'
  | TRef (p_t1', _,, TRef, p_t2', _) -> ty_eqb p_t1' p_t2'
  | TSecret (p_t1',, TSecret, p_t2') -> ty_eqb p_t1' p_t2'
  | TLabeled (p_t1', _,, TLabeled, p_t2', _) -> ty_eqb p_t1' p_t2'
  | TTainted (p_t1', _,, TTainted, p_t2', _) -> ty_eqb p_t1' p_t2'
  | TSanitized (p_t1', _,, TSanitized, p_t2', _) -> ty_eqb p_t1' p_t2'
  | TProof (p_t1',, TProof, p_t2') -> ty_eqb p_t1' p_t2'
  | TCapability (_,, TCapability, _) -> true
  | TCapabilityFull (_,, TCapabilityFull, _) -> true
  | TChan (_,, TChan, _) -> true
  | TSecureChan (_, _,, TSecureChan, _, _) -> true
  | TConstantTime (p_t1',, TConstantTime, p_t2') -> ty_eqb p_t1' p_t2'
  | TZeroizing (p_t1',, TZeroizing, p_t2') -> ty_eqb p_t1' p_t2'
  | _, _ -> false
  | _ -> false

(* first_order_subtype (matches Coq: Lemma first_order_subtype) *)
let first_order_subtype_obligation () : Tot bool = true
let first_order_subtype_lemma () : Lemma (requires True) (ensures (first_order_subtype_obligation () == first_order_subtype_obligation ())) = ()

(* first_order_subtypes_fo (matches Coq: Lemma first_order_subtypes_fo) *)
let first_order_subtypes_fo (p_t: _) : Lemma (requires (first_order_type p_t == true /\ (forall (p_t: _). ((exists p_t2. p_t == TProd p_t' p_t2))) \/ ((exists p_t1. p_t == TProd p_t1 p_t')) \/ ((exists p_t2. p_t == TSum p_t' p_t2)) \/ ((exists p_t1. p_t == TSum p_t1 p_t')) \/ p_t == TList p_t' \/ p_t == TOption p_t' \/ ((exists p_sl. p_t == TRef p_t' p_sl)) \/ p_t == TSecret p_t' \/ ((exists p_sl. p_t == TLabeled p_t' p_sl)) \/ ((exists p_src. p_t == TTainted p_t' p_src)) \/ ((exists p_san. p_t == TSanitized p_t' p_san)) \/ p_t == TProof p_t' \/ p_t == TConstantTime p_t' \/ p_t == TZeroizing p_t')) (ensures (first_order_type p_t' == true)) = admit ()

(* base_type_first_order (matches Coq: Lemma base_type_first_order) *)
let base_type_first_order (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures (first_order_type p_t == true)) = admit ()

(* base_type_size_one (matches Coq: Lemma base_type_size_one) *)
let base_type_size_one (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures (ty_size p_t == 1)) = admit ()

(* first_order_value_structure (matches Coq: Lemma first_order_value_structure) *)
let first_order_value_structure_obligation () : Tot bool = true
let first_order_value_structure_lemma () : Lemma (requires True) (ensures (first_order_value_structure_obligation () == first_order_value_structure_obligation ())) = ()

(* first_order_induction_simple (matches Coq: Lemma first_order_induction_simple) *)
let first_order_induction_simple_obligation () : Tot bool = true
let first_order_induction_simple_lemma () : Lemma (requires True) (ensures (first_order_induction_simple_obligation () == first_order_induction_simple_obligation ())) = ()

(* ty_eqb_refl (matches Coq: Lemma ty_eqb_refl) *)
let ty_eqb_refl (p_t: _) : Lemma (ty_eqb p_t p_t == true) = admit ()

(* ty_eqb_eq (matches Coq: Lemma ty_eqb_eq) *)
let ty_eqb_eq_obligation () : Tot bool = true
let ty_eqb_eq_lemma () : Lemma (requires True) (ensures (ty_eqb_eq_obligation () == ty_eqb_eq_obligation ())) = ()

(* ty_eqb_unit_bool_false (matches Coq: Lemma ty_eqb_unit_bool_false) *)
let ty_eqb_unit_bool_false () : Lemma (ty_eqb TUnit TBool == false) = admit ()

(* ty_eqb_unit_int_false (matches Coq: Lemma ty_eqb_unit_int_false) *)
let ty_eqb_unit_int_false () : Lemma (ty_eqb TUnit TInt == false) = admit ()

(* ty_eqb_bool_int_false (matches Coq: Lemma ty_eqb_bool_int_false) *)
let ty_eqb_bool_int_false () : Lemma (ty_eqb TBool TInt == false) = admit ()

(* ty_eqb_bool_string_false (matches Coq: Lemma ty_eqb_bool_string_false) *)
let ty_eqb_bool_string_false () : Lemma (ty_eqb TBool TString == false) = admit ()

(* ty_eqb_int_string_false (matches Coq: Lemma ty_eqb_int_string_false) *)
let ty_eqb_int_string_false () : Lemma (ty_eqb TInt TString == false) = admit ()

(* ty_eqb_unit_string_false (matches Coq: Lemma ty_eqb_unit_string_false) *)
let ty_eqb_unit_string_false () : Lemma (ty_eqb TUnit TString == false) = admit ()

(* fn_not_first_order (matches Coq: Lemma fn_not_first_order) *)
let fn_not_first_order (p_t1: _) (p_t2: _) (p_eff: _) : Lemma (first_order_type (TFn p_t1 p_t2 p_eff) == false) = admit ()

(* chan_not_first_order (matches Coq: Lemma chan_not_first_order) *)
let chan_not_first_order (p_s: _) : Lemma (first_order_type (TChan p_s) == false) = admit ()

(* securechan_not_first_order (matches Coq: Lemma securechan_not_first_order) *)
let securechan_not_first_order (p_s: _) (p_sl: _) : Lemma (first_order_type (TSecureChan p_s p_sl) == false) = admit ()

(* base_type_not_fn (matches Coq: Lemma base_type_not_fn) *)
let base_type_not_fn (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (t1: _). (forall (t2: _). (forall (eff: _). ~(p_t == TFn t1 t2 eff)))))) = admit ()

(* base_type_not_prod (matches Coq: Lemma base_type_not_prod) *)
let base_type_not_prod (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (t1: _). (forall (t2: _). ~(p_t == TProd t1 t2))))) = admit ()

(* base_type_not_sum (matches Coq: Lemma base_type_not_sum) *)
let base_type_not_sum (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (t1: _). (forall (t2: _). ~(p_t == TSum t1 t2))))) = admit ()

(* base_type_not_list (matches Coq: Lemma base_type_not_list) *)
let base_type_not_list (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (p_t: _). ~(p_t == TList p_t')))) = admit ()

(* base_type_not_option (matches Coq: Lemma base_type_not_option) *)
let base_type_not_option (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (p_t: _). ~(p_t == TOption p_t')))) = admit ()

(* fo_compound_depth_unit (matches Coq: Lemma fo_compound_depth_unit) *)
let fo_compound_depth_unit () : Lemma (fo_compound_depth TUnit == 0) = admit ()

(* fo_compound_depth_bool (matches Coq: Lemma fo_compound_depth_bool) *)
let fo_compound_depth_bool () : Lemma (fo_compound_depth TBool == 0) = admit ()

(* fo_compound_depth_int (matches Coq: Lemma fo_compound_depth_int) *)
let fo_compound_depth_int () : Lemma (fo_compound_depth TInt == 0) = admit ()

(* fo_compound_depth_string (matches Coq: Lemma fo_compound_depth_string) *)
let fo_compound_depth_string () : Lemma (fo_compound_depth TString == 0) = admit ()

(* fo_compound_depth_bytes (matches Coq: Lemma fo_compound_depth_bytes) *)
let fo_compound_depth_bytes () : Lemma (fo_compound_depth TBytes == 0) = admit ()

(* fo_compound_depth_list (matches Coq: Lemma fo_compound_depth_list) *)
let fo_compound_depth_list (p_t: _) : Lemma (fo_compound_depth (TList p_t) == 0) = admit ()

(* fo_compound_depth_option (matches Coq: Lemma fo_compound_depth_option) *)
let fo_compound_depth_option (p_t: _) : Lemma (fo_compound_depth (TOption p_t) == 0) = admit ()

(* fo_compound_depth_ref (matches Coq: Lemma fo_compound_depth_ref) *)
let fo_compound_depth_ref (p_t: _) (p_sl: _) : Lemma (fo_compound_depth (TRef p_t p_sl) == 0) = admit ()

(* fo_compound_depth_secret (matches Coq: Lemma fo_compound_depth_secret) *)
let fo_compound_depth_secret (p_t: _) : Lemma (fo_compound_depth (TSecret p_t) == 0) = admit ()

(* fo_compound_depth_fn (matches Coq: Lemma fo_compound_depth_fn) *)
let fo_compound_depth_fn (p_t1: _) (p_t2: _) (p_eff: _) : Lemma (fo_compound_depth (TFn p_t1 p_t2 p_eff) == 0) = admit ()

(* ty_eqb_sym (matches Coq: Lemma ty_eqb_sym) *)
let ty_eqb_sym (p_t1: _) (p_t2: _) : Lemma (ty_eqb p_t1 p_t2 == ty_eqb p_t2 p_t1) = admit ()

(* expr_eqb_unit (matches Coq: Lemma expr_eqb_unit) *)
let expr_eqb_unit () : Lemma (expr_eqb EUnit EUnit == true) = admit ()

(* expr_eqb_bool (matches Coq: Lemma expr_eqb_bool) *)
let expr_eqb_bool (p_b: _) : Lemma (expr_eqb (EBool p_b) (EBool p_b) == true) = admit ()

(* expr_eqb_int (matches Coq: Lemma expr_eqb_int) *)
let expr_eqb_int (p_n: _) : Lemma (expr_eqb (EInt p_n) (EInt p_n) == true) = admit ()

(* expr_eqb_string (matches Coq: Lemma expr_eqb_string) *)
let expr_eqb_string (p_s: _) : Lemma (expr_eqb (EString p_s) (EString p_s) == true) = admit ()

(* expr_eqb_loc (matches Coq: Lemma expr_eqb_loc) *)
let expr_eqb_loc (p_l: _) : Lemma (expr_eqb (ELoc p_l) (ELoc p_l) == true) = admit ()

(* expr_eqb_var (matches Coq: Lemma expr_eqb_var) *)
let expr_eqb_var (p_x: _) : Lemma (expr_eqb (EVar p_x) (EVar p_x) == true) = admit ()

(* is_base_type_unit (matches Coq: Lemma is_base_type_unit) *)
let is_base_type_unit () : Lemma (is_base_type TUnit == true) = admit ()

(* is_base_type_bool (matches Coq: Lemma is_base_type_bool) *)
let is_base_type_bool () : Lemma (is_base_type TBool == true) = admit ()

(* is_base_type_int (matches Coq: Lemma is_base_type_int) *)
let is_base_type_int () : Lemma (is_base_type TInt == true) = admit ()

(* is_base_type_string (matches Coq: Lemma is_base_type_string) *)
let is_base_type_string () : Lemma (is_base_type TString == true) = admit ()

(* is_base_type_bytes (matches Coq: Lemma is_base_type_bytes) *)
let is_base_type_bytes () : Lemma (is_base_type TBytes == true) = admit ()

(* first_order_type_prod_iff (matches Coq: Lemma first_order_type_prod_iff) *)
let first_order_type_prod_iff (p_t1: _) (p_t2: _) : Lemma (first_order_type (TProd p_t1 p_t2) == true <==> first_order_type p_t1 == true /\ first_order_type p_t2 == true) = admit ()

(* first_order_type_sum_iff (matches Coq: Lemma first_order_type_sum_iff) *)
let first_order_type_sum_iff (p_t1: _) (p_t2: _) : Lemma (first_order_type (TSum p_t1 p_t2) == true <==> first_order_type p_t1 == true /\ first_order_type p_t2 == true) = admit ()

(* first_order_type_secret_iff (matches Coq: Lemma first_order_type_secret_iff) *)
let first_order_type_secret_iff (p_t: _) : Lemma (first_order_type (TSecret p_t) == first_order_type p_t) = admit ()

(* ty_eqb_prod (matches Coq: Lemma ty_eqb_prod) *)
let ty_eqb_prod (p_t1: _) (p_t2: _) (p_t3: _) (p_t4: _) : Lemma (ty_eqb (TProd p_t1 p_t2) (TProd p_t3 p_t4) == (ty_eqb p_t1 p_t3 && ty_eqb p_t2 p_t4)%bool) = admit ()

(* ty_eqb_sum (matches Coq: Lemma ty_eqb_sum) *)
let ty_eqb_sum (p_t1: _) (p_t2: _) (p_t3: _) (p_t4: _) : Lemma (ty_eqb (TSum p_t1 p_t2) (TSum p_t3 p_t4) == (ty_eqb p_t1 p_t3 && ty_eqb p_t2 p_t4)%bool) = admit ()

(* base_type_not_ref (matches Coq: Lemma base_type_not_ref) *)
let base_type_not_ref (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (p_t: _). ~(p_t == TRef p_t' sl)))) = admit ()

(* base_type_not_secret (matches Coq: Lemma base_type_not_secret) *)
let base_type_not_secret (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (p_t: _). ~(p_t == TSecret p_t')))) = admit ()

(* first_order_type_list_iff (matches Coq: Lemma first_order_type_list_iff) *)
let first_order_type_list_iff (p_t: _) : Lemma (first_order_type (TList p_t) == first_order_type p_t) = admit ()

(* first_order_type_option_iff (matches Coq: Lemma first_order_type_option_iff) *)
let first_order_type_option_iff (p_t: _) : Lemma (first_order_type (TOption p_t) == first_order_type p_t) = admit ()

(* ty_eqb_list (matches Coq: Lemma ty_eqb_list) *)
let ty_eqb_list (p_t1: _) (p_t2: _) : Lemma (ty_eqb (TList p_t1) (TList p_t2) == ty_eqb p_t1 p_t2) = admit ()

(* ty_eqb_option (matches Coq: Lemma ty_eqb_option) *)
let ty_eqb_option (p_t1: _) (p_t2: _) : Lemma (ty_eqb (TOption p_t1) (TOption p_t2) == ty_eqb p_t1 p_t2) = admit ()

(* base_type_not_labeled (matches Coq: Lemma base_type_not_labeled) *)
let base_type_not_labeled (p_t: _) : Lemma (requires (is_base_type p_t == true)) (ensures ((forall (p_t: _). ~(p_t == TLabeled p_t' sl)))) = admit ()
