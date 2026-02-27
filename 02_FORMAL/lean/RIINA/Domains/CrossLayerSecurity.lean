-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA CrossLayerSecurity - Lean 4 Port

Port of 02_FORMAL/coq/domains/CrossLayerSecurity.v (21 theorems).

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| label | label | OK |
| src_expr | src_expr | OK |
| tgt_instr | tgt_instr | OK |
| label_eqb | label_eqb | OK |
| label_leb | label_leb | OK |
| label_join | label_join | OK |
| lookup | lookup | OK |
| src_eval | src_eval | OK |
| src_low_equiv | src_low_equiv | OK |
| tgt_label_of_prog | tgt_label_of_prog | OK |
| tgt_eval_fuel | tgt_eval_fuel | OK |
| compile_with_env | compile_with_env | OK |
| is_constant_time | is_constant_time | OK |
| label_eqb_refl | label_eqb_refl | OK |
| label_leb_refl | label_leb_refl | OK |
| label_leb_trans | label_leb_trans | OK |
| label_join_low_r | label_join_low_r | OK |
| label_join_comm | label_join_comm | OK |
| lookup_some_both | lookup_some_both | OK |
| source_noninterference | source_noninterference | OK |
| compilation_preserves_labels | compilation_preserves_labels | OK |
| tgt_eval_env_independent | tgt_eval_env_independent | OK |
| target_noninterference | target_noninterference | OK |
| semantic_preservation | semantic_preservation | OK |
| security_composition | security_composition | OK |
| label_monotonicity_compilation | label_monotonicity_compilation | OK |
| constant_time_preserved | constant_time_preserved | OK |
| end_to_end_security | end_to_end_security | OK |
| compiler_determinism | compiler_determinism | OK |
| label_lattice_join_upper_bound | label_lattice_join_upper_bound | OK |
| label_lattice_join_least | label_lattice_join_least | OK |
| label_eqb_refl2 | label_eqb_refl2 | OK |
| label_join_comm2 | label_join_comm2 | OK |
| label_join_idem2 | label_join_idem2 | OK |
-/

namespace RIINA.Domains.CrossLayerSecurity

-- ====================================================================
-- Section 1: Security Labels
-- ====================================================================

/-- Security label: Low or High -/
inductive label where
  | Low : label
  | High : label
  deriving DecidableEq, Repr

open label

/-- Boolean equality for labels -/
def label_eqb (l1 l2 : label) : Bool :=
  match l1, l2 with
  | .Low, .Low => true
  | .High, .High => true
  | _, _ => false

/-- Label ordering (less-than-or-equal) -/
def label_leb (l1 l2 : label) : Bool :=
  match l1, l2 with
  | .Low, _ => true
  | .High, .High => true
  | .High, .Low => false

/-- Label join (least upper bound) -/
def label_join (l1 l2 : label) : label :=
  match l1, l2 with
  | .Low, .Low => .Low
  | _, _ => .High

/-- Helper: label_join l1 l2 = Low implies both are Low -/
private theorem label_join_low_inv (l1 l2 : label) (h : label_join l1 l2 = .Low) :
    l1 = .Low ∧ l2 = .Low := by
  cases l1 <;> cases l2 <;> simp [label_join] at h <;> exact ⟨rfl, rfl⟩

-- ====================================================================
-- Section 2: Source Language
-- ====================================================================

/-- Source expression type -/
inductive src_expr where
  | SConst : Nat → label → src_expr
  | SVar : Nat → label → src_expr
  | SAdd : src_expr → src_expr → src_expr
  | SIf : src_expr → src_expr → src_expr → src_expr
  deriving DecidableEq, Repr

open src_expr

/-- Source environment: list of (value, label) pairs -/
abbrev src_env := List (Nat × label)

/-- Look up variable in environment by index -/
def lookup (env : src_env) (x : Nat) : Option (Nat × label) :=
  match env with
  | [] => none
  | (v, l) :: rest =>
    match x with
    | 0 => some (v, l)
    | Nat.succ x' => lookup rest x'

/-- Evaluate source expression in environment -/
def src_eval (env : src_env) (e : src_expr) : Option (Nat × label) :=
  match e with
  | .SConst n l => some (n, l)
  | .SVar x _ =>
    match lookup env x with
    | some (v, l') => some (v, l')
    | none => none
  | .SAdd e1 e2 =>
    match src_eval env e1, src_eval env e2 with
    | some (v1, l1), some (v2, l2) => some (v1 + v2, label_join l1 l2)
    | _, _ => none
  | .SIf c t f =>
    match src_eval env c with
    | some (0, lc) =>
      match src_eval env f with
      | some (v, lv) => some (v, label_join lc lv)
      | none => none
    | some (Nat.succ _, lc) =>
      match src_eval env t with
      | some (v, lv) => some (v, label_join lc lv)
      | none => none
    | none => none

