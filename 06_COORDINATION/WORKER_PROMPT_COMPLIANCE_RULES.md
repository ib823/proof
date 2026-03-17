# WORKER PROMPT: Real Compliance Rules (Phase 5, REQ-15 Adjacent)

**Mission:** Expand RIINA's compliance rule engine from 6 implemented rules to 100+ real, tested rules across all 15 compliance profiles. Every rule must be tested. This is the "tested, not 6/1054" Phase 5 requirement.

---

## CURRENT STATE

### Crate: `03_PROTO/crates/riina-compliance/`

| File | Lines | Purpose |
|------|-------|---------|
| `lib.rs` | 191 | `ComplianceProfile` enum (15 profiles), `ComplianceRule` struct, `ComplianceViolation` |
| `rules.rs` | 258 | Rule definitions — **only 6 rules implemented** (3 PCI-DSS, 2 PDPA, 1 BNM) |
| `tests.rs` | 154 | 15 tests for existing rules |
| `validator.rs` | 71 | AST walker that applies rules to expressions |
| `report.rs` | 492 | Text and JSON report generation |

### How Rules Work

A `ComplianceRule` has:
```rust
pub struct ComplianceRule {
    pub id: &'static str,        // e.g., "PCI-DSS-3.4"
    pub profile: ComplianceProfile,
    pub description: &'static str,
    pub severity: Severity,       // Critical, High, Medium, Low, Info
    pub check: fn(&Expr) -> Option<ComplianceViolation>,
}
```

The `check` function receives an AST expression (`riina_types::Expr`) and returns `Some(violation)` if the expression violates the rule. The validator walks the entire AST and applies all rules.

### Available AST Nodes for Checking

```rust
Expr::Let(name, linearity, value, body)  // Variable bindings
Expr::Classify(expr)                     // Secret classification
Expr::Declassify(expr, proof)            // Declassification with proof
Expr::Perform(effect, expr)              // Effect operations
Expr::Ref(expr, security_level)          // Memory references with security level
Expr::Var(name)                          // Variable references
Expr::Lam(param, ty, body)              // Lambda functions
Expr::App(func, arg)                     // Function application
Expr::String(value)                      // String literals
Expr::Int(value)                         // Integer literals
```

### 15 Compliance Profiles (all declared, most empty)

| Profile | Rules | Target | Standard |
|---------|-------|--------|----------|
| `PciDss` | 3 | 15+ | PCI-DSS 4.0 — Payment Card Industry |
| `Pdpa` | 2 | 10+ | Malaysia Personal Data Protection Act 2010 |
| `Bnm` | 1 | 10+ | Bank Negara Malaysia Risk Management in Technology |
| `Hipaa` | 0 | 10+ | US HIPAA — Healthcare data |
| `Cmmc` | 0 | 8+ | US CMMC — Defense cybersecurity |
| `Sox` | 0 | 8+ | Sarbanes-Oxley — Financial reporting |
| `Gdpr` | 0 | 10+ | EU GDPR — Data protection |
| `Do178c` | 0 | 10+ | DO-178C — Aviation software |
| `Iec62443` | 0 | 8+ | IEC 62443 — Industrial control systems |
| `NercCip` | 0 | 6+ | NERC CIP — Energy grid |
| `Fda21cfr` | 0 | 6+ | FDA 21 CFR Part 11 — Pharma |
| `Iso27001` | 0 | 10+ | ISO 27001 — InfoSec management |
| `Nist80053` | 0 | 10+ | NIST 800-53 — Federal systems |
| `MasTrm` | 0 | 8+ | MAS TRM — Singapore financial |
| `Itar` | 0 | 4+ | ITAR — Arms export |

**Target: 100+ rules total, every rule tested.**

---

## WHAT TO IMPLEMENT

### Per-Profile Rules

For each profile, implement rules that check the AST for compliance violations. Rules should be practical — things a real compiler can actually detect from source code analysis.

#### PCI-DSS 4.0 (expand from 3 → 15)

Existing rules to keep:
- `PCI-DSS-3.4`: Card data must be Secret-typed (detects `card_number`, `pan`, `cvv` in Let bindings without Classify)
- `PCI-DSS-6.5.1`: SQL injection prevention (detects string concatenation near `query`/`sql` names)
- `PCI-DSS-6.5.7`: XSS prevention (detects string concatenation near `html`/`response` names)

