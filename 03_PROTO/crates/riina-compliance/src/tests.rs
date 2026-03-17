// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Tests for compliance validation — 127 rules × 2+ tests each.

use riina_types::{Expr, Ty, Effect};

use crate::{ComplianceProfile, parse_profiles, validate, has_errors};

// ===========================================================================
// Test helpers
// ===========================================================================

fn make_let(name: &str, value: Expr) -> Expr {
    Expr::Let(name.into(), None, Box::new(value), Box::new(Expr::Unit))
}

fn make_classified_let(name: &str, value: Expr) -> Expr {
    Expr::Let(name.into(), None, Box::new(Expr::Classify(Box::new(value))), Box::new(Expr::Unit))
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

#[test]
fn parse_profiles_single() {
    let profiles = parse_profiles("pci-dss").unwrap();
    assert_eq!(profiles, vec![ComplianceProfile::PciDss]);
}

#[test]
fn parse_profiles_multiple() {
    let profiles = parse_profiles("pci-dss,pdpa,bnm").unwrap();
    assert_eq!(profiles, vec![ComplianceProfile::PciDss, ComplianceProfile::Pdpa, ComplianceProfile::Bnm]);
}

#[test]
fn parse_profiles_unknown() {
    assert!(parse_profiles("unknown").is_err());
}

#[test]
fn parse_profiles_all_15() {
    assert_eq!(ComplianceProfile::ALL.len(), 15);
}

#[test]
fn no_violations_without_profiles() {
    let expr = Expr::Declassify(
        Box::new(Expr::Int(42)),
        Box::new(Expr::Int(0)),
    );
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
        Box::new(Expr::Classify(Box::new(Expr::String("4111111111111111".into())))),
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
        Box::new(Expr::Lam("pwd".into(), Ty::String, Box::new(Expr::Bool(true)))),
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
            Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("pwd".into())))),
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
        ComplianceProfile::PciDss, "PCI-DSS-3.5.1",
    );
}
#[test]
fn pci_dss_3_5_1_ok() {
    assert_no_violation(
        &make_classified_let("encryption_key", Expr::String("mykey".into())),
        ComplianceProfile::PciDss, "PCI-DSS-3.5.1",
    );
}

#[test]
fn pci_dss_4_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::PciDss, "PCI-DSS-4.1",
    );
}
#[test]
fn pci_dss_4_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Var("data".into()))),
        ComplianceProfile::PciDss, "PCI-DSS-4.1",
    );
}

#[test]
fn pci_dss_6_5_2_violation() {
    assert_violation(
        &Expr::String("http://example.com/api".into()),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.2",
    );
}
#[test]
fn pci_dss_6_5_2_ok() {
    assert_no_violation(
        &Expr::String("https://example.com/api".into()),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.2",
    );
}

#[test]
fn pci_dss_6_5_3_violation() {
    assert_violation(
        &Expr::String("md5".into()),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.3",
    );
}
#[test]
fn pci_dss_6_5_3_ok() {
    assert_no_violation(
        &Expr::String("aes256-gcm".into()),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.3",
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
        ComplianceProfile::PciDss, "PCI-DSS-6.5.4",
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
        ComplianceProfile::PciDss, "PCI-DSS-6.5.4",
    );
}

#[test]
fn pci_dss_6_5_5_violation() {
    assert_violation(
        &make_let("password", Expr::String("hunter2".into())),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.5",
    );
}
#[test]
fn pci_dss_6_5_5_ok() {
    assert_no_violation(
        &make_let("password", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.5",
    );
}

#[test]
fn pci_dss_6_5_6_violation() {
    assert_violation(
        &make_let("credential", Expr::String("cred".into())),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.6",
    );
}
#[test]
fn pci_dss_6_5_6_ok() {
    assert_no_violation(
        &make_classified_let("credential", Expr::String("cred".into())),
        ComplianceProfile::PciDss, "PCI-DSS-6.5.6",
    );
}

#[test]
fn pci_dss_6_2_1_violation() {
    assert_violation(
        &Expr::FFICall { name: "openssl_rand".into(), args: vec![], ret_ty: Ty::Unit },
        ComplianceProfile::PciDss, "PCI-DSS-6.2.1",
    );
}
#[test]
fn pci_dss_6_2_1_ok() {
    assert_no_violation(
        &Expr::App(Box::new(Expr::Var("safe_fn".into())), Box::new(Expr::Unit)),
        ComplianceProfile::PciDss, "PCI-DSS-6.2.1",
    );
}

#[test]
fn pci_dss_8_3_1_violation() {
    assert_violation(
        &make_let("otp", Expr::String("123456".into())),
        ComplianceProfile::PciDss, "PCI-DSS-8.3.1",
    );
}
#[test]
fn pci_dss_8_3_1_ok() {
    assert_no_violation(
        &make_classified_let("otp", Expr::String("123456".into())),
        ComplianceProfile::PciDss, "PCI-DSS-8.3.1",
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
        ComplianceProfile::PciDss, "PCI-DSS-10.2",
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
        ComplianceProfile::PciDss, "PCI-DSS-10.2",
    );
}

#[test]
fn pci_dss_11_3_violation() {
    assert_violation(
        &Expr::Grant(Effect::System, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss, "PCI-DSS-11.3",
    );
}
#[test]
fn pci_dss_11_3_ok() {
    assert_no_violation(
        &Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
        ComplianceProfile::PciDss, "PCI-DSS-11.3",
    );
}

#[test]
fn pci_dss_6_3_1_violation() {
    assert_violation(
        &Expr::LetRec(
            "infinite".into(),
            Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(Box::new(Expr::Var("infinite".into())), Box::new(Expr::Unit))),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss, "PCI-DSS-6.3.1",
    );
}
#[test]
fn pci_dss_6_3_1_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "factorial".into(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam("n".into(), Ty::Int, Box::new(Expr::If(
                Box::new(Expr::Bool(true)),
                Box::new(Expr::Int(1)),
                Box::new(Expr::Int(0)),
            )))),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::PciDss, "PCI-DSS-6.3.1",
    );
}

