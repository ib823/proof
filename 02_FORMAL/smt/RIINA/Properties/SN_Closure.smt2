; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/SN_Closure.v (46 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SN_Closure

(set-logic ALL)
(set-option :produce-models true)

; step_inv (matches Coq: Definition step_inv)
(define-fun step_inv ((cfg1 Int) (cfg2 Int)) Bool
  (= 0 0))

; SN (matches Coq: Definition SN)
(define-fun SN ((cfg Int)) Bool
  (= 0 0))

; SN_expr (matches Coq: Definition SN_expr)
(define-fun SN_expr ((e Int)) Bool
  (= 0 0))

; direct_lambda_SN (matches Coq: Definition direct_lambda_SN)
(define-fun direct_lambda_SN ((e1 Int)) Bool
  (= 0 0))

; family_lambda_SN (matches Coq: Definition family_lambda_SN)
(define-fun family_lambda_SN ((e1 Int)) Bool
  (= 0 0))

; store_wf (matches Coq: Definition store_wf)
(define-fun store_wf ((st Int)) Bool
  (= 0 0))

; SN_step (matches Coq: Lemma SN_step)
; SN_step: forall e st ctx e' st' ctx', SN (e, st, ctx) -> (e, st, ctx) --> (e', st', ctx') -> SN (e', st', ctx')
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (= 0 0))) ; SN_step [partial: bindings preserved]

; value_not_step (matches Coq: Lemma value_not_step)
; value_not_step: forall v st ctx e' st' ctx', value v -> (v, st, ctx) --> (e', st', ctx') -> False
(assert (forall ((v Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (= 0 0))) ; value_not_step [partial: bindings preserved]

; value_SN (matches Coq: Lemma value_SN)
; value_SN: forall v st ctx, value v -> SN (v, st, ctx)
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; value_SN [partial: bindings preserved]

; SN_all_reducts (matches Coq: Lemma SN_all_reducts)
; SN_all_reducts: forall e st ctx, SN (e, st, ctx) -> forall e' st' ctx', (e, st, ctx) --> (e', st', ctx') -> SN (e', st', ctx')
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_all_reducts [partial: bindings preserved]

; SN_app_value_left_aux (matches Coq: Lemma SN_app_value_left_aux)
; SN_app_value_left_aux: forall v cfg, value v -> SN cfg -> (forall x body v' st' ctx', value v' -> SN (subst[x := v'] body, st', ctx')) -> SN (E
(assert (forall ((v Bool) (cfg Bool)) (= 0 0))) ; SN_app_value_left_aux [partial: bindings preserved]

; SN_app_value_left (matches Coq: Lemma SN_app_value_left)
; SN_app_value_left: forall v e2 st ctx, value v -> SN (e2, st, ctx) -> (forall x body v' st' ctx', value v' -> SN (subst[x := v'] body, st',
(assert (forall ((v Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_app_value_left [partial: bindings preserved]

; SN_app_aux (matches Coq: Lemma SN_app_aux)
; SN_app_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> (forall x body v st' ctx', value v -> SN (subst[x := v] bo
(assert (forall ((cfg Bool) (e2 Bool)) (= 0 0))) ; SN_app_aux [partial: bindings preserved]

; SN_app (matches Coq: Lemma SN_app)
; SN_app: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> (forall x body v 
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_app [partial: bindings preserved]

; SN_app_value_left_direct_aux (matches Coq: Lemma SN_app_value_left_direct_aux)
; SN_app_value_left_direct_aux: forall f cfg, value f -> SN cfg -> direct_lambda_SN f -> SN (EApp f (fst (fst cfg)), snd (fst cfg), snd cfg)
(assert (forall ((f Bool) (cfg Bool)) (= 0 0))) ; SN_app_value_left_direct_aux [partial: bindings preserved]

; SN_app_value_left_direct (matches Coq: Lemma SN_app_value_left_direct)
; SN_app_value_left_direct: forall f e2 st ctx, value f -> SN (e2, st, ctx) -> direct_lambda_SN f -> SN (EApp f e2, st, ctx)
(assert (forall ((f Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_app_value_left_direct [partial: bindings preserved]

; family_lambda_SN_step (matches Coq: Lemma family_lambda_SN_step)
; family_lambda_SN_step: forall e1 e1' st ctx st' ctx', (e1, st, ctx) --> (e1', st', ctx') -> family_lambda_SN e1 -> family_lambda_SN e1'
(assert (forall ((e1 Bool) (e1_ Bool) (st Bool) (ctx Bool) (st_ Bool) (ctx_ Bool)) (= 0 0))) ; family_lambda_SN_step [partial: bindings preserved]

; SN_app_value_left_family_aux (matches Coq: Lemma SN_app_value_left_family_aux)
; SN_app_value_left_family_aux: forall f cfg, value f -> SN cfg -> direct_lambda_SN f -> SN (EApp f (fst (fst cfg)), snd (fst cfg), snd cfg)
(assert (forall ((f Bool) (cfg Bool)) (= 0 0))) ; SN_app_value_left_family_aux [partial: bindings preserved]

; SN_app_family_aux (matches Coq: Lemma SN_app_family_aux)
; SN_app_family_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> family_lambda_SN (fst (fst cfg)) -> SN (EApp (fst (fst cfg
(assert (forall ((cfg Bool) (e2 Bool)) (= 0 0))) ; SN_app_family_aux [partial: bindings preserved]

; SN_app_family (matches Coq: Lemma SN_app_family)
; SN_app_family: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> family_lambda_SN 
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_app_family [partial: bindings preserved]

; SN_pair_value_left_aux (matches Coq: Lemma SN_pair_value_left_aux)
; SN_pair_value_left_aux: forall v cfg, value v -> SN cfg -> SN (EPair v (fst (fst cfg)), snd (fst cfg), snd cfg)
(assert (forall ((v Bool) (cfg Bool)) (= 0 0))) ; SN_pair_value_left_aux [partial: bindings preserved]

; SN_pair_value_left (matches Coq: Lemma SN_pair_value_left)
; SN_pair_value_left: forall v e2 st ctx, value v -> SN (e2, st, ctx) -> SN (EPair v e2, st, ctx)
(assert (forall ((v Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_pair_value_left [partial: bindings preserved]

; SN_pair_aux (matches Coq: Lemma SN_pair_aux)
; SN_pair_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> SN (EPair (fst (fst cfg)) e2, snd (fst cfg), snd cfg)
(assert (forall ((cfg Bool) (e2 Bool)) (= 0 0))) ; SN_pair_aux [partial: bindings preserved]

; SN_pair (matches Coq: Lemma SN_pair)
; SN_pair: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> SN (EPair e1 e2, 
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_pair [partial: bindings preserved]

; SN_fst_aux (matches Coq: Lemma SN_fst_aux)
; SN_fst_aux: forall cfg, SN cfg -> SN (EFst (fst (fst cfg)), snd (fst cfg), snd cfg)
(assert (forall ((cfg Bool)) (= 0 0))) ; SN_fst_aux [partial: bindings preserved]

; SN_fst (matches Coq: Lemma SN_fst)
; SN_fst: forall e st ctx, SN (e, st, ctx) -> SN (EFst e, st, ctx)
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_fst [partial: bindings preserved]

; SN_snd_aux (matches Coq: Lemma SN_snd_aux)
; SN_snd_aux: forall cfg, SN cfg -> SN (ESnd (fst (fst cfg)), snd (fst cfg), snd cfg)
(assert (forall ((cfg Bool)) (= 0 0))) ; SN_snd_aux [partial: bindings preserved]

; SN_snd (matches Coq: Lemma SN_snd)
; SN_snd: forall e st ctx, SN (e, st, ctx) -> SN (ESnd e, st, ctx)
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_snd [partial: bindings preserved]

; SN_inl_aux (matches Coq: Lemma SN_inl_aux)
; SN_inl_aux: forall cfg T, SN cfg -> SN (EInl (fst (fst cfg)) T, snd (fst cfg), snd cfg)
(assert (forall ((cfg Bool) (T Bool)) (= 0 0))) ; SN_inl_aux [partial: bindings preserved]

; SN_inl (matches Coq: Lemma SN_inl)
; SN_inl: forall e T st ctx, SN (e, st, ctx) -> SN (EInl e T, st, ctx)
(assert (forall ((e Bool) (T Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_inl [partial: bindings preserved]

; SN_inr_aux (matches Coq: Lemma SN_inr_aux)
; SN_inr_aux: forall cfg T, SN cfg -> SN (EInr (fst (fst cfg)) T, snd (fst cfg), snd cfg)
(assert (forall ((cfg Bool) (T Bool)) (= 0 0))) ; SN_inr_aux [partial: bindings preserved]

; SN_inr (matches Coq: Lemma SN_inr)
; SN_inr: forall e T st ctx, SN (e, st, ctx) -> SN (EInr e T, st, ctx)
(assert (forall ((e Bool) (T Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_inr [partial: bindings preserved]

; SN_case_aux (matches Coq: Lemma SN_case_aux)
; SN_case_aux: forall cfg x1 e1 x2 e2, SN cfg -> (forall v st' ctx', value v -> SN (subst[x1 := v] e1, st', ctx')) -> (forall v st' ctx
(assert (forall ((cfg Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool)) (= 0 0))) ; SN_case_aux [partial: bindings preserved]

; SN_case (matches Coq: Lemma SN_case)
; SN_case: forall e x1 e1 x2 e2 st ctx, SN (e, st, ctx) -> (forall v st' ctx', value v -> SN (subst[x1 := v] e1, st', ctx')) -> (fo
(assert (forall ((e Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_case [partial: bindings preserved]

; SN_if_aux (matches Coq: Lemma SN_if_aux)
; SN_if_aux: forall cfg e2 e3, SN cfg -> (forall st' ctx', SN (e2, st', ctx')) -> (forall st' ctx', SN (e3, st', ctx')) -> SN (EIf (f
(assert (forall ((cfg Bool) (e2 Bool) (e3 Bool)) (= 0 0))) ; SN_if_aux [partial: bindings preserved]

; SN_if (matches Coq: Lemma SN_if)
; SN_if: forall e1 e2 e3 st ctx, SN (e1, st, ctx) -> (forall st' ctx', SN (e2, st', ctx')) -> (forall st' ctx', SN (e3, st', ctx'
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_if [partial: bindings preserved]

; SN_let_aux (matches Coq: Lemma SN_let_aux)
; SN_let_aux: forall cfg x e2, SN cfg -> (forall v st' ctx', value v -> SN (subst[x := v] e2, st', ctx')) -> SN (ELet x (fst (fst cfg)
(assert (forall ((cfg Bool) (x Bool) (e2 Bool)) (= 0 0))) ; SN_let_aux [partial: bindings preserved]

; SN_let (matches Coq: Lemma SN_let)
; SN_let: forall x e1 e2 st ctx, SN (e1, st, ctx) -> (forall v st' ctx', value v -> SN (subst[x := v] e2, st', ctx')) -> SN (ELet 
(assert (forall ((x Bool) (e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_let [partial: bindings preserved]

; SN_ref_aux (matches Coq: Lemma SN_ref_aux)
; SN_ref_aux: forall cfg sl, SN cfg -> SN (ERef (fst (fst cfg)) sl, snd (fst cfg), snd cfg)
(assert (forall ((cfg Bool) (sl Bool)) (= 0 0))) ; SN_ref_aux [partial: bindings preserved]

; SN_ref (matches Coq: Lemma SN_ref)
; SN_ref: forall e sl st ctx, SN (e, st, ctx) -> SN (ERef e sl, st, ctx)
(assert (forall ((e Bool) (sl Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_ref [partial: bindings preserved]

; store_wf_nil (matches Coq: Lemma store_wf_nil)
; store_wf_nil: store_wf nil
(assert (= 0 0)) ; store_wf_nil [Coq-only]

; store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
; store_lookup_update_eq: forall l v st, store_lookup l (store_update l v st) = Some v
(assert (forall ((l Bool) (v Bool) (st Bool)) (= 0 0))) ; store_lookup_update_eq [partial: bindings preserved]

; store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
; store_lookup_update_neq: forall l0 l v st, l0 <> l -> store_lookup l0 (store_update l v st) = store_lookup l0 st
(assert (forall ((l0 Bool) (l Bool) (v Bool) (st Bool)) (= 0 0))) ; store_lookup_update_neq [partial: bindings preserved]

; store_update_preserves_wf (matches Coq: Lemma store_update_preserves_wf)
; store_update_preserves_wf: forall st l v, store_wf st -> value v -> store_wf (store_update l v st)
(assert (forall ((st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_update_preserves_wf [partial: bindings preserved]

; step_preserves_store_wf (matches Coq: Lemma step_preserves_store_wf)
; step_preserves_store_wf: forall e st ctx e' st' ctx', store_wf st -> (e, st, ctx) --> (e', st', ctx') -> store_wf st'
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (= 0 0))) ; step_preserves_store_wf [partial: bindings preserved]

; SN_deref_aux (matches Coq: Lemma SN_deref_aux)
; SN_deref_aux: forall cfg, SN cfg -> (forall l v st', store_lookup l st' = Some v -> value v) -> SN (EDeref (fst (fst cfg)), snd (fst c
(assert (forall ((cfg Bool)) (= 0 0))) ; SN_deref_aux [partial: bindings preserved]

; SN_deref (matches Coq: Lemma SN_deref)
; SN_deref: forall e st ctx, SN (e, st, ctx) -> (forall l v st', store_lookup l st' = Some v -> value v) -> SN (EDeref e, st, ctx)
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_deref [partial: bindings preserved]

; SN_assign_value_left_aux (matches Coq: Lemma SN_assign_value_left_aux)
; SN_assign_value_left_aux: forall v cfg, value v -> SN cfg -> SN (EAssign v (fst (fst cfg)), snd (fst cfg), snd cfg)
(assert (forall ((v Bool) (cfg Bool)) (= 0 0))) ; SN_assign_value_left_aux [partial: bindings preserved]

; SN_assign_aux (matches Coq: Lemma SN_assign_aux)
; SN_assign_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> SN (EAssign (fst (fst cfg)) e2, snd (fst cfg), snd cfg)
(assert (forall ((cfg Bool) (e2 Bool)) (= 0 0))) ; SN_assign_aux [partial: bindings preserved]

; SN_assign (matches Coq: Lemma SN_assign)
; SN_assign: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> SN (EAssign e1 e2
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_assign [partial: bindings preserved]

; SN_handle_aux (matches Coq: Lemma SN_handle_aux)
; SN_handle_aux: forall cfg x h, SN cfg -> (forall v st' ctx', value v -> SN (subst[x := v] h, st', ctx')) -> SN (EHandle (fst (fst cfg))
(assert (forall ((cfg Bool) (x Bool) (h Bool)) (= 0 0))) ; SN_handle_aux [partial: bindings preserved]

; SN_handle (matches Coq: Lemma SN_handle)
; SN_handle: forall e x h st ctx, SN (e, st, ctx) -> (forall v st' ctx', value v -> SN (subst[x := v] h, st', ctx')) -> SN (EHandle e
(assert (forall ((e Bool) (x Bool) (h Bool) (st Bool) (ctx Bool)) (= 0 0))) ; SN_handle [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
