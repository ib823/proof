## Verdict

The primary audit is not defensible as written. It correctly notices `False` stubs in `X001_ConcurrencyModel.v`, but it still over-rates the domain at `R2`, omits multiple stronger contradictions, and does not satisfy the required evidence shape from the R5 checklist/worksheet. The strongest honest conclusion for `X_CONCURRENCY_MODEL` at this snapshot is `R1`, not `R2`.

## Snapshot validation

- `git status --short --branch` showed `main...origin/main` with a dirty worktree. The primary audit file itself is currently untracked, so the audit artifact is not committed in the validated snapshot.
- `git rev-parse HEAD` returned `2d436b083b56005b101f18718a7bd0f0aab722e9`, which matches the expected commit.
- `git diff --name-only 2d436b083b56005b101f18718a7bd0f0aab722e9..HEAD` returned nothing.
- `grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"` and `grep -rnP "^\s*Admitted\." 02_FORMAL/coq --include="*.v"` only hit `_archive_deprecated` files. The active lane has no `Axiom`/`Admitted` on those checks.
- `grep -RIn "Auto-generated from" 02_FORMAL` and `grep -RIn "Derived from" 02_FORMAL` confirmed that the non-Coq lanes for this domain include generated and derived artifacts.
- `cargo test --all --manifest-path 03_PROTO/Cargo.toml` passed.

Conclusion: the code snapshot matches the requested commit, but the audit artifact is not itself snapshot-committed, which weakens reproducibility.

## Maximum honest rating

`R1`

Why not `R2`:
- `R2` requires a formal model plus nontrivial local proofs. The active Coq file is structurally vacuous for core concurrency properties:
  - `accesses` and `writes` are `False` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:129-130`.
  - `waiting` and `holding` are `False` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:156-159`.
  - `holds_lock` and `acquires_lock` are `False` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:189-192`.
  - `livelock` and `starved` are `False` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:326-329`.
  - `atomic_race_free` is always `True` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:305-311`.
- Major “proofs” then collapse into contradiction or tautology:
  - `X_001_05_race_freedom` ends by unfolding `accesses := False` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:393-401`.
  - `X_001_20_session_deadlock_free` ends by unfolding `waiting := False` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:594-607`.
  - `X_001_11_session_progress` proves `exists cfg', True` by returning `cfg` unchanged at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:481-488`.
  - `X_001_12_session_safety` proves `True` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:491-498`.
  - `X_001_22_timeout_prevents_deadlock` proves `~ deadlocked cfg \/ True` by choosing `True` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:619-625`.
  - `X_001_34_role_conformance` proves `conforms ... -> True` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:757-763`.

Why not `R3`:
- The live toolchain has real actor/runtime pieces, but the domain-level enforcement is incomplete and partly stubbed:
  - `ChoreographyBlock` typechecking only checks `roles.len() >= 2` and otherwise returns the protocol unchanged at `03_PROTO/crates/riina-typechecker/src/lib.rs:3078-3091`.
  - The interpreter gives choreography no runtime behavior at `03_PROTO/crates/riina-codegen/src/interp.rs:818-820`.
  - C codegen lowers choreography to `riina_choreography_decl()` which just returns unit at `03_PROTO/crates/riina-codegen/src/emit.rs:2611-2614` and `03_PROTO/crates/riina-codegen/src/emit.rs:3210-3212`.
  - The interpreter’s actor send path coerces messages via `msg.as_int().unwrap_or(0)` at `03_PROTO/crates/riina-codegen/src/interp.rs:839-849`, so it is not type-faithful for general messages.
  - The C actor backend initializes mutexes and mailboxes but never creates a worker thread, and `riina_actor_recv` only returns current state; nothing consumes the mailbox at `03_PROTO/crates/riina-codegen/src/emit.rs:2617-2656`.
  - The WASM backend is explicitly placeholder: actor spawn returns `1`, send is a no-op, and recv returns `0` at `03_PROTO/crates/riina-codegen/src/wasm.rs:1106-1125`.

The honest claim today is: research-backed specification plus partial actor/session/choreography implementation experiments, not a non-vacuous formal concurrency model.

## Gate review table

| Gate | Status | Evidence | Review note |
|------|--------|----------|-------------|
| G1 Canonical Identity | Fail | Audit lines 4-10, plus explicit “Overlaps with H_CONCURRENCY_AND_POLICY” at `06_COORDINATION/audit_outputs/domain_r5/X_CONCURRENCY_MODEL_R5_AUDIT.md:10` | Name and identifier exist, but there is no canonical scope, assumptions block, or “not in scope” block, and overlap with H is unresolved. |
| G2 Boundary Precision | Fail | Audit has no entry/exit criteria, actors, assets, trust boundaries, or lifecycle coverage; research scope is broad at `01_RESEARCH/24_DOMAIN_X_CONCURRENCY_MODEL/RESEARCH_X01_FOUNDATION.md:72-83` | The domain claim spans races, deadlocks, session fidelity, lock ordering, TOCTOU, and progress without a written coverage boundary. |
| G3 Workflow Inventory | Fail | No workflow matrix in audit; choreography typing is only a role-count check at `03_PROTO/crates/riina-typechecker/src/lib.rs:3078-3091` | Theorems are not mapped to concrete valid/invalid workflows, and choreography is not enforced as a real protocol workflow. |
| G4 Threat and Failure Model | Fail | No adversary/failure model in audit; core predicates are stubbed to `False` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:129-130`, `156-159`, `189-192`, `326-329` | The active model does not actually encode races, waits, lock ownership, livelock, or starvation. |
| G5 Property Set | Fail | Research lists domain properties at `01_RESEARCH/24_DOMAIN_X_CONCURRENCY_MODEL/RESEARCH_X01_FOUNDATION.md:74-83`; active Coq reduces several to tautologies or `True` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:444-450`, `481-498`, `619-625`, `757-771` | The claimed property set exists on paper, but not as meaningful active domain proofs. |
| G6 Formal Model Depth | Fail | Core vacuity at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:129-130`, `156-159`, `189-192`, `305-311`, `326-329`; trivial proofs at `393-401`, `594-607` | No `Admitted` is not enough. The active model is mostly vacuous at the abstraction layer that matters. |
| G7 Toolchain Enforcement | Partial | Real actor/runtime tests passed; actor typing rejects some bad cases at `03_PROTO/crates/riina-typechecker/src/tests.rs:3693-3879`; but choreography is shallow/stubbed and backends are incomplete at `03_PROTO/crates/riina-codegen/src/interp.rs:818-820`, `03_PROTO/crates/riina-codegen/src/emit.rs:2611-2614`, `2617-2656`, `03_PROTO/crates/riina-codegen/src/wasm.rs:1106-1125` | There is bounded actor/message enforcement, but not a workflow-complete concurrency model. |
| G8 Executable Evidence | Fail | `cargo test` passes, but the audit provides no positive/negative end-to-end commands; example files are present in `07_EXAMPLES/08_jalinan/` but a search only found the example files themselves and audit docs, not execution harnesses | The audit does not show one valid RIINA workflow and one invalid RIINA workflow being reproduced from commands. |
| G9 Adversarial Coverage | Partial | Negative actor tests exist at `03_PROTO/crates/riina-typechecker/src/tests.rs:3702-3866`; runtime has actor/session tests at `03_PROTO/crates/riina-runtime/src/tests.rs:22-177` | Some bounded negative tests exist, but there is no serious adversarial coverage for data races, deadlocks, starvation, lock ordering, or protocol abuse in the RIINA toolchain. |
| G10 Evidence Honesty Across Prover Lanes | Fail | Lean and Isabelle are auto-generated ports at `02_FORMAL/lean/RIINA/Domains/X001_ConcurrencyModel.lean:5-9` and `02_FORMAL/isabelle/RIINA/Domains/X001_ConcurrencyModel.thy:5-9`; F*, TLA+, Alloy, SMT are derived/generated at `02_FORMAL/fstar/RIINA/Domains/X001_ConcurrencyModel.fst:3-4`, `02_FORMAL/tlaplus/RIINA/Domains/X001_ConcurrencyModel.tla:4-5`, `02_FORMAL/alloy/RIINA/Domains/X001_ConcurrencyModel.als:3-4`, `02_FORMAL/smt/RIINA/Domains/X001_ConcurrencyModel.smt2:3-4` | Any independent-count interpretation would be dishonest. The primary audit does not document this lane status. |
| G11 Observability and Auditability | Fail | Primary audit is 22 lines and omits the worksheet sections for source map, scope, workflows, property matrix, executable evidence, vacuity audit, gate scores, and blockers | A reviewer cannot reconstruct why `R2` was assigned. |
| G12 Freshness and Reproducibility | Partial | Commit matches expected and required commands reproduce current code state; however the audit file itself is untracked in a dirty worktree | Snapshot validation passed at commit level, but the audit artifact is not fully reproducible from the snapshot alone. |
| G13 Public Claim Discipline | Fail | `R2` at `06_COORDINATION/audit_outputs/domain_r5/X_CONCURRENCY_MODEL_R5_AUDIT.md:14-15` overstates the weakest real link | The real evidence does not justify “formally modeled” for this domain. |
| G14 Regression Immunity | Fail | No domain-specific check catches `:= False` placeholders or choreography stubs; generic cargo tests passing did not expose the formal vacuity | The rating would depend on human inspection, not automatic regression detection. |

## Findings table

| Severity | Finding | Evidence | Impact |
|----------|---------|----------|--------|
| Critical | The active Coq domain model is vacuous for core concurrency semantics. | `accesses`, `writes`, `waiting`, `holding`, `holds_lock`, `acquires_lock`, `livelock`, and `starved` are `False`; `atomic_race_free` is always `True` in `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:129-130`, `156-159`, `189-192`, `305-311`, `326-329` | This collapses data-race, deadlock, and liveness claims. `R2` is not supportable. |
| Critical | Several flagship theorems are tautologies or contradiction-from-stub proofs. | `X_001_05`, `X_001_20`, `X_001_11`, `X_001_12`, `X_001_22`, `X_001_34` at `02_FORMAL/coq/domains/X001_ConcurrencyModel.v:393-401`, `481-498`, `594-607`, `619-625`, `757-763` | The proof count is not meaningful domain evidence. |
| High | Choreography support is largely declarative data, not enforced protocol execution. | Typechecker only checks role count at `03_PROTO/crates/riina-typechecker/src/lib.rs:3078-3091`; interpreter is no-op at `03_PROTO/crates/riina-codegen/src/interp.rs:818-820`; C codegen returns unit at `03_PROTO/crates/riina-codegen/src/emit.rs:2611-2614`, `3210-3212` | Workflow/protocol claims are broader than the toolchain actually enforces. |
| High | The RIINA-generated actor backends are not faithful concurrency implementations. | Interpreter coerces messages through `msg.as_int().unwrap_or(0)` at `03_PROTO/crates/riina-codegen/src/interp.rs:839-849`; C actor backend never starts a thread and never drains the mailbox at `03_PROTO/crates/riina-codegen/src/emit.rs:2617-2656`; WASM is placeholder at `03_PROTO/crates/riina-codegen/src/wasm.rs:1106-1125` | Shared `riina-runtime` success does not prove the audited RIINA concurrency model is live end-to-end. |
| High | Generated non-Coq lanes are derivative, not independent corroboration. | Auto-generated/derived headers in Lean, Isabelle, F*, TLA+, Alloy, SMT files listed in G10 | Any future attempt to use lane multiplicity here would be inflated evidence. |
| Medium | The primary audit is not worksheet-compliant and omits mandatory evidence pack sections. | Compare the 22-line audit with `04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md` | The audit is not reconstructible and does not support hostile review. |
| Medium | Example materials overstate what the compiler currently proves. | `07_EXAMPLES/08_jalinan/secure_chat.rii:21-24` says the compiler proves protocol-following, but choreography is only stored as data and lowered to stubs | Example prose is not safe audit evidence. |
| Medium | Snapshot reproducibility is weakened because the audit artifact is untracked. | `git status --short --branch` showed `?? 06_COORDINATION/audit_outputs/domain_r5/X_CONCURRENCY_MODEL_R5_AUDIT.md` | Reviewers cannot recover the exact audit artifact from the validated commit alone. |

## Overclaim lines

| Audit line(s) | Claim | Why it overclaims |
|---------------|-------|-------------------|
| `14` | `Current rating: R2` | `R2` requires a nontrivial formal model. The active Coq file is vacuous for the claimed concurrency properties. |
| `15` | `False stubs prevent R3.` | They also prevent `R2`. The domain does not have meaningful active proof depth, and the runtime overlap does not repair that. |
| `22` | `Final verdict: R2` | Same problem as line 14. The strongest honest cap is `R1`. |

## Missed evidence lines

| Audit line(s) | Missed evidence | Why it matters |
|---------------|-----------------|----------------|
| `9-15` | The review never enumerates the actual stubbed predicates: `accesses`, `writes`, `waiting`, `holding`, `holds_lock`, `acquires_lock`, `livelock`, `starved`, plus `atomic_race_free := True` | Without this, the reader misses how fully the active model collapses. |
| `15` | The audit does not note that choreography typing is only `roles.len() >= 2`, and that interpreter/C/WASM backends are stubbed or placeholder for choreography/actor execution | This materially lowers G3, G7, and G8. |
| `9-15` | The audit does not identify the trivial theorem bodies (`exists cfg', True`, `... -> True`, reflexivity-only results, contradiction from `False`) | Required vacuity audit was not performed deeply enough. |
| `9-15` | The audit omits that non-Coq lanes for this domain are generated/derived from the same Coq source | Required G10 honesty check is incomplete. |
| Entire file | The audit omits scope, assumptions, out-of-scope, workflow matrix, property matrix, executable evidence, gate scores, and blocking gaps from the worksheet template | This makes the rating non-auditable. |

## Safe claim

RIINA has research documentation for a concurrency model and partial implementation work around actors, typed message passing, and session/choreography data structures. The Rust runtime crate is real and tested, and the typechecker rejects some malformed actor workflows. But `X_CONCURRENCY_MODEL` is not yet a non-vacuous formal concurrency model, and its end-to-end RIINA choreography/session enforcement is incomplete.

## Unsafe claim

RIINA currently has an `R2` or higher formal concurrency model for `X_CONCURRENCY_MODEL`, or proves data-race freedom, deadlock freedom, session fidelity, progress, or multiparty protocol safety for the live RIINA toolchain in this domain.

## Release condition

Do not release this domain above `R1` until all of the following are true:

1. Replace the `False`/`True` placeholder semantics in `02_FORMAL/coq/domains/X001_ConcurrencyModel.v` with real stateful definitions for access, writes, waiting, holding, lock acquisition, livelock, and starvation.
2. Re-prove the flagship properties against those real definitions, with theorem bodies that survive vacuity inspection.
3. Wire choreography/session semantics through the live RIINA toolchain instead of storing protocol data and lowering it to unit/stubs.
4. Demonstrate at least one positive and one negative end-to-end RIINA workflow from commands, not just unit tests.
5. Rewrite the audit in worksheet form and explicitly mark generated/derived lanes as non-independent.
6. Commit the audit artifact and add regression checks that fail on `:= False` placeholder semantics in active concurrency files.

## Next review advice

- Start with theorem bodies, not theorem counts. Search for `:= False`, `:= True`, `exists _, True`, `A -> True`, and reflexivity-only statements before reading any prose.
- Treat the Rust runtime crate as a separate bounded subsystem. Do not let it stand in for the RIINA-generated interpreter/C/WASM concurrency semantics.
- Treat choreography separately from actors. Today the choreography path is mostly syntax plus storage, not protocol enforcement.
- Count generated and derived non-Coq lanes as derivative evidence only.
- Require a worksheet-complete audit next time. A 22-line note is not enough for a hostile review on a broad domain.
