# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.1.0   | Yes       |

Only the latest release receives security updates. Users should always build from the latest `main` branch or tagged release.

---

## Reporting Vulnerabilities

If you discover a security vulnerability in the RIINA compiler, standard library, or formal proofs, please report it responsibly:

**Email:** security@riina-lang.org

Please include:
- A description of the vulnerability
- Steps to reproduce, including a minimal `.rii` file if applicable
- The component affected (compiler, type system, effect system, proof, tooling)
- Your assessment of severity

We will acknowledge receipt within 48 hours and provide an initial assessment within 7 days. We will coordinate disclosure timing with you.

Do **not** open a public GitHub issue for security vulnerabilities.

---

## Security Model

RIINA's security guarantees are not assertions, conventions, or best practices. They are **mathematical theorems proven in Coq** and checked at compile time. The formal proofs ship with the compiler and are independently auditable.

### Information Flow Lattice

RIINA enforces a 6-level information flow lattice. Data at a higher security level cannot flow to a lower level without an explicit, compiler-verified declassification proof.

```
Rahsia (Secret)        -- Level 5: Cryptographic keys, credentials
  |
Sistem (System)        -- Level 4: OS-level, kernel data
  |
Pengguna (User)        -- Level 3: User-specific data (PII, sessions)
  |
Sesi (Session)         -- Level 2: Session-scoped data
  |
Dalaman (Internal)     -- Level 1: Internal application data
  |
Awam (Public)          -- Level 0: Public, unrestricted
```

The compiler statically tracks the security level of every value and rejects programs that violate the lattice ordering. This is enforced by the **non-interference theorem**, proven in Coq.

### Non-Interference Theorem

The core security property: modifying secret inputs cannot change public outputs. This is the gold standard for information flow security, proven for the full RIINA language (including references, mutable state, and declassification) in:

