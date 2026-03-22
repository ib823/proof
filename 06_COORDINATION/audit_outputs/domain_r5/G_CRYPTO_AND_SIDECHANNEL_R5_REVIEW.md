# G_CRYPTO_AND_SIDECHANNEL R5 Hostile Review

## Verdict
reject

## Snapshot validation
- **Branch:** main
- **Commit:** 2d436b083b56005b101f18718a7bd0f0aab722e9
- **Valid for snapshot:** Yes
- **Drift:** Materially harmless (only audit, tracker, and prompt files changed).

## Maximum honest rating
R2

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| G1 | Pass | Pass | Agree | 01_RESEARCH domain docs exist | None |
| G2 | Partial | Partial | Agree | Scope is huge (ZK, PQ, side-channels, CT). Only CT is enforced. | Bounded scope needed |
| G3 | Partial | Partial | Agree | CT workflows tested, others formal-only | None |
| G4 | Partial | Partial | Agree | Side-channel taxonomy exists, no consolidated threat model | None |
| G5 | Pass | Fail | Downgrade | The 428 Coq theorems are vacuous boolean stubs (e.g. `Definition riina_ct_config := mkCTConfig true true...`) | Major overclaim on formal modeling |
| G6 | Pass | Fail | Downgrade | Proofs are just `Proof. reflexivity. Qed.` The audit missed this because it only checked for `trivial.`/`exact I.` | Vacuous formal evidence cannot support R3 |
| G7 | Pass | Pass | Agree | CT enforcement in riina-typechecker is real (error CT0001) | Solid R2 evidence |
| G8 | Partial | Partial | Corrected | The audit claimed "4 CT tests + 6 chain tests". It entirely missed the 228 passing tests in `riina-core` including RFC test vectors and hardware side-channel litmus tests | Missing positive evidence in audit |
| G9 | Partial | Partial | Agree | Branch rejection tested. No ZK/PQ adversarial tests | None |
| G10 | Pass | Pass | Agree | Non-Coq lanes not counted | None |
| G11 | Pass | Pass | Agree | CT0001 is mapped | None |
| G12 | Pass | Pass | Agree | Command-derived | None |
| G13 | Not audited | Not audited | Agree | | None |
| G14 | Partial | Partial | Agree | Hook-gated | None |

## Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| Critical | G5, G6 | "428 Qed, 0 Admitted, nontrivial (verified by sampling + vacuity check)" | All 7 Coq files just define hardcoded boolean records (e.g., `zk_completeness = true`) and prove them with `reflexivity.` | Downgrade formal layer from R3 to vacuous. Vacuity script must check `reflexivity.` |
| High | G8 | "4 CT tests + 6 chain/error tests + 5 content hash tests." | `cargo test --manifest-path 05_TOOLING/crates/riina-core/Cargo.toml` runs 228 tests, covering AES, SHA, ML-KEM, side-channel litmus tests, and zeroize. | Update positive test evidence. Audit was too harsh on implementation depth. |
| Medium | G2 | "ZK/PQ are formally modeled" | The models have no mathematical meaning; they assert booleans. | Remove ZK/PQ from formal claims until AST-based proofs exist. |

## Overclaim lines
- "428 Qed, 0 Admitted, nontrivial (verified by sampling + vacuity check)"
- "Formally modeled but not enforced: ZK proof soundness, post-quantum security properties" (They are not modeled, just stated as `true`).
- "Vacuity check: ... Proof body samples show real `andb_true_iff` decomposition" (This is technically true but hides that the root theorems are `reflexivity.` over hardcoded `true`).

## Missed evidence lines
- ~228 crypto tests in `05_TOOLING/crates/riina-core` for AES, HMAC, HKDF, Keccak, ML-DSA, ML-KEM, Ed25519.
- Side-channel litmus tests (spectre, meltdown, etc.) in `riina-core/src/litmus`.
- Secret zeroization tests in `riina-core`.

## Safe claim
"Crypto and side-channel security features constant-time type discipline enforced at compile time, preventing branches on CT values. The standard library includes implementations of ML-KEM, ML-DSA, and AES/SHA with 220+ tests including hardware side-channel litmus tests."

## Unsafe claim
"ZK-SNARK soundness, post-quantum security, and side-channel protections are formally proven in Coq." (The Coq proofs are vacuous boolean stubs).

## Release condition
Either rewrite the Coq models to mathematically evaluate real AST types rather than boolean record fields, or permanently split the domain, dropping the ZK/PQ formal claims and claiming only the enforced constant-time type discipline.

## Next review advice
Always include `reflexivity.` against hardcoded boolean records in the vacuity check. Do not trust theorem counts without checking the definition of the structures being proven. Run `cargo test --all` across `05_TOOLING` as well as `03_PROTO`.