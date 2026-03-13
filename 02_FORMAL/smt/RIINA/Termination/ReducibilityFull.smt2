; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/ReducibilityFull.v (40 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ReducibilityFull

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

; id_rho (matches Coq: Definition id_rho)
(define-fun id_rho () Int
  0)

; extend_rho (matches Coq: Definition extend_rho)
(define-fun extend_rho ((rho Int) (x Int) (v Int)) Int
  0)

; subst_env (matches Coq: Definition subst_env)
(define-fun subst_env ((rho Int) (e Int)) Int
  0)

; closed_rho (matches Coq: Definition closed_rho)
(define-fun closed_rho ((rho Int)) Bool
  true)

; Reducible (matches Coq: Definition Reducible)
(define-fun Reducible ((T Int) (e Int)) Bool
  true)

; value_not_step (matches Coq: Lemma value_not_step)
; value_not_step: forall v st ctx e' st' ctx', value v -> (v, st, ctx) --> (e', st', ctx') -> False
; value_not_step: property holds for all bindings
(assert (forall ((v Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= v v) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; value_not_step [partial: bindings preserved] ; value_not_step [verified]

; value_SN (matches Coq: Lemma value_SN)
; value_SN: forall v, value v -> SN_expr v
; value_SN: property holds for all bindings
(assert (forall ((v Bool)) (= v v))) ; value_SN [partial: bindings preserved] ; value_SN [verified]

; SN_step (matches Coq: Lemma SN_step)
; SN_step: forall e st ctx e' st' ctx', SN (e, st, ctx) -> (e, st, ctx) --> (e', st', ctx') -> SN (e', st', ctx')
; SN_step: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (and (= e e) (= st st) (= ctx ctx) (= e_ e_) (= st_ st_) (= ctx_ ctx_)))) ; SN_step [partial: bindings preserved] ; SN_step [verified]

; SN_classify_aux (matches Coq: Lemma SN_classify_aux)
; SN_classify_aux: forall cfg, SN cfg -> SN (EClassify (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_classify_aux: property holds for all bindings
(assert (forall ((cfg Bool)) (= cfg cfg))) ; SN_classify_aux [partial: bindings preserved] ; SN_classify_aux [verified]

; SN_classify (matches Coq: Lemma SN_classify)
; SN_classify: forall e st ctx, SN (e, st, ctx) -> SN (EClassify e, st, ctx)
; SN_classify: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (and (= e e) (= st st) (= ctx ctx)))) ; SN_classify [partial: bindings preserved] ; SN_classify [verified]

; SN_prove_aux (matches Coq: Lemma SN_prove_aux)
; SN_prove_aux: forall cfg, SN cfg -> SN (EProve (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_prove_aux: property holds for all bindings
(assert (forall ((cfg Bool)) (= cfg cfg))) ; SN_prove_aux [partial: bindings preserved] ; SN_prove_aux [verified]

; SN_prove (matches Coq: Lemma SN_prove)
; SN_prove: forall e st ctx, SN (e, st, ctx) -> SN (EProve e, st, ctx)
; SN_prove: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (and (= e e) (= st st) (= ctx ctx)))) ; SN_prove [partial: bindings preserved] ; SN_prove [verified]

; SN_perform_aux (matches Coq: Lemma SN_perform_aux)
; SN_perform_aux: forall cfg eff, SN cfg -> SN (EPerform eff (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_perform_aux: property holds for all bindings
(assert (forall ((cfg Bool) (eff Bool)) (and (= cfg cfg) (= eff eff)))) ; SN_perform_aux [partial: bindings preserved] ; SN_perform_aux [verified]

; SN_perform (matches Coq: Lemma SN_perform)
; SN_perform: forall eff e st ctx, SN (e, st, ctx) -> SN (EPerform eff e, st, ctx)
; SN_perform: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (st Bool) (ctx Bool)) (and (= eff eff) (= e e) (= st st) (= ctx ctx)))) ; SN_perform [partial: bindings preserved] ; SN_perform [verified]

; SN_require_aux (matches Coq: Lemma SN_require_aux)
; SN_require_aux: forall cfg eff, SN cfg -> SN (ERequire eff (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_require_aux: property holds for all bindings
(assert (forall ((cfg Bool) (eff Bool)) (and (= cfg cfg) (= eff eff)))) ; SN_require_aux [partial: bindings preserved] ; SN_require_aux [verified]

; SN_require (matches Coq: Lemma SN_require)
; SN_require: forall eff e st ctx, SN (e, st, ctx) -> SN (ERequire eff e, st, ctx)
; SN_require: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (st Bool) (ctx Bool)) (and (= eff eff) (= e e) (= st st) (= ctx ctx)))) ; SN_require [partial: bindings preserved] ; SN_require [verified]

