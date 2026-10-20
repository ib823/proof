// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! One licence, stated the same way on every surface (mandate S4.3 and S4.8,
//! owner ruling D5, 2026-10-19).
//!
//! The licence text is the repository's `LICENSE`. Before this check, Cargo
//! called it `license = "Proprietary"` (not an SPDX expression), six tooling
//! crates had no licence field at all, and the SBOM therefore listed six
//! unlicensed components. Now:
//! - both workspaces set `license-file = "../LICENSE"` and every crate inherits
//!   it with `license-file.workspace = true`;
//! - the npm manifests say `SEE LICENSE IN ../LICENSE`;
//! - every SBOM component carries a licence.
//!
//! This runs in CI with the rest of `cargo test`.

use std::path::{Path, PathBuf};

fn repo_root() -> &'static Path {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root above 03_PROTO/crates/riinac")
}

fn read(rel: &str) -> String {
    std::fs::read_to_string(repo_root().join(rel)).unwrap_or_else(|e| panic!("{rel}: {e}"))
}

/// Every `Cargo.toml` under a workspace's `crates/` and `tools/` directories.
fn member_manifests(workspace: &str) -> Vec<PathBuf> {
    let mut out = Vec::new();
    for sub in ["crates", "tools"] {
        let Ok(entries) = std::fs::read_dir(repo_root().join(workspace).join(sub)) else {
            continue;
        };
        for entry in entries.flatten() {
            let manifest = entry.path().join("Cargo.toml");
            if manifest.is_file() {
                out.push(manifest);
            }
        }
    }
    out.sort();
    out
}

#[test]
fn every_surface_points_at_the_one_licence_file() {
    let licence = read("LICENSE");
    assert!(
        licence.lines().next().unwrap_or("").contains("PROPRIETARY LICENSE"),
        "LICENSE no longer starts with the RIINA licence title"
    );

    let mut problems = Vec::new();
    for workspace in ["03_PROTO", "05_TOOLING"] {
        let root = read(&format!("{workspace}/Cargo.toml"));
        if !root.lines().any(|l| l.trim() == "license-file = \"../LICENSE\"") {
            problems.push(format!("{workspace}/Cargo.toml: no license-file = \"../LICENSE\""));
        }
        let members = member_manifests(workspace);
        assert!(!members.is_empty(), "{workspace}: found no member manifests");
        for manifest in members {
            let text = std::fs::read_to_string(&manifest).unwrap();
            if !text.lines().any(|l| l.trim() == "license-file.workspace = true") {
                problems.push(format!("{}: does not inherit the licence file", manifest.display()));
            }
            if text.lines().any(|l| l.trim_start().starts_with("license =")) {
                problems.push(format!("{}: sets its own `license =`", manifest.display()));
            }
        }
    }
    for npm in ["riina-vscode/package.json", "website/package.json"] {
        if !read(npm).contains("\"license\": \"SEE LICENSE IN ../LICENSE\"") {
            problems.push(format!("{npm}: licence does not point at LICENSE"));
        }
    }
    assert!(problems.is_empty(), "licence surfaces disagree:\n{}", problems.join("\n"));
}

/// Every component in the committed SBOMs has a licence entry (S4.8). The
/// generator now fails on a gap, and this catches a hand-edited SBOM too.
#[test]
fn every_sbom_component_has_a_licence() {
    for sbom in ["sbom/riina-proto.cdx.json", "sbom/riina-tooling.cdx.json"] {
        let text = read(sbom);
        // CycloneDX components are objects that carry a "bom-ref"; count those
        // and the "licenses" arrays, which the generator writes one per
        // component.
        let components = text.matches("\"bom-ref\":").count();
        let licensed = text.matches("\"licenses\":").count();
        assert!(components > 0, "{sbom}: no components found");
        assert_eq!(
            licensed, components,
            "{sbom}: {components} components but only {licensed} licence entries"
        );
    }
}
