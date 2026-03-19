# AN_SYARIAH Child Domain Breakdown v1.0.0

## Rule

Umbrella `AN_SYARIAH` is not allowed to inherit the best child-domain rating. It inherits the weakest claimed child-domain or integration layer.

## Child Domains

| Child Domain | Purpose | Core Workflows | Profile Sensitivity | Suggested Initial Rating | Notes |
|-------------|---------|----------------|---------------------|--------------------------|-------|
| `AN_SYARIAH_ZAKAT` | Verified zakat obligation, calculation, and distribution control | declare assets, determine nisab, validate haul, compute amount, validate recipients, emit receipt | High | `R1` | Best first flagship |
| `AN_SYARIAH_SCREENING_PURIFICATION` | Business-activity screening, financial-ratio checks, impure-income purification | classify issuer/business, compute thresholds, flag prohibited exposure, compute purification | Very high | `R0-R1` | Depends on profile layer |
| `AN_SYARIAH_SUKUK` | Asset-backed certificate issuance and lifecycle | pool assets, issue certificates, distribute returns, redeem, handle default | High | `R0-R1` | Strong capital-markets vertical |
| `AN_SYARIAH_MUDARABAH` | Profit-sharing partnership with loss allocation | capital funding, profit declaration, loss allocation, misconduct handling | High | `R0-R1` | Needs lifecycle model |
| `AN_SYARIAH_MUSHARAKAH` | Joint venture with capital-based allocation | co-investment, profit split, loss split, exit, dissolution | Medium-high | `R0-R1` | Needs accounting model |
| `AN_SYARIAH_TAKAFUL` | Mutual risk pool and surplus/deficit handling | contributions, claims, operator fee, qard handling, surplus distribution | High | `R0-R1` | Needs pool semantics |
| `AN_SYARIAH_WAKAF` | Perpetual endowment and benefit constraints | dedicate asset, preserve corpus, authorize benefit use, reject transfer | Medium-high | `R0-R1` | Strong fit for immutability/linearity |
| `AN_SYARIAH_GOVERNANCE_PROFILES` | Profile selection and board-review boundaries | choose profile, reject unsupported combinations, route ambiguous cases | Very high | `R0-R1` | Required for honesty |
| `AN_SYARIAH_INTEGRATION` | Cross-child-domain interactions and umbrella claims | combined products, asset flow consistency, receipt composition, profile composition | Very high | `R0` | Must come last |

## Dependency Order

1. `AN_SYARIAH_GOVERNANCE_PROFILES`
2. `AN_SYARIAH_ZAKAT`
3. `AN_SYARIAH_SUKUK`
4. `AN_SYARIAH_MUDARABAH`
5. `AN_SYARIAH_MUSHARAKAH`
6. `AN_SYARIAH_TAKAFUL`
7. `AN_SYARIAH_WAKAF`
8. `AN_SYARIAH_SCREENING_PURIFICATION`
9. `AN_SYARIAH_INTEGRATION`

## Canonical Output Per Child Domain

Each child domain should eventually have:
- `audit_outputs/domain_r5/<DOMAIN_ID>_R5_AUDIT.md`
- `audit_outputs/domain_r5/<DOMAIN_ID>_R5_REVIEW.md`
- one canonical research/spec file
- one canonical Coq file
- one implementation surface map
- one executable example set
- one regression gate

## Rating Policy

### Child-domain rating

A child domain may be rated independently.

### Umbrella rating

`AN_SYARIAH` is capped by:
- weakest claimed child domain
- weakest governance/profile control
- weakest integration control

## Public-Claim Discipline

Allowed:
- “RIINA has an audited `R5` zakat subsystem under profile `X`.”

Not allowed:
- “RIINA is R5 for Syariah finance.”

until:
- governance profiles are explicit
- integration is audited
- other claimed child domains are not below the umbrella claim
