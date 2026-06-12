# AX1-R Impact Matrix

| Symbol | File | Change Type | Direct Impact | Transitive Impact |
|---|---|---|---|---|
| `logical_relation_declassify` | `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1143` | `Axiom` -> proved `Theorem` with restated premises | Removes trusted axiom; requires explicit redex/value/payload premises | Used by `logical_relation` `T_Declassify` branch |
| `declass_payload_rel_assumption` | `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1188` | New helper predicate definition | Encodes minimal payload relation obligation for declassify | Threaded into section-scoped theorem interfaces |
| `logical_relation` | `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3301` | Signature generalized with leading payload-assumption parameter (section variable) | `T_Declassify` branch no longer axiomatic | Affects `non_interference_stmt` and corollaries depending on `logical_relation` |
| `non_interference_stmt` | `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:5025` | Signature generalized with same leading payload-assumption parameter | Caller must provide payload-assumption premise | Affects `security_non_interference` |
| `security_non_interference` | `02_FORMAL/coq/properties/SecurityProperties.v:21` | Added explicit payload-assumption premise | Re-export theorem now forwards parameter to `non_interference_stmt` | No further in-repo uses found |

## Signature Deltas (Concise)

1. `logical_relation_declassify`
- old: `Axiom ... has_type Γ Σ Δ e (TSecret T) ε -> store_ty_extends ... -> env_rel ... -> ...`
- new: `Theorem ... has_type Γ Σ Δ (EClassify v) (TSecret T) ε -> value v -> p = EProve (EClassify v) -> exp_rel_n ... payload -> ...`

2. `logical_relation` (compiled type)
- old: starts at `forall G Σ e T eps, ...`
- new: starts with leading premise `forall Γ Σ Σ_base rho1 rho2, declass_payload_rel_assumption Γ Σ Σ_base rho1 rho2` then previous arguments

3. `non_interference_stmt` (compiled type)
- old: starts at `forall x T_in T_out v1 v2 e, ...`
- new: same leading payload-assumption premise as `logical_relation`

4. `security_non_interference`
- old: `forall x T_in T_out v1 v2 e, ...`
- new: `forall x T_in T_out v1 v2 e, (forall Γ Σ Σ_base rho1 rho2, declass_payload_rel_assumption ...) -> ...`
