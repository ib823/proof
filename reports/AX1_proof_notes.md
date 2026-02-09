# AX1 Proof Notes

## Target

- Symbol: `logical_relation_declassify`
- Declaration: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1149`
- Primary usage site: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4773` (`T_Declassify` case of `logical_relation`)

## What was attempted

1. Usage-site direct replacement at `T_Declassify` with explicit `ST_DeclassifyValue` steps.
2. Usage-site direct replacement with corrected substitution/declass proof and explicit existential witnesses.
3. Declaration-level conversion of AX1 from `Axiom` to `Theorem` under unchanged statement.

## Exact blocker (goal + context)

### Blocker A: original statement lacks operational preconditions

From strategy 3 (`/tmp/ax1_strategy3.log`):

- Goal required by `ST_DeclassifyValue`:
  - stepping from `(EDeclassify (subst_rho rho1 e) (subst_rho rho1 p), st1, ctx)`
- But rule requires redex shape and policy proof:
  - `(EDeclassify (EClassify v) p, st, ctx) --> (v, st, ctx)` with `declass_ok (EClassify v) p`
- Available assumptions in original statement only include:
  - `has_type Γ Σ Δ e (TSecret T) ε`
  - no `declass_ok e p`
  - no shape guarantee `e = EClassify v`

So the theorem body cannot even establish one declassify reduction step in general.

### Blocker B: payload relation at `T` is missing even after forcing redex shape

From strategy 2 (`/tmp/ax1_strategy2.log`):

- Current required goal:
  - `val_rel_n n' Σ_cur T (subst_rho rho1 v0) (subst_rho rho2 v0)`
- Available strongest relation evidence from local IH:
  - `exp_rel_n n' Σ_base (TSecret T) (subst_rho rho1 (EClassify v0)) (subst_rho rho2 (EClassify v0))`
- This only yields secret-wrapped relation; it does **not** provide underlying payload relation at type `T`.

This is the core semantic gap: declassifying `TSecret T` requires additional policy/invariant that connects released payloads across runs.

## Why each strategy failed

1. Strategy 1 failed early on substituted `declass_ok` unification; after correction this was not the fundamental blocker.
2. Strategy 2 reached the real blocker: impossible to derive `val_rel_n ... T ...` from available `TSecret`-level relation evidence.
3. Strategy 3 proved unchanged AX1 statement is too strong operationally: missing `declass_ok` / redex-shape premises.

## Minimal additional lemma/invariant needed

To complete AX1 constructively, one must add an invariant connecting declassified payloads across runs. Minimal useful form:

- For declassifiable payload `v`:
  - `val_rel Σ_base T (subst_rho rho1 v) (subst_rho rho2 v)`

without this (or an equivalent step-indexed version), `exp_rel_n ... T ...` after declassification cannot be established.

## Minimal restatement candidate (exact)

The current AX1 statement is too strong. A constructively provable variant requires both declassifiability and payload relation premises:

```coq
forall Γ Σ Δ v T ε p rho1 rho2 n Σ_base,
  has_type Γ Σ Δ v T ε ->
  p = EProve (EClassify v) ->
  store_ty_extends Σ Σ_base ->
  env_rel Σ_base Γ rho1 rho2 ->
  rho_no_free_all rho1 ->
  rho_no_free_all rho2 ->
  exp_rel_n n Σ_base T (subst_rho rho1 v) (subst_rho rho2 v) ->
  exp_rel_n n Σ_base T
    (subst_rho rho1 (EDeclassify (EClassify v) p))
    (subst_rho rho2 (EDeclassify (EClassify v) p)).
```

This is the smallest restatement that exposes the missing invariant explicitly while preserving the intended declassify operational step.

## Statement-strength verdict

- Yes: theorem statement strength is the issue.
- AX1 as currently declared cannot be eliminated constructively without strengthening premises (or weakening conclusion) to include payload relation across runs.
