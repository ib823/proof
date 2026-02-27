# PROMPT: Prove Type Preservation and Eliminate 3 Remaining Sorry

## Goal
Prove the type preservation theorem in Lean 4, then use it to eliminate the 3 remaining `sorry` in the codebase.

## Working Directory
```
cd /workspaces/proof/02_FORMAL/lean
```

## Build Command
```bash
PATH="$HOME/.elan/bin:$PATH" lake build RIINA
```

## Current State
- `lake build RIINA` passes with 1 sorry warning (NI_v2)
- 3 sorry remain across 2 files:
  - `RIINA/Properties/NonInterference_v2.lean:741` — `val_rel_at_type_TFn_step_0_bridge`
  - `RIINA/Properties/NonInterference_v2_LogicalRelation.lean:2075` — `multi_step_preservation_aux`
  - `RIINA/Properties/NonInterference_v2_LogicalRelation.lean:2078` — `multi_step_preservation`
- All 3 require **type preservation** (subject reduction) which doesn't exist yet

## Blueprint
The Coq proof is in `02_FORMAL/coq/type_system/Preservation.v` (1,316 lines, fully proven).
Use it as a structural guide for the Lean 4 port.

## PHASE 1: Fix and Build Preservation.lean

The file `RIINA/TypeSystem/Preservation.lean` exists but is completely broken:
- Lines 65, 109, 113: theorem names are numbers (`theorem 1`, `theorem 2`, `theorem 3`) with prose in them
- Line 127: `-->` notation gets parsed as line comment (`--`)
- Line 131: `preservation_stmt` is undefined
- All proofs are `simp_all` or `rfl` stubs
- Coq shims conflict with other modules (remove them all)

**Rewrite this file from scratch.** It should contain:

### 1a. `free_in_context`
```
theorem free_in_context : ∀ x e Γ St Δ T ε,
    free_in x e → has_type Γ St Δ e T ε → ∃ T', lookup x Γ = some T'
```
Proof: induction on `e`, using inversion lemmas from TypingInversion.lean.

### 1b. `context_invariance`
```
theorem context_invariance : ∀ Γ1 Γ2 St Δ e T ε,
    has_type Γ1 St Δ e T ε →
    (∀ x, free_in x e → lookup x Γ1 = lookup x Γ2) →
    has_type Γ2 St Δ e T ε
```
Proof: induction on has_type derivation.

### 1c. `closed_typing_weakening`
```
theorem closed_typing_weakening : ∀ St Δ v T ε Γ,
    has_type [] St Δ v T ε → has_type Γ St Δ v T ε
```
Proof: use context_invariance. In empty context, no free variables, so any Γ works.

### 1d. `substitution_preserves_typing` (THE KEY LEMMA)
```
theorem substitution_preserves_typing : ∀ Γ St Δ z v e T1 T2 ε2,
    value v → has_type [] St Δ v T1 EffPure →
    has_type ((z, T1) :: Γ) St Δ e T2 ε2 →
    has_type Γ St Δ ([z := v] e) T2 ε2
```
Proof: induction on has_type derivation of `e`. Key cases:
- **T_Var**: If var is `z`, substitute; if not, it's still in Γ
- **T_Lam**: If binder shadows `z`, no substitution; otherwise recurse
- **T_App, T_Pair, etc.**: Recurse into subexpressions
- Use `closed_typing_weakening` for the substituted value

### 1e. `preservation` (single-step)
```
theorem preservation : ∀ e e' T ε st st' ctx ctx' St,
    has_type [] St LPublic e T ε → store_wf St st →
    (e, st, ctx) -→ (e', st', ctx') →
    ∃ St' ε', store_ty_extends St St' ∧ store_wf St' st' ∧
              has_type [] St' LPublic e' T ε'
```
Proof: cases on the step relation. Key cases:
- **ST_AppAbs**: `(EApp (ELam x T1 e) v, st, ctx) → ([x := v] e, st, ctx)` — use substitution_preserves_typing
- **ST_App1/ST_App2**: Congruence — recurse with IH
- **ST_Ref**: Allocate new location — extend store typing
- **ST_Deref**: Lookup in store — use store_wf
- **ST_Assign**: Update store — use store_wf_update
- All other congruence rules: similar pattern

### 1f. `multi_step_preservation`
```
theorem multi_step_preservation : ∀ e e' T ε st st' ctx ctx' St,
    has_type [] St LPublic e T ε → store_wf St st →
    (e, st, ctx) -→* (e', st', ctx') →
    ∃ St' ε', store_ty_extends St St' ∧ store_wf St' st' ∧
              has_type [] St' LPublic e' T ε'
```
Proof: induction on multi_step. Base case: reflexivity. Step case: apply single-step preservation, then IH.

## PHASE 2: Eliminate Sorry #7 and #8

After Phase 1, `multi_step_preservation` exists in Preservation.lean.

### Sorry #7: `multi_step_preservation_aux` (NI_v2_LogicalRelation.lean:2075)
```lean
theorem multi_step_preservation_aux : ∀ cfg1 cfg2,
    cfg1 -→* cfg2 → ∀ St e st ctx T ε,
    cfg1 = (e, st, ctx) → has_type nil St Public e T ε → store_wf St st →
    ∃ e' st' ctx' St' ε', cfg2 = (e', st', ctx') ∧
    store_ty_extends St St' ∧ store_wf St' st' ∧ has_type nil St' Public e' T ε'
```
This is equivalent to multi_step_preservation. Replace `sorry` with:
```lean
  intro cfg1 cfg2 hstep St e st ctx T ε heq htype hwf
  subst heq
  obtain ⟨St', ε', hext, hwf', htype'⟩ := multi_step_preservation e ... htype hwf hstep
  -- destructure cfg2 and provide witnesses
```

