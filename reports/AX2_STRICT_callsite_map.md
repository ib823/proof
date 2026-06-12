# AX2 STRICT Callsite Map (`val_rel_n_step_up`)

## Axiom Declaration

- `02_FORMAL/coq/properties/NonInterference_v2.v:1535`
  - `Axiom val_rel_n_step_up : forall n Σ T v1 v2, ...`

## Callsite Clusters

### Cluster C1: Store-relation lifting in base module

- `02_FORMAL/coq/properties/NonInterference_v2.v:1587`
  - In `store_rel_n_step_up`
  - Local goal shape: lift low-security cell relation from `val_rel_n n'` to `val_rel_n (S n')` under typing extracted from store well-formedness.
- `02_FORMAL/coq/properties/NonInterference_v2.v:1605`
  - In `store_vals_rel_step_up`
  - Local goal shape: pointwise store-values lifting `val_rel_n n` -> `val_rel_n (S n)`.

### Cluster C2: Converting finite-step relation to limit relation

- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1213`
  - In `val_rel_n_to_val_rel`
  - Local goal shape: inductive `m -> S m` lift while building `forall m, val_rel_n m ...`.
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1229`
  - In `val_rel_n_to_val_rel_any`
  - Local goal shape: bootstrap from `n=0` to `n=1` before applying limit conversion.

### Cluster C3: Product/sum projection and extraction helpers

- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2332`
  - `val_rel_n_prod_fst`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2372`
  - `val_rel_n_prod_snd`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2559`
  - `val_rel_n_from_prod_fst`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2633`
  - `val_rel_n_from_prod_snd`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2834`
  - `val_rel_n_from_sum_inl`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2887`
  - `val_rel_n_from_sum_inr`
- Local goal shape: force `val_rel_n (S n)` / `val_rel_n (S (S n))` to expose `val_rel_at_type` structure needed for decomposition.

### Cluster C4: Fundamental theorem (`logical_relation`) and mutual step-up wrapper

- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3198`
  - `step_up_at_0`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3502`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3503`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3529`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3659`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3661`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3707`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3709`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3802`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3804`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3917`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4633`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4635`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4693`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4695`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4951`
- Local goal shape: synchronize step indices in TFn/TProd/TSum/TRef cases and prove `step_up_at n` branch of `step_up_and_fundamental_mutual`.

### Cluster C5: External step-limit helper file

- `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:73`
  - In `val_rel_n_step_up_k`
  - Local goal shape: repeated `k`-step lifting for higher-order types.
- `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:95`
  - `val_rel_n_to_val_rel_with_typing` depends on `val_rel_n_step_up_k`.

## Pattern Summary

1. `IndexLift`: direct `val_rel_n n` -> `val_rel_n (S n)`.
2. `ExposeStructure`: double-lift to `S (S n)` so `val_rel_at_type_n (S n)` becomes concrete `val_rel_at_type`.
3. `StoreTransport`: lift value-level relation to store-level relations.
4. `LimitClosure`: repeated lifting to establish `forall m` relation.
