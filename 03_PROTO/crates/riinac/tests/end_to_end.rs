//! End-to-end integration tests: .rii → C → executable → run
//!
//! These tests verify the full RIINA compilation pipeline:
//! parse → typecheck → IR → C emit → cc → execute binary.
//!
//! Also includes .rii example regression gate tests that validate
//! the parser/typechecker against the example corpus.

use std::fs;
use std::path::Path;
use std::process::Command;

/// Helper: compile a .rii source string to an executable and run it.
/// Returns (stdout, exit_code).
fn compile_and_run(name: &str, source: &str) -> (String, i32) {
    let dir = std::env::temp_dir().join("riina_e2e_tests");
    fs::create_dir_all(&dir).unwrap();

    let rii_path = dir.join(format!("{}.rii", name));
    let c_path = dir.join(format!("{}.c", name));
    let bin_path = dir.join(name);

    fs::write(&rii_path, source).unwrap();

    // Step 1: emit C
    let emit = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["emit-c", &rii_path.to_string_lossy()])
        .output()
        .expect("failed to run riinac emit-c");

    assert!(
        emit.status.success(),
        "riinac emit-c failed for {}: {}",
        name,
        String::from_utf8_lossy(&emit.stderr)
    );

    fs::write(&c_path, &emit.stdout).unwrap();

    // Step 2: compile C with cc/gcc
    let cc = Command::new("cc")
        .args([
            "-o",
            &bin_path.to_string_lossy(),
            &c_path.to_string_lossy(),
            "-lm",
        ])
        .output()
        .expect("failed to run cc");

    assert!(
        cc.status.success(),
        "cc failed for {}: {}",
        name,
        String::from_utf8_lossy(&cc.stderr)
    );

    // Step 3: run binary
    let run = Command::new(&bin_path)
        .output()
        .expect("failed to run compiled binary");

    let stdout = String::from_utf8_lossy(&run.stdout).to_string();
    let code = run.status.code().unwrap_or(-1);

    // Cleanup
    let _ = fs::remove_file(&rii_path);
    let _ = fs::remove_file(&c_path);
    let _ = fs::remove_file(&bin_path);

    (stdout, code)
}

#[test]
fn e2e_hello_cetak() {
    let (out, code) = compile_and_run(
        "e2e_hello",
        r#"
fungsi utama() -> Nombor kesan Sistem {
    cetak("Selamat pagi!");
    pulang 0
}
"#,
    );
    assert_eq!(code, 0);
    assert!(out.contains("Selamat pagi!"), "got: {}", out);
}

#[test]
fn e2e_arithmetic() {
    let (out, code) = compile_and_run(
        "e2e_arith",
        r#"
fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    pulang x + y
}

fungsi utama() -> Nombor kesan Sistem {
    biar r = tambah(17, 25);
    cetak(r);
    pulang 0
}
"#,
    );
    assert_eq!(code, 0);
    assert!(out.contains("42"), "expected 42, got: {}", out);
}

#[test]
fn e2e_conditional() {
    let (out, code) = compile_and_run(
        "e2e_cond",
        r#"
fungsi utama() -> Nombor kesan Sistem {
    biar x = 10;
    biar msg = kalau x > 5 { "besar" } lain { "kecil" };
    cetak(msg);
    pulang 0
}
"#,
    );
    assert_eq!(code, 0);
    assert!(out.contains("besar"), "got: {}", out);
}

#[test]
fn e2e_declassify() {
    let (out, code) = compile_and_run(
        "e2e_declass",
        r#"
fungsi utama() -> Nombor kesan Sistem {
    biar v = dedah sulit 99 dengan bukti sulit 99;
    cetak(v);
    pulang 0
}
"#,
    );
    assert_eq!(code, 0);
    assert!(out.contains("99"), "expected 99, got: {}", out);
}

#[test]
fn e2e_multi_function_calls() {
    let (out, code) = compile_and_run(
        "e2e_multi_fn",
        r#"
fungsi gandakan(x: Nombor) -> Nombor kesan Bersih {
    pulang x * 2
}

fungsi tambah_satu(x: Nombor) -> Nombor kesan Bersih {
    pulang x + 1
}

fungsi utama() -> Nombor kesan Sistem {
    biar r = tambah_satu(gandakan(5));
    cetak(r);
    pulang 0
}
"#,
    );
    assert_eq!(code, 0);
    assert!(out.contains("11"), "expected 11, got: {}", out);
}

