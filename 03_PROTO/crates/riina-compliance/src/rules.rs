// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Compliance rule definitions per profile.
//! Spec: 04_SPECS/industries/
//!
//! 127 rules across 15 compliance profiles, each with AST-level detection.

use riina_types::{Expr, Effect};

use crate::{ComplianceProfile, ComplianceViolation, Severity};

/// A compliance rule: a check function that inspects a single AST node
/// and returns violations if the node violates the rule.
/// Type alias for compliance check function.
type CheckFn = Box<dyn Fn(&Expr) -> Option<ComplianceViolation> + Send + Sync>;

#[allow(dead_code)]
pub struct ComplianceRule {
    pub id: &'static str,
    pub profile: ComplianceProfile,
    pub description: &'static str,
    pub check: CheckFn,
}

/// Number of implemented rules for a profile.
pub fn rule_count(profile: ComplianceProfile) -> usize {
    match profile {
        ComplianceProfile::PciDss => 15,
        ComplianceProfile::Pdpa => 10,
        ComplianceProfile::Bnm => 10,
        ComplianceProfile::Hipaa => 10,
        ComplianceProfile::Cmmc => 6,
        ComplianceProfile::Sox => 8,
        ComplianceProfile::Gdpr => 10,
        ComplianceProfile::Do178c => 10,
        ComplianceProfile::Iec62443 => 6,
        ComplianceProfile::NercCip => 5,
        ComplianceProfile::Fda21cfr => 5,
        ComplianceProfile::Iso27001 => 10,
        ComplianceProfile::Nist80053 => 10,
        ComplianceProfile::MasTrm => 8,
        ComplianceProfile::Itar => 4,
    }
}

/// Collect all rules for the given profiles.
pub fn rules_for_profiles(profiles: &[ComplianceProfile]) -> Vec<ComplianceRule> {
    let mut rules = Vec::new();
    for &p in profiles {
        match p {
            ComplianceProfile::PciDss => rules.extend(pci_dss_rules()),
            ComplianceProfile::Pdpa => rules.extend(pdpa_rules()),
            ComplianceProfile::Bnm => rules.extend(bnm_rules()),
            ComplianceProfile::Hipaa => rules.extend(hipaa_rules()),
            ComplianceProfile::Cmmc => rules.extend(cmmc_rules()),
            ComplianceProfile::Sox => rules.extend(sox_rules()),
            ComplianceProfile::Gdpr => rules.extend(gdpr_rules()),
            ComplianceProfile::Do178c => rules.extend(do178c_rules()),
            ComplianceProfile::Iec62443 => rules.extend(iec62443_rules()),
            ComplianceProfile::NercCip => rules.extend(nerc_cip_rules()),
            ComplianceProfile::Fda21cfr => rules.extend(fda_rules()),
            ComplianceProfile::Iso27001 => rules.extend(iso27001_rules()),
            ComplianceProfile::Nist80053 => rules.extend(nist_rules()),
            ComplianceProfile::MasTrm => rules.extend(mas_trm_rules()),
            ComplianceProfile::Itar => rules.extend(itar_rules()),
        }
    }
    rules
}

// ===========================================================================
// Helper functions
// ===========================================================================

/// Check if a name (lowercased) contains any of the given keywords.
fn name_matches(name: &str, keywords: &[String]) -> bool {
    let lower = name.to_lowercase();
    keywords.iter().any(|k| lower.contains(k.as_str()))
}

/// Check if an expression tree contains a Perform with the given effect.
fn contains_effect(expr: &Expr, target: Effect) -> bool {
    match expr {
        Expr::Perform(eff, _) if *eff == target => true,
        Expr::Lam(_, _, body) => contains_effect(body, target),
        Expr::App(f, a) => contains_effect(f, target) || contains_effect(a, target),
        Expr::Let(_, _, v, b) | Expr::LetRec(_, _, v, b) | Expr::Handle(v, _, b) => {
            contains_effect(v, target) || contains_effect(b, target)
        }
        Expr::If(c, t, e) | Expr::Case(c, _, t, _, e) => {
            contains_effect(c, target) || contains_effect(t, target) || contains_effect(e, target)
        }
        Expr::Perform(_, inner) => contains_effect(inner, target),
        Expr::BinOp(_, l, r) | Expr::Pair(l, r) | Expr::Assign(l, r)
        | Expr::Declassify(l, r) => {
            contains_effect(l, target) || contains_effect(r, target)
        }
        Expr::Classify(e) | Expr::Fst(e) | Expr::Snd(e) | Expr::Deref(e)
        | Expr::Ref(e, _) | Expr::Inl(e, _) | Expr::Inr(e, _) | Expr::Prove(e)
        | Expr::Require(_, e) | Expr::Grant(_, e) => contains_effect(e, target),
        Expr::FFICall { args, .. } => args.iter().any(|a| contains_effect(a, target)),
        _ => false,
    }
}

