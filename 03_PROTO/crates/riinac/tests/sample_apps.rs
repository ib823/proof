// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Gate C exit criterion: "≥1 non-trivial sample app shipping on stdlib."
//!
//! The applications under `07_EXAMPLES/03_applications/` that run on the shipped
//! interpreter are pinned here — each is executed via `riinac run` and its
//! output asserted — so a grammar or standard-library regression that breaks a
//! shipping app is caught immediately. They exercise the numeric-tower money
//! type (`wang`), recursion + `padan` list folding, and the Unicode-security
//! builtins end-to-end through the real driver.

use std::path::{Path, PathBuf};
use std::process::Command;

fn repo_root() -> PathBuf {
    // .../03_PROTO/crates/riinac -> .../ (up 3)
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root")
        .to_path_buf()
}

/// Run a sample app through `riinac run`; returns its stdout (asserting success).
fn run_app(name: &str) -> String {
    let app = repo_root().join("07_EXAMPLES/03_applications").join(name);
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&app)
        .output()
        .expect("failed to spawn riinac");
    assert!(
        out.status.success(),
        "{name} must run on the shipped interpreter:\n{}",
        String::from_utf8_lossy(&out.stderr)
    );
    String::from_utf8(out.stdout).expect("utf-8 stdout")
}

#[test]
fn invois_invoice_app_ships_with_exact_money() {
    // 3·19.99 + 2·5.50 + 1·12.00 = 82.97; +6% SST (rounded to cents) = 87.95.
    let out = run_app("invois.rii");
    assert!(out.contains("= RM 59.97"), "{out}");
    assert!(out.contains("Subjumlah            = RM 82.97"), "{out}");
    assert!(out.contains("SST (6%)             = RM 4.98"), "{out}");
    assert!(out.contains("JUMLAH               = RM 87.95"), "{out}");
}

#[test]
fn gaji_payroll_app_ships() {
    let out = run_app("gaji.rii");
    // 5000: EPF 550.00, tax (5000-3000)*8% = 160.00, net 4290.00.
    assert!(out.contains("EPF (11%)   = RM 550.00"), "{out}");
    assert!(out.contains("Gaji bersih = RM 4290.00"), "{out}");
    // 2500: under the tax threshold, so tax is exactly 0.00, net 2225.00.
    assert!(out.contains("Cukai       = RM 0.00"), "{out}");
    assert!(out.contains("Gaji bersih = RM 2225.00"), "{out}");
}

#[test]
fn belah_bil_app_demonstrates_numeric_tower() {
    let out = run_app("belah_bil.rii");
    // wang: 100.00 / 3 = 33.33 each; reconciled first payer 33.34.
    assert!(out.contains("Setiap orang (3)   = RM 33.33"), "{out}");
    assert!(out.contains("Sen baki           = RM 0.01"), "{out}");
    assert!(out.contains("Pembayar pertama   = RM 33.34"), "{out}");
    // perpuluhan: the same quotient kept to 34 places (distinct from money).
    assert!(out.contains(&format!("33.{}", "3".repeat(34))), "{out}");
}

#[test]
fn keselamatan_nama_app_flags_homograph() {
    let out = run_app("keselamatan_nama.rii");
    // The Cyrillic look-alike of "paypal" is flagged confusable; a distinct
    // brand ("microsoft") is reported safe.
    assert!(out.contains("AMARAN"), "{out}");
    assert!(out.contains("microsoft") && out.contains("selamat"), "{out}");
}
