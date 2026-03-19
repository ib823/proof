# RIINA_BANK Child-Domain Breakdown v1.0.0

This is a likely decomposition, not yet a confirmed queue expansion.

## Probable Child Domains

1. `RIINA_BANK_CIF_AND_KYC`
   - customer identity
   - KYC/AML screening
   - sanctions and PEP controls

2. `RIINA_BANK_LEDGER_AND_DEPOSITS`
   - balances
   - double-entry invariants
   - dormancy and term-deposit rules

3. `RIINA_BANK_LENDING`
   - eligibility
   - collateral coverage
   - amortization and covenant logic

4. `RIINA_BANK_PAYMENTS_AND_SETTLEMENT`
   - instant payments
   - idempotency
   - SWIFT and Nostro handling

5. `RIINA_BANK_TREASURY_AND_MARKETS`
   - FX
   - repo
   - bond accrual
   - derivative valuation

6. `RIINA_BANK_ISLAMIC_FINANCE`
   - murabaha
   - ijarah
   - musharakah
   - sukuk
   - no-riba constraints

7. `RIINA_BANK_INTEGRATION`
   - cross-module workflows
   - executable examples
   - public claim discipline

## Why a Split Is Likely

- the current umbrella bundles many banking product families and control layers into one claim
- the live repo today only has a broad formal file and no executable subsystem
- a child-domain split will likely be required before the umbrella can honestly move beyond `R2`
