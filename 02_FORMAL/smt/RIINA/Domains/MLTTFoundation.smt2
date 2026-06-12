; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/MLTTFoundation.v (25 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: MLTTFoundation

(set-logic ALL)
(set-option :produce-models true)

; Ty (matches Coq: Inductive Ty)
(declare-datatypes ((Ty 0)) (((TUnit) (TPi) (TSigma) (TId) (TUniverse))))

; Term (matches Coq: Inductive Term)
(declare-datatypes ((Term 0)) (((TmVar) (TmUnit) (TmLam) (TmApp) (TmPair) (TmFst) (TmSnd) (TmRefl) (TmJ))))

(declare-const __default_Term Term)
(declare-const __default_Ty Ty)

; empty_ctx (matches Coq: Definition empty_ctx)
(define-fun empty_ctx () Int
  0)

; ctx_extend (matches Coq: Definition ctx_extend)
(define-fun ctx_extend ((G Int) (A Ty)) Int
  0)

; ctx_lookup (matches Coq: Definition ctx_lookup)
(define-fun ctx_lookup ((G Int) (n Int)) Int
  0)

; shift (matches Coq: Definition shift)
(declare-fun shift (Int Int Term) Term)

; subst (matches Coq: Definition subst)
(declare-fun subst (Int Term Term) Term)

; cumulativity_level (matches Coq: Lemma cumulativity_level)
; cumulativity_level: forall A l, has_level A l -> has_level A (S l)
(assert (forall ((A Bool) (l Bool)) (= 0 0))) ; cumulativity_level [partial: bindings preserved]

; TYPE_001_01 (matches Coq: Theorem TYPE_001_01)
; TYPE_001_01: forall (G : Ctx) (A B : Ty), wf_ctx G -> wf_ty G A -> wf_ty (ctx_extend G A) B -> wf_ty G (TPi A B)
(assert (forall ((G Int) (A Ty) (B Ty)) (= 0 0))) ; TYPE_001_01 [partial: bindings preserved]

; TYPE_001_02 (matches Coq: Theorem TYPE_001_02)
; TYPE_001_02: forall (G : Ctx) (A B : Ty) (f a : Term), has_type G f (TPi A B) -> has_type G a A -> has_type G (TmApp f a) B
(assert (forall ((G Int) (A Ty) (B Ty) (f Term) (a Term)) (= 0 0))) ; TYPE_001_02 [partial: bindings preserved]

; TYPE_001_03 (matches Coq: Theorem TYPE_001_03)
; TYPE_001_03: forall (G : Ctx) (A B : Ty) (a b : Term), wf_ty G (TSigma A B) -> has_type G a A -> has_type G b B -> has_type G (TmPair
(assert (forall ((G Int) (A Ty) (B Ty) (a Term) (b Term)) (= 0 0))) ; TYPE_001_03 [partial: bindings preserved]

; TYPE_001_04 (matches Coq: Theorem TYPE_001_04)
; TYPE_001_04: forall (G : Ctx) (A B : Ty) (p : Term), has_type G p (TSigma A B) -> has_type G (TmFst p) A /\ has_type G (TmSnd p) B
(assert (forall ((G Int) (A Ty) (B Ty) (p Term)) (= 0 0))) ; TYPE_001_04 [partial: bindings preserved]

; TYPE_001_05 (matches Coq: Theorem TYPE_001_05)
; TYPE_001_05: forall (G : Ctx) (A : Ty) (a : Term), wf_ty G A -> has_type G a A -> has_type G (TmRefl a) (TId A)
(assert (forall ((G Int) (A Ty) (a Term)) (= 0 0))) ; TYPE_001_05 [partial: bindings preserved]

; TYPE_001_06 (matches Coq: Theorem TYPE_001_06)
; TYPE_001_06: forall (G : Ctx) (A : Ty) (C : Ty) (d p : Term), wf_ty G A -> has_type G d C -> has_type G p (TId A) -> has_type G (TmJ 
(assert (forall ((G Int) (A Ty) (C Ty) (d Term) (p Term)) (= 0 0))) ; TYPE_001_06 [partial: bindings preserved]

; TYPE_001_07 (matches Coq: Theorem TYPE_001_07)
; TYPE_001_07: forall l, has_level (TUniverse l) (S l)
(assert (forall ((l Bool)) (= 0 0))) ; TYPE_001_07 [partial: bindings preserved]

; TYPE_001_08 (matches Coq: Theorem TYPE_001_08)
; TYPE_001_08: forall (A : Ty) (l : Level), has_level A l -> has_level A (S l)
(assert (forall ((A Ty) (l Int)) (= 0 0))) ; TYPE_001_08 [partial: bindings preserved]

; TYPE_001_09 (matches Coq: Theorem TYPE_001_09)
; TYPE_001_09: forall (G : Ctx) (A : Ty), wf_ctx G -> wf_ctx (ctx_extend G A)
(assert (forall ((G Int) (A Ty)) (= 0 0))) ; TYPE_001_09 [partial: bindings preserved]

; TYPE_001_10 (matches Coq: Theorem TYPE_001_10)
; TYPE_001_10: forall t1 t2 n s, term_eq t1 t2 -> term_eq (subst n s t1) (subst n s t2)
(assert (forall ((t1 Bool) (t2 Bool) (n Bool) (s Bool)) (= 0 0))) ; TYPE_001_10 [partial: bindings preserved]

; type_uniqueness_eq (matches Coq: Lemma type_uniqueness_eq)
; type_uniqueness_eq: forall (G : Ctx) t A B, has_type G t A -> has_type G t B -> A = B
(assert (= 0 0)) ; type_uniqueness_eq [Coq-only]

; TYPE_001_11 (matches Coq: Theorem TYPE_001_11)
; TYPE_001_11: forall (G : Ctx) t A B, has_type G t A -> has_type G t B -> ty_eq A B
(assert (= 0 0)) ; TYPE_001_11 [Coq-only]

; TYPE_001_12 (matches Coq: Theorem TYPE_001_12)
; TYPE_001_12: forall A t a, comp_eq (TmApp (TmLam A t) a) (subst 0 a t)
(assert (forall ((A Bool) (t Bool) (a Bool)) (= 0 0))) ; TYPE_001_12 [partial: bindings preserved]

; TYPE_001_13 (matches Coq: Theorem TYPE_001_13)
; TYPE_001_13: forall A f, comp_eq (TmLam A (TmApp (shift 0 1 f) (TmVar 0))) f
(assert (forall ((A Bool) (f Bool)) (= 0 0))) ; TYPE_001_13 [partial: bindings preserved]

; TYPE_001_14 (matches Coq: Theorem TYPE_001_14)
; TYPE_001_14: forall p, comp_eq (TmPair (TmFst p) (TmSnd p)) p
(assert (forall ((p Bool)) (= 0 0))) ; TYPE_001_14 [partial: bindings preserved]

; red_star_trans (matches Coq: Lemma red_star_trans)
; red_star_trans: forall t u v, reduces_star t u -> reduces_star u v -> reduces_star t v
(assert (forall ((t Bool) (u Bool) (v Bool)) (= 0 0))) ; red_star_trans [partial: bindings preserved]

; red_star_app (matches Coq: Lemma red_star_app)
; red_star_app: forall f f' a a', reduces_star f f' -> reduces_star a a' -> reduces_star (TmApp f a) (TmApp f' a')
(assert (forall ((f Bool) (f_ Bool) (a Bool) (a_ Bool)) (= 0 0))) ; red_star_app [partial: bindings preserved]

; red_star_lam (matches Coq: Lemma red_star_lam)
; red_star_lam: forall A body body', reduces_star body body' -> reduces_star (TmLam A body) (TmLam A body')
(assert (forall ((A Bool) (body Bool) (body_ Bool)) (= 0 0))) ; red_star_lam [partial: bindings preserved]

; red_star_pair (matches Coq: Lemma red_star_pair)
; red_star_pair: forall a a' b b', reduces_star a a' -> reduces_star b b' -> reduces_star (TmPair a b) (TmPair a' b')
(assert (forall ((a Bool) (a_ Bool) (b Bool) (b_ Bool)) (= 0 0))) ; red_star_pair [partial: bindings preserved]

; red_star_fst (matches Coq: Lemma red_star_fst)
; red_star_fst: forall p p', reduces_star p p' -> reduces_star (TmFst p) (TmFst p')
(assert (forall ((p Bool) (p_ Bool)) (= 0 0))) ; red_star_fst [partial: bindings preserved]

; red_star_snd (matches Coq: Lemma red_star_snd)
; red_star_snd: forall p p', reduces_star p p' -> reduces_star (TmSnd p) (TmSnd p')
(assert (forall ((p Bool) (p_ Bool)) (= 0 0))) ; red_star_snd [partial: bindings preserved]

; red_star_refl_tm (matches Coq: Lemma red_star_refl_tm)
; red_star_refl_tm: forall a a', reduces_star a a' -> reduces_star (TmRefl a) (TmRefl a')
(assert (forall ((a Bool) (a_ Bool)) (= 0 0))) ; red_star_refl_tm [partial: bindings preserved]

; red_star_J (matches Coq: Lemma red_star_J)
; red_star_J: forall A C d d' p p', reduces_star d d' -> reduces_star p p' -> reduces_star (TmJ A C d p) (TmJ A C d' p')
(assert (forall ((A Bool) (C Bool) (d Bool) (d_ Bool) (p Bool) (p_ Bool)) (= 0 0))) ; red_star_J [partial: bindings preserved]

; TYPE_001_15 (matches Coq: Theorem TYPE_001_15)
; TYPE_001_15: forall t, (exists nf, reduces_star t nf /\ (normal nf \/ neutral nf))
(assert (forall ((t Bool)) (= 0 0))) ; TYPE_001_15 [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
