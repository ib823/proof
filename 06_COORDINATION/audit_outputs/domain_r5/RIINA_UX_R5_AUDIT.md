# Domain Audit Record

## 1. Identity
- Domain name: RIINA User Experience
- Domain identifier: `RIINA_UX`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: VerifiedUI.v — 36% reflexivity, REAL
- Implementation: riina-ui (real but limited)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq has real proofs (36% reflexivity). riina-ui provides real but limited UI implementation. However, no domain-specific UX enforcement exists in the typechecker with tested negative cases.

## 3. Safe Public Wording
- Safe claim: "RIINA UX has nontrivial formal models and a limited UI implementation, but no specific UX enforcement."
- Unsafe claim: "RIINA provides formally verified user experience guarantees."

## 4. Sign-Off
- Final verdict: **R2**
