# AK_VERIFIED_PROCUREMENT Remediation Plan v1.0.0

## Purpose

Turn `AK_VERIFIED_PROCUREMENT` from a research-first procurement umbrella with bounded smoke models into a domain that can eventually support honest bounded compile-time procurement claims.

## Current Truth

As of [AK_VERIFIED_PROCUREMENT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AK_VERIFIED_PROCUREMENT_R5_AUDIT.md) and [AK_VERIFIED_PROCUREMENT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AK_VERIFIED_PROCUREMENT_R5_REVIEW.md):
- `AK_VERIFIED_PROCUREMENT` is `R1`
- the repo has a strong procurement research set
- the live formal/implementation footprint is limited to bounded TLA+ and Alloy smoke models
- no live procurement syntax, types, effects, or runtime semantics exist in the core frontend
- the canonical procurement example does not parse through the actual toolchain
- no Coq procurement lane exists despite research wording that suggests otherwise

## Governing Rule

The domain may not be claimed above the weakest live link. Today that weakest link is the total absence of live procurement enforcement in the frontend/runtime and the absence of a matching Coq lane.

## Non-Negotiable Remediation Principles

1. Procurement research is not the same thing as procurement enforcement.
2. Bounded smoke models are useful, but they do not stand in for workflow-complete formalization.
3. Canonical examples do not count unless they parse, typecheck, and run in CI.
4. Standards mappings do not count as guarantees unless they are tied to live rejected states and live accepted states.
5. Public or research wording must stay at the reviewer-safe level until the bounded live slice is real.

## Required Strategic Shift

### 1. Pick one bounded procurement slice

Required outcome:
- one narrow, explicitly scoped procurement lifecycle becomes the canonical live slice
- example: request publication -> supplier eligibility -> bid submission -> award decision
- every out-of-scope procurement step is stated openly

### 2. Implement the bounded slice in the live frontend

Required outcome:
- procurement syntax parses in the current language
- bounded state/types/effects exist in the core frontend
- invalid state transitions are rejected by the actual toolchain

### 3. Mirror that same slice in Coq

Required outcome:
- a live Coq file exists for the exact same bounded slice
- theorems cover state transitions and invalidity, not only boolean unpacking
- workflow-to-proof mapping is explicit

### 4. Make canonical workflows executable

Required outcome:
- at least one valid procurement workflow passes end-to-end
- at least one invalid workflow is rejected by the parser, typechecker, or runtime
- `07_EXAMPLES/08_jalinan/procurement.rii` or its replacement is a real executable artifact

### 5. Re-scope smoke-model evidence

Required outcome:
- TLA+ and Alloy stay as bounded support evidence
- they are not used as umbrella proof inflation
- their exact scope and limitations are stated in public wording

### 6. Repair public wording

Required outcome:
- research and public docs stop claiming compile-time refusal or mechanized theorem coverage for the whole umbrella
- wording matches only the bounded live slice

## Execution Order

1. Freeze public procurement wording at `R1`.
2. Define the first bounded procurement slice and live workflow matrix.
3. Implement parser/typechecker/runtime semantics for that slice.
4. Create the matching Coq lane.
5. Make the canonical example executable.
6. Re-audit the bounded child domain.
7. Re-audit umbrella `AK_VERIFIED_PROCUREMENT` only after child-domain evidence is real.

## Exit Criteria

`AK_VERIFIED_PROCUREMENT` may not move above `R1` until:
- one bounded procurement slice exists in the live frontend
- the canonical procurement workflow parses and executes
- a matching Coq lane exists for that same slice
- research wording stops implying full compile-time procurement enforcement
