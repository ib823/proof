# Domain Audit Record

## 1. Identity

- Domain name: RIINA Capital Markets
- Domain identifier: `RIINA_CAPITAL_MARKETS`
- Folder(s): `01_RESEARCH/39_DOMAIN_RIINA_CAPITAL_MARKETS/`, `02_FORMAL/coq/domains/CapitalMarkets.v`
- Audit date: `2026-03-19`
- Auditor: Codex
- Current repo commit: `5e861d69924fd904619cc56f2a6734d571ccbb06`
- Command-derived Rust passing tests on this snapshot: `2476`
- `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings` on this snapshot: `passed`
- `audit-docs.sh` status on this snapshot before the audit: `0 discrepancies`, `1 warning`

## 2. Canonical Source Map

### Canonical research authority

- `01_RESEARCH/39_DOMAIN_RIINA_CAPITAL_MARKETS/RESEARCH_CAPMARKET01_FOUNDATION.md`

### Canonical formal files

- `02_FORMAL/coq/domains/CapitalMarkets.v`
- secondary lanes:
  - `02_FORMAL/lean/RIINA/Domains/CapitalMarkets.lean`
  - `02_FORMAL/isabelle/RIINA/Domains/CapitalMarkets.thy`
  - `02_FORMAL/fstar/RIINA/Domains/CapitalMarkets.fst`
  - `02_FORMAL/alloy/RIINA/Domains/CapitalMarkets.als`
  - `02_FORMAL/smt/RIINA/Domains/CapitalMarkets.smt2`
  - `02_FORMAL/tlaplus/RIINA/Domains/CapitalMarkets.tla`
  - `02_FORMAL/tv/RIINA/Domains/CapitalMarkets.tv.smt2`

### Live implementation search result

No dedicated capital-markets subsystem was found in the live compiler/runtime crates. Searches across `03_PROTO` for trading, settlement, securities, repo, bond, FX, treasury, and derivatives did not reveal a real AST/typechecker/runtime feature set for this domain.

### Canonical example search result

No canonical capital-markets examples were found in `07_EXAMPLES` by filename search.

## 3. Current Scope Assessment

### What the research claims

The research file claims RIINA will make:
- NASDAQ
- Bloomberg
- Reuters
- all trading platforms

obsolete, across:
- market data
- FX
- multi-asset trading
- clearing and settlement
- post-trade infrastructure

### What the live repo actually supports

- one bounded Coq formalization centered on:
  - order priority
  - simple trade balance
  - settlement consistency
  - basic order matching
  - monotonic tick ordering
- no live trading language subsystem
- no executable capital-markets workflow examples

### What is not honestly supported yet

- live order-book semantics in the compiler/runtime
- trading or settlement workflows through `riinac`
- market-data, FX, repo, bond, derivative, or multi-asset modules as live language features
- any real platform replacing an exchange, OMS, EMS, or market-data plant

## 4. Workflow Inventory

| Workflow | Current status | Evidence |
|----------|----------------|----------|
| Formal reasoning about bounded order-book and settlement properties | Exists | `CapitalMarkets.v` has 26 theorem statements |
| Live compile-time trading or settlement workflows | Missing | no corresponding compiler/runtime subsystem in `03_PROTO` |
| Executable capital-markets example through `riinac` | Missing | no canonical examples found in `07_EXAMPLES` |

## 5. Formal Depth Assessment

### Coq

`CapitalMarkets.v` is real and bounded. It models:
- order sides and price-time priority
- trades and simple settlement
- order books and match execution
- monotonic market ticks

Some theorems are structurally meaningful:
- `higher_price_buy_wins`
- `lower_price_sell_wins`
- `match_only_when_price_crosses`
- `no_match_when_price_gap`

Many others are still shallow or definitional:
- `trade_always_balanced`
- `trade_consideration_zero_qty`
- `trade_consideration_zero_price`
- `settlement_complete_implies_final`

This is a real formal core for a narrow slice, but it is nowhere near the research document's broad capital-markets platform thesis.

### Non-Coq lanes

- `CapitalMarkets.als` is `Auto-generated from 02_FORMAL/coq/domains/CapitalMarkets.v`
- `CapitalMarkets.smt2` contains many `= 0 0` placeholders
- `CapitalMarkets.tla` contains `== TRUE` definitions
- `CapitalMarkets.tv.smt2` is also derived

Conclusion:
- the domain exceeds pure research-only status because the Coq slice is real
- the secondary lanes are not safe to count as strong independent evidence

## 6. Live Implementation Assessment

Searches across:
- `03_PROTO/crates/riina-types/src`
- `03_PROTO/crates/riina-parser/src`
- `03_PROTO/crates/riina-typechecker/src`
- `03_PROTO/crates/riina-codegen/src`

did not surface:
- orders
- trades
- settlements
- order books
- market-data types
- FX or repo semantics
- post-trade capital-markets modules

Current reality:
- the capital-markets lane is a bounded formal file without a live toolchain counterpart

## 7. Executable Evidence

Commands run on this snapshot:

```bash
find 07_EXAMPLES -type f | grep -Ei 'market|trading|settlement|securities|repo|bond|fx|treasury|capital'
grep -RIn --exclude-dir=target --exclude-dir=.git -E 'order|trade|settlement|orderbook|market data|fx|repo|bond|derivative' 03_PROTO/crates/riina-types/src 03_PROTO/crates/riina-parser/src 03_PROTO/crates/riina-typechecker/src 03_PROTO/crates/riina-codegen/src
```

