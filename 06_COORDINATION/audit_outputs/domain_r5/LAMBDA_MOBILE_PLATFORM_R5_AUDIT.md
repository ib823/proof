# Domain Audit Record

## 1. Identity
- Domain name: Mobile Platform
- Domain identifier: `LAMBDA_MOBILE_PLATFORM`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: MobilePlatform.v — likely vacuous
- Implementation: riina-codegen has JNI/Swift bridges
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq is likely vacuous. riina-codegen has JNI and Swift bridge codegen paths providing real mobile platform implementation. No domain-specific mobile enforcement with negative cases.

## 3. Safe Public Wording
- Safe claim: "Mobile platform has codegen bridges for JNI/Swift but Coq proofs are likely vacuous and no specific mobile enforcement exists."
- Unsafe claim: "RIINA provides formally verified mobile platform security."

## 4. Sign-Off
- Final verdict: **R2**
