; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/V001_TerminationGuarantees.v (32 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: V001_TerminationGuarantees

(set-logic ALL)
(set-option :produce-models true)

; expr (matches Coq: Inductive expr)
(declare-datatypes ((expr 0)) (((EVar) (EConst) (EApp) (ELam) (ERec))))

; sized_ty (matches Coq: Inductive sized_ty)
(declare-datatypes ((sized_ty 0)) (((STNat) (STList) (STTree) (STFun))))

; even_tree (matches Coq: Inductive even_tree)
(declare-datatypes ((even_tree 0)) (((ELeaf) (ENode))))

; odd_tree (matches Coq: Inductive odd_tree)
(declare-datatypes ((odd_tree 0)) (((OLeaf) (ONode))))

; NonTerminating (matches Coq: Inductive NonTerminating)
(declare-datatypes ((NonTerminating 0)) (((Loop))))

(declare-const __default_NonTerminating NonTerminating)
(declare-const __default_even_tree even_tree)
(declare-const __default_expr expr)
(declare-const __default_odd_tree odd_tree)
(declare-const __default_sized_ty sized_ty)

; expr_size (matches Coq: Definition expr_size)
(define-fun expr_size ((e expr)) Int
  0)

; structurally_smaller (matches Coq: Definition structurally_smaller)
(define-fun structurally_smaller ((e1 expr) (e2 expr)) Bool
  (= 0 0))

; structural_recursion (matches Coq: Definition structural_recursion)
(define-fun structural_recursion ((e expr)) Bool
  (= 0 0))

; size_subtype (matches Coq: Definition size_subtype)
(define-fun size_subtype ((s1 Int) (s2 Int)) Bool
  (= 0 0))

; sized_wellformed (matches Coq: Definition sized_wellformed)
(define-fun sized_wellformed ((st sized_ty)) Bool
  (= 0 0))

; size_less (matches Coq: Definition size_less)
(define-fun size_less ((st1 sized_ty) (st2 sized_ty)) Bool
  (= 0 0))

; ackermann (matches Coq: Definition ackermann)
(define-fun ackermann ((m Int) (n Int)) Int
  0)

; pure (matches Coq: Definition pure)
(define-fun defn_pure ((e expr)) Bool
  (= 0 0))

; well_typed (matches Coq: Definition well_typed)
(define-fun well_typed ((e expr)) Bool
  (= 0 0))

; is_value (matches Coq: Definition is_value)
(define-fun is_value ((e expr)) Bool
  (= 0 0))

; check_termination (matches Coq: Definition check_termination)
(define-fun check_termination ((e expr)) Bool
  (= 0 0))

; even_size (matches Coq: Definition even_size)
(define-fun even_size ((t even_tree)) Int
  0)

; infer_size (matches Coq: Definition infer_size)
(define-fun infer_size ((e expr)) Int
  0)

; infer_measure (matches Coq: Definition infer_measure)
(define-fun infer_measure ((e expr)) Int
  0)

; explicitly_marked (matches Coq: Definition explicitly_marked)
(define-fun explicitly_marked ((e expr)) Bool
  (= 0 0))

; V_001_01_structural_decrease (matches Coq: Theorem V_001_01_structural_decrease)
; V_001_01_structural_decrease: forall e e_rec arg, structural_recursion e -> recursive_call e e_rec arg -> structurally_smaller arg e
(assert (forall ((e Bool) (e_rec Bool) (arg Bool)) (= 0 0))) ; V_001_01_structural_decrease [partial: bindings preserved]

; V_001_02_structural_termination (matches Coq: Theorem V_001_02_structural_termination)
; V_001_02_structural_termination: forall e, structural_recursion e -> terminates e
(assert (forall ((e Bool)) (= 0 0))) ; V_001_02_structural_termination [partial: bindings preserved]

; V_001_03_nat_structural (matches Coq: Theorem V_001_03_nat_structural)
; V_001_03_nat_structural: forall (f : nat -> nat) n, exists v, (fix go m := match m with 0 => 0 | S m' => f (go m') end) n = v
(assert (= 0 0)) ; V_001_03_nat_structural [Coq-only]

; V_001_04_list_structural (matches Coq: Theorem V_001_04_list_structural)
; V_001_04_list_structural: forall A (f : A -> nat -> nat) (l : list A), exists v, fold_left (fun acc x => f x acc) l 0 = v
(assert (= 0 0)) ; V_001_04_list_structural [Coq-only]

