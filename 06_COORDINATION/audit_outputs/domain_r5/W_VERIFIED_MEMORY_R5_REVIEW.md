## Verdict
**Reject.** The primary audit lands on the right ceiling (`R2`), but it is not safe as written. It overstates live implementation by treating `riina-arena` as verified-memory evidence, and it does not perform the required `G1-G14` gate attack.

## Snapshot validation
- Branch: `main`
- `HEAD`: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- `git diff --name-only 2d436b083b56005b101f18718a7bd0f0aab722e9..HEAD`: empty
- Worktree state: dirty, with many modified/untracked files; the target audit file is currently untracked
- Snapshot validity: valid for the requested commit hash, but not a clean working tree reproduction

## Maximum honest rating
**R2** only, and only for **abstract formal modeling**.

Why not higher:
- There is no live verified allocator bound into the compiler/runtime.
- The live C backend still emits raw `calloc`/`malloc`/`realloc` calls in `03_PROTO/crates/riina-codegen/src/emit.rs:379-426`, `03_PROTO/crates/riina-codegen/src/emit.rs:1187-1191`, `03_PROTO/crates/riina-codegen/src/emit.rs:1244-1268`, `03_PROTO/crates/riina-codegen/src/emit.rs:2152-2155`, `03_PROTO/crates/riina-codegen/src/emit.rs:2207-2210`, and `03_PROTO/crates/riina-codegen/src/emit.rs:2268-2269`.
- There is no covered invalid workflow rejected by the live toolchain for this domain.
- There are no domain-specific executable examples or adversarial tests.

## Gate review table

| Gate | Reviewer score | Evidence | Consequence |
|------|----------------|----------|-------------|
| `G1` Canonical Identity | Partial | `02_FORMAL/coq/domains/W001_VerifiedMemory.v:3-5` points to `RESEARCH_W01_FOUNDATION.md`, but `01_RESEARCH/23_DOMAIN_W_VERIFIED_MEMORY/OLD_RESEARCH_W01_FOUNDATION.md` still exists and the audit has no canonical assumptions / not-in-scope block. | Not `R5` |
| `G2` Boundary Precision | Fail | Research scope targets a verified allocator stack below the type system (`01_RESEARCH/23_DOMAIN_W_VERIFIED_MEMORY/RESEARCH_W01_FOUNDATION.md:6`, `01_RESEARCH/23_DOMAIN_W_VERIFIED_MEMORY/RESEARCH_W01_FOUNDATION.md:107-123`), but the live evidence stops at an abstract Coq model plus an AST arena. | Caps at `R2` |
| `G3` Workflow Inventory | Fail | `exec` only models `CSkip`, `CWrite`, and `CSeq`; allocator commands `CAlloc`, `CFree`, `CRead` have no semantics in the execution relation (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:99-123`). | No workflow-complete evidence |
| `G4` Threat and Failure Model | Partial | Research names buffer overflow, use-after-free, double-free, heap corruption (`01_RESEARCH/23_DOMAIN_W_VERIFIED_MEMORY/RESEARCH_W01_FOUNDATION.md:12-14`), but the audit never maps them to covered abuse cases, invalid workflows, or residual operational risk. | Not `R5` |
| `G5` Property Set | Partial | The research and Coq file enumerate domain-shaped properties (`01_RESEARCH/23_DOMAIN_W_VERIFIED_MEMORY/RESEARCH_W01_FOUNDATION.md:72-80`, `02_FORMAL/coq/domains/W001_VerifiedMemory.v:532-740`), but several headline properties are tautological or assumption-baked. | Supports at most abstract `R2` |
| `G6` Formal Model Depth | Partial | Some real lemmas exist (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:264-369`), but `alloc`/`free` ignore `free_lists` (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:136-159`), buddy proofs are arithmetic wrappers (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:510-525`), and many later theorems are vacuous (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:397-740`). | Keeps `R2`, blocks higher |
| `G7` Toolchain Enforcement | Fail | No parser/typechecker/runtime feature enforces Domain W workflows. `riina-arena` is documented for AST nodes (`03_PROTO/crates/riina-arena/src/lib.rs:3-18`, `03_PROTO/crates/riina-arena/src/lib.rs:272-309`) and no other crate consumes it. | No `R3+` |
| `G8` Executable Evidence | Fail | `cargo test --all --manifest-path 03_PROTO/Cargo.toml` passes, but the only direct Domain W candidate tests are six happy-path arena utility tests (`03_PROTO/crates/riina-arena/src/lib.rs:366-420`). No positive/negative verified-memory workflow exists. | No `R3+` |
| `G9` Adversarial Coverage | Fail | No invalid allocator workflow, tamper case, boundary rejection, or regression case for this domain. `find 07_EXAMPLES ...` found no memory/arena/alloc/borrow/region examples. | No `R4+` |
| `G10` Evidence Honesty Across Prover Lanes | Partial | Lean is explicitly auto-generated (`02_FORMAL/lean/RIINA/Domains/W001_VerifiedMemory.lean:5-9`); SMT/TLA+/F*/Alloy are derived/generated (`02_FORMAL/smt/RIINA/Domains/W001_VerifiedMemory.smt2:3-4`, `02_FORMAL/tlaplus/RIINA/Domains/W001_VerifiedMemory.tla:4-5`, `02_FORMAL/fstar/RIINA/Domains/W001_VerifiedMemory.fst:3-4`, `02_FORMAL/alloy/RIINA/Domains/W001_VerifiedMemory.als:3-4`). The SMT/TLA encodings are visibly vacuous (`02_FORMAL/smt/RIINA/Domains/W001_VerifiedMemory.smt2:42-76`, `02_FORMAL/tlaplus/RIINA/Domains/W001_VerifiedMemory.tla:30-40`). | Must not be counted independently |
| `G11` Observability and Auditability | Fail | The primary audit is only 22 lines and gives no trace matrix from claim to artifact (`06_COORDINATION/audit_outputs/domain_r5/W_VERIFIED_MEMORY_R5_AUDIT.md:3-22`). | Release-blocking |
| `G12` Freshness and Reproducibility | Partial | Commit matches and commands reproduce, but the worktree is dirty and the audit does not disclose the actual runtime contradiction with raw allocator calls. | Not `R5` |
| `G13` Public Claim Discipline | Fail | The audit's "safe claim" still says there is "a memory arena implementation" (`06_COORDINATION/audit_outputs/domain_r5/W_VERIFIED_MEMORY_R5_AUDIT.md:18`), which overstates what is live and relevant to this domain. | Release-blocking |
| `G14` Regression Immunity | Fail | No domain-specific regression gate exists. Generic arena tests do not detect loss of verified-memory semantics because those semantics are not wired into the toolchain. | No `R5` |

## Findings table

| Severity | Finding | Evidence | Impact |
|----------|---------|----------|--------|
| High | The audit overclaims live implementation by counting `riina-arena` as verified-memory evidence. | `riina-arena` is an AST-node arena (`03_PROTO/crates/riina-arena/src/lib.rs:3-18`, `03_PROTO/crates/riina-arena/src/lib.rs:272-309`); no other crate `Cargo.toml` depends on it; the backend still uses raw allocators (`03_PROTO/crates/riina-codegen/src/emit.rs:379-426`). | Remove implementation language from the audit and safe claim. |
| High | The formal model does not cover allocator workflows end to end. | `exec` omits allocation/free/read semantics (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:99-123`); `alloc` and `free` never touch `free_lists` (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:136-159`). | Domain is abstract-only; no basis for `R3+`. |
| High | A large fraction of the theorem set is vacuous, duplicate, or assumption-baked. | Examples: `W_001_09_sep_monotonic` is identity (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:397-405`), `W_001_22_no_buffer_overflow` is contradiction-in-hypothesis (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:544-552`), `W_001_26_type_safe_access` is existential echo (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:585-592`), `W_001_31_ownership_unique` proves `om l' = om l'` (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:636-643`), and `W_001_14` / `W_001_16` are duplicate outcomes (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:457-480`). | The theorem count cannot justify deeper maturity. |
| Medium | Region isolation is not proved as originally claimed. | The first theorem is aborted (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:672-680`) and replaced by a stronger precondition requiring already-disjoint regions (`02_FORMAL/coq/domains/W001_VerifiedMemory.v:682-690`). | Weakens G4/G5/G6; audit should cite the weaker theorem, not the stronger claim. |
| Medium | There is no executable negative evidence for this domain. | `riina-arena` tests are only alloc/get/grow/len/equality/happy-path heterogeneous cases (`03_PROTO/crates/riina-arena/src/lib.rs:366-420`); no domain examples were found under `07_EXAMPLES`. | Fails G8 and G9. |
| Medium | Auxiliary prover lanes are generated or vacuous and cannot be counted independently. | Auto-generated / derived headers in Lean, SMT, Alloy, TLA+, F* (`02_FORMAL/lean/RIINA/Domains/W001_VerifiedMemory.lean:5-9`, `02_FORMAL/smt/RIINA/Domains/W001_VerifiedMemory.smt2:3-4`, `02_FORMAL/alloy/RIINA/Domains/W001_VerifiedMemory.als:3-4`, `02_FORMAL/tlaplus/RIINA/Domains/W001_VerifiedMemory.tla:4-5`, `02_FORMAL/fstar/RIINA/Domains/W001_VerifiedMemory.fst:3-4`). | G10 must be called out explicitly. |

## Overclaim lines
- `06_COORDINATION/audit_outputs/domain_r5/W_VERIFIED_MEMORY_R5_AUDIT.md:10`  
  "`Implementation: riina-arena (shared).`"  
  Overclaim: this crate is an AST arena, not a live verified allocator, and it is not consumed by the rest of the compiler/runtime.

- `06_COORDINATION/audit_outputs/domain_r5/W_VERIFIED_MEMORY_R5_AUDIT.md:15`  
  "`riina-arena provides memory arena implementation.`"  
  Overclaim: the live backend still uses raw `calloc`/`malloc`/`realloc`, so the claimed implementation is not the runtime memory mechanism this domain is supposed to verify.

- `06_COORDINATION/audit_outputs/domain_r5/W_VERIFIED_MEMORY_R5_AUDIT.md:18`  
  "`Verified memory has partial formal modeling and a memory arena implementation...`"  
  Unsafe as written: the formal model exists, but the implementation half is not Domain W evidence in the R5 sense.

## Missed evidence lines
- `02_FORMAL/coq/domains/W001_VerifiedMemory.v:99-123`  
  The execution semantics do not model allocation, free, or read.

- `02_FORMAL/coq/domains/W001_VerifiedMemory.v:136-159`  
  `alloc` / `free` ignore `free_lists`, so the supposed buddy allocator state is not operationally modeled.

- `02_FORMAL/coq/domains/W001_VerifiedMemory.v:672-690`  
  Region isolation was first aborted, then weakened to require disjointness as an assumption.

- `03_PROTO/crates/riina-codegen/src/emit.rs:379-426` and `03_PROTO/crates/riina-codegen/src/emit.rs:1187-1191`  
  The live C backend allocates with raw `calloc`, `malloc`, and `realloc`.

- `03_PROTO/crates/riina-arena/src/lib.rs:3-18` and `03_PROTO/crates/riina-arena/src/lib.rs:272-309`  
  The supposed implementation evidence is an AST arena with placeholder slots.

- `02_FORMAL/lean/RIINA/Domains/W001_VerifiedMemory.lean:5-9`, `02_FORMAL/smt/RIINA/Domains/W001_VerifiedMemory.smt2:3-4`, `02_FORMAL/alloy/RIINA/Domains/W001_VerifiedMemory.als:3-4`, `02_FORMAL/tlaplus/RIINA/Domains/W001_VerifiedMemory.tla:4-5`, `02_FORMAL/fstar/RIINA/Domains/W001_VerifiedMemory.fst:3-4`  
  Auxiliary lanes are generated / derived, not independent confirmations.

## Safe claim
RIINA has an abstract Coq model for heap, separation-logic, ownership, and region concepts in `W001_VerifiedMemory.v`, with some nontrivial local lemmas, but it does **not** have a live verified allocator integrated into the compiler/runtime or a domain-specific reject-invalid workflow.

## Unsafe claim
RIINA has a verified memory allocator implementation; `riina-arena` is the verified allocator; Domain W enforces verified memory at compile time or runtime; or “memory is proven” for the live system.

## Release condition
- Keep the domain at `R2`, but rewrite the audit around **abstract formal modeling only**.
- Remove all language that treats `riina-arena` as live verified-memory implementation evidence.
- Explicitly score `G3`, `G7`, `G8`, `G9`, `G11`, `G13`, and `G14` as failing, with citations.
- Explicitly note that non-Coq lanes are generated / derived and not independent support.
- Do not promote above `R2` until the verified allocator is actually wired into the live runtime/backend and invalid covered cases are reproducibly rejected.

## Next review advice
- Start from the current research file, but add a canonical assumptions / not-in-scope block and explicitly demote the `OLD_RESEARCH` file for audit purposes.
- If `riina-arena` is intended to matter for Domain W, wire it into real compiler/runtime consumers and test misuse/rejection; otherwise keep it out of the evidence pack.
- Replace vacuous theorems with properties over real allocator state transitions, and add `exec` semantics for allocation, free, and read.
- Add one positive end-to-end memory workflow and at least one invalid workflow that is rejected by the live toolchain before considering `R3`.