/-- Low-equivalence of two environments -/
def src_low_equiv (env1 env2 : src_env) : Prop :=
  env1.length = env2.length ∧
  ∀ x v1 l1 v2 l2,
    lookup env1 x = some (v1, l1) →
    lookup env2 x = some (v2, l2) →
    l1 = .Low → l2 = .Low → v1 = v2

-- ====================================================================
-- Section 3: Target Language (assembly-like, stack-based)
-- ====================================================================

/-- Target instruction type -/
inductive tgt_instr where
  | TLoad : Nat → label → tgt_instr
  | TRead : Nat → label → tgt_instr
  | TAddI : tgt_instr
  | TBrz : Nat → tgt_instr
  | TJmp : Nat → tgt_instr
  | THalt : tgt_instr
  deriving DecidableEq, Repr

open tgt_instr

/-- Target program: list of instructions -/
abbrev tgt_prog := List tgt_instr

/-- Target stack: list of (value, label) pairs -/
abbrev tgt_stack := List (Nat × label)

/-- Get the label of the first instruction of a program -/
def tgt_label_of_prog (p : tgt_prog) : label :=
  match p with
  | [] => .Low
  | .TLoad _ l :: _ => l
  | .TRead _ l :: _ => l
  | _ :: _ => .Low

/-- Fuel-bounded evaluation of target programs -/
def tgt_eval_fuel (fuel : Nat) (env : src_env) (prog : tgt_prog)
    (pc : Nat) (stack : tgt_stack) : Option (Nat × label) :=
  match fuel with
  | 0 => none
  | Nat.succ fuel' =>
    match prog.get? pc with
    | none =>
      match stack with
      | top :: _ => some top
      | [] => none
    | some instr =>
      match instr with
      | .TLoad n l => tgt_eval_fuel fuel' env prog (pc + 1) ((n, l) :: stack)
      | .TRead x l =>
        match lookup env x with
        | some (v, _) => tgt_eval_fuel fuel' env prog (pc + 1) ((v, l) :: stack)
        | none => none
      | .TAddI =>
        match stack with
        | (v1, l1) :: (v2, l2) :: rest =>
          tgt_eval_fuel fuel' env prog (pc + 1) ((v2 + v1, label_join l1 l2) :: rest)
        | _ => none
      | .TBrz off =>
        match stack with
        | (0, _) :: rest => tgt_eval_fuel fuel' env prog off rest
        | (_, _) :: rest => tgt_eval_fuel fuel' env prog (pc + 1) rest
        | [] => none
      | .TJmp off => tgt_eval_fuel fuel' env prog off stack
      | .THalt =>
        match stack with
        | top :: _ => some top
        | [] => none

-- ====================================================================
-- Section 4: Compiler (Source -> Target)
-- ====================================================================

/-- Compile source expression to target program using environment -/
def compile_with_env (env : src_env) (e : src_expr) : Option tgt_prog :=
  match src_eval env e with
  | some (v, l) => some [.TLoad v l, .THalt]
  | none => none

/-- A program is constant-time if it contains no branch instructions -/
def is_constant_time (prog : tgt_prog) : Prop :=
  ∀ i instr, prog.get? i = some instr →
    match instr with
    | .TBrz _ => False
    | _ => True

-- ====================================================================
-- Basic label lemmas
-- ====================================================================

/-- label_eqb_refl (matches Coq) -/
theorem label_eqb_refl : ∀ l, label_eqb l l = true := by
  intro l; cases l <;> rfl

/-- label_leb_refl (matches Coq) -/
theorem label_leb_refl : ∀ l, label_leb l l = true := by
  intro l; cases l <;> rfl

/-- label_leb_trans (matches Coq) -/
theorem label_leb_trans : ∀ l1 l2 l3,
    label_leb l1 l2 = true → label_leb l2 l3 = true → label_leb l1 l3 = true := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> simp [label_leb]

/-- label_join_low_r (matches Coq) -/
theorem label_join_low_r : ∀ l, label_join l .Low = l := by
  intro l; cases l <;> rfl

