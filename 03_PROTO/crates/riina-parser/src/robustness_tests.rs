// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Termination and stack-depth robustness of the parser.
//!
//! * Every token-skipping loop must stop at end of input. The lexer yields
//!   `Eof` forever (never `None`), so a loop that only watched for its closing
//!   token or `None` spun at 100% CPU: `jenis T =` and `guna std::teks` without
//!   a `;`, or an unclosed `modul m {`, hung `riinac check`/`fmt`, the LSP and
//!   MCP.
//! * Flat input — long statement sequences, operator chains, `lain kalau`
//!   chains, runs of skipped declarations — is parsed iteratively, so it needs
//!   no stack in proportion to its length; past `limits::MAX_AST_DEPTH` it is
//!   rejected with a clean error instead of being handed to later stages.
//! * Every genuinely recursive path is charged against the nesting guard.

use crate::{limits, ParseErrorKind, Parser};
use riina_types::{Expr, Program, TopLevelDecl};
use std::sync::mpsc;
use std::time::Duration;

/// Outcome of a bounded parse, reduced to what the tests inspect so the
/// (possibly very deep) tree never leaves the worker thread.
#[derive(Debug)]
enum Outcome {
    Parsed { decls: Vec<String>, max_depth: usize },
    Failed(ParseErrorKind),
}

fn decl_label(d: &TopLevelDecl) -> String {
    match d {
        TopLevelDecl::Function { name, .. } => format!("fn {name}"),
        TopLevelDecl::Binding { name, .. } => format!("let {name}"),
        TopLevelDecl::Expr(e) if matches!(**e, Expr::Unit) => "expr ()".to_string(),
        TopLevelDecl::Expr(_) => "expr".to_string(),
        TopLevelDecl::ExternBlock { .. } => "extern".to_string(),
        TopLevelDecl::Test { name, .. } => format!("test {name}"),
    }
}

/// Parse `src` on a worker thread with `stack` bytes of stack, failing the
/// test if the parser does not finish within `secs` seconds (a hang) — and,
/// because a stack overflow aborts the whole process, any overflow is fatal
/// to the run rather than silently passing. The tree is dismantled without
/// recursion on the worker.
fn parse_bounded(src: &str, stack: usize, secs: u64) -> Outcome {
    let owned = src.to_string();
    let (tx, rx) = mpsc::channel();
    std::thread::Builder::new()
        .stack_size(stack)
        .spawn(move || {
            let outcome = match Parser::new(&owned).parse_program() {
                Ok(Program { decls, spans, .. }) => {
                    let labels = decls.iter().map(decl_label).collect();
                    let max_depth = decls.iter().map(limits::decl_depth).max().unwrap_or(0);
                    for d in decls {
                        limits::dismantle_decl(d);
                    }
                    for s in spans {
                        limits::dismantle_decl(s.decl);
                    }
                    Outcome::Parsed {
                        decls: labels,
                        max_depth,
                    }
                }
                Err(e) => Outcome::Failed(e.kind),
            };
            let _ = tx.send(outcome);
        })
        .expect("spawn parser thread");
    rx.recv_timeout(Duration::from_secs(secs)).unwrap_or_else(|_| {
        panic!(
            "parser did not terminate within {secs}s on {:?}",
            src.chars().take(80).collect::<String>()
        )
    })
}

/// Stack for inputs that hit the nesting guard. The guard bounds the parser's
/// recursion to ~15 MiB in an unoptimised build at the very worst (measured:
/// ~115 KiB per parenthesised level, ~95 KiB per `[`, ~47 KiB per `!`), and
/// far less optimised; 32 MiB leaves 2x margin.
const NEST_STACK: usize = 32 * 1024 * 1024;
const BIG_STACK: usize = 64 * 1024 * 1024;

