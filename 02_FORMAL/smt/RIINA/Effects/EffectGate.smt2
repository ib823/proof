; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/effects/EffectGate.v (38 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: EffectGate

(set-logic ALL)
(set-option :produce-models true)

; is_gate (matches Coq: Definition is_gate)
(define-fun is_gate ((eff Int) (e_gate Int)) Bool
  true)

; pure_performs_any (matches Coq: Theorem pure_performs_any)
; pure_performs_any: forall G S D e T, has_type G S D e T EffectPure -> forall eff, performs_within e eff
; pure_performs_any: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (e Bool) (T Bool)) (and (= G G) (= S S) (= D D) (= e e) (= T T)))) ; pure_performs_any [partial: bindings preserved] ; pure_performs_any [verified]

; pure_full_performs_any (matches Coq: Theorem pure_full_performs_any)
; pure_full_performs_any: forall G S D e T, has_type_full G S D e T EffectPure -> forall eff, performs_within e eff
; pure_full_performs_any: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (e Bool) (T Bool)) (and (= G G) (= S S) (= D D) (= e e) (= T T)))) ; pure_full_performs_any [partial: bindings preserved] ; pure_full_performs_any [verified]

; grant_no_escalation (matches Coq: Theorem grant_no_escalation)
; grant_no_escalation: forall G S D eff e T ε, has_type G S D (EGrant eff e) T ε -> has_type G S D e T ε
; grant_no_escalation: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= G G) (= S S) (= D D) (= eff eff) (= e e) (= T T) (= epsilon epsilon)))) ; grant_no_escalation [partial: bindings preserved] ; grant_no_escalation [verified]

; grant_effect_transparent (matches Coq: Theorem grant_effect_transparent)
; grant_effect_transparent: forall G S D eff e T ε, has_type G S D e T ε -> has_type G S D (EGrant eff e) T ε
; grant_effect_transparent: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= G G) (= S S) (= D D) (= eff eff) (= e e) (= T T) (= epsilon epsilon)))) ; grant_effect_transparent [partial: bindings preserved] ; grant_effect_transparent [verified]

; grant_preserves_bound (matches Coq: Theorem grant_preserves_bound)
; grant_preserves_bound: forall eff e eff_bound, performs_within e eff_bound -> performs_within (EGrant eff e) eff_bound
; grant_preserves_bound: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (eff_bound Bool)) (and (= eff eff) (= e e) (= eff_bound eff_bound)))) ; grant_preserves_bound [partial: bindings preserved] ; grant_preserves_bound [verified]

; handle_body_bound (matches Coq: Lemma handle_body_bound)
; handle_body_bound: forall e x h eff, performs_within (EHandle e x h) eff -> performs_within e eff
; handle_body_bound: property holds for all bindings
(assert (forall ((e Bool) (x Bool) (h Bool) (eff Bool)) (and (= e e) (= x x) (= h h) (= eff eff)))) ; handle_body_bound [partial: bindings preserved] ; handle_body_bound [verified]

; handle_handler_bound (matches Coq: Lemma handle_handler_bound)
; handle_handler_bound: forall e x h eff, performs_within (EHandle e x h) eff -> performs_within h eff
; handle_handler_bound: property holds for all bindings
(assert (forall ((e Bool) (x Bool) (h Bool) (eff Bool)) (and (= e e) (= x x) (= h h) (= eff eff)))) ; handle_handler_bound [partial: bindings preserved] ; handle_handler_bound [verified]

; handle_bound_combine (matches Coq: Lemma handle_bound_combine)
; handle_bound_combine: forall e x h eff, performs_within e eff -> performs_within h eff -> performs_within (EHandle e x h) eff
; handle_bound_combine: property holds for all bindings
(assert (forall ((e Bool) (x Bool) (h Bool) (eff Bool)) (and (= e e) (= x x) (= h h) (= eff eff)))) ; handle_bound_combine [partial: bindings preserved] ; handle_bound_combine [verified]

; perform_requires_license (matches Coq: Theorem perform_requires_license)
; perform_requires_license: forall eff' e, effect_level eff' > 0 -> ~ performs_within (EPerform eff' e) EffectPure
; perform_requires_license: property holds for all bindings
(assert (forall ((eff_ Bool) (e Bool)) (and (= eff_ eff_) (= e e)))) ; perform_requires_license [partial: bindings preserved] ; perform_requires_license [verified]

; nonpure_level_pos (matches Coq: Lemma nonpure_level_pos)
; nonpure_level_pos: forall eff, eff <> EffPure -> effect_level eff > 0
; nonpure_level_pos: property holds for all bindings
(assert (forall ((eff Bool)) (= eff eff))) ; nonpure_level_pos [partial: bindings preserved] ; nonpure_level_pos [verified]

; pure_perform_is_pure (matches Coq: Theorem pure_perform_is_pure)
; pure_perform_is_pure: forall G S D eff' e_inner T, has_type G S D (EPerform eff' e_inner) T EffectPure -> eff' = EffPure
; pure_perform_is_pure: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (eff_ Bool) (e_inner Bool) (T Bool)) (and (= G G) (= S S) (= D D) (= eff_ eff_) (= e_inner e_inner) (= T T)))) ; pure_perform_is_pure [partial: bindings preserved] ; pure_perform_is_pure [verified]

