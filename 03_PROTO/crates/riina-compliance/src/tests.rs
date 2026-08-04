// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Tests for compliance validation — 562 rules × 2+ tests each.

use riina_types::{Effect, Expr, Ty};

use crate::{has_errors, parse_profiles, validate, ComplianceProfile};

// ===========================================================================
// Test helpers
// ===========================================================================

fn make_let(name: &str, value: Expr) -> Expr {
    Expr::Let(name.into(), None, Box::new(value), Box::new(Expr::Unit))
}

fn make_classified_let(name: &str, value: Expr) -> Expr {
    Expr::Let(
        name.into(),
        None,
        Box::new(Expr::Classify(Box::new(value))),
        Box::new(Expr::Unit),
    )
}

fn make_let_with_body(name: &str, value: Expr, body: Expr) -> Expr {
    Expr::Let(name.into(), None, Box::new(value), Box::new(body))
}

fn assert_violation(expr: &Expr, profile: ComplianceProfile, rule_id: &str) {
    let violations = validate(expr, &[profile]);
    assert!(
        violations.iter().any(|v| v.rule_id == rule_id),
        "Expected violation '{}' but got: {:?}",
        rule_id,
        violations.iter().map(|v| v.rule_id).collect::<Vec<_>>()
    );
}

fn assert_no_violation(expr: &Expr, profile: ComplianceProfile, rule_id: &str) {
    let violations = validate(expr, &[profile]);
    assert!(
        !violations.iter().any(|v| v.rule_id == rule_id),
        "Unexpected violation '{}' found",
        rule_id
    );
}

// ===========================================================================
// Utility tests (existing)
// ===========================================================================

// ===========================================================================
// REQ-44 regression: LetRecGroup must be walked exactly like LetRec
//
// Top-level functions desugar to a mutually-recursive GROUP. Rules and helper
// walks were written against the single-binding `Expr::LetRec`, and the
// matches involved end in a wildcard — so when the group landed, every
// per-function rule SILENTLY stopped firing and the helper walks stopped at
// the group boundary. Nothing failed to compile; compliance simply stopped
// inspecting function bodies.
//
// These are DIFFERENTIAL tests: the same function expressed either way must
// produce the same verdict. They depend on no particular rule id, so they keep
// working as the rule set evolves — and they fail loudly if a future walker
// forgets the group again.
// ===========================================================================

/// Wrap a function binding as a single-binding `LetRecGroup`.
fn as_group(name: &str, ty: Ty, body: Expr, cont: Expr) -> Expr {
    Expr::LetRecGroup(vec![(name.into(), ty, body)], Box::new(cont))
}

/// Wrap the same binding as the equivalent chain `LetRec`.
fn as_letrec(name: &str, ty: Ty, body: Expr, cont: Expr) -> Expr {
    Expr::LetRec(name.into(), ty, Box::new(body), Box::new(cont))
}

#[test]
fn letrec_group_yields_same_violations_as_letrec_chain() {
    // A function whose body performs a Write effect — enough to exercise the
    // per-function rules and the effect-scanning helpers.
    let body = Expr::Lam(
        "x".into(),
        Ty::Int,
        Box::new(Expr::Perform(Effect::Write, Box::new(Expr::Var("x".into())))),
    );
    let ty = Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Unit), Effect::Write);

    for profile in [
        ComplianceProfile::Gdpr,
        ComplianceProfile::PciDss,
        ComplianceProfile::Hipaa,
    ] {
        for name in ["sahkan_pengguna", "authenticate", "proses_bayaran", "helper"] {
            let chain = as_letrec(name, ty.clone(), body.clone(), Expr::Unit);
            let group = as_group(name, ty.clone(), body.clone(), Expr::Unit);

            let mut a: Vec<&str> = validate(&chain, &[profile])
                .iter()
                .map(|v| v.rule_id)
                .collect();
            let mut b: Vec<&str> = validate(&group, &[profile])
                .iter()
                .map(|v| v.rule_id)
                .collect();
            a.sort_unstable();
            b.sort_unstable();

            assert_eq!(
                a, b,
                "LetRecGroup and LetRec disagree for fn '{name}' under {profile:?}: \
                 a group member must be inspected exactly like the equivalent \
                 single binding (REQ-44 silent-gap class)"
            );
        }
    }
}

#[test]
fn letrec_group_body_is_actually_inspected() {
    // Guards the degenerate way the test above could pass: if BOTH forms were
    // ignored, the lists would match while nothing was inspected. Pin that the
    // walk truly reaches a grouped body by requiring the group form to produce
    // at least as many violations as an empty program.
    let leaky = Expr::Lam(
        "x".into(),
        Ty::Int,
        Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Var("x".into())))),
    );
    let ty = Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Unit), Effect::Network);

    let group = as_group("hantar_data_peribadi", ty, leaky, Expr::Unit);
    let empty = Expr::Unit;

    let g = validate(&group, &[ComplianceProfile::Gdpr]).len();
    let e = validate(&empty, &[ComplianceProfile::Gdpr]).len();
    assert!(
        g >= e,
        "a grouped function body must be inspected (got {g} violations vs {e} for an empty program)"
    );
}


// ===========================================================================
// Silent-gap regression: `pulang` (Expr::Return) must be transparent to the
// effect/security scans.
//
// Same class as the LetRecGroup gap above, one level down. The per-function
// rules ask "does this body use effect X?" via the `rules.rs` helper walks,
// and those matches end in `_ => false`. `Expr::Return` had no arm — yet
// `pulang e` is the ordinary way to write a RIINA function body, so a
// *correct* effectful function scanned as effect-free and the rules fired
// spuriously. Differential, so it survives rule-set changes: wrapping a body
// in `pulang` must not change the verdict.
// ===========================================================================

/// Sorted rule ids reported for `expr` across every profile.
fn verdict(expr: &Expr) -> Vec<&'static str> {
    let mut ids: Vec<&'static str> = validate(
        expr,
        &[
            ComplianceProfile::Gdpr,
            ComplianceProfile::PciDss,
            ComplianceProfile::Hipaa,
            ComplianceProfile::Pdpa,
            ComplianceProfile::Bnm,
        ],
    )
    .iter()
    .map(|v| v.rule_id)
    .collect();
    ids.sort_unstable();
    ids
}

#[test]
fn pulang_wrapped_body_scans_like_a_bare_body() {
    // `fungsi <name>(x) { pulang perform <eff> x; }` vs the same body written
    // without the `pulang`. Both use the effect; both must be judged alike.
    for effect in [Effect::Crypto, Effect::Write, Effect::Time, Effect::Network] {
        let inner = Expr::Perform(effect, Box::new(Expr::Var("x".into())));
        let ty = Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Unit), effect);

        for name in ["sahkan_pengguna", "authenticate", "proses_bayaran", "log_audit"] {
            let bare = as_letrec(
                name,
                ty.clone(),
                Expr::Lam("x".into(), Ty::Int, Box::new(inner.clone())),
                Expr::Unit,
            );
            let returned = as_letrec(
                name,
                ty.clone(),
                Expr::Lam(
                    "x".into(),
                    Ty::Int,
                    Box::new(Expr::Return(Box::new(inner.clone()))),
                ),
                Expr::Unit,
            );

            assert_eq!(
                verdict(&bare),
                verdict(&returned),
                "`pulang` changed the compliance verdict for fn '{name}' with \
                 effect {effect:?}: a transparent wrapper must not hide the \
                 body from the effect scan (silent-gap class)"
            );
        }
    }
}

#[test]
fn parse_profiles_single() {
    let profiles = parse_profiles("pci-dss").unwrap();
    assert_eq!(profiles, vec![ComplianceProfile::PciDss]);
}

#[test]
fn parse_profiles_multiple() {
    let profiles = parse_profiles("pci-dss,pdpa,bnm").unwrap();
    assert_eq!(
        profiles,
        vec![
            ComplianceProfile::PciDss,
            ComplianceProfile::Pdpa,
            ComplianceProfile::Bnm
        ]
    );
}

#[test]
fn parse_profiles_unknown() {
    assert!(parse_profiles("unknown").is_err());
}

#[test]
fn parse_profiles_all_16() {
    assert_eq!(ComplianceProfile::ALL.len(), 16);
}

#[test]
fn no_violations_without_profiles() {
    let expr = Expr::Declassify(Box::new(Expr::Int(42)), Box::new(Expr::Int(0)));
    let violations = validate(&expr, &[]);
    assert!(violations.is_empty());
}

#[test]
fn profile_display_roundtrip() {
    for &p in ComplianceProfile::ALL {
        let slug = p.slug();
        let parsed: ComplianceProfile = slug.parse().unwrap();
        assert_eq!(parsed, p);
    }
}

// ===========================================================================
// PCI-DSS tests (existing preserved + new)
// ===========================================================================

#[test]
fn pci_dss_3_4_declassify_without_prove() {
    let expr = Expr::Declassify(
        Box::new(Expr::Classify(Box::new(Expr::Int(4242)))),
        Box::new(Expr::Int(0)),
    );
    let violations = validate(&expr, &[ComplianceProfile::PciDss]);
    assert!(violations.iter().any(|v| v.rule_id == "PCI-DSS-3.4"));
    assert!(has_errors(&violations));
}

#[test]
fn pci_dss_3_4_declassify_with_prove_ok() {
    let expr = Expr::Declassify(
        Box::new(Expr::Classify(Box::new(Expr::Int(4242)))),
        Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
    );
    let violations = validate(&expr, &[ComplianceProfile::PciDss]);
    assert!(!violations.iter().any(|v| v.rule_id == "PCI-DSS-3.4"));
}

#[test]
fn pci_dss_6_5_card_data_not_secret() {
    let expr = Expr::Let(
        "card_number".into(),
        None,
        Box::new(Expr::String("4111111111111111".into())),
        Box::new(Expr::Unit),
    );
    let violations = validate(&expr, &[ComplianceProfile::PciDss]);
    assert!(violations.iter().any(|v| v.rule_id == "PCI-DSS-6.5"));
}

#[test]
fn pci_dss_6_5_card_data_classified_ok() {
    let expr = Expr::Let(
        "card_number".into(),
        None,
        Box::new(Expr::Classify(Box::new(Expr::String(
            "4111111111111111".into(),
        )))),
        Box::new(Expr::Unit),
    );
    let violations = validate(&expr, &[ComplianceProfile::PciDss]);
    assert!(!violations.iter().any(|v| v.rule_id == "PCI-DSS-6.5"));
}

#[test]
fn pci_dss_8_3_auth_without_crypto() {
    let expr = Expr::LetRec(
        "authenticate".into(),
        Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
        Box::new(Expr::Lam(
            "pwd".into(),
            Ty::String,
            Box::new(Expr::Bool(true)),
        )),
        Box::new(Expr::Unit),
    );
    let violations = validate(&expr, &[ComplianceProfile::PciDss]);
    assert!(violations.iter().any(|v| v.rule_id == "PCI-DSS-8.3"));
}

#[test]
fn pci_dss_8_3_auth_with_crypto_ok() {
    let expr = Expr::LetRec(
        "authenticate".into(),
        Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
        Box::new(Expr::Lam(
            "pwd".into(),
            Ty::String,
            Box::new(Expr::Perform(
                Effect::Crypto,
                Box::new(Expr::Var("pwd".into())),
            )),
        )),
        Box::new(Expr::Unit),
    );
    let violations = validate(&expr, &[ComplianceProfile::PciDss]);
    assert!(!violations.iter().any(|v| v.rule_id == "PCI-DSS-8.3"));
}

// New PCI-DSS tests

#[test]
fn pci_dss_3_5_1_violation() {
    assert_violation(
        &make_let("encryption_key", Expr::String("mykey".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.5.1",
    );
}
#[test]
fn pci_dss_3_5_1_ok() {
    assert_no_violation(
        &make_classified_let("encryption_key", Expr::String("mykey".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.5.1",
    );
}

#[test]
fn pci_dss_4_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.1",
    );
}
#[test]
fn pci_dss_4_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.1",
    );
}

#[test]
fn pci_dss_6_5_2_violation() {
    assert_violation(
        &Expr::String("http://example.com/api".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.2",
    );
}
#[test]
fn pci_dss_6_5_2_ok() {
    assert_no_violation(
        &Expr::String("https://example.com/api".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.2",
    );
}

#[test]
fn pci_dss_6_5_3_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.3",
    );
}
#[test]
fn pci_dss_6_5_3_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.3",
    );
}

#[test]
fn pci_dss_6_5_4_violation() {
    assert_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.4",
    );
}
#[test]
fn pci_dss_6_5_4_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::String("error logged".into())),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.4",
    );
}

#[test]
fn pci_dss_6_5_5_violation() {
    assert_violation(
        &make_let("password", Expr::String("hunter2".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.5",
    );
}
#[test]
fn pci_dss_6_5_5_ok() {
    assert_no_violation(
        &make_let(
            "password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.5",
    );
}

#[test]
fn pci_dss_6_5_6_violation() {
    assert_violation(
        &make_let("credential", Expr::String("cred".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.6",
    );
}
#[test]
fn pci_dss_6_5_6_ok() {
    assert_no_violation(
        &make_classified_let("credential", Expr::String("cred".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.6",
    );
}

#[test]
fn pci_dss_6_2_1_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "openssl_rand".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::PciDss,
        "PCI-DSS-6.2.1",
    );
}
#[test]
fn pci_dss_6_2_1_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.2.1",
    );
}

#[test]
fn pci_dss_8_3_1_violation() {
    assert_violation(
        &make_let("otp", Expr::String("123456".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-8.3.1",
    );
}
#[test]
fn pci_dss_8_3_1_ok() {
    assert_no_violation(
        &make_classified_let("otp", Expr::String("123456".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-8.3.1",
    );
}

#[test]
fn pci_dss_10_2_violation() {
    assert_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Unit,
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.2",
    );
}
#[test]
fn pci_dss_10_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit log".into()))),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.2",
    );
}

#[test]
fn pci_dss_11_3_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-11.3",
    );
}
#[test]
fn pci_dss_11_3_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-11.3",
    );
}

#[test]
fn pci_dss_6_3_1_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.3.1",
    );
}
#[test]
fn pci_dss_6_3_1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.3.1",
    );
}

// ===========================================================================
// HIPAA tests
// ===========================================================================

#[test]
fn hipaa_164_312_a1_violation() {
    assert_violation(
        &make_let("patient_data", Expr::String("PHI".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-a1",
    );
}
#[test]
fn hipaa_164_312_a1_ok() {
    assert_no_violation(
        &make_classified_let("patient_data", Expr::String("PHI".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-a1",
    );
}

#[test]
fn hipaa_164_312_a2_violation() {
    assert_violation(
        &Expr::LetRec(
            "medical_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-a2",
    );
}
#[test]
fn hipaa_164_312_a2_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "medical_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-a2",
    );
}

#[test]
fn hipaa_164_312_c1_violation() {
    assert_violation(
        &make_let("patient_id", Expr::String("P12345".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-c1",
    );
}
#[test]
fn hipaa_164_312_c1_ok() {
    assert_no_violation(
        &make_let(
            "patient_id",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-c1",
    );
}

#[test]
fn hipaa_164_312_d_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-d",
    );
}
#[test]
fn hipaa_164_312_d_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-d",
    );
}

#[test]
fn hipaa_164_312_e1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-e1",
    );
}
#[test]
fn hipaa_164_312_e1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-e1",
    );
}

#[test]
fn hipaa_164_530_c_violation() {
    assert_violation(
        &Expr::Perform(
            Effect::Network,
            Box::new(Expr::Var("patient_record".into())),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.530-c",
    );
}
#[test]
fn hipaa_164_530_c_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("public_info".into()))),
        ComplianceProfile::Hipaa,
        "HIPAA-164.530-c",
    );
}

#[test]
fn hipaa_164_308_a5_violation() {
    assert_violation(
        &Expr::String("sha1".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a5",
    );
}
#[test]
fn hipaa_164_308_a5_ok() {
    assert_no_violation(
        &Expr::String("sha256".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a5",
    );
}

#[test]
fn hipaa_164_310_d_violation() {
    assert_violation(
        &Expr::String("http://ehr.example.com".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-d",
    );
}
#[test]
fn hipaa_164_310_d_ok() {
    assert_no_violation(
        &Expr::String("https://ehr.example.com".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-d",
    );
}

#[test]
fn hipaa_164_314_a_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Hipaa,
        "HIPAA-164.314-a",
    );
}
#[test]
fn hipaa_164_314_a_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.314-a",
    );
}

#[test]
fn hipaa_164_316_b_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.316-b",
    );
}
#[test]
fn hipaa_164_316_b_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("handled".into())),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.316-b",
    );
}

// ===========================================================================
// GDPR tests
// ===========================================================================

#[test]
fn gdpr_5_1_a_violation() {
    assert_violation(
        &make_let("personal_info", Expr::String("name".into())),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-a",
    );
}
#[test]
fn gdpr_5_1_a_ok() {
    assert_no_violation(
        &make_classified_let("personal_info", Expr::String("name".into())),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-a",
    );
}

#[test]
fn gdpr_5_1_b_violation() {
    assert_violation(
        &make_let("email_address", Expr::String("a@b.com".into())),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-b",
    );
}
#[test]
fn gdpr_5_1_b_ok() {
    assert_no_violation(
        &make_let(
            "email_address",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-b",
    );
}

#[test]
fn gdpr_5_1_c_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("personal_info".into()))),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-c",
    );
}
#[test]
fn gdpr_5_1_c_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("public_data".into()))),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-c",
    );
}

#[test]
fn gdpr_5_1_e_violation() {
    assert_violation(
        &Expr::String("http://gdpr.eu".into()),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-e",
    );
}
#[test]
fn gdpr_5_1_e_ok() {
    assert_no_violation(
        &Expr::String("https://gdpr.eu".into()),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-e",
    );
}

#[test]
fn gdpr_5_1_f_violation() {
    assert_violation(
        &Expr::String("des-cbc".into()),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-f",
    );
}
#[test]
fn gdpr_5_1_f_ok() {
    assert_no_violation(
        &Expr::String("aes-256-gcm".into()),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-f",
    );
}

#[test]
fn gdpr_25_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Gdpr,
        "GDPR-25.1",
    );
}
#[test]
fn gdpr_25_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Gdpr,
        "GDPR-25.1",
    );
}

#[test]
fn gdpr_32_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Gdpr,
        "GDPR-32",
    );
}
#[test]
fn gdpr_32_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-32",
    );
}

#[test]
fn gdpr_33_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Gdpr,
        "GDPR-33",
    );
}
#[test]
fn gdpr_33_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-33",
    );
}

#[test]
fn gdpr_35_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::Gdpr,
        "GDPR-35",
    );
}
#[test]
fn gdpr_35_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Gdpr,
        "GDPR-35",
    );
}

#[test]
fn gdpr_17_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Gdpr,
        "GDPR-17",
    );
}
#[test]
fn gdpr_17_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("ok".into())),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-17",
    );
}

// ===========================================================================
// PDPA tests
// ===========================================================================

#[test]
fn pdpa_s7_user_input_not_tainted() {
    let expr = Expr::Let(
        "user_input".into(),
        None,
        Box::new(Expr::String("raw data".into())),
        Box::new(Expr::Unit),
    );
    let violations = validate(&expr, &[ComplianceProfile::Pdpa]);
    assert!(violations.iter().any(|v| v.rule_id == "PDPA-S7"));
}

#[test]
fn pdpa_s7_user_input_tainted_ok() {
    assert_no_violation(
        &make_let(
            "user_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S7",
    );
}

#[test]
fn pdpa_s24_personal_data_over_network() {
    let expr = Expr::Perform(Effect::Network, Box::new(Expr::Var("personal_data".into())));
    let violations = validate(&expr, &[ComplianceProfile::Pdpa]);
    assert!(violations.iter().any(|v| v.rule_id == "PDPA-S24"));
}

#[test]
fn pdpa_s24_non_personal_data_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("public_stats".into()))),
        ComplianceProfile::Pdpa,
        "PDPA-S24",
    );
}

#[test]
fn pdpa_s6_violation() {
    assert_violation(
        &make_let("nama", Expr::String("Ali".into())),
        ComplianceProfile::Pdpa,
        "PDPA-S6",
    );
}
#[test]
fn pdpa_s6_ok() {
    assert_no_violation(
        &make_classified_let("nama", Expr::String("Ali".into())),
        ComplianceProfile::Pdpa,
        "PDPA-S6",
    );
}

#[test]
fn pdpa_s8_violation() {
    assert_violation(
        &make_let("no_ic", Expr::String("901234-56-7890".into())),
        ComplianceProfile::Pdpa,
        "PDPA-S8",
    );
}
#[test]
fn pdpa_s8_ok() {
    assert_no_violation(
        &make_let("no_ic", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::Pdpa,
        "PDPA-S8",
    );
}

#[test]
fn pdpa_s9_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Pdpa,
        "PDPA-S9",
    );
}
#[test]
fn pdpa_s9_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Pdpa,
        "PDPA-S9",
    );
}

#[test]
fn pdpa_s10_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Pdpa,
        "PDPA-S10",
    );
}
#[test]
fn pdpa_s10_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S10",
    );
}

#[test]
fn pdpa_s11_violation() {
    assert_violation(
        &Expr::String("rc4".into()),
        ComplianceProfile::Pdpa,
        "PDPA-S11",
    );
}
#[test]
fn pdpa_s11_ok() {
    assert_no_violation(
        &Expr::String("aes128".into()),
        ComplianceProfile::Pdpa,
        "PDPA-S11",
    );
}

