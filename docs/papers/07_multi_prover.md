# Paper 7: Multi-Prover Verification Architecture for RIINA

## Abstract

We describe RIINA's multi-prover verification architecture, which uses
Coq (Rocq 9.1.1) as the primary proof assistant with cross-validation
in Lean 4 and Isabelle. This architecture increases assurance by verifying
critical properties in independent proof assistants with different trusted
computing bases. We present the methodology for translating proof obligations
across provers, maintaining consistency, and resolving discrepancies.

## Key Results

- **Multi-prover coverage**: Core type safety proven in Coq, cross-validated
  in Lean 4 for critical theorems.
- **Theorem: Value Conservation** — Total token value is conserved across
  transactions. Proven in Coq. Coq reference: `value_conservation`
- **Theorem: No Reentrancy** — Smart contract state is linear; reentrancy
  is impossible by construction. Coq reference: `no_reentrancy`
- **Theorem: Token Supply Invariant** — Sum of all balances equals total
  supply at all times. Coq reference: `token_supply_invariant`
- **Translation methodology**: Systematic approach to translating between
  Coq's Gallina, Lean 4's tactic language, and Isabelle's Isar.

## Prover Stack

| Prover | Role | Toolchain |
|--------|------|-----------|
| Coq (Rocq 9.1.1) | Primary — all core proofs | `02_FORMAL/coq/` |
| Lean 4 (v4.16.0) | Secondary — cross-validation | `02_FORMAL/lean/` |
| Isabelle | Tertiary — selected properties | `02_FORMAL/isabelle/` |

## Architecture

1. **Proof obligations** generated from RIINA source by `riinac verify`
2. **Primary verification** in Coq with full mechanization
3. **Cross-validation** of critical theorems exported to Lean 4
4. **Consistency checking** between prover outputs
5. **Discrepancy resolution** protocol when provers disagree

## Related Work (Sketch)

- Assaf et al. (2019) — Dedukti: a universal proof checker
- Keller & Werner (2010) — Importing HOL Light proofs into Coq
- Obua et al. (2006) — Importing HOL into Isabelle/HOL
- Müller et al. (2017) — Cross-verification of mathematical proofs

## Venue Target

**ITP** (International Conference on Interactive Theorem Proving)
or **CPP** (ACM SIGPLAN Conference on Certified Programs and Proofs)

## Source Files

- `02_FORMAL/coq/` — Primary Coq proofs
- `02_FORMAL/lean/` — Lean 4 cross-validation
- `02_FORMAL/isabelle/` — Isabelle stubs
- `06_COORDINATION/` — Cross-prover coordination
