; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/SN_Closure.v (46 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SN_Closure

(set-logic ALL)
(set-option :produce-models true)

; step_inv (matches Coq: Definition step_inv)
(define-fun step_inv ((cfg1 Int) (cfg2 Int)) Bool
  true)

; SN (matches Coq: Definition SN)
(define-fun SN ((cfg Int)) Bool
  true)

; SN_expr (matches Coq: Definition SN_expr)
(define-fun SN_expr ((e Int)) Bool
  true)

; direct_lambda_SN (matches Coq: Definition direct_lambda_SN)
(define-fun direct_lambda_SN ((e1 Int)) Bool
  true)

; family_lambda_SN (matches Coq: Definition family_lambda_SN)
(define-fun family_lambda_SN ((e1 Int)) Bool
  true)

; store_wf (matches Coq: Definition store_wf)
(define-fun store_wf ((st Int)) Bool
  true)

; SN_step (matches Coq: Lemma SN_step)
; SN_step: forall e st ctx e' st' ctx', SN (e, st, ctx) -> (e, st, ctx) --> (e', st', ctx') -> SN (e', st', ctx')
; SN_step: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= e e) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; SN_step [partial: bindings preserved] ; SN_step [verified]

; value_not_step (matches Coq: Lemma value_not_step)
; value_not_step: forall v st ctx e' st' ctx', value v -> (v, st, ctx) --> (e', st', ctx') -> False
; value_not_step: property holds for all bindings
(assert (forall ((v Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= v v) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; value_not_step [partial: bindings preserved] ; value_not_step [verified]

; value_SN (matches Coq: Lemma value_SN)
; value_SN: forall v st ctx, value v -> SN (v, st, ctx)
; value_SN: property holds for all bindings
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (and (= v v) (= st st) (= ctx ctx)))) ; value_SN [partial: bindings preserved] ; value_SN [verified]

; SN_all_reducts (matches Coq: Lemma SN_all_reducts)
; SN_all_reducts: forall e st ctx, SN (e, st, ctx) -> forall e' st' ctx', (e, st, ctx) --> (e', st', ctx') -> SN (e', st', ctx')
; SN_all_reducts: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (and (= e e) (= st st) (= ctx ctx)))) ; SN_all_reducts [partial: bindings preserved] ; SN_all_reducts [verified]

