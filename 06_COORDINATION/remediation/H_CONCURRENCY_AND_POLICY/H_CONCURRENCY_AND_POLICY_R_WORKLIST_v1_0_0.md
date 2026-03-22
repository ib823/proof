# H_CONCURRENCY_AND_POLICY — Remediation Worklist v1.0.0

**Current:** R2 | **Target:** R3
**Created:** 2026-03-21

---

## R2 → R3 Tasks

### Critical (Blocks R3)

- [ ] **H-R3-01:** Scope-split document — Define H-ENFORCED (actor/session/choreography enforcement) vs H-FORMAL (deadlock/race formal proofs) with separate rating tracks
- [ ] **H-R3-02:** Remove False predicates — In X001_ConcurrencyModel.v, replace `accesses := False`, `writes := False`, `waiting := False`, `holding := False`, `livelock := False`, `starved := False` with either real definitions or delete them
- [ ] **H-R3-03:** Fix SessionTypes.v — Remove `waiting` stub, replace with real session state predicate
- [ ] **H-R3-04:** Fix ChoreographyTypes.v — Remove `chor_waiting` stub
- [ ] **H-R3-05:** Delete or rewrite dependent theorems — All deadlock/livelock/starvation theorems that relied on False predicates must be removed or reproven against real definitions

### High Priority

- [ ] **H-R3-06:** Nontrivial Coq proof — Write at least one real concurrency proof. Candidates:
  - Mutex mutual exclusion (extend DataRaceFreedom.v)
  - Session type duality: if client sends T, server receives T
  - Channel linearity: used-once channels cannot be reused
- [ ] **H-R3-07:** Concurrency threat model — Document what RIINA's actor/session model prevents vs what remains unaddressed

### Medium Priority

- [ ] **H-R3-08:** Wire .rii examples into tests — Actor/session/choreography examples need integration test coverage
- [ ] **H-R3-09:** DataRaceFreedom.v audit — Confirm which theorems in this file are legitimate vs which depend on False stubs from other files

---

## R3 → R4 Tasks (Future)

- [ ] **H-R4-01:** Session type progress theorem — Well-typed sessions cannot get stuck
- [ ] **H-R4-02:** Choreography deadlock freedom — Well-typed choreographies are deadlock-free
- [ ] **H-R4-03:** TLA+ model — Model concurrent protocol interactions for model checking
- [ ] **H-R4-04:** Actor mailbox overflow analysis — Formal bounds on message queue sizes
- [ ] **H-R4-05:** Linearizability proofs for concurrent data structures

---

## Verification Commands

```bash
# Find False stubs
grep -n ":= False" 02_FORMAL/coq/concurrency/X001_ConcurrencyModel.v
grep -n ":= False" 02_FORMAL/coq/concurrency/SessionTypes.v

# Run jalinan tests
cargo test -p riina-typechecker -- jalinan 2>&1 | grep "test result"

# Check DataRaceFreedom.v for real content
grep -c "Qed\." 02_FORMAL/coq/concurrency/DataRaceFreedom.v
```
