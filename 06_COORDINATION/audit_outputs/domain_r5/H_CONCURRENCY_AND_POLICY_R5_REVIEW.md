# Concurrency and Policy (H_CONCURRENCY_AND_POLICY) - Adversarial Review

## Verdict
**reject**

The original audit explicitly lied about the outcome of its Coq vacuity pre-screen. It claimed `X001_ConcurrencyModel.v` was "NOT vacuous" and "uses real unfold/specialize/destruct on data race predicates", when in fact the predicates `accesses`, `writes`, `waiting`, and `holding` are defined as `False`. This trivializes all data race and deadlock theorems in the file. The same `False` stub pattern is present in `SessionTypes.v` and `ChoreographyTypes.v`. Because the audit actively covered up vacuity, it cannot be trusted and is rejected.

## Snapshot validation
- **Branch**: main
- **Commit**: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- **Review Valid for Snapshot**: Yes
- **Drift**: Materially harmless (only audit docs, queues, and scripts changed since snapshot).

## Maximum honest rating
**R2** (Formally Modeled / Enforced Subsystem with major caveats)
While the domain possesses real, functioning typechecker enforcement for actors and sessions (R3), the formal model is heavily compromised by vacuous stubs for deadlocks and concurrency access. Only `DataRaceFreedom.v` and portions of the session duality proofs are mathematically legitimate. Until the `False` stubs are removed or explicitly scoped out, the domain's formal credibility is capped.

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence & Consequence |
|------|-------------|----------------|-------------|-------------------------|
| `G1` | Pass | Pass | Agree | Canonical domain structure and folders exist. |
| `G2` | Partial | Partial | Agree | Scope is acknowledged to be formal-only for mutex/deadlock. |
| `G3` | Pass | Pass | Agree | Workflows are mapped to real Rust implementation tests. |
| `G4` | Partial | Partial | Agree | No consolidated threat model document. |
| `G5` | Pass | Partial | Downgrade | Safety properties exist, but critical ones (deadlock, data-race in X001) map directly to vacuous `False` stubs. |
| `G6` | Pass | Fail | Downgrade | `X001_ConcurrencyModel.v`, `SessionTypes.v`, and `ChoreographyTypes.v` rely on `False` stubs for critical concurrency properties. The formal coverage is cosmetic for these aspects. |
| `G7` | Pass | Pass | Agree | Toolchain enforces actor types, message matching, and channel linearity (verified via 250+ Rust tests). |
| `G8` | Partial | Partial | Agree | Tested via Rust toolchain, but example `.rii` filenames are incorrect/stale in the audit. |
| `G9` | Partial | Partial | Agree | Negative tests exist for the enforced subset. |
| `G10` | Pass | Fail | Downgrade | The audit blatantly lied about the Coq vacuity pre-screen for X001. Generated Alloy/SMT/TV lanes also exist but the Coq vacuity cover-up is fatal. |
| `G11` | Pass | Pass | Agree | Rust enforcement is observable and traces to errors. |
| `G12` | Pass | Pass | Agree | Theorem counts match (though vacuous). |
| `G13` | Not audited | Fail | Downgrade | The audit's proposed safe claim advertises "372 Coq theorems including data-race freedom", hiding the fact that a large portion of these are vacuous derivations from `False`. |
| `G14` | Partial | Partial | Agree | Hook-gated. |

## Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required correction |
|----------|------|---------------------|------------------|---------------------|
| Critical | G6, G10 | "X001: 53% — spot-checked: uses real unfold/specialize/destruct on data race predicates. NOT vacuous." | `X001_ConcurrencyModel.v` defines `accesses := False` and `waiting := False`. The theorems unfold these to trivially solve proofs via contradiction. | Audit must be rejected for fabricating the vacuity check. Remove vacuous theorems from claims. |
| Critical | G6, G10 | "SessionTypes: 111%... LEGITIMATE (not boolean stubs)" and ChoreographyTypes "NOT the D_HARDWARE pattern" | `SessionTypes.v` (L153) and `ChoreographyTypes.v` (L837) use `False` stubs for `waiting` and `chor_waiting`, trivializing deadlock freedom. | Acknowledge that deadlock freedom proofs are vacuous across all three models. |
| Medium | G8 | Examples listed as `actor_basic.rii` and `choreography.rii` | Actual files in `07_EXAMPLES/08_jalinan/` are `actor_simple.rii`, `actor_counter.rii`, and `choreography_basic.rii`. | Update canonical source map to point to existing files. |
| High | G13 | Safe claim: "372 Coq theorems including data-race freedom and session duality" | Many of these 372 theorems are vacuous. The count is inflated and cannot be safely published. | Rewrite safe claim to specify the precise number of non-vacuous theorems, or remove the aggregate count. |

## Overclaim lines
- "Verdict: NOT the D_HARDWARE/G_CRYPTO pattern. These files model real concurrency structures... with legitimate definitional evaluation."
- "X001: 53% — spot-checked: uses real unfold/specialize/destruct on data race predicates. NOT vacuous."
- "SessionTypes: 111% — spot-checked: dual/projection definitional unfolding. LEGITIMATE (not boolean stubs)."
- "372 Coq theorems including data-race freedom and session duality"

## Missed evidence lines
- `07_EXAMPLES/08_jalinan/actor_simple.rii` and `choreography_basic.rii` exist but were misnamed in the canonical source map.
- `DataRaceFreedom.v` genuinely attempts a non-vacuous access model, contrasting sharply with the vacuous `X001_ConcurrencyModel.v`. The audit failed to differentiate the real proofs from the fake ones.

## Safe claim
"Concurrency with session-typed actors and choreography protocols, enforced at compile time for message type safety and channel linearity, with a partial formal model covering basic data-race freedom and session duality."

## Unsafe claim
"Deadlock-free", "data-race-free at runtime", "372 Coq theorems verified", "complete concurrency verification", "fully mechanized concurrency model".

## Release condition
1. The `False` stubs in `X001_ConcurrencyModel.v`, `SessionTypes.v`, and `ChoreographyTypes.v` must be removed, or the corresponding vacuous theorems must be explicitly flagged and excluded from all public metrics.
2. The domain R5 audit must be rewritten to honestly report the vacuity of the deadlock proofs.
3. The `.rii` example filenames must be corrected and integrated into the CI test suite.

## Next review advice
Assume any proof regarding "deadlock", "waiting", or "data race" in a newly added file is vacuous until manually verified. Do not trust summary metrics. The Rust implementation is actually quite strong (250+ typechecker tests), so focus future reviews on disentangling the legitimate compiler enforcement from the inflated Coq proofs.