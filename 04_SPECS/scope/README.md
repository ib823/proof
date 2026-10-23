# RIINA Scope Specifications

**Verification:** Coq 1,679 core Qed, 9,719 model Qed, 1,443 excluded Qed (vacuous, example, counterexample or test); 0 Admitted, 0 `Axiom`, 29 `Parameter`s (trusted interface) — Coq is the only fully mechanized lane | 3659 Rust tests | other lanes: a scoped Z3 set and smoke artifacts (generated mirrors archived 2026-10-20; claim levels in metrics.json)

This directory contains the definitive scope and architecture documents for the RIINA project.

## Files

| File | Description |
|------|-------------|
| `RIINA_DEFINITIVE_SCOPE.md` | Definitive project scope and boundaries |
| `RIINA_ARCHITECTURE_CORRECTED.md` | Corrected architecture specification |
| `RIINA_RESEARCH_EXECUTION_MAP.md` | Research track execution roadmap |

## Purpose

These documents define:
- What RIINA includes and excludes
- The architectural foundations
- How research tracks map to implementation

## Integrity

All files are SHA-256 verified. See `../CHECKSUMS.sha256` for hashes.

---
*RIINA: Rigorous Immutable Invariant — Normalized Axiom*
