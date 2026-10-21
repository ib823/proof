// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `docs/spec/CORE_MAPPING.md` maps the whole AST in both directions (mandate
//! S1.1, REQ-99), and stays true.
//!
//! The Coq core (`02_FORMAL/coq/foundations/Syntax.v`) is the normative
//! definition of the language. The shipped compiler's AST
//! (`riina-types/src/lib.rs`) is much larger, and until 2026-10-20 nothing said
//! which of its constructs the proofs cover: comments in `riina-types` claimed
//! `Effect` "matches Coq `effect`" (it has two more variants, so every level
//! from `Read` up differs) and `Ty` "matches Coq `ty`" (45 variants against
//! 22).
//!
//! This test reads both definitions and the lexer's keyword table, and fails
//! when:
//! * a Rust variant or a Coq constructor has no row, or a row names one that
//!   no longer exists (100% / 100%);
//! * a row's status is outside the vocabulary, or it points at a constructor
//!   the other side does not have, or the two directions disagree;
//! * a keyword token has no row, its spellings differ from the lexer's, a
//!   `reserved` keyword parses, or a `soft` one does not work as a name;
//! * an elaboration the page states no longer matches the parser;
//! * the website lists a keyword with no meaning as a working one.

use std::collections::{BTreeMap, BTreeSet};
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::atomic::{AtomicUsize, Ordering};

use riina_parser::Parser;

const DOC: &str = "docs/spec/CORE_MAPPING.md";

/// The Rust enums the page maps. A new enum in the AST that carries meaning
/// is added here and to the page.
const RUST_ENUMS: &[&str] = &[
    "Expr",
    "Ty",
    "Effect",
    "SecurityLevel",
    "SessionType",
    "TaintSource",
    "Sanitizer",
    "CapabilityKind",
    "Capability",
    "BinOp",
    "Linearity",
];

/// The Coq inductives of `Syntax.v` the page maps.
const COQ_INDUCTIVES: &[&str] = &[
    "expr",
    "ty",
    "session_type",
    "effect",
    "security_level",
    "taint_source",
    "sanitizer",
    "sanitizer_comp",
    "capability_kind",
    "capability",
];

const RUST_STATUSES: &[&str] = &["core", "refined", "elaborated", "unmodelled"];
const COQ_STATUSES: &[&str] = &["core", "refined", "coq-only"];
const KINDS: &[&str] = &["construct", "part", "soft", "reserved"];

fn repo_root() -> PathBuf {
    // .../03_PROTO/crates/riinac -> repo root
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root above 03_PROTO/crates/riinac")
        .to_path_buf()
}

fn read(rel: &str) -> String {
    fs::read_to_string(repo_root().join(rel)).unwrap_or_else(|e| panic!("read {rel}: {e}"))
}

/// The variants of `pub enum <name>`: identifiers at exactly four spaces of
/// indentation (fields of a struct variant sit deeper).
fn rust_variants(src: &str, name: &str) -> Vec<String> {
    let header = format!("pub enum {name} {{");
    let mut lines = src.lines().skip_while(|l| !l.starts_with(&header));
    assert!(lines.next().is_some(), "riina-types has no `{header}`");
    let mut out = Vec::new();
    for line in lines {
        if line == "}" {
            break;
        }
        let Some(rest) = line.strip_prefix("    ") else { continue };
        if rest.starts_with(' ') || rest.starts_with("//") || rest.starts_with("#[") {
            continue;
        }
        let ident: String = rest.chars().take_while(|c| c.is_ascii_alphanumeric() || *c == '_').collect();
        if ident.starts_with(|c: char| c.is_ascii_uppercase()) {
            out.push(ident);
        }
    }
    out
}

/// `src` with every `(* … *)` comment removed (Coq comments nest).
fn strip_coq_comments(src: &str) -> String {
    let b: Vec<char> = src.chars().collect();
    let (mut out, mut depth, mut i) = (String::new(), 0usize, 0usize);
    while i < b.len() {
        if b[i] == '(' && b.get(i + 1) == Some(&'*') {
            depth += 1;
            i += 2;
        } else if depth > 0 && b[i] == '*' && b.get(i + 1) == Some(&')') {
            depth -= 1;
            i += 2;
        } else {
            if depth == 0 {
                out.push(b[i]);
            }
            i += 1;
        }
    }
    out
}