/-- label_join_comm (matches Coq) -/
theorem label_join_comm : ∀ l1 l2, label_join l1 l2 = label_join l2 l1 := by
  intro l1 l2; cases l1 <;> cases l2 <;> rfl

-- ====================================================================
-- Theorem: lookup_some_both
-- ====================================================================

/-- lookup_some_both: If env1 and env2 have the same length and lookup env1 x succeeds,
    then lookup env2 x also succeeds -/
theorem lookup_some_both : ∀ (env1 env2 : src_env) (x : Nat) (v1 : Nat) (l1 : label),
    env1.length = env2.length →
    lookup env1 x = some (v1, l1) →
    ∃ v2 l2, lookup env2 x = some (v2, l2) := by
  intro env1
  induction env1 with
  | nil =>
    intro env2 x v1 l1 _ h
    simp [lookup] at h
  | cons a rest1 ih =>
    intro env2 x v1 l1 hlen hlook
    cases env2 with
    | nil => simp [List.length] at hlen
    | cons b rest2 =>
      obtain ⟨va, la⟩ := a
      obtain ⟨vb, lb⟩ := b
      cases x with
      | zero =>
        exact ⟨vb, lb, rfl⟩
      | succ x' =>
        simp [lookup] at hlook
        have hlen' : rest1.length = rest2.length := by
          simp [List.length] at hlen; exact hlen
        exact ih rest2 x' v1 l1 hlen' hlook

-- ====================================================================
-- Theorem: source_noninterference
-- ====================================================================

/-- source_noninterference: If two low-equivalent environments both evaluate
    a source expression to Low results, then the values are equal -/
