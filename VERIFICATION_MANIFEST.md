# RIINA Verification Manifest
**Generated:** 2026-05-16T00:00:00Z
**Git SHA:** e4599e4b (pre-drift-correction tip; doc-only commit follows)
**Branch:** claude/assess-codebase-0PDOR
**Status:** PASS (Rust); INHERITED (Coq, Lean, others)

| Check | Status | Details |
|-------|--------|---------|
| Rust proto tests | PASS | 2,479 passed, 0 failed, 3 ignored |
| Rust tooling tests | PASS | 248 passed, 0 failed, 2 ignored |
| Clippy | PASS (inherited) | 0 warnings as of 2026-03-22 manifest |
| Coq build (`make`) | NOT RE-VERIFIED | Ephemeral container lacks Rocq/opam; last verified upstream 2026-03-22 |
| Lean build (`lake build RIINA`) | NOT RE-VERIFIED | Ephemeral container lacks elan; last verified upstream 2026-03-22 |
| Isabelle smoke (`RIINA_CORE`) | NOT RE-VERIFIED | Container lacks Isabelle |
| F* / TLA+ / Alloy / SMT smoke | NOT RE-VERIFIED | Container lacks respective toolchains |
| `scripts/update-proof-ledger.sh --check` | PASS | Ledger matches generated content |
| `scripts/audit-docs.sh` (content checks) | PASS | All metric cross-references current |

## Honest scope of "PASS"
- "PASS" lines are commands that were run in this session and exited 0.
- "INHERITED" or "NOT RE-VERIFIED" lines depend on toolchains absent from this ephemeral container; the project's compilation status for those is trusted from the upstream verification record (last 2026-03-22, git SHA 2d436b08) but was not re-proven here.
- A fresh session in a fully-provisioned environment should re-run the full Part 0 command set before relying on any non-Rust claim.