// ===========================================================================
// HIPAA tests
// ===========================================================================

#[test]
fn hipaa_164_312_a1_violation() {
    assert_violation(
        &make_let("patient_data", Expr::String("PHI".into())),
        ComplianceProfile::Hipaa, "HIPAA-164.312-a1",
    );
}
#[test]
fn hipaa_164_312_a1_ok() {
    assert_no_violation(
        &make_classified_let("patient_data", Expr::String("PHI".into())),
        ComplianceProfile::Hipaa, "HIPAA-164.312-a1",
    );
}

#[test]
fn hipaa_164_312_a2_violation() {
    assert_violation(
        &Expr::LetRec(
            "medical_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam("x".into(), Ty::String, Box::new(Expr::Bool(true)))),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa, "HIPAA-164.312-a2",
    );
}
#[test]
fn hipaa_164_312_a2_ok() {
    assert_no_violation(
        &Expr::LetRec(
            "medical_auth".into(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam("x".into(), Ty::String,
                Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("x".into())))))),
            Box::new(Expr::Unit),
        ),
        ComplianceProfile::Hipaa, "HIPAA-164.312-a2",
    );
}

#[test]
fn hipaa_164_312_c1_violation() {
    assert_violation(
        &make_let("patient_id", Expr::String("P12345".into())),
        ComplianceProfile::Hipaa, "HIPAA-164.312-c1",
    );
}
#[test]
fn hipaa_164_312_c1_ok() {
    assert_no_violation(
        &make_let("patient_id", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::Hipaa, "HIPAA-164.312-c1",
    );
}

#[test]
fn hipaa_164_312_d_violation() {
    assert_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))),
        ComplianceProfile::Hipaa, "HIPAA-164.312-d",
    );
}
#[test]
fn hipaa_164_312_d_ok() {
    assert_no_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Prove(Box::new(Expr::Bool(true))))),
        ComplianceProfile::Hipaa, "HIPAA-164.312-d",
    );
}

#[test]
fn hipaa_164_312_e1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa, "HIPAA-164.312-e1",
    );
}
#[test]
fn hipaa_164_312_e1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa, "HIPAA-164.312-e1",
    );
}

#[test]
fn hipaa_164_530_c_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("patient_record".into()))),
        ComplianceProfile::Hipaa, "HIPAA-164.530-c",
    );
}
#[test]
fn hipaa_164_530_c_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("public_info".into()))),
        ComplianceProfile::Hipaa, "HIPAA-164.530-c",
    );
}

#[test]
fn hipaa_164_308_a5_violation() {
    assert_violation(&Expr::String("sha1".into()), ComplianceProfile::Hipaa, "HIPAA-164.308-a5");
}
#[test]
fn hipaa_164_308_a5_ok() {
    assert_no_violation(&Expr::String("sha256".into()), ComplianceProfile::Hipaa, "HIPAA-164.308-a5");
}

#[test]
fn hipaa_164_310_d_violation() {
    assert_violation(&Expr::String("http://ehr.example.com".into()), ComplianceProfile::Hipaa, "HIPAA-164.310-d");
}
#[test]
fn hipaa_164_310_d_ok() {
    assert_no_violation(&Expr::String("https://ehr.example.com".into()), ComplianceProfile::Hipaa, "HIPAA-164.310-d");
}

#[test]
fn hipaa_164_314_a_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Hipaa, "HIPAA-164.314-a",
    );
}
#[test]
fn hipaa_164_314_a_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Hipaa, "HIPAA-164.314-a",
    );
}

#[test]
fn hipaa_164_316_b_violation() {
    assert_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)),
        ComplianceProfile::Hipaa, "HIPAA-164.316-b",
    );
}
#[test]
fn hipaa_164_316_b_ok() {
    assert_no_violation(
        &Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("handled".into()))),
        ComplianceProfile::Hipaa, "HIPAA-164.316-b",
    );
}

// ===========================================================================
// GDPR tests
// ===========================================================================

#[test]
fn gdpr_5_1_a_violation() {
    assert_violation(&make_let("personal_info", Expr::String("name".into())), ComplianceProfile::Gdpr, "GDPR-5.1-a");
}
#[test]
fn gdpr_5_1_a_ok() {
    assert_no_violation(&make_classified_let("personal_info", Expr::String("name".into())), ComplianceProfile::Gdpr, "GDPR-5.1-a");
}

#[test]
fn gdpr_5_1_b_violation() {
    assert_violation(&make_let("email_address", Expr::String("a@b.com".into())), ComplianceProfile::Gdpr, "GDPR-5.1-b");
}
#[test]
fn gdpr_5_1_b_ok() {
    assert_no_violation(&make_let("email_address", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Gdpr, "GDPR-5.1-b");
}

#[test]
fn gdpr_5_1_c_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("personal_info".into()))),
        ComplianceProfile::Gdpr, "GDPR-5.1-c",
    );
}
#[test]
fn gdpr_5_1_c_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("public_data".into()))),
        ComplianceProfile::Gdpr, "GDPR-5.1-c",
    );
}

#[test]
fn gdpr_5_1_e_violation() {
    assert_violation(&Expr::String("http://gdpr.eu".into()), ComplianceProfile::Gdpr, "GDPR-5.1-e");
}
#[test]
fn gdpr_5_1_e_ok() {
    assert_no_violation(&Expr::String("https://gdpr.eu".into()), ComplianceProfile::Gdpr, "GDPR-5.1-e");
}

#[test]
fn gdpr_5_1_f_violation() {
    assert_violation(&Expr::String("des-cbc".into()), ComplianceProfile::Gdpr, "GDPR-5.1-f");
}
#[test]
fn gdpr_5_1_f_ok() {
    assert_no_violation(&Expr::String("aes-256-gcm".into()), ComplianceProfile::Gdpr, "GDPR-5.1-f");
}

#[test]
fn gdpr_25_1_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Gdpr, "GDPR-25.1");
}
#[test]
fn gdpr_25_1_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Gdpr, "GDPR-25.1");
}

