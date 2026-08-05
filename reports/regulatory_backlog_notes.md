# Regulatory backlog notes (REQ-51)

*Recorded 2026-08-05. Companion to `reports/pci_dss_4_0_1_mapping.md`. Confirm every date and
scope reading with counsel before relying on it.*

## NIS2 (Directive (EU) 2022/2555) — profile ADDED

The `nis2` profile (13 rules) checks the compiler-checkable slice of the Art. 21(2)
risk-management measures: incident-handling audit trails (b), supply-chain/FFI boundaries (d),
secure development (e), cyber hygiene (g), cryptography policies (h), access control (i),
secured authentication (j), and availability (21(1)). Passing it is NOT NIS2 compliance:
governance (Art. 20), the 24 h/72 h/1-month CSIRT reporting ladder (Art. 23), and entity
registration are organisational. NIS2 is a **directive** — member-state transpositions vary and
several were still late as of the 2026-08-05 survey; the profile targets the directive text, not
any single transposition.

## EU AI Act Art. 50 — DEFERRED, deliberately, with rationale

The Digital Omnibus delayed the high-risk regime (Annex III → 2 Dec 2027, some obligations →
2 Aug 2028), so the near-term slice is only **Art. 50 transparency** (from 2 Aug 2026): disclose
to users that they interact with an AI system; mark synthetic content machine-readably.

**No profile is added, and that is the honest outcome, not an omission.** Art. 50's obligations
attach to what a deployed *product does at runtime* (its UI discloses; its outputs carry
provenance marks) — not to statically checkable properties of source code. A keyword rule over
identifiers like `chatbot`/`ai_response` would be exactly the kind of theatre the
checker-not-theorem rule prohibits: it could neither confirm disclosure happens nor detect its
absence. If RIINA later grows AI-facing stdlib surface (e.g. an LLM-call builtin), the right
enforcement is a **type-level obligation on that builtin** (a `Disclosed`/provenance-marked
return type), which would be a Gate-B-style enforcement rule with a Coq counterpart — tracked
here as the trigger condition, not built speculatively.

## Malaysia PDPA (Amendment) Act 2024 — profile REFRESHED

Two rules added to `pdpa` (18 → 20), targeting the Amendment's compiler-checkable changes:

- **`PDPA-2024-S4-BIO`** — biometric data reclassified as *sensitive* personal data: biometric
  identifiers (`biometric`, `biometrik`, `cap_jari`, `fingerprint`, `facial_data`, `wajah`)
  must be `Classify`-protected. The pre-refresh profile had **zero** biometric coverage.
- **`PDPA-2024-S12B`** — mandatory breach notification (new s.12B): a breach cannot be notified
  if security operations leave no audit trail, so classification operations must carry a `Write`
  (audit) effect in their continuation.

Out of compiler reach, recorded for completeness: the DPO appointment duty (s.12A), the
RM 1 m penalty ceiling, the data-portability right, and the cross-border transfer guideline
changes — all organisational.

## UK PSTI / EN 18031 — still backlog

Not touched this pass. PSTI's consumer-connectable-product duties (no default passwords,
disclosure policy, update transparency) partially overlap the `cra` profile's rules; EN 18031 is
the harmonised-standard route to them. Sequence behind any actual UK go-to-market need.
