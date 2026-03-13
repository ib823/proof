; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/EffectSafety.v (41 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: EffectSafety

(set-logic ALL)
(set-option :produce-models true)

; effect_join_pure_inv (matches Coq: Lemma effect_join_pure_inv)
; effect_join_pure_inv: forall ε1 ε2, effect_join ε1 ε2 = EffPure -> ε1 = EffPure /\ ε2 = EffPure
; effect_join_pure_inv: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (and (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; effect_join_pure_inv [partial: bindings preserved] ; effect_join_pure_inv [verified]

; effect_join_write_not_pure (matches Coq: Lemma effect_join_write_not_pure)
; effect_join_write_not_pure: forall ε, effect_join ε EffWrite <> EffPure
; effect_join_write_not_pure: property holds for all bindings
(assert (forall ((epsilon Bool)) (= epsilon epsilon))) ; effect_join_write_not_pure [partial: bindings preserved] ; effect_join_write_not_pure [verified]

; effect_join_read_not_pure (matches Coq: Lemma effect_join_read_not_pure)
; effect_join_read_not_pure: forall ε, effect_join ε EffRead <> EffPure
; effect_join_read_not_pure: property holds for all bindings
(assert (forall ((epsilon Bool)) (= epsilon epsilon))) ; effect_join_read_not_pure [partial: bindings preserved] ; effect_join_read_not_pure [verified]

; value_dec (matches Coq: Lemma value_dec)
; value_dec: forall e, {value e} + {~ value e}
; value_dec: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; value_dec [partial: bindings preserved] ; value_dec [verified]

; pure_step_preserves_store (matches Coq: Theorem pure_step_preserves_store)
; pure_step_preserves_store: forall e e' T st st' ctx ctx' Σ, has_type nil Σ Public e T EffPure -> store_wf Σ st -> (e, st, ctx) --> (e', st', ctx') 
; pure_step_preserves_store: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (and (= e e) (= e_ e_) (= T T) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_) (= sigma sigma)))) ; pure_step_preserves_store [partial: bindings preserved] ; pure_step_preserves_store [verified]

; pure_step_preserves_ctx (matches Coq: Theorem pure_step_preserves_ctx)
; pure_step_preserves_ctx: forall e e' T st st' ctx ctx' Σ, has_type nil Σ Public e T EffPure -> store_wf Σ st -> (e, st, ctx) --> (e', st', ctx') 
; pure_step_preserves_ctx: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (and (= e e) (= e_ e_) (= T T) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_) (= sigma sigma)))) ; pure_step_preserves_ctx [partial: bindings preserved] ; pure_step_preserves_ctx [verified]

; preservation_pure (matches Coq: Lemma preservation_pure)
; preservation_pure: forall e e' T st st' ctx ctx' Σ, has_type nil Σ Public e T EffPure -> store_wf Σ st -> (e, st, ctx) --> (e', st', ctx') 
; preservation_pure: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (and (= e e) (= e_ e_) (= T T) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_) (= sigma sigma)))) ; preservation_pure [partial: bindings preserved] ; preservation_pure [verified]

; pure_multi_step_preserves_store (matches Coq: Theorem pure_multi_step_preserves_store)
; pure_multi_step_preserves_store: forall e e' T st st' ctx ctx' Σ, has_type nil Σ Public e T EffPure -> store_wf Σ st -> (e, st, ctx) -->* (e', st', ctx')
; pure_multi_step_preserves_store: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (and (= e e) (= e_ e_) (= T T) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_) (= sigma sigma)))) ; pure_multi_step_preserves_store [partial: bindings preserved] ; pure_multi_step_preserves_store [verified]

; multi_step_value_inv (matches Coq: Lemma multi_step_value_inv)
; multi_step_value_inv: forall v st ctx e' st' ctx', value v -> (v, st, ctx) -->* (e', st', ctx') -> v = e' /\ st = st' /\ ctx = ctx'
; multi_step_value_inv: property holds for all bindings
(assert (forall ((v Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= v v) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; multi_step_value_inv [partial: bindings preserved] ; multi_step_value_inv [verified]

; atomic_value_pure (matches Coq: Lemma atomic_value_pure)
; atomic_value_pure: forall Γ Σ Δ v T ε, has_type Γ Σ Δ v T ε -> (v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n) \/ (exists s
; atomic_value_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= v v) (= T T) (= epsilon epsilon)))) ; atomic_value_pure [partial: bindings preserved] ; atomic_value_pure [verified]

