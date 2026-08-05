// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! REQ-47: every Coq⇄Rust formal-equivalence proof must carry a verification-
//! boundary statement — enforced, not merely documented.
//!
//! "Verification Theatre" (IACR ePrint 2026/192) found thirteen vulnerabilities
//! in a peer formally-verified crypto library, four of them INSIDE the verified
//! specification/proof code, and named the cause: the boundary between what is
//! machine-checked and what is merely trusted was not communicated. RIINA's
//! claim levels are per-lane; this test makes the boundary per-PRIMITIVE.
//!
//! The authoritative list of equivalence proofs is the crypto section of
//! `02_FORMAL/coq/_CoqProject` (the build's own source of truth — a proof that
//! is not listed there does not compile, and one that is listed cannot hide).
//! Every `crypto/*.v` entry there MUST have a matching entry in
//! `verification_boundary.json` with non-empty disclosure fields. Adding a
//! tenth primitive without a boundary statement therefore FAILS THE BUILD.
//!
//! Hand-parsed JSON — riina-core carries zero third-party dependencies (Law 8).

use std::fs;
use std::path::{Path, PathBuf};

fn repo_root() -> PathBuf {
    // .../05_TOOLING/crates/riina-core -> repo root
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root above 05_TOOLING/crates/riina-core")
        .to_path_buf()
}

/// `crypto/<Name>.v` entries from `_CoqProject` — the authoritative proof list.
///
/// Deliberately case-SENSITIVE on `.v`: the Coq build only accepts lowercase,
/// so a case-insensitive match would "find" files the build itself ignores.
#[allow(clippy::case_sensitive_file_extension_comparisons)]
fn coqproject_crypto_files(coqproject: &str) -> Vec<String> {
    coqproject
        .lines()
        .map(str::trim)
        .filter(|l| l.starts_with("crypto/") && l.ends_with(".v"))
        .map(str::to_string)
        .collect()
}

/// All string values for `"key"` occurrences in the manifest, in order.
fn string_values_for(json: &str, key: &str) -> Vec<String> {
    let needle = format!("\"{key}\"");
    let mut out = Vec::new();
    let mut from = 0;
    while let Some(pos) = json[from..].find(&needle) {
        let after = from + pos + needle.len();
        let Some(colon) = json[after..].find(':') else { break };
        let rest = &json[after + colon + 1..];
        let Some(q1) = rest.find('"') else { break };
        // Value may contain escaped quotes; scan for the closing unescaped one.
        let bytes = rest.as_bytes();
        let mut i = q1 + 1;
        while i < bytes.len() && !(bytes[i] == b'"' && bytes[i - 1] != b'\\') {
            i += 1;
        }
        if i >= bytes.len() {
            break;
        }
        out.push(rest[q1 + 1..i].to_string());
        from = after + colon + 1;
    }
    out
}

fn manifest() -> String {
    let path = repo_root().join("05_TOOLING/crates/riina-core/verification_boundary.json");
    fs::read_to_string(&path)
        .unwrap_or_else(|e| panic!("cannot read {}: {e}", path.display()))
}

#[test]
fn every_equivalence_proof_has_a_boundary_entry() {
    let root = repo_root();
    let coqproject = fs::read_to_string(root.join("02_FORMAL/coq/_CoqProject"))
        .expect("read _CoqProject");
    let proofs = coqproject_crypto_files(&coqproject);
    assert!(
        !proofs.is_empty(),
        "no crypto/*.v entries found in _CoqProject — the parse is broken, so \
         this test would pass while checking nothing"
    );

    let m = manifest();
    let declared = string_values_for(&m, "coq_file");
    for proof in &proofs {
        let full = format!("02_FORMAL/coq/{proof}");
        assert!(
            declared.iter().any(|d| d == &full),
            "`{full}` is a formal-equivalence proof (listed in _CoqProject) with \
             NO entry in verification_boundary.json. Every primitive must state \
             what is modelled, what is trusted, and what is NOT covered — a \
             proof without a boundary statement is exactly the 'Verification \
             Theatre' failure mode (ePrint 2026/192). Add an entry before \
             adding the proof."
        );
    }
    // And the reverse: no stale entries for proofs that no longer exist.
    for d in &declared {
        assert!(
            root.join(d).is_file(),
            "verification_boundary.json declares `{d}`, which does not exist — \
             a stale boundary entry misstates what is verified"
        );
    }
}

