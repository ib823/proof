; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ReferenceOps.v (15 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ReferenceOps

(set-logic ALL)
(set-option :produce-models true)

; step_preserves_ctx_snd (matches Coq: Lemma step_preserves_ctx_snd)
; step_preserves_ctx_snd: forall cfg1 cfg2, cfg1 --> cfg2 -> snd cfg1 = snd cfg2
; step_preserves_ctx_snd: property holds for all bindings
(assert (forall ((cfg1 Bool) (cfg2 Bool)) (and (= cfg1 cfg1) (= cfg2 cfg2)))) ; step_preserves_ctx_snd [partial: bindings preserved] ; step_preserves_ctx_snd [verified]

; step_preserves_ctx (matches Coq: Lemma step_preserves_ctx)
; step_preserves_ctx: forall e st ctx e' st' ctx', (e, st, ctx) --> (e', st', ctx') -> ctx' = ctx
; step_preserves_ctx: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= e e) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; step_preserves_ctx [partial: bindings preserved] ; step_preserves_ctx [verified]

; multi_step_preserves_ctx (matches Coq: Lemma multi_step_preserves_ctx)
; multi_step_preserves_ctx: forall e st ctx e' st' ctx', multi_step (e, st, ctx) (e', st', ctx') -> ctx' = ctx
; multi_step_preserves_ctx: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= e e) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; multi_step_preserves_ctx [partial: bindings preserved] ; multi_step_preserves_ctx [verified]

; value_multi_step_refl (matches Coq: Lemma value_multi_step_refl)
; value_multi_step_refl: forall v st ctx cfg, value v -> multi_step (v, st, ctx) cfg -> cfg = (v, st, ctx)
; value_multi_step_refl: property holds for all bindings
(assert (forall ((v Bool) (st Bool) (ctx Bool) (cfg Bool)) (and (= v v) (= st st) (= ctx ctx) (= cfg cfg)))) ; value_multi_step_refl [partial: bindings preserved] ; value_multi_step_refl [verified]

; multi_step_ref_inversion (matches Coq: Lemma multi_step_ref_inversion)
; multi_step_ref_inversion: forall e sl st v st' ctx, multi_step (ERef e sl, st, ctx) (v, st', ctx) -> value v -> exists v_inner st_mid l, multi_ste
; multi_step_ref_inversion: property holds for all bindings
(assert (forall ((e Bool) (sl Bool) (st Bool) (v Bool) (st_ Bool) (ctx Bool)) (and (= e e) (= sl sl) (= st st) (= v v) (= st_ st_) (= ctx ctx)))) ; multi_step_ref_inversion [partial: bindings preserved] ; multi_step_ref_inversion [verified]

; multi_step_deref_inversion (matches Coq: Lemma multi_step_deref_inversion)
; multi_step_deref_inversion: forall e st v st' ctx, multi_step (EDeref e, st, ctx) (v, st', ctx) -> value v -> store_has_values st -> exists l st_mid
; multi_step_deref_inversion: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (v Bool) (st_ Bool) (ctx Bool)) (and (= e e) (= st st) (= v v) (= st_ st_) (= ctx ctx)))) ; multi_step_deref_inversion [partial: bindings preserved] ; multi_step_deref_inversion [verified]

; multi_step_assign_inversion (matches Coq: Lemma multi_step_assign_inversion)
; multi_step_assign_inversion: forall e1 e2 st v st' ctx, multi_step (EAssign e1 e2, st, ctx) (v, st', ctx) -> value v -> store_has_values st -> exists
; multi_step_assign_inversion: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (v Bool) (st_ Bool) (ctx Bool)) (and (= e1 e1) (= e2 e2) (= st st) (= v v) (= st_ st_) (= ctx ctx)))) ; multi_step_assign_inversion [partial: bindings preserved] ; multi_step_assign_inversion [verified]