/// The constructors of `Inductive <name> : Type :=` (or `with <name> : Type :=`).
fn coq_constructors(src: &str, name: &str) -> Vec<String> {
    let src = strip_coq_comments(src);
    let start = [format!("Inductive {name} : Type :="), format!("with {name} : Type :=")]
        .iter()
        .find_map(|h| src.find(h.as_str()).map(|p| p + h.len()))
        .unwrap_or_else(|| panic!("Syntax.v has no inductive `{name}`"));
    let body = &src[start..];
    let end = [body.find('.'), body.find("\nwith ")]
        .into_iter()
        .flatten()
        .min()
        .expect("end of inductive");
    body[..end]
        .split('|')
        .filter_map(|c| {
            let ident: String = c.trim().chars().take_while(|c| c.is_ascii_alphanumeric() || *c == '_').collect();
            (!ident.is_empty()).then_some(ident)
        })
        .collect()
}

/// Keyword token -> its spellings, from the lexer's identifier match.
fn lexer_keywords(src: &str) -> BTreeMap<String, BTreeSet<String>> {
    let start = src.find("match s.as_str() {").expect("keyword match in the lexer");
    let end = src[start..].find("_ => TokenKind::Identifier(s)").expect("end of keyword match") + start;
    let mut out: BTreeMap<String, BTreeSet<String>> = BTreeMap::new();
    for arm in src[start..end].split(',') {
        let Some((pats, tok)) = arm.split_once("=> TokenKind::") else { continue };
        let tok: String = tok.trim().chars().take_while(|c| c.is_ascii_alphanumeric() || *c == '_').collect();
        if !tok.starts_with("Kw") {
            continue;
        }
        let spellings = pats.split('"').skip(1).step_by(2).map(str::to_string);
        out.entry(tok).or_default().extend(spellings);
    }
    out
}

#[derive(Debug)]
struct Row {
    line: usize,
    cells: Vec<String>,
}

/// The single backticked token a cell consists of, if it is exactly one.
fn single_code(cell: &str) -> Option<&str> {
    let inner = cell.strip_prefix('`')?.strip_suffix('`')?;
    (!inner.contains('`')).then_some(inner)
}

/// Backticked tokens in a cell.
fn codes(cell: &str) -> Vec<&str> {
    cell.split('`').skip(1).step_by(2).collect()
}

fn is_ident(s: &str) -> bool {
    !s.is_empty() && s.chars().all(|c| c.is_ascii_alphanumeric() || c == '_')
}

/// Table rows of the page, split into Rust (`Enum::Variant`), Coq
/// (`Constructor`) and keyword (`KwX`) rows by the shape of the first cell.
#[derive(Default)]
struct Page {
    rust: BTreeMap<String, Row>,
    coq: BTreeMap<String, Row>,
    keywords: BTreeMap<String, Row>,
    duplicates: Vec<String>,
}

fn parse_page(doc: &str) -> Page {
    let mut page = Page::default();
    for (i, line) in doc.lines().enumerate() {
        let Some(inner) = line.strip_prefix('|').and_then(|l| l.strip_suffix('|')) else { continue };
        // `\|` is an escaped pipe inside a cell.
        let cells: Vec<String> = inner
            .replace("\\|", "\u{1}")
            .split('|')
            .map(|c| c.trim().replace('\u{1}', "|"))
            .collect();
        let Some(key) = single_code(&cells[0]).map(str::to_string) else { continue };
        let row = Row { line: i + 1, cells };
        let target = match key.split_once("::") {
            Some((e, v)) if is_ident(e) && is_ident(v) => &mut page.rust,
            None if key.starts_with("Kw") && is_ident(&key) => &mut page.keywords,
            None if key.starts_with(|c: char| c.is_ascii_uppercase()) && is_ident(&key) => &mut page.coq,
            _ => continue,
        };
        if target.insert(key.clone(), row).is_some() {
            page.duplicates.push(key);
        }
    }
    page
}

