; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/StrongNorm.v (34 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: StrongNorm

(set-logic ALL)
(set-option :produce-models true)

; value_strongly_normalizing (matches Coq: Theorem value_strongly_normalizing)
; value_strongly_normalizing: forall v st ctx, value v -> SN st ctx v
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; value_strongly_normalizing [partial: bindings preserved]

; fst_terminates_to_value (matches Coq: Lemma fst_terminates_to_value)
; fst_terminates_to_value: forall v1 v2 st ctx, value v1 -> value v2 -> exists v st' ctx', (EFst (EPair v1 v2), st, ctx) -->* (v, st', ctx') /\ val
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; fst_terminates_to_value [partial: bindings preserved]

; snd_terminates_to_value (matches Coq: Lemma snd_terminates_to_value)
; snd_terminates_to_value: forall v1 v2 st ctx, value v1 -> value v2 -> exists v st' ctx', (ESnd (EPair v1 v2), st, ctx) -->* (v, st', ctx') /\ val
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; snd_terminates_to_value [partial: bindings preserved]

; if_bool_terminates_once (matches Coq: Lemma if_bool_terminates_once)
; if_bool_terminates_once: forall b e2 e3 st ctx, exists e' st' ctx', (EIf (EBool b) e2 e3, st, ctx) -->* (e', st', ctx') /\ st' = st /\ ctx' = ctx
(assert (forall ((b Bool) (e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_bool_terminates_once [partial: bindings preserved]

; let_terminates_once (matches Coq: Lemma let_terminates_once)
; let_terminates_once: forall x v e2 st ctx, value v -> exists e' st' ctx', (ELet x v e2, st, ctx) -->* (e', st', ctx') /\ st' = st /\ ctx' = c
(assert (forall ((x Bool) (v Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; let_terminates_once [partial: bindings preserved]

; handle_terminates_once (matches Coq: Lemma handle_terminates_once)
; handle_terminates_once: forall x v h st ctx, value v -> exists e' st' ctx', (EHandle v x h, st, ctx) -->* (e', st', ctx') /\ st' = st /\ ctx' = 
(assert (forall ((x Bool) (v Bool) (h Bool) (st Bool) (ctx Bool)) (= 0 0))) ; handle_terminates_once [partial: bindings preserved]

; app_lam_terminates_once (matches Coq: Lemma app_lam_terminates_once)
; app_lam_terminates_once: forall x T body v st ctx, value v -> exists e' st' ctx', (EApp (ELam x T body) v, st, ctx) -->* (e', st', ctx') /\ st' =
(assert (forall ((x Bool) (T Bool) (body Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; app_lam_terminates_once [partial: bindings preserved]

; store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
; store_ty_extends_refl: forall Σ, store_ty_extends Σ Σ
(assert (forall ((sigma Bool)) (= 0 0))) ; store_ty_extends_refl [partial: bindings preserved]

; SN_multi_step (matches Coq: Lemma SN_multi_step)
; SN_multi_step: forall cfg cfg', cfg -->* cfg' -> forall e st ctx e' st' ctx', cfg = (e, st, ctx) -> cfg' = (e', st', ctx') -> SN st ctx
(assert (forall ((cfg Bool) (cfg_ Bool)) (= 0 0))) ; SN_multi_step [partial: bindings preserved]

; fst_value_terminates_pair (matches Coq: Lemma fst_value_terminates_pair)
; fst_value_terminates_pair: forall v1 v2 st ctx, value v1 -> value v2 -> SN st ctx (EFst (EPair v1 v2))
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; fst_value_terminates_pair [partial: bindings preserved]

; snd_value_SN (matches Coq: Lemma snd_value_SN)
; snd_value_SN: forall v1 v2 st ctx, value v1 -> value v2 -> SN st ctx (ESnd (EPair v1 v2))
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; snd_value_SN [partial: bindings preserved]

; if_bool_SN (matches Coq: Lemma if_bool_SN)
; if_bool_SN: forall b e2 e3 st ctx, SN st ctx e2 -> SN st ctx e3 -> SN st ctx (EIf (EBool b) e2 e3)
(assert (forall ((b Bool) (e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_bool_SN [partial: bindings preserved]

; let_value_SN (matches Coq: Lemma let_value_SN)
; let_value_SN: forall x v e2 st ctx, value v -> SN st ctx (subst[x := v] e2) -> SN st ctx (ELet x v e2)
(assert (forall ((x Bool) (v Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; let_value_SN [partial: bindings preserved]

; app_lam_value_SN (matches Coq: Lemma app_lam_value_SN)
; app_lam_value_SN: forall x T body v st ctx, value v -> SN st ctx (subst[x := v] body) -> SN st ctx (EApp (ELam x T body) v)
(assert (forall ((x Bool) (T Bool) (body Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; app_lam_value_SN [partial: bindings preserved]

; handle_value_SN (matches Coq: Lemma handle_value_SN)
; handle_value_SN: forall x v h st ctx, value v -> SN st ctx (subst[x := v] h) -> SN st ctx (EHandle v x h)
(assert (forall ((x Bool) (v Bool) (h Bool) (st Bool) (ctx Bool)) (= 0 0))) ; handle_value_SN [partial: bindings preserved]

; case_inl_value_SN (matches Coq: Lemma case_inl_value_SN)
; case_inl_value_SN: forall v T x1 e1 x2 e2 st ctx, value v -> SN st ctx (subst[x1 := v] e1) -> SN st ctx (ECase (EInl v T) x1 e1 x2 e2)
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inl_value_SN [partial: bindings preserved]

; case_inr_value_SN (matches Coq: Lemma case_inr_value_SN)
; case_inr_value_SN: forall v T x1 e1 x2 e2 st ctx, value v -> SN st ctx (subst[x2 := v] e2) -> SN st ctx (ECase (EInr v T) x1 e1 x2 e2)
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inr_value_SN [partial: bindings preserved]

; classify_value_strongly_normalizing (matches Coq: Lemma classify_value_strongly_normalizing)
; classify_value_strongly_normalizing: forall v st ctx, value v -> SN st ctx (EClassify v)
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; classify_value_strongly_normalizing [partial: bindings preserved]

; declassify_classify_SN (matches Coq: Lemma declassify_classify_SN)
; declassify_classify_SN: forall v p st ctx, value v -> declass_ok (EClassify v) p -> SN st ctx v -> SN st ctx (EDeclassify (EClassify v) p)
(assert (forall ((v Bool) (p Bool) (st Bool) (ctx Bool)) (= 0 0))) ; declassify_classify_SN [partial: bindings preserved]

; fst_fst_pair_SN (matches Coq: Lemma fst_fst_pair_SN)
; fst_fst_pair_SN: forall a b c d st ctx, value a -> value b -> value c -> value d -> SN st ctx (EFst (EFst (EPair (EPair a b) (EPair c d))
(assert (forall ((a Bool) (b Bool) (c Bool) (d Bool) (st Bool) (ctx Bool)) (= 0 0))) ; fst_fst_pair_SN [partial: bindings preserved]

; perform_value_SN (matches Coq: Lemma perform_value_SN)
; perform_value_SN: forall eff v st ctx, value v -> SN st ctx (EPerform eff v)
(assert (forall ((eff Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; perform_value_SN [partial: bindings preserved]

; require_value_SN (matches Coq: Lemma require_value_SN)
; require_value_SN: forall eff v st ctx, value v -> SN st ctx (ERequire eff v)
(assert (forall ((eff Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; require_value_SN [partial: bindings preserved]

; grant_value_SN (matches Coq: Lemma grant_value_SN)
; grant_value_SN: forall eff v st ctx, value v -> SN st ctx (EGrant eff v)
(assert (forall ((eff Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; grant_value_SN [partial: bindings preserved]

; pair_value_SN (matches Coq: Lemma pair_value_SN)
; pair_value_SN: forall v1 v2 st ctx, value v1 -> value v2 -> SN st ctx (EPair v1 v2)
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; pair_value_SN [partial: bindings preserved]

; inl_value_SN (matches Coq: Lemma inl_value_SN)
; inl_value_SN: forall v T st ctx, value v -> SN st ctx (EInl v T)
(assert (forall ((v Bool) (T Bool) (st Bool) (ctx Bool)) (= 0 0))) ; inl_value_SN [partial: bindings preserved]

; inr_value_SN (matches Coq: Lemma inr_value_SN)
; inr_value_SN: forall v T st ctx, value v -> SN st ctx (EInr v T)
(assert (forall ((v Bool) (T Bool) (st Bool) (ctx Bool)) (= 0 0))) ; inr_value_SN [partial: bindings preserved]

; prove_value_SN (matches Coq: Lemma prove_value_SN)
; prove_value_SN: forall v st ctx, value v -> SN st ctx (EProve v)
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; prove_value_SN [partial: bindings preserved]

; snd_snd_pair_SN (matches Coq: Lemma snd_snd_pair_SN)
; snd_snd_pair_SN: forall a b c d st ctx, value a -> value b -> value c -> value d -> SN st ctx (ESnd (ESnd (EPair (EPair a b) (EPair c d))
(assert (forall ((a Bool) (b Bool) (c Bool) (d Bool) (st Bool) (ctx Bool)) (= 0 0))) ; snd_snd_pair_SN [partial: bindings preserved]

; fst_snd_pair_SN (matches Coq: Lemma fst_snd_pair_SN)
; fst_snd_pair_SN: forall a b c d st ctx, value a -> value b -> value c -> value d -> SN st ctx (EFst (ESnd (EPair (EPair a b) (EPair c d))
(assert (forall ((a Bool) (b Bool) (c Bool) (d Bool) (st Bool) (ctx Bool)) (= 0 0))) ; fst_snd_pair_SN [partial: bindings preserved]

; snd_fst_pair_SN (matches Coq: Lemma snd_fst_pair_SN)
; snd_fst_pair_SN: forall a b c d st ctx, value a -> value b -> value c -> value d -> SN st ctx (ESnd (EFst (EPair (EPair a b) (EPair c d))
(assert (forall ((a Bool) (b Bool) (c Bool) (d Bool) (st Bool) (ctx Bool)) (= 0 0))) ; snd_fst_pair_SN [partial: bindings preserved]

; fst_fst_nested_SN (matches Coq: Lemma fst_fst_nested_SN)
; fst_fst_nested_SN: forall a b c st ctx, value a -> value b -> value c -> SN st ctx (EFst (EFst (EPair (EPair a b) c)))
(assert (forall ((a Bool) (b Bool) (c Bool) (st Bool) (ctx Bool)) (= 0 0))) ; fst_fst_nested_SN [partial: bindings preserved]

; classify_classify_SN (matches Coq: Lemma classify_classify_SN)
; classify_classify_SN: forall v st ctx, value v -> SN st ctx (EClassify (EClassify v))
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; classify_classify_SN [partial: bindings preserved]

; prove_prove_SN (matches Coq: Lemma prove_prove_SN)
; prove_prove_SN: forall v st ctx, value v -> SN st ctx (EProve (EProve v))
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; prove_prove_SN [partial: bindings preserved]

; nested_pair_value_SN (matches Coq: Lemma nested_pair_value_SN)
; nested_pair_value_SN: forall a b c d st ctx, value a -> value b -> value c -> value d -> SN st ctx (EPair (EPair a b) (EPair c d))
(assert (forall ((a Bool) (b Bool) (c Bool) (d Bool) (st Bool) (ctx Bool)) (= 0 0))) ; nested_pair_value_SN [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
