// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The AI-training data in `07_EXAMPLES/08_ai_training/` must match the
//! compiler.
//!
//! `error_fix_pairs.jsonl` teaches a model what `riinac` reports for a mistake
//! and how to fix it. Each `broken_code` must fail `riinac check` with the
//! pair's `error_code` and `error_message`, and each `fixed_code` must pass.
//! On 2026-10-20, 61 of the 66 pairs stated a code the compiler did not report
//! (the codes had been numbered by entry), nine broken programs had become
//! valid, and four fixed programs failed.
//!
//! The other three files pair a task, a Python function or a vulnerability
//! with RIINA code; every RIINA program must check. On 2026-10-20, 32 of the
//! 151 did not, and 37 `vuln_to_safe` entries cited a proof file that had been
//! archived as deprecated.

use std::io::Write;
use std::path::PathBuf;
use std::process::{Command, Stdio};

fn repo() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../..")
}

fn pairs_path() -> PathBuf {
    repo().join("07_EXAMPLES/08_ai_training/error_fix_pairs.jsonl")
}

/// Read a JSON string literal at the start of `s` (after its opening `"`
/// has been consumed); return it and the rest of `s`.
fn json_string(s: &str) -> Option<(String, &str)> {
    let mut out = String::new();
    let mut chars = s.char_indices();
    while let Some((i, c)) = chars.next() {
        match c {
            '"' => return Some((out, &s[i + 1..])),
            '\\' => match chars.next()?.1 {
                'n' => out.push('\n'),
                't' => out.push('\t'),
                'r' => out.push('\r'),
                'b' => out.push('\u{8}'),
                'f' => out.push('\u{c}'),
                'u' => {
                    let hex: String = (0..4)
                        .filter_map(|_| chars.next().map(|(_, h)| h))
                        .collect();
                    out.push(char::from_u32(u32::from_str_radix(&hex, 16).ok()?)?);
                }
                other => out.push(other),
            },
            c => out.push(c),
        }
    }
    None
}

/// The string value of `"key": "…"` in a flat JSON object.
fn field(obj: &str, key: &str) -> Option<String> {
    let at = obj.find(&format!("\"{key}\":"))? + key.len() + 3;
    let rest = obj[at..].trim_start().strip_prefix('"')?;
    json_string(rest).map(|(v, _)| v)
}

/// Run `riinac check --stdin --json` on `source`: `None` if it checks, else
/// the first diagnostic's code and message.
fn check(source: &str) -> Option<(String, String)> {
    let mut child = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["check", "--stdin", "--json"])
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("run riinac");
    child
        .stdin
        .take()
        .expect("stdin")
        .write_all(format!("{source}\n").as_bytes())
        .expect("write source");
    let out = child.wait_with_output().expect("riinac output");
    let json = String::from_utf8_lossy(&out.stdout);
    if json.contains("\"success\":true") {
        return None;
    }
    let code = field(&json, "code").unwrap_or_else(|| format!("no diagnostic in {json}"));
    let message = field(&json, "message").unwrap_or_default();
    Some((code, message))
}

#[test]
fn error_fix_pairs_match_the_compiler() {
    let text = std::fs::read_to_string(pairs_path()).expect("read error_fix_pairs.jsonl");
    let mut errs = Vec::new();
    let mut n = 0;
    for (i, line) in text
        .lines()
        .enumerate()
        .filter(|(_, l)| !l.trim().is_empty())
    {
        n += 1;
        let at = format!("line {}", i + 1);
        let get = |key| field(line, key).unwrap_or_else(|| panic!("{at}: no string field `{key}`"));
        let (code, message) = (get("error_code"), get("error_message"));
        match check(&get("broken_code")) {
            None => errs.push(format!(
                "{at}: broken_code checks, so the pair teaches a rule that no longer exists"
            )),
            Some((c, m)) => {
                let want = format!("{c}: error: {m}");
                if c != code || want != message {
                    errs.push(format!(
                        "{at}: states {code} {message:?}, the compiler reports {want:?}"
                    ));
                }
            }
        }
        if let Some((c, m)) = check(&get("fixed_code")) {
            errs.push(format!("{at}: fixed_code fails with {c}: {m}"));
        }
    }
    assert!(
        n > 50,
        "only {n} pairs read: the file or the reader is broken"
    );
    assert!(
        errs.is_empty(),
        "error_fix_pairs.jsonl disagrees with riinac:\n  {}",
        errs.join("\n  ")
    );
}

/// The non-empty lines of a training file, numbered from 1.
fn lines(file: &str) -> Vec<(usize, String)> {
    let path = repo().join("07_EXAMPLES/08_ai_training").join(file);
    let text = std::fs::read_to_string(&path).unwrap_or_else(|e| panic!("read {file}: {e}"));
    text.lines()
        .enumerate()
        .filter(|(_, l)| !l.trim().is_empty())
        .map(|(i, l)| (i + 1, l.to_string()))
        .collect()
}

#[test]
fn every_training_program_checks() {
    let mut errs = Vec::new();
    for (file, key, at_least) in [
        ("intent_code_pairs.jsonl", "code", 50),
        ("python_to_riina.jsonl", "riina", 50),
        ("vuln_to_safe.jsonl", "riina_safe_code", 30),
    ] {
        let rows = lines(file);
        assert!(
            rows.len() >= at_least,
            "{file}: only {} entries read",
            rows.len()
        );
        for (n, line) in rows {
            let code = field(&line, key).unwrap_or_else(|| panic!("{file}:{n}: no `{key}`"));
            if let Some((c, m)) = check(&code) {
                errs.push(format!("{file}:{n}: {c}: {m}"));
            }
        }
    }
    assert!(
        errs.is_empty(),
        "training programs that riinac rejects:\n  {}",
        errs.join("\n  ")
    );
}

/// A `proof_reference` names a live Coq file (not an archived one) and the
/// theorem in it: `path/File.v (theorem_name)`, or `none (…)`.
#[test]
fn vuln_to_safe_proof_references_exist() {
    let coq = repo().join("02_FORMAL/coq");
    let mut errs = Vec::new();
    for (n, line) in lines("vuln_to_safe.jsonl") {
        let r = field(&line, "proof_reference")
            .unwrap_or_else(|| panic!("line {n}: no proof_reference"));
        if r.starts_with("none") {
            continue;
        }
        let Some((file, rest)) = r.split_once(" (") else {
            errs.push(format!("line {n}: `{r}` is not `path/File.v (theorem)`"));
            continue;
        };
        let theorem = rest.trim_end_matches(')');
        match std::fs::read_to_string(coq.join(file)) {
            Err(_) => errs.push(format!("line {n}: no file 02_FORMAL/coq/{file}")),
            Ok(_) if file.contains("_archive") => {
                errs.push(format!("line {n}: {file} is archived"))
            }
            Ok(src) if !src.contains(&format!("Theorem {theorem} ")) => {
                errs.push(format!("line {n}: {file} has no `Theorem {theorem}`"));
            }
            Ok(_) => {}
        }
    }
    assert!(errs.is_empty(), "{}", errs.join("\n"));
}