#[test]
fn boundary_entries_are_complete_and_anchored() {
    let root = repo_root();
    let m = manifest();

    let coq_files = string_values_for(&m, "coq_file");
    let rust_files = string_values_for(&m, "rust_file");
    let strengths = string_values_for(&m, "proof_strength");
    let modelled = string_values_for(&m, "modelled");

    let n = coq_files.len();
    assert!(n > 0, "manifest has no primitives — vacuous");
    assert_eq!(rust_files.len(), n, "every entry needs a rust_file anchor");
    assert_eq!(strengths.len(), n, "every entry needs a proof_strength");
    assert_eq!(modelled.len(), n, "every entry needs a `modelled` statement");

    for rf in &rust_files {
        assert!(
            root.join(rf).is_file(),
            "rust_file anchor `{rf}` does not exist — the boundary must point \
             at the real implementation it covers"
        );
    }
    for (i, s) in strengths.iter().enumerate() {
        assert!(
            s == "symbolic+kat" || s == "kat_only",
            "entry {i}: proof_strength `{s}` is not an honest category — only \
             `symbolic+kat` (symbolic theorems present) or `kat_only` \
             (executable model validated on vectors) exist. Inventing a \
             stronger-sounding label here is the overclaim this file prevents."
        );
    }
    for (i, text) in modelled.iter().enumerate() {
        assert!(
            text.len() >= 40,
            "entry {i}: `modelled` is too thin to inform an auditor ({} chars)",
            text.len()
        );
    }

    // The global disclosure must keep naming the load-bearing trust: the
    // hand-transcription correspondence and the functional-only scope.
    for required in [
        "HAND-TRANSCRIBED",
        "NO mechanical extraction",
        "FUNCTIONAL only",
    ] {
        assert!(
            m.contains(required),
            "global boundary lost the phrase `{required}` — the transcription \
             gap and functional-only scope are the two facts an auditor must \
             see first; do not soften them"
        );
    }
}

#[test]
fn kat_only_entries_are_not_presented_as_symbolic() {
    // The four KAT-only primitives (AES full cipher, SHA-256, SHA3-256,
    // X25519 ladder) must stay labelled kat_only unless symbolic theorems are
    // actually added to their .v files. This pins today's honest gradation;
    // if someone strengthens a proof, they update this list CONSCIOUSLY.
    let m = manifest();
    let coq_files = string_values_for(&m, "coq_file");
    let strengths = string_values_for(&m, "proof_strength");
    let by_file: std::collections::HashMap<_, _> =
        coq_files.iter().zip(strengths.iter()).collect();

    for kat_only in [
        "02_FORMAL/coq/crypto/AES.v",
        "02_FORMAL/coq/crypto/SHA256.v",
        "02_FORMAL/coq/crypto/Keccak.v",
        "02_FORMAL/coq/crypto/X25519.v",
    ] {
        let s = by_file
            .get(&kat_only.to_string())
            .unwrap_or_else(|| panic!("{kat_only} missing from manifest"));
        assert_eq!(
            *s, "kat_only",
            "{kat_only} is recorded as `{s}` but its .v file has no symbolic \
             theorems (Examples/vector checks only). If symbolic proofs were \
             added, update BOTH the manifest and this pin together."
        );
    }
}

#[test]
fn parser_negative_controls() {
    // A parser that returned nothing would make every test above vacuous.
    let sample = r#"{ "coq_file": "a/b.v", "x": 1, "coq_file": "c/d.v" }"#;
    assert_eq!(string_values_for(sample, "coq_file"), vec!["a/b.v", "c/d.v"]);
    assert!(string_values_for(sample, "absent").is_empty());

    let cp = "# comment\ncrypto/GF128.v\ntype_system/Progress.v\n crypto/X.v\n";
    assert_eq!(
        coqproject_crypto_files(cp),
        vec!["crypto/GF128.v".to_string(), "crypto/X.v".to_string()]
    );
    assert!(coqproject_crypto_files("no crypto here").is_empty());
}