/// Check if an expression contains a security operation (Classify, Declassify, Grant).
fn contains_security_op(expr: &Expr) -> bool {
    match expr {
        Expr::Classify(_) | Expr::Declassify(_, _) | Expr::Grant(_, _) => true,
        Expr::Let(_, _, v, b) | Expr::LetRec(_, _, v, b) | Expr::Handle(v, _, b) => {
            contains_security_op(v) || contains_security_op(b)
        }
        Expr::App(f, a) | Expr::Pair(f, a) | Expr::BinOp(_, f, a)
        | Expr::Assign(f, a) => {
            contains_security_op(f) || contains_security_op(a)
        }
        Expr::If(c, t, e) | Expr::Case(c, _, t, _, e) => {
            contains_security_op(c) || contains_security_op(t) || contains_security_op(e)
        }
        Expr::Lam(_, _, b) | Expr::Fst(b) | Expr::Snd(b) | Expr::Inl(b, _)
        | Expr::Inr(b, _) | Expr::Ref(b, _) | Expr::Deref(b) | Expr::Perform(_, b)
        | Expr::Prove(b) | Expr::Require(_, b) => contains_security_op(b),
        _ => false,
    }
}

/// Check if an expression tree contains an If or Case (base case for recursion).
fn has_if_or_case(expr: &Expr) -> bool {
    match expr {
        Expr::If(_, _, _) | Expr::Case(_, _, _, _, _) => true,
        Expr::Let(_, _, v, b) | Expr::LetRec(_, _, v, b) | Expr::Handle(v, _, b) => {
            has_if_or_case(v) || has_if_or_case(b)
        }
        Expr::Lam(_, _, b) | Expr::Fst(b) | Expr::Snd(b) | Expr::Perform(_, b)
        | Expr::Classify(b) | Expr::Prove(b) | Expr::Deref(b) | Expr::Ref(b, _)
        | Expr::Inl(b, _) | Expr::Inr(b, _) | Expr::Require(_, b) | Expr::Grant(_, b) => {
            has_if_or_case(b)
        }
        Expr::App(f, a) | Expr::Pair(f, a) | Expr::BinOp(_, f, a)
        | Expr::Assign(f, a) | Expr::Declassify(f, a) => {
            has_if_or_case(f) || has_if_or_case(a)
        }
        _ => false,
    }
}

/// Check if a Var in the expression matches any of the given keywords.
fn contains_var_matching(expr: &Expr, keywords: &[String]) -> bool {
    match expr {
        Expr::Var(name) => name_matches(name, keywords),
        Expr::App(f, a) | Expr::Pair(f, a) | Expr::BinOp(_, f, a) => {
            contains_var_matching(f, keywords) || contains_var_matching(a, keywords)
        }
        Expr::Fst(e) | Expr::Snd(e) | Expr::Classify(e) | Expr::Perform(_, e)
        | Expr::Deref(e) => {
            contains_var_matching(e, keywords)
        }
        _ => false,
    }
}

/// Check if an expression is "tainted" (wrapped in a taint-producing construct).
fn is_tainted_expr(expr: &Expr) -> bool {
    matches!(expr, Expr::Perform(_, _) | Expr::Classify(_))
}

/// Check if a crypto argument is wrapped in ConstantTime (heuristic).
fn is_constant_time_wrapped(_expr: &Expr) -> bool {
    false
}

fn to_owned_keywords(keywords: &[&str]) -> Vec<String> {
    keywords.iter().map(|k| (*k).to_string()).collect()
}

// ===========================================================================
// Template rule builders
// ===========================================================================

/// Template A: Let binding with sensitive name must use Classify.
fn sensitive_let_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    keywords: &[&str],
    severity: Severity,
) -> ComplianceRule {
    let kw = to_owned_keywords(keywords);
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Let(name, _, value, _) = expr {
                if name_matches(name, &kw) && !matches!(value.as_ref(), Expr::Classify(_)) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Variable '{}' must be classified as Secret", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template B: Let binding with credential-like name must not be a string literal.
fn hardcoded_credential_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    keywords: &[&str],
    severity: Severity,
) -> ComplianceRule {
    let kw = to_owned_keywords(keywords);
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Let(name, _, value, _) = expr {
                if name_matches(name, &kw) && matches!(value.as_ref(), Expr::String(_)) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Variable '{}' contains a hardcoded credential", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template C: Perform(Network, _) should use NetworkSecure instead.
fn insecure_network_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Perform(Effect::Network, _) = expr {
                return Some(ComplianceViolation {
                    rule_id: id,
                    profile,
                    message: "Network communication must use secure channel (NetworkSecure effect)".into(),
                    severity,
                });
            }
            None
        }),
    }
}