- `02_FORMAL/coq/properties/NonInterference_v2.v`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v`

### Effect System

Every side effect in RIINA (IO, network, filesystem, database, cryptography) is tracked in the type system. A function declared `kesan Bersih` (pure) is **proven** to have no side effects. A function that performs IO must declare `kesan IO`. Effect escalation is impossible without explicit annotation -- a dependency cannot secretly perform network operations if its caller only permits pure computation.

The effect system soundness is proven in `02_FORMAL/coq/effects/EffectSystem.v`.

### Mandatory Declassification Proofs

When secret data must be released (e.g., displaying a masked credit card number), the programmer must provide an explicit `dedah` (declassify) expression. The compiler verifies that every declassification satisfies the declassification policy, preventing accidental or malicious information leaks.

Declassification correctness is proven in `02_FORMAL/coq/properties/NonInterference_v2.v` and the domain-specific `02_FORMAL/coq/domains/` proofs.

---

## Vulnerability Classes Prevented

RIINA's formal verification eliminates entire classes of vulnerabilities by construction. Each prevention is backed by a Coq theorem.

### SQL Injection

**Prevention:** The effect system requires database operations to use `kesan SQL`. Input values are typed as `Teks` (public text) and cannot be spliced into queries without passing through a parameterization function that is proven to preserve the query structure. Untrusted input cannot reach the SQL execution path without explicit effect annotation and type-safe parameterization.

**Proof reference:** `02_FORMAL/coq/effects/EffectSystem.v` (effect gate soundness)

### Cross-Site Scripting (XSS)

**Prevention:** The type system distinguishes raw text (`Teks`) from sanitized HTML output (`HtmlSelamat`). Output functions that emit HTML require the `HtmlSelamat` type, which can only be constructed through a proven sanitization function. Unsanitized user input cannot reach HTML output.

**Proof reference:** `02_FORMAL/coq/type_system/Typing.v` (type safety), `02_FORMAL/coq/type_system/Progress.v`, `02_FORMAL/coq/type_system/Preservation.v` (type soundness)

### Information Leakage

**Prevention:** The non-interference theorem proves that no program can leak secret data to public outputs. This covers all channels tracked by the type system: return values, printed output, network responses, file writes, and database writes. Data at security level `Rahsia` (Secret) cannot flow to any context at level `Awam` (Public) or below without a verified declassification.

**Proof reference:** `02_FORMAL/coq/properties/NonInterference_v2.v` (non-interference theorem, 6,193 total Qed proofs in active build)

### Buffer Overflow

**Prevention:** RIINA uses a safe memory model with bounds-checked array access and no raw pointer arithmetic. The separation logic proofs guarantee that every memory access is within allocated bounds. There is no `unsafe` escape hatch in the language.

**Proof reference:** `02_FORMAL/coq/domains/DOMAIN_W_VerifiedMemory.v` (separation logic, memory safety)

### Cross-Site Request Forgery (CSRF)

**Prevention:** Network operations require the `kesan Rangkaian` (Network effect) annotation. The effect system prevents any function from making network requests unless its caller explicitly grants the Network effect. Combined with the information flow lattice, this ensures that authentication tokens (marked `Rahsia`) cannot be exfiltrated through unauthorized network requests.

**Proof reference:** `02_FORMAL/coq/effects/EffectSystem.v` (effect gate soundness), `02_FORMAL/coq/properties/NonInterference_v2.v` (non-interference)

### Supply Chain Attacks

**Prevention:** RIINA has **zero external dependencies** in its compiler, standard library, and cryptographic primitives. Every line of code is auditable from source. The package manager (`riinac pkg`) enforces SHA-256 integrity checks and effect escalation detection -- if a dependency introduces a new effect (e.g., Network), the build fails unless the developer explicitly approves it.

**Proof reference:** `02_FORMAL/coq/effects/EffectSystem.v` (effect composition), verified build pipeline in `05_TOOLING/`

---

## Formal Proof References

The following Coq files contain the key security proofs. All compile with Coq 8.20.1, with 0 `Admitted` proofs and 1 justified axiom in the active build.

| File | Purpose | Qed Count |
|------|---------|-----------|
| `02_FORMAL/coq/properties/NonInterference_v2.v` | Non-interference theorem (information flow security) | Part of 6,193 total |
| `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v` | Logical relation for non-interference proof | Part of 6,193 total |
| `02_FORMAL/coq/type_system/Typing.v` | Typing rules for the full language | Part of 6,193 total |
| `02_FORMAL/coq/type_system/Progress.v` | Progress theorem (well-typed programs don't get stuck) | Part of 6,193 total |
| `02_FORMAL/coq/type_system/Preservation.v` | Preservation theorem (types are preserved by evaluation) | Part of 6,193 total |
| `02_FORMAL/coq/effects/EffectSystem.v` | Effect algebra soundness | Part of 6,193 total |
| `02_FORMAL/coq/properties/TypeSafety.v` | Type safety composition (Progress + Preservation) | Part of 6,193 total |
| `02_FORMAL/coq/domains/DOMAIN_W_VerifiedMemory.v` | Memory safety (separation logic) | Part of 6,193 total |

**Multi-prover verification:** 17 critical theorems are independently verified in Lean 4 and Isabelle/HOL in addition to Coq. See `02_FORMAL/MULTIPROVER_VALIDATION.md`.

**Total proof metrics:**
- 6,193 Qed proofs in active build (249 files)
- 506 Qed proofs in deprecated archive (34 files)
- 6,700 Qed proofs total (283 files)
- 0 Admitted proofs
- 1 justified axiom (documented in proof files)
- 122,431 lines of proof (active build)

---

## Axioms

The active build contains exactly 1 axiom:

1. **`logical_relation_declassify`** -- Encodes the declassification policy as an axiom. Justified: this is a *policy* axiom -- it defines what declassification means, not a proof obligation. It is permanently unprovable by design, as it encodes the programmer's responsibility to justify declassification.

Three axioms were eliminated in Session 76 (2026-02-06): `logical_relation_ref` (reference creation), `logical_relation_assign` (reference assignment), and `fundamental_theorem_step_0` (step-indexed base case). A fourth, `logical_relation_deref` (reference dereference), was eliminated in Session 66.

---

## Verification Commands

```bash
# Run the compiler's built-in verification gate
riinac verify --fast    # Tests + clippy (pre-commit hook)
riinac verify --full    # + Coq audit (pre-push hook)

# Build all Coq proofs from source
cd 02_FORMAL/coq && make

# Check for any admitted proofs (should return nothing)
grep -r "Admitted\." 02_FORMAL/coq/ --include="*.v" | grep -v "_archive_deprecated"

# Run all Rust tests
cd 03_PROTO && cargo test --all
```

---

*RIINA -- Rigorous Immutable Invariant, No Assumptions*

*Security by proof, not by promise.*
