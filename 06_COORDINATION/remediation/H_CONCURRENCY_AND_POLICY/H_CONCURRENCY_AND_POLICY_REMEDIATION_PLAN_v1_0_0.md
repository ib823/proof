# H_CONCURRENCY_AND_POLICY — Remediation Plan v1.0.0

**Domain:** H_CONCURRENCY_AND_POLICY
**Current Rating:** R2 | **Target:** R3
**Created:** 2026-03-21 | **Authority:** RIINA_MASTER_PLAN.md

---

## 1. Purpose

Remediate Domain H from R2 to R3. The core problem: real actor/session/choreography enforcement exists (71 jalinan tests), but the Coq formal layer defines critical predicates (`accesses`, `writes`, `waiting`, `holding`, `livelock`, `starved`) as `False`, making all deadlock/race theorems trivially provable by contradiction.

## 2. Current Truth (Verified)

| Asset | Status | Evidence |
|-------|--------|----------|
| Actor declaration validation | Real | Handler/state/init type checking |
| Actor send/recv type matching | Real | Negative rejection tests |
| Choreography protocol validation | Real | Phase 6 jalinan tests |
| Channel linearity enforcement | Real | Phase 6 jalinan tests |
| 71 jalinan tests | Real | All pass |
| DataRaceFreedom.v mutex/rwlock | Mostly real | Legitimate lock model |
| X001_ConcurrencyModel.v predicates | Vacuous | `accesses := False`, `writes := False`, etc. |
| SessionTypes.v `waiting` | Vacuous | Stub |
| ChoreographyTypes.v `chor_waiting` | Vacuous | Stub |
| All deadlock/livelock/starvation theorems | Vacuous | Provable by contradiction from False |

## 3. Governing Rules

- `Definition X := False` predicates are vacuous; any theorem using them is unprovable evidence
- Scope split between enforced (actor/session) and formal-only (deadlock/race) is mandatory
- DataRaceFreedom.v is partially legitimate — must be evaluated separately from the False-stub files

## 4. Required Structural Changes

### 4.1 Scope Split
- **H-ENFORCED:** Actor validation, session types, choreography, channel linearity — R2→R3 eligible
- **H-FORMAL:** Deadlock freedom, livelock freedom, starvation freedom, race freedom — R0-R1 until predicates are real

### 4.2 False Predicate Removal
Every `Definition X := False` in concurrency .v files must be either:
- Replaced with real predicate definitions modeling actual concurrent access patterns, OR
- Removed entirely with dependent theorems deleted

### 4.3 DataRaceFreedom.v Triage
Separate the legitimate mutex/rwlock model from any theorems that depend on False-stubbed predicates elsewhere.

## 5. Per-Gate Remediation

### Gate R2 (Current — verified hold)
- Actor/session enforcement: confirmed real
- 71 tests: confirmed passing
- Formal: near-zero (False stubs)

### Gate R3 (Target)
Requires ALL of:
1. Scope split documented
2. False predicates removed or replaced with real definitions
3. At least one nontrivial concurrency Coq proof (e.g., mutex exclusion, session type duality)
4. .rii concurrency examples wired into integration tests
5. Concurrency threat model document

### Gate R4 (Future)
- Progress/preservation for session types
- Deadlock freedom for well-typed choreographies
- Model checking integration (TLA+ or similar)
