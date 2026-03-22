# Domain Audit Record

## 1. Identity
- Domain name: Declassification Policy
- Domain identifier: `Z_DECLASSIFICATION_POLICY`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: Z001_DeclassificationPolicy.v — 47% reflexivity, MIXED
- Implementation: Ties to C_IFC declassification enforcement (test_proper_declassification, test_declassify_wrong_proof_structure)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq is mixed (47% reflexivity). Ties to C_INFORMATION_FLOW_CONTROL's declassification enforcement which has tested negative cases. However, Z is not independently enforced — it depends on C_IFC's typechecker paths. Conservatively R2 unless hostile review confirms independent enforcement.

## 3. Safe Public Wording
- Safe claim: "Declassification policy has partial formal modeling and shares enforcement with C_IFC's declassification mechanism."
- Unsafe claim: "RIINA has independently verified declassification policy guarantees."

## 4. Sign-Off
- Final verdict: **R2** (pending hostile review for potential R3 via C_IFC enforcement)

## 5. Hostile Review Reconciliation
- Reviewer: Codex GPT (OpenAI) — independent from Claude
- Review verdict: **INVALID** (audit rejected as written)
- Review maximum honest rating: **R2** (narrow claim only)
- Reconciled rating: **R2** (keep rating; remove R3 speculation; narrow claim)
- Rationale: Hostile review confirms R2 ceiling but rejects R3 speculation and finds the audit's claim scope too broad. Key issues: (1) `acts_for` is vacuous (equality or `exists authority > 0`, always satisfiable); (2) `Step_Declass` is a state no-op; (3) live toolchain only enforces narrow syntactic `declass_ok` witness, not principals/guards/budgets/audit/DP; (4) shipped domain example `declassify.rii` fails to parse at pinned snapshot; (5) docs claim proof-string audit logging that code does not implement; (6) QuantitativeDeclassification.v was missed by audit; (7) non-Coq lanes are generated/derived.
- Key findings accepted:
  - G6 fail: authority model vacuous, operational semantics is no-op
  - G7 fail: only narrow `declass_ok` enforced, no policy dimensions
  - G8 fail: shipped domain example is stale/broken
  - G13 fail: repo prose overclaims policy enforcement
  - R3 via C_IFC is not supported; remove all R3 language
- Remediation tracked in: `06_COORDINATION/remediation/Z_DECLASSIFICATION_POLICY/`