New rules to add:
- `PCI-DSS-3.5.1`: Encryption key must be Secret-typed (detect `key`, `encryption_key`, `aes_key` without Classify)
- `PCI-DSS-4.1`: Transmission encryption (detect network Perform without `kesan RangkaianSelamat`)
- `PCI-DSS-6.2.1`: Secure coding (detect `unsafe`/`bahaya` keywords in security-critical contexts)
- `PCI-DSS-6.3.1`: Custom code review (detect functions exceeding complexity threshold)
- `PCI-DSS-6.5.2`: Buffer overflow prevention (detect unchecked array access patterns)
- `PCI-DSS-6.5.3`: Insecure crypto (detect weak algorithm names like `md5`, `sha1`, `des`)
- `PCI-DSS-6.5.4`: Insecure communication (detect `http://` in string literals, not `https://`)
- `PCI-DSS-6.5.5`: Improper error handling (detect empty catch/handle blocks)
- `PCI-DSS-6.5.6`: Identification flaws (detect password/token in Let without Secret)
- `PCI-DSS-8.3.1`: Strong authentication (detect password length < 12 in validation)
- `PCI-DSS-10.2`: Audit logging (detect security operations without accompanying log)
- `PCI-DSS-11.3`: Penetration testing prep (flag any `unsafe` usage for review)

#### HIPAA (0 → 10)
- `HIPAA-164.312-a1`: Access control (PHI data must be Secret-typed)
- `HIPAA-164.312-a2`: Emergency access (detect emergency override without audit trail)
- `HIPAA-164.312-c1`: Integrity controls (detect PHI modification without hashing)
- `HIPAA-164.312-d`: Person authentication (detect PHI access without auth check)
- `HIPAA-164.312-e1`: Transmission security (PHI over network must use secure channel)
- `HIPAA-164.530-c`: Minimum necessary (detect overly broad PHI access patterns)
- `HIPAA-164.308-a5`: Security awareness (detect hardcoded credentials near health data)
- `HIPAA-164.310-d`: Device security (detect unencrypted storage of PHI)
- `HIPAA-164.314-a`: Business associate controls (detect PHI sharing without taint tracking)
- `HIPAA-164.316-b`: Documentation (detect PHI operations without logging effect)

#### GDPR (0 → 10)
- `GDPR-5.1-a`: Lawfulness (personal data processing must have consent/legal basis annotation)
- `GDPR-5.1-b`: Purpose limitation (detect personal data used outside declared purpose)
- `GDPR-5.1-c`: Data minimization (detect collecting more personal data than needed)
- `GDPR-5.1-e`: Storage limitation (detect personal data without TTL/expiry)
- `GDPR-5.1-f`: Integrity and confidentiality (personal data must be Secret-typed)
- `GDPR-17`: Right to erasure (detect personal data without delete capability)
- `GDPR-25.1`: Data protection by design (detect personal data in non-Secret bindings)
- `GDPR-32`: Security of processing (detect personal data without encryption)
- `GDPR-33`: Breach notification (detect security events without alert mechanism)
- `GDPR-35`: DPIA requirement (flag high-risk processing patterns)

#### PDPA Malaysia (expand 2 → 10)

Existing:
- `PDPA-S7-1`: User input must be taint-tracked
- `PDPA-S7-2`: Personal data must be sanitized before storage

New:
- `PDPA-S6`: Consent requirement (personal data processing without consent annotation)
- `PDPA-S8`: Disclosure principle (personal data sharing without purpose declaration)
- `PDPA-S9`: Security principle (personal data without Secret/encryption)
- `PDPA-S10`: Retention principle (personal data without TTL)
- `PDPA-S11`: Data integrity (personal data modification without validation)
- `PDPA-S12`: Access principle (personal data without access control check)
- `PDPA-S13-1`: Cross-border transfer (personal data with network effect without geo-check)
- `PDPA-S42`: Breach notification (security violation without alert)

#### BNM RMiT (expand 1 → 10)

Existing:
- `BNM-10.49`: Sensitive data classification required

New:
- `BNM-10.18`: Cryptographic controls (financial data without encryption)
- `BNM-10.49-b`: Data leakage prevention (classified data flowing to unclassified output)
- `BNM-10.50`: Access control (financial operations without authentication)
- `BNM-10.51`: Audit trail (financial transactions without logging)
- `BNM-10.52`: Incident management (security events without escalation)
- `BNM-10.54`: System resilience (critical operations without error handling)
- `BNM-10.55`: Third-party risk (external API calls without validation)
- `BNM-10.56`: Cloud security (cloud operations without encryption)
- `BNM-10.58`: Cyber threat intelligence (network operations without monitoring)

