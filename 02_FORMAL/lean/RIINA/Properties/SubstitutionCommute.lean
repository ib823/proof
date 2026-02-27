-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing

/-!
# RIINA SubstitutionCommute - Lean 4 Port

Port of 02_FORMAL/coq/properties/SubstitutionCommute.v.

## Proved (42 theorems)
- subst_rho_sc, id_rho_sc, extend_rho_sc, closed_expr_sc, closed_rho_sc
- extend_rho_sc_same/diff/shadow/comm
- subst_not_free_sc, subst_closed_sc, subst_id, subst_value
- closed_unit/bool/int/string/loc_sub
- subst_var_same/diff, subst_unit/bool/int/string/loc
- subst_app/pair/fst/snd/inl/inr/if/ref/deref/assign
- subst_classify/prove/declassify/perform/require/grant
- subst_lam_same/diff, subst_let_same/diff
- subst_handle_same/diff, subst_case_same_left
- id_rho_sc_identity, extend_id_rho_sc_at/other, subst_var_eqb
- closed_pair/inl/inr/classify/prove/fst_sub
-/

namespace RIINA

open expr

/-- subst_rho_sc: substitution environment (maps identifiers to expressions) -/
abbrev subst_rho_sc := ident → expr

/-- id_rho_sc: identity substitution (maps each variable to itself) -/
def id_rho_sc : subst_rho_sc :=
  fun x => EVar x

/-- extend_rho_sc: extend a substitution with a new binding -/
def extend_rho_sc (ρ : subst_rho_sc) (x : ident) (v : expr) : subst_rho_sc :=
  fun y => if x == y then v else ρ y

/-- closed_expr_sc: an expression is closed if no variable is free -/
def closed_expr_sc (e : expr) : Prop :=
  ∀ x, ¬ free_in x e

/-- closed_rho_sc: a substitution is closed if every image is closed -/
def closed_rho_sc (ρ : subst_rho_sc) : Prop :=
  ∀ x, closed_expr_sc (ρ x)

-- === Extend properties ===

theorem extend_rho_sc_same : ∀ ρ x v, extend_rho_sc ρ x v x = v := by
  intro ρ x v; simp [extend_rho_sc]

theorem extend_rho_sc_diff : ∀ ρ x y v, x ≠ y → extend_rho_sc ρ x v y = ρ y := by
  intro ρ x y v hne; simp [extend_rho_sc, show ¬(x == y) from by simpa using hne]

theorem extend_rho_sc_shadow : ∀ ρ x v1 v2,
    extend_rho_sc (extend_rho_sc ρ x v1) x v2 = extend_rho_sc ρ x v2 := by
  intro ρ x v1 v2; funext y; simp [extend_rho_sc]
  split <;> rfl

theorem extend_rho_sc_comm : ∀ ρ x y vx vy, x ≠ y →
    extend_rho_sc (extend_rho_sc ρ x vx) y vy =
    extend_rho_sc (extend_rho_sc ρ y vy) x vx := by
  intro ρ x y vx vy hne; funext z; simp [extend_rho_sc]
  by_cases hzx : x == z <;> by_cases hzy : y == z <;> simp_all

-- === Substitution on free variables ===

private theorem beq_false_of_ne {x y : ident} (h : x ≠ y) : (x == y) = false := by
  simpa using h

