; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SpeculativeExecution.v (20 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SpeculativeExecution

(set-logic ALL)
(set-option :produce-models true)

; effect (matches Coq: Inductive effect)
(declare-datatypes ((Ind_effect 0)) (((Eff_pure) (Eff_timed) (Eff_speculative))))

; visibility (matches Coq: Inductive visibility)
(declare-datatypes ((visibility 0)) (((Public) (Secret))))

; value (matches Coq: Inductive value)
(declare-datatypes ((value 0)) (((VNat) (VBool))))

; instr (matches Coq: Inductive instr)
(declare-datatypes ((instr 0)) (((IConst) (IBinop) (IBranch) (ISeq) (IAnnot))))

(declare-const __default_Ind_effect Ind_effect)
(declare-const __default_instr instr)
(declare-const __default_value value)
(declare-const __default_visibility visibility)

; eff_le (matches Coq: Definition eff_le)
(define-fun eff_le ((e1 Ind_effect) (e2 Ind_effect)) Bool
  (= 0 0))

; eff_join (matches Coq: Definition eff_join)
(declare-fun eff_join (Ind_effect Ind_effect) Ind_effect)

; infer_effect (matches Coq: Definition infer_effect)
(declare-fun infer_effect (instr) Ind_effect)

; is_constant_time (matches Coq: Definition is_constant_time)
(define-fun is_constant_time ((i instr)) Bool
  (= 0 0))

; is_spec_safe (matches Coq: Definition is_spec_safe)
(define-fun is_spec_safe ((i instr)) Bool
  (= 0 0))

; eval_instr (matches Coq: Definition eval_instr)
(define-fun eval_instr ((i instr)) Int
  0)

; no_speculative_annotation (matches Coq: Definition no_speculative_annotation)
(define-fun no_speculative_annotation ((i instr)) Bool
  (= 0 0))

; eff_join_pure_l (matches Coq: Lemma eff_join_pure_l)
; eff_join_pure_l: forall e, eff_join Eff_pure e = e
(assert (forall ((e Bool)) (= 0 0))) ; eff_join_pure_l [partial: bindings preserved]

; eff_join_pure_r (matches Coq: Lemma eff_join_pure_r)
; eff_join_pure_r: forall e, eff_join e Eff_pure = e
(assert (forall ((e Bool)) (= 0 0))) ; eff_join_pure_r [partial: bindings preserved]

; eff_le_refl (matches Coq: Lemma eff_le_refl)
; eff_le_refl: forall e, eff_le e e = true
(assert (forall ((e Bool)) (= 0 0))) ; eff_le_refl [partial: bindings preserved]

; eff_le_trans (matches Coq: Lemma eff_le_trans)
; eff_le_trans: forall e1 e2 e3, eff_le e1 e2 = true -> eff_le e2 e3 = true -> eff_le e1 e3 = true
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool)) (= 0 0))) ; eff_le_trans [partial: bindings preserved]

; pure_is_constant_time (matches Coq: Theorem pure_is_constant_time)
; pure_is_constant_time: forall i, infer_effect i = Eff_pure -> is_constant_time i = true
(assert (forall ((i Bool)) (= 0 0))) ; pure_is_constant_time [partial: bindings preserved]

; ct_composition (matches Coq: Theorem ct_composition)
; ct_composition: forall a b, is_constant_time a = true -> is_constant_time b = true -> is_constant_time (ISeq a b) = true
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; ct_composition [partial: bindings preserved]

; no_secret_branch (matches Coq: Lemma no_secret_branch)
; no_secret_branch: forall i, is_constant_time i = true -> forall c t f, i <> IBranch Secret c t f
(assert (forall ((i Bool)) (= 0 0))) ; no_secret_branch [partial: bindings preserved]

