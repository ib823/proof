// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `riinac emit-core` (REQ-110, mandate S1.2): the Coq core term a program
//! elaborates to, or a hard error naming the construct the core lacks.
//!
//! The term's constructors are held to `Syntax.v` by the unit test
//! `emit_core::tests::signatures_match_syntax_v`. Before printing, the binary
//! checks every term against those signatures and parses its own output back,
//! so each successful run here is also a round-trip check.
//!
//! On 2026-10-21 none of the 83 corpus examples that pass `riinac check` can
//! be written in the core: each uses an operator, a builtin, a mutable local,
//! `pulang`, a type the core lacks, or another unmodelled construct. The core
//! growing to the shipped language is REQ-99.

use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

fn riinac(args: &[&str], stdin: &str) -> (bool, String, String) {
    let mut child = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(args)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("run riinac");
    child
        .stdin
        .take()
        .expect("stdin")
        .write_all(stdin.as_bytes())
        .expect("write stdin");
    let out = child.wait_with_output().expect("riinac output");
    (
        out.status.success(),
        String::from_utf8_lossy(&out.stdout).into_owned(),
        String::from_utf8_lossy(&out.stderr).into_owned(),
    )
}

fn emit(source: &str) -> Result<String, String> {
    let (ok, out, err) = riinac(&["emit-core", "--stdin"], source);
    if ok {
        Ok(out.trim_end().to_string())
    } else {
        Err(err)
    }
}

fn repo() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).join("../../..")
}

#[test]
fn a_core_program_is_written_with_coq_constructors() {
    let src = "fungsi pilih_satu(b: Benar, x: Nombor, y: Nombor) -> Nombor kesan Bersih {\n\
               kalau b { x } lain { y }\n}\n\
               fungsi utama() -> Nombor kesan Bersih {\n biar r = pilih_satu(betul, 1, 2);\n r\n}\n";
    assert_eq!(
        emit(src).expect("emits"),
        r#"(ELet "pilih_satu" (EApp (ELam "ascribed" (TFn TBool (TFn TInt (TFn TInt TInt EffPure) EffPure) EffPure) (EVar "ascribed")) (ELam "b" TBool (ELam "x" TInt (ELam "y" TInt (EIf (EVar "b") (EVar "x") (EVar "y")))))) (ELet "utama" (EApp (ELam "ascribed" (TFn TUnit TInt EffPure) (EVar "ascribed")) (ELam "_unit" TUnit (ELet "r" (EApp (EApp (EApp (EVar "pilih_satu") (EBool true)) (EInt 1)) (EInt 2)) (EVar "r")))) (ELet "_" (EApp (EVar "utama") EUnit) EUnit)))"#
    );
}

#[test]
fn a_recursive_function_is_a_fix_and_a_group_follows_its_calls() {
    // `utama` is declared first but calls `sendiri`, so `sendiri` is bound first.
    let src = "fungsi utama() -> () kesan Bersih { sendiri(0) }\n\
               fungsi sendiri(n: Nombor) -> () kesan Bersih { sendiri(n) }\n";
    let out = emit(src).expect("emits");
    assert!(
        out.starts_with(r#"(ELet "sendiri" (EFix (ELam "sendiri" (TFn TInt TUnit EffPure) (ELam "n" TInt (EApp (EVar "sendiri") (EVar "n"))))) (ELet "utama" "#),
        "{out}"
    );
}

#[test]
fn security_constructs_and_references_are_core() {
    let src = "fungsi utama() -> Nombor kesan Tulis {\n\
               biar r = ruj 1 @Awam;\n\
               biar s = dedah (sulit 7) dengan bukti (sulit 7);\n\
               s\n}\n";
    let out = emit(src).expect("emits");
    for want in [
        r#"(ERef (EInt 1) LPublic)"#,
        r#"(EDeclassify (EClassify (EInt 7)) (EProve (EClassify (EInt 7))))"#,
        "EffWrite",
    ] {
        assert!(out.contains(want), "missing {want} in {out}");
    }
}

#[test]
fn the_output_is_deterministic() {
    let src = "fungsi a() -> () kesan Bersih { () }\nfungsi b() -> () kesan Bersih { a(()) }\n\
               fungsi c() -> () kesan Bersih { b(()) }\nfungsi utama() -> () kesan Bersih { c(()) }\n";
    let first = emit(src).expect("emits");
    for _ in 0..3 {
        assert_eq!(emit(src).expect("emits"), first);
    }
}

/// The `Rust` column rows `docs/spec/CORE_MAPPING.md` marks `unmodelled`.
fn unmodelled_rows() -> std::collections::BTreeSet<String> {
    let text = std::fs::read_to_string(repo().join("docs/spec/CORE_MAPPING.md"))
        .expect("read CORE_MAPPING.md");
    text.lines()
        .filter_map(|l| {
            let cells: Vec<&str> = l.split('|').map(str::trim).collect();
            (cells.len() > 3 && cells[3] == "unmodelled")
                .then(|| cells[1].trim_matches('`').to_string())
        })
        .collect()
}

/// The CORE_MAPPING row an emit-core error names: "… [CORE_MAPPING.md: Expr::BinOp] …".
fn error_row(err: &str) -> Option<String> {
    let start = err.find("[CORE_MAPPING.md: ")? + "[CORE_MAPPING.md: ".len();
    Some(err[start..start + err[start..].find(']')?].to_string())
}

/// A row an error may name although CORE_MAPPING does not mark it
/// `unmodelled`: builtins have their own section, a group of mutually
/// recursive functions is the one `LetRecGroup` shape with no encoding, and an
/// injection annotated with a non-sum type has no Coq form.
const SPECIAL_ROWS: &[&str] = &["Builtins", "Expr::LetRecGroup", "Expr::Inl", "Expr::Inr"];

fn assert_names_an_unmodelled_row(err: &str, rows: &std::collections::BTreeSet<String>) {
    let row = error_row(err).unwrap_or_else(|| panic!("error names no CORE_MAPPING row: {err}"));
    assert!(
        rows.contains(&row) || SPECIAL_ROWS.contains(&row.as_str()),
        "error names `{row}`, which CORE_MAPPING.md does not mark unmodelled: {err}"
    );
}

#[test]
fn an_unmodelled_construct_is_a_hard_error_naming_its_row() {
    let rows = unmodelled_rows();
    assert!(
        rows.len() > 50,
        "only {} unmodelled rows read from CORE_MAPPING.md",
        rows.len()
    );
    for (src, row) in [
        (
            "fungsi utama() -> Nombor kesan Bersih { 1 + 2 }",
            "Expr::BinOp",
        ),
        (
            "fungsi utama() -> () kesan Tulis { cetak(\"x\") }",
            "Builtins",
        ),
        (
            "fungsi utama() -> Nombor kesan Bersih { pulang 1; }",
            "Expr::Return",
        ),
        (
            "fungsi utama() -> Nombor kesan Bersih { biar ubah x = 1; x }",
            "Expr::LetMut",
        ),
        ("fungsi utama() -> i64 kesan Bersih { 7i64 }", "Expr::IntN"),
        (
            "fungsi utama() -> () kesan Bersih { biar f = fn(x: i64) -> () { () }; () }",
            "Ty::IntN",
        ),
        (
            "fungsi utama() -> () kesan Bersih { biar xs = [1]; () }",
            "Expr::ListLit",
        ),
        (
            "fungsi a() -> () kesan Bersih { b(()) }\nfungsi b() -> () kesan Bersih { a(()) }",
            "Expr::LetRecGroup",
        ),
    ] {
        let err = emit(src).expect_err(src);
        assert_eq!(error_row(&err).as_deref(), Some(row), "{src}: {err}");
        assert_names_an_unmodelled_row(&err, &rows);
        assert!(err.contains("mandate R3"), "{err}");
    }
}

#[test]
fn emit_core_takes_no_other_options() {
    let (ok, _, err) = riinac(
        &["emit-core", "--stdin", "--json"],
        "fungsi utama() -> () kesan Bersih { () }",
    );
    assert!(
        !ok && err.contains("emit-core takes no options other than --stdin"),
        "{err}"
    );
}

/// How many corpus examples that pass `riinac check` emit-core can write in
/// the core. A change in either direction must update this number and the
/// REQ-110 row in RIINA_MASTER_PLAN.md in the same commit.
const EMIT_CORE_PASSING: usize = 0;

fn rii_files(dir: &Path, out: &mut Vec<PathBuf>) {
    let mut entries: Vec<_> = std::fs::read_dir(dir)
        .expect("read dir")
        .flatten()
        .map(|e| e.path())
        .collect();
    entries.sort();
    for p in entries {
        if p.is_dir() {
            rii_files(&p, out);
        } else if p.extension().is_some_and(|e| e == "rii") {
            out.push(p);
        }
    }
}

#[test]
fn every_checked_example_emits_or_names_what_the_core_lacks() {
    let rows = unmodelled_rows();
    let mut files = Vec::new();
    rii_files(&repo().join("07_EXAMPLES"), &mut files);
    let (mut checked, mut emitted) = (0, 0);
    let mut by_row: std::collections::BTreeMap<String, usize> = std::collections::BTreeMap::new();
    for f in &files {
        let path = f.to_string_lossy().into_owned();
        if !riinac(&["check", &path], "").0 {
            continue;
        }
        checked += 1;
        let (ok, out, err) = riinac(&["emit-core", &path], "");
        if ok {
            emitted += 1;
            assert!(
                out.starts_with('(') || out.trim_end().chars().all(|c| c.is_ascii_alphanumeric()),
                "{path}: {out}"
            );
        } else {
            assert_names_an_unmodelled_row(&err, &rows);
            *by_row
                .entry(error_row(&err).unwrap_or_default())
                .or_default() += 1;
        }
    }
    eprintln!("emit-core: {emitted} of {checked} checked examples emit; first unmodelled construct: {by_row:?}");
    assert!(
        checked > 50,
        "only {checked} examples pass check: the corpus walk is broken"
    );
    assert_eq!(
        emitted, EMIT_CORE_PASSING,
        "{emitted} of {checked} checked examples emit (recorded: {EMIT_CORE_PASSING}); update \
         EMIT_CORE_PASSING and the REQ-110 row together"
    );
}
