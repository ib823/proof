# K_METAPROGRAMMING_AND_EXISTING_SYSTEMS — Remediation Plan v1.0.0

**Domain:** K_METAPROGRAMMING_AND_EXISTING_SYSTEMS
**Current Rating:** R1 | **Target:** R2
**Created:** 2026-03-21 | **Authority:** RIINA_MASTER_PLAN.md

---

## 1. Purpose

Remediate Domain K from R1 to R2. The core problem: no metaprogramming implementation exists. The Coq layer is 89% reflexivity proofs. Only research documentation exists, earning R1.

## 2. Current Truth (Verified)

| Asset | Status | Evidence |
|-------|--------|----------|
| Macro/derive system | Not implemented | No parser/typechecker support |
| Metaprogramming.v | Vacuous | 89% reflexivity proofs |
| Research specification | Exists | Research docs in 01_RESEARCH/ |
| Compile-time code generation | Not implemented | N/A |
| Hygienic macro model | Not implemented | N/A |

## 3. Governing Rules

- 89% reflexivity Coq files are vacuous and count as zero formal evidence
- R2 requires working implementation, not just specification
- Metaprogramming must be hygienic (no accidental variable capture) for RIINA's safety guarantees to hold

## 4. Required Structural Changes

### 4.1 Macro System Design Decision
Choose one of:
- **Derive macros:** Auto-generate trait implementations (lower complexity, Rust-like)
- **Syntax macros:** Token-tree rewriting (higher complexity, Lisp-like)
- **Attribute macros:** Annotation-driven code generation

Derive macros are recommended for R2 as the simplest path with clear safety properties.

### 4.2 Implementation Requirements
- Parser: recognize macro invocation syntax
- Typechecker: validate macro-generated code
- Expansion: macro expansion before type checking

### 4.3 Coq Rewrite
Replace Metaprogramming.v with nontrivial properties:
- Macro hygiene: generated bindings do not capture ambient variables
- Expansion termination: macro expansion terminates

## 5. Per-Gate Remediation

### Gate R1 (Current — verified hold)
- Research exists, no implementation, vacuous Coq

### Gate R2 (Target)
Requires ALL of:
1. At least one macro form implemented (derive recommended)
2. Parser + expansion working with tests
3. At least one nontrivial Coq proof about macro properties
4. Positive and negative tests (valid macro use, invalid macro rejection)

### Gate R3 (Future)
- Hygiene enforcement with proofs
- Multiple macro forms
- .rii macro examples in integration tests
- Macro-aware error messages

### Gate R4 (Future)
- Full macro hygiene soundness proof
- Macro expansion preserves typing (type soundness through expansion)
- Compile-time computation model with resource bounds