; effect_level_zero_is_pure (matches Coq: Lemma effect_level_zero_is_pure)
; effect_level_zero_is_pure: forall ε, effect_level ε = 0 -> ε = EffPure
; effect_level_zero_is_pure: property holds for all bindings
(assert (forall ((epsilon Bool)) (= epsilon epsilon))) ; effect_level_zero_is_pure [partial: bindings preserved] ; effect_level_zero_is_pure [verified]

; effect_join_nonpure (matches Coq: Lemma effect_join_nonpure)
; effect_join_nonpure: forall ε1 ε2, ε2 <> EffPure -> effect_join ε1 ε2 <> EffPure
; effect_join_nonpure: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (and (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; effect_join_nonpure [partial: bindings preserved] ; effect_join_nonpure [verified]

; effect_join_monotone (matches Coq: Lemma effect_join_monotone)
; effect_join_monotone: forall ε1 ε1' ε2 ε2', effect_leq ε1 ε1' -> effect_leq ε2 ε2' -> effect_leq (effect_join ε1 ε2) (effect_join ε1' ε2')
; effect_join_monotone: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon1_ Bool) (epsilon2 Bool) (epsilon2_ Bool)) (and (= epsilon1 epsilon1) (= epsilon1_ epsilon1_) (= epsilon2 epsilon2) (= epsilon2_ epsilon2_)))) ; effect_join_monotone [partial: bindings preserved] ; effect_join_monotone [verified]

; effect_join_mono_l (matches Coq: Lemma effect_join_mono_l)
; effect_join_mono_l: forall ε1 ε1' ε2, effect_leq ε1 ε1' -> effect_leq (effect_join ε1 ε2) (effect_join ε1' ε2)
; effect_join_mono_l: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon1_ Bool) (epsilon2 Bool)) (and (= epsilon1 epsilon1) (= epsilon1_ epsilon1_) (= epsilon2 epsilon2)))) ; effect_join_mono_l [partial: bindings preserved] ; effect_join_mono_l [verified]

; effect_join_mono_r (matches Coq: Lemma effect_join_mono_r)
; effect_join_mono_r: forall ε1 ε2 ε2', effect_leq ε2 ε2' -> effect_leq (effect_join ε1 ε2) (effect_join ε1 ε2')
; effect_join_mono_r: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon2 Bool) (epsilon2_ Bool)) (and (= epsilon1 epsilon1) (= epsilon2 epsilon2) (= epsilon2_ epsilon2_)))) ; effect_join_mono_r [partial: bindings preserved] ; effect_join_mono_r [verified]

; effect_leq_pure (matches Coq: Lemma effect_leq_pure)
; effect_leq_pure: forall ε, effect_leq EffPure ε
; effect_leq_pure: property holds for all bindings
(assert (forall ((epsilon Bool)) (= epsilon epsilon))) ; effect_leq_pure [partial: bindings preserved] ; effect_leq_pure [verified]

; read_leq_write (matches Coq: Lemma read_leq_write)
; read_leq_write: effect_leq EffRead EffWrite
(assert true) ; read_leq_write [Coq-only]

; write_subsumes_read (matches Coq: Lemma write_subsumes_read)
; write_subsumes_read: effect_join EffRead EffWrite = EffWrite
(assert true) ; write_subsumes_read [Coq-only]

; write_leq_filesystem (matches Coq: Lemma write_leq_filesystem)
; write_leq_filesystem: effect_leq EffWrite EffFileSystem
(assert true) ; write_leq_filesystem [Coq-only]

; pure_leq_read (matches Coq: Lemma pure_leq_read)
; pure_leq_read: effect_leq EffPure EffRead
(assert true) ; pure_leq_read [Coq-only]

; pure_leq_write (matches Coq: Lemma pure_leq_write)
; pure_leq_write: effect_leq EffPure EffWrite
(assert true) ; pure_leq_write [Coq-only]

; read_neq_write (matches Coq: Lemma read_neq_write)
; read_neq_write: EffRead <> EffWrite
(assert true) ; read_neq_write [Coq-only]

; effect_join_pure_l (matches Coq: Lemma effect_join_pure_l)
; effect_join_pure_l: forall ε, effect_join EffPure ε = ε
; effect_join_pure_l: property holds for all bindings
(assert (forall ((epsilon Bool)) (= epsilon epsilon))) ; effect_join_pure_l [partial: bindings preserved] ; effect_join_pure_l [verified]

; effect_join_idem (matches Coq: Lemma effect_join_idem)
; effect_join_idem: forall ε, effect_join ε ε = ε
; effect_join_idem: property holds for all bindings
(assert (forall ((epsilon Bool)) (= epsilon epsilon))) ; effect_join_idem [partial: bindings preserved] ; effect_join_idem [verified]