#[test]
fn gdpr_32_violation() {
    assert_violation(&Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))), ComplianceProfile::Gdpr, "GDPR-32");
}
#[test]
fn gdpr_32_ok() {
    assert_no_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Prove(Box::new(Expr::Bool(true))))),
        ComplianceProfile::Gdpr, "GDPR-32",
    );
}

#[test]
fn gdpr_33_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Gdpr, "GDPR-33",
    );
}
#[test]
fn gdpr_33_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Gdpr, "GDPR-33",
    );
}

#[test]
fn gdpr_35_violation() {
    assert_violation(&Expr::Grant(Effect::System, Box::new(Expr::Unit)), ComplianceProfile::Gdpr, "GDPR-35");
}
#[test]
fn gdpr_35_ok() {
    assert_no_violation(&Expr::Grant(Effect::Read, Box::new(Expr::Unit)), ComplianceProfile::Gdpr, "GDPR-35");
}

#[test]
fn gdpr_17_violation() {
    assert_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)), ComplianceProfile::Gdpr, "GDPR-17");
}
#[test]
fn gdpr_17_ok() {
    assert_no_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("ok".into()))), ComplianceProfile::Gdpr, "GDPR-17");
}

// ===========================================================================
// PDPA tests
// ===========================================================================

#[test]
fn pdpa_s7_user_input_not_tainted() {
    let expr = Expr::Let(
        "user_input".into(), None,
        Box::new(Expr::String("raw data".into())),
        Box::new(Expr::Unit),
    );
    let violations = validate(&expr, &[ComplianceProfile::Pdpa]);
    assert!(violations.iter().any(|v| v.rule_id == "PDPA-S7"));
}

#[test]
fn pdpa_s7_user_input_tainted_ok() {
    assert_no_violation(
        &make_let("user_input", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::Pdpa, "PDPA-S7",
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
        ComplianceProfile::Pdpa, "PDPA-S24",
    );
}

#[test]
fn pdpa_s6_violation() {
    assert_violation(&make_let("nama", Expr::String("Ali".into())), ComplianceProfile::Pdpa, "PDPA-S6");
}
#[test]
fn pdpa_s6_ok() {
    assert_no_violation(&make_classified_let("nama", Expr::String("Ali".into())), ComplianceProfile::Pdpa, "PDPA-S6");
}

#[test]
fn pdpa_s8_violation() {
    assert_violation(&make_let("no_ic", Expr::String("901234-56-7890".into())), ComplianceProfile::Pdpa, "PDPA-S8");
}
#[test]
fn pdpa_s8_ok() {
    assert_no_violation(&make_let("no_ic", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Pdpa, "PDPA-S8");
}

#[test]
fn pdpa_s9_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Pdpa, "PDPA-S9");
}
#[test]
fn pdpa_s9_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Pdpa, "PDPA-S9");
}

#[test]
fn pdpa_s10_violation() {
    assert_violation(&Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))), ComplianceProfile::Pdpa, "PDPA-S10");
}
#[test]
fn pdpa_s10_ok() {
    assert_no_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Prove(Box::new(Expr::Bool(true))))),
        ComplianceProfile::Pdpa, "PDPA-S10",
    );
}

#[test]
fn pdpa_s11_violation() {
    assert_violation(&Expr::String("rc4".into()), ComplianceProfile::Pdpa, "PDPA-S11");
}
#[test]
fn pdpa_s11_ok() {
    assert_no_violation(&Expr::String("aes128".into()), ComplianceProfile::Pdpa, "PDPA-S11");
}

#[test]
fn pdpa_s12_violation() {
    assert_violation(
        &Expr::LetRec("pengesahan".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam("x".into(), Ty::String, Box::new(Expr::Bool(true)))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Pdpa, "PDPA-S12",
    );
}
#[test]
fn pdpa_s12_ok() {
    assert_no_violation(
        &Expr::LetRec("pengesahan".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam("x".into(), Ty::String,
                Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("x".into())))))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Pdpa, "PDPA-S12",
    );
}

#[test]
fn pdpa_s13_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Pdpa, "PDPA-S13-1",
    );
}
#[test]
fn pdpa_s13_1_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Pdpa, "PDPA-S13-1",
    );
}

#[test]
fn pdpa_s42_violation() {
    assert_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)), ComplianceProfile::Pdpa, "PDPA-S42");
}
#[test]
fn pdpa_s42_ok() {
    assert_no_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("ok".into()))), ComplianceProfile::Pdpa, "PDPA-S42");
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
    assert_violation(&make_let("financial_data", Expr::String("RM1000".into())), ComplianceProfile::Bnm, "BNM-10.18");
}
#[test]
fn bnm_10_18_ok() {
    assert_no_violation(&make_classified_let("financial_data", Expr::String("RM1000".into())), ComplianceProfile::Bnm, "BNM-10.18");
}

#[test]
fn bnm_10_49_b_violation() {
    assert_violation(&make_let("kata_laluan", Expr::String("p@ssword".into())), ComplianceProfile::Bnm, "BNM-10.49-b");
}
#[test]
fn bnm_10_49_b_ok() {
    assert_no_violation(&make_let("kata_laluan", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Bnm, "BNM-10.49-b");
}

#[test]
fn bnm_10_50_violation() {
    assert_violation(
        &Expr::LetRec("pengesahan".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam("x".into(), Ty::String, Box::new(Expr::Bool(true)))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Bnm, "BNM-10.50",
    );
}
#[test]
fn bnm_10_50_ok() {
    assert_no_violation(
        &Expr::LetRec("pengesahan".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam("x".into(), Ty::String,
                Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("x".into())))))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Bnm, "BNM-10.50",
    );
}

#[test]
fn bnm_10_51_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Bnm, "BNM-10.51",
    );
}
#[test]
fn bnm_10_51_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Bnm, "BNM-10.51",
    );
}

#[test]
fn bnm_10_52_violation() {
    assert_violation(&Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))), ComplianceProfile::Bnm, "BNM-10.52");
}
#[test]
fn bnm_10_52_ok() {
    assert_no_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Prove(Box::new(Expr::Bool(true))))),
        ComplianceProfile::Bnm, "BNM-10.52",
    );
}

