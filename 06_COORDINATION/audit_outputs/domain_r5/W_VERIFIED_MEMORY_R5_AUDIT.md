# Domain Audit Record

## 1. Identity
- Domain name: Verified Memory
- Domain identifier: `W_VERIFIED_MEMORY`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: W001_VerifiedMemory.v — 65% reflexivity, MIXED
- Implementation: riina-arena (shared). Overlaps with F_MEMORY_SAFETY
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq is mixed (65% reflexivity). riina-arena provides memory arena implementation. Overlaps significantly with F_MEMORY_SAFETY domain. No independent verified memory enforcement.

## 3. Safe Public Wording
- Safe claim: "Verified memory has partial formal modeling and a memory arena implementation, overlapping with the memory safety domain."
- Unsafe claim: "RIINA provides independently verified memory safety guarantees beyond F_MEMORY_SAFETY."

## 4. Sign-Off
- Final verdict: **R2**

## 5. Hostile Review Reconciliation
- Reviewer: Codex GPT (OpenAI) — independent from Claude
- Review verdict: **REJECT** (audit not acceptable as written)
- Review maximum honest rating: **R2** (abstract formal modeling only)
- Reconciled rating: **R2** (keep rating; narrow claim to abstract modeling only)
- Rationale: Hostile review agrees R2 is the ceiling but rejects the audit's implementation claims. Key issues: (1) riina-arena is an AST-node arena, not a verified allocator — no other crate depends on it; (2) live C backend still emits raw calloc/malloc/realloc; (3) Coq `exec` semantics omit allocation/free/read; (4) `alloc`/`free` never touch `free_lists`; (5) region isolation was aborted then weakened; (6) many theorems are vacuous/duplicate/assumption-baked; (7) non-Coq lanes are generated/derived.
- Key findings accepted:
  - G7/G8/G9 fail: no verified allocator in live toolchain
  - G6 partial: real local lemmas exist but headline theorems are weak
  - G13 fail: "memory arena implementation" wording overstates evidence
  - Implementation language must be removed from safe claim
- Remediation tracked in: `06_COORDINATION/remediation/W_VERIFIED_MEMORY/`