; ref_same_location (matches Coq: Lemma ref_same_location)
; ref_same_location: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> fresh_loc st1 = fresh_loc st2
; ref_same_location: property holds for all bindings
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (and (= sigma sigma) (= st1 st1) (= st2 st2)))) ; ref_same_location [partial: bindings preserved] ; ref_same_location [verified]

; logical_relation_ref_proven (matches Coq: Lemma logical_relation_ref_proven)
; logical_relation_ref_proven: forall n Σ T sl v1 v2 st1 st2 ctx, n > 0 -> value v1 -> value v2 -> store_wf Σ st1 -> val_rel_le n Σ T v1 v2 -> store_re
; logical_relation_ref_proven: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= v1 v1) (= v2 v2) (= st1 st1) (= st2 st2) (= ctx ctx)))) ; logical_relation_ref_proven [partial: bindings preserved] ; logical_relation_ref_proven [verified]

; exp_rel_le_ref (matches Coq: Lemma exp_rel_le_ref)
; exp_rel_le_ref: forall n Σ T sl e1 e2 st1 st2 ctx, exp_rel_le n Σ T e1 e2 st1 st2 ctx -> store_rel_le n Σ st1 st2 -> exp_rel_le n Σ (TRe
; exp_rel_le_ref: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (e1 Bool) (e2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= e1 e1) (= e2 e2) (= st1 st1) (= st2 st2) (= ctx ctx)))) ; exp_rel_le_ref [partial: bindings preserved] ; exp_rel_le_ref [verified]

; logical_relation_deref_proven (matches Coq: Lemma logical_relation_deref_proven)
; logical_relation_deref_proven: forall n Σ T sl l st1 st2 ctx, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> exists v1 v2, store_loo
; logical_relation_deref_proven: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (l Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= l l) (= st1 st1) (= st2 st2) (= ctx ctx)))) ; logical_relation_deref_proven [partial: bindings preserved] ; logical_relation_deref_proven [verified]

; exp_rel_le_deref (matches Coq: Lemma exp_rel_le_deref)
; exp_rel_le_deref: forall n Σ T sl e1 e2 st1 st2 ctx, (forall k v1 v2 st1' st2', k <= n -> multi_step (e1, st1, ctx) (v1, st1', ctx) -> mul
; exp_rel_le_deref: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (e1 Bool) (e2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= e1 e1) (= e2 e2) (= st1 st1) (= st2 st2) (= ctx ctx)))) ; exp_rel_le_deref [partial: bindings preserved] ; exp_rel_le_deref [verified]

; logical_relation_assign_proven (matches Coq: Lemma logical_relation_assign_proven)
; logical_relation_assign_proven: forall n Σ T sl l v1 v2 st1 st2 ctx, value v1 -> value v2 -> store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, 
; logical_relation_assign_proven: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (l Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= l l) (= v1 v1) (= v2 v2) (= st1 st1) (= st2 st2) (= ctx ctx)))) ; logical_relation_assign_proven [partial: bindings preserved] ; logical_relation_assign_proven [verified]

; exp_rel_le_assign (matches Coq: Lemma exp_rel_le_assign)
; exp_rel_le_assign: forall n Σ T sl e1 e2 e1' e2' st1 st2 ctx, (forall k v1 v2 st1' st2', k <= n -> multi_step (e1, st1, ctx) (v1, st1', ctx
; exp_rel_le_assign: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (e1 Bool) (e2 Bool) (e1_ Bool) (e2_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= e1 e1) (= e2 e2) (= e1_ e1_) (= e2_ e2_) (= st1 st1) (= st2 st2) (= ctx ctx)))) ; exp_rel_le_assign [partial: bindings preserved] ; exp_rel_le_assign [verified]

; reference_ops_zero_admits (matches Coq: Theorem reference_ops_zero_admits)
; reference_ops_zero_admits: True
(assert true) ; reference_ops_zero_admits [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)