theorem source_noninterference : ∀ (e : src_expr) (env1 env2 : src_env)
    (v1 : Nat) (l1 : label) (v2 : Nat) (l2 : label),
    src_low_equiv env1 env2 →
    src_eval env1 e = some (v1, l1) →
    src_eval env2 e = some (v2, l2) →
    l1 = .Low → l2 = .Low →
    v1 = v2 := by
  intro e
  induction e with
  | SConst n l =>
    intro env1 env2 v1 l1 v2 l2 _ he1 he2 _ _
    simp [src_eval] at he1 he2
    obtain ⟨rfl, _⟩ := he1
    obtain ⟨rfl, _⟩ := he2
    rfl
  | SVar x lx =>
    intro env1 env2 v1 l1 v2 l2 hle he1 he2 hl1 hl2
    obtain ⟨_, hlow⟩ := hle
    simp [src_eval] at he1 he2
    -- Split on lookup env1 x
    split at he1
    · rename_i hk1 v' l' hlk1
      simp at he1
      obtain ⟨rfl, rfl⟩ := he1
      -- Split on lookup env2 x
      split at he2
      · rename_i hk2 v'' l'' hlk2
        simp at he2
        obtain ⟨rfl, rfl⟩ := he2
        exact hlow x v' l' v'' l'' hlk1 hlk2 hl1 hl2
      · simp at he2
    · simp at he1
  | SAdd e1 e2 ih1 ih2 =>
    intro env1 env2 v1 l1 v2 l2 hle he1 he2 hl1 hl2
    subst hl1 hl2
    simp only [src_eval] at he1 he2
    revert he1 he2
    match ha1 : src_eval env1 e1, ha2 : src_eval env1 e2 with
    | some (va1, la1), some (va2, la2) =>
      simp [ha1, ha2]
      intro hveq hlj1
      match hb1 : src_eval env2 e1, hb2 : src_eval env2 e2 with
      | some (vb1, lb1), some (vb2, lb2) =>
        simp [hb1, hb2]
        intro hveq2 hlj2
        have ⟨hla1, hla2⟩ := label_join_low_inv la1 la2 hlj1
        have ⟨hlb1, hlb2⟩ := label_join_low_inv lb1 lb2 hlj2
        have := ih1 env1 env2 va1 la1 vb1 lb1 hle ha1 hb1 hla1 hlb1
        have := ih2 env1 env2 va2 la2 vb2 lb2 hle ha2 hb2 hla2 hlb2
        omega
      | some _, none => simp [hb1, hb2]
      | none, _ => simp [hb1]
    | some _, none => simp [ha1, ha2]
    | none, _ => simp [ha1]
  | SIf c t f ihc iht ihf =>
    intro env1 env2 v1 l1 v2 l2 hle he1 he2 hl1 hl2
    subst hl1 hl2
    simp only [src_eval] at he1 he2
    revert he1 he2
    match hc1 : src_eval env1 c with
    | none => simp [hc1]
    | some (0, lc1) =>
      match hf1 : src_eval env1 f with
      | none => simp [hc1, hf1]
      | some (vf1, lf1) =>
        simp [hc1, hf1]
        intro hv1eq hlj1
        have ⟨hlc1, hlf1⟩ := label_join_low_inv lc1 lf1 hlj1
        match hc2 : src_eval env2 c with
        | none => simp [hc2]
        | some (0, lc2) =>
          match hf2 : src_eval env2 f with
          | none => simp [hc2, hf2]
          | some (vf2, lf2) =>
            simp [hc2, hf2]
            intro hv2eq hlj2
            have ⟨_, hlf2⟩ := label_join_low_inv lc2 lf2 hlj2
            subst hv1eq hv2eq
            exact ihf env1 env2 vf1 lf1 vf2 lf2 hle hf1 hf2 hlf1 hlf2
        | some (Nat.succ n2, lc2) =>
          match ht2 : src_eval env2 t with
          | none => simp [hc2, ht2]
          | some (vt2, lt2) =>
            simp [hc2, ht2]
            intro _ hlj2
            have ⟨hlc2, _⟩ := label_join_low_inv lc2 lt2 hlj2
            have hceq := ihc env1 env2 0 lc1 (Nat.succ n2) lc2 hle hc1 hc2 hlc1 hlc2
            exact absurd hceq (by omega)
    | some (Nat.succ n1, lc1) =>
      match ht1 : src_eval env1 t with
      | none => simp [hc1, ht1]
      | some (vt1, lt1) =>
        simp [hc1, ht1]
        intro hv1eq hlj1
        have ⟨hlc1, hlt1⟩ := label_join_low_inv lc1 lt1 hlj1
        match hc2 : src_eval env2 c with
        | none => simp [hc2]
        | some (0, lc2) =>
          match hf2 : src_eval env2 f with
          | none => simp [hc2, hf2]
          | some (vf2, lf2) =>
            simp [hc2, hf2]
            intro _ hlj2
            have ⟨hlc2, _⟩ := label_join_low_inv lc2 lf2 hlj2
            have hceq := ihc env1 env2 (Nat.succ n1) lc1 0 lc2 hle hc1 hc2 hlc1 hlc2
            exact absurd hceq (by omega)
        | some (Nat.succ n2, lc2) =>
          match ht2 : src_eval env2 t with
          | none => simp [hc2, ht2]
          | some (vt2, lt2) =>
            simp [hc2, ht2]
            intro hv2eq hlj2
            have ⟨hlc2, hlt2⟩ := label_join_low_inv lc2 lt2 hlj2
            subst hv1eq hv2eq
            exact iht env1 env2 vt1 lt1 vt2 lt2 hle ht1 ht2 hlt1 hlt2

-- ====================================================================
-- Theorem: compilation_preserves_labels
-- ====================================================================

/-- compilation_preserves_labels (matches Coq) -/
theorem compilation_preserves_labels : ∀ (env : src_env) (e : src_expr)
    (v : Nat) (l : label) (prog : tgt_prog),
    src_eval env e = some (v, l) →
    compile_with_env env e = some prog →
    tgt_label_of_prog prog = l := by
  intro env e v l prog heval hcomp
  unfold compile_with_env at hcomp
  rw [heval] at hcomp
  simp at hcomp
  subst hcomp
  rfl

-- ====================================================================
-- Lemma: tgt_eval_env_independent
-- ====================================================================

/-- tgt_eval_env_independent: If a program has no TRead instructions,
    evaluation is independent of the environment -/
