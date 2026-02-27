-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA CertificationEvidence - Lean 4 Port

Port of 02_FORMAL/coq/domains/CertificationEvidence.v (24 theorems).

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| differ_at_one | differ_at_one | OK |
| mcdc_pair | mcdc_pair | OK |
| fully_traced | fully_traced | OK |
| all_tests_linked | all_tests_linked | OK |
| sfr_satisfied | sfr_satisfied | OK |
| dal_to_nat | dal_to_nat | OK |
| dal_leq | dal_leq | OK |
| evidence_count | evidence_count | OK |
| eqb_sym | eqb_sym | OK |
| forallb_eqb_combine_sym | forallb_eqb_combine_sym | OK |
| differ_at_one_sym | differ_at_one_sym | OK |
| mcdc_pair_sym | mcdc_pair_sym | OK |
| no_self_mcdc | no_self_mcdc | OK |
| full_trace_no_gaps | full_trace_no_gaps | OK |
| sfr_needs_evidence | sfr_needs_evidence | OK |
| sfr_needs_verification | sfr_needs_verification | OK |
| dal_a_highest | dal_a_highest | OK |
| dal_leq_refl | dal_leq_refl | OK |
| dal_leq_trans | dal_leq_trans | OK |
| fold_left_add_acc | fold_left_add_acc | OK |
| evidence_count_app | evidence_count_app | OK |
| all_satisfied_have_evidence | all_satisfied_have_evidence | OK |
| empty_trace_fully_traced | empty_trace_fully_traced | OK |
| dal_e_lowest | dal_e_lowest | OK |
| dal_leq_antisym | dal_leq_antisym | OK |
| dal_to_nat_bounded | dal_to_nat_bounded | OK |
| evidence_count_nil | evidence_count_nil | OK |
| evidence_count_singleton | evidence_count_singleton | OK |
| sfr_satisfied_decompose | sfr_satisfied_decompose | OK |
| no_self_mcdc_no_flip | no_self_mcdc_no_flip | OK |
| dal_a_gt_b | dal_a_gt_b | OK |
| evidence_count_mono | evidence_count_mono | OK |
-/

namespace RIINA.Domains.CertificationEvidence

-- Type aliases
abbrev ReqId := Nat
abbrev TestId := Nat
abbrev ConditionId := Nat
abbrev CondVector := List Bool

-- Coq compatibility: forallb
private def forallb {α : Type} (f : α → Bool) (xs : List α) : Bool := xs.all f

/-- Two vectors differ in exactly one position -/
def differ_at_one (v1 v2 : CondVector) : Option Nat :=
  match v1, v2 with
  | [], [] => none
  | b1 :: r1, b2 :: r2 =>
      if b1 == b2 then
        match differ_at_one r1 r2 with
        | some n => some (n + 1)
        | none => none
      else
        if forallb (fun p => p.1 == p.2) (r1.zip r2)
        then some 0
        else none
  | _, _ => none

/-- MC/DC pair: two vectors differ at one position and flip the decision -/
def mcdc_pair (v1 v2 : CondVector) (decision : CondVector → Bool) : Prop :=
  ∃ pos, differ_at_one v1 v2 = some pos ∧
    decision v1 ≠ decision v2

/-- Traceability record -/
structure Traceability where
  tr_reqs : List ReqId
  tr_tests : List TestId
  tr_map : ReqId → List TestId

/-- Full traceability: every requirement maps to at least one test -/
def fully_traced (t : Traceability) : Prop :=
  ∀ r, r ∈ t.tr_reqs → t.tr_map r ≠ []

/-- All tests are linked to some requirement -/
def all_tests_linked (t : Traceability) : Prop :=
  ∀ tid, tid ∈ t.tr_tests →
    ∃ r, r ∈ t.tr_reqs ∧ tid ∈ t.tr_map r

/-- Security Functional Requirement -/
structure SFR where
  sfr_id : Nat
  sfr_verified : Bool
  sfr_evidence_count : Nat

/-- SFR satisfaction: verified and has evidence -/
def sfr_satisfied (s : SFR) : Prop :=
  s.sfr_verified = true ∧ s.sfr_evidence_count ≥ 1

/-- DAL levels (DO-178C) -/
inductive DalLevel where
  | DAL_A : DalLevel
  | DAL_B : DalLevel
  | DAL_C : DalLevel
  | DAL_D : DalLevel
  | DAL_E : DalLevel
deriving DecidableEq

/-- Convert DAL level to natural number -/
def dal_to_nat (d : DalLevel) : Nat :=
  match d with
  | .DAL_A => 5
  | .DAL_B => 4
  | .DAL_C => 3
  | .DAL_D => 2
  | .DAL_E => 1

/-- DAL ordering (less-or-equal) -/
def dal_leq (d1 d2 : DalLevel) : Bool :=
  Nat.ble (dal_to_nat d1) (dal_to_nat d2)

