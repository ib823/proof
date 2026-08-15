// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Zero-parameter functions are real functions — master plan REQ-68.
//!
//! # The bug this pins
//!
//! `fungsi f() -> T` did not desugar to a function. `desugar_function` with no
//! parameters returned the body unchanged, bound at the RETURN type, and the
//! parser dropped the `()` of a call as a no-op suffix. A zero-parameter
//! function was therefore a global initializer with a memoized result, and all
//! of the following were measured — with the interpreter and the C backend
//! **agreeing on the wrong answer**, so this was the reference semantics being
//! wrong rather than a backend divergence:
//!
//! ```text
//! fungsi sapa() -> Nombor kesan Tulis { cetakln("dipanggil"); 1 }
//! fungsi utama() -> Nombor kesan Tulis {
//!     cetakln("mula");
//!     biar a = sapa();
//!     biar b = sapa();
//!     cetakln(ke_teks(a + b));
//!     0
//! }
//! ```
//!
//! | | before | after |
//! |---|---|---|
//! | body runs | once | twice — once per call |
//! | ordering | `dipanggil` BEFORE `mula` | `mula`, then both calls |
//! | never called | still runs | does not run |
//!
//! A function whose body ran before the program's own first line, exactly once
//! no matter how many times it was called, and even when it was never called,
//! is not a function. `pulang` could not work there either: with no lambda
//! there was no function to return from (REQ-80).
//!
//! # Why a differential
//!
//! Every case runs under the interpreter, the C backend and the WASM backend
//! and asserts all three agree. The interpreter is the reference, so pinning it
//! against the compiled backends is what catches a shared wrong assumption —
//! which is precisely what the old model was.

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
            "!!! SKIPPED (tools missing: {}) — zero-arg coverage NOT exercised.",
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

