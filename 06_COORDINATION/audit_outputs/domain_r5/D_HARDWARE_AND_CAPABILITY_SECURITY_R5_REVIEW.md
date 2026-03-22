# Domain Audit Review: Hardware and Capability Security

## Verdict
**Verdict:** reject

The audit fundamentally failed to inspect the content of the Coq proofs, accepting 255 vacuous theorems as "nontrivial." The Coq files (e.g., `HardwareSecurity.v`, `CapabilitySecurity.v`) consist entirely of theorems proving `True` via `trivial.` or simple tautologies of hardcoded boolean structures (e.g., `true = true`). Counting vacuous proof structures as "Formal Model Depth" is a severe defect that necessitates rejecting the audit and downgrading the domain's rating.

## Snapshot validation
- **Branch:** main
- **Commit:** `2d436b083b56005b101f18718a7bd0f0aab722e9`
- **Valid:** Yes
- **Drift:** No drift. HEAD matches the snapshot exactly.

## Maximum honest rating
**Maximum honest rating:** **R1**

The domain possesses research artifacts, a canonical scope, and placeholder code wrappers (`riina-os/src/capability.rs` provides basic Rust structures). However, because the entire formal modeling layer is mathematically vacuous and proves no actual system properties, the domain does not meet the requirements for R2 ("formally modeled").

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| `G1` Canonical Identity | Pass | Pass | Agree | Single domain folder and research docs exist. | None |
| `G2` Boundary Precision | Fail | Fail | Agree | Scope attempts to cover hardware attacks, software capabilities, CHERI, and TERAS OS simultaneously. | Blocker |
| `G3` Workflow Inventory | Fail | Fail | Agree | No executable workflow inventory exists. | Blocker |
| `G4` Threat and Failure Model | Partial | Partial | Agree | Abstract threat model exists in `HardwareSecurity.v`, but no compiler binding. | None |
| `G5` Property Set | Pass | Fail | **Downgrade** | The 255 "properties" are vacuous tautologies or `True` statements. They do not constitute a mathematically sound property set. | R2 Blocker |
| `G6` Formal Model Depth | Pass | Fail | **Downgrade** | The audit claims "nontrivial proofs", but inspection reveals proofs like `Theorem hw_001_spectre_v1_mitigated : ... -> True. Proof. intros. trivial. Qed.` and boolean tautologies. | R2 Blocker |
| `G7` Toolchain Enforcement | Fail | Fail | Agree | `capability.rs` is just a basic struct. The compiler enforces no hardware security or capability boundaries. | R3 Blocker |
| `G8` Executable Evidence | Fail | Fail | Agree | No capability workflows are executable in the toolchain. | R3 Blocker |
| `G9` Adversarial Coverage | Fail | Fail | Agree | No adversarial test coverage. | R3 Blocker |
| `G10` Evidence Honesty Across Prover Lanes | Pass | Fail | **Downgrade** | While non-Coq lanes are marked generated, the Coq lane itself is highly misleading, relying on 255 vacuous theorems. The audit failed to flag this. | Blocker |
| `G11` Observability and Auditability | Partial | Fail | **Downgrade** | You cannot meaningfully audit a formal trace that traces back to `True = True`. | Blocker |
| `G12` Freshness and Reproducibility | Pass | Pass | Agree | Command-derived counts technically match grep. | None |
| `G13` Public Claim Discipline | Not audited | Not audited | Agree | N/A | None |
| `G14` Regression Immunity | Partial | Fail | **Downgrade** | Vacuous proofs provide zero regression immunity. You cannot break a `trivial.` proof of `True` by changing system logic. | Blocker |

## Findings table

| Severity | Gate | Claim Under Dispute | Counter-evidence | Required Downgrade or Correction |
|----------|------|---------------------|------------------|----------------------------------|
| **Critical** | `G6` | "255 Coq Qed, zero Admitted, nontrivial proofs" | `HardwareSecurity.v` proves `True` for every theorem via `trivial.`. `CapabilitySecurity.v` proves `true = true` for hardcoded record fields. There are no nontrivial proofs. | Downgrade G6 to Fail. Change verdict to Reject. Downgrade rating to R1. |
| **High** | `G5` | "255 theorems covering unforgability, monotonicity, revocation, confinement, delegation, hardware attacks, CHERI bounds" | The theorems do not mathematically cover these properties; they are placeholders wrapped in valid Coq syntax. | Downgrade G5 to Fail. |
| **High** | `G10` | "Pass - All non-Coq lanes correctly marked as auto-generated" | The audit missed that the Coq evidence itself is vacuous and fundamentally misleading. | Downgrade G10 to Fail. |

## Overclaim lines
- "Nontrivial proofs"
- "255 theorems covering unforgability, monotonicity, revocation, confinement, delegation, hardware attacks, CHERI bounds"
- "Why this is R2 and not R1: Formal models exist and are nontrivial (255 Qed, zero Admitted). The models cover hardware attacks and capability theory at depth."
- Rating of R2.

## Missed evidence lines
- The actual definitions of the theorems in `02_FORMAL/coq/domains/HardwareSecurity.v` and others, which terminate by simply asserting and proving `True` (e.g., `Theorem hw_001_spectre_v1_mitigated : ... -> True. Proof. intros ... trivial. Qed.`).
- The reliance on boolean tautologies (e.g., `true = true`) in `CapabilitySecurity.v` and `TerasCapabilities.v`.

## Safe claim
"Hardware and capability security concepts have been specified in research, but lack formal verification, executable models, or enforcement in the RIINA compiler."

## Unsafe claim
"Hardware-verified", "CHERI-enforced", "capability-secured", "formally modeled", "hardware attack mitigation implemented", "proven unforgability".

## Release condition
1. Demote the domain to R1.
2. The Coq models must be completely rewritten to formalize actual state transitions, memory models, and semantic properties rather than just proving `True`.
3. Scope must be bound to a concrete implementation target (e.g., software capabilities) before attempting to claim R2 or R3.

## Next review advice
Never rely exclusively on grep counts for `Qed` and `Admitted`. Always open a sample of the `.v` files and read the theorem statements and proofs to ensure they are not vacuous. A theorem proving `True` is mechanically valid but practically meaningless.
