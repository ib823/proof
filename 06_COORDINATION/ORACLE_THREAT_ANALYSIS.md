# ORACLE THREAT ANALYSIS — CORRECTED STATUS

**Mode:** ULTRA KIASU | FUCKING PARANOID | ZERO TRUST
**Generated:** 2026-01-15
**Status:** BREAKER FINDINGS VERIFIED

---

## CRITICAL DISCOVERY: DATA INCONSISTENCY

There are **uncommitted local modifications** to the proof files:
- Working copy has completed proofs for Progress.v
- Committed version (HEAD) may differ
- **Coq is NOT INSTALLED** - proofs cannot be verified

**Trust level: ZERO** until `make` succeeds.

---

## VERIFIED BREAKER FINDINGS

### VACUOUS PROOFS (Prove `True`)

| File | Theorem | Status |
|------|---------|--------|
| `EffectSystem.v:84-90` | `effect_safety` | **PROVES TRUE** |
| `EffectGate.v:22-26` | `is_gate` definition | **EQUALS TRUE** |
| `EffectGate.v:34-41` | `gate_enforcement` | **PROVES TRUE** |

### EMPTY FILES

| File | Status |
|------|--------|
| `SecurityProperties.v` | **EMPTY** (TODO comment only) |
| `Composition.v` | **EMPTY** (TODO comment only) |

### DESIGN FLAWS (Cannot be fixed by completing proofs)

| ID | Issue | Location | Impact |
|----|-------|----------|--------|
| S-001 | References don't use store | `Semantics.v:166-168` | Mutable state is broken |
| S-002 | No heap allocation model | `Semantics.v` | No actual memory model |
| S-003 | Effect context never checked | `Semantics.v:145-147` | Capabilities have no teeth |
| S-004 | Declassification accepts any proof | `Semantics.v:198-201` | Security bypass |
| T-003 | TProof is trivially forgeable | `Typing.v:177-179` | Declassify anything |
| E-003 | T_Declassify type mismatch | `EffectSystem.v:72` vs `Typing.v:173` | Spec inconsistency |

### INCOMPLETE PROOFS

| File | What's Missing |
|------|----------------|
| `NonInterference.v` | Only covers effect-free, reference-free fragment |
| `Preservation.v` | Missing cases for refs, effects, security ops |

---

## WORKING COPY STATUS

The working tree has uncommitted changes that add:
- `canonical_ref`, `canonical_secret`, `canonical_proof` lemmas
- Completed Progress theorem cases for T_Perform through T_Grant

**BUT**: These fixes do NOT address the design flaws above.

---

## CWE MAPPING — CORRECTED

### ACTUALLY PROVEN (Core subset only)

| CWE | TERAS Defense | Proof Status |
|-----|---------------|--------------|
| CWE-476 | No null refs | ✅ Progress/Preservation for core |
| CWE-843 | Type uniqueness | ✅ Typing.v:type_uniqueness |
| CWE-134 | No format strings | ✅ By language design |
| CWE-94 | No eval | ✅ By language design |

### CLAIMED BUT NOT PROVEN

| CWE | TERAS Claim | Actual Status |
|-----|-------------|---------------|
| CWE-200 | Non-interference | ⚠️ Only for pure, ref-free subset |
| CWE-78 | Effect gates | ❌ `gate_enforcement` proves True |
| CWE-311 | TSecret protection | ❌ Declassify accepts any proof |
| CWE-362 | Effect isolation | ❌ Effect ctx never checked |
| CWE-416 | Linear types | ❌ Not implemented |
| CWE-787 | Array bounds | ❌ No array type exists |

### NOT ADDRESSED

| CWE | Description | Gap |
|-----|-------------|-----|
| CWE-89 | SQL Injection | No query API model |
| CWE-352 | CSRF | No web security model |
| CWE-190 | Integer Overflow | TInt is unbounded (unrealistic) |
| CWE-369 | Divide by Zero | No dependent types |

---

## THREAT DEFEAT STATUS — HONEST ASSESSMENT

| Threat Class | Status | Notes |
|--------------|--------|-------|
| Memory Safety | ⚠️ PARTIAL | Core refs proven, no arrays, heap model broken |
| Information Flow | ⚠️ PARTIAL | Non-interference for pure fragment only |
| Type Safety | ✅ CORE ONLY | Progress/Preservation for core subset |
| Effect Control | ❌ BROKEN | Capabilities never enforced at runtime |
| Declassification | ❌ BROKEN | Any value is a valid "proof" |

---

## BUILDER WORK QUEUE — PRIORITIZED

### CRITICAL (Security-breaking)

1. **Fix reference semantics** - Add heap allocation, store operations
2. **Fix effect enforcement** - Check effect_ctx in step rules
3. **Fix declassification** - Require meaningful proofs
4. **Complete NonInterference** - Cover effects and refs

### HIGH (Incomplete proofs)

5. **Complete Preservation** - Add missing step rule cases
6. **Fix EffectSystem spec** - Match Typing.v rules
7. **Implement SecurityProperties** - Actually define properties

### MEDIUM (Missing features)

8. **Add array types** - TArray T n with bounds checking
9. **Add linear/affine types** - For resource tracking
10. **Add concurrency model** - For race condition prevention

---

## ORACLE VERDICT

**The threat matrix and CWE mappings in THREAT_DEFEAT_MATRIX.md are OVERSTATED.**

Actual security guarantees:
- Type safety for core functional subset: **PROVEN** (assuming proofs compile)
- Non-interference for pure subset: **PROVEN** (assuming proofs compile)
- Effect system enforcement: **NOT PROVEN** (vacuous theorems)
- Declassification security: **NOT PROVEN** (trivially bypassable)
- Memory safety for refs: **NOT PROVEN** (heap model broken)

**Recommendation:** Do NOT claim security guarantees until:
1. Coq is installed and `make` succeeds with 0 errors
2. Design flaws (S-001 through S-004, T-003) are fixed
3. Vacuous theorems are replaced with meaningful proofs

---

*ORACLE trusts nothing. ORACLE verifies everything. BREAKER was right.*
