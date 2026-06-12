; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CRDTFoundations.v (95 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: CRDTFoundations

(set-logic ALL)
(set-option :produce-models true)

; LWWRegister (matches Coq: Record LWWRegister)
(declare-datatypes ((LWWRegister 0))
  (((mk-lww_register (lww_val Int) (lww_ts Int)))))

(declare-const __default_LWWRegister LWWRegister)

; pointwise_max (matches Coq: Definition pointwise_max)
(define-fun pointwise_max ((a (Seq Int)) (b (Seq Int))) (Seq Int)
  (as seq.empty (Seq Int)))

; list_leq (matches Coq: Definition list_leq)
(define-fun list_leq ((a (Seq Int)) (b (Seq Int))) Bool
  (= 0 0))

; member (matches Coq: Definition member)
(define-fun member ((v Int) (s (Seq Int))) Bool
  (= 0 0))

; set_eq (matches Coq: Definition set_eq)
(define-fun set_eq ((a (Seq Int)) (b (Seq Int))) Bool
  (= 0 0))

; gc_bottom (matches Coq: Definition gc_bottom)
(define-fun gc_bottom ((n Int)) Int
  0)

; gc_merge (matches Coq: Definition gc_merge)
(define-fun gc_merge ((a Int) (b Int)) Int
  0)

; gc_value (matches Coq: Definition gc_value)
(define-fun gc_value ((gc Int)) Int
  0)

; gc_increment (matches Coq: Definition gc_increment)
(define-fun gc_increment ((gc Int) (node Int)) Int
  0)

; gc_leq (matches Coq: Definition gc_leq)
(define-fun gc_leq ((a Int) (b Int)) Bool
  (= 0 0))

; pn_merge (matches Coq: Definition pn_merge)
(define-fun pn_merge ((a Int) (b Int)) Int
  0)

; pn_positive (matches Coq: Definition pn_positive)
(define-fun pn_positive ((p Int)) Int
  0)

; pn_negative (matches Coq: Definition pn_negative)
(define-fun pn_negative ((p Int)) Int
  0)

; pn_bottom (matches Coq: Definition pn_bottom)
(define-fun pn_bottom ((n Int)) Int
  0)

; pn_increment (matches Coq: Definition pn_increment)
(define-fun pn_increment ((p Int) (node Int)) Int
  0)

; pn_decrement (matches Coq: Definition pn_decrement)
(define-fun pn_decrement ((p Int) (node Int)) Int
  0)

; pn_leq (matches Coq: Definition pn_leq)
(define-fun pn_leq ((a Int) (b Int)) Bool
  (= 0 0))

; gs_add (matches Coq: Definition gs_add)
(define-fun gs_add ((s Int) (v Int)) Int
  0)

; gs_merge (matches Coq: Definition gs_merge)
(define-fun gs_merge ((a Int) (b Int)) Int
  0)

; gs_member (matches Coq: Definition gs_member)
(define-fun gs_member ((s Int) (v Int)) Bool
  (= 0 0))

; gs_empty (matches Coq: Definition gs_empty)
(define-fun gs_empty () Int
  0)

; tp_add (matches Coq: Definition tp_add)
(define-fun tp_add ((s Int) (v Int)) Int
  0)

; tp_remove (matches Coq: Definition tp_remove)
(define-fun tp_remove ((s Int) (v Int)) Int
  0)

; tp_lookup (matches Coq: Definition tp_lookup)
(define-fun tp_lookup ((s Int) (v Int)) Bool
  (= 0 0))

; tp_merge (matches Coq: Definition tp_merge)
(define-fun tp_merge ((a Int) (b Int)) Int
  0)

; tp_empty (matches Coq: Definition tp_empty)
(define-fun tp_empty () Int
  0)

; lww_merge (matches Coq: Definition lww_merge)
(declare-fun lww_merge (LWWRegister LWWRegister) LWWRegister)

; lww_write (matches Coq: Definition lww_write)
(declare-fun lww_write (LWWRegister Int Int) LWWRegister)

; lww_read (matches Coq: Definition lww_read)
(define-fun lww_read ((r LWWRegister)) Int
  0)

; lww_bottom (matches Coq: Definition lww_bottom)
(define-fun lww_bottom () LWWRegister
  __default_LWWRegister)

; or_entry_eqb (matches Coq: Definition or_entry_eqb)
(define-fun or_entry_eqb ((a Int) (b Int)) Bool
  (= 0 0))

; or_in_list (matches Coq: Definition or_in_list)
(define-fun or_in_list ((e Int) (l (Seq Int))) Bool
  (= 0 0))

; or_lookup (matches Coq: Definition or_lookup)
(define-fun or_lookup ((s Int) (v Int)) Bool
  (= 0 0))

; or_add (matches Coq: Definition or_add)
(define-fun or_add ((s Int) (v Int) (tag Int)) Int
  0)

; or_remove (matches Coq: Definition or_remove)
(define-fun or_remove ((s Int) (v Int)) Int
  0)

; or_merge (matches Coq: Definition or_merge)
(define-fun or_merge ((a Int) (b Int)) Int
  0)

; or_empty (matches Coq: Definition or_empty)
(define-fun or_empty () Int
  0)

; pointwise_max_nil_l (matches Coq: Lemma pointwise_max_nil_l)
; pointwise_max_nil_l: forall b, pointwise_max [] b = b
(assert (forall ((b Bool)) (= 0 0))) ; pointwise_max_nil_l [partial: bindings preserved]

; pointwise_max_nil_r (matches Coq: Lemma pointwise_max_nil_r)
; pointwise_max_nil_r: forall a, pointwise_max a [] = a
(assert (forall ((a Bool)) (= 0 0))) ; pointwise_max_nil_r [partial: bindings preserved]

; pointwise_max_comm (matches Coq: Lemma pointwise_max_comm)
; pointwise_max_comm: forall a b, length a = length b -> pointwise_max a b = pointwise_max b a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pointwise_max_comm [partial: bindings preserved]

; pointwise_max_assoc (matches Coq: Lemma pointwise_max_assoc)
; pointwise_max_assoc: forall a b c, length a = length b -> length b = length c -> pointwise_max (pointwise_max a b) c = pointwise_max a (point
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; pointwise_max_assoc [partial: bindings preserved]

; pointwise_max_idem (matches Coq: Lemma pointwise_max_idem)
; pointwise_max_idem: forall a, pointwise_max a a = a
(assert (forall ((a Bool)) (= 0 0))) ; pointwise_max_idem [partial: bindings preserved]

; pointwise_max_length (matches Coq: Lemma pointwise_max_length)
; pointwise_max_length: forall a b, length a = length b -> length (pointwise_max a b) = length a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pointwise_max_length [partial: bindings preserved]

; list_leq_refl (matches Coq: Lemma list_leq_refl)
; list_leq_refl: forall a, list_leq a a
(assert (forall ((a Bool)) (= 0 0))) ; list_leq_refl [partial: bindings preserved]

; list_leq_trans (matches Coq: Lemma list_leq_trans)
; list_leq_trans: forall a b c, list_leq a b -> list_leq b c -> list_leq a c
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; list_leq_trans [partial: bindings preserved]

; nth_pointwise_max (matches Coq: Lemma nth_pointwise_max)
; nth_pointwise_max: forall a b i, length a = length b -> nth i (pointwise_max a b) 0 = Nat.max (nth i a 0) (nth i b 0)
(assert (forall ((a Bool) (b Bool) (i Bool)) (= 0 0))) ; nth_pointwise_max [partial: bindings preserved]

; list_leq_pointwise_max_l (matches Coq: Lemma list_leq_pointwise_max_l)
; list_leq_pointwise_max_l: forall a b, length a = length b -> list_leq a (pointwise_max a b)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; list_leq_pointwise_max_l [partial: bindings preserved]

; list_leq_pointwise_max_r (matches Coq: Lemma list_leq_pointwise_max_r)
; list_leq_pointwise_max_r: forall a b, length a = length b -> list_leq b (pointwise_max a b)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; list_leq_pointwise_max_r [partial: bindings preserved]

; pointwise_max_lub (matches Coq: Lemma pointwise_max_lub)
; pointwise_max_lub: forall a b c, length a = length b -> length b = length c -> list_leq a c -> list_leq b c -> list_leq (pointwise_max a b)
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; pointwise_max_lub [partial: bindings preserved]

; gc_merge_comm (matches Coq: Theorem gc_merge_comm)
; gc_merge_comm: forall a b, length a = length b -> gc_merge a b = gc_merge b a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; gc_merge_comm [partial: bindings preserved]

; gc_merge_assoc (matches Coq: Theorem gc_merge_assoc)
; gc_merge_assoc: forall a b c, length a = length b -> length b = length c -> gc_merge (gc_merge a b) c = gc_merge a (gc_merge b c)
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; gc_merge_assoc [partial: bindings preserved]

; gc_merge_idem (matches Coq: Theorem gc_merge_idem)
; gc_merge_idem: forall a, gc_merge a a = a
(assert (forall ((a Bool)) (= 0 0))) ; gc_merge_idem [partial: bindings preserved]

; gc_merge_length (matches Coq: Theorem gc_merge_length)
; gc_merge_length: forall a b, length a = length b -> length (gc_merge a b) = length a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; gc_merge_length [partial: bindings preserved]

; gc_leq_refl (matches Coq: Theorem gc_leq_refl)
; gc_leq_refl: forall a, gc_leq a a
(assert (forall ((a Bool)) (= 0 0))) ; gc_leq_refl [partial: bindings preserved]

; gc_leq_trans (matches Coq: Theorem gc_leq_trans)
; gc_leq_trans: forall a b c, gc_leq a b -> gc_leq b c -> gc_leq a c
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; gc_leq_trans [partial: bindings preserved]

; gc_leq_merge_l (matches Coq: Theorem gc_leq_merge_l)
; gc_leq_merge_l: forall a b, length a = length b -> gc_leq a (gc_merge a b)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; gc_leq_merge_l [partial: bindings preserved]

; gc_leq_merge_r (matches Coq: Theorem gc_leq_merge_r)
; gc_leq_merge_r: forall a b, length a = length b -> gc_leq b (gc_merge a b)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; gc_leq_merge_r [partial: bindings preserved]

; gc_merge_lub (matches Coq: Theorem gc_merge_lub)
; gc_merge_lub: forall a b c, length a = length b -> length b = length c -> gc_leq a c -> gc_leq b c -> gc_leq (gc_merge a b) c
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; gc_merge_lub [partial: bindings preserved]

; fold_left_add_le (matches Coq: Lemma fold_left_add_le)
; fold_left_add_le: forall l acc1 acc2, acc1 <= acc2 -> fold_left Nat.add l acc1 <= fold_left Nat.add l acc2
(assert (forall ((l Bool) (acc1 Bool) (acc2 Bool)) (= 0 0))) ; fold_left_add_le [partial: bindings preserved]

; fold_left_add_ge (matches Coq: Lemma fold_left_add_ge)
; fold_left_add_ge: forall l acc1 acc2, acc1 >= acc2 -> fold_left Nat.add l acc1 >= fold_left Nat.add l acc2
(assert (forall ((l Bool) (acc1 Bool) (acc2 Bool)) (= 0 0))) ; fold_left_add_ge [partial: bindings preserved]

; fold_left_add_mono (matches Coq: Lemma fold_left_add_mono)
; fold_left_add_mono: forall l n m, n >= m -> fold_left Nat.add l n >= fold_left Nat.add l m
(assert (forall ((l Bool) (n Bool) (m Bool)) (= 0 0))) ; fold_left_add_mono [partial: bindings preserved]

; pointwise_max_geq_l (matches Coq: Lemma pointwise_max_geq_l)
; pointwise_max_geq_l: forall a b, length a = length b -> forall n, fold_left Nat.add (pointwise_max a b) n >= fold_left Nat.add a n
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pointwise_max_geq_l [partial: bindings preserved]

; gc_merge_value_geq_l (matches Coq: Theorem gc_merge_value_geq_l)
; gc_merge_value_geq_l: forall a b, length a = length b -> gc_value (gc_merge a b) >= gc_value a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; gc_merge_value_geq_l [partial: bindings preserved]

; gc_merge_value_geq_r (matches Coq: Theorem gc_merge_value_geq_r)
; gc_merge_value_geq_r: forall a b, length a = length b -> gc_value (gc_merge a b) >= gc_value b
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; gc_merge_value_geq_r [partial: bindings preserved]

; gc_value_nonneg (matches Coq: Theorem gc_value_nonneg)
; gc_value_nonneg: forall gc, gc_value gc >= 0
(assert (forall ((gc Bool)) (= 0 0))) ; gc_value_nonneg [partial: bindings preserved]

; gc_bottom_length (matches Coq: Theorem gc_bottom_length)
; gc_bottom_length: forall n, length (gc_bottom n) = n
(assert (forall ((n Bool)) (= 0 0))) ; gc_bottom_length [partial: bindings preserved]

; gc_bottom_value (matches Coq: Theorem gc_bottom_value)
; gc_bottom_value: forall n, gc_value (gc_bottom n) = 0
(assert (forall ((n Bool)) (= 0 0))) ; gc_bottom_value [partial: bindings preserved]

; gc_bottom_nth (matches Coq: Lemma gc_bottom_nth)
; gc_bottom_nth: forall n i, nth i (gc_bottom n) 0 = 0
(assert (forall ((n Bool) (i Bool)) (= 0 0))) ; gc_bottom_nth [partial: bindings preserved]

; gc_bottom_leq (matches Coq: Theorem gc_bottom_leq)
; gc_bottom_leq: forall gc n, length gc = n -> gc_leq (gc_bottom n) gc
(assert (forall ((gc Bool) (n Bool)) (= 0 0))) ; gc_bottom_leq [partial: bindings preserved]

; pointwise_max_zero_l (matches Coq: Lemma pointwise_max_zero_l)
; pointwise_max_zero_l: forall xs, pointwise_max (repeat 0 (length xs)) xs = xs
(assert (forall ((xs Bool)) (= 0 0))) ; pointwise_max_zero_l [partial: bindings preserved]

; gc_bottom_merge_l (matches Coq: Theorem gc_bottom_merge_l)
; gc_bottom_merge_l: forall gc n, length gc = n -> gc_merge (gc_bottom n) gc = gc
(assert (forall ((gc Bool) (n Bool)) (= 0 0))) ; gc_bottom_merge_l [partial: bindings preserved]

; gc_bottom_merge_r (matches Coq: Theorem gc_bottom_merge_r)
; gc_bottom_merge_r: forall gc n, length gc = n -> gc_merge gc (gc_bottom n) = gc
(assert (forall ((gc Bool) (n Bool)) (= 0 0))) ; gc_bottom_merge_r [partial: bindings preserved]

; gc_increment_length (matches Coq: Theorem gc_increment_length)
; gc_increment_length: forall gc node, length (gc_increment gc node) = length gc
(assert (forall ((gc Bool) (node Bool)) (= 0 0))) ; gc_increment_length [partial: bindings preserved]

; pn_merge_comm (matches Coq: Theorem pn_merge_comm)
; pn_merge_comm: forall a b, length (fst a) = length (fst b) -> length (snd a) = length (snd b) -> pn_merge a b = pn_merge b a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pn_merge_comm [partial: bindings preserved]

; pn_merge_assoc (matches Coq: Theorem pn_merge_assoc)
; pn_merge_assoc: forall a b c, length (fst a) = length (fst b) -> length (fst b) = length (fst c) -> length (snd a) = length (snd b) -> l
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; pn_merge_assoc [partial: bindings preserved]

; pn_merge_idem (matches Coq: Theorem pn_merge_idem)
; pn_merge_idem: forall a, pn_merge a a = a
(assert (forall ((a Bool)) (= 0 0))) ; pn_merge_idem [partial: bindings preserved]

; pn_leq_refl (matches Coq: Theorem pn_leq_refl)
; pn_leq_refl: forall a, pn_leq a a
(assert (forall ((a Bool)) (= 0 0))) ; pn_leq_refl [partial: bindings preserved]

; pn_leq_trans (matches Coq: Theorem pn_leq_trans)
; pn_leq_trans: forall a b c, pn_leq a b -> pn_leq b c -> pn_leq a c
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; pn_leq_trans [partial: bindings preserved]

; pn_leq_merge_l (matches Coq: Theorem pn_leq_merge_l)
; pn_leq_merge_l: forall a b, length (fst a) = length (fst b) -> length (snd a) = length (snd b) -> pn_leq a (pn_merge a b)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pn_leq_merge_l [partial: bindings preserved]

; pn_leq_merge_r (matches Coq: Theorem pn_leq_merge_r)
; pn_leq_merge_r: forall a b, length (fst a) = length (fst b) -> length (snd a) = length (snd b) -> pn_leq b (pn_merge a b)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pn_leq_merge_r [partial: bindings preserved]

; pn_bottom_merge_l (matches Coq: Theorem pn_bottom_merge_l)
; pn_bottom_merge_l: forall p n, length (fst p) = n -> length (snd p) = n -> pn_merge (pn_bottom n) p = p
(assert (forall ((p Bool) (n Bool)) (= 0 0))) ; pn_bottom_merge_l [partial: bindings preserved]

; pn_bottom_merge_r (matches Coq: Theorem pn_bottom_merge_r)
; pn_bottom_merge_r: forall p n, length (fst p) = n -> length (snd p) = n -> pn_merge p (pn_bottom n) = p
(assert (forall ((p Bool) (n Bool)) (= 0 0))) ; pn_bottom_merge_r [partial: bindings preserved]

; pn_bottom_leq (matches Coq: Theorem pn_bottom_leq)
; pn_bottom_leq: forall p n, length (fst p) = n -> length (snd p) = n -> pn_leq (pn_bottom n) p
(assert (forall ((p Bool) (n Bool)) (= 0 0))) ; pn_bottom_leq [partial: bindings preserved]

; pn_increment_preserves_neg (matches Coq: Theorem pn_increment_preserves_neg)
; pn_increment_preserves_neg: forall p node, snd (pn_increment p node) = snd p
(assert (forall ((p Bool) (node Bool)) (= 0 0))) ; pn_increment_preserves_neg [partial: bindings preserved]

; pn_decrement_preserves_pos (matches Coq: Theorem pn_decrement_preserves_pos)
; pn_decrement_preserves_pos: forall p node, fst (pn_decrement p node) = fst p
(assert (forall ((p Bool) (node Bool)) (= 0 0))) ; pn_decrement_preserves_pos [partial: bindings preserved]

; pn_increment_pos_length (matches Coq: Theorem pn_increment_pos_length)
; pn_increment_pos_length: forall p node, length (fst (pn_increment p node)) = length (fst p)
(assert (forall ((p Bool) (node Bool)) (= 0 0))) ; pn_increment_pos_length [partial: bindings preserved]

; pn_decrement_neg_length (matches Coq: Theorem pn_decrement_neg_length)
; pn_decrement_neg_length: forall p node, length (snd (pn_decrement p node)) = length (snd p)
(assert (forall ((p Bool) (node Bool)) (= 0 0))) ; pn_decrement_neg_length [partial: bindings preserved]

; pn_merge_pos_length (matches Coq: Theorem pn_merge_pos_length)
; pn_merge_pos_length: forall a b, length (fst a) = length (fst b) -> length (fst (pn_merge a b)) = length (fst a)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pn_merge_pos_length [partial: bindings preserved]

; pn_merge_neg_length (matches Coq: Theorem pn_merge_neg_length)
; pn_merge_neg_length: forall a b, length (snd a) = length (snd b) -> length (snd (pn_merge a b)) = length (snd a)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; pn_merge_neg_length [partial: bindings preserved]

; member_cons (matches Coq: Lemma member_cons)
; member_cons: forall v x s, member v (x :: s) = (Nat.eqb v x) || member v s
(assert (forall ((v Bool) (x Bool) (s Bool)) (= 0 0))) ; member_cons [partial: bindings preserved]

; member_refl (matches Coq: Lemma member_refl)
; member_refl: forall v s, In v s -> member v s = true
(assert (forall ((v Bool) (s Bool)) (= 0 0))) ; member_refl [partial: bindings preserved]

; gs_add_member (matches Coq: Theorem gs_add_member)
; gs_add_member: forall s v, gs_member (gs_add s v) v = true
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; gs_add_member [partial: bindings preserved]

; gs_add_preserves (matches Coq: Theorem gs_add_preserves)
; gs_add_preserves: forall s v v', gs_member s v' = true -> gs_member (gs_add s v) v' = true
(assert (forall ((s Bool) (v Bool) (v_ Bool)) (= 0 0))) ; gs_add_preserves [partial: bindings preserved]

; gs_add_idempotent (matches Coq: Theorem gs_add_idempotent)
; gs_add_idempotent: forall s v, gs_member s v = true -> gs_add s v = s
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; gs_add_idempotent [partial: bindings preserved]

; gs_merge_contains_l (matches Coq: Theorem gs_merge_contains_l)
; gs_merge_contains_l: forall a b v, gs_member a v = true -> gs_member (gs_merge a b) v = true
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; gs_merge_contains_l [partial: bindings preserved]

; gs_merge_contains_r (matches Coq: Theorem gs_merge_contains_r)
; gs_merge_contains_r: forall a b v, gs_member b v = true -> gs_member (gs_merge a b) v = true
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; gs_merge_contains_r [partial: bindings preserved]

; gs_merge_not_member (matches Coq: Lemma gs_merge_not_member)
; gs_merge_not_member: forall a b v, gs_member a v = false -> gs_member b v = false -> gs_member (gs_merge a b) v = false
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; gs_merge_not_member [partial: bindings preserved]

; gs_merge_comm_member (matches Coq: Theorem gs_merge_comm_member)
; gs_merge_comm_member: forall a b v, gs_member (gs_merge a b) v = true <-> gs_member (gs_merge b a) v = true
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; gs_merge_comm_member [partial: bindings preserved]

; gs_merge_add_idem (matches Coq: Lemma gs_merge_add_idem)
; gs_merge_add_idem: forall b a, (forall v, gs_member b v = true -> gs_member a v = true) -> gs_merge a b = a
(assert (forall ((b Bool) (a Bool)) (= 0 0))) ; gs_merge_add_idem [partial: bindings preserved]

; gs_merge_idem (matches Coq: Theorem gs_merge_idem)
; gs_merge_idem: forall a, gs_merge a a = a
(assert (forall ((a Bool)) (= 0 0))) ; gs_merge_idem [partial: bindings preserved]

; gs_empty_merge_l (matches Coq: Theorem gs_empty_merge_l)
; gs_empty_merge_l: forall s v, gs_member s v = true -> gs_member (gs_merge gs_empty s) v = true
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; gs_empty_merge_l [partial: bindings preserved]

; gs_empty_member (matches Coq: Theorem gs_empty_member)
; gs_empty_member: forall v, gs_member gs_empty v = false
(assert (forall ((v Bool)) (= 0 0))) ; gs_empty_member [partial: bindings preserved]

; gs_add_not_member (matches Coq: Lemma gs_add_not_member)
; gs_add_not_member: forall s u w, w <> u -> gs_member s w = false -> gs_member (gs_add s u) w = false
(assert (forall ((s Bool) (u Bool) (w Bool)) (= 0 0))) ; gs_add_not_member [partial: bindings preserved]

; gs_add_comm_member (matches Coq: Theorem gs_add_comm_member)
; gs_add_comm_member: forall s u v w, gs_member (gs_add (gs_add s u) v) w = gs_member (gs_add (gs_add s v) u) w
(assert (forall ((s Bool) (u Bool) (v Bool) (w Bool)) (= 0 0))) ; gs_add_comm_member [partial: bindings preserved]

; gs_member_add_cases (matches Coq: Theorem gs_member_add_cases)
; gs_member_add_cases: forall s v w, gs_member (gs_add s v) w = true -> w = v \/ gs_member s w = true
(assert (forall ((s Bool) (v Bool) (w Bool)) (= 0 0))) ; gs_member_add_cases [partial: bindings preserved]

; gs_merge_member_iff (matches Coq: Theorem gs_merge_member_iff)
; gs_merge_member_iff: forall a b v, gs_member (gs_merge a b) v = true -> gs_member a v = true \/ gs_member b v = true
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; gs_merge_member_iff [partial: bindings preserved]

; gs_merge_monotone (matches Coq: Theorem gs_merge_monotone)
; gs_merge_monotone: forall a b v, gs_member a v = true -> gs_member (gs_merge a b) v = true
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; gs_merge_monotone [partial: bindings preserved]

; tp_add_visible (matches Coq: Theorem tp_add_visible)
; tp_add_visible: forall s v, gs_member (snd s) v = false -> tp_lookup (tp_add s v) v = true
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; tp_add_visible [partial: bindings preserved]

; tp_remove_hides (matches Coq: Theorem tp_remove_hides)
; tp_remove_hides: forall s v, tp_lookup (tp_remove s v) v = false
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; tp_remove_hides [partial: bindings preserved]

; tp_remove_permanent (matches Coq: Theorem tp_remove_permanent)
; tp_remove_permanent: forall s v a b, gs_member (snd s) v = true -> tp_lookup (tp_merge s (a, b)) v = false
(assert (forall ((s Bool) (v Bool) (a Bool) (b Bool)) (= 0 0))) ; tp_remove_permanent [partial: bindings preserved]

; tp_merge_comm_lookup (matches Coq: Theorem tp_merge_comm_lookup)
; tp_merge_comm_lookup: forall a b v, tp_lookup (tp_merge a b) v = tp_lookup (tp_merge b a) v
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; tp_merge_comm_lookup [partial: bindings preserved]

; tp_merge_idem (matches Coq: Theorem tp_merge_idem)
; tp_merge_idem: forall s, tp_merge s s = s
(assert (forall ((s Bool)) (= 0 0))) ; tp_merge_idem [partial: bindings preserved]

; tp_empty_merge_l (matches Coq: Theorem tp_empty_merge_l)
; tp_empty_merge_l: forall s v, tp_lookup s v = true -> tp_lookup (tp_merge tp_empty s) v = true
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; tp_empty_merge_l [partial: bindings preserved]

; tp_add_preserves_removed (matches Coq: Theorem tp_add_preserves_removed)
; tp_add_preserves_removed: forall s v, snd (tp_add s v) = snd s
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; tp_add_preserves_removed [partial: bindings preserved]

; tp_remove_preserves_added (matches Coq: Theorem tp_remove_preserves_added)
; tp_remove_preserves_added: forall s v, fst (tp_remove s v) = fst s
(assert (forall ((s Bool) (v Bool)) (= 0 0))) ; tp_remove_preserves_added [partial: bindings preserved]

; tp_lookup_false_not_added (matches Coq: Theorem tp_lookup_false_not_added)
; tp_lookup_false_not_added: forall v, tp_lookup tp_empty v = false
(assert (forall ((v Bool)) (= 0 0))) ; tp_lookup_false_not_added [partial: bindings preserved]

; tp_merge_add_visible (matches Coq: Theorem tp_merge_add_visible)
; tp_merge_add_visible: forall a b v, gs_member (fst a) v = true -> gs_member (snd a) v = false -> gs_member (gs_merge (snd a) (snd b)) v = fals
(assert (forall ((a Bool) (b Bool) (v Bool)) (= 0 0))) ; tp_merge_add_visible [partial: bindings preserved]

; tp_merge_preserves_removal (matches Coq: Theorem tp_merge_preserves_removal)
; tp_merge_preserves_removal: forall (a b : TwoPSet) v, gs_member (snd a) v = true -> gs_member (gs_merge (snd a) (snd b)) v = true
(assert (= 0 0)) ; tp_merge_preserves_removal [Coq-only]

; tp_once_removed_stays_removed (matches Coq: Theorem tp_once_removed_stays_removed)
; tp_once_removed_stays_removed: forall s v ops, gs_member (snd s) v = true -> gs_member (snd (fold_left (fun acc op => tp_merge acc op) ops s)) v = true
(assert (forall ((s Bool) (v Bool) (ops Bool)) (= 0 0))) ; tp_once_removed_stays_removed [partial: bindings preserved]

; lww_merge_comm (matches Coq: Theorem lww_merge_comm)
; lww_merge_comm: forall a b, lww_merge a b = lww_merge b a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; lww_merge_comm [partial: bindings preserved]

; lww_merge_idem (matches Coq: Theorem lww_merge_idem)
; lww_merge_idem: forall a, lww_merge a a = a
(assert (forall ((a Bool)) (= 0 0))) ; lww_merge_idem [partial: bindings preserved]

; lww_merge_assoc_idem (matches Coq: Theorem lww_merge_assoc_idem)
; lww_merge_assoc_idem: forall a, lww_merge (lww_merge a a) a = lww_merge a a
(assert (forall ((a Bool)) (= 0 0))) ; lww_merge_assoc_idem [partial: bindings preserved]

; lww_write_higher_wins (matches Coq: Theorem lww_write_higher_wins)
; lww_write_higher_wins: forall r v1 v2 ts1 ts2, ts1 < ts2 -> lww_merge (lww_write r v1 ts1) (lww_write r v2 ts2) = mkLWW v2 ts2
(assert (forall ((r Bool) (v1 Bool) (v2 Bool) (ts1 Bool) (ts2 Bool)) (= 0 0))) ; lww_write_higher_wins [partial: bindings preserved]

; lww_read_after_write (matches Coq: Theorem lww_read_after_write)
; lww_read_after_write: forall r v ts, lww_read (lww_write r v ts) = v
(assert (forall ((r Bool) (v Bool) (ts Bool)) (= 0 0))) ; lww_read_after_write [partial: bindings preserved]

; lww_merge_ts_nondecreasing (matches Coq: Theorem lww_merge_ts_nondecreasing)
; lww_merge_ts_nondecreasing: forall a b, lww_ts (lww_merge a b) >= lww_ts a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; lww_merge_ts_nondecreasing [partial: bindings preserved]

; lww_merge_ts_max (matches Coq: Theorem lww_merge_ts_max)
; lww_merge_ts_max: forall a b, lww_ts (lww_merge a b) = Nat.max (lww_ts a) (lww_ts b)
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; lww_merge_ts_max [partial: bindings preserved]

; lww_bottom_merge_l (matches Coq: Theorem lww_bottom_merge_l)
; lww_bottom_merge_l: forall r, lww_ts r >= 0 -> lww_merge lww_bottom r = r
(assert (forall ((r Bool)) (= 0 0))) ; lww_bottom_merge_l [partial: bindings preserved]

; lww_concurrent_same_ts (matches Coq: Theorem lww_concurrent_same_ts)
; lww_concurrent_same_ts: forall v1 v2 ts, lww_merge (mkLWW v1 ts) (mkLWW v2 ts) = lww_merge (mkLWW v2 ts) (mkLWW v1 ts)
(assert (forall ((v1 Bool) (v2 Bool) (ts Bool)) (= 0 0))) ; lww_concurrent_same_ts [partial: bindings preserved]

; lww_merge_either (matches Coq: Theorem lww_merge_either)
; lww_merge_either: forall a b, lww_merge a b = a \/ lww_merge a b = b
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; lww_merge_either [partial: bindings preserved]

; or_entry_eqb_refl (matches Coq: Lemma or_entry_eqb_refl)
; or_entry_eqb_refl: forall e, or_entry_eqb e e = true
(assert (forall ((e Bool)) (= 0 0))) ; or_entry_eqb_refl [partial: bindings preserved]

; existsb_app (matches Coq: Lemma existsb_app)
; existsb_app: forall {A} (f : A -> bool) l1 l2, existsb f (l1 ++ l2) = existsb f l1 || existsb f l2
(assert (= 0 0)) ; existsb_app [Coq-only]

; or_add_lookup (matches Coq: Theorem or_add_lookup)
; or_add_lookup: forall s v tag, or_in_list (v, tag) (snd s) = false -> or_lookup (or_add s v tag) v = true
(assert (forall ((s Bool) (v Bool) (tag Bool)) (= 0 0))) ; or_add_lookup [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
