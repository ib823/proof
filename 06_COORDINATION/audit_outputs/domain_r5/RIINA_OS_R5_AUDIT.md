# Domain Audit Record

## 1. Identity
- Domain name: RIINA OS (Teras Kernel)
- Domain identifier: `RIINA_OS`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: TerasKernel.v 51% refl, TerasCapabilities.v 61% refl — MIXED
- Implementation: riina-os 8 modules (real but limited)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq files are mixed (51-61% reflexivity). riina-os has 8 real modules providing limited OS implementation. However, Coq proofs are not nontrivial enough and no domain-specific OS enforcement exists in the typechecker.

## 3. Safe Public Wording
- Safe claim: "RIINA OS has partial formal modeling and limited Rust OS modules, but Coq proofs are mixed and no OS-specific enforcement exists."
- Unsafe claim: "RIINA provides a formally verified operating system kernel."

## 4. Sign-Off
- Final verdict: **R2**