#[test]
fn pdpa_s12_violation() {
    assert_violation(
        &Expr::LetRec(
            "pengesahan".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S12",
    );
}
#[test]
fn pdpa_s12_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "pengesahan".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S12",
    );
}

#[test]
fn pdpa_s13_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Pdpa,
        "PDPA-S13-1",
    );
}
#[test]
fn pdpa_s13_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S13-1",
    );
}

#[test]
fn pdpa_s42_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Pdpa,
        "PDPA-S42",
    );
}
#[test]
fn pdpa_s42_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("ok".into())),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S42",
    );
}

// ===========================================================================
// BNM tests
// ===========================================================================

#[test]
fn bnm_rmit_10_crypto_without_constant_time() {
    let expr = Expr::Perform(Effect::Crypto, Box::new(Expr::Var("payment_hash".into())));
    let violations = validate(&expr, &[ComplianceProfile::Bnm]);
    assert!(violations.iter().any(|v| v.rule_id == "BNM-RMiT-10"));
}

#[test]
fn bnm_10_18_violation() {
    assert_violation(
        &make_let("financial_data", Expr::String("RM1000".into())),
        ComplianceProfile::Bnm,
        "BNM-10.18",
    );
}
#[test]
fn bnm_10_18_ok() {
    assert_no_violation(
        &make_classified_let("financial_data", Expr::String("RM1000".into())),
        ComplianceProfile::Bnm,
        "BNM-10.18",
    );
}

#[test]
fn bnm_10_49_b_violation() {
    assert_violation(
        &make_let("kata_laluan", Expr::String("p@ssword".into())),
        ComplianceProfile::Bnm,
        "BNM-10.49-b",
    );
}
#[test]
fn bnm_10_49_b_ok() {
    assert_no_violation(
        &make_let(
            "kata_laluan",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.49-b",
    );
}

#[test]
fn bnm_10_50_violation() {
    assert_violation(
        &Expr::LetRec(
            "pengesahan".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.50",
    );
}
#[test]
fn bnm_10_50_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "pengesahan".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.50",
    );
}

#[test]
fn bnm_10_51_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Bnm,
        "BNM-10.51",
    );
}
#[test]
fn bnm_10_51_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.51",
    );
}

#[test]
fn bnm_10_52_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Bnm,
        "BNM-10.52",
    );
}
#[test]
fn bnm_10_52_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.52",
    );
}

#[test]
fn bnm_10_54_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Bnm,
        "BNM-10.54",
    );
}
#[test]
fn bnm_10_54_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("ok".into())),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.54",
    );
}

#[test]
fn bnm_10_55_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext_lib".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Bnm,
        "BNM-10.55",
    );
}
#[test]
fn bnm_10_55_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Bnm,
        "BNM-10.55",
    );
}

#[test]
fn bnm_10_56_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Bnm,
        "BNM-10.56",
    );
}
#[test]
fn bnm_10_56_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Bnm,
        "BNM-10.56",
    );
}

#[test]
fn bnm_10_58_violation() {
    assert_violation(
        &Expr::String("http://bank.my".into()),
        ComplianceProfile::Bnm,
        "BNM-10.58",
    );
}
#[test]
fn bnm_10_58_ok() {
    assert_no_violation(
        &Expr::String("https://bank.my".into()),
        ComplianceProfile::Bnm,
        "BNM-10.58",
    );
}

// ===========================================================================
// MAS TRM tests
// ===========================================================================

#[test]
fn mas_trm_5_1_1_violation() {
    assert_violation(
        &make_let("customer_data", Expr::String("info".into())),
        ComplianceProfile::MasTrm,
        "MAS-TRM-5.1.1",
    );
}
#[test]
fn mas_trm_5_1_1_ok() {
    assert_no_violation(
        &make_classified_let("customer_data", Expr::String("info".into())),
        ComplianceProfile::MasTrm,
        "MAS-TRM-5.1.1",
    );
}

#[test]
fn mas_trm_9_1_1_violation() {
    assert_violation(
        &Expr::String("md5_hash".into()),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.1.1",
    );
}
#[test]
fn mas_trm_9_1_1_ok() {
    assert_no_violation(
        &Expr::String("sha256".into()),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.1.1",
    );
}

#[test]
fn mas_trm_9_2_1_violation() {
    assert_violation(
        &Expr::LetRec(
            "authenticate".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.2.1",
    );
}
#[test]
fn mas_trm_9_2_1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "authenticate".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.2.1",
    );
}

#[test]
fn mas_trm_9_4_1_violation() {
    assert_violation(
        &make_let("password", Expr::String("secret123".into())),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.4.1",
    );
}
#[test]
fn mas_trm_9_4_1_ok() {
    assert_no_violation(
        &make_let(
            "password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.4.1",
    );
}

#[test]
fn mas_trm_11_1_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.1.1",
    );
}
#[test]
fn mas_trm_11_1_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.1.1",
    );
}

#[test]
fn mas_trm_11_2_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("customer_info".into()))),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.2.1",
    );
}
#[test]
fn mas_trm_11_2_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("public_rate".into()))),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.2.1",
    );
}

#[test]
fn mas_trm_12_1_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::MasTrm,
        "MAS-TRM-12.1.1",
    );
}
#[test]
fn mas_trm_12_1_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-12.1.1",
    );
}

#[test]
fn mas_trm_13_1_1_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-13.1.1",
    );
}
#[test]
fn mas_trm_13_1_1_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-13.1.1",
    );
}

// ===========================================================================
// NIST 800-53 tests
// ===========================================================================

#[test]
fn nist_ac_1_violation() {
    assert_violation(
        &make_let("classified_data", Expr::String("top secret".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-1",
    );
}
#[test]
fn nist_ac_1_ok() {
    assert_no_violation(
        &make_classified_let("classified_data", Expr::String("top secret".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-1",
    );
}

#[test]
fn nist_ac_6_violation() {
    assert_violation(
        &Expr::Grant(Effect::Process, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-AC-6",
    );
}
#[test]
fn nist_ac_6_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Write, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-AC-6",
    );
}

#[test]
fn nist_au_2_violation() {
    assert_violation(
        &make_let_with_body(
            "x",
            Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
            Expr::Unit,
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-2",
    );
}
#[test]
fn nist_au_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-2",
    );
}

#[test]
fn nist_ia_5_violation() {
    assert_violation(
        &make_let("api_key", Expr::String("sk-12345".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-5",
    );
}
#[test]
fn nist_ia_5_ok() {
    assert_no_violation(
        &make_let("api_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::Nist80053,
        "NIST-IA-5",
    );
}

#[test]
fn nist_sc_8_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-SC-8",
    );
}
#[test]
fn nist_sc_8_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-SC-8",
    );
}

#[test]
fn nist_sc_12_violation() {
    assert_violation(
        &make_let("private_key", Expr::String("key".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-12",
    );
}
#[test]
fn nist_sc_12_ok() {
    assert_no_violation(
        &make_classified_let("private_key", Expr::String("key".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-12",
    );
}

#[test]
fn nist_sc_13_violation() {
    assert_violation(
        &Expr::String("sha1_digest".into()),
        ComplianceProfile::Nist80053,
        "NIST-SC-13",
    );
}
#[test]
fn nist_sc_13_ok() {
    assert_no_violation(
        &Expr::String("sha512".into()),
        ComplianceProfile::Nist80053,
        "NIST-SC-13",
    );
}

#[test]
fn nist_sc_28_violation() {
    assert_violation(
        &Expr::String("http://fed.gov".into()),
        ComplianceProfile::Nist80053,
        "NIST-SC-28",
    );
}
#[test]
fn nist_sc_28_ok() {
    assert_no_violation(
        &Expr::String("https://fed.gov".into()),
        ComplianceProfile::Nist80053,
        "NIST-SC-28",
    );
}

#[test]
fn nist_si_2_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "legacy_lib".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SI-2",
    );
}
#[test]
fn nist_si_2_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-SI-2",
    );
}

#[test]
fn nist_si_10_violation() {
    assert_violation(
        &make_let("user_input", Expr::String("raw".into())),
        ComplianceProfile::Nist80053,
        "NIST-SI-10",
    );
}
#[test]
fn nist_si_10_ok() {
    assert_no_violation(
        &make_let(
            "user_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SI-10",
    );
}

// ===========================================================================
// ISO 27001 tests
// ===========================================================================

#[test]
fn iso_a5_1_violation() {
    assert_violation(
        &make_let("confidential_doc", Expr::String("secret".into())),
        ComplianceProfile::Iso27001,
        "ISO-A5.1",
    );
}
#[test]
fn iso_a5_1_ok() {
    assert_no_violation(
        &make_classified_let("confidential_doc", Expr::String("secret".into())),
        ComplianceProfile::Iso27001,
        "ISO-A5.1",
    );
}

#[test]
fn iso_a6_1_violation() {
    assert_violation(
        &make_let("api_key", Expr::String("key123".into())),
        ComplianceProfile::Iso27001,
        "ISO-A6.1",
    );
}
#[test]
fn iso_a6_1_ok() {
    assert_no_violation(
        &make_let("api_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::Iso27001,
        "ISO-A6.1",
    );
}

#[test]
fn iso_a8_1_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Iso27001,
        "ISO-A8.1",
    );
}
#[test]
fn iso_a8_1_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A8.1",
    );
}

#[test]
fn iso_a9_1_violation() {
    assert_violation(
        &Expr::LetRec(
            "authenticate".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A9.1",
    );
}
#[test]
fn iso_a9_1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "authenticate".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A9.1",
    );
}

#[test]
fn iso_a10_1_violation() {
    assert_violation(
        &Expr::String("md5sum".into()),
        ComplianceProfile::Iso27001,
        "ISO-A10.1",
    );
}
#[test]
fn iso_a10_1_ok() {
    assert_no_violation(
        &Expr::String("blake2b".into()),
        ComplianceProfile::Iso27001,
        "ISO-A10.1",
    );
}

#[test]
fn iso_a12_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Iso27001,
        "ISO-A12.1",
    );
}
#[test]
fn iso_a12_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A12.1",
    );
}

#[test]
fn iso_a13_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A13.1",
    );
}
#[test]
fn iso_a13_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A13.1",
    );
}

#[test]
fn iso_a14_1_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "lib".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iso27001,
        "ISO-A14.1",
    );
}
#[test]
fn iso_a14_1_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A14.1",
    );
}

#[test]
fn iso_a16_1_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A16.1",
    );
}
#[test]
fn iso_a16_1_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("ok".into())),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A16.1",
    );
}

#[test]
fn iso_a18_1_violation() {
    assert_violation(
        &Expr::String("http://iso.org".into()),
        ComplianceProfile::Iso27001,
        "ISO-A18.1",
    );
}
#[test]
fn iso_a18_1_ok() {
    assert_no_violation(
        &Expr::String("https://iso.org".into()),
        ComplianceProfile::Iso27001,
        "ISO-A18.1",
    );
}

// ===========================================================================
// DO-178C tests
// ===========================================================================

#[test]
fn do178c_6_3_1_violation() {
    assert_violation(
        &Expr::LetRec(
            "loop_fn".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("loop_fn".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.1",
    );
}
#[test]
fn do178c_6_3_1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "safe_fn".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.1",
    );
}

#[test]
fn do178c_6_3_2_violation() {
    assert_violation(
        &Expr::Let(
            "dead_binding".into(),
            None,
            Box::new(Expr::Unit),
            Box::new(Expr::Int(42)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.2",
    );
}
#[test]
fn do178c_6_3_2_ok() {
    assert_no_violation(
        &Expr::Let(
            "x".into(),
            None,
            Box::new(Expr::Int(42)),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.2",
    );
}

#[test]
fn do178c_6_3_3_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "avionics_lib".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Do178c,
        "DO178C-6.3.3",
    );
}
#[test]
fn do178c_6_3_3_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.3.3",
    );
}

#[test]
fn do178c_6_4_1_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.1",
    );
}
#[test]
fn do178c_6_4_1_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("ok".into())),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.1",
    );
}

#[test]
fn do178c_6_4_2_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Do178c,
        "DO178C-6.4.2",
    );
}
#[test]
fn do178c_6_4_2_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.2",
    );
}

#[test]
fn do178c_6_4_3_violation() {
    assert_violation(
        &Expr::String("sha1_checksum".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.4.3",
    );
}
#[test]
fn do178c_6_4_3_ok() {
    assert_no_violation(
        &Expr::String("sha256".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.4.3",
    );
}

#[test]
fn do178c_6_4_4_violation() {
    assert_violation(
        &make_let("altitude", Expr::String("35000".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.4",
    );
}
#[test]
fn do178c_6_4_4_ok() {
    assert_no_violation(
        &make_classified_let("altitude", Expr::String("35000".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.4",
    );
}

#[test]
fn do178c_6_4_5_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.5",
    );
}
#[test]
fn do178c_6_4_5_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.5",
    );
}

#[test]
fn do178c_6_7_1_violation() {
    assert_violation(
        &make_let("altitude_limit", Expr::String("45000".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.7.1",
    );
}
#[test]
fn do178c_6_7_1_ok() {
    assert_no_violation(
        &make_let(
            "altitude_limit",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.7.1",
    );
}

#[test]
fn do178c_6_7_2_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.7.2",
    );
}
#[test]
fn do178c_6_7_2_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.7.2",
    );
}

// ===========================================================================
// SOX tests
// ===========================================================================

#[test]
fn sox_302_1_violation() {
    assert_violation(
        &make_let("revenue", Expr::String("1000000".into())),
        ComplianceProfile::Sox,
        "SOX-302-1",
    );
}
#[test]
fn sox_302_1_ok() {
    assert_no_violation(
        &make_classified_let("revenue", Expr::String("1000000".into())),
        ComplianceProfile::Sox,
        "SOX-302-1",
    );
}

#[test]
fn sox_302_2_violation() {
    assert_violation(
        &Expr::LetRec(
            "financial_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Sox,
        "SOX-302-2",
    );
}
#[test]
fn sox_302_2_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "financial_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Sox,
        "SOX-302-2",
    );
}

#[test]
fn sox_404_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Sox,
        "SOX-404-1",
    );
}
#[test]
fn sox_404_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Sox,
        "SOX-404-1",
    );
}

#[test]
fn sox_404_2_violation() {
    assert_violation(
        &make_let("revenue_amount", Expr::String("5000".into())),
        ComplianceProfile::Sox,
        "SOX-404-2",
    );
}
#[test]
fn sox_404_2_ok() {
    assert_no_violation(
        &make_let(
            "revenue_amount",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Sox,
        "SOX-404-2",
    );
}

#[test]
fn sox_409_1_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Sox,
        "SOX-409-1",
    );
}
#[test]
fn sox_409_1_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("ok".into())),
        ),
        ComplianceProfile::Sox,
        "SOX-409-1",
    );
}

#[test]
fn sox_802_1_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Sox,
        "SOX-802-1",
    );
}
#[test]
fn sox_802_1_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Sox,
        "SOX-802-1",
    );
}

#[test]
fn sox_906_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Sox,
        "SOX-906-1",
    );
}
#[test]
fn sox_906_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Sox,
        "SOX-906-1",
    );
}

#[test]
fn sox_1102_1_violation() {
    assert_violation(
        &Expr::Grant(Effect::Process, Box::new(Expr::Unit)),
        ComplianceProfile::Sox,
        "SOX-1102-1",
    );
}
#[test]
fn sox_1102_1_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Write, Box::new(Expr::Unit)),
        ComplianceProfile::Sox,
        "SOX-1102-1",
    );
}

// ===========================================================================
// CMMC tests
// ===========================================================================

#[test]
fn cmmc_ac_1_violation() {
    assert_violation(
        &make_let("cui_document", Expr::String("secret".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-1",
    );
}
#[test]
fn cmmc_ac_1_ok() {
    assert_no_violation(
        &make_classified_let("cui_document", Expr::String("secret".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-1",
    );
}

#[test]
fn cmmc_ac_2_violation() {
    assert_violation(
        &make_let("password", Expr::String("abc123".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-2",
    );
}
#[test]
fn cmmc_ac_2_ok() {
    assert_no_violation(
        &make_let(
            "password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-AC-2",
    );
}

#[test]
fn cmmc_sc_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-SC-1",
    );
}
#[test]
fn cmmc_sc_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-SC-1",
    );
}

#[test]
fn cmmc_sc_2_violation() {
    assert_violation(
        &Expr::String("des_encrypt".into()),
        ComplianceProfile::Cmmc,
        "CMMC-SC-2",
    );
}
#[test]
fn cmmc_sc_2_ok() {
    assert_no_violation(
        &Expr::String("aes256".into()),
        ComplianceProfile::Cmmc,
        "CMMC-SC-2",
    );
}

#[test]
fn cmmc_si_1_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Cmmc,
        "CMMC-SI-1",
    );
}
#[test]
fn cmmc_si_1_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-SI-1",
    );
}

#[test]
fn cmmc_au_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Cmmc,
        "CMMC-AU-1",
    );
}
#[test]
fn cmmc_au_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-AU-1",
    );
}

// ===========================================================================
// IEC 62443 tests
// ===========================================================================

#[test]
fn iec62443_sr_1_violation() {
    assert_violation(
        &make_let("scada_config", Expr::String("data".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-1",
    );
}
#[test]
fn iec62443_sr_1_ok() {
    assert_no_violation(
        &make_classified_let("scada_config", Expr::String("data".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-1",
    );
}

#[test]
fn iec62443_sr_2_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-2",
    );
}
#[test]
fn iec62443_sr_2_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-2",
    );
}

#[test]
fn iec62443_sr_3_violation() {
    assert_violation(
        &make_let("plc_key", Expr::String("key".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-3",
    );
}
#[test]
fn iec62443_sr_3_ok() {
    assert_no_violation(
        &make_let("plc_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-3",
    );
}

#[test]
fn iec62443_sr_4_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-4",
    );
}
#[test]
fn iec62443_sr_4_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Unit),
            "e".into(),
            Box::new(Expr::String("ok".into())),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-4",
    );
}

#[test]
fn iec62443_sr_5_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "plc_driver".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iec62443,
        "IEC62443-SR-5",
    );
}
#[test]
fn iec62443_sr_5_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-5",
    );
}

#[test]
fn iec62443_sr_6_violation() {
    assert_violation(
        &Expr::String("rc4".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-6",
    );
}
#[test]
fn iec62443_sr_6_ok() {
    assert_no_violation(
        &Expr::String("chacha20".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-6",
    );
}

// ===========================================================================
// NERC CIP tests
// ===========================================================================

#[test]
fn nerc_cip_004_violation() {
    assert_violation(
        &make_let("grid_data", Expr::String("load".into())),
        ComplianceProfile::NercCip,
        "NERC-CIP-004",
    );
}
#[test]
fn nerc_cip_004_ok() {
    assert_no_violation(
        &make_classified_let("grid_data", Expr::String("load".into())),
        ComplianceProfile::NercCip,
        "NERC-CIP-004",
    );
}

#[test]
fn nerc_cip_005_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::NercCip,
        "NERC-CIP-005",
    );
}
#[test]
fn nerc_cip_005_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::NercCip,
        "NERC-CIP-005",
    );
}

#[test]
fn nerc_cip_007_violation() {
    assert_violation(
        &make_let("scada_key", Expr::String("key".into())),
        ComplianceProfile::NercCip,
        "NERC-CIP-007",
    );
}
#[test]
fn nerc_cip_007_ok() {
    assert_no_violation(
        &make_let(
            "scada_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-007",
    );
}

#[test]
fn nerc_cip_010_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::NercCip,
        "NERC-CIP-010",
    );
}
#[test]
fn nerc_cip_010_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-010",
    );
}

#[test]
fn nerc_cip_011_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::NercCip,
        "NERC-CIP-011",
    );
}
#[test]
fn nerc_cip_011_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::NercCip,
        "NERC-CIP-011",
    );
}

// ===========================================================================
// FDA 21 CFR tests
// ===========================================================================

#[test]
fn fda_11_10_a_violation() {
    assert_violation(
        &make_let("clinical_data", Expr::String("trial".into())),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-a",
    );
}
#[test]
fn fda_11_10_a_ok() {
    assert_no_violation(
        &make_classified_let("clinical_data", Expr::String("trial".into())),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-a",
    );
}

#[test]
fn fda_11_10_b_violation() {
    assert_violation(
        &Expr::LetRec(
            "clinical_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-b",
    );
}
#[test]
fn fda_11_10_b_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "clinical_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-b",
    );
}

#[test]
fn fda_11_10_c_violation() {
    assert_violation(
        &make_let("pharma_key", Expr::String("key".into())),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-c",
    );
}
#[test]
fn fda_11_10_c_ok() {
    assert_no_violation(
        &make_let(
            "pharma_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-c",
    );
}

#[test]
fn fda_11_10_d_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-d",
    );
}
#[test]
fn fda_11_10_d_ok() {
    assert_no_violation(
        &make_let_with_body(
            "x",
            Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into()))),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-d",
    );
}

#[test]
fn fda_11_10_e_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-e",
    );
}
#[test]
fn fda_11_10_e_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-e",
    );
}

// ===========================================================================
// ITAR tests
// ===========================================================================

#[test]
fn itar_120_1_violation() {
    assert_violation(
        &make_let("munition_data", Expr::String("specs".into())),
        ComplianceProfile::Itar,
        "ITAR-120.1",
    );
}
#[test]
fn itar_120_1_ok() {
    assert_no_violation(
        &make_classified_let("munition_data", Expr::String("specs".into())),
        ComplianceProfile::Itar,
        "ITAR-120.1",
    );
}

