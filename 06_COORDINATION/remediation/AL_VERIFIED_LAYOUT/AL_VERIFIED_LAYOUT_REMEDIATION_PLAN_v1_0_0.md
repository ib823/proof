# AL_VERIFIED_LAYOUT Remediation Plan v1.0.0

## Purpose

Turn `AL_VERIFIED_LAYOUT` from a broad research thesis plus partial CAHAYA/UI implementation into a domain that can eventually support honest bounded verified-layout claims.

## Current Truth

As of [AL_VERIFIED_LAYOUT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AL_VERIFIED_LAYOUT_R5_AUDIT.md) and [AL_VERIFIED_LAYOUT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AL_VERIFIED_LAYOUT_R5_REVIEW.md):
- `AL_VERIFIED_LAYOUT` is `R2`
- live CAHAYA support exists for basic display, row/column composition, text, button, color, contrast, and style
- a standalone `riina-ui` crate exists with terminal/HTML renderers, layout helpers, and 45 passing tests
- the standalone crate is not wired into the live compiler backend targets
- the canonical `hello_ui.rii` example fails to parse
- research/spec wording overclaims perfect UI/UX, pixel-perfect responsiveness, and broad cross-platform guarantees

## Governing Rule

The domain may not be claimed above the weakest live link. Today that weakest link is the gap between the bounded working CAHAYA subset and the much broader public thesis.

## Non-Negotiable Remediation Principles

1. A standalone UI crate is not the same thing as a live language capability.
2. A passing contrast helper is not the same thing as full accessibility enforcement.
3. Boolean-heavy formal files do not justify perfect-UI claims.
4. Broken canonical examples invalidate strong public statements immediately.
5. Flexbox/grid/responsive claims remain out of scope until they are live and audited.

## Required Strategic Shift

### 1. Freeze the claim surface

Required outcome:
- all public wording drops to the reviewer-safe `R2` claim
- perfect-UI and pixel-perfect claims are removed or explicitly marked research-only

### 2. Pick the bounded live slice

Required outcome:
- one explicit scope statement for the current live slice:
  - basic display trees
  - row/column composition
  - terminal/HTML rendering
  - WCAG contrast checks
- all broader layout aspirations are clearly marked out of scope

### 3. Integrate the renderer path

Required outcome:
- `riina-ui` is either wired into `riinac` backends or replaced by an integrated equivalent
- HTML/terminal rendering is reachable through a stable compiler path

### 4. Repair canonical examples

Required outcome:
- all canonical CAHAYA examples parse and execute
- broken button-handler syntax no longer invalidates the domain's basic examples

### 5. Strengthen the formal-to-live binding

Required outcome:
- live examples map directly to the bounded Coq properties
- accessibility proofs move beyond config booleans where the live toolchain claims enforcement
- non-Coq derived lanes are treated as secondary, not independent, evidence

## Execution Order

1. Reduce wording to the bounded live slice.
2. Make all canonical CAHAYA examples executable.
3. Add real HTML/terminal compiler integration.
4. Refactor the formal model around the same bounded slice.
5. Add end-to-end negative UI/accessibility workflows.
6. Re-audit `AL_VERIFIED_LAYOUT`.

## Exit Criteria

`AL_VERIFIED_LAYOUT` may not move above `R2` until:
- the live UI crate is actually reachable from the compiler
- all canonical examples pass
- public wording stops claiming perfect UI/UX
- the formal model is tied to live executable workflows rather than mostly sample-instance validity