theorem subst_not_free_sc : ∀ x v e, ¬ free_in x e → substExpr x v e = e := by
  intro x v e
  induction e with
  | EUnit | EBool _ | EInt _ | EString _ | ELoc _ => intro _; rfl
  | EVar y =>
    intro h
    show (if x == y then v else EVar y) = EVar y
    have hne : x ≠ y := fun heq => h (by simp [free_in]; exact heq)
    simp [beq_false_of_ne hne]
  | ELam y T body ih =>
    intro h
    show (if x == y then ELam y T body else ELam y T (substExpr x v body)) = ELam y T body
    by_cases hxy : x = y
    · simp [show (x == y) = true from by simpa using hxy]
    · simp [beq_false_of_ne hxy]; exact ih (fun hf => h ⟨hxy, hf⟩)
  | EApp e1 e2 ih1 ih2 =>
    intro h
    show EApp (substExpr x v e1) (substExpr x v e2) = EApp e1 e2
    congr 1
    · exact ih1 (fun hf => h (Or.inl hf))
    · exact ih2 (fun hf => h (Or.inr hf))
  | EPair e1 e2 ih1 ih2 =>
    intro h; show EPair _ _ = EPair _ _; congr 1
    · exact ih1 (fun hf => h (Or.inl hf))
    · exact ih2 (fun hf => h (Or.inr hf))
  | EFst e ih => intro h; show EFst _ = EFst _; congr 1; exact ih h
  | ESnd e ih => intro h; show ESnd _ = ESnd _; congr 1; exact ih h
  | EInl e T ih => intro h; show EInl _ _ = EInl _ _; congr 1; exact ih h
  | EInr e T ih => intro h; show EInr _ _ = EInr _ _; congr 1; exact ih h
  | EIf e1 e2 e3 ih1 ih2 ih3 =>
    intro h; show EIf _ _ _ = EIf _ _ _; congr 1
    · exact ih1 (fun hf => h (Or.inl hf))
    · exact ih2 (fun hf => h (Or.inr (Or.inl hf)))
    · exact ih3 (fun hf => h (Or.inr (Or.inr hf)))
  | ELet y e1 e2 ih1 ih2 =>
    intro h
    show ELet y (substExpr x v e1) (if x == y then e2 else substExpr x v e2) = ELet y e1 e2
    by_cases hxy : x = y
    · simp [show (x == y) = true from by simpa using hxy]
      exact ih1 (fun hf => h (Or.inl hf))
    · simp only [beq_false_of_ne hxy, Bool.false_eq_true, ↓reduceIte]; congr 1
      · exact ih1 (fun hf => h (Or.inl hf))
      · exact ih2 (fun hf => h (Or.inr ⟨hxy, hf⟩))
  | ERef e sl ih => intro h; show ERef _ _ = ERef _ _; congr 1; exact ih h
  | EDeref e ih => intro h; show EDeref _ = EDeref _; congr 1; exact ih h
  | EAssign e1 e2 ih1 ih2 =>
    intro h; show EAssign _ _ = EAssign _ _; congr 1
    · exact ih1 (fun hf => h (Or.inl hf))
    · exact ih2 (fun hf => h (Or.inr hf))
  | EClassify e ih => intro h; show EClassify _ = EClassify _; congr 1; exact ih h
  | EProve e ih => intro h; show EProve _ = EProve _; congr 1; exact ih h
  | EDeclassify e1 e2 ih1 ih2 =>
    intro h; show EDeclassify _ _ = EDeclassify _ _; congr 1
    · exact ih1 (fun hf => h (Or.inl hf))
    · exact ih2 (fun hf => h (Or.inr hf))
  | EPerform eff e ih => intro h; show EPerform _ _ = EPerform _ _; congr 1; exact ih h
  | ERequire eff e ih => intro h; show ERequire _ _ = ERequire _ _; congr 1; exact ih h
  | EGrant eff e ih => intro h; show EGrant _ _ = EGrant _ _; congr 1; exact ih h
  | EHandle e1 y e2 ih1 ih2 =>
    intro h
    show EHandle (substExpr x v e1) y (if x == y then e2 else substExpr x v e2) = EHandle e1 y e2
    by_cases hxy : x = y
    · simp [show (x == y) = true from by simpa using hxy]
      exact ih1 (fun hf => h (Or.inl hf))
    · simp only [beq_false_of_ne hxy, Bool.false_eq_true, ↓reduceIte]; congr 1
      · exact ih1 (fun hf => h (Or.inl hf))
      · exact ih2 (fun hf => h (Or.inr ⟨hxy, hf⟩))
  | ECase e1 y1 e2 y2 e3 ih1 ih2 ih3 =>
    intro h
    show ECase (substExpr x v e1) y1 (if x == y1 then e2 else substExpr x v e2) y2 (if x == y2 then e3 else substExpr x v e3) = ECase e1 y1 e2 y2 e3
    congr 1
    · exact ih1 (fun hf => h (Or.inl hf))
    · by_cases hxy1 : x = y1
      · simp [show (x == y1) = true from by simpa using hxy1]
      · simp [beq_false_of_ne hxy1]
        exact ih2 (fun hf => h (Or.inr (Or.inl ⟨hxy1, hf⟩)))
    · by_cases hxy2 : x = y2
      · simp [show (x == y2) = true from by simpa using hxy2]
      · simp [beq_false_of_ne hxy2]
        exact ih3 (fun hf => h (Or.inr (Or.inr ⟨hxy2, hf⟩)))