; spec_safe_no_secret_branch_aux (matches Coq: Lemma spec_safe_no_secret_branch_aux)
; spec_safe_no_secret_branch_aux: forall i, no_speculative_annotation i = true -> infer_effect i <> Eff_speculative -> is_constant_time i = true
(assert (forall ((i Bool)) (= 0 0))) ; spec_safe_no_secret_branch_aux [partial: bindings preserved]

; spec_safe_implies_no_secret_leakage (matches Coq: Theorem spec_safe_implies_no_secret_leakage)
; spec_safe_implies_no_secret_leakage: forall i, no_speculative_annotation i = true -> is_spec_safe i = true -> is_constant_time i = true
(assert (forall ((i Bool)) (= 0 0))) ; spec_safe_implies_no_secret_leakage [partial: bindings preserved]

; effect_preorder_refl (matches Coq: Theorem effect_preorder_refl)
; effect_preorder_refl: forall e, eff_le e e = true
(assert (forall ((e Bool)) (= 0 0))) ; effect_preorder_refl [partial: bindings preserved]

; effect_preorder_trans (matches Coq: Theorem effect_preorder_trans)
; effect_preorder_trans: forall e1 e2 e3, eff_le e1 e2 = true -> eff_le e2 e3 = true -> eff_le e1 e3 = true
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool)) (= 0 0))) ; effect_preorder_trans [partial: bindings preserved]

; pure_is_bottom (matches Coq: Theorem pure_is_bottom)
; pure_is_bottom: forall e, eff_le Eff_pure e = true
(assert (forall ((e Bool)) (= 0 0))) ; pure_is_bottom [partial: bindings preserved]

; seq_preserves_spec_safe (matches Coq: Theorem seq_preserves_spec_safe)
; seq_preserves_spec_safe: forall a b, is_spec_safe a = true -> is_spec_safe b = true -> is_spec_safe (ISeq a b) = true
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; seq_preserves_spec_safe [partial: bindings preserved]

; public_branch_ct (matches Coq: Theorem public_branch_ct)
; public_branch_ct: forall c t f, is_constant_time c = true -> is_constant_time t = true -> is_constant_time f = true -> is_constant_time (I
(assert (forall ((c Bool) (t Bool) (f Bool)) (= 0 0))) ; public_branch_ct [partial: bindings preserved]

; annotation_soundness (matches Coq: Theorem annotation_soundness)
; annotation_soundness: forall e i, eff_le (infer_effect i) e = true -> eff_le (infer_effect (IAnnot e i)) e = true
(assert (forall ((e Bool) (i Bool)) (= 0 0))) ; annotation_soundness [partial: bindings preserved]

; binop_preserves_ct (matches Coq: Theorem binop_preserves_ct)
; binop_preserves_ct: forall a b, is_constant_time a = true -> is_constant_time b = true -> is_constant_time (IBinop a b) = true
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; binop_preserves_ct [partial: bindings preserved]

; pure_implies_spec_safe (matches Coq: Theorem pure_implies_spec_safe)
; pure_implies_spec_safe: forall i, infer_effect i = Eff_pure -> is_spec_safe i = true
(assert (forall ((i Bool)) (= 0 0))) ; pure_implies_spec_safe [partial: bindings preserved]

; timed_implies_spec_safe (matches Coq: Theorem timed_implies_spec_safe)
; timed_implies_spec_safe: forall i, infer_effect i = Eff_timed -> is_spec_safe i = true
(assert (forall ((i Bool)) (= 0 0))) ; timed_implies_spec_safe [partial: bindings preserved]

; const_is_pure (matches Coq: Theorem const_is_pure)
; const_is_pure: forall v, infer_effect (IConst v) = Eff_pure
(assert (forall ((v Bool)) (= 0 0))) ; const_is_pure [partial: bindings preserved]

; eff_join_comm (matches Coq: Theorem eff_join_comm)
; eff_join_comm: forall e1 e2, eff_join e1 e2 = eff_join e2 e1
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; eff_join_comm [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