#[test]
fn bnm_10_54_violation() {
    assert_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)), ComplianceProfile::Bnm, "BNM-10.54");
}
#[test]
fn bnm_10_54_ok() {
    assert_no_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("ok".into()))), ComplianceProfile::Bnm, "BNM-10.54");
}

#[test]
fn bnm_10_55_violation() {
    assert_violation(&Expr::FFICall { name: "ext_lib".into(), args: vec![], ret_ty: Ty::Unit }, ComplianceProfile::Bnm, "BNM-10.55");
}
#[test]
fn bnm_10_55_ok() {
    assert_no_violation(&Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)), ComplianceProfile::Bnm, "BNM-10.55");
}

#[test]
fn bnm_10_56_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Bnm, "BNM-10.56");
}
#[test]
fn bnm_10_56_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Bnm, "BNM-10.56");
}

#[test]
fn bnm_10_58_violation() {
    assert_violation(&Expr::String("http://bank.my".into()), ComplianceProfile::Bnm, "BNM-10.58");
}
#[test]
fn bnm_10_58_ok() {
    assert_no_violation(&Expr::String("https://bank.my".into()), ComplianceProfile::Bnm, "BNM-10.58");
}

// ===========================================================================
// MAS TRM tests
// ===========================================================================

#[test]
fn mas_trm_5_1_1_violation() {
    assert_violation(&make_let("customer_data", Expr::String("info".into())), ComplianceProfile::MasTrm, "MAS-TRM-5.1.1");
}
#[test]
fn mas_trm_5_1_1_ok() {
    assert_no_violation(&make_classified_let("customer_data", Expr::String("info".into())), ComplianceProfile::MasTrm, "MAS-TRM-5.1.1");
}

#[test]
fn mas_trm_9_1_1_violation() {
    assert_violation(&Expr::String("md5_hash".into()), ComplianceProfile::MasTrm, "MAS-TRM-9.1.1");
}
#[test]
fn mas_trm_9_1_1_ok() {
    assert_no_violation(&Expr::String("sha256".into()), ComplianceProfile::MasTrm, "MAS-TRM-9.1.1");
}

#[test]
fn mas_trm_9_2_1_violation() {
    assert_violation(
        &Expr::LetRec("authenticate".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam("x".into(), Ty::String, Box::new(Expr::Bool(true)))),
            Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm, "MAS-TRM-9.2.1",
    );
}
#[test]
fn mas_trm_9_2_1_ok() {
    assert_no_violation(
        &Expr::LetRec("authenticate".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam("x".into(), Ty::String,
                Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("x".into())))))),
            Box::new(Expr::Unit)),
        ComplianceProfile::MasTrm, "MAS-TRM-9.2.1",
    );
}

#[test]
fn mas_trm_9_4_1_violation() {
    assert_violation(&make_let("password", Expr::String("secret123".into())), ComplianceProfile::MasTrm, "MAS-TRM-9.4.1");
}
#[test]
fn mas_trm_9_4_1_ok() {
    assert_no_violation(&make_let("password", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::MasTrm, "MAS-TRM-9.4.1");
}

#[test]
fn mas_trm_11_1_1_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::MasTrm, "MAS-TRM-11.1.1");
}
#[test]
fn mas_trm_11_1_1_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::MasTrm, "MAS-TRM-11.1.1");
}

#[test]
fn mas_trm_11_2_1_violation() {
    assert_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("customer_info".into()))),
        ComplianceProfile::MasTrm, "MAS-TRM-11.2.1",
    );
}
#[test]
fn mas_trm_11_2_1_ok() {
    assert_no_violation(
        &Expr::Perform(Effect::Network, Box::new(Expr::Var("public_rate".into()))),
        ComplianceProfile::MasTrm, "MAS-TRM-11.2.1",
    );
}

#[test]
fn mas_trm_12_1_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::MasTrm, "MAS-TRM-12.1.1",
    );
}
#[test]
fn mas_trm_12_1_1_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::MasTrm, "MAS-TRM-12.1.1",
    );
}

#[test]
fn mas_trm_13_1_1_violation() {
    assert_violation(&Expr::Grant(Effect::System, Box::new(Expr::Unit)), ComplianceProfile::MasTrm, "MAS-TRM-13.1.1");
}
#[test]
fn mas_trm_13_1_1_ok() {
    assert_no_violation(&Expr::Grant(Effect::Read, Box::new(Expr::Unit)), ComplianceProfile::MasTrm, "MAS-TRM-13.1.1");
}

// ===========================================================================
// NIST 800-53 tests
// ===========================================================================

#[test]
fn nist_ac_1_violation() {
    assert_violation(&make_let("classified_data", Expr::String("top secret".into())), ComplianceProfile::Nist80053, "NIST-AC-1");
}
#[test]
fn nist_ac_1_ok() {
    assert_no_violation(&make_classified_let("classified_data", Expr::String("top secret".into())), ComplianceProfile::Nist80053, "NIST-AC-1");
}

#[test]
fn nist_ac_6_violation() {
    assert_violation(&Expr::Grant(Effect::Process, Box::new(Expr::Unit)), ComplianceProfile::Nist80053, "NIST-AC-6");
}
#[test]
fn nist_ac_6_ok() {
    assert_no_violation(&Expr::Grant(Effect::Write, Box::new(Expr::Unit)), ComplianceProfile::Nist80053, "NIST-AC-6");
}

#[test]
fn nist_au_2_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Grant(Effect::Read, Box::new(Expr::Unit)), Expr::Unit),
        ComplianceProfile::Nist80053, "NIST-AU-2",
    );
}
#[test]
fn nist_au_2_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Grant(Effect::Read, Box::new(Expr::Unit)),
            Expr::Perform(Effect::Write, Box::new(Expr::String("audit".into())))),
        ComplianceProfile::Nist80053, "NIST-AU-2",
    );
}

