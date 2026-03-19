# RIINA_CAPITAL_MARKETS R2 To R5 Worklist v1.0.0

This worklist is gate-driven. `RIINA_CAPITAL_MARKETS` does not move upward because it has one formal file and a large research manifesto. It moves upward only when bounded live trading semantics, workflows, and evidence are re-audited as passing.

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
| `G1` Canonical Identity | Partial | define one bounded capital-markets slice and authoritative files for it | bounded scope pack | research, formal, and implementation identity line up |
| `G2` Boundary Precision | Fail | write explicit in-scope and out-of-scope statements | scope statement | global trading-platform claims disappear |
| `G3` Workflow Inventory | Partial | enumerate valid and invalid workflows for the bounded slice | workflow matrix | every claim maps to an executable workflow |
| `G4` Threat and Failure Model | Partial | add abuse and failure states for the live slice | threat model and negative workflows | failure handling is explicit |
| `G5` Property Set | Partial | keep only slice-relevant active properties | property matrix | every public property is live-bounded |
| `G6` Formal Model Depth | Partial | deepen proofs for the bounded live slice | updated Coq files | structural proof depth outweighs shallow lemmas |
| `G7` Toolchain Enforcement | Fail | add order/trade/settlement semantics to the compiler/runtime | AST/parser/typechecker/runtime/codegen changes | the compiler understands the bounded slice |
| `G8` Executable Evidence | Fail | add canonical valid workflows | live examples and tests | bounded examples execute |
| `G9` Adversarial Evidence | Fail | add invalid and adversarial trading workflows | negative tests and attack cases | live rejection evidence exists |
| `G10` Independent Evidence Honesty | Fail | remove generated/vacuous lanes from strong confidence claims | metrics/wording cleanup | proof counts stop being inflated |
| `G11` Observability and Auditability | Fail | add inspectable runtime evidence for the slice | logs, receipts, or reports | third parties can inspect execution |
| `G12` Freshness and Reproducibility | Pass | preserve rerunnable commands | audit commands and CI | evidence remains reproducible |
| `G13` Public Claim Discipline | Fail | purge exchange-obsolescence language | wording updates | claims match the bounded state |
| `G14` Regression Immunity | Fail | add capital-markets readiness gates | domain-specific CI checks | rating cannot silently drift |

## R2 -> R3

Required:
- one bounded live capital-markets slice exists
- at least one valid workflow executes
- at least one invalid workflow is rejected

Do not claim `R3` if:
- the compiler still has no order or trade types
- examples are still absent
- the domain is still only a formal model

## R3 -> R4

Required:
- workflow coverage is complete for the stated slice
- negative and adversarial tests exist
- runtime evidence is inspectable

Do not claim `R4` if:
- only happy-path formal examples exist
- major slice boundaries remain implied
- observability is still absent

## R4 -> R5

Required:
- all `G1-G14` pass
- third-party reproduction is straightforward
- claims are exact and conservative
- regression gates prevent drift

Do not claim `R5` if:
- generated/vacuous lanes still inflate confidence
- public wording outruns implementation
- multiple capital-markets concerns remain bundled under one vague umbrella

## Concrete Work Sequence

1. Freeze wording at the reviewer-safe `R2` claim.
2. Pick `RIINA_CAPMARKET_ORDERBOOK_CORE` or `RIINA_CAPMARKET_TRADE_AND_SETTLEMENT` as the first live slice.
3. Add the bounded slice to the toolchain.
4. Rework Coq around that same slice.
5. Add valid and invalid executable workflows.
6. Re-audit `RIINA_CAPITAL_MARKETS`.

## Final Rule

The fastest way to fake capital-markets progress is to keep publishing exchange-replacement rhetoric while the compiler still cannot represent an order or a trade.

The fastest way to reach real `R5` is:
- one bounded live capital-markets slice
- one explicit workflow family
- one deeper formal model tied to that slice
- one executable example suite
