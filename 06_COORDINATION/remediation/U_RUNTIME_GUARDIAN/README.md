# U_RUNTIME_GUARDIAN Remediation Package

## Reconciliation Summary
- **Original audit rating**: R2
- **Hostile review rating**: R1 (Codex GPT, OpenAI)
- **Reconciled rating**: R1 (downgrade accepted)
- **Review date**: 2026-03-22

## Root Cause
The R2 rating was based on misattributed implementation evidence (riina-runtime's
actor/session tests counted as guardian evidence) and shallow Coq modeling (vacuous
predicates like `complete_mediation`, `tamper_evident`, `variants_independent`).

## Critical Defects
1. Track U is marked Level 0 / NOT STARTED in repo scope docs
2. Expected artifacts (`riina-hypervisor`, `Hypervisor.v`) do not exist
3. Core Coq predicates are tautologies or self-equality
4. No guardian-specific implementation, examples, or adversarial tests
5. All non-Coq lanes are generated/derived from the same Coq source

## Promotion Path: R1 -> R2
- Replace vacuous predicates with real guardian semantics (CFI, tamper detection, fault isolation)
- Create domain-specific Coq model with workflow-aligned properties
- Add at least one positive and one negative guardian workflow example

## Promotion Path: R2 -> R3
- Implement `riina-hypervisor` crate with real guardian/micro-hypervisor logic
- Wire guardian enforcement into the live toolchain
- Add adversarial test suite (attack patterns, tamper cases, invalid sequencing)
