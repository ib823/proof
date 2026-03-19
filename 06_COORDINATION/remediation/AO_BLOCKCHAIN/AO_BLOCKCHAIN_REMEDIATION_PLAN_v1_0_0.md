# AO_BLOCKCHAIN Remediation Plan v1.0.0

## Purpose

Turn `AO_BLOCKCHAIN` from an overbroad blockchain umbrella into a domain family that can eventually support honest `R5` claims without relying on lexer-only support, wrapper-only runtime behavior, boolean-proof theater, or vacuous prover breadth.

This plan does not change the current audit outcome. It defines how to earn a higher rating.

## Current Truth

As of [AO_BLOCKCHAIN_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md) and [AO_BLOCKCHAIN_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md):
- `AO_BLOCKCHAIN` is `R1`
- the umbrella domain has real implementation support for content-addressing and receipt chains
- the umbrella domain has active formal artifacts, but much of the Coq surface is boolean-heavy
- `block/blok` is not implemented
- `consensus` is lexer-only downstream
- `ContractDeploy` is wrapper-level only
- public wording outruns the bounded live subset

## Governing Rule

`AO_BLOCKCHAIN` cannot reach `R5` as a single undifferentiated umbrella. It must be decomposed into auditable child domains, each with its own scope, formal model, implementation path, executable workflows, adversarial tests, receipts, and public wording.

Umbrella `AO_BLOCKCHAIN` may not be rated above the minimum of:
- its claimed child domains
- its cross-domain integration layer
- its public-claim discipline

## Non-Negotiable Remediation Principles

1. No blockchain child domain is counted because a keyword exists.
2. No blockchain child domain is counted because a theorem name sounds strong.
3. No FNV-1a implementation is counted as cryptographic-grade blockchain integrity.
4. No generated prover lane is counted as serious independent evidence.
5. No consensus claim is counted without live reject-invalid behavior.
6. No smart-contract claim is counted while `ContractDeploy` is a passthrough wrapper.
7. No token claim is counted while accounting and supply invariants are unenforced.
8. No end-to-end workflow counts unless it runs through the actual toolchain.
9. Public wording must state the narrowest true scope.

## Required Structural Changes

### 1. Decompose the domain

Break `AO_BLOCKCHAIN` into audited child domains:
- `AO_EXECUTION_RECEIPTS`
- `AO_CONTENT_ADDRESSED_STATE`
- `AO_MERKLE_DAG`
- `AO_TOKEN_ACCOUNTING`
- `AO_SMART_CONTRACT_RUNTIME`
- `AO_CONSENSUS_CORE`
- `AO_BLOCKCHAIN_INTEGRATION`

### 2. Rebuild the formal model style

The current boolean-config style across several blockchain Coq files is not enough. Replace it with:
- inductive state and trace models
- typed state transitions
- explicit invalid-state predicates
- accounting invariants
- adversary-aware theorems
- runtime-connected proof obligations

### 3. Rebuild the implementation style

The live Rust layer must move from:
- syntax fragments
- wrapper-only types
- passthrough runtime behavior
- isolated unit tests

to:
- scoped domain AST
- bounded but real enforcement
- invalid workflow rejection
- runtime observability and receipts
- audited examples
- adversarial tests

## Execution Order

### Phase 0: Claim Reset

Objective:
- ensure docs, research wording, and examples do not imply a live end-to-end blockchain platform

Required outputs:
- safe public wording for umbrella `AO_BLOCKCHAIN`
- explicit statement that current umbrella baseline is `R1`
- removal or qualification of consensus/smart-contract claims that are not live

### Phase 1: Domain Split

Objective:
- isolate narrow blockchain primitives that can actually be made `R5`

Required outputs:
- child-domain audit IDs
- canonical scope per child domain
- exclusion list per child domain
- dependency graph across child domains

### Phase 2: First Flagship Vertical

Objective:
- take `AO_EXECUTION_RECEIPTS` to `R5` first

Why receipts first:
- strongest current live artifact
- already has a dedicated Rust crate
- already has tamper tests
- already has a dedicated Coq file
- naturally produces observable audit evidence

### Phase 3: Content Addressing Foundation

Objective:
- build `AO_CONTENT_ADDRESSED_STATE` and `AO_MERKLE_DAG` into honest `R4-R5` candidates

Required outputs:
- content lookup semantics exposed through the live toolchain
- deterministic Merkle aggregation semantics with executable workflows
- stronger integrity model and tests

### Phase 4: Value and Contract Semantics

Objective:
- implement `AO_TOKEN_ACCOUNTING` and `AO_SMART_CONTRACT_RUNTIME`

Required outputs:
- token conservation and supply invariants
- stateful contract execution semantics
- invalid transfer/reentrancy rejection
- runtime receipts for effectful transitions

### Phase 5: Consensus Core

Objective:
- implement and verify `AO_CONSENSUS_CORE`

Required outputs:
- explicit validator/quorum model in the toolchain
- reject-invalid consensus workflows
- executable valid and invalid consensus cases

### Phase 6: Umbrella Integration

Objective:
- prove that child domains compose without hidden contradictions

Required outputs:
- cross-domain interaction model
- integration receipts
- integration attack tests
- umbrella safe claim

## Required Evidence Per Child Domain

Each child domain must have all of:
- one canonical spec
- one canonical Coq file
- explicit in-scope and out-of-scope statement
- AST/type/runtime semantics
- invalid workflow rejection
- positive workflow tests
- negative workflow tests
- adversarial tests
- receipts or observability artifacts
- reviewer-safe public wording

## Exit Criteria For Umbrella AO_BLOCKCHAIN

`AO_BLOCKCHAIN` may be reconsidered for `R5` only when:
- every claimed child domain is at least `R4`
- flagship child domains are `R5`
- `AO_BLOCKCHAIN_INTEGRATION` is at least `R4`
- no public wording outruns the weakest real link
- an adversarial reviewer cannot downgrade the umbrella on scope, depth, or honesty grounds

## Immediate Next Action

Do not broaden. Narrow.

Start with:
- [AO_BLOCKCHAIN_EXECUTION_RECEIPTS_R5_TARGET_SPEC_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AO_BLOCKCHAIN/AO_BLOCKCHAIN_EXECUTION_RECEIPTS_R5_TARGET_SPEC_v1_0_0.md)
- [AO_BLOCKCHAIN_R1_TO_R5_WORKLIST_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AO_BLOCKCHAIN/AO_BLOCKCHAIN_R1_TO_R5_WORKLIST_v1_0_0.md)
