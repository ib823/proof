# Elimination Plan (No Source Edits)

## Recommended Order

1. `AX1` (`logical_relation_declassify`) — narrowest direct proof cutpoint (single `T_Declassify` branch in `logical_relation`).
2. `AX2` (`val_rel_n_step_up`) — broad architectural dependency across FT and step-index infrastructure.

---

## AX1 Plan — `logical_relation_declassify`

- Target declaration: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1149`
- Main callsite: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4773`

### Candidate helper lemmas (statement sketches)

1. `declassify_subst_rho_comm`
- Sketch: for closed substitutions, `subst_rho rho (EDeclassify e p)` preserves declassify shape and keeps policy side-condition accessible.

2. `declassify_eval_related_configs`
- Sketch: if substituted secret terms evaluate to `EClassify v1` and `EClassify v2` from related stores, then declassified terms evaluate to `v1`/`v2` with store relation preserved.

3. `exp_rel_declassify_from_secret_rel`
- Sketch: from `exp_rel_n n Σ (TSecret T) (subst_rho rho1 e) (subst_rho rho2 e)` plus typing/policy premises, derive `exp_rel_n n Σ T (subst_rho rho1 (EDeclassify e p)) (subst_rho rho2 (EDeclassify e p))`.

4. `declassify_case_in_fundamental`
- Sketch: a local lemma specialized to the `T_Declassify` branch of `logical_relation` removing direct axiom invocation.

### Likely proof method

- Dependent inversion on `T_Declassify` typing.
- Rewriting over `subst_rho` and `multi_step` constructors.
- Use determinism lemmas already in `Declassification.v` (`declassify_eval`, `eval_deterministic`).
- Build branch-local proof term and plug into `logical_relation` case split.

### Risk

- `high`

### Expected impact radius

- `medium`: localized edit point in `logical_relation`, but affects downstream `non_interference_stmt` and `security_non_interference` proof chain.

---

## AX2 Plan — `val_rel_n_step_up`

- Target declaration: `02_FORMAL/coq/properties/NonInterference_v2.v:1535`
- Architectural warning block: `02_FORMAL/coq/properties/NonInterference_v2.v:1500-1516`

### Candidate helper lemmas (statement sketches)

1. `val_rel_n_step_up_on_ft_image`
- Sketch: step-up holds for values obtained from the fundamental theorem image (typed, closed, evaluation-origin values), not arbitrary `TFn` pairs.

2. `fundamental_mutual_Sk_body`
- Sketch: for lambda case at step `S k`, body IH directly yields the `TFn`-required `exp_rel_n (S k)` obligations without global step-up.

3. `val_rel_n_fun_kripke_direct`
- Sketch: function-case monotonic behavior follows from Kripke quantification over smaller indices (`j < n`) via Ahmed-style recursion, bypassing `n -> S n` lift.

4. `store_rel_step_up_from_ft_witnesses`
- Sketch: derive the specific store/value step-lift obligations used in FT branches from produced witnesses, replacing global `store_rel_n_step_up` dependence.

### Likely proof method

- Well-founded (index-first) or mutually recursive induction in Ahmed-style (as hinted in `AhmedStyleTest.v`).
- Refactor `logical_relation` lambda/app/match branches to consume IH at `S k` with smaller subderivations.
- Replace global monotonic lift calls with branch-local derivations and `val_rel_n_mono` (downward) where admissible.

### Risk

- `high`

### Expected impact radius

- `high`: touches `NonInterference_v2.v`, `NonInterference_v2_LogicalRelation.v`, and `ValRelStepLimit_PROOF.v`; impacts all top-level noninterference guarantees.
