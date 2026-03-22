# X_CONCURRENCY_MODEL Remediation Worklist

## Immediate (audit cleanup)
- [ ] Rewrite audit to R1 rating
- [ ] Enumerate all False/True stub predicates in audit
- [ ] Add generated-lane disclaimers for non-Coq X001 files
- [ ] Resolve X vs H domain boundary

## Phase 2 (formal model)
- [ ] Replace `accesses := False` with real memory-access predicate
- [ ] Replace `writes := False` with real write predicate
- [ ] Replace `waiting := False` with real wait-state predicate
- [ ] Replace `holding := False` with real lock-holding predicate
- [ ] Replace `holds_lock := False` with real lock model
- [ ] Replace `acquires_lock := False` with real acquisition model
- [ ] Replace `livelock := False` with real livelock predicate
- [ ] Replace `starved := False` with real starvation predicate
- [ ] Replace `atomic_race_free := True` with real check
- [ ] Reprove race/deadlock/progress/safety theorems non-vacuously
- [ ] Add regression test that greps for `:= False` in active concurrency files

## Phase 3 (implementation)
- [ ] Implement real choreography typing beyond roles.len() >= 2
- [ ] Add choreography runtime behavior in interpreter
- [ ] Fix C actor backend (threads, mailbox drain)
- [ ] Fix WASM actor backend (real spawn/send/recv)
- [ ] Add positive concurrency .rii example
- [ ] Add negative concurrency .rii example (rejected)
