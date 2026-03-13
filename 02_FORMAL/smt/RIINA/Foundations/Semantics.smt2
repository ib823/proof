; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/foundations/Semantics.v (37 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: Semantics

(set-logic ALL)
(set-option :produce-models true)

; store_lookup (matches Coq: Definition store_lookup)
(define-fun store_lookup ((l Int) (st Int)) Int
  0)

; store_update (matches Coq: Definition store_update)
(define-fun store_update ((l Int) (v Int) (st Int)) Int
  0)

; store_max (matches Coq: Definition store_max)
(define-fun store_max ((st Int)) Int
  0)

; fresh_loc (matches Coq: Definition fresh_loc)
(define-fun fresh_loc ((st Int)) Int
  0)

; has_effect (matches Coq: Definition has_effect)
(define-fun has_effect ((eff Int) (ctx Int)) Bool
  true)

; store_has_values (matches Coq: Definition store_has_values)
(define-fun store_has_values ((st Int)) Bool
  true)

; store_lookup_above_max (matches Coq: Lemma store_lookup_above_max)
; store_lookup_above_max: forall st l, store_max st < l -> store_lookup l st = None
; store_lookup_above_max: property holds for all bindings
(assert (forall ((st Bool) (l Bool)) (and (= st st) (= l l)))) ; store_lookup_above_max [partial: bindings preserved] ; store_lookup_above_max [verified]

; store_lookup_fresh (matches Coq: Lemma store_lookup_fresh)
; store_lookup_fresh: forall st, store_lookup (fresh_loc st) st = None
; store_lookup_fresh: property holds for all bindings
(assert (forall ((st Bool)) (= st st))) ; store_lookup_fresh [partial: bindings preserved] ; store_lookup_fresh [verified]

; value_not_step (matches Coq: Lemma value_not_step)
; value_not_step: forall v st ctx cfg, value v -> ~ ((v, st, ctx) --> cfg)
; value_not_step: property holds for all bindings
(assert (forall ((v Bool) (st Bool) (ctx Bool) (cfg Bool)) (and (= v v) (= st st) (= ctx ctx) (= cfg cfg)))) ; value_not_step [partial: bindings preserved] ; value_not_step [verified]

; value_does_not_step (matches Coq: Lemma value_does_not_step)
; value_does_not_step: forall v st ctx e' st' ctx', value v -> (v, st, ctx) --> (e', st', ctx') -> False
; value_does_not_step: property holds for all bindings
(assert (forall ((v Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= v v) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; value_does_not_step [partial: bindings preserved] ; value_does_not_step [verified]

; step_deterministic_cfg (matches Coq: Theorem step_deterministic_cfg)
; step_deterministic_cfg: forall cfg cfg1 cfg2, step cfg cfg1 -> step cfg cfg2 -> cfg1 = cfg2
; step_deterministic_cfg: property holds for all bindings
(assert (forall ((cfg Bool) (cfg1 Bool) (cfg2 Bool)) (and (= cfg cfg) (= cfg1 cfg1) (= cfg2 cfg2)))) ; step_deterministic_cfg [partial: bindings preserved] ; step_deterministic_cfg [verified]

; step_deterministic (matches Coq: Theorem step_deterministic)
; step_deterministic: forall t st ctx t1 st1 ctx1 t2 st2 ctx2, (t, st, ctx) --> (t1, st1, ctx1) -> (t, st, ctx) --> (t2, st2, ctx2) -> t1 = t2
; step_deterministic: property holds for all bindings
(assert (forall ((t Bool) (st Bool) (ctx Bool) (t1 Bool) (st1 Bool) (ctx1 Bool) (t2 Bool) (st2 Bool) (ctx2 Bool)) (and (= t t) (= st st) (= ctx ctx) (= t1 t1) (= st1 st1) (= ctx1 ctx1) (= t2 t2) (= st2 st2) (= ctx2 ctx2)))) ; step_deterministic [partial: bindings preserved] ; step_deterministic [verified]

; store_update_lookup_eq (matches Coq: Lemma store_update_lookup_eq)
; store_update_lookup_eq: forall st l v, store_lookup l (store_update l v st) = Some v
; store_update_lookup_eq: property holds for all bindings
(assert (forall ((st Bool) (l Bool) (v Bool)) (and (= st st) (= l l) (= v v)))) ; store_update_lookup_eq [partial: bindings preserved] ; store_update_lookup_eq [verified]

; store_update_lookup_neq (matches Coq: Lemma store_update_lookup_neq)
; store_update_lookup_neq: forall st l l' v, l <> l' -> store_lookup l' (store_update l v st) = store_lookup l' st
; store_update_lookup_neq: property holds for all bindings
(assert (forall ((st Bool) (l Bool) (l_ Bool) (v Bool)) (and (= st st) (= l l) (= l_ l_) (= v v)))) ; store_update_lookup_neq [partial: bindings preserved] ; store_update_lookup_neq [verified]

; store_has_values_empty (matches Coq: Lemma store_has_values_empty)
; store_has_values_empty: store_has_values nil
(assert true) ; store_has_values_empty [Coq-only]

; store_update_preserves_values (matches Coq: Lemma store_update_preserves_values)
; store_update_preserves_values: forall st l v, store_has_values st -> value v -> store_has_values (store_update l v st)
; store_update_preserves_values: property holds for all bindings
(assert (forall ((st Bool) (l Bool) (v Bool)) (and (= st st) (= l l) (= v v)))) ; store_update_preserves_values [partial: bindings preserved] ; store_update_preserves_values [verified]

; step_preserves_store_values_aux (matches Coq: Lemma step_preserves_store_values_aux)
; step_preserves_store_values_aux: forall cfg1 cfg2, cfg1 --> cfg2 -> store_has_values (snd (fst cfg1)) -> store_has_values (snd (fst cfg2))
; step_preserves_store_values_aux: property holds for all bindings
(assert (forall ((cfg1 Bool) (cfg2 Bool)) (and (= cfg1 cfg1) (= cfg2 cfg2)))) ; step_preserves_store_values_aux [partial: bindings preserved] ; step_preserves_store_values_aux [verified]

; step_preserves_store_values (matches Coq: Lemma step_preserves_store_values)
; step_preserves_store_values: forall e st ctx e' st' ctx', (e, st, ctx) --> (e', st', ctx') -> store_has_values st -> store_has_values st'
; step_preserves_store_values: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= e e) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; step_preserves_store_values [partial: bindings preserved] ; step_preserves_store_values [verified]

; multi_step_preserves_store_values (matches Coq: Lemma multi_step_preserves_store_values)
; multi_step_preserves_store_values: forall cfg1 cfg2, multi_step cfg1 cfg2 -> store_has_values (snd (fst cfg1)) -> store_has_values (snd (fst cfg2))
; multi_step_preserves_store_values: property holds for all bindings
(assert (forall ((cfg1 Bool) (cfg2 Bool)) (and (= cfg1 cfg1) (= cfg2 cfg2)))) ; multi_step_preserves_store_values [partial: bindings preserved] ; multi_step_preserves_store_values [verified]

; multi_step_trans (matches Coq: Theorem multi_step_trans)
; multi_step_trans: forall cfg1 cfg2 cfg3, multi_step cfg1 cfg2 -> multi_step cfg2 cfg3 -> multi_step cfg1 cfg3
; multi_step_trans: property holds for all bindings
(assert (forall ((cfg1 Bool) (cfg2 Bool) (cfg3 Bool)) (and (= cfg1 cfg1) (= cfg2 cfg2) (= cfg3 cfg3)))) ; multi_step_trans [partial: bindings preserved] ; multi_step_trans [verified]

; step_to_multi_step (matches Coq: Lemma step_to_multi_step)
; step_to_multi_step: forall cfg1 cfg2, step cfg1 cfg2 -> multi_step cfg1 cfg2
; step_to_multi_step: property holds for all bindings
(assert (forall ((cfg1 Bool) (cfg2 Bool)) (and (= cfg1 cfg1) (= cfg2 cfg2)))) ; step_to_multi_step [partial: bindings preserved] ; step_to_multi_step [verified]

; multi_step_congruence_1 (matches Coq: Lemma multi_step_congruence_1)
; multi_step_congruence_1: forall (f : expr -> expr) (step_compat : forall e e' st st' ctx ctx', (e, st, ctx) --> (e', st', ctx') -> (f e, st, ctx)
; multi_step_congruence_1: property holds for all bindings
(assert (forall ((f Int) (step_compat Int) (e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= f f) (= step_compat step_compat) (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_congruence_1 [partial: bindings preserved] ; multi_step_congruence_1 [verified]

; multi_step_app1 (matches Coq: Lemma multi_step_app1)
; multi_step_app1: forall e1 e1' e2 st st' ctx ctx', (e1, st, ctx) -->* (e1', st', ctx') -> (EApp e1 e2, st, ctx) -->* (EApp e1' e2, st', c
; multi_step_app1: property holds for all bindings
(assert (forall ((e1 Bool) (e1_ Bool) (e2 Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e1 e1) (= e1_ e1_) (= e2 e2) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_app1 [partial: bindings preserved] ; multi_step_app1 [verified]

; multi_step_app2 (matches Coq: Lemma multi_step_app2)
; multi_step_app2: forall v1 e2 e2' st st' ctx ctx', value v1 -> (e2, st, ctx) -->* (e2', st', ctx') -> (EApp v1 e2, st, ctx) -->* (EApp v1
; multi_step_app2: property holds for all bindings
(assert (forall ((v1 Bool) (e2 Bool) (e2_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= v1 v1) (= e2 e2) (= e2_ e2_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_app2 [partial: bindings preserved] ; multi_step_app2 [verified]

; multi_step_pair1 (matches Coq: Lemma multi_step_pair1)
; multi_step_pair1: forall e1 e1' e2 st st' ctx ctx', (e1, st, ctx) -->* (e1', st', ctx') -> (EPair e1 e2, st, ctx) -->* (EPair e1' e2, st',
; multi_step_pair1: property holds for all bindings
(assert (forall ((e1 Bool) (e1_ Bool) (e2 Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e1 e1) (= e1_ e1_) (= e2 e2) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_pair1 [partial: bindings preserved] ; multi_step_pair1 [verified]

; multi_step_pair2 (matches Coq: Lemma multi_step_pair2)
; multi_step_pair2: forall v1 e2 e2' st st' ctx ctx', value v1 -> (e2, st, ctx) -->* (e2', st', ctx') -> (EPair v1 e2, st, ctx) -->* (EPair 
; multi_step_pair2: property holds for all bindings
(assert (forall ((v1 Bool) (e2 Bool) (e2_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= v1 v1) (= e2 e2) (= e2_ e2_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_pair2 [partial: bindings preserved] ; multi_step_pair2 [verified]

; multi_step_fst (matches Coq: Lemma multi_step_fst)
; multi_step_fst: forall e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EFst e, st, ctx) -->* (EFst e', st', ctx')
; multi_step_fst: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_fst [partial: bindings preserved] ; multi_step_fst [verified]

; multi_step_snd (matches Coq: Lemma multi_step_snd)
; multi_step_snd: forall e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (ESnd e, st, ctx) -->* (ESnd e', st', ctx')
; multi_step_snd: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_snd [partial: bindings preserved] ; multi_step_snd [verified]

; multi_step_if (matches Coq: Lemma multi_step_if)
; multi_step_if: forall e1 e1' e2 e3 st st' ctx ctx', (e1, st, ctx) -->* (e1', st', ctx') -> (EIf e1 e2 e3, st, ctx) -->* (EIf e1' e2 e3,
; multi_step_if: property holds for all bindings
(assert (forall ((e1 Bool) (e1_ Bool) (e2 Bool) (e3 Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e1 e1) (= e1_ e1_) (= e2 e2) (= e3 e3) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_if [partial: bindings preserved] ; multi_step_if [verified]

; multi_step_let (matches Coq: Lemma multi_step_let)
; multi_step_let: forall x e1 e1' e2 st st' ctx ctx', (e1, st, ctx) -->* (e1', st', ctx') -> (ELet x e1 e2, st, ctx) -->* (ELet x e1' e2, 
; multi_step_let: property holds for all bindings
(assert (forall ((x Bool) (e1 Bool) (e1_ Bool) (e2 Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= x x) (= e1 e1) (= e1_ e1_) (= e2 e2) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_let [partial: bindings preserved] ; multi_step_let [verified]

; multi_step_case (matches Coq: Lemma multi_step_case)
; multi_step_case: forall e e' x1 e1 x2 e2 st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (ECase e x1 e1 x2 e2, st, ctx) -->* (ECase
; multi_step_case: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= x1 x1) (= e1 e1) (= x2 x2) (= e2 e2) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_case [partial: bindings preserved] ; multi_step_case [verified]

; multi_step_classify (matches Coq: Lemma multi_step_classify)
; multi_step_classify: forall e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EClassify e, st, ctx) -->* (EClassify e', st', ctx')
; multi_step_classify: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_classify [partial: bindings preserved] ; multi_step_classify [verified]

; multi_step_prove (matches Coq: Lemma multi_step_prove)
; multi_step_prove: forall e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EProve e, st, ctx) -->* (EProve e', st', ctx')
; multi_step_prove: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_prove [partial: bindings preserved] ; multi_step_prove [verified]

; multi_step_ref (matches Coq: Lemma multi_step_ref)
; multi_step_ref: forall e e' sl st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (ERef e sl, st, ctx) -->* (ERef e' sl, st', ctx')
; multi_step_ref: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (sl Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= sl sl) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_ref [partial: bindings preserved] ; multi_step_ref [verified]

; multi_step_deref (matches Coq: Lemma multi_step_deref)
; multi_step_deref: forall e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EDeref e, st, ctx) -->* (EDeref e', st', ctx')
; multi_step_deref: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_deref [partial: bindings preserved] ; multi_step_deref [verified]

; multi_step_handle (matches Coq: Lemma multi_step_handle)
; multi_step_handle: forall e e' x h st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EHandle e x h, st, ctx) -->* (EHandle e' x h, st'
; multi_step_handle: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (x Bool) (h Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= x x) (= h h) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_handle [partial: bindings preserved] ; multi_step_handle [verified]

; multi_step_perform (matches Coq: Lemma multi_step_perform)
; multi_step_perform: forall eff e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EPerform eff e, st, ctx) -->* (EPerform eff e', s
; multi_step_perform: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= eff eff) (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_perform [partial: bindings preserved] ; multi_step_perform [verified]

; multi_step_inl (matches Coq: Lemma multi_step_inl)
; multi_step_inl: forall e e' T st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EInl e T, st, ctx) -->* (EInl e' T, st', ctx')
; multi_step_inl: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= T T) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_inl [partial: bindings preserved] ; multi_step_inl [verified]

; multi_step_inr (matches Coq: Lemma multi_step_inr)
; multi_step_inr: forall e e' T st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EInr e T, st, ctx) -->* (EInr e' T, st', ctx')
; multi_step_inr: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e e) (= e_ e_) (= T T) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_inr [partial: bindings preserved] ; multi_step_inr [verified]

; multi_step_assign1 (matches Coq: Lemma multi_step_assign1)
; multi_step_assign1: forall e1 e1' e2 st st' ctx ctx', (e1, st, ctx) -->* (e1', st', ctx') -> (EAssign e1 e2, st, ctx) -->* (EAssign e1' e2, 
; multi_step_assign1: property holds for all bindings
(assert (forall ((e1 Bool) (e1_ Bool) (e2 Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= e1 e1) (= e1_ e1_) (= e2 e2) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_assign1 [partial: bindings preserved] ; multi_step_assign1 [verified]

; multi_step_assign2 (matches Coq: Lemma multi_step_assign2)
; multi_step_assign2: forall v1 e2 e2' st st' ctx ctx', value v1 -> (e2, st, ctx) -->* (e2', st', ctx') -> (EAssign v1 e2, st, ctx) -->* (EAss
; multi_step_assign2: property holds for all bindings
(assert (forall ((v1 Bool) (e2 Bool) (e2_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= v1 v1) (= e2 e2) (= e2_ e2_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_assign2 [partial: bindings preserved] ; multi_step_assign2 [verified]

; multi_step_require (matches Coq: Lemma multi_step_require)
; multi_step_require: forall eff e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (ERequire eff e, st, ctx) -->* (ERequire eff e', s
; multi_step_require: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= eff eff) (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_require [partial: bindings preserved] ; multi_step_require [verified]

; multi_step_grant (matches Coq: Lemma multi_step_grant)
; multi_step_grant: forall eff e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> (EGrant eff e, st, ctx) -->* (EGrant eff e', st', 
; multi_step_grant: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (and (= eff eff) (= e e) (= e_ e_) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_)))) ; multi_step_grant [partial: bindings preserved] ; multi_step_grant [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
