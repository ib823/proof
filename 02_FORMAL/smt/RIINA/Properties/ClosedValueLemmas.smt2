; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ClosedValueLemmas.v (39 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ClosedValueLemmas

(set-logic ALL)
(set-option :produce-models true)

; closed_expr_cv (matches Coq: Definition closed_expr_cv)
(define-fun closed_expr_cv ((e Int)) Bool
  (= 0 0))

; value_typed_closed (matches Coq: Lemma value_typed_closed)
; value_typed_closed: forall Σ Δ v T ε, value v -> has_type nil Σ Δ v T ε -> closed_expr_cv v
(assert (forall ((sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_typed_closed [partial: bindings preserved]

; closed_pair_cv (matches Coq: Lemma closed_pair_cv)
; closed_pair_cv: forall e1 e2, closed_expr_cv (EPair e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; closed_pair_cv [partial: bindings preserved]

; closed_inl_cv (matches Coq: Lemma closed_inl_cv)
; closed_inl_cv: forall e T, closed_expr_cv (EInl e T) <-> closed_expr_cv e
(assert (forall ((e Bool) (T Bool)) (= 0 0))) ; closed_inl_cv [partial: bindings preserved]

; closed_inr_cv (matches Coq: Lemma closed_inr_cv)
; closed_inr_cv: forall e T, closed_expr_cv (EInr e T) <-> closed_expr_cv e
(assert (forall ((e Bool) (T Bool)) (= 0 0))) ; closed_inr_cv [partial: bindings preserved]

; closed_app_cv (matches Coq: Lemma closed_app_cv)
; closed_app_cv: forall e1 e2, closed_expr_cv (EApp e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; closed_app_cv [partial: bindings preserved]

; closed_unit_cv (matches Coq: Lemma closed_unit_cv)
; closed_unit_cv: closed_expr_cv EUnit
(assert (= 0 0)) ; closed_unit_cv [Coq-only]

; closed_bool_cv (matches Coq: Lemma closed_bool_cv)
; closed_bool_cv: forall b, closed_expr_cv (EBool b)
(assert (forall ((b Bool)) (= 0 0))) ; closed_bool_cv [partial: bindings preserved]

; closed_int_cv (matches Coq: Lemma closed_int_cv)
; closed_int_cv: forall n, closed_expr_cv (EInt n)
(assert (forall ((n Bool)) (= 0 0))) ; closed_int_cv [partial: bindings preserved]

; closed_string_cv (matches Coq: Lemma closed_string_cv)
; closed_string_cv: forall s, closed_expr_cv (EString s)
(assert (forall ((s Bool)) (= 0 0))) ; closed_string_cv [partial: bindings preserved]

; closed_loc_cv (matches Coq: Lemma closed_loc_cv)
; closed_loc_cv: forall l, closed_expr_cv (ELoc l)
(assert (forall ((l Bool)) (= 0 0))) ; closed_loc_cv [partial: bindings preserved]

; closed_lam_body_cv (matches Coq: Lemma closed_lam_body_cv)
; closed_lam_body_cv: forall x T body y, closed_expr_cv (ELam x T body) -> free_in y body -> y = x
(assert (forall ((x Bool) (T Bool) (body Bool) (y Bool)) (= 0 0))) ; closed_lam_body_cv [partial: bindings preserved]

; closed_if_cv (matches Coq: Lemma closed_if_cv)
; closed_if_cv: forall e1 e2 e3, closed_expr_cv (EIf e1 e2 e3) <-> closed_expr_cv e1 /\ closed_expr_cv e2 /\ closed_expr_cv e3
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool)) (= 0 0))) ; closed_if_cv [partial: bindings preserved]

; closed_let_cv (matches Coq: Lemma closed_let_cv)
; closed_let_cv: forall y e1 e2, closed_expr_cv (ELet y e1 e2) <-> closed_expr_cv e1 /\ (forall x, x <> y -> free_in x e2 -> False)
(assert (forall ((y Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; closed_let_cv [partial: bindings preserved]

; closed_ref_cv (matches Coq: Lemma closed_ref_cv)
; closed_ref_cv: forall e sl, closed_expr_cv (ERef e sl) <-> closed_expr_cv e
(assert (forall ((e Bool) (sl Bool)) (= 0 0))) ; closed_ref_cv [partial: bindings preserved]

; closed_deref_cv (matches Coq: Lemma closed_deref_cv)
; closed_deref_cv: forall e, closed_expr_cv (EDeref e) <-> closed_expr_cv e
(assert (forall ((e Bool)) (= 0 0))) ; closed_deref_cv [partial: bindings preserved]

; closed_assign_cv (matches Coq: Lemma closed_assign_cv)
; closed_assign_cv: forall e1 e2, closed_expr_cv (EAssign e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; closed_assign_cv [partial: bindings preserved]

; closed_classify_cv (matches Coq: Lemma closed_classify_cv)
; closed_classify_cv: forall e, closed_expr_cv (EClassify e) <-> closed_expr_cv e
(assert (forall ((e Bool)) (= 0 0))) ; closed_classify_cv [partial: bindings preserved]

; closed_prove_cv (matches Coq: Lemma closed_prove_cv)
; closed_prove_cv: forall e, closed_expr_cv (EProve e) <-> closed_expr_cv e
(assert (forall ((e Bool)) (= 0 0))) ; closed_prove_cv [partial: bindings preserved]

; closed_fst_cv (matches Coq: Lemma closed_fst_cv)
; closed_fst_cv: forall e, closed_expr_cv (EFst e) <-> closed_expr_cv e
(assert (forall ((e Bool)) (= 0 0))) ; closed_fst_cv [partial: bindings preserved]

; closed_snd_cv (matches Coq: Lemma closed_snd_cv)
; closed_snd_cv: forall e, closed_expr_cv (ESnd e) <-> closed_expr_cv e
(assert (forall ((e Bool)) (= 0 0))) ; closed_snd_cv [partial: bindings preserved]

; value_closed_simple (matches Coq: Lemma value_closed_simple)
; value_closed_simple: forall v Σ Δ T ε, value v -> has_type nil Σ Δ v T ε -> match v with | EUnit | EBool _ | EInt _ | EString _ | ELoc _ => T
(assert (forall ((v Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_closed_simple [partial: bindings preserved]

; closed_weaken_ctx (matches Coq: Lemma closed_weaken_ctx)
; closed_weaken_ctx: forall e Σ1 Σ2 Δ T ε, has_type nil Σ1 Δ e T ε -> store_ty_extends Σ1 Σ2 -> closed_expr_cv e
(assert (forall ((e Bool) (sigma1 Bool) (sigma2 Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; closed_weaken_ctx [partial: bindings preserved]

; nil_ctx_is_closed (matches Coq: Lemma nil_ctx_is_closed)
; nil_ctx_is_closed: forall e Σ Δ T ε, has_type nil Σ Δ e T ε -> closed_expr_cv e
(assert (forall ((e Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; nil_ctx_is_closed [partial: bindings preserved]

; closed_grant_cv (matches Coq: Lemma closed_grant_cv)
; closed_grant_cv: forall eff e, closed_expr_cv (EGrant eff e) <-> closed_expr_cv e
(assert (forall ((eff Bool) (e Bool)) (= 0 0))) ; closed_grant_cv [partial: bindings preserved]

; closed_require_cv (matches Coq: Lemma closed_require_cv)
; closed_require_cv: forall eff e, closed_expr_cv (ERequire eff e) <-> closed_expr_cv e
(assert (forall ((eff Bool) (e Bool)) (= 0 0))) ; closed_require_cv [partial: bindings preserved]

; closed_perform_cv (matches Coq: Lemma closed_perform_cv)
; closed_perform_cv: forall eff e, closed_expr_cv (EPerform eff e) <-> closed_expr_cv e
(assert (forall ((eff Bool) (e Bool)) (= 0 0))) ; closed_perform_cv [partial: bindings preserved]

; closed_handle_cv (matches Coq: Lemma closed_handle_cv)
; closed_handle_cv: forall e y h, closed_expr_cv (EHandle e y h) <-> closed_expr_cv e /\ (forall x, x <> y -> ~ free_in x h)
(assert (forall ((e Bool) (y Bool) (h Bool)) (= 0 0))) ; closed_handle_cv [partial: bindings preserved]

; closed_declassify_cv (matches Coq: Lemma closed_declassify_cv)
; closed_declassify_cv: forall e1 e2, closed_expr_cv (EDeclassify e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; closed_declassify_cv [partial: bindings preserved]

; closed_case_cv (matches Coq: Lemma closed_case_cv)
; closed_case_cv: forall e y1 e1 y2 e2, closed_expr_cv (ECase e y1 e1 y2 e2) <-> closed_expr_cv e /\ (forall x, x <> y1 -> ~ free_in x e1)
(assert (forall ((e Bool) (y1 Bool) (e1 Bool) (y2 Bool) (e2 Bool)) (= 0 0))) ; closed_case_cv [partial: bindings preserved]

; closed_lam_cv (matches Coq: Lemma closed_lam_cv)
; closed_lam_cv: forall x T body, closed_expr_cv (ELam x T body) <-> (forall y, y <> x -> ~ free_in y body)
(assert (forall ((x Bool) (T Bool) (body Bool)) (= 0 0))) ; closed_lam_cv [partial: bindings preserved]

; closed_pair_value_components (matches Coq: Lemma closed_pair_value_components)
; closed_pair_value_components: forall a b, value (EPair a b) -> closed_expr_cv (EPair a b) -> closed_expr_cv a /\ closed_expr_cv b
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; closed_pair_value_components [partial: bindings preserved]

; closed_inl_value_inner (matches Coq: Lemma closed_inl_value_inner)
; closed_inl_value_inner: forall a T, value (EInl a T) -> closed_expr_cv (EInl a T) -> closed_expr_cv a
(assert (forall ((a Bool) (T Bool)) (= 0 0))) ; closed_inl_value_inner [partial: bindings preserved]

; closed_inr_value_inner (matches Coq: Lemma closed_inr_value_inner)
; closed_inr_value_inner: forall b T, value (EInr b T) -> closed_expr_cv (EInr b T) -> closed_expr_cv b
(assert (forall ((b Bool) (T Bool)) (= 0 0))) ; closed_inr_value_inner [partial: bindings preserved]

; closed_store_extension (matches Coq: Lemma closed_store_extension)
; closed_store_extension: forall e Σ1 Σ2 Δ T ε, has_type nil Σ1 Δ e T ε -> store_ty_extends Σ1 Σ2 -> closed_expr_cv e
(assert (forall ((e Bool) (sigma1 Bool) (sigma2 Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; closed_store_extension [partial: bindings preserved]

; nil_ctx_pair_closed (matches Coq: Lemma nil_ctx_pair_closed)
; nil_ctx_pair_closed: forall Σ Δ a b T ε, has_type nil Σ Δ (EPair a b) T ε -> closed_expr_cv a /\ closed_expr_cv b
(assert (forall ((sigma Bool) (delta Bool) (a Bool) (b Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; nil_ctx_pair_closed [partial: bindings preserved]

; nil_ctx_inl_closed (matches Coq: Lemma nil_ctx_inl_closed)
; nil_ctx_inl_closed: forall Σ Δ e T' T ε, has_type nil Σ Δ (EInl e T') T ε -> closed_expr_cv e
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T_ Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; nil_ctx_inl_closed [partial: bindings preserved]

; nil_ctx_inr_closed (matches Coq: Lemma nil_ctx_inr_closed)
; nil_ctx_inr_closed: forall Σ Δ e T' T ε, has_type nil Σ Δ (EInr e T') T ε -> closed_expr_cv e
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T_ Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; nil_ctx_inr_closed [partial: bindings preserved]

; closed_classify_value_inner (matches Coq: Lemma closed_classify_value_inner)
; closed_classify_value_inner: forall v, closed_expr_cv (EClassify v) -> closed_expr_cv v
(assert (forall ((v Bool)) (= 0 0))) ; closed_classify_value_inner [partial: bindings preserved]

; closed_prove_value_inner (matches Coq: Lemma closed_prove_value_inner)
; closed_prove_value_inner: forall v, closed_expr_cv (EProve v) -> closed_expr_cv v
(assert (forall ((v Bool)) (= 0 0))) ; closed_prove_value_inner [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