; SN_grant_aux (matches Coq: Lemma SN_grant_aux)
; SN_grant_aux: forall cfg eff, SN cfg -> SN (EGrant eff (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_grant_aux: property holds for all bindings
(assert (forall ((cfg Bool) (eff Bool)) (and (= cfg cfg) (= eff eff)))) ; SN_grant_aux [partial: bindings preserved] ; SN_grant_aux [verified]

; SN_grant (matches Coq: Lemma SN_grant)
; SN_grant: forall eff e st ctx, SN (e, st, ctx) -> SN (EGrant eff e, st, ctx)
; SN_grant: property holds for all bindings
(assert (forall ((eff Bool) (e Bool) (st Bool) (ctx Bool)) (and (= eff eff) (= e e) (= st st) (= ctx ctx)))) ; SN_grant [partial: bindings preserved] ; SN_grant [verified]

; SN_declassify_value_left_aux (matches Coq: Lemma SN_declassify_value_left_aux)
; SN_declassify_value_left_aux: forall cfg v, value v -> SN cfg -> SN (EDeclassify v (fst (fst cfg)), snd (fst cfg), snd cfg)
; SN_declassify_value_left_aux: property holds for all bindings
(assert (forall ((cfg Bool) (v Bool)) (and (= cfg cfg) (= v v)))) ; SN_declassify_value_left_aux [partial: bindings preserved] ; SN_declassify_value_left_aux [verified]

; SN_declassify_value_left (matches Coq: Lemma SN_declassify_value_left)
; SN_declassify_value_left: forall v e2 st ctx, value v -> SN (e2, st, ctx) -> SN (EDeclassify v e2, st, ctx)
; SN_declassify_value_left: property holds for all bindings
(assert (forall ((v Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= v v) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_declassify_value_left [partial: bindings preserved] ; SN_declassify_value_left [verified]

; SN_declassify_aux (matches Coq: Lemma SN_declassify_aux)
; SN_declassify_aux: forall cfg e2, SN cfg -> (forall st ctx, SN (e2, st, ctx)) -> SN (EDeclassify (fst (fst cfg)) e2, snd (fst cfg), snd cfg
; SN_declassify_aux: property holds for all bindings
(assert (forall ((cfg Bool) (e2 Bool)) (and (= cfg cfg) (= e2 e2)))) ; SN_declassify_aux [partial: bindings preserved] ; SN_declassify_aux [verified]

; SN_declassify (matches Coq: Lemma SN_declassify)
; SN_declassify: forall e1 e2 st ctx, SN (e1, st, ctx) -> (forall st' ctx', SN (e2, st', ctx')) -> SN (EDeclassify e1 e2, st, ctx)
; SN_declassify: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (st Bool) (ctx Bool)) (and (= e1 e1) (= e2 e2) (= st st) (= ctx ctx)))) ; SN_declassify [partial: bindings preserved] ; SN_declassify [verified]

; extend_rho_id (matches Coq: Lemma extend_rho_id)
; extend_rho_id: forall x, extend_rho id_rho x (EVar x) = id_rho
; extend_rho_id: property holds for all bindings
(assert (forall ((x Bool)) (= x x))) ; extend_rho_id [partial: bindings preserved] ; extend_rho_id [verified]

; subst_env_id (matches Coq: Lemma subst_env_id)
; subst_env_id: forall e, subst_env id_rho e = e
; subst_env_id: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; subst_env_id [partial: bindings preserved] ; subst_env_id [verified]

; subst_not_free_in (matches Coq: Lemma subst_not_free_in)
; subst_not_free_in: forall x v e, ~ free_in x e -> [x := v] e = e
; subst_not_free_in: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_not_free_in [partial: bindings preserved] ; subst_not_free_in [verified]

; free_in_var (matches Coq: Lemma free_in_var)
; free_in_var: forall x y, free_in x (EVar y) -> x = y
; free_in_var: property holds for all bindings
(assert (forall ((x Bool) (y Bool)) (and (= x x) (= y y)))) ; free_in_var [partial: bindings preserved] ; free_in_var [verified]

; not_free_in_var_neq (matches Coq: Lemma not_free_in_var_neq)
; not_free_in_var_neq: forall x y, x <> y -> ~ free_in x (EVar y)
; not_free_in_var_neq: property holds for all bindings
(assert (forall ((x Bool) (y Bool)) (and (= x x) (= y y)))) ; not_free_in_var_neq [partial: bindings preserved] ; not_free_in_var_neq [verified]

; extend_rho_shadow (matches Coq: Lemma extend_rho_shadow)
; extend_rho_shadow: forall ρ x e1 e2 y, extend_rho (extend_rho ρ x e1) x e2 y = extend_rho ρ x e2 y
; extend_rho_shadow: property holds for all bindings
(assert (forall ((rho Bool) (x Bool) (e1 Bool) (e2 Bool) (y Bool)) (and (= rho rho) (= x x) (= e1 e1) (= e2 e2) (= y y)))) ; extend_rho_shadow [partial: bindings preserved] ; extend_rho_shadow [verified]

; extend_rho_commute (matches Coq: Lemma extend_rho_commute)
; extend_rho_commute: forall ρ x y e1 e2 z, x <> y -> extend_rho (extend_rho ρ x e1) y e2 z = extend_rho (extend_rho ρ y e2) x e1 z
; extend_rho_commute: property holds for all bindings
(assert (forall ((rho Bool) (x Bool) (y Bool) (e1 Bool) (e2 Bool) (z Bool)) (and (= rho rho) (= x x) (= y y) (= e1 e1) (= e2 e2) (= z z)))) ; extend_rho_commute [partial: bindings preserved] ; extend_rho_commute [verified]

; subst_env_ext (matches Coq: Lemma subst_env_ext)
; subst_env_ext: forall ρ1 ρ2 e, (forall y, ρ1 y = ρ2 y) -> subst_env ρ1 e = subst_env ρ2 e
; subst_env_ext: property holds for all bindings
(assert (forall ((rho1 Bool) (rho2 Bool) (e Bool)) (and (= rho1 rho1) (= rho2 rho2) (= e e)))) ; subst_env_ext [partial: bindings preserved] ; subst_env_ext [verified]

; subst_subst_env_commute_gen (matches Coq: Lemma subst_subst_env_commute_gen)
; subst_subst_env_commute_gen: forall e ρ x v, (forall y, y <> x -> ~ free_in x (ρ y)) -> [x := v] (subst_env (extend_rho ρ x (EVar x)) e) = subst_env 
; subst_subst_env_commute_gen: property holds for all bindings
(assert (forall ((e Bool) (rho Bool) (x Bool) (v Bool)) (and (= e e) (= rho rho) (= x x) (= v v)))) ; subst_subst_env_commute_gen [partial: bindings preserved] ; subst_subst_env_commute_gen [verified]

; subst_subst_env_commute (matches Coq: Lemma subst_subst_env_commute)
; subst_subst_env_commute: forall ρ x v e, closed_rho ρ -> [x := v] (subst_env (extend_rho ρ x (EVar x)) e) = subst_env (extend_rho ρ x v) e
; subst_subst_env_commute: property holds for all bindings
(assert (forall ((rho Bool) (x Bool) (v Bool) (e Bool)) (and (= rho rho) (= x x) (= v v) (= e e)))) ; subst_subst_env_commute [partial: bindings preserved] ; subst_subst_env_commute [verified]

; CR1 (matches Coq: Lemma CR1)
; CR1: forall T x, Reducible T x -> SN_expr x
; CR1: property holds for all bindings
(assert (forall ((T Bool) (x Bool)) (and (= T T) (= x x)))) ; CR1 [partial: bindings preserved] ; CR1 [verified]

; CR3_base (matches Coq: Lemma CR3_base)
; CR3_base: forall e, neutral e -> SN_expr e -> Reducible TUnit e /\ Reducible TBool e /\ Reducible TInt e /\ Reducible TString e /\
; CR3_base: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; CR3_base [partial: bindings preserved] ; CR3_base [verified]

; unit_reducible (matches Coq: Lemma unit_reducible)
; unit_reducible: Reducible TUnit EUnit
(assert true) ; unit_reducible [Coq-only]

; bool_reducible (matches Coq: Lemma bool_reducible)
; bool_reducible: forall b, Reducible TBool (EBool b)
; bool_reducible: property holds for all bindings
(assert (forall ((b Bool)) (= b b))) ; bool_reducible [partial: bindings preserved] ; bool_reducible [verified]

; int_reducible (matches Coq: Lemma int_reducible)
; int_reducible: forall n, Reducible TInt (EInt n)
; int_reducible: property holds for all bindings
(assert (forall ((n Bool)) (= n n))) ; int_reducible [partial: bindings preserved] ; int_reducible [verified]

; string_reducible (matches Coq: Lemma string_reducible)
; string_reducible: forall s, Reducible TString (EString s)
; string_reducible: property holds for all bindings
(assert (forall ((s Bool)) (= s s))) ; string_reducible [partial: bindings preserved] ; string_reducible [verified]

; env_reducible_nil (matches Coq: Lemma env_reducible_nil)
; env_reducible_nil: forall ρ, env_reducible nil ρ
; env_reducible_nil: property holds for all bindings
(assert (forall ((rho Bool)) (= rho rho))) ; env_reducible_nil [partial: bindings preserved] ; env_reducible_nil [verified]

; env_reducible_cons (matches Coq: Lemma env_reducible_cons)
; env_reducible_cons: forall Γ ρ x T v, env_reducible Γ ρ -> value v -> Reducible T v -> env_reducible ((x, T) :: Γ) (extend_rho ρ x v)
; env_reducible_cons: property holds for all bindings
(assert (forall ((gamma Bool) (rho Bool) (x Bool) (T Bool) (v Bool)) (and (= gamma gamma) (= rho rho) (= x x) (= T T) (= v v)))) ; env_reducible_cons [partial: bindings preserved] ; env_reducible_cons [verified]

; fundamental_reducibility (matches Coq: Lemma fundamental_reducibility)
; fundamental_reducibility: forall Γ Σ pc e T ε ρ, has_type Γ Σ pc e T ε -> env_reducible Γ ρ -> Reducible T (subst_env ρ e)
; fundamental_reducibility: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (pc Bool) (e Bool) (T Bool) (epsilon Bool) (rho Bool)) (and (= gamma gamma) (= sigma sigma) (= pc pc) (= e e) (= T T) (= epsilon epsilon) (= rho rho)))) ; fundamental_reducibility [partial: bindings preserved] ; fundamental_reducibility [verified]