#[test]
fn itar_120_2_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Itar,
        "ITAR-120.2",
    );
}
#[test]
fn itar_120_2_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Itar,
        "ITAR-120.2",
    );
}

#[test]
fn itar_120_3_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Itar,
        "ITAR-120.3",
    );
}
#[test]
fn itar_120_3_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Itar,
        "ITAR-120.3",
    );
}

#[test]
fn itar_120_4_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::Itar,
        "ITAR-120.4",
    );
}
#[test]
fn itar_120_4_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Itar,
        "ITAR-120.4",
    );
}

// ===========================================================================
// New PCI-DSS tests (10 new rules × 2 tests)
// ===========================================================================

#[test]
fn pci_dss_1_3_1_violation() {
    assert_violation(
        &Expr::String("192.168.1.1".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.3.1",
    );
}
#[test]
fn pci_dss_1_3_1_ok() {
    assert_no_violation(
        &Expr::String("hostname.example.com".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.3.1",
    );
}
#[test]
fn pci_dss_1_3_2_violation() {
    assert_violation(&Expr::Int(8080), ComplianceProfile::PciDss, "PCI-DSS-1.3.2");
}
#[test]
fn pci_dss_1_3_2_ok() {
    assert_no_violation(
        &Expr::Int(12345),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.3.2",
    );
}
#[test]
fn pci_dss_2_2_1_violation() {
    assert_violation(
        &make_let("encryption_enabled", Expr::Bool(false)),
        ComplianceProfile::PciDss,
        "PCI-DSS-2.2.1",
    );
}
#[test]
fn pci_dss_2_2_1_ok() {
    assert_no_violation(
        &make_let("encryption_enabled", Expr::Bool(true)),
        ComplianceProfile::PciDss,
        "PCI-DSS-2.2.1",
    );
}
#[test]
fn pci_dss_3_6_1_violation() {
    assert_violation(
        &make_let("key_created", Expr::Int(1700000000)),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.6.1",
    );
}
#[test]
fn pci_dss_3_6_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "key_created",
            Expr::Int(1700000000),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.6.1",
    );
}
#[test]
fn pci_dss_4_2_1_violation() {
    assert_violation(
        &Expr::String("debug: payment flow".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.2.1",
    );
}
#[test]
fn pci_dss_4_2_1_ok() {
    assert_no_violation(
        &Expr::String("payment processed".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.2.1",
    );
}
#[test]
fn pci_dss_6_5_7_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("card_number".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.7",
    );
}
#[test]
fn pci_dss_6_5_7_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("safe_data".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.7",
    );
}
#[test]
fn pci_dss_6_5_8_violation() {
    assert_violation(
        &make_let("payment_input", Expr::String("raw".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.8",
    );
}
#[test]
fn pci_dss_6_5_8_ok() {
    assert_no_violation(
        &make_let(
            "payment_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.8",
    );
}
#[test]
fn pci_dss_7_1_1_violation() {
    assert_violation(
        &Expr::Grant(Effect::FileSystem, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.1.1",
    );
}
#[test]
fn pci_dss_7_1_1_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.1.1",
    );
}
#[test]
fn pci_dss_8_5_1_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "auth_verify".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::PciDss,
        "PCI-DSS-8.5.1",
    );
}
#[test]
fn pci_dss_8_5_1_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::PciDss,
        "PCI-DSS-8.5.1",
    );
}
#[test]
fn pci_dss_10_3_1_violation() {
    assert_violation(
        &Expr::Let(
            "x".into(),
            None,
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.3.1",
    );
}
#[test]
fn pci_dss_10_3_1_ok() {
    assert_no_violation(
        &Expr::Let(
            "x".into(),
            None,
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Perform(Effect::Write, Box::new(Expr::Unit))),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.3.1",
    );
}

// ===========================================================================
// New HIPAA tests (8 new rules × 2 tests)
// ===========================================================================

#[test]
fn hipaa_164_308_a1_violation() {
    assert_violation(
        &Expr::String("10.0.0.1".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a1",
    );
}
#[test]
fn hipaa_164_308_a1_ok() {
    assert_no_violation(
        &Expr::String("health.example.com".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a1",
    );
}
#[test]
fn hipaa_164_308_a3_violation() {
    assert_violation(
        &Expr::String("debug: patient record".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a3",
    );
}
#[test]
fn hipaa_164_308_a3_ok() {
    assert_no_violation(
        &Expr::String("patient record processed".into()),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a3",
    );
}
#[test]
fn hipaa_164_310_a_violation() {
    assert_violation(
        &make_let("phi_protection", Expr::Bool(false)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-a",
    );
}
#[test]
fn hipaa_164_310_a_ok() {
    assert_no_violation(
        &make_let("phi_protection", Expr::Bool(true)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-a",
    );
}
#[test]
fn hipaa_164_312_b_violation() {
    assert_violation(
        &Expr::Int(3306),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-b",
    );
}
#[test]
fn hipaa_164_312_b_ok() {
    assert_no_violation(
        &Expr::Int(99999),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-b",
    );
}
#[test]
fn hipaa_164_312_c2_violation() {
    assert_violation(
        &make_let("admission_date", Expr::Int(20240101)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-c2",
    );
}
#[test]
fn hipaa_164_312_c2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "admission_date",
            Expr::Int(20240101),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-c2",
    );
}
#[test]
fn hipaa_164_312_e2_violation() {
    assert_violation(
        &Expr::Grant(Effect::FileSystem, Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-e2",
    );
}
#[test]
fn hipaa_164_312_e2_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-e2",
    );
}
#[test]
fn hipaa_164_530_a_violation() {
    assert_violation(
        &make_let("patient_input", Expr::String("data".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.530-a",
    );
}
#[test]
fn hipaa_164_530_a_ok() {
    assert_no_violation(
        &make_let(
            "patient_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.530-a",
    );
}
#[test]
fn hipaa_164_530_b_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "patient_lookup".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Hipaa,
        "HIPAA-164.530-b",
    );
}
#[test]
fn hipaa_164_530_b_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Hipaa,
        "HIPAA-164.530-b",
    );
}

// ===========================================================================
// New GDPR tests (8 new rules × 2 tests)
// ===========================================================================

#[test]
fn gdpr_5_1_d_violation() {
    assert_violation(
        &Expr::String("172.16.0.1".into()),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-d",
    );
}
#[test]
fn gdpr_5_1_d_ok() {
    assert_no_violation(
        &Expr::String("eu-west-1.example.com".into()),
        ComplianceProfile::Gdpr,
        "GDPR-5.1-d",
    );
}
#[test]
fn gdpr_6_1_violation() {
    assert_violation(
        &Expr::String("debug: user consent".into()),
        ComplianceProfile::Gdpr,
        "GDPR-6.1",
    );
}
#[test]
fn gdpr_6_1_ok() {
    assert_no_violation(
        &Expr::String("consent recorded".into()),
        ComplianceProfile::Gdpr,
        "GDPR-6.1",
    );
}
#[test]
fn gdpr_13_1_violation() {
    assert_violation(
        &make_let("consent_required", Expr::Bool(false)),
        ComplianceProfile::Gdpr,
        "GDPR-13.1",
    );
}
#[test]
fn gdpr_13_1_ok() {
    assert_no_violation(
        &make_let("consent_required", Expr::Bool(true)),
        ComplianceProfile::Gdpr,
        "GDPR-13.1",
    );
}
#[test]
fn gdpr_15_1_violation() {
    assert_violation(&Expr::Int(5432), ComplianceProfile::Gdpr, "GDPR-15.1");
}
#[test]
fn gdpr_15_1_ok() {
    assert_no_violation(&Expr::Int(55555), ComplianceProfile::Gdpr, "GDPR-15.1");
}
#[test]
fn gdpr_17_1_violation() {
    assert_violation(
        &make_let("consent_date", Expr::Int(20240301)),
        ComplianceProfile::Gdpr,
        "GDPR-17.1",
    );
}
#[test]
fn gdpr_17_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "consent_date",
            Expr::Int(20240301),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-17.1",
    );
}
#[test]
fn gdpr_20_1_violation() {
    assert_violation(
        &make_let("subject_data", Expr::String("raw".into())),
        ComplianceProfile::Gdpr,
        "GDPR-20.1",
    );
}
#[test]
fn gdpr_20_1_ok() {
    assert_no_violation(
        &make_let(
            "subject_data",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-20.1",
    );
}
#[test]
fn gdpr_25_2_violation() {
    assert_violation(
        &Expr::Grant(Effect::Random, Box::new(Expr::Unit)),
        ComplianceProfile::Gdpr,
        "GDPR-25.2",
    );
}
#[test]
fn gdpr_25_2_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Gdpr,
        "GDPR-25.2",
    );
}
#[test]
fn gdpr_44_1_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "transfer_data".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Gdpr,
        "GDPR-44.1",
    );
}
#[test]
fn gdpr_44_1_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Gdpr,
        "GDPR-44.1",
    );
}

// ===========================================================================
// New PDPA tests (8 new rules × 2 tests)
// ===========================================================================

#[test]
fn pdpa_s5_violation() {
    assert_violation(
        &Expr::String("10.1.1.1".into()),
        ComplianceProfile::Pdpa,
        "PDPA-S5",
    );
}
#[test]
fn pdpa_s5_ok() {
    assert_no_violation(
        &Expr::String("data.pdpa.my".into()),
        ComplianceProfile::Pdpa,
        "PDPA-S5",
    );
}
#[test]
fn pdpa_s7_1_violation() {
    assert_violation(
        &Expr::String("debug: personal data".into()),
        ComplianceProfile::Pdpa,
        "PDPA-S7-1",
    );
}
#[test]
fn pdpa_s7_1_ok() {
    assert_no_violation(
        &Expr::String("personal data stored".into()),
        ComplianceProfile::Pdpa,
        "PDPA-S7-1",
    );
}
#[test]
fn pdpa_s14_violation() {
    assert_violation(
        &make_let("data_protection", Expr::Bool(false)),
        ComplianceProfile::Pdpa,
        "PDPA-S14",
    );
}
#[test]
fn pdpa_s14_ok() {
    assert_no_violation(
        &make_let("data_protection", Expr::Bool(true)),
        ComplianceProfile::Pdpa,
        "PDPA-S14",
    );
}
#[test]
fn pdpa_s15_violation() {
    assert_violation(&Expr::Int(443), ComplianceProfile::Pdpa, "PDPA-S15");
}
#[test]
fn pdpa_s15_ok() {
    assert_no_violation(&Expr::Int(65000), ComplianceProfile::Pdpa, "PDPA-S15");
}
#[test]
fn pdpa_s16_violation() {
    assert_violation(
        &make_let("tarikh_kutip", Expr::Int(20240101)),
        ComplianceProfile::Pdpa,
        "PDPA-S16",
    );
}
#[test]
fn pdpa_s16_ok() {
    assert_no_violation(
        &make_let_with_body(
            "tarikh_kutip",
            Expr::Int(20240101),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S16",
    );
}
#[test]
fn pdpa_s17_violation() {
    assert_violation(
        &make_let("input_pengguna", Expr::String("raw".into())),
        ComplianceProfile::Pdpa,
        "PDPA-S17",
    );
}
#[test]
fn pdpa_s17_ok() {
    assert_no_violation(
        &make_let(
            "input_pengguna",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Pdpa,
        "PDPA-S17",
    );
}
#[test]
fn pdpa_s18_violation() {
    assert_violation(
        &Expr::Grant(Effect::Time, Box::new(Expr::Unit)),
        ComplianceProfile::Pdpa,
        "PDPA-S18",
    );
}
#[test]
fn pdpa_s18_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Pdpa,
        "PDPA-S18",
    );
}
#[test]
fn pdpa_s19_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "data_peribadi_export".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Pdpa,
        "PDPA-S19",
    );
}
#[test]
fn pdpa_s19_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Pdpa,
        "PDPA-S19",
    );
}

// ===========================================================================
// New BNM tests (8 new rules × 2 tests)
// ===========================================================================

#[test]
fn bnm_10_18_1_violation() {
    assert_violation(
        &Expr::String("10.10.10.1".into()),
        ComplianceProfile::Bnm,
        "BNM-10.18-1",
    );
}
#[test]
fn bnm_10_18_1_ok() {
    assert_no_violation(
        &Expr::String("bank.bnm.gov.my".into()),
        ComplianceProfile::Bnm,
        "BNM-10.18-1",
    );
}
#[test]
fn bnm_10_49_c_violation() {
    assert_violation(
        &Expr::String("debug: bank transfer".into()),
        ComplianceProfile::Bnm,
        "BNM-10.49-c",
    );
}
#[test]
fn bnm_10_49_c_ok() {
    assert_no_violation(
        &Expr::String("transfer completed".into()),
        ComplianceProfile::Bnm,
        "BNM-10.49-c",
    );
}
#[test]
fn bnm_10_53_violation() {
    assert_violation(
        &make_let("encryption_enabled", Expr::Bool(false)),
        ComplianceProfile::Bnm,
        "BNM-10.53",
    );
}
#[test]
fn bnm_10_53_ok() {
    assert_no_violation(
        &make_let("encryption_enabled", Expr::Bool(true)),
        ComplianceProfile::Bnm,
        "BNM-10.53",
    );
}
#[test]
fn bnm_10_57_violation() {
    assert_violation(&Expr::Int(22), ComplianceProfile::Bnm, "BNM-10.57");
}
#[test]
fn bnm_10_57_ok() {
    assert_no_violation(&Expr::Int(50000), ComplianceProfile::Bnm, "BNM-10.57");
}
#[test]
fn bnm_10_59_violation() {
    assert_violation(
        &make_let("tarikh_transaksi", Expr::Int(20240601)),
        ComplianceProfile::Bnm,
        "BNM-10.59",
    );
}
#[test]
fn bnm_10_59_ok() {
    assert_no_violation(
        &make_let_with_body(
            "tarikh_transaksi",
            Expr::Int(20240601),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.59",
    );
}
#[test]
fn bnm_10_60_violation() {
    assert_violation(
        &make_let("input_pelanggan", Expr::String("raw".into())),
        ComplianceProfile::Bnm,
        "BNM-10.60",
    );
}
#[test]
fn bnm_10_60_ok() {
    assert_no_violation(
        &make_let(
            "input_pelanggan",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.60",
    );
}
#[test]
fn bnm_10_61_violation() {
    assert_violation(
        &Expr::Grant(Effect::FileSystem, Box::new(Expr::Unit)),
        ComplianceProfile::Bnm,
        "BNM-10.61",
    );
}
#[test]
fn bnm_10_61_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Bnm,
        "BNM-10.61",
    );
}
#[test]
fn bnm_10_62_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "bank_transfer".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Bnm,
        "BNM-10.62",
    );
}
#[test]
fn bnm_10_62_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Bnm,
        "BNM-10.62",
    );
}

// ===========================================================================
// New MAS TRM tests (7 new rules × 2 tests)
// ===========================================================================

#[test]
fn mas_trm_5_1_2_violation() {
    assert_violation(
        &Expr::String("192.168.0.1".into()),
        ComplianceProfile::MasTrm,
        "MAS-TRM-5.1.2",
    );
}
#[test]
fn mas_trm_5_1_2_ok() {
    assert_no_violation(
        &Expr::String("api.mas.gov.sg".into()),
        ComplianceProfile::MasTrm,
        "MAS-TRM-5.1.2",
    );
}
#[test]
fn mas_trm_9_1_2_violation() {
    assert_violation(
        &Expr::String("debug: transaction".into()),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.1.2",
    );
}
#[test]
fn mas_trm_9_1_2_ok() {
    assert_no_violation(
        &Expr::String("transaction logged".into()),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.1.2",
    );
}
#[test]
fn mas_trm_9_2_2_violation() {
    assert_violation(
        &make_let("mfa_required", Expr::Bool(false)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.2.2",
    );
}
#[test]
fn mas_trm_9_2_2_ok() {
    assert_no_violation(
        &make_let("mfa_required", Expr::Bool(true)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.2.2",
    );
}
#[test]
fn mas_trm_9_4_2_violation() {
    assert_violation(&Expr::Int(3389), ComplianceProfile::MasTrm, "MAS-TRM-9.4.2");
}
#[test]
fn mas_trm_9_4_2_ok() {
    assert_no_violation(
        &Expr::Int(44444),
        ComplianceProfile::MasTrm,
        "MAS-TRM-9.4.2",
    );
}
#[test]
fn mas_trm_11_1_2_violation() {
    assert_violation(
        &make_let("token_issued", Expr::Int(20240101)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.1.2",
    );
}
#[test]
fn mas_trm_11_1_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "token_issued",
            Expr::Int(20240101),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.1.2",
    );
}
#[test]
fn mas_trm_11_2_2_violation() {
    assert_violation(
        &make_let("customer_input", Expr::String("raw".into())),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.2.2",
    );
}
#[test]
fn mas_trm_11_2_2_ok() {
    assert_no_violation(
        &make_let(
            "customer_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-11.2.2",
    );
}
#[test]
fn mas_trm_12_1_2_violation() {
    assert_violation(
        &Expr::Grant(Effect::Random, Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-12.1.2",
    );
}
#[test]
fn mas_trm_12_1_2_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm,
        "MAS-TRM-12.1.2",
    );
}

// ===========================================================================
// New NIST 800-53 tests (8 new rules × 2 tests)
// ===========================================================================

#[test]
fn nist_ac_2_violation() {
    assert_violation(
        &Expr::String("10.0.0.50".into()),
        ComplianceProfile::Nist80053,
        "NIST-AC-2",
    );
}
#[test]
fn nist_ac_2_ok() {
    assert_no_violation(
        &Expr::String("federal.gov".into()),
        ComplianceProfile::Nist80053,
        "NIST-AC-2",
    );
}
#[test]
fn nist_au_3_violation() {
    assert_violation(
        &Expr::String("debug: access control".into()),
        ComplianceProfile::Nist80053,
        "NIST-AU-3",
    );
}
#[test]
fn nist_au_3_ok() {
    assert_no_violation(
        &Expr::String("access granted".into()),
        ComplianceProfile::Nist80053,
        "NIST-AU-3",
    );
}
#[test]
fn nist_cm_6_violation() {
    assert_violation(
        &make_let("fips_mode", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-CM-6",
    );
}
#[test]
fn nist_cm_6_ok() {
    assert_no_violation(
        &make_let("fips_mode", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-CM-6",
    );
}
#[test]
fn nist_ia_6_violation() {
    assert_violation(&Expr::Int(1433), ComplianceProfile::Nist80053, "NIST-IA-6");
}
#[test]
fn nist_ia_6_ok() {
    assert_no_violation(&Expr::Int(33333), ComplianceProfile::Nist80053, "NIST-IA-6");
}
#[test]
fn nist_sc_4_violation() {
    assert_violation(
        &make_let("cert_expiry", Expr::Int(20251231)),
        ComplianceProfile::Nist80053,
        "NIST-SC-4",
    );
}
#[test]
fn nist_sc_4_ok() {
    assert_no_violation(
        &make_let_with_body(
            "cert_expiry",
            Expr::Int(20251231),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SC-4",
    );
}
#[test]
fn nist_ac_6_1_violation() {
    assert_violation(
        &Expr::Grant(Effect::Time, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-AC-6-1",
    );
}
#[test]
fn nist_ac_6_1_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-AC-6-1",
    );
}
#[test]
fn nist_sa_11_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "crypto_verify".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SA-11",
    );
}
#[test]
fn nist_sa_11_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SA-11",
    );
}
#[test]
fn nist_au_12_violation() {
    assert_violation(
        &Expr::Let(
            "x".into(),
            None,
            Box::new(Expr::Classify(Box::new(Expr::Int(1)))),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-12",
    );
}
#[test]
fn nist_au_12_ok() {
    assert_no_violation(
        &Expr::Let(
            "x".into(),
            None,
            Box::new(Expr::Classify(Box::new(Expr::Int(1)))),
            Box::new(Expr::Perform(Effect::Write, Box::new(Expr::Unit))),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-12",
    );
}

// ===========================================================================
// New ISO 27001 tests (8 new rules × 2 tests)
// ===========================================================================

#[test]
fn iso_a5_2_violation() {
    assert_violation(
        &Expr::String("10.20.30.40".into()),
        ComplianceProfile::Iso27001,
        "ISO-A5.2",
    );
}
#[test]
fn iso_a5_2_ok() {
    assert_no_violation(
        &Expr::String("intranet.corp.com".into()),
        ComplianceProfile::Iso27001,
        "ISO-A5.2",
    );
}
#[test]
fn iso_a7_1_violation() {
    assert_violation(
        &Expr::String("debug: access log".into()),
        ComplianceProfile::Iso27001,
        "ISO-A7.1",
    );
}
#[test]
fn iso_a7_1_ok() {
    assert_no_violation(
        &Expr::String("access logged".into()),
        ComplianceProfile::Iso27001,
        "ISO-A7.1",
    );
}
#[test]
fn iso_a8_2_violation() {
    assert_violation(
        &make_let("encryption_enabled", Expr::Bool(false)),
        ComplianceProfile::Iso27001,
        "ISO-A8.2",
    );
}
#[test]
fn iso_a8_2_ok() {
    assert_no_violation(
        &make_let("encryption_enabled", Expr::Bool(true)),
        ComplianceProfile::Iso27001,
        "ISO-A8.2",
    );
}
#[test]
fn iso_a9_2_violation() {
    assert_violation(&Expr::Int(27017), ComplianceProfile::Iso27001, "ISO-A9.2");
}
#[test]
fn iso_a9_2_ok() {
    assert_no_violation(&Expr::Int(11111), ComplianceProfile::Iso27001, "ISO-A9.2");
}
#[test]
fn iso_a11_1_violation() {
    assert_violation(
        &make_let("classification_date", Expr::Int(20240601)),
        ComplianceProfile::Iso27001,
        "ISO-A11.1",
    );
}
#[test]
fn iso_a11_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "classification_date",
            Expr::Int(20240601),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A11.1",
    );
}
#[test]
fn iso_a12_2_violation() {
    assert_violation(
        &make_let("user_input", Expr::String("raw".into())),
        ComplianceProfile::Iso27001,
        "ISO-A12.2",
    );
}
#[test]
fn iso_a12_2_ok() {
    assert_no_violation(
        &make_let(
            "user_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A12.2",
    );
}
#[test]
fn iso_a15_1_violation() {
    assert_violation(
        &Expr::Grant(Effect::FileSystem, Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A15.1",
    );
}
#[test]
fn iso_a15_1_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A15.1",
    );
}
#[test]
fn iso_a17_1_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "backup_restore".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iso27001,
        "ISO-A17.1",
    );
}
#[test]
fn iso_a17_1_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iso27001,
        "ISO-A17.1",
    );
}

