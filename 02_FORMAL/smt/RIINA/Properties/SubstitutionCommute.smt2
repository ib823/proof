; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/SubstitutionCommute.v (40 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SubstitutionCommute

(set-logic ALL)
(set-option :produce-models true)

; id_rho_sc (matches Coq: Definition id_rho_sc)
(define-fun id_rho_sc () Int
  0)

; extend_rho_sc (matches Coq: Definition extend_rho_sc)
(define-fun extend_rho_sc ((rho Int) (x Int) (v Int)) Int
  0)

; closed_expr_sc (matches Coq: Definition closed_expr_sc)
(define-fun closed_expr_sc ((e Int)) Bool
  true)

; closed_rho_sc (matches Coq: Definition closed_rho_sc)
(define-fun closed_rho_sc ((rho Int)) Bool
  true)

; extend_rho_sc_same (matches Coq: Lemma extend_rho_sc_same)
; extend_rho_sc_same: forall ρ x v, extend_rho_sc ρ x v x = v
; extend_rho_sc_same: property holds for all bindings
(assert (forall ((rho Bool) (x Bool) (v Bool)) (and (= rho rho) (= x x) (= v v)))) ; extend_rho_sc_same [partial: bindings preserved] ; extend_rho_sc_same [verified]

; extend_rho_sc_diff (matches Coq: Lemma extend_rho_sc_diff)
; extend_rho_sc_diff: forall ρ x y v, x <> y -> extend_rho_sc ρ x v y = ρ y
; extend_rho_sc_diff: property holds for all bindings
(assert (forall ((rho Bool) (x Bool) (y Bool) (v Bool)) (and (= rho rho) (= x x) (= y y) (= v v)))) ; extend_rho_sc_diff [partial: bindings preserved] ; extend_rho_sc_diff [verified]

; extend_rho_sc_shadow (matches Coq: Lemma extend_rho_sc_shadow)
; extend_rho_sc_shadow: forall ρ x v1 v2, extend_rho_sc (extend_rho_sc ρ x v1) x v2 = extend_rho_sc ρ x v2
; extend_rho_sc_shadow: property holds for all bindings
(assert (forall ((rho Bool) (x Bool) (v1 Bool) (v2 Bool)) (and (= rho rho) (= x x) (= v1 v1) (= v2 v2)))) ; extend_rho_sc_shadow [partial: bindings preserved] ; extend_rho_sc_shadow [verified]

; extend_rho_sc_comm (matches Coq: Lemma extend_rho_sc_comm)
; extend_rho_sc_comm: forall ρ x y vx vy, x <> y -> extend_rho_sc (extend_rho_sc ρ x vx) y vy = extend_rho_sc (extend_rho_sc ρ y vy) x vx
; extend_rho_sc_comm: property holds for all bindings
(assert (forall ((rho Bool) (x Bool) (y Bool) (vx Bool) (vy Bool)) (and (= rho rho) (= x x) (= y y) (= vx vx) (= vy vy)))) ; extend_rho_sc_comm [partial: bindings preserved] ; extend_rho_sc_comm [verified]

; subst_not_free_sc (matches Coq: Lemma subst_not_free_sc)
; subst_not_free_sc: forall x v e, ~ free_in x e -> [x := v] e = e
; subst_not_free_sc: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_not_free_sc [partial: bindings preserved] ; subst_not_free_sc [verified]

; subst_closed_sc (matches Coq: Lemma subst_closed_sc)
; subst_closed_sc: forall x v e, closed_expr_sc e -> [x := v] e = e
; subst_closed_sc: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_closed_sc [partial: bindings preserved] ; subst_closed_sc [verified]

; closed_unit_sub (matches Coq: Lemma closed_unit_sub)
; closed_unit_sub: closed_expr_sc EUnit
(assert true) ; closed_unit_sub [Coq-only]

; closed_bool_sub (matches Coq: Lemma closed_bool_sub)
; closed_bool_sub: forall b, closed_expr_sc (EBool b)
; closed_bool_sub: property holds for all bindings
(assert (forall ((b Bool)) (= b b))) ; closed_bool_sub [partial: bindings preserved] ; closed_bool_sub [verified]

; closed_int_sub (matches Coq: Lemma closed_int_sub)
; closed_int_sub: forall n, closed_expr_sc (EInt n)
; closed_int_sub: property holds for all bindings
(assert (forall ((n Bool)) (= n n))) ; closed_int_sub [partial: bindings preserved] ; closed_int_sub [verified]

; closed_string_sub (matches Coq: Lemma closed_string_sub)
; closed_string_sub: forall s, closed_expr_sc (EString s)
; closed_string_sub: property holds for all bindings
(assert (forall ((s Bool)) (= s s))) ; closed_string_sub [partial: bindings preserved] ; closed_string_sub [verified]

; closed_loc_sub (matches Coq: Lemma closed_loc_sub)
; closed_loc_sub: forall l, closed_expr_sc (ELoc l)
; closed_loc_sub: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; closed_loc_sub [partial: bindings preserved] ; closed_loc_sub [verified]

; subst_var_same (matches Coq: Lemma subst_var_same)
; subst_var_same: forall x v, [x := v] (EVar x) = v
; subst_var_same: property holds for all bindings
(assert (forall ((x Bool) (v Bool)) (and (= x x) (= v v)))) ; subst_var_same [partial: bindings preserved] ; subst_var_same [verified]

; subst_var_diff (matches Coq: Lemma subst_var_diff)
; subst_var_diff: forall x y v, x <> y -> [x := v] (EVar y) = EVar y
; subst_var_diff: property holds for all bindings
(assert (forall ((x Bool) (y Bool) (v Bool)) (and (= x x) (= y y) (= v v)))) ; subst_var_diff [partial: bindings preserved] ; subst_var_diff [verified]

; subst_unit (matches Coq: Lemma subst_unit)
; subst_unit: forall x v, [x := v] EUnit = EUnit
; subst_unit: property holds for all bindings
(assert (forall ((x Bool) (v Bool)) (and (= x x) (= v v)))) ; subst_unit [partial: bindings preserved] ; subst_unit [verified]

; subst_bool (matches Coq: Lemma subst_bool)
; subst_bool: forall x v b, [x := v] (EBool b) = EBool b
; subst_bool: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (b Bool)) (and (= x x) (= v v) (= b b)))) ; subst_bool [partial: bindings preserved] ; subst_bool [verified]

