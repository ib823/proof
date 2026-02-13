# Worker C: F* Vacuous Lemma Survey

**Date:** 2026-02-12
**Total Vacuous Lemmas:** 1,158
**Pattern:** `val name : unit -> Lemma (True)`

## Summary by Category

| Category | Count | % of Total | Priority | Estimated Hours |
|----------|-------|------------|----------|-----------------|
| **Properties** | 499 | 43.1% | **CRITICAL** | 120-180 |
| **Industries** | 375 | 32.4% | Medium | 80-120 |
| **Compliance** | 108 | 9.3% | Medium | 30-50 |
| **Termination** | 80 | 6.9% | High | 40-60 |
| **Effects** | 36 | 3.1% | High | 20-30 |
| **Foundations** | 30 | 2.6% | **CRITICAL** | 30-40 |
| **TypeSystem** | 30 | 2.6% | **CRITICAL** | 30-40 |
| **Domains** | 0 | 0.0% | N/A | 0 |
| **TOTAL** | **1,158** | **100%** | — | **350-520** |

## Termination Breakdown (80 total)

| File | Count | Notes |
|------|-------|-------|
| ReducibilityFull.fst | 40 | Logical relations for strong normalization |
| SizedTypes.fst | 16 | Sized type termination metrics |
| Reducibility.fst | 9 | Core reducibility lemmas |
| StrongNorm.fst | 8 | Strong normalization proofs |
| TerminationLemmas.fst | 7 | Auxiliary termination lemmas |

## Crypto Relevance Analysis

**CRITICAL FINDING:** The 1,158 stubs are NOT crypto primitive implementations.
They are **security property proofs** that ENABLE crypto correctness.

### Crypto-Relevant Categories (Priority Order)

1. **Properties (499)** — NonInterference, SecurityProperties, Declassification
   - These prove information flow security
   - Required for proving crypto operations don't leak secrets
   - Example: `noninterference_aead` would prove AEAD doesn't leak plaintext

2. **Foundations (30) + TypeSystem (30) + Effects (36) = 96** — Core language
   - Type safety, effect soundness, substitution lemmas
   - Foundation for all security properties

3. **Termination (80)** — Strong normalization
   - Proves all crypto operations terminate
   - Required for WCET bounds (constant-time crypto)

4. **Compliance (108) + Industries (375) = 483** — Regulatory
   - FIPS 140-3, Common Criteria, PCI-DSS compliance
   - Lower priority than core crypto correctness

## Actual Crypto Primitive Status

**Files checked:**
- `RIINA/Domains/CryptographicSecurity.fst` — 42 lines, 3 trivial lemmas (policy only)
- `RIINA/Domains/ConstantTimeCrypto.fst` — 26 lines, 1 trivial lemma (trace policy only)

**No crypto primitive implementations exist.** The files define:
- Crypto policies (key sizes, nonce uniqueness)
- Constant-time execution traces
- Basic policy validation lemmas

**To implement real crypto:**
- Option A: Bind to HACL* (import verified primitives)
- Option B: Implement from scratch (AES, ChaCha20, Poly1305, etc.)

## Recommended Attack Strategy

### Phase 1: Core Foundations (Priority: CRITICAL, 100-120 hours)
1. Foundations (30) — Type definitions, substitution
2. TypeSystem (30) — Type safety proofs
3. Effects (36) — Effect system soundness
4. Termination core (ReducibilityFull 40) — Strong normalization

**Deliverable:** Core language semantics verified

### Phase 2: Security Properties (Priority: CRITICAL, 120-180 hours)
1. Properties/NonInterference*.fst — Information flow security
2. Properties/SecurityProperties.fst — Confidentiality, integrity
3. Properties/Declassification.fst — Controlled declassification

**Deliverable:** Security properties proven, crypto foundation ready

### Phase 3: Crypto Integration (Priority: HIGH, 80-120 hours)
**Decision point:** HACL* binding vs from-scratch implementation
- Option A (recommended): Bind RIINA to HACL* verified crypto
  - Import HACL* modules
  - Prove RIINA crypto APIs wrap HACL* correctly
  - Leverage 200K+ lines of existing verified crypto
- Option B: Implement AES, ChaCha20, etc. from specs
  - Much longer timeline (200-400 hours)
  - Only if HACL* binding fails

**Deliverable:** Verified crypto primitives available to RIINA programs

### Phase 4: Remaining Termination (Priority: MEDIUM, 30-40 hours)
1. SizedTypes (16)
2. StrongNorm (8)
3. TerminationLemmas (7)

**Deliverable:** Complete termination analysis

### Phase 5: Compliance (Priority: MEDIUM, 110-170 hours)
1. Compliance/*.fst (108)
2. Industries/*.fst (375)

**Deliverable:** Regulatory compliance evidence

## Success Metrics

- [ ] 1,158 / 1,158 lemmas proven (0 `Lemma (True)` remaining)
- [ ] All 244 F* files compile without errors
- [ ] Core security properties verified (NonInterference, TypeSafety)
- [ ] Crypto primitives verified (HACL*-bound or implemented)
- [ ] Constant-time execution proven for crypto operations
- [ ] Zero `admit()`, zero `assume`

## Timeline Estimate

| Phase | Hours (Conservative) | Hours (Optimistic) |
|-------|---------------------|--------------------|
| Phase 1: Core | 100-120 | 80-100 |
| Phase 2: Security | 120-180 | 100-140 |
| Phase 3: Crypto | 80-120 | 60-90 |
| Phase 4: Termination | 30-40 | 20-30 |
| Phase 5: Compliance | 110-170 | 80-120 |
| **TOTAL** | **440-630** | **340-480** |

**Revised estimate:** 340-630 hours (not 200-400 as initially stated)

## Next Steps

1. ✅ F* toolchain installed (v2025.12.15)
2. ✅ Survey complete (this document)
3. ⏭️ Start Phase 1: Core Foundations
4. ⏭️ Research HACL* integration strategy
5. ⏭️ Begin replacing Foundations/ stubs

---

**Worker C Status:** Survey complete. Ready to begin Phase 1.