// ===========================================================================
// New DO-178C tests (8 new rules × 2 tests)
// ===========================================================================

#[test]
fn do178c_6_3_4_violation() {
    assert_violation(
        &Expr::String("10.0.1.1".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.3.4",
    );
}
#[test]
fn do178c_6_3_4_ok() {
    assert_no_violation(
        &Expr::String("avionics.local".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.3.4",
    );
}
#[test]
fn do178c_6_3_5_violation() {
    assert_violation(
        &Expr::String("debug: autopilot".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.3.5",
    );
}
#[test]
fn do178c_6_3_5_ok() {
    assert_no_violation(
        &Expr::String("autopilot engaged".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.3.5",
    );
}
#[test]
fn do178c_6_4_6_violation() {
    assert_violation(
        &make_let("safety_enabled", Expr::Bool(false)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.6",
    );
}
#[test]
fn do178c_6_4_6_ok() {
    assert_no_violation(
        &make_let("safety_enabled", Expr::Bool(true)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.6",
    );
}
#[test]
fn do178c_6_4_7_violation() {
    assert_violation(&Expr::Int(80), ComplianceProfile::Do178c, "DO178C-6.4.7");
}
#[test]
fn do178c_6_4_7_ok() {
    assert_no_violation(&Expr::Int(42), ComplianceProfile::Do178c, "DO178C-6.4.7");
}
#[test]
fn do178c_6_4_8_violation() {
    assert_violation(
        &make_let("sensor_timestamp", Expr::Int(1700000000)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.8",
    );
}
#[test]
fn do178c_6_4_8_ok() {
    assert_no_violation(
        &make_let_with_body(
            "sensor_timestamp",
            Expr::Int(1700000000),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.8",
    );
}
#[test]
fn do178c_6_7_3_violation() {
    assert_violation(
        &make_let("sensor_input", Expr::String("raw".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.7.3",
    );
}
#[test]
fn do178c_6_7_3_ok() {
    assert_no_violation(
        &make_let(
            "sensor_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.7.3",
    );
}
#[test]
fn do178c_6_7_4_violation() {
    assert_violation(
        &Expr::Grant(Effect::FileSystem, Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.7.4",
    );
}
#[test]
fn do178c_6_7_4_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.7.4",
    );
}
#[test]
fn do178c_6_7_5_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "autopilot_control".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Do178c,
        "DO178C-6.7.5",
    );
}
#[test]
fn do178c_6_7_5_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "format_output".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Do178c,
        "DO178C-6.7.5",
    );
}

// ===========================================================================
// New SOX tests (7 new rules × 2 tests)
// ===========================================================================

#[test]
fn sox_302_3_violation() {
    assert_violation(
        &Expr::String("172.16.1.1".into()),
        ComplianceProfile::Sox,
        "SOX-302-3",
    );
}
#[test]
fn sox_302_3_ok() {
    assert_no_violation(
        &Expr::String("finance.corp.com".into()),
        ComplianceProfile::Sox,
        "SOX-302-3",
    );
}
#[test]
fn sox_302_4_violation() {
    assert_violation(
        &Expr::String("debug: revenue calc".into()),
        ComplianceProfile::Sox,
        "SOX-302-4",
    );
}
#[test]
fn sox_302_4_ok() {
    assert_no_violation(
        &Expr::String("revenue calculated".into()),
        ComplianceProfile::Sox,
        "SOX-302-4",
    );
}
#[test]
fn sox_404_3_violation() {
    assert_violation(
        &make_let("audit_enabled", Expr::Bool(false)),
        ComplianceProfile::Sox,
        "SOX-404-3",
    );
}
#[test]
fn sox_404_3_ok() {
    assert_no_violation(
        &make_let("audit_enabled", Expr::Bool(true)),
        ComplianceProfile::Sox,
        "SOX-404-3",
    );
}
#[test]
fn sox_404_4_violation() {
    assert_violation(&Expr::Int(5432), ComplianceProfile::Sox, "SOX-404-4");
}
#[test]
fn sox_404_4_ok() {
    assert_no_violation(&Expr::Int(54321), ComplianceProfile::Sox, "SOX-404-4");
}
#[test]
fn sox_409_2_violation() {
    assert_violation(
        &make_let("report_date", Expr::Int(20240630)),
        ComplianceProfile::Sox,
        "SOX-409-2",
    );
}
#[test]
fn sox_409_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "report_date",
            Expr::Int(20240630),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Sox,
        "SOX-409-2",
    );
}
#[test]
fn sox_802_2_violation() {
    assert_violation(
        &make_let("financial_input", Expr::String("raw".into())),
        ComplianceProfile::Sox,
        "SOX-802-2",
    );
}
#[test]
fn sox_802_2_ok() {
    assert_no_violation(
        &make_let(
            "financial_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Sox,
        "SOX-802-2",
    );
}
#[test]
fn sox_906_2_violation() {
    assert_violation(
        &Expr::Grant(Effect::Random, Box::new(Expr::Unit)),
        ComplianceProfile::Sox,
        "SOX-906-2",
    );
}
#[test]
fn sox_906_2_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Sox,
        "SOX-906-2",
    );
}

// ===========================================================================
// New CMMC tests (6 new rules × 2 tests)
// ===========================================================================

#[test]
fn cmmc_ac_3_violation() {
    assert_violation(
        &Expr::String("10.0.0.100".into()),
        ComplianceProfile::Cmmc,
        "CMMC-AC-3",
    );
}
#[test]
fn cmmc_ac_3_ok() {
    assert_no_violation(
        &Expr::String("defense.mil".into()),
        ComplianceProfile::Cmmc,
        "CMMC-AC-3",
    );
}
#[test]
fn cmmc_ac_4_violation() {
    assert_violation(
        &Expr::String("debug: CUI data".into()),
        ComplianceProfile::Cmmc,
        "CMMC-AC-4",
    );
}
#[test]
fn cmmc_ac_4_ok() {
    assert_no_violation(
        &Expr::String("CUI processed".into()),
        ComplianceProfile::Cmmc,
        "CMMC-AC-4",
    );
}
#[test]
fn cmmc_sc_3_violation() {
    assert_violation(
        &make_let("fips_enabled", Expr::Bool(false)),
        ComplianceProfile::Cmmc,
        "CMMC-SC-3",
    );
}
#[test]
fn cmmc_sc_3_ok() {
    assert_no_violation(
        &make_let("fips_enabled", Expr::Bool(true)),
        ComplianceProfile::Cmmc,
        "CMMC-SC-3",
    );
}
#[test]
fn cmmc_sc_4_violation() {
    assert_violation(&Expr::Int(23), ComplianceProfile::Cmmc, "CMMC-SC-4");
}
#[test]
fn cmmc_sc_4_ok() {
    assert_no_violation(&Expr::Int(40000), ComplianceProfile::Cmmc, "CMMC-SC-4");
}
#[test]
fn cmmc_si_2_violation() {
    assert_violation(
        &make_let("cui_created", Expr::Int(20240101)),
        ComplianceProfile::Cmmc,
        "CMMC-SI-2",
    );
}
#[test]
fn cmmc_si_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "cui_created",
            Expr::Int(20240101),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-SI-2",
    );
}
#[test]
fn cmmc_au_2_violation() {
    assert_violation(
        &Expr::Grant(Effect::Time, Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-AU-2",
    );
}
#[test]
fn cmmc_au_2_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-AU-2",
    );
}

// ===========================================================================
// New IEC 62443 tests (6 new rules × 2 tests)
// ===========================================================================

#[test]
fn iec62443_sr_7_violation() {
    assert_violation(
        &Expr::String("192.168.100.1".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-7",
    );
}
#[test]
fn iec62443_sr_7_ok() {
    assert_no_violation(
        &Expr::String("scada.local".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-7",
    );
}
#[test]
fn iec62443_sr_8_violation() {
    assert_violation(
        &Expr::String("debug: PLC status".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-8",
    );
}
#[test]
fn iec62443_sr_8_ok() {
    assert_no_violation(
        &Expr::String("PLC status ok".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-8",
    );
}
#[test]
fn iec62443_sr_9_violation() {
    assert_violation(
        &make_let("scada_secure", Expr::Bool(false)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-9",
    );
}
#[test]
fn iec62443_sr_9_ok() {
    assert_no_violation(
        &make_let("scada_secure", Expr::Bool(true)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-9",
    );
}
#[test]
fn iec62443_sr_10_violation() {
    assert_violation(
        &Expr::Int(445),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-10",
    );
}
#[test]
fn iec62443_sr_10_ok() {
    assert_no_violation(
        &Expr::Int(60000),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-10",
    );
}
#[test]
fn iec62443_sr_11_violation() {
    assert_violation(
        &make_let("sensor_timestamp", Expr::Int(1700000000)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-11",
    );
}
#[test]
fn iec62443_sr_11_ok() {
    assert_no_violation(
        &make_let_with_body(
            "sensor_timestamp",
            Expr::Int(1700000000),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-11",
    );
}
#[test]
fn iec62443_sr_12_violation() {
    assert_violation(
        &Expr::Grant(Effect::Random, Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-12",
    );
}
#[test]
fn iec62443_sr_12_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-12",
    );
}

// ===========================================================================
// New NERC CIP tests (5 new rules × 2 tests)
// ===========================================================================

#[test]
fn nerc_cip_003_violation() {
    assert_violation(
        &Expr::String("10.100.0.1".into()),
        ComplianceProfile::NercCip,
        "NERC-CIP-003",
    );
}
#[test]
fn nerc_cip_003_ok() {
    assert_no_violation(
        &Expr::String("grid.energy.gov".into()),
        ComplianceProfile::NercCip,
        "NERC-CIP-003",
    );
}
#[test]
fn nerc_cip_006_violation() {
    assert_violation(
        &Expr::String("debug: grid status".into()),
        ComplianceProfile::NercCip,
        "NERC-CIP-006",
    );
}
#[test]
fn nerc_cip_006_ok() {
    assert_no_violation(
        &Expr::String("grid status normal".into()),
        ComplianceProfile::NercCip,
        "NERC-CIP-006",
    );
}
#[test]
fn nerc_cip_008_violation() {
    assert_violation(
        &make_let("grid_protection", Expr::Bool(false)),
        ComplianceProfile::NercCip,
        "NERC-CIP-008",
    );
}
#[test]
fn nerc_cip_008_ok() {
    assert_no_violation(
        &make_let("grid_protection", Expr::Bool(true)),
        ComplianceProfile::NercCip,
        "NERC-CIP-008",
    );
}
#[test]
fn nerc_cip_009_violation() {
    assert_violation(&Expr::Int(110), ComplianceProfile::NercCip, "NERC-CIP-009");
}
#[test]
fn nerc_cip_009_ok() {
    assert_no_violation(
        &Expr::Int(55000),
        ComplianceProfile::NercCip,
        "NERC-CIP-009",
    );
}
#[test]
fn nerc_cip_012_violation() {
    assert_violation(
        &make_let("outage_date", Expr::Int(20240315)),
        ComplianceProfile::NercCip,
        "NERC-CIP-012",
    );
}
#[test]
fn nerc_cip_012_ok() {
    assert_no_violation(
        &make_let_with_body(
            "outage_date",
            Expr::Int(20240315),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-012",
    );
}

// ===========================================================================
// New FDA 21CFR tests (5 new rules × 2 tests)
// ===========================================================================

#[test]
fn fda_11_10_f_violation() {
    assert_violation(
        &Expr::String("10.200.0.1".into()),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-f",
    );
}
#[test]
fn fda_11_10_f_ok() {
    assert_no_violation(
        &Expr::String("pharma.fda.gov".into()),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-f",
    );
}
#[test]
fn fda_11_10_g_violation() {
    assert_violation(
        &Expr::String("debug: clinical trial".into()),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-g",
    );
}
#[test]
fn fda_11_10_g_ok() {
    assert_no_violation(
        &Expr::String("clinical trial completed".into()),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-g",
    );
}
#[test]
fn fda_11_10_h_violation() {
    assert_violation(
        &make_let("validation_enabled", Expr::Bool(false)),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-h",
    );
}
#[test]
fn fda_11_10_h_ok() {
    assert_no_violation(
        &make_let("validation_enabled", Expr::Bool(true)),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-h",
    );
}
#[test]
fn fda_11_10_i_violation() {
    assert_violation(&Expr::Int(993), ComplianceProfile::Fda21cfr, "FDA-11.10-i");
}
#[test]
fn fda_11_10_i_ok() {
    assert_no_violation(
        &Expr::Int(45000),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-i",
    );
}
#[test]
fn fda_11_10_j_violation() {
    assert_violation(
        &make_let("trial_date", Expr::Int(20240101)),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-j",
    );
}
#[test]
fn fda_11_10_j_ok() {
    assert_no_violation(
        &make_let_with_body(
            "trial_date",
            Expr::Int(20240101),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-j",
    );
}

// ===========================================================================
// New ITAR tests (4 new rules × 2 tests)
// ===========================================================================

#[test]
fn itar_120_5_violation() {
    assert_violation(
        &Expr::String("10.50.0.1".into()),
        ComplianceProfile::Itar,
        "ITAR-120.5",
    );
}
#[test]
fn itar_120_5_ok() {
    assert_no_violation(
        &Expr::String("defense.mil".into()),
        ComplianceProfile::Itar,
        "ITAR-120.5",
    );
}
#[test]
fn itar_120_6_violation() {
    assert_violation(
        &Expr::String("debug: export data".into()),
        ComplianceProfile::Itar,
        "ITAR-120.6",
    );
}
#[test]
fn itar_120_6_ok() {
    assert_no_violation(
        &Expr::String("export processed".into()),
        ComplianceProfile::Itar,
        "ITAR-120.6",
    );
}
#[test]
fn itar_120_7_violation() {
    assert_violation(
        &make_let("export_control", Expr::Bool(false)),
        ComplianceProfile::Itar,
        "ITAR-120.7",
    );
}
#[test]
fn itar_120_7_ok() {
    assert_no_violation(
        &make_let("export_control", Expr::Bool(true)),
        ComplianceProfile::Itar,
        "ITAR-120.7",
    );
}
#[test]
fn itar_120_8_violation() {
    assert_violation(&Expr::Int(25), ComplianceProfile::Itar, "ITAR-120.8");
}
#[test]
fn itar_120_8_ok() {
    assert_no_violation(&Expr::Int(30000), ComplianceProfile::Itar, "ITAR-120.8");
}

// ===========================================================================
// Cross-cutting / integration tests
// ===========================================================================

#[test]
fn all_profiles_have_rules() {
    for &p in ComplianceProfile::ALL {
        let rules = crate::rules::rules_for_profiles(&[p]);
        assert!(
            !rules.is_empty(),
            "Profile {:?} has no rules implemented",
            p
        );
    }
}

#[test]
fn total_rule_count_exceeds_100() {
    let mut total = 0;
    for &p in ComplianceProfile::ALL {
        total += crate::rules::rule_count(p);
    }
    assert!(total >= 200, "Expected 200+ rules, got {}", total);
}

#[test]
fn rule_count_matches_actual() {
    for &p in ComplianceProfile::ALL {
        let declared = crate::rules::rule_count(p);
        let actual = crate::rules::rules_for_profiles(&[p]).len();
        assert_eq!(
            declared, actual,
            "Profile {:?}: rule_count() says {} but actual rules = {}",
            p, declared, actual
        );
    }
}

#[test]
fn multiple_profiles_accumulate_violations() {
    // An insecure network perform triggers multiple profiles
    let expr = Expr::Perform(Effect::Network, Box::new(Expr::Unit));
    let violations = validate(
        &expr,
        &[
            ComplianceProfile::PciDss,
            ComplianceProfile::Hipaa,
            ComplianceProfile::Gdpr,
        ],
    );
    // Each profile should produce at least one violation
    assert!(violations.iter().any(|v| v.rule_id == "PCI-DSS-4.1"));
    assert!(violations.iter().any(|v| v.rule_id == "HIPAA-164.312-e1"));
    assert!(violations.iter().any(|v| v.rule_id == "GDPR-25.1"));
}
#[test]
fn pci_dss_pci_dss_1_1_1_violation() {
    assert_violation(
        &make_let("firewall_config", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_1_1_1_ok() {
    assert_no_violation(
        &make_classified_let("firewall_config", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_1_2_1_violation() {
    assert_violation(
        &make_let("segmentation_enabled", Expr::Bool(false)),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.2.1",
    );
}
#[test]
fn pci_dss_pci_dss_1_2_1_ok() {
    assert_no_violation(
        &make_let("segmentation_enabled", Expr::Bool(true)),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.2.1",
    );
}

#[test]
fn pci_dss_pci_dss_1_3_3_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("cardholder".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.3.3",
    );
}
#[test]
fn pci_dss_pci_dss_1_3_3_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.3.3",
    );
}

#[test]
fn pci_dss_pci_dss_1_4_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.4.1",
    );
}
#[test]
fn pci_dss_pci_dss_1_4_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.4.1",
    );
}

#[test]
fn pci_dss_pci_dss_1_5_1_violation() {
    assert_violation(
        &make_let("network_diagram", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.5.1",
    );
}
#[test]
fn pci_dss_pci_dss_1_5_1_ok() {
    assert_no_violation(
        &make_classified_let("network_diagram", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-1.5.1",
    );
}

#[test]
fn pci_dss_pci_dss_2_1_1_violation() {
    assert_violation(
        &make_let("default_password", Expr::String("hardcoded".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-2.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_2_1_1_ok() {
    assert_no_violation(
        &make_let(
            "default_password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-2.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_2_3_1_violation() {
    assert_violation(
        &make_let("admin_encryption", Expr::Bool(false)),
        ComplianceProfile::PciDss,
        "PCI-DSS-2.3.1",
    );
}
#[test]
fn pci_dss_pci_dss_2_3_1_ok() {
    assert_no_violation(
        &make_let("admin_encryption", Expr::Bool(true)),
        ComplianceProfile::PciDss,
        "PCI-DSS-2.3.1",
    );
}

#[test]
fn pci_dss_pci_dss_3_1_1_violation() {
    assert_violation(
        &make_let("retention_data", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_3_1_1_ok() {
    assert_no_violation(
        &make_classified_let("retention_data", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_3_2_1_violation() {
    assert_violation(
        &make_let("auth_store", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.2.1",
    );
}
#[test]
fn pci_dss_pci_dss_3_2_1_ok() {
    assert_no_violation(
        &make_classified_let("auth_store", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.2.1",
    );
}

#[test]
fn pci_dss_pci_dss_3_3_1_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.3.1",
    );
}
#[test]
fn pci_dss_pci_dss_3_3_1_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.3.1",
    );
}

#[test]
fn pci_dss_pci_dss_3_7_1_violation() {
    assert_violation(
        &make_let("key_procedure", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.7.1",
    );
}
#[test]
fn pci_dss_pci_dss_3_7_1_ok() {
    assert_no_violation(
        &make_classified_let("key_procedure", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-3.7.1",
    );
}

#[test]
fn pci_dss_pci_dss_4_1_1_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_4_1_1_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_4_2_2_violation() {
    assert_violation(
        &make_let("message_data", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.2.2",
    );
}
#[test]
fn pci_dss_pci_dss_4_2_2_ok() {
    assert_no_violation(
        &make_classified_let("message_data", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-4.2.2",
    );
}

#[test]
fn pci_dss_pci_dss_5_1_1_violation() {
    assert_violation(
        &make_let("scan_input", Expr::String("raw".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-5.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_5_1_1_ok() {
    assert_no_violation(
        &make_let(
            "scan_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-5.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_5_2_1_violation() {
    assert_violation(
        &make_let("antimalware_enabled", Expr::Bool(false)),
        ComplianceProfile::PciDss,
        "PCI-DSS-5.2.1",
    );
}
#[test]
fn pci_dss_pci_dss_5_2_1_ok() {
    assert_no_violation(
        &make_let("antimalware_enabled", Expr::Bool(true)),
        ComplianceProfile::PciDss,
        "PCI-DSS-5.2.1",
    );
}

#[test]
fn pci_dss_pci_dss_6_3_2_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::PciDss,
        "PCI-DSS-6.3.2",
    );
}
#[test]
fn pci_dss_pci_dss_6_3_2_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.3.2",
    );
}

#[test]
fn pci_dss_pci_dss_6_5_9_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.9",
    );
}
#[test]
fn pci_dss_pci_dss_6_5_9_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-6.5.9",
    );
}

#[test]
fn pci_dss_pci_dss_7_1_2_violation() {
    assert_violation(
        &make_let("access_system", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.1.2",
    );
}
#[test]
fn pci_dss_pci_dss_7_1_2_ok() {
    assert_no_violation(
        &make_classified_let("access_system", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.1.2",
    );
}

#[test]
fn pci_dss_pci_dss_7_2_1_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.2.1",
    );
}
#[test]
fn pci_dss_pci_dss_7_2_1_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.2.1",
    );
}

#[test]
fn pci_dss_pci_dss_7_3_1_violation() {
    assert_violation(
        &make_let("access_policy", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.3.1",
    );
}
#[test]
fn pci_dss_pci_dss_7_3_1_ok() {
    assert_no_violation(
        &make_classified_let("access_policy", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-7.3.1",
    );
}

#[test]
fn pci_dss_pci_dss_8_1_1_violation() {
    assert_violation(
        &Expr::LetRec(
            "user_identify".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-8.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_8_1_1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "user_identify".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-8.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_8_2_1_violation() {
    assert_violation(
        &make_let("user_password", Expr::String("hardcoded".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-8.2.1",
    );
}
#[test]
fn pci_dss_pci_dss_8_2_1_ok() {
    assert_no_violation(
        &make_let(
            "user_password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-8.2.1",
    );
}

#[test]
fn pci_dss_pci_dss_9_1_1_violation() {
    assert_violation(
        &make_let("badge_data", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-9.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_9_1_1_ok() {
    assert_no_violation(
        &make_classified_let("badge_data", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-9.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_10_1_1_violation() {
    assert_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Unit,
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_10_1_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_10_4_1_violation() {
    assert_violation(
        &make_let_with_body("log_timestamp", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.4.1",
    );
}
#[test]
fn pci_dss_pci_dss_10_4_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "log_timestamp",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.4.1",
    );
}

#[test]
fn pci_dss_pci_dss_10_5_1_violation() {
    assert_violation(
        &make_let("audit_trail", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.5.1",
    );
}
#[test]
fn pci_dss_pci_dss_10_5_1_ok() {
    assert_no_violation(
        &make_classified_let("audit_trail", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.5.1",
    );
}

#[test]
fn pci_dss_pci_dss_10_6_1_violation() {
    assert_violation(
        &make_let("log_review", Expr::Bool(false)),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.6.1",
    );
}
#[test]
fn pci_dss_pci_dss_10_6_1_ok() {
    assert_no_violation(
        &make_let("log_review", Expr::Bool(true)),
        ComplianceProfile::PciDss,
        "PCI-DSS-10.6.1",
    );
}

#[test]
fn pci_dss_pci_dss_11_1_1_violation() {
    assert_violation(
        &make_let("wireless_ap", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-11.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_11_1_1_ok() {
    assert_no_violation(
        &make_classified_let("wireless_ap", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-11.1.1",
    );
}

#[test]
fn pci_dss_pci_dss_11_3_1_violation() {
    assert_violation(
        &make_let("pentest_input", Expr::String("raw".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-11.3.1",
    );
}
#[test]
fn pci_dss_pci_dss_11_3_1_ok() {
    assert_no_violation(
        &make_let(
            "pentest_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::PciDss,
        "PCI-DSS-11.3.1",
    );
}

#[test]
fn pci_dss_pci_dss_12_1_1_violation() {
    assert_violation(
        &make_let("security_policy", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-12.1.1",
    );
}
#[test]
fn pci_dss_pci_dss_12_1_1_ok() {
    assert_no_violation(
        &make_classified_let("security_policy", Expr::String("val".into())),
        ComplianceProfile::PciDss,
        "PCI-DSS-12.1.1",
    );
}

#[test]
fn hipaa_hipaa_164_308_a2_violation() {
    assert_violation(
        &make_let("security_mgmt", Expr::Bool(false)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a2",
    );
}
#[test]
fn hipaa_hipaa_164_308_a2_ok() {
    assert_no_violation(
        &make_let("security_mgmt", Expr::Bool(true)),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a2",
    );
}

#[test]
fn hipaa_hipaa_164_308_a4_violation() {
    assert_violation(
        &Expr::LetRec(
            "access_mgmt".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a4",
    );
}
#[test]
fn hipaa_hipaa_164_308_a4_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "access_mgmt".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a4",
    );
}

#[test]
fn hipaa_hipaa_164_308_a6_violation() {
    assert_violation(
        &make_let("incident_data", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a6",
    );
}
#[test]
fn hipaa_hipaa_164_308_a6_ok() {
    assert_no_violation(
        &make_classified_let("incident_data", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a6",
    );
}

#[test]
fn hipaa_hipaa_164_308_a7_violation() {
    assert_violation(
        &make_let("contingency_data", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a7",
    );
}
#[test]
fn hipaa_hipaa_164_308_a7_ok() {
    assert_no_violation(
        &make_classified_let("contingency_data", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.308-a7",
    );
}

#[test]
fn hipaa_hipaa_164_310_a1_violation() {
    assert_violation(
        &make_let("facility_access", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-a1",
    );
}
#[test]
fn hipaa_hipaa_164_310_a1_ok() {
    assert_no_violation(
        &make_classified_let("facility_access", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-a1",
    );
}

#[test]
fn hipaa_hipaa_164_310_b1_violation() {
    assert_violation(
        &make_let("workstation_data", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-b1",
    );
}
#[test]
fn hipaa_hipaa_164_310_b1_ok() {
    assert_no_violation(
        &make_classified_let("workstation_data", Expr::String("val".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.310-b1",
    );
}

#[test]
fn hipaa_hipaa_164_312_a3_violation() {
    assert_violation(
        &make_let("emergency_password", Expr::String("hardcoded".into())),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-a3",
    );
}
#[test]
fn hipaa_hipaa_164_312_a3_ok() {
    assert_no_violation(
        &make_let(
            "emergency_password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-a3",
    );
}

#[test]
fn hipaa_hipaa_164_312_c3_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-c3",
    );
}
#[test]
fn hipaa_hipaa_164_312_c3_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-c3",
    );
}

#[test]
fn hipaa_hipaa_164_312_e3_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("phi".into()))),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-e3",
    );
}
#[test]
fn hipaa_hipaa_164_312_e3_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Hipaa,
        "HIPAA-164.312-e3",
    );
}

#[test]
fn hipaa_hipaa_164_316_a1_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Hipaa,
        "HIPAA-164.316-a1",
    );
}
#[test]
fn hipaa_hipaa_164_316_a1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.316-a1",
    );
}

#[test]
fn hipaa_hipaa_164_316_b1_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.316-b1",
    );
}
#[test]
fn hipaa_hipaa_164_316_b1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa,
        "HIPAA-164.316-b1",
    );
}

#[test]
fn gdpr_gdpr_9_1_violation() {
    assert_violation(
        &make_let("biometric", Expr::String("val".into())),
        ComplianceProfile::Gdpr,
        "GDPR-9.1",
    );
}
#[test]
fn gdpr_gdpr_9_1_ok() {
    assert_no_violation(
        &make_classified_let("biometric", Expr::String("val".into())),
        ComplianceProfile::Gdpr,
        "GDPR-9.1",
    );
}

#[test]
fn gdpr_gdpr_17_2_violation() {
    assert_violation(
        &make_let_with_body("erasure_request_date", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Gdpr,
        "GDPR-17.2",
    );
}
#[test]
fn gdpr_gdpr_17_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "erasure_request_date",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-17.2",
    );
}

#[test]
fn gdpr_gdpr_33_1_violation() {
    assert_violation(
        &make_let("breach_notification", Expr::String("val".into())),
        ComplianceProfile::Gdpr,
        "GDPR-33.1",
    );
}
#[test]
fn gdpr_gdpr_33_1_ok() {
    assert_no_violation(
        &make_classified_let("breach_notification", Expr::String("val".into())),
        ComplianceProfile::Gdpr,
        "GDPR-33.1",
    );
}

#[test]
fn gdpr_gdpr_35_1_violation() {
    assert_violation(
        &make_let("dpia_enabled", Expr::Bool(false)),
        ComplianceProfile::Gdpr,
        "GDPR-35.1",
    );
}
#[test]
fn gdpr_gdpr_35_1_ok() {
    assert_no_violation(
        &make_let("dpia_enabled", Expr::Bool(true)),
        ComplianceProfile::Gdpr,
        "GDPR-35.1",
    );
}

#[test]
fn gdpr_gdpr_30_1_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Gdpr,
        "GDPR-30.1",
    );
}
#[test]
fn gdpr_gdpr_30_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-30.1",
    );
}

#[test]
fn gdpr_gdpr_32_1_violation() {
    assert_violation(
        &make_let("processing_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Gdpr,
        "GDPR-32.1",
    );
}
#[test]
fn gdpr_gdpr_32_1_ok() {
    assert_no_violation(
        &make_let(
            "processing_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-32.1",
    );
}

#[test]
fn gdpr_gdpr_25_3_violation() {
    assert_violation(
        &Expr::LetRec(
            "privacy_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-25.3",
    );
}
#[test]
fn gdpr_gdpr_25_3_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "privacy_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-25.3",
    );
}

// --- GDPR IFC-mapped rules ---
#[test]
fn gdpr_ifc_1_violation() {
    assert_violation(
        &make_let("controller_data", Expr::String("data".into())),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.1",
    );
}
#[test]
fn gdpr_ifc_1_ok() {
    assert_no_violation(
        &make_classified_let("controller_data", Expr::String("data".into())),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.1",
    );
}

#[test]
fn gdpr_ifc_2_violation() {
    assert_violation(
        &make_let("cross_border", Expr::String("eu_to_us".into())),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.2",
    );
}
#[test]
fn gdpr_ifc_2_ok() {
    assert_no_violation(
        &make_classified_let("cross_border", Expr::String("eu_to_us".into())),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.2",
    );
}

#[test]
fn gdpr_ifc_3_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.3",
    );
}
#[test]
fn gdpr_ifc_3_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.3",
    );
}

#[test]
fn gdpr_ifc_4_violation() {
    assert_violation(
        &Expr::Perform(
            Effect::Network,
            Box::new(Expr::Var("consent_withdrawn".into())),
        ),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.4",
    );
}
#[test]
fn gdpr_ifc_4_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.4",
    );
}

#[test]
fn gdpr_ifc_6_violation() {
    assert_violation(
        &make_let("automated_decision", Expr::Int(1)),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.6",
    );
}
#[test]
fn gdpr_ifc_6_ok() {
    assert_no_violation(
        &make_classified_let("automated_decision", Expr::Int(1)),
        ComplianceProfile::Gdpr,
        "GDPR-IFC.6",
    );
}

#[test]
fn bnm_bnm_10_18_1_violation() {
    assert_violation(
        &Expr::String("192.168.1.1".into()),
        ComplianceProfile::Bnm,
        "BNM-10.18-1",
    );
}
#[test]
fn bnm_bnm_10_18_1_ok() {
    assert_no_violation(
        &Expr::String("safe_value".into()),
        ComplianceProfile::Bnm,
        "BNM-10.18-1",
    );
}

#[test]
fn bnm_bnm_10_63_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Bnm,
        "BNM-10.63",
    );
}
#[test]
fn bnm_bnm_10_63_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Bnm,
        "BNM-10.63",
    );
}

#[test]
fn bnm_bnm_10_64_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("bank_data".into()))),
        ComplianceProfile::Bnm,
        "BNM-10.64",
    );
}
#[test]
fn bnm_bnm_10_64_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Bnm,
        "BNM-10.64",
    );
}

#[test]
fn mas_trm_mas_trm_6_1_1_violation() {
    assert_violation(
        &make_let("project_data", Expr::String("val".into())),
        ComplianceProfile::MasTrm,
        "MAS-TRM-6.1.1",
    );
}
#[test]
fn mas_trm_mas_trm_6_1_1_ok() {
    assert_no_violation(
        &make_classified_let("project_data", Expr::String("val".into())),
        ComplianceProfile::MasTrm,
        "MAS-TRM-6.1.1",
    );
}

#[test]
fn mas_trm_mas_trm_7_1_1_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-7.1.1",
    );
}
#[test]
fn mas_trm_mas_trm_7_1_1_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-7.1.1",
    );
}

#[test]
fn mas_trm_mas_trm_8_1_1_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "banking_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::MasTrm,
        "MAS-TRM-8.1.1",
    );
}
#[test]
fn mas_trm_mas_trm_8_1_1_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::MasTrm,
        "MAS-TRM-8.1.1",
    );
}

#[test]
fn mas_trm_mas_trm_10_1_1_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::MasTrm,
        "MAS-TRM-10.1.1",
    );
}
#[test]
fn mas_trm_mas_trm_10_1_1_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-10.1.1",
    );
}

#[test]
fn mas_trm_mas_trm_13_1_2_violation() {
    assert_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-13.1.2",
    );
}
#[test]
fn mas_trm_mas_trm_13_1_2_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::String("error logged".into())),
        ),
        ComplianceProfile::MasTrm,
        "MAS-TRM-13.1.2",
    );
}