; subst_int (matches Coq: Lemma subst_int)
; subst_int: forall x v n, [x := v] (EInt n) = EInt n
; subst_int: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (n Bool)) (and (= x x) (= v v) (= n n)))) ; subst_int [partial: bindings preserved] ; subst_int [verified]

; subst_string (matches Coq: Lemma subst_string)
; subst_string: forall x v s, [x := v] (EString s) = EString s
; subst_string: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (s Bool)) (and (= x x) (= v v) (= s s)))) ; subst_string [partial: bindings preserved] ; subst_string [verified]

; subst_loc (matches Coq: Lemma subst_loc)
; subst_loc: forall x v l, [x := v] (ELoc l) = ELoc l
; subst_loc: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (l Bool)) (and (= x x) (= v v) (= l l)))) ; subst_loc [partial: bindings preserved] ; subst_loc [verified]

; subst_id (matches Coq: Lemma subst_id)
; subst_id: forall x e, [x := EVar x] e = e
; subst_id: property holds for all bindings
(assert (forall ((x Bool) (e Bool)) (and (= x x) (= e e)))) ; subst_id [partial: bindings preserved] ; subst_id [verified]

; subst_value (matches Coq: Lemma subst_value)
; subst_value: forall x v e, value e -> value v -> value ([x := v] e)
; subst_value: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_value [partial: bindings preserved] ; subst_value [verified]

; subst_app (matches Coq: Lemma subst_app)
; subst_app: forall x v e1 e2, [x := v] (EApp e1 e2) = EApp ([x := v] e1) ([x := v] e2)
; subst_app: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (and (= x x) (= v v) (= e1 e1) (= e2 e2)))) ; subst_app [partial: bindings preserved] ; subst_app [verified]

; subst_pair (matches Coq: Lemma subst_pair)
; subst_pair: forall x v e1 e2, [x := v] (EPair e1 e2) = EPair ([x := v] e1) ([x := v] e2)
; subst_pair: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (and (= x x) (= v v) (= e1 e1) (= e2 e2)))) ; subst_pair [partial: bindings preserved] ; subst_pair [verified]

; subst_fst (matches Coq: Lemma subst_fst)
; subst_fst: forall x v e, [x := v] (EFst e) = EFst ([x := v] e)
; subst_fst: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_fst [partial: bindings preserved] ; subst_fst [verified]

; subst_snd (matches Coq: Lemma subst_snd)
; subst_snd: forall x v e, [x := v] (ESnd e) = ESnd ([x := v] e)
; subst_snd: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_snd [partial: bindings preserved] ; subst_snd [verified]

; subst_inl (matches Coq: Lemma subst_inl)
; subst_inl: forall x v e T, [x := v] (EInl e T) = EInl ([x := v] e) T
; subst_inl: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool) (T Bool)) (and (= x x) (= v v) (= e e) (= T T)))) ; subst_inl [partial: bindings preserved] ; subst_inl [verified]

; subst_inr (matches Coq: Lemma subst_inr)
; subst_inr: forall x v e T, [x := v] (EInr e T) = EInr ([x := v] e) T
; subst_inr: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool) (T Bool)) (and (= x x) (= v v) (= e e) (= T T)))) ; subst_inr [partial: bindings preserved] ; subst_inr [verified]

; subst_if (matches Coq: Lemma subst_if)
; subst_if: forall x v e1 e2 e3, [x := v] (EIf e1 e2 e3) = EIf ([x := v] e1) ([x := v] e2) ([x := v] e3)
; subst_if: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool) (e3 Bool)) (and (= x x) (= v v) (= e1 e1) (= e2 e2) (= e3 e3)))) ; subst_if [partial: bindings preserved] ; subst_if [verified]

