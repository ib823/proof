# TERAS THREAT DEFEAT MATRIX

**Version:** 1.1.0 (CORRECTED PER BREAKER FINDINGS)
**Generated:** 2026-01-15
**Mode:** ULTRA KIASU | FUCKING PARANOID | ZERO TRUST

---

## CRITICAL WARNING

**This matrix has been CORRECTED based on BREAKER attack findings.**

BREAKER identified **27 vulnerabilities (15 CRITICAL)** in the proof system.
Many proofs previously marked "fully proven" are actually:
- ADMITTED (not proven)
- Built on FALSE lemmas
- Proving `True` (meaningless)

See: `06_COORDINATION/BREAKER_ATTACK_LOG.md` for full details.

---

## Proof Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Fully proven (no `Admitted`, verified sound) |
| 🟡 | Partially proven (some admits or incomplete) |
| 🔴 | INVALID - Built on broken/admitted foundations |
| 📋 | Theorem stated, proof pending |
| ⚫ | Proves `True` (meaningless) |
| ❌ | Not addressed |

---

## BREAKER INVALIDATION MAP

| Proof | BREAKER Finding | Impact |
|-------|-----------------|--------|
| `type_safety` | TS-001: Built on admitted Progress | 🔴 All CWEs citing this are INVALID |
| `progress` | P-002: 10 ADMITTED cases | 🔴 Theorem not proven |
| `canonical_bool/fn` | P-001, P-003: FALSE as stated | 🔴 Progress foundations broken |
| `preservation` | R-001: Missing 5 value cases | 🟡 Incomplete |
| `effect_safety` | E-001: Proves `True` | ⚫ Meaningless |
| `gate_enforcement` | G-002: Proves `True` | ⚫ Meaningless |
| `non_interference` | NI-002: Only pure fragment | 🟡 Limited scope |
| `is_gate` | G-001: Definition = `True` | ⚫ Vacuous |
| Reference semantics | S-001, S-002: Don't use store | 🔴 Broken |
| Declassification | S-004: Accepts any proof | 🔴 Unsound |

---

## 1. Memory Safety Vulnerabilities

### CWE-119: Improper Restriction of Operations within Bounds of a Memory Buffer

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-119 | Buffer overflow (parent) | Type safety | `TypeSafety.v:25` | ✅ | 🔴 | TS-001: Built on admitted Progress |
| CWE-120 | Buffer Copy without Size Check | Substitution | `Preservation.v:319` | ✅ | 🟡 | R-001: value_has_pure_effect incomplete |
| CWE-121 | Stack-based Buffer Overflow | No raw pointers | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-122 | Heap-based Buffer Overflow | Type-safe refs | `Preservation.v:683` | ✅ | 🔴 | S-001, S-002: Refs don't work |
| CWE-123 | Write-what-where | No arbitrary writes | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-124 | Buffer Underwrite | Bounded arrays | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-125 | Out-of-bounds Read | Type safety | `Progress.v:74` | 🟡 | 🔴 | P-002: Progress admitted |
| CWE-126 | Buffer Over-read | Type-safe access | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-127 | Buffer Under-read | Type-safe access | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-129 | Array Index Validation | Type system | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-131 | Buffer Size Calculation | Type-level size | `Typing.v` | 🟡 | 🔴 | T-004: Store typing unused |

### CWE-416: Use After Free

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-416 | Use After Free | Linear types | `Progress.v:74` | 🟡 | 🔴 | P-002, S-001: No heap model |
| CWE-415 | Double Free | Linear types | `Progress.v:74` | 🟡 | 🔴 | P-002, S-002 |
| CWE-414 | Missing Lock | Capabilities | `EffectSystem.v:52` | 📋 | ⚫ | E-001: effect_safety = True |

### CWE-476: NULL Pointer Dereference

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-476 | NULL Pointer Deref | Option types | `TypeSafety.v:25` | ✅ | 🔴 | TS-001, P-004: No canonical_ref |
| CWE-690 | Unchecked Return to NULL | Sum types | `Preservation.v:629` | ✅ | 🟡 | R-002: preservation_helper incomplete |

---

