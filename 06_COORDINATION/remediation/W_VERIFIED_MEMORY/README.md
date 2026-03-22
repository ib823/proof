# W_VERIFIED_MEMORY Remediation Package

## Reconciliation Summary
- **Original audit rating**: R2
- **Hostile review rating**: R2 (abstract formal modeling only; reject audit as written)
- **Reconciled rating**: R2 (keep; narrow to abstract modeling; remove implementation claims)
- **Review date**: 2026-03-22

## Root Cause
The audit overclaimed live implementation by treating riina-arena (an AST-node arena)
as verified-memory evidence, while the live C backend still uses raw calloc/malloc/realloc.

## Critical Defects
1. riina-arena is AST storage, not a verified allocator; no crate depends on it
2. Live codegen emits raw calloc/malloc/realloc calls
3. Coq `exec` semantics omit allocation/free/read commands
4. `alloc`/`free` never touch `free_lists` in the model
5. Region isolation was aborted then weakened to require disjointness as assumption
6. Many theorems are vacuous, duplicate, or assumption-baked
7. Non-Coq lanes are generated/derived

## Promotion Path: R2 -> R3
- Add exec semantics for CAlloc, CFree, CRead in Coq model
- Wire verified allocator into live runtime/backend
- Create positive/negative end-to-end memory workflow examples
- Add adversarial tests for use-after-free, double-free, buffer overflow