/// A throwaway directory, unique per test name and pid — `riinac build` derives
/// its intermediate C path from the source stem, so a shared stem would make
/// parallel tests race on one file.
struct Sandbox {
    dir: PathBuf,
    stem: String,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let stem = format!("req68_{tag}");
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
/// program's final value.
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
    let run = Command::new(sb.dir.join(&sb.stem))
        .output()
        .expect("run native binary");
    assert!(
        run.status.success(),
        "native binary failed (exit {:?}): {}{}",
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
    let run = Command::new("wasmtime")
        .arg("run")
        .arg(sb.dir.join(format!("{}.wasm", sb.stem)))
        .output()
        .expect("wasmtime run");
    assert!(
        run.status.success(),
        "wasmtime rejected or trapped: {}{}",
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    String::from_utf8_lossy(&run.stdout).into_owned()
}

/// All three backends agree, AND the output is `expected`.
///
/// The expected value is asserted as well as the agreement here, because the
/// old behaviour was a shared wrong answer: interpreter and C agreed on it.
/// Agreement alone would have passed.
fn assert_output(tag: &str, source: &str, expected: &str) {
    if !require_backend_tools(&["cc", "wasmtime"]) {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.src(source);
    let interp = run_interp(&src);
    let native = run_native(&sb, &src);
    let wasm = run_wasm(&sb, &src);
    assert_eq!(interp, expected, "interpreter output wrong for {tag}");
    assert_eq!(
        native, expected,
        "C output wrong for {tag} (interp said {interp:?})"
    );
    assert_eq!(
        wasm, expected,
        "WASM output wrong for {tag} (interp said {interp:?})"
    );
}

/// THE REQ-68 regression: called twice, so it runs twice — and it runs WHEN
/// called, after `utama` has started. Before, `dipanggil` printed once, before
/// `mula`.
#[test]
fn body_runs_once_per_call_and_in_order() {
    assert_output(
        "per_call",
        "fungsi sapa() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"dipanggil\");\n\
         \x20   1\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"mula\");\n\
         \x20   biar a = sapa();\n\
         \x20   biar b = sapa();\n\
         \x20   cetakln(ke_teks(a + b));\n\
         \x20   0\n\
         }\n",
        "mula\ndipanggil\ndipanggil\n2\n",
    );
}

/// A zero-arg function that is NEVER called must not run. It used to run
/// anyway, because binding it WAS running it.
#[test]
fn uncalled_function_does_not_run() {
    assert_output(
        "uncalled",
        "fungsi tidak_dipanggil() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"TIDAK SEPATUTNYA MUNCUL\");\n\
         \x20   9\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"hanya ini\");\n\
         \x20   0\n\
         }\n",
        "hanya ini\n",
    );
}

/// REQ-80 + REQ-68 together: an early `pulang` inside a zero-arg function
/// returns from THAT function. The trailing `tamat` is the load-bearing part —
/// it proves the return did not unwind past the call site into `utama`.
#[test]
fn early_return_stays_inside_the_zero_arg_function() {
    assert_output(
        "early_return",
        "fungsi tentukan() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"dalam tentukan\");\n\
         \x20   kalau 1 > 0 { pulang 11; }\n\
         \x20   pulang 99;\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"mula\");\n\
         \x20   cetakln(ke_teks(tentukan()));\n\
         \x20   cetakln(\"tamat\");\n\
         \x20   0\n\
         }\n",
        "mula\ndalam tentukan\n11\ntamat\n",
    );
}

/// A zero-arg function calling another zero-arg function — the composition the
/// thunk model made incoherent, since both bodies ran at binding time in
/// declaration order rather than call order.
#[test]
fn zero_arg_functions_compose() {
    assert_output(
        "compose",
        "fungsi asas() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"asas\");\n\
         \x20   10\n\
         }\n\
         fungsi atas() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"atas\");\n\
         \x20   asas() + 5\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(atas()));\n\
         \x20   0\n\
         }\n",
        "atas\nasas\n15\n",
    );
}

/// A NESTED zero-arg function. Nested declarations desugar through a separate
/// path in the parser, which held its own copy of the lambda-building fold and
/// so kept the old thunk shape after the top-level path was fixed.
#[test]
fn nested_zero_arg_function_is_a_real_function() {
    assert_output(
        "nested",
        "fungsi luar() -> Nombor kesan Tulis {\n\
         \x20   fungsi dalaman() -> Nombor kesan Tulis {\n\
         \x20       cetakln(\"dalaman\");\n\
         \x20       3\n\
         \x20   }\n\
         \x20   biar a = dalaman();\n\
         \x20   biar b = dalaman();\n\
         \x20   a + b\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(luar()));\n\
         \x20   0\n\
         }\n",
        "dalaman\ndalaman\n6\n",
    );
}

/// A zero-arg function is a VALUE too: it can be passed and applied later, and
/// applying it twice runs it twice.
#[test]
fn zero_arg_function_is_a_first_class_value() {
    assert_output(
        "first_class",
        "fungsi jana() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"jana\");\n\
         \x20   4\n\
         }\n\
         fungsi guna_dua_kali(f: Fn() -> Nombor kesan Tulis) -> Nombor kesan Tulis {\n\
         \x20   f() + f()\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(guna_dua_kali(jana)));\n\
         \x20   0\n\
         }\n",
        "jana\njana\n8\n",
    );
}

/// Parameterised functions are untouched — the change must not disturb the
/// path every other function in the corpus takes.
#[test]
fn parameterised_functions_are_unaffected() {
    assert_output(
        "params",
        "fungsi tambah(a: Nombor, b: Nombor) -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"tambah\");\n\
         \x20   a + b\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(tambah(1, 2)));\n\
         \x20   cetakln(ke_teks(tambah(3, 4)));\n\
         \x20   0\n\
         }\n",
        "tambah\n3\ntambah\n7\n",
    );
}

/// `utama` is itself a zero-parameter function, so it is now a real function
/// that has to be CALLED. It used to run as a side effect of being bound.
/// The program's value stays `Unit`, so a compiled binary must not print
/// `utama`'s return code as a trailing line.
#[test]
fn entry_point_is_invoked_and_its_return_is_not_printed() {
    assert_output(
        "entry",
        "fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"satu\");\n\
         \x20   7\n\
         }\n",
        "satu\n",
    );
}

/// THE REQ-68 "t22" trigger shape, named in the original 2026-08-06 row:
/// `fungsi a()` + `fungsi b(x) { a() }` + `fungsi c() { b(5) }`.
///
/// This is the second consequence that row recorded, distinct from the
/// eager-evaluation one above: a zero-parameter member was excluded from the
/// mutual-recursion group's sibling-closure rebind set, so `c` evaluated
/// eagerly at bind time, entered `b`, and died with `unbound variable: a` —
/// **even when `c` was never called** — while `riinac check` and BOTH compiled
/// backends accepted and ran the same program. The corpus carried a written
/// discipline because of it ("zero-param functions must not call group
/// siblings"), and `07_EXAMPLES/02_effects/effect_inference.rii` carried a
/// workaround note; both are removed now that this passes.
#[test]
fn zero_arg_function_may_call_its_group_siblings() {
    assert_output(
        "siblings",
        "fungsi a() -> Nombor kesan Bersih { 7 }\n\
         fungsi b(x: Nombor) -> Nombor kesan Bersih { a() + x }\n\
         fungsi c() -> Nombor kesan Bersih { b(5) }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(c()));\n\
         \x20   0\n\
         }\n",
        "12\n",
    );
}

/// The same shape where the sibling-calling zero-arg function is NEVER called.
/// Under the old model this still died at startup, because binding the group
/// evaluated it; nothing should happen now.
#[test]
fn uncalled_sibling_caller_does_not_run_or_fail() {
    assert_output(
        "siblings_uncalled",
        "fungsi a() -> Nombor kesan Bersih { 7 }\n\
         fungsi b(x: Nombor) -> Nombor kesan Bersih { a() + x }\n\
         fungsi c() -> Nombor kesan Bersih { b(5) }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"tiada panggilan\");\n\
         \x20   0\n\
         }\n",
        "tiada panggilan\n",
    );
}