## 2. Information Flow Vulnerabilities

### CWE-200: Exposure of Sensitive Information

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-200 | Information Exposure | Non-interference | `NonInterference.v:1326` | ✅ | 🟡 | NI-002: Only pure fragment |
| CWE-201 | Sensitive Info in Output | Security labels | `NonInterference.v:941` | ✅ | 🟡 | NI-002, NI-003 |
| CWE-209 | Error Message Leak | Secret type | `NonInterference.v:85` | ✅ | 🟡 | NI-001: Timing not covered |
| CWE-212 | Improper Removal | Declassify w/proof | `EffectSystem.v:70` | 📋 | 🔴 | S-004: Declassify accepts any proof |
| CWE-214 | Visible Sensitive Info | Effect system | `EffectSystem.v:84` | 📋 | ⚫ | E-001: proves True |
| CWE-215 | Debug Info Leak | Effect isolation | `Syntax.v:43` | ✅ | 🔴 | S-003: Effects never checked |

### CWE-285: Improper Authorization

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-285 | Improper Authorization | Capabilities | `EffectSystem.v:52-63` | 📋 | ⚫ | G-001, G-002: Gates are vacuous |
| CWE-287 | Improper Authentication | Proof-carrying | `EffectSystem.v:75` | 📋 | 🔴 | T-003: Proofs trivially forgeable |
| CWE-863 | Incorrect Authorization | Capability + level | `Syntax.v:31` | ✅ | 🔴 | S-003: Effect ctx never checked |

---

## 3. Type Safety Vulnerabilities

### CWE-843: Type Confusion

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-843 | Type Confusion | Strong typing | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-704 | Incorrect Conversion | No implicit coercions | `Preservation.v:683` | ✅ | 🟡 | R-001, R-002 |
| CWE-681 | Numeric Conversion | Explicit types | `Syntax.v:83-95` | ✅ | 🟡 | Syntax OK, semantics broken |
| CWE-588 | Non-structure Pointer | No ptr arithmetic | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |

### CWE-134: Uncontrolled Format String

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-134 | Format String | Typed I/O | `Syntax.v:87` | ✅ | 🟡 | Syntax only, no semantics |

---

## 4. Injection Vulnerabilities

### CWE-74: Injection

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-74 | Injection (parent) | Effect system | `EffectSystem.v` | 📋 | ⚫ | E-001: proves True |
| CWE-77 | Command Injection | Effect gates | `EffectGate.v` | 📋 | ⚫ | G-001, G-002: vacuous |
| CWE-78 | OS Command Injection | Capabilities | `Syntax.v:48` | ✅ | 🔴 | S-003: never checked |
| CWE-79 | XSS | Type-safe output | `Typing.v` | 📋 | 🔴 | No output encoding proofs |
| CWE-89 | SQL Injection | Parameterized | Future work | ❌ | ❌ | - |
| CWE-91 | XML Injection | Structured output | Future work | ❌ | ❌ | - |
| CWE-94 | Code Injection | Static compilation | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |

---

## 5. Concurrency Vulnerabilities

### CWE-362: Race Condition

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-362 | Race Condition | Linear types | `NonInterference.v` | 🟡 | 🔴 | NI-002, S-001: No shared state |
| CWE-364 | Signal Handler Race | No signals | N/A | ✅ | ✅ | Not applicable |
| CWE-366 | Thread Race | Effect tracking | `Syntax.v:46` | ✅ | 🔴 | S-003: Effects not enforced |
| CWE-367 | TOCTOU | Capabilities | `EffectSystem.v:52` | 📋 | ⚫ | G-001, G-002 |
| CWE-369 | Divide By Zero | Dependent types | Future work | ❌ | ❌ | - |

---

## 6. Cryptographic Vulnerabilities