struct Truth {
    rust: BTreeSet<String>,
    coq: BTreeSet<String>,
    keywords: BTreeMap<String, BTreeSet<String>>,
}

fn truth() -> Truth {
    let types = read("03_PROTO/crates/riina-types/src/lib.rs");
    let syntax = read("02_FORMAL/coq/foundations/Syntax.v");
    let lexer = read("03_PROTO/crates/riina-lexer/src/lexer.rs");
    let rust = RUST_ENUMS
        .iter()
        .flat_map(|e| rust_variants(&types, e).into_iter().map(move |v| format!("{e}::{v}")))
        .collect();
    let coq = COQ_INDUCTIVES.iter().flat_map(|i| coq_constructors(&syntax, i)).collect();
    Truth { rust, coq, keywords: lexer_keywords(&lexer) }
}

/// Every rule the page must satisfy that does not need the compiler.
fn page_errors(page: &Page, t: &Truth) -> Vec<String> {
    let mut errs: Vec<String> = page.duplicates.iter().map(|k| format!("`{k}` has two rows")).collect();
    let keys = |m: &BTreeMap<String, Row>| m.keys().cloned().collect::<BTreeSet<_>>();
    for (side, want, have) in [("Rust", &t.rust, keys(&page.rust)), ("Coq", &t.coq, keys(&page.coq))] {
        for k in want.difference(&have) {
            errs.push(format!("{side} `{k}` has no row in {DOC}"));
        }
        for k in have.difference(want) {
            errs.push(format!("{DOC} has a row for `{k}`, which {side} does not define"));
        }
    }
    let want_kw: BTreeSet<String> = t.keywords.keys().cloned().collect();
    for k in want_kw.difference(&keys(&page.keywords)) {
        errs.push(format!("keyword token `{k}` has no row in {DOC}"));
    }
    for k in keys(&page.keywords).difference(&want_kw) {
        errs.push(format!("{DOC} has a row for `{k}`, which the lexer does not define"));
    }

    for (key, row) in &page.rust {
        let at = format!("{DOC}:{}: `{key}`", row.line);
        if row.cells.len() != 4 {
            errs.push(format!("{at}: a Rust row has 4 cells (Rust | Coq | Status | Notes)"));
            continue;
        }
        let (coq, status) = (&row.cells[1], row.cells[2].as_str());
        if !RUST_STATUSES.contains(&status) {
            errs.push(format!("{at}: status `{status}` is not one of {RUST_STATUSES:?}"));
        } else if status == "unmodelled" {
            if coq != "—" {
                errs.push(format!("{at}: an unmodelled row names no Coq constructor (`—`)"));
            }
        } else if codes(coq).is_empty() {
            errs.push(format!("{at}: a `{status}` row names its Coq constructor(s)"));
        }
        for c in codes(coq) {
            if !t.coq.contains(c) {
                errs.push(format!("{at}: Coq has no constructor `{c}`"));
            }
        }
        if matches!(status, "core" | "refined") {
            let back = codes(coq).first().and_then(|c| page.coq.get(*c));
            if back.map(|r| single_code(&r.cells[1]) != Some(key.as_str())).unwrap_or(true) {
                errs.push(format!("{at}: the Coq row for {coq} must map back to `{key}`"));
            }
        }
    }
    for (key, row) in &page.coq {
        let at = format!("{DOC}:{}: `{key}`", row.line);
        if row.cells.len() != 4 {
            errs.push(format!("{at}: a Coq row has 4 cells (Coq | Rust | Status | Notes)"));
            continue;
        }
        let (rust, status) = (&row.cells[1], row.cells[2].as_str());
        if !COQ_STATUSES.contains(&status) {
            errs.push(format!("{at}: status `{status}` is not one of {COQ_STATUSES:?}"));
        } else if status == "coq-only" {
            if rust != "—" {
                errs.push(format!("{at}: a coq-only row names no Rust variant (`—`)"));
            }
        } else {
            match single_code(rust) {
                Some(r) if t.rust.contains(r) => {
                    let fwd = page.rust.get(r).map(|row| codes(&row.cells[1]).contains(&key.as_str()));
                    if fwd != Some(true) {
                        errs.push(format!("{at}: the Rust row for `{r}` must name `{key}`"));
                    }
                }
                _ => errs.push(format!("{at}: `{rust}` is not a Rust variant")),
            }
        }
    }
    for (key, row) in &page.keywords {
        let at = format!("{DOC}:{}: `{key}`", row.line);
        if row.cells.len() != 4 {
            errs.push(format!("{at}: a keyword row has 4 cells (Token | Spellings | Kind | Elaborates to)"));
            continue;
        }
        let spellings: BTreeSet<String> = codes(&row.cells[1]).into_iter().map(str::to_string).collect();
        if let Some(want) = t.keywords.get(key) {
            if &spellings != want {
                errs.push(format!("{at}: spellings {spellings:?}, but the lexer has {want:?}"));
            }
        }
        let kind = row.cells[2].as_str();
        if !KINDS.contains(&kind) {
            errs.push(format!("{at}: kind `{kind}` is not one of {KINDS:?}"));
        }
        if matches!(kind, "construct" | "part") && row.cells[3].is_empty() {
            errs.push(format!("{at}: a `{kind}` keyword says what it elaborates to"));
        }
    }
    errs
}