#### MAS TRM Singapore (0 → 8)
- `MAS-TRM-5.1.1`: Technology risk governance (detect ungoverned system operations)
- `MAS-TRM-9.1.1`: System security (detect unencrypted financial data)
- `MAS-TRM-9.2.1`: Access control (financial operations without auth)
- `MAS-TRM-9.4.1`: Cryptographic controls (weak crypto detection)
- `MAS-TRM-11.1.1`: Data security (customer data without Secret typing)
- `MAS-TRM-11.2.1`: Data loss prevention (data egress without classification check)
- `MAS-TRM-12.1.1`: Incident management (security events without handling)
- `MAS-TRM-13.1.1`: IT audit (operations without audit trail)

#### NIST 800-53 (0 → 10)
- `NIST-AC-1`: Access control policy (detect operations without authorization check)
- `NIST-AC-6`: Least privilege (detect overly broad capability grants)
- `NIST-AU-2`: Audit events (security operations must produce audit events)
- `NIST-IA-5`: Authenticator management (detect hardcoded passwords/tokens)
- `NIST-SC-8`: Transmission confidentiality (network data must be encrypted)
- `NIST-SC-12`: Cryptographic key management (keys must be Secret-typed)
- `NIST-SC-13`: Cryptographic protection (detect weak algorithms)
- `NIST-SC-28`: Protection at rest (stored data must be encrypted)
- `NIST-SI-2`: Flaw remediation (detect known-vulnerable patterns)
- `NIST-SI-10`: Input validation (user input must be taint-tracked)

#### ISO 27001 (0 → 10)
- `ISO-A5.1`: Policies for information security (detect ungoverned data access)
- `ISO-A6.1`: Organization of information security (detect unattributed operations)
- `ISO-A8.1`: Asset management (detect unclassified data assets)
- `ISO-A9.1`: Access control (operations without authentication)
- `ISO-A10.1`: Cryptography (sensitive data without encryption)
- `ISO-A12.1`: Operations security (detect logging gaps)
- `ISO-A13.1`: Communications security (network transfer without encryption)
- `ISO-A14.1`: System acquisition security (detect insecure dependencies)
- `ISO-A16.1`: Incident management (security events without handling)
- `ISO-A18.1`: Compliance (detect regulatory data without classification)

#### DO-178C (0 → 10)
- `DO178C-6.3.1`: Low-level requirements traceability (detect unlinked functions)
- `DO178C-6.3.2`: Source code accuracy (detect dead code)
- `DO178C-6.3.3`: Source code traceability (detect untraced functions)
- `DO178C-6.4.1`: Test coverage — statement (detect untested paths)
- `DO178C-6.4.2`: Test coverage — decision (detect uncovered branches)
- `DO178C-6.4.3`: Test coverage — MC/DC (detect complex conditions without full coverage)
- `DO178C-6.4.4`: Data flow analysis (detect uninitialized variable use)
- `DO178C-6.4.5`: Control flow analysis (detect unreachable code)
- `DO178C-6.7.1`: Stack usage analysis (detect unbounded recursion)
- `DO178C-6.7.2`: Worst-case execution time (detect unbounded loops)

#### SOX (0 → 8)
- `SOX-302-1`: Financial data integrity (financial values must be typed, not raw strings)
- `SOX-302-2`: Access controls (financial operations require authentication)
- `SOX-404-1`: Internal controls (financial calculations must have audit trail)
- `SOX-404-2`: Change management (detect unlogged modifications to financial data)
- `SOX-409-1`: Real-time disclosure (financial events must trigger reporting)
- `SOX-802-1`: Record retention (financial records without retention policy)
- `SOX-906-1`: CEO/CFO certification support (financial reports must be verifiable)
- `SOX-1102-1`: Document destruction prevention (detect deletion of financial records)

#### Remaining Profiles (CMMC, IEC-62443, NERC-CIP, FDA-21CFR, ITAR) — 4-6 rules each

For each, implement domain-specific rules following the same pattern. Focus on what a static analyzer can detect from AST inspection.

---

## IMPLEMENTATION PATTERN

Each rule follows the same pattern. Here's the template:

```rust
ComplianceRule {
    id: "PROFILE-SECTION",
    profile: ComplianceProfile::ProfileName,
    description: "Human-readable description of what this checks",
    severity: Severity::High, // or Critical, Medium, Low, Info
    check: |expr| {
        // Pattern match on the AST
        if let Expr::Let(name, _, value, _) = expr {
            let lower = name.to_lowercase();
            // Check for violations
            if lower.contains("sensitive_keyword") {
                if !matches!(**value, Expr::Classify(_)) {
                    return Some(ComplianceViolation {
                        rule_id: "PROFILE-SECTION".to_string(),
                        message: "Sensitive data must be classified".to_string(),
                        severity: Severity::High,
                        suggestion: Some("Use `classify` to mark as Secret".to_string()),
                    });
                }
            }
        }
        None
    },
}
```

### Detection Patterns (reusable across profiles)

1. **Sensitive data not classified**: `Let(name, _, value, _)` where name contains sensitive keywords but value is not `Classify(_)`
2. **Hardcoded credentials**: `Let(name, _, Expr::String(_), _)` where name contains `password`, `token`, `secret`, `key`, `credential`
3. **Insecure communication**: `Expr::String(s)` containing `http://` (not `https://`)
4. **Missing encryption**: `Perform(Network, _)` without wrapping in `Classify`
5. **Missing audit trail**: Security operations (`Classify`, `Declassify`, `Grant`) without adjacent `Perform(Write, _)`
6. **Weak crypto**: `Expr::String(s)` containing `md5`, `sha1`, `des`, `rc4`
7. **Taint flow**: `Expr::Perform(Read, _)` result used without `Sanitize`
8. **Excessive privilege**: `Grant(effect, _)` with high-level effects
9. **Missing error handling**: `Handle` blocks with empty bodies
10. **Data retention**: `Ref(_, SecurityLevel::Secret)` without associated TTL/cleanup

---

## FILE OWNERSHIP

You ONLY touch files in `03_PROTO/crates/riina-compliance/`:
- `rules.rs` — Add all new rules
- `tests.rs` — Add tests for every new rule
- `lib.rs` — Update `rule_count()` per profile if needed
- `validator.rs` — Only if the walker needs enhancement

Do NOT touch: `02_FORMAL/`, `05_TOOLING/`, `website/`, or any other crate.

---

## TESTING REQUIREMENTS

**Every rule must have at least 2 tests:**
1. A **positive test** — code that violates the rule → violation detected
2. A **negative test** — code that complies → no violation

Example:
```rust
#[test]
fn hipaa_phi_data_must_be_secret() {
    // Violation: PHI data without Secret classification
    let expr = Expr::Let(
        "patient_record".into(),
        None,
        Box::new(Expr::String("SSN: 123-45-6789".into())),
        Box::new(Expr::Unit),
    );
    let violations = check_compliance(&[ComplianceProfile::Hipaa], &expr);
    assert!(violations.iter().any(|v| v.rule_id == "HIPAA-164.312-a1"));
}

#[test]
fn hipaa_phi_classified_ok() {
    // Compliance: PHI data properly classified
    let expr = Expr::Let(
        "patient_record".into(),
        None,
        Box::new(Expr::Classify(Box::new(Expr::String("SSN: 123-45-6789".into())))),
        Box::new(Expr::Unit),
    );
    let violations = check_compliance(&[ComplianceProfile::Hipaa], &expr);
    assert!(violations.iter().all(|v| v.rule_id != "HIPAA-164.312-a1"));
}
```

---

## COMMIT FORMAT

```
[TRACK_B] IMPL: Add N compliance rules for PROFILE (tested)
```

Commit after each profile or batch of profiles. Push to main.

---

## SUCCESS CRITERIA

1. **100+ rules** across all 15 profiles (currently 6)
2. **200+ tests** (currently 15) — 2+ per rule
3. **All tests pass**: `cargo test --manifest-path 03_PROTO/Cargo.toml -p riina-compliance`
4. **Clippy clean**: `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings`
5. **`riinac --list-compliance`** shows rule counts per profile
6. **`riinac check --compliance pci-dss myfile.rii`** produces meaningful output

---

## VALUE-ADD: MALAYSIA/SINGAPORE SPECIFIC

RIINA targets Malaysia and Singapore markets. Give extra depth to:
- **PDPA (Malaysia)**: All 7 principles with sub-rules
- **BNM RMiT**: Comprehensive technology risk controls
- **MAS TRM (Singapore)**: Full technology risk management
- **MCMC regulations**: Communications and multimedia
- **SC Guidelines**: Securities Commission Malaysia cybersecurity

These make RIINA uniquely valuable for ASEAN financial technology compliance — no other language has these built in.

---

## QUALITY OVER QUANTITY

A well-designed rule that catches real bugs is worth 10 trivial rules. Focus on rules that:
1. A real developer would actually trigger in production code
2. Have clear, actionable suggestions
3. Map to specific regulatory sections
4. Can be verified from AST inspection alone (no dataflow analysis required)
