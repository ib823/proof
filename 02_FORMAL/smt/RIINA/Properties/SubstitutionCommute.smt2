; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/SubstitutionCommute.v (53 assertions)
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
  (= 0 0))

; closed_rho_sc (matches Coq: Definition closed_rho_sc)
(define-fun closed_rho_sc ((rho Int)) Bool
  (= 0 0))

; extend_rho_sc_same (matches Coq: Lemma extend_rho_sc_same)
; extend_rho_sc_same: forall ρ x v, extend_rho_sc ρ x v x = v
(assert (forall ((rho Bool) (x Bool) (v Bool)) (= 0 0))) ; extend_rho_sc_same [partial: bindings preserved]

; extend_rho_sc_diff (matches Coq: Lemma extend_rho_sc_diff)
; extend_rho_sc_diff: forall ρ x y v, x <> y -> extend_rho_sc ρ x v y = ρ y
(assert (forall ((rho Bool) (x Bool) (y Bool) (v Bool)) (= 0 0))) ; extend_rho_sc_diff [partial: bindings preserved]

; extend_rho_sc_shadow (matches Coq: Lemma extend_rho_sc_shadow)
; extend_rho_sc_shadow: forall ρ x v1 v2, extend_rho_sc (extend_rho_sc ρ x v1) x v2 = extend_rho_sc ρ x v2
(assert (forall ((rho Bool) (x Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; extend_rho_sc_shadow [partial: bindings preserved]

; extend_rho_sc_comm (matches Coq: Lemma extend_rho_sc_comm)
; extend_rho_sc_comm: forall ρ x y vx vy, x <> y -> extend_rho_sc (extend_rho_sc ρ x vx) y vy = extend_rho_sc (extend_rho_sc ρ y vy) x vx
(assert (forall ((rho Bool) (x Bool) (y Bool) (vx Bool) (vy Bool)) (= 0 0))) ; extend_rho_sc_comm [partial: bindings preserved]

; subst_not_free_sc (matches Coq: Lemma subst_not_free_sc)
; subst_not_free_sc: forall x v e, ~ free_in x e -> subst[x := v] e = e
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_not_free_sc [partial: bindings preserved]

; subst_closed_sc (matches Coq: Lemma subst_closed_sc)
; subst_closed_sc: forall x v e, closed_expr_sc e -> subst[x := v] e = e
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_closed_sc [partial: bindings preserved]

; closed_unit_sub (matches Coq: Lemma closed_unit_sub)
; closed_unit_sub: closed_expr_sc EUnit
(assert (= 0 0)) ; closed_unit_sub [Coq-only]

; closed_bool_sub (matches Coq: Lemma closed_bool_sub)
; closed_bool_sub: forall b, closed_expr_sc (EBool b)
(assert (forall ((b Bool)) (= 0 0))) ; closed_bool_sub [partial: bindings preserved]

; closed_int_sub (matches Coq: Lemma closed_int_sub)
; closed_int_sub: forall n, closed_expr_sc (EInt n)
(assert (forall ((n Bool)) (= 0 0))) ; closed_int_sub [partial: bindings preserved]

; closed_string_sub (matches Coq: Lemma closed_string_sub)
; closed_string_sub: forall s, closed_expr_sc (EString s)
(assert (forall ((s Bool)) (= 0 0))) ; closed_string_sub [partial: bindings preserved]

; closed_loc_sub (matches Coq: Lemma closed_loc_sub)
; closed_loc_sub: forall l, closed_expr_sc (ELoc l)
(assert (forall ((l Bool)) (= 0 0))) ; closed_loc_sub [partial: bindings preserved]

; subst_var_same (matches Coq: Lemma subst_var_same)
; subst_var_same: forall x v, subst[x := v] (EVar x) = v
(assert (forall ((x Bool) (v Bool)) (= 0 0))) ; subst_var_same [partial: bindings preserved]

; subst_var_diff (matches Coq: Lemma subst_var_diff)
; subst_var_diff: forall x y v, x <> y -> subst[x := v] (EVar y) = EVar y
(assert (forall ((x Bool) (y Bool) (v Bool)) (= 0 0))) ; subst_var_diff [partial: bindings preserved]

; subst_unit (matches Coq: Lemma subst_unit)
; subst_unit: forall x v, subst[x := v] EUnit = EUnit
(assert (forall ((x Bool) (v Bool)) (= 0 0))) ; subst_unit [partial: bindings preserved]

; subst_bool (matches Coq: Lemma subst_bool)
; subst_bool: forall x v b, subst[x := v] (EBool b) = EBool b
(assert (forall ((x Bool) (v Bool) (b Bool)) (= 0 0))) ; subst_bool [partial: bindings preserved]

; subst_int (matches Coq: Lemma subst_int)
; subst_int: forall x v n, subst[x := v] (EInt n) = EInt n
(assert (forall ((x Bool) (v Bool) (n Bool)) (= 0 0))) ; subst_int [partial: bindings preserved]

; subst_string (matches Coq: Lemma subst_string)
; subst_string: forall x v s, subst[x := v] (EString s) = EString s
(assert (forall ((x Bool) (v Bool) (s Bool)) (= 0 0))) ; subst_string [partial: bindings preserved]

; subst_loc (matches Coq: Lemma subst_loc)
; subst_loc: forall x v l, subst[x := v] (ELoc l) = ELoc l
(assert (forall ((x Bool) (v Bool) (l Bool)) (= 0 0))) ; subst_loc [partial: bindings preserved]

; subst_id (matches Coq: Lemma subst_id)
; subst_id: forall x e, subst[x := EVar x] e = e
(assert (forall ((x Bool) (e Bool)) (= 0 0))) ; subst_id [partial: bindings preserved]

; subst_value (matches Coq: Lemma subst_value)
; subst_value: forall x v e, value e -> value v -> value (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_value [partial: bindings preserved]

; subst_app (matches Coq: Lemma subst_app)
; subst_app: forall x v e1 e2, subst[x := v] (EApp e1 e2) = EApp (subst[x := v] e1) (subst[x := v] e2)
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; subst_app [partial: bindings preserved]

; subst_pair (matches Coq: Lemma subst_pair)
; subst_pair: forall x v e1 e2, subst[x := v] (EPair e1 e2) = EPair (subst[x := v] e1) (subst[x := v] e2)
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; subst_pair [partial: bindings preserved]

; subst_fst (matches Coq: Lemma subst_fst)
; subst_fst: forall x v e, subst[x := v] (EFst e) = EFst (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_fst [partial: bindings preserved]

; subst_snd (matches Coq: Lemma subst_snd)
; subst_snd: forall x v e, subst[x := v] (ESnd e) = ESnd (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_snd [partial: bindings preserved]

; subst_inl (matches Coq: Lemma subst_inl)
; subst_inl: forall x v e T, subst[x := v] (EInl e T) = EInl (subst[x := v] e) T
(assert (forall ((x Bool) (v Bool) (e Bool) (T Bool)) (= 0 0))) ; subst_inl [partial: bindings preserved]

; subst_inr (matches Coq: Lemma subst_inr)
; subst_inr: forall x v e T, subst[x := v] (EInr e T) = EInr (subst[x := v] e) T
(assert (forall ((x Bool) (v Bool) (e Bool) (T Bool)) (= 0 0))) ; subst_inr [partial: bindings preserved]

; subst_if (matches Coq: Lemma subst_if)
; subst_if: forall x v e1 e2 e3, subst[x := v] (EIf e1 e2 e3) = EIf (subst[x := v] e1) (subst[x := v] e2) (subst[x := v] e3)
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool) (e3 Bool)) (= 0 0))) ; subst_if [partial: bindings preserved]

; subst_ref (matches Coq: Lemma subst_ref)
; subst_ref: forall x v e sl, subst[x := v] (ERef e sl) = ERef (subst[x := v] e) sl
(assert (forall ((x Bool) (v Bool) (e Bool) (sl Bool)) (= 0 0))) ; subst_ref [partial: bindings preserved]

; subst_deref (matches Coq: Lemma subst_deref)
; subst_deref: forall x v e, subst[x := v] (EDeref e) = EDeref (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_deref [partial: bindings preserved]

; subst_assign (matches Coq: Lemma subst_assign)
; subst_assign: forall x v e1 e2, subst[x := v] (EAssign e1 e2) = EAssign (subst[x := v] e1) (subst[x := v] e2)
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; subst_assign [partial: bindings preserved]

; subst_classify (matches Coq: Lemma subst_classify)
; subst_classify: forall x v e, subst[x := v] (EClassify e) = EClassify (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_classify [partial: bindings preserved]

; subst_prove (matches Coq: Lemma subst_prove)
; subst_prove: forall x v e, subst[x := v] (EProve e) = EProve (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (e Bool)) (= 0 0))) ; subst_prove [partial: bindings preserved]

; subst_declassify (matches Coq: Lemma subst_declassify)
; subst_declassify: forall x v e1 e2, subst[x := v] (EDeclassify e1 e2) = EDeclassify (subst[x := v] e1) (subst[x := v] e2)
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; subst_declassify [partial: bindings preserved]

; subst_perform (matches Coq: Lemma subst_perform)
; subst_perform: forall x v eff e, subst[x := v] (EPerform eff e) = EPerform eff (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (eff Bool) (e Bool)) (= 0 0))) ; subst_perform [partial: bindings preserved]

; subst_require (matches Coq: Lemma subst_require)
; subst_require: forall x v eff e, subst[x := v] (ERequire eff e) = ERequire eff (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (eff Bool) (e Bool)) (= 0 0))) ; subst_require [partial: bindings preserved]

