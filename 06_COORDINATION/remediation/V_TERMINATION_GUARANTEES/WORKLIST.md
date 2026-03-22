# V_TERMINATION_GUARANTEES Remediation Worklist

## Immediate (audit cleanup)
- [ ] Rewrite audit evidence around canonical V001 + termination/*.v sources
- [ ] Remove all R3 speculation from audit
- [ ] Disclose 3 unresolved premises in well_typed_SN/SN_app
- [ ] Separate WCET evidence from termination evidence
- [ ] Add generated-lane disclaimers for non-Coq V001 files

## Phase 2 (formal model)
- [ ] Close `env_reducible_closed` premise
- [ ] Close `lambda_body_SN` premise
- [ ] Close `store_values_are_values` premise
- [ ] Replace vacuous `check_termination` with real logic
- [ ] Reprove checker soundness over non-trivial definition
- [ ] Verify 0 Admitted / 0 Axiom after changes

## Phase 3 (toolchain enforcement)
- [ ] Implement bounded-or-Sistem loop policy in riina-parser
- [ ] Add `had:` bound syntax support for `selagi`
- [ ] Add typechecker rejection for unbounded pure loops
- [ ] Add negative test: unbounded recursion rejected
- [ ] Add negative test: unbounded selagi in Bersih rejected
- [ ] Fix 07_EXAMPLES/00_basics/loops_while.rii overclaims
- [ ] Fix 07_EXAMPLES/08_ai_training/vuln_to_safe.jsonl overclaims
