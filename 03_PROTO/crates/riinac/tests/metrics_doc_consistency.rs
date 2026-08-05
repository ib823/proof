// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `metrics.json` and the doc banners must agree — enforced as a test, not
//! only as a hook.
//!
//! CLAUDE.md Forbidden #8 makes `website/public/metrics.json` the single source
//! of truth for published counts, and every doc must agree with it. That was
//! enforced only by `scripts/audit-docs.sh` and the pre-commit hook, both of
//! which inspect the WORKING TREE. Neither could see an inconsistent *commit* —
//! and the hook produced them: `sync-metrics.sh` rewrites a `**Verification:**`
//! banner in a computed set of ~40 docs while the hook auto-staged a hardcoded
//! list of five, so the rest kept their old banner while metrics.json moved on.
//!
//! Verified in history before the fix: commits `8b47426d`, `bcba007c` and
//! `d6be6ff7` each shipped a `metrics.json` whose Rust-test count disagreed
//! with their own committed doc banners.
//!
//! A test sees the checked-out tree, so it catches the committed state in CI
//! regardless of what any hook did or did not stage.

use std::fs;
use std::path::{Path, PathBuf};

fn repo_root() -> PathBuf {
    // .../03_PROTO/crates/riinac -> repo root
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root above 03_PROTO/crates/riinac")
        .to_path_buf()
}

/// The `"tests"` value inside the `"rust"` object of metrics.json.
///
/// Hand-parsed: 03_PROTO carries zero third-party dependencies (Law 8), so
/// there is no serde here.
fn metrics_rust_tests(json: &str) -> Option<u64> {
    let rust = json.find("\"rust\"")?;
    let tests = json[rust..].find("\"tests\"")? + rust;
    let colon = json[tests..].find(':')? + tests;
    let digits: String = json[colon + 1..]
        .chars()
        .skip_while(|c| c.is_whitespace())
        .take_while(char::is_ascii_digit)
        .collect();
    digits.parse().ok()
}

/// The Rust-test count quoted in a doc's `**Verification:**` banner.
fn banner_rust_tests(doc: &str) -> Option<u64> {
    let line = doc
        .lines()
        .find(|l| l.starts_with("**Verification:**") && l.contains("Rust tests"))?;
    // "... | 2949 Rust tests | ..."
    let idx = line.find(" Rust tests")?;
    let digits: String = line[..idx]
        .chars()
        .rev()
        .take_while(char::is_ascii_digit)
        .collect::<Vec<_>>()
        .into_iter()
        .rev()
        .collect();
    digits.parse().ok()
}

#[test]
fn doc_banners_agree_with_metrics_json() {
    let root = repo_root();
    let metrics_path = root.join("website/public/metrics.json");
    let metrics = fs::read_to_string(&metrics_path)
        .unwrap_or_else(|e| panic!("cannot read {}: {e}", metrics_path.display()));
    let expected = metrics_rust_tests(&metrics)
        .expect("metrics.json must carry rust.tests — the single source of truth");

    // Every doc that quotes a test count in its banner must quote THIS one.
    // Walked, not hardcoded: a hardcoded list is what caused the bug.
    // One walk from the root: it already reaches 04_SPECS, 06_COORDINATION,
    // docs and the rest, so listing them again would double-report.
    let mut checked = 0usize;
    let mut mismatches = Vec::new();
    collect_mismatches(&root, expected, &mut checked, &mut mismatches);

    assert!(
        checked > 0,
        "no `**Verification:**` banner found anywhere — the walk is broken, so \
         this test would pass while checking nothing"
    );
    assert!(
        mismatches.is_empty(),
        "{} doc(s) disagree with metrics.json (rust.tests = {expected}); \
         run `bash scripts/sync-metrics.sh` and stage the result:\n  {}",
        mismatches.len(),
        mismatches.join("\n  ")
    );
}

fn collect_mismatches(dir: &Path, expected: u64, checked: &mut usize, out: &mut Vec<String>) {
    let Ok(entries) = fs::read_dir(dir) else {
        return;
    };
    for entry in entries.flatten() {
        let path = entry.path();
        let name = entry.file_name();
        let name = name.to_string_lossy();
        if path.is_dir() {
            // Archival trees are Tier 3 — deliberately not synced.
            if matches!(
                name.as_ref(),
                "01_RESEARCH" | "99_ARCHIVE" | ".git" | "target" | "node_modules"
            ) || name.starts_with("_archive")
            {
                continue;
            }
            collect_mismatches(&path, expected, checked, out);
        } else if name.ends_with(".md") {
            let Ok(text) = fs::read_to_string(&path) else {
                continue;
            };
            if let Some(found) = banner_rust_tests(&text) {
                *checked += 1;
                if found != expected {
                    out.push(format!("{} says {found}, metrics.json says {expected}", path.display()));
                }
            }
        }
    }
}

#[test]
fn banner_and_metrics_parsers_actually_parse() {
    // NEGATIVE CONTROL: if both helpers silently returned None, the test above
    // would find zero banners and zero mismatches and pass while checking
    // nothing. Pin that each extracts the right number, and rejects garbage.
    let json = r#"{ "coq": { "tests": 111 }, "rust": { "tests": 2949, "crates": 19 } }"#;
    assert_eq!(metrics_rust_tests(json), Some(2949), "must read rust.tests, not another object's");
    assert_eq!(metrics_rust_tests("{}"), None);

    let doc = "# Title\n**Verification:** 12,638 Coq Qed (compiled, 0 Admitted, 0 active axioms) \
               — Coq is the only mechanized lane | 2949 Rust tests | the other prover trees are \
               machine-generated\n";
    assert_eq!(banner_rust_tests(doc), Some(2949));
    assert_eq!(banner_rust_tests("# no banner here\n"), None);
}
