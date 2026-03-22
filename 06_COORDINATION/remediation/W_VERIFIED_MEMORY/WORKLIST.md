# W_VERIFIED_MEMORY Remediation Worklist

## Immediate (audit cleanup)
- [ ] Remove riina-arena as implementation evidence from audit
- [ ] Rewrite safe claim to "abstract Coq model" only
- [ ] Add failing gate scores (G3, G7, G8, G9, G11, G13, G14)
- [ ] Add generated-lane disclaimers for non-Coq W001 files
- [ ] Demote OLD_RESEARCH file for audit purposes

## Phase 2 (formal model)
- [ ] Add CAlloc/CFree/CRead to exec semantics
- [ ] Make alloc/free interact with free_lists state
- [ ] Replace W_001_09 (identity) with real separation monotonicity
- [ ] Replace W_001_22 (contradiction-in-hypothesis) with real overflow check
- [ ] Fix W_001_31 (self-equality) with real uniqueness proof
- [ ] Remove duplicate W_001_14/W_001_16 outcomes
- [ ] Fix region isolation to not assume disjointness

## Phase 3 (implementation)
- [ ] Wire verified allocator into live compiler consumers
- [ ] Replace raw calloc/malloc/realloc in codegen
- [ ] Add positive .rii memory workflow example
- [ ] Add negative .rii memory workflow (use-after-free rejected)
- [ ] Add adversarial test suite for memory violations
