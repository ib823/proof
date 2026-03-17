// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Compliance rule definitions per profile.
//! Spec: 04_SPECS/industries/
//!
//! 233 rules across 15 compliance profiles, each with AST-level detection.

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
        ComplianceProfile::PciDss => 25,
        ComplianceProfile::Pdpa => 18,
        ComplianceProfile::Bnm => 18,
        ComplianceProfile::Hipaa => 18,
        ComplianceProfile::Cmmc => 12,
        ComplianceProfile::Sox => 15,
        ComplianceProfile::Gdpr => 18,
        ComplianceProfile::Do178c => 18,
        ComplianceProfile::Iec62443 => 12,
        ComplianceProfile::NercCip => 10,
        ComplianceProfile::Fda21cfr => 10,
        ComplianceProfile::Iso27001 => 18,
        ComplianceProfile::Nist80053 => 18,
        ComplianceProfile::MasTrm => 15,
        ComplianceProfile::Itar => 8,
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

/// Template O: String literal containing a hardcoded IP address pattern.
fn hardcoded_ip_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::String(s) = expr {
                // Simple heuristic: contains digit.digit.digit.digit pattern
                let bytes = s.as_bytes();
                let mut i = 0;
                while i < bytes.len() {
                    if bytes[i].is_ascii_digit() {
                        // Try to match N.N.N.N
                        let mut parts = 0;
                        let mut j = i;
                        while j < bytes.len() && parts < 4 {
                            if !bytes[j].is_ascii_digit() { break; }
                            while j < bytes.len() && bytes[j].is_ascii_digit() { j += 1; }
                            parts += 1;
                            if parts < 4 {
                                if j < bytes.len() && bytes[j] == b'.' {
                                    j += 1;
                                } else {
                                    break;
                                }
                            }
                        }
                        if parts == 4 {
                            return Some(ComplianceViolation {
                                rule_id: id,
                                profile,
                                message: format!("Hardcoded IP address detected in string: '{}'", s),
                                severity,
                            });
                        }
                    }
                    i += 1;
                }
            }
            None
        }),
    }
}