#[test]
fn nist_nist_ac_3_violation() {
    assert_violation(
        &make_let("access_list", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-3",
    );
}
#[test]
fn nist_nist_ac_3_ok() {
    assert_no_violation(
        &make_classified_let("access_list", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-3",
    );
}

#[test]
fn nist_nist_ac_4_violation() {
    assert_violation(
        &make_let("data_flow", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-4",
    );
}
#[test]
fn nist_nist_ac_4_ok() {
    assert_no_violation(
        &make_classified_let("data_flow", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-4",
    );
}

#[test]
fn nist_nist_ac_5_violation() {
    assert_violation(
        &make_let("separation_duty", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-5",
    );
}
#[test]
fn nist_nist_ac_5_ok() {
    assert_no_violation(
        &make_classified_let("separation_duty", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-5",
    );
}

#[test]
fn nist_nist_ac_7_violation() {
    assert_violation(
        &make_let("max_attempts", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-7",
    );
}
#[test]
fn nist_nist_ac_7_ok() {
    assert_no_violation(
        &make_let(
            "max_attempts",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AC-7",
    );
}

#[test]
fn nist_nist_ac_8_violation() {
    assert_violation(
        &make_let("login_banner", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-AC-8",
    );
}
#[test]
fn nist_nist_ac_8_ok() {
    assert_no_violation(
        &make_let("login_banner", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-AC-8",
    );
}

#[test]
fn nist_nist_ac_10_violation() {
    assert_violation(
        &make_let("session_limit", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-10",
    );
}
#[test]
fn nist_nist_ac_10_ok() {
    assert_no_violation(
        &make_classified_let("session_limit", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-10",
    );
}

#[test]
fn nist_nist_ac_11_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-AC-11",
    );
}
#[test]
fn nist_nist_ac_11_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-AC-11",
    );
}

#[test]
fn nist_nist_ac_14_violation() {
    assert_violation(
        &make_let("anonymous_action", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-14",
    );
}
#[test]
fn nist_nist_ac_14_ok() {
    assert_no_violation(
        &make_classified_let("anonymous_action", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-14",
    );
}

#[test]
fn nist_nist_ac_17_violation() {
    assert_violation(
        &make_let("remote_password", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-17",
    );
}
#[test]
fn nist_nist_ac_17_ok() {
    assert_no_violation(
        &make_let(
            "remote_password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AC-17",
    );
}

#[test]
fn nist_nist_ac_18_violation() {
    assert_violation(
        &make_let("wifi_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-18",
    );
}
#[test]
fn nist_nist_ac_18_ok() {
    assert_no_violation(
        &make_classified_let("wifi_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-18",
    );
}

#[test]
fn nist_nist_ac_19_violation() {
    assert_violation(
        &make_let("mobile_data", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-19",
    );
}
#[test]
fn nist_nist_ac_19_ok() {
    assert_no_violation(
        &make_classified_let("mobile_data", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-19",
    );
}

#[test]
fn nist_nist_ac_20_violation() {
    assert_violation(
        &make_let("external_trust", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-AC-20",
    );
}
#[test]
fn nist_nist_ac_20_ok() {
    assert_no_violation(
        &make_let("external_trust", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-AC-20",
    );
}

#[test]
fn nist_nist_ac_21_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("classified".into()))),
        ComplianceProfile::Nist80053,
        "NIST-AC-21",
    );
}
#[test]
fn nist_nist_ac_21_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Nist80053,
        "NIST-AC-21",
    );
}

#[test]
fn nist_nist_ac_22_violation() {
    assert_violation(
        &make_let("public_content", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-22",
    );
}
#[test]
fn nist_nist_ac_22_ok() {
    assert_no_violation(
        &make_classified_let("public_content", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-22",
    );
}

#[test]
fn nist_nist_ac_23_violation() {
    assert_violation(
        &make_let("mining_data", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-23",
    );
}
#[test]
fn nist_nist_ac_23_ok() {
    assert_no_violation(
        &make_classified_let("mining_data", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-23",
    );
}

#[test]
fn nist_nist_ac_24_violation() {
    assert_violation(
        &make_let("access_decision", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-24",
    );
}
#[test]
fn nist_nist_ac_24_ok() {
    assert_no_violation(
        &make_classified_let("access_decision", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AC-24",
    );
}

#[test]
fn nist_nist_ac_25_violation() {
    assert_violation(
        &make_let("reference_monitor", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-AC-25",
    );
}
#[test]
fn nist_nist_ac_25_ok() {
    assert_no_violation(
        &make_let("reference_monitor", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-AC-25",
    );
}

#[test]
fn nist_nist_au_4_violation() {
    assert_violation(
        &make_let("audit_storage", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-4",
    );
}
#[test]
fn nist_nist_au_4_ok() {
    assert_no_violation(
        &make_classified_let("audit_storage", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-4",
    );
}

#[test]
fn nist_nist_au_5_violation() {
    assert_violation(
        &make_let("audit_failure_action", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-AU-5",
    );
}
#[test]
fn nist_nist_au_5_ok() {
    assert_no_violation(
        &make_let("audit_failure_action", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-AU-5",
    );
}

#[test]
fn nist_nist_au_6_violation() {
    assert_violation(
        &make_let("audit_review", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-6",
    );
}
#[test]
fn nist_nist_au_6_ok() {
    assert_no_violation(
        &make_classified_let("audit_review", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-6",
    );
}

#[test]
fn nist_nist_au_7_violation() {
    assert_violation(
        &make_let("audit_filter", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-7",
    );
}
#[test]
fn nist_nist_au_7_ok() {
    assert_no_violation(
        &make_let(
            "audit_filter",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-7",
    );
}

#[test]
fn nist_nist_au_8_violation() {
    assert_violation(
        &make_let_with_body("audit_timestamp", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Nist80053,
        "NIST-AU-8",
    );
}
#[test]
fn nist_nist_au_8_ok() {
    assert_no_violation(
        &make_let_with_body(
            "audit_timestamp",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-8",
    );
}

#[test]
fn nist_nist_au_9_violation() {
    assert_violation(
        &make_let("audit_data", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-9",
    );
}
#[test]
fn nist_nist_au_9_ok() {
    assert_no_violation(
        &make_classified_let("audit_data", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-9",
    );
}

#[test]
fn nist_nist_au_10_violation() {
    assert_violation(
        &make_let("non_repudiation", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-AU-10",
    );
}
#[test]
fn nist_nist_au_10_ok() {
    assert_no_violation(
        &make_let("non_repudiation", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-AU-10",
    );
}

#[test]
fn nist_nist_au_11_violation() {
    assert_violation(
        &make_let("retention_policy", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-11",
    );
}
#[test]
fn nist_nist_au_11_ok() {
    assert_no_violation(
        &make_classified_let("retention_policy", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-11",
    );
}

#[test]
fn nist_nist_au_13_violation() {
    assert_violation(
        &make_let("monitor_target", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-13",
    );
}
#[test]
fn nist_nist_au_13_ok() {
    assert_no_violation(
        &make_let(
            "monitor_target",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-13",
    );
}

#[test]
fn nist_nist_au_14_violation() {
    assert_violation(
        &make_let("session_audit", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-14",
    );
}
#[test]
fn nist_nist_au_14_ok() {
    assert_no_violation(
        &make_classified_let("session_audit", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-AU-14",
    );
}

#[test]
fn nist_nist_au_16_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Nist80053,
        "NIST-AU-16",
    );
}
#[test]
fn nist_nist_au_16_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Nist80053,
        "NIST-AU-16",
    );
}

#[test]
fn nist_nist_ia_2_violation() {
    assert_violation(
        &Expr::LetRec(
            "identify_user".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-2",
    );
}
#[test]
fn nist_nist_ia_2_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "identify_user".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-2",
    );
}

#[test]
fn nist_nist_ia_3_violation() {
    assert_violation(
        &Expr::LetRec(
            "device_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-3",
    );
}
#[test]
fn nist_nist_ia_3_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "device_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-3",
    );
}

#[test]
fn nist_nist_ia_4_violation() {
    assert_violation(
        &make_let("user_id", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-4",
    );
}
#[test]
fn nist_nist_ia_4_ok() {
    assert_no_violation(
        &make_classified_let("user_id", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-4",
    );
}

#[test]
fn nist_nist_ia_7_violation() {
    assert_violation(
        &make_let("module_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-7",
    );
}
#[test]
fn nist_nist_ia_7_ok() {
    assert_no_violation(
        &make_let(
            "module_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-7",
    );
}

#[test]
fn nist_nist_ia_8_violation() {
    assert_violation(
        &Expr::LetRec(
            "external_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-8",
    );
}
#[test]
fn nist_nist_ia_8_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "external_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-8",
    );
}

#[test]
fn nist_nist_ia_9_violation() {
    assert_violation(
        &make_let("service_id", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-9",
    );
}
#[test]
fn nist_nist_ia_9_ok() {
    assert_no_violation(
        &make_classified_let("service_id", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-9",
    );
}

#[test]
fn nist_nist_ia_10_violation() {
    assert_violation(
        &make_let("risk_score", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-10",
    );
}
#[test]
fn nist_nist_ia_10_ok() {
    assert_no_violation(
        &make_let(
            "risk_score",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-10",
    );
}

#[test]
fn nist_nist_ia_11_violation() {
    assert_violation(
        &make_let("reauth_token", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-11",
    );
}
#[test]
fn nist_nist_ia_11_ok() {
    assert_no_violation(
        &make_classified_let("reauth_token", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-IA-11",
    );
}

#[test]
fn nist_nist_ia_12_violation() {
    assert_violation(
        &make_let_with_body("identity_proof_date", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Nist80053,
        "NIST-IA-12",
    );
}
#[test]
fn nist_nist_ia_12_ok() {
    assert_no_violation(
        &make_let_with_body(
            "identity_proof_date",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-IA-12",
    );
}

#[test]
fn nist_nist_sc_2_violation() {
    assert_violation(
        &make_let("partition_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-2",
    );
}
#[test]
fn nist_nist_sc_2_ok() {
    assert_no_violation(
        &make_classified_let("partition_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-2",
    );
}

#[test]
fn nist_nist_sc_7_violation() {
    assert_violation(
        &Expr::String("http://example.com/api".into()),
        ComplianceProfile::Nist80053,
        "NIST-SC-7",
    );
}
#[test]
fn nist_nist_sc_7_ok() {
    assert_no_violation(
        &Expr::String("https://example.com/api".into()),
        ComplianceProfile::Nist80053,
        "NIST-SC-7",
    );
}

#[test]
fn nist_nist_sc_8_1_violation() {
    assert_violation(
        &Expr::Perform(
            Effect::Network,
            Box::new(Expr::Var("integrity_data".into())),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SC-8-1",
    );
}
#[test]
fn nist_nist_sc_8_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Nist80053,
        "NIST-SC-8-1",
    );
}

#[test]
fn nist_nist_sc_10_violation() {
    assert_violation(
        &make_let("session_timeout", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-10",
    );
}
#[test]
fn nist_nist_sc_10_ok() {
    assert_no_violation(
        &make_classified_let("session_timeout", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-10",
    );
}

#[test]
fn nist_nist_sc_15_violation() {
    assert_violation(
        &make_let("collab_session", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-15",
    );
}
#[test]
fn nist_nist_sc_15_ok() {
    assert_no_violation(
        &make_classified_let("collab_session", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-15",
    );
}

#[test]
fn nist_nist_sc_17_violation() {
    assert_violation(
        &make_let("pki_cert", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-17",
    );
}
#[test]
fn nist_nist_sc_17_ok() {
    assert_no_violation(
        &make_classified_let("pki_cert", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-17",
    );
}

#[test]
fn nist_nist_sc_18_violation() {
    assert_violation(
        &make_let("mobile_code", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-18",
    );
}
#[test]
fn nist_nist_sc_18_ok() {
    assert_no_violation(
        &make_classified_let("mobile_code", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-18",
    );
}

#[test]
fn nist_nist_sc_19_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("voip_data".into()))),
        ComplianceProfile::Nist80053,
        "NIST-SC-19",
    );
}
#[test]
fn nist_nist_sc_19_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Nist80053,
        "NIST-SC-19",
    );
}

#[test]
fn nist_nist_sc_20_violation() {
    assert_violation(
        &make_let("dns_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-20",
    );
}
#[test]
fn nist_nist_sc_20_ok() {
    assert_no_violation(
        &make_classified_let("dns_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-20",
    );
}

#[test]
fn nist_nist_sc_23_violation() {
    assert_violation(
        &make_let("session_token", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-23",
    );
}
#[test]
fn nist_nist_sc_23_ok() {
    assert_no_violation(
        &make_classified_let("session_token", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-23",
    );
}

#[test]
fn nist_nist_sc_26_violation() {
    assert_violation(
        &make_let("honeypot_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-26",
    );
}
#[test]
fn nist_nist_sc_26_ok() {
    assert_no_violation(
        &make_let(
            "honeypot_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SC-26",
    );
}

#[test]
fn nist_nist_sc_29_violation() {
    assert_violation(
        &make_let("platform_config", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-29",
    );
}
#[test]
fn nist_nist_sc_29_ok() {
    assert_no_violation(
        &make_classified_let("platform_config", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-29",
    );
}

#[test]
fn nist_nist_sc_36_violation() {
    assert_violation(
        &make_let("distributed_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-36",
    );
}
#[test]
fn nist_nist_sc_36_ok() {
    assert_no_violation(
        &make_classified_let("distributed_key", Expr::String("val".into())),
        ComplianceProfile::Nist80053,
        "NIST-SC-36",
    );
}

#[test]
fn nist_nist_si_3_violation() {
    assert_violation(
        &make_let("upload_data", Expr::String("raw".into())),
        ComplianceProfile::Nist80053,
        "NIST-SI-3",
    );
}
#[test]
fn nist_nist_si_3_ok() {
    assert_no_violation(
        &make_let(
            "upload_data",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SI-3",
    );
}

#[test]
fn nist_nist_si_4_violation() {
    assert_violation(
        &Expr::String("debug".into()),
        ComplianceProfile::Nist80053,
        "NIST-SI-4",
    );
}
#[test]
fn nist_nist_si_4_ok() {
    assert_no_violation(
        &Expr::String("production".into()),
        ComplianceProfile::Nist80053,
        "NIST-SI-4",
    );
}

#[test]
fn nist_nist_si_5_violation() {
    assert_violation(
        &make_let("alert_input", Expr::String("raw".into())),
        ComplianceProfile::Nist80053,
        "NIST-SI-5",
    );
}
#[test]
fn nist_nist_si_5_ok() {
    assert_no_violation(
        &make_let(
            "alert_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SI-5",
    );
}

#[test]
fn nist_nist_si_7_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SI-7",
    );
}
#[test]
fn nist_nist_si_7_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Nist80053,
        "NIST-SI-7",
    );
}

#[test]
fn nist_nist_si_11_violation() {
    assert_violation(
        &make_let("error_input", Expr::String("raw".into())),
        ComplianceProfile::Nist80053,
        "NIST-SI-11",
    );
}
#[test]
fn nist_nist_si_11_ok() {
    assert_no_violation(
        &make_let(
            "error_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SI-11",
    );
}

#[test]
fn nist_nist_si_12_violation() {
    assert_violation(
        &Expr::String("192.168.1.1".into()),
        ComplianceProfile::Nist80053,
        "NIST-SI-12",
    );
}
#[test]
fn nist_nist_si_12_ok() {
    assert_no_violation(
        &Expr::String("safe_value".into()),
        ComplianceProfile::Nist80053,
        "NIST-SI-12",
    );
}

#[test]
fn nist_nist_si_14_violation() {
    assert_violation(
        &make_let("volatile_input", Expr::String("raw".into())),
        ComplianceProfile::Nist80053,
        "NIST-SI-14",
    );
}
#[test]
fn nist_nist_si_14_ok() {
    assert_no_violation(
        &make_let(
            "volatile_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SI-14",
    );
}

#[test]
fn nist_nist_si_16_violation() {
    assert_violation(
        &make_let("memory_input", Expr::String("raw".into())),
        ComplianceProfile::Nist80053,
        "NIST-SI-16",
    );
}
#[test]
fn nist_nist_si_16_ok() {
    assert_no_violation(
        &make_let(
            "memory_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-SI-16",
    );
}

#[test]
fn nist_nist_cm_2_violation() {
    assert_violation(
        &make_let("baseline_config", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-CM-2",
    );
}
#[test]
fn nist_nist_cm_2_ok() {
    assert_no_violation(
        &make_let("baseline_config", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-CM-2",
    );
}

#[test]
fn nist_nist_cm_3_violation() {
    assert_violation(
        &make_let("change_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Nist80053,
        "NIST-CM-3",
    );
}
#[test]
fn nist_nist_cm_3_ok() {
    assert_no_violation(
        &make_let(
            "change_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Nist80053,
        "NIST-CM-3",
    );
}

#[test]
fn nist_nist_cm_7_violation() {
    assert_violation(
        &make_let("feature_flag", Expr::Bool(false)),
        ComplianceProfile::Nist80053,
        "NIST-CM-7",
    );
}
#[test]
fn nist_nist_cm_7_ok() {
    assert_no_violation(
        &make_let("feature_flag", Expr::Bool(true)),
        ComplianceProfile::Nist80053,
        "NIST-CM-7",
    );
}

#[test]
fn nist_nist_sa_4_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "vendor_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SA-4",
    );
}
#[test]
fn nist_nist_sa_4_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SA-4",
    );
}

#[test]
fn nist_nist_sa_9_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "external_service_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SA-9",
    );
}
#[test]
fn nist_nist_sa_9_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Nist80053,
        "NIST-SA-9",
    );
}

#[test]
fn iso27001_iso_a5_3_violation() {
    assert_violation(
        &make_let("policy_enforcement", Expr::Bool(false)),
        ComplianceProfile::Iso27001,
        "ISO-A5.3",
    );
}
#[test]
fn iso27001_iso_a5_3_ok() {
    assert_no_violation(
        &make_let("policy_enforcement", Expr::Bool(true)),
        ComplianceProfile::Iso27001,
        "ISO-A5.3",
    );
}

#[test]
fn iso27001_iso_a5_4_violation() {
    assert_violation(
        &make_let("policy_review", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A5.4",
    );
}
#[test]
fn iso27001_iso_a5_4_ok() {
    assert_no_violation(
        &make_classified_let("policy_review", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A5.4",
    );
}

#[test]
fn iso27001_iso_a5_5_violation() {
    assert_violation(
        &make_let("policy_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Iso27001,
        "ISO-A5.5",
    );
}
#[test]
fn iso27001_iso_a5_5_ok() {
    assert_no_violation(
        &make_let(
            "policy_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A5.5",
    );
}

#[test]
fn iso27001_iso_a6_2_violation() {
    assert_violation(
        &make_let("mobile_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A6.2",
    );
}
#[test]
fn iso27001_iso_a6_2_ok() {
    assert_no_violation(
        &make_classified_let("mobile_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A6.2",
    );
}

#[test]
fn iso27001_iso_a6_3_violation() {
    assert_violation(
        &make_let("authority_contact", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A6.3",
    );
}
#[test]
fn iso27001_iso_a6_3_ok() {
    assert_no_violation(
        &make_classified_let("authority_contact", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A6.3",
    );
}

#[test]
fn iso27001_iso_a6_4_violation() {
    assert_violation(
        &Expr::LetRec(
            "group_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A6.4",
    );
}
#[test]
fn iso27001_iso_a6_4_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "group_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A6.4",
    );
}

#[test]
fn iso27001_iso_a6_5_violation() {
    assert_violation(
        &make_let("project_secret", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A6.5",
    );
}
#[test]
fn iso27001_iso_a6_5_ok() {
    assert_no_violation(
        &make_classified_let("project_secret", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A6.5",
    );
}

#[test]
fn iso27001_iso_a7_2_violation() {
    assert_violation(
        &make_let("employee_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A7.2",
    );
}
#[test]
fn iso27001_iso_a7_2_ok() {
    assert_no_violation(
        &make_classified_let("employee_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A7.2",
    );
}

#[test]
fn iso27001_iso_a7_3_violation() {
    assert_violation(
        &make_let("hr_password", Expr::String("hardcoded".into())),
        ComplianceProfile::Iso27001,
        "ISO-A7.3",
    );
}
#[test]
fn iso27001_iso_a7_3_ok() {
    assert_no_violation(
        &make_let(
            "hr_password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A7.3",
    );
}

#[test]
fn iso27001_iso_a7_4_violation() {
    assert_violation(
        &make_let_with_body("termination_date", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Iso27001,
        "ISO-A7.4",
    );
}
#[test]
fn iso27001_iso_a7_4_ok() {
    assert_no_violation(
        &make_let_with_body(
            "termination_date",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A7.4",
    );
}

#[test]
fn iso27001_iso_a8_3_violation() {
    assert_violation(
        &make_let("media_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A8.3",
    );
}
#[test]
fn iso27001_iso_a8_3_ok() {
    assert_no_violation(
        &make_classified_let("media_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A8.3",
    );
}

#[test]
fn iso27001_iso_a8_4_violation() {
    assert_violation(
        &make_let("asset_return", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A8.4",
    );
}
#[test]
fn iso27001_iso_a8_4_ok() {
    assert_no_violation(
        &make_classified_let("asset_return", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A8.4",
    );
}

#[test]
fn iso27001_iso_a8_5_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Iso27001,
        "ISO-A8.5",
    );
}
#[test]
fn iso27001_iso_a8_5_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A8.5",
    );
}

#[test]
fn iso27001_iso_a8_6_violation() {
    assert_violation(
        &make_let("label_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A8.6",
    );
}
#[test]
fn iso27001_iso_a8_6_ok() {
    assert_no_violation(
        &make_classified_let("label_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A8.6",
    );
}

#[test]
fn iso27001_iso_a8_7_violation() {
    assert_violation(
        &make_let("disposal_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Iso27001,
        "ISO-A8.7",
    );
}
#[test]
fn iso27001_iso_a8_7_ok() {
    assert_no_violation(
        &make_let(
            "disposal_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A8.7",
    );
}

#[test]
fn iso27001_iso_a9_3_violation() {
    assert_violation(
        &make_let("provisioning_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A9.3",
    );
}
#[test]
fn iso27001_iso_a9_3_ok() {
    assert_no_violation(
        &make_classified_let("provisioning_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A9.3",
    );
}

#[test]
fn iso27001_iso_a9_4_violation() {
    assert_violation(
        &make_let("access_review", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A9.4",
    );
}
#[test]
fn iso27001_iso_a9_4_ok() {
    assert_no_violation(
        &make_classified_let("access_review", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A9.4",
    );
}

#[test]
fn iso27001_iso_a9_5_violation() {
    assert_violation(
        &make_let("access_password", Expr::String("hardcoded".into())),
        ComplianceProfile::Iso27001,
        "ISO-A9.5",
    );
}
#[test]
fn iso27001_iso_a9_5_ok() {
    assert_no_violation(
        &make_let(
            "access_password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A9.5",
    );
}

#[test]
fn iso27001_iso_a9_6_violation() {
    assert_violation(
        &make_let("logon_secure", Expr::Bool(false)),
        ComplianceProfile::Iso27001,
        "ISO-A9.6",
    );
}
#[test]
fn iso27001_iso_a9_6_ok() {
    assert_no_violation(
        &make_let("logon_secure", Expr::Bool(true)),
        ComplianceProfile::Iso27001,
        "ISO-A9.6",
    );
}

#[test]
fn iso27001_iso_a9_7_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A9.7",
    );
}
#[test]
fn iso27001_iso_a9_7_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A9.7",
    );
}

#[test]
fn iso27001_iso_a10_2_violation() {
    assert_violation(
        &make_let("key_management", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A10.2",
    );
}
#[test]
fn iso27001_iso_a10_2_ok() {
    assert_no_violation(
        &make_classified_let("key_management", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A10.2",
    );
}

#[test]
fn iso27001_iso_a10_3_violation() {
    assert_violation(
        &make_let("encryption_policy", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A10.3",
    );
}
#[test]
fn iso27001_iso_a10_3_ok() {
    assert_no_violation(
        &make_classified_let("encryption_policy", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A10.3",
    );
}

#[test]
fn iso27001_iso_a10_4_violation() {
    assert_violation(
        &make_let("master_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Iso27001,
        "ISO-A10.4",
    );
}
#[test]
fn iso27001_iso_a10_4_ok() {
    assert_no_violation(
        &make_let(
            "master_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A10.4",
    );
}

#[test]
fn iso27001_iso_a10_5_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A10.5",
    );
}
#[test]
fn iso27001_iso_a10_5_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A10.5",
    );
}

#[test]
fn iso27001_iso_a11_2_violation() {
    assert_violation(
        &make_let("equipment_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A11.2",
    );
}
#[test]
fn iso27001_iso_a11_2_ok() {
    assert_no_violation(
        &make_classified_let("equipment_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A11.2",
    );
}

#[test]
fn iso27001_iso_a11_3_violation() {
    assert_violation(
        &Expr::String("192.168.1.1".into()),
        ComplianceProfile::Iso27001,
        "ISO-A11.3",
    );
}
#[test]
fn iso27001_iso_a11_3_ok() {
    assert_no_violation(
        &Expr::String("safe_value".into()),
        ComplianceProfile::Iso27001,
        "ISO-A11.3",
    );
}

#[test]
fn iso27001_iso_a12_3_violation() {
    assert_violation(
        &make_let("capacity_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A12.3",
    );
}
#[test]
fn iso27001_iso_a12_3_ok() {
    assert_no_violation(
        &make_classified_let("capacity_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A12.3",
    );
}

#[test]
fn iso27001_iso_a12_4_violation() {
    assert_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Unit,
        ),
        ComplianceProfile::Iso27001,
        "ISO-A12.4",
    );
}
#[test]
fn iso27001_iso_a12_4_ok() {
    assert_no_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A12.4",
    );
}

#[test]
fn iso27001_iso_a12_5_violation() {
    assert_violation(
        &make_let("software_install", Expr::Bool(false)),
        ComplianceProfile::Iso27001,
        "ISO-A12.5",
    );
}
#[test]
fn iso27001_iso_a12_5_ok() {
    assert_no_violation(
        &make_let("software_install", Expr::Bool(true)),
        ComplianceProfile::Iso27001,
        "ISO-A12.5",
    );
}

#[test]
fn iso27001_iso_a12_6_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iso27001,
        "ISO-A12.6",
    );
}
#[test]
fn iso27001_iso_a12_6_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001,
        "ISO-A12.6",
    );
}

#[test]
fn iso27001_iso_a13_2_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("transfer_data".into()))),
        ComplianceProfile::Iso27001,
        "ISO-A13.2",
    );
}
#[test]
fn iso27001_iso_a13_2_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Iso27001,
        "ISO-A13.2",
    );
}

#[test]
fn iso27001_iso_a13_3_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::Iso27001,
        "ISO-A13.3",
    );
}
#[test]
fn iso27001_iso_a13_3_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::Iso27001,
        "ISO-A13.3",
    );
}

#[test]
fn iso27001_iso_a13_4_violation() {
    assert_violation(
        &make_let("nda_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A13.4",
    );
}
#[test]
fn iso27001_iso_a13_4_ok() {
    assert_no_violation(
        &make_classified_let("nda_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A13.4",
    );
}

#[test]
fn iso27001_iso_a14_2_violation() {
    assert_violation(
        &make_let("app_input", Expr::String("raw".into())),
        ComplianceProfile::Iso27001,
        "ISO-A14.2",
    );
}
#[test]
fn iso27001_iso_a14_2_ok() {
    assert_no_violation(
        &make_let(
            "app_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A14.2",
    );
}

#[test]
fn iso27001_iso_a14_3_violation() {
    assert_violation(
        &make_let("test_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A14.3",
    );
}
#[test]
fn iso27001_iso_a14_3_ok() {
    assert_no_violation(
        &make_classified_let("test_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A14.3",
    );
}

#[test]
fn iso27001_iso_a14_4_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A14.4",
    );
}
#[test]
fn iso27001_iso_a14_4_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A14.4",
    );
}

#[test]
fn iso27001_iso_a15_2_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "supplier_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iso27001,
        "ISO-A15.2",
    );
}
#[test]
fn iso27001_iso_a15_2_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iso27001,
        "ISO-A15.2",
    );
}

#[test]
fn iso27001_iso_a15_3_violation() {
    assert_violation(
        &make_let("supply_chain", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A15.3",
    );
}
#[test]
fn iso27001_iso_a15_3_ok() {
    assert_no_violation(
        &make_classified_let("supply_chain", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A15.3",
    );
}

#[test]
fn iso27001_iso_a16_2_violation() {
    assert_violation(
        &make_let("security_event", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A16.2",
    );
}
#[test]
fn iso27001_iso_a16_2_ok() {
    assert_no_violation(
        &make_classified_let("security_event", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A16.2",
    );
}

#[test]
fn iso27001_iso_a16_3_violation() {
    assert_violation(
        &make_let_with_body("incident_time", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Iso27001,
        "ISO-A16.3",
    );
}
#[test]
fn iso27001_iso_a16_3_ok() {
    assert_no_violation(
        &make_let_with_body(
            "incident_time",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iso27001,
        "ISO-A16.3",
    );
}

#[test]
fn iso27001_iso_a18_2_violation() {
    assert_violation(
        &make_let("privacy_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A18.2",
    );
}
#[test]
fn iso27001_iso_a18_2_ok() {
    assert_no_violation(
        &make_classified_let("privacy_data", Expr::String("val".into())),
        ComplianceProfile::Iso27001,
        "ISO-A18.2",
    );
}

#[test]
fn do178c_do178c_6_3_6_violation() {
    assert_violation(
        &make_let("avionics_config", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.3.6",
    );
}
#[test]
fn do178c_do178c_6_3_6_ok() {
    assert_no_violation(
        &make_classified_let("avionics_config", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.3.6",
    );
}

#[test]
fn do178c_do178c_6_3_7_violation() {
    assert_violation(
        &make_let("safety_limit", Expr::String("hardcoded".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.3.7",
    );
}
#[test]
fn do178c_do178c_6_3_7_ok() {
    assert_no_violation(
        &make_let(
            "safety_limit",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.7",
    );
}

#[test]
fn do178c_do178c_6_3_8_violation() {
    assert_violation(
        &Expr::String("http://example.com/api".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.3.8",
    );
}
#[test]
fn do178c_do178c_6_3_8_ok() {
    assert_no_violation(
        &Expr::String("https://example.com/api".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.3.8",
    );
}

#[test]
fn do178c_do178c_6_3_9_violation() {
    assert_violation(
        &Expr::LetRec(
            "pilot_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.9",
    );
}
#[test]
fn do178c_do178c_6_3_9_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "pilot_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.9",
    );
}

#[test]
fn do178c_do178c_6_3_10_violation() {
    assert_violation(
        &make_let("flight_plan", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.3.10",
    );
}
#[test]
fn do178c_do178c_6_3_10_ok() {
    assert_no_violation(
        &make_classified_let("flight_plan", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.3.10",
    );
}

#[test]
fn do178c_do178c_6_3_11_violation() {
    assert_violation(
        &make_let("engine_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.3.11",
    );
}
#[test]
fn do178c_do178c_6_3_11_ok() {
    assert_no_violation(
        &make_classified_let("engine_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.3.11",
    );
}

#[test]
fn do178c_do178c_6_3_12_violation() {
    assert_violation(
        &make_let("interlock_enabled", Expr::Bool(false)),
        ComplianceProfile::Do178c,
        "DO178C-6.3.12",
    );
}
#[test]
fn do178c_do178c_6_3_12_ok() {
    assert_no_violation(
        &make_let("interlock_enabled", Expr::Bool(true)),
        ComplianceProfile::Do178c,
        "DO178C-6.3.12",
    );
}

#[test]
fn do178c_do178c_6_3_13_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Do178c,
        "DO178C-6.3.13",
    );
}
#[test]
fn do178c_do178c_6_3_13_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.3.13",
    );
}

#[test]
fn do178c_do178c_6_4_9_violation() {
    assert_violation(
        &make_let("coverage_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.9",
    );
}
#[test]
fn do178c_do178c_6_4_9_ok() {
    assert_no_violation(
        &make_classified_let("coverage_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.9",
    );
}

#[test]
fn do178c_do178c_6_4_10_violation() {
    assert_violation(
        &make_let("traceability_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.10",
    );
}
#[test]
fn do178c_do178c_6_4_10_ok() {
    assert_no_violation(
        &make_classified_let("traceability_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.10",
    );
}

#[test]
fn do178c_do178c_6_4_11_violation() {
    assert_violation(
        &make_let("hardware_input", Expr::String("raw".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.11",
    );
}
#[test]
fn do178c_do178c_6_4_11_ok() {
    assert_no_violation(
        &make_let(
            "hardware_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.11",
    );
}

#[test]
fn do178c_do178c_6_4_12_violation() {
    assert_violation(
        &make_let("test_limit", Expr::String("hardcoded".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.4.12",
    );
}
#[test]
fn do178c_do178c_6_4_12_ok() {
    assert_no_violation(
        &make_let(
            "test_limit",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.12",
    );
}

#[test]
fn do178c_do178c_6_4_13_violation() {
    assert_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.13",
    );
}
#[test]
fn do178c_do178c_6_4_13_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::String("error logged".into())),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.13",
    );
}

#[test]
fn do178c_do178c_6_4_14_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("flight_data".into()))),
        ComplianceProfile::Do178c,
        "DO178C-6.4.14",
    );
}
#[test]
fn do178c_do178c_6_4_14_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Do178c,
        "DO178C-6.4.14",
    );
}

#[test]
fn do178c_do178c_6_4_15_violation() {
    assert_violation(
        &make_let("test_mode", Expr::Bool(false)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.15",
    );
}
#[test]
fn do178c_do178c_6_4_15_ok() {
    assert_no_violation(
        &make_let("test_mode", Expr::Bool(true)),
        ComplianceProfile::Do178c,
        "DO178C-6.4.15",
    );
}

#[test]
fn do178c_do178c_6_4_16_violation() {
    assert_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Unit,
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.16",
    );
}
#[test]
fn do178c_do178c_6_4_16_ok() {
    assert_no_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.4.16",
    );
}

#[test]
fn do178c_do178c_6_7_6_violation() {
    assert_violation(
        &make_let("evidence_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.7.6",
    );
}
#[test]
fn do178c_do178c_6_7_6_ok() {
    assert_no_violation(
        &make_classified_let("evidence_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.7.6",
    );
}

#[test]
fn do178c_do178c_6_7_7_violation() {
    assert_violation(
        &make_let("ground_input", Expr::String("raw".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.7.7",
    );
}
#[test]
fn do178c_do178c_6_7_7_ok() {
    assert_no_violation(
        &make_let(
            "ground_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.7.7",
    );
}

#[test]
fn do178c_do178c_6_7_8_violation() {
    assert_violation(
        &make_let("redundancy_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.7.8",
    );
}
#[test]
fn do178c_do178c_6_7_8_ok() {
    assert_no_violation(
        &make_classified_let("redundancy_data", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.7.8",
    );
}

#[test]
fn do178c_do178c_6_7_9_violation() {
    assert_violation(
        &Expr::String("192.168.1.1".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.7.9",
    );
}
#[test]
fn do178c_do178c_6_7_9_ok() {
    assert_no_violation(
        &Expr::String("safe_value".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.7.9",
    );
}

#[test]
fn do178c_do178c_6_7_10_violation() {
    assert_violation(&Expr::Int(8080), ComplianceProfile::Do178c, "DO178C-6.7.10");
}
#[test]
fn do178c_do178c_6_7_10_ok() {
    assert_no_violation(
        &Expr::Int(12345),
        ComplianceProfile::Do178c,
        "DO178C-6.7.10",
    );
}

#[test]
fn do178c_do178c_6_7_11_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.7.11",
    );
}
#[test]
fn do178c_do178c_6_7_11_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::Do178c,
        "DO178C-6.7.11",
    );
}

#[test]
fn do178c_do178c_6_7_12_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.7.12",
    );
}
#[test]
fn do178c_do178c_6_7_12_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.7.12",
    );
}

#[test]
fn do178c_do178c_6_7_13_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.7.13",
    );
}
#[test]
fn do178c_do178c_6_7_13_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.7.13",
    );
}

#[test]
fn do178c_do178c_6_8_1_violation() {
    assert_violation(
        &make_let("config_id", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.8.1",
    );
}
#[test]
fn do178c_do178c_6_8_1_ok() {
    assert_no_violation(
        &make_classified_let("config_id", Expr::String("val".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.8.1",
    );
}

#[test]
fn do178c_do178c_6_8_2_violation() {
    assert_violation(
        &make_let_with_body("change_date", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Do178c,
        "DO178C-6.8.2",
    );
}
#[test]
fn do178c_do178c_6_8_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "change_date",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.8.2",
    );
}

#[test]
fn do178c_do178c_6_8_3_violation() {
    assert_violation(
        &make_let("config_password", Expr::String("hardcoded".into())),
        ComplianceProfile::Do178c,
        "DO178C-6.8.3",
    );
}
#[test]
fn do178c_do178c_6_8_3_ok() {
    assert_no_violation(
        &make_let(
            "config_password",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Do178c,
        "DO178C-6.8.3",
    );
}

#[test]
fn do178c_do178c_6_8_4_violation() {
    assert_violation(
        &make_let("config_control", Expr::Bool(false)),
        ComplianceProfile::Do178c,
        "DO178C-6.8.4",
    );
}
#[test]
fn do178c_do178c_6_8_4_ok() {
    assert_no_violation(
        &make_let("config_control", Expr::Bool(true)),
        ComplianceProfile::Do178c,
        "DO178C-6.8.4",
    );
}

#[test]
fn do178c_do178c_6_8_5_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "config_tool_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Do178c,
        "DO178C-6.8.5",
    );
}
#[test]
fn do178c_do178c_6_8_5_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Do178c,
        "DO178C-6.8.5",
    );
}

#[test]
fn do178c_do178c_6_8_6_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Do178c,
        "DO178C-6.8.6",
    );
}
#[test]
fn do178c_do178c_6_8_6_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Do178c,
        "DO178C-6.8.6",
    );
}

#[test]
fn sox_sox_302_5_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "financial_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Sox,
        "SOX-302-5",
    );
}
#[test]
fn sox_sox_302_5_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Sox,
        "SOX-302-5",
    );
}

#[test]
fn sox_sox_404_5_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Sox,
        "SOX-404-5",
    );
}
#[test]
fn sox_sox_404_5_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Sox,
        "SOX-404-5",
    );
}

#[test]
fn sox_sox_906_3_violation() {
    assert_violation(
        &Expr::Perform(
            Effect::Network,
            Box::new(Expr::Var("financial_report".into())),
        ),
        ComplianceProfile::Sox,
        "SOX-906-3",
    );
}
#[test]
fn sox_sox_906_3_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Sox,
        "SOX-906-3",
    );
}

#[test]
fn cmmc_cmmc_ac_5_violation() {
    assert_violation(
        &make_let("access_list", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-5",
    );
}
#[test]
fn cmmc_cmmc_ac_5_ok() {
    assert_no_violation(
        &make_classified_let("access_list", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-5",
    );
}

#[test]
fn cmmc_cmmc_ac_6_violation() {
    assert_violation(
        &make_let("flow_control", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-6",
    );
}
#[test]
fn cmmc_cmmc_ac_6_ok() {
    assert_no_violation(
        &make_classified_let("flow_control", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-6",
    );
}

#[test]
fn cmmc_cmmc_ac_7_violation() {
    assert_violation(
        &make_let("duty_separation", Expr::Bool(false)),
        ComplianceProfile::Cmmc,
        "CMMC-AC-7",
    );
}
#[test]
fn cmmc_cmmc_ac_7_ok() {
    assert_no_violation(
        &make_let("duty_separation", Expr::Bool(true)),
        ComplianceProfile::Cmmc,
        "CMMC-AC-7",
    );
}

#[test]
fn cmmc_cmmc_ac_8_violation() {
    assert_violation(
        &make_let("max_attempts", Expr::String("hardcoded".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-8",
    );
}
#[test]
fn cmmc_cmmc_ac_8_ok() {
    assert_no_violation(
        &make_let(
            "max_attempts",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-AC-8",
    );
}

#[test]
fn cmmc_cmmc_ac_9_violation() {
    assert_violation(
        &make_let("session_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-9",
    );
}
#[test]
fn cmmc_cmmc_ac_9_ok() {
    assert_no_violation(
        &make_classified_let("session_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-9",
    );
}

#[test]
fn cmmc_cmmc_ac_10_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("cui".into()))),
        ComplianceProfile::Cmmc,
        "CMMC-AC-10",
    );
}
#[test]
fn cmmc_cmmc_ac_10_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Cmmc,
        "CMMC-AC-10",
    );
}

#[test]
fn cmmc_cmmc_ac_11_violation() {
    assert_violation(
        &make_let("remote_access", Expr::Bool(false)),
        ComplianceProfile::Cmmc,
        "CMMC-AC-11",
    );
}
#[test]
fn cmmc_cmmc_ac_11_ok() {
    assert_no_violation(
        &make_let("remote_access", Expr::Bool(true)),
        ComplianceProfile::Cmmc,
        "CMMC-AC-11",
    );
}

#[test]
fn cmmc_cmmc_ac_12_violation() {
    assert_violation(
        &make_let("wireless_key", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-12",
    );
}
#[test]
fn cmmc_cmmc_ac_12_ok() {
    assert_no_violation(
        &make_classified_let("wireless_key", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-12",
    );
}

#[test]
fn cmmc_cmmc_ac_13_violation() {
    assert_violation(
        &make_let("mobile_device", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-13",
    );
}
#[test]
fn cmmc_cmmc_ac_13_ok() {
    assert_no_violation(
        &make_classified_let("mobile_device", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AC-13",
    );
}

#[test]
fn cmmc_cmmc_ac_14_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-AC-14",
    );
}
#[test]
fn cmmc_cmmc_ac_14_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-AC-14",
    );
}

#[test]
fn cmmc_cmmc_at_1_violation() {
    assert_violation(
        &make_let("training_record", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AT-1",
    );
}
#[test]
fn cmmc_cmmc_at_1_ok() {
    assert_no_violation(
        &make_classified_let("training_record", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AT-1",
    );
}

#[test]
fn cmmc_cmmc_at_2_violation() {
    assert_violation(
        &make_let("role_training", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AT-2",
    );
}
#[test]
fn cmmc_cmmc_at_2_ok() {
    assert_no_violation(
        &make_classified_let("role_training", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AT-2",
    );
}

#[test]
fn cmmc_cmmc_au_3_violation() {
    assert_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Unit,
        ),
        ComplianceProfile::Cmmc,
        "CMMC-AU-3",
    );
}
#[test]
fn cmmc_cmmc_au_3_ok() {
    assert_no_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-AU-3",
    );
}

#[test]
fn cmmc_cmmc_au_4_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Cmmc,
        "CMMC-AU-4",
    );
}
#[test]
fn cmmc_cmmc_au_4_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-AU-4",
    );
}

#[test]
fn cmmc_cmmc_au_5_violation() {
    assert_violation(
        &make_let("audit_log", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AU-5",
    );
}
#[test]
fn cmmc_cmmc_au_5_ok() {
    assert_no_violation(
        &make_classified_let("audit_log", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-AU-5",
    );
}

#[test]
fn cmmc_cmmc_au_6_violation() {
    assert_violation(
        &make_let_with_body("audit_timestamp", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Cmmc,
        "CMMC-AU-6",
    );
}
#[test]
fn cmmc_cmmc_au_6_ok() {
    assert_no_violation(
        &make_let_with_body(
            "audit_timestamp",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-AU-6",
    );
}

#[test]
fn cmmc_cmmc_au_7_violation() {
    assert_violation(
        &make_let("audit_alert", Expr::Bool(false)),
        ComplianceProfile::Cmmc,
        "CMMC-AU-7",
    );
}
#[test]
fn cmmc_cmmc_au_7_ok() {
    assert_no_violation(
        &make_let("audit_alert", Expr::Bool(true)),
        ComplianceProfile::Cmmc,
        "CMMC-AU-7",
    );
}

#[test]
fn cmmc_cmmc_cm_1_violation() {
    assert_violation(
        &make_let("baseline_config", Expr::Bool(false)),
        ComplianceProfile::Cmmc,
        "CMMC-CM-1",
    );
}
#[test]
fn cmmc_cmmc_cm_1_ok() {
    assert_no_violation(
        &make_let("baseline_config", Expr::Bool(true)),
        ComplianceProfile::Cmmc,
        "CMMC-CM-1",
    );
}

#[test]
fn cmmc_cmmc_cm_2_violation() {
    assert_violation(
        &make_let("config_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Cmmc,
        "CMMC-CM-2",
    );
}
#[test]
fn cmmc_cmmc_cm_2_ok() {
    assert_no_violation(
        &make_let(
            "config_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-CM-2",
    );
}

#[test]
fn cmmc_cmmc_cm_3_violation() {
    assert_violation(
        &make_let("feature_enabled", Expr::Bool(false)),
        ComplianceProfile::Cmmc,
        "CMMC-CM-3",
    );
}
#[test]
fn cmmc_cmmc_cm_3_ok() {
    assert_no_violation(
        &make_let("feature_enabled", Expr::Bool(true)),
        ComplianceProfile::Cmmc,
        "CMMC-CM-3",
    );
}

#[test]
fn cmmc_cmmc_cm_4_violation() {
    assert_violation(
        &make_let("software_inventory", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-CM-4",
    );
}
#[test]
fn cmmc_cmmc_cm_4_ok() {
    assert_no_violation(
        &make_classified_let("software_inventory", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-CM-4",
    );
}

#[test]
fn cmmc_cmmc_ia_1_violation() {
    assert_violation(
        &Expr::LetRec(
            "defense_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-1",
    );
}
#[test]
fn cmmc_cmmc_ia_1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "defense_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-1",
    );
}

#[test]
fn cmmc_cmmc_ia_2_violation() {
    assert_violation(
        &Expr::LetRec(
            "device_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-2",
    );
}
#[test]
fn cmmc_cmmc_ia_2_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "device_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-2",
    );
}

#[test]
fn cmmc_cmmc_ia_3_violation() {
    assert_violation(
        &make_let("authenticator", Expr::String("hardcoded".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IA-3",
    );
}
#[test]
fn cmmc_cmmc_ia_3_ok() {
    assert_no_violation(
        &make_let(
            "authenticator",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-3",
    );
}

#[test]
fn cmmc_cmmc_ia_4_violation() {
    assert_violation(
        &make_let("identity_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IA-4",
    );
}
#[test]
fn cmmc_cmmc_ia_4_ok() {
    assert_no_violation(
        &make_classified_let("identity_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IA-4",
    );
}

#[test]
fn cmmc_cmmc_ia_5_violation() {
    assert_violation(
        &make_let_with_body("auth_expiry", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Cmmc,
        "CMMC-IA-5",
    );
}
#[test]
fn cmmc_cmmc_ia_5_ok() {
    assert_no_violation(
        &make_let_with_body(
            "auth_expiry",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-5",
    );
}

#[test]
fn cmmc_cmmc_ia_6_violation() {
    assert_violation(
        &make_let("auth_feedback", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IA-6",
    );
}
#[test]
fn cmmc_cmmc_ia_6_ok() {
    assert_no_violation(
        &make_classified_let("auth_feedback", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IA-6",
    );
}

#[test]
fn cmmc_cmmc_ia_7_violation() {
    assert_violation(
        &make_let("crypto_module", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IA-7",
    );
}
#[test]
fn cmmc_cmmc_ia_7_ok() {
    assert_no_violation(
        &make_classified_let("crypto_module", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IA-7",
    );
}

#[test]
fn cmmc_cmmc_ia_8_violation() {
    assert_violation(
        &Expr::LetRec(
            "external_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-8",
    );
}
#[test]
fn cmmc_cmmc_ia_8_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "external_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IA-8",
    );
}

#[test]
fn cmmc_cmmc_ir_1_violation() {
    assert_violation(
        &make_let("incident_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IR-1",
    );
}
#[test]
fn cmmc_cmmc_ir_1_ok() {
    assert_no_violation(
        &make_classified_let("incident_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-IR-1",
    );
}

#[test]
fn cmmc_cmmc_ir_2_violation() {
    assert_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Unit,
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IR-2",
    );
}
#[test]
fn cmmc_cmmc_ir_2_ok() {
    assert_no_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IR-2",
    );
}

#[test]
fn cmmc_cmmc_ir_3_violation() {
    assert_violation(
        &make_let_with_body("incident_time", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Cmmc,
        "CMMC-IR-3",
    );
}
#[test]
fn cmmc_cmmc_ir_3_ok() {
    assert_no_violation(
        &make_let_with_body(
            "incident_time",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-IR-3",
    );
}

#[test]
fn cmmc_cmmc_ma_1_violation() {
    assert_violation(
        &make_let("maintenance_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-MA-1",
    );
}
#[test]
fn cmmc_cmmc_ma_1_ok() {
    assert_no_violation(
        &make_classified_let("maintenance_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-MA-1",
    );
}

#[test]
fn cmmc_cmmc_ma_2_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Cmmc,
        "CMMC-MA-2",
    );
}
#[test]
fn cmmc_cmmc_ma_2_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::Cmmc,
        "CMMC-MA-2",
    );
}

#[test]
fn cmmc_cmmc_mp_1_violation() {
    assert_violation(
        &make_let("media_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-MP-1",
    );
}
#[test]
fn cmmc_cmmc_mp_1_ok() {
    assert_no_violation(
        &make_classified_let("media_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-MP-1",
    );
}

#[test]
fn cmmc_cmmc_mp_2_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-MP-2",
    );
}
#[test]
fn cmmc_cmmc_mp_2_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-MP-2",
    );
}

#[test]
fn cmmc_cmmc_pe_1_violation() {
    assert_violation(
        &make_let("physical_access", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-PE-1",
    );
}
#[test]
fn cmmc_cmmc_pe_1_ok() {
    assert_no_violation(
        &make_classified_let("physical_access", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-PE-1",
    );
}

#[test]
fn cmmc_cmmc_pe_2_violation() {
    assert_violation(
        &Expr::String("192.168.1.1".into()),
        ComplianceProfile::Cmmc,
        "CMMC-PE-2",
    );
}
#[test]
fn cmmc_cmmc_pe_2_ok() {
    assert_no_violation(
        &Expr::String("safe_value".into()),
        ComplianceProfile::Cmmc,
        "CMMC-PE-2",
    );
}

#[test]
fn cmmc_cmmc_ps_1_violation() {
    assert_violation(
        &make_let("screening_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-PS-1",
    );
}
#[test]
fn cmmc_cmmc_ps_1_ok() {
    assert_no_violation(
        &make_classified_let("screening_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-PS-1",
    );
}

#[test]
fn cmmc_cmmc_ra_1_violation() {
    assert_violation(
        &make_let("risk_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-RA-1",
    );
}
#[test]
fn cmmc_cmmc_ra_1_ok() {
    assert_no_violation(
        &make_classified_let("risk_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-RA-1",
    );
}

#[test]
fn cmmc_cmmc_ra_2_violation() {
    assert_violation(
        &make_let("scan_input", Expr::String("raw".into())),
        ComplianceProfile::Cmmc,
        "CMMC-RA-2",
    );
}
#[test]
fn cmmc_cmmc_ra_2_ok() {
    assert_no_violation(
        &make_let(
            "scan_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-RA-2",
    );
}

#[test]
fn cmmc_cmmc_re_1_violation() {
    assert_violation(
        &make_let("backup_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-RE-1",
    );
}
#[test]
fn cmmc_cmmc_re_1_ok() {
    assert_no_violation(
        &make_classified_let("backup_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-RE-1",
    );
}

#[test]
fn cmmc_cmmc_re_2_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "backup_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Cmmc,
        "CMMC-RE-2",
    );
}
#[test]
fn cmmc_cmmc_re_2_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Cmmc,
        "CMMC-RE-2",
    );
}

#[test]
fn cmmc_cmmc_sc_5_violation() {
    assert_violation(
        &make_let("boundary_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-SC-5",
    );
}
#[test]
fn cmmc_cmmc_sc_5_ok() {
    assert_no_violation(
        &make_classified_let("boundary_data", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-SC-5",
    );
}

#[test]
fn cmmc_cmmc_sc_6_violation() {
    assert_violation(
        &Expr::String("http://example.com/api".into()),
        ComplianceProfile::Cmmc,
        "CMMC-SC-6",
    );
}
#[test]
fn cmmc_cmmc_sc_6_ok() {
    assert_no_violation(
        &Expr::String("https://example.com/api".into()),
        ComplianceProfile::Cmmc,
        "CMMC-SC-6",
    );
}

#[test]
fn cmmc_cmmc_sc_7_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("cui_data".into()))),
        ComplianceProfile::Cmmc,
        "CMMC-SC-7",
    );
}
#[test]
fn cmmc_cmmc_sc_7_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Cmmc,
        "CMMC-SC-7",
    );
}

#[test]
fn cmmc_cmmc_sc_8_violation() {
    assert_violation(
        &make_let("crypto_key", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-SC-8",
    );
}
#[test]
fn cmmc_cmmc_sc_8_ok() {
    assert_no_violation(
        &make_classified_let("crypto_key", Expr::String("val".into())),
        ComplianceProfile::Cmmc,
        "CMMC-SC-8",
    );
}

#[test]
fn cmmc_cmmc_sc_9_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-SC-9",
    );
}
#[test]
fn cmmc_cmmc_sc_9_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-SC-9",
    );
}

#[test]
fn cmmc_cmmc_si_3_violation() {
    assert_violation(
        &make_let("system_input", Expr::String("raw".into())),
        ComplianceProfile::Cmmc,
        "CMMC-SI-3",
    );
}
#[test]
fn cmmc_cmmc_si_3_ok() {
    assert_no_violation(
        &make_let(
            "system_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-SI-3",
    );
}

#[test]
fn cmmc_cmmc_si_4_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "monitor_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Cmmc,
        "CMMC-SI-4",
    );
}
#[test]
fn cmmc_cmmc_si_4_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Cmmc,
        "CMMC-SI-4",
    );
}

#[test]
fn cmmc_cmmc_si_5_violation() {
    assert_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-SI-5",
    );
}
#[test]
fn cmmc_cmmc_si_5_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::String("error logged".into())),
        ),
        ComplianceProfile::Cmmc,
        "CMMC-SI-5",
    );
}

#[test]
fn iec62443_iec62443_sr_13_violation() {
    assert_violation(
        &Expr::LetRec(
            "scada_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-13",
    );
}
#[test]
fn iec62443_iec62443_sr_13_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "scada_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-13",
    );
}

#[test]
fn iec62443_iec62443_sr_14_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-14",
    );
}
#[test]
fn iec62443_iec62443_sr_14_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-14",
    );
}

#[test]
fn iec62443_iec62443_sr_15_violation() {
    assert_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Unit,
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-15",
    );
}
#[test]
fn iec62443_iec62443_sr_15_ok() {
    assert_no_violation(
        &make_let_with_body(
            "secret",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-15",
    );
}

#[test]
fn iec62443_iec62443_sr_16_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("scada_data".into()))),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-16",
    );
}
#[test]
fn iec62443_iec62443_sr_16_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-16",
    );
}

#[test]
fn iec62443_iec62443_sr_17_violation() {
    assert_violation(
        &make_let("operator_input", Expr::String("raw".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-17",
    );
}
#[test]
fn iec62443_iec62443_sr_17_ok() {
    assert_no_violation(
        &make_let(
            "operator_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-17",
    );
}

#[test]
fn iec62443_iec62443_sr_18_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-18",
    );
}
#[test]
fn iec62443_iec62443_sr_18_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-18",
    );
}

#[test]
fn iec62443_iec62443_sr_19_violation() {
    assert_violation(
        &Expr::String("http://example.com/api".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-19",
    );
}
#[test]
fn iec62443_iec62443_sr_19_ok() {
    assert_no_violation(
        &Expr::String("https://example.com/api".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-19",
    );
}

#[test]
fn iec62443_iec62443_sr_20_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-20",
    );
}
#[test]
fn iec62443_iec62443_sr_20_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-20",
    );
}

#[test]
fn iec62443_iec62443_sr_21_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-21",
    );
}
#[test]
fn iec62443_iec62443_sr_21_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-21",
    );
}

#[test]
fn iec62443_iec62443_sr_22_violation() {
    assert_violation(
        &make_let("zone_data", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-22",
    );
}
#[test]
fn iec62443_iec62443_sr_22_ok() {
    assert_no_violation(
        &make_classified_let("zone_data", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-22",
    );
}

#[test]
fn iec62443_iec62443_sr_23_violation() {
    assert_violation(
        &make_let("sis_data", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-23",
    );
}
#[test]
fn iec62443_iec62443_sr_23_ok() {
    assert_no_violation(
        &make_classified_let("sis_data", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-23",
    );
}

#[test]
fn iec62443_iec62443_sr_24_violation() {
    assert_violation(
        &make_let("maintenance_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-24",
    );
}
#[test]
fn iec62443_iec62443_sr_24_ok() {
    assert_no_violation(
        &make_let(
            "maintenance_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-24",
    );
}

#[test]
fn iec62443_iec62443_sr_25_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "modbus_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iec62443,
        "IEC62443-SR-25",
    );
}
#[test]
fn iec62443_iec62443_sr_25_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Iec62443,
        "IEC62443-SR-25",
    );
}

#[test]
fn iec62443_iec62443_sr_26_violation() {
    assert_violation(
        &make_let("firmware_data", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-26",
    );
}
#[test]
fn iec62443_iec62443_sr_26_ok() {
    assert_no_violation(
        &make_classified_let("firmware_data", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-26",
    );
}

#[test]
fn iec62443_iec62443_sr_27_violation() {
    assert_violation(
        &make_let_with_body("cert_expiry", Expr::String("v".into()), Expr::Unit),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-27",
    );
}
#[test]
fn iec62443_iec62443_sr_27_ok() {
    assert_no_violation(
        &make_let_with_body(
            "cert_expiry",
            Expr::String("v".into()),
            Expr::Perform(Effect::Time, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-27",
    );
}

#[test]
fn iec62443_iec62443_sr_28_violation() {
    assert_violation(
        &make_let("patch_mgmt", Expr::Bool(false)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-28",
    );
}
#[test]
fn iec62443_iec62443_sr_28_ok() {
    assert_no_violation(
        &make_let("patch_mgmt", Expr::Bool(true)),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-28",
    );
}

#[test]
fn iec62443_iec62443_sr_29_violation() {
    assert_violation(
        &Expr::String("192.168.1.1".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-29",
    );
}
#[test]
fn iec62443_iec62443_sr_29_ok() {
    assert_no_violation(
        &Expr::String("safe_value".into()),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-29",
    );
}

#[test]
fn iec62443_iec62443_sr_30_violation() {
    assert_violation(
        &make_let("ics_incident", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-30",
    );
}
#[test]
fn iec62443_iec62443_sr_30_ok() {
    assert_no_violation(
        &make_classified_let("ics_incident", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-30",
    );
}

#[test]
fn iec62443_iec62443_sr_31_violation() {
    assert_violation(
        &Expr::LetRec(
            "remote_access".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-31",
    );
}
#[test]
fn iec62443_iec62443_sr_31_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "remote_access".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-31",
    );
}

#[test]
fn iec62443_iec62443_sr_32_violation() {
    assert_violation(
        &make_let("ics_backup", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-32",
    );
}
#[test]
fn iec62443_iec62443_sr_32_ok() {
    assert_no_violation(
        &make_classified_let("ics_backup", Expr::String("val".into())),
        ComplianceProfile::Iec62443,
        "IEC62443-SR-32",
    );
}

#[test]
fn nerc_cip_nerc_cip_013_violation() {
    assert_violation(
        &Expr::LetRec(
            "grid_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Bool(true)),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-013",
    );
}
#[test]
fn nerc_cip_nerc_cip_013_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "grid_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam(
                "x".into(),
                Ty::String,
                Box::new(Expr::Perform(
                    Effect::Crypto,
                    Box::new(Expr::Var("x".into())),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-013",
    );
}

#[test]
fn nerc_cip_nerc_cip_014_violation() {
    assert_violation(
        &make_let("physical_security", Expr::String("val".into())),
        ComplianceProfile::NercCip,
        "NERC-CIP-014",
    );
}
#[test]
fn nerc_cip_nerc_cip_014_ok() {
    assert_no_violation(
        &make_classified_let("physical_security", Expr::String("val".into())),
        ComplianceProfile::NercCip,
        "NERC-CIP-014",
    );
}

#[test]
fn nerc_cip_nerc_cip_015_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-015",
    );
}
#[test]
fn nerc_cip_nerc_cip_015_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-015",
    );
}

#[test]
fn nerc_cip_nerc_cip_016_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::NercCip,
        "NERC-CIP-016",
    );
}
#[test]
fn nerc_cip_nerc_cip_016_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::NercCip,
        "NERC-CIP-016",
    );
}

#[test]
fn nerc_cip_nerc_cip_017_violation() {
    assert_violation(
        &make_let("grid_input", Expr::String("raw".into())),
        ComplianceProfile::NercCip,
        "NERC-CIP-017",
    );
}
#[test]
fn nerc_cip_nerc_cip_017_ok() {
    assert_no_violation(
        &make_let(
            "grid_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-017",
    );
}

#[test]
fn nerc_cip_nerc_cip_018_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("grid_data".into()))),
        ComplianceProfile::NercCip,
        "NERC-CIP-018",
    );
}
#[test]
fn nerc_cip_nerc_cip_018_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::NercCip,
        "NERC-CIP-018",
    );
}

#[test]
fn nerc_cip_nerc_cip_019_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "ext_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::NercCip,
        "NERC-CIP-019",
    );
}
#[test]
fn nerc_cip_nerc_cip_019_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::NercCip,
        "NERC-CIP-019",
    );
}

#[test]
fn nerc_cip_nerc_cip_020_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::NercCip,
        "NERC-CIP-020",
    );
}
#[test]
fn nerc_cip_nerc_cip_020_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-020",
    );
}

#[test]
fn nerc_cip_nerc_cip_021_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-021",
    );
}
#[test]
fn nerc_cip_nerc_cip_021_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::NercCip,
        "NERC-CIP-021",
    );
}

#[test]
fn nerc_cip_nerc_cip_022_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "iec61850_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::NercCip,
        "NERC-CIP-022",
    );
}
#[test]
fn nerc_cip_nerc_cip_022_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::NercCip,
        "NERC-CIP-022",
    );
}

#[test]
fn fda_fda_11_10_k_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-k",
    );
}
#[test]
fn fda_fda_11_10_k_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-k",
    );
}

#[test]
fn fda_fda_11_10_l_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-l",
    );
}
#[test]
fn fda_fda_11_10_l_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-l",
    );
}

#[test]
fn fda_fda_11_10_m_violation() {
    assert_violation(
        &make_let("clinical_input", Expr::String("raw".into())),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-m",
    );
}
#[test]
fn fda_fda_11_10_m_ok() {
    assert_no_violation(
        &make_let(
            "clinical_input",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-m",
    );
}

#[test]
fn fda_fda_11_10_n_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("clinical_data".into()))),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-n",
    );
}
#[test]
fn fda_fda_11_10_n_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Fda21cfr,
        "FDA-11.10-n",
    );
}

#[test]
fn fda_fda_11_50_a_violation() {
    assert_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-a",
    );
}
#[test]
fn fda_fda_11_50_a_ok() {
    assert_no_violation(
        &Expr::Handle(
            Box::new(Expr::Perform(Effect::Network, Box::new(Expr::Unit))),
            "err".into(),
            Box::new(Expr::String("error logged".into())),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-a",
    );
}

#[test]
fn fda_fda_11_50_b_violation() {
    assert_violation(
        &make_let_with_body("data", Expr::Classify(Box::new(Expr::Int(42))), Expr::Unit),
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-b",
    );
}
#[test]
fn fda_fda_11_50_b_ok() {
    assert_no_violation(
        &make_let_with_body(
            "data",
            Expr::Classify(Box::new(Expr::Int(42))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into()))),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-b",
    );
}

#[test]
fn fda_fda_11_50_c_violation() {
    assert_violation(
        &Expr::FFICall {
            name: "clinical_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-c",
    );
}
#[test]
fn fda_fda_11_50_c_ok() {
    assert_no_violation(
        &Expr::FFICall {
            name: "safe_fn".into(),
            args: vec![],
            ret_ty: Ty::Unit,
        },
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-c",
    );
}

#[test]
fn fda_fda_11_50_d_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(
                Box::new(Expr::Var("infinite".into())),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-d",
    );
}
#[test]
fn fda_fda_11_50_d_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::If(
                    Box::new(Expr::Bool(true)),
                    Box::new(Expr::Int(1)),
                    Box::new(Expr::Int(0)),
                )),
            )),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Fda21cfr,
        "FDA-11.50-d",
    );
}

#[test]
fn itar_itar_121_1_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::Itar,
        "ITAR-121.1",
    );
}
#[test]
fn itar_itar_121_1_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::Itar,
        "ITAR-121.1",
    );
}