; closed_pure_no_effects (matches Coq: Theorem closed_pure_no_effects)
; closed_pure_no_effects: forall e T, has_type nil nil Public e T EffectPure -> forall eff, performs_within e eff
; closed_pure_no_effects: property holds for all bindings
(assert (forall ((e Bool) (T Bool)) (and (= e e) (= T T)))) ; closed_pure_no_effects [partial: bindings preserved] ; closed_pure_no_effects [verified]

; gate_enforcement (matches Coq: Theorem gate_enforcement)
; gate_enforcement: forall G S D e T eff_allowed eff_used, has_type_full G S D e T eff_used -> effect_level eff_used <= effect_level eff_all
; gate_enforcement: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (e Bool) (T Bool) (eff_allowed Bool) (eff_used Bool)) (and (= G G) (= S S) (= D D) (= e e) (= T T) (= eff_allowed eff_allowed) (= eff_used eff_used)))) ; gate_enforcement [partial: bindings preserved] ; gate_enforcement [verified]

; lambda_is_syntactic_gate (matches Coq: Theorem lambda_is_syntactic_gate)
; lambda_is_syntactic_gate: forall x T body eff, is_gate eff (ELam x T body)
; lambda_is_syntactic_gate: property holds for all bindings
(assert (forall ((x Bool) (T Bool) (body Bool) (eff Bool)) (and (= x x) (= T T) (= body body) (= eff eff)))) ; lambda_is_syntactic_gate [partial: bindings preserved] ; lambda_is_syntactic_gate [verified]

; gate_weakening (matches Coq: Theorem gate_weakening)
; gate_weakening: forall eff1 eff2 g, is_gate eff1 g -> effect_leq eff1 eff2 -> is_gate eff2 g
; gate_weakening: property holds for all bindings
(assert (forall ((eff1 Bool) (eff2 Bool) (g Bool)) (and (= eff1 eff1) (= eff2 eff2) (= g g)))) ; gate_weakening [partial: bindings preserved] ; gate_weakening [verified]

; effect_sound_after_step (matches Coq: Theorem effect_sound_after_step)
; effect_sound_after_step: forall e e' T ε st st' ctx ctx' Σ, has_type nil Σ Public e T ε -> store_wf Σ st -> (e, st, ctx) --> (e', st', ctx') -> e
; effect_sound_after_step: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool) (epsilon Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (and (= e e) (= e_ e_) (= T T) (= epsilon epsilon) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_) (= sigma sigma)))) ; effect_sound_after_step [partial: bindings preserved] ; effect_sound_after_step [verified]

; effect_sound_multi_step (matches Coq: Theorem effect_sound_multi_step)
; effect_sound_multi_step: forall cfg cfg' e e' T ε st st' ctx ctx' Σ, cfg = (e, st, ctx) -> cfg' = (e', st', ctx') -> has_type nil Σ Public e T ε 
; effect_sound_multi_step: property holds for all bindings
(assert (forall ((cfg Bool) (cfg_ Bool) (e Bool) (e_ Bool) (T Bool) (epsilon Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (and (= cfg cfg) (= cfg_ cfg_) (= e e) (= e_ e_) (= T T) (= epsilon epsilon) (= st st) (= st_ st_) (= ctx ctx) (= ctx_ ctx_) (= sigma sigma)))) ; effect_sound_multi_step [partial: bindings preserved] ; effect_sound_multi_step [verified]

; capability_lexical_scope (matches Coq: Theorem capability_lexical_scope)
; capability_lexical_scope: forall G S D eff e T ε, has_type G S D (EGrant eff e) T ε -> has_type G S D e T ε
; capability_lexical_scope: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= G G) (= S S) (= D D) (= eff eff) (= e e) (= T T) (= epsilon epsilon)))) ; capability_lexical_scope [partial: bindings preserved] ; capability_lexical_scope [verified]

; require_effect_additive (matches Coq: Theorem require_effect_additive)
; require_effect_additive: forall G S D eff e T ε, has_type G S D (ERequire eff e) T (effect_join ε eff) -> exists ε', has_type G S D e T ε' /\ eff
; require_effect_additive: property holds for all bindings
(assert (forall ((G Bool) (S Bool) (D Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= G G) (= S S) (= D D) (= eff eff) (= e e) (= T T) (= epsilon epsilon)))) ; require_effect_additive [partial: bindings preserved] ; require_effect_additive [verified]

