# RIINA Track & Phase Dependency Graph

**Last Updated:** 2026-02-02 (Session 71 Audit)

---

## 1. Materialization Phase Dependencies

```
RESEARCH (67 domains, 57 foundation docs)
    │
    │ informs all phases
    │
    ├──► Phase 1: Compiler Completion ────────────────────── ✅ DONE
    │        │
    │        ├──► Phase 2: Standard Library ──────────────── ✅ DONE
    │        │
    │        ├──► Phase 4: Developer Experience ──────────── ✅ DONE
    │        │        │
    │        │        └──► Phase 5: Ecosystem ────────────── ✅ DONE
    │        │                 │
    │        │                 └──► Phase 6: Adoption ────── ✅ DONE
    │        │                          │
    │        │                          └──► Phase 7: Platform ── ✅ DONE (scaffolding)
    │        │
    │        └──► Phase 3: Formal Verification ──────────── ⚠️ 7 Admitted
    │                 │
    │                 └──► Phase 8: Long-term Vision ────── ❌ NOT STARTED
    │
    └──► Track AL (Verified Layout) ─────────────────────── ❌ RESEARCH ONLY
    └──► Track AM (AI-First Language) ───────────────────── ❌ RESEARCH ONLY
```

## 2. Track Dependencies

### Core Tracks (A, B, F)

| Track | Name | Status | Depends On | Feeds Into |
|-------|------|--------|-----------|-----------|
| A | Formal Proofs (Coq) | ⚠️ 7 Admitted, 4 axioms | Research | B, C, all phases |
| B | Prototype (Rust) | ✅ 679 tests | Research, A | Phases 1-7 |
| C | Specifications | ✅ 33 spec docs | Research, A, B | All phases |
| F | Tooling & Crypto | ✅ Build tools complete | Research | B, Phases 4-5 |

### Zero-Trust Tracks (R-Z)

| Track | Name | Coq File | Status |
|-------|------|----------|--------|
| R | Certified Compilation | TranslationValidation.v | ✅ Formalized |
| S | Hardware Contracts | S001_HardwareContracts.v | ✅ Formalized |
| T | Hermetic Build | T001_HermeticBuild.v | ✅ Formalized |
| U | Runtime Guardian | U001_RuntimeGuardian.v | ✅ Formalized |
| V | Termination Guarantees | V001_TerminationGuarantees.v | ✅ Formalized |
| W | Verified Memory | W001_VerifiedMemory.v | ✅ Formalized |
| X | Concurrency Model | X001_ConcurrencyModel.v | ✅ Formalized |
| Y | Verified Stdlib | Y001_VerifiedStdlib.v | ✅ Formalized |
| Z | Declassification Policy | Z001_DeclassificationPolicy.v | ✅ Formalized |

### Extended Tracks (Greek, AA-AM)

See `06_COORDINATION/DOMAIN_COVERAGE_MATRIX.md` for full mapping of all 67 domains.

## 3. Critical Gaps (Blocking Paths)

```
Gap A1-A5 (Unverified Typechecker Rules — ~40% of Rust type system)
    │
    │  A1: Tainted/Sanitized typing (injection prevention)
    │  A2: Labeled types (explicit security labels)
    │  A3: Crypto types (ConstantTime, Zeroizing)
    │  A4: Session channels + FFI boundary typing
    │  A5: LetRec + BinOp + Capability-aware effects
    │
    │ blocks
    │
    └──► "Every compiler rule has a Coq proof" claim
             │
             └──► Phase 3 completion
                      │
                      └──► Phase 8 (self-hosting needs verified compiler)

7 Admitted Proofs
    │
    │ blocks
    │
    └──► "0 Admitted" claim (NOW CORRECTED — was false)
             │
             └──► Public credibility

34 Unformalized Research Domains
    │
    │ does NOT block anything immediately
    │
    └──► Phase 8 completeness (long-term)
```

## 4. Phase-to-Track Mapping

| Phase | Primary Track | Supporting Tracks | Research Domains |
|-------|--------------|-------------------|-----------------|
| 1. Compiler | B | A, F | A (Types), B (Effects), Q (Compiler) |
| 2. Stdlib | B | A, Y | P (Stdlib), Y (Verified Stdlib) |
| 3. Formal Verification | A | B | A-Z + all Greek/extended |
| 4. Developer Experience | B | F | N (Tooling) |
| 5. Ecosystem | B, F | C | — |
| 6. Adoption | B | A, C | L (FFI), M (Testing) |
| 7. Platform | B | A | Lambda (Mobile), WASM domains |
| 8. Long-term | A, B | All | R-Z, AL, AM, all remaining |

## 5. Immediate Priority Chain

```
1. Fix documentation integrity ──────────────── ✅ DONE (Session 71)
       │
2. Create domain coverage matrix ────────────── ✅ DONE (Session 71)
       │
3. Triage unformalized domains ──────────────── ✅ DONE (Session 71)
       │
4. Document 7 Admitted + gaps A1-A5 ─────────── ✅ DONE (Session 71)
       │
5. Track AM Phase AM-1 (AI language reference) ─ ❌ NEXT
       │   - Machine-readable language ref (≤40K tokens)
       │   - llms.txt + AI IDE config files
       │   - Expanded all_examples.rii
       │
6. Eliminate 7 Admitted proofs ──────────────── ❌ NEXT (Coq work)
       │   - 3 in DELTA001 (distribution)
       │   - 3 Rocq 9.1 compat stubs
       │   - 1 ValRelStepLimit
       │
7. Close gaps A1-A5 ────────────────────────── ❌ FUTURE (major Coq effort)
       │   - A5 first (LetRec/BinOp — most used)
       │   - A1 next (Tainted — security critical)
       │
8. Website mobile overhaul ──────────────────── ❌ FUTURE
       │
9. Phase 8 long-term items ─────────────────── ❌ FUTURE
```

---

*RIINA: Rigorous Immutable Invariant, No Assumptions*
