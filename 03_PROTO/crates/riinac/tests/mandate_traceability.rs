// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Every part of the hardening mandate is tracked (REQ-118).
//!
//! The owner adopted `04_SPECS/governance/HARDENING_MANDATE.md` on 2026-10-19.
//! Its standards (S1.1–S5.8), rules (R1–R12), milestones (M0–M6), baseline
//! items (B1–B14), concern elements (C1.a–C5.d) and definition-of-done items
//! (DoD-1–DoD-7) must each have a row in the master plan's Part 11 section
//! "Mandate traceability", and every REQ a row names must exist in the Part 3
//! registry. A mapping that silently drops an item, or points at a REQ that
//! was never written, fails here.
//!
//! The coverage audit of 2026-10-20 found that a coarse "standard → REQ" map
//! hid gaps (whole standards with no REQ text behind them), which is why each
//! row also carries a status and the open must-hits.

use std::collections::{BTreeMap, BTreeSet};
use std::path::Path;

fn repo_root() -> &'static Path {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root above 03_PROTO/crates/riinac")
}

fn read(rel: &str) -> String {
    std::fs::read_to_string(repo_root().join(rel)).unwrap_or_else(|e| panic!("{rel}: {e}"))
}

const STATUSES: &[&str] = &["MET", "PARTIAL", "OPEN", "OWNER"];

/// The identifiers the mandate defines, read from the mandate itself.
fn mandate_ids(mandate: &str) -> BTreeSet<String> {
    let mut ids = BTreeSet::new();
    for line in mandate.lines() {
        let t = line.trim_start();
        // "- **S1.1 — ...", "- **R1 — ...", "- **B1 — ..."
        if let Some(rest) = t.strip_prefix("- **") {
            let id: String = rest
                .chars()
                .take_while(|c| c.is_ascii_alphanumeric() || *c == '.')
                .collect();
            let after = &rest[id.len()..];
            let is_std = id.len() >= 4
                && id.starts_with('S')
                && id[1..].split_once('.').is_some_and(|(a, b)| {
                    a.parse::<u8>().is_ok() && b.parse::<u8>().is_ok()
                });
            let is_rule_or_base = (id.starts_with('R') || id.starts_with('B'))
                && id.len() >= 2
                && id[1..].parse::<u8>().is_ok();
            if (is_std || is_rule_or_base) && after.trim_start().starts_with('—') {
                ids.insert(id);
            }
        }
        // Milestone table: "| **M0 — Truth-up** | ..."
        if let Some(rest) = t.strip_prefix("| **M") {
            if let Some(d) = rest.chars().next().filter(char::is_ascii_digit) {
                ids.insert(format!("M{d}"));
            }
        }
        // Traceability table: "| C1.a Proofs cover only a model | ..."
        if let Some(rest) = t.strip_prefix("| C") {
            let id: String = rest.chars().take(3).collect();
            let b = id.as_bytes();
            if b.len() == 3 && b[0].is_ascii_digit() && b[1] == b'.' && b[2].is_ascii_lowercase() {
                ids.insert(format!("C{id}"));
            }
        }
    }
    // §9 definition of done: the numbered list under its heading.
    let dod = mandate
        .split_once("## 9. Programme definition of done")
        .map(|(_, rest)| rest)
        .expect("mandate has a §9 definition of done");
    for line in dod.lines() {
        let t = line.trim_start();
        if let Some((n, _)) = t.split_once(". ") {
            if n.len() == 1 && n.chars().all(|c| c.is_ascii_digit()) {
                ids.insert(format!("DoD-{n}"));
            }
        }
        if t.starts_with("Until then") {
            break;
        }
    }
    ids
}

/// Rows of the master plan's "Mandate traceability" tables:
/// `| ID | subject | REQs | status | notes |`.
fn traceability_rows(plan: &str) -> BTreeMap<String, (String, String)> {
    let section = plan
        .split_once("#### Mandate traceability")
        .map(|(_, rest)| rest)
        .expect("RIINA_MASTER_PLAN.md Part 11 has no `#### Mandate traceability` section (REQ-118)");
    // The section ends at the next heading of level 3 or above.
    let end = ["\n### ", "\n## ", "\n# "]
        .iter()
        .filter_map(|h| section.find(h))
        .min()
        .unwrap_or(section.len());
    let section = &section[..end];
    let mut rows = BTreeMap::new();
    for line in section.lines() {
        let cells: Vec<&str> = line.trim().trim_matches('|').split('|').map(str::trim).collect();
        if !line.trim_start().starts_with('|') || cells.len() < 5 {
            continue;
        }
        let id = cells[0].trim_matches('*').to_string();
        if id == "ID" || id.starts_with("---") {
            continue;
        }
        let dup = rows.insert(id.clone(), (cells[2].to_string(), cells[3].to_string()));
        assert!(dup.is_none(), "duplicate traceability row for {id}");
    }
    rows
}

