# G_CRYPTO_AND_SIDECHANNEL — Remediation Plan v1.0.0

**Domain:** G_CRYPTO_AND_SIDECHANNEL
**Current Rating:** R2 | **Target:** R3
**Created:** 2026-03-21 | **Authority:** RIINA_MASTER_PLAN.md

---

## 1. Purpose

This plan governs the remediation of Domain G from R2 to R3. The core problem: real constant-time enforcement and a substantial crypto implementation (~10,868 lines, ~130+ tests) exist, but all 428 Coq domain theorems are vacuous boolean stubs. The formal layer adds zero assurance.

## 2. Current Truth (Verified)

| Asset | Status | Evidence |
|-------|--------|----------|
| CT type enforcement | Real | 5 typechecker tests, CT0001 error, branch rejection |
| ct_eq_bytes / ct_select | Real | compiler_fence, 199 lines in riina-core |
| Post-quantum (ML-KEM, ML-DSA) | Real impl, no formal | 3,184 lines |
| Crypto suite (AES, Ed25519, SHA-2, etc.) | Real impl, no formal | ~10,868 lines, ~130+ tests with RFC vectors |
| ct_oracle timing detector | Real | Statistical leakage detection |
| CryptographicSecurity.v (76 Qed) | Vacuous | Boolean conjunction unfolding |
| TimingSecurity.v (67 Qed) | Vacuous | Boolean stubs |
| ZKSNARKSecurity.v (98 Qed) | Vacuous | "soundness" = boolean field |
| ZKSTARKSecurity.v (107 Qed) | Vacuous | Same pattern |
| PostQuantumSignatures.v, PostQuantumKEM.v | Vacuous | "IND-CCA2 security" = boolean field |

## 3. Governing Rules

- No vacuous Coq file may count toward formal evidence
- Boolean-field-record theorems proven by `reflexivity.` are vacuous by definition
- Scope splits must be documented before re-audit
- Implementation test counts must be verified by `cargo test` output, not copied from docs

## 4. Required Structural Changes

### 4.1 Scope Split (Mandatory)
Split domain into two sub-scopes:
- **G-CT:** Constant-time discipline (CT type enforcement, ct_select, ct_oracle) — eligible for R3
- **G-CRYPTO:** ZK, PQ, broader crypto — R0-R1 until formal models exist

### 4.2 Vacuous File Disposition
Each vacuous .v file must be either:
- Rewritten with nontrivial properties (real field arithmetic, lattice ops, simulation-based security), OR
- Moved to `99_ARCHIVE/` and removed from all evidence counts

### 4.3 Test Count Reconciliation
Run `cargo test -p riina-core 2>&1 | grep "test result"` and record the actual crypto test count. The ~130+ figure must be verified.

## 5. Per-Gate Remediation

### Gate R2 (Current — verified hold)
- CT enforcement: confirmed real
- Implementation: confirmed real
- Formal: zero (all vacuous)

### Gate R3 (Target)
Requires ALL of:
1. Scope split documented and applied to audit scoring
2. At least one nontrivial CT-related Coq proof (e.g., ct_select correctness, CT propagation soundness)
3. Verified test count for riina-core crypto suite
4. .rii CT examples wired into integration tests
5. CT threat model document

### Gate R4 (Future)
- Nontrivial formal proofs for PQ/ZK properties
- Side-channel test suite with measurable coverage
- ct_oracle integrated into CI-equivalent workflow