Observed outcomes:

- no canonical capital-markets example files found
- no live capital-markets subsystem in the compiler/runtime crates

## 8. Gate Scores

| Gate | Score | Basis | Consequence |
|------|-------|-------|-------------|
| `G1` Canonical Identity | Partial | One canonical research file and one bounded Coq file exist, but no live implementation slice exists | Identity is research/formal-heavy |
| `G2` Boundary Precision | Fail | Research claims a world-replacing capital-markets platform while the live formal slice is a small order-book model | Caps enforcement claims |
| `G3` Workflow Inventory | Partial | Research enumerates broad workflows, but only a narrow formal subset exists and nothing is live | Blocks `R3-R4` |
| `G4` Threat and Failure Model | Partial | Matching and settlement constraints exist formally, but adversarial market abuse and runtime failure handling are not live | Blocks `R4` |
| `G5` Property Set | Partial | Domain-shaped properties exist for order priority, crossing, settlement balance, and tick ordering | Supports formal modeling only |
| `G6` Formal Model Depth | Partial | Real bounded Coq formalization exists, but the scope is narrow and mixed with shallow lemmas | Supports `R2` |
| `G7` Toolchain Enforcement | Fail | No live trading or settlement subsystem exists in `03_PROTO` | Blocks `R3` |
| `G8` Executable Evidence | Fail | No canonical capital-markets examples execute through the toolchain | Blocks `R3` |
| `G9` Adversarial Evidence | Fail | No live negative trading/settlement workflow suite exists | Blocks `R4` |
| `G10` Independent Evidence Honesty | Fail | Secondary lanes are generated/vacuous (`Auto-generated`, `= 0 0`, `== TRUE`) | They must not be counted as serious independent evidence |
| `G11` Observability and Auditability | Fail | No live capital-markets runtime artifact or evidence chain exists | Blocks `R4-R5` |
| `G12` Freshness and Reproducibility | Pass | Commands are reproducible on current `HEAD` | Audit is reproducible |
| `G13` Public Claim Discipline | Fail | Research claims total platform obsolescence and domination of global capital markets | Wording must be reduced drastically |
| `G14` Regression Immunity | Fail | No capital-markets-specific readiness gate exists | Rating is not protected |

## 9. Rating

- Current rating: `R2`
- Rating cap: `R2`
- Why this is not lower:
  - a real capital-markets Coq slice exists
  - the properties are domain-shaped rather than generic security boilerplate
- Why this is not higher:
  - there is no live capital-markets subsystem in the toolchain
  - there are no executable examples
  - the formal scope is much narrower than the research thesis
  - secondary prover lanes are generated or vacuous

## 10. Safe Public Wording

- Safe claim:
  - `RIINA currently contains a bounded formal capital-markets model covering selected order-priority, trade-balance, settlement, and tick-ordering properties. It does not yet provide a live executable trading, market-data, or settlement subsystem in the language toolchain.`
- Unsafe claim:
  - `RIINA is a fully verified capital-markets platform that makes NASDAQ, Bloomberg, Reuters, and all trading systems obsolete with live end-to-end trading and settlement guarantees.`

## 11. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| No live capital-markets subsystem | Critical | Build a bounded order/trade/settlement slice in the compiler/runtime | Pending | Main blocker |
| No canonical examples | Critical | Add bounded live trading/settlement examples | Pending | Needed for any move beyond `R2` |
| Research wording is wildly stronger than reality | Critical | Reduce wording to the bounded formal-model claim | Pending | Trust blocker |
| Formal scope is too narrow relative to thesis | High | Split into child domains and keep claims bounded | Pending | Needed for depth |
| Secondary lanes are vacuous | High | Exclude or replace them with honest models | Pending | Independent-evidence blocker |
| No capital-markets regression gates | Medium | Add readiness checks for the bounded live slice | Pending | Needed for `R4-R5` |

## 12. Promotion Checklist

### To stay honest at `R2`

- [x] Canonical research source exists
- [x] Real Coq slice exists
- [x] Domain-shaped properties exist
- [ ] Public wording is reduced to the bounded formal-model status

### To reach `R3`

- [ ] a bounded live capital-markets subsystem exists
- [ ] at least one valid workflow executes through the toolchain
- [ ] at least one invalid workflow is rejected

### To reach `R4`

- [ ] workflow coverage is complete for the stated bounded slice
- [ ] negative and adversarial workflows exist
- [ ] runtime observability exists where needed

### To reach `R5`

- [ ] every gate `G1-G14` passes
- [ ] third-party reproduction is straightforward
- [ ] public wording is exact and conservative
- [ ] capital-markets regression gates exist and are enforced

## 13. Sign-Off

- Final verdict:
  - `R2` is the maximum honest rating at commit `5e861d69924fd904619cc56f2a6734d571ccbb06`.
- Reviewer notes:
  - hostile review completed in [RIINA_CAPITAL_MARKETS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_CAPITAL_MARKETS_R5_REVIEW.md)
  - review verdict: `accept`
  - review confirmed the `R2` cap and agreed that the current reality is a bounded Coq capital-markets model with no live toolchain counterpart
- Follow-up date:
  - after bounded live order/trade/settlement semantics and executable examples justify re-audit
