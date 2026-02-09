# Final 2 Target Axioms

## Selection Basis

Active `_CoqProject` files contain exactly two live `Axiom` declarations:

1. `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1149` (`logical_relation_declassify`)
2. `02_FORMAL/coq/properties/NonInterference_v2.v:1535` (`val_rel_n_step_up`)

No active `_CoqProject` file contains `Admitted.` or tactic `admit.`.

---

## AX1 — `logical_relation_declassify`

### 1) Declaration / import source

- Declaration: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1149`
- Imported transitively by:
  - `02_FORMAL/coq/properties/SecurityProperties.v:12`
  - `02_FORMAL/coq/properties/Composition.v:14`
  - `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:29`

### 2) Direct dependents (theorem-level)

- `logical_relation` — declaration `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3253`, direct axiom use at `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4773`

### 3) Transitive high-value dependents

- `step_up_and_fundamental_mutual` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4883`
- `val_rel_n_step_up_proven` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4906`
- `fundamental_at_all_steps` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4918`
- `non_interference_stmt` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4965`
- `security_non_interference` — `02_FORMAL/coq/properties/SecurityProperties.v:21`

### 4) Dependency depth + minimal proof cone files

- File-level reverse dependency depth from decl file:
  - depth 1: `02_FORMAL/coq/properties/SecurityProperties.v`, `02_FORMAL/coq/properties/Composition.v`, `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v`
- Theorem-level dependency depth to top guarantee: up to 2 hops (`logical_relation` -> `non_interference_stmt` -> `security_non_interference`)
- Minimal elimination cone files:
  - `02_FORMAL/coq/properties/NonInterference_v2.v`
  - `02_FORMAL/coq/properties/NonInterference_v2_Monotone.v`
  - `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v`
  - `02_FORMAL/coq/properties/Declassification.v`
  - `02_FORMAL/coq/properties/SecurityProperties.v`

### 5) Probable blocker type

- `theorem too strong`
- Evidence: file commentary at `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1141-1148` states declassification intentionally breaks full noninterference and treats this as policy responsibility.

### Minimal reproducible context (ordered)

1. `02_FORMAL/coq/properties/Declassification.v:95` — `declassify_eval`
2. `02_FORMAL/coq/properties/Declassification.v:130` — `logical_relation_declassify_proven`
3. `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3253` — `logical_relation`
4. `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4965` — `non_interference_stmt`
5. `02_FORMAL/coq/properties/SecurityProperties.v:21` — `security_non_interference`

---

## AX2 — `val_rel_n_step_up`

### 1) Declaration / import source

- Declaration: `02_FORMAL/coq/properties/NonInterference_v2.v:1535`
- Imported/transitively consumed by:
  - `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:14`
  - `02_FORMAL/coq/properties/NonInterference_v2_Monotone.v:21`
  - `02_FORMAL/coq/properties/Composition.v:13`
  - `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:28`

### 2) Direct dependents (theorem-level)

- `store_rel_n_step_up` — `02_FORMAL/coq/properties/NonInterference_v2.v:1542` (use at `:1587`)
- `store_vals_rel_step_up` — `02_FORMAL/coq/properties/NonInterference_v2.v:1596` (use at `:1605`)
- `val_rel_n_to_val_rel` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1161` (use at `:1171`)
- `val_rel_n_to_val_rel_any` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1177` (use at `:1187`)
- `val_rel_n_prod_fst` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2279` (use at `:2290`)
- `val_rel_n_prod_snd` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2319` (use at `:2330`)
- `val_rel_n_from_prod_fst` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2507` (use at `:2517`)
- `val_rel_n_from_prod_snd` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2581` (use at `:2591`)
- `val_rel_n_from_sum_inl` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2783` (use at `:2792`)
- `val_rel_n_from_sum_inr` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:2836` (use at `:2845`)
- `step_up_at_0` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3153` (use at `:3156`)
- `logical_relation` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3253` (uses at `:3454`, `:3455`, `:3481`, `:3611`, `:3613`, `:3659`, `:3661`, `:3754`, `:3756`, `:3869`, `:4585`, `:4587`, `:4645`, `:4647`)
- `step_up_and_fundamental_mutual` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4883` (use at `:4891`)
- `val_rel_n_step_up_k` — `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:58` (use at `:73`)

### 3) Transitive high-value dependents

- `non_interference_stmt` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4965`
- `security_non_interference` — `02_FORMAL/coq/properties/SecurityProperties.v:21`
- `val_rel_n_step_up_proven` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4906`
- `fundamental_at_all_steps` — `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4918`
- `val_rel_n_to_val_rel_with_typing` — `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:80`
- `val_rel_n_to_val_rel_proven` — `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:157`

### 4) Dependency depth + minimal proof cone files

- File-level reverse dependency depth from decl file:
  - depth 1: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v`, `02_FORMAL/coq/properties/NonInterference_v2_Monotone.v`, `02_FORMAL/coq/properties/Composition.v`, `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v`
  - depth 2: `02_FORMAL/coq/properties/SecurityProperties.v`
- Theorem-level dependency depth to top guarantee: up to 2 hops (`val_rel_n_step_up` -> `logical_relation` -> `non_interference_stmt` -> `security_non_interference`)
- Minimal elimination cone files:
  - `02_FORMAL/coq/properties/NonInterference_v2.v`
  - `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v`
  - `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v`
  - `02_FORMAL/coq/properties/AhmedStyleTest.v`
  - `02_FORMAL/coq/properties/SecurityProperties.v`

### 5) Probable blocker type

- `theorem too strong`
- Evidence: file commentary at `02_FORMAL/coq/properties/NonInterference_v2.v:1500-1516` states global step-up is not valid for current higher-order `val_rel_n` definition and points to Ahmed-style re-architecture.

### Minimal reproducible context (ordered)

1. `02_FORMAL/coq/properties/NonInterference_v2.v:642` — `val_rel_n_step_up_fo`
2. `02_FORMAL/coq/properties/NonInterference_v2.v:1535` — `val_rel_n_step_up` (target)
3. `02_FORMAL/coq/properties/NonInterference_v2.v:1542` — `store_rel_n_step_up`
4. `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1161` — `val_rel_n_to_val_rel`
5. `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3253` — `logical_relation`
6. `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4883` — `step_up_and_fundamental_mutual`
7. `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:58` — `val_rel_n_step_up_k`
8. `02_FORMAL/coq/properties/SecurityProperties.v:21` — `security_non_interference`
