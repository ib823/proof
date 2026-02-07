# RIINA Axiom Elimination Plan

**Date:** 2026-02-07
**Current axiom count:** 4
**Target axiom count:** 1 (only the intentional policy axiom)
**Location:** All in `02_FORMAL/coq/properties/`

---

## Axiom Inventory

| # | Name | File | Line | Eliminable | Priority |
|---|------|------|------|------------|----------|
| 1 | `fundamental_theorem_step_0` | NonInterference_v2.v | 1015 | YES | P1 |
| 2 | `logical_relation_ref` | NonInterference_v2_LogicalRelation.v | 782 | YES | P2 |
| 3 | `logical_relation_assign` | NonInterference_v2_LogicalRelation.v | 800 | YES | P2 |
| 4 | `logical_relation_declassify` | NonInterference_v2_LogicalRelation.v | 817 | NO (by design) | N/A |

---

## Axiom 1: `fundamental_theorem_step_0`

### Statement

```coq
Axiom fundamental_theorem_step_0 : forall T Σ v1 v2,
  first_order_type T = false ->
  val_rel_n 0 Σ T v1 v2 ->
  has_type nil Σ Public v1 T EffectPure ->
  has_type nil Σ Public v2 T EffectPure ->
  val_rel_at_type Σ (store_rel_n 0) (val_rel_n 0)
    (store_rel_n 0) (store_vals_rel 0) T v1 v2.
```

### Why It Exists

At step index 0 for higher-order types, `val_rel_n 0` only guarantees typing (returns `True`
for non-first-order types). But `val_rel_at_type` requires structural content — for `TFn T1 T2`,
it requires that applying both functions to related arguments yields related results. Since
`val_rel_n 0` doesn't track this, the axiom bridges the gap.

### Elimination Strategy

**Option A (Recommended): Make step 0 purely typing-based for all types**

Redefine `val_rel_n 0 Σ T v1 v2` to return `True` for ALL types at step 0, not just
higher-order types. This removes the asymmetry that forces the axiom. The trade-off is that
every step-up lemma must handle the `n=0` case as a trivial base case.

Estimated effort: 200-400 lines of proof changes across `val_rel_n_step_up` and the
fundamental theorem's application case.

**Option B: Adopt biorthogonal step-indexing**

Switch to the biorthogonal/CPS-style step-indexed logical relation (Dreyer et al. LICS 2010,
"State-Dependent Representation Independence"). In this formulation, the step count decreases
on elimination forms rather than observation forms, which naturally avoids the step-0 issue.

Estimated effort: ~2000 lines — essentially rewriting the logical relation from scratch.
Not recommended unless a deeper restructuring is already planned.

### Dependencies

- `val_rel_n_step_up` (line ~1805): Uses this axiom for the `n=0, first_order_type = false` case
- Fundamental theorem `T_App` case (LogicalRelation.v ~line 3100): Depends transitively

---

## Axiom 2: `logical_relation_ref`

### Statement

```coq
Axiom logical_relation_ref : forall Γ Σ Δ e T l ε rho1 rho2 n Σ_base,
  has_type Γ Σ Δ e T ε ->
  store_ty_extends Σ Σ_base ->
  env_rel Σ_base Γ rho1 rho2 ->
  rho_no_free_all rho1 -> rho_no_free_all rho2 ->
  exp_rel_n n Σ_base (TRef T l)
    (subst_rho rho1 (ERef e l)) (subst_rho rho2 (ERef e l)).
```

### Why It Exists

The fundamental theorem case for `T_Ref` (reference allocation) needs to show that allocating
a reference with related values produces related references. The induction hypothesis gives
`val_rel_n` for the stored value. For LOW references, `store_rel_n` tracks the value relation.
For HIGH references, `store_rel_n` only tracks typing (by design for IFC — high locations
may differ between runs). A full proof requires strengthening `store_rel_n` to maintain
`val_rel` for ALL locations, or carrying an auxiliary invariant.

### Elimination Strategy

**Strengthen `store_rel_n` (Recommended)**

Redefine `store_rel_n` to track `val_rel_n` for all locations, not just low-security ones.
For high-security locations, the current definition only checks well-typedness. The strengthened
version would check:
- Low locations: `val_rel_n n Σ T v1 v2` (same as now)
- High locations: `val_rel_n n Σ T v1 v2` (strengthened — currently only checks typing)

This is semantically sound because the logical relation is always applied to the same program
under different environments. High-security allocations in the same program with related
environments will always produce related values.