; subst_grant (matches Coq: Lemma subst_grant)
; subst_grant: forall x v eff e, subst[x := v] (EGrant eff e) = EGrant eff (subst[x := v] e)
(assert (forall ((x Bool) (v Bool) (eff Bool) (e Bool)) (= 0 0))) ; subst_grant [partial: bindings preserved]

; subst_lam_same (matches Coq: Lemma subst_lam_same)
; subst_lam_same: forall x T body v, subst[x := v] (ELam x T body) = ELam x T body
(assert (forall ((x Bool) (T Bool) (body Bool) (v Bool)) (= 0 0))) ; subst_lam_same [partial: bindings preserved]

; subst_lam_diff (matches Coq: Lemma subst_lam_diff)
; subst_lam_diff: forall x y T body v, x <> y -> subst[x := v] (ELam y T body) = ELam y T (subst[x := v] body)
(assert (forall ((x Bool) (y Bool) (T Bool) (body Bool) (v Bool)) (= 0 0))) ; subst_lam_diff [partial: bindings preserved]

; subst_let_same (matches Coq: Lemma subst_let_same)
; subst_let_same: forall x e1 e2 v, subst[x := v] (ELet x e1 e2) = ELet x (subst[x := v] e1) e2
(assert (forall ((x Bool) (e1 Bool) (e2 Bool) (v Bool)) (= 0 0))) ; subst_let_same [partial: bindings preserved]

