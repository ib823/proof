# V_TERMINATION_GUARANTEES Remediation Plan

## Phase 1: Audit Repair (immediate)
1. Rewrite evidence pack around canonical sources: V001_TerminationGuarantees.v,
   RESEARCH_V01_FOUNDATION.md, and 02_FORMAL/coq/termination/*.v
2. Remove all R3 language from the audit
3. Disclose that `well_typed_SN`/`SN_app` require 3 external premises
4. Separate WCET claims from termination claims

## Phase 2: Formal Model Strengthening
1. Close `env_reducible_closed` premise in ReducibilityFull.v
2. Close `lambda_body_SN` premise in ReducibilityFull.v
3. Close `store_values_are_values` premise in ReducibilityFull.v
4. Replace vacuous `check_termination := true` with real checker logic
5. Prove checker soundness over non-trivial definition

## Phase 3: Toolchain Enforcement (R2 -> R3)
1. Implement bounded-or-Sistem loop policy in parser
2. Add `had:` bound support to `selagi` loop parsing
3. Add typechecker rejection for unbounded loops in `kesan Bersih`
4. Add negative test: rejected unbounded recursion
5. Add negative test: rejected `selagi` without bound in pure context
6. Fix stale public examples (loops_while.rii, vuln_to_safe.jsonl)

## Dependencies
- Termination infrastructure in 02_FORMAL/coq/termination/ is prerequisite