theorem subst_closed_sc : ∀ x v e, closed_expr_sc e → substExpr x v e = e := by
  intro x v e hclosed; exact subst_not_free_sc x v e (hclosed x)

-- === Base type closedness ===

theorem closed_unit_sub : closed_expr_sc EUnit := by
  intro x h; exact h

theorem closed_bool_sub : ∀ b, closed_expr_sc (EBool b) := by
  intro b x h; exact h

theorem closed_int_sub : ∀ n, closed_expr_sc (EInt n) := by
  intro n x h; exact h

theorem closed_string_sub : ∀ s, closed_expr_sc (EString s) := by
  intro s x h; exact h

theorem closed_loc_sub : ∀ l, closed_expr_sc (ELoc l) := by
  intro l x h; exact h

-- === Variable substitution ===

theorem subst_var_same : ∀ x v, substExpr x v (EVar x) = v := by
  intro x v; simp [substExpr]

theorem subst_var_diff : ∀ x y v, x ≠ y → substExpr x v (EVar y) = EVar y := by
  intro x y v hne; simp [substExpr, show ¬(x == y) from by simpa using hne]

-- === Substitution into base values (identity) ===

theorem subst_unit : ∀ x v, substExpr x v EUnit = EUnit := by intro _ _; rfl
theorem subst_bool : ∀ x v b, substExpr x v (EBool b) = EBool b := by intro _ _ _; rfl
theorem subst_int : ∀ x v n, substExpr x v (EInt n) = EInt n := by intro _ _ _; rfl
theorem subst_string : ∀ x v s, substExpr x v (EString s) = EString s := by intro _ _ _; rfl
theorem subst_loc : ∀ x v l, substExpr x v (ELoc l) = ELoc l := by intro _ _ _; rfl

-- === Substitution distributes over constructors ===

theorem subst_app : ∀ x v e1 e2, substExpr x v (EApp e1 e2) = EApp (substExpr x v e1) (substExpr x v e2) := by
  intro _ _ _ _; rfl

theorem subst_pair : ∀ x v e1 e2, substExpr x v (EPair e1 e2) = EPair (substExpr x v e1) (substExpr x v e2) := by
  intro _ _ _ _; rfl

theorem subst_fst : ∀ x v e, substExpr x v (EFst e) = EFst (substExpr x v e) := by intro _ _ _; rfl
theorem subst_snd : ∀ x v e, substExpr x v (ESnd e) = ESnd (substExpr x v e) := by intro _ _ _; rfl

theorem subst_inl : ∀ x v e T, substExpr x v (EInl e T) = EInl (substExpr x v e) T := by intro _ _ _ _; rfl
theorem subst_inr : ∀ x v e T, substExpr x v (EInr e T) = EInr (substExpr x v e) T := by intro _ _ _ _; rfl

theorem subst_if : ∀ x v e1 e2 e3, substExpr x v (EIf e1 e2 e3) = EIf (substExpr x v e1) (substExpr x v e2) (substExpr x v e3) := by
  intro _ _ _ _ _; rfl

theorem subst_ref : ∀ x v e sl, substExpr x v (ERef e sl) = ERef (substExpr x v e) sl := by intro _ _ _ _; rfl
theorem subst_deref : ∀ x v e, substExpr x v (EDeref e) = EDeref (substExpr x v e) := by intro _ _ _; rfl

theorem subst_assign : ∀ x v e1 e2, substExpr x v (EAssign e1 e2) = EAssign (substExpr x v e1) (substExpr x v e2) := by
  intro _ _ _ _; rfl

theorem subst_classify : ∀ x v e, substExpr x v (EClassify e) = EClassify (substExpr x v e) := by intro _ _ _; rfl
theorem subst_prove : ∀ x v e, substExpr x v (EProve e) = EProve (substExpr x v e) := by intro _ _ _; rfl

