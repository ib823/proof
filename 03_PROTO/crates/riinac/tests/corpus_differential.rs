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
/// 2026-08-07: four asymmetric RUNTIME divergences surfaced the moment the
/// differential learned to treat one-side-runs/one-side-fails as a
/// divergence instead of a silent skip (the bool-print bug hid behind that
/// skip). All four run CORRECTLY on the reference interpreter; the native
/// backends have feature gaps their REQ-55 example rewrites now exercise:
///   - builder/command/state_machine: C runtime aborts ("le/mul on non-int",
///     "load on non-ref") — C lowering of padan enum-payload arithmetic and
///     record field loads through sum values.
///   - test_driven: C runs; WASM translation error — closures stored in
///     records (validator combinators).
/// Tracked as backend-parity work in the REQ-68 cluster (master plan).
const KNOWN_DIVERGENT: &[&str] = &[
    "05_patterns/builder.rii",
    "05_patterns/command.rii",
    "05_patterns/state_machine.rii",
    "07_ai_patterns/test_driven.rii",
];

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// Guard for tests that need an external backend toolchain (`cc`, `wasmtime`).
///
/// Returns `true` when the test may proceed. When a tool is MISSING this
/// **panics by default** — a test that cannot run must never report `ok`.
///
/// This is not hypothetical. On 2026-08-04 a real C/WASM codegen regression
/// (the REQ-44 `LetRecGroup` landing dropping `fn_returns_struct` for grouped
/// functions) reached `main` because `corpus_differential` silently skipped
/// itself in a dev container without `wasmtime` — and still counted toward a
/// reported "2915 passed / 0 failed". CI caught it; the local suite could not.
/// A silently-skipping test is UNVERIFIED, not green.
///
/// To work in a container that genuinely lacks the tools, opt out DELIBERATELY:
///     RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 cargo test ...
/// The skip is then announced loudly on stderr so it cannot be mistaken for a
/// pass. CI never sets it, so CI can never silently lose this coverage.
fn require_backend_tools(tools: &[&str]) -> bool {
    let missing: Vec<&str> = tools
        .iter()
        .copied()
        .filter(|t| !tool_available(t))
        .collect();
    if missing.is_empty() {
        return true;
    }
    if std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_ok() {
        eprintln!(
            "!!! SKIPPED (tools missing: {}) — coverage NOT exercised; \
             this run does not verify the C/WASM backends.",
            missing.join(", ")
        );
        return false;
    }
    panic!(
        "required backend tool(s) missing: {}. This test cannot verify anything \
         without them, so it fails rather than reporting a false pass. Install \
         them, or set RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately.",
        missing.join(", ")
    );
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

/// Outcome of one backend attempt. Distinguishing a BUILD failure (the
/// example is simply outside this backend's supported surface — out of
/// differential scope) from a RUNTIME failure matters: if BOTH backends
/// build but only one runs, that asymmetry IS a divergence, not a skip.
/// The 2026-08-07 bool-print bug hid locally behind exactly this gap —
/// wasmtime crashed (skip) while CI's wasmtime produced wrong bytes
/// (failure), so the local suite stayed green while CI went red.
enum BackendOutcome {
    NoBuild,
    RunFail(String),
    Ran(Vec<u8>),
}


impl BackendOutcome {
    /// Unwrap a successful run's bytes; panics with `msg` otherwise (used by
    /// the pinned single-example tests below).
    fn expect(self, msg: &str) -> Vec<u8> {
        match self {
            BackendOutcome::Ran(bytes) => bytes,
            BackendOutcome::NoBuild => panic!("{msg}: backend build failed"),
            BackendOutcome::RunFail(e) => panic!("{msg}: runtime failure: {e}"),
        }
    }
}

/// Build+run via the C backend.
fn run_c(work: &Path, stem: &str, src: &Path) -> BackendOutcome {
    let c = work.join(format!("{stem}.c"));
    let bin = work.join(format!("{stem}_c"));
    let Ok(emit) = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["emit-c", &src.to_string_lossy()])
        .output()
    else {
        return BackendOutcome::NoBuild;
    };
    if !emit.status.success() {
        return BackendOutcome::NoBuild;
    }
    if fs::write(&c, &emit.stdout).is_err() {
        return BackendOutcome::NoBuild;
    }
    let Ok(cc) = Command::new("cc")
        .args(["-o", &bin.to_string_lossy(), &c.to_string_lossy(), "-lm"])
        .output()
    else {
        return BackendOutcome::NoBuild;
    };
    if !cc.status.success() {
        return BackendOutcome::NoBuild;
    }
    let Ok(run) = Command::new(&bin).output() else {
        return BackendOutcome::RunFail("spawn failed".to_string());
    };
    if !run.status.success() {
        return BackendOutcome::RunFail(String::from_utf8_lossy(&run.stderr).chars().take(120).collect());
    }
    BackendOutcome::Ran(run.stdout)
}

