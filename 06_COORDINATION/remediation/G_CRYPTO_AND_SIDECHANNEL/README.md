# Remediation Package: G_CRYPTO_AND_SIDECHANNEL

## Domain
- Domain ID: `G_CRYPTO_AND_SIDECHANNEL`
- Current honest rating: `R2`
- Target rating: `R3`
- Hostile review verdict: **reject** (downgrade from R3 to R2)
- Created: 2026-03-20

## Why R2
CT type enforcement is real (5 typechecker tests, CT0001 error, branch rejection + propagation). But all 428 Coq domain theorems are vacuous boolean stubs (same D_HARDWARE pattern — `reflexivity.` on hardcoded boolean fields). No actual cryptographic properties are formally modeled. Substantial crypto implementation exists (10,868 lines, ~130+ tests with RFC vectors) but is not formally verified.

## What IS Real
- CT type discipline: branch rejection, CT propagation, comparison chain (riina-typechecker)
- Constant-time primitives: ct_eq_bytes, ct_select with compiler_fence (riina-core, 199 lines)
- Post-quantum crypto: ML-KEM, ML-DSA implementations (3,184 lines)
- Crypto suite: AES, Ed25519, X25519, SHA-2, GCM, HMAC, HKDF, Keccak (~10,868 lines, ~130+ tests)
- ct_oracle: statistical timing-leakage detection
- Spectre litmus tests

## What Is Vacuous
- CryptographicSecurity.v (76 Qed): boolean conjunction unfolding
- TimingSecurity.v (67 Qed): boolean stubs
- ZKSNARKSecurity.v (98 Qed): "soundness" is a boolean field
- ZKSTARKSecurity.v (107 Qed): same pattern
- PostQuantumSignatures.v, PostQuantumKEM.v: "IND-CCA2 security" is a boolean field

## Remediation Items to Reach R3

### R3-1: Rewrite or discard vacuous Coq domain files
**Severity:** Critical
**What:** Either build real cryptographic models (field arithmetic, lattice operations, simulation-based security) or remove the files and stop counting them.

### R3-2: Scope-split the domain
**Severity:** High
**What:** CT discipline is R2-to-R3 material. ZK/PQ/broader crypto is R0-R1. Split them.

### R3-3: Count riina-core test suite properly
**Severity:** Medium
**What:** The audit missed ~130+ crypto tests with RFC test vectors. These are real evidence.

### R3-4: Wire .rii examples into integration tests
**Severity:** Medium

### R3-5: Write threat model for CT subset
**Severity:** Medium

## Methodology Lesson
Vacuity check must include `reflexivity.` on hardcoded boolean records, not just `trivial.`/`exact I.`. The D_HARDWARE lesson was insufficiently applied.

## Re-audit Trigger
Re-audit after Coq files rewritten OR scope-split completed.
