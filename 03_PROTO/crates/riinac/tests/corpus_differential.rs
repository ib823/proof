// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Full example-corpus C ⇄ WASM differential.
//!
//! Sweeps every `07_EXAMPLES/**/*.rii`. For each example that BOTH backends
//! successfully build+run, stdout must be byte-for-byte identical — UNLESS the
//! example is in `KNOWN_DIVERGENT`, the explicitly-tracked set of programs that
//! currently differ because of documented WASM-backend limitations (see
//! RIINA_MASTER_PLAN.md Gate B "WASM target parity").
//!
//! This guards the matching subset against regressions and surfaces any NEW
//! divergence. Requires `cc` + `wasmtime`; skips when either is absent (CI).
//!
//! Measured 2026-06-03: of 158 examples, 32 build+run in both backends and
//! **all 32 are byte-equal** (`KNOWN_DIVERGENT` is empty); the rest don't
//! compile/run under one or both backends. The numeric-tower pair is
//! `00_basics/sized_integers` (width-masked u8/u16 + full-u32-range wrap →
//! 44/255/0/705032704) and `00_basics/signed_integers` (signed i8 two's-complement
//! → -128/-5/-64), both byte-identical across the C, WASM, and interpreter paths.
//! NB: the wasm32 backend uses a 32-bit value cell, so a true 64-bit value
//! (`>= 2^32`) is a clean compile error there (not a divergence); C handles it.
//! Re-verified across a wasmtime
//! major-version jump: identical result under **wasmtime 27.0.0 and 45.0.0**
//! (the byte-equality is robust to the runtime version). (30 equal is up from 10
//! over the session: the `main.return_ty` lowering fix, WASM `ke_teks`/
//! `gabung_teks` string builtins, the `cetakln` newline, a structured-control-flow
//! relooper fix for sequential if/else, a nested-if/else fix (merge `Phi` pushed
//! from each branch region's exit block, fixing `padan` integer/tuple matches
//! that lower to a nested `If` chain), struct field resolution (`FieldAccess`
//! lowers to the real positional projection over the struct's product layout —
//! fixing `compiler/main`), and WASM string-`Add` concat + `ke_teks` string
//! pass-through (fixing the CAHAYA UI `paparan`/`tulisan`/`butang` examples) —
//! together moved 20 examples to byte-equal.)

use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

/// Examples that run in both backends but currently differ, with the WASM-side
/// root cause. These are tracked, not silently ignored. Removing a WASM bug
/// should remove the corresponding entries here.
/// Examples whose two backends are known to differ, with the reason. The
/// differential test tolerates these (so it tracks them without failing) but
/// fails on any *new* divergence. **Empty as of 2026-06-03** — all 32
/// dual-backend examples are byte-equal.
const KNOWN_DIVERGENT: &[&str] = &[];

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

fn repo_root() -> PathBuf {
    // .../03_PROTO/crates/riinac -> .../  (up 3)
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root")
        .to_path_buf()
}

fn collect_examples(dir: &Path, out: &mut Vec<PathBuf>) {
    if let Ok(entries) = fs::read_dir(dir) {
        for e in entries.flatten() {
            let p = e.path();
            if p.is_dir() {
                collect_examples(&p, out);
            } else if p.extension().and_then(|s| s.to_str()) == Some("rii") {
                out.push(p);
            }
        }
    }
}

/// Build+run via the C backend; `None` if any step fails (parse/typecheck/cc/run).
fn run_c(work: &Path, stem: &str, src: &Path) -> Option<Vec<u8>> {
    let c = work.join(format!("{stem}.c"));
    let bin = work.join(format!("{stem}_c"));
    let emit = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["emit-c", &src.to_string_lossy()])
        .output()
        .ok()?;
    if !emit.status.success() {
        return None;
    }
    fs::write(&c, &emit.stdout).ok()?;
    let cc = Command::new("cc")
        .args(["-o", &bin.to_string_lossy(), &c.to_string_lossy(), "-lm"])
        .output()
        .ok()?;
    if !cc.status.success() {
        return None;
    }
    let run = Command::new(&bin).output().ok()?;
    if !run.status.success() {
        return None;
    }
    Some(run.stdout)
}

/// Build+run via the WASM backend; `None` if any step fails.
fn run_wasm(work: &Path, stem: &str, src: &Path) -> Option<Vec<u8>> {
    // Copy into the work dir so the emitted `<stem>.wasm` lands there.
    let rii = work.join(format!("{stem}.rii"));
    fs::copy(src, &rii).ok()?;
    let wasm = work.join(format!("{stem}.wasm"));
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "--target", "wasm32", &rii.to_string_lossy()])
        .output()
        .ok()?;
    if !build.status.success() {
        return None;
    }
    let run = Command::new("wasmtime")
        .args(["run", &wasm.to_string_lossy()])
        .output()
        .ok()?;
    if !run.status.success() {
        return None;
    }
    Some(run.stdout)
}

