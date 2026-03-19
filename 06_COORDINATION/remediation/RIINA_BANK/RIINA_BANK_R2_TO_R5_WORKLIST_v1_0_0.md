# RIINA_BANK R2 To R5 Worklist v1.0.0

This worklist is gate-driven. `RIINA_BANK` does not move upward because it has one Coq file and many strong words. It moves upward only when bounded banking semantics, workflows, and evidence are re-audited as passing.

## Current Baseline

- Conservative umbrella rating: `R2`
- Conservative blocker gates:
  - `G2`
  - `G3`
  - `G4`
  - `G7`
  - `G8`
  - `G9`
  - `G10`
  - `G11`
  - `G13`
  - `G14`

## Gate-By-Gate Remediation

| Gate | Current State | Required Change | Required Artifact | Done When |
|------|---------------|-----------------|-------------------|-----------|
| `G1` Canonical Identity | Partial | define one bounded banking slice and authoritative files for it | bounded scope pack | research, formal, and implementation identity line up |
| `G2` Boundary Precision | Fail | write explicit in-scope and out-of-scope statements | scope statement | absolute banking-platform wording disappears |
| `G3` Workflow Inventory | Partial | enumerate valid and invalid workflows for the bounded slice | workflow matrix | every claim maps to an executable workflow |
| `G4` Threat and Failure Model | Partial | add abuse, failure, and recovery states for the live slice | threat model and negative workflows | runtime failure handling is explicit |
| `G5` Property Set | Partial | keep only slice-relevant properties in the active claim surface | property matrix | every public property is live-bounded |
| `G6` Formal Model Depth | Partial | strengthen proofs for the bounded live slice | updated Coq files | structural proof depth outweighs shallow unfold proofs |
| `G7` Toolchain Enforcement | Fail | add banking data types and semantics to the compiler/runtime | AST/parser/typechecker/runtime/codegen changes | the compiler understands the bounded banking slice |
| `G8` Executable Evidence | Fail | add canonical valid workflows | live examples and tests | bounded banking examples execute |
| `G9` Adversarial Evidence | Fail | add invalid and adversarial banking workflows | negative tests and attack cases | live rejection evidence exists |
| `G10` Independent Evidence Honesty | Fail | remove generated/vacuous lanes from strong confidence claims | metrics/wording cleanup | proof counts stop being inflated by placeholder lanes |
| `G11` Observability and Auditability | Fail | add inspectable runtime evidence for the slice | logs, receipts, or reports | third parties can inspect execution/evidence |
| `G12` Freshness and Reproducibility | Pass | preserve rerunnable commands | audit commands and CI | evidence remains reproducible |
| `G13` Public Claim Discipline | Fail | purge absolute obsolescence language | wording updates | claims match the bounded state |
| `G14` Regression Immunity | Fail | add bank-specific readiness gates | domain-specific CI checks | rating cannot silently drift |

## R2 -> R3

Required:
- one bounded live banking slice exists
- at least one valid workflow executes
- at least one invalid workflow is rejected

Do not claim `R3` if:
- banking is still only a proof file
- examples are still absent
- the compiler still has no banking types

## R3 -> R4

Required:
- workflow coverage is complete for the stated slice
- negative and adversarial tests exist
- runtime evidence is inspectable

Do not claim `R4` if:
- only happy-path examples exist
- no evidence chain exists
- major slice boundaries remain implied

## R4 -> R5

Required:
- all `G1-G14` pass
- third-party reproduction is straightforward
- claims are exact and conservative
- regression gates prevent drift

Do not claim `R5` if:
- generated/vacuous lanes still inflate confidence
- marketing language outruns implementation
- banking modules remain bundled under one vague umbrella

## Concrete Work Sequence

1. Freeze wording at the reviewer-safe `R2` claim.
2. Pick `RIINA_BANK_LEDGER_AND_DEPOSITS` or `RIINA_BANK_PAYMENTS_AND_SETTLEMENT` as the first live slice.
3. Add the bounded slice to the toolchain.
4. Rework Coq around that same slice.
5. Add valid and invalid executable workflows.
6. Re-audit `RIINA_BANK`.

## Final Rule

The fastest way to fake banking progress is to keep adding theorem names and market-obsolescence rhetoric while the compiler still cannot represent an account or a ledger entry.

The fastest way to reach real `R5` is:
- one bounded live banking slice
- one explicit workflow family
- one deeper formal model tied to that slice
- one executable example suite