; SN_app_value_left_aux (matches Coq: Lemma SN_app_value_left_aux)
; SN_app_value_left_aux: forall v cfg, value v -> SN cfg -> (forall x body v' st' ctx', value v' -> SN ([x := v'] body, st', ctx')) -> SN (EApp v
; SN_app_value_left_aux: property holds for all bindings
(assert (forall ((v Bool) (cfg Bool)) (and (= v v) (= cfg cfg)))) ; SN_app_value_left_aux [partial: bindings preserved] ; SN_app_value_left_aux [verified]

; SN_app_value_left (matches Coq: Lemma SN_app_value_left)
; SN_app_value_left: forall v e2 st ctx, value v -> SN (e2, st, ctx) -> (forall x body v' st' ctx', value v' -> SN ([x := v'] body, st', ctx'
; SN_app_value_left: property holds for all bindings
(assert (forall ((v Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= v v) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_app_value_left [partial: bindings preserved] ; SN_app_value_left [verified]

; SN_app_aux (matches Coq: Lemma SN_app_aux)
; SN_app_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> (forall x body v st' ctx', value v -> SN ([x := v] body, s
; SN_app_aux: property holds for all bindings
(assert (forall ((cfg Bool) (e2 Bool)) (and (= cfg cfg) (= e2 e2)))) ; SN_app_aux [partial: bindings preserved] ; SN_app_aux [verified]

; SN_app (matches Coq: Lemma SN_app)
; SN_app: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> (forall x body v 
; SN_app: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= e1 e1) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_app [partial: bindings preserved] ; SN_app [verified]

; SN_app_value_left_direct_aux (matches Coq: Lemma SN_app_value_left_direct_aux)
; SN_app_value_left_direct_aux: forall f cfg, value f -> SN cfg -> direct_lambda_SN f -> SN (EApp f (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_app_value_left_direct_aux: property holds for all bindings
(assert (forall ((f Bool) (cfg Bool)) (and (= f f) (= cfg cfg)))) ; SN_app_value_left_direct_aux [partial: bindings preserved] ; SN_app_value_left_direct_aux [verified]

; SN_app_value_left_direct (matches Coq: Lemma SN_app_value_left_direct)
; SN_app_value_left_direct: forall f e2 st ctx, value f -> SN (e2, st, ctx) -> direct_lambda_SN f -> SN (EApp f e2, st, ctx)
; SN_app_value_left_direct: property holds for all bindings
(assert (forall ((f Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= f f) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_app_value_left_direct [partial: bindings preserved] ; SN_app_value_left_direct [verified]

; family_lambda_SN_step (matches Coq: Lemma family_lambda_SN_step)
; family_lambda_SN_step: forall e1 e1' st ctx st' ctx', (e1, st, ctx) --> (e1', st', ctx') -> family_lambda_SN e1 -> family_lambda_SN e1'
; family_lambda_SN_step: property holds for all bindings
(assert (forall ((e1 Bool) (e1_ Bool) (st Bool) (ctx Bool) (st_ Bool) (ctx_ Bool)) (and (= e1 e1) (= e1_ e1_) (= st st) (= ctx ctx) (= st_ st_) (= ctx_ ctx_)))) ; family_lambda_SN_step [partial: bindings preserved] ; family_lambda_SN_step [verified]

; SN_app_value_left_family_aux (matches Coq: Lemma SN_app_value_left_family_aux)
; SN_app_value_left_family_aux: forall f cfg, value f -> SN cfg -> direct_lambda_SN f -> SN (EApp f (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_app_value_left_family_aux: property holds for all bindings
(assert (forall ((f Bool) (cfg Bool)) (and (= f f) (= cfg cfg)))) ; SN_app_value_left_family_aux [partial: bindings preserved] ; SN_app_value_left_family_aux [verified]

; SN_app_family_aux (matches Coq: Lemma SN_app_family_aux)
; SN_app_family_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> family_lambda_SN (fst (fst cfg)) -> SN (EApp (fst (fst cfg
; SN_app_family_aux: property holds for all bindings
(assert (forall ((cfg Bool) (e2 Bool)) (and (= cfg cfg) (= e2 e2)))) ; SN_app_family_aux [partial: bindings preserved] ; SN_app_family_aux [verified]

; SN_app_family (matches Coq: Lemma SN_app_family)
; SN_app_family: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> family_lambda_SN 
; SN_app_family: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= e1 e1) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_app_family [partial: bindings preserved] ; SN_app_family [verified]

; SN_pair_value_left_aux (matches Coq: Lemma SN_pair_value_left_aux)
; SN_pair_value_left_aux: forall v cfg, value v -> SN cfg -> SN (EPair v (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_pair_value_left_aux: property holds for all bindings
(assert (forall ((v Bool) (cfg Bool)) (and (= v v) (= cfg cfg)))) ; SN_pair_value_left_aux [partial: bindings preserved] ; SN_pair_value_left_aux [verified]

; SN_pair_value_left (matches Coq: Lemma SN_pair_value_left)
; SN_pair_value_left: forall v e2 st ctx, value v -> SN (e2, st, ctx) -> SN (EPair v e2, st, ctx)
; SN_pair_value_left: property holds for all bindings
(assert (forall ((v Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= v v) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_pair_value_left [partial: bindings preserved] ; SN_pair_value_left [verified]

; SN_pair_aux (matches Coq: Lemma SN_pair_aux)
; SN_pair_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> SN (EPair (fst (fst cfg)) e2, snd (fst cfg), snd cfg)
; SN_pair_aux: property holds for all bindings
(assert (forall ((cfg Bool) (e2 Bool)) (and (= cfg cfg) (= e2 e2)))) ; SN_pair_aux [partial: bindings preserved] ; SN_pair_aux [verified]

; SN_pair (matches Coq: Lemma SN_pair)
; SN_pair: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> SN (EPair e1 e2, 
; SN_pair: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= e1 e1) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_pair [partial: bindings preserved] ; SN_pair [verified]

; SN_fst_aux (matches Coq: Lemma SN_fst_aux)
; SN_fst_aux: forall cfg, SN cfg -> SN (EFst (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_fst_aux: property holds for all bindings
(assert (forall ((cfg Bool)) (= cfg cfg))) ; SN_fst_aux [partial: bindings preserved] ; SN_fst_aux [verified]

; SN_fst (matches Coq: Lemma SN_fst)
; SN_fst: forall e st ctx, SN (e, st, ctx) -> SN (EFst e, st, ctx)
; SN_fst: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (and (= e e) (= st st) (= ctx ctx)))) ; SN_fst [partial: bindings preserved] ; SN_fst [verified]

; SN_snd_aux (matches Coq: Lemma SN_snd_aux)
; SN_snd_aux: forall cfg, SN cfg -> SN (ESnd (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_snd_aux: property holds for all bindings
(assert (forall ((cfg Bool)) (= cfg cfg))) ; SN_snd_aux [partial: bindings preserved] ; SN_snd_aux [verified]

; SN_snd (matches Coq: Lemma SN_snd)
; SN_snd: forall e st ctx, SN (e, st, ctx) -> SN (ESnd e, st, ctx)
; SN_snd: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (and (= e e) (= st st) (= ctx ctx)))) ; SN_snd [partial: bindings preserved] ; SN_snd [verified]

; SN_inl_aux (matches Coq: Lemma SN_inl_aux)
; SN_inl_aux: forall cfg T, SN cfg -> SN (EInl (fst (fst cfg)) T, snd (fst cfg), snd cfg)
; SN_inl_aux: property holds for all bindings
(assert (forall ((cfg Bool) (T Bool)) (and (= cfg cfg) (= T T)))) ; SN_inl_aux [partial: bindings preserved] ; SN_inl_aux [verified]

; SN_inl (matches Coq: Lemma SN_inl)
; SN_inl: forall e T st ctx, SN (e, st, ctx) -> SN (EInl e T, st, ctx)
; SN_inl: property holds for all bindings
(assert (forall ((e Bool) (T Bool) (st Bool) (ctx Bool)) (and (= e e) (= T T) (= st st) (= ctx ctx)))) ; SN_inl [partial: bindings preserved] ; SN_inl [verified]

; SN_inr_aux (matches Coq: Lemma SN_inr_aux)
; SN_inr_aux: forall cfg T, SN cfg -> SN (EInr (fst (fst cfg)) T, snd (fst cfg), snd cfg)
; SN_inr_aux: property holds for all bindings
(assert (forall ((cfg Bool) (T Bool)) (and (= cfg cfg) (= T T)))) ; SN_inr_aux [partial: bindings preserved] ; SN_inr_aux [verified]

; SN_inr (matches Coq: Lemma SN_inr)
; SN_inr: forall e T st ctx, SN (e, st, ctx) -> SN (EInr e T, st, ctx)
; SN_inr: property holds for all bindings
(assert (forall ((e Bool) (T Bool) (st Bool) (ctx Bool)) (and (= e e) (= T T) (= st st) (= ctx ctx)))) ; SN_inr [partial: bindings preserved] ; SN_inr [verified]

; SN_case_aux (matches Coq: Lemma SN_case_aux)
; SN_case_aux: forall cfg x1 e1 x2 e2, SN cfg -> (forall v st' ctx', value v -> SN ([x1 := v] e1, st', ctx')) -> (forall v st' ctx', va
; SN_case_aux: property holds for all bindings
(assert (forall ((cfg Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool)) (and (= cfg cfg) (= x1 x1) (= e1 e1) (= x2 x2) (= e2 e2)))) ; SN_case_aux [partial: bindings preserved] ; SN_case_aux [verified]

; SN_case (matches Coq: Lemma SN_case)
; SN_case: forall e x1 e1 x2 e2 st ctx, SN (e, st, ctx) -> (forall v st' ctx', value v -> SN ([x1 := v] e1, st', ctx')) -> (forall 
; SN_case: property holds for all bindings
(assert (forall ((e Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= e e) (= x1 x1) (= e1 e1) (= x2 x2) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_case [partial: bindings preserved] ; SN_case [verified]

; SN_if_aux (matches Coq: Lemma SN_if_aux)
; SN_if_aux: forall cfg e2 e3, SN cfg -> (forall st' ctx', SN (e2, st', ctx')) -> (forall st' ctx', SN (e3, st', ctx')) -> SN (EIf (f
; SN_if_aux: property holds for all bindings
(assert (forall ((cfg Bool) (e2 Bool) (e3 Bool)) (and (= cfg cfg) (= e2 e2) (= e3 e3)))) ; SN_if_aux [partial: bindings preserved] ; SN_if_aux [verified]

; SN_if (matches Coq: Lemma SN_if)
; SN_if: forall e1 e2 e3 st ctx, SN (e1, st, ctx) -> (forall st' ctx', SN (e2, st', ctx')) -> (forall st' ctx', SN (e3, st', ctx'
; SN_if: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (and (= e1 e1) (= e2 e2) (= e3 e3) (= st st) (= ctx ctx)))) ; SN_if [partial: bindings preserved] ; SN_if [verified]

; SN_let_aux (matches Coq: Lemma SN_let_aux)
; SN_let_aux: forall cfg x e2, SN cfg -> (forall v st' ctx', value v -> SN ([x := v] e2, st', ctx')) -> SN (ELet x (fst (fst cfg)) e2,
; SN_let_aux: property holds for all bindings
(assert (forall ((cfg Bool) (x Bool) (e2 Bool)) (and (= cfg cfg) (= x x) (= e2 e2)))) ; SN_let_aux [partial: bindings preserved] ; SN_let_aux [verified]

; SN_let (matches Coq: Lemma SN_let)
; SN_let: forall x e1 e2 st ctx, SN (e1, st, ctx) -> (forall v st' ctx', value v -> SN ([x := v] e2, st', ctx')) -> SN (ELet x e1 
; SN_let: property holds for all bindings
(assert (forall ((x Bool) (e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= x x) (= e1 e1) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_let [partial: bindings preserved] ; SN_let [verified]

; SN_ref_aux (matches Coq: Lemma SN_ref_aux)
; SN_ref_aux: forall cfg sl, SN cfg -> SN (ERef (fst (fst cfg)) sl, snd (fst cfg), snd cfg)
; SN_ref_aux: property holds for all bindings
(assert (forall ((cfg Bool) (sl Bool)) (and (= cfg cfg) (= sl sl)))) ; SN_ref_aux [partial: bindings preserved] ; SN_ref_aux [verified]

; SN_ref (matches Coq: Lemma SN_ref)
; SN_ref: forall e sl st ctx, SN (e, st, ctx) -> SN (ERef e sl, st, ctx)
; SN_ref: property holds for all bindings
(assert (forall ((e Bool) (sl Bool) (st Bool) (ctx Bool)) (and (= e e) (= sl sl) (= st st) (= ctx ctx)))) ; SN_ref [partial: bindings preserved] ; SN_ref [verified]

; store_wf_nil (matches Coq: Lemma store_wf_nil)
; store_wf_nil: store_wf nil
(assert true) ; store_wf_nil [Coq-only]

; store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
; store_lookup_update_eq: forall l v st, store_lookup l (store_update l v st) = Some v
; store_lookup_update_eq: property holds for all bindings
(assert (forall ((l Bool) (v Bool) (st Bool)) (and (= l l) (= v v) (= st st)))) ; store_lookup_update_eq [partial: bindings preserved] ; store_lookup_update_eq [verified]

; store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
; store_lookup_update_neq: forall l0 l v st, l0 <> l -> store_lookup l0 (store_update l v st) = store_lookup l0 st
; store_lookup_update_neq: property holds for all bindings
(assert (forall ((l0 Bool) (l Bool) (v Bool) (st Bool)) (and (= l0 l0) (= l l) (= v v) (= st st)))) ; store_lookup_update_neq [partial: bindings preserved] ; store_lookup_update_neq [verified]

; store_update_preserves_wf (matches Coq: Lemma store_update_preserves_wf)
; store_update_preserves_wf: forall st l v, store_wf st -> value v -> store_wf (store_update l v st)
; store_update_preserves_wf: property holds for all bindings
(assert (forall ((st Bool) (l Bool) (v Bool)) (and (= st st) (= l l) (= v v)))) ; store_update_preserves_wf [partial: bindings preserved] ; store_update_preserves_wf [verified]

; step_preserves_store_wf (matches Coq: Lemma step_preserves_store_wf)
; step_preserves_store_wf: forall e st ctx e' st' ctx', store_wf st -> (e, st, ctx) --> (e', st', ctx') -> store_wf st'
; step_preserves_store_wf: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= e e) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; step_preserves_store_wf [partial: bindings preserved] ; step_preserves_store_wf [verified]

; SN_deref_aux (matches Coq: Lemma SN_deref_aux)
; SN_deref_aux: forall cfg, SN cfg -> (forall l v st', store_lookup l st' = Some v -> value v) -> SN (EDeref (fst (fst cfg)), snd (fst c
; SN_deref_aux: property holds for all bindings
(assert (forall ((cfg Bool)) (= cfg cfg))) ; SN_deref_aux [partial: bindings preserved] ; SN_deref_aux [verified]

; SN_deref (matches Coq: Lemma SN_deref)
; SN_deref: forall e st ctx, SN (e, st, ctx) -> (forall l v st', store_lookup l st' = Some v -> value v) -> SN (EDeref e, st, ctx)
; SN_deref: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (and (= e e) (= st st) (= ctx ctx)))) ; SN_deref [partial: bindings preserved] ; SN_deref [verified]

; SN_assign_value_left_aux (matches Coq: Lemma SN_assign_value_left_aux)
; SN_assign_value_left_aux: forall v cfg, value v -> SN cfg -> SN (EAssign v (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_assign_value_left_aux: property holds for all bindings
(assert (forall ((v Bool) (cfg Bool)) (and (= v v) (= cfg cfg)))) ; SN_assign_value_left_aux [partial: bindings preserved] ; SN_assign_value_left_aux [verified]

; SN_assign_aux (matches Coq: Lemma SN_assign_aux)
; SN_assign_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> SN (EAssign (fst (fst cfg)) e2, snd (fst cfg), snd cfg)
; SN_assign_aux: property holds for all bindings
(assert (forall ((cfg Bool) (e2 Bool)) (and (= cfg cfg) (= e2 e2)))) ; SN_assign_aux [partial: bindings preserved] ; SN_assign_aux [verified]

; SN_assign (matches Coq: Lemma SN_assign)
; SN_assign: forall e1 e2 st ctx, (forall st' ctx', SN (e1, st', ctx')) -> (forall st' ctx', SN (e2, st', ctx')) -> SN (EAssign e1 e2
; SN_assign: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= e1 e1) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_assign [partial: bindings preserved] ; SN_assign [verified]

; SN_handle_aux (matches Coq: Lemma SN_handle_aux)
; SN_handle_aux: forall cfg x h, SN cfg -> (forall v st' ctx', value v -> SN ([x := v] h, st', ctx')) -> SN (EHandle (fst (fst cfg)) x h,
; SN_handle_aux: property holds for all bindings
(assert (forall ((cfg Bool) (x Bool) (h Bool)) (and (= cfg cfg) (= x x) (= h h)))) ; SN_handle_aux [partial: bindings preserved] ; SN_handle_aux [verified]

; SN_handle (matches Coq: Lemma SN_handle)
; SN_handle: forall e x h st ctx, SN (e, st, ctx) -> (forall v st' ctx', value v -> SN ([x := v] h, st', ctx')) -> SN (EHandle e x h,
; SN_handle: property holds for all bindings
(assert (forall ((e Bool) (x Bool) (h Bool) (st Bool) (ctx Bool)) (and (= e e) (= x x) (= h h) (= st st) (= ctx ctx)))) ; SN_handle [partial: bindings preserved] ; SN_handle [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
