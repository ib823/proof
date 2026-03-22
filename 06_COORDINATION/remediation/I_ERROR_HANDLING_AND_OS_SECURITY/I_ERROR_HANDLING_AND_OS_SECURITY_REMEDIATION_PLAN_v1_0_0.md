# I_ERROR_HANDLING_AND_OS_SECURITY — Remediation Plan v1.0.0

**Domain:** I_ERROR_HANDLING_AND_OS_SECURITY
**Current Rating:** R2 | **Target:** R3
**Created:** 2026-03-21 | **Authority:** RIINA_MASTER_PLAN.md

---

## 1. Purpose

Remediate Domain I from R2 to R3. The core problem: real injection prevention enforcement exists (44 tests, many negative), but the Coq layer is a mix of vacuous boolean stubs (TerasSecurity.v, SQLInjectionPrevention.v), toy ASTs disconnected from the compiler (InjectionPrevention.v), and some legitimate proofs (CrossLayerSecurity.v, VerifiedMicrokernel.v).

## 2. Current Truth (Verified)

| Asset | Status | Evidence |
|-------|--------|----------|
| Injection prevention enforcement | Real | 44 tests, negative tests for SQL/XSS/path traversal |
| Error type checking (Keputusan/Ralat) | Real | Typechecker enforcement |
| TerasSecurity.v | Vacuous | Boolean record stubs |
| SQLInjectionPrevention.v | Vacuous | Boolean record stubs |
| InjectionPrevention.v | Toy | `list nat` ASTs, not connected to compiler |
| CrossLayerSecurity.v | Legitimate | Real security property proofs |
| VerifiedMicrokernel.v | Legitimate | Real kernel model |

## 3. Governing Rules

- Boolean-record .v files are vacuous and cannot count as formal evidence
- Toy AST models disconnected from the actual compiler AST provide limited assurance — they may count at R2 but not R3
- Legitimate .v files must be preserved and correctly counted

## 4. Required Structural Changes

### 4.1 Vacuous File Disposition
- `TerasSecurity.v`: ARCHIVE or REWRITE
- `SQLInjectionPrevention.v`: ARCHIVE or REWRITE
- `InjectionPrevention.v`: REWRITE to use actual riina-types AST or scope-exclude with documented rationale

### 4.2 Legitimate File Preservation
- `CrossLayerSecurity.v` and `VerifiedMicrokernel.v` are real evidence and must be retained
- Their theorem counts must be separately tracked from vacuous files

### 4.3 Compiler AST Linkage
If InjectionPrevention.v is rewritten, its AST definitions must correspond to the actual `riina-types` Expr/Stmt types, or a documented abstraction of them.

## 5. Per-Gate Remediation

### Gate R2 (Current — verified hold)
- Injection enforcement: confirmed real (44 tests)
- Error handling: confirmed real
- Formal: mixed (some legitimate, some vacuous)

### Gate R3 (Target)
Requires ALL of:
1. Vacuous .v files archived or rewritten
2. InjectionPrevention.v linked to compiler AST or scope-excluded
3. Legitimate Coq files correctly counted
4. .rii error handling examples wired into integration tests
5. Threat model for injection/error handling domain

### Gate R4 (Future)
- Formal proof that injection prevention is complete (covers all input vectors)
- OS security model connected to capability system
- Error propagation soundness proofs
