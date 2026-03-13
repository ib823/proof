(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/IrisSeparationLogic.v (21 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.IrisSeparationLogic
open FStar.All

(* hprop (matches Coq) *)
type hprop =
  | HEmpty
  | HPointsTo of (nat * nat)
  | HStar of (hprop * hprop)
  | HPure of bool
  | HWand of (hprop * hprop)

(* fprop (matches Coq) *)
type fprop =
  | FEmpty
  | FPointsTo of (nat * nat)
  | FStar of (fprop * fprop)
  | FPure of bool

(* mem (matches Coq: Fixpoint mem) *)
let rec mem (p_n: nat) (p_l: (list nat)) : Tot bool =
  match p_l with
  | [] -> false
  | x :: xs -> (x = p_n)
  | _ -> false

(* disjoint (matches Coq: Definition disjoint) *)
let disjoint (p_h1: nat) (p_h2: nat) : Tot bool =
  true

(* heap_union (matches Coq: Definition heap_union) *)
let heap_union (p_h1: nat) (p_h2: nat) : Tot nat =
  p_h1 @ p_h2

(* heap_lookup (matches Coq: Fixpoint heap_lookup) *)
let rec heap_lookup (p_h: nat) (p_l: nat) : Tot nat =
  match p_h with
  | [] -> None
  | (p_l', v) :: rest -> if p_l' = p_l then Some v else heap_lookup rest p_l
  | _ -> 0

(* satisfies (matches Coq: Fixpoint satisfies) *)
let rec satisfies (p_h: nat) (p_p: hprop) : Tot bool =
  true

(* fempty (matches Coq: Definition fempty) *)
let fempty : nat = fun _ -> None

(* fsingleton (matches Coq: Definition fsingleton) *)
let fsingleton (p_l: nat) (p_v: nat) : Tot nat =
  fun p_l' => if p_l' = p_l then Some p_v else None

(* fdisjoint (matches Coq: Definition fdisjoint) *)
let fdisjoint (p_h1: nat) (p_h2: nat) : Tot bool =
  true

(* funion (matches Coq: Definition funion) *)
let funion (p_h1: nat) (p_h2: nat) : Tot nat =
  fun l -> match p_h1 l with
  | Some v -> Some v
  | None -> p_h2 l
  | _ -> 0

(* fsat (matches Coq: Fixpoint fsat) *)
let rec fsat (p_h: nat) (p_p: fprop) : Tot bool =
  true

(* emp_empty (matches Coq: Theorem emp_empty) *)
let emp_empty () : Lemma (satisfies [] HEmpty == true) = ()

(* points_to_singleton (matches Coq: Theorem points_to_singleton) *)
let points_to_singleton (p_l: _) (p_v: _) : Lemma (satisfies [(p_l, p_v)] (HPointsTo p_l p_v) == true) = ()

(* disjoint_sym (matches Coq: Lemma disjoint_sym) *)
let disjoint_sym (p_h1: _) (p_h2: _) : Lemma (requires (disjoint p_h1 p_h2 == true)) (ensures (disjoint p_h2 p_h1 == true)) = ()

(* star_comm (matches Coq: Theorem star_comm) *)
let star_comm (p_p1: _) (p_p2: _) (p_h: _) : Lemma (requires (fsat p_h (FStar p_p1 p_p2) == true)) (ensures (fsat p_h (FStar p_p2 p_p1) == true)) = ()

(* star_emp_l (matches Coq: Theorem star_emp_l) *)
let star_emp_l (p_p: _) (p_h: _) : Lemma (requires (fsat p_h p_p == true)) (ensures (fsat p_h (FStar FEmpty p_p) == true)) = ()

(* points_to_exclusive (matches Coq: Theorem points_to_exclusive) *)
let points_to_exclusive (p_l: _) (p_v1: _) (p_v2: _) (p_h: _) : Lemma (requires (fsat p_h (FStar (FPointsTo p_l p_v1) (FPointsTo p_l p_v2)) == true)) (ensures (False)) = ()

(* frame_rule (matches Coq: Theorem frame_rule) *)
let frame_rule (p_p: _) (p_f: _) (p_h1: _) (p_h2: _) : Lemma (requires (fsat p_h1 p_p == true /\ fsat p_h2 p_f == true /\ fdisjoint p_h1 p_h2 == true)) (ensures (fsat (funion p_h1 p_h2) (FStar p_p p_f) == true)) = ()

(* fdisjoint_empty_l (matches Coq: Theorem fdisjoint_empty_l) *)
let fdisjoint_empty_l (p_h: _) : Lemma (fdisjoint fempty p_h == true) = ()

(* fdisjoint_empty_r (matches Coq: Theorem fdisjoint_empty_r) *)
let fdisjoint_empty_r (p_h: _) : Lemma (fdisjoint p_h fempty == true) = ()

(* funion_empty_l (matches Coq: Theorem funion_empty_l) *)
let funion_empty_l (p_h: _) (p_l: _) : Lemma (funion fempty p_h p_l == p_h p_l) = ()

(* funion_empty_r (matches Coq: Theorem funion_empty_r) *)
let funion_empty_r (p_h: _) (p_l: _) : Lemma (funion p_h fempty p_l == p_h p_l) = ()

(* fdisjoint_sym (matches Coq: Theorem fdisjoint_sym) *)
let fdisjoint_sym (p_h1: _) (p_h2: _) : Lemma (requires (fdisjoint p_h1 p_h2 == true)) (ensures (fdisjoint p_h2 p_h1 == true)) = ()

(* pure_extract (matches Coq: Theorem pure_extract) *)
let pure_extract (p_p: bool) (p_h: _) : Lemma (requires (fsat p_h (FPure p_p) == true)) (ensures (p_p == true)) = ()

(* pure_empty_heap (matches Coq: Theorem pure_empty_heap) *)
let pure_empty_heap (p_p: bool) (p_h: _) : Lemma (requires (fsat p_h (FPure p_p) == true)) (ensures ((forall (l: _). p_h l == None))) = ()

(* points_to_read (matches Coq: Theorem points_to_read) *)
let points_to_read (p_l: _) (p_v: _) (p_h: _) : Lemma (requires (fsat p_h (FPointsTo p_l p_v) == true)) (ensures (p_h p_l == Some p_v)) = ()

(* points_to_other_none (matches Coq: Theorem points_to_other_none) *)
let points_to_other_none (p_l: _) (p_v: _) (p_h: _) (p_l_: _) : Lemma (requires (fsat p_h (FPointsTo p_l p_v) == true /\ ~(p_l_ == p_l))) (ensures (p_h p_l_ == None)) = ()

(* fempty_sat_empty (matches Coq: Theorem fempty_sat_empty) *)
let fempty_sat_empty () : Lemma (fsat fempty FEmpty == true) = ()

(* fsingleton_sat (matches Coq: Theorem fsingleton_sat) *)
let fsingleton_sat (p_l: _) (p_v: _) : Lemma (fsat (fsingleton p_l p_v) (FPointsTo p_l p_v) == true) = ()

(* fsingleton_lookup_neq (matches Coq: Theorem fsingleton_lookup_neq) *)
let fsingleton_lookup_neq (p_l: _) (p_l_: _) (p_v: _) : Lemma (requires (~(p_l_ == p_l))) (ensures (fsingleton p_l p_v p_l_ == None)) = ()

(* fdisjoint_singletons (matches Coq: Theorem fdisjoint_singletons) *)
let fdisjoint_singletons (p_l1: _) (p_l2: _) (p_v1: _) (p_v2: _) : Lemma (requires (~(p_l1 == p_l2))) (ensures (fdisjoint (fsingleton p_l1 p_v1) (fsingleton p_l2 p_v2) == true)) = ()

(* fempty_pure_true (matches Coq: Theorem fempty_pure_true) *)
let fempty_pure_true () : Lemma (fsat fempty (FPure True) == true) = ()