#[test]
fn nist_ia_5_violation() {
    assert_violation(&make_let("api_key", Expr::String("sk-12345".into())), ComplianceProfile::Nist80053, "NIST-IA-5");
}
#[test]
fn nist_ia_5_ok() {
    assert_no_violation(&make_let("api_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Nist80053, "NIST-IA-5");
}

#[test]
fn nist_sc_8_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Nist80053, "NIST-SC-8");
}
#[test]
fn nist_sc_8_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Nist80053, "NIST-SC-8");
}

#[test]
fn nist_sc_12_violation() {
    assert_violation(&make_let("private_key", Expr::String("key".into())), ComplianceProfile::Nist80053, "NIST-SC-12");
}
#[test]
fn nist_sc_12_ok() {
    assert_no_violation(&make_classified_let("private_key", Expr::String("key".into())), ComplianceProfile::Nist80053, "NIST-SC-12");
}

#[test]
fn nist_sc_13_violation() {
    assert_violation(&Expr::String("sha1_digest".into()), ComplianceProfile::Nist80053, "NIST-SC-13");
}
#[test]
fn nist_sc_13_ok() {
    assert_no_violation(&Expr::String("sha512".into()), ComplianceProfile::Nist80053, "NIST-SC-13");
}

#[test]
fn nist_sc_28_violation() {
    assert_violation(&Expr::String("http://fed.gov".into()), ComplianceProfile::Nist80053, "NIST-SC-28");
}
#[test]
fn nist_sc_28_ok() {
    assert_no_violation(&Expr::String("https://fed.gov".into()), ComplianceProfile::Nist80053, "NIST-SC-28");
}

#[test]
fn nist_si_2_violation() {
    assert_violation(&Expr::FFICall { name: "legacy_lib".into(), args: vec![], ret_ty: Ty::Unit }, ComplianceProfile::Nist80053, "NIST-SI-2");
}
#[test]
fn nist_si_2_ok() {
    assert_no_violation(&Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)), ComplianceProfile::Nist80053, "NIST-SI-2");
}

#[test]
fn nist_si_10_violation() {
    assert_violation(&make_let("user_input", Expr::String("raw".into())), ComplianceProfile::Nist80053, "NIST-SI-10");
}
#[test]
fn nist_si_10_ok() {
    assert_no_violation(
        &make_let("user_input", Expr::Perform(Effect::Read, Box::new(Expr::Unit))),
        ComplianceProfile::Nist80053, "NIST-SI-10",
    );
}

// ===========================================================================
// ISO 27001 tests
// ===========================================================================

#[test]
fn iso_a5_1_violation() {
    assert_violation(&make_let("confidential_doc", Expr::String("secret".into())), ComplianceProfile::Iso27001, "ISO-A5.1");
}
#[test]
fn iso_a5_1_ok() {
    assert_no_violation(&make_classified_let("confidential_doc", Expr::String("secret".into())), ComplianceProfile::Iso27001, "ISO-A5.1");
}

#[test]
fn iso_a6_1_violation() {
    assert_violation(&make_let("api_key", Expr::String("key123".into())), ComplianceProfile::Iso27001, "ISO-A6.1");
}
#[test]
fn iso_a6_1_ok() {
    assert_no_violation(&make_let("api_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Iso27001, "ISO-A6.1");
}

#[test]
fn iso_a8_1_violation() {
    assert_violation(&Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))), ComplianceProfile::Iso27001, "ISO-A8.1");
}
#[test]
fn iso_a8_1_ok() {
    assert_no_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Prove(Box::new(Expr::Bool(true))))),
        ComplianceProfile::Iso27001, "ISO-A8.1",
    );
}

#[test]
fn iso_a9_1_violation() {
    assert_violation(
        &Expr::LetRec("authenticate".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam("x".into(), Ty::String, Box::new(Expr::Bool(true)))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001, "ISO-A9.1",
    );
}
#[test]
fn iso_a9_1_ok() {
    assert_no_violation(
        &Expr::LetRec("authenticate".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam("x".into(), Ty::String,
                Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("x".into())))))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Iso27001, "ISO-A9.1",
    );
}

#[test]
fn iso_a10_1_violation() {
    assert_violation(&Expr::String("md5sum".into()), ComplianceProfile::Iso27001, "ISO-A10.1");
}
#[test]
fn iso_a10_1_ok() {
    assert_no_violation(&Expr::String("blake2b".into()), ComplianceProfile::Iso27001, "ISO-A10.1");
}

#[test]
fn iso_a12_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Iso27001, "ISO-A12.1",
    );
}
#[test]
fn iso_a12_1_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Iso27001, "ISO-A12.1",
    );
}

#[test]
fn iso_a13_1_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Iso27001, "ISO-A13.1");
}
#[test]
fn iso_a13_1_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Iso27001, "ISO-A13.1");
}

#[test]
fn iso_a14_1_violation() {
    assert_violation(&Expr::FFICall { name: "lib".into(), args: vec![], ret_ty: Ty::Unit }, ComplianceProfile::Iso27001, "ISO-A14.1");
}
#[test]
fn iso_a14_1_ok() {
    assert_no_violation(&Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)), ComplianceProfile::Iso27001, "ISO-A14.1");
}

#[test]
fn iso_a16_1_violation() {
    assert_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)), ComplianceProfile::Iso27001, "ISO-A16.1");
}
#[test]
fn iso_a16_1_ok() {
    assert_no_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("ok".into()))), ComplianceProfile::Iso27001, "ISO-A16.1");
}

#[test]
fn iso_a18_1_violation() {
    assert_violation(&Expr::String("http://iso.org".into()), ComplianceProfile::Iso27001, "ISO-A18.1");
}
#[test]
fn iso_a18_1_ok() {
    assert_no_violation(&Expr::String("https://iso.org".into()), ComplianceProfile::Iso27001, "ISO-A18.1");
}

// ===========================================================================
// DO-178C tests
// ===========================================================================

