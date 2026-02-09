# AX1 Attempt Log

## Scope and constraints

- Target: `logical_relation_declassify`
- Decl site: `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1149`
- Hard constraints enforced during attempts:
  - no `Admitted`/`admit`
  - no new `Axiom`
  - no new unconstrained `Parameter`
  - edits restricted to AX1 cone files (only temporary edits in `NonInterference_v2_LogicalRelation.v`, then fully reverted)

## Preflight

- Baseline narrow target build command:
  - `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo`
- Result: `pass` (see `/tmp/ax1_narrow_target.log`)

## Strategy 1 (usage-site direct proof, first pass)

- Edit: replaced `T_Declassify` branch call to `logical_relation_declassify` with a constructive branch skeleton.
- Check:
  - `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo`
  - status: `fail`
- Failure point:
  - `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4787`
- Core error:
  - unification failure while establishing substituted `declass_ok` witness shape.
- Log: `/tmp/ax1_strategy1.log`

## Strategy 2 (usage-site direct proof, corrected declassify stepping)

- Edit: corrected declassify-step construction (`ST_DeclassifyValue`) and pushed proof to payload relation obligation.
- Check:
  - `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo`
  - status: `fail`
- Failure point:
  - `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4805`
- Core blocker:
  - required goal: `val_rel_n n' Σ_cur T (subst_rho rho1 v0) (subst_rho rho2 v0)`
  - available IH gives only: `exp_rel_n n' Σ_base (TSecret T) (subst_rho rho1 (EClassify v0)) (subst_rho rho2 (EClassify v0))`
  - mismatch is fundamental (secret-wrapped relation does not provide underlying `T` payload relation).
- Log: `/tmp/ax1_strategy2.log`

## Strategy 3 (declaration-level theorem conversion under original statement)

- Edit: converted AX1 declaration from `Axiom` to `Theorem` with explicit proof attempt under unchanged statement.
- Check:
  - `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo`
  - status: `fail`
- Failure point:
  - `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1166`
- Core blocker:
  - cannot apply `ST_DeclassifyValue` because the original theorem statement does not provide `declass_ok e p` or even redex shape `e = EClassify v`.
- Log: `/tmp/ax1_strategy3.log`

## Restore and validation

- Restored `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v` byte-identical to backup.
- Restore check:
  - `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo`
  - status: `pass` (see `/tmp/ax1_restore_check.log`)

## Conclusion

- AX1 elimination is **blocked** under unchanged obligation shape.
- No source changes retained.
- Blocker details and minimal restatement candidate are documented in `reports/AX1_proof_notes.md`.