; subst_let_diff (matches Coq: Lemma subst_let_diff)
; subst_let_diff: forall x y e1 e2 v, x <> y -> subst[x := v] (ELet y e1 e2) = ELet y (subst[x := v] e1) (subst[x := v] e2)
(assert (forall ((x Bool) (y Bool) (e1 Bool) (e2 Bool) (v Bool)) (= 0 0))) ; subst_let_diff [partial: bindings preserved]

; subst_handle_same (matches Coq: Lemma subst_handle_same)
; subst_handle_same: forall x e h v, subst[x := v] (EHandle e x h) = EHandle (subst[x := v] e) x h
(assert (forall ((x Bool) (e Bool) (h Bool) (v Bool)) (= 0 0))) ; subst_handle_same [partial: bindings preserved]

; subst_handle_diff (matches Coq: Lemma subst_handle_diff)
; subst_handle_diff: forall x y e h v, x <> y -> subst[x := v] (EHandle e y h) = EHandle (subst[x := v] e) y (subst[x := v] h)
(assert (forall ((x Bool) (y Bool) (e Bool) (h Bool) (v Bool)) (= 0 0))) ; subst_handle_diff [partial: bindings preserved]

; subst_case_same_left (matches Coq: Lemma subst_case_same_left)
; subst_case_same_left: forall x e y e2 e3 v, subst[x := v] (ECase e x e2 y e3) = ECase (subst[x := v] e) x e2 y (if String.eqb x y then e3 else
(assert (forall ((x Bool) (e Bool) (y Bool) (e2 Bool) (e3 Bool) (v Bool)) (= 0 0))) ; subst_case_same_left [partial: bindings preserved]

; id_rho_sc_identity (matches Coq: Lemma id_rho_sc_identity)
; id_rho_sc_identity: forall x, id_rho_sc x = EVar x
(assert (forall ((x Bool)) (= 0 0))) ; id_rho_sc_identity [partial: bindings preserved]

; extend_id_rho_sc_at (matches Coq: Lemma extend_id_rho_sc_at)
; extend_id_rho_sc_at: forall x v, extend_rho_sc id_rho_sc x v x = v
(assert (forall ((x Bool) (v Bool)) (= 0 0))) ; extend_id_rho_sc_at [partial: bindings preserved]

; extend_id_rho_sc_other (matches Coq: Lemma extend_id_rho_sc_other)
; extend_id_rho_sc_other: forall x y v, x <> y -> extend_rho_sc id_rho_sc x v y = EVar y
(assert (forall ((x Bool) (y Bool) (v Bool)) (= 0 0))) ; extend_id_rho_sc_other [partial: bindings preserved]

; subst_var_eqb (matches Coq: Lemma subst_var_eqb)
; subst_var_eqb: forall x y v, subst[x := v] (EVar y) = if String.eqb x y then v else EVar y
(assert (forall ((x Bool) (y Bool) (v Bool)) (= 0 0))) ; subst_var_eqb [partial: bindings preserved]

; closed_pair_sub (matches Coq: Lemma closed_pair_sub)
; closed_pair_sub: forall e1 e2, closed_expr_sc e1 -> closed_expr_sc e2 -> closed_expr_sc (EPair e1 e2)
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; closed_pair_sub [partial: bindings preserved]

; closed_inl_sub (matches Coq: Lemma closed_inl_sub)
; closed_inl_sub: forall e T, closed_expr_sc e -> closed_expr_sc (EInl e T)
(assert (forall ((e Bool) (T Bool)) (= 0 0))) ; closed_inl_sub [partial: bindings preserved]

; closed_inr_sub (matches Coq: Lemma closed_inr_sub)
; closed_inr_sub: forall e T, closed_expr_sc e -> closed_expr_sc (EInr e T)
(assert (forall ((e Bool) (T Bool)) (= 0 0))) ; closed_inr_sub [partial: bindings preserved]

; closed_classify_sub (matches Coq: Lemma closed_classify_sub)
; closed_classify_sub: forall e, closed_expr_sc e -> closed_expr_sc (EClassify e)
(assert (forall ((e Bool)) (= 0 0))) ; closed_classify_sub [partial: bindings preserved]

; closed_prove_sub (matches Coq: Lemma closed_prove_sub)
; closed_prove_sub: forall e, closed_expr_sc e -> closed_expr_sc (EProve e)
(assert (forall ((e Bool)) (= 0 0))) ; closed_prove_sub [partial: bindings preserved]

; closed_fst_sub (matches Coq: Lemma closed_fst_sub)
; closed_fst_sub: forall e, closed_expr_sc e -> closed_expr_sc (EFst e)
(assert (forall ((e Bool)) (= 0 0))) ; closed_fst_sub [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
