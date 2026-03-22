# Domain Audit Record

## 1. Identity
- Domain name: Verified Hardware
- Domain identifier: `PHI_VERIFIED_HARDWARE`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: VerifiedHardware.v — 202% reflexivity (more reflexivity calls than Qed), VACUOUS
- Implementation: riina-codegen (shared)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq is vacuous (202% reflexivity — more reflexivity calls than theorems). riina-codegen provides shared codegen targeting hardware. No domain-specific hardware verification enforcement.

## 3. Safe Public Wording
- Safe claim: "Verified hardware has vacuous Coq proofs and shared codegen infrastructure, with no specific hardware verification."
- Unsafe claim: "RIINA provides formally verified hardware correctness."

## 4. Sign-Off
- Final verdict: **R2**
