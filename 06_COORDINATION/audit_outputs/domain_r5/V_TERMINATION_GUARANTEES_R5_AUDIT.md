# Domain Audit Record

## 1. Identity
- Domain name: Termination Guarantees
- Domain identifier: `V_TERMINATION_GUARANTEES`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: WCETBounds.v 25% refl REAL, WCETTypes.v 31% refl REAL
- Implementation: Needs verification — check if typechecker has WCET tests
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq proofs are nontrivial (25-31% reflexivity). Potential R3 if typechecker has WCET enforcement with tested negative cases. Needs hostile review to verify enforcement exists. Conservatively rated R2 pending verification.

## 3. Safe Public Wording
- Safe claim: "Termination guarantees have nontrivial formal models for WCET bounds. Enforcement status needs independent verification."
- Unsafe claim: "RIINA formally guarantees program termination."

## 4. Sign-Off
- Final verdict: **R2** (pending hostile review for potential R3 upgrade)

## 5. Hostile Review Reconciliation
- Reviewer: Codex GPT (OpenAI) — independent from Claude
- Review verdict: **FAIL** (reject audit as written)
- Review maximum honest rating: **R2** (only under narrower claim)
- Reconciled rating: **R2** (keep conservative rating; review agrees R2 ceiling but rejects R3 speculation)
- Rationale: Hostile review confirmed R2 ceiling but rejected the audit's evidence basis and R3 speculation. Key issues: (1) audit cited wrong-layer evidence (WCETBounds.v/WCETTypes.v instead of canonical V001_TerminationGuarantees.v and termination/*.v); (2) strongest theorem `well_typed_SN` exports with 3 unresolved premises (`env_reducible_closed`, `lambda_body_SN`, `store_values_are_values`); (3) V001_TerminationGuarantees.v has vacuous checker (`check_termination` always returns `true`); (4) live parser/spec contradict documented bounded-or-Sistem loop policy; (5) no termination enforcement in typechecker; (6) public examples overclaim `Bersih` termination guarantees. R3 is impossible at this snapshot.
- Key findings accepted:
  - G7 fail: `check_termination` is literally `true`, no WCET rejection path
  - G8/G9 fail: no end-to-end termination workflow or negative tests
  - G13 fail: public examples and training data overclaim termination
  - G14 fail: parser/spec loop policy already regressed
  - R3 language must be removed entirely
- Remediation tracked in: `06_COORDINATION/remediation/V_TERMINATION_GUARANTEES/`
