# L_FFI_AND_ATTACK_RESEARCH — Remediation Plan v1.0.0

**Domain:** L_FFI_AND_ATTACK_RESEARCH
**Current Rating:** R2 | **Target:** R3
**Created:** 2026-03-21 | **Authority:** RIINA_MASTER_PLAN.md

---

## 1. Purpose

Remediate Domain L from R2 to R3. The asymmetry: strong FFI implementation (extern blocks, raw pointers, C/WASM/JNI/Swift codegen, 153 tests) but vacuous Coq layer (RustFFISecurity.v is 79% reflexivity). Implementation without formal backing caps at R2.

## 2. Current Truth (Verified)

| Asset | Status | Evidence |
|-------|--------|----------|
| Extern block parsing | Real | Parser handles extern declarations |
| Raw pointer types | Real | Pointer type system in riina-types |
| C codegen | Real | Code generation with tests |
| WASM codegen | Real | Code generation with tests |
| JNI codegen | Real | Code generation with tests |
| Swift codegen | Real | Code generation with tests |
| 153 codegen tests | Real | All pass |
| RustFFISecurity.v | Vacuous | 79% reflexivity proofs |
| FFI boundary attack tests | Not implemented | No memory corruption / type confusion tests |
| Attack research | Minimal | No systematic attack surface analysis |

## 3. Governing Rules

- 79% reflexivity Coq files are vacuous
- FFI is a critical security boundary — formal gaps here are high-severity
- Attack research requires actual attack implementations, not just documentation
- R3 requires formal backing for at least the FFI safety invariants

## 4. Required Structural Changes

### 4.1 Coq FFI Safety Model
Replace RustFFISecurity.v with real properties:
- FFI call preserves memory safety (no dangling pointers across boundary)
- Type marshaling correctness (RIINA types map correctly to C/WASM types)
- Lifetime constraints at FFI boundary (no use-after-free across calls)

### 4.2 Attack Test Suite
Create FFI boundary attack tests:
- Memory corruption across FFI (buffer overflow, use-after-free)
- Type confusion (wrong type marshaling)
- Double-free across boundary
- Callback safety (RIINA function passed to C, called after scope exit)

### 4.3 Attack Research Documentation
Document known FFI attack vectors and which ones RIINA's design prevents vs. leaves to the programmer.

## 5. Per-Gate Remediation

### Gate R2 (Current — verified hold)
- FFI implementation: confirmed real (153 tests)
- Formal: zero (vacuous)
- Attack testing: none

### Gate R3 (Target)
Requires ALL of:
1. RustFFISecurity.v rewritten with nontrivial FFI safety properties
2. At least 10 FFI boundary attack tests (negative tests that must be rejected)
3. .rii FFI examples wired into integration tests
4. FFI threat model document

### Gate R4 (Future)
- Full FFI safety soundness proof
- Verified marshaling for all supported target platforms
- Fuzzing of FFI boundary with coverage tracking
- Formal model of callback safety