fn kinds(page: &Page) -> BTreeMap<String, String> {
    page.keywords.iter().map(|(k, r)| (k.clone(), r.cells[2].clone())).collect()
}

#[test]
fn the_mapping_covers_both_sides_exactly() {
    let t = truth();
    // The parsers themselves must not have silently found nothing.
    assert!(t.rust.len() > 200 && t.coq.len() > 130 && t.keywords.len() > 100);
    assert!(t.rust.contains("Expr::LetRecGroup") && t.coq.contains("EFix") && t.coq.contains("SessVar"));
    let page = parse_page(&read(DOC));
    let errs = page_errors(&page, &t);
    assert!(errs.is_empty(), "{} problem(s):\n  {}", errs.len(), errs.join("\n  "));
}

fn check(src: &str) -> (bool, String) {
    static N: AtomicUsize = AtomicUsize::new(0);
    let dir = std::env::temp_dir().join(format!("riina_core_mapping_{}", std::process::id()));
    fs::create_dir_all(&dir).expect("mkdir");
    let path = dir.join(format!("k{}.rii", N.fetch_add(1, Ordering::Relaxed)));
    fs::write(&path, src).expect("write");
    let out = Command::new(env!("CARGO_BIN_EXE_riinac")).arg("check").arg(&path).output().expect("riinac");
    let _ = fs::remove_file(&path);
    let text = format!("{}{}", String::from_utf8_lossy(&out.stdout), String::from_utf8_lossy(&out.stderr));
    (out.status.success(), text)
}

#[test]
fn reserved_keywords_are_rejected_and_soft_ones_are_names() {
    let t = truth();
    let page = parse_page(&read(DOC));
    let mut errs = Vec::new();
    for (tok, kind) in kinds(&page) {
        for spelling in t.keywords.get(&tok).into_iter().flatten() {
            match kind.as_str() {
                "reserved" => {
                    let (ok, out) = check(&format!(
                        "fungsi utama() -> Unit kesan Bersih {{ biar x = {spelling}; () }}\n"
                    ));
                    if ok || !out.contains(&tok) {
                        errs.push(format!("`{spelling}` ({tok}) is `reserved`, but: {}", out.trim()));
                    }
                }
                "soft" => {
                    let (ok, out) = check(&format!(
                        "fungsi f() -> Nombor kesan Bersih {{ biar {spelling} = 1; {spelling} }}\n"
                    ));
                    if !ok {
                        errs.push(format!("`{spelling}` ({tok}) is `soft`, but as a name: {}", out.trim()));
                    }
                }
                _ => {}
            }
        }
    }
    assert!(errs.is_empty(), "{} keyword(s) misdescribed:\n  {}", errs.len(), errs.join("\n  "));
}