#[test]
fn do178c_6_3_1_violation() {
    assert_violation(
        &Expr::LetRec("loop_fn".into(), Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), Effect::Pure),
            Box::new(Expr::App(Box::new(Expr::Var("loop_fn".into())), Box::new(Expr::Unit))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Do178c, "DO178C-6.3.1",
    );
}
#[test]
fn do178c_6_3_1_ok() {
    assert_no_violation(
        &Expr::LetRec("safe_fn".into(), Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure),
            Box::new(Expr::Lam("n".into(), Ty::Int, Box::new(Expr::If(
                Box::new(Expr::Bool(true)), Box::new(Expr::Int(1)), Box::new(Expr::Int(0)))))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Do178c, "DO178C-6.3.1",
    );
}

#[test]
fn do178c_6_3_2_violation() {
    assert_violation(
        &Expr::Let("dead_binding".into(), None, Box::new(Expr::Unit), Box::new(Expr::Int(42))),
        ComplianceProfile::Do178c, "DO178C-6.3.2",
    );
}
#[test]
fn do178c_6_3_2_ok() {
    assert_no_violation(
        &Expr::Let("x".into(), None, Box::new(Expr::Int(42)), Box::new(Expr::Unit)),
        ComplianceProfile::Do178c, "DO178C-6.3.2",
    );
}

#[test]
fn do178c_6_3_3_violation() {
    assert_violation(&Expr::FFICall { name: "avionics_lib".into(), args: vec![], ret_ty: Ty::Unit }, ComplianceProfile::Do178c, "DO178C-6.3.3");
}
#[test]
fn do178c_6_3_3_ok() {
    assert_no_violation(&Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)), ComplianceProfile::Do178c, "DO178C-6.3.3");
}

#[test]
fn do178c_6_4_1_violation() {
    assert_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)), ComplianceProfile::Do178c, "DO178C-6.4.1");
}
#[test]
fn do178c_6_4_1_ok() {
    assert_no_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("ok".into()))), ComplianceProfile::Do178c, "DO178C-6.4.1");
}

#[test]
fn do178c_6_4_2_violation() {
    assert_violation(&Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))), ComplianceProfile::Do178c, "DO178C-6.4.2");
}
#[test]
fn do178c_6_4_2_ok() {
    assert_no_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Prove(Box::new(Expr::Bool(true))))),
        ComplianceProfile::Do178c, "DO178C-6.4.2",
    );
}

#[test]
fn do178c_6_4_3_violation() {
    assert_violation(&Expr::String("sha1_checksum".into()), ComplianceProfile::Do178c, "DO178C-6.4.3");
}
#[test]
fn do178c_6_4_3_ok() {
    assert_no_violation(&Expr::String("sha256".into()), ComplianceProfile::Do178c, "DO178C-6.4.3");
}

#[test]
fn do178c_6_4_4_violation() {
    assert_violation(&make_let("altitude", Expr::String("35000".into())), ComplianceProfile::Do178c, "DO178C-6.4.4");
}
#[test]
fn do178c_6_4_4_ok() {
    assert_no_violation(&make_classified_let("altitude", Expr::String("35000".into())), ComplianceProfile::Do178c, "DO178C-6.4.4");
}

#[test]
fn do178c_6_4_5_violation() {
    assert_violation(&Expr::Grant(Effect::System, Box::new(Expr::Unit)), ComplianceProfile::Do178c, "DO178C-6.4.5");
}
#[test]
fn do178c_6_4_5_ok() {
    assert_no_violation(&Expr::Grant(Effect::Read, Box::new(Expr::Unit)), ComplianceProfile::Do178c, "DO178C-6.4.5");
}

#[test]
fn do178c_6_7_1_violation() {
    assert_violation(&make_let("altitude_limit", Expr::String("45000".into())), ComplianceProfile::Do178c, "DO178C-6.7.1");
}
#[test]
fn do178c_6_7_1_ok() {
    assert_no_violation(&make_let("altitude_limit", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Do178c, "DO178C-6.7.1");
}

#[test]
fn do178c_6_7_2_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Do178c, "DO178C-6.7.2");
}
#[test]
fn do178c_6_7_2_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Do178c, "DO178C-6.7.2");
}

// ===========================================================================
// SOX tests
// ===========================================================================

#[test]
fn sox_302_1_violation() {
    assert_violation(&make_let("revenue", Expr::String("1000000".into())), ComplianceProfile::Sox, "SOX-302-1");
}
#[test]
fn sox_302_1_ok() {
    assert_no_violation(&make_classified_let("revenue", Expr::String("1000000".into())), ComplianceProfile::Sox, "SOX-302-1");
}

#[test]
fn sox_302_2_violation() {
    assert_violation(
        &Expr::LetRec("financial_auth".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam("x".into(), Ty::String, Box::new(Expr::Bool(true)))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Sox, "SOX-302-2",
    );
}
#[test]
fn sox_302_2_ok() {
    assert_no_violation(
        &Expr::LetRec("financial_auth".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam("x".into(), Ty::String,
                Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("x".into())))))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Sox, "SOX-302-2",
    );
}

#[test]
fn sox_404_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Sox, "SOX-404-1",
    );
}
#[test]
fn sox_404_1_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Sox, "SOX-404-1",
    );
}

#[test]
fn sox_404_2_violation() {
    assert_violation(&make_let("revenue_amount", Expr::String("5000".into())), ComplianceProfile::Sox, "SOX-404-2");
}
#[test]
fn sox_404_2_ok() {
    assert_no_violation(&make_let("revenue_amount", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Sox, "SOX-404-2");
}

#[test]
fn sox_409_1_violation() {
    assert_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)), ComplianceProfile::Sox, "SOX-409-1");
}
#[test]
fn sox_409_1_ok() {
    assert_no_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("ok".into()))), ComplianceProfile::Sox, "SOX-409-1");
}

#[test]
fn sox_802_1_violation() {
    assert_violation(&Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Int(0))), ComplianceProfile::Sox, "SOX-802-1");
}
#[test]
fn sox_802_1_ok() {
    assert_no_violation(
        &Expr::Declassify(Box::new(Expr::Int(1)), Box::new(Expr::Prove(Box::new(Expr::Bool(true))))),
        ComplianceProfile::Sox, "SOX-802-1",
    );
}