#[test]
fn e2e_nontrivial_full_pipeline() {
    // REQ-13: non-trivial program using Secret<T> + declassify,
    // function calls, conditionals, and effects.
    let (out, code) = compile_and_run(
        "e2e_nontrivial",
        r#"
fungsi kira(jam: Nombor, kadar: Nombor) -> Nombor kesan Bersih {
    pulang jam * kadar
}

fungsi utama() -> Nombor kesan Sistem {
    biar gaji = kira(40, 25);
    cetak("RM");
    cetak(gaji);
    cetak(" ");
    biar s = kalau gaji > 500 { "OK" } lain { "LOW" };
    cetak(s);
    cetak(" ");
    biar d = dedah sulit gaji dengan bukti sulit gaji;
    cetak(d);
    pulang 0
}
"#,
    );
    assert_eq!(code, 0);
    assert!(out.contains("RM1000"), "expected RM1000, got: {}", out);
    assert!(out.contains("OK"), "expected OK status, got: {}", out);
    assert!(
        out.contains("1000"),
        "expected declassified 1000, got: {}",
        out
    );
}

// ============================================================================
// .rii Example Regression Gate
//
// These tests load actual .rii files from 07_EXAMPLES/ and run them through
// riinac check (parse + typecheck). They serve as a regression gate:
// - The MINIMUM_PASS_COUNT must not decrease (catches parser regressions)
// - As more syntax is implemented, the count should increase
// ============================================================================

/// Helper: run `riinac check` on a .rii file.
/// Returns true if parse + typecheck succeeded (exit code 0, no error output).
fn rii_check_passes(path: &Path) -> bool {
    let output = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["check", &path.to_string_lossy()])
        .output()
        .expect("failed to run riinac check");

    output.status.success()
        && !String::from_utf8_lossy(&output.stderr).contains("error")
}

/// Collect all .rii files from a directory.
fn collect_rii_files(dir: &str) -> Vec<std::path::PathBuf> {
    let base = Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()  // crates/
        .unwrap()
        .parent()  // 03_PROTO/
        .unwrap()
        .parent()  // /workspaces/proof/
        .unwrap()
        .join(dir);

    if !base.exists() {
        return vec![];
    }

    fs::read_dir(&base)
        .unwrap()
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().map_or(false, |ext| ext == "rii"))
        .collect()
}

#[test]
fn rii_example_regression_gate_effects() {
    let files = collect_rii_files("07_EXAMPLES/02_effects");
    assert!(
        !files.is_empty(),
        "No .rii files found in 07_EXAMPLES/02_effects/"
    );

    let mut pass_count = 0;
    let mut fail_names = vec![];

    for f in &files {
        if rii_check_passes(f) {
            pass_count += 1;
        } else {
            fail_names.push(f.file_name().unwrap().to_string_lossy().to_string());
        }
    }

    // Regression gate: this number must never decrease.
    // As more syntax is implemented, increase this minimum.
    let minimum_pass_count = 2;

    assert!(
        pass_count >= minimum_pass_count,
        "Effect examples regression: {pass_count}/{} pass (minimum {minimum_pass_count}). \
         Failures: {:?}",
        files.len(),
        fail_names
    );

    eprintln!(
        "rii_example_regression_gate_effects: {pass_count}/{} pass ({} fail)",
        files.len(),
        fail_names.len()
    );
}

#[test]
fn rii_example_regression_gate_security() {
    let files = collect_rii_files("07_EXAMPLES/01_security");
    assert!(
        !files.is_empty(),
        "No .rii files found in 07_EXAMPLES/01_security/"
    );

    let mut pass_count = 0;
    let mut fail_names = vec![];

    for f in &files {
        if rii_check_passes(f) {
            pass_count += 1;
        } else {
            fail_names.push(f.file_name().unwrap().to_string_lossy().to_string());
        }
    }

    // Regression gate: currently 0 security examples pass.
    // When security syntax is implemented, increase this.
    let minimum_pass_count = 0;

    assert!(
        pass_count >= minimum_pass_count,
        "Security examples regression: {pass_count}/{} pass (minimum {minimum_pass_count}). \
         Failures: {:?}",
        files.len(),
        fail_names
    );

    eprintln!(
        "rii_example_regression_gate_security: {pass_count}/{} pass ({} fail)",
        files.len(),
        fail_names.len()
    );
}

#[test]
fn rii_example_regression_gate_all() {
    // Scan ALL .rii example directories
    let dirs = [
        "07_EXAMPLES/00_basics",
        "07_EXAMPLES/01_security",
        "07_EXAMPLES/02_effects",
        "07_EXAMPLES/03_advanced",
        "07_EXAMPLES/04_compliance",
        "07_EXAMPLES/05_patterns",
        "07_EXAMPLES/06_ai_context",
        "07_EXAMPLES/07_compiler",
        "07_EXAMPLES/08_jalinan",
    ];

    let mut total = 0;
    let mut pass = 0;

    for dir in &dirs {
        for f in collect_rii_files(dir) {
            total += 1;
            if rii_check_passes(&f) {
                pass += 1;
            }
        }
    }

    // Overall regression gate
    let minimum_pass_count = 2;

    assert!(
        pass >= minimum_pass_count,
        "Overall .rii regression: {pass}/{total} pass (minimum {minimum_pass_count})"
    );

    eprintln!("rii_example_regression_gate_all: {pass}/{total} pass");
}