/// A keyword spelling that can be bound as a name can also be read back. Eight
/// construct keywords (`token`, `tulisan`, `paparan`, `baris`, `lajur`,
/// `gabung`, `warna`, `gaya`) were accepted by `biar`, but every read parsed as
/// the keyword's construct, so the binding was write-only. A bound name now
/// shadows the construct.
#[test]
fn a_keyword_that_can_be_bound_can_be_read() {
    let t = truth();
    let mut errs = Vec::new();
    for (tok, spellings) in &t.keywords {
        for spelling in spellings {
            let bind = format!("fungsi f() -> Nombor kesan Bersih {{ biar {spelling} = 1; 0 }}\n");
            if !check(&bind).0 {
                continue; // not accepted as a name at all
            }
            for read in [
                spelling.to_string(),
                format!("biar p = ({spelling}, 2); 0"),
                format!("g({spelling})"),
            ] {
                let src = format!(
                    "fungsi g(x: Nombor) -> Nombor kesan Bersih {{ x }}\n\
                     fungsi f() -> Nombor kesan Bersih {{ biar {spelling} = 1; {read} }}\n"
                );
                let (ok, out) = check(&src);
                if !ok {
                    errs.push(format!("`{spelling}` ({tok}) binds but `{read}` fails: {}", out.trim()));
                }
            }
        }
    }
    assert!(errs.is_empty(), "write-only keyword bindings:\n  {}", errs.join("\n  "));
}

