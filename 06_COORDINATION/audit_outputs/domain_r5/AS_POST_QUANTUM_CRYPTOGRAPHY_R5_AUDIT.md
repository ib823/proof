# Domain Audit Record

## 1. Identity
- Domain name: Post-Quantum Cryptography
- Domain identifier: `AS_POST_QUANTUM_CRYPTOGRAPHY`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: PostQuantumKEM.v + PostQuantumSignatures.v — reflexivity% needs verification
- Implementation: riina-core has ML-KEM/ML-DSA (10K+ lines)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Substantial implementation exists (ML-KEM/ML-DSA in riina-core, 10K+ lines). However, Coq proof quality for the post-quantum domain files needs hostile review verification. Even with real implementation, vacuous Coq proofs cap at R2. If Coq proofs are nontrivial AND typechecker enforces PQ crypto with negative cases, could reach R3 on review.

## 3. Safe Public Wording
- Safe claim: "RIINA has a substantial post-quantum cryptography implementation (ML-KEM/ML-DSA) but Coq proof quality needs independent verification."
- Unsafe claim: "RIINA provides formally verified post-quantum cryptographic guarantees."

## 4. Sign-Off
- Final verdict: **R2**
