// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Arithmetic and comparison on secrets run (2026-10-19 assessment).
//!
//! The type checker accepts `biar d = pin + 1;` for a secret `pin` and types
//! it `Labeled(Int, Secret)`, but no backend could run it: the interpreter
//! failed with "expected matching operand types for binary op, found
//! Secret(Int(1234)) Add Int(1)" and the native binary aborted with "add on
//! incompatible types". A program the checker accepted went wrong at runtime.
//!
//! Both backends now compute on the underlying values and keep the result
//! secret. The interpreter's result is compared with `Secret(expected)`; the
//! native result is declassified against a proof of the EXPECTED value, which
//! the C runtime refuses unless it matches, so a wrong answer cannot pass.

use riina_types::{BinOp, Expr};
use std::process::Command;

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

fn int(n: u64) -> Expr {
    Expr::Int(n)
}

fn secret(e: Expr) -> Expr {
    Expr::Classify(Box::new(e))
}

fn binop(op: BinOp, l: Expr, r: Expr) -> Expr {
    Expr::BinOp(op, Box::new(l), Box::new(r))
}

/// `dedah e dengan bukti (sulit expected)`.
fn declassify_as(e: Expr, expected: Expr) -> Expr {
    Expr::Declassify(Box::new(e), Box::new(Expr::Prove(Box::new(secret(expected)))))
}

/// (op, lhs, rhs, expected) with every operand shape: secret∘public,
/// public∘secret and secret∘secret.
fn cases() -> Vec<(BinOp, Expr, Expr, Expr)> {
    let mut v = Vec::new();
    for (op, a, b, want) in [
        (BinOp::Add, 40, 2, Expr::Int(42)),
        (BinOp::Sub, 50, 8, Expr::Int(42)),
        (BinOp::Mul, 6, 7, Expr::Int(42)),
        (BinOp::Div, 84, 2, Expr::Int(42)),
        (BinOp::Mod, 142, 100, Expr::Int(42)),
        (BinOp::Eq, 42, 42, Expr::Bool(true)),
        (BinOp::Ne, 42, 42, Expr::Bool(false)),
        (BinOp::Lt, 41, 42, Expr::Bool(true)),
        (BinOp::Ge, 41, 42, Expr::Bool(false)),
    ] {
        v.push((op, secret(int(a)), int(b), want.clone()));
        v.push((op, int(a), secret(int(b)), want.clone()));
        v.push((op, secret(int(a)), secret(int(b)), want));
    }
    v
}

#[test]
fn the_interpreter_computes_on_secrets_and_keeps_the_result_secret() {
    for (op, l, r, want) in cases() {
        let e = binop(op, l, r);
        // The interpreter's `dedah` takes only a proof of the literal
        // classified expression (Coq `declass_ok`, syntactic — REQ-66), so
        // the secret result is compared directly.
        let raw = riina_codegen::eval(&e).unwrap_or_else(|err| panic!("{e:?}: {err}"));
        let want_val = riina_codegen::eval(&want).unwrap();
        assert_eq!(raw, riina_codegen::Value::secret(want_val), "{e:?}");
    }
}

#[test]
fn the_native_backend_computes_on_secrets_and_agrees_with_the_interpreter() {
    if !cc_available() {
        return;
    }
    let dir = std::env::temp_dir().join(format!("riina_secret_arith_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    std::fs::create_dir_all(&dir).unwrap();
    for (i, (op, l, r, want)) in cases().into_iter().enumerate() {
        let e = binop(op, l, r);
        // Branch on the declassified result so Int and Bool both print one
        // public marker.
        let program = Expr::If(
            Box::new(binop(BinOp::Eq, declassify_as(e.clone(), want.clone()), want)),
            Box::new(Expr::App(
                Box::new(Expr::Var("cetak".to_string())),
                Box::new(Expr::String("SAMA".to_string())),
            )),
            Box::new(Expr::App(
                Box::new(Expr::Var("cetak".to_string())),
                Box::new(Expr::String("BEZA".to_string())),
            )),
        );
        let c = riina_codegen::compile_to_c(&program).unwrap_or_else(|err| panic!("{e:?}: {err}"));
        let c_path = dir.join(format!("p{i}.c"));
        let exe = dir.join(format!("p{i}"));
        std::fs::write(&c_path, c).unwrap();
        let cc = Command::new("cc").arg("-o").arg(&exe).arg(&c_path).output().unwrap();
        assert!(cc.status.success(), "{}", String::from_utf8_lossy(&cc.stderr));
        let out = Command::new(&exe).output().unwrap();
        assert!(
            out.status.success(),
            "{e:?} aborted natively: {}",
            String::from_utf8_lossy(&out.stderr)
        );
        assert_eq!(String::from_utf8_lossy(&out.stdout), "SAMA", "{e:?}");
    }
    // Negative control: a proof of the WRONG value is refused, so the check
    // above really compares the computed value.
    let wrong = Expr::App(
        Box::new(Expr::Var("cetak".to_string())),
        Box::new(declassify_as(binop(BinOp::Add, secret(int(40)), int(2)), int(41))),
    );
    let c_path = dir.join("wrong.c");
    let exe = dir.join("wrong");
    std::fs::write(&c_path, riina_codegen::compile_to_c(&wrong).unwrap()).unwrap();
    assert!(Command::new("cc").arg("-o").arg(&exe).arg(&c_path).status().unwrap().success());
    let out = Command::new(&exe).output().unwrap();
    assert!(!out.status.success(), "a mismatched proof was accepted");
    let _ = std::fs::remove_dir_all(&dir);
}

/// The surface program from the assessment: accepted by the checker, and now
/// run by both backends instead of failing at runtime.
#[test]
fn the_surface_program_runs_under_run_and_build() {
    if !cc_available() {
        return;
    }
    let dir = std::env::temp_dir().join(format!("riina_secret_surface_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    std::fs::create_dir_all(&dir).unwrap();
    let src = dir.join("pin.rii");
    std::fs::write(
        &src,
        "fungsi utama() -> Unit kesan Tulis {\n\
         \x20   biar pin = sulit 1234;\n\
         \x20   biar d = pin + 1;\n\
         \x20   biar sama = (pin * 2) == 2468;\n\
         \x20   biar tanda = kalau sama { 1 } lain { 0 };\n\
         \x20   cetak(\"ok\")\n\
         }\n",
    )
    .unwrap();
    let run = Command::new(env!("CARGO_BIN_EXE_riinac")).arg("run").arg(&src).output().unwrap();
    assert!(run.status.success(), "run: {}", String::from_utf8_lossy(&run.stderr));
    let build = Command::new(env!("CARGO_BIN_EXE_riinac")).arg("build").arg(&src).output().unwrap();
    assert!(build.status.success(), "build: {}", String::from_utf8_lossy(&build.stderr));
    let native = Command::new(dir.join("pin")).output().unwrap();
    assert!(native.status.success(), "native: {}", String::from_utf8_lossy(&native.stderr));
    assert_eq!(String::from_utf8_lossy(&native.stdout), "ok");
    let _ = std::fs::remove_dir_all(&dir);
}
