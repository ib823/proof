# Paper 5: Formally Verified Accessible UI — The CAHAYA Framework

## Abstract

We present CAHAYA (Cara Akses Hebat Antara-muka Yang Aksesibel), RIINA's
UI framework with compile-time accessibility guarantees. CAHAYA uses the
type system to enforce WCAG 2.1 AA compliance: color contrast ratios,
keyboard navigability, screen reader compatibility, and semantic structure
are all checked statically. We formalize accessibility properties as types
and prove that well-typed CAHAYA programs produce accessible interfaces.

## Key Results

- **Theorem: Contrast Compliance** — All text rendered by a well-typed
  CAHAYA program meets WCAG 2.1 AA contrast ratios (4.5:1 for normal text,
  3:1 for large text).
- **Theorem: Keyboard Completeness** — Every interactive element in a
  well-typed CAHAYA program is keyboard-reachable and operable.
- **Theorem: Semantic Soundness** — The generated UI tree has valid ARIA
  roles, labels, and relationships.
- **Theorem: Focus Management** — Focus order follows a well-defined
  traversal that matches visual layout.

## CAHAYA Primitives

- `paparan` — view/component declaration
- `tulisan` — text with style constraints
- `butang` — button with action handler
- `medan_teks` — text input field
- `label` — accessible label bound to input
- `warna` — color with contrast checking

## Related Work (Sketch)

- Bigham et al. (2017) — Automated accessibility testing
- Swallow, Petrie & Power (2014) — Compile-time UI verification
- Brady (2013) — Idris type-driven development (inspiration for type-level proofs)
- WCAG 2.1 (W3C 2018) — Web Content Accessibility Guidelines

## Venue Target

**CHI** (ACM Conference on Human Factors in Computing Systems)
or **ASSETS** (ACM SIGACCESS Conference on Computers and Accessibility)

## Coq Source Files

- `02_FORMAL/coq/cahaya/` (accessibility proofs)
- `02_FORMAL/coq/ui/` (UI type soundness)