#[test]
fn every_skipping_loop_stops_at_end_of_input() {
    // The three hangs from the audit, then every other loop that skips or
    // scans tokens, each cut off at end of input. All must be errors.
    let cases = [
        "jenis t=",
        "jenis T = ",
        "jenis T = Senarai<Nombor>",
        "guna std::teks",
        "guna std::teks fungsi f() -> Nombor kesan Bersih { 1 }",
        "guna",
        "modul m {",
        "modul m { fungsi f() -> Nombor kesan Bersih { 1 }",
        "modul m { biar x = 1",
        "modul m",
        "jenis T<",
        "jenis T<A, <B",
        "jenis T {",
        "bentuk S {",
        "pilihan E { A, B",
        "luaran \"C\" {",
        "luaran \"C\" { fungsi f(",
        "fungsi f(",
        "fungsi f<T",
        "fungsi f() -> Nombor kesan Bersih {",
        "fungsi f() -> Nombor kesan Bersih { padan x {",
        "fungsi f() -> Nombor kesan Bersih { padan x { [a, b",
        "fungsi f() -> Nombor kesan Bersih { [1, 2",
        "fungsi f() -> Nombor kesan Bersih { Titik { x: 1",
        "fungsi f() -> Nombor kesan Bersih { kalau a { 1 } lain kalau",
        "fungsi f() -> Nombor kesan Bersih { selagi a {",
        "fungsi f() -> Nombor kesan Bersih { pastikan a lain {",
        "fungsi f() -> Nombor kesan Bersih { paparan {",
        "fungsi f() -> Nombor kesan Bersih { gaya {",
        "fungsi f() -> Nombor kesan Bersih { format!(\"{}\", ",
        "awam",
        "awam guna",
    ];
    for src in cases {
        match parse_bounded(src, NEST_STACK, 5) {
            Outcome::Failed(_) => {}
            other => panic!("{src:?} must be a parse error, got {other:?}"),
        }
    }
}

#[test]
fn a_missing_alias_semicolon_is_an_error() {
    // Used to be silently accepted (and, before that, to hang).
    assert!(matches!(
        parse_bounded("jenis T = Nombor", NEST_STACK, 5),
        Outcome::Failed(ParseErrorKind::UnexpectedToken(_))
    ));
    // The terminated forms still parse.
    for src in ["jenis T = Nombor;", "guna std::teks;", "modul m { }", "modul m;"] {
        assert!(
            matches!(parse_bounded(src, NEST_STACK, 5), Outcome::Parsed { .. }),
            "{src}"
        );
    }
}

#[test]
fn trailing_skipped_declarations_keep_the_program_intact() {
    // A trailing `guna`/`jenis` used to leave a synthetic `()` declaration
    // behind, which desugaring took as the program BODY — so `utama` never
    // ran. A trailing `modul` lost its flattened functions.
    let utama = "fungsi utama() -> Kosong kesan Tulis { cetakln(\"hai\"); }\n";
    for tail in ["guna std::teks;", "jenis T = Nombor;", "bentuk S { x: Nombor }"] {
        match parse_bounded(&format!("{utama}{tail}"), NEST_STACK, 5) {
            Outcome::Parsed { decls, .. } => assert_eq!(decls, ["fn utama"], "{tail}"),
            other => panic!("{tail}: {other:?}"),
        }
    }
    let src = format!(
        "{utama}modul m {{ fungsi f() -> Nombor kesan Bersih {{ 1 }} fungsi g() -> Nombor kesan Bersih {{ 2 }} }}"
    );
    match parse_bounded(&src, NEST_STACK, 5) {
        Outcome::Parsed { decls, .. } => assert_eq!(decls, ["fn utama", "fn m_f", "fn m_g"]),
        other => panic!("{other:?}"),
    }
}

#[test]
fn a_long_run_of_skipped_declarations_is_iterative() {
    // Each `guna`/`jenis` declaration used to recurse once. (Each alias needs
    // its own name: a type declared twice is an error.)
    let decls: String = (0..50_000)
        .map(|i| format!("guna std::teks;\njenis T{i} = Nombor;\n"))
        .collect();
    let src = format!("{decls}fungsi utama() -> Nombor kesan Bersih {{ 0 }}");
    match parse_bounded(&src, NEST_STACK, 30) {
        Outcome::Parsed { decls, .. } => assert_eq!(decls, ["fn utama"]),
        other => panic!("{other:?}"),
    }
}

/// Deeply nested input of every recursive shape is a clean `NestingTooDeep`
/// within a bounded stack — before the guard covered every recursive path,
/// several of these overflowed ANY stack at a few thousand levels.
#[test]
fn every_recursive_path_is_bounded_by_the_nesting_guard() {
    const N: usize = 50_000;
    let body = |inner: String| format!("fungsi f() -> Nombor kesan Bersih {{ {inner} }}");
    let cases: Vec<(&str, String)> = vec![
        ("parens", body(format!("{}1{}", "(".repeat(N), ")".repeat(N)))),
        ("brackets", body(format!("{}1{}", "[".repeat(N), "]".repeat(N)))),
        ("deref", body(format!("{}x", "!".repeat(N)))),
        ("not", body(format!("{}betul", "bukan ".repeat(N)))),
        ("calls", body(format!("{}1{}", "g(".repeat(N), ")".repeat(N)))),
        ("lambdas", body(format!("{}1", "fungsi(x: Nombor) ".repeat(N)))),
        (
            "block lambdas",
            body(format!("{}1{}", "fungsi(x: Nombor) { ".repeat(N), " }".repeat(N))),
        ),
        (
            "match arms",
            body(format!("{}1{}", "padan 1 { _ -> { ".repeat(N), " } }".repeat(N))),
        ),
        ("assignments", body(format!("{}1", "r := ".repeat(N)))),
        ("ref", body(format!("{}1", "ruj ".repeat(N)))),
        (
            "local fns",
            body(format!(
                "{}1{}",
                "fungsi g() -> Nombor kesan Bersih { ".repeat(N),
                " }".repeat(N)
            )),
        ),
        (
            "types",
            format!(
                "fungsi f(x: {}Nombor{}) -> Nombor kesan Bersih {{ 0 }}",
                "Senarai<".repeat(N),
                ">".repeat(N)
            ),
        ),
        (
            "patterns",
            body(format!("padan 1 {{ {}x{} -> 0 }}", "(".repeat(N), ")".repeat(N))),
        ),
    ];
    for (shape, src) in cases {
        match parse_bounded(&src, NEST_STACK, 30) {
            Outcome::Failed(ParseErrorKind::NestingTooDeep) => {}
            other => panic!("{shape}: expected NestingTooDeep, got {other:?}"),
        }
    }
}

#[test]
fn nesting_within_the_limit_still_parses() {
    // ~100 nested parentheses were accepted before the guard was extended to
    // every recursive path; they still are.
    let src = format!(
        "fungsi f() -> Nombor kesan Bersih {{ {}1{} }}",
        "(".repeat(95),
        ")".repeat(95)
    );
    assert!(matches!(
        parse_bounded(&src, NEST_STACK, 5),
        Outcome::Parsed { .. }
    ));
}

/// Flat input parses without stack in proportion to its length. Each of these
/// overflowed the stack when the parser recursed per statement / link (the
/// remaining stack use is the derived `Clone` of the finished tree, which
/// `parse_program` keeps for spans).
#[test]
fn long_flat_input_is_parsed_iteratively() {
    const N: usize = 10_000;
    let fun = |body: String| format!("fungsi f() -> Nombor kesan Bersih {{ {body} }}");
    let cases = vec![
        (
            "biar",
            fun(format!("{}0", (0..N).map(|i| format!("biar x{i} = {i}; ")).collect::<String>())),
        ),
        ("sum", fun(vec!["1"; N].join(" + "))),
        (
            "lain kalau",
            fun(format!(
                "{}{{ 0 }}",
                (0..N).map(|i| format!("kalau a == {i} {{ {i} }} lain ")).collect::<String>()
            )),
        ),
        ("pastikan", fun(format!("{}0", "pastikan betul; ".repeat(N)))),
        ("statements", fun(format!("{}0", "cetak(\"a\"); ".repeat(N)))),
        ("ubah", fun(format!("biar ubah x = 0; {}x", "x = x + 1; ".repeat(N)))),
    ];
    for (shape, src) in cases {
        // 64 MiB: the parser itself no longer needs stack per statement, but
        // `parse_program` keeps a (recursive) `Clone` of each finished tree
        // for its spans. Recursing per statement needed far more than this.
        match parse_bounded(&src, BIG_STACK, 60) {
            Outcome::Parsed { max_depth, .. } => {
                assert!(max_depth > N, "{shape}: depth {max_depth}");
                assert!(max_depth < limits::MAX_AST_DEPTH, "{shape}: depth {max_depth}");
            }
            other => panic!("{shape}: {other:?}"),
        }
    }
}