; V_001_05_tree_structural (matches Coq: Theorem V_001_05_tree_structural)
; V_001_05_tree_structural: forall A (t : tree A), exists v, tree_size t = v
(assert (= 0 0)) ; V_001_05_tree_structural [Coq-only]

; V_001_06_mutual_structural (matches Coq: Theorem V_001_06_mutual_structural)
; V_001_06_mutual_structural: forall et ot, exists ve vo, even_size et = ve /\ odd_size ot = vo
(assert (forall ((et Bool) (ot Bool)) (= 0 0))) ; V_001_06_mutual_structural [partial: bindings preserved]

; V_001_07_nested_structural (matches Coq: Theorem V_001_07_nested_structural)
; V_001_07_nested_structural: forall n, exists v, (fix outer m := match m with | 0 => 0 | S m' => (fix inner k := match k with 0 => 0 | S k' => 1 + in
(assert (forall ((n Bool)) (= 0 0))) ; V_001_07_nested_structural [partial: bindings preserved]

; V_001_08_structural_checker_sound (matches Coq: Theorem V_001_08_structural_checker_sound)
; V_001_08_structural_checker_sound: forall e, check_termination e = true -> structural_recursion e -> terminates e
(assert (forall ((e Bool)) (= 0 0))) ; V_001_08_structural_checker_sound [partial: bindings preserved]

; V_001_09_sized_type_wellformed (matches Coq: Theorem V_001_09_sized_type_wellformed)
; V_001_09_sized_type_wellformed: forall st, sized_wellformed st
(assert (forall ((st Bool)) (= 0 0))) ; V_001_09_sized_type_wellformed [partial: bindings preserved]

; V_001_10_size_decreases (matches Coq: Theorem V_001_10_size_decreases)
; V_001_10_size_decreases: forall st1 st2 s1 s2, get_size st1 = Some s1 -> get_size st2 = Some s2 -> s1 < s2 -> size_less st1 st2
(assert (forall ((st1 Bool) (st2 Bool) (s1 Bool) (s2 Bool)) (= 0 0))) ; V_001_10_size_decreases [partial: bindings preserved]

; V_001_11_sized_list_terminates (matches Coq: Theorem V_001_11_sized_list_terminates)
; V_001_11_sized_list_terminates: forall A B (f : A -> B -> B) (l : list A) (acc : B), exists v, sized_list_fold f l acc = v
(assert (= 0 0)) ; V_001_11_sized_list_terminates [Coq-only]

; V_001_12_sized_tree_terminates (matches Coq: Theorem V_001_12_sized_tree_terminates)
; V_001_12_sized_tree_terminates: forall A B (f : A -> B -> B -> B) (leaf : B) (t : tree A), exists v, sized_tree_fold f leaf t = v
(assert (= 0 0)) ; V_001_12_sized_tree_terminates [Coq-only]

; V_001_13_size_inference_correct (matches Coq: Theorem V_001_13_size_inference_correct)
; V_001_13_size_inference_correct: forall e, infer_size e = expr_size e
(assert (forall ((e Bool)) (= 0 0))) ; V_001_13_size_inference_correct [partial: bindings preserved]

; V_001_14_size_subtyping (matches Coq: Theorem V_001_14_size_subtyping)
; V_001_14_size_subtyping: forall s1 s2 s3, size_subtype s1 s2 -> size_subtype s2 s3 -> size_subtype s1 s3
(assert (forall ((s1 Bool) (s2 Bool) (s3 Bool)) (= 0 0))) ; V_001_14_size_subtyping [partial: bindings preserved]

; V_001_15_sized_preservation (matches Coq: Theorem V_001_15_sized_preservation)
; V_001_15_sized_preservation: forall e1 e2 st, has_sized_type e1 st -> step e1 e2 -> exists st', has_sized_type e2 st'
(assert (forall ((e1 Bool) (e2 Bool) (st Bool)) (= 0 0))) ; V_001_15_sized_preservation [partial: bindings preserved]

; V_001_16_sized_composition (matches Coq: Theorem V_001_16_sized_composition)
; V_001_16_sized_composition: forall s1 s2, size_subtype s1 s2 -> size_subtype 0 s1 -> size_subtype 0 s2
(assert (forall ((s1 Bool) (s2 Bool)) (= 0 0))) ; V_001_16_sized_composition [partial: bindings preserved]

; V_001_17_measure_wellformed (matches Coq: Theorem V_001_17_measure_wellformed)
; V_001_17_measure_wellformed: forall A (m : Measure A), wf_measure m
(assert (= 0 0)) ; V_001_17_measure_wellformed [Coq-only]

; V_001_18_measure_decreases (matches Coq: Theorem V_001_18_measure_decreases)
; V_001_18_measure_decreases: forall A (m : Measure A) e, decreases_on m e
(assert (= 0 0)) ; V_001_18_measure_decreases [Coq-only]

; V_001_19_lexicographic_wellformed (matches Coq: Theorem V_001_19_lexicographic_wellformed)
; V_001_19_lexicographic_wellformed: forall A B (ma : Measure A) (mb : Measure B), well_founded (lex_order ma mb)
(assert (= 0 0)) ; V_001_19_lexicographic_wellformed [Coq-only]

; V_001_20_ackermann_terminates (matches Coq: Theorem V_001_20_ackermann_terminates)
; V_001_20_ackermann_terminates: forall m n, exists v, ackermann m n = v
(assert (forall ((m Bool) (n Bool)) (= 0 0))) ; V_001_20_ackermann_terminates [partial: bindings preserved]

; V_001_21_complex_measure_sound (matches Coq: Theorem V_001_21_complex_measure_sound)
; V_001_21_complex_measure_sound: forall A B (ma : Measure A) (mb : Measure B), wf_measure (complex_measure ma mb)
(assert (= 0 0)) ; V_001_21_complex_measure_sound [Coq-only]

; V_001_22_measure_inference (matches Coq: Theorem V_001_22_measure_inference)
; V_001_22_measure_inference: forall e, infer_measure e >= 1
(assert (forall ((e Bool)) (= 0 0))) ; V_001_22_measure_inference [partial: bindings preserved]

; V_001_23_measure_composition (matches Coq: Theorem V_001_23_measure_composition)
; V_001_23_measure_composition: forall A (m1 m2 : Measure A) x, m1 x + m2 x >= m1 x
(assert (= 0 0)) ; V_001_23_measure_composition [Coq-only]

; V_001_24_wellfounded_checker_sound (matches Coq: Theorem V_001_24_wellfounded_checker_sound)
; V_001_24_wellfounded_checker_sound: forall A e (m : Measure A), check_termination e = true -> wf_measure m -> decreases_on m e -> terminates e
(assert (= 0 0)) ; V_001_24_wellfounded_checker_sound [Coq-only]

; V_001_25_codata_productive (matches Coq: Theorem V_001_25_codata_productive)
; V_001_25_codata_productive: forall A (s : Stream A), productive s
(assert (= 0 0)) ; V_001_25_codata_productive [Coq-only]

; V_001_26_stream_productive (matches Coq: Theorem V_001_26_stream_productive)
; V_001_26_stream_productive: forall A (s : Stream A), forall n, List.length (observe n s) = n
(assert (= 0 0)) ; V_001_26_stream_productive [Coq-only]

; V_001_27_productivity_observe (matches Coq: Theorem V_001_27_productivity_observe)
; V_001_27_productivity_observe: forall A (s : Stream A) k, exists l, observe k s = l /\ List.length l = k
(assert (= 0 0)) ; V_001_27_productivity_observe [Coq-only]

; V_001_28_guarded_recursion (matches Coq: Theorem V_001_28_guarded_recursion)
; V_001_28_guarded_recursion: forall A (g : Guarded (Stream A)), match g with Later s => productive s end
(assert (= 0 0)) ; V_001_28_guarded_recursion [Coq-only]

; V_001_29_codata_unfold (matches Coq: Theorem V_001_29_codata_unfold)
; V_001_29_codata_unfold: forall A S (f : S -> A * S) (seed : S), productive (stream_unfold f seed)
(assert (= 0 0)) ; V_001_29_codata_unfold [Coq-only]

; V_001_30_productive_composition (matches Coq: Theorem V_001_30_productive_composition)
; V_001_30_productive_composition: forall A (s1 s2 : Stream A), productive s1 -> productive s2 -> productive s1 /\ productive s2
(assert (= 0 0)) ; V_001_30_productive_composition [Coq-only]

; V_001_31_non_terminating_marked (matches Coq: Theorem V_001_31_non_terminating_marked)
; V_001_31_non_terminating_marked: forall e, ~ terminates e -> explicitly_marked e \/ is_value e \/ exists e', step e e'
(assert (forall ((e Bool)) (= 0 0))) ; V_001_31_non_terminating_marked [partial: bindings preserved]

; V_001_32_strong_normalization (matches Coq: Theorem V_001_32_strong_normalization)
; V_001_32_strong_normalization: forall e, pure e -> well_typed e -> is_value e \/ exists e', step e e'
(assert (forall ((e Bool)) (= 0 0))) ; V_001_32_strong_normalization [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
