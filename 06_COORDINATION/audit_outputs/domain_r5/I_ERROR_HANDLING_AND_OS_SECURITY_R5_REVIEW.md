# Domain Audit Review: I_ERROR_HANDLING_AND_OS_SECURITY

## Verdict
reject

## Snapshot validation
- Branch: `main`
- Commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Valid: Yes
- Drift: Materially harmless (only audit docs and tracker files modified since snapshot).

## Maximum honest rating
R2 - The domain has working implementation and tests for injection prevention, but the formal Coq models are a mix of heavily disconnected toy abstractions and outright vacuous boolean stubs.

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| G1 | Pass | Pass | Agree | Domain exists with 2 research docs. | None |
| G2 | Partial | Partial | Agree | Scope covers injection and OS security, with split enforcement. | None |
| G3 | Partial | Partial | Agree | Workflows split between tested implementation and formal-only models. | None |
| G4 | Partial | Partial | Agree | No consolidated threat model document. | None |
| G5 | Pass | Partial | Downgrade | The 169 theorems exist, but several files (`TerasSecurity.v`, `SQLInjectionPrevention.v`) are entirely vacuous boolean record stubs. The remaining files (`InjectionPrevention.v`, `VerifiedMicrokernel.v`, `PSI001_OperationalSecurity.v`) are highly abstract toy models completely disconnected from the implementation. | Theorem counts are highly misleading. |
| G6 | Pass | Fail | Downgrade | The audit explicitly claims "Reflexivity is from finite-type case analysis and definitional unfolding, not boolean record stubs." This is mathematically false. `TerasSecurity.v` and `SQLInjectionPrevention.v` define records of `true` booleans and prove them equal to `true` using reflexivity. This is the textbook definition of boolean record stubs. | Vacuity check failed to catch obvious stubs. |
| G7 | Pass | Pass | Agree | Rust tests show taint tracking and sanitizer mismatch enforcement. | None |
| G8 | Partial | Partial | Agree | 44 Rust tests exist, but `.rii` examples are not tested. | None |
| G9 | Pass | Pass | Agree | Negative tests exist for injection and CSRF flows. | None |
| G10 | Pass | Pass | Agree | Non-Coq lanes correctly identified as auto-generated. | None |
| G11 | Pass | Partial | Downgrade | Error codes trace to abstract concepts, but the formal Coq rules they trace to are toy models not mathematically linked to the AST. | Cannot claim full formal error mapping. |
| G12 | Pass | Pass | Agree | Derived from correct commands. | None |
| G13 | Not audited | Not audited | Agree | | None |
| G14 | Partial | Partial | Agree | Hook-gated. | None |

## Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| Critical | G6 | "Reflexivity is from finite-type case analysis and definitional unfolding, not boolean record stubs." | `TerasSecurity.v` (Theorems TS_001-TS_035) and `SQLInjectionPrevention.v` (Theorems SQLI_001-SQLI_015) rely heavily on boolean records where every field is `true` and the proof is `reflexivity. Qed.` | Downgrade G6 to Fail. The vacuity check was either bypassed or hallucinated. |
| High | G5 | "169 theorems covering injection safety, label noninterference, microkernel isolation" | The theorems are split between vacuous boolean stubs and highly abstract toy models that have zero mechanical linkage to the `riina-typechecker` AST or implementation. | Downgrade G5 to Partial. Explicitly state the disconnect. |
| Medium | G11 | "Error codes trace to Coq rules" | Coq rules are abstract lists of `SQLPart` and `TaintedValue`, lacking any formal mapping to the actual compiler AST. | Downgrade G11 to Partial. |

## Overclaim lines
- "Vacuity pre-screen (3-pattern check): ... Verdict: NOT vacuous. Reflexivity is from finite-type case analysis and definitional unfolding, not boolean record stubs."
- "169 Qed, 0 Admitted, nontrivial (3-pattern vacuity pre-screen passed)"

## Missed evidence lines
- The review missed the explicit boolean stub patterns in `TerasSecurity.v` and `SQLInjectionPrevention.v`.
- The review missed the structural disconnect between `InjectionPrevention.v` (which uses toy `list nat` ASTs) and the actual Rust typechecker.

## Safe claim
"Error handling and injection prevention enforced in toolchain via taint tracking and sanitizer matching, supported by abstract formal models of OS security and injection principles."

## Unsafe claim
"OS-level security formally enforced", "Microkernel formally verified", "SQL injection prevention mathematically proven in compiler", "Zero vacuous proofs in security models."

## Release condition
1. Rewrite `TerasSecurity.v` and `SQLInjectionPrevention.v` to use actual structural proofs rather than boolean record stubs, or remove them from the formal evidence count.
2. Formally link the abstract `InjectionPrevention.v` models to the actual AST used in `riina-typechecker`.
3. Provide a unified threat model document.
4. Wire `.rii` examples into the test suite.

## Next review advice
Inspect every file individually for vacuity. Do not trust automated vacuity scripts or LLM pre-screens that claim "not boolean record stubs" without verifying the definitions. Check for mechanical linkage between formal models and Rust implementation; toy models of `list nat` do not constitute formal enforcement of compiler behavior.