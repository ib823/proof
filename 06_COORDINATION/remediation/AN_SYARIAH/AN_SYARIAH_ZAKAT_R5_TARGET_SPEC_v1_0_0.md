# AN_SYARIAH_ZAKAT R5 Target Spec v1.0.0

## Goal

Define the narrowest serious `AN_SYARIAH` vertical that can realistically be made `R5` first.

Chosen vertical:
- `AN_SYARIAH_ZAKAT`

## Why Zakat First

- it is lifecycle-shaped
- it has concrete accounting semantics
- it supports exact rejection rules
- it supports receipts and auditability naturally
- it is narrow enough to be made serious without pretending to cover all Islamic finance

## Scope Statement

This target covers:
- zakatable wealth declaration
- asset categorization for the supported profile
- nisab threshold evaluation
- haul completion evaluation
- net-zakatable-base calculation
- 2.5% computation where that rate is applicable under the selected profile
- recipient-class validation
- calculation receipts
- invalid-case rejection

This target does not yet cover:
- agricultural produce
- livestock
- mining/treasure-specific rules
- cross-border fiat treatment outside the declared profile
- discretionary jurisprudential exceptions not encoded in the selected profile

Unsupported or ambiguous cases must produce:
- `RequiresBoardReview`
or
- explicit compile-time/runtime rejection

## Supported Policy Profile Strategy

R5 for zakat must be profile-bounded.

Minimum serious launch:
- one explicit profile such as `AAOIFI_ZAKAT_CORE_V1`

Future profiles:
- `BNM_ZAKAT_CORE_V1`
- `BOARD_CUSTOM_ZAKAT_V1`

Rules:
- profile selection must be mandatory
- no implicit default profile
- profile mismatch must fail closed

## Domain Model Requirements

## 1. Entities

- `Payer`
- `Asset`
- `Liability`
- `HoldingPeriod`
- `Recipient`
- `Profile`
- `ZakatAssessment`
- `ZakatReceipt`

## 2. Asset categories in the first serious scope

Support a declared subset only. Recommended first subset:
- cash and bank balances
- gold
- silver
- trade inventory
- receivables explicitly permitted by profile

Each asset must carry:
- category
- quantity/value
- valuation timestamp
- ownership status
- encumbrance status
- holding-period evidence

## 3. Core workflow

1. Select profile.
2. Declare asset portfolio.
3. Declare deductible liabilities allowed by profile.
4. Validate ownership and holding period.
5. Evaluate nisab.
6. Evaluate haul.
7. Compute net zakatable base.
8. Compute due amount.
9. Validate recipient class or transfer destination.
10. Emit receipt chain entry.

## 4. Forbidden workflows

- no profile selected
- unsupported asset category silently treated as supported
- haul not completed but zakat treated as obligatory under the chosen profile
- liabilities deducted beyond profile allowance
- non-zakatable assets counted as zakatable
- recipient outside allowed classes treated as valid
- duplicate payment counted twice
- negative or overflowed amounts
- silent fallback on ambiguous rules

## Formal Requirements

## Required Coq artifacts

Recommended canonical file:
- `02_FORMAL/coq/domains/Zakat.v`

Required formal structures:
- inductive asset categories
- profile parameterization
- stateful assessment lifecycle
- validity predicates
- forbidden-state predicates
- receipt relation

Required theorem classes:
- profile totality over supported asset subset
- unsupported-category rejection
- nisab correctness
- haul correctness
- monotonicity of payable amount over additional supported wealth
- non-negativity
- no-double-counting
- recipient-class soundness
- receipt-chain integrity for zakat events
- determinism of assessment under fixed inputs and profile

Unacceptable theorem style:
- pure boolean decomposition without lifecycle semantics
- tautological restatement of definitions
- theorem names stronger than proof content

## Toolchain Requirements

## Syntax and typing

The implementation must expose real zakat constructs, not just a toy numeric function. Minimum serious surface:
- profile declaration
- asset declaration
- liability declaration
- assessment command
- recipient validation
- receipt emission

Type system must reject:
- unsupported asset categories for the selected profile
- missing profile
- malformed recipient category
- invalid liability usage
- impossible negative monetary states

## Runtime/accounting semantics

Runtime must do more than `amount / 40`.

Required runtime capabilities:
- asset aggregation by category
- profile-specific nisab resolution
- haul validation
- deductible-liability validation
- exact arithmetic semantics
- receipt emission
- replay/tamper detection for issued receipts

## Observability

Each assessment must produce a structured artifact containing:
- profile used
- included assets
- excluded assets with reasons
- liabilities deducted with reasons
- nisab decision
- haul decision
- due amount
- recipient validation result
- receipt identifier

## Test Requirements

Required positive tests:
- payer below nisab -> not due
- payer above nisab with completed haul -> due
- mixed supported assets -> correct aggregation
- valid recipient -> accepted

Required negative tests:
- missing profile -> reject
- unsupported asset type -> reject
- haul incomplete -> reject or mark not due according to profile
- disallowed recipient -> reject
- invalid liability deduction -> reject

Required adversarial tests:
- duplicate asset declaration
- duplicate payment receipt
- tampered receipt chain
- boundary values around nisab
- boundary values around haul completion
- overflow/rounding edge cases

## R5 Exit Criteria For AN_SYARIAH_ZAKAT

`AN_SYARIAH_ZAKAT` is not `R5` until:
- all gates `G1-G14` pass for the zakat child domain
- one profile is fully explicit and enforced
- unsupported cases fail closed
- Coq proofs are lifecycle-based and nontrivial
- implementation rejects invalid covered workflows
- executable positive, negative, and adversarial cases all exist
- receipts are emitted and verified
- a hostile reviewer cannot downgrade the child-domain claim

## Safe Public Wording Target

When and only when the above is true, a safe claim may look like:
- “RIINA provides an audited zakat assessment subsystem for profile `AAOIFI_ZAKAT_CORE_V1`, with explicit scope limits, enforced invalid-case rejection, and reproducible receipts.”

Not safe:
- “RIINA proves zakat compliance for all Islamic contexts.”
