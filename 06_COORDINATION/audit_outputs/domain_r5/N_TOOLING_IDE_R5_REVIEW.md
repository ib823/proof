# Domain N_TOOLING_IDE R5 Adversarial Review

## Verdict
`accept with reductions`

## Snapshot validation
- Branch: `main`
- Commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Snapshot valid: Yes.
- Drift: Materially harmless (unstaged audit, prompt, and script files only).

## Maximum honest rating
**R1** (Downgraded from R2).
*Justification*: The audit correctly identified that the Coq layer is 100% vacuous (reflexivity, trivial `True` definitions, simple unfolding). However, the audit incorrectly awarded an R2 rating. According to `DOMAIN_R5_CHECKLIST_v1_0_0.md`, promotion to R2 strictly requires: "Theorems are nontrivial and domain-relevant." Because the formal model is entirely trivial and vacuous, the domain fails the prerequisites for R2. Live implementation without a nontrivial formal model caps the overall rating at R1.

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| `G1` | Pass | Pass | Agree | `RESEARCH_DOMAIN_N_COMPLETE.md`, `RESEARCH_N01_TOOLING_IDE_SURVEY.md` exist. | Domain canonically identified. |
| `G2` | Partial | Partial | Agree | Boundary spans LSP, formatting, build, package manager, but specs combine them loosely. | Boundary imprecise. |
| `G3` | Not Rated | Fail | Downgrade | No formal workflow tracking or matrix for the tooling. | Fails workflow depth. |
| `G4` | Not Rated | Fail | Downgrade | Missing explicit threat models (e.g. malicious LSP payloads, supply chain attacks on formatting) in the formal level. | Fails threat model. |
| `G5` | Fail | Fail | Agree | Properties are `True` or identity. | Vacuous properties. |
| `G6` | Fail | Fail | Agree | `ToolingIDE.v` contains 20 identity/trivial proofs and 1 trivial termination lemma. TLA+ contains 38 placeholder `== TRUE` definitions. | Formal model is cosmetic. Blocks R2. |
| `G7` | Pass | Pass | Agree | `riina-lsp` and `riina-fmt` have functioning syntax and analysis logic. | Real implementation. |
| `G8` | Pass | Pass | Agree | 34 cargo tests pass across both crates. | Code is executable. |
| `G9` | Partial | Partial | Agree | `capability_violation` test exists for LSP, but no adversarial/malformed tests for formatter. | Weak adversarial coverage. |
| `G10` | Not Rated | Fail | Downgrade | TLA+ file `ToolingIDE.tla` claims 21 invariants derived from Coq but is entirely placeholder `== TRUE`. | Fails evidence honesty across lanes. |
| `G11` | Not Rated | Partial | New | Tests and Coq files are visible, but traceability between research and code is informal. | Observability weak. |
| `G12` | Not Rated | Pass | New | Cargo tests run and reproduce reliably. | Reproducible. |
| `G13` | Not Rated | Partial | New | Audit proposed safe claim, but missing R1 qualification. | Need stricter claim. |
| `G14` | Not Rated | Fail | New | Vacuous formal proofs cannot act as regression tests for any actual property. | Zero formal regression immunity. |

## Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| High | `G6` | "R2 rating" | `DOMAIN_R5_CHECKLIST_v1_0_0.md` requires nontrivial theorems for R2. All 21 proofs in `ToolingIDE.v` are reflexivity, `True`, or trivial inductions. | Downgrade rating from R2 to R1. |
| Medium | `G10` | N/A (Missing from audit) | `02_FORMAL/tlaplus/RIINA/Domains/ToolingIDE.tla` contains 38 placeholder definitions (e.g., `semantically_equivalent(a, b) == TRUE`) masking as formal evidence. | Add G10 Fail to the audit record. |
| Low | `G9` | "LSP has capability_violation test" | The test exists but only checks standard parse error and one specific policy violation. Not heavily fuzz/adversarially tested. | Keep as Partial, but note the lack of depth. |

## Overclaim lines
- "Current rating: **R2**" (The evidence only supports R1 due to R2's strict requirement for nontrivial theorems).
- "Sign-Off: R2 — Implementation real, Coq vacuous" (Contradictory to the R-level definitions).

## Missed evidence lines
- The audit accurately counted the 34 tests and the vacuous nature of the Coq proofs, though it slightly miscounted theorems (20 `Theorem` + 1 `Lemma` = 21).
- The audit missed the completely placeholder TLA+ file `ToolingIDE.tla` which falsely claims to verify invariants.

## Safe claim
"IDE tooling with LSP server and code formatter implemented and tested, but entirely lacking formal verification (R1)."

## Unsafe claim
"Formally verified IDE tooling", "Verified LSP", "Formally modeled tooling" (because the model is vacuous).

## Release condition
- Do not release any claims of formal verification for the tooling domain.
- Fix the rating to R1.
- Erase or flag the placeholder TLA+ file.

## Next review advice
Before upgrading this domain past R1, genuine security properties of the tooling (e.g., that the LSP server cannot leak capabilities, or that the formatter preserves AST semantics) must be mechanically verified with non-trivial proofs in Coq or another prover, rather than simply returning `True`.