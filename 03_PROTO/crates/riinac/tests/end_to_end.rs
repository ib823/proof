//! End-to-end integration tests: .rii → C → executable → run
//!
//! These tests verify the full RIINA compilation pipeline:
//! parse → typecheck → IR → C emit → cc → execute binary.

use std::fs;
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
    assert!(out.contains("1000"), "expected declassified 1000, got: {}", out);
}