/// REQ ids defined as rows of the Part 3 registry (other parts also have
/// tables whose rows start with a REQ id; those do not define one).
fn registry_reqs(plan: &str) -> BTreeSet<u32> {
    let part3 = plan
        .split_once("## PART 3: REQUIREMENTS REGISTRY")
        .map_or(plan, |(_, rest)| rest);
    let part3 = part3.split_once("\n## PART 4").map_or(part3, |(body, _)| body);
    part3
        .lines()
        .filter_map(|l| l.strip_prefix("| REQ-"))
        .filter_map(|r| r.split_once(' ').and_then(|(n, _)| n.parse().ok()))
        .collect()
}

fn req_refs(cell: &str) -> Vec<u32> {
    cell.split("REQ-")
        .skip(1)
        .filter_map(|s| {
            let n: String = s.chars().take_while(char::is_ascii_digit).collect();
            n.parse().ok()
        })
        .collect()
}

#[test]
fn every_mandate_item_is_traced_to_an_existing_req() {
    let mandate = read("04_SPECS/governance/HARDENING_MANDATE.md");
    let plan = read("RIINA_MASTER_PLAN.md");
    let ids = mandate_ids(&mandate);
    let rows = traceability_rows(&plan);
    let registry = registry_reqs(&plan);

    // The mandate's own counts, so a parser that silently finds nothing fails.
    let count = |p: &str| ids.iter().filter(|i| i.starts_with(p)).count();
    assert_eq!(count("S"), 53, "standards found in the mandate");
    assert_eq!(count("R"), 12, "rules found in the mandate");
    assert_eq!(count("M"), 7, "milestones found in the mandate");
    assert_eq!(count("B"), 14, "baseline items found in the mandate");
    assert_eq!(count("C"), 24, "concern elements found in the mandate");
    assert_eq!(count("DoD-"), 7, "definition-of-done items found in the mandate");

    let mut problems = Vec::new();
    for id in &ids {
        let Some((reqs, status)) = rows.get(id) else {
            problems.push(format!("{id}: no traceability row"));
            continue;
        };
        let refs = req_refs(reqs);
        if refs.is_empty() {
            problems.push(format!("{id}: row names no REQ"));
        }
        for r in refs {
            if !registry.contains(&r) {
                problems.push(format!("{id}: REQ-{r} is not in the Part 3 registry"));
            }
        }
        let st = status.split_whitespace().next().unwrap_or("");
        if !STATUSES.contains(&st) {
            problems.push(format!("{id}: status `{status}` is not one of {STATUSES:?}"));
        }
    }
    for id in rows.keys() {
        if !ids.contains(id) {
            problems.push(format!("{id}: row for an identifier the mandate does not define"));
        }
    }
    assert!(problems.is_empty(), "mandate traceability gaps:\n{}", problems.join("\n"));
}

/// Negative control: the parsers find exactly what a known fragment holds,
/// and a missing or dangling row is reported.
#[test]
fn the_traceability_parsers_count_exactly() {
    let mandate = "- **S1.1 — Normative core.** x\n- **S1.10 — Backend.** y\n\
                   - **R2 — Proof hygiene.** z\n- **B6 — Entry point.** w\n\
                   | **M0 — Truth-up** | a |\n| C1.a Proofs cover | S1.1 |\n\
                   ## 9. Programme definition of done\n1. One\n2. Two\nUntil then\n3. Not counted\n";
    let ids = mandate_ids(mandate);
    let want: BTreeSet<String> = ["S1.1", "S1.10", "R2", "B6", "M0", "C1.a", "DoD-1", "DoD-2"]
        .iter()
        .map(|s| s.to_string())
        .collect();
    assert_eq!(ids, want);

    let plan = "## PART 3: REQUIREMENTS REGISTRY\n| REQ-7 | x | P1 | TODO | Gate A |\n## PART 4\n\
                | REQ-99 | not a registry row |\n#### Mandate traceability\n\
                | ID | Subject | REQs | Status | Notes |\n|---|---|---|---|---|\n\
                | S1.1 | core | REQ-7, REQ-99 | OPEN | n |\n## Next part\n| S9.9 | x | REQ-1 | MET | n |\n";
    let rows = traceability_rows(plan);
    assert_eq!(rows.len(), 1, "rows after the section end must not be read");
    let (reqs, status) = &rows["S1.1"];
    assert_eq!(req_refs(reqs), vec![7, 99]);
    assert_eq!(status, "OPEN");
    assert!(registry_reqs(plan).contains(&7));
    assert!(!registry_reqs(plan).contains(&99), "REQ-99 is dangling in this fragment");
}
