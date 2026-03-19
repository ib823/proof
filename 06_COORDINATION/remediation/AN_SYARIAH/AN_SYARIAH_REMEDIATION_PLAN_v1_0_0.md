# AN_SYARIAH Remediation Plan v1.0.0

## Purpose

Turn `AN_SYARIAH` from an audited `R1` research lane into a domain family that can eventually support honest `R5` claims without relying on lexical support, shallow proofs, or conceptual examples.

This plan does not change the current audit outcome. It defines how to earn a higher rating.

## Current Truth

As of [AN_SYARIAH_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md) and [AN_SYARIAH_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md):
- `AN_SYARIAH` is `R1`
- formal coverage exists, but theorem depth is too shallow for `R2`
- live compiler/runtime support is narrow and not domain-complete
- public wording in research outruns live enforceable reality

## Governing Rule

`AN_SYARIAH` cannot reach `R5` as a single undifferentiated umbrella. It must be decomposed into auditable child domains, each with its own scope, policy profile, formal model, enforcement path, tests, receipts, and public wording.

Umbrella `AN_SYARIAH` may not be rated above the minimum of:
- its claimed child domains
- its cross-domain integration layer
- its public-claim discipline

## Non-Negotiable Remediation Principles

1. No child domain is counted because a keyword exists.
2. No child domain is counted because a theorem name sounds strong.
3. No generated prover lane is counted as serious independent evidence.
4. No workflow counts unless it runs through the actual toolchain.
5. No unresolved jurisprudential variation is auto-decided silently.
6. Any profile-sensitive issue must be expressed as:
   - explicit policy profile selection, or
   - `RequiresBoardReview`
7. Public wording must state the narrowest true scope.

## Required Structural Changes

### 1. Decompose the domain

Break `AN_SYARIAH` into audited child domains:
- `AN_SYARIAH_ZAKAT`
- `AN_SYARIAH_SCREENING_PURIFICATION`
- `AN_SYARIAH_SUKUK`
- `AN_SYARIAH_MUDARABAH`
- `AN_SYARIAH_MUSHARAKAH`
- `AN_SYARIAH_TAKAFUL`
- `AN_SYARIAH_WAKAF`
- `AN_SYARIAH_GOVERNANCE_PROFILES`
- `AN_SYARIAH_INTEGRATION`

### 2. Introduce policy profiles

No serious Syariah system can pretend there is one universal rule set. RIINA needs explicit policy profile support, for example:
- `AAOIFI_CORE_V1`
- `BNM_CORE_V1`
- `BOARD_CUSTOM_V1`

Rules:
- profile choice must be explicit in specs and artifacts
- unsupported profile combinations must fail closed
- unresolved fiqh variation must not be auto-passed

### 3. Rebuild the formal model style

The current boolean-flag style in [SyariahCompliance.v](/workspaces/proof/02_FORMAL/coq/domains/SyariahCompliance.v) is not enough. Replace it with:
- inductive domain states
- typed lifecycle transitions
- forbidden-state predicates
- accounting invariants
- trace properties
- invalidity theorems

### 4. Rebuild the implementation style

The live Rust layer must move from:
- wrapper-only types
- token/`zakat` fragments
- conceptual examples

to:
- scoped domain AST
- profile-aware typechecking
- invalid workflow rejection
- runtime accounting and receipts
- audited examples
- adversarial tests

## Execution Order

### Phase 0: Claim Reset

Objective:
- ensure docs, research wording, and examples do not imply live full-stack Syariah enforcement

Required outputs:
- safe public wording for umbrella `AN_SYARIAH`
- explicit statement that current domain is `R1`
- profile-sensitive claims marked as future work

### Phase 1: Domain Split

Objective:
- create child-domain boundaries and isolate what can realistically be made `R5`

Required outputs:
- child-domain audit IDs
- canonical spec file per child domain
- exclusion list per child domain
- dependency graph across child domains

### Phase 2: First Flagship Vertical

Objective:
- take `AN_SYARIAH_ZAKAT` to `R5` first

Why zakat first:
- high formalizability
- strong accounting semantics
- natural audit trail
- narrower jurisprudential ambiguity than other products
- direct value to “serious, not for show” proof discipline

### Phase 3: Profile/Governance Layer

Objective:
- add board-review boundaries and policy profile selection

Required outputs:
- profile selection syntax
- unsupported-profile rejection behavior
- `RequiresBoardReview` path
- proofs that unsupported ambiguity does not silently pass

### Phase 4: Contract Verticals

Objective:
- implement and verify `Sukuk`, `Mudarabah`, `Musharakah`, `Takaful`, `Wakaf`

Order:
1. `AN_SYARIAH_SUKUK`
2. `AN_SYARIAH_MUDARABAH`
3. `AN_SYARIAH_MUSHARAKAH`
4. `AN_SYARIAH_TAKAFUL`
5. `AN_SYARIAH_WAKAF`

### Phase 5: Screening and Purification

Objective:
- implement business-activity screening, financial-ratio thresholds, impure-income detection, and purification

Why late:
- depends on profile layer
- requires portfolio/entity modeling and receipts

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
- declared supported policy profiles
- excluded cases
- AST/type/runtime semantics
- invalid workflow rejection
- positive workflow tests
- negative workflow tests
- adversarial tests
- receipts or observability artifacts
- reviewer-safe public wording

## Exit Criteria For Umbrella AN_SYARIAH

`AN_SYARIAH` may be reconsidered for `R5` only when:
- every claimed child domain is at least `R4`
- flagship child domains are `R5`
- `AN_SYARIAH_GOVERNANCE_PROFILES` is at least `R4`
- `AN_SYARIAH_INTEGRATION` is at least `R4`
- no public wording outruns the weakest real link
- an adversarial reviewer cannot downgrade the umbrella on cross-domain composition grounds

## Immediate Next Action

Do not broaden. Narrow.

Start with:
- [AN_SYARIAH_ZAKAT_R5_TARGET_SPEC_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AN_SYARIAH/AN_SYARIAH_ZAKAT_R5_TARGET_SPEC_v1_0_0.md)
- [AN_SYARIAH_R1_TO_R5_WORKLIST_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AN_SYARIAH/AN_SYARIAH_R1_TO_R5_WORKLIST_v1_0_0.md)
