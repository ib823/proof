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

---

# LLM proof-automation evaluation note (REQ-52a)

*Scope: whether to adopt LLM-assisted proving for the 12,646-Qed Rocq corpus and the Phase-10
LLM proof pipeline, and what to evaluate before building anything bespoke. Recorded 2026-08-05;
tool landscape from the 2026-08-05 survey.*

## Landscape (as surveyed)

- **LLM4Rocq / Strat2Rocq** — LLM lemma discovery feeding CoqHammer's hammer loop (Strat2Rocq
  reports ≈ +13.4 % solved goals by extracting LLM-found lemmas into the hammer's library).
- **PALM / ProofAug** — proof *repair*: take a broken proof script and patch it, which is the
  workload a 12k-Qed corpus actually has (refactors breaking downstream proofs), not greenfield
  theorem proving.
- **Lean side (LeanDojo, Lean Copilot)** — more mature, but RIINA's mechanized lane is Rocq and
  REQ-29 retracted the multi-prover claim; adopting Lean tooling would re-open that decision.

## Verdict: EVALUATE-BEFORE-BUILD, and not in this environment

1. **Do not build a bespoke Phase-10 pipeline first.** The survey's point stands: this is now a
   tool category, not a research project. The Phase-10 "LLM proof pipeline" item should begin as
   an evaluation of LLM4Rocq/Strat2Rocq/PALM against a frozen sample of RIINA's own proof
   obligations (e.g. 50 lemmas from `domains/`, 20 from `properties/`), measuring solve/repair
   rate and — critically — that outputs pass RIINA's own gates (0 Admitted/Axiom, warning budget).
2. **This container cannot run the evaluation.** These tools ship from GitHub (egress 403 — the
   same boundary as the REQ-50 spike) and need model API access. The evaluation is a
   host-machine task; the harness for it (frozen lemma sample + gate check) can be prepared
   in-repo when Phase 10 opens.
3. **Trust boundary stays unchanged.** Any adopted tool's output is untrusted input to `rocq`;
   acceptance remains "the kernel checked it", so no claim level moves by adopting one — only
   throughput. This is worth stating because "AI-assisted proofs" is a claims hazard: the
   assistant is a *search* strategy, never part of the TCB.

# JALINAN-vs-Kalas claims correction (REQ-52b) — APPLIED

Three public documents claimed choreography deadlock-freedom without stating the level at which
RIINA proves it. All three now carry the precise scope, and cite Kalas as the stronger prior art:

- `docs/JALINAN_GUIDE.md` — "deadlock-free by construction" now says: theorems are mechanized in
  Coq over the session calculus; the compiler's projection *mirrors* those definitions and is not
  a verified compiler; per-statement channel-operation checking does not exist yet.
- `docs/papers/04_session_types.md` — abstract gains an explicit scope block: "mechanized
  calculus + mirroring implementation, not verified compilation", citing Kalas (ITP 2022,
  end-to-end verified compiler to CakeML with verified endpoint projection) and hacc.
- `docs/UNDERSTANDING_RIINA.md` Track X — same qualification, pointing to the paper for scope.

This is the same honesty pattern as the REQ-47 verification boundary: say exactly what is
machine-checked, name what is merely mirrored, and cite the work that sets the higher bar.
