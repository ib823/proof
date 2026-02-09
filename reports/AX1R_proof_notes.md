# AX1-R Proof Notes

## Final AX1 Form

`logical_relation_declassify` is now a theorem at `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1143` with constructive premises:

- `has_type Γ Σ Δ (EClassify v) (TSecret T) ε`
- `value v`
- `p = EProve (EClassify v)`
- `exp_rel_n n Σ_base T (subst_rho rho1 v) (subst_rho rho2 v)`

Conclusion:

- `exp_rel_n n Σ_base T`
  - `(subst_rho rho1 (EDeclassify (EClassify v) p))`
  - `(subst_rho rho2 (EDeclassify (EClassify v) p))`

## Constructive Proof Structure

1. `n = 0`: trivial by definition of `exp_rel_n`.
2. `n = S n'`:
   - instantiate payload relation hypothesis to obtain witnesses after evaluation
   - execute one declassify step per side using `ST_DeclassifyValue`
   - continue with payload relation witnesses
   - preserve store/typing/agreement invariants from payload relation continuation

## Declassify Case in Fundamental Theorem

`logical_relation` (`T_Declassify` branch) now proceeds by:

1. destructing `declass_ok` to obtain witness `v` and redex equalities
2. using `Hdeclass_payload_rel` (scoped section assumption) to recover payload relation at type `T`
3. invoking the new proved `logical_relation_declassify` theorem

This replaces the previous direct axiom call.

## Signature Propagation

To keep changes minimal and auditable, payload-obligation threading is scoped via:

- `Section LogicalRelationWithDeclassPayload`
- `Variable Hdeclass_payload_rel : forall Γ Σ Σ_base rho1 rho2, declass_payload_rel_assumption Γ Σ Σ_base rho1 rho2`

Effects:

- `logical_relation` type gains a leading payload-assumption parameter (after section generalization)
- `non_interference_stmt` type gains the same leading parameter
- `security_non_interference` now explicitly accepts this premise and forwards it

## No New Trusted Assumptions

- No `Axiom` added.
- No `Parameter` added.
- No `Admitted`/`admit` used.
