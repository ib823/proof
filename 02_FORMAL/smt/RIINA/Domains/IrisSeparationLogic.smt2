; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/IrisSeparationLogic.v (21 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: IrisSeparationLogic

(set-logic ALL)
(set-option :produce-models true)

; hprop (matches Coq: Inductive hprop)
(declare-datatypes ((hprop 0)) (((HEmpty) (HPointsTo) (HStar) (HPure) (HWand))))

; fprop (matches Coq: Inductive fprop)
(declare-datatypes ((fprop 0)) (((FEmpty) (FPointsTo) (FStar) (FPure))))

(declare-const __default_fprop fprop)
(declare-const __default_hprop hprop)

; mem (matches Coq: Definition mem)
(define-fun mem ((n Int) (l (Seq Int))) Bool
  (= 0 0))

; disjoint (matches Coq: Definition disjoint)
(define-fun disjoint ((h1 Int) (h2 Int)) Bool
  (= 0 0))

; heap_union (matches Coq: Definition heap_union)
(define-fun heap_union ((h1 Int) (h2 Int)) Int
  0)

; heap_lookup (matches Coq: Definition heap_lookup)
(define-fun heap_lookup ((h Int) (l Int)) Int
  0)

; satisfies (matches Coq: Definition satisfies)
(define-fun satisfies ((h Int) (p hprop)) Bool
  (= 0 0))

; fempty (matches Coq: Definition fempty)
(define-fun fempty () Int
  0)

; fsingleton (matches Coq: Definition fsingleton)
(define-fun fsingleton ((l Int) (v Int)) Int
  0)

; fdisjoint (matches Coq: Definition fdisjoint)
(define-fun fdisjoint ((h1 Int) (h2 Int)) Bool
  (= 0 0))

; funion (matches Coq: Definition funion)
(define-fun funion ((h1 Int) (h2 Int)) Int
  0)

; fsat (matches Coq: Definition fsat)
(define-fun fsat ((h Int) (p fprop)) Bool
  (= 0 0))

; emp_empty (matches Coq: Theorem emp_empty)
; emp_empty: satisfies [] HEmpty
(assert (= 0 0)) ; emp_empty [Coq-only]

; points_to_singleton (matches Coq: Theorem points_to_singleton)
; points_to_singleton: forall l v, satisfies [(l, v)] (HPointsTo l v)
(assert (forall ((l Bool) (v Bool)) (= 0 0))) ; points_to_singleton [partial: bindings preserved]

; disjoint_sym (matches Coq: Lemma disjoint_sym)
; disjoint_sym: forall h1 h2, disjoint h1 h2 -> disjoint h2 h1
(assert (forall ((h1 Bool) (h2 Bool)) (= 0 0))) ; disjoint_sym [partial: bindings preserved]

; star_comm (matches Coq: Theorem star_comm)
; star_comm: forall p1 p2 h, fsat h (FStar p1 p2) -> fsat h (FStar p2 p1)
(assert (forall ((p1 Bool) (p2 Bool) (h Bool)) (= 0 0))) ; star_comm [partial: bindings preserved]

; star_emp_l (matches Coq: Theorem star_emp_l)
; star_emp_l: forall p h, fsat h p -> fsat h (FStar FEmpty p)
(assert (forall ((p Bool) (h Bool)) (= 0 0))) ; star_emp_l [partial: bindings preserved]

; points_to_exclusive (matches Coq: Theorem points_to_exclusive)
; points_to_exclusive: forall l v1 v2 h, fsat h (FStar (FPointsTo l v1) (FPointsTo l v2)) -> False
(assert (forall ((l Bool) (v1 Bool) (v2 Bool) (h Bool)) (= 0 0))) ; points_to_exclusive [partial: bindings preserved]

; frame_rule (matches Coq: Theorem frame_rule)
; frame_rule: forall p f h1 h2, fsat h1 p -> fsat h2 f -> fdisjoint h1 h2 -> fsat (funion h1 h2) (FStar p f)
(assert (forall ((p Bool) (f Bool) (h1 Bool) (h2 Bool)) (= 0 0))) ; frame_rule [partial: bindings preserved]

; fdisjoint_empty_l (matches Coq: Theorem fdisjoint_empty_l)
; fdisjoint_empty_l: forall h, fdisjoint fempty h
(assert (forall ((h Bool)) (= 0 0))) ; fdisjoint_empty_l [partial: bindings preserved]

; fdisjoint_empty_r (matches Coq: Theorem fdisjoint_empty_r)
; fdisjoint_empty_r: forall h, fdisjoint h fempty
(assert (forall ((h Bool)) (= 0 0))) ; fdisjoint_empty_r [partial: bindings preserved]

; funion_empty_l (matches Coq: Theorem funion_empty_l)
; funion_empty_l: forall h l, funion fempty h l = h l
(assert (forall ((h Bool) (l Bool)) (= 0 0))) ; funion_empty_l [partial: bindings preserved]

; funion_empty_r (matches Coq: Theorem funion_empty_r)
; funion_empty_r: forall h l, funion h fempty l = h l
(assert (forall ((h Bool) (l Bool)) (= 0 0))) ; funion_empty_r [partial: bindings preserved]

; fdisjoint_sym (matches Coq: Theorem fdisjoint_sym)
; fdisjoint_sym: forall h1 h2, fdisjoint h1 h2 -> fdisjoint h2 h1
(assert (forall ((h1 Bool) (h2 Bool)) (= 0 0))) ; fdisjoint_sym [partial: bindings preserved]

; pure_extract (matches Coq: Theorem pure_extract)
; pure_extract: forall (P : Prop) h, fsat h (FPure P) -> P
(assert (= 0 0)) ; pure_extract [Coq-only]

; pure_empty_heap (matches Coq: Theorem pure_empty_heap)
; pure_empty_heap: forall (P : Prop) h, fsat h (FPure P) -> forall l, h l = None
(assert (= 0 0)) ; pure_empty_heap [Coq-only]

; points_to_read (matches Coq: Theorem points_to_read)
; points_to_read: forall l v h, fsat h (FPointsTo l v) -> h l = Some v
(assert (forall ((l Bool) (v Bool) (h Bool)) (= 0 0))) ; points_to_read [partial: bindings preserved]

; points_to_other_none (matches Coq: Theorem points_to_other_none)
; points_to_other_none: forall l v h l', fsat h (FPointsTo l v) -> l' <> l -> h l' = None
(assert (forall ((l Bool) (v Bool) (h Bool) (l_ Bool)) (= 0 0))) ; points_to_other_none [partial: bindings preserved]

; fempty_sat_empty (matches Coq: Theorem fempty_sat_empty)
; fempty_sat_empty: fsat fempty FEmpty
(assert (= 0 0)) ; fempty_sat_empty [Coq-only]

; fsingleton_sat (matches Coq: Theorem fsingleton_sat)
; fsingleton_sat: forall l v, fsat (fsingleton l v) (FPointsTo l v)
(assert (forall ((l Bool) (v Bool)) (= 0 0))) ; fsingleton_sat [partial: bindings preserved]

; fsingleton_lookup_neq (matches Coq: Theorem fsingleton_lookup_neq)
; fsingleton_lookup_neq: forall l l' v, l' <> l -> fsingleton l v l' = None
(assert (forall ((l Bool) (l_ Bool) (v Bool)) (= 0 0))) ; fsingleton_lookup_neq [partial: bindings preserved]

; fdisjoint_singletons (matches Coq: Theorem fdisjoint_singletons)
; fdisjoint_singletons: forall l1 l2 v1 v2, l1 <> l2 -> fdisjoint (fsingleton l1 v1) (fsingleton l2 v2)
(assert (forall ((l1 Bool) (l2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; fdisjoint_singletons [partial: bindings preserved]

; fempty_pure_true (matches Coq: Theorem fempty_pure_true)
; fempty_pure_true: fsat fempty (FPure True)
(assert (= 0 0)) ; fempty_pure_true [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)