#[test]
fn sox_906_1_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Sox, "SOX-906-1");
}
#[test]
fn sox_906_1_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Sox, "SOX-906-1");
}

#[test]
fn sox_1102_1_violation() {
    assert_violation(&Expr::Grant(Effect::Process, Box::new(Expr::Unit)), ComplianceProfile::Sox, "SOX-1102-1");
}
#[test]
fn sox_1102_1_ok() {
    assert_no_violation(&Expr::Grant(Effect::Write, Box::new(Expr::Unit)), ComplianceProfile::Sox, "SOX-1102-1");
}

// ===========================================================================
// CMMC tests
// ===========================================================================

#[test]
fn cmmc_ac_1_violation() {
    assert_violation(&make_let("cui_document", Expr::String("secret".into())), ComplianceProfile::Cmmc, "CMMC-AC-1");
}
#[test]
fn cmmc_ac_1_ok() {
    assert_no_violation(&make_classified_let("cui_document", Expr::String("secret".into())), ComplianceProfile::Cmmc, "CMMC-AC-1");
}

#[test]
fn cmmc_ac_2_violation() {
    assert_violation(&make_let("password", Expr::String("abc123".into())), ComplianceProfile::Cmmc, "CMMC-AC-2");
}
#[test]
fn cmmc_ac_2_ok() {
    assert_no_violation(&make_let("password", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Cmmc, "CMMC-AC-2");
}

#[test]
fn cmmc_sc_1_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Cmmc, "CMMC-SC-1");
}
#[test]
fn cmmc_sc_1_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Cmmc, "CMMC-SC-1");
}

#[test]
fn cmmc_sc_2_violation() {
    assert_violation(&Expr::String("des_encrypt".into()), ComplianceProfile::Cmmc, "CMMC-SC-2");
}
#[test]
fn cmmc_sc_2_ok() {
    assert_no_violation(&Expr::String("aes256".into()), ComplianceProfile::Cmmc, "CMMC-SC-2");
}

#[test]
fn cmmc_si_1_violation() {
    assert_violation(&Expr::FFICall { name: "ext".into(), args: vec![], ret_ty: Ty::Unit }, ComplianceProfile::Cmmc, "CMMC-SI-1");
}
#[test]
fn cmmc_si_1_ok() {
    assert_no_violation(&Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)), ComplianceProfile::Cmmc, "CMMC-SI-1");
}

#[test]
fn cmmc_au_1_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Cmmc, "CMMC-AU-1",
    );
}
#[test]
fn cmmc_au_1_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Cmmc, "CMMC-AU-1",
    );
}

// ===========================================================================
// IEC 62443 tests
// ===========================================================================

#[test]
fn iec62443_sr_1_violation() {
    assert_violation(&make_let("scada_config", Expr::String("data".into())), ComplianceProfile::Iec62443, "IEC62443-SR-1");
}
#[test]
fn iec62443_sr_1_ok() {
    assert_no_violation(&make_classified_let("scada_config", Expr::String("data".into())), ComplianceProfile::Iec62443, "IEC62443-SR-1");
}

#[test]
fn iec62443_sr_2_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Iec62443, "IEC62443-SR-2");
}
#[test]
fn iec62443_sr_2_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Iec62443, "IEC62443-SR-2");
}

#[test]
fn iec62443_sr_3_violation() {
    assert_violation(&make_let("plc_key", Expr::String("key".into())), ComplianceProfile::Iec62443, "IEC62443-SR-3");
}
#[test]
fn iec62443_sr_3_ok() {
    assert_no_violation(&make_let("plc_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Iec62443, "IEC62443-SR-3");
}

#[test]
fn iec62443_sr_4_violation() {
    assert_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::Unit)), ComplianceProfile::Iec62443, "IEC62443-SR-4");
}
#[test]
fn iec62443_sr_4_ok() {
    assert_no_violation(&Expr::Handle(Box::new(Expr::Unit), "e".into(), Box::new(Expr::String("ok".into()))), ComplianceProfile::Iec62443, "IEC62443-SR-4");
}

#[test]
fn iec62443_sr_5_violation() {
    assert_violation(&Expr::FFICall { name: "plc_driver".into(), args: vec![], ret_ty: Ty::Unit }, ComplianceProfile::Iec62443, "IEC62443-SR-5");
}
#[test]
fn iec62443_sr_5_ok() {
    assert_no_violation(&Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)), ComplianceProfile::Iec62443, "IEC62443-SR-5");
}

#[test]
fn iec62443_sr_6_violation() {
    assert_violation(&Expr::String("rc4".into()), ComplianceProfile::Iec62443, "IEC62443-SR-6");
}
#[test]
fn iec62443_sr_6_ok() {
    assert_no_violation(&Expr::String("chacha20".into()), ComplianceProfile::Iec62443, "IEC62443-SR-6");
}

// ===========================================================================
// NERC CIP tests
// ===========================================================================

#[test]
fn nerc_cip_004_violation() {
    assert_violation(&make_let("grid_data", Expr::String("load".into())), ComplianceProfile::NercCip, "NERC-CIP-004");
}
#[test]
fn nerc_cip_004_ok() {
    assert_no_violation(&make_classified_let("grid_data", Expr::String("load".into())), ComplianceProfile::NercCip, "NERC-CIP-004");
}

#[test]
fn nerc_cip_005_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::NercCip, "NERC-CIP-005");
}
#[test]
fn nerc_cip_005_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::NercCip, "NERC-CIP-005");
}

#[test]
fn nerc_cip_007_violation() {
    assert_violation(&make_let("scada_key", Expr::String("key".into())), ComplianceProfile::NercCip, "NERC-CIP-007");
}
#[test]
fn nerc_cip_007_ok() {
    assert_no_violation(&make_let("scada_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::NercCip, "NERC-CIP-007");
}

#[test]
fn nerc_cip_010_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::NercCip, "NERC-CIP-010",
    );
}
#[test]
fn nerc_cip_010_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::NercCip, "NERC-CIP-010",
    );
}