#[test]
fn itar_itar_121_2_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("munition".into()))),
        ComplianceProfile::Itar,
        "ITAR-121.2",
    );
}
#[test]
fn itar_itar_121_2_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::String("safe_val".into()))),
        ComplianceProfile::Itar,
        "ITAR-121.2",
    );
}

#[test]
fn itar_itar_121_3_violation() {
    assert_violation(
        &make_let("export_key", Expr::String("hardcoded".into())),
        ComplianceProfile::Itar,
        "ITAR-121.3",
    );
}
#[test]
fn itar_itar_121_3_ok() {
    assert_no_violation(
        &make_let(
            "export_key",
            Expr::Perform(Effect::Read, Box::new(Expr::Unit)),
        ),
        ComplianceProfile::Itar,
        "ITAR-121.3",
    );
}

#[test]
fn itar_itar_121_4_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::Itar,
        "ITAR-121.4",
    );
}
#[test]
fn itar_itar_121_4_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::Itar,
        "ITAR-121.4",
    );
}

// ===========================================================================
// ESG/SDG tests
// ===========================================================================

#[test]
fn esg_parse_profile() {
    let profiles = parse_profiles("esg-sdg").unwrap();
    assert_eq!(profiles, vec![ComplianceProfile::EsgSdg]);
}