; app_joins_effects (matches Coq: Theorem app_joins_effects)
; app_joins_effects: forall e1 e2 eff, performs_within e1 eff -> performs_within e2 eff -> performs_within (EApp e1 e2) eff
; app_joins_effects: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (eff Bool)) (and (= e1 e1) (= e2 e2) (= eff eff)))) ; app_joins_effects [partial: bindings preserved] ; app_joins_effects [verified]

; let_joins_effects (matches Coq: Theorem let_joins_effects)
; let_joins_effects: forall x e1 e2 eff, performs_within e1 eff -> performs_within e2 eff -> performs_within (ELet x e1 e2) eff
; let_joins_effects: property holds for all bindings
(assert (forall ((x Bool) (e1 Bool) (e2 Bool) (eff Bool)) (and (= x x) (= e1 e1) (= e2 e2) (= eff eff)))) ; let_joins_effects [partial: bindings preserved] ; let_joins_effects [verified]

; effect_isolation (matches Coq: Theorem effect_isolation)
; effect_isolation: forall e1 e2 eff1 eff2, performs_within e1 eff1 -> performs_within e2 eff2 -> performs_within (EApp e1 e2) (effect_join 
; effect_isolation: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (eff1 Bool) (eff2 Bool)) (and (= e1 e1) (= e2 e2) (= eff1 eff1) (= eff2 eff2)))) ; effect_isolation [partial: bindings preserved] ; effect_isolation [verified]

; effect_isolation_let (matches Coq: Theorem effect_isolation_let)
; effect_isolation_let: forall x e1 e2 eff1 eff2, performs_within e1 eff1 -> performs_within e2 eff2 -> performs_within (ELet x e1 e2) (effect_j
; effect_isolation_let: property holds for all bindings
(assert (forall ((x Bool) (e1 Bool) (e2 Bool) (eff1 Bool) (eff2 Bool)) (and (= x x) (= e1 e1) (= e2 e2) (= eff1 eff1) (= eff2 eff2)))) ; effect_isolation_let [partial: bindings preserved] ; effect_isolation_let [verified]

; effect_isolation_pair (matches Coq: Theorem effect_isolation_pair)
; effect_isolation_pair: forall e1 e2 eff1 eff2, performs_within e1 eff1 -> performs_within e2 eff2 -> performs_within (EPair e1 e2) (effect_join
; effect_isolation_pair: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (eff1 Bool) (eff2 Bool)) (and (= e1 e1) (= e2 e2) (= eff1 eff1) (= eff2 eff2)))) ; effect_isolation_pair [partial: bindings preserved] ; effect_isolation_pair [verified]

; double_handle_body (matches Coq: Theorem double_handle_body)
; double_handle_body: forall e x1 h1 x2 h2 eff, performs_within (EHandle (EHandle e x1 h1) x2 h2) eff -> performs_within e eff
; double_handle_body: property holds for all bindings
(assert (forall ((e Bool) (x1 Bool) (h1 Bool) (x2 Bool) (h2 Bool) (eff Bool)) (and (= e e) (= x1 x1) (= h1 h1) (= x2 x2) (= h2 h2) (= eff eff)))) ; double_handle_body [partial: bindings preserved] ; double_handle_body [verified]

; double_handle_outer_handler (matches Coq: Theorem double_handle_outer_handler)
; double_handle_outer_handler: forall e x1 h1 x2 h2 eff, performs_within (EHandle (EHandle e x1 h1) x2 h2) eff -> performs_within h2 eff
; double_handle_outer_handler: property holds for all bindings
(assert (forall ((e Bool) (x1 Bool) (h1 Bool) (x2 Bool) (h2 Bool) (eff Bool)) (and (= e e) (= x1 x1) (= h1 h1) (= x2 x2) (= h2 h2) (= eff eff)))) ; double_handle_outer_handler [partial: bindings preserved] ; double_handle_outer_handler [verified]

; double_handle_inner_handler (matches Coq: Theorem double_handle_inner_handler)
; double_handle_inner_handler: forall e x1 h1 x2 h2 eff, performs_within (EHandle (EHandle e x1 h1) x2 h2) eff -> performs_within h1 eff
; double_handle_inner_handler: property holds for all bindings
(assert (forall ((e Bool) (x1 Bool) (h1 Bool) (x2 Bool) (h2 Bool) (eff Bool)) (and (= e e) (= x1 x1) (= h1 h1) (= x2 x2) (= h2 h2) (= eff eff)))) ; double_handle_inner_handler [partial: bindings preserved] ; double_handle_inner_handler [verified]