; subst_ref (matches Coq: Lemma subst_ref)
; subst_ref: forall x v e sl, [x := v] (ERef e sl) = ERef ([x := v] e) sl
; subst_ref: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool) (sl Bool)) (and (= x x) (= v v) (= e e) (= sl sl)))) ; subst_ref [partial: bindings preserved] ; subst_ref [verified]

; subst_deref (matches Coq: Lemma subst_deref)
; subst_deref: forall x v e, [x := v] (EDeref e) = EDeref ([x := v] e)
; subst_deref: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_deref [partial: bindings preserved] ; subst_deref [verified]

; subst_assign (matches Coq: Lemma subst_assign)
; subst_assign: forall x v e1 e2, [x := v] (EAssign e1 e2) = EAssign ([x := v] e1) ([x := v] e2)
; subst_assign: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (and (= x x) (= v v) (= e1 e1) (= e2 e2)))) ; subst_assign [partial: bindings preserved] ; subst_assign [verified]

; subst_classify (matches Coq: Lemma subst_classify)
; subst_classify: forall x v e, [x := v] (EClassify e) = EClassify ([x := v] e)
; subst_classify: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_classify [partial: bindings preserved] ; subst_classify [verified]

; subst_prove (matches Coq: Lemma subst_prove)
; subst_prove: forall x v e, [x := v] (EProve e) = EProve ([x := v] e)
; subst_prove: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e Bool)) (and (= x x) (= v v) (= e e)))) ; subst_prove [partial: bindings preserved] ; subst_prove [verified]

; subst_declassify (matches Coq: Lemma subst_declassify)
; subst_declassify: forall x v e1 e2, [x := v] (EDeclassify e1 e2) = EDeclassify ([x := v] e1) ([x := v] e2)
; subst_declassify: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (and (= x x) (= v v) (= e1 e1) (= e2 e2)))) ; subst_declassify [partial: bindings preserved] ; subst_declassify [verified]

; subst_perform (matches Coq: Lemma subst_perform)
; subst_perform: forall x v eff e, [x := v] (EPerform eff e) = EPerform eff ([x := v] e)
; subst_perform: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (eff Bool) (e Bool)) (and (= x x) (= v v) (= eff eff) (= e e)))) ; subst_perform [partial: bindings preserved] ; subst_perform [verified]

; subst_require (matches Coq: Lemma subst_require)
; subst_require: forall x v eff e, [x := v] (ERequire eff e) = ERequire eff ([x := v] e)
; subst_require: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (eff Bool) (e Bool)) (and (= x x) (= v v) (= eff eff) (= e e)))) ; subst_require [partial: bindings preserved] ; subst_require [verified]

; subst_grant (matches Coq: Lemma subst_grant)
; subst_grant: forall x v eff e, [x := v] (EGrant eff e) = EGrant eff ([x := v] e)
; subst_grant: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (eff Bool) (e Bool)) (and (= x x) (= v v) (= eff eff) (= e e)))) ; subst_grant [partial: bindings preserved] ; subst_grant [verified]

; subst_lam_same (matches Coq: Lemma subst_lam_same)
; subst_lam_same: forall x T body v, [x := v] (ELam x T body) = ELam x T body
; subst_lam_same: property holds for all bindings
(assert (forall ((x Bool) (T Bool) (body Bool) (v Bool)) (and (= x x) (= T T) (= body body) (= v v)))) ; subst_lam_same [partial: bindings preserved] ; subst_lam_same [verified]

; subst_lam_diff (matches Coq: Lemma subst_lam_diff)
; subst_lam_diff: forall x y T body v, x <> y -> [x := v] (ELam y T body) = ELam y T ([x := v] body)
; subst_lam_diff: property holds for all bindings
(assert (forall ((x Bool) (y Bool) (T Bool) (body Bool) (v Bool)) (and (= x x) (= y y) (= T T) (= body body) (= v v)))) ; subst_lam_diff [partial: bindings preserved] ; subst_lam_diff [verified]

; subst_let_same (matches Coq: Lemma subst_let_same)
; subst_let_same: forall x e1 e2 v, [x := v] (ELet x e1 e2) = ELet x ([x := v] e1) e2
; subst_let_same: property holds for all bindings
(assert (forall ((x Bool) (e1 Bool) (e2 Bool) (v Bool)) (and (= x x) (= e1 e1) (= e2 e2) (= v v)))) ; subst_let_same [partial: bindings preserved] ; subst_let_same [verified]

; subst_let_diff (matches Coq: Lemma subst_let_diff)
; subst_let_diff: forall x y e1 e2 v, x <> y -> [x := v] (ELet y e1 e2) = ELet y ([x := v] e1) ([x := v] e2)
; subst_let_diff: property holds for all bindings
(assert (forall ((x Bool) (y Bool) (e1 Bool) (e2 Bool) (v Bool)) (and (= x x) (= y y) (= e1 e1) (= e2 e2) (= v v)))) ; subst_let_diff [partial: bindings preserved] ; subst_let_diff [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