#[test]
fn esg_sdg3_1_violation() {
    assert_violation(
        &make_let("health_outcome", Expr::String("data".into())),
        ComplianceProfile::EsgSdg,
        "ESG-SDG3.1",
    );
}
#[test]
fn esg_sdg3_1_ok() {
    assert_no_violation(
        &make_classified_let("health_outcome", Expr::String("data".into())),
        ComplianceProfile::EsgSdg,
        "ESG-SDG3.1",
    );
}

#[test]
fn esg_sdg5_1_violation() {
    assert_violation(
        &make_let("gender_parity", Expr::Int(75)),
        ComplianceProfile::EsgSdg,
        "ESG-SDG5.1",
    );
}
#[test]
fn esg_sdg5_1_ok() {
    assert_no_violation(
        &make_classified_let("gender_parity", Expr::Int(75)),
        ComplianceProfile::EsgSdg,
        "ESG-SDG5.1",
    );
}

#[test]
fn esg_sdg5_2_violation() {
    assert_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(0)),
        ),
        ComplianceProfile::EsgSdg,
        "ESG-SDG5.2",
    );
}
#[test]
fn esg_sdg5_2_ok() {
    assert_no_violation(
        &Expr::Declassify(
            Box::new(Expr::Classify(Box::new(Expr::Int(42)))),
            Box::new(Expr::Prove(Box::new(Expr::Bool(true)))),
        ),
        ComplianceProfile::EsgSdg,
        "ESG-SDG5.2",
    );
}

