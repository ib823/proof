// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the collection families (master plan REQ-79,
//! part of REQ-70's family routing).
//!
//! # The bug this pins
//!
//! A list literal lowered to a cons chain of `Instruction::Pair`s terminated by
//! Unit, but the C backend's own `senarai_*` builtins require a tagged list and
//! `abort()` on anything else. The two halves of the C backend disagreed about
//! the representation, so
//!
//! ```text
//! cetakln(ke_teks(senarai_panjang([1, 2, 3])))
//! ```
//!
//! printed `3` under `riinac run` and died with **SIGABRT and no diagnostic at
//! all** when compiled. The Backend column called the family `native-only`,
//! i.e. "lowers to C" — true, and useless, because it aborted on contact.
//!
//! `Instruction::MakeList` now carries a first-class list into both the
//! interpreter's `Value::List` and the C runtime's existing
//! `riina_list_push`/`riina_make_list`, which builtins already returned.
//!
//! # Why a differential rather than expected-output assertions
//!
//! REQ-70 asks for each family to land "with a byte-equal interp/C differential".
//! Comparing the two backends against EACH OTHER catches a wrong shared
//! assumption that a hand-written expected value would simply encode twice.

use std::path::PathBuf;
use std::process::Command;

/// Run one program under `riinac run` and as a compiled binary; assert the
/// program's own output matches.
///
/// `riinac run` additionally prints the program's final value as a trailing
/// LINE, so the comparison drops exactly that line. Every case below ends with
/// a `cetakln`, so the dropped line is always the echoed `0`/Unit and never
/// part of the program's own output.
fn assert_backends_agree(tag: &str, body: &str) {
    let dir = std::env::temp_dir().join(format!("riina_req79_{tag}_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    std::fs::create_dir_all(&dir).expect("create dir");
    // The source STEM must be unique per test: `riinac build` writes its
    // intermediate C to a temp path derived from the stem, so a shared name
    // makes parallel tests race on the same file.
    let stem = format!("ujian_{tag}");
    let src: PathBuf = dir.join(format!("{stem}.rii"));
    std::fs::write(
        &src,
        format!("fungsi utama() -> Nombor kesan Tulis {{\n{body}\n    0\n}}\n"),
    )
    .expect("write program");

    let interp = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&src)
        .output()
        .expect("riinac run");
    assert!(
        interp.status.success(),
        "interpreter failed for {tag}: {}{}",
        String::from_utf8_lossy(&interp.stdout),
        String::from_utf8_lossy(&interp.stderr)
    );
    let interp_out = String::from_utf8_lossy(&interp.stdout).into_owned();

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "compile failed for {tag}: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );

    let binary = dir.join(&stem);
    let run = Command::new(&binary).output().expect("run compiled binary");
    assert!(
        run.status.success(),
        "compiled binary failed for {tag} (exit {:?}) — SIGABRT/SIGSEGV here is the \
         REQ-79 class of bug: {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    let c_out = String::from_utf8_lossy(&run.stdout).into_owned();

    // `riinac run` prints the program's final value as a trailing LINE after
    // the program's own output; drop exactly that line before comparing.
    let mut lines: Vec<&str> = interp_out.lines().collect();
    lines.pop();
    let interp_prog_out = if lines.is_empty() {
        String::new()
    } else {
        format!("{}\n", lines.join("\n"))
    };

    assert_eq!(
        interp_prog_out, c_out,
        "interp/C divergence for {tag}\n  interp: {interp_prog_out:?}\n  C:      {c_out:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// THE REQ-79 regression: this exact program used to abort with no diagnostic.
#[test]
fn list_literal_length_agrees() {
    assert_backends_agree(
        "len",
        "    cetakln(ke_teks(senarai_panjang([1, 2, 3])));",
    );
}

#[test]
fn empty_and_nested_list_literals_agree() {
    assert_backends_agree("empty", "    cetakln(ke_teks(senarai_panjang([])));");
    assert_backends_agree(
        "nested",
        "    cetakln(ke_teks(senarai_panjang([[1], [2], [3]])));",
    );
}

#[test]
fn list_indexing_and_reversal_agree() {
    assert_backends_agree(
        "index",
        "    cetakln(ke_teks(senarai_dapat(([10, 20, 30], 1))));",
    );
    assert_backends_agree(
        "reverse",
        "    biar r = senarai_balik([1, 2, 3]);\n\
         \x20   cetakln(ke_teks(senarai_dapat((r, 0))));",
    );
}

/// A list literal bound to a variable, then consumed — the path that a real
/// program takes rather than an inline literal.
#[test]
fn list_through_a_binding_agrees() {
    assert_backends_agree(
        "binding",
        "    biar xs = [10, 20];\n\
         \x20   cetakln(ke_teks(senarai_panjang(xs)));",
    );
}

/// List PATTERNS destructure a list. They must keep working now that a literal
/// is a tagged list rather than a cons chain of pairs.
#[test]
fn list_patterns_agree() {
    assert_backends_agree(
        "pattern",
        "    biar n = padan [1, 2, 3] {\n\
         \x20       [] => 0,\n\
         \x20       [_, ..ekor] => 1 + senarai_panjang(ekor),\n\
         \x20   };\n\
         \x20   cetakln(ke_teks(n));",
    );
}

/// A builtin that RETURNS a list feeds one that consumes it — the two list
/// producers (literal and builtin) must agree on representation.
#[test]
fn builtin_produced_list_agrees() {
    assert_backends_agree(
        "split",
        "    cetakln(ke_teks(senarai_panjang(teks_belah((\"a,b,c\", \",\")))));",
    );
}

/// Maps and sets were already built by builtins rather than literals, so they
/// worked; pinned here so the collection surface is covered as one family.
#[test]
fn map_and_set_agree() {
    assert_backends_agree(
        "map",
        "    biar m = peta_letak((peta_baru(()), (\"k\", \"v\")));\n\
         \x20   cetakln(peta_dapat((m, \"k\")));",
    );
    assert_backends_agree(
        "set",
        "    biar s = set_letak((set_baru(()), \"a\"));\n\
         \x20   cetakln(ke_teks(set_panjang(s)));",
    );
}
