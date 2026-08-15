// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Early return (`pulang`) across all three backends — master plan REQ-80.
//!
//! # The bug this pins
//!
//! `Expr::Return(e)` lowered to just `e`, DISCARDING the control flow that the
//! reference interpreter implements as real unwinding. The two consequences
//! were measured, not inferred:
//!
//!   * `kalau n <= 1 { pulang 1; } pulang 99;` fell through to 99 — a silent
//!     wrong answer, the worst failure mode: the program ran and lied;
//!   * a recursive function never reached its base case, so
//!     `07_EXAMPLES/00_basics/recursion.rii` recursed until the stack died
//!     (**SIGSEGV, exit 139**) under the C backend while the interpreter
//!     printed the right answers.
//!
//! # Why a differential rather than expected-output assertions
//!
//! Comparing the backends against EACH OTHER catches a wrong shared assumption
//! that a hand-written expected value would simply encode twice. The C and WASM
//! backends reach `pulang` by different routes — C emits the IR terminator
//! directly, WASM has to fit it into structured control flow — so agreement
//! between them is real evidence.
//!
//! # The WASM half
//!
//! Honouring the return exposed a second defect, in the structured control-flow
//! emitter: when BOTH arms of an `if` end in a return, nothing rejoins, so there
//! is no merge block and the `if`'s `(result i64)` was left on the operand stack
//! with no phi local to receive it. `wasmtime` rejected the module outright with
//! *"values remaining on stack at end of block"*. That arm was effectively dead
//! before REQ-80, because no branch could end in a return — every one fell
//! through to a merge. It now emits `unreachable`, which is both true and what
//! makes the frame validate.

use std::path::PathBuf;
use std::process::Command;

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// Guard for tests needing an external backend toolchain (`cc`, `wasmtime`).
///
/// Mirrors `wasm_c_differential.rs`: a missing tool PANICS by default, because
/// a test that cannot run must never report `ok`. Opt out deliberately with
/// `RIINA_ALLOW_MISSING_BACKEND_TOOLS=1`, which announces the lost coverage.
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
            "!!! SKIPPED (tools missing: {}) — early-return coverage NOT exercised.",
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