/// The elaborations the page states, as the parser produces them. When the
/// parser changes one of these, the page is re-read and this list updated.
#[test]
fn the_stated_elaborations_are_what_the_parser_produces() {
    let exprs = [
        ("kalau betul { 1 } lain { 2 }", "If(Bool(true), Int(1), Int(2))"),
        ("ulang { putus }", "While(Bool(true), Break)"),
        ("bukan betul", "If(Bool(true), Bool(false), Bool(true))"),
        ("padan x { Ada(y) -> y, Tiada -> 0 }", r#"Case(Var("x"), "y", Var("y"), "$padR0", Int(0))"#),
        ("padan x { 1 -> 2, _ -> 3 }", r#"Let("$padS0", None, Var("x"), If(BinOp(Eq, Var("$padS0"), Int(1)), Int(2), Int(3)))"#),
        ("xs[0]", r#"App(Var("senarai_dapat"), Pair(Var("xs"), Int(0)))"#),
        ("x |> f", r#"App(Var("f"), Var("x"))"#),
        ("1..5", r#"App(Var("julat"), Pair(Int(1), Int(5)))"#),
        ("Titik(1, 2)", r#"Pair(String("Titik"), Pair(Int(1), Int(2)))"#),
        ("a::b", r#"Var("a_b")"#),
        ("dedah(a, b)", r#"Declassify(Var("a"), Var("b"))"#),
        ("lahir P(0)", r#"Spawn(Var("P"), Int(0))"#),
        ("token::pindah(a, b, 5)", r#"TokenTransfer { from: Var("a"), to: Var("b"), amount: Int(5) }"#),
        ("zakat(100)", "ZakatCalculate(Int(100))"),
        ("f(a, b)", r#"App(App(Var("f"), Var("a")), Var("b"))"#),
        ("f()", r#"App(Var("f"), Unit)"#),
        ("0xFF", "Int(255)"),
        ("Ada(1)", "Inl(Int(1), Any)"),
        ("Tiada", "Inr(Unit, Any)"),
    ];
    let programs = [
        (
            "fungsi f() -> Nombor kesan Bersih { biar ubah x = 1; x = 2; x }",
            r#"LetRecGroup([("f", Fn(Unit, Int, Pure), Lam("_unit", Unit, LetMut("x", Int(1), Let("_", None, SlotSet("x", Int(2)), SlotGet("x")))))], Unit)"#,
        ),
        (
            "fungsi f() -> Nombor kesan Bersih { pastikan betul lain { 0 }; 1 }",
            r#"LetRecGroup([("f", Fn(Unit, Int, Pure), Lam("_unit", Unit, If(Bool(true), Int(1), Int(0))))], Unit)"#,
        ),
        // Annotations are kept and checked (`Ascribe`), and a function type
        // with two parameters curries (REQ-97, fixed 2026-10-20).
        (
            "fungsi f() -> Nombor kesan Bersih { biar x: Teks = 5; x }",
            r#"LetRecGroup([("f", Fn(Unit, Int, Pure), Lam("_unit", Unit, Let("x", None, Ascribe(Int(5), String), Var("x"))))], Unit)"#,
        ),
        (
            "fungsi f() -> Nombor kesan Bersih { biar g = fungsi(y: Nombor) -> Teks { y }; 1 }",
            r#"LetRecGroup([("f", Fn(Unit, Int, Pure), Lam("_unit", Unit, Let("g", None, Lam("y", Int, Ascribe(Var("y"), String)), Int(1))))], Unit)"#,
        ),
        (
            "fungsi f(g: Fn(Nombor, Teks) -> Nombor) -> Nombor kesan Bersih { 1 }",
            r#"LetRecGroup([("f", Fn(Fn(Int, Fn(String, Int, Pure), Pure), Int, Pure), Lam("g", Fn(Int, Fn(String, Int, Pure), Pure), Int(1)))], Unit)"#,
        ),
        // A type alias means its type; a record or variant type name reads
        // as `Any` (REQ-93(c), 2026-10-20). Both used to be `Any`.
        (
            "jenis W = Nombor;\nfungsi f(x: W) -> W kesan Bersih { x }",
            r#"LetRecGroup([("f", Fn(Int, Int, Pure), Lam("x", Int, Var("x")))], Unit)"#,
        ),
        (
            "bentuk T { x: Nombor }\nfungsi f(x: T) -> Hasil<Nombor, Kosong> kesan Bersih { Jadi(1) }",
            r#"LetRecGroup([("f", Fn(Any, Sum(Int, Unit), Pure), Lam("x", Any, Inl(Int(1), Any)))], Unit)"#,
        ),
        (
            "fungsi f() -> Unit kesan Bersih { fungsi g(y: Nombor) -> Nombor kesan Bersih { y } () }",
            r#"LetRecGroup([("f", Fn(Unit, Unit, Pure), Lam("_unit", Unit, LetRec("g", Fn(Int, Int, Pure), Lam("y", Int, Var("y")), Unit)))], Unit)"#,
        ),
    ];
    let mut errs = Vec::new();
    for (src, want) in exprs {
        match Parser::new(src).parse_expr() {
            Ok(e) if format!("{e:?}") == want => {}
            other => errs.push(format!("{src}\n    want {want}\n    got  {other:?}")),
        }
    }
    for (src, want) in programs {
        match Parser::new(src).parse_program() {
            Ok(p) => {
                let got = format!("{:?}", p.desugar());
                if got != want {
                    errs.push(format!("{src}\n    want {want}\n    got  {got}"));
                }
            }
            Err(e) => errs.push(format!("{src}\n    does not parse: {e:?}")),
        }
    }
    assert!(errs.is_empty(), "{DOC} states elaborations the parser no longer produces:\n  {}", errs.join("\n  "));
}

/// The website's keyword reference lists only keywords that mean something,
/// and type names that are real types.
#[test]
fn the_website_lists_only_working_keywords_and_types() {
    let t = truth();
    let kinds = kinds(&parse_page(&read(DOC)));
    let token_of: BTreeMap<&str, &str> =
        t.keywords.iter().flat_map(|(tok, sp)| sp.iter().map(move |s| (s.as_str(), tok.as_str()))).collect();
    let site = read("website/src/RiinaWebsite.jsx");
    let start = site.find("const KW = [").expect("website KW table");
    let end = site[start..].find("\n];").expect("end of KW") + start;
    let mut errs = Vec::new();
    for group in site[start..end].split("{ title: '").skip(1) {
        let title = &group[..group.find('\'').unwrap()];
        for item in group.split("{ bm: '").skip(1) {
            let bm = &item[..item.find('\'').unwrap()];
            if title == "Built-in types" {
                let real = [bm.to_string(), format!("{bm}<Nombor>"), format!("{bm}<Nombor, Nombor>")]
                    .iter()
                    .any(|ty| {
                        let src = format!("fungsi f(x: {ty}) -> Unit kesan Bersih {{ () }}");
                        Parser::new(&src)
                            .parse_program()
                            .map(|p| !format!("{:?}", p.desugar()).contains("Lam(\"x\", Any"))
                            .unwrap_or(false)
                    });
                if !real {
                    errs.push(format!("`{bm}` is listed as a built-in type, but it reads as `Any`"));
                }
                continue;
            }
            let kind = token_of.get(bm).and_then(|tok| kinds.get(*tok)).map(String::as_str);
            if !matches!(kind, Some("construct" | "part")) {
                errs.push(format!("`{bm}` is listed as a keyword, but its kind is {kind:?} in {DOC}"));
            }
        }
    }
    assert!(errs.is_empty(), "website/src/RiinaWebsite.jsx:\n  {}", errs.join("\n  "));
}

// The checks above must be able to fail.

#[test]
fn control_missing_stale_and_wrong_rows_are_caught() {
    let t = truth();
    let doc = read(DOC);
    let errs = |d: &str| page_errors(&parse_page(d), &t);
    assert!(errs(&doc).is_empty());

    let missing = doc.replace("| `Expr::While` | — | unmodelled | loops (`selagi`, `ulang`, `untuk`) |\n", "");
    assert!(errs(&missing).iter().any(|e| e.contains("Rust `Expr::While` has no row")));

    let stale = doc.replace("| `EFix` |", "| `EFixed` |");
    let e = errs(&stale);
    assert!(e.iter().any(|e| e.contains("Coq `EFix` has no row")), "{e:?}");
    assert!(e.iter().any(|e| e.contains("`EFixed`, which Coq does not define")), "{e:?}");

    let status = doc.replace("| `Expr::Lam` | `ELam` | core |", "| `Expr::Lam` | `ELam` | proven |");
    assert!(errs(&status).iter().any(|e| e.contains("status `proven`")));

    let wrong_target = doc.replace("| `Expr::Lam` | `ELam` | core |", "| `Expr::Lam` | `ELambda` | core |");
    assert!(errs(&wrong_target).iter().any(|e| e.contains("no constructor `ELambda`")));

    let asym = doc.replace("| `ELam` | `Expr::Lam` | core |", "| `ELam` | `Expr::App` | core |");
    assert!(errs(&asym).iter().any(|e| e.contains("must map back")));

    let kw = doc.replace("| `KwConst` | `tetap`, `const` |", "| `KwConst` | `tetap` |");
    assert!(errs(&kw).iter().any(|e| e.contains("spellings")));
}

#[test]
fn control_the_parsers_read_the_real_definitions() {
    let types = read("03_PROTO/crates/riina-types/src/lib.rs");
    let expr = rust_variants(&types, "Expr");
    assert_eq!(expr.first().map(String::as_str), Some("Unit"));
    assert!(expr.contains(&"IntN".to_string()) && expr.contains(&"UIContrastCheck".to_string()));
    assert!(!expr.contains(&"Box".to_string()), "struct-variant fields are not variants");
    let syntax = read("02_FORMAL/coq/foundations/Syntax.v");
    let e = coq_constructors(&syntax, "expr");
    assert_eq!(e.first().map(String::as_str), Some("EUnit"));
    assert_eq!(e.last().map(String::as_str), Some("EGrant"));
    let ty = coq_constructors(&syntax, "ty");
    assert_eq!(ty.last().map(String::as_str), Some("TZeroizing"), "`ty` ends at `with`");
    assert_eq!(coq_constructors(&syntax, "session_type").len(), 7);
    let kw = lexer_keywords(&read("03_PROTO/crates/riina-lexer/src/lexer.rs"));
    assert_eq!(kw["KwNone"], ["None", "Tiada", "Tidak"].iter().map(|s| s.to_string()).collect());
    assert!(!kw.contains_key("LiteralBool"));
}