#[test]
fn nerc_cip_011_violation() {
    assert_violation(&Expr::Grant(Effect::System, Box::new(Expr::Unit)), ComplianceProfile::NercCip, "NERC-CIP-011");
}
#[test]
fn nerc_cip_011_ok() {
    assert_no_violation(&Expr::Grant(Effect::Read, Box::new(Expr::Unit)), ComplianceProfile::NercCip, "NERC-CIP-011");
}

// ===========================================================================
// FDA 21 CFR tests
// ===========================================================================

#[test]
fn fda_11_10_a_violation() {
    assert_violation(&make_let("clinical_data", Expr::String("trial".into())), ComplianceProfile::Fda21cfr, "FDA-11.10-a");
}
#[test]
fn fda_11_10_a_ok() {
    assert_no_violation(&make_classified_let("clinical_data", Expr::String("trial".into())), ComplianceProfile::Fda21cfr, "FDA-11.10-a");
}

#[test]
fn fda_11_10_b_violation() {
    assert_violation(
        &Expr::LetRec("clinical_auth".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Pure),
            Box::new(Expr::Lam("x".into(), Ty::String, Box::new(Expr::Bool(true)))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Fda21cfr, "FDA-11.10-b",
    );
}
#[test]
fn fda_11_10_b_ok() {
    assert_no_violation(
        &Expr::LetRec("clinical_auth".into(), Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Crypto),
            Box::new(Expr::Lam("x".into(), Ty::String,
                Box::new(Expr::Perform(Effect::Crypto, Box::new(Expr::Var("x".into())))))),
            Box::new(Expr::Unit)),
        ComplianceProfile::Fda21cfr, "FDA-11.10-b",
    );
}

#[test]
fn fda_11_10_c_violation() {
    assert_violation(&make_let("pharma_key", Expr::String("key".into())), ComplianceProfile::Fda21cfr, "FDA-11.10-c");
}
#[test]
fn fda_11_10_c_ok() {
    assert_no_violation(&make_let("pharma_key", Expr::Perform(Effect::Read, Box::new(Expr::Unit))), ComplianceProfile::Fda21cfr, "FDA-11.10-c");
}

#[test]
fn fda_11_10_d_violation() {
    assert_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))), Expr::Unit),
        ComplianceProfile::Fda21cfr, "FDA-11.10-d",
    );
}
#[test]
fn fda_11_10_d_ok() {
    assert_no_violation(
        &make_let_with_body("x", Expr::Classify(Box::new(Expr::Int(1))),
            Expr::Perform(Effect::Write, Box::new(Expr::String("log".into())))),
        ComplianceProfile::Fda21cfr, "FDA-11.10-d",
    );
}

#[test]
fn fda_11_10_e_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Fda21cfr, "FDA-11.10-e");
}
#[test]
fn fda_11_10_e_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Fda21cfr, "FDA-11.10-e");
}

// ===========================================================================
// ITAR tests
// ===========================================================================

#[test]
fn itar_120_1_violation() {
    assert_violation(&make_let("munition_data", Expr::String("specs".into())), ComplianceProfile::Itar, "ITAR-120.1");
}
#[test]
fn itar_120_1_ok() {
    assert_no_violation(&make_classified_let("munition_data", Expr::String("specs".into())), ComplianceProfile::Itar, "ITAR-120.1");
}

#[test]
fn itar_120_2_violation() {
    assert_violation(&Expr::FFICall { name: "ext".into(), args: vec![], ret_ty: Ty::Unit }, ComplianceProfile::Itar, "ITAR-120.2");
}
#[test]
fn itar_120_2_ok() {
    assert_no_violation(&Expr::App(Box::new(Expr::Var("f".into())), Box::new(Expr::Unit)), ComplianceProfile::Itar, "ITAR-120.2");
}

#[test]
fn itar_120_3_violation() {
    assert_violation(&Expr::Perform(Effect::Network, Box::new(Expr::Unit)), ComplianceProfile::Itar, "ITAR-120.3");
}
#[test]
fn itar_120_3_ok() {
    assert_no_violation(&Expr::Perform(Effect::NetworkSecure, Box::new(Expr::Unit)), ComplianceProfile::Itar, "ITAR-120.3");
}

#[test]
fn itar_120_4_violation() {
    assert_violation(&Expr::Grant(Effect::System, Box::new(Expr::Unit)), ComplianceProfile::Itar, "ITAR-120.4");
}
#[test]
fn itar_120_4_ok() {
    assert_no_violation(&Expr::Grant(Effect::Read, Box::new(Expr::Unit)), ComplianceProfile::Itar, "ITAR-120.4");
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
            "Profile {:?} has no rules implemented", p
        );
    }
}

#[test]
fn total_rule_count_exceeds_100() {
    let mut total = 0;
    for &p in ComplianceProfile::ALL {
        total += crate::rules::rule_count(p);
    }
    assert!(total >= 100, "Expected 100+ rules, got {}", total);
}

#[test]
fn rule_count_matches_actual() {
    for &p in ComplianceProfile::ALL {
        let declared = crate::rules::rule_count(p);
        let actual = crate::rules::rules_for_profiles(&[p]).len();
        assert_eq!(declared, actual,
            "Profile {:?}: rule_count() says {} but actual rules = {}", p, declared, actual);
    }
}

#[test]
fn multiple_profiles_accumulate_violations() {
    // An insecure network perform triggers multiple profiles
    let expr = Expr::Perform(Effect::Network, Box::new(Expr::Unit));
    let violations = validate(&expr, &[
        ComplianceProfile::PciDss,
        ComplianceProfile::Hipaa,
        ComplianceProfile::Gdpr,
    ]);
    // Each profile should produce at least one violation
    assert!(violations.iter().any(|v| v.rule_id == "PCI-DSS-4.1"));
    assert!(violations.iter().any(|v| v.rule_id == "HIPAA-164.312-e1"));
    assert!(violations.iter().any(|v| v.rule_id == "GDPR-25.1"));
}