/// A throwaway directory, unique per test name and pid.
///
/// The stem must be unique: `riinac build` derives its intermediate C path from
/// it, so a shared name makes parallel tests race on the same file.
struct Sandbox {
    dir: PathBuf,
    stem: String,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let stem = format!("req80_{tag}");
        let dir = std::env::temp_dir().join(format!("riina_{stem}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self { dir, stem }
    }

    fn src(&self, source: &str) -> PathBuf {
        let p = self.dir.join(format!("{}.rii", self.stem));
        std::fs::write(&p, source).expect("write program");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

/// Interpreter stdout, WITHOUT the trailing line `riinac run` adds for the
/// program's final value. Every case below ends in a `cetakln`, so the dropped
/// line is always that echoed value and never program output.
fn run_interp(src: &PathBuf) -> String {
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(src)
        .output()
        .expect("riinac run");
    assert!(
        out.status.success(),
        "interpreter failed: {}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    let s = String::from_utf8_lossy(&out.stdout).into_owned();
    let mut lines: Vec<&str> = s.lines().collect();
    lines.pop();
    if lines.is_empty() {
        String::new()
    } else {
        format!("{}\n", lines.join("\n"))
    }
}

fn run_native(sb: &Sandbox, src: &PathBuf) -> String {
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "native build failed: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );
    let bin = sb.dir.join(&sb.stem);
    let run = Command::new(&bin).output().expect("run native binary");
    assert!(
        run.status.success(),
        "native binary failed (exit {:?}) — a SIGSEGV here is the REQ-80 \
         unbounded-recursion regression: {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    String::from_utf8_lossy(&run.stdout).into_owned()
}

fn run_wasm(sb: &Sandbox, src: &PathBuf) -> String {
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "--target", "wasm32"])
        .arg(src)
        .output()
        .expect("riinac build wasm32");
    assert!(
        build.status.success(),
        "wasm build failed: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );
    let wasm = sb.dir.join(format!("{}.wasm", sb.stem));
    let run = Command::new("wasmtime")
        .arg("run")
        .arg(&wasm)
        .output()
        .expect("wasmtime run");
    assert!(
        run.status.success(),
        "wasmtime rejected or trapped — \"values remaining on stack at end of \
         block\" here is the REQ-80 diverging-arms regression: {}{}",
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    String::from_utf8_lossy(&run.stdout).into_owned()
}

/// Assert interpreter, C and WASM all produce byte-identical output.
fn assert_all_three_agree(tag: &str, source: &str) {
    if !require_backend_tools(&["cc", "wasmtime"]) {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.src(source);
    let interp = run_interp(&src);
    let native = run_native(&sb, &src);
    let wasm = run_wasm(&sb, &src);
    assert_eq!(
        interp, native,
        "interp/C divergence for {tag}\n  interp: {interp:?}\n  C:      {native:?}"
    );
    assert_eq!(
        native, wasm,
        "C/WASM divergence for {tag}\n  C:    {native:?}\n  WASM: {wasm:?}"
    );
}

/// THE REQ-80 wrong-answer regression: the guard fires, so the answer is 1.
/// Before the fix every backend but the interpreter said 99.
#[test]
fn guard_clause_returns_early() {
    assert_all_three_agree(
        "guard",
        "fungsi f(n: Nombor) -> Nombor kesan Bersih {\n\
         \x20   kalau n <= 1 { pulang 1; }\n\
         \x20   pulang 99;\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(f(0)));\n\
         \x20   cetakln(ke_teks(f(5)));\n\
         \x20   0\n\
         }\n",
    );
}

/// THE REQ-80 crash regression: without the early return the base case is never
/// reached and this recursed until the stack died (SIGSEGV, exit 139).
#[test]
fn recursion_reaches_its_base_case() {
    assert_all_three_agree(
        "recursion",
        "fungsi faktorial(n: Nombor) -> Nombor kesan Bersih {\n\
         \x20   kalau n == 0 { pulang 1; }\n\
         \x20   pulang n * faktorial(n - 1);\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(faktorial(0)));\n\
         \x20   cetakln(ke_teks(faktorial(5)));\n\
         \x20   cetakln(ke_teks(faktorial(10)));\n\
         \x20   0\n\
         }\n",
    );
}

/// EVERY arm returns, so there is no merge block. This is the shape that made
/// `wasmtime` reject the module with "values remaining on stack at end of
/// block" — the `if`'s result had nowhere to go.
#[test]
fn if_else_chain_where_every_arm_returns() {
    assert_all_three_agree(
        "all_arms",
        "fungsi periksa(x: Nombor) -> Teks kesan Bersih {\n\
         \x20   kalau x > 0 { pulang \"positif\"; }\n\
         \x20   lain kalau x < 0 { pulang \"negatif\"; }\n\
         \x20   lain { pulang \"kosong\"; }\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(periksa(7));\n\
         \x20   cetakln(periksa(0 - 7));\n\
         \x20   cetakln(periksa(0));\n\
         \x20   0\n\
         }\n",
    );
}

/// The same shape NESTED — an inner diverging if/else inside an outer one.
#[test]
fn nested_ifs_where_every_arm_returns() {
    assert_all_three_agree(
        "nested",
        "fungsi periksa(x: Nombor, y: Nombor) -> Teks kesan Bersih {\n\
         \x20   kalau x > 0 {\n\
         \x20       kalau y > 0 { pulang \"kedua positif\"; }\n\
         \x20       lain { pulang \"x positif\"; }\n\
         \x20   } lain { pulang \"x tidak positif\"; }\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(periksa(1, 1));\n\
         \x20   cetakln(periksa(1, 0 - 1));\n\
         \x20   cetakln(periksa(0 - 1, 1));\n\
         \x20   0\n\
         }\n",
    );
}

/// A return in only ONE arm: the other still falls through to the merge, so the
/// phi path must keep working. This is the case the diverging-arms fix must not
/// break.
#[test]
fn one_arm_returns_and_the_other_falls_through() {
    assert_all_three_agree(
        "one_arm",
        "fungsi f(n: Nombor) -> Nombor kesan Bersih {\n\
         \x20   biar m = kalau n > 10 { 100 } lain { n * 2 };\n\
         \x20   kalau m > 50 { pulang m; }\n\
         \x20   pulang m + 1;\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(f(20)));\n\
         \x20   cetakln(ke_teks(f(3)));\n\
         \x20   0\n\
         }\n",
    );
}

/// A function with NO early return must be unaffected — the fix touches only
/// the `pulang` path, and every existing program depends on that.
#[test]
fn plain_tail_return_is_unchanged() {
    assert_all_three_agree(
        "tail",
        "fungsi tambah(a: Nombor, b: Nombor) -> Nombor kesan Bersih {\n\
         \x20   pulang a + b;\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(tambah(3, 4)));\n\
         \x20   0\n\
         }\n",
    );
}

/// REQ-80 REMAINING, pinned as CURRENT behaviour rather than desired: a
/// `pulang` in a ZERO-PARAMETER function is not honoured, because such a
/// function is not an IR function at all — `build_lambda` with no params
/// returns the body unchanged, so it is spliced into its definition site.
///
/// In TAIL position — where nearly every one of them sits, including `utama`'s
/// own `pulang 0` — the old value-passthrough is correct, so all three backends
/// still agree. This test exists so that stays true while the general case is
/// open; see `backend_agreement.rs` for the IR-level pin.
#[test]
fn zero_arg_function_with_a_tail_return_still_agrees() {
    assert_all_three_agree(
        "zero_arg",
        "fungsi ambil() -> Nombor kesan Bersih {\n\
         \x20   pulang 42;\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(ambil()));\n\
         \x20   0\n\
         }\n",
    );
}