### CWE-310: Cryptographic Issues

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-310 | Crypto Issues | EffectCrypto | `Syntax.v:48` | ✅ | 🔴 | S-003: Effect never checked |
| CWE-311 | Missing Encryption | Secret type | `Syntax.v:93` | ✅ | 🟡 | NI-002: Only pure fragment |
| CWE-312 | Cleartext Storage | Security levels | `NonInterference.v:24` | ✅ | 🟡 | NI-002, NI-003 |
| CWE-319 | Cleartext Transmission | Effect + level | `NonInterference.v:1326` | ✅ | 🟡 | NI-002 |
| CWE-320 | Key Management | Proof-carrying | `EffectSystem.v:70` | 📋 | 🔴 | S-004, T-003 |
| CWE-327 | Broken Crypto | External | N/A | ❌ | ❌ | - |
| CWE-328 | Reversible Hash | External | N/A | ❌ | ❌ | - |
| CWE-330 | Weak Randomness | External | N/A | ❌ | ❌ | - |

---

## 7. Resource Management Vulnerabilities

### CWE-400: Resource Exhaustion

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-400 | Resource Exhaustion | Effect budgets | `EffectAlgebra.v` | 📋 | 🟡 | EffectAlgebra CLEAN |
| CWE-401 | Memory Leak | Linear types | `Progress.v:74` | 🟡 | 🔴 | P-002, S-002 |
| CWE-404 | Improper Shutdown | Linear types | `Progress.v:74` | 🟡 | 🔴 | P-002 |
| CWE-770 | Allocation w/o Limits | Effect system | `Syntax.v:46` | ✅ | 🔴 | S-003 |
| CWE-771 | Missing Ref to Resource | Type tracking | `Preservation.v:683` | ✅ | 🟡 | R-001, R-002 |
| CWE-772 | Missing Release | Linear types | `Progress.v:74` | 🟡 | 🔴 | P-002, S-001 |

---

## 8. Control Flow Vulnerabilities

### CWE-691: Control Flow

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-691 | Control Flow | Structured only | `Syntax.v:124-126` | ✅ | ✅ | Syntax definition sound |
| CWE-697 | Incorrect Comparison | Type-safe equality | `Syntax.v` | ✅ | ✅ | Syntax definition sound |
| CWE-480 | Incorrect Operator | Strong typing | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-484 | Omitted Break | ECase exhaustive | `Preservation.v:629` | ✅ | 🟡 | Preservation incomplete |
| CWE-835 | Infinite Loop | Progress | `Progress.v:74` | 🟡 | 🔴 | P-002 |

---

## 9. Error Handling Vulnerabilities

### CWE-755: Exceptional Conditions

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-755 | Exceptions | Effect handlers | `EffectSystem.v:38` | 📋 | 🔴 | P-002: Handle cases admitted |
| CWE-248 | Uncaught Exception | Effect tracking | `EffectSystem.v` | 📋 | ⚫ | E-001 |
| CWE-252 | Unchecked Return | Sum types | `Preservation.v:56` | ✅ | ✅ | canonical_sum proven |
| CWE-273 | Dropped Privileges | Capability revoke | Future work | ❌ | ❌ | - |
| CWE-390 | Error w/o Action | Effect typing | `EffectSystem.v:38` | 📋 | ⚫ | E-001 |

---

## 10. Initialization Vulnerabilities

### CWE-665: Improper Initialization

| CWE | Description | TERAS Defense | Proof Reference | Original | Corrected | BREAKER Issue |
|-----|-------------|---------------|-----------------|----------|-----------|---------------|
| CWE-665 | Initialization | Explicit construction | `Syntax.v:102-144` | ✅ | ✅ | Syntax definition sound |
| CWE-457 | Uninitialized Variable | Type system | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-824 | Uninitialized Pointer | No null pointers | `TypeSafety.v:25` | ✅ | 🔴 | TS-001 |
| CWE-908 | Uninitialized Resource | Type-level tracking | `Progress.v:74` | 🟡 | 🔴 | P-002 |
| CWE-909 | Missing Init | Refs require value | `Syntax.v:133` | ✅ | 🔴 | S-001, S-002 |

---

## CORRECTED Coverage Statistics

