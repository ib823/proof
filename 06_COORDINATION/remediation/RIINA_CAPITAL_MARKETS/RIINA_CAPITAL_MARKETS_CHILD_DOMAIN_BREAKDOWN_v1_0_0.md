# RIINA_CAPITAL_MARKETS Child-Domain Breakdown v1.0.0

This is a likely decomposition, not yet a confirmed queue expansion.

## Probable Child Domains

1. `RIINA_CAPMARKET_ORDERBOOK_CORE`
   - order priority
   - matching rules
   - price-time fairness

2. `RIINA_CAPMARKET_TRADE_AND_SETTLEMENT`
   - trade balance
   - settlement completion
   - finality and asset delivery

3. `RIINA_CAPMARKET_MARKET_DATA`
   - ticks
   - ordering
   - feed integrity

4. `RIINA_CAPMARKET_FX_AND_MULTI_ASSET`
   - FX execution integrity
   - cross-asset margin/netting
   - multi-asset boundaries

5. `RIINA_CAPMARKET_POST_TRADE_AND_RISK`
   - clearing
   - reconciliation
   - collateral and risk workflows

6. `RIINA_CAPMARKET_INTEGRATION`
   - executable examples
   - compiler/runtime/formal alignment
   - public claim discipline

## Why a Split Is Likely

- the current umbrella bundles exchange matching, settlement, market data, FX, multi-asset, and post-trade concerns into one claim
- the live repo today only has a bounded formal file and no toolchain subsystem
- a child-domain split will likely be required before the umbrella can honestly move beyond `R2`