### Sorry #8: `multi_step_preservation` (NI_v2_LogicalRelation.lean:2078)
```lean
theorem multi_step_preservation : ∀ e e' T ε st st' ctx ctx' St,
    has_type nil St Public e T ε → store_wf St st →
    (e, st, ctx) -→* (e', st', ctx') →
    ∃ St' ε', store_ty_extends St St' ∧ store_wf St' st' ∧ has_type nil St' Public e' T ε'
```
Direct wrapper — call `multi_step_preservation_aux` or the Preservation.lean version.

**NOTE**: There may be a name clash between the `multi_step_preservation` in Preservation.lean and the one in NI_v2_LogicalRelation.lean. Resolve by either:
- Using `import` + qualified names
- Defining a different name in Preservation.lean (e.g., `preservation_multi_step`)

## PHASE 3: Eliminate Sorry #6

### Sorry #6: `val_rel_at_type_TFn_step_0_bridge` (NI_v2.lean:741)

This states: if v1, v2 are typed function values and x, y are related arguments,
then applying v1 to x and v2 to y produces related results.

The proof requires:
1. Since v1 : TFn T1 T2 ε and `value v1`, by canonical_forms_fn, `v1 = ELam x1 T1 body1`
2. `EApp v1 x` steps to `[x1 := x] body1` by ST_AppAbs
3. By preservation, `[x1 := x] body1 : T2`
4. Similarly for v2/y
5. The step results are related at step 0

This may still be hard because the value relation at step 0 for T2 might require more work.
If T2 is first-order (fo_type_has_trivial_rel returns true), the relation is trivial.
Otherwise, step 0 makes the relation vacuously true for function types.

Try this approach:
```lean
  -- Get canonical forms
  have ⟨x1, _, body1, hv1eq⟩ := canonical_forms_fn hval1 htype1
  have ⟨x2, _, body2, hv2eq⟩ := canonical_forms_fn hval2 htype2
  subst hv1eq; subst hv2eq
  -- Step: EApp (ELam ...) arg →* [x := arg] body
  -- Use multi_step to get typed results
  -- Use val_rel_n 0 which is trivially satisfied for most types
```

## Available Infrastructure

These are proven and importable:

| Module | Key Theorems |
|--------|-------------|
| `TypingInversion` | `inversion_app`, `inversion_lam`, all 20 inversion lemmas, `type_unique`, `effect_unique` |
| `StoreWfLemmas` | `store_wf_lookup_value`, `store_wf_typed_loc_gives_typed_value`, `store_wf_forward`, `store_wf_backward` |
| `StoreSafety` | `store_lookup_after_update`, `store_ty_update_same`, `store_ty_extends_reflexive`, `typing_monotone_store` |
| `Typing` | `has_type_store_weaken`, `canonical_forms_fn`, `canonical_forms_unit`, etc. |
| `Syntax` | `substExpr` (`[x := v] e`), `free_in`, `effect_join`, `value` |
| `Semantics` | `step` (`-→`), `multi_step` (`-→*`), `store_lookup`, `store_update` |

## Key Definitions Reference

### substExpr (Syntax.lean:344)
```lean
def substExpr (x : ident) (v : expr) : expr → expr
  | EVar y => if x = y then v else EVar y
  | ELam y T e => if x = y then ELam y T e else ELam y T (substExpr x v e)
  | EApp e1 e2 => EApp (substExpr x v e1) (substExpr x v e2)
  | ... -- recurses into all subexpressions except binders
```

### free_in (Syntax.lean:380)
```lean
def free_in (x : ident) (e : expr) : Prop :=
  match e with
  | EVar y => x = y
  | ELam y _ body => x ≠ y ∧ free_in x body
  | EApp e1 e2 => free_in x e1 ∨ free_in x e2
  | ... -- similar for all constructors
```

### step relation (Semantics.lean)
Key constructors: ST_AppAbs, ST_App1, ST_App2, ST_FstPair, ST_SndPair,
ST_CaseInl, ST_CaseInr, ST_IfTrue, ST_IfFalse, ST_LetVal,
ST_Ref, ST_DerefLoc, ST_Assign, etc.

### has_type constructors (Typing.lean:132-250)
28 constructors: T_Unit, T_Bool, T_Int, T_String, T_Loc, T_Var,
T_Lam, T_App, T_Pair, T_Fst, T_Snd, T_Inl, T_Inr, T_Case,
T_If, T_Let, T_Perform, T_Handle, T_Ref, T_Deref, T_Assign,
T_Classify, T_Declassify, T_Prove, T_Require, T_Grant

## Rules
1. NEVER use `sorry` — comment out theorems you can't prove
2. Commit format: `[TRACK_A] PROOF: description`
3. All work on `main` branch
4. Remove Coq compatibility shims from any file you touch (they conflict)
5. Verify `lake build RIINA` passes after each phase
6. The notation `-→` is `step` and `-→*` is `multi_step` (defined in Semantics.lean)
7. `Public` = `LPublic`, `EffectPure` = `EffPure`
8. `nil` = `[]` for empty lists
9. `lookup` = `type_env_lookup` (abbrev)