theorem tgt_eval_env_independent : ∀ (fuel : Nat) (env1 env2 : src_env)
    (prog : tgt_prog) (pc : Nat) (stk : tgt_stack),
    (∀ (i : Nat) (instr : tgt_instr), prog.get? i = some instr →
      match instr with | .TRead _ _ => False | _ => True) →
    tgt_eval_fuel fuel env1 prog pc stk = tgt_eval_fuel fuel env2 prog pc stk := by
  intro fuel
  induction fuel with
  | zero => intro _ _ _ _ _ _; rfl
  | succ fuel' ih =>
    intro env1 env2 prog pc stk hnoread
    simp only [tgt_eval_fuel]
    match hget : prog.get? pc with
    | none => rfl
    | some instr =>
      simp only [hget]
      have hni := hnoread pc instr hget
      match instr with
      | .TLoad n l => exact ih env1 env2 prog (pc + 1) ((n, l) :: stk) hnoread
      | .TRead _ _ => exact absurd hni id
      | .TAddI =>
        match stk with
        | [] => rfl
        | [_] => rfl
        | (v1, l1) :: (v2, l2) :: rest =>
          exact ih env1 env2 prog (pc + 1) ((v2 + v1, label_join l1 l2) :: rest) hnoread
      | .TBrz off =>
        match stk with
        | [] => rfl
        | (0, _) :: rest => exact ih env1 env2 prog off rest hnoread
        | (Nat.succ _, _) :: rest => exact ih env1 env2 prog (pc + 1) rest hnoread
      | .TJmp off => exact ih env1 env2 prog off stk hnoread
      | .THalt => rfl

-- ====================================================================
-- Theorem: target_noninterference
-- ====================================================================

/-- target_noninterference (matches Coq) -/
theorem target_noninterference : ∀ (prog : tgt_prog) (env1 env2 : src_env)
    (v1 : Nat) (l1 : label) (v2 : Nat) (l2 : label) (fuel : Nat),
    tgt_eval_fuel fuel env1 prog 0 [] = some (v1, l1) →
    tgt_eval_fuel fuel env2 prog 0 [] = some (v2, l2) →
    l1 = .Low → l2 = .Low →
    (∀ (i : Nat) (instr : tgt_instr), prog.get? i = some instr →
      match instr with | .TRead _ _ => False | _ => True) →
    v1 = v2 := by
  intro prog env1 env2 v1 l1 v2 l2 fuel h1 h2 _ _ hnoread
  rw [tgt_eval_env_independent fuel env1 env2 prog 0 [] hnoread] at h1
  rw [h1] at h2
  simp at h2
  exact h2.1

-- ====================================================================
-- Theorem: semantic_preservation
-- ====================================================================

/-- semantic_preservation (matches Coq) -/
theorem semantic_preservation : ∀ (env : src_env) (e : src_expr)
    (v : Nat) (l : label) (prog : tgt_prog),
    src_eval env e = some (v, l) →
    compile_with_env env e = some prog →
    tgt_eval_fuel 3 env prog 0 [] = some (v, l) := by
  intro env e v l prog heval hcomp
  unfold compile_with_env at hcomp
  rw [heval] at hcomp
  simp at hcomp
  subst hcomp
  rfl

-- ====================================================================
-- Theorem: security_composition
-- ====================================================================

/-- security_composition (matches Coq) -/
theorem security_composition : ∀ (env1 env2 : src_env) (e1 e2 : src_expr)
    (v1 : Nat) (l1 : label) (v2 : Nat) (l2 : label)
    (v3 : Nat) (l3 : label) (v4 : Nat) (l4 : label),
    src_low_equiv env1 env2 →
    src_eval env1 e1 = some (v1, l1) →
    src_eval env2 e1 = some (v2, l2) →
    src_eval env1 e2 = some (v3, l3) →
    src_eval env2 e2 = some (v4, l4) →
    l1 = .Low → l2 = .Low → l3 = .Low → l4 = .Low →
    v1 = v2 ∧ v3 = v4 := by
  intro env1 env2 e1 e2 v1 l1 v2 l2 v3 l3 v4 l4
    hle he1a he1b he2a he2b hl1 hl2 hl3 hl4
  constructor
  · exact source_noninterference e1 env1 env2 v1 l1 v2 l2 hle he1a he1b hl1 hl2
  · exact source_noninterference e2 env1 env2 v3 l3 v4 l4 hle he2a he2b hl3 hl4

-- ====================================================================
-- Theorem: label_monotonicity_compilation
-- ====================================================================

/-- label_monotonicity_compilation (matches Coq) -/
theorem label_monotonicity_compilation : ∀ (env : src_env) (e : src_expr)
    (v : Nat) (l : label) (prog : tgt_prog),
    src_eval env e = some (v, l) →
    compile_with_env env e = some prog →
    label_leb l (tgt_label_of_prog prog) = true := by
  intro env e v l prog heval hcomp
  have hlabel := compilation_preserves_labels env e v l prog heval hcomp
  rw [hlabel]
  exact label_leb_refl l

-- ====================================================================
-- Theorem: constant_time_preserved
-- ====================================================================

