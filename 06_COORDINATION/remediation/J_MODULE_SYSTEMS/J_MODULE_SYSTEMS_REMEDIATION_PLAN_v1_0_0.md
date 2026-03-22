# J_MODULE_SYSTEMS — Remediation Plan v1.0.0

**Domain:** J_MODULE_SYSTEMS
**Current Rating:** R1 | **Target:** R2
**Created:** 2026-03-21 | **Authority:** RIINA_MASTER_PLAN.md

---

## 1. Purpose

Remediate Domain J from R1 to R2. The core problem: the parser explicitly skips `modul`/`guna` keywords with a comment "no module system yet." The Coq ModuleSystems.v contains only definitional unfolding proofs. riina-pkg (54 tests) is a package manager, not a language-level module system. Only research specs exist, earning R1.

## 2. Current Truth (Verified)

| Asset | Status | Evidence |
|-------|--------|----------|
| `modul`/`guna` parsing | Not implemented | Parser skips with comment |
| ModuleSystems.v | Vacuous | Definitional unfolding only |
| riina-pkg | Real but wrong scope | Package manager (54 tests), not module system |
| Research specification | Exists | 2 documents in 01_RESEARCH/ |
| Module boundary type checking | Not implemented | N/A |

## 3. Governing Rules

- riina-pkg tests CANNOT count as module system evidence (different concept)
- Definitional unfolding Coq proofs are vacuous
- R2 requires at minimum: working parser support + basic enforcement tests

## 4. Required Structural Changes

### 4.1 Parser Implementation
Implement `modul` and `guna` keyword parsing in riina-parser. At minimum:
- `modul NamaMod { ... }` declares a module
- `guna NamaMod;` imports a module
- Parser produces AST nodes for both

### 4.2 Coq Rewrite
Replace ModuleSystems.v definitional unfolding with at minimum:
- Module well-formedness predicate
- Basic module typing judgment

### 4.3 Scope Clarification
Document that riina-pkg is package management (dependency resolution, versioning) and is evaluated separately from language-level module systems.

## 5. Per-Gate Remediation

### Gate R1 (Current — verified hold)
- Research specification: exists
- No implementation, no formal model

### Gate R2 (Target)
Requires ALL of:
1. `modul`/`guna` parsing implemented and tested (positive + negative cases)
2. At least one nontrivial module-related Coq proof
3. Basic module boundary type checking in riina-typechecker
4. Scope clarification document separating riina-pkg from module system

### Gate R3 (Future)
- Module visibility enforcement (private/public boundaries)
- Circular import rejection with tests
- .rii module examples wired into integration tests
- Module-aware type checking (qualified names, re-exports)

### Gate R4 (Future)
- Module system soundness proof (well-typed modules compose safely)
- Separate compilation correctness
- Module-level effect tracking