/// Past `MAX_AST_DEPTH` the program is rejected with `ProgramTooDeep`, both
/// for a single over-long chain (stopped while it is built) and for chains
/// that are each within the cap but combine past it (caught after the
/// declaration is parsed, then taken apart without recursion).
#[test]
fn over_deep_programs_are_rejected_cleanly() {
    let over = limits::MAX_AST_DEPTH + 5_000;
    let half = limits::MAX_AST_DEPTH / 2 + 2_000;
    let fun = |body: String| format!("fungsi f() -> Nombor kesan Bersih {{ {body} }}");
    let cases = vec![
        ("biar", fun(format!("{}0", "biar x = 1; ".repeat(over)))),
        ("sum", fun(vec!["1"; over].join(" + "))),
        ("product", fun(vec!["1"; over].join(" * "))),
        ("pipe", fun(format!("1{}", " |> g".repeat(over)))),
        ("postfix", fun(format!("p{}", ".f".repeat(over)))),
        ("calls", fun(format!("g{}", "(1)".repeat(over)))),
        ("tuple", fun(format!("({})", vec!["1"; over].join(", ")))),
        (
            "format!",
            fun(format!("format!(\"{}\")", "{}".repeat(over / 2 + 10))),
        ),
        (
            "nested chains",
            fun(format!(
                "({}) + {}",
                vec!["1"; half].join(" + "),
                vec!["1"; half].join(" + ")
            )),
        ),
        (
            "declarations",
            "fungsi g() -> Nombor kesan Bersih { 0 }\n".repeat(over),
        ),
    ];
    for (shape, src) in cases {
        match parse_bounded(&src, BIG_STACK, 120) {
            Outcome::Failed(ParseErrorKind::ProgramTooDeep { limit, .. }) => {
                assert_eq!(limit, limits::MAX_AST_DEPTH, "{shape}");
            }
            other => panic!("{shape}: expected ProgramTooDeep, got {other:?}"),
        }
    }
}

#[test]
fn program_too_deep_has_its_own_code_and_hint() {
    let kind = ParseErrorKind::ProgramTooDeep {
        depth: 30_000,
        limit: 20_000,
    };
    assert_eq!(kind.error_code(), "P0014");
    assert!(kind.to_string().contains("30000"));
    assert!(kind.fix_hint().unwrap().contains("smaller functions"));
}

/// A lexical error ends the token stream, and the top-level loop used to take
/// that for the end of the FILE: a stray character between declarations
/// silently discarded every declaration after it, and the program ran
/// without them.
#[test]
fn a_lexical_error_is_reported_not_taken_for_end_of_file() {
    let src = "fungsi utama() -> Kosong kesan Tulis { cetakln(\"a\"); }\n`\n\
               fungsi g() -> Nombor kesan Bersih { 1 }\n";
    match parse_bounded(src, NEST_STACK, 5) {
        Outcome::Failed(ParseErrorKind::Lex(_)) => {}
        other => panic!("expected a lexical error, got {other:?}"),
    }
    // Mid-expression the cause is the lexical error, not "end of input".
    match parse_bounded("fungsi f() -> Nombor kesan Bersih { 1 + ` }", NEST_STACK, 5) {
        Outcome::Failed(ParseErrorKind::Lex(e)) => assert_eq!(e.error_code(), "L0001"),
        other => panic!("expected a lexical error, got {other:?}"),
    }
}