**Impact:** This change also eliminates Axiom 3 (same root cause). Both `T_Ref` and `T_Assign`
cases would become provable with the strengthened `store_rel_n`.

Estimated effort: 500-800 lines. The main work is updating all `store_rel_n` lemmas to handle
the strengthened invariant. Key lemmas affected:
- `store_rel_n_update` (existing)
- `store_rel_n_fresh` (existing)
- `store_rel_n_mono` (existing)
- New: `store_rel_n_ref` and `store_rel_n_assign` proof obligations

---

## Axiom 3: `logical_relation_assign`

### Statement

```coq
Axiom logical_relation_assign : forall Γ Σ Δ e1 e2 T l ε1 ε2 rho1 rho2 n Σ_base,
  has_type Γ Σ Δ e1 (TRef T l) ε1 ->
  has_type Γ Σ Δ e2 T ε2 ->
  store_ty_extends Σ Σ_base ->
  env_rel Σ_base Γ rho1 rho2 ->
  rho_no_free_all rho1 -> rho_no_free_all rho2 ->
  exp_rel_n n Σ_base TUnit
    (subst_rho rho1 (EAssign e1 e2)) (subst_rho rho2 (EAssign e1 e2)).
```

### Why It Exists

Same root cause as Axiom 2. Assignment to a reference with related values should produce
related stores. The `store_rel_n` definition doesn't track value relations for high-security
locations, so the proof cannot close the `T_Assign` case.

### Elimination Strategy

**Same fix as Axiom 2.** Strengthening `store_rel_n` eliminates both axioms simultaneously.

---

## Axiom 4: `logical_relation_declassify` (PERMANENT)

### Statement

```coq
Axiom logical_relation_declassify : forall Γ Σ Δ e T ε p rho1 rho2 n Σ_base,
  has_type Γ Σ Δ e (TSecret T) ε ->
  store_ty_extends Σ Σ_base ->
  env_rel Σ_base Γ rho1 rho2 ->
  rho_no_free_all rho1 -> rho_no_free_all rho2 ->
  exp_rel_n n Σ_base T
    (subst_rho rho1 (EDeclassify e p)) (subst_rho rho2 (EDeclassify e p)).
```

### Why It Is Permanent

This axiom is **unprovable by design**. Declassification intentionally breaks noninterference.
When `e : TSecret T` is declassified, it may evaluate to `EClassify w1` and `EClassify w2`
where `w1 ≠ w2` (secret values differ between runs). The result after declassification
exposes the secret, so `val_rel` at `T` for `w1` and `w2` is not guaranteed.

This axiom encodes the **programmer's declassification responsibility**: by using `dedah()`
(RIINA's declassification keyword), the programmer asserts that revealing this secret value
is safe. This is a fundamental aspect of any IFC system with declassification — see:

- Myers & Liskov, "Protecting Privacy using the Decentralized Label Model" (2000)
- Sabelfeld & Myers, "Language-Based Information-Flow Security" (2003)
- Askarov & Sabelfeld, "Gradual Release" (2007)

**This axiom will not be eliminated.** It is a justified policy axiom.

---

## Elimination Roadmap

| Phase | Work | Axioms Eliminated | Lines | Dependencies |
|-------|------|-------------------|-------|-------------|
| Phase 1 | Strengthen `store_rel_n` to track `val_rel_n` for all locations | #2 (`ref`), #3 (`assign`) | ~600 | None |
| Phase 2 | Redefine `val_rel_n 0` to be purely typing-based for all types | #1 (`step_0`) | ~400 | Phase 1 recommended first |
| Final | Axiom #4 remains as permanent policy axiom | — | 0 | N/A |

### Post-Elimination State

After completing Phases 1 and 2:
- **Axioms: 1** (down from 4)
- **The remaining axiom** (`logical_relation_declassify`) is a justified policy axiom that
  encodes the intentional trust boundary of declassification. It is standard in IFC literature
  and cannot be eliminated without removing declassification support.
- **Non-interference theorem** becomes fully proved modulo the declassification trust assumption,
  which is exactly the standard formulation.

### References

1. Appel & McAllester, "An Indexed Model of Recursive Types for Foundational Proof-Carrying Code" (2001)
2. Ahmed, "Step-Indexed Syntactic Logical Relations for Recursive and Quantified Types" (2006)
3. Dreyer, Neis, Birkedal, "The Impact of Higher-Order State and Control Effects on Local Relational Reasoning" (LICS 2010)
4. Sabelfeld & Myers, "Language-Based Information-Flow Security" (2003)

---

*Document created: 2026-02-07*