/-- Evidence count: sum of evidence items across SFRs -/
def evidence_count (sfrs : List SFR) : Nat :=
  sfrs.foldl (fun acc s => acc + s.sfr_evidence_count) 0

-- ============================================================
-- Helper lemmas
-- ============================================================

/-- Boolean equality is symmetric -/
theorem eqb_sym (a b : Bool) : (a == b) = (b == a) := by
  cases a <;> cases b <;> rfl

/-- forallb of eqb over zip is symmetric -/
theorem forallb_eqb_combine_sym (v1 v2 : List Bool) :
    forallb (fun p => p.1 == p.2) (v1.zip v2) = true →
    forallb (fun p => p.1 == p.2) (v2.zip v1) = true := by
  induction v1 generalizing v2 with
  | nil => intro _; cases v2 <;> rfl
  | cons a1 r1 ih =>
    cases v2 with
    | nil => intro _; rfl
    | cons a2 r2 =>
      simp only [forallb, List.zip, List.all, List.zipWith]
      intro h
      cases hab : (a1 == a2) with
      | false => simp [hab] at h
      | true =>
        simp only [hab, Bool.true_and] at h
        have ha2 : (a2 == a1) = true := by rw [eqb_sym]; exact hab
        have hr2 := ih r2 h
        simp only [ha2, Bool.true_and]
        exact hr2

/-- differ_at_one is symmetric -/
theorem differ_at_one_sym (v1 v2 : CondVector) (pos : Nat) :
    differ_at_one v1 v2 = some pos → differ_at_one v2 v1 = some pos := by
  induction v1 generalizing v2 pos with
  | nil =>
    cases v2 with
    | nil => intro h; exact h
    | cons _ _ => intro h; simp [differ_at_one] at h
  | cons a1 r1 ih =>
    cases v2 with
    | nil => intro h; simp [differ_at_one] at h
    | cons a2 r2 =>
      intro h
      simp only [differ_at_one] at h ⊢
      cases hab : (a1 == a2) with
      | true =>
        have hab2 : (a2 == a1) = true := by rw [eqb_sym]; exact hab
        simp only [hab, ite_true] at h
        simp only [hab2, ite_true]
        match hd : differ_at_one r1 r2 with
        | some n =>
          rw [hd] at h; simp at h; subst h
          have hd2 := ih r2 n hd
          rw [hd2]
        | none => rw [hd] at h; simp at h
      | false =>
        have hab2 : (a2 == a1) = false := by rw [← eqb_sym]; exact hab
        simp only [hab, ite_false] at h
        simp only [hab2, ite_false]
        cases hf : forallb (fun p => p.1 == p.2) (r1.zip r2) with
        | true =>
          rw [hf] at h; simp at h; subst h
          rw [forallb_eqb_combine_sym r1 r2 hf]; simp
        | false => rw [hf] at h; simp at h

-- ============================================================
-- Theorems 1-20
-- ============================================================

/-- Theorem 1: MC/DC pair symmetry -/
theorem mcdc_pair_sym (v1 v2 : CondVector) (d : CondVector → Bool) :
    mcdc_pair v1 v2 d → mcdc_pair v2 v1 d := by
  intro ⟨pos, hdiff, hdec⟩
  exact ⟨pos, differ_at_one_sym v1 v2 pos hdiff, Ne.symm hdec⟩

/-- Theorem 2: Vectors equal to themselves have no MC/DC differ -/
theorem no_self_mcdc (v : CondVector) : differ_at_one v v = none := by
  induction v with
  | nil => rfl
  | cons a r ih =>
    simp only [differ_at_one]
    have : (a == a) = true := by cases a <;> rfl
    simp [this, ih]

/-- Theorem 3: Full traceability means no untested requirements -/
theorem full_trace_no_gaps (t : Traceability) :
    fully_traced t → ∀ r, r ∈ t.tr_reqs → ∃ tid, tid ∈ t.tr_map r := by
  intro ht r hr
  have hne := ht r hr
  cases hm : t.tr_map r with
  | nil => exact absurd hm hne
  | cons x xs => exact ⟨x, hm ▸ List.mem_cons_self x xs⟩

/-- Theorem 4: SFR satisfaction requires evidence -/
theorem sfr_needs_evidence (s : SFR) :
    sfr_satisfied s → s.sfr_evidence_count ≥ 1 := by
  intro ⟨_, h⟩; exact h

/-- Theorem 5: SFR satisfaction requires verification -/
theorem sfr_needs_verification (s : SFR) :
    sfr_satisfied s → s.sfr_verified = true := by
  intro ⟨h, _⟩; exact h

/-- Theorem 6: DAL_A is the highest level -/
theorem dal_a_highest (d : DalLevel) : dal_leq d .DAL_A = true := by
  cases d <;> rfl