| Category | Total | Original ✅ | Corrected ✅ | 🔴 Invalid | 🟡 Partial | ⚫ Vacuous |
|----------|-------|-------------|--------------|------------|------------|------------|
| Memory Safety | 14 | 10 | 0 | 13 | 1 | 0 |
| Information Flow | 9 | 5 | 0 | 4 | 4 | 1 |
| Type Safety | 5 | 5 | 0 | 3 | 2 | 0 |
| Injection | 8 | 3 | 0 | 4 | 0 | 3 |
| Concurrency | 5 | 2 | 1 | 3 | 0 | 1 |
| Cryptographic | 9 | 4 | 0 | 3 | 3 | 0 |
| Resource Mgmt | 6 | 2 | 0 | 5 | 1 | 0 |
| Control Flow | 5 | 4 | 2 | 2 | 1 | 0 |
| Error Handling | 5 | 1 | 1 | 1 | 0 | 2 |
| Initialization | 5 | 4 | 1 | 4 | 0 | 0 |
| **TOTAL** | **71** | **40** | **5** | **42** | **12** | **7** |

---

## Summary of Corrections

### Original vs Corrected

| Metric | Original | Corrected | Change |
|--------|----------|-----------|--------|
| ✅ Fully Proven | 40 | **5** | -35 |
| 🟡 Partial | 22 | **12** | -10 |
| 🔴 Invalid | 0 | **42** | +42 |
| ⚫ Vacuous | 0 | **7** | +7 |
| 📋 Pending | 6 | **0** | -6 |
| ❌ Not Addressed | 3 | **5** | +2 |

### What Remains Valid (✅)

Only **5 CWEs** have proofs that BREAKER did not invalidate:

1. **CWE-364** - Signal Handler Race: Not applicable (no signals in TERAS)
2. **CWE-691** - Control Flow: Syntax definition is sound
3. **CWE-697** - Incorrect Comparison: Syntax definition is sound
4. **CWE-252** - Unchecked Return: `canonical_sum` is proven
5. **CWE-665** - Improper Initialization: Syntax requires explicit construction

### What Is Completely Broken (🔴)

**42 CWEs** had their proofs invalidated because they relied on:
- `type_safety` (built on admitted `progress`) - TS-001
- `progress` (10 ADMITTED cases) - P-002
- Reference semantics (don't use store) - S-001, S-002
- Effect enforcement (never checked) - S-003

### What Proves Nothing (⚫)

**7 CWEs** were mapped to theorems that prove `True`:
- `effect_safety` - E-001
- `gate_enforcement` - G-002
- `is_gate` definition - G-001

---

## BREAKER Issue Cross-Reference

| BREAKER ID | Severity | Files Affected | CWEs Invalidated |
|------------|----------|----------------|------------------|
| TS-001 | CRITICAL | TypeSafety.v | 15+ |
| P-002 | CRITICAL | Progress.v | 20+ |
| P-001, P-003 | CRITICAL | Progress.v | Foundations |
| R-001, R-002 | CRITICAL/HIGH | Preservation.v | 8+ |
| S-001, S-002 | CRITICAL | Semantics.v | All ref-based |
| S-003 | HIGH | Semantics.v | All effect-based |
| S-004 | CRITICAL | Semantics.v | All declassify |
| E-001 | CRITICAL | EffectSystem.v | All effect safety |
| G-001, G-002 | CRITICAL | EffectGate.v | All gates |
| NI-002 | CRITICAL | NonInterference.v | Partial info flow |
| T-003 | HIGH | Typing.v | Proof forgery |

---

## Remediation Required

Before ANY CWE can be marked ✅, BUILDER must:

1. **Complete Progress.v** - Prove all 10 admitted cases
2. **Fix Canonical Forms** - Handle VRequire, VGrant, VClassify, etc.
3. **Implement Real Heap** - Store must actually store values
4. **Enforce Effects at Runtime** - Check effect_ctx in step rules
5. **Fix Declassification** - Validate proof structure
6. **Extend Non-Interference** - Cover effects, refs, security ops
7. **Implement Effect Safety** - Real proof, not `True`

---

*This matrix has been CORRECTED per BREAKER attack findings.*
*Previous "40 fully proven" claim was FALSE. Actual: 5 valid, 42 invalid, 7 vacuous.*
*CARTOGRAPHER trusts BREAKER. ZERO LAZINESS in verification.*
