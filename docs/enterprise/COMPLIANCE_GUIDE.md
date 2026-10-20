# RIINA Compliance Checking — User Guide

`riinac check --compliance` runs heuristic rules over a program and reports what
it finds, profile by profile. The result is **evidence toward a standard**: it is
not a conformity assessment, a certification, or a substitute for an auditor.
No independent audit of RIINA has been published.

Every number below is generated or checked by `scripts/check-doc-drift.sh`;
`riinac check --list-compliance` is the authoritative list.

## What is always checked, with or without a profile

These come from the type checker itself, so every program gets them. Each is
**enforced by the compiler and tested** (positive and negative tests); none is
proven to match the Coq model. The claim level of each property is in
[PROPERTY_LEDGER.md](../../PROPERTY_LEDGER.md).

- **Effects:** a function that does more than its `kesan` declaration allows is
  rejected.
- **Secrets:** a `Rahsia<T>` value cannot reach a print, network or file sink;
  `dedah` with a proof is the only exit.
- **Taint:** data read from a file or the user is `Tercemar` and cannot reach a
  sensitive sink (SQL, a file path) until sanitized.
- **Capabilities:** at run time, an effect the program was not granted is refused
  (interpreter and native C; the WASM gate is not built yet).

## The compliance profiles

There are 19 profiles with 606 heuristic rules in total. List them with:

```bash
riinac check --list-compliance
```

The profiles are `pci-dss`, `pdpa`, `bnm`, `hipaa`, `cmmc`, `sox`, `gdpr`,
`do-178c`, `iec-62443`, `nerc-cip`, `fda-21cfr`, `iso-27001`, `nist-800-53`,
`mas-trm`, `itar`, `esg-sdg`, `cra`, `dora` and `nis2`. The per-profile rule
counts are in `website/public/metrics.json` (`compliance.perProfile`).

A rule is a pattern check over the elaborated program: a name that looks like a
credential bound to a literal, a sensitive value sent over the network unsanitized,
a recursive function with no base case, a broad capability grant, and so on. That
makes the rules **heuristics**. They can miss a real problem (a false negative)
and can flag code that is fine (a false positive). Which rules are fully
implemented, partial or keyword-only is tracked as REQ-123.

## Running a check

```bash
# One profile, or several (comma-separated)
riinac check --compliance hipaa app.rii
riinac check --compliance hipaa,pci-dss app.rii

# A report: text, or JSON for tools
riinac check --compliance hipaa --report app.rii
riinac check --compliance hipaa --report-json app.rii
riinac check --compliance hipaa --report-json --report-output report.json app.rii
```

With `--report-json` the report is the only thing written to stdout, so it can be
piped straight into another tool.

The exit code is `1` when any rule of error severity fires; warnings alone do not
fail the check.

## The report

This is real output for a small program that writes a record to a file:

```
════════════════════════════════════════════════════════════════════════
  RIINA COMPLIANCE REPORT
════════════════════════════════════════════════════════════════════════
  Compiler:    RIINA v0.4.0
  File:        rekod.rii
  SHA-256:     b385515ce2672933abbda18e3be0d6f1e465319b909014efa8e0e1436264222c
  Timestamp:   2026-10-20T09:39:05Z
  Verdict:     PASS
────────────────────────────────────────────────────────────────────────
  Rules checked: 33   Violations: 0   Errors: 0   Warnings: 0
────────────────────────────────────────────────────────────────────────

  PROFILE: HIPAA: US Health Insurance Portability and Accountability Act
  Coverage: 33/54 rules (61.1%)
  Status: CLEAN — no violations

════════════════════════════════════════════════════════════════════════
  This report is a machine-generated audit artifact.
  Its rules are heuristic checks: evidence toward each profile,
  not a conformity assessment or certification.
  Verify integrity: sha256sum <source_file> == b385515ce2672933abbda18e3be0d6f1e465319b909014efa8e0e1436264222c
════════════════════════════════════════════════════════════════════════
```

- **Verdict:** `FAIL` if any error-severity rule fired, `PASS_WITH_WARNINGS` if
  only warnings did, `PASS` otherwise.
- **Coverage:** the rules RIINA implements for the profile, out of the number of
  requirements the project catalogued for it. The denominator is RIINA's own
  catalogue, not an official count from the standard.
- **SHA-256:** the hash of the exact source checked, so a reviewer can confirm the
  report belongs to the file in front of them.

The JSON report carries the same fields: `riina_version`, `file`,
`source_sha256`, `timestamp`, `verdict`, the totals, and one entry per profile
with `rules_implemented`, `rules_total`, `coverage_pct` and its `violations`.

## The Coq compliance files

`02_FORMAL/coq/compliance/` and `02_FORMAL/coq/Industries/` hold Coq models of
regulations. They prove facts **about their own definitions**; they are not
proofs that any program complies, and the compliance rules above are not derived
from them. The project counts them as model Qed, never as core results.
[HEADLINE_THEOREMS.md](../../HEADLINE_THEOREMS.md) lists the only theorems a public
surface may cite as guarantees.

## Reproducing a report

1. Build the compiler from source: `cd 03_PROTO && cargo build --release`.
2. Run the same command on the same file and compare the SHA-256 in the report.
3. Read the rules: `03_PROTO/crates/riina-compliance/src/rules.rs`, with positive
   and negative tests in `03_PROTO/crates/riina-compliance/src/tests.rs`.
4. To re-check the Coq lane: `riinac verify --coq`.

## Adding a rule

Rules live in `03_PROTO/crates/riina-compliance/src/rules.rs`. Each has an id, a
profile, a description and a check over the elaborated program. Add a positive
and a negative test in `tests.rs`, and update `rule_count` for the profile: the
test `rule_count_matches_actual` fails if the count and the rule list disagree.
The language surface is frozen (REQ-108), so a new profile needs an owner
decision.

## Related documentation

- [COMPLIANCE_PACKAGING.md](COMPLIANCE_PACKAGING.md) — what to hand a reviewer
- [CERTIFICATION.md](CERTIFICATION.md) — why RIINA issues no certificate
- [PROPERTY_LEDGER.md](../../PROPERTY_LEDGER.md), [TRUSTED_BASE.md](../../TRUSTED_BASE.md)