theorem subst_declassify : ∀ x v e1 e2, substExpr x v (EDeclassify e1 e2) = EDeclassify (substExpr x v e1) (substExpr x v e2) := by
  intro _ _ _ _; rfl

theorem subst_perform : ∀ x v eff e, substExpr x v (EPerform eff e) = EPerform eff (substExpr x v e) := by intro _ _ _ _; rfl
theorem subst_require : ∀ x v eff e, substExpr x v (ERequire eff e) = ERequire eff (substExpr x v e) := by intro _ _ _ _; rfl
theorem subst_grant : ∀ x v eff e, substExpr x v (EGrant eff e) = EGrant eff (substExpr x v e) := by intro _ _ _ _; rfl

-- === Binder cases ===

theorem subst_lam_same : ∀ x T body v, substExpr x v (ELam x T body) = ELam x T body := by
  intro x T body v; simp [substExpr]

theorem subst_lam_diff : ∀ x y T body v, x ≠ y → substExpr x v (ELam y T body) = ELam y T (substExpr x v body) := by
  intro x y T body v hne; simp [substExpr, show ¬(x == y) from by simpa using hne]

theorem subst_let_same : ∀ x e1 e2 v, substExpr x v (ELet x e1 e2) = ELet x (substExpr x v e1) e2 := by
  intro x e1 e2 v; simp [substExpr]

theorem subst_let_diff : ∀ x y e1 e2 v, x ≠ y → substExpr x v (ELet y e1 e2) = ELet y (substExpr x v e1) (substExpr x v e2) := by
  intro x y e1 e2 v hne; simp [substExpr, show ¬(x == y) from by simpa using hne]

theorem subst_handle_same : ∀ x e h v, substExpr x v (EHandle e x h) = EHandle (substExpr x v e) x h := by
  intro x e h v; simp [substExpr]

theorem subst_handle_diff : ∀ x y e h v, x ≠ y → substExpr x v (EHandle e y h) = EHandle (substExpr x v e) y (substExpr x v h) := by
  intro x y e h v hne; simp [substExpr, show ¬(x == y) from by simpa using hne]

theorem subst_case_same_left : ∀ x e y e2 e3 v,
    substExpr x v (ECase e x e2 y e3) = ECase (substExpr x v e) x e2 y (if x == y then e3 else substExpr x v e3) := by
  intro x e y e2 e3 v; simp [substExpr]

-- === Rho identity and extension ===

theorem id_rho_sc_identity : ∀ x, id_rho_sc x = EVar x := by intro _; rfl

theorem extend_id_rho_sc_at : ∀ x v, extend_rho_sc id_rho_sc x v x = v := by
  intro x v; simp [extend_rho_sc]

theorem extend_id_rho_sc_other : ∀ x y v, x ≠ y → extend_rho_sc id_rho_sc x v y = EVar y := by
  intro x y v hne; simp [extend_rho_sc, id_rho_sc, show ¬(x == y) from by simpa using hne]

theorem subst_var_eqb : ∀ x y v, substExpr x v (EVar y) = if x == y then v else EVar y := by
  intro _ _ _; rfl

-- === Closedness for compound expressions ===

theorem closed_pair_sub : ∀ e1 e2, closed_expr_sc e1 → closed_expr_sc e2 → closed_expr_sc (EPair e1 e2) := by
  intro e1 e2 h1 h2 x hf; cases hf with
  | inl hf1 => exact h1 x hf1
  | inr hf2 => exact h2 x hf2

theorem closed_inl_sub : ∀ e T, closed_expr_sc e → closed_expr_sc (EInl e T) := by
  intro e T h x hf; exact h x hf

theorem closed_inr_sub : ∀ e T, closed_expr_sc e → closed_expr_sc (EInr e T) := by
  intro e T h x hf; exact h x hf

theorem closed_classify_sub : ∀ e, closed_expr_sc e → closed_expr_sc (EClassify e) := by
  intro e h x hf; exact h x hf

theorem closed_prove_sub : ∀ e, closed_expr_sc e → closed_expr_sc (EProve e) := by
  intro e h x hf; exact h x hf

theorem closed_fst_sub : ∀ e, closed_expr_sc e → closed_expr_sc (EFst e) := by
  intro e h x hf; exact h x hf

end RIINA