#[test]
fn esg_sdg13_1_violation() {
    assert_violation(
        &make_let("carbon_emission", Expr::Int(1000)),
        ComplianceProfile::EsgSdg,
        "ESG-SDG13.1",
    );
}
#[test]
fn esg_sdg13_1_ok() {
    assert_no_violation(
        &make_classified_let("carbon_emission", Expr::Int(1000)),
        ComplianceProfile::EsgSdg,
        "ESG-SDG13.1",
    );
}

#[test]
fn esg_sdg13_2_violation() {
    assert_violation(
        &make_let("climate_reporting", Expr::Bool(false)),
        ComplianceProfile::EsgSdg,
        "ESG-SDG13.2",
    );
}
#[test]
fn esg_sdg13_2_ok() {
    assert_no_violation(
        &make_let("climate_reporting", Expr::Bool(true)),
        ComplianceProfile::EsgSdg,
        "ESG-SDG13.2",
    );
}

#[test]
fn esg_e1_violation() {
    assert_violation(
        &make_let("biodiversity_loss", Expr::Int(50)),
        ComplianceProfile::EsgSdg,
        "ESG-E.1",
    );
}
#[test]
fn esg_e1_ok() {
    assert_no_violation(
        &make_classified_let("biodiversity_loss", Expr::Int(50)),
        ComplianceProfile::EsgSdg,
        "ESG-E.1",
    );
}

#[test]
fn esg_s1_violation() {
    assert_violation(
        &make_let("worker_safety", Expr::String("incident".into())),
        ComplianceProfile::EsgSdg,
        "ESG-S.1",
    );
}
#[test]
fn esg_s1_ok() {
    assert_no_violation(
        &make_classified_let("worker_safety", Expr::String("incident".into())),
        ComplianceProfile::EsgSdg,
        "ESG-S.1",
    );
}

#[test]
fn esg_g2_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::EsgSdg,
        "ESG-G.2",
    );
}
#[test]
fn esg_g2_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::EsgSdg,
        "ESG-G.2",
    );
}

#[test]
fn esg_sdvista1_violation() {
    assert_violation(
        &make_let("verified_impact", Expr::Int(100)),
        ComplianceProfile::EsgSdg,
        "ESG-SDVISTA.1",
    );
}
#[test]
fn esg_sdvista1_ok() {
    assert_no_violation(
        &make_classified_let("verified_impact", Expr::Int(100)),
        ComplianceProfile::EsgSdg,
        "ESG-SDVISTA.1",
    );
}

#[test]
fn esg_sdvista5_violation() {
    assert_violation(
        &make_let("verification_enabled", Expr::Bool(false)),
        ComplianceProfile::EsgSdg,
        "ESG-SDVISTA.5",
    );
}
#[test]
fn esg_sdvista5_ok() {
    assert_no_violation(
        &make_let("verification_enabled", Expr::Bool(true)),
        ComplianceProfile::EsgSdg,
        "ESG-SDVISTA.5",
    );
}

// ===========================================================================
// JALINAN Phase 6 — the compliance walker must recurse into actor /
// content-addressed sub-expressions instead of panicking. Regression for the
// former `todo!("JALINAN Phase 6")` arm in `validator.rs` (Gate B exit
// criterion: zero `todo!()` outside test code).
// ===========================================================================

/// A `declassify` without a `prove` — triggers `PCI-DSS-3.4`. Used as the
/// nested payload to prove the walker descends into each JALINAN expression.
fn violating_declassify() -> Expr {
    Expr::Declassify(
        Box::new(Expr::Classify(Box::new(Expr::Int(4242)))),
        Box::new(Expr::Int(0)),
    )
}

#[test]
fn jalinan_walk_recurses_into_subexprs() {
    let inner = violating_declassify();
    let cases = vec![
        Expr::ContentVerify(Box::new(inner.clone()), Box::new(Expr::Int(0))),
        Expr::Spawn(Box::new(inner.clone()), Box::new(Expr::Int(0))),
        Expr::ActorSend(Box::new(inner.clone()), Box::new(Expr::Int(0))),
        Expr::CRDTMerge(Box::new(inner.clone()), Box::new(Expr::Int(0))),
        Expr::ActorRecv(Box::new(inner.clone())),
        Expr::ContentHash(Box::new(inner.clone())),
        Expr::ActorDecl {
            name: "Akaun".into(),
            state_ty: Ty::Unit,
            message_ty: Ty::Unit,
            init_state: Box::new(inner.clone()),
            handler: Box::new(Expr::Unit),
        },
    ];
    for expr in &cases {
        let violations = validate(expr, &[ComplianceProfile::PciDss]);
        assert!(
            violations.iter().any(|v| v.rule_id == "PCI-DSS-3.4"),
            "compliance walker did not recurse into JALINAN expression: {expr:?}"
        );
    }
}

#[test]
fn jalinan_choreography_block_walks_without_panic() {
    // ChoreographyBlock has no value sub-expressions; walking it must be a
    // no-op that does not panic.
    let expr = Expr::ChoreographyBlock {
        name: "Protokol".into(),
        roles: vec!["A".into(), "B".into()],
        protocol: riina_types::SessionType::End,
    };
    let violations = validate(&expr, &[ComplianceProfile::PciDss]);
    assert!(violations.is_empty());
}