/-- Theorem 7: DAL ordering is reflexive -/
theorem dal_leq_refl (d : DalLevel) : dal_leq d d = true := by
  cases d <;> rfl

/-- Theorem 8: DAL ordering is transitive -/
theorem dal_leq_trans (d1 d2 d3 : DalLevel) :
    dal_leq d1 d2 = true → dal_leq d2 d3 = true → dal_leq d1 d3 = true := by
  simp only [dal_leq]
  cases d1 <;> cases d2 <;> cases d3 <;> simp [dal_to_nat, Nat.ble]

/-- fold_left_add_acc: accumulator lemma for foldl -/
theorem fold_left_add_acc (l : List SFR) (acc : Nat) :
    l.foldl (fun a s => a + s.sfr_evidence_count) acc =
    acc + l.foldl (fun a s => a + s.sfr_evidence_count) 0 := by
  induction l generalizing acc with
  | nil => simp [List.foldl]
  | cons x xs ih =>
    simp only [List.foldl]
    rw [ih (acc + x.sfr_evidence_count)]
    rw [ih (0 + x.sfr_evidence_count)]
    omega

/-- Theorem 9: Evidence count is additive over concatenation -/
theorem evidence_count_app (l1 l2 : List SFR) :
    evidence_count (l1 ++ l2) = evidence_count l1 + evidence_count l2 := by
  simp only [evidence_count]
  rw [List.foldl_append]
  rw [fold_left_add_acc]

/-- Theorem 10: All satisfied SFRs contribute evidence -/
theorem all_satisfied_have_evidence (sfrs : List SFR) :
    (∀ s, s ∈ sfrs → sfr_satisfied s) →
    evidence_count sfrs ≥ sfrs.length := by
  induction sfrs with
  | nil => simp [evidence_count, List.foldl]
  | cons x xs ih =>
    intro hall
    simp only [evidence_count, List.foldl, List.length_cons]
    rw [fold_left_add_acc]
    have hx := hall x (List.mem_cons_self x xs)
    have hxs : ∀ s, s ∈ xs → sfr_satisfied s :=
      fun s hs => hall s (List.mem_cons_of_mem x hs)
    have := ih hxs
    simp only [evidence_count] at this
    have hev := hx.2
    omega

/-- Theorem 11: Empty traceability is vacuously fully traced -/
theorem empty_trace_fully_traced (tt_ : List TestId) (tm : ReqId → List TestId) :
    fully_traced (Traceability.mk [] tt_ tm) := by
  intro r hr
  exact absurd hr (List.not_mem_nil r)

/-- Theorem 12: DAL_E is the lowest level -/
theorem dal_e_lowest (d : DalLevel) : dal_leq .DAL_E d = true := by
  cases d <;> rfl

/-- Theorem 13: DAL ordering is antisymmetric on nat -/
theorem dal_leq_antisym (d1 d2 : DalLevel) :
    dal_leq d1 d2 = true → dal_leq d2 d1 = true → dal_to_nat d1 = dal_to_nat d2 := by
  cases d1 <;> cases d2 <;> simp [dal_leq, dal_to_nat, Nat.ble]

/-- Theorem 14: dal_to_nat is bounded -/
theorem dal_to_nat_bounded (d : DalLevel) : dal_to_nat d ≤ 5 ∧ dal_to_nat d ≥ 1 := by
  cases d <;> simp [dal_to_nat]

/-- Theorem 15: Evidence count of nil is zero -/
theorem evidence_count_nil : evidence_count [] = 0 := by
  rfl

/-- Theorem 16: Evidence count of singleton -/
theorem evidence_count_singleton (s : SFR) :
    evidence_count [s] = s.sfr_evidence_count := by
  simp [evidence_count, List.foldl]

/-- Theorem 17: SFR satisfied decomposition -/
theorem sfr_satisfied_decompose (sid : Nat) (sv : Bool) (sec : Nat) :
    sfr_satisfied (SFR.mk sid sv sec) → sv = true ∧ sec ≥ 1 := by
  intro ⟨h1, h2⟩
  exact ⟨h1, h2⟩

/-- Theorem 18: No self MC/DC means no decision flip -/
theorem no_self_mcdc_no_flip (v : CondVector) (d : CondVector → Bool) :
    ¬ mcdc_pair v v d := by
  intro ⟨pos, hdiff, _⟩
  rw [no_self_mcdc] at hdiff
  exact absurd hdiff (by simp)

/-- Theorem 19: DAL_A strictly greater than DAL_B -/
theorem dal_a_gt_b : dal_to_nat .DAL_A > dal_to_nat .DAL_B := by
  simp [dal_to_nat]

/-- Theorem 20: Evidence count monotonic under append -/
theorem evidence_count_mono (l : List SFR) (s : SFR) :
    evidence_count l ≤ evidence_count (l ++ [s]) := by
  rw [evidence_count_app, evidence_count_singleton]
  omega

end RIINA.Domains.CertificationEvidence
