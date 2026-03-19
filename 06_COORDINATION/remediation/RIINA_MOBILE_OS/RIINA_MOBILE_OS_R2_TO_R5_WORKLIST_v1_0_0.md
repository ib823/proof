# RIINA_MOBILE_OS R2 To R5 Worklist v1.0.0

This worklist is gate-driven. `RIINA_MOBILE_OS` does not move upward because it has multiple Coq files and a primitive Rust crate. It moves upward only when bounded child domains become live, executable, and re-audited as passing.

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
| `G1` Canonical Identity | Partial | define one bounded child domain and authoritative files for it | bounded scope pack | research, formal, and implementation identity line up |
| `G2` Boundary Precision | Fail | write exact in-scope and out-of-scope boundaries | scope statement | world-replacing mobile-OS claims disappear |
| `G3` Workflow Inventory | Partial | enumerate valid and invalid workflows for the bounded child domain | workflow matrix | every claim maps to executable workflows |
| `G4` Threat and Failure Model | Partial | add abuse and failure states for the live slice | threat model and negative workflows | failure handling is explicit |
| `G5` Property Set | Partial | keep only live-bounded properties for the selected child domain | property matrix | every public property is tied to scope |
| `G6` Formal Model Depth | Partial | replace config-heavy proof emphasis with workflow or state-transition theorems | updated Coq files | proof depth matches the selected child domain |
| `G7` Toolchain Enforcement | Partial | bind the bounded child domain into real compiler/runtime behavior | AST/typechecker/runtime/codegen changes | invalid cases are rejected or trapped by the live toolchain |
| `G8` Executable Evidence | Partial | add canonical valid workflows | live examples and tests | bounded examples execute end-to-end |
| `G9` Adversarial Evidence | Fail | add invalid and adversarial workflows | negative tests and attack cases | live rejection evidence exists |
| `G10` Independent Evidence Honesty | Fail | remove generated/vacuous lanes from strong confidence claims | metrics/wording cleanup | proof counts stop inflating assurance |
| `G11` Observability and Auditability | Fail | add inspectable runtime evidence for the bounded slice | logs, receipts, or reports | third parties can inspect execution |
| `G12` Freshness and Reproducibility | Pass | preserve rerunnable commands | audit commands and CI | evidence remains reproducible |
| `G13` Public Claim Discipline | Fail | purge world-first mobile-OS rhetoric from current-state claims | wording updates | claims match the bounded state |
| `G14` Regression Immunity | Fail | add mobile-domain readiness gates | domain-specific CI checks | rating cannot silently drift |

## R2 -> R3

Required:
- one bounded mobile child domain exists as a live toolchain subsystem
- at least one valid workflow executes
- at least one invalid workflow is rejected

Do not claim `R3` if:
- the selected child domain is still only a formal file
- examples are still missing
- the implementation is still only standalone primitives or helper generators

## R3 -> R4

Required:
- workflow coverage is complete for the bounded child domain
- negative and adversarial tests exist
- runtime evidence is inspectable

Do not claim `R4` if:
- only happy-path examples exist
- scope boundaries remain implied
- observability is still missing

## R4 -> R5

Required:
- all `G1-G14` pass
- third-party reproduction is straightforward
- claims are exact and conservative
- regression gates prevent drift

Do not claim `R5` if:
- generated/vacuous lanes still inflate confidence
- public wording outruns implementation
- multiple mobile and OS concerns remain bundled into one vague umbrella claim

## Concrete Work Sequence

1. Freeze wording at the reviewer-safe `R2` claim.
2. Split the umbrella and choose `RIINA_MOBILE_OS_MOBILE_BRIDGES` as the first bounded child domain.
3. Bind bridge generation and validation into a live end-to-end workflow.
4. Rework Coq around the same slice.
5. Add valid and invalid executable mobile workflows.
6. Re-audit the child domain.
7. Revisit the umbrella only after multiple child domains mature.

## Final Rule

The fastest way to fake mobile-OS progress is to keep saying “world's first mathematically proven secure mobile operating system” while the live evidence is still bounded bridge generation plus primitive structs.

The fastest way to reach real `R5` is:
- one bounded child domain
- one explicit workflow family
- one deeper formal model tied to that workflow
- one executable positive and negative example suite