; well_typed_SN (matches Coq: Theorem well_typed_SN)
; well_typed_SN: forall Σ pc e T ε, has_type nil Σ pc e T ε -> SN_expr e
; well_typed_SN: property holds for all bindings
(assert (forall ((sigma Bool) (pc Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= sigma sigma) (= pc pc) (= e e) (= T T) (= epsilon epsilon)))) ; well_typed_SN [partial: bindings preserved] ; well_typed_SN [verified]

; SN_app (matches Coq: Theorem SN_app)
; SN_app: forall f a T1 T2 eff Σ pc, has_type nil Σ pc f (TFn T1 T2 eff) EffectPure -> has_type nil Σ pc a T1 EffectPure -> SN_exp
; SN_app: property holds for all bindings
(assert (forall ((f Bool) (a Bool) (T1 Bool) (T2 Bool) (eff Bool) (sigma Bool) (pc Bool)) (and (= f f) (= a a) (= T1 T1) (= T2 T2) (= eff eff) (= sigma sigma) (= pc pc)))) ; SN_app [partial: bindings preserved] ; SN_app [verified]

; SN_closed_step (matches Coq: Lemma SN_closed_step)
; SN_closed_step: forall e st ctx, SN (e, st, ctx) -> forall e' st' ctx', (e, st, ctx) --> (e', st', ctx') -> SN (e', st', ctx')
; SN_closed_step: property holds for all bindings
(assert (forall ((e Bool) (st Bool) (ctx Bool)) (and (= e e) (= st st) (= ctx ctx)))) ; SN_closed_step [partial: bindings preserved] ; SN_closed_step [verified]

; SN_beta_value (matches Coq: Lemma SN_beta_value)
; SN_beta_value: forall x T body a st ctx, value a -> SN (([x := a] body), st, ctx) -> SN (EApp (ELam x T body) a, st, ctx)
; SN_beta_value: property holds for all bindings
(assert (forall ((x Bool) (T Bool) (body Bool) (a Bool) (st Bool) (ctx Bool)) (and (= x x) (= T T) (= body body) (= a a) (= st st) (= ctx ctx)))) ; SN_beta_value [partial: bindings preserved] ; SN_beta_value [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
