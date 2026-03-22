# Domain Audit Record

## 1. Identity
- Domain name: RIINA Runtime
- Domain identifier: `RIINA_RUNTIME`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: VerifiedRuntime.v — 68% reflexivity, MIXED
- Implementation: riina-runtime 49 tests (shared). Overlaps with O_RUNTIME and U_RUNTIME_GUARDIAN
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq is mixed (68% reflexivity). riina-runtime has 49 tests but is shared across multiple domains. Overlaps significantly with O and U domains.

## 3. Safe Public Wording
- Safe claim: "RIINA runtime has partial formal modeling and 49 shared tests, overlapping with O_RUNTIME and U_RUNTIME_GUARDIAN."
- Unsafe claim: "RIINA has an independently verified runtime system."

## 4. Sign-Off
- Final verdict: **R2**