/-- constant_time_preserved (matches Coq) -/
theorem constant_time_preserved : ∀ (env : src_env) (e : src_expr)
    (v : Nat) (l : label) (prog : tgt_prog),
    src_eval env e = some (v, l) →
    compile_with_env env e = some prog →
    is_constant_time prog := by
  intro env e v l prog heval hcomp
  unfold compile_with_env at hcomp
  rw [heval] at hcomp
  simp at hcomp
  subst hcomp
  intro i instr hnth
  match i with
  | 0 => simp [List.get?] at hnth; subst hnth; trivial
  | 1 => simp [List.get?] at hnth; subst hnth; trivial
  | Nat.succ (Nat.succ (Nat.succ _)) => simp [List.get?] at hnth

-- ====================================================================
-- Theorem: end_to_end_security
-- ====================================================================

/-- end_to_end_security (matches Coq) -/
theorem end_to_end_security : ∀ (e : src_expr) (env1 env2 : src_env)
    (v1 : Nat) (l1 : label) (v2 : Nat) (l2 : label)
    (prog1 prog2 : tgt_prog),
    src_low_equiv env1 env2 →
    src_eval env1 e = some (v1, l1) →
    src_eval env2 e = some (v2, l2) →
    compile_with_env env1 e = some prog1 →
    compile_with_env env2 e = some prog2 →
    l1 = .Low → l2 = .Low →
    ∃ tv1 tl1 tv2 tl2,
      tgt_eval_fuel 3 env1 prog1 0 [] = some (tv1, tl1) ∧
      tgt_eval_fuel 3 env2 prog2 0 [] = some (tv2, tl2) ∧
      tv1 = tv2 ∧ tl1 = .Low ∧ tl2 = .Low := by
  intro e env1 env2 v1 l1 v2 l2 prog1 prog2
    hle hev1 hev2 hc1 hc2 hl1 hl2
  have hsem1 := semantic_preservation env1 e v1 l1 prog1 hev1 hc1
  have hsem2 := semantic_preservation env2 e v2 l2 prog2 hev2 hc2
  subst hl1 hl2
  have heq := source_noninterference e env1 env2 v1 .Low v2 .Low hle hev1 hev2 rfl rfl
  exact ⟨v1, .Low, v2, .Low, hsem1, hsem2, heq, rfl, rfl⟩

-- ====================================================================
-- Theorem: compiler_determinism
-- ====================================================================

/-- compiler_determinism (matches Coq) -/
theorem compiler_determinism : ∀ (env : src_env) (e : src_expr)
    (prog1 prog2 : tgt_prog),
    compile_with_env env e = some prog1 →
    compile_with_env env e = some prog2 →
    prog1 = prog2 := by
  intro env e prog1 prog2 h1 h2
  rw [h1] at h2
  simp at h2
  exact h2

-- ====================================================================
-- Theorem: label_lattice_join_upper_bound
-- ====================================================================

/-- label_lattice_join_upper_bound (matches Coq) -/
theorem label_lattice_join_upper_bound : ∀ (l1 l2 : label),
    label_leb l1 (label_join l1 l2) = true ∧
    label_leb l2 (label_join l1 l2) = true := by
  intro l1 l2; cases l1 <;> cases l2 <;> simp [label_join, label_leb]

-- ====================================================================
-- Theorem: label_lattice_join_least
-- ====================================================================

/-- label_lattice_join_least (matches Coq) -/
theorem label_lattice_join_least : ∀ (l1 l2 l3 : label),
    label_leb l1 l3 = true →
    label_leb l2 l3 = true →
    label_leb (label_join l1 l2) l3 = true := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> simp [label_join, label_leb]

-- ====================================================================
-- Theorem: label_eqb_refl2
-- ====================================================================

/-- label_eqb_refl2 (matches Coq) -/
theorem label_eqb_refl2 : ∀ l, label_eqb l l = true := by
  intro l; cases l <;> rfl

-- ====================================================================
-- Theorem: label_join_comm2
-- ====================================================================

/-- label_join_comm2 (matches Coq) -/
theorem label_join_comm2 : ∀ l1 l2, label_join l1 l2 = label_join l2 l1 := by
  intro l1 l2; cases l1 <;> cases l2 <;> rfl

-- ====================================================================
-- Theorem: label_join_idem2
-- ====================================================================

/-- label_join_idem2 (matches Coq) -/
theorem label_join_idem2 : ∀ l, label_join l l = l := by
  intro l; cases l <;> rfl

end RIINA.Domains.CrossLayerSecurity
