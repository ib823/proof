# Domain Audit Record

## 1. Identity
- Domain name: RIINA Network Stack
- Domain identifier: `RIINA_NET`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: VerifiedNetworkStack.v — 72% reflexivity, VACUOUS
- Implementation: riina-wasm (limited)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq is vacuous (72% reflexivity). riina-wasm provides limited network-adjacent implementation. No domain-specific network stack enforcement.

## 3. Safe Public Wording
- Safe claim: "RIINA's network stack has vacuous Coq proofs and limited implementation with no specific enforcement."
- Unsafe claim: "RIINA provides a formally verified network stack."

## 4. Sign-Off
- Final verdict: **R2**
