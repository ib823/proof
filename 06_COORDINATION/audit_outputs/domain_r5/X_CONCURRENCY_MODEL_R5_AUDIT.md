# Domain Audit Record

## 1. Identity
- Domain name: Concurrency Model
- Domain identifier: `X_CONCURRENCY_MODEL`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: X001_ConcurrencyModel.v — has False stubs (same pattern as H_CONCURRENCY)
- Implementation: riina-runtime (shared). Overlaps with H_CONCURRENCY_AND_POLICY
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq file contains False stubs (proven from impossible hypotheses). riina-runtime provides shared concurrency infrastructure. Overlaps with H_CONCURRENCY domain. False stubs prevent R3.

## 3. Safe Public Wording
- Safe claim: "Concurrency model shares runtime infrastructure with H_CONCURRENCY, but Coq proofs contain False stubs."
- Unsafe claim: "RIINA has an independently verified concurrency model."

## 4. Sign-Off
- Final verdict: **R2**

## 5. Hostile Review Reconciliation
- Reviewer: Codex GPT (OpenAI) — independent from Claude
- Review verdict: **Not defensible** (reject audit)
- Review maximum honest rating: **R1**
- Reconciled rating: **R1** (downgrade accepted)
- Rationale: Hostile review correctly identified that the Coq model is structurally vacuous for core concurrency properties. `accesses`, `writes`, `waiting`, `holding`, `holds_lock`, `acquires_lock`, `livelock`, `starved` are all defined as `False`; `atomic_race_free` is always `True`. Flagship theorems collapse to contradiction or tautology (e.g., race_freedom unfolds `accesses := False`; session_deadlock_free unfolds `waiting := False`; session_safety proves `True`). Additionally: (1) choreography typechecking only checks `roles.len() >= 2`; (2) interpreter gives choreography no behavior; (3) C/WASM actor backends are placeholder/stubbed; (4) non-Coq lanes are generated/derived. False stubs prevent not just R3 but R2.
- Key findings accepted:
  - G4/G5/G6 fail: core predicates are False stubs, model is vacuous
  - G7 partial: real actor tests exist but choreography is shallow
  - G8/G9 fail: no end-to-end workflow evidence
  - G10 fail: non-Coq lanes are derivative
- Remediation tracked in: `06_COORDINATION/remediation/X_CONCURRENCY_MODEL/`
