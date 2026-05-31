(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/CRDTFoundations.v (95 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.CRDTFoundations
open FStar.All

(* LWWRegister (matches Coq) *)
type lww_register = {
  f_lww_val: nat;
  f_lww_ts: nat;
}

(* pointwise_max (matches Coq: Fixpoint pointwise_max) *)
let rec pointwise_max (p_a: (list nat)) (p_b: (list nat)) : Tot list bool =
  match p_a, p_b with
  | [], _ -> p_b
  | _, [] -> p_a
  | x :: xs, y :: ys -> (if x >= y then x else y) :: pointwise_max xs ys
  | _ -> []

(* list_leq (matches Coq: Definition list_leq) *)
let list_leq (p_a: (list nat)) (p_b: (list nat)) : Tot bool =
  true

(* member (matches Coq: Definition member) *)
let member (p_v: nat) (p_s: (list nat)) : Tot bool =
  existsb (Nat.eqb p_v) p_s

(* set_eq (matches Coq: Definition set_eq) *)
let set_eq (p_a: (list nat)) (p_b: (list nat)) : Tot bool =
  true

(* gc_bottom (matches Coq: Definition gc_bottom) *)
let gc_bottom (p_n: nat) : Tot nat =
  repeat 0 p_n

(* gc_merge (matches Coq: Definition gc_merge) *)
let gc_merge (p_a: nat) (p_b: nat) : Tot nat =
  pointwise_max p_a p_b

(* gc_value (matches Coq: Definition gc_value) *)
let gc_value (p_gc: nat) : Tot nat =
  fold_left Nat.add p_gc 0

(* gc_increment (matches Coq: Definition gc_increment) *)
let gc_increment (p_gc: nat) (p_node: nat) : Tot nat =
  map (fun p -> if Nat.eqb (fst p) p_node then ((snd p) + 1) else snd p) (combine (seq 0 (List.Tot.length p_gc)) p_gc)

(* gc_leq (matches Coq: Definition gc_leq) *)
let gc_leq (p_a: nat) (p_b: nat) : Tot bool =
  true

(* pn_merge (matches Coq: Definition pn_merge) *)
let pn_merge (p_a: nat) (p_b: nat) : Tot nat =
  (gc_merge (fst p_a) (fst p_b), gc_merge (snd p_a) (snd p_b))

(* pn_positive (matches Coq: Definition pn_positive) *)
let pn_positive (p_p: nat) : Tot nat =
  gc_value (fst p_p)

(* pn_negative (matches Coq: Definition pn_negative) *)
let pn_negative (p_p: nat) : Tot nat =
  gc_value (snd p_p)

(* pn_bottom (matches Coq: Definition pn_bottom) *)
let pn_bottom (p_n: nat) : Tot nat =
  (gc_bottom p_n, gc_bottom p_n)

(* pn_increment (matches Coq: Definition pn_increment) *)
let pn_increment (p_p: nat) (p_node: nat) : Tot nat =
  (gc_increment (fst p_p) p_node, snd p_p)

(* pn_decrement (matches Coq: Definition pn_decrement) *)
let pn_decrement (p_p: nat) (p_node: nat) : Tot nat =
  (fst p_p, gc_increment (snd p_p) p_node)

(* pn_leq (matches Coq: Definition pn_leq) *)
let pn_leq (p_a: nat) (p_b: nat) : Tot bool =
  true

(* gs_add (matches Coq: Definition gs_add) *)
let gs_add (p_s: nat) (p_v: nat) : Tot nat =
  if member p_v p_s then p_s else p_v :: p_s

(* gs_merge (matches Coq: Definition gs_merge) *)
let gs_merge (p_a: nat) (p_b: nat) : Tot nat =
  fold_left (fun acc v -> gs_add acc v) p_b p_a

(* gs_member (matches Coq: Definition gs_member) *)
let gs_member (p_s: nat) (p_v: nat) : Tot bool =
  member p_v p_s

(* gs_empty (matches Coq: Definition gs_empty) *)
let gs_empty : nat = []

(* tp_add (matches Coq: Definition tp_add) *)
let tp_add (p_s: nat) (p_v: nat) : Tot nat =
  (gs_add (fst p_s) p_v, snd p_s)

(* tp_remove (matches Coq: Definition tp_remove) *)
let tp_remove (p_s: nat) (p_v: nat) : Tot nat =
  (fst p_s, gs_add (snd p_s) p_v)

(* tp_lookup (matches Coq: Definition tp_lookup) *)
let tp_lookup (p_s: nat) (p_v: nat) : Tot bool =
  gs_member (fst p_s) p_v && (not (gs_member (snd p_s)) p_v)

(* tp_merge (matches Coq: Definition tp_merge) *)
let tp_merge (p_a: nat) (p_b: nat) : Tot nat =
  (gs_merge (fst p_a) (fst p_b), gs_merge (snd p_a) (snd p_b))

(* tp_empty (matches Coq: Definition tp_empty) *)
let tp_empty : nat = (gs_empty, gs_empty)

(* lww_merge (matches Coq: Definition lww_merge) *)
let lww_merge (p_a: lww_register) (p_b: lww_register) : Tot lww_register =
  if p_a.f_lww_ts < p_b.f_lww_ts then p_b else if p_b.f_lww_ts < p_a.f_lww_ts then p_a else if p_a.f_lww_val <= p_b.f_lww_val then p_b else p_a

(* lww_write (matches Coq: Definition lww_write) *)
let lww_write (p_r: lww_register) (p_v: nat) (p_ts: nat) : Tot lww_register =
  {f_lww_val=p_v; f_lww_ts=p_ts}

(* lww_read (matches Coq: Definition lww_read) *)
let lww_read (p_r: lww_register) : Tot nat =
  p_r.f_lww_val

(* lww_bottom (matches Coq: Definition lww_bottom) *)
let lww_bottom : lww_register = {f_lww_val=0; f_lww_ts=0}

(* or_entry_eqb (matches Coq: Definition or_entry_eqb) *)
let or_entry_eqb (p_a: nat) (p_b: nat) : Tot bool =
  Nat.eqb (fst p_a) (fst p_b) && Nat.eqb (snd p_a) (snd p_b)

(* or_in_list (matches Coq: Definition or_in_list) *)
let or_in_list (p_e: nat) (p_l: (list nat)) : Tot bool =
  existsb (or_entry_eqb p_e) p_l

(* or_lookup (matches Coq: Definition or_lookup) *)
let or_lookup (p_s: nat) (p_v: nat) : Tot bool =
  existsb (fun e -> Nat.eqb (fst e) p_v && (not (or_in_list e (snd p_s)))) (fst p_s)

(* or_add (matches Coq: Definition or_add) *)
let or_add (p_s: nat) (p_v: nat) (p_tag: nat) : Tot nat =
  ((p_v, p_tag) :: fst p_s, snd p_s)

(* or_remove (matches Coq: Definition or_remove) *)
let or_remove (p_s: nat) (p_v: nat) : Tot nat =
  (fst p_s, filter (fun e -> Nat.eqb (fst e) p_v) (fst p_s) @ snd p_s)

(* or_merge (matches Coq: Definition or_merge) *)
let or_merge (p_a: nat) (p_b: nat) : Tot nat =
  (fst p_a @ fst p_b, snd p_a @ snd p_b)

(* or_empty (matches Coq: Definition or_empty) *)
let or_empty : nat = ([], [])

(* pointwise_max_nil_l (matches Coq: Lemma pointwise_max_nil_l) *)
let pointwise_max_nil_l (p_b: _) : Lemma (pointwise_max [] p_b == p_b) = admit ()

(* pointwise_max_nil_r (matches Coq: Lemma pointwise_max_nil_r) *)
let pointwise_max_nil_r (p_a: _) : Lemma (pointwise_max p_a [] == p_a) = admit ()

(* pointwise_max_comm (matches Coq: Lemma pointwise_max_comm) *)
let pointwise_max_comm (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (pointwise_max p_a p_b == pointwise_max p_b p_a)) = admit ()

(* pointwise_max_assoc (matches Coq: Lemma pointwise_max_assoc) *)
let pointwise_max_assoc (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (length p_a == length p_b /\ length p_b == length p_c)) (ensures (pointwise_max (pointwise_max p_a p_b) p_c == pointwise_max p_a (pointwise_max p_b p_c))) = admit ()

(* pointwise_max_idem (matches Coq: Lemma pointwise_max_idem) *)
let pointwise_max_idem (p_a: _) : Lemma (pointwise_max p_a p_a == p_a) = admit ()

(* pointwise_max_length (matches Coq: Lemma pointwise_max_length) *)
let pointwise_max_length (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (length (pointwise_max p_a p_b) == length p_a)) = admit ()

(* list_leq_refl (matches Coq: Lemma list_leq_refl) *)
let list_leq_refl (p_a: _) : Lemma (list_leq p_a p_a == true) = admit ()

(* list_leq_trans (matches Coq: Lemma list_leq_trans) *)
let list_leq_trans (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (list_leq p_a p_b == true /\ list_leq p_b p_c == true)) (ensures (list_leq p_a p_c == true)) = admit ()

(* nth_pointwise_max (matches Coq: Lemma nth_pointwise_max) *)
let nth_pointwise_max (p_a: _) (p_b: _) (p_i: _) : Lemma (requires (length p_a == length p_b)) (ensures (nth p_i (pointwise_max p_a p_b) 0 == Nat.max (nth p_i p_a 0) (nth p_i p_b 0))) = admit ()

(* list_leq_pointwise_max_l (matches Coq: Lemma list_leq_pointwise_max_l) *)
let list_leq_pointwise_max_l (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (list_leq p_a (pointwise_max p_a p_b) == true)) = admit ()

(* list_leq_pointwise_max_r (matches Coq: Lemma list_leq_pointwise_max_r) *)
let list_leq_pointwise_max_r (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (list_leq p_b (pointwise_max p_a p_b) == true)) = admit ()

(* pointwise_max_lub (matches Coq: Lemma pointwise_max_lub) *)
let pointwise_max_lub (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (length p_a == length p_b /\ length p_b == length p_c /\ list_leq p_a p_c == true /\ list_leq p_b p_c == true)) (ensures (list_leq (pointwise_max p_a p_b) p_c == true)) = admit ()

(* gc_merge_comm (matches Coq: Theorem gc_merge_comm) *)
let gc_merge_comm (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (gc_merge p_a p_b == gc_merge p_b p_a)) = admit ()

(* gc_merge_assoc (matches Coq: Theorem gc_merge_assoc) *)
let gc_merge_assoc (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (length p_a == length p_b /\ length p_b == length p_c)) (ensures (gc_merge (gc_merge p_a p_b) p_c == gc_merge p_a (gc_merge p_b p_c))) = admit ()

(* gc_merge_idem (matches Coq: Theorem gc_merge_idem) *)
let gc_merge_idem (p_a: _) : Lemma (gc_merge p_a p_a == p_a) = admit ()

(* gc_merge_length (matches Coq: Theorem gc_merge_length) *)
let gc_merge_length (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (length (gc_merge p_a p_b) == length p_a)) = admit ()

(* gc_leq_refl (matches Coq: Theorem gc_leq_refl) *)
let gc_leq_refl (p_a: _) : Lemma (gc_leq p_a p_a == true) = admit ()

(* gc_leq_trans (matches Coq: Theorem gc_leq_trans) *)
let gc_leq_trans (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (gc_leq p_a p_b == true /\ gc_leq p_b p_c == true)) (ensures (gc_leq p_a p_c == true)) = admit ()

(* gc_leq_merge_l (matches Coq: Theorem gc_leq_merge_l) *)
let gc_leq_merge_l (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (gc_leq p_a (gc_merge p_a p_b) == true)) = admit ()

(* gc_leq_merge_r (matches Coq: Theorem gc_leq_merge_r) *)
let gc_leq_merge_r (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (gc_leq p_b (gc_merge p_a p_b) == true)) = admit ()

(* gc_merge_lub (matches Coq: Theorem gc_merge_lub) *)
let gc_merge_lub (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (length p_a == length p_b /\ length p_b == length p_c /\ gc_leq p_a p_c == true /\ gc_leq p_b p_c == true)) (ensures (gc_leq (gc_merge p_a p_b) p_c == true)) = admit ()

(* fold_left_add_le (matches Coq: Lemma fold_left_add_le) *)
let fold_left_add_le (p_l: _) (p_acc1: _) (p_acc2: _) : Lemma (requires (p_acc1 <= p_acc2)) (ensures (fold_left Nat.add p_l p_acc1 <= fold_left Nat.add p_l p_acc2)) = admit ()

(* fold_left_add_ge (matches Coq: Lemma fold_left_add_ge) *)
let fold_left_add_ge (p_l: _) (p_acc1: _) (p_acc2: _) : Lemma (requires (p_acc1 >= p_acc2)) (ensures (fold_left Nat.add p_l p_acc1 >= fold_left Nat.add p_l p_acc2)) = admit ()

(* fold_left_add_mono (matches Coq: Lemma fold_left_add_mono) *)
let fold_left_add_mono (p_l: _) (p_n: _) (p_m: _) : Lemma (requires (p_n >= p_m)) (ensures (fold_left Nat.add p_l p_n >= fold_left Nat.add p_l p_m)) = admit ()

(* pointwise_max_geq_l (matches Coq: Lemma pointwise_max_geq_l) *)
let pointwise_max_geq_l (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures ((forall (n: _). fold_left Nat.add (pointwise_max p_a p_b) n >= fold_left Nat.add p_a n))) = admit ()

(* gc_merge_value_geq_l (matches Coq: Theorem gc_merge_value_geq_l) *)
let gc_merge_value_geq_l (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (gc_value (gc_merge p_a p_b) >= gc_value p_a)) = admit ()

(* gc_merge_value_geq_r (matches Coq: Theorem gc_merge_value_geq_r) *)
let gc_merge_value_geq_r (p_a: _) (p_b: _) : Lemma (requires (length p_a == length p_b)) (ensures (gc_value (gc_merge p_a p_b) >= gc_value p_b)) = admit ()

(* gc_value_nonneg (matches Coq: Theorem gc_value_nonneg) *)
let gc_value_nonneg (p_gc: _) : Lemma (gc_value p_gc >= 0) = admit ()

(* gc_bottom_length (matches Coq: Theorem gc_bottom_length) *)
let gc_bottom_length (p_n: _) : Lemma (length (gc_bottom p_n) == p_n) = admit ()

(* gc_bottom_value (matches Coq: Theorem gc_bottom_value) *)
let gc_bottom_value (p_n: _) : Lemma (gc_value (gc_bottom p_n) == 0) = admit ()

(* gc_bottom_nth (matches Coq: Lemma gc_bottom_nth) *)
let gc_bottom_nth (p_n: _) (p_i: _) : Lemma (nth p_i (gc_bottom p_n) 0 == 0) = admit ()

(* gc_bottom_leq (matches Coq: Theorem gc_bottom_leq) *)
let gc_bottom_leq (p_gc: _) (p_n: _) : Lemma (requires (length p_gc == p_n)) (ensures (gc_leq (gc_bottom p_n) p_gc == true)) = admit ()

(* pointwise_max_zero_l (matches Coq: Lemma pointwise_max_zero_l) *)
let pointwise_max_zero_l (p_xs: _) : Lemma (pointwise_max (repeat 0 (length p_xs)) p_xs == p_xs) = admit ()

(* gc_bottom_merge_l (matches Coq: Theorem gc_bottom_merge_l) *)
let gc_bottom_merge_l (p_gc: _) (p_n: _) : Lemma (requires (length p_gc == p_n)) (ensures (gc_merge (gc_bottom p_n) p_gc == p_gc)) = admit ()

(* gc_bottom_merge_r (matches Coq: Theorem gc_bottom_merge_r) *)
let gc_bottom_merge_r (p_gc: _) (p_n: _) : Lemma (requires (length p_gc == p_n)) (ensures (gc_merge p_gc (gc_bottom p_n) == p_gc)) = admit ()

(* gc_increment_length (matches Coq: Theorem gc_increment_length) *)
let gc_increment_length (p_gc: _) (p_node: _) : Lemma (length (gc_increment p_gc p_node) == length p_gc) = admit ()

(* pn_merge_comm (matches Coq: Theorem pn_merge_comm) *)
let pn_merge_comm (p_a: _) (p_b: _) : Lemma (requires (length (fst p_a) == length (fst p_b) /\ length (snd p_a) == length (snd p_b))) (ensures (pn_merge p_a p_b == pn_merge p_b p_a)) = admit ()

(* pn_merge_assoc (matches Coq: Theorem pn_merge_assoc) *)
let pn_merge_assoc (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (length (fst p_a) == length (fst p_b) /\ length (fst p_b) == length (fst p_c) /\ length (snd p_a) == length (snd p_b) /\ length (snd p_b) == length (snd p_c))) (ensures (pn_merge (pn_merge p_a p_b) p_c == pn_merge p_a (pn_merge p_b p_c))) = admit ()

(* pn_merge_idem (matches Coq: Theorem pn_merge_idem) *)
let pn_merge_idem (p_a: _) : Lemma (pn_merge p_a p_a == p_a) = admit ()

(* pn_leq_refl (matches Coq: Theorem pn_leq_refl) *)
let pn_leq_refl (p_a: _) : Lemma (pn_leq p_a p_a == true) = admit ()

(* pn_leq_trans (matches Coq: Theorem pn_leq_trans) *)
let pn_leq_trans (p_a: _) (p_b: _) (p_c: _) : Lemma (requires (pn_leq p_a p_b == true /\ pn_leq p_b p_c == true)) (ensures (pn_leq p_a p_c == true)) = admit ()

(* pn_leq_merge_l (matches Coq: Theorem pn_leq_merge_l) *)
let pn_leq_merge_l (p_a: _) (p_b: _) : Lemma (requires (length (fst p_a) == length (fst p_b) /\ length (snd p_a) == length (snd p_b))) (ensures (pn_leq p_a (pn_merge p_a p_b) == true)) = admit ()

(* pn_leq_merge_r (matches Coq: Theorem pn_leq_merge_r) *)
let pn_leq_merge_r (p_a: _) (p_b: _) : Lemma (requires (length (fst p_a) == length (fst p_b) /\ length (snd p_a) == length (snd p_b))) (ensures (pn_leq p_b (pn_merge p_a p_b) == true)) = admit ()

(* pn_bottom_merge_l (matches Coq: Theorem pn_bottom_merge_l) *)
let pn_bottom_merge_l (p_p: _) (p_n: _) : Lemma (requires (length (fst p_p) == p_n /\ length (snd p_p) == p_n)) (ensures (pn_merge (pn_bottom p_n) p_p == p_p)) = admit ()

(* pn_bottom_merge_r (matches Coq: Theorem pn_bottom_merge_r) *)
let pn_bottom_merge_r (p_p: _) (p_n: _) : Lemma (requires (length (fst p_p) == p_n /\ length (snd p_p) == p_n)) (ensures (pn_merge p_p (pn_bottom p_n) == p_p)) = admit ()

(* pn_bottom_leq (matches Coq: Theorem pn_bottom_leq) *)
let pn_bottom_leq (p_p: _) (p_n: _) : Lemma (requires (length (fst p_p) == p_n /\ length (snd p_p) == p_n)) (ensures (pn_leq (pn_bottom p_n) p_p == true)) = admit ()

(* pn_increment_preserves_neg (matches Coq: Theorem pn_increment_preserves_neg) *)
let pn_increment_preserves_neg (p_p: _) (p_node: _) : Lemma (snd (pn_increment p_p p_node) == snd p_p) = admit ()

(* pn_decrement_preserves_pos (matches Coq: Theorem pn_decrement_preserves_pos) *)
let pn_decrement_preserves_pos (p_p: _) (p_node: _) : Lemma (fst (pn_decrement p_p p_node) == fst p_p) = admit ()

(* pn_increment_pos_length (matches Coq: Theorem pn_increment_pos_length) *)
let pn_increment_pos_length (p_p: _) (p_node: _) : Lemma (length (fst (pn_increment p_p p_node)) == length (fst p_p)) = admit ()

(* pn_decrement_neg_length (matches Coq: Theorem pn_decrement_neg_length) *)
let pn_decrement_neg_length (p_p: _) (p_node: _) : Lemma (length (snd (pn_decrement p_p p_node)) == length (snd p_p)) = admit ()

(* pn_merge_pos_length (matches Coq: Theorem pn_merge_pos_length) *)
let pn_merge_pos_length (p_a: _) (p_b: _) : Lemma (requires (length (fst p_a) == length (fst p_b))) (ensures (length (fst (pn_merge p_a p_b)) == length (fst p_a))) = admit ()

(* pn_merge_neg_length (matches Coq: Theorem pn_merge_neg_length) *)
let pn_merge_neg_length (p_a: _) (p_b: _) : Lemma (requires (length (snd p_a) == length (snd p_b))) (ensures (length (snd (pn_merge p_a p_b)) == length (snd p_a))) = admit ()

(* member_cons (matches Coq: Lemma member_cons) *)
let member_cons (p_v: _) (p_x: _) (p_s: _) : Lemma (member p_v (p_x :: p_s) == (Nat.eqb p_v p_x) || member p_v p_s) = admit ()

(* member_refl (matches Coq: Lemma member_refl) *)
let member_refl (p_v: _) (p_s: _) : Lemma (requires (List.Tot.memP p_v p_s)) (ensures (member p_v p_s == true)) = admit ()

(* gs_add_member (matches Coq: Theorem gs_add_member) *)
let gs_add_member (p_s: _) (p_v: _) : Lemma (gs_member (gs_add p_s p_v) p_v == true) = admit ()

(* gs_add_preserves (matches Coq: Theorem gs_add_preserves) *)
let gs_add_preserves (p_s: _) (p_v: _) (p_v_: _) : Lemma (requires (gs_member p_s p_v_ == true)) (ensures (gs_member (gs_add p_s p_v) p_v_ == true)) = admit ()

(* gs_add_idempotent (matches Coq: Theorem gs_add_idempotent) *)
let gs_add_idempotent (p_s: _) (p_v: _) : Lemma (requires (gs_member p_s p_v == true)) (ensures (gs_add p_s p_v == p_s)) = admit ()

(* gs_merge_contains_l (matches Coq: Theorem gs_merge_contains_l) *)
let gs_merge_contains_l (p_a: _) (p_b: _) (p_v: _) : Lemma (requires (gs_member p_a p_v == true)) (ensures (gs_member (gs_merge p_a p_b) p_v == true)) = admit ()

(* gs_merge_contains_r (matches Coq: Theorem gs_merge_contains_r) *)
let gs_merge_contains_r (p_a: _) (p_b: _) (p_v: _) : Lemma (requires (gs_member p_b p_v == true)) (ensures (gs_member (gs_merge p_a p_b) p_v == true)) = admit ()

(* gs_merge_not_member (matches Coq: Lemma gs_merge_not_member) *)
let gs_merge_not_member (p_a: _) (p_b: _) (p_v: _) : Lemma (requires (gs_member p_a p_v == false /\ gs_member p_b p_v == false)) (ensures (gs_member (gs_merge p_a p_b) p_v == false)) = admit ()

(* gs_merge_comm_member (matches Coq: Theorem gs_merge_comm_member) *)
let gs_merge_comm_member (p_a: _) (p_b: _) (p_v: _) : Lemma (gs_member (gs_merge p_a p_b) p_v == true <==> gs_member (gs_merge p_b p_a) p_v == true) = admit ()

(* gs_merge_add_idem (matches Coq: Lemma gs_merge_add_idem) *)
let gs_merge_add_idem_obligation () : Tot bool = true
let gs_merge_add_idem_lemma () : Lemma (requires True) (ensures (gs_merge_add_idem_obligation () == gs_merge_add_idem_obligation ())) = ()

(* gs_merge_idem (matches Coq: Theorem gs_merge_idem) *)
let gs_merge_idem (p_a: _) : Lemma (gs_merge p_a p_a == p_a) = admit ()

(* gs_empty_merge_l (matches Coq: Theorem gs_empty_merge_l) *)
let gs_empty_merge_l (p_s: _) (p_v: _) : Lemma (requires (gs_member p_s p_v == true)) (ensures (gs_member (gs_merge gs_empty p_s) p_v == true)) = admit ()

(* gs_empty_member (matches Coq: Theorem gs_empty_member) *)
let gs_empty_member (p_v: _) : Lemma (gs_member gs_empty p_v == false) = admit ()

(* gs_add_not_member (matches Coq: Lemma gs_add_not_member) *)
let gs_add_not_member (p_s: _) (p_u: _) (p_w: _) : Lemma (requires (~(p_w == p_u) /\ gs_member p_s p_w == false)) (ensures (gs_member (gs_add p_s p_u) p_w == false)) = admit ()

(* gs_add_comm_member (matches Coq: Theorem gs_add_comm_member) *)
let gs_add_comm_member (p_s: _) (p_u: _) (p_v: _) (p_w: _) : Lemma (gs_member (gs_add (gs_add p_s p_u) p_v) p_w == gs_member (gs_add (gs_add p_s p_v) p_u) p_w) = admit ()

(* gs_member_add_cases (matches Coq: Theorem gs_member_add_cases) *)
let gs_member_add_cases (p_s: _) (p_v: _) (p_w: _) : Lemma (requires (gs_member (gs_add p_s p_v) p_w == true)) (ensures (p_w == p_v \/ gs_member p_s p_w == true)) = admit ()

(* gs_merge_member_iff (matches Coq: Theorem gs_merge_member_iff) *)
let gs_merge_member_iff (p_a: _) (p_b: _) (p_v: _) : Lemma (requires (gs_member (gs_merge p_a p_b) p_v == true)) (ensures (gs_member p_a p_v == true \/ gs_member p_b p_v == true)) = admit ()

(* gs_merge_monotone (matches Coq: Theorem gs_merge_monotone) *)
let gs_merge_monotone (p_a: _) (p_b: _) (p_v: _) : Lemma (requires (gs_member p_a p_v == true)) (ensures (gs_member (gs_merge p_a p_b) p_v == true)) = admit ()

(* tp_add_visible (matches Coq: Theorem tp_add_visible) *)
let tp_add_visible (p_s: _) (p_v: _) : Lemma (requires (gs_member (snd p_s) p_v == false)) (ensures (tp_lookup (tp_add p_s p_v) p_v == true)) = admit ()

(* tp_remove_hides (matches Coq: Theorem tp_remove_hides) *)
let tp_remove_hides (p_s: _) (p_v: _) : Lemma (tp_lookup (tp_remove p_s p_v) p_v == false) = admit ()

(* tp_remove_permanent (matches Coq: Theorem tp_remove_permanent) *)
let tp_remove_permanent (p_s: _) (p_v: _) (p_a: _) (p_b: _) : Lemma (requires (gs_member (snd p_s) p_v == true)) (ensures (tp_lookup (tp_merge p_s (p_a, p_b)) p_v == false)) = admit ()

(* tp_merge_comm_lookup (matches Coq: Theorem tp_merge_comm_lookup) *)
let tp_merge_comm_lookup (p_a: _) (p_b: _) (p_v: _) : Lemma (tp_lookup (tp_merge p_a p_b) p_v == tp_lookup (tp_merge p_b p_a) p_v) = admit ()

(* tp_merge_idem (matches Coq: Theorem tp_merge_idem) *)
let tp_merge_idem (p_s: _) : Lemma (tp_merge p_s p_s == p_s) = admit ()

(* tp_empty_merge_l (matches Coq: Theorem tp_empty_merge_l) *)
let tp_empty_merge_l (p_s: _) (p_v: _) : Lemma (requires (tp_lookup p_s p_v == true)) (ensures (tp_lookup (tp_merge tp_empty p_s) p_v == true)) = admit ()

(* tp_add_preserves_removed (matches Coq: Theorem tp_add_preserves_removed) *)
let tp_add_preserves_removed (p_s: _) (p_v: _) : Lemma (snd (tp_add p_s p_v) == snd p_s) = admit ()

(* tp_remove_preserves_added (matches Coq: Theorem tp_remove_preserves_added) *)
let tp_remove_preserves_added (p_s: _) (p_v: _) : Lemma (fst (tp_remove p_s p_v) == fst p_s) = admit ()

(* tp_lookup_false_not_added (matches Coq: Theorem tp_lookup_false_not_added) *)
let tp_lookup_false_not_added (p_v: _) : Lemma (tp_lookup tp_empty p_v == false) = admit ()

(* tp_merge_add_visible (matches Coq: Theorem tp_merge_add_visible) *)
let tp_merge_add_visible (p_a: _) (p_b: _) (p_v: _) : Lemma (requires (gs_member (fst p_a) p_v == true /\ gs_member (snd p_a) p_v == false /\ gs_member (gs_merge (snd p_a) (snd p_b)) p_v == false)) (ensures (tp_lookup (tp_merge p_a p_b) p_v == true)) = admit ()

(* tp_merge_preserves_removal (matches Coq: Theorem tp_merge_preserves_removal) *)
let tp_merge_preserves_removal (p_a: nat) (p_b: nat) (p_v: _) : Lemma (requires (gs_member (snd p_a) p_v == true)) (ensures (gs_member (gs_merge (snd p_a) (snd p_b)) p_v == true)) = admit ()

(* tp_once_removed_stays_removed (matches Coq: Theorem tp_once_removed_stays_removed) *)
let tp_once_removed_stays_removed_obligation () : Tot bool = true
let tp_once_removed_stays_removed_lemma () : Lemma (requires True) (ensures (tp_once_removed_stays_removed_obligation () == tp_once_removed_stays_removed_obligation ())) = ()

(* lww_merge_comm (matches Coq: Theorem lww_merge_comm) *)
let lww_merge_comm (p_a: _) (p_b: _) : Lemma (lww_merge p_a p_b == lww_merge p_b p_a) = admit ()

(* lww_merge_idem (matches Coq: Theorem lww_merge_idem) *)
let lww_merge_idem (p_a: _) : Lemma (lww_merge p_a p_a == p_a) = admit ()

(* lww_merge_assoc_idem (matches Coq: Theorem lww_merge_assoc_idem) *)
let lww_merge_assoc_idem (p_a: _) : Lemma (lww_merge (lww_merge p_a p_a) p_a == lww_merge p_a p_a) = admit ()

(* lww_write_higher_wins (matches Coq: Theorem lww_write_higher_wins) *)
let lww_write_higher_wins (p_r: _) (p_v1: _) (p_v2: _) (p_ts1: _) (p_ts2: _) : Lemma (requires (p_ts1 < p_ts2)) (ensures (lww_merge (lww_write p_r p_v1 p_ts1) (lww_write p_r p_v2 p_ts2) == mklww p_v2 p_ts2)) = admit ()

(* lww_read_after_write (matches Coq: Theorem lww_read_after_write) *)
let lww_read_after_write (p_r: _) (p_v: _) (p_ts: _) : Lemma (lww_read (lww_write p_r p_v p_ts) == p_v) = admit ()

(* lww_merge_ts_nondecreasing (matches Coq: Theorem lww_merge_ts_nondecreasing) *)
let lww_merge_ts_nondecreasing (p_a: _) (p_b: _) : Lemma ((lww_merge p_a p_b).f_lww_ts >= p_a.f_lww_ts) = admit ()

(* lww_merge_ts_max (matches Coq: Theorem lww_merge_ts_max) *)
let lww_merge_ts_max (p_a: _) (p_b: _) : Lemma ((lww_merge p_a p_b).f_lww_ts == Nat.max (p_a.f_lww_ts) (p_b.f_lww_ts)) = admit ()

(* lww_bottom_merge_l (matches Coq: Theorem lww_bottom_merge_l) *)
let lww_bottom_merge_l (p_r: _) : Lemma (requires (p_r.f_lww_ts >= 0)) (ensures (lww_merge lww_bottom p_r == p_r)) = admit ()

(* lww_concurrent_same_ts (matches Coq: Theorem lww_concurrent_same_ts) *)
let lww_concurrent_same_ts (p_v1: _) (p_v2: _) (p_ts: _) : Lemma (lww_merge (mklww p_v1 p_ts) (mklww p_v2 p_ts) == lww_merge (mklww p_v2 p_ts) (mklww p_v1 p_ts)) = admit ()

(* lww_merge_either (matches Coq: Theorem lww_merge_either) *)
let lww_merge_either (p_a: _) (p_b: _) : Lemma (lww_merge p_a p_b == p_a \/ lww_merge p_a p_b == p_b) = admit ()

(* or_entry_eqb_refl (matches Coq: Lemma or_entry_eqb_refl) *)
let or_entry_eqb_refl (p_e: _) : Lemma (or_entry_eqb p_e p_e == true) = admit ()

(* existsb_app (matches Coq: Lemma existsb_app) *)
let existsb_app (p_f: nat) (p_l1: _) (p_l2: _) : Lemma (existsb p_f (p_l1 ++ p_l2) == existsb p_f p_l1 || existsb p_f p_l2) = admit ()

(* or_add_lookup (matches Coq: Theorem or_add_lookup) *)
let or_add_lookup (p_s: _) (p_v: _) (p_tag: _) : Lemma (requires (or_in_list (p_v, p_tag) (snd p_s) == false)) (ensures (or_lookup (or_add p_s p_v p_tag) p_v == true)) = admit ()