/// Build+run via the WASM backend.
fn run_wasm(work: &Path, stem: &str, src: &Path) -> BackendOutcome {
    // Copy into the work dir so the emitted `<stem>.wasm` lands there.
    let rii = work.join(format!("{stem}.rii"));
    if fs::copy(src, &rii).is_err() {
        return BackendOutcome::NoBuild;
    }
    let wasm = work.join(format!("{stem}.wasm"));
    let Ok(build) = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "--target", "wasm32", &rii.to_string_lossy()])
        .output()
    else {
        return BackendOutcome::NoBuild;
    };
    if !build.status.success() {
        return BackendOutcome::NoBuild;
    }
    let Ok(run) = Command::new("wasmtime")
        .args(["run", &wasm.to_string_lossy()])
        .output()
    else {
        return BackendOutcome::RunFail("spawn failed".to_string());
    };
    if !run.status.success() {
        return BackendOutcome::RunFail(String::from_utf8_lossy(&run.stderr).chars().take(120).collect());
    }
    BackendOutcome::Ran(run.stdout)
}

#[test]
fn corpus_c_wasm_differential() {
    if !require_backend_tools(&["cc", "wasmtime"]) {
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
        let (c, w) = match (run_c(&work, &stem, ex), run_wasm(&work, &stem, ex)) {
            (BackendOutcome::Ran(c), BackendOutcome::Ran(w)) => (c, w),
            // Either backend declining to BUILD puts the example out of
            // differential scope (unsupported surface) — a legitimate skip.
            (BackendOutcome::NoBuild, _) | (_, BackendOutcome::NoBuild) => continue,
            // Both backends BUILT and both fail at RUNTIME: a shared
            // feature gap (e.g. higher-order calls), not a C-vs-WASM
            // divergence — out of differential scope like NoBuild.
            (BackendOutcome::RunFail(_), BackendOutcome::RunFail(_)) => continue,
            // Both backends BUILT but exactly ONE fails at RUNTIME: that
            // asymmetry IS a divergence and must fail loudly.
            (c_out, w_out) => {
                if !KNOWN_DIVERGENT.contains(&rel.as_str()) {
                    let describe = |o: &BackendOutcome| match o {
                        BackendOutcome::Ran(_) => "ran".to_string(),
                        BackendOutcome::RunFail(e) => format!("RUNTIME FAILURE: {e}"),
                        BackendOutcome::NoBuild => unreachable!(),
                    };
                    new_divergences.push(format!(
                        "{rel}: C {} | WASM {}",
                        describe(&c_out),
                        describe(&w_out)
                    ));
                }
                continue;
            }
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
    if !require_backend_tools(&["cc"]) {
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
    if !require_backend_tools(&["cc"]) {
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

/// C-backend correctness for the fixed-point numeric tower — fixed-scale money
/// (`wang`/`titik_tetap`) and binary Q-format (`qmn`). Like BigInt/Decimal these
/// have no WASM backend (fail closed), so `00_basics/fixed.rii` is skipped by the
/// corpus differential above. This pins the C output directly: it can only be
/// correct if the emitted C ports of `fixed.rs` (round-to-scale money) and
/// `fixed_bin.rs` (decimal↔binary Q-format) actually work — the same values the
/// interpreter produces (`fixed::tests`, `fixed_bin::tests`). Needs only `cc`.
#[test]
fn fixed_point_c_backend_matches_interpreter() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let root = repo_root();
    let ex = root.join("07_EXAMPLES/00_basics/fixed.rii");
    let work = std::env::temp_dir().join("riina_fixed_c");
    let _ = fs::create_dir_all(&work);
    let out = run_c(&work, "fixed", &ex)
        .expect("00_basics/fixed.rii must build and run via the C backend");
    let expected = "59.97\n\
                    3.33\n\
                    99.99\n\
                    3.14\n\
                    0.75\n\
                    0.1015625\n";
    assert_eq!(
        String::from_utf8(out).unwrap(),
        expected,
        "C fixed-point runtime output must match the interpreter (money + Q-format)"
    );
}
