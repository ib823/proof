# W_VERIFIED_MEMORY Remediation Plan

## Phase 1: Audit Repair (immediate)
1. Remove all riina-arena implementation language from audit
2. Rewrite safe claim: "abstract Coq model for heap/separation/ownership concepts"
3. Score G3/G7/G8/G9/G11/G13/G14 as failing with citations
4. Add generated-lane disclaimers for non-Coq W001 files

## Phase 2: Formal Model Strengthening
1. Add exec semantics for CAlloc, CFree, CRead in W001_VerifiedMemory.v
2. Make alloc/free interact with free_lists
3. Replace vacuous theorems with properties over real allocator state transitions
4. Fix region isolation: prove without assuming disjointness as precondition
5. Remove duplicate theorem outcomes (W_001_14/W_001_16)

## Phase 3: Implementation (R2 -> R3)
1. Wire riina-arena or new verified allocator into compiler/runtime consumers
2. Replace raw calloc/malloc/realloc in codegen with arena-backed allocation
3. Add positive example: safe memory workflow end-to-end
4. Add negative example: rejected use-after-free or double-free
5. Add adversarial tests for buffer overflow, heap corruption

## Dependencies
- Overlaps with F_MEMORY_SAFETY; coordinate changes
