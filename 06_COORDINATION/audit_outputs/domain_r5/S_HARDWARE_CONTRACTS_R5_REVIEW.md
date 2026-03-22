# Domain Audit Review: S_HARDWARE_CONTRACTS

## Verdict
reject

## Snapshot validation
- Branch: `main`
- Commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Validity: The review remains materially valid for this snapshot.
- Drift: Materially harmless (only tracking and audit files changed).

## Maximum honest rating
**R0**

## Gate review table
| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| G1 (Identity) | Pass | Pass | Agree | Domain ID and scope exist | Proceed |
| G2 (R1 Baseline) | Pass | Fail | Downgrade | `S001_HardwareContracts.v` proves tautologies on a constant `[]` trace model | Fails R1 |
| G3 (R2 Deepen) | Pass | Fail | Downgrade | `riina-compliance` has no hardware contract logic; typechecker has no enforcement | Fails R2 |
| G4 (R3 Realize) | Fail | Fail | Agree | No live backend integration | Blocks R3 |
| G5 (R4 Complete) | Fail | Fail | Agree | No complete coverage | Blocks R4 |
| G6 (R5 Multi-Prover) | Fail | Fail | Agree | Multi-prover ports are equally vacuous | Blocks R5 |
| G7 (R6 Hardware) | Fail | Fail | Agree | N/A | Blocks R6 |
| G8 (R7 Total) | Fail | Fail | Agree | N/A | Blocks R7 |
| G9 (Negative Tests) | Fail | Fail | Agree | No negative tests for domain | Fails depth |
| G10 (Vacuous Proofs) | Pass | Fail | Downgrade | `leakage ms ms' := []` makes all proofs trivially vacuous | Disqualifies formal evidence |
| G11 (FFI Security) | Fail | Fail | Agree | N/A | Blocks deployment |
| G12 (Public Claims) | Pass | Fail | Downgrade | Audit claims "shared compliance infrastructure" but this is false | Must retract claim |
| G13 (Safety & Bound) | Pass | Fail | Downgrade | Safe claim is still too generous given R0 state | Must revise claim |
| G14 (Remediation) | Fail | Fail | Agree | No remediation plan provided in audit | Blocks closure |

## Findings table
| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| CRITICAL | G10 | "56% reflexivity, MIXED" | Proofs are 100% vacuous. `leakage` is a constant `[]`. Most proofs are `reflexivity` or structural tautologies (`exact H`). | Downgrade formal evidence to R0. |
| CRITICAL | G3 | "riina-compliance provides shared implementation" | `riina-compliance` contains zero logic for `HardwareContracts`. The only mention of hardware is a string literal `hardware_input` for a DO178C rule. | Downgrade implementation evidence to R0. |
| MAJOR | G12 | Rating: R2 | No formal enforcement and no typechecker implementation. | Downgrade domain rating to R0. |

## Overclaim lines
- "Current rating: **R2**"
- "Coq is mixed (56% reflexivity)."
- "riina-compliance provides shared implementation."
- Safe claim: "Hardware contracts have partial formal modeling and shared compliance infrastructure, but no domain-specific enforcement."

## Missed evidence lines
- The audit completely missed that `leakage` is defined as a constant `[]`, rendering the entire `constant_time` modeling branch vacuous.

## Safe claim
"Hardware contracts are planned for future implementation but currently lack any formal enforcement or domain-specific logic."

## Unsafe claim
"Hardware contracts have partial formal modeling and shared compliance infrastructure." (Or any claim implying R1 or R2 status, verified guarantees, or current implementation.)

## Release condition
Block release. The domain is R0 and all claims of hardware contract verification must be stripped from public messaging.

## Next review advice
Re-audit only when a non-vacuous leakage model is defined and the `riina-compliance` or `riina-typechecker` crates contain actual `S_HARDWARE_CONTRACTS` code paths.