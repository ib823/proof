# Domain Audit Record

## 1. Identity

- Domain name: Blockchain Primitives
- Domain identifier: `AO_BLOCKCHAIN`
- Folder(s): `01_RESEARCH/60_DOMAIN_AO_VERIFIED_BLOCKCHAIN/`, `02_FORMAL/*/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.*`, `03_PROTO/crates/*`, `07_EXAMPLES/08_jalinan/`
- Audit date: `2026-03-19`
- Auditor: Codex
- Current repo commit: `93ad08b8684ae7a2d3e94b35c6308f218c60f132`
- Command-derived Rust passing tests on this snapshot: `2476`
- `audit-docs.sh` status on this snapshot: `0 discrepancies`, `1 warning` (`Coq warning status is stale`)
- Dirty files at audit start:
  - `website/public/metrics.json`
  - `06_COORDINATION/audit_outputs/domain_r5/`
  - `06_COORDINATION/prompts/AN_SYARIAH_R5_REVIEW_PROMPT_v1_0_0.md`
  - `06_COORDINATION/prompts/AO_BLOCKCHAIN_R5_AUDIT_PROMPT_v1_0_0.md`
  - `06_COORDINATION/prompts/DOMAIN_R5_AUDIT_PROMPT_PACK_v1_0_0.md`
  - `06_COORDINATION/remediation/`

## 2. Canonical Sources

### 2.1 Live authority files

| Layer | File(s) | Canonical? | Notes |
|------|---------|------------|-------|
| Research | `01_RESEARCH/60_DOMAIN_AO_VERIFIED_BLOCKCHAIN/VERIFIED_BLOCKCHAIN_RESEARCH_v1_0_0.md` | Yes | Explicitly marked `SPEC ONLY - NOT IMPLEMENTED` at lines 1-2 |
| Formal | `02_FORMAL/coq/domains/MerkleDAG.v` | Yes | Active Coq Merkle/content integrity model |
| Formal | `02_FORMAL/coq/domains/ContentAddressedState.v` | Yes | Active Coq content-addressed state model |
| Formal | `02_FORMAL/coq/domains/BlockchainConsensus.v` | Yes | Active Coq blockchain consensus/smart-contract safety model |
| Formal | `02_FORMAL/coq/domains/DistributedConsensus.v` | Yes | Strongest local consensus proof cluster in the domain |
| Formal | `02_FORMAL/coq/domains/BlockchainSafety.v` | Yes | Active Coq value conservation and reentrancy guard model |
| Formal | `02_FORMAL/coq/domains/ExecutionReceipts.v` | Yes | Active Coq receipt-chain model |
| Implementation | `03_PROTO/crates/riina-lexer/src/token.rs`, `03_PROTO/crates/riina-parser/src/lib.rs`, `03_PROTO/crates/riina-typechecker/src/lib.rs`, `03_PROTO/crates/riina-codegen/src/interp.rs`, `03_PROTO/crates/riina-codegen/src/lower.rs`, `03_PROTO/crates/riina-codegen/src/emit.rs`, `03_PROTO/crates/riina-compliance/src/validator.rs`, `03_PROTO/crates/riina-receipt/src/lib.rs` | Yes | Real implementation exists for content-addressing and receipt chains; smart-contract/token support is thinner; consensus is not wired through |
| Specs | none domain-specific found under `04_SPECS/` | No | Cross-cutting audit standards exist, but no blockchain-specific live spec file was found |
| Examples | `07_EXAMPLES/08_jalinan/content_hash.rii`, `07_EXAMPLES/08_jalinan/merkle_audit.rii` | Yes | Example coverage is narrow and not shown to run in CI as end-to-end blockchain workflows |
| Reports | none domain-specific found under `reports/` | No | Only global repo metrics were found |

### 2.2 Historical or non-authoritative files

| File | Why not authoritative |
|------|------------------------|
| `AGENTS.md` | Stale for this domain: still says `Blockchain + Syariah Finance` has `zero implementation`, which is false for current Rust state |
| `02_FORMAL/lean/RIINA/Domains/MerkleDAG.lean` | Auto-generated port of Coq, not independent source design |
| `02_FORMAL/lean/RIINA/Domains/ContentAddressedState.lean` | Auto-generated port of Coq |
| `02_FORMAL/lean/RIINA/Domains/BlockchainConsensus.lean` | Auto-generated port of Coq |
| `02_FORMAL/lean/RIINA/Domains/DistributedConsensus.lean` | Auto-generated port of Coq |
| `02_FORMAL/lean/RIINA/Domains/BlockchainSafety.lean` | Auto-generated port of Coq |
| `02_FORMAL/lean/RIINA/Domains/ExecutionReceipts.lean` | Auto-generated port of Coq |
| `02_FORMAL/isabelle/RIINA/Domains/MerkleDAG.thy` | Auto-generated port of Coq |
| `02_FORMAL/fstar/RIINA/Domains/BlockchainSafety.fst` | Derived from Coq and contains `admit ()` in live file |
| `02_FORMAL/tlaplus/RIINA/Domains/BlockchainConsensus.tla` | Derived from Coq and collapses key predicates to `TRUE` |
| `02_FORMAL/verus/RIINA/Domains/blockchain_safety.rs` | Derived from Coq and uses trivial constant equalities |
| `02_FORMAL/kani/RIINA/Domains/blockchain_safety.rs` | Derived from Coq and uses trivial constant equalities |
| `02_FORMAL/tv/RIINA/Domains/ExecutionReceipts.tv.smt2` | Derived from Coq and only asserts source/target symbol equality |
| `03_PROTO/target/` | Build artifact tree, not source evidence |

## 3. Scope

- Covered problem:
  - content-addressed state, deterministic Merkle-root hashing, hash verification, receipt-chain integrity, a basic smart-contract/token syntax layer, and formally modeled consensus/safety sketches
- Explicitly excluded problem:
  - full blockchain node lifecycle, block production/finality, networking, mempool behavior, fee markets, validator incentives, chain reorg economics, deployed VM semantics, cryptographic collision resistance, and production-grade chain interoperability
- Covered actors:
  - program author, content store user, receipt verifier, contract deployer, token holder, validator/quorum participant in the formal layer
- Covered assets:
  - hashed values, Merkle roots, content-addressed entries, receipt chains, token-typed values, smart-contract wrapped values
- Covered trust boundaries:
  - compiler/typechecker boundary, interpreter/content-store boundary, receipt-consumer boundary, validator quorum boundary in the formal layer
- Covered lifecycle phases:
  - hash/store, lookup/verify, receipt append/verify, formal consensus decision properties
- Covered jurisdictions or standards:
  - none; this is a technical primitives domain, not a regulatory profile
- Assumptions:
  - FNV-1a is accepted here as the current implementation hash primitive
  - Coq boolean-config models are treated as abstractions of domain properties
  - distributed consensus proofs rely on explicit BFT-style assumptions in `DistributedConsensus.v`
  - examples in `07_EXAMPLES` are illustrative unless shown executable by command
- Residual risks:
  - content-addressing is not cryptographically strong at current hash choice
  - consensus is formally modeled more than it is implemented
  - smart-contract and token semantics are thin relative to research claims
  - non-Coq lanes can mislead reviewers if counted as independent evidence

## 4. Workflow Matrix

| Workflow | Valid or forbidden | Research | Formalized | Enforced | Tested | Receipted/observable | Notes |
|----------|--------------------|----------|------------|----------|--------|----------------------|-------|
| Hash scalar content and get deterministic address | Valid | Yes | Yes | Yes | Yes | No | Real parser, typechecker, interpreter, and lowering support |
| Hash list content and derive Merkle-style root | Valid | Yes | Yes | Yes | Yes | No | Implemented in interpreter via concatenated leaf-hash FNV-1a root |
| Verify content against correct hash | Valid | Yes | Yes | Yes | Yes | No | `sahkan(hash, value)` is live |
| Reject content against wrong hash | Forbidden | Yes | Partial | Yes | Yes | No | False case exercised in interpreter tests |
| Store value by content hash and retrieve it later | Valid | Yes | Partial | Yes | Yes | No | Live interpreter content store exists; no standalone public language construct for lookup |
| Append execution receipts and verify chain | Valid | Yes | Yes | Yes | Yes | Yes | Narrow but real receipt chain crate with tamper detection |
| Detect receipt tampering | Forbidden | Yes | Partial | Yes | Yes | Yes | Tested in `riina-receipt` |
| Consensus agreement under quorum assumptions | Valid | Yes | Yes | No | No | No | Strongest local Coq proof cluster, but no runtime/compiler enforcement |
| Smart contract deployment | Valid | Yes | Partial | Partial | Partial | No | Current runtime just evaluates the inner expression |
| Token transfer with incompatible sender/recipient/amount | Forbidden | Yes | Partial | Partial | Yes | No | Typechecker rejects obvious mismatches, but there is no accounting or supply discipline |

## 5. Property Matrix

| Property | Why it matters | Formal artifact | Enforcement artifact | Tests/examples | Status |
|----------|----------------|-----------------|----------------------|----------------|--------|
| Content integrity | Content hash should identify exact value | `MerkleDAG.v`, `ContentAddressedState.v` | `Expr::ContentHash`, `Expr::ContentVerify` in typechecker/interpreter/lowering | Parser/typechecker/interpreter tests, `content_hash.rii` | Real but narrow |
| Deterministic Merkle roots | Same ordered list should hash the same way | `MerkleDAG.v` | `merkle_root_hash` in interpreter | `test_content_hash_list_is_deterministic`, `test_content_hash_list_is_order_sensitive` | Real runtime, shallow formal depth |
| Content lookup integrity | Stored hash should map back to original value | `ContentAddressedState.v` | `content_store`, `content_lookup` in interpreter | `test_content_lookup_round_trip_*` style interpreter tests | Real runtime, no first-class language construct |
| Receipt-chain integrity | Effect history should be tamper-evident | `ExecutionReceipts.v` | `riina-receipt` crate | receipt tamper tests | Real narrow subsystem |
| Consensus agreement and quorum intersection | Prevent conflicting decisions | `DistributedConsensus.v` | None live | No executable workflow found | Formally modeled only |
| Value conservation / token supply invariants | Prevent inflation and loss of accounting integrity | `BlockchainSafety.v` | Thin token-transfer typing only | Type mismatch tests only | Partial and not enforced economically |
| No reentrancy | Prevent state abuse in smart contracts | `BlockchainSafety.v`, research file | None live | None | Research/formal sketch only |

## 6. Formal Evidence

### 6.1 Coq

| File | Key definitions | Key theorems | Nontrivial? | Notes |
|------|-----------------|--------------|-------------|-------|
| `02_FORMAL/coq/domains/MerkleDAG.v` | `HashIntegrityConfig`, `MerkleTreeConfig`, `DAGStructureConfig`, `ContentLookupConfig` | `MKL_001` to `MKL_100` | Partial | Active and domain-specific, but much of the file proves boolean decomposition and direct configuration implications |
| `02_FORMAL/coq/domains/ContentAddressedState.v` | `StateChainConfig`, `ForkDetectionConfig`, `CRDTMergeConfig` | `CAS_001` to `CAS_067` | Partial | Real active model, but dominated by reflexivity and flag extraction |
| `02_FORMAL/coq/domains/BlockchainConsensus.v` | `ConsensusConfig`, `SmartContractConfig` | `BC_001` to `BC_050` | Partial | Mostly configuration validity, negative checks, and boolean unpacking |
| `02_FORMAL/coq/domains/DistributedConsensus.v` | `Node`, `Vote`, `Message`, `Config`, `is_quorum`, `honest_decided` | `agreement`, `validity`, `quorum_intersection`, `quorum_sufficiency`, `bft_threshold` | Yes | Strongest local proof cluster; includes arithmetic and structural reasoning beyond pure unfolding |
| `02_FORMAL/coq/domains/BlockchainSafety.v` | `ValueConservationConfig`, `ReentrancyGuardConfig`, `TokenSupplyConfig`, `FlashLoanGuardConfig` | `BS_001` onward | Partial | Domain-shaped properties exist, but theorems mainly show that conjunction members are true when the top-level boolean is true |
| `02_FORMAL/coq/domains/ExecutionReceipts.v` | `ReceiptChain`, `chain_valid`, `chain_length` | append/validity lemmas | Partial | Structural inductive model is real, but receipt payloads are still boolean-heavy abstractions |

### 6.2 Other prover lanes

| Lane | Files | Independent or generated | Serious or cosmetic | Notes |
|------|-------|--------------------------|---------------------|-------|
| Lean | `02_FORMAL/lean/RIINA/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.lean` | Generated | Cosmetic for independence claims | Useful as ports, not safe to count as independent confirmation |
| Isabelle | `02_FORMAL/isabelle/RIINA/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.thy` | Generated | Cosmetic for independence claims | Same issue as Lean |
| SMT | `02_FORMAL/smt/RIINA/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.smt2` | Compiled/derived | Cosmetic here | Core predicates in `BlockchainSafety.smt2` collapse to `(= 0 0)` |
| Alloy | `02_FORMAL/alloy/RIINA/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.als` | Compiled/derived | Cosmetic here | Assertions reduce to `some`-style placeholders in key files |
| F* | `02_FORMAL/fstar/RIINA/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.fst` | Compiled/derived | Cosmetic here | `BlockchainSafety.fst` uses `admit ()` in live domain file |
| TLA+ | `02_FORMAL/tlaplus/RIINA/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.tla` | Generated/derived | Cosmetic here | `BlockchainConsensus.tla` sets key predicates to `TRUE` |
| Verus | `02_FORMAL/verus/RIINA/Domains/{merkle_dag,content_addressed_state,blockchain_consensus,distributed_consensus,blockchain_safety,execution_receipts}.rs` | Generated | Cosmetic here | Domain specs reduce to trivial constant comparisons in key files |
| Kani | `02_FORMAL/kani/RIINA/Domains/{merkle_dag,content_addressed_state,blockchain_consensus,distributed_consensus,blockchain_safety,execution_receipts}.rs` | Generated | Cosmetic here | Harnesses mostly assert trivial equalities |
| TV | `02_FORMAL/tv/RIINA/Domains/{MerkleDAG,ContentAddressedState,BlockchainConsensus,DistributedConsensus,BlockchainSafety,ExecutionReceipts}.tv.smt2` | Generated | Cosmetic here | Equality transfer stubs only |

### 6.3 Vacuity audit

| Finding | File | Impact | Resolved? |
|---------|------|--------|-----------|
| Research claims are broader than implementation and marked `SPEC ONLY - NOT IMPLEMENTED` | `01_RESEARCH/60_DOMAIN_AO_VERIFIED_BLOCKCHAIN/VERIFIED_BLOCKCHAIN_RESEARCH_v1_0_0.md` | Public wording must be constrained below research ambition | No |
| Core blockchain safety predicates collapse to `(= 0 0)` | `02_FORMAL/smt/RIINA/Domains/BlockchainSafety.smt2` | SMT lane is not serious independent evidence for this domain | No |
| Core blockchain safety predicates collapse to `some p_c` style placeholders | `02_FORMAL/alloy/RIINA/Domains/BlockchainSafety.als` | Alloy lane is not serious independent evidence for this domain | No |
| Live F* domain file contains `admit ()` | `02_FORMAL/fstar/RIINA/Domains/BlockchainSafety.fst` | F* lane cannot be counted as independent strong evidence | No |
| Key TLA+ predicates are `TRUE` | `02_FORMAL/tlaplus/RIINA/Domains/BlockchainConsensus.tla` | TLA+ lane is cosmetic here | No |
| Compliance validator still has `todo!()` for content hash/verify | `03_PROTO/crates/riina-compliance/src/validator.rs` | Domain enforcement is incomplete even where runtime support exists | No |

## 7. Implementation Evidence

| Layer | File(s) | What is real today | What is still placeholder |
|------|---------|--------------------|---------------------------|
| Lexer/parser | `03_PROTO/crates/riina-lexer/src/token.rs`, `03_PROTO/crates/riina-parser/src/lib.rs` | `content_hash`, `verify`, `smart_contract`, `token`, `token::pindah` parse today | `consensus` is lexer-only downstream; `block/blok` is absent from current Rust surface |
| Types/effects | `03_PROTO/crates/riina-types/src/lib.rs`, `03_PROTO/crates/riina-typechecker/src/lib.rs` | `ContentAddressed<T>`, `SmartContract<T>`, `Token<T>` and related expressions are typed | wrappers are thin; no accounting, no economic invariants, no consensus type regime |
| Typechecker | `03_PROTO/crates/riina-typechecker/src/lib.rs` | real typing for content hash/verify and token-transfer shape checks | `ContractDeploy` just wraps inner type; `TokenTransfer` does not enforce conservation or supply invariants |
| Runtime | `03_PROTO/crates/riina-codegen/src/interp.rs`, `03_PROTO/crates/riina-receipt/src/lib.rs` | content store, Merkle-style list hashing, content verification, receipt append/verify | no consensus runtime; smart-contract deployment and token transfer semantics are skeletal |
| Codegen | `03_PROTO/crates/riina-codegen/src/lower.rs`, `03_PROTO/crates/riina-codegen/src/emit.rs` | content hash/verify lower through the codegen path | contract deploy and token transfer lower only thinly; no consensus backend |
| Tooling | `03_PROTO/Cargo.toml`, `scripts/audit-docs.sh` | full Rust tests and clippy pass; doc audit passes with 0 discrepancies | no blockchain-specific regression gate or domain status report exists |

## 8. Executable Evidence

| Evidence | Command | Expected outcome | Last verified |
|----------|---------|------------------|---------------|
| Positive workflow | `export PATH="/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH" && cargo test --manifest-path /workspaces/proof/03_PROTO/Cargo.toml -p riina-codegen test_content_verify_list_merkle_true_via_store` | interpreter verifies a list Merkle root through `sahkan` and content store path | `2026-03-19` |
| Negative workflow | `export PATH="/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH" && cargo test --manifest-path /workspaces/proof/03_PROTO/Cargo.toml -p riina-typechecker test_token_transfer_rejects_non_token_sender` | invalid token sender is rejected by the typechecker | `2026-03-19` |
| Attack/tamper case | `export PATH="/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH" && cargo test --manifest-path /workspaces/proof/03_PROTO/Cargo.toml -p riina-receipt tampered_receipt_id_fails_verification` | tampered receipt chain fails verification | `2026-03-19` |
| Regression test | `export PATH="/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH" && cargo test --all --manifest-path /workspaces/proof/03_PROTO/Cargo.toml && cargo clippy --manifest-path /workspaces/proof/03_PROTO/Cargo.toml -- -D warnings && bash scripts/audit-docs.sh` | Rust workspace remains green; docs show 0 discrepancies | `2026-03-19` |

## 9. Gate Scores

| Gate | Pass / Partial / Fail | Evidence | Notes |
|------|-----------------------|----------|-------|
| `G1` Canonical Identity | Partial | Canonical source set can be reconstructed from one research file, six Coq files, and a small Rust subset | The domain is still split between research ambition and a narrower live implementation |
| `G2` Boundary Precision | Partial | Scope can be written precisely from files, but repo claims are broader than live coverage | Exclusions are not the public default wording today |
| `G3` Workflow Inventory | Partial | Content hash/verify and receipt append/verify workflows are real; broader chain workflows are not | Smart-contract and consensus lifecycles are incomplete |
| `G4` Threat and Failure Model | Partial | Research and formal files mention reentrancy, fork detection, tamper, and quorum assumptions | Failure/abuse modeling is not end-to-end and is not enforced live |
| `G5` Property Set | Partial | Integrity, conservation, agreement, and receipt-chain properties exist | Domain-critical execution and economic properties are incomplete |
| `G6` Formal Model Depth | Partial | `DistributedConsensus.v` and `ExecutionReceipts.v` provide real local depth; several other domain files are definition-heavy | Stronger than pure theater, but not deep enough across the whole domain to justify higher claims |
| `G7` Toolchain Enforcement | Partial | Content hash/verify and receipt verification are real; token rejection exists | Consensus is not implemented; smart-contract and token semantics are too thin for domain-wide enforcement |
| `G8` Executable Evidence | Partial | Reproducible positive, negative, and tamper tests exist for covered subset | No end-to-end `.rii` blockchain workflow is shown to run in CI |
| `G9` Adversarial Coverage | Partial | Tamper receipt tests, false verify tests, and token rejection tests exist | No broad attack corpus for reentrancy, inflation, or consensus abuse exists |
| `G10` Evidence Honesty Across Prover Lanes | Fail | Lean/Isabelle are generated; SMT/Alloy/F*/TLA+/Verus/Kani/TV are vacuous or admitted for this domain | Multi-prover breadth is not safe to count as strong independent blockchain evidence |
| `G11` Observability and Auditability | Partial | Claims can be traced to files and commands; receipt chain exists as a narrow observable subsystem | No domain-specific report or audit artifact ties the whole domain together |
| `G12` Freshness and Reproducibility | Pass | Current commit captured, command-derived test count recomputed, `audit-docs.sh` rerun on live tree | Audit is reproducible on this snapshot |
| `G13` Public Claim Discipline | Fail | `RIINA_MASTER_PLAN.md` and research wording describe broader verified blockchain support than live enforcement justifies | Public language must be reduced to covered subset |
| `G14` Regression Immunity | Fail | No domain-specific CI gate or rating check exists | Future drift would rely on human memory, not enforcement |

## 10. Rating

- Current rating: `R2`
- Rating cap: `R2`
- Why this is not higher:
  - The domain has real formal modeling and at least one nontrivial local proof cluster in `DistributedConsensus.v`, which is enough to exceed `R1`.
  - The live toolchain enforces only a bounded subset: content-addressing, hash verification, and receipt-chain integrity, plus thin token-transfer rejection.
  - The domain is not `R3` because consensus is not live, smart-contract/token semantics are skeletal, examples are not workflow-complete, and public claim discipline is still too strong.
- Minimum work to reach next level:
  - make the live scope explicit as a bounded blockchain-primitives subset
  - complete downstream semantics for claimed syntax such as `consensus`, `block`, smart-contract execution rules, and token accounting invariants
  - add end-to-end valid and invalid `.rii` blockchain workflows that run in CI
  - complete compliance/runtime enforcement where current validators still contain `todo!()`
  - reduce public wording until it matches the enforced subset

## 11. Safe Public Wording

- Safe claim:
  - `RIINA currently has a partial blockchain-primitives lane with real runtime support for content-addressed hashing and receipt chains, plus active but uneven formal modeling of Merkle, content-addressed, and consensus topics; it is not an end-to-end verified blockchain platform.`
- Unsafe claim:
  - `RIINA provides verified blockchain primitives including enforced consensus, smart-contract safety, and complete independent multi-prover confirmation.`

## 12. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| Canonical domain boundary is not publicly normalized | High | Add a narrow live-scope statement for `AO_BLOCKCHAIN` and demote research-only claims | Pending | Needed before broader public wording is safe |
| Consensus support is lexer/formal-only, not live | Critical | Implement parser-to-runtime/codegen consensus semantics or stop counting it as supported | Pending | Major blocker for `R3+` |
| `block/blok` surface is absent despite domain wording | High | Either add the syntax and semantics or remove it from scope claims | Pending | Current domain surface is inconsistent |
| Smart-contract runtime semantics are skeletal | High | Replace `ContractDeploy` passthrough behavior with stateful contract semantics and invalid-case rejection | Pending | Current behavior is wrapper-level only |
| Token transfer lacks conservation and supply enforcement | High | Add issuer/supply/accounting rules and rejection tests | Pending | Type shape alone is not enough |
| Compliance validator is incomplete on content primitives | Medium | Remove `todo!()` from `riina-compliance/src/validator.rs` for content features | Pending | Important because content primitives are among the real implemented subset |
| Non-Coq lanes are not honest independent evidence | High | Demote, quarantine, or substantively strengthen vacuous domain encodings | Pending | Required before any high-assurance multi-prover claim |
| No end-to-end `.rii` blockchain workflows are shown in CI | High | Add positive and negative example execution to tests | Pending | Needed for `G8` and `G14` |
| No domain-specific report or readiness gate exists | Medium | Add a blockchain readiness check/report and CI enforcement | Pending | Needed for `R5` |
| Public wording overstates scope | Critical | Rewrite blockchain claims in `RIINA_MASTER_PLAN.md`, research summaries, and any public surfaces to the safe claim level until remediation lands | Pending | Claim discipline blocks `R5` even if engineering improves |

## 13. Promotion Checklist

### To reach `R1`

- [x] Canonical research scope exists
- [x] Canonical source set can be identified
- [ ] Historical/generated/non-authoritative evidence is clearly demoted in repo-wide claims

### To reach `R2`

- [x] Formal model exists
- [x] Nontrivial local theorem set exists for part of the domain
- [x] Workflow-to-proof mapping exists for a bounded subset of the domain

### To reach `R3`

- [ ] Live enforcement exists for the bounded claimed subset beyond content hash and receipts
- [ ] Invalid covered cases are rejected across all claimed blockchain workflows
- [ ] Executable positive path exists for the full stated subset, not just unit tests

### To reach `R4`

- [ ] Workflow coverage is complete for the stated scope
- [ ] Negative and adversarial tests exist for all covered workflows
- [ ] Residual risks are explicit and narrow

### To reach `R5`

- [ ] Every gate `G1-G14` passes
- [ ] Third-party reproduction is possible without interpretive guesswork
- [ ] Public wording is conservative and exact
- [ ] Regression checks exist and are enforced

## 14. Sign-Off

- Final verdict:
  - `R2` is the maximum honest rating at commit `93ad08b8684ae7a2d3e94b35c6308f218c60f132`.
- Reviewer notes:
  - This audit applies the stricter no-theater standards already enforced by the `AN_SYARIAH` review.
  - The strongest live evidence is content-addressing plus receipt chains.
  - The weakest links are consensus implementation, thin smart-contract/token semantics, vacuous non-Coq lanes, and overstated public wording.
- Follow-up date:
  - after adversarial review and after any claim-discipline fixes land

## 15. Next Audit Handoff

- Recommended next domain:
  - `AO_EXECUTION_RECEIPTS`
- Recommended pattern:
  - `executionreceipt|execution_receipt|execution receipt|receipt chain|receipt`
- Why this should be next:
  - it is the strongest adjacent narrow subsystem in the blockchain lane
  - it already has live Rust enforcement, real tamper tests, and a dedicated Coq file
  - auditing it separately will show whether a narrow domain can honestly reach `R3` sooner than the umbrella blockchain claim
- Files to start from:
  - `02_FORMAL/coq/domains/ExecutionReceipts.v`
  - `03_PROTO/crates/riina-receipt/src/lib.rs`
  - `03_PROTO/crates/riina-codegen/src/interp.rs`
- Cross-domain risks to carry forward:
  - generated/vacuous non-Coq lanes
  - stale or overstated public wording
  - missing domain-specific regression gates
