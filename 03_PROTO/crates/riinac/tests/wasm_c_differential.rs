// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! C ⇄ WASM differential tests.
//!
//! For each program, compile it through BOTH backends and assert the stdout is
//! byte-for-byte identical:
//!   - C:    `riinac emit-c` -> `cc` -> run native binary
//!   - WASM: `riinac build --target wasm32` -> `wasmtime run`
//!
//! These require `cc` and `wasmtime` on PATH. When either is missing (e.g. in a
//! minimal CI image) the tests skip rather than fail.

use std::fs;
use std::path::PathBuf;
use std::process::Command;

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

fn workdir() -> PathBuf {
    let dir = std::env::temp_dir().join("riina_wasm_c_diff");
    fs::create_dir_all(&dir).unwrap();
    dir
}

/// Run `source` through the C backend; return native stdout.
fn run_c(name: &str, source: &str) -> Vec<u8> {
    let dir = workdir();
    let rii = dir.join(format!("{name}.rii"));
    let c = dir.join(format!("{name}.c"));
    let bin = dir.join(format!("{name}_c"));
    fs::write(&rii, source).unwrap();

    let emit = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["emit-c", &rii.to_string_lossy()])
        .output()
        .expect("emit-c");
    assert!(
        emit.status.success(),
        "emit-c failed: {}",
        String::from_utf8_lossy(&emit.stderr)
    );
    fs::write(&c, &emit.stdout).unwrap();

    let cc = Command::new("cc")
        .args([
            "-o",
            &bin.to_string_lossy(),
            &c.to_string_lossy(),
            "-lm",
        ])
        .output()
        .expect("cc");
    assert!(
        cc.status.success(),
        "cc failed: {}",
        String::from_utf8_lossy(&cc.stderr)
    );

    Command::new(&bin).output().expect("run C binary").stdout
}

/// Run `source` through the WASM backend; return wasmtime stdout.
fn run_wasm(name: &str, source: &str) -> Vec<u8> {
    let dir = workdir();
    let rii = dir.join(format!("{name}.rii"));
    let wasm = dir.join(format!("{name}.wasm"));
    fs::write(&rii, source).unwrap();

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "--target", "wasm32", &rii.to_string_lossy()])
        .output()
        .expect("build wasm");
    assert!(
        build.status.success(),
        "build wasm failed: {}",
        String::from_utf8_lossy(&build.stderr)
    );

    Command::new("wasmtime")
        .args(["run", &wasm.to_string_lossy()])
        .output()
        .expect("wasmtime run")
        .stdout
}

fn assert_byte_equal(name: &str, source: &str) {
    if !tool_available("cc") || !tool_available("wasmtime") {
        eprintln!("skipping {name}: cc/wasmtime not available");
        return;
    }
    let c = run_c(name, source);
    let w = run_wasm(name, source);
    assert_eq!(
        c,
        w,
        "C/WASM differ for {name}: C={:?} WASM={:?}",
        String::from_utf8_lossy(&c),
        String::from_utf8_lossy(&w)
    );
}

#[test]
fn diff_cetak_int() {
    assert_byte_equal(
        "cetak_int",
        "fungsi utama() -> Nombor kesan Sistem { cetak(42); pulang 0 }",
    );
}

#[test]
fn diff_cetak_string() {
    assert_byte_equal(
        "cetak_string",
        "fungsi utama() -> Nombor kesan Sistem { cetak(\"Selamat\"); pulang 0 }",
    );
}

#[test]
fn diff_cetak_arithmetic() {
    assert_byte_equal(
        "cetak_arith",
        "fungsi utama() -> Nombor kesan Sistem { cetak(3 + 4); pulang 0 }",
    );
}

#[test]
fn diff_cetak_multiple() {
    assert_byte_equal(
        "cetak_multi",
        "fungsi utama() -> Nombor kesan Sistem { cetak(1); cetak(2); cetak(3); pulang 0 }",
    );
}

#[test]
fn diff_bare_int() {
    assert_byte_equal("bare_int", "42");
}

#[test]
fn diff_bare_arithmetic() {
    assert_byte_equal("bare_arith", "100 * 100 * 100");
}

#[test]
fn diff_bare_zero() {
    assert_byte_equal("bare_zero", "0");
}

#[test]
fn diff_bare_bool() {
    assert_byte_equal("bare_bool", "betul");
}