/// Template D: String literal containing weak crypto algorithm names.
fn weak_crypto_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::String(s) = expr {
                let lower = s.to_lowercase();
                if lower.contains("md5") || lower.contains("sha1")
                    || lower.contains("des") || lower.contains("rc4")
                    || lower.contains("rot13")
                {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Weak cryptographic algorithm detected: '{}'", s),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template E: String literal containing insecure HTTP URL.
fn insecure_url_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::String(s) = expr {
                if s.contains("http://") {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Insecure HTTP URL detected: '{}'. Use HTTPS instead", s),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template F: LetRec with auth-related name must use Crypto effect.
fn auth_crypto_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    keywords: &[&str],
    severity: Severity,
) -> ComplianceRule {
    let kw = to_owned_keywords(keywords);
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::LetRec(name, _ty, body, _) = expr {
                if name_matches(name, &kw) && !contains_effect(body, Effect::Crypto) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Authentication function '{}' must use Crypto effect", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template G: Declassify without Prove guard.
fn declassify_prove_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Declassify(_, proof) = expr {
                if !matches!(proof.as_ref(), Expr::Prove(_)) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: "Declassification requires a Prove guard for audit compliance".into(),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template H: Let binding with security op value but body lacks Write (audit trail).
fn audit_trail_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Let(_, _, value, body) = expr {
                if contains_security_op(value) && !contains_effect(body, Effect::Write) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: "Security operation without audit trail (missing Write effect in continuation)".into(),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template I: FFICall detected — needs security review.
fn ffi_review_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::FFICall { name, .. } = expr {
                return Some(ComplianceViolation {
                    rule_id: id,
                    profile,
                    message: format!("FFI call to '{}' requires security review", name),
                    severity,
                });
            }
            None
        }),
    }
}

/// Template J: Handle with Unit body (error swallowed).
fn trivial_handle_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Handle(_, _, body) = expr {
                if matches!(body.as_ref(), Expr::Unit) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: "Error handler discards error (body is Unit)".into(),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template K: Grant with overly broad effect (System, Process).
fn broad_grant_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Grant(effect, _) = expr {
                if matches!(effect, Effect::System | Effect::Process) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Overly broad capability grant: {:?} effect", effect),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template L: Perform(Network/NetworkSecure, arg) where arg references sensitive var.
fn sensitive_network_send_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    keywords: &[&str],
    severity: Severity,
) -> ComplianceRule {
    let kw = to_owned_keywords(keywords);
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Perform(Effect::Network | Effect::NetworkSecure, arg) = expr {
                if contains_var_matching(arg, &kw) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: "Sending sensitive data over network without sanitization".into(),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template M: LetRec without If/Case in body (no base case → potential infinite recursion).
fn unbounded_recursion_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::LetRec(name, _, body, _) = expr {
                if !has_if_or_case(body) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Recursive function '{}' has no visible base case (missing If/Case)", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template N: Let binding with input-like name must be tainted (Perform/Classify).
fn tainted_input_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    keywords: &[&str],
    severity: Severity,
) -> ComplianceRule {
    let kw = to_owned_keywords(keywords);
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Let(name, _, value, _) = expr {
                if name_matches(name, &kw) && !is_tainted_expr(value) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Variable '{}' holds user input but is not taint-tracked", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

// ===========================================================================
// PCI-DSS rules (15)
// ===========================================================================

fn pci_dss_rules() -> Vec<ComplianceRule> {
    vec![
        // --- Existing 3 rules (preserved) ---
        ComplianceRule {
            id: "PCI-DSS-3.4",
            profile: ComplianceProfile::PciDss,
            description: "Secret data must not be declassified without a Prove guard",
            check: Box::new(|expr| {
                if let Expr::Declassify(_, proof) = expr {
                    if !matches!(proof.as_ref(), Expr::Prove(_)) {
                        return Some(ComplianceViolation {
                            rule_id: "PCI-DSS-3.4",
                            profile: ComplianceProfile::PciDss,
                            message: "Declassification of secret data requires a Prove guard".into(),
                            severity: Severity::Error,
                        });
                    }
                }
                None
            }),
        },
        ComplianceRule {
            id: "PCI-DSS-6.5",
            profile: ComplianceProfile::PciDss,
            description: "Card data variables must use Secret<_> type",
            check: Box::new(|expr| {
                if let Expr::Let(name, _, value, _) = expr {
                    let lower = name.to_lowercase();
                    if (lower.contains("card") || lower.contains("pan") || lower.contains("cvv"))
                        && !matches!(value.as_ref(), Expr::Classify(_))
                    {
                        return Some(ComplianceViolation {
                            rule_id: "PCI-DSS-6.5",
                            profile: ComplianceProfile::PciDss,
                            message: format!(
                                "Variable '{name}' appears to hold card data but is not wrapped in classify (Secret<_>)"
                            ),
                            severity: Severity::Error,
                        });
                    }
                }
                None
            }),
        },
        ComplianceRule {
            id: "PCI-DSS-8.3",
            profile: ComplianceProfile::PciDss,
            description: "Authentication functions must require Crypto effect",
            check: Box::new(|expr| {
                if let Expr::LetRec(name, _ty, body, _) = expr {
                    let lower = name.to_lowercase();
                    if (lower.contains("auth") || lower.contains("login") || lower.contains("verify_password"))
                        && !contains_effect(body, Effect::Crypto)
                    {
                        return Some(ComplianceViolation {
                            rule_id: "PCI-DSS-8.3",
                            profile: ComplianceProfile::PciDss,
                            message: format!(
                                "Authentication function '{name}' does not use Crypto effect"
                            ),
                            severity: Severity::Warning,
                        });
                    }
                }
                None
            }),
        },
        // --- New 12 rules ---
        sensitive_let_rule(
            "PCI-DSS-3.5.1",
            ComplianceProfile::PciDss,
            "Encryption keys must be Secret-typed",
            &["encryption_key", "aes_key", "private_key", "secret_key", "crypto_key"],
            Severity::Error,
        ),
        insecure_network_rule(
            "PCI-DSS-4.1",
            ComplianceProfile::PciDss,
            "Transmission encryption required",
            Severity::Error,
        ),
        insecure_url_rule(
            "PCI-DSS-6.5.2",
            ComplianceProfile::PciDss,
            "Insecure HTTP communication detected",
            Severity::Error,
        ),
        weak_crypto_rule(
            "PCI-DSS-6.5.3",
            ComplianceProfile::PciDss,
            "Weak cryptographic algorithm detected",
            Severity::Error,
        ),
        trivial_handle_rule(
            "PCI-DSS-6.5.4",
            ComplianceProfile::PciDss,
            "Error handling must not swallow errors",
            Severity::Warning,
        ),
        hardcoded_credential_rule(
            "PCI-DSS-6.5.5",
            ComplianceProfile::PciDss,
            "Hardcoded credentials detected",
            &["password", "passwd", "api_key", "secret_token", "access_key"],
            Severity::Error,
        ),
        sensitive_let_rule(
            "PCI-DSS-6.5.6",
            ComplianceProfile::PciDss,
            "Authentication data must be Secret-typed",
            &["password", "credential", "auth_token", "session_key"],
            Severity::Error,
        ),
        ffi_review_rule(
            "PCI-DSS-6.2.1",
            ComplianceProfile::PciDss,
            "FFI calls require security review",
            Severity::Warning,
        ),
        sensitive_let_rule(
            "PCI-DSS-8.3.1",
            ComplianceProfile::PciDss,
            "MFA/authentication data must be Secret-typed",
            &["pin_code", "otp", "mfa_code", "two_factor"],
            Severity::Error,
        ),
        audit_trail_rule(
            "PCI-DSS-10.2",
            ComplianceProfile::PciDss,
            "Security operations must produce audit events",
            Severity::Warning,
        ),
        broad_grant_rule(
            "PCI-DSS-11.3",
            ComplianceProfile::PciDss,
            "Overly broad capability grants require review",
            Severity::Warning,
        ),
        unbounded_recursion_rule(
            "PCI-DSS-6.3.1",
            ComplianceProfile::PciDss,
            "Recursive functions must have a visible base case",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// HIPAA rules (10)
// ===========================================================================

fn hipaa_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "HIPAA-164.312-a1",
            ComplianceProfile::Hipaa,
            "PHI must be classified as Secret",
            &["patient", "medical", "health", "diagnosis", "phi", "ssn"],
            Severity::Error,
        ),
        auth_crypto_rule(
            "HIPAA-164.312-a2",
            ComplianceProfile::Hipaa,
            "Health system auth must use Crypto effect",
            &["medical_auth", "health_login", "patient_verify", "clinical_auth"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "HIPAA-164.312-c1",
            ComplianceProfile::Hipaa,
            "No hardcoded health system credentials",
            &["patient_id", "medical_id", "health_record_id", "mrn"],
            Severity::Error,
        ),
        declassify_prove_rule(
            "HIPAA-164.312-d",
            ComplianceProfile::Hipaa,
            "PHI declassification requires Prove guard",
            Severity::Error,
        ),
        insecure_network_rule(
            "HIPAA-164.312-e1",
            ComplianceProfile::Hipaa,
            "PHI transmission must use secure channel",
            Severity::Error,
        ),
        sensitive_network_send_rule(
            "HIPAA-164.530-c",
            ComplianceProfile::Hipaa,
            "PHI must not be sent over network without sanitization",
            &["patient", "medical", "health", "phi", "diagnosis"],
            Severity::Error,
        ),
        weak_crypto_rule(
            "HIPAA-164.308-a5",
            ComplianceProfile::Hipaa,
            "Weak crypto not allowed for health data",
            Severity::Error,
        ),
        insecure_url_rule(
            "HIPAA-164.310-d",
            ComplianceProfile::Hipaa,
            "Health system URLs must use HTTPS",
            Severity::Error,
        ),
        audit_trail_rule(
            "HIPAA-164.314-a",
            ComplianceProfile::Hipaa,
            "PHI operations must have audit trail",
            Severity::Warning,
        ),
        trivial_handle_rule(
            "HIPAA-164.316-b",
            ComplianceProfile::Hipaa,
            "Health system errors must not be swallowed",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// GDPR rules (10)
// ===========================================================================

fn gdpr_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "GDPR-5.1-a",
            ComplianceProfile::Gdpr,
            "Personal data must be classified as Secret",
            &["personal", "gdpr_data", "eu_citizen", "subject_data", "pii"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "GDPR-5.1-b",
            ComplianceProfile::Gdpr,
            "No hardcoded personal data",
            &["personal_name", "email_address", "home_address", "phone_number", "birth_date"],
            Severity::Error,
        ),
        sensitive_network_send_rule(
            "GDPR-5.1-c",
            ComplianceProfile::Gdpr,
            "Personal data must not be sent over network without sanitization",
            &["personal", "gdpr_data", "subject", "eu_citizen", "pii"],
            Severity::Error,
        ),
        insecure_url_rule(
            "GDPR-5.1-e",
            ComplianceProfile::Gdpr,
            "Data processing URLs must use HTTPS",
            Severity::Error,
        ),
        weak_crypto_rule(
            "GDPR-5.1-f",
            ComplianceProfile::Gdpr,
            "Weak crypto not allowed for personal data",
            Severity::Error,
        ),
        insecure_network_rule(
            "GDPR-25.1",
            ComplianceProfile::Gdpr,
            "Data protection by design: secure channel required",
            Severity::Error,
        ),
        declassify_prove_rule(
            "GDPR-32",
            ComplianceProfile::Gdpr,
            "Declassification of personal data requires Prove guard",
            Severity::Error,
        ),
        audit_trail_rule(
            "GDPR-33",
            ComplianceProfile::Gdpr,
            "Security operations need audit trail for breach notification",
            Severity::Warning,
        ),
        broad_grant_rule(
            "GDPR-35",
            ComplianceProfile::Gdpr,
            "High-risk processing: overly broad grants flagged",
            Severity::Warning,
        ),
        trivial_handle_rule(
            "GDPR-17",
            ComplianceProfile::Gdpr,
            "Data handling errors must not be silently discarded",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// PDPA Malaysia rules (10)
// ===========================================================================

fn pdpa_rules() -> Vec<ComplianceRule> {
    vec![
        // --- Existing 2 rules (preserved) ---
        ComplianceRule {
            id: "PDPA-S7",
            profile: ComplianceProfile::Pdpa,
            description: "User input must be Tainted<_, UserInput>",
            check: Box::new(|expr| {
                if let Expr::Let(name, _, value, _) = expr {
                    let lower = name.to_lowercase();
                    if (lower.contains("user_input") || lower.contains("personal_data"))
                        && !is_tainted_expr(value)
                    {
                        return Some(ComplianceViolation {
                            rule_id: "PDPA-S7",
                            profile: ComplianceProfile::Pdpa,
                            message: format!(
                                "Variable '{name}' holds user data but is not marked as Tainted<_, UserInput>"
                            ),
                            severity: Severity::Error,
                        });
                    }
                }
                None
            }),
        },
        ComplianceRule {
            id: "PDPA-S24",
            profile: ComplianceProfile::Pdpa,
            description: "No Network effect on personal data without sanitization",
            check: Box::new(|expr| {
                if let Expr::Perform(Effect::Network | Effect::NetworkSecure, arg) = expr {
                    if contains_personal_data_var(arg) {
                        return Some(ComplianceViolation {
                            rule_id: "PDPA-S24",
                            profile: ComplianceProfile::Pdpa,
                            message: "Sending personal data over network without sanitization".into(),
                            severity: Severity::Error,
                        });
                    }
                }
                None
            }),
        },
        // --- New 8 rules ---
        sensitive_let_rule(
            "PDPA-S6",
            ComplianceProfile::Pdpa,
            "Personal data must be classified (consent principle)",
            &["nama", "ic_number", "kad_pengenalan", "no_telefon", "alamat_emel"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "PDPA-S8",
            ComplianceProfile::Pdpa,
            "No hardcoded personal data (disclosure principle)",
            &["nama_penuh", "no_ic", "alamat", "no_tel", "emel"],
            Severity::Error,
        ),
        insecure_network_rule(
            "PDPA-S9",
            ComplianceProfile::Pdpa,
            "Personal data transmission must use secure channel",
            Severity::Error,
        ),
        declassify_prove_rule(
            "PDPA-S10",
            ComplianceProfile::Pdpa,
            "Personal data declassification requires Prove guard (retention principle)",
            Severity::Error,
        ),
        weak_crypto_rule(
            "PDPA-S11",
            ComplianceProfile::Pdpa,
            "Weak crypto not allowed for personal data (integrity principle)",
            Severity::Error,
        ),
        auth_crypto_rule(
            "PDPA-S12",
            ComplianceProfile::Pdpa,
            "Access control functions must use Crypto (access principle)",
            &["akses", "capaian", "kebenaran", "pengesahan"],
            Severity::Warning,
        ),
        audit_trail_rule(
            "PDPA-S13-1",
            ComplianceProfile::Pdpa,
            "Personal data operations need audit trail (cross-border transfer)",
            Severity::Warning,
        ),
        trivial_handle_rule(
            "PDPA-S42",
            ComplianceProfile::Pdpa,
            "Error handling for personal data must not be swallowed (breach notification)",
            Severity::Warning,
        ),
    ]
}

/// Check if an expression references a variable with personal-data naming.
fn contains_personal_data_var(expr: &Expr) -> bool {
    match expr {
        Expr::Var(name) => {
            let lower = name.to_lowercase();
            lower.contains("personal") || lower.contains("user_data")
                || lower.contains("nama") || lower.contains("ic_number")
        }
        Expr::App(f, a) => contains_personal_data_var(f) || contains_personal_data_var(a),
        Expr::Pair(l, r) => contains_personal_data_var(l) || contains_personal_data_var(r),
        Expr::Fst(e) | Expr::Snd(e) | Expr::Classify(e) => contains_personal_data_var(e),
        _ => false,
    }
}

// ===========================================================================
// BNM RMiT rules (10)
// ===========================================================================

fn bnm_rules() -> Vec<ComplianceRule> {
    vec![
        // --- Existing 1 rule (preserved) ---
        ComplianceRule {
            id: "BNM-RMiT-10",
            profile: ComplianceProfile::Bnm,
            description: "Financial crypto must use ConstantTime<_>",
            check: Box::new(|expr| {
                if let Expr::Perform(Effect::Crypto, arg) = expr {
                    if !is_constant_time_wrapped(arg) {
                        return Some(ComplianceViolation {
                            rule_id: "BNM-RMiT-10",
                            profile: ComplianceProfile::Bnm,
                            message: "Crypto operation argument should use ConstantTime<_> type for financial data".into(),
                            severity: Severity::Warning,
                        });
                    }
                }
                None
            }),
        },
        // --- New 9 rules ---
        sensitive_let_rule(
            "BNM-10.18",
            ComplianceProfile::Bnm,
            "Financial data must be Secret-typed",
            &["financial", "banking", "akaun", "transaksi", "baki"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "BNM-10.49-b",
            ComplianceProfile::Bnm,
            "No hardcoded financial credentials",
            &["pin_bank", "kata_laluan", "token_bank", "kunci_api"],
            Severity::Error,
        ),
        auth_crypto_rule(
            "BNM-10.50",
            ComplianceProfile::Bnm,
            "Financial auth must use Crypto effect",
            &["pengesahan", "log_masuk", "sahkan", "bank_auth"],
            Severity::Error,
        ),
        audit_trail_rule(
            "BNM-10.51",
            ComplianceProfile::Bnm,
            "Financial transactions must have audit trail",
            Severity::Error,
        ),
        declassify_prove_rule(
            "BNM-10.52",
            ComplianceProfile::Bnm,
            "Financial data declassification requires Prove guard",
            Severity::Error,
        ),
        trivial_handle_rule(
            "BNM-10.54",
            ComplianceProfile::Bnm,
            "Financial error handling must not swallow errors",
            Severity::Warning,
        ),
        ffi_review_rule(
            "BNM-10.55",
            ComplianceProfile::Bnm,
            "Third-party FFI calls require security review",
            Severity::Warning,
        ),
        insecure_network_rule(
            "BNM-10.56",
            ComplianceProfile::Bnm,
            "Financial network communication must use secure channel",
            Severity::Error,
        ),
        insecure_url_rule(
            "BNM-10.58",
            ComplianceProfile::Bnm,
            "Financial system URLs must use HTTPS",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// MAS TRM Singapore rules (8)
// ===========================================================================

fn mas_trm_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "MAS-TRM-5.1.1",
            ComplianceProfile::MasTrm,
            "Customer/financial data must be Secret-typed",
            &["customer", "account", "balance", "transaction", "financial"],
            Severity::Error,
        ),
        weak_crypto_rule(
            "MAS-TRM-9.1.1",
            ComplianceProfile::MasTrm,
            "Weak crypto not allowed for financial systems",
            Severity::Error,
        ),
        auth_crypto_rule(
            "MAS-TRM-9.2.1",
            ComplianceProfile::MasTrm,
            "Financial auth must use Crypto effect",
            &["authenticate", "verify", "authorize", "login"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "MAS-TRM-9.4.1",
            ComplianceProfile::MasTrm,
            "No hardcoded credentials in financial systems",
            &["password", "token", "api_key", "secret", "credential"],
            Severity::Error,
        ),
        insecure_network_rule(
            "MAS-TRM-11.1.1",
            ComplianceProfile::MasTrm,
            "Financial data transmission must use secure channel",
            Severity::Error,
        ),
        sensitive_network_send_rule(
            "MAS-TRM-11.2.1",
            ComplianceProfile::MasTrm,
            "Customer data must not be sent over network without sanitization",
            &["customer", "account", "financial", "transaction"],
            Severity::Error,
        ),
        audit_trail_rule(
            "MAS-TRM-12.1.1",
            ComplianceProfile::MasTrm,
            "Financial operations must have audit trail",
            Severity::Warning,
        ),
        broad_grant_rule(
            "MAS-TRM-13.1.1",
            ComplianceProfile::MasTrm,
            "Overly broad grants require review in financial systems",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// NIST 800-53 rules (10)
// ===========================================================================

fn nist_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "NIST-AC-1",
            ComplianceProfile::Nist80053,
            "Sensitive data must be classified as Secret",
            &["classified", "sensitive", "protected", "controlled"],
            Severity::Error,
        ),
        broad_grant_rule(
            "NIST-AC-6",
            ComplianceProfile::Nist80053,
            "Least privilege: overly broad grants flagged",
            Severity::Warning,
        ),
        audit_trail_rule(
            "NIST-AU-2",
            ComplianceProfile::Nist80053,
            "Security operations must produce audit events",
            Severity::Warning,
        ),
        hardcoded_credential_rule(
            "NIST-IA-5",
            ComplianceProfile::Nist80053,
            "No hardcoded authenticators",
            &["password", "token", "credential", "api_key", "secret"],
            Severity::Error,
        ),
        insecure_network_rule(
            "NIST-SC-8",
            ComplianceProfile::Nist80053,
            "Transmission confidentiality: secure channel required",
            Severity::Error,
        ),
        sensitive_let_rule(
            "NIST-SC-12",
            ComplianceProfile::Nist80053,
            "Cryptographic keys must be Secret-typed",
            &["crypto_key", "signing_key", "cert_key", "private_key"],
            Severity::Error,
        ),
        weak_crypto_rule(
            "NIST-SC-13",
            ComplianceProfile::Nist80053,
            "Weak cryptographic algorithms prohibited",
            Severity::Error,
        ),
        insecure_url_rule(
            "NIST-SC-28",
            ComplianceProfile::Nist80053,
            "Data at rest/in transit must use HTTPS",
            Severity::Error,
        ),
        ffi_review_rule(
            "NIST-SI-2",
            ComplianceProfile::Nist80053,
            "FFI calls require flaw remediation review",
            Severity::Warning,
        ),
        tainted_input_rule(
            "NIST-SI-10",
            ComplianceProfile::Nist80053,
            "User input must be taint-tracked for validation",
            &["user_input", "form_data", "request_body", "query_param"],
            Severity::Error,
        ),
    ]
}

// ===========================================================================
// ISO 27001 rules (10)
// ===========================================================================

fn iso27001_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "ISO-A5.1",
            ComplianceProfile::Iso27001,
            "Sensitive data must be classified as Secret",
            &["sensitive", "confidential", "restricted", "internal"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "ISO-A6.1",
            ComplianceProfile::Iso27001,
            "No hardcoded credentials",
            &["password", "token", "credential", "api_key"],
            Severity::Error,
        ),
        declassify_prove_rule(
            "ISO-A8.1",
            ComplianceProfile::Iso27001,
            "Asset declassification requires Prove guard",
            Severity::Error,
        ),
        auth_crypto_rule(
            "ISO-A9.1",
            ComplianceProfile::Iso27001,
            "Access control functions must use Crypto",
            &["authenticate", "authorize", "login", "verify"],
            Severity::Error,
        ),
        weak_crypto_rule(
            "ISO-A10.1",
            ComplianceProfile::Iso27001,
            "Weak cryptographic algorithms prohibited",
            Severity::Error,
        ),
        audit_trail_rule(
            "ISO-A12.1",
            ComplianceProfile::Iso27001,
            "Operations security: audit trail required",
            Severity::Warning,
        ),
        insecure_network_rule(
            "ISO-A13.1",
            ComplianceProfile::Iso27001,
            "Communications security: secure channel required",
            Severity::Error,
        ),
        ffi_review_rule(
            "ISO-A14.1",
            ComplianceProfile::Iso27001,
            "System acquisition: FFI calls require review",
            Severity::Warning,
        ),
        trivial_handle_rule(
            "ISO-A16.1",
            ComplianceProfile::Iso27001,
            "Incident management: errors must not be swallowed",
            Severity::Warning,
        ),
        insecure_url_rule(
            "ISO-A18.1",
            ComplianceProfile::Iso27001,
            "Compliance: URLs must use HTTPS",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// DO-178C rules (10)
// ===========================================================================

fn do178c_rules() -> Vec<ComplianceRule> {
    vec![
        unbounded_recursion_rule(
            "DO178C-6.3.1",
            ComplianceProfile::Do178c,
            "Low-level requirements traceability: recursion must have base case",
            Severity::Error,
        ),
        ComplianceRule {
            id: "DO178C-6.3.2",
            profile: ComplianceProfile::Do178c,
            description: "Dead code detection: Unit in non-terminal Let value",
            check: Box::new(|expr| {
                if let Expr::Let(name, _, value, body) = expr {
                    if matches!(value.as_ref(), Expr::Unit) && !matches!(body.as_ref(), Expr::Unit) {
                        return Some(ComplianceViolation {
                            rule_id: "DO178C-6.3.2",
                            profile: ComplianceProfile::Do178c,
                            message: format!("Potential dead code: '{}' bound to Unit with non-trivial continuation", name),
                            severity: Severity::Warning,
                        });
                    }
                }
                None
            }),
        },
        ffi_review_rule(
            "DO178C-6.3.3",
            ComplianceProfile::Do178c,
            "Source code traceability: FFI calls require review",
            Severity::Error,
        ),
        trivial_handle_rule(
            "DO178C-6.4.1",
            ComplianceProfile::Do178c,
            "Test coverage: error handlers must not be trivial",
            Severity::Error,
        ),
        declassify_prove_rule(
            "DO178C-6.4.2",
            ComplianceProfile::Do178c,
            "Decision coverage: declassification requires Prove guard",
            Severity::Error,
        ),
        weak_crypto_rule(
            "DO178C-6.4.3",
            ComplianceProfile::Do178c,
            "MC/DC: weak crypto in safety-critical system",
            Severity::Error,
        ),
        sensitive_let_rule(
            "DO178C-6.4.4",
            ComplianceProfile::Do178c,
            "Data flow: flight data must be classified",
            &["flight", "altitude", "airspeed", "navigation", "sensor_data"],
            Severity::Error,
        ),
        broad_grant_rule(
            "DO178C-6.4.5",
            ComplianceProfile::Do178c,
            "Control flow: overly broad grants in safety system",
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "DO178C-6.7.1",
            ComplianceProfile::Do178c,
            "Stack usage: no hardcoded safety-critical values",
            &["altitude_limit", "speed_limit", "threshold", "max_altitude", "min_speed"],
            Severity::Warning,
        ),
        insecure_network_rule(
            "DO178C-6.7.2",
            ComplianceProfile::Do178c,
            "Aviation systems must use secure communication channels",
            Severity::Error,
        ),
    ]
}

// ===========================================================================
// SOX rules (8)
// ===========================================================================

fn sox_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "SOX-302-1",
            ComplianceProfile::Sox,
            "Financial data must be classified as Secret",
            &["revenue", "profit", "earnings", "financial_report", "balance_sheet"],
            Severity::Error,
        ),
        auth_crypto_rule(
            "SOX-302-2",
            ComplianceProfile::Sox,
            "Financial system auth must use Crypto",
            &["financial_auth", "accounting_login", "audit_verify", "reporting_auth"],
            Severity::Error,
        ),
        audit_trail_rule(
            "SOX-404-1",
            ComplianceProfile::Sox,
            "Financial operations must have audit trail",
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "SOX-404-2",
            ComplianceProfile::Sox,
            "No hardcoded financial data",
            &["revenue_amount", "profit_margin", "earning_value", "balance_total"],
            Severity::Warning,
        ),
        trivial_handle_rule(
            "SOX-409-1",
            ComplianceProfile::Sox,
            "Financial error handling must not be swallowed",
            Severity::Error,
        ),
        declassify_prove_rule(
            "SOX-802-1",
            ComplianceProfile::Sox,
            "Financial data declassification requires Prove guard",
            Severity::Error,
        ),
        insecure_network_rule(
            "SOX-906-1",
            ComplianceProfile::Sox,
            "Financial reporting must use secure channel",
            Severity::Error,
        ),
        broad_grant_rule(
            "SOX-1102-1",
            ComplianceProfile::Sox,
            "Broad grants in financial system require review",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// CMMC rules (6)
// ===========================================================================

fn cmmc_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "CMMC-AC-1",
            ComplianceProfile::Cmmc,
            "CUI must be classified as Secret",
            &["cui", "controlled_unclassified", "fouo", "sensitive_but"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "CMMC-AC-2",
            ComplianceProfile::Cmmc,
            "No hardcoded credentials in defense systems",
            &["password", "token", "credential", "api_key"],
            Severity::Error,
        ),
        insecure_network_rule(
            "CMMC-SC-1",
            ComplianceProfile::Cmmc,
            "Defense systems must use secure channels",
            Severity::Error,
        ),
        weak_crypto_rule(
            "CMMC-SC-2",
            ComplianceProfile::Cmmc,
            "Weak crypto prohibited in defense systems",
            Severity::Error,
        ),
        ffi_review_rule(
            "CMMC-SI-1",
            ComplianceProfile::Cmmc,
            "FFI calls require security review in defense context",
            Severity::Warning,
        ),
        audit_trail_rule(
            "CMMC-AU-1",
            ComplianceProfile::Cmmc,
            "Security operations must have audit trail",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// IEC 62443 rules (6)
// ===========================================================================

fn iec62443_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "IEC62443-SR-1",
            ComplianceProfile::Iec62443,
            "Industrial control data must be classified",
            &["scada", "plc", "hmi", "control_system", "sensor_data"],
            Severity::Error,
        ),
        insecure_network_rule(
            "IEC62443-SR-2",
            ComplianceProfile::Iec62443,
            "ICS communications must use secure channel",
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "IEC62443-SR-3",
            ComplianceProfile::Iec62443,
            "No hardcoded ICS credentials",
            &["password", "token", "credential", "plc_key", "scada_pass"],
            Severity::Error,
        ),
        trivial_handle_rule(
            "IEC62443-SR-4",
            ComplianceProfile::Iec62443,
            "ICS error handling must not swallow errors",
            Severity::Error,
        ),
        ffi_review_rule(
            "IEC62443-SR-5",
            ComplianceProfile::Iec62443,
            "FFI calls in ICS require security review",
            Severity::Warning,
        ),
        weak_crypto_rule(
            "IEC62443-SR-6",
            ComplianceProfile::Iec62443,
            "Weak crypto prohibited in ICS",
            Severity::Error,
        ),
    ]
}

// ===========================================================================
// NERC CIP rules (5)
// ===========================================================================

fn nerc_cip_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "NERC-CIP-004",
            ComplianceProfile::NercCip,
            "Grid/energy data must be classified as Secret",
            &["grid", "substation", "generator", "transformer", "load_data"],
            Severity::Error,
        ),
        insecure_network_rule(
            "NERC-CIP-005",
            ComplianceProfile::NercCip,
            "Energy grid communications must use secure channel",
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "NERC-CIP-007",
            ComplianceProfile::NercCip,
            "No hardcoded energy system credentials",
            &["password", "token", "scada_key", "grid_pass"],
            Severity::Error,
        ),
        audit_trail_rule(
            "NERC-CIP-010",
            ComplianceProfile::NercCip,
            "Energy system operations must have audit trail",
            Severity::Warning,
        ),
        broad_grant_rule(
            "NERC-CIP-011",
            ComplianceProfile::NercCip,
            "Broad grants in energy systems require review",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// FDA 21 CFR Part 11 rules (5)
// ===========================================================================

fn fda_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "FDA-11.10-a",
            ComplianceProfile::Fda21cfr,
            "Electronic health records must be classified",
            &["patient_record", "drug_data", "clinical", "trial_data", "pharma"],
            Severity::Error,
        ),
        auth_crypto_rule(
            "FDA-11.10-b",
            ComplianceProfile::Fda21cfr,
            "Clinical system auth must use Crypto",
            &["clinical_auth", "pharma_login", "drug_verify", "trial_auth"],
            Severity::Error,
        ),
        hardcoded_credential_rule(
            "FDA-11.10-c",
            ComplianceProfile::Fda21cfr,
            "No hardcoded clinical system credentials",
            &["password", "token", "credential", "pharma_key"],
            Severity::Error,
        ),
        audit_trail_rule(
            "FDA-11.10-d",
            ComplianceProfile::Fda21cfr,
            "Clinical operations must have audit trail",
            Severity::Error,
        ),
        insecure_network_rule(
            "FDA-11.10-e",
            ComplianceProfile::Fda21cfr,
            "Clinical data transmission must use secure channel",
            Severity::Error,
        ),
    ]
}

// ===========================================================================
// ITAR rules (4)
// ===========================================================================

fn itar_rules() -> Vec<ComplianceRule> {
    vec![
        sensitive_let_rule(
            "ITAR-120.1",
            ComplianceProfile::Itar,
            "Defense/munitions data must be classified as Secret",
            &["munition", "weapon", "defense", "military", "export_controlled"],
            Severity::Error,
        ),
        ffi_review_rule(
            "ITAR-120.2",
            ComplianceProfile::Itar,
            "FFI calls require ITAR compliance review",
            Severity::Error,
        ),
        insecure_network_rule(
            "ITAR-120.3",
            ComplianceProfile::Itar,
            "Defense data transmission must use secure channel",
            Severity::Error,
        ),
        broad_grant_rule(
            "ITAR-120.4",
            ComplianceProfile::Itar,
            "Broad grants in defense systems require review",
            Severity::Error,
        ),
    ]
}
