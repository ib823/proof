# Z_DECLASSIFICATION_POLICY Remediation Worklist

## Immediate (audit cleanup)
- [ ] Remove R3 speculation from audit
- [ ] Include QuantitativeDeclassification.v in evidence
- [ ] Narrow safe claim to "narrow structural witness" only
- [ ] Write canonical scope/assumptions block for Track Z
- [ ] Add generated-lane disclaimers for non-Coq files

## Phase 2 (formal model)
- [ ] Replace vacuous `acts_for` with real authority model
- [ ] Replace no-op `Step_Declass` with real state transition
- [ ] Strengthen Z_001_02, Z_001_06, Z_001_07 beyond `exists 1`
- [ ] Prove non-interference over real declassification semantics
- [ ] Connect QuantitativeDeclassification.v to main domain model

## Phase 3 (toolchain enforcement)
- [ ] Add principal authorization to declassification path
- [ ] Add guard condition checking
- [ ] Add budget consumption tracking
- [ ] Add audit receipt generation for declassification events
- [ ] Fix 07_EXAMPLES/01_security/declassify.rii to parse correctly
- [ ] Fix COMMON_MISTAKES.md stale proof-string/audit claims
- [ ] Add negative test: unauthorized principal declassification rejected
- [ ] Add negative test: budget-exhausted declassification rejected
- [ ] Add negative test: missing guard declassification rejected
