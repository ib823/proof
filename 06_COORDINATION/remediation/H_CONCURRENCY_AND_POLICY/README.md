# Remediation Package: H_CONCURRENCY_AND_POLICY

## Domain
- Domain ID: `H_CONCURRENCY_AND_POLICY`
- Current honest rating: `R2`
- Hostile review verdict: **reject** (downgrade from R3 to R2)
- Created: 2026-03-20

## Why R2
Rust enforcement is real (71 jalinan tests, actor/session type checking). But the Coq formal model is compromised: `X001_ConcurrencyModel.v` defines `accesses := False`, `writes := False`, `waiting := False`, `holding := False`, `livelock := False`, `starved := False`. All deadlock and data-race theorems are trivially provable by contradiction from these `False` stubs. SessionTypes.v and ChoreographyTypes.v have similar stubs.

## What IS Real
- Actor declaration validation (handler type, state type, init type)
- Actor send/recv type matching with negative rejection tests
- Choreography protocol validation
- Channel linearity enforcement
- 71 jalinan phase6 tests, all pass
- DataRaceFreedom.v mutex/rwlock model (mostly legitimate)

## What Is Vacuous
- `X001_ConcurrencyModel.v`: all access/write/waiting/holding predicates are `False`
- `SessionTypes.v`: `waiting` stub
- `ChoreographyTypes.v`: `chor_waiting` stub
- All deadlock freedom, livelock freedom, starvation freedom theorems

## Remediation Items to Reach R3

### R3-1: Remove or rewrite False-stubbed predicates
**Severity:** Critical
**What:** Replace `accesses := False` etc. with real predicate definitions that model actual concurrent access.

### R3-2: Scope-split enforced vs formal-only
**Severity:** High
**What:** Explicitly document that actor/session enforcement is R3 while deadlock/race is R1 (vacuous proofs).

### R3-3: Fix .rii example filenames and wire into tests
**Severity:** Medium

### R3-4: Write threat model
**Severity:** Medium

## Methodology Lesson
Three vacuity patterns now known:
1. `True` conclusion with `trivial.` (D_HARDWARE)
2. `reflexivity.` on hardcoded boolean records (G_CRYPTO)
3. `Definition predicate := False` making all theorems trivially provable by contradiction (H_CONCURRENCY)

## Re-audit Trigger
Re-audit after False stubs are replaced with real predicates.