#[test]
fn corpus_c_wasm_differential() {
    if !tool_available("cc") || !tool_available("wasmtime") {
        eprintln!("skipping corpus differential: cc/wasmtime not available");
        return;
    }
    let root = repo_root();
    let examples_dir = root.join("07_EXAMPLES");
    let mut examples = Vec::new();
    collect_examples(&examples_dir, &mut examples);
    examples.sort();
    assert!(!examples.is_empty(), "no examples found under 07_EXAMPLES");

    let work = std::env::temp_dir().join("riina_corpus_diff");
    let _ = fs::create_dir_all(&work);

    let mut both_ran = 0usize;
    let mut equal = 0usize;
    let mut new_divergences: Vec<String> = Vec::new();

    for (i, ex) in examples.iter().enumerate() {
        let rel = ex
            .strip_prefix(&examples_dir)
            .unwrap()
            .to_string_lossy()
            .replace('\\', "/");
        let stem = format!("ex{i}");
        let (Some(c), Some(w)) = (run_c(&work, &stem, ex), run_wasm(&work, &stem, ex)) else {
            continue; // not runnable in both backends — out of differential scope
        };
        both_ran += 1;
        let known = KNOWN_DIVERGENT.contains(&rel.as_str());
        if c == w {
            equal += 1;
        } else if !known {
            new_divergences.push(format!(
                "{rel}: C={:?} WASM={:?}",
                String::from_utf8_lossy(&c).chars().take(60).collect::<String>(),
                String::from_utf8_lossy(&w).chars().take(60).collect::<String>(),
            ));
        }
    }

    eprintln!(
        "corpus differential: {both_ran} examples ran in both backends, {equal} byte-equal, \
         {} known-divergent (tracked)",
        both_ran - equal
    );
    assert!(
        new_divergences.is_empty(),
        "NEW C/WASM divergence(s) not in KNOWN_DIVERGENT:\n{}",
        new_divergences.join("\n")
    );
}

/// C-backend correctness for arbitrary-precision `besar` (BigInt). The corpus
/// differential above compares C vs WASM, but BigInt has no WASM backend (it
/// fails closed), so `00_basics/bigint.rii` is skipped there. This test pins the
/// C output directly: it compiles the example through the C backend and asserts
/// the exact decimal results — every one overflows 64 bits, so it can only be
/// correct if the emitted C bignum runtime (a port of `bigint.rs`, the model
/// `foundations/BigIntModel.v` proves) actually works. Needs only `cc`.
#[test]
fn bigint_c_backend_matches_expected_decimal() {
    if !tool_available("cc") {
        eprintln!("skipping bigint C-backend test: cc not available");
        return;
    }
    let root = repo_root();
    let ex = root.join("07_EXAMPLES/00_basics/bigint.rii");
    let work = std::env::temp_dir().join("riina_bigint_c");
    let _ = fs::create_dir_all(&work);
    let out = run_c(&work, "bigint", &ex)
        .expect("00_basics/bigint.rii must build and run via the C backend");
    // a = 99999999999999999999, b = 12345678901234567890.
    let expected = "9999999999999999999800000000000000000001\n\
                    112345678901234567889\n\
                    87654321098765432109\n\
                    8\n\
                    1234568790123456879\n";
    assert_eq!(
        String::from_utf8(out).unwrap(),
        expected,
        "C bignum runtime output must match the proven decimal values"
    );
}

/// C-backend correctness for arbitrary-precision exact `perpuluhan` (Decimal).
/// Like BigInt, Decimal has no WASM backend (it fails closed), so
/// `00_basics/decimal.rii` is skipped by the corpus differential above. This
/// test pins the C output directly: it compiles the example through the C
/// backend and asserts the exact base-10 results — `0.1 + 0.2` is exactly `0.3`
/// (no float drift), `1/3` rounds half-to-even to 34 places — so it can only be
/// correct if the emitted C decimal runtime (a port of `decimal.rs`, the model
/// `foundations/DecimalModel.v` proves a ring homomorphism to ℚ) actually works.
/// The same values the interpreter produces (`decimal::tests`). Needs only `cc`.
#[test]
fn decimal_c_backend_matches_expected_decimal() {
    if !tool_available("cc") {
        eprintln!("skipping decimal C-backend test: cc not available");
        return;
    }
    let root = repo_root();
    let ex = root.join("07_EXAMPLES/00_basics/decimal.rii");
    let work = std::env::temp_dir().join("riina_decimal_c");
    let _ = fs::create_dir_all(&work);
    let out = run_c(&work, "decimal", &ex)
        .expect("00_basics/decimal.rii must build and run via the C backend");
    let expected = "0.3\n\
                    59.97\n\
                    4.99\n\
                    0.25\n\
                    0.3333333333333333333333333333333333\n";
    assert_eq!(
        String::from_utf8(out).unwrap(),
        expected,
        "C decimal runtime output must match the proven exact-base-10 values"
    );
}
