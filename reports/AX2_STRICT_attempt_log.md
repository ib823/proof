# AX2-STRICT Attempt Log

## Scope

- Target axiom: `val_rel_n_step_up`
- Decl site: `02_FORMAL/coq/properties/NonInterference_v2.v:1535`
- Constraints enforced:
  - no `Admitted`/`admit`
  - no new `Axiom`
  - no new unconstrained `Parameter`
  - no additional public theorem premise additions

## Preflight (required commands)

1. `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2.vo` -> pass (`/tmp/ax2_preflight_nonintv2.log`)
2. `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo` -> pass (`/tmp/ax2_preflight_logrel.log`)
3. `make -C 02_FORMAL/coq -j2 properties/ValRelStepLimit_PROOF.vo` -> pass (`/tmp/ax2_preflight_valrelstep.log`)
4. `make -C 02_FORMAL/coq -j2 properties/SecurityProperties.vo` -> pass (`/tmp/ax2_preflight_securityprops.log`)

## Strategy 1 (direct structural proof of AX2)

- Edit: replaced AX2 axiom with theorem and attempted direct proof by unfolding `val_rel_n` and inducting on `n`.
- Result: fail.
- Compile command: `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2.vo`
- Log: `/tmp/ax2_strategy1.log`
- Failing point:
  - file: `02_FORMAL/coq/properties/NonInterference_v2.v:1553`
  - context includes `Hrat : True` from `val_rel_n 1` payload
  - required goal is `val_rel_at_type_n 1 ...`

## Strategy 2 (FO/HO split at critical branch)

- Edit: in critical `n = 1 -> 2` branch, split on `first_order_type T`; solved FO side via `val_rel_at_type_fo_equiv` and `val_rel_n_0_unfold` extraction.
- Result: fail on non-FO branch.
- Compile command: `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2.vo`
- Log: `/tmp/ax2_strategy2.log`
- Failing point:
  - file: `02_FORMAL/coq/properties/NonInterference_v2.v:1559`
  - context includes `Hfo : first_order_type T = false`, `Hrat : True`
  - required goal remains `val_rel_at_type_n 1 ...`

## Strategy 3 (typed non-FO constructor analysis)

- Edit: attempted constructive discharge of non-FO branch via constructor analysis (`destruct T`) under typing/closedness hypotheses.
- Result: fail; concrete TFn branch requires semantic function relation not derivable from `val_rel_n 1` data.
- Compile command: `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2.vo`
- Log: `/tmp/ax2_strategy3.log`
- Failing point:
  - file: `02_FORMAL/coq/properties/NonInterference_v2.v:1559`
  - context specialized to `T = TFn T1 T2 e`
  - `Hrat : True` but goal requires `val_rel_at_type_n 1 ... (TFn T1 T2 e) ...`

## Restore and re-check

- Restored `02_FORMAL/coq/properties/NonInterference_v2.v` from backup after failed strategies.
- Narrow checks after restore:
  1. `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2.vo` -> pass (`/tmp/ax2_restore_nonintv2.log`)
  2. `make -C 02_FORMAL/coq -j2 properties/NonInterference_v2_LogicalRelation.vo` -> pass (`/tmp/ax2_restore_logrel.log`)
  3. `make -C 02_FORMAL/coq -j2 properties/ValRelStepLimit_PROOF.vo` -> pass (`/tmp/ax2_restore_valrelstep.log`)
  4. `make -C 02_FORMAL/coq -j2 properties/SecurityProperties.vo` -> pass (`/tmp/ax2_restore_securityprops.log`)

## Full build check

- Command: `make -C 02_FORMAL/coq -j2`
- Status: fail
- Log: `/tmp/ax2_full_build.log`
- AX2-related failures: none (AX2 attempts reverted)
- Unrelated baseline failure persists: `02_FORMAL/coq/effects/EffectGate.v:97`