/// Template P: Integer literal matching a well-known network port.
fn hardcoded_port_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Int(n) = expr {
                let well_known: &[u64] = &[
                    20, 21, 22, 23, 25, 53, 80, 110, 143, 443,
                    445, 993, 995, 1433, 1521, 3306, 3389, 5432,
                    5900, 6379, 8080, 8443, 9090, 27017,
                ];
                if well_known.contains(n) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Hardcoded network port detected: {}", n),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template Q: String literal containing debug/diagnostic patterns.
fn debug_code_rule(
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
                if lower.contains("debug") || lower.contains("println")
                    || lower.contains("console.log") || lower.contains("print_debug")
                    || lower.contains("todo!") || lower.contains("fixme")
                    || lower.contains("hack:")
                {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Debug/diagnostic code detected: '{}'", s),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template R: Let binding with security-flag name bound to Bool(false).
fn insecure_default_rule(
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
                if name_matches(name, &kw) && matches!(value.as_ref(), Expr::Bool(false)) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Security setting '{}' defaults to false (insecure default)", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template S: Let binding with temporal name but body lacks Time effect.
fn temporal_no_expiry_rule(
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
            if let Expr::Let(name, _, _value, body) = expr {
                if name_matches(name, &kw) && !contains_effect(body, Effect::Time) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Variable '{}' holds temporal data but body lacks Time effect for expiry handling", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template T: Grant with non-standard effects (FileSystem, Random, Time) beyond System/Process.
fn excessive_grant_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Grant(effect, _) = expr {
                if matches!(effect, Effect::FileSystem | Effect::Random | Effect::Time) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("Excessive capability grant: {:?} effect should be minimized", effect),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template U: Classify operation in Let value but body lacks Write (audit) effect.
fn classify_without_audit_rule(
    id: &'static str,
    profile: ComplianceProfile,
    description: &'static str,
    severity: Severity,
) -> ComplianceRule {
    ComplianceRule {
        id, profile, description,
        check: Box::new(move |expr| {
            if let Expr::Let(_, _, value, body) = expr {
                if matches!(value.as_ref(), Expr::Classify(_)) && !contains_effect(body, Effect::Write) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: "Classification operation without audit trail (missing Write effect in continuation)".into(),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

/// Template V: FFICall with sensitive-looking function name.
fn sensitive_ffi_rule(
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
            if let Expr::FFICall { name, .. } = expr {
                if name_matches(name, &kw) {
                    return Some(ComplianceViolation {
                        rule_id: id,
                        profile,
                        message: format!("FFI call to sensitive function '{}' requires enhanced security review", name),
                        severity,
                    });
                }
            }
            None
        }),
    }
}

// ===========================================================================
// PCI-DSS rules (25)
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
        // --- 10 new rules (templates O-V + L, N) ---
        hardcoded_ip_rule(
            "PCI-DSS-1.3.1",
            ComplianceProfile::PciDss,
            "No hardcoded IP addresses in payment systems",
            Severity::Warning,
        ),
        hardcoded_port_rule(
            "PCI-DSS-1.3.2",
            ComplianceProfile::PciDss,
            "No hardcoded network ports in payment systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "PCI-DSS-2.2.1",
            ComplianceProfile::PciDss,
            "Security settings must not default to false",
            &["encryption_enabled", "tls_required", "auth_required", "secure_mode", "verify_ssl"],
            Severity::Error,
        ),
        temporal_no_expiry_rule(
            "PCI-DSS-3.6.1",
            ComplianceProfile::PciDss,
            "Cryptographic keys must have expiry handling",
            &["key_created", "cert_date", "token_issued", "key_timestamp", "session_start"],
            Severity::Warning,
        ),
        debug_code_rule(
            "PCI-DSS-4.2.1",
            ComplianceProfile::PciDss,
            "No debug code in production payment systems",
            Severity::Warning,
        ),
        sensitive_network_send_rule(
            "PCI-DSS-6.5.7",
            ComplianceProfile::PciDss,
            "Card data must not be sent over network without sanitization",
            &["card", "pan", "cvv", "card_number", "expiry"],
            Severity::Error,
        ),
        tainted_input_rule(
            "PCI-DSS-6.5.8",
            ComplianceProfile::PciDss,
            "User input in payment flow must be taint-tracked",
            &["user_input", "form_data", "payment_input", "card_input"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "PCI-DSS-7.1.1",
            ComplianceProfile::PciDss,
            "Excessive capability grants in payment context",
            Severity::Warning,
        ),
        sensitive_ffi_rule(
            "PCI-DSS-8.5.1",
            ComplianceProfile::PciDss,
            "FFI calls to auth-related functions need enhanced review",
            &["auth", "login", "password", "credential", "token"],
            Severity::Warning,
        ),
        classify_without_audit_rule(
            "PCI-DSS-10.3.1",
            ComplianceProfile::PciDss,
            "Classification operations must have audit trail",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// HIPAA rules (18)
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
        // --- 8 new rules ---
        hardcoded_ip_rule(
            "HIPAA-164.308-a1",
            ComplianceProfile::Hipaa,
            "No hardcoded IPs in health systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "HIPAA-164.308-a3",
            ComplianceProfile::Hipaa,
            "No debug code in clinical systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "HIPAA-164.310-a",
            ComplianceProfile::Hipaa,
            "Health system security defaults must be enabled",
            &["encryption_enabled", "hipaa_mode", "audit_enabled", "phi_protection", "access_control"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "HIPAA-164.312-b",
            ComplianceProfile::Hipaa,
            "No hardcoded ports in health systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "HIPAA-164.312-c2",
            ComplianceProfile::Hipaa,
            "Health records must have retention handling",
            &["record_date", "admission_date", "discharge_date", "prescription_date", "consent_date"],
            Severity::Warning,
        ),
        excessive_grant_rule(
            "HIPAA-164.312-e2",
            ComplianceProfile::Hipaa,
            "Excessive grants in health context",
            Severity::Warning,
        ),
        tainted_input_rule(
            "HIPAA-164.530-a",
            ComplianceProfile::Hipaa,
            "Patient input must be taint-tracked",
            &["patient_input", "medical_form", "health_data", "clinical_input"],
            Severity::Error,
        ),
        sensitive_ffi_rule(
            "HIPAA-164.530-b",
            ComplianceProfile::Hipaa,
            "FFI to health-data functions need enhanced review",
            &["patient", "medical", "health", "clinical", "pharma"],
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// GDPR rules (18)
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
        // --- 8 new rules ---
        hardcoded_ip_rule(
            "GDPR-5.1-d",
            ComplianceProfile::Gdpr,
            "No hardcoded IPs (data localization)",
            Severity::Warning,
        ),
        debug_code_rule(
            "GDPR-6.1",
            ComplianceProfile::Gdpr,
            "No debug code with personal data",
            Severity::Warning,
        ),
        insecure_default_rule(
            "GDPR-13.1",
            ComplianceProfile::Gdpr,
            "Privacy defaults must be enabled (privacy by default)",
            &["consent_required", "data_protection", "privacy_mode", "gdpr_enabled", "anonymize"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "GDPR-15.1",
            ComplianceProfile::Gdpr,
            "No hardcoded ports in data processing",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "GDPR-17.1",
            ComplianceProfile::Gdpr,
            "Personal data must have retention/expiry handling",
            &["consent_date", "data_collected", "retention_start", "processing_date", "erasure_date"],
            Severity::Warning,
        ),
        tainted_input_rule(
            "GDPR-20.1",
            ComplianceProfile::Gdpr,
            "User input must be taint-tracked for GDPR",
            &["user_input", "subject_data", "consent_form", "data_request"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "GDPR-25.2",
            ComplianceProfile::Gdpr,
            "Excessive grants violate data minimization",
            Severity::Warning,
        ),
        sensitive_ffi_rule(
            "GDPR-44.1",
            ComplianceProfile::Gdpr,
            "FFI to data-transfer functions need review",
            &["transfer", "export", "personal", "subject", "consent"],
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// PDPA Malaysia rules (18)
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
        // --- 8 new rules ---
        hardcoded_ip_rule(
            "PDPA-S5",
            ComplianceProfile::Pdpa,
            "No hardcoded IPs in personal data systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "PDPA-S7-1",
            ComplianceProfile::Pdpa,
            "No debug code exposing personal data",
            Severity::Warning,
        ),
        insecure_default_rule(
            "PDPA-S14",
            ComplianceProfile::Pdpa,
            "Data protection defaults must be enabled",
            &["perlindungan", "data_protection", "consent_enabled", "privacy_mode", "kebenaran_data"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "PDPA-S15",
            ComplianceProfile::Pdpa,
            "No hardcoded ports in data systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "PDPA-S16",
            ComplianceProfile::Pdpa,
            "Personal data must have retention period",
            &["tarikh_kutip", "data_collected", "tarikh_persetujuan", "consent_date", "tarikh_simpan"],
            Severity::Warning,
        ),
        tainted_input_rule(
            "PDPA-S17",
            ComplianceProfile::Pdpa,
            "User input must be taint-tracked",
            &["input_pengguna", "data_borang", "user_input", "form_data"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "PDPA-S18",
            ComplianceProfile::Pdpa,
            "Excessive grants on personal data",
            Severity::Warning,
        ),
        sensitive_ffi_rule(
            "PDPA-S19",
            ComplianceProfile::Pdpa,
            "FFI calls handling personal data need review",
            &["personal", "nama", "ic_number", "data_peribadi", "pengguna"],
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
// BNM RMiT rules (18)
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
        // --- 8 new rules ---
        hardcoded_ip_rule(
            "BNM-10.18-1",
            ComplianceProfile::Bnm,
            "No hardcoded IPs in financial systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "BNM-10.49-c",
            ComplianceProfile::Bnm,
            "No debug code in banking systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "BNM-10.53",
            ComplianceProfile::Bnm,
            "Financial security defaults must be enabled",
            &["keselamatan", "encryption_enabled", "audit_mode", "tls_required", "pengesahan_aktif"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "BNM-10.57",
            ComplianceProfile::Bnm,
            "No hardcoded ports in banking",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "BNM-10.59",
            ComplianceProfile::Bnm,
            "Financial records must have retention handling",
            &["tarikh_transaksi", "transaction_date", "statement_date", "tarikh_audit", "maturity_date"],
            Severity::Warning,
        ),
        tainted_input_rule(
            "BNM-10.60",
            ComplianceProfile::Bnm,
            "Financial user input must be taint-tracked",
            &["input_pelanggan", "customer_input", "form_bank", "transaction_input"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "BNM-10.61",
            ComplianceProfile::Bnm,
            "Excessive grants in financial context",
            Severity::Warning,
        ),
        sensitive_ffi_rule(
            "BNM-10.62",
            ComplianceProfile::Bnm,
            "FFI to financial functions need review",
            &["bank", "financial", "transaksi", "akaun", "payment"],
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// MAS TRM Singapore rules (15)
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
        // --- 7 new rules ---
        hardcoded_ip_rule(
            "MAS-TRM-5.1.2",
            ComplianceProfile::MasTrm,
            "No hardcoded IPs in financial systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "MAS-TRM-9.1.2",
            ComplianceProfile::MasTrm,
            "No debug code in financial systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "MAS-TRM-9.2.2",
            ComplianceProfile::MasTrm,
            "Security defaults must be enabled",
            &["encryption_enabled", "mfa_required", "audit_enabled", "tls_mode", "auth_required"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "MAS-TRM-9.4.2",
            ComplianceProfile::MasTrm,
            "No hardcoded ports in financial systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "MAS-TRM-11.1.2",
            ComplianceProfile::MasTrm,
            "Financial data must have retention handling",
            &["transaction_date", "statement_date", "audit_timestamp", "session_created", "token_issued"],
            Severity::Warning,
        ),
        tainted_input_rule(
            "MAS-TRM-11.2.2",
            ComplianceProfile::MasTrm,
            "Customer input must be taint-tracked",
            &["customer_input", "user_input", "form_data", "transaction_input"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "MAS-TRM-12.1.2",
            ComplianceProfile::MasTrm,
            "Excessive grants in financial systems",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// NIST 800-53 rules (18)
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
        // --- 8 new rules ---
        hardcoded_ip_rule(
            "NIST-AC-2",
            ComplianceProfile::Nist80053,
            "No hardcoded IPs in federal systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "NIST-AU-3",
            ComplianceProfile::Nist80053,
            "No debug code in production",
            Severity::Warning,
        ),
        insecure_default_rule(
            "NIST-CM-6",
            ComplianceProfile::Nist80053,
            "Security configs must not default to false",
            &["fips_mode", "encryption_enabled", "audit_enabled", "tls_required", "auth_required"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "NIST-IA-6",
            ComplianceProfile::Nist80053,
            "No hardcoded ports in federal systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "NIST-SC-4",
            ComplianceProfile::Nist80053,
            "Sensitive data must have retention handling",
            &["classification_date", "cert_expiry", "key_created", "session_start", "token_timestamp"],
            Severity::Warning,
        ),
        excessive_grant_rule(
            "NIST-AC-6-1",
            ComplianceProfile::Nist80053,
            "Least privilege enforcement",
            Severity::Warning,
        ),
        sensitive_ffi_rule(
            "NIST-SA-11",
            ComplianceProfile::Nist80053,
            "FFI calls require developer security testing",
            &["crypto", "auth", "certificate", "classified", "secure"],
            Severity::Warning,
        ),
        classify_without_audit_rule(
            "NIST-AU-12",
            ComplianceProfile::Nist80053,
            "Classification must produce audit events",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// ISO 27001 rules (18)
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
        // --- 8 new rules ---
        hardcoded_ip_rule(
            "ISO-A5.2",
            ComplianceProfile::Iso27001,
            "No hardcoded IPs in information systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "ISO-A7.1",
            ComplianceProfile::Iso27001,
            "No debug code in production",
            Severity::Warning,
        ),
        insecure_default_rule(
            "ISO-A8.2",
            ComplianceProfile::Iso27001,
            "Security defaults must be enabled",
            &["encryption_enabled", "access_control", "audit_enabled", "secure_mode", "tls_required"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "ISO-A9.2",
            ComplianceProfile::Iso27001,
            "No hardcoded ports in information systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "ISO-A11.1",
            ComplianceProfile::Iso27001,
            "Data must have retention handling",
            &["classification_date", "review_date", "access_granted_date", "cert_expiry", "policy_date"],
            Severity::Warning,
        ),
        tainted_input_rule(
            "ISO-A12.2",
            ComplianceProfile::Iso27001,
            "External input must be taint-tracked",
            &["user_input", "external_data", "api_input", "form_data"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "ISO-A15.1",
            ComplianceProfile::Iso27001,
            "Supplier grants must be minimal",
            Severity::Warning,
        ),
        sensitive_ffi_rule(
            "ISO-A17.1",
            ComplianceProfile::Iso27001,
            "FFI calls in continuity planning need review",
            &["backup", "recovery", "restore", "continuity", "disaster"],
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// DO-178C rules (18)
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
        // --- 8 new rules ---
        hardcoded_ip_rule(
            "DO178C-6.3.4",
            ComplianceProfile::Do178c,
            "No hardcoded IPs in avionics",
            Severity::Warning,
        ),
        debug_code_rule(
            "DO178C-6.3.5",
            ComplianceProfile::Do178c,
            "No debug code in safety-critical systems",
            Severity::Error,
        ),
        insecure_default_rule(
            "DO178C-6.4.6",
            ComplianceProfile::Do178c,
            "Safety defaults must be enabled",
            &["safety_enabled", "redundancy_active", "failsafe_mode", "monitoring_enabled", "watchdog_active"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "DO178C-6.4.7",
            ComplianceProfile::Do178c,
            "No hardcoded ports in avionics",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "DO178C-6.4.8",
            ComplianceProfile::Do178c,
            "Flight data must have temporal handling",
            &["flight_time", "sensor_timestamp", "calibration_date", "maintenance_date", "inspection_date"],
            Severity::Warning,
        ),
        tainted_input_rule(
            "DO178C-6.7.3",
            ComplianceProfile::Do178c,
            "Sensor input must be taint-tracked",
            &["sensor_input", "pilot_input", "radar_data", "telemetry_input"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "DO178C-6.7.4",
            ComplianceProfile::Do178c,
            "Excessive grants in safety system",
            Severity::Error,
        ),
        sensitive_ffi_rule(
            "DO178C-6.7.5",
            ComplianceProfile::Do178c,
            "FFI in safety-critical code needs review",
            &["flight", "navigation", "autopilot", "engine", "control"],
            Severity::Error,
        ),
    ]
}

// ===========================================================================
// SOX rules (15)
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
        // --- 7 new rules ---
        hardcoded_ip_rule(
            "SOX-302-3",
            ComplianceProfile::Sox,
            "No hardcoded IPs in financial reporting",
            Severity::Warning,
        ),
        debug_code_rule(
            "SOX-302-4",
            ComplianceProfile::Sox,
            "No debug code in financial systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "SOX-404-3",
            ComplianceProfile::Sox,
            "Financial security defaults must be enabled",
            &["audit_enabled", "reporting_secure", "internal_control", "sox_compliance", "review_required"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "SOX-404-4",
            ComplianceProfile::Sox,
            "No hardcoded ports in financial systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "SOX-409-2",
            ComplianceProfile::Sox,
            "Financial records need retention handling",
            &["report_date", "filing_date", "audit_date", "fiscal_period", "statement_date"],
            Severity::Warning,
        ),
        tainted_input_rule(
            "SOX-802-2",
            ComplianceProfile::Sox,
            "Financial input must be taint-tracked",
            &["financial_input", "accounting_input", "report_data", "audit_input"],
            Severity::Error,
        ),
        excessive_grant_rule(
            "SOX-906-2",
            ComplianceProfile::Sox,
            "Excessive grants in financial context",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// CMMC rules (12)
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
        // --- 6 new rules ---
        hardcoded_ip_rule(
            "CMMC-AC-3",
            ComplianceProfile::Cmmc,
            "No hardcoded IPs in defense systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "CMMC-AC-4",
            ComplianceProfile::Cmmc,
            "No debug code in defense systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "CMMC-SC-3",
            ComplianceProfile::Cmmc,
            "Security defaults in defense context",
            &["fips_enabled", "encryption_required", "cmmc_mode", "secure_boot", "access_control"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "CMMC-SC-4",
            ComplianceProfile::Cmmc,
            "No hardcoded ports in defense systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "CMMC-SI-2",
            ComplianceProfile::Cmmc,
            "CUI must have retention handling",
            &["classification_date", "cui_created", "access_granted", "clearance_date", "review_date"],
            Severity::Warning,
        ),
        excessive_grant_rule(
            "CMMC-AU-2",
            ComplianceProfile::Cmmc,
            "Excessive grants in defense systems",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// IEC 62443 rules (12)
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
        // --- 6 new rules ---
        hardcoded_ip_rule(
            "IEC62443-SR-7",
            ComplianceProfile::Iec62443,
            "No hardcoded IPs in ICS",
            Severity::Warning,
        ),
        debug_code_rule(
            "IEC62443-SR-8",
            ComplianceProfile::Iec62443,
            "No debug code in ICS",
            Severity::Warning,
        ),
        insecure_default_rule(
            "IEC62443-SR-9",
            ComplianceProfile::Iec62443,
            "ICS security defaults must be enabled",
            &["safety_enabled", "scada_secure", "plc_auth", "hmi_locked", "network_segmented"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "IEC62443-SR-10",
            ComplianceProfile::Iec62443,
            "No hardcoded ports in ICS",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "IEC62443-SR-11",
            ComplianceProfile::Iec62443,
            "ICS data must have retention handling",
            &["sensor_timestamp", "calibration_date", "maintenance_date", "alarm_time", "log_date"],
            Severity::Warning,
        ),
        excessive_grant_rule(
            "IEC62443-SR-12",
            ComplianceProfile::Iec62443,
            "Excessive grants in ICS",
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// NERC CIP rules (10)
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
        // --- 5 new rules ---
        hardcoded_ip_rule(
            "NERC-CIP-003",
            ComplianceProfile::NercCip,
            "No hardcoded IPs in energy grid",
            Severity::Warning,
        ),
        debug_code_rule(
            "NERC-CIP-006",
            ComplianceProfile::NercCip,
            "No debug code in energy systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "NERC-CIP-008",
            ComplianceProfile::NercCip,
            "Energy security defaults must be enabled",
            &["grid_protection", "scada_secure", "monitoring_enabled", "alarm_active", "failsafe_mode"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "NERC-CIP-009",
            ComplianceProfile::NercCip,
            "No hardcoded ports in grid systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "NERC-CIP-012",
            ComplianceProfile::NercCip,
            "Grid data must have retention handling",
            &["outage_date", "maintenance_date", "inspection_date", "meter_timestamp", "load_date"],
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// FDA 21 CFR Part 11 rules (10)
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
        // --- 5 new rules ---
        hardcoded_ip_rule(
            "FDA-11.10-f",
            ComplianceProfile::Fda21cfr,
            "No hardcoded IPs in pharma systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "FDA-11.10-g",
            ComplianceProfile::Fda21cfr,
            "No debug code in clinical systems",
            Severity::Warning,
        ),
        insecure_default_rule(
            "FDA-11.10-h",
            ComplianceProfile::Fda21cfr,
            "Clinical security defaults must be enabled",
            &["validation_enabled", "audit_trail", "electronic_sig", "access_control", "data_integrity"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "FDA-11.10-i",
            ComplianceProfile::Fda21cfr,
            "No hardcoded ports in pharma systems",
            Severity::Warning,
        ),
        temporal_no_expiry_rule(
            "FDA-11.10-j",
            ComplianceProfile::Fda21cfr,
            "Clinical trial data must have retention handling",
            &["trial_date", "batch_date", "expiry_date", "approval_date", "manufacturing_date"],
            Severity::Warning,
        ),
    ]
}

// ===========================================================================
// ITAR rules (8)
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
        // --- 4 new rules ---
        hardcoded_ip_rule(
            "ITAR-120.5",
            ComplianceProfile::Itar,
            "No hardcoded IPs in defense export systems",
            Severity::Warning,
        ),
        debug_code_rule(
            "ITAR-120.6",
            ComplianceProfile::Itar,
            "No debug code in ITAR systems",
            Severity::Error,
        ),
        insecure_default_rule(
            "ITAR-120.7",
            ComplianceProfile::Itar,
            "Defense security defaults must be enabled",
            &["export_control", "classification_enabled", "itar_mode", "dcs_required", "encryption_required"],
            Severity::Error,
        ),
        hardcoded_port_rule(
            "ITAR-120.8",
            ComplianceProfile::Itar,
            "No hardcoded ports in defense systems",
            Severity::Warning,
        ),
    ]
}