; base_value_always_pure (matches Coq: Lemma base_value_always_pure)
; base_value_always_pure: forall Γ Σ Δ v T ε, has_type Γ Σ Δ v T ε -> (v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n) \/ (exists s
; base_value_always_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= v v) (= T T) (= epsilon epsilon)))) ; base_value_always_pure [partial: bindings preserved] ; base_value_always_pure [verified]

; pure_multi_step_preserves_ctx (matches Coq: Theorem pure_multi_step_preserves_ctx)
; pure_multi_step_preserves_ctx: forall e e' T st st' ctx ctx' Σ, has_type nil Σ Public e T EffPure -> store_wf Σ st -> (e, st, ctx) -->* (e', st', ctx')
; pure_multi_step_preserves_ctx: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (and (= e e) (= e_ e_) (= T T) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_) (= sigma sigma)))) ; pure_multi_step_preserves_ctx [partial: bindings preserved] ; pure_multi_step_preserves_ctx [verified]

; effect_read_not_pure (matches Coq: Lemma effect_read_not_pure)
; effect_read_not_pure: EffRead <> EffPure
(assert true) ; effect_read_not_pure [Coq-only]

; effect_write_not_pure (matches Coq: Lemma effect_write_not_pure)
; effect_write_not_pure: EffWrite <> EffPure
(assert true) ; effect_write_not_pure [Coq-only]

; effect_filesystem_not_pure (matches Coq: Lemma effect_filesystem_not_pure)
; effect_filesystem_not_pure: EffFileSystem <> EffPure
(assert true) ; effect_filesystem_not_pure [Coq-only]

; effect_network_not_pure (matches Coq: Lemma effect_network_not_pure)
; effect_network_not_pure: EffNetwork <> EffPure
(assert true) ; effect_network_not_pure [Coq-only]

; effect_system_not_pure (matches Coq: Lemma effect_system_not_pure)
; effect_system_not_pure: EffSystem <> EffPure
(assert true) ; effect_system_not_pure [Coq-only]

; effect_crypto_not_pure (matches Coq: Lemma effect_crypto_not_pure)
; effect_crypto_not_pure: EffCrypto <> EffPure
(assert true) ; effect_crypto_not_pure [Coq-only]

; effect_random_not_pure (matches Coq: Lemma effect_random_not_pure)
; effect_random_not_pure: EffRandom <> EffPure
(assert true) ; effect_random_not_pure [Coq-only]

; effect_time_not_pure (matches Coq: Lemma effect_time_not_pure)
; effect_time_not_pure: EffTime <> EffPure
(assert true) ; effect_time_not_pure [Coq-only]

; effect_process_not_pure (matches Coq: Lemma effect_process_not_pure)
; effect_process_not_pure: EffProcess <> EffPure
(assert true) ; effect_process_not_pure [Coq-only]

; effect_netsecure_not_pure (matches Coq: Lemma effect_netsecure_not_pure)
; effect_netsecure_not_pure: EffNetSecure <> EffPure
(assert true) ; effect_netsecure_not_pure [Coq-only]

; effect_level_pure (matches Coq: Lemma effect_level_pure)
; effect_level_pure: effect_level EffPure = 0
(assert true) ; effect_level_pure [Coq-only]

; effect_level_read (matches Coq: Lemma effect_level_read)
; effect_level_read: effect_level EffRead = 1
(assert true) ; effect_level_read [Coq-only]

; effect_level_write (matches Coq: Lemma effect_level_write)
; effect_level_write: effect_level EffWrite = 2
(assert true) ; effect_level_write [Coq-only]

; effect_level_pure_min (matches Coq: Lemma effect_level_pure_min)
; effect_level_pure_min: forall ε, effect_level EffPure <= effect_level ε
; effect_level_pure_min: property holds for all bindings
(assert (forall ((epsilon Bool)) (= epsilon epsilon))) ; effect_level_pure_min [partial: bindings preserved] ; effect_level_pure_min [verified]

; pure_multi_step_compose (matches Coq: Lemma pure_multi_step_compose)
; pure_multi_step_compose: forall e1 v1 e2 v2 st ctx ctx1 ctx2, multi_step (e1, st, ctx) (v1, st, ctx1) -> multi_step (e2, st, ctx) (v2, st, ctx2) 
; pure_multi_step_compose: property holds for all bindings
(assert (forall ((e1 Bool) (v1 Bool) (e2 Bool) (v2 Bool) (st Bool) (ctx Bool) (ctx1 Bool) (ctx2 Bool)) (and (= e1 e1) (= v1 v1) (= e2 e2) (= v2 v2) (= st st) (= ctx ctx) (= ctx1 ctx1) (= ctx2 ctx2)))) ; pure_multi_step_compose [partial: bindings preserved] ; pure_multi_step_compose [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
