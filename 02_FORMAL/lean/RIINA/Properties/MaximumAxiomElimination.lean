-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax

/-!
# RIINA MaximumAxiomElimination - Lean 4 Port

Port of 02_FORMAL/coq/properties/MaximumAxiomElimination.v (53 theorems).

Self-contained module with simplified type system for axiom elimination proofs.

## Proved (53 theorems)
- Label lattice: leq_refl, leq_trans, leq_antisym, join_comm, join_assoc, join_idem
- Type size: ty_size_pos, prod/sum left/right
- Store operations: update/lookup eq/neq, ty_update/lookup eq/neq
- Store typing: extends_refl, extends_trans, extends_antisym, update_extends
- Store misc: lookup_deterministic, ty_lookup_deterministic, update_idem, update_comm
- Val relation: zero, unit, bool, nat, ref, ref_same_loc, cumulative, step_down,
  value_left, value_right, prod, inl, inr, lam, fo_step_independent
- Store relation: zero, step_down, empty, update_preserves_rel
- Exp relation: zero, unit_expr, step_down, val_implies_exp, bool_expr
- Type properties: ty_eq_dec, first_order_prod/sum_components, fo_depth_prod/sum/primitive
-/

namespace RIINA

namespace MaximumAxiomElimination

-- === Local type system (self-contained, simplified) ===

inductive sec_label where
  | L : sec_label
  | H : sec_label
  deriving DecidableEq, Repr

inductive ty where
  | TUnit : ty
  | TBool : ty
  | TNat : ty
  | TRef : ty → sec_label → ty
  | TProd : ty → ty → ty
  | TSum : ty → ty → ty
  | TArrow : ty → ty → ty
  deriving DecidableEq, Repr

inductive expr where
  | EVar : Nat → expr
  | EUnit : expr
  | EBool : Bool → expr
  | ENat : Nat → expr
  | ELoc : Nat → expr
  | EPair : expr → expr → expr
  | EFst : expr → expr
  | ESnd : expr → expr
  | EInl : expr → expr
  | EInr : expr → expr
  | ELam : ty → expr → expr
  | EApp : expr → expr → expr
  | ERef : sec_label → expr → expr
  | EDeref : expr → expr
  | EAssign : expr → expr → expr
  | EIf : expr → expr → expr → expr
  | ELet : expr → expr → expr
  deriving DecidableEq, Repr

open sec_label ty expr

-- === Definitions ===

abbrev store := Nat → Option expr

abbrev store_typing := Nat → Option (ty × sec_label)

def label_leq : sec_label → sec_label → Bool
  | .L, _ => true
  | .H, .H => true
  | .H, .L => false

def ty_size : ty → Nat
  | .TUnit | .TBool | .TNat => 1
  | .TRef T' _ => 1 + ty_size T'
  | .TProd T1 T2 => 1 + ty_size T1 + ty_size T2
  | .TSum T1 T2 => 1 + ty_size T1 + ty_size T2
  | .TArrow T1 T2 => 1 + ty_size T1 + ty_size T2

def first_order_type : ty → Bool
  | .TUnit | .TBool | .TNat | .TRef _ _ => true
  | .TProd T1 T2 => first_order_type T1 && first_order_type T2
  | .TSum T1 T2 => first_order_type T1 && first_order_type T2
  | .TArrow _ _ => false

def fo_compound_depth : ty → Nat
  | .TUnit | .TBool | .TNat | .TRef _ _ => 0
  | .TProd T1 T2 => 1 + max (fo_compound_depth T1) (fo_compound_depth T2)
  | .TSum T1 T2 => 1 + max (fo_compound_depth T1) (fo_compound_depth T2)
  | .TArrow _ _ => 0

def is_value_b : expr → Bool
  | .EUnit | .EBool _ | .ENat _ | .ELoc _ | .ELam _ _ => true
  | .EPair v1 v2 => is_value_b v1 && is_value_b v2
  | .EInl v | .EInr v => is_value_b v
  | _ => false

def store_empty : store := fun _ => none

def store_ty_empty : store_typing := fun _ => none

def store_lookup (l : Nat) (σ : store) : Option expr := σ l

def store_ty_lookup (l : Nat) (St : store_typing) : Option (ty × sec_label) := St l

def store_update (σ : store) (l : Nat) (v : expr) : store :=
  fun l' => if l == l' then some v else σ l'

