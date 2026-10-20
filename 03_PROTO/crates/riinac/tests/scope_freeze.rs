// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The scope freeze (owner ruling D4, 2026-10-19; master plan REQ-108).
//!
//! Until the mandate's depth exit gate, RIINA adds no new keywords, effects,
//! types or compliance profiles, except work a hardening standard requires
//! and the REQ-33 Syariah track. This test makes the freeze a gate rather
//! than a request. It measures the language surface and compares it with the
//! one line in `RIINA_MASTER_PLAN.md` that records the frozen counts:
//!
//! ```text
//! **Scope-freeze pins:** keywords=132 effects=19 types=45 profiles=19
//! ```
//!
//! Growing any of them fails here until that line is changed. That edit is
//! the linked owner override: it is reviewable, it sits next to the REQ-108
//! row, and a commit cannot slip past it. Removing surface also fails, so the
//! pins stay accurate.

use std::path::Path;

fn repo_root() -> &'static Path {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root above 03_PROTO/crates/riinac")
}

/// Variant names of `pub enum <name>` in a Rust source file.
fn enum_variants(src: &str, header: &str) -> Vec<String> {
    let start = src
        .find(header)
        .unwrap_or_else(|| panic!("`{header}` not found"));
    let body = &src[start + header.len()..];
    let end = body.find("\n}").expect("enum end");
    body[..end]
        .lines()
        .filter_map(|l| {
            let t = l.trim_start();
            if l.len() - t.len() != 4 || !t.starts_with(|c: char| c.is_ascii_uppercase()) {
                return None;
            }
            let name: String = t
                .chars()
                .take_while(|c| c.is_ascii_alphanumeric() || *c == '_')
                .collect();
            let rest = &t[name.len()..];
            matches!(rest.trim_start().chars().next(), Some(',' | '(' | '{')).then_some(name)
        })
        .collect()
}

fn pinned(plan: &str, key: &str) -> usize {
    let line = plan
        .lines()
        .find(|l| l.starts_with("**Scope-freeze pins:**"))
        .expect("RIINA_MASTER_PLAN.md has no `**Scope-freeze pins:**` line (REQ-108)");
    let tok = line
        .split_whitespace()
        .find_map(|w| w.strip_prefix(&format!("{key}=")))
        .unwrap_or_else(|| panic!("pin line has no `{key}=`: {line}"));
    tok.trim_end_matches(|c: char| !c.is_ascii_digit())
        .parse()
        .unwrap_or_else(|_| panic!("bad `{key}` pin in: {line}"))
}

#[test]
fn the_language_surface_matches_the_frozen_pins() {
    let root = repo_root();
    let plan = std::fs::read_to_string(root.join("RIINA_MASTER_PLAN.md")).expect("master plan");
    let lexer_tokens =
        std::fs::read_to_string(root.join("03_PROTO/crates/riina-lexer/src/token.rs")).unwrap();
    let types_src =
        std::fs::read_to_string(root.join("03_PROTO/crates/riina-types/src/lib.rs")).unwrap();

    let keywords = enum_variants(&lexer_tokens, "pub enum TokenKind {")
        .into_iter()
        .filter(|v| v.starts_with("Kw"))
        .count();
    let types = enum_variants(&types_src, "pub enum Ty {").len();
    let effects = riina_types::Effect::ALL.len();
    let profiles = riina_compliance::ComplianceProfile::ALL.len();

    let mut drift = Vec::new();
    for (key, actual) in [
        ("keywords", keywords),
        ("effects", effects),
        ("types", types),
        ("profiles", profiles),
    ] {
        let pin = pinned(&plan, key);
        if pin != actual {
            drift.push(format!("{key}: pinned {pin}, actual {actual}"));
        }
    }
    assert!(
        drift.is_empty(),
        "the language surface moved under the scope freeze (REQ-108): {}. Growing it \
         needs an owner override: change the `**Scope-freeze pins:**` line in \
         RIINA_MASTER_PLAN.md in the same change, with the reason.",
        drift.join("; ")
    );
}

/// The scanner itself counts what it claims to (a negative control: an
/// enum with a known shape).
#[test]
fn the_variant_scanner_counts_exactly() {
    let src = "pub enum TokenKind {\n    KwA,\n    KwB(String),\n    LiteralInt(u64),\n    // KwComment,\n    KwC { x: u8 },\n}\n";
    let v = enum_variants(src, "pub enum TokenKind {");
    assert_eq!(v, vec!["KwA", "KwB", "LiteralInt", "KwC"]);
}