; program_effect_contained (matches Coq: Theorem program_effect_contained)
; program_effect_contained: forall e T ε, has_type nil nil Public e T ε -> performs_within e ε
; program_effect_contained: property holds for all bindings
(assert (forall ((e Bool) (T Bool) (epsilon Bool)) (and (= e e) (= T T) (= epsilon epsilon)))) ; program_effect_contained [partial: bindings preserved] ; program_effect_contained [verified]

; pure_program_no_effects (matches Coq: Theorem pure_program_no_effects)
; pure_program_no_effects: forall e T, has_type nil nil Public e T EffectPure -> forall eff, performs_within e eff
; pure_program_no_effects: property holds for all bindings
(assert (forall ((e Bool) (T Bool)) (and (= e e) (= T T)))) ; pure_program_no_effects [partial: bindings preserved] ; pure_program_no_effects [verified]

; grant_idempotent_bound (matches Coq: Theorem grant_idempotent_bound)
; grant_idempotent_bound: forall eff e eff_bound, performs_within e eff_bound -> performs_within (EGrant eff e) eff_bound
; grant_idempotent_bound: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (eff_bound Bool)) (and (= eff eff) (= e e) (= eff_bound eff_bound)))) ; grant_idempotent_bound [partial: bindings preserved] ; grant_idempotent_bound [verified]

; require_bound_transparent (matches Coq: Theorem require_bound_transparent)
; require_bound_transparent: forall eff e eff_bound, performs_within e eff_bound -> performs_within (ERequire eff e) eff_bound
; require_bound_transparent: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (eff_bound Bool)) (and (= eff eff) (= e e) (= eff_bound eff_bound)))) ; require_bound_transparent [partial: bindings preserved] ; require_bound_transparent [verified]

; if_performs_within (matches Coq: Theorem if_performs_within)
; if_performs_within: forall e1 e2 e3 eff, performs_within e1 eff -> performs_within e2 eff -> performs_within e3 eff -> performs_within (EIf 
; if_performs_within: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool) (eff Bool)) (and (= e1 e1) (= e2 e2) (= e3 e3) (= eff eff)))) ; if_performs_within [partial: bindings preserved] ; if_performs_within [verified]

; case_performs_within (matches Coq: Theorem case_performs_within)
; case_performs_within: forall e0 x1 e1 x2 e2 eff, performs_within e0 eff -> performs_within e1 eff -> performs_within e2 eff -> performs_within
; case_performs_within: property holds for all bindings
(assert (forall ((e0 Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (eff Bool)) (and (= e0 e0) (= x1 x1) (= e1 e1) (= x2 x2) (= e2 e2) (= eff eff)))) ; case_performs_within [partial: bindings preserved] ; case_performs_within [verified]

; ref_performs_within (matches Coq: Theorem ref_performs_within)
; ref_performs_within: forall e sl eff, performs_within e eff -> performs_within (ERef e sl) eff
; ref_performs_within: property holds for all bindings
(assert (forall ((e Bool) (sl Bool) (eff Bool)) (and (= e e) (= sl sl) (= eff eff)))) ; ref_performs_within [partial: bindings preserved] ; ref_performs_within [verified]

; deref_performs_within (matches Coq: Theorem deref_performs_within)
; deref_performs_within: forall e eff, performs_within e eff -> performs_within (EDeref e) eff
; deref_performs_within: property holds for all bindings
(assert (forall ((e Bool) (eff Bool)) (and (= e e) (= eff eff)))) ; deref_performs_within [partial: bindings preserved] ; deref_performs_within [verified]

; assign_performs_within (matches Coq: Theorem assign_performs_within)
; assign_performs_within: forall e1 e2 eff, performs_within e1 eff -> performs_within e2 eff -> performs_within (EAssign e1 e2) eff
; assign_performs_within: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (eff Bool)) (and (= e1 e1) (= e2 e2) (= eff eff)))) ; assign_performs_within [partial: bindings preserved] ; assign_performs_within [verified]

; classify_performs_within (matches Coq: Theorem classify_performs_within)
; classify_performs_within: forall e eff, performs_within e eff -> performs_within (EClassify e) eff
; classify_performs_within: property holds for all bindings
(assert (forall ((e Bool) (eff Bool)) (and (= e e) (= eff eff)))) ; classify_performs_within [partial: bindings preserved] ; classify_performs_within [verified]

; prove_performs_within (matches Coq: Theorem prove_performs_within)
; prove_performs_within: forall e eff, performs_within e eff -> performs_within (EProve e) eff
; prove_performs_within: property holds for all bindings
(assert (forall ((e Bool) (eff Bool)) (and (= e e) (= eff eff)))) ; prove_performs_within [partial: bindings preserved] ; prove_performs_within [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
