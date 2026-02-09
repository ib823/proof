# AX1-R Attempt Log

## Scope

- Target axiom: `logical_relation_declassify`
- Declaration site: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1149` (old)
- Execution mode: AX1-R (controlled restatement + elimination)
- Hard constraints respected:
  - no `Admitted`/`admit`
  - no new `Axiom`
  - no new unconstrained `Parameter`

## Preflight

- Command: `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo`
- Status: pass (`/tmp/ax1r_check_logical_relation.log`)

## Work Performed

1. Converted AX1 from `Axiom` to constructive `Theorem` with minimal explicit premises for declassification redex shape and payload relation.
2. Added helper predicate `declass_payload_rel_assumption` to encode the minimal cross-run payload obligation required by declassification.
3. Introduced a scoped assumption parameter for the logical-relation chain (`Section LogicalRelationWithDeclassPayload`) so upper proofs can thread the new obligation explicitly.
4. Replaced the `T_Declassify` branch in `logical_relation` with a constructive proof:
   - derive declassify witness from `declass_ok`
   - obtain payload relation via `Hdeclass_payload_rel`
   - discharge branch with `logical_relation_declassify`
5. Propagated signature compatibility at the top-level re-export theorem in `SecurityProperties.v`.

## Intermediate Issues and Resolutions

- Initial AX1 theorem proof used `multi_step_trans` before its local definition; replaced by direct `MS_Step` chaining.
- `match goal` branch scripting around `T_Declassify` triggered Ltac parsing instability; replaced with direct `assert` + `eapply` proof script.

## Verification

- Narrow checks (all pass):
  - `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo`
  - `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2.vo`
  - `make -C 02_FORMAL/coq -j2 properties/Declassification.vo`
  - `make -C 02_FORMAL/coq -j2 properties/SecurityProperties.vo`
- Full build:
  - `make -C 02_FORMAL/coq -j2`
  - status: fail (unrelated baseline failure at `02_FORMAL/coq/effects/EffectGate.v:97`)

## Outcome

- AX1 eliminated as an axiom.
- AX1 is now a proved theorem under explicit minimal premises.
- Cone-local required checks pass.
