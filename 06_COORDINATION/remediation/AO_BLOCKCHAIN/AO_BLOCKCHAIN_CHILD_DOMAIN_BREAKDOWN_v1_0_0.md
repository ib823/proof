# AO_BLOCKCHAIN Child Domain Breakdown v1.0.0

`AO_BLOCKCHAIN` is too broad to become honest `R5` as one label. It must be split into child domains with separate audits and separate claims.

## Child Domains

| Child domain | Purpose | Why separate | Current reality | Dependency notes |
|-------------|---------|--------------|-----------------|------------------|
| `AO_EXECUTION_RECEIPTS` | Tamper-evident effect history | Strongest live implementation artifact, narrow scope, clear observability | Rust crate exists, Coq file exists, tamper tests exist | Can be built first |
| `AO_CONTENT_ADDRESSED_STATE` | Hash-addressed storage and lookup | Distinct from aggregate Merkle semantics and broader blockchain claims | Interpreter store exists; public workflow surface is still narrow | Feeds Merkle and receipts |
| `AO_MERKLE_DAG` | Deterministic aggregate hashing and DAG integrity | Different proof and workflow concerns from plain content store | List-root hashing exists; DAG claims are broader than live tooling | Depends on content-addressed semantics |
| `AO_TOKEN_ACCOUNTING` | Conservation, balances, issuance, and supply discipline | Type-shape transfer is not enough to count as token semantics | Current transfer checks are shallow | Depends on runtime state and receipts |
| `AO_SMART_CONTRACT_RUNTIME` | Stateful contract execution and reentrancy control | `ContractDeploy` wrapper behavior is not a runtime | Live runtime is skeletal | Depends on token/accounting and receipt integration |
| `AO_CONSENSUS_CORE` | Validator/quorum safety and invalidity handling | Consensus is a distinct distributed protocol domain | Stronger local Coq exists; live toolchain support does not | Depends on explicit runtime protocol model |
| `AO_BLOCKCHAIN_INTEGRATION` | Composition of content, contracts, tokens, consensus, and receipts | Umbrella claims fail if child domains do not compose honestly | Not real yet | Depends on all claimed child domains |

## Recommended Order

1. `AO_EXECUTION_RECEIPTS`
2. `AO_CONTENT_ADDRESSED_STATE`
3. `AO_MERKLE_DAG`
4. `AO_TOKEN_ACCOUNTING`
5. `AO_SMART_CONTRACT_RUNTIME`
6. `AO_CONSENSUS_CORE`
7. `AO_BLOCKCHAIN_INTEGRATION`

## Why This Order

- `AO_EXECUTION_RECEIPTS` already has the best live evidence-to-scope ratio.
- `AO_CONTENT_ADDRESSED_STATE` and `AO_MERKLE_DAG` are the next strongest bounded primitives.
- `AO_TOKEN_ACCOUNTING` and `AO_SMART_CONTRACT_RUNTIME` currently overclaim most severely relative to reality.
- `AO_CONSENSUS_CORE` should come after the repo can demonstrate a live protocol surface, not just formal sketches.
- umbrella integration is last because it is only honest once child domains are individually real.

## What Must Not Be Bundled Again

Do not collapse these back into one public statement such as:
- "RIINA has verified blockchain primitives"
- "RIINA supports smart contracts, consensus, and receipts"

unless the exact claimed child domains have individually survived hostile review.

## Safe Interim Umbrella Wording

Until child domains are re-audited and real:
- `AO_BLOCKCHAIN` should be treated as a specified blockchain-primitives umbrella with partial live support for content-addressing and execution receipts, not as an end-to-end blockchain platform.
