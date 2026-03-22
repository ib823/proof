# X_CONCURRENCY_MODEL Remediation Plan

## Phase 1: Foundation Repair (R1 stabilization)
1. Resolve domain overlap with H_CONCURRENCY_AND_POLICY
2. Write canonical scope/assumptions/not-in-scope block
3. Add generated-lane disclaimers for non-Coq X001 files
4. Rewrite audit in worksheet form

## Phase 2: Formal Model (R1 -> R2)
1. Replace `accesses` and `writes` with real memory-access predicates
2. Replace `waiting` and `holding` with real lock-state predicates
3. Replace `holds_lock` and `acquires_lock` with real acquisition model
4. Replace `livelock` and `starved` with real liveness predicates
5. Replace `atomic_race_free := True` with real race-freedom check
6. Reprove X_001_05 (race freedom) over non-vacuous definitions
7. Reprove X_001_20 (deadlock freedom) over non-vacuous definitions
8. Reprove X_001_11/X_001_12 (session progress/safety) with real content

## Phase 3: Implementation (R2 -> R3)
1. Implement real choreography enforcement beyond role-count check
2. Give choreography runtime behavior in interpreter
3. Fix C actor backend: create worker threads, drain mailbox
4. Fix WASM backend: real actor spawn/send/recv
5. Add positive .rii concurrency workflow example
6. Add negative .rii example (race/deadlock rejected)

## Dependencies
- Coordinate with H_CONCURRENCY_AND_POLICY remediation