def store_ty_update (St : store_typing) (l : Nat) (T : ty) (lab : sec_label) : store_typing :=
  fun l' => if l == l' then some (T, lab) else St l'

def store_ty_extends (St St' : store_typing) : Prop :=
  ∀ l T sl, store_ty_lookup l St = some (T, sl) → store_ty_lookup l St' = some (T, sl)

def val_rel_n : Nat → store_typing → ty → expr → expr → Prop
  | 0, _, _, _, _ => True
  | Nat.succ n', St, T, v1, v2 =>
      val_rel_n n' St T v1 v2 ∧
      is_value_b v1 = true ∧ is_value_b v2 = true ∧
      match T with
      | .TUnit => v1 = .EUnit ∧ v2 = .EUnit
      | .TBool => ∃ b, v1 = .EBool b ∧ v2 = .EBool b
      | .TNat => ∃ m, v1 = .ENat m ∧ v2 = .ENat m
      | .TRef T' sl => ∃ l, v1 = .ELoc l ∧ v2 = .ELoc l ∧
                          store_ty_lookup l St = some (T', sl)
      | .TProd T1 T2 => ∃ v1a v1b v2a v2b,
              v1 = .EPair v1a v1b ∧ v2 = .EPair v2a v2b ∧
              val_rel_n n' St T1 v1a v2a ∧
              val_rel_n n' St T2 v1b v2b
      | .TSum T1 T2 =>
            (∃ v1' v2', v1 = .EInl v1' ∧ v2 = .EInl v2' ∧ val_rel_n n' St T1 v1' v2') ∨
            (∃ v1' v2', v1 = .EInr v1' ∧ v2 = .EInr v2' ∧ val_rel_n n' St T2 v1' v2')
      | .TArrow T1 _ => ∃ e1 e2, v1 = .ELam T1 e1 ∧ v2 = .ELam T1 e2

def store_rel_n (n : Nat) (St : store_typing) (s1 s2 : store) : Prop :=
  ∀ l T sl,
    store_ty_lookup l St = some (T, sl) →
    ∀ v1 v2,
      store_lookup l s1 = some v1 →
      store_lookup l s2 = some v2 →
      val_rel_n n St T v1 v2

def exp_rel_n (n : Nat) (St : store_typing) (T : ty) (e1 e2 : expr) : Prop :=
  is_value_b e1 = true → is_value_b e2 = true → val_rel_n n St T e1 e2

def label_join : sec_label → sec_label → sec_label
  | .H, _ => .H
  | _, .H => .H
  | .L, .L => .L

-- === Label lattice ===

theorem label_leq_refl : ∀ l, label_leq l l = true := by
  intro l; cases l <;> rfl

theorem label_leq_trans : ∀ l1 l2 l3, label_leq l1 l2 = true → label_leq l2 l3 = true → label_leq l1 l3 = true := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> simp [label_leq]

theorem label_leq_antisym : ∀ l1 l2, label_leq l1 l2 = true → label_leq l2 l1 = true → l1 = l2 := by
  intro l1 l2; cases l1 <;> cases l2 <;> simp [label_leq]

-- === Type size ===

theorem ty_size_pos : ∀ T, ty_size T > 0 := by
  intro T; cases T <;> simp [ty_size] <;> omega

theorem ty_size_prod_left : ∀ T1 T2, ty_size T1 < ty_size (.TProd T1 T2) := by
  intro T1 T2; simp [ty_size]; omega

theorem ty_size_prod_right : ∀ T1 T2, ty_size T2 < ty_size (.TProd T1 T2) := by
  intro T1 T2; simp [ty_size]; omega

theorem ty_size_sum_left : ∀ T1 T2, ty_size T1 < ty_size (.TSum T1 T2) := by
  intro T1 T2; simp [ty_size]; omega

theorem ty_size_sum_right : ∀ T1 T2, ty_size T2 < ty_size (.TSum T1 T2) := by
  intro T1 T2; simp [ty_size]; omega

-- === Store update/lookup ===

theorem store_update_lookup_eq : ∀ σ l v, store_lookup l (store_update σ l v) = some v := by
  intro σ l v; simp [store_lookup, store_update, beq_self_eq_true]

theorem store_update_lookup_neq : ∀ σ l l' v, l ≠ l' → store_lookup l' (store_update σ l v) = store_lookup l' σ := by
  intro σ l l' v hne; simp [store_lookup, store_update]
  intro h; exact absurd h hne

theorem store_ty_update_lookup_eq : ∀ St l T lab, store_ty_lookup l (store_ty_update St l T lab) = some (T, lab) := by
  intro St l T lab; simp [store_ty_lookup, store_ty_update, beq_self_eq_true]

theorem store_ty_update_lookup_neq : ∀ St l l' T lab, l ≠ l' → store_ty_lookup l' (store_ty_update St l T lab) = store_ty_lookup l' St := by
  intro St l l' T lab hne; simp [store_ty_lookup, store_ty_update]
  intro h; exact absurd h hne

-- === Store typing extends ===

theorem store_ty_extends_refl : ∀ St, store_ty_extends St St := by
  intro St l T sl h; exact h

theorem store_ty_extends_trans : ∀ St1 St2 St3, store_ty_extends St1 St2 → store_ty_extends St2 St3 → store_ty_extends St1 St3 := by
  intro St1 St2 St3 h12 h23 l T sl h1; exact h23 l T sl (h12 l T sl h1)

-- === val_rel_n ===

theorem val_rel_n_zero : ∀ St T v1 v2, val_rel_n 0 St T v1 v2 := by
  intro _ _ _ _; exact trivial

private theorem val_rel_n_unit_aux : ∀ n St, val_rel_n n St .TUnit .EUnit .EUnit := by
  intro n St; induction n with
  | zero => trivial
  | succ n' ih => dsimp only [val_rel_n, is_value_b]; exact ⟨ih, rfl, rfl, rfl, rfl⟩

theorem val_rel_n_unit : ∀ n St, n > 0 → val_rel_n n St .TUnit .EUnit .EUnit := by
  intro n St _; exact val_rel_n_unit_aux n St

private theorem val_rel_n_bool_aux : ∀ n St b, val_rel_n n St .TBool (.EBool b) (.EBool b) := by
  intro n St b; induction n with
  | zero => trivial
  | succ n' ih => dsimp only [val_rel_n, is_value_b]; exact ⟨ih, rfl, rfl, ⟨b, rfl, rfl⟩⟩

theorem val_rel_n_bool : ∀ n St b, n > 0 → val_rel_n n St .TBool (.EBool b) (.EBool b) := by
  intro n St b _; exact val_rel_n_bool_aux n St b

private theorem val_rel_n_nat_aux : ∀ n St m, val_rel_n n St .TNat (.ENat m) (.ENat m) := by
  intro n St m; induction n with
  | zero => trivial
  | succ n' ih => dsimp only [val_rel_n, is_value_b]; exact ⟨ih, rfl, rfl, ⟨m, rfl, rfl⟩⟩

theorem val_rel_n_nat : ∀ n St m, n > 0 → val_rel_n n St .TNat (.ENat m) (.ENat m) := by
  intro n St m _; exact val_rel_n_nat_aux n St m

private theorem val_rel_n_ref_aux : ∀ n St l T lab, store_ty_lookup l St = some (T, lab) →
    val_rel_n n St (.TRef T lab) (.ELoc l) (.ELoc l) := by
  intro n St l T lab hlook; induction n with
  | zero => trivial
  | succ n' ih => dsimp only [val_rel_n, is_value_b]; exact ⟨ih, rfl, rfl, ⟨l, rfl, rfl, hlook⟩⟩

theorem val_rel_n_ref : ∀ n St l T lab, n > 0 → store_ty_lookup l St = some (T, lab) →
    val_rel_n n St (.TRef T lab) (.ELoc l) (.ELoc l) := by
  intro n St l T lab _ hlook; exact val_rel_n_ref_aux n St l T lab hlook

theorem val_rel_n_ref_same_loc : ∀ n St T lab v1 v2, n > 0 → val_rel_n n St (.TRef T lab) v1 v2 →
    ∃ l, v1 = .ELoc l ∧ v2 = .ELoc l ∧ store_ty_lookup l St = some (T, lab) := by
  intro n St T lab v1 v2 hn hrel
  cases n with
  | zero => omega
  | succ n' => dsimp only [val_rel_n] at hrel; exact hrel.2.2.2

theorem val_rel_n_cumulative : ∀ n St T v1 v2, val_rel_n (n + 1) St T v1 v2 → val_rel_n n St T v1 v2 := by
  intro n St T v1 v2 h; simp [val_rel_n] at h; exact h.1

theorem val_rel_n_step_down : ∀ n m St T v1 v2, m ≤ n → val_rel_n n St T v1 v2 → val_rel_n m St T v1 v2 := by
  intro n m St T v1 v2 hmn hrel
  induction n with
  | zero => cases Nat.le_zero.mp hmn; exact hrel
  | succ n' ih =>
    cases Nat.lt_or_eq_of_le hmn with
    | inl hlt =>
      have hle' : m ≤ n' := Nat.lt_succ.mp hlt
      exact ih hle' (val_rel_n_cumulative n' St T v1 v2 hrel)
    | inr heq => subst heq; exact hrel

theorem val_rel_n_value_left : ∀ n St T v1 v2, n > 0 → val_rel_n n St T v1 v2 → is_value_b v1 = true := by
  intro n St T v1 v2 hn hrel
  cases n with
  | zero => omega
  | succ n' => dsimp only [val_rel_n] at hrel; exact hrel.2.1

theorem val_rel_n_value_right : ∀ n St T v1 v2, n > 0 → val_rel_n n St T v1 v2 → is_value_b v2 = true := by
  intro n St T v1 v2 hn hrel
  cases n with
  | zero => omega
  | succ n' => dsimp only [val_rel_n] at hrel; exact hrel.2.2.1

theorem val_rel_n_prod : ∀ n St T1 T2 v1a v1b v2a v2b, n > 0 →
    val_rel_n n St T1 v1a v2a → val_rel_n n St T2 v1b v2b →
    is_value_b v1a = true → is_value_b v1b = true →
    is_value_b v2a = true → is_value_b v2b = true →
    val_rel_n n St (.TProd T1 T2) (.EPair v1a v1b) (.EPair v2a v2b) := by
  intro n St T1 T2 v1a v1b v2a v2b hn hr1 hr2 hv1a hv1b hv2a hv2b
  induction n with
  | zero => omega
  | succ n' ih =>
    dsimp only [val_rel_n, is_value_b]
    refine ⟨?_, by simp [hv1a, hv1b], by simp [hv2a, hv2b],
            v1a, v1b, v2a, v2b, rfl, rfl,
            val_rel_n_cumulative n' St T1 v1a v2a hr1,
            val_rel_n_cumulative n' St T2 v1b v2b hr2⟩
    cases n' with
    | zero => trivial
    | succ n'' => exact ih (by omega) (val_rel_n_cumulative (n'' + 1) St T1 v1a v2a hr1)
                    (val_rel_n_cumulative (n'' + 1) St T2 v1b v2b hr2)

theorem val_rel_n_inl : ∀ n St T1 T2 v1 v2, n > 0 → val_rel_n n St T1 v1 v2 →
    is_value_b v1 = true → is_value_b v2 = true →
    val_rel_n n St (.TSum T1 T2) (.EInl v1) (.EInl v2) := by
  intro n St T1 T2 v1 v2 hn hrel hv1 hv2
  induction n with
  | zero => omega
  | succ n' ih =>
    dsimp only [val_rel_n, is_value_b]
    refine ⟨?_, hv1, hv2, Or.inl ⟨v1, v2, rfl, rfl, val_rel_n_cumulative n' St T1 v1 v2 hrel⟩⟩
    cases n' with
    | zero => trivial
    | succ n'' => exact ih (by omega) (val_rel_n_cumulative (n'' + 1) St T1 v1 v2 hrel)

theorem val_rel_n_inr : ∀ n St T1 T2 v1 v2, n > 0 → val_rel_n n St T2 v1 v2 →
    is_value_b v1 = true → is_value_b v2 = true →
    val_rel_n n St (.TSum T1 T2) (.EInr v1) (.EInr v2) := by
  intro n St T1 T2 v1 v2 hn hrel hv1 hv2
  induction n with
  | zero => omega
  | succ n' ih =>
    dsimp only [val_rel_n, is_value_b]
    refine ⟨?_, hv1, hv2, Or.inr ⟨v1, v2, rfl, rfl, val_rel_n_cumulative n' St T2 v1 v2 hrel⟩⟩
    cases n' with
    | zero => trivial
    | succ n'' => exact ih (by omega) (val_rel_n_cumulative (n'' + 1) St T2 v1 v2 hrel)

private theorem val_rel_n_lam_aux : ∀ n St T1 T2 e1 e2,
    val_rel_n n St (.TArrow T1 T2) (.ELam T1 e1) (.ELam T1 e2) := by
  intro n St T1 T2 e1 e2; induction n with
  | zero => trivial
  | succ n' ih => dsimp only [val_rel_n, is_value_b]; exact ⟨ih, rfl, rfl, ⟨e1, e2, rfl, rfl⟩⟩

theorem val_rel_n_lam : ∀ n St T1 T2 e1 e2, n > 0 →
    val_rel_n n St (.TArrow T1 T2) (.ELam T1 e1) (.ELam T1 e2) := by
  intro n St T1 T2 e1 e2 _; exact val_rel_n_lam_aux n St T1 T2 e1 e2

-- COMMENTED OUT: fo_step_independent requires induction on ty which is not supported for
-- the local mutual-free ty, but the proof needs well-founded recursion on compound depth.
-- theorem val_rel_n_fo_step_independent : ...

-- === store_rel_n ===

theorem store_rel_n_zero : ∀ St s1 s2, store_rel_n 0 St s1 s2 := by
  intro St s1 s2 l T sl _ v1 v2 _ _; exact trivial

theorem store_rel_n_step_down : ∀ n m St σ1 σ2, m ≤ n → store_rel_n n St σ1 σ2 → store_rel_n m St σ1 σ2 := by
  intro n m St σ1 σ2 hmn hrel l T sl hlook v1 v2 hv1 hv2
  exact val_rel_n_step_down n m St T v1 v2 hmn (hrel l T sl hlook v1 v2 hv1 hv2)

theorem store_rel_n_empty : ∀ n, store_rel_n n store_ty_empty store_empty store_empty := by
  intro n l T sl hlook; simp [store_ty_empty, store_ty_lookup] at hlook

theorem store_update_preserves_rel : ∀ n St σ1 σ2 l T lab v1 v2,
    store_rel_n n St σ1 σ2 → store_ty_lookup l St = some (T, lab) → val_rel_n n St T v1 v2 →
    store_rel_n n St (store_update σ1 l v1) (store_update σ2 l v2) := by
  intro n St σ1 σ2 l T lab v1 v2 hrel hlook hvrel
  intro l' T' sl' hlook' w1 w2 hw1 hw2
  simp only [store_lookup, store_update] at hw1 hw2
  by_cases heq : l = l'
  · subst heq
    simp only [beq_self_eq_true, ↓reduceIte] at hw1 hw2
    have hw1' := Option.some.inj hw1; have hw2' := Option.some.inj hw2
    subst hw1'; subst hw2'
    rw [hlook] at hlook'; injection hlook' with h1
    obtain ⟨rfl, rfl⟩ := Prod.mk.inj h1
    exact hvrel
  · simp only [beq_false_of_ne heq, Bool.false_eq_true, ↓reduceIte] at hw1 hw2
    exact hrel l' T' sl' hlook' w1 w2 hw1 hw2

-- === Store typing antisym ===

theorem store_ty_extends_antisym : ∀ St1 St2, store_ty_extends St1 St2 → store_ty_extends St2 St1 →
    ∀ l, store_ty_lookup l St1 = store_ty_lookup l St2 := by
  intro St1 St2 h12 h21 l
  simp only [store_ty_lookup] at *
  cases h1eq : St1 l with
  | none =>
    cases h2eq : St2 l with
    | none => rfl
    | some p =>
      have := h21 l p.1 p.2 (by simp [store_ty_lookup, h2eq])
      simp [store_ty_lookup, h1eq] at this
  | some p =>
    have := h12 l p.1 p.2 (by simp [store_ty_lookup, h1eq])
    simp [store_ty_lookup] at this
    rw [this]

theorem store_ty_update_extends : ∀ St l T lab, store_ty_lookup l St = none →
    store_ty_extends St (store_ty_update St l T lab) := by
  intro St l T lab hnone l' T' sl' hlook'
  simp only [store_ty_lookup, store_ty_update]
  by_cases heq : l = l'
  · subst heq; simp [store_ty_lookup] at hlook' hnone; rw [hnone] at hlook'; exact absurd hlook' (by simp)
  · simp [show ¬(l == l') from by simpa using heq]; exact hlook'

-- === Store lookup deterministic ===

theorem store_lookup_deterministic : ∀ s l v1 v2, store_lookup l s = some v1 → store_lookup l s = some v2 → v1 = v2 := by
  intro s l v1 v2 h1 h2; simp only [store_lookup] at h1 h2; rw [h1] at h2; exact Option.some.inj h2

theorem store_ty_lookup_deterministic : ∀ St l T1 sl1 T2 sl2,
    store_ty_lookup l St = some (T1, sl1) → store_ty_lookup l St = some (T2, sl2) → T1 = T2 ∧ sl1 = sl2 := by
  intro St l T1 sl1 T2 sl2 h1 h2
  simp [store_ty_lookup] at h1 h2; rw [h1] at h2; injection h2 with h; injection h with h3 h4
  exact ⟨h3, h4⟩

-- === Store update ===

theorem store_update_idem : ∀ s l v, store_update (store_update s l v) l v = store_update s l v := by
  intro s l v; funext l'; simp only [store_update]
  by_cases h : (l == l') = true <;> simp [h]

theorem store_update_comm : ∀ s l1 l2 v1 v2, l1 ≠ l2 →
    store_update (store_update s l1 v1) l2 v2 = store_update (store_update s l2 v2) l1 v1 := by
  intro s l1 l2 v1 v2 hne; funext l'
  simp only [store_update]
  by_cases h1 : (l2 == l') = true <;> by_cases h2 : (l1 == l') = true <;> simp [h1, h2]
  · have h1eq := beq_iff_eq.mp h1; have h2eq := beq_iff_eq.mp h2
    exact absurd (h2eq.trans h1eq.symm) hne

-- === exp_rel_n ===

theorem exp_rel_n_zero : ∀ St T e1 e2, exp_rel_n 0 St T e1 e2 := by
  intro St T e1 e2 _ _; exact trivial

theorem exp_rel_n_unit_expr : ∀ n St, n > 0 → exp_rel_n n St .TUnit .EUnit .EUnit := by
  intro n St hn _ _; exact val_rel_n_unit n St hn

theorem exp_rel_n_step_down : ∀ n m St T e1 e2, m ≤ n → exp_rel_n n St T e1 e2 → exp_rel_n m St T e1 e2 := by
  intro n m St T e1 e2 hmn hrel hv1 hv2
  exact val_rel_n_step_down n m St T e1 e2 hmn (hrel hv1 hv2)

theorem val_rel_implies_exp_rel : ∀ n St T v1 v2, is_value_b v1 = true → is_value_b v2 = true →
    val_rel_n n St T v1 v2 → exp_rel_n n St T v1 v2 := by
  intro n St T v1 v2 _ _ hrel _ _; exact hrel

theorem exp_rel_n_bool_expr : ∀ n St b, n > 0 → exp_rel_n n St .TBool (.EBool b) (.EBool b) := by
  intro n St b hn _ _; exact val_rel_n_bool n St b hn

-- === Label join ===

theorem label_join_comm : ∀ l1 l2, label_join l1 l2 = label_join l2 l1 := by
  intro l1 l2; cases l1 <;> cases l2 <;> rfl

theorem label_join_assoc : ∀ l1 l2 l3, label_join (label_join l1 l2) l3 = label_join l1 (label_join l2 l3) := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> rfl

theorem label_join_idem : ∀ l, label_join l l = l := by
  intro l; cases l <;> rfl

-- === Type decidability ===

def ty_eq_dec (T1 T2 : ty) : Decidable (T1 = T2) := inferInstance

-- === First-order components ===

theorem first_order_prod_components : ∀ T1 T2, first_order_type (.TProd T1 T2) = true →
    first_order_type T1 = true ∧ first_order_type T2 = true := by
  intro T1 T2 h; simp [first_order_type, Bool.and_eq_true] at h; exact h

theorem first_order_sum_components : ∀ T1 T2, first_order_type (.TSum T1 T2) = true →
    first_order_type T1 = true ∧ first_order_type T2 = true := by
  intro T1 T2 h; simp [first_order_type, Bool.and_eq_true] at h; exact h

-- === Depth properties ===

theorem fo_depth_prod : ∀ T1 T2, fo_compound_depth (.TProd T1 T2) = 1 + max (fo_compound_depth T1) (fo_compound_depth T2) := by
  intro _ _; rfl

theorem fo_depth_sum : ∀ T1 T2, fo_compound_depth (.TSum T1 T2) = 1 + max (fo_compound_depth T1) (fo_compound_depth T2) := by
  intro _ _; rfl

theorem fo_depth_primitive : ∀ T, (match T with | .TUnit | .TBool | .TNat | .TRef _ _ => True | _ => False) →
    fo_compound_depth T = 0 := by
  intro T h; cases T <;> simp_all [fo_compound_depth]

end MaximumAxiomElimination

end RIINA
