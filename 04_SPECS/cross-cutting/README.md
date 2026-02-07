# RIINA Cross-Cutting Specifications

**Audit Update:** 2026-02-06 (Session 78: Proof Depth 20+ All Files) — 7,929 Coq Qed + 91 Lean theorems + 102 Isabelle lemmas = 8,122 total proofs. 0 Admitted/sorry across all provers. 1 axiom (policy). 250 active .v, 11 .lean, 10 .thy. 86 triple-prover theorems. 849 Rust tests.

This directory contains cross-cutting concerns that span multiple industries and domains.

## Files

| File | Description |
|------|-------------|
| `EXHAUSTIVENESS_AUDIT.md` | Forensic audit of specification completeness |
| `SYNERGY_MATRIX.md` | Cross-industry synergy and reuse matrix |
| `PERFORMANCE_TEMPLATES.md` | Performance and size constraint templates |
| `UI_UX_TEMPLATES.md` | User interface and experience security templates |

## Purpose

These documents ensure:
- No gaps in security coverage across industries
- Maximum reuse of security patterns
- Consistent performance requirements
- Secure UI/UX patterns

## Integrity

All files are SHA-256 verified. See `../CHECKSUMS.sha256` for hashes.

---
*RIINA: Rigorous Immutable Invariant — Normalized Axiom*
