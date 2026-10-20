// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The runtime capability gate agrees across backends (2026-10-19 assessment).
//!
//! Before: the C entry point granted itself every capability
//! (`riina_ctx.capabilities = 0xFFFFFFFF`), so the native gate could never
//! refuse anything, while the interpreter started with none, so `riinac run`
//! refused `laku Tulis` inside `utama kesan Tulis` — a program the checker had
//! accepted. `07_EXAMPLES/hello_dunia.rii` failed under `run` and ran natively.
//! The interpreter also reported "unhandled effect" for a `laku` with no
//! handler, where Coq `ST_PerformValue` and the C runtime return the payload.
//!
//! Now both gates start with the effect set the checker verified, and the C
//! check runs before the payload.

use std::path::PathBuf;
use std::process::Command;

struct Sandbox(PathBuf);

impl Sandbox {
    fn new(tag: &str) -> Self {
        let dir = std::env::temp_dir().join(format!("riina_capgate_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self(dir)
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}

fn cc_available() -> bool {
    let ok = Command::new("cc")
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false);
    if !ok && std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_err() {
        panic!("`cc` is required (set RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately)");
    }
    ok
}

const LAKU_TULIS: &str = "fungsi utama() -> Unit kesan Tulis {\n    laku Tulis cetak(\"dari laku\");\n    ()\n}\n";

/// `laku Tulis` under a `kesan Tulis` entry point: the interpreter and the
/// native binary both run it, and print the same thing.
#[test]
fn a_declared_perform_runs_under_both_backends_with_the_same_output() {
    if !cc_available() {
        return;
    }
    let sb = Sandbox::new("agree");
    let src = sb.0.join("laku.rii");
    std::fs::write(&src, LAKU_TULIS).unwrap();

    let run = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["run"])
        .arg(&src)
        .output()
        .expect("riinac run");
    let run_out = String::from_utf8_lossy(&run.stdout);
    assert!(run.status.success(), "run: {}", String::from_utf8_lossy(&run.stderr));
    assert!(run_out.starts_with("dari laku"), "run printed {run_out:?}");

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build"])
        .arg(&src)
        .output()
        .expect("riinac build");
    assert!(build.status.success(), "build: {}", String::from_utf8_lossy(&build.stderr));
    let native = Command::new(sb.0.join("laku")).output().expect("run binary");
    assert!(native.status.success(), "native binary failed: {native:?}");
    assert_eq!(String::from_utf8_lossy(&native.stdout), "dari laku");
}

/// A program the type checker did NOT vouch for (no capabilities stated)
/// aborts at the gate natively, and BEFORE its payload prints — the old C
/// runtime printed first and aborted second, when it aborted at all.
#[test]
fn an_unseeded_native_program_stops_at_the_gate_before_the_payload() {
    if !cc_available() {
        return;
    }
    use riina_types::{Effect, Expr};
    let perform = Expr::Perform(
        Effect::Write,
        Box::new(Expr::App(
            Box::new(Expr::Var("cetak".to_string())),
            Box::new(Expr::String("BOCOR".to_string())),
        )),
    );
    let sb = Sandbox::new("unseeded");
    let c = riina_codegen::compile_to_c(&perform).expect("emit C");
    assert!(c.contains("riina_ctx.capabilities = 0u;"));
    let c_path = sb.0.join("p.c");
    std::fs::write(&c_path, c).unwrap();
    let exe = sb.0.join("p");
    let cc = Command::new("cc").arg("-o").arg(&exe).arg(&c_path).output().unwrap();
    assert!(cc.status.success(), "{}", String::from_utf8_lossy(&cc.stderr));
    let out = Command::new(&exe).output().unwrap();
    assert!(!out.status.success(), "ran without the capability");
    assert!(
        !String::from_utf8_lossy(&out.stdout).contains("BOCOR"),
        "payload ran before the capability check"
    );
    assert!(String::from_utf8_lossy(&out.stderr).contains("missing capability"));
}
