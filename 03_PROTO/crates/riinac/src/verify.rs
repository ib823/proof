// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Verification Gate
//!
//! `riinac verify [--fast|--full]` — runs all checks and produces a manifest.
//!
//! Full mode invokes real proof compilers (Coq, Lean 4, Isabelle/HOL) plus
//! bounded F* and TLA+ smoke builds when pinned local tooling is available.
//! Static scans cover the broader prover corpus, but claim levels stay tied to
//! executable evidence.

#![forbid(unsafe_code)]

use std::fmt::Write as _;
use std::fs;
use std::io;
use std::path::{Path, PathBuf};
use std::process::{Command, Output};
use std::time::{Duration, Instant, SystemTime};

// ---------------------------------------------------------------------------
// Timeout constants (generous to allow clean CI builds)
// ---------------------------------------------------------------------------

const COQ_TIMEOUT: Duration = Duration::from_secs(45 * 60); // 45 min
const LEAN_TIMEOUT: Duration = Duration::from_secs(30 * 60); // 30 min
const ISABELLE_TIMEOUT: Duration = Duration::from_secs(20 * 60); // 20 min
const FSTAR_TIMEOUT: Duration = Duration::from_secs(10 * 60); // 10 min
const TLAPLUS_TIMEOUT: Duration = Duration::from_secs(5 * 60); // 5 min
const ALLOY_TIMEOUT: Duration = Duration::from_secs(5 * 60); // 5 min

// ---------------------------------------------------------------------------
// Mode / CheckResult / ToolStatus
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Mode {
    Fast,
    Full,
}

#[derive(Debug)]
struct CheckResult {
    name: String,
    passed: bool,
    /// If false, a failure is informational (e.g. tool not installed).
    /// Only `blocking` failures cause overall verification to FAIL.
    blocking: bool,
    details: String,
}

struct ProverDirs<'a> {
    coq_dir: &'a Path,
    lean_dir: &'a Path,
    isabelle_dir: &'a Path,
    fstar_dir: &'a Path,
    tlaplus_dir: &'a Path,
    alloy_dir: &'a Path,
    smt_dir: &'a Path,
    verus_dir: &'a Path,
    kani_dir: &'a Path,
    tv_dir: &'a Path,
}

#[derive(Debug)]
enum ToolStatus {
    Found(PathBuf),
    NotFound(String),
}

// ---------------------------------------------------------------------------
// Helper utilities
// ---------------------------------------------------------------------------

/// Locate an executable on `$PATH` using the `which` command.
fn which_tool(name: &str) -> Option<PathBuf> {
    Command::new("which")
        .arg(name)
        .output()
        .ok()
        .filter(|o| o.status.success())
        .and_then(|o| String::from_utf8(o.stdout).ok())
        .map(|s| PathBuf::from(s.trim()))
        .filter(|p| p.exists())
}

/// Extract the last `n` lines from a string.
fn last_n_lines(s: &str, n: usize) -> String {
    let lines: Vec<&str> = s.lines().collect();
    let start = lines.len().saturating_sub(n);
    lines[start..].join("\n")
}

/// Truncate a string to at most `max` bytes (on a char boundary).
fn truncate_str(s: &str, max: usize) -> String {
    if s.len() <= max {
        return s.to_string();
    }
    let mut end = max;
    while end > 0 && !s.is_char_boundary(end) {
        end -= 1;
    }
    format!("{}...", &s[..end])
}

/// Count files with a given extension under `dir` (recursive).
fn count_files_with_ext(dir: &Path, ext: &str) -> u32 {
    let mut count = 0u32;
    if let Ok(entries) = fs::read_dir(dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir() {
                count += count_files_with_ext(&path, ext);
            } else if path.extension().and_then(|e| e.to_str()) == Some(ext) {
                count += 1;
            }
        }
    }
    count
}

// ---------------------------------------------------------------------------
// Toolchain detection
// ---------------------------------------------------------------------------

/// Detect the Coq prover binary: `$COQBIN` env → OPAM switch paths → `PATH`.
///
/// Accepts the modern Rocq 9.x `rocq` binary as well as the legacy `coqc`.
/// Rocq 9.2 — the toolchain this repo requires (the corpus uses `From Stdlib`)
/// — ships `rocq` and has dropped the standalone `coqc`; the Coq `Makefile`
/// drives every compile through `$(COQBIN)rocq compile`, so what matters here
/// is finding *a* prover binary whose parent directory becomes `COQBIN`.
/// `coqc` is probed first to preserve behaviour on Coq 8.x / compat installs.
fn detect_coqc() -> ToolStatus {
    const PROVER_BINS: [&str; 2] = ["coqc", "rocq"];

    // 1. COQBIN environment variable
    if let Ok(coqbin) = std::env::var("COQBIN") {
        for bin in PROVER_BINS {
            let p = PathBuf::from(&coqbin).join(bin);
            if p.exists() {
                return ToolStatus::Found(p);
            }
        }
    }

    // 2. OPAM switch paths
    if let Ok(home) = std::env::var("HOME") {
        let opam_base = PathBuf::from(&home).join(".opam");
        if opam_base.is_dir() {
            if let Ok(entries) = fs::read_dir(&opam_base) {
                for entry in entries.flatten() {
                    for bin in PROVER_BINS {
                        let candidate = entry.path().join("bin").join(bin);
                        if candidate.exists() {
                            return ToolStatus::Found(candidate);
                        }
                    }
                }
            }
        }
    }

    // 3. which coqc / rocq
    for bin in PROVER_BINS {
        if let Some(p) = which_tool(bin) {
            return ToolStatus::Found(p);
        }
    }

    ToolStatus::NotFound("coqc/rocq not found (set COQBIN or install Rocq via opam)".into())
}

/// Detect `lake` (Lean 4 build tool): `$ELAN_HOME` → `~/.elan/bin/lake` → `which lake`.
fn detect_lake() -> ToolStatus {
    // 1. ELAN_HOME
    if let Ok(elan) = std::env::var("ELAN_HOME") {
        let p = PathBuf::from(&elan).join("bin").join("lake");
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    // 2. Default ~/.elan/bin/lake
    if let Ok(home) = std::env::var("HOME") {
        let p = PathBuf::from(&home).join(".elan").join("bin").join("lake");
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    // 3. which lake
    if let Some(p) = which_tool("lake") {
        return ToolStatus::Found(p);
    }

    ToolStatus::NotFound("lake not found (install elan / Lean 4)".into())
}

/// Detect pinned local `isabelle` toolchain:
/// `RIINA_ISABELLE_BIN` → `RIINA_ISABELLE_HOME` → `ISABELLE_HOME`
/// → repo-local `05_TOOLING/tools/isabelle/current/bin/isabelle`.
fn detect_isabelle() -> ToolStatus {
    // 1. Explicit binary override
    if let Ok(bin) = std::env::var("RIINA_ISABELLE_BIN") {
        let p = PathBuf::from(bin);
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    // 2. RIINA_ISABELLE_HOME
    if let Ok(isa) = std::env::var("RIINA_ISABELLE_HOME") {
        let p = PathBuf::from(&isa).join("bin").join("isabelle");
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    // 3. ISABELLE_HOME
    if let Ok(isa) = std::env::var("ISABELLE_HOME") {
        let p = PathBuf::from(&isa).join("bin").join("isabelle");
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    // 4. Search upward from current directory for pinned repo-local install.
    if let Ok(mut dir) = std::env::current_dir() {
        loop {
            let p = dir
                .join("05_TOOLING")
                .join("tools")
                .join("isabelle")
                .join("current")
                .join("bin")
                .join("isabelle");
            if p.exists() {
                return ToolStatus::Found(p);
            }
            if !dir.pop() {
                break;
            }
        }
    }

    ToolStatus::NotFound(
        "pinned local Isabelle not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-isabelle.sh)".into(),
    )
}

/// Detect pinned local `fstar.exe`:
/// `RIINA_FSTAR_BIN` → `RIINA_FSTAR_HOME` → repo-local
/// `05_TOOLING/tools/fstar/current/bin/fstar.exe`.
fn detect_fstar() -> ToolStatus {
    // 1. Explicit binary override
    if let Ok(bin) = std::env::var("RIINA_FSTAR_BIN") {
        let p = PathBuf::from(bin);
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    // 2. RIINA_FSTAR_HOME
    if let Ok(home) = std::env::var("RIINA_FSTAR_HOME") {
        let p = PathBuf::from(&home).join("bin").join("fstar.exe");
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    // 3. Search upward from current directory for pinned repo-local install.
    if let Ok(mut dir) = std::env::current_dir() {
        loop {
            let p = dir
                .join("05_TOOLING")
                .join("tools")
                .join("fstar")
                .join("current")
                .join("bin")
                .join("fstar.exe");
            if p.exists() {
                return ToolStatus::Found(p);
            }
            if !dir.pop() {
                break;
            }
        }
    }

    ToolStatus::NotFound(
        "pinned local F* not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-fstar.sh)".into(),
    )
}

/// Detect pinned local `tla2tools.jar`:
/// `TLA2TOOLS_JAR` → repo-local `05_TOOLING/tools/formal/tla2tools.jar`.
fn detect_tla2tools() -> ToolStatus {
    if let Ok(jar) = std::env::var("TLA2TOOLS_JAR") {
        let p = PathBuf::from(jar);
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    if let Ok(mut dir) = std::env::current_dir() {
        loop {
            let p = dir
                .join("05_TOOLING")
                .join("tools")
                .join("formal")
                .join("tla2tools.jar");
            if p.exists() {
                return ToolStatus::Found(p);
            }
            if !dir.pop() {
                break;
            }
        }
    }

    ToolStatus::NotFound(
        "pinned local TLA2Tools jar not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-formal-tools.sh)".into(),
    )
}

/// Detect pinned local `org.alloytools.alloy.dist.jar`:
/// `ALLOY_JAR` → repo-local
/// `05_TOOLING/tools/formal/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar`.
fn detect_alloy() -> ToolStatus {
    if let Ok(jar) = std::env::var("ALLOY_JAR") {
        let p = PathBuf::from(jar);
        if p.exists() {
            return ToolStatus::Found(p);
        }
    }

    if let Ok(mut dir) = std::env::current_dir() {
        loop {
            let p = dir
                .join("05_TOOLING")
                .join("tools")
                .join("formal")
                .join("alloy-6.2.0")
                .join("lib")
                .join("app")
                .join("org.alloytools.alloy.dist.jar");
            if p.exists() {
                return ToolStatus::Found(p);
            }
            if !dir.pop() {
                break;
            }
        }
    }

    ToolStatus::NotFound(
        "pinned local Alloy jar not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-formal-tools.sh)".into(),
    )
}

// ---------------------------------------------------------------------------
// Timeout-wrapped command runner
// ---------------------------------------------------------------------------

/// Run a command with a timeout.  Uses the Linux `timeout` coreutil if
/// available, otherwise falls back to a manual `try_wait` loop.
fn run_with_timeout(cmd: &str, args: &[&str], cwd: &Path, timeout: Duration) -> io::Result<Output> {
    // Try using the `timeout` coreutil (available on Linux)
    let timeout_secs = timeout.as_secs().to_string();
    if which_tool("timeout").is_some() {
        let mut full_args = vec![&timeout_secs[..], cmd];
        full_args.extend_from_slice(args);
        return Command::new("timeout")
            .args(&full_args)
            .current_dir(cwd)
            .output();
    }

    // Fallback: manual child process management
    let mut child = Command::new(cmd)
        .args(args)
        .current_dir(cwd)
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .spawn()?;

    let start = Instant::now();
    let poll_interval = Duration::from_secs(2);

    loop {
        match child.try_wait()? {
            Some(status) => {
                let stdout = child
                    .stdout
                    .take()
                    .map(|mut r| {
                        let mut buf = Vec::new();
                        io::Read::read_to_end(&mut r, &mut buf).ok();
                        buf
                    })
                    .unwrap_or_default();
                let stderr = child
                    .stderr
                    .take()
                    .map(|mut r| {
                        let mut buf = Vec::new();
                        io::Read::read_to_end(&mut r, &mut buf).ok();
                        buf
                    })
                    .unwrap_or_default();
                return Ok(Output {
                    status,
                    stdout,
                    stderr,
                });
            }
            None => {
                if start.elapsed() >= timeout {
                    let _ = child.kill();
                    let _ = child.wait();
                    return Err(io::Error::new(
                        io::ErrorKind::TimedOut,
                        format!("command timed out after {}s", timeout.as_secs()),
                    ));
                }
                std::thread::sleep(poll_interval);
            }
        }
    }
}

// ---------------------------------------------------------------------------
// File globbers
// ---------------------------------------------------------------------------

/// Recursively find .v files under a directory.
fn glob_v_files(dir: &Path) -> Result<Vec<PathBuf>, std::io::Error> {
    let mut files = vec![];
    if !dir.is_dir() {
        return Ok(files);
    }
    for entry in fs::read_dir(dir)? {
        let entry = entry?;
        let path = entry.path();
        if path.is_dir() {
            files.extend(glob_v_files(&path)?);
        } else if path.extension().and_then(|e| e.to_str()) == Some("v") {
            files.push(path);
        }
    }
    Ok(files)
}

/// Find `.lean` files under `dir`, excluding `lakefile.lean`.
fn glob_lean_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    if path.file_name().and_then(|n| n.to_str()) != Some("_wip") {
                        walk(&path, files);
                    }
                } else if path.extension().and_then(|e| e.to_str()) == Some("lean") {
                    if let Some(name) = path.file_name().and_then(|n| n.to_str()) {
                        if name != "lakefile.lean" {
                            files.push(path);
                        }
                    }
                }
            }
        }
    }
    walk(dir, &mut files);
    files
}

/// Find `.thy` files under `dir`.
fn glob_thy_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if path.extension().and_then(|e| e.to_str()) == Some("thy") {
                    files.push(path);
                }
            }
        }
    }
    walk(dir, &mut files);
    files
}

/// Find `.fst` (F*) files under `dir`.
fn glob_fst_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if path.extension().and_then(|e| e.to_str()) == Some("fst") {
                    files.push(path);
                }
            }
        }
    }
    walk(dir, &mut files);
    files
}

/// Find `.tla` (TLA+) files under `dir`.
fn glob_tla_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if path.extension().and_then(|e| e.to_str()) == Some("tla") {
                    files.push(path);
                }
            }
        }
    }
    walk(dir, &mut files);
    files
}

/// Find `.als` (Alloy) files under `dir`.
fn glob_als_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if path.extension().and_then(|e| e.to_str()) == Some("als") {
                    files.push(path);
                }
            }
        }
    }
    walk(dir, &mut files);
    files
}

/// Find `.smt2` files under `dir`, excluding `.tv.smt2` (translation validation).
fn glob_smt_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if let Some(name) = path.file_name().and_then(|n| n.to_str()) {
                    if name.ends_with(".smt2") && !name.ends_with(".tv.smt2") {
                        files.push(path);
                    }
                }
            }
        }
    }
    walk(dir, &mut files);
    files
}

/// Find `.rs` files under a `verus/` directory.
fn glob_verus_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if path.extension().and_then(|e| e.to_str()) == Some("rs") {
                    files.push(path);
                }
            }
        }
    }
    if dir.is_dir() {
        walk(dir, &mut files);
    }
    files
}

/// Find `.rs` files under a `kani/` directory.
fn glob_kani_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if path.extension().and_then(|e| e.to_str()) == Some("rs") {
                    files.push(path);
                }
            }
        }
    }
    if dir.is_dir() {
        walk(dir, &mut files);
    }
    files
}

/// Find `.tv.smt2` (translation validation) files under `dir`.
fn glob_tv_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = vec![];
    fn walk(dir: &Path, files: &mut Vec<PathBuf>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    walk(&path, files);
                } else if let Some(name) = path.file_name().and_then(|n| n.to_str()) {
                    if name.ends_with(".tv.smt2") {
                        files.push(path);
                    }
                }
            }
        }
    }
    walk(dir, &mut files);
    files
}

// ---------------------------------------------------------------------------
// Counting helpers (for cross-prover validation)
// ---------------------------------------------------------------------------

/// Count `Qed.` occurrences in active Coq build files.
/// Matches any line containing "Qed." (aligned with generate-metrics.sh grep).
fn count_coq_qed(coq_dir: &Path) -> u32 {
    let files = active_coq_files(coq_dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.contains("Qed.") {
                    count += 1;
                }
            }
        }
    }
    count
}

/// Count `theorem` and `lemma` declarations in Lean files.
fn count_lean_theorems(lean_dir: &Path) -> u32 {
    let files = glob_lean_files(lean_dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.starts_with("theorem ") || t.starts_with("lemma ") {
                    count += 1;
                }
            }
        }
    }
    count
}

/// Count `lemma` and `theorem` declarations in Isabelle `.thy` files.
fn count_isabelle_lemmas(isa_dir: &Path) -> u32 {
    let files = glob_thy_files(isa_dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.starts_with("lemma ") || t.starts_with("theorem ") {
                    count += 1;
                }
            }
        }
    }
    count
}

/// Count `val ..._lemma` declarations in F* `.fst` files.
fn count_fstar_lemmas(dir: &Path) -> u32 {
    let files = glob_fst_files(dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if (t.starts_with("val ") || t.starts_with("let ")) && t.contains("_lemma") {
                    count += 1;
                }
            }
        }
    }
    count
}

/// Count `THEOREM` declarations in TLA+ `.tla` files.
fn count_tla_theorems(dir: &Path) -> u32 {
    let files = glob_tla_files(dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                if line.starts_with("THEOREM ") {
                    count += 1;
                }
            }
        }
    }
    count
}

fn count_tlaplus_smoke_theorems(active_file: &Path) -> u32 {
    fs::read_to_string(active_file)
        .ok()
        .map(|content| {
            content
                .lines()
                .filter(|line| line.trim_start().starts_with("THEOREM "))
                .count() as u32
        })
        .unwrap_or(0)
}

fn count_alloy_smoke_assertions(active_file: &Path) -> u32 {
    fs::read_to_string(active_file)
        .ok()
        .map(|content| {
            content
                .lines()
                .filter(|line| line.trim_start().starts_with("check "))
                .count() as u32
        })
        .unwrap_or(0)
}

/// Count `check` declarations in Alloy `.als` files.
fn count_alloy_assertions(dir: &Path) -> u32 {
    let files = glob_als_files(dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.starts_with("check ") {
                    count += 1;
                }
            }
        }
    }
    count
}

fn parse_alloy_command_rows(output: &str) -> Vec<(usize, String)> {
    output
        .lines()
        .filter_map(|line| {
            let parts: Vec<&str> = line.split_whitespace().collect();
            if parts.len() >= 3 && parts[1] == "." {
                let idx = parts[0].parse::<usize>().ok()?;
                Some((idx, parts[2].to_ascii_lowercase()))
            } else {
                None
            }
        })
        .collect()
}

fn parse_alloy_exec_status(output: &str) -> Option<String> {
    let normalized = output.replace(['\u{0008}', '\r'], " ");
    normalized
        .lines()
        .filter_map(|line| {
            let trimmed = line.trim_start();
            if !trimmed.chars().next().is_some_and(|c| c.is_ascii_digit()) {
                return None;
            }
            if !trimmed.contains(". ") {
                return None;
            }
            trimmed.split_whitespace().last().map(str::to_string)
        })
        .next_back()
}

/// Count `(assert ` occurrences in `.smt2` files (excluding `.tv.smt2`).
fn count_smt_assertions(dir: &Path) -> u32 {
    let files = glob_smt_files(dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.contains("(assert ") {
                    count += 1;
                }
            }
        }
    }
    count
}

/// Count `proof fn ` declarations in Verus `.rs` files.
fn count_verus_proofs(dir: &Path) -> u32 {
    let files = glob_verus_files(dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.contains("proof fn ") {
                    count += 1;
                }
            }
        }
    }
    count
}

/// Count `#[kani::proof]` annotations in Kani `.rs` files.
fn count_kani_proofs(dir: &Path) -> u32 {
    let files = glob_kani_files(dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.contains("#[kani::proof]") {
                    count += 1;
                }
            }
        }
    }
    count
}

/// Count `(assert ` occurrences in `.tv.smt2` (translation validation) files.
fn count_tv_validations(dir: &Path) -> u32 {
    let files = glob_tv_files(dir);
    let mut count = 0u32;
    for path in files {
        if let Ok(content) = fs::read_to_string(&path) {
            for line in content.lines() {
                let t = line.trim();
                if t.contains("(assert ") {
                    count += 1;
                }
            }
        }
    }
    count
}

// ---------------------------------------------------------------------------
// Rust checks (unchanged)
// ---------------------------------------------------------------------------

/// Run `cargo test --all` in the given dir, return (passed, test_count_string).
fn run_cargo_test(proto_dir: &Path) -> CheckResult {
    let output = Command::new("cargo")
        .args(["test", "--all"])
        .current_dir(proto_dir)
        .output();

    match output {
        Ok(o) => {
            let stdout = String::from_utf8_lossy(&o.stdout);
            let stderr = String::from_utf8_lossy(&o.stderr);
            let combined = format!("{stdout}\n{stderr}");
            let count = parse_test_count(&combined);
            let passed = o.status.success();
            // A backend differential that cannot run panics rather than
            // silently skipping (deliberately — see the harnesses' own
            // `require_backend_tools`). That panic means `cc`/`wasmtime` is
            // absent HERE, which is an environment fact, not a repo one, and
            // must not be recorded as a verification result (REQ-76).
            let tools_absent = combined.contains("required backend tool(s) missing");
            CheckResult {
                name: "Rust Tests".into(),
                passed,
                blocking: true,
                details: if passed {
                    format!("{count} tests")
                } else if tools_absent {
                    format!(
                        "FAILED ({count} tests parsed) — a backend differential could not \
                         run for want of `cc`/`wasmtime` ({ENV_INCOMPLETE})"
                    )
                } else {
                    format!("FAILED ({count} tests parsed)")
                },
            }
        }
        Err(e) => CheckResult {
            name: "Rust Tests".into(),
            passed: false,
            blocking: true,
            details: format!("failed to run: {e}"),
        },
    }
}

/// Parse total passed test count from cargo test output.
pub fn parse_test_count(output: &str) -> u32 {
    let mut total = 0u32;
    for line in output.lines() {
        // Lines like: "test result: ok. 42 passed; 0 failed; ..."
        if let Some(rest) = line.strip_prefix("test result:") {
            for part in rest.split(';') {
                let part = part.trim();
                if let Some(num_str) = part.strip_suffix("passed") {
                    // num_str could be "ok. 42 " — take last word
                    if let Some(last) = num_str.trim().rsplit_once(' ') {
                        if let Ok(n) = last.1.parse::<u32>() {
                            total += n;
                        }
                    } else if let Ok(n) = num_str.trim().parse::<u32>() {
                        total += n;
                    }
                }
            }
        }
    }
    total
}

/// Run clippy in the given dir.
fn run_clippy(proto_dir: &Path) -> CheckResult {
    let output = Command::new("cargo")
        .args(["clippy", "--all"])
        .current_dir(proto_dir)
        .output();

    match output {
        Ok(o) => {
            let stderr = String::from_utf8_lossy(&o.stderr);
            let warnings = stderr.lines().filter(|l| l.contains("warning[")).count();
            let errors = stderr.lines().filter(|l| l.starts_with("error")).count();
            CheckResult {
                name: "Clippy".into(),
                passed: o.status.success(),
                blocking: true,
                details: if o.status.success() {
                    format!("{warnings} warnings")
                } else {
                    format!("{errors} errors, {warnings} warnings")
                },
            }
        }
        Err(e) => CheckResult {
            name: "Clippy".into(),
            passed: false,
            blocking: true,
            details: format!("failed to run: {e}"),
        },
    }
}

// ---------------------------------------------------------------------------
// Coq: active file list + static scan + compilation
// ---------------------------------------------------------------------------

/// Read active .v files from _CoqProject, falling back to recursive scan.
fn active_coq_files(coq_dir: &Path) -> Vec<PathBuf> {
    let project_file = coq_dir.join("_CoqProject");
    if let Ok(content) = fs::read_to_string(&project_file) {
        return content
            .lines()
            .map(|l| l.trim())
            .filter(|l| l.ends_with(".v") && !l.starts_with('#') && !l.starts_with('-'))
            .map(|l| coq_dir.join(l))
            .filter(|p| p.exists())
            .collect();
    }
    glob_v_files(coq_dir).unwrap_or_default()
}

/// Static scan of Coq directory for admits and axioms (active build files only).
fn scan_coq(coq_dir: &Path) -> Vec<CheckResult> {
    let mut results = vec![];

    let mut admit_count = 0u32;
    let mut axiom_count = 0u32;
    let mut explicit_step_up_assumption_count = 0u32;

    {
        let entries = active_coq_files(coq_dir);
        for path in entries {
            if let Ok(content) = fs::read_to_string(&path) {
                let mut in_comment = false;
                for line in content.lines() {
                    let trimmed = line.trim();
                    // Track block comments (simple heuristic)
                    if trimmed.contains("(*") {
                        in_comment = true;
                    }
                    if trimmed.contains("*)") {
                        in_comment = false;
                        continue;
                    }
                    if in_comment || trimmed.starts_with("(*") {
                        continue;
                    }
                    if trimmed == "Admitted." || trimmed.ends_with(" Admitted.") {
                        admit_count += 1;
                    }
                    if trimmed.contains("admit.") {
                        admit_count += 1;
                    }
                    if trimmed.starts_with("Axiom ") {
                        axiom_count += 1;
                    }
                    if trimmed.starts_with("Parameter val_rel_n_step_up ") {
                        explicit_step_up_assumption_count += 1;
                    }
                }
            }
        }
    }

    // 1 Admitted allowed: combined_step_up_all in NonInterference_v2.v
    // (HO step-up at n=1 for TFn — requires restructuring mutual induction to eliminate)
    let admit_target = 1;
    results.push(CheckResult {
        name: "Coq Admits".into(),
        passed: admit_count <= admit_target,
        blocking: true,
        details: format!("{admit_count} (target: {admit_target})"),
    });

    results.push(CheckResult {
        name: "Coq Axioms".into(),
        passed: true, // axioms are informational
        blocking: true,
        details: format!("{axiom_count} (informational; explicit assumptions tracked separately)"),
    });

    results.push(CheckResult {
        name: "Coq Explicit Step-Up Assumption".into(),
        passed: explicit_step_up_assumption_count == 0,
        blocking: true,
        details: format!(
            "{explicit_step_up_assumption_count} (target: 0; Parameter val_rel_n_step_up)"
        ),
    });

    results
}


// ---------------------------------------------------------------------------
// Kernel-level assumption attestation (REQ-53)
// ---------------------------------------------------------------------------

/// The theorems whose assumption sets are attested by the kernel on every full
/// verify. Grep counts what RIINA's sources DECLARE; `Print Assumptions` asks
/// the kernel what a theorem actually DEPENDS ON — including axioms imported
/// from the standard library, which grep cannot see (that is how the
/// `functional_extensionality_dep` dependency of the SN development went
/// undisclosed until 2026-08-05).
const KERNEL_CAPSTONES: &[(&str, &str)] = &[
    ("type_system.TypeSafety", "type_safety"),
    ("type_system.Progress", "progress"),
    ("type_system.Preservation", "preservation"),
    ("termination.ReducibilityFull", "well_typed_SN"),
    ("crypto.AlgorithmPolicy", "accepts_uses_only_current"),
];

/// Axioms the capstones are ALLOWED to depend on. Additions require the same
/// deliberate review as a TCB change: each entry is a named, documented
/// assumption (master plan Part 2, kernel-level assumption audit).
const ALLOWED_KERNEL_AXIOMS: &[&str] = &[
    // Rocq stdlib functional extensionality — standard, consistent with the
    // calculus, used by the SN/logical-relations development (30 files).
    "FunctionalExtensionality.functional_extensionality_dep",
];

/// Parse `Print Assumptions` output into (attestation_blocks, axiom_names).
///
/// A block is either `Closed under the global context` or an `Axioms:` section
/// whose entries start at column 0 as `Name :` with the type indented on
/// following lines. The block count must match the number of capstones queried
/// — fewer means the scratch file did not get through all of them, and that is
/// a FAILURE, not a pass (a gate that silently checked nothing would be green).
fn parse_print_assumptions(output: &str) -> (usize, Vec<String>) {
    let mut blocks = 0usize;
    let mut axioms = Vec::new();
    let mut in_axioms = false;
    for line in output.lines() {
        let trimmed = line.trim_end();
        if trimmed == "Closed under the global context" {
            blocks += 1;
            in_axioms = false;
        } else if trimmed == "Axioms:" {
            blocks += 1;
            in_axioms = true;
        } else if in_axioms {
            // Axiom names are flush-left; continuation/type lines are indented.
            if trimmed.starts_with(char::is_whitespace) || trimmed.is_empty() {
                continue;
            }
            // `Name : ...` or `Name :` — take the token before the colon.
            if let Some(name) = trimmed.split(':').next() {
                let name = name.trim();
                if !name.is_empty() {
                    axioms.push(name.to_string());
                }
            }
        }
    }
    (blocks, axioms)
}

/// Ask the kernel what the capstone theorems depend on, and fail on any axiom
/// outside the reviewed whitelist. Requires the `.vo` files compile_coq just
/// produced; runs only in full mode where the prover is mandatory.
fn check_kernel_assumptions(coq_dir: &Path) -> CheckResult {
    let coqc_path = match detect_coqc() {
        ToolStatus::Found(p) => p,
        ToolStatus::NotFound(msg) => {
            return CheckResult {
                name: "Coq Kernel Assumptions".into(),
                passed: false,
                blocking: false,
                details: format!("SKIPPED ({msg}). Attestation INCOMPLETE"),
            };
        }
    };
    let rocq = coqc_path.parent().map(|d| d.join("rocq"));
    let rocq = match rocq {
        Some(p) if p.exists() => p,
        _ => coqc_path.clone(),
    };

    let mut scratch = String::new();
    for (module, _) in KERNEL_CAPSTONES {
        scratch.push_str(&format!("From RIINA Require Import {module}.\n"));
    }
    for (_, theorem) in KERNEL_CAPSTONES {
        scratch.push_str(&format!("Print Assumptions {theorem}.\n"));
    }
    let tmp = std::env::temp_dir().join("riina_kernel_assumptions_check.v");
    if let Err(e) = fs::write(&tmp, &scratch) {
        return CheckResult {
            name: "Coq Kernel Assumptions".into(),
            passed: false,
            blocking: true,
            details: format!("cannot write scratch file: {e}"),
        };
    }

    let output = std::process::Command::new(&rocq)
        .args([
            "compile",
            "-q",
            "-w",
            "-deprecated-native-compiler-option",
            "-native-compiler",
            "no",
            "-Q",
            ".",
            "RIINA",
        ])
        .arg(&tmp)
        .current_dir(coq_dir)
        .output();

    let output = match output {
        Ok(o) => o,
        Err(e) => {
            return CheckResult {
                name: "Coq Kernel Assumptions".into(),
                passed: false,
                blocking: true,
                details: format!("failed to run rocq: {e}"),
            }
        }
    };
    let text = format!(
        "{}\n{}",
        String::from_utf8_lossy(&output.stdout),
        String::from_utf8_lossy(&output.stderr)
    );
    if !output.status.success() {
        return CheckResult {
            name: "Coq Kernel Assumptions".into(),
            passed: false,
            blocking: true,
            details: format!(
                "scratch compile failed: {}",
                truncate_str(text.trim(), 300)
            ),
        };
    }

    let (blocks, axioms) = parse_print_assumptions(&text);
    let unexpected: Vec<&String> = axioms
        .iter()
        .filter(|a| !ALLOWED_KERNEL_AXIOMS.contains(&a.as_str()))
        .collect();

    if blocks != KERNEL_CAPSTONES.len() {
        return CheckResult {
            name: "Coq Kernel Assumptions".into(),
            passed: false,
            blocking: true,
            details: format!(
                "attested {blocks}/{} capstones — output did not cover every \
                 theorem, refusing to report a pass on a partial attestation",
                KERNEL_CAPSTONES.len()
            ),
        };
    }
    if !unexpected.is_empty() {
        return CheckResult {
            name: "Coq Kernel Assumptions".into(),
            passed: false,
            blocking: true,
            details: format!(
                "NEW kernel-level axiom(s) outside the reviewed whitelist: {:?} — \
                 a capstone theorem now depends on an assumption nobody reviewed. \
                 Either eliminate it or add it to ALLOWED_KERNEL_AXIOMS with a \
                 Part 2 TCB entry (a deliberate, documented decision)",
                unexpected
            ),
        };
    }
    CheckResult {
        name: "Coq Kernel Assumptions".into(),
        passed: true,
        blocking: true,
        details: format!(
            "{} capstones attested; axioms within reviewed whitelist ({} allowed: funext)",
            KERNEL_CAPSTONES.len(),
            ALLOWED_KERNEL_AXIOMS.len()
        ),
    }
}

/// Verify every `.v` file on disk (excluding `_archive_deprecated/`) is listed
/// in `_CoqProject`.  Catches drift where a file exists but the build system
/// (and therefore `verify.rs`) never sees it.
fn verify_coqproject_completeness(coq_dir: &Path) -> CheckResult {
    let project_file = coq_dir.join("_CoqProject");
    let project_content = match fs::read_to_string(&project_file) {
        Ok(c) => c,
        Err(e) => {
            return CheckResult {
                name: "_CoqProject Completeness".into(),
                passed: false,
                blocking: true,
                details: format!("cannot read _CoqProject: {e}"),
            };
        }
    };

    // Collect entries from _CoqProject (relative paths ending in .v)
    let project_entries: std::collections::HashSet<String> = project_content
        .lines()
        .map(|l| l.trim().to_string())
        .filter(|l| l.ends_with(".v") && !l.starts_with('#') && !l.starts_with('-'))
        .collect();

    // Collect all .v files on disk (excluding _archive_deprecated)
    let all_v = glob_v_files(coq_dir).unwrap_or_default();
    let mut missing = Vec::new();
    for path in &all_v {
        // Skip _archive_deprecated and _incomplete
        if path
            .components()
            .any(|c| c.as_os_str() == "_archive_deprecated" || c.as_os_str() == "_incomplete")
        {
            continue;
        }
        // Convert to relative path from coq_dir
        if let Ok(rel) = path.strip_prefix(coq_dir) {
            let rel_str = rel.to_string_lossy().to_string();
            if !project_entries.contains(&rel_str) {
                missing.push(rel_str);
            }
        }
    }

    if missing.is_empty() {
        CheckResult {
            name: "_CoqProject Completeness".into(),
            passed: true,
            blocking: true,
            details: format!(
                "all {} .v files listed in _CoqProject",
                project_entries.len()
            ),
        }
    } else {
        missing.sort();
        let listed = missing
            .iter()
            .take(10)
            .cloned()
            .collect::<Vec<_>>()
            .join(", ");
        let suffix = if missing.len() > 10 {
            format!(" (and {} more)", missing.len() - 10)
        } else {
            String::new()
        };
        CheckResult {
            name: "_CoqProject Completeness".into(),
            passed: false,
            blocking: true,
            details: format!(
                "{} .v file(s) not in _CoqProject: {}{}",
                missing.len(),
                listed,
                suffix
            ),
        }
    }
}

/// Compile all Coq proofs by running `make -j2` in the Coq directory.
fn compile_coq(coq_dir: &Path) -> CheckResult {
    let coqc_path = match detect_coqc() {
        ToolStatus::Found(p) => p,
        ToolStatus::NotFound(msg) => {
            return CheckResult {
                name: "Coq Compilation".into(),
                passed: false,
                blocking: false,
                details: format!("SKIPPED ({msg}). Verification INCOMPLETE"),
            };
        }
    };

    // Derive COQBIN directory (parent of coqc binary)
    let coqbin = coqc_path
        .parent()
        .map(|p| p.to_string_lossy().to_string())
        .unwrap_or_default();

    eprintln!("  coqc found: {}", coqc_path.display());

    // Set up environment: COQBIN and PATH must be consistent for both clean and build.
    let path_env = if !coqbin.is_empty() {
        let existing = std::env::var("PATH").unwrap_or_default();
        format!("{coqbin}:{existing}")
    } else {
        std::env::var("PATH").unwrap_or_default()
    };
    let coqbin_env = format!("{coqbin}/");

    // Clean stale .vo files first to avoid spurious failures from prior builds
    let _ = Command::new("make")
        .args(["clean"])
        .env("COQBIN", &coqbin_env)
        .env("PATH", &path_env)
        .current_dir(coq_dir)
        .output();

    let start = Instant::now();

    // Run make -j2 with COQBIN set and coq binaries on PATH
    // Use -j2 (not -j4) to avoid race conditions in Makefile dependency graph.
    // The Makefile's Makefile.conf target calls bare `coq_makefile` (not $(COQBIN)coq_makefile),
    // so we must ensure COQBIN is also on PATH.
    let result = Command::new("make")
        .args(["-j2"])
        .env("COQBIN", &coqbin_env)
        .env("PATH", &path_env)
        .current_dir(coq_dir)
        .output();

    let elapsed = start.elapsed();

    match result {
        Ok(o) => {
            if o.status.success() {
                let vo_count = count_files_with_ext(coq_dir, "vo");
                CheckResult {
                    name: "Coq Compilation".into(),
                    passed: true,
                    blocking: true,
                    details: format!(
                        "{vo_count} .vo files compiled in {:.0}s",
                        elapsed.as_secs_f64()
                    ),
                }
            } else {
                let code = o.status.code().unwrap_or(-1);
                // Exit code 124 = timeout (from `timeout` coreutil)
                if code == 124 {
                    return CheckResult {
                        name: "Coq Compilation".into(),
                        passed: false,
                        blocking: true,
                        details: format!(
                            "TIMEOUT after {:.0}s (limit: {}s)",
                            elapsed.as_secs_f64(),
                            COQ_TIMEOUT.as_secs()
                        ),
                    };
                }
                let stderr = String::from_utf8_lossy(&o.stderr);
                let tail = last_n_lines(&stderr, 10);
                CheckResult {
                    name: "Coq Compilation".into(),
                    passed: false,
                    // Blocking: Coq 8.20.1 is stable. If compilation fails,
                    // the push must fail — static scans alone are insufficient.
                    blocking: true,
                    details: format!(
                        "FAILED (exit {code}, {:.0}s)\n{}",
                        elapsed.as_secs_f64(),
                        truncate_str(&tail, 500)
                    ),
                }
            }
        }
        Err(e) => CheckResult {
            name: "Coq Compilation".into(),
            passed: false,
            blocking: true,
            details: format!("failed to run make: {e}"),
        },
    }
}

// ---------------------------------------------------------------------------
// Lean 4: compilation + static scan
// ---------------------------------------------------------------------------

/// Elaborate a single canary CORE Lean file and return its `error:` count.
///
/// `Some(0)` means the core type-safety file genuinely elaborates (real progress);
/// `Some(n)` means it does not (the lane is a generated port); `None` means the
/// probe could not run (lean missing/errored). This is what keeps the manifest
/// from reporting a shim-only `lake build` as a Lean PASS.
fn lean_core_canary_errors(lake_path: &Path, lean_dir: &Path) -> Option<u32> {
    let canary = "RIINA/Foundations/Syntax.lean";
    if !lean_dir.join(canary).exists() {
        return None;
    }
    let out = run_with_timeout(
        lake_path.to_str().unwrap_or("lake"),
        &["env", "lean", canary],
        lean_dir,
        LEAN_TIMEOUT,
    )
    .ok()?;
    if out.status.success() {
        return Some(0);
    }
    // Timeout / spawn failure → inconclusive, not "0 errors".
    if out.status.code() == Some(124) {
        return None;
    }
    let combined = format!(
        "{}\n{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    let errors = combined.lines().filter(|l| l.contains("error:")).count() as u32;
    // Non-zero exit but no parsed "error:" lines still means "did not elaborate".
    Some(errors.max(1))
}

/// Compile Lean proofs by running `lake build`.
fn compile_lean(lean_dir: &Path) -> CheckResult {
    let lake_path = match detect_lake() {
        ToolStatus::Found(p) => p,
        ToolStatus::NotFound(msg) => {
            return CheckResult {
                name: "Lean 4 Compilation".into(),
                passed: false,
                blocking: false,
                details: format!("SKIPPED ({msg}). Verification INCOMPLETE"),
            };
        }
    };

    eprintln!("  lake found: {}", lake_path.display());
    let start = Instant::now();

    let result = run_with_timeout(
        lake_path.to_str().unwrap_or("lake"),
        &["build"],
        lean_dir,
        LEAN_TIMEOUT,
    );

    let elapsed = start.elapsed();

    match result {
        Ok(o) => {
            let stdout = String::from_utf8_lossy(&o.stdout);
            let stderr = String::from_utf8_lossy(&o.stderr);
            let combined = format!("{stdout}\n{stderr}");

            // Check for sorry warnings in build output
            let sorry_warnings = combined
                .lines()
                .filter(|l| l.contains("declaration uses 'sorry'"))
                .count();

            if o.status.success() && sorry_warnings == 0 {
                // A successful default `lake build` only proves the default target
                // builds — which is the 0-theorem `Domains/All` shim, NOT the lane.
                // Probe a canary CORE type-safety file to tell "lane genuinely
                // elaborates" apart from "shim builds". Only the former is a real
                // PASS; otherwise the lane is generated/not-mechanized (WARN), so
                // the manifest never claims an inherited Lean PASS.
                let canary_errors = lean_core_canary_errors(&lake_path, lean_dir);
                match canary_errors {
                    Some(0) => CheckResult {
                        name: "Lean 4 Compilation".into(),
                        passed: true,
                        blocking: true,
                        details: format!(
                            "Built in {:.0}s (0 sorry); core canary Foundations/Syntax.lean elaborates",
                            elapsed.as_secs_f64()
                        ),
                    },
                    Some(n) => CheckResult {
                        name: "Lean 4 Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!(
                            "GENERATED, not mechanized: default `lake build` builds only the \
                             0-theorem `Domains/All` shim ({:.0}s); core Foundations/Syntax.lean \
                             does NOT elaborate ({n} errors). See 02_FORMAL/lean/COMPILATION_STATUS.md",
                            elapsed.as_secs_f64()
                        ),
                    },
                    None => CheckResult {
                        name: "Lean 4 Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!(
                            "GENERATED, not mechanized: shim build succeeded ({:.0}s) but the core \
                             canary could not be elaborated (lean unavailable/errored). \
                             See 02_FORMAL/lean/COMPILATION_STATUS.md",
                            elapsed.as_secs_f64()
                        ),
                    },
                }
            } else if o.status.success() && sorry_warnings > 0 {
                // Build succeeded but sorry found — non-blocking (transpiled)
                CheckResult {
                    name: "Lean 4 Compilation".into(),
                    passed: false,
                    blocking: false,
                    details: format!(
                        "Built in {:.0}s but {sorry_warnings} sorry warning(s) detected",
                        elapsed.as_secs_f64()
                    ),
                }
            } else {
                let code = o.status.code().unwrap_or(-1);
                if code == 124 {
                    return CheckResult {
                        name: "Lean 4 Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!(
                            "TIMEOUT after {:.0}s (limit: {}s)",
                            elapsed.as_secs_f64(),
                            LEAN_TIMEOUT.as_secs()
                        ),
                    };
                }
                let tail = last_n_lines(&stderr, 10);
                CheckResult {
                    name: "Lean 4 Compilation".into(),
                    passed: false,
                    blocking: false,
                    details: format!(
                        "FAILED (exit {code}, {:.0}s)\n{}",
                        elapsed.as_secs_f64(),
                        truncate_str(&tail, 500)
                    ),
                }
            }
        }
        Err(e) => {
            if e.kind() == io::ErrorKind::TimedOut {
                CheckResult {
                    name: "Lean 4 Compilation".into(),
                    passed: false,
                    blocking: false,
                    details: format!(
                        "TIMEOUT after {:.0}s (limit: {}s)",
                        elapsed.as_secs_f64(),
                        LEAN_TIMEOUT.as_secs()
                    ),
                }
            } else {
                CheckResult {
                    name: "Lean 4 Compilation".into(),
                    passed: false,
                    blocking: false,
                    details: format!("failed to run lake: {e}"),
                }
            }
        }
    }
}

/// Static scan of Lean files for `sorry` (skipping comments and strings).
fn scan_lean(lean_dir: &Path) -> Vec<CheckResult> {
    let files = glob_lean_files(lean_dir);
    let mut sorry_count = 0u32;
    let mut generated_stub_sorry = 0u32;
    let mut theorem_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            let mut in_block_comment = 0i32; // nesting depth
            for line in content.lines() {
                let trimmed = line.trim();

                // Transpiler fallback marker: keep visible in counts, but do not
                // treat as actionable `sorry` backlog for verification noise.
                if trimmed.contains("sorry -- complex match, needs manual translation") {
                    generated_stub_sorry += 1;
                    continue;
                }

                // Track nested block comments /- ... -/
                for window in trimmed.as_bytes().windows(2) {
                    if window == b"/-" {
                        in_block_comment += 1;
                    }
                    if window == b"-/" && in_block_comment > 0 {
                        in_block_comment -= 1;
                    }
                }

                if in_block_comment > 0 {
                    continue;
                }

                // Skip line comments
                let effective = if let Some(pos) = trimmed.find("--") {
                    &trimmed[..pos]
                } else {
                    trimmed
                };

                // Count theorems/lemmas
                if effective.starts_with("theorem ") || effective.starts_with("lemma ") {
                    theorem_count += 1;
                }

                // Check for sorry (as a word boundary)
                if contains_word(effective, "sorry") {
                    sorry_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "Lean sorry Scan".into(),
        passed: sorry_count == 0,
        // Non-blocking informational check; hand-written lanes are validated by
        // Lean compilation and claim-level quality gates.
        blocking: false,
        details: format!(
            "{sorry_count} actionable sorry (+{generated_stub_sorry} generated fallback stubs) in {} files ({theorem_count} theorems/lemmas)",
            files.len(),
        ),
    }]
}

// ---------------------------------------------------------------------------
// Isabelle: compilation + static scan
// ---------------------------------------------------------------------------

/// Compile Isabelle core TypeSystem proofs using an isolated session.
fn compile_isabelle(isabelle_dir: &Path) -> CheckResult {
    // The ROOT file lives in 02_FORMAL/isabelle/RIINA/
    let riina_dir = isabelle_dir.join("RIINA");
    if !riina_dir.join("ROOT").exists() {
        return CheckResult {
            name: "Isabelle Compilation".into(),
            passed: false,
            blocking: false,
            details: "ROOT file not found in isabelle/RIINA/".into(),
        };
    }

    fn run_isabelle_build(cmd: &str, args: &[&str], cwd: &Path, source: &str) -> CheckResult {
        let start = Instant::now();
        let result = run_with_timeout(cmd, args, cwd, ISABELLE_TIMEOUT);
        let elapsed = start.elapsed();

        match result {
            Ok(o) => {
                if o.status.success() {
                    CheckResult {
                        name: "Isabelle Compilation".into(),
                        passed: true,
                        blocking: false,
                        details: format!(
                            "Session RIINA_CORE built in {:.0}s ({source})",
                            elapsed.as_secs_f64()
                        ),
                    }
                } else {
                    let code = o.status.code().unwrap_or(-1);
                    if code == 124 {
                        return CheckResult {
                            name: "Isabelle Compilation".into(),
                            passed: false,
                            blocking: false,
                            details: format!(
                                "TIMEOUT after {:.0}s (limit: {}s, {source})",
                                elapsed.as_secs_f64(),
                                ISABELLE_TIMEOUT.as_secs()
                            ),
                        };
                    }
                    let stderr = String::from_utf8_lossy(&o.stderr);
                    let stdout = String::from_utf8_lossy(&o.stdout);
                    let combined = format!("{stdout}\n{stderr}");
                    let tail = last_n_lines(&combined, 10);
                    CheckResult {
                        name: "Isabelle Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!(
                            "FAILED (exit {code}, {:.0}s, {source})\n{}",
                            elapsed.as_secs_f64(),
                            truncate_str(&tail, 500)
                        ),
                    }
                }
            }
            Err(e) => {
                if e.kind() == io::ErrorKind::TimedOut {
                    CheckResult {
                        name: "Isabelle Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!(
                            "TIMEOUT after {:.0}s (limit: {}s, {source})",
                            elapsed.as_secs_f64(),
                            ISABELLE_TIMEOUT.as_secs()
                        ),
                    }
                } else {
                    CheckResult {
                        name: "Isabelle Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!("failed to run isabelle ({source}): {e}"),
                    }
                }
            }
        }
    }

    fn prepare_isabelle_core_dir(riina_dir: &Path) -> io::Result<PathBuf> {
        let repo_root = riina_dir
            .parent() // .../isabelle
            .and_then(|p| p.parent()) // .../02_FORMAL
            .and_then(|p| p.parent()) // repo root
            .unwrap_or(riina_dir);

        let ts = SystemTime::now()
            .duration_since(SystemTime::UNIX_EPOCH)
            .unwrap_or_default()
            .as_millis();
        let core_dir = repo_root.join(format!(
            ".isabelle-core-verify-{}-{}",
            std::process::id(),
            ts
        ));
        fs::create_dir_all(&core_dir)?;

        let progress_src = riina_dir.join("TypeSystem/Progress.thy");
        let preservation_src = riina_dir.join("TypeSystem/Preservation.thy");
        let typesafety_src = riina_dir.join("TypeSystem/TypeSafety.thy");

        if !progress_src.exists() || !preservation_src.exists() || !typesafety_src.exists() {
            return Err(io::Error::new(
                io::ErrorKind::NotFound,
                "missing Isabelle TypeSystem core files",
            ));
        }

        fs::copy(&progress_src, core_dir.join("Progress.thy"))?;
        fs::copy(&preservation_src, core_dir.join("Preservation.thy"))?;
        fs::copy(&typesafety_src, core_dir.join("TypeSafety.thy"))?;
        fs::write(
            core_dir.join("ROOT"),
            "session RIINA_CORE = HOL +\n  theories\n    Progress\n    Preservation\n    TypeSafety\n",
        )?;

        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            fs::set_permissions(&core_dir, fs::Permissions::from_mode(0o755))?;
            for file in ["Progress.thy", "Preservation.thy", "TypeSafety.thy", "ROOT"] {
                fs::set_permissions(core_dir.join(file), fs::Permissions::from_mode(0o644))?;
            }
        }

        Ok(core_dir)
    }

    let core_dir = match prepare_isabelle_core_dir(&riina_dir) {
        Ok(p) => p,
        Err(e) => {
            return CheckResult {
                name: "Isabelle Compilation".into(),
                passed: false,
                blocking: true,
                details: format!("failed to prepare core Isabelle session: {e}"),
            };
        }
    };

    let result = match detect_isabelle() {
        ToolStatus::Found(isa_path) => {
            eprintln!("  isabelle found: {}", isa_path.display());
            run_isabelle_build(
                isa_path.to_str().unwrap_or("isabelle"),
                &[
                    "build",
                    "-d",
                    core_dir.to_str().unwrap_or("."),
                    "-b",
                    "RIINA_CORE",
                ],
                &core_dir,
                "local_core",
            )
        }
        ToolStatus::NotFound(msg) => CheckResult {
            name: "Isabelle Compilation".into(),
            passed: false,
            blocking: false,
            details: msg.to_string(),
        },
    };

    let _ = fs::remove_dir_all(&core_dir);
    result
}

/// Static scan of Isabelle `.thy` files for `sorry` and `oops`.
fn scan_isabelle(isabelle_dir: &Path) -> Vec<CheckResult> {
    let thy_dir = isabelle_dir.join("RIINA");
    let files = glob_thy_files(&thy_dir);
    let mut sorry_count = 0u32;
    let mut oops_count = 0u32;
    let mut lemma_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            let mut in_comment = false;
            let mut in_text_block = false;
            for line in content.lines() {
                let trimmed = line.trim();

                // Track Isabelle text blocks \<open> ... \<close>
                if trimmed.contains("\\<open>") {
                    in_text_block = true;
                }
                if trimmed.contains("\\<close>") {
                    in_text_block = false;
                    continue;
                }
                if in_text_block {
                    continue;
                }

                // Track Isabelle block comments (* ... *)
                // Handle single-line comments: (* ... *)
                if trimmed.contains("(*") && trimmed.contains("*)") {
                    continue; // entire line is a single-line comment
                }
                if trimmed.contains("(*") {
                    in_comment = true;
                }
                if trimmed.contains("*)") {
                    in_comment = false;
                    continue;
                }
                if in_comment {
                    continue;
                }

                // Count lemmas/theorems
                if trimmed.starts_with("lemma ") || trimmed.starts_with("theorem ") {
                    lemma_count += 1;
                }

                // Check for sorry / oops — must be standalone tactic, not in text
                if contains_word(trimmed, "sorry") {
                    sorry_count += 1;
                }
                if contains_word(trimmed, "oops") {
                    oops_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "Isabelle sorry/oops".into(),
        passed: sorry_count == 0 && oops_count == 0,
        blocking: true,
        details: format!(
            "{sorry_count} sorry + {oops_count} oops in {} files ({lemma_count} lemmas)",
            files.len()
        ),
    }]
}

// ---------------------------------------------------------------------------
// Cross-prover validation (informational)
// ---------------------------------------------------------------------------

/// Verify metrics.json accuracy against live codebase counts.
/// Catches drift between documented metrics and actual state.
fn verify_metrics_accuracy(
    repo: &Path,
    coq_dir: &Path,
    lean_dir: &Path,
    isabelle_dir: &Path,
) -> CheckResult {
    let metrics_path = repo.join("website/public/metrics.json");
    let content = match fs::read_to_string(&metrics_path) {
        Ok(c) => c,
        Err(_) => {
            return CheckResult {
                name: "Metrics Accuracy".into(),
                passed: false,
                blocking: true,
                details: "metrics.json not found — run generate-metrics.sh".into(),
            };
        }
    };

    // Parse key values from JSON (no serde — zero deps)
    let parse_field = |field: &str| -> Option<u32> {
        content.find(&format!("\"{field}\"")).and_then(|pos| {
            let after = &content[pos + field.len() + 3..]; // skip `"field": `
            let num_start = after.find(|c: char| c.is_ascii_digit())?;
            let num_end = after[num_start..].find(|c: char| !c.is_ascii_digit())?;
            after[num_start..num_start + num_end].parse().ok()
        })
    };

    let json_qed = parse_field("qedActive").unwrap_or(0);
    let json_lean = parse_field("theorems").unwrap_or(0);
    let json_isabelle = parse_field("lemmasRaw").unwrap_or(0);
    let json_admitted = parse_field("admitted").unwrap_or(u32::MAX);
    let json_axioms = parse_field("axioms").unwrap_or(u32::MAX);

    // Live counts
    let live_qed = count_coq_qed(coq_dir);
    let live_lean = count_lean_theorems(lean_dir);
    let live_isabelle = count_isabelle_lemmas(&isabelle_dir.join("RIINA"));

    let mut drifts = Vec::new();
    if json_qed != live_qed {
        drifts.push(format!("Coq Qed: json={json_qed} live={live_qed}"));
    }
    if json_lean != live_lean {
        drifts.push(format!("Lean: json={json_lean} live={live_lean}"));
    }
    if json_isabelle != live_isabelle {
        drifts.push(format!(
            "Isabelle: json={json_isabelle} live={live_isabelle}"
        ));
    }
    // 1 Admitted allowed: combined_step_up_all in NonInterference_v2.v
    if json_admitted > 1 {
        drifts.push(format!(
            "Admitted in metrics.json: {json_admitted} (must be <= 1)"
        ));
    }

    if drifts.is_empty() {
        CheckResult {
            name: "Metrics Accuracy".into(),
            passed: true,
            blocking: true,
            details: format!(
                "metrics.json matches live counts (Qed={live_qed}, Lean={live_lean}, Isabelle={live_isabelle}, Admitted={json_admitted}, Axioms={json_axioms})"
            ),
        }
    } else {
        CheckResult {
            name: "Metrics Accuracy".into(),
            passed: false,
            blocking: true,
            details: format!("DRIFT: {}", drifts.join("; ")),
        }
    }
}

/// Cross-validate proof counts across all ten provers.
/// Checks that Lean and Isabelle theorem counts are within 50% of the Coq domain count.
/// Also aggregates counts from all 7 additional provers.
fn cross_validate_provers(dirs: &ProverDirs<'_>) -> CheckResult {
    let coq_qed = count_coq_qed(dirs.coq_dir);
    let lean_thm = count_lean_theorems(dirs.lean_dir);
    let isa_lem = count_isabelle_lemmas(&dirs.isabelle_dir.join("RIINA"));
    let fstar_lem = count_fstar_lemmas(dirs.fstar_dir);
    let tla_thm = count_tla_theorems(dirs.tlaplus_dir);
    let alloy_asrt = count_alloy_assertions(dirs.alloy_dir);
    let smt_asrt = count_smt_assertions(dirs.smt_dir);
    let verus_pf = count_verus_proofs(dirs.verus_dir);
    let kani_pf = count_kani_proofs(dirs.kani_dir);
    let tv_val = count_tv_validations(dirs.tv_dir);

    let grand_total = coq_qed
        + lean_thm
        + isa_lem
        + fstar_lem
        + tla_thm
        + alloy_asrt
        + smt_asrt
        + verus_pf
        + kani_pf
        + tv_val;

    // Check multi-prover parity: Lean and Isabelle should each have
    // at least 50% of the Coq theorem count (accounting for foundation
    // proofs that are more detailed in Coq).
    let threshold = coq_qed / 2;
    let parity_ok = lean_thm >= threshold && isa_lem >= threshold;

    CheckResult {
        name: "Cross-Prover Validation (10 provers)".into(),
        passed: parity_ok,
        // Non-blocking for now — promote to blocking once parity is validated
        blocking: false,
        details: format!(
            "Grand total: {grand_total} | Coq: {coq_qed} | Lean: {lean_thm} | Isabelle: {isa_lem} | \
             F*: {fstar_lem} | TLA+: {tla_thm} | Alloy: {alloy_asrt} | SMT: {smt_asrt} | \
             Verus: {verus_pf} | Kani: {kani_pf} | TV: {tv_val} | Parity: {}",
            if parity_ok { "OK" } else { "DRIFT (Lean/Isabelle < 50% of Coq)" }
        ),
    }
}

// ---------------------------------------------------------------------------
// Transpiler staleness check
// ---------------------------------------------------------------------------

/// Get the most recent modification time of any file with the given extension
/// under `dir`.  Returns `None` if no files found.
/// A directory whose contents must not influence freshness: it holds material
/// that is deliberately no longer built.
///
/// The staleness check compares "newest Coq source" against "newest transpiled
/// output", and without this an ARCHIVED file drives the verdict for every lane.
/// It was not hypothetical: `properties/_archive_deprecated/` held the newest
/// `.v` in the whole tree, 14 days ahead of any active file, so every lane was
/// measured against a proof that was retired on purpose.
fn is_archived_dir(path: &Path) -> bool {
    path.file_name()
        .and_then(|n| n.to_str())
        .is_some_and(|n| n.starts_with("_archive"))
}

fn newest_mtime(dir: &Path, ext: &str) -> Option<SystemTime> {
    fn walk(dir: &Path, ext: &str, best: &mut Option<SystemTime>) {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    if is_archived_dir(&path) {
                        continue;
                    }
                    walk(&path, ext, best);
                } else if path.extension().and_then(|e| e.to_str()) == Some(ext) {
                    if let Ok(meta) = fs::metadata(&path) {
                        if let Ok(mt) = meta.modified() {
                            if best.is_none_or(|b| mt > b) {
                                *best = Some(mt);
                            }
                        }
                    }
                }
            }
        }
    }
    let mut best = None;
    walk(dir, ext, &mut best);
    best
}

/// Is `lane` one the owner has RETIRED, whatever its per-lane status field
/// happens to say?
///
/// Retirement is recorded in two independent places — `claimLevels.<lane>` and,
/// for some lanes, a `<lane>Status` field — and the per-lane arms in
/// `check_transpiler_staleness` only ever enumerated `generated` and `stub`.
/// `fstarStatus` is `"retired"`, which matches neither, so the F* arm returned
/// "freshness required" for a lane that is not built at all. Isabelle escaped
/// only by accident: its arm keys on `isabelleCompiled`, which is false for an
/// unrelated reason.
///
/// Owner decision 2026-08-06 retired F* and Isabelle; asking a retired lane to
/// keep pace with Coq is asking for a regeneration nobody intends to run.
///
/// This is a free function rather than a closure so the test below can call the
/// REAL predicate — a test that reimplements the rule it is checking proves
/// only that the author can copy code twice.
fn lane_is_retired(metrics: &str, lane: &str) -> bool {
    let (claim_key, status_key) = match lane {
        "Lean" => ("lean", "leanStatus"),
        "Isabelle" => ("isabelle", "isabelleStatus"),
        "F*" => ("fstar", "fstarStatus"),
        "TLA+" => ("tlaplus", "tlaplusStatus"),
        "Alloy" => ("alloy", "alloyStatus"),
        "SMT" => ("smt", "smtStatus"),
        "Verus" => ("verus", "verusStatus"),
        "Kani" => ("kani", "kaniStatus"),
        "TV" => ("tv", "tvStatus"),
        _ => return false,
    };
    metrics.contains(&format!("\"{claim_key}\": \"retired\""))
        || metrics.contains(&format!("\"{status_key}\": \"retired\""))
}

/// Must `lane` be regenerated whenever Coq moves?
///
/// `metrics` is `None` when `website/public/metrics.json` could not be read, in
/// which case every lane is held to freshness — the conservative legacy answer.
///
/// Free function rather than a closure so the test below can exercise the whole
/// decision, retirement early-exit included. Testing only `lane_is_retired`
/// would leave the wiring — the part that was actually missing — unpinned.
fn lane_requires_freshness(metrics: Option<&str>, lane: &str) -> bool {
    let Some(content) = metrics else {
        // If metrics are unavailable, keep legacy conservative behavior.
        return true;
    };
    // Retirement outranks every per-lane rule below.
    if lane_is_retired(content, lane) {
        return false;
    }
    match lane {
            "Lean" => content.contains("\"leanCompiled\": true"),
            "Isabelle" => content.contains("\"isabelleCompiled\": true"),
            "F*" => {
                !(content.contains("\"fstarStatus\": \"generated\"")
                    || content.contains("\"fstarStatus\": \"stub\""))
            }
            "TLA+" => {
                !(content.contains("\"tlaplusStatus\": \"generated\"")
                    || content.contains("\"tlaplusStatus\": \"stub\""))
            }
            "Alloy" => {
                !(content.contains("\"alloyStatus\": \"generated\"")
                    || content.contains("\"alloyStatus\": \"stub\""))
            }
            "SMT" => {
                !(content.contains("\"smtStatus\": \"generated\"")
                    || content.contains("\"smtStatus\": \"stub\""))
            }
            "Verus" => {
                !(content.contains("\"verusStatus\": \"generated\"")
                    || content.contains("\"verusStatus\": \"stub\""))
            }
            "Kani" => {
                !(content.contains("\"kaniStatus\": \"generated\"")
                    || content.contains("\"kaniStatus\": \"stub\""))
            }
            "TV" => {
                !(content.contains("\"tvStatus\": \"generated\"")
                    || content.contains("\"tvStatus\": \"stub\""))
            }
        _ => true,
    }
}

/// Check if transpiled prover files are stale relative to Coq source files.
/// Returns non-blocking warnings for each stale prover.
fn check_transpiler_staleness(repo: &Path, dirs: &ProverDirs<'_>) -> Vec<CheckResult> {
    let coq_newest = match newest_mtime(dirs.coq_dir, "v") {
        Some(t) => t,
        None => return vec![],
    };

    let metrics_content = fs::read_to_string(repo.join("website/public/metrics.json")).ok();
    let lane_requires_freshness =
        |lane: &str| -> bool { lane_requires_freshness(metrics_content.as_deref(), lane) };

    let provers: &[(&str, &Path, &str, &str)] = &[
        (
            "Lean",
            dirs.lean_dir,
            "lean",
            "python3 scripts/generate-multiprover.py",
        ),
        (
            "Isabelle",
            dirs.isabelle_dir,
            "thy",
            "python3 scripts/generate-multiprover.py",
        ),
        (
            "F*",
            dirs.fstar_dir,
            "fst",
            "python3 scripts/generate-full-stack.py",
        ),
        (
            "TLA+",
            dirs.tlaplus_dir,
            "tla",
            "python3 scripts/generate-full-stack.py",
        ),
        (
            "Alloy",
            dirs.alloy_dir,
            "als",
            "python3 scripts/generate-full-stack.py",
        ),
        (
            "SMT",
            dirs.smt_dir,
            "smt2",
            "python3 scripts/generate-full-stack.py",
        ),
        (
            "Verus",
            dirs.verus_dir,
            "rs",
            "python3 scripts/generate-full-stack.py",
        ),
        (
            "Kani",
            dirs.kani_dir,
            "rs",
            "python3 scripts/generate-full-stack.py",
        ),
        (
            "TV",
            dirs.tv_dir,
            "smt2",
            "python3 scripts/generate-full-stack.py",
        ),
    ];

    let mut results = vec![];
    let mut stale_names = vec![];
    let mut checked_lanes: Vec<&str> = vec![];
    let mut skipped_lanes: Vec<&str> = vec![];

    for (name, dir, ext, cmd) in provers {
        if !lane_requires_freshness(name) {
            skipped_lanes.push(*name);
            continue;
        }
        if !dir.is_dir() {
            continue;
        }
        checked_lanes.push(*name);
        if let Some(prover_newest) = newest_mtime(dir, ext) {
            if coq_newest > prover_newest {
                stale_names.push((*name, *cmd));
            }
        } else {
            // No files at all — also stale
            stale_names.push((*name, *cmd));
        }
    }

    if !stale_names.is_empty() {
        let names: Vec<&str> = stale_names.iter().map(|(n, _)| *n).collect();
        let hint = if stale_names.iter().any(|(_, c)| c.contains("multiprover")) {
            "run `python3 scripts/generate-multiprover.py` and/or `python3 scripts/generate-full-stack.py`"
        } else {
            "run `python3 scripts/generate-full-stack.py`"
        };
        results.push(CheckResult {
            name: "Transpiler Staleness".into(),
            passed: false,
            blocking: false,
            details: format!(
                "{} prover(s) may be stale: {} — {} (checked: {}; skipped generated/non-compiled: {})",
                stale_names.len(),
                names.join(", "),
                hint,
                checked_lanes.join(", "),
                skipped_lanes.join(", "),
            ),
        });
    } else {
        let details = if checked_lanes.is_empty() {
            "all transpiler lanes are generated/non-compiled per metrics; freshness check skipped"
                .to_string()
        } else if skipped_lanes.is_empty() {
            "all checked prover files up-to-date with Coq sources".to_string()
        } else {
            format!(
                "all checked prover files up-to-date with Coq sources (checked: {}; skipped generated/non-compiled: {})",
                checked_lanes.join(", "),
                skipped_lanes.join(", "),
            )
        };
        results.push(CheckResult {
            name: "Transpiler Staleness".into(),
            passed: true,
            blocking: false,
            details,
        });
    }

    results
}

// ---------------------------------------------------------------------------
// Word boundary helper
// ---------------------------------------------------------------------------

/// Check if `haystack` contains `word` as a whole word (not inside an identifier).
fn contains_word(haystack: &str, word: &str) -> bool {
    let bytes = haystack.as_bytes();
    let word_bytes = word.as_bytes();
    let wlen = word_bytes.len();

    if bytes.len() < wlen {
        return false;
    }

    for i in 0..=(bytes.len() - wlen) {
        if &bytes[i..i + wlen] == word_bytes {
            let before_ok = i == 0 || !bytes[i - 1].is_ascii_alphanumeric() && bytes[i - 1] != b'_';
            let after_ok = i + wlen >= bytes.len()
                || !bytes[i + wlen].is_ascii_alphanumeric() && bytes[i + wlen] != b'_';
            if before_ok && after_ok {
                return true;
            }
        }
    }
    false
}

// ---------------------------------------------------------------------------
// Repo root / git / manifest
// ---------------------------------------------------------------------------

/// Find repo root by walking up from cwd looking for `.git/`.
fn find_repo_root() -> Result<PathBuf, String> {
    let mut dir = std::env::current_dir().map_err(|e| format!("cwd: {e}"))?;
    loop {
        if dir.join(".git").exists() {
            return Ok(dir);
        }
        if !dir.pop() {
            return Err("could not find repo root (.git/)".into());
        }
    }
}

/// Get short git SHA.
fn git_sha(repo: &Path) -> String {
    Command::new("git")
        .args(["rev-parse", "--short", "HEAD"])
        .current_dir(repo)
        .output()
        .ok()
        .and_then(|o| String::from_utf8(o.stdout).ok())
        .map(|s| s.trim().to_string())
        .unwrap_or_else(|| "unknown".into())
}

/// How thorough a run is. A `full` run verifies strictly more than a `fast` one
/// (it adds the Coq and other proof lanes), so its manifest is stronger evidence.
fn mode_rank(mode: Mode) -> u8 {
    match mode {
        Mode::Fast => 0,
        Mode::Full => 1,
    }
}

/// What `write_manifest` should do with an existing manifest on disk.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum ManifestAction {
    Write,
    /// A weaker run must not replace a stronger record.
    SkipWeakerMode,
    /// Nothing about the verification changed — only the timestamp/SHA would.
    SkipUnchanged,
    /// The run could not actually verify (a toolchain is absent locally), so it
    /// must not replace a record of a run that could.
    SkipIncomplete,
}

/// The `Mode:` recorded in an existing manifest, if it is parseable.
fn parse_manifest_mode(existing: &str) -> Option<Mode> {
    existing.lines().find_map(|l| match l.trim() {
        "**Mode:** fast" => Some(Mode::Fast),
        "**Mode:** full" => Some(Mode::Full),
        _ => None,
    })
}

/// Replace the digits in `in <N>s` with `N`, e.g. "compiled in 176s" =>
/// "compiled in Ns".
///
/// Wall-clock build durations jitter by a few seconds on every run. They are a
/// measurement of the machine, not a verification finding, so leaving them in
/// the comparison would rewrite the manifest on literally every run — which is
/// half the churn this policy exists to stop. Written by hand rather than with
/// a regex crate: 03_PROTO carries zero third-party runtime dependencies
/// (Law 8).
fn normalize_durations(line: &str) -> String {
    let b = line.as_bytes();
    let mut out = String::with_capacity(line.len());
    let mut i = 0;
    while i < b.len() {
        // Look for " in " followed by digits followed by 's'.
        if b[i..].starts_with(b" in ") {
            let start = i + 4;
            let mut j = start;
            while j < b.len() && b[j].is_ascii_digit() {
                j += 1;
            }
            if j > start && j < b.len() && b[j] == b's' {
                out.push_str(" in Ns");
                i = j + 1;
                continue;
            }
        }
        out.push(b[i] as char);
        i += 1;
    }
    out
}

/// The manifest minus everything that changes without the verification changing.
///
/// `Generated:` and `Git SHA:` change on literally every run, and build
/// durations jitter, so none of them may count as "the manifest changed" —
/// otherwise every run rewrites the file. Everything else, including
/// `**Status:**` and every check's PASS/FAIL/WARN and details, IS compared.
fn manifest_body(text: &str) -> String {
    text.lines()
        .filter(|l| {
            let t = l.trim_start();
            !t.starts_with("**Generated:**") && !t.starts_with("**Git SHA:**")
        })
        .map(normalize_durations)
        .collect::<Vec<_>>()
        .join("\n")
}

/// Sentinel embedded in a BLOCKING failure's `details` when the cause is the
/// MACHINE — a toolchain this container lacks — rather than the repository.
///
/// A run carrying one is INCOMPLETE: it verified strictly less than its mode
/// claims, so it neither confirms nor refutes a stored record and must not
/// overwrite a complete one (REQ-76). The text is user-facing as well as a
/// marker, so it reads correctly in the manifest row it lands in.
pub const ENV_INCOMPLETE: &str = "environment incomplete";

/// Whether any BLOCKING check failed for an environmental reason.
fn run_is_incomplete(results: &[CheckResult]) -> bool {
    results
        .iter()
        .any(|r| r.blocking && !r.passed && r.details.contains(ENV_INCOMPLETE))
}

/// Whether the manifest already on disk records an incomplete run.
///
/// An incomplete run may replace another incomplete one — nothing stronger is
/// lost — but never a complete one.
fn manifest_is_incomplete(existing: &str) -> bool {
    existing
        .lines()
        .any(|l| l.trim_start().starts_with("**Incomplete:**"))
}

/// Decide whether a new manifest should replace the one already on disk.
///
/// This exists because the manifest used to be rewritten AND `git add`-ed on
/// every single run, which churned endlessly:
///
///   * `pre-commit` runs `verify --fast`, so it overwrote and re-staged a
///     fast-mode manifest on top of a full-mode one — a full-mode manifest
///     could therefore never be committed through the normal path, no matter
///     how it was staged; and
///   * `pre-push` runs `verify --full`, which rewrote the file again straight
///     after the push, leaving the tree dirty and inviting a "refresh the
///     manifest" chore commit that the next commit would immediately undo.
///
/// Two rules stop it without ever hiding evidence:
///   1. a FAILING run always writes — a failure is never suppressed;
///   2. otherwise a weaker run never replaces a stronger one, and an unchanged
///      verification never rewrites the file at all.
fn manifest_action(
    existing: Option<&str>,
    new_text: &str,
    new_mode: Mode,
    new_passed: bool,
    new_incomplete: bool,
) -> ManifestAction {
    let Some(existing) = existing else {
        return ManifestAction::Write;
    };
    // Rule 0: an INCOMPLETE run never replaces a complete record.
    //
    // A blocking failure whose only cause is an absent local toolchain is a
    // fact about the MACHINE, not the repository — it neither confirms nor
    // refutes what the stored record attests, so overwriting with it destroys
    // evidence and produces none. This fired twice on 2026-08-11: a `--fast`
    // run without `wasmtime` replaced full/PASS with fast/FAIL, erasing every
    // Coq attestation row, and a `--full` run without `coqc` replaced it with
    // full/FAIL whose sole failing row was the Coq presence check. Rule 1
    // below returns `Write` before any other rule is consulted, which is
    // exactly how an environment fact came to destroy a repo fact (REQ-76).
    //
    // Ordered FIRST, ahead of Rule 1, because the failure it describes is not
    // one this run established. Rule 1 keeps its full force for every failure
    // that is.
    if new_incomplete && !manifest_is_incomplete(existing) {
        return ManifestAction::SkipIncomplete;
    }
    // Rule 1: never suppress a failure the run actually established.
    if !new_passed {
        return ManifestAction::Write;
    }
    // Rule 2a: a fast PASS must not erase a full PASS.
    if let Some(old_mode) = parse_manifest_mode(existing) {
        if mode_rank(new_mode) < mode_rank(old_mode) {
            return ManifestAction::SkipWeakerMode;
        }
    }
    // Rule 2b: same findings => leave the file (and the index) alone.
    if manifest_body(existing) == manifest_body(new_text) {
        return ManifestAction::SkipUnchanged;
    }
    ManifestAction::Write
}

/// Write VERIFICATION_MANIFEST.md and auto-stage it — unless doing so would
/// weaken the recorded evidence or merely churn the timestamp.
fn write_manifest(repo: &Path, results: &[CheckResult], mode: Mode) {
    let sha = git_sha(repo);
    let now = SystemTime::now()
        .duration_since(SystemTime::UNIX_EPOCH)
        .map(|d| {
            let secs = d.as_secs();
            // Simple UTC timestamp without chrono
            format_timestamp(secs)
        })
        .unwrap_or_else(|_| "unknown".into());

    let all_pass = results.iter().all(|r| r.passed || !r.blocking);
    let status = if all_pass { "PASS" } else { "FAIL" };

    // Record the mode so a fast-mode PASS (Rust tests + clippy only) can never be
    // mistaken for a full proof-checked PASS. A `--fast` PASS makes no claim about
    // any proof lane.
    let (mode_label, scope_note) = match mode {
        Mode::Fast => (
            "fast",
            "Scope: Rust tests + clippy only. NOT a proof-checked verification \
             (no Coq/Lean/etc.). Run `verify --full` for proof lanes.",
        ),
        Mode::Full => (
            "full",
            "Scope: Rust + primary proof lane (Coq). Fails closed if the Coq \
             toolchain is absent.",
        ),
    };

    let mut md = String::new();
    writeln!(md, "# RIINA Verification Manifest").unwrap();
    writeln!(md, "**Generated:** {now}").unwrap();
    writeln!(md, "**Git SHA:** {sha}").unwrap();
    writeln!(md, "**Mode:** {mode_label}").unwrap();
    writeln!(md, "**Status:** {status}").unwrap();
    // An incomplete run that DOES get written (no prior record, or the prior
    // one was incomplete too) says so, so a reader never mistakes it for a
    // verification that actually ran (REQ-76).
    let incomplete = run_is_incomplete(results);
    if incomplete {
        let lanes: Vec<&str> = results
            .iter()
            .filter(|r| r.blocking && !r.passed && r.details.contains(ENV_INCOMPLETE))
            .map(|r| r.name.as_str())
            .collect();
        writeln!(
            md,
            "**Incomplete:** {} — a required toolchain is absent on this machine, \
             so these lanes did NOT run. This is not a verification of the \
             repository.",
            lanes.join(", ")
        )
        .unwrap();
    }
    writeln!(md).unwrap();
    writeln!(md, "> {scope_note}").unwrap();
    writeln!(md).unwrap();
    writeln!(md, "| Check | Status | Details |").unwrap();
    writeln!(md, "|-------|--------|---------|").unwrap();
    for r in results {
        let s = if r.passed {
            "PASS"
        } else if r.blocking {
            "FAIL"
        } else {
            "WARN"
        };
        writeln!(md, "| {} | {} | {} |", r.name, s, r.details).unwrap();
    }

    let manifest_path = repo.join("VERIFICATION_MANIFEST.md");
    let existing = fs::read_to_string(&manifest_path).ok();
    match manifest_action(existing.as_deref(), &md, mode, all_pass, incomplete) {
        ManifestAction::SkipWeakerMode => {
            eprintln!(
                "  manifest: kept the existing full-mode record (a {mode_label}-mode \
                 PASS would weaken it)"
            );
            return;
        }
        ManifestAction::SkipIncomplete => {
            eprintln!(
                "  manifest: kept the existing record — this run is INCOMPLETE (a \
                 required toolchain is absent here), so it cannot speak to what \
                 the stored record attests"
            );
            return;
        }
        ManifestAction::SkipUnchanged => return,
        ManifestAction::Write => {}
    }

    if let Err(e) = fs::write(&manifest_path, &md) {
        eprintln!("warning: could not write manifest: {e}");
        return;
    }

    // Auto-stage only when something was actually written, so a no-op run
    // leaves a clean index.
    let _ = Command::new("git")
        .args(["add", "VERIFICATION_MANIFEST.md"])
        .current_dir(repo)
        .status();
}

/// Format unix timestamp as ISO 8601 UTC (no external deps).
fn format_timestamp(secs: u64) -> String {
    // Days from epoch to year, simple calculation
    let days_total = secs / 86400;
    let time_of_day = secs % 86400;
    let hours = time_of_day / 3600;
    let minutes = (time_of_day % 3600) / 60;
    let seconds = time_of_day % 60;

    // Compute year/month/day from days since 1970-01-01
    let (year, month, day) = days_to_ymd(days_total);

    format!("{year:04}-{month:02}-{day:02}T{hours:02}:{minutes:02}:{seconds:02}Z")
}

fn days_to_ymd(mut days: u64) -> (u64, u64, u64) {
    let mut year = 1970u64;
    loop {
        let days_in_year = if is_leap(year) { 366 } else { 365 };
        if days < days_in_year {
            break;
        }
        days -= days_in_year;
        year += 1;
    }
    let month_days: &[u64] = if is_leap(year) {
        &[31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    } else {
        &[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    };
    let mut month = 1u64;
    for &md in month_days {
        if days < md {
            break;
        }
        days -= md;
        month += 1;
    }
    (year, month, days + 1)
}

fn is_leap(y: u64) -> bool {
    y.is_multiple_of(4) && (!y.is_multiple_of(100) || y.is_multiple_of(400))
}

// ---------------------------------------------------------------------------
// F* / TLA+ / Alloy / SMT / Verus / Kani / TV smoke builds + static scans
// ---------------------------------------------------------------------------

fn count_fstar_smoke_lemmas(active_file: &Path) -> u32 {
    fs::read_to_string(active_file)
        .ok()
        .map(|content| {
            content
                .lines()
                .filter(|line| {
                    let trimmed = line.trim();
                    trimmed.starts_with("let lemma_")
                        || trimmed.starts_with("let rec lemma_")
                        || (trimmed.starts_with("val ") && trimmed.contains("Lemma"))
                })
                .count() as u32
        })
        .unwrap_or(0)
}

/// Compile the manually maintained F* smoke module.
fn compile_fstar(fstar_dir: &Path) -> CheckResult {
    let active_file = fstar_dir
        .join("RIINA")
        .join("Active")
        .join("CryptographicSecurityActive.fst");
    if !active_file.exists() {
        return CheckResult {
            name: "F* Compilation".into(),
            passed: false,
            blocking: false,
            details: "active smoke file not found (expected RIINA/Active/CryptographicSecurityActive.fst)".into(),
        };
    }

    let repo_root = fstar_dir
        .parent()
        .and_then(|p| p.parent())
        .unwrap_or(fstar_dir);
    let cache_dir = repo_root.join(format!(
        ".fstar-active-verify-{}-{}",
        std::process::id(),
        SystemTime::now()
            .duration_since(SystemTime::UNIX_EPOCH)
            .unwrap_or_default()
            .as_millis()
    ));
    let _ = fs::create_dir_all(&cache_dir);

    let smoke_lemmas = count_fstar_smoke_lemmas(&active_file);
    let result = match detect_fstar() {
        ToolStatus::Found(fstar_path) => {
            eprintln!("  fstar found: {}", fstar_path.display());
            let args = [
                "--cache_checked_modules".to_string(),
                "--cache_dir".to_string(),
                cache_dir.to_string_lossy().into_owned(),
                "--include".to_string(),
                fstar_dir.to_string_lossy().into_owned(),
                active_file.to_string_lossy().into_owned(),
            ];
            let arg_refs: Vec<&str> = args.iter().map(String::as_str).collect();
            let start = Instant::now();
            match run_with_timeout(
                fstar_path.to_str().unwrap_or("fstar.exe"),
                &arg_refs,
                repo_root,
                FSTAR_TIMEOUT,
            ) {
                Ok(o) => {
                    let elapsed = start.elapsed();
                    if o.status.success() {
                        CheckResult {
                            name: "F* Compilation".into(),
                            passed: true,
                            blocking: false,
                            details: format!(
                                "Active module CryptographicSecurityActive compiled in {:.0}s ({} lemmas, local_active)",
                                elapsed.as_secs_f64(),
                                smoke_lemmas
                            ),
                        }
                    } else {
                        let code = o.status.code().unwrap_or(-1);
                        let stderr = String::from_utf8_lossy(&o.stderr);
                        let stdout = String::from_utf8_lossy(&o.stdout);
                        let combined = format!("{stdout}\n{stderr}");
                        let tail = last_n_lines(&combined, 10);
                        CheckResult {
                            name: "F* Compilation".into(),
                            passed: false,
                            blocking: false,
                            details: format!(
                                "FAILED (exit {code}, {:.0}s)\n{}",
                                elapsed.as_secs_f64(),
                                truncate_str(&tail, 500)
                            ),
                        }
                    }
                }
                Err(e) => CheckResult {
                    name: "F* Compilation".into(),
                    passed: false,
                    blocking: false,
                    details: format!("failed to run F* local_active: {e}"),
                },
            }
        }
        ToolStatus::NotFound(msg) => CheckResult {
            name: "F* Compilation".into(),
            passed: false,
            blocking: false,
            details: msg,
        },
    };

    let _ = fs::remove_dir_all(&cache_dir);
    result
}

/// Parse and bounded-model-check the manually maintained TLA+ smoke spec.
fn compile_tlaplus(tlaplus_dir: &Path) -> CheckResult {
    let active_dir = tlaplus_dir.join("RIINA").join("Active");
    let active_file = active_dir.join("TelusProcurementProtocol.tla");
    let cfg_file = active_dir.join("TelusProcurementProtocol.cfg");
    if !active_file.exists() || !cfg_file.exists() {
        return CheckResult {
            name: "TLA+ Compilation".into(),
            passed: false,
            blocking: false,
            details: "active smoke files not found (expected RIINA/Active/TelusProcurementProtocol.{tla,cfg})".into(),
        };
    }

    let smoke_theorems = count_tlaplus_smoke_theorems(&active_file);
    let java_path = match which_tool("java") {
        Some(path) => path,
        None => {
            return CheckResult {
                name: "TLA+ Compilation".into(),
                passed: false,
                blocking: false,
                details: "java not found (install a JRE/JDK to run tla2tools.jar)".into(),
            };
        }
    };

    match detect_tla2tools() {
        ToolStatus::Found(tla2tools_jar) => {
            eprintln!("  tla2tools jar found: {}", tla2tools_jar.display());
            let meta_dir = std::env::temp_dir().join(format!(
                "riina-tla-active-verify-{}-{}",
                std::process::id(),
                SystemTime::now()
                    .duration_since(SystemTime::UNIX_EPOCH)
                    .unwrap_or_default()
                    .as_millis()
            ));
            let _ = fs::create_dir_all(&meta_dir);

            let sany_args = [
                "-cp".to_string(),
                tla2tools_jar.to_string_lossy().into_owned(),
                "tla2sany.SANY".to_string(),
                active_file
                    .file_name()
                    .and_then(|s| s.to_str())
                    .unwrap_or("TelusProcurementProtocol.tla")
                    .to_string(),
            ];
            let sany_refs: Vec<&str> = sany_args.iter().map(String::as_str).collect();
            let start = Instant::now();
            match run_with_timeout(
                java_path.to_str().unwrap_or("java"),
                &sany_refs,
                &active_dir,
                TLAPLUS_TIMEOUT,
            ) {
                Ok(o) if o.status.success() => {
                    let tlc_args = vec![
                        "-cp".to_string(),
                        tla2tools_jar.to_string_lossy().into_owned(),
                        "tlc2.TLC".to_string(),
                        "-cleanup".to_string(),
                        "-workers".to_string(),
                        "1".to_string(),
                        "-metadir".to_string(),
                        meta_dir.to_string_lossy().into_owned(),
                        "-config".to_string(),
                        cfg_file
                            .file_name()
                            .and_then(|s| s.to_str())
                            .unwrap_or("TelusProcurementProtocol.cfg")
                            .to_string(),
                        active_file
                            .file_name()
                            .and_then(|s| s.to_str())
                            .unwrap_or("TelusProcurementProtocol.tla")
                            .to_string(),
                    ];
                    let tlc_refs: Vec<&str> = tlc_args.iter().map(String::as_str).collect();
                    match run_with_timeout(
                        java_path.to_str().unwrap_or("java"),
                        &tlc_refs,
                        &active_dir,
                        TLAPLUS_TIMEOUT,
                    ) {
                        Ok(tlc_output) => {
                            let elapsed = start.elapsed();
                            let result = if tlc_output.status.success() {
                                CheckResult {
                                    name: "TLA+ Compilation".into(),
                                    passed: true,
                                    blocking: false,
                                    details: format!(
                                        "Active spec TelusProcurementProtocol parsed and model checked in {:.0}s ({} theorems, local_active)",
                                        elapsed.as_secs_f64(),
                                        smoke_theorems
                                    ),
                                }
                            } else {
                                let code = tlc_output.status.code().unwrap_or(-1);
                                let stderr = String::from_utf8_lossy(&tlc_output.stderr);
                                let stdout = String::from_utf8_lossy(&tlc_output.stdout);
                                let combined = format!("{stdout}\n{stderr}");
                                let tail = last_n_lines(&combined, 10);
                                CheckResult {
                                    name: "TLA+ Compilation".into(),
                                    passed: false,
                                    blocking: false,
                                    details: format!(
                                        "FAILED TLC (exit {code}, {:.0}s)\n{}",
                                        elapsed.as_secs_f64(),
                                        truncate_str(&tail, 500)
                                    ),
                                }
                            };
                            let _ = fs::remove_dir_all(&meta_dir);
                            result
                        }
                        Err(e) => {
                            let _ = fs::remove_dir_all(&meta_dir);
                            CheckResult {
                                name: "TLA+ Compilation".into(),
                                passed: false,
                                blocking: false,
                                details: format!("failed to run TLA+ TLC local_active: {e}"),
                            }
                        }
                    }
                }
                Ok(o) => {
                    let elapsed = start.elapsed();
                    let stderr = String::from_utf8_lossy(&o.stderr);
                    let stdout = String::from_utf8_lossy(&o.stdout);
                    let combined = format!("{stdout}\n{stderr}");
                    let tail = last_n_lines(&combined, 10);
                    let result = CheckResult {
                        name: "TLA+ Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!(
                            "FAILED SANY (exit {}, {:.0}s)\n{}",
                            o.status.code().unwrap_or(-1),
                            elapsed.as_secs_f64(),
                            truncate_str(&tail, 500)
                        ),
                    };
                    let _ = fs::remove_dir_all(&meta_dir);
                    result
                }
                Err(e) => {
                    let _ = fs::remove_dir_all(&meta_dir);
                    CheckResult {
                        name: "TLA+ Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!("failed to run TLA+ SANY local_active: {e}"),
                    }
                }
            }
        }
        ToolStatus::NotFound(msg) => CheckResult {
            name: "TLA+ Compilation".into(),
            passed: false,
            blocking: false,
            details: msg,
        },
    }
}

/// Parse and execute the manually maintained Alloy smoke model.
fn compile_alloy(alloy_dir: &Path) -> CheckResult {
    let active_file = alloy_dir
        .join("RIINA")
        .join("Active")
        .join("TelusProcurementAccessControl.als");
    if !active_file.exists() {
        return CheckResult {
            name: "Alloy Compilation".into(),
            passed: false,
            blocking: false,
            details: "active smoke file not found (expected RIINA/Active/TelusProcurementAccessControl.als)".into(),
        };
    }

    let smoke_assertions = count_alloy_smoke_assertions(&active_file);
    let java_path = match which_tool("java") {
        Some(path) => path,
        None => {
            return CheckResult {
                name: "Alloy Compilation".into(),
                passed: false,
                blocking: false,
                details: "java not found (install a JRE/JDK to run Alloy)".into(),
            };
        }
    };

    match detect_alloy() {
        ToolStatus::Found(alloy_jar) => {
            eprintln!("  alloy jar found: {}", alloy_jar.display());
            let repo_root = alloy_dir
                .parent()
                .and_then(|p| p.parent())
                .unwrap_or(alloy_dir);
            let class = "org.alloytools.alloy.core.infra.Alloy";
            let commands_args = [
                "-cp".to_string(),
                alloy_jar.to_string_lossy().into_owned(),
                class.to_string(),
                "commands".to_string(),
                active_file.to_string_lossy().into_owned(),
            ];
            let command_refs: Vec<&str> = commands_args.iter().map(String::as_str).collect();
            let start = Instant::now();
            match run_with_timeout(
                java_path.to_str().unwrap_or("java"),
                &command_refs,
                repo_root,
                ALLOY_TIMEOUT,
            ) {
                Ok(o) if o.status.success() => {
                    let combined = format!(
                        "{}\n{}",
                        String::from_utf8_lossy(&o.stdout),
                        String::from_utf8_lossy(&o.stderr)
                    );
                    let command_rows = parse_alloy_command_rows(&combined);
                    if command_rows.is_empty() {
                        return CheckResult {
                            name: "Alloy Compilation".into(),
                            passed: false,
                            blocking: false,
                            details: "Alloy commands listing produced no executable commands"
                                .into(),
                        };
                    }

                    let mut saw_run = false;
                    let mut checked_assertions = 0u32;
                    for (idx, kind) in command_rows {
                        let exec_dir = std::env::temp_dir().join(format!(
                            "riina-alloy-active-verify-{}-{}-{}",
                            std::process::id(),
                            idx,
                            SystemTime::now()
                                .duration_since(SystemTime::UNIX_EPOCH)
                                .unwrap_or_default()
                                .as_millis()
                        ));
                        let _ = fs::create_dir_all(&exec_dir);
                        let idx_str = idx.to_string();
                        let exec_args = [
                            "-cp".to_string(),
                            alloy_jar.to_string_lossy().into_owned(),
                            class.to_string(),
                            "exec".to_string(),
                            "-c".to_string(),
                            idx_str,
                            active_file.to_string_lossy().into_owned(),
                        ];
                        let exec_refs: Vec<&str> = exec_args.iter().map(String::as_str).collect();
                        let exec_output = run_with_timeout(
                            java_path.to_str().unwrap_or("java"),
                            &exec_refs,
                            &exec_dir,
                            ALLOY_TIMEOUT,
                        );
                        let _ = fs::remove_dir_all(&exec_dir);
                        let exec_output = match exec_output {
                            Ok(output) => output,
                            Err(e) => {
                                return CheckResult {
                                    name: "Alloy Compilation".into(),
                                    passed: false,
                                    blocking: false,
                                    details: format!("failed to run Alloy command {idx}: {e}"),
                                }
                            }
                        };
                        if !exec_output.status.success() {
                            let code = exec_output.status.code().unwrap_or(-1);
                            let combined = format!(
                                "{}\n{}",
                                String::from_utf8_lossy(&exec_output.stdout),
                                String::from_utf8_lossy(&exec_output.stderr)
                            );
                            let tail = last_n_lines(&combined, 10);
                            return CheckResult {
                                name: "Alloy Compilation".into(),
                                passed: false,
                                blocking: false,
                                details: format!(
                                    "FAILED exec command {idx} (exit {code})\n{}",
                                    truncate_str(&tail, 500)
                                ),
                            };
                        }

                        let combined = format!(
                            "{}\n{}",
                            String::from_utf8_lossy(&exec_output.stdout),
                            String::from_utf8_lossy(&exec_output.stderr)
                        );
                        let status = parse_alloy_exec_status(&combined).unwrap_or_default();
                        let expected = match kind.as_str() {
                            "run" => {
                                saw_run = true;
                                "SAT"
                            }
                            "check" => {
                                checked_assertions += 1;
                                "UNSAT"
                            }
                            other => {
                                return CheckResult {
                                    name: "Alloy Compilation".into(),
                                    passed: false,
                                    blocking: false,
                                    details: format!(
                                        "unsupported Alloy command kind in smoke file: {other}"
                                    ),
                                }
                            }
                        };
                        if status != expected {
                            let tail = last_n_lines(&combined, 10);
                            return CheckResult {
                                name: "Alloy Compilation".into(),
                                passed: false,
                                blocking: false,
                                details: format!(
                                    "command {idx} expected {expected} but got {}\n{}",
                                    if status.is_empty() {
                                        "<missing>"
                                    } else {
                                        &status
                                    },
                                    truncate_str(&tail, 500)
                                ),
                            };
                        }
                    }

                    if !saw_run {
                        return CheckResult {
                            name: "Alloy Compilation".into(),
                            passed: false,
                            blocking: false,
                            details:
                                "Alloy smoke file must include at least one satisfiable run command"
                                    .into(),
                        };
                    }

                    CheckResult {
                        name: "Alloy Compilation".into(),
                        passed: true,
                        blocking: false,
                        details: format!(
                            "Active model TelusProcurementAccessControl executed in {:.0}s ({} checked assertions, local_active)",
                            start.elapsed().as_secs_f64(),
                            checked_assertions.max(smoke_assertions)
                        ),
                    }
                }
                Ok(o) => {
                    let combined = format!(
                        "{}\n{}",
                        String::from_utf8_lossy(&o.stdout),
                        String::from_utf8_lossy(&o.stderr)
                    );
                    let tail = last_n_lines(&combined, 10);
                    CheckResult {
                        name: "Alloy Compilation".into(),
                        passed: false,
                        blocking: false,
                        details: format!(
                            "FAILED commands listing (exit {})\n{}",
                            o.status.code().unwrap_or(-1),
                            truncate_str(&tail, 500)
                        ),
                    }
                }
                Err(e) => CheckResult {
                    name: "Alloy Compilation".into(),
                    passed: false,
                    blocking: false,
                    details: format!("failed to run Alloy commands local_active: {e}"),
                },
            }
        }
        ToolStatus::NotFound(msg) => CheckResult {
            name: "Alloy Compilation".into(),
            passed: false,
            blocking: false,
            details: msg,
        },
    }
}

/// Static scan of F* `.fst` files for `admit` keyword and lemma count.
fn scan_fstar(dir: &Path) -> Vec<CheckResult> {
    if !dir.is_dir() {
        return vec![CheckResult {
            name: "F* Scan".into(),
            passed: true,
            blocking: false,
            details: "directory not found (skipped)".into(),
        }];
    }

    let files = glob_fst_files(dir);
    let mut admit_count = 0u32;
    let mut lemma_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                let trimmed = line.trim();

                // Skip comments
                if trimmed.starts_with("//") || trimmed.starts_with("(*") {
                    continue;
                }

                // Count lemmas: val ..._lemma
                if trimmed.starts_with("val ") && trimmed.contains("_lemma") {
                    lemma_count += 1;
                }

                // Check for admit
                if contains_word(trimmed, "admit") {
                    admit_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "F* admit Scan".into(),
        passed: admit_count == 0,
        blocking: false, // F* files are generated stubs (claim level: "generated"), not mechanized
        details: format!(
            "{admit_count} admit in {} files ({lemma_count} lemmas)",
            files.len()
        ),
    }]
}

/// Static scan of TLA+ `.tla` files for theorem count.
fn scan_tlaplus(dir: &Path) -> Vec<CheckResult> {
    if !dir.is_dir() {
        return vec![CheckResult {
            name: "TLA+ Scan".into(),
            passed: true,
            blocking: false,
            details: "directory not found (skipped)".into(),
        }];
    }

    let files = glob_tla_files(dir);
    let mut theorem_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                if line.starts_with("THEOREM ") {
                    theorem_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "TLA+ Scan".into(),
        passed: true,
        blocking: !files.is_empty(),
        details: format!("{} files ({theorem_count} theorems)", files.len()),
    }]
}

/// Static scan of Alloy `.als` files for `check` command count.
fn scan_alloy(dir: &Path) -> Vec<CheckResult> {
    if !dir.is_dir() {
        return vec![CheckResult {
            name: "Alloy Scan".into(),
            passed: true,
            blocking: false,
            details: "directory not found (skipped)".into(),
        }];
    }

    let files = glob_als_files(dir);
    let mut assertion_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                let t = line.trim();
                if t.starts_with("check ") {
                    assertion_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "Alloy Scan".into(),
        passed: true,
        blocking: !files.is_empty(),
        details: format!("{} files ({assertion_count} assertions)", files.len()),
    }]
}

/// Static scan of SMT-LIB `.smt2` files for assertion count (excluding `.tv.smt2`).
fn scan_smt(dir: &Path) -> Vec<CheckResult> {
    if !dir.is_dir() {
        return vec![CheckResult {
            name: "SMT Scan".into(),
            passed: true,
            blocking: false,
            details: "directory not found (skipped)".into(),
        }];
    }

    let files = glob_smt_files(dir);
    let mut assertion_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                let t = line.trim();
                if t.contains("(assert ") {
                    assertion_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "SMT Scan".into(),
        passed: true,
        blocking: !files.is_empty(),
        details: format!("{} files ({assertion_count} assertions)", files.len()),
    }]
}

/// Static scan of Verus `.rs` files for proof fn count and `admit` keyword.
fn scan_verus(dir: &Path) -> Vec<CheckResult> {
    if !dir.is_dir() {
        return vec![CheckResult {
            name: "Verus Scan".into(),
            passed: true,
            blocking: false,
            details: "directory not found (skipped)".into(),
        }];
    }

    let files = glob_verus_files(dir);
    let mut proof_count = 0u32;
    let mut admit_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                let trimmed = line.trim();

                // Skip comments
                if trimmed.starts_with("//") {
                    continue;
                }

                if trimmed.contains("proof fn ") {
                    proof_count += 1;
                }

                if contains_word(trimmed, "admit") {
                    admit_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "Verus admit Scan".into(),
        passed: admit_count == 0,
        blocking: false, // Verus files are at "generated" claim level, not mechanized
        details: format!(
            "{admit_count} admit in {} files ({proof_count} proof fns)",
            files.len()
        ),
    }]
}

/// Static scan of Kani `.rs` files for `#[kani::proof]` harness count.
fn scan_kani(dir: &Path) -> Vec<CheckResult> {
    if !dir.is_dir() {
        return vec![CheckResult {
            name: "Kani Scan".into(),
            passed: true,
            blocking: false,
            details: "directory not found (skipped)".into(),
        }];
    }

    let files = glob_kani_files(dir);
    let mut harness_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                let trimmed = line.trim();
                if trimmed.contains("#[kani::proof]") {
                    harness_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "Kani Scan".into(),
        passed: true,
        blocking: !files.is_empty(),
        details: format!("{} files ({harness_count} harnesses)", files.len()),
    }]
}

/// Static scan of `.tv.smt2` (translation validation) files for validation count.
fn scan_tv(dir: &Path) -> Vec<CheckResult> {
    if !dir.is_dir() {
        return vec![CheckResult {
            name: "TV Scan".into(),
            passed: true,
            blocking: false,
            details: "directory not found (skipped)".into(),
        }];
    }

    let files = glob_tv_files(dir);
    let mut validation_count = 0u32;

    for path in &files {
        if let Ok(content) = fs::read_to_string(path) {
            for line in content.lines() {
                let t = line.trim();
                if t.contains("(assert ") {
                    validation_count += 1;
                }
            }
        }
    }

    vec![CheckResult {
        name: "TV Scan".into(),
        passed: true,
        blocking: !files.is_empty(),
        details: format!("{} files ({validation_count} validations)", files.len()),
    }]
}

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

/// In `--full` mode the Coq toolchain is mandatory: without it no proof is
/// machine-checked, so the gate must fail closed rather than report PASS on the
/// strength of static scans alone. Pure over its input so it can be unit-tested.
fn primary_verifier_result(status: ToolStatus) -> CheckResult {
    match status {
        ToolStatus::Found(p) => CheckResult {
            name: "Primary Verifier (Coq) Present".into(),
            passed: true,
            blocking: true,
            details: format!("Coq/Rocq prover available at {}", p.display()),
        },
        ToolStatus::NotFound(msg) => CheckResult {
            name: "Primary Verifier (Coq) Present".into(),
            passed: false,
            blocking: true,
            details: format!(
                "{msg}. `verify --full` cannot machine-check any proof without coqc, so it is \
                 failing closed instead of reporting PASS ({ENV_INCOMPLETE}). Install Rocq/Coq \
                 (see CLAUDE.md), or use `verify --fast` for the Rust-only gate."
            ),
        },
    }
}

/// Entry point for `riinac verify`.
pub fn run(mode: Mode) -> i32 {
    let repo = match find_repo_root() {
        Ok(r) => r,
        Err(e) => {
            eprintln!("error: {e}");
            return 1;
        }
    };

    eprintln!("RIINA verify ({:?} mode)", mode);
    eprintln!("Repo root: {}", repo.display());

    let proto_dir = repo.join("03_PROTO");
    let mut results = vec![];

    // Fast checks (always run)
    eprintln!("\n=== Rust Verification ===");
    eprintln!("Running cargo test...");
    results.push(run_cargo_test(&proto_dir));

    eprintln!("Running clippy...");
    results.push(run_clippy(&proto_dir));

    // Full checks
    if mode == Mode::Full {
        let coq_dir = repo.join("02_FORMAL").join("coq");
        let lean_dir = repo.join("02_FORMAL").join("lean");
        let isabelle_dir = repo.join("02_FORMAL").join("isabelle");
        let fstar_dir = repo.join("02_FORMAL").join("fstar");
        let tlaplus_dir = repo.join("02_FORMAL").join("tlaplus");
        let alloy_dir = repo.join("02_FORMAL").join("alloy");
        let smt_dir = repo.join("02_FORMAL").join("smt");
        let verus_dir = repo.join("02_FORMAL").join("verus");
        let kani_dir = repo.join("02_FORMAL").join("kani");
        let tv_dir = repo.join("02_FORMAL").join("tv");
        let prover_dirs = ProverDirs {
            coq_dir: &coq_dir,
            lean_dir: &lean_dir,
            isabelle_dir: &isabelle_dir,
            fstar_dir: &fstar_dir,
            tlaplus_dir: &tlaplus_dir,
            alloy_dir: &alloy_dir,
            smt_dir: &smt_dir,
            verus_dir: &verus_dir,
            kani_dir: &kani_dir,
            tv_dir: &tv_dir,
        };

        // === Coq ===
        eprintln!("\n=== Coq Verification ===");

        eprintln!("Checking _CoqProject completeness...");
        results.push(verify_coqproject_completeness(&coq_dir));

        eprintln!("Compiling Coq proofs...");
        results.push(compile_coq(&coq_dir));

        eprintln!("Attesting kernel-level assumptions (Print Assumptions)...");
        results.push(check_kernel_assumptions(&coq_dir));

        eprintln!("Scanning Coq proofs...");
        results.extend(scan_coq(&coq_dir));

        // === Lean 4 ===
        eprintln!("\n=== Lean 4 Verification ===");
        eprintln!("Compiling Lean proofs...");
        results.push(compile_lean(&lean_dir));

        eprintln!("Scanning Lean files...");
        results.extend(scan_lean(&lean_dir));

        // === Isabelle ===
        eprintln!("\n=== Isabelle Verification ===");
        eprintln!("Compiling Isabelle proofs...");
        results.push(compile_isabelle(&isabelle_dir));

        eprintln!("Scanning Isabelle files...");
        results.extend(scan_isabelle(&isabelle_dir));

        // === F* ===
        eprintln!("\n=== F* Verification ===");
        eprintln!("Compiling F* smoke proof...");
        results.push(compile_fstar(&fstar_dir));
        eprintln!("Scanning F* files...");
        results.extend(scan_fstar(&fstar_dir));

        // === TLA+ ===
        eprintln!("\n=== TLA+ Verification ===");
        eprintln!("Compiling TLA+ smoke proof...");
        results.push(compile_tlaplus(&tlaplus_dir));
        eprintln!("Scanning TLA+ files...");
        results.extend(scan_tlaplus(&tlaplus_dir));

        // === Alloy ===
        eprintln!("\n=== Alloy Verification ===");
        eprintln!("Compiling Alloy smoke model...");
        results.push(compile_alloy(&alloy_dir));
        eprintln!("Scanning Alloy files...");
        results.extend(scan_alloy(&alloy_dir));

        // === SMT ===
        eprintln!("\n=== SMT Verification ===");
        eprintln!("Scanning SMT files...");
        results.extend(scan_smt(&smt_dir));

        // === Verus ===
        eprintln!("\n=== Verus Verification ===");
        eprintln!("Scanning Verus files...");
        results.extend(scan_verus(&verus_dir));

        // === Kani ===
        eprintln!("\n=== Kani Verification ===");
        eprintln!("Scanning Kani files...");
        results.extend(scan_kani(&kani_dir));

        // === Translation Validation ===
        eprintln!("\n=== Translation Validation ===");
        eprintln!("Scanning TV files...");
        results.extend(scan_tv(&tv_dir));

        // === Cross-Prover ===
        eprintln!("\n=== Cross-Prover Validation (10 provers) ===");
        results.push(cross_validate_provers(&prover_dirs));

        // === Transpiler Staleness ===
        eprintln!("\n=== Transpiler Staleness Check ===");
        results.extend(check_transpiler_staleness(&repo, &prover_dirs));

        // === Metrics Accuracy ===
        eprintln!("\n=== Metrics Accuracy Check ===");
        results.push(verify_metrics_accuracy(
            &repo,
            &coq_dir,
            &lean_dir,
            &isabelle_dir,
        ));

        // === Fail-closed guard ===
        // A `--full` run that cannot execute its primary verifier (Coq) has not
        // verified anything — it must FAIL rather than silently report PASS, so a
        // missing toolchain can never be mistaken for "verified". Extended prover
        // lanes stay informational; only the primary lane is mandatory here.
        eprintln!("\n=== Fail-Closed Guard ===");
        results.push(primary_verifier_result(detect_coqc()));
    }

    // Report
    let all_pass = results.iter().all(|r| r.passed || !r.blocking);
    eprintln!();
    for r in &results {
        let icon = if r.passed {
            "OK"
        } else if r.blocking {
            "FAIL"
        } else {
            "WARN"
        };
        eprintln!("  [{icon}] {}: {}", r.name, r.details);
    }
    eprintln!();

    write_manifest(&repo, &results, mode);

    if all_pass {
        eprintln!("Verification: PASS");
        0
    } else {
        eprintln!("Verification: FAIL");
        1
    }
}

#[cfg(test)]
mod tests {
    use super::*;


    // =======================================================================
    // Manifest write policy — stops the auto-stage churn.
    //
    // The manifest used to be rewritten AND `git add`-ed on EVERY run, which
    // made two loops. (a) `pre-commit` runs `--fast`, so it re-staged a
    // fast-mode manifest over a full-mode one — a full-mode manifest could
    // never be committed through the normal path at all. (b) `pre-push` runs
    // `--full`, rewriting the file immediately after the push and leaving the
    // tree dirty, which is what produced the long run of "refresh the
    // verification manifest" chore commits.
    // =======================================================================

    fn manifest(mode: &str, rows: &str) -> String {
        format!(
            "# RIINA Verification Manifest\n\
             **Generated:** 2026-01-01T00:00:00Z\n\
             **Git SHA:** deadbeef\n\
             **Mode:** {mode}\n\
             **Status:** PASS\n\n\
             | Check | Status | Details |\n\
             |-------|--------|---------|\n{rows}"
        )
    }

    /// A manifest that records an INCOMPLETE run.
    fn incomplete_manifest(mode: &str, rows: &str) -> String {
        manifest(mode, rows).replace(
            "**Status:**",
            "**Incomplete:** Rust Tests — a required toolchain is absent.\n**Status:**",
        )
    }

    const ROWS_FAST: &str = "| Rust Tests | PASS | 10 tests |\n";
    const ROWS_FULL: &str =
        "| Rust Tests | PASS | 10 tests |\n| Coq Compilation | PASS | 328 .vo |\n";

    #[test]
    fn fast_run_never_overwrites_a_full_manifest() {
        // THE bug: pre-commit's `--fast` clobbering the pre-push `--full`
        // record, so the committed manifest always read `Mode: fast`.
        let existing = manifest("full", ROWS_FULL);
        let new = manifest("fast", ROWS_FAST);
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Fast, true, false),
            ManifestAction::SkipWeakerMode
        );
    }

    #[test]
    fn full_run_does_overwrite_a_fast_manifest() {
        // NEGATIVE CONTROL for the rule above: a policy that skipped every
        // write would satisfy "no churn" while never recording anything.
        let existing = manifest("fast", ROWS_FAST);
        let new = manifest("full", ROWS_FULL);
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Full, true, false),
            ManifestAction::Write
        );
    }

    #[test]
    fn identical_verification_does_not_rewrite_the_manifest() {
        // The post-push half of the churn: `--full` re-running at a new commit
        // with the same findings must not dirty the tree just to restamp the
        // timestamp and SHA.
        let existing = manifest("full", ROWS_FULL);
        let mut new = manifest("full", ROWS_FULL);
        new = new.replace("2026-01-01T00:00:00Z", "2026-06-01T12:00:00Z");
        new = new.replace("deadbeef", "cafef00d");
        assert_ne!(existing, new, "the fixtures must differ, or this proves nothing");
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Full, true, false),
            ManifestAction::SkipUnchanged
        );
    }

    #[test]
    fn changed_findings_do_rewrite_the_manifest() {
        // NEGATIVE CONTROL for the rule above: real changes must still land.
        let existing = manifest("full", ROWS_FULL);
        let new = manifest(
            "full",
            "| Rust Tests | PASS | 99 tests |\n| Coq Compilation | PASS | 328 .vo |\n",
        );
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Full, true, false),
            ManifestAction::Write
        );
    }

    #[test]
    fn a_failing_run_always_writes_even_when_weaker() {
        // A failure is evidence and must never be suppressed by the
        // mode-ranking rule — otherwise a fast run that FAILS would leave a
        // stale full-mode PASS on disk.
        let existing = manifest("full", ROWS_FULL);
        let new = manifest("fast", ROWS_FAST);
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Fast, false, false),
            ManifestAction::Write
        );
    }

    #[test]
    fn first_ever_run_writes() {
        let new = manifest("fast", ROWS_FAST);
        assert_eq!(
            manifest_action(None, &new, Mode::Fast, true, false),
            ManifestAction::Write
        );
    }


    // ── REQ-76: an environment fact must not destroy a repo fact ────────────

    #[test]
    fn incomplete_run_never_overwrites_a_complete_record() {
        // THE REQ-76 bug, both times it fired on 2026-08-11. A blocking
        // failure caused only by an absent local toolchain says nothing about
        // the repository, so it must not replace a record of a run that
        // actually verified — even though Rule 1 ("never suppress a failure")
        // would otherwise write it immediately.
        let existing = manifest("full", ROWS_FULL);
        let new = manifest("full", ROWS_FULL);
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Full, false, true),
            ManifestAction::SkipIncomplete
        );
        // ... and the `--fast`-without-wasmtime shape, which erased every Coq
        // attestation row.
        let new_fast = manifest("fast", ROWS_FAST);
        assert_eq!(
            manifest_action(Some(&existing), &new_fast, Mode::Fast, false, true),
            ManifestAction::SkipIncomplete
        );
    }

    #[test]
    fn a_real_failure_still_writes_over_a_complete_record() {
        // Rule 1 keeps its full force for a failure the run actually
        // established. Only an INCOMPLETE run is held back.
        let existing = manifest("full", ROWS_FULL);
        let new = manifest("full", ROWS_FULL);
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Full, false, false),
            ManifestAction::Write
        );
    }

    #[test]
    fn incomplete_run_may_replace_another_incomplete_record() {
        // Nothing stronger is lost, so an incomplete run is free to refresh an
        // equally incomplete one — otherwise a container that never has the
        // toolchain could never record anything at all.
        let existing = incomplete_manifest("full", ROWS_FULL);
        let new = manifest("full", ROWS_FAST);
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Full, false, true),
            ManifestAction::Write
        );
    }

    #[test]
    fn incomplete_run_writes_when_there_is_no_record_at_all() {
        let new = manifest("full", ROWS_FAST);
        assert_eq!(
            manifest_action(None, &new, Mode::Full, false, true),
            ManifestAction::Write
        );
    }

    #[test]
    fn environmental_failures_are_recognised_only_when_blocking_and_failed() {
        let env = |passed, blocking| CheckResult {
            name: "Rust Tests".into(),
            passed,
            blocking,
            details: format!("FAILED — tool absent ({ENV_INCOMPLETE})"),
        };
        assert!(run_is_incomplete(&[env(false, true)]));
        // A PASS is never incomplete, whatever its text says.
        assert!(!run_is_incomplete(&[env(true, true)]));
        // A non-blocking (informational) row never makes a run incomplete.
        assert!(!run_is_incomplete(&[env(false, false)]));
        // An ordinary failure is a REPO fact and must stay one.
        assert!(!run_is_incomplete(&[CheckResult {
            name: "Rust Tests".into(),
            passed: false,
            blocking: true,
            details: "FAILED (3200 tests parsed)".into(),
        }]));
    }

    #[test]
    fn stored_incompleteness_round_trips() {
        assert!(manifest_is_incomplete(&incomplete_manifest("full", ROWS_FULL)));
        assert!(!manifest_is_incomplete(&manifest("full", ROWS_FULL)));
    }

    #[test]
    fn coq_absent_in_full_mode_is_an_environment_fact() {
        // The `--full`-without-coqc shape: it must fail the RUN (fail closed)
        // but be classified as environmental so it cannot rewrite the record.
        let r = primary_verifier_result(ToolStatus::NotFound("coqc/rocq not found".into()));
        assert!(!r.passed && r.blocking, "must still fail closed");
        assert!(run_is_incomplete(std::slice::from_ref(&r)));
    }

    #[test]
    fn manifest_mode_round_trips_and_unparseable_is_none() {
        assert_eq!(parse_manifest_mode(&manifest("fast", ROWS_FAST)), Some(Mode::Fast));
        assert_eq!(parse_manifest_mode(&manifest("full", ROWS_FULL)), Some(Mode::Full));
        // An unreadable/legacy manifest must not be treated as `full` — that
        // would wedge the file permanently against every future write.
        assert_eq!(parse_manifest_mode("# nothing useful here"), None);
        assert_eq!(
            manifest_action(Some("# nothing useful here"), &manifest("fast", ROWS_FAST), Mode::Fast, true, false),
            ManifestAction::Write
        );
    }

    #[test]
    fn manifest_body_ignores_only_the_volatile_lines() {
        let a = manifest("full", ROWS_FULL);
        let b = a
            .replace("2026-01-01T00:00:00Z", "2099-12-31T23:59:59Z")
            .replace("deadbeef", "0badcafe");
        assert_eq!(manifest_body(&a), manifest_body(&b));
        // ...but the Status line is NOT volatile.
        let failed = a.replace("**Status:** PASS", "**Status:** FAIL");
        assert_ne!(manifest_body(&a), manifest_body(&failed));
    }


    #[test]
    fn build_duration_jitter_does_not_rewrite_the_manifest() {
        // The residual churn found by pushing: the Coq row embeds a wall-clock
        // duration, so "compiled in 180s" vs "176s" rewrote the file on every
        // single run even when every finding was identical.
        let rows_a = "| Coq Compilation | PASS | 328 .vo files compiled in 180s |\n";
        let rows_b = "| Coq Compilation | PASS | 328 .vo files compiled in 176s |\n";
        let existing = manifest("full", rows_a);
        let new = manifest("full", rows_b);
        assert_ne!(existing, new, "the fixtures must differ, or this proves nothing");
        assert_eq!(
            manifest_action(Some(&existing), &new, Mode::Full, true, false),
            ManifestAction::SkipUnchanged
        );
    }

    #[test]
    fn duration_normalisation_does_not_eat_real_numbers() {
        // NEGATIVE CONTROL: only `in <N>s` is normalised. A changed .vo COUNT
        // or test count must still register as a real change.
        let a = manifest("full", "| Coq Compilation | PASS | 328 .vo files compiled in 180s |\n");
        let b = manifest("full", "| Coq Compilation | PASS | 327 .vo files compiled in 180s |\n");
        assert_eq!(
            manifest_action(Some(&a), &b, Mode::Full, true, false),
            ManifestAction::Write,
            "a dropped .vo file must not be mistaken for timing jitter"
        );
        assert_eq!(normalize_durations("compiled in 176s"), "compiled in Ns");
        assert_eq!(normalize_durations("328 .vo files"), "328 .vo files");
        assert_eq!(normalize_durations("2947 tests"), "2947 tests");
        // No trailing 's' => not a duration.
        assert_eq!(normalize_durations("in 42 files"), "in 42 files");
    }


    // ── REQ-53: kernel-attestation parser ──────────────────────────────────

    #[test]
    fn print_assumptions_parser_counts_blocks_and_names() {
        let out = "Closed under the global context\nAxioms:\nFunctionalExtensionality.functional_extensionality_dep :\n  forall (A : Type), True\nClosed under the global context\n";
        let (blocks, axioms) = parse_print_assumptions(out);
        assert_eq!(blocks, 3);
        assert_eq!(
            axioms,
            vec!["FunctionalExtensionality.functional_extensionality_dep".to_string()]
        );
    }

    #[test]
    fn print_assumptions_parser_negative_controls() {
        // Empty output = ZERO blocks — the caller must treat that as failure,
        // never as "no axioms, pass". This is the vacuity guard.
        let (blocks, axioms) = parse_print_assumptions("");
        assert_eq!(blocks, 0);
        assert!(axioms.is_empty());
        // Indented type lines are NOT axiom names.
        let out = "Axioms:\nfoo.bar :\n  forall x, x = x\n  another indented line\n";
        let (b, a) = parse_print_assumptions(out);
        assert_eq!(b, 1);
        assert_eq!(a, vec!["foo.bar".to_string()]);
        // A NEW axiom is detected as outside the whitelist.
        assert!(!ALLOWED_KERNEL_AXIOMS.contains(&"evil.new_axiom"));
    }

    #[test]
    fn kernel_capstones_cover_the_load_bearing_theorems() {
        // The gate is only as strong as this list. Pin the current five so a
        // removal is a conscious edit here, not a silent narrowing.
        let names: Vec<&str> = KERNEL_CAPSTONES.iter().map(|(_, t)| *t).collect();
        for required in ["type_safety", "progress", "preservation", "well_typed_SN"] {
            assert!(names.contains(&required), "{required} missing from KERNEL_CAPSTONES");
        }
    }

    // -- Existing tests (unchanged) --

    #[test]
    fn test_parse_test_count_single() {
        let output = "test result: ok. 42 passed; 0 failed; 0 ignored;";
        assert_eq!(parse_test_count(output), 42);
    }

    #[test]
    fn test_parse_test_count_multiple() {
        let output = "\
test result: ok. 10 passed; 0 failed; 0 ignored;
test result: ok. 20 passed; 0 failed; 0 ignored;
test result: ok. 5 passed; 1 failed; 0 ignored;";
        assert_eq!(parse_test_count(output), 35);
    }

    #[test]
    fn test_parse_test_count_empty() {
        assert_eq!(parse_test_count("no test output here"), 0);
    }

    #[test]
    fn test_format_timestamp() {
        // 2024-01-01T00:00:00Z = 1704067200
        let ts = format_timestamp(1704067200);
        assert_eq!(ts, "2024-01-01T00:00:00Z");
    }

    #[test]
    fn test_days_to_ymd_epoch() {
        assert_eq!(days_to_ymd(0), (1970, 1, 1));
    }

    #[test]
    fn test_is_leap() {
        assert!(is_leap(2000));
        assert!(is_leap(2024));
        assert!(!is_leap(1900));
        assert!(!is_leap(2023));
    }

    #[test]
    fn test_primary_verifier_missing_fails_closed() {
        // When the Coq toolchain is absent, the guard must be a *blocking
        // failure* so `verify --full` cannot report PASS without it.
        let r = primary_verifier_result(ToolStatus::NotFound("coqc not found".into()));
        assert!(!r.passed, "missing coqc must not pass");
        assert!(r.blocking, "missing primary verifier must be blocking");
    }

    #[test]
    fn test_primary_verifier_present_passes() {
        let r = primary_verifier_result(ToolStatus::Found(PathBuf::from("/usr/bin/coqc")));
        assert!(r.passed, "present coqc must pass");
        assert!(r.blocking, "primary verifier check is always blocking");
    }

    // -- New tests --

    #[test]
    fn test_which_tool_nonexistent() {
        assert!(which_tool("__nonexistent_tool_xyz__").is_none());
    }

    #[test]
    fn test_last_n_lines() {
        assert_eq!(last_n_lines("a\nb\nc\nd\ne", 3), "c\nd\ne");
        assert_eq!(last_n_lines("a\nb", 5), "a\nb");
        assert_eq!(last_n_lines("single", 1), "single");
        assert_eq!(last_n_lines("", 3), "");
    }

    #[test]
    fn test_truncate_str() {
        assert_eq!(truncate_str("hello", 10), "hello");
        assert_eq!(truncate_str("hello world", 5), "hello...");
        assert_eq!(truncate_str("", 5), "");
    }

    #[test]
    fn test_contains_word() {
        assert!(contains_word("sorry", "sorry"));
        assert!(contains_word("x sorry y", "sorry"));
        assert!(!contains_word("not_sorry_here", "sorry"));
        assert!(!contains_word("sorrynotsorry", "sorry"));
        assert!(contains_word("(sorry)", "sorry"));
        assert!(contains_word("sorry.", "sorry"));
    }

    #[test]
    fn test_count_coq_qed() {
        // Run against the actual repo if available
        let coq_dir = PathBuf::from("/workspaces/proof/02_FORMAL/coq");
        if coq_dir.exists() {
            let count = count_coq_qed(&coq_dir);
            assert!(count > 1000, "Expected >1000 Qed, got {count}");
        }
    }

    #[test]
    fn test_count_lean_theorems() {
        let lean_dir = PathBuf::from("/workspaces/proof/02_FORMAL/lean");
        if lean_dir.exists() {
            let count = count_lean_theorems(&lean_dir);
            assert!(
                count > 3000,
                "Expected >3000 Lean theorems (domain+foundation), got {count}"
            );
        }
    }

    #[test]
    fn test_count_isabelle_lemmas() {
        let isa_dir = PathBuf::from("/workspaces/proof/02_FORMAL/isabelle/RIINA");
        if isa_dir.exists() {
            let count = count_isabelle_lemmas(&isa_dir);
            assert!(
                count > 3000,
                "Expected >3000 Isabelle lemmas (domain+foundation), got {count}"
            );
        }
    }

    #[test]
    fn test_detect_coqc() {
        // Should not panic regardless of whether coqc is installed
        let status = detect_coqc();
        match status {
            ToolStatus::Found(p) => assert!(p.exists()),
            ToolStatus::NotFound(msg) => assert!(!msg.is_empty()),
        }
    }

    #[test]
    fn test_glob_lean_files_excludes_lakefile_and_wip() {
        let lean_dir = PathBuf::from("/workspaces/proof/02_FORMAL/lean");
        if lean_dir.exists() {
            let files = glob_lean_files(&lean_dir);
            for f in &files {
                assert_ne!(
                    f.file_name().and_then(|n| n.to_str()),
                    Some("lakefile.lean"),
                    "lakefile.lean should be excluded"
                );
                assert!(
                    !f.components().any(|c| c.as_os_str() == "_wip"),
                    "_wip Lean files should be excluded"
                );
            }
            assert!(!files.is_empty(), "Should find at least one .lean file");
        }
    }

    #[test]
    fn test_glob_thy_files() {
        let isa_dir = PathBuf::from("/workspaces/proof/02_FORMAL/isabelle/RIINA");
        if isa_dir.exists() {
            let files = glob_thy_files(&isa_dir);
            assert!(
                files.len() >= 10,
                "Expected >=10 .thy files, got {}",
                files.len()
            );
        }
    }

    #[test]
    fn test_count_fstar_lemmas() {
        let dir = PathBuf::from("/workspaces/proof/02_FORMAL/fstar");
        if dir.exists() {
            let count = count_fstar_lemmas(&dir);
            assert!(count > 100, "Expected >100 F* lemmas, got {count}");
        }
    }

    #[test]
    fn test_count_tla_theorems() {
        let dir = PathBuf::from("/workspaces/proof/02_FORMAL/tlaplus");
        if dir.exists() {
            let count = count_tla_theorems(&dir);
            assert!(count > 100, "Expected >100 TLA+ theorems, got {count}");
        }
    }

    #[test]
    fn test_count_tlaplus_smoke_theorems() {
        let file = PathBuf::from(
            "/workspaces/proof/02_FORMAL/tlaplus/RIINA/Active/TelusProcurementProtocol.tla",
        );
        if file.exists() {
            let count = count_tlaplus_smoke_theorems(&file);
            assert!(count >= 1, "Expected >=1 TLA+ smoke theorem, got {count}");
        }
    }

    #[test]
    fn test_count_alloy_assertions() {
        let dir = PathBuf::from("/workspaces/proof/02_FORMAL/alloy");
        if dir.exists() {
            let count = count_alloy_assertions(&dir);
            assert!(count > 100, "Expected >100 Alloy assertions, got {count}");
        }
    }

    #[test]
    fn test_count_alloy_smoke_assertions() {
        let file = PathBuf::from(
            "/workspaces/proof/02_FORMAL/alloy/RIINA/Active/TelusProcurementAccessControl.als",
        );
        if file.exists() {
            let count = count_alloy_smoke_assertions(&file);
            assert!(
                count >= 1,
                "Expected >=1 Alloy smoke assertion, got {count}"
            );
        }
    }

    #[test]
    fn test_parse_alloy_command_rows() {
        let rows = parse_alloy_command_rows(
            "0 . Run ExampleTelusProcurement for 5\n1 . Check DerivedCapabilitiesCannotAmplify for 6\n",
        );
        assert_eq!(
            rows,
            vec![(0usize, "run".to_string()), (1usize, "check".to_string())]
        );
    }

    #[test]
    fn test_parse_alloy_exec_status() {
        let status = parse_alloy_exec_status(
            "00. check Broken                   0\u{0008}\u{0008}\u{0008}\u{0008}\u{0008}    1/1     SAT\n",
        );
        assert_eq!(status.as_deref(), Some("SAT"));
    }

    #[test]
    fn test_count_smt_assertions() {
        let dir = PathBuf::from("/workspaces/proof/02_FORMAL/smt");
        if dir.exists() {
            let count = count_smt_assertions(&dir);
            assert!(count > 100, "Expected >100 SMT assertions, got {count}");
        }
    }

    #[test]
    fn test_count_verus_proofs() {
        let dir = PathBuf::from("/workspaces/proof/02_FORMAL/verus");
        if dir.exists() {
            let count = count_verus_proofs(&dir);
            assert!(count > 100, "Expected >100 Verus proofs, got {count}");
        }
    }

    #[test]
    fn test_count_kani_proofs() {
        let dir = PathBuf::from("/workspaces/proof/02_FORMAL/kani");
        if dir.exists() {
            let count = count_kani_proofs(&dir);
            assert!(count > 100, "Expected >100 Kani proofs, got {count}");
        }
    }

    #[test]
    fn test_count_tv_validations() {
        let dir = PathBuf::from("/workspaces/proof/02_FORMAL/tv");
        if dir.exists() {
            let count = count_tv_validations(&dir);
            assert!(count > 100, "Expected >100 TV validations, got {count}");
        }
    }

    // =======================================================================
    // Transpiler-staleness gate semantics (owner-sign-off change, 2026-08-23).
    //
    // Both defects below were live and both change what `riinac verify --full`
    // ASSERTS, which is why they are pinned here rather than left to a manual
    // run: a session must not be able to weaken its own verification gate
    // without a test saying exactly how.
    // =======================================================================

    /// A RETIRED lane must not be required to keep pace with Coq.
    ///
    /// Before the fix this returned "freshness required" for F*: the per-lane
    /// arms enumerated only `generated` and `stub`, and `fstarStatus` is
    /// `"retired"` — which matches neither. Isabelle escaped by accident, via an
    /// unrelated `isabelleCompiled: false`.
    ///
    /// NEGATIVE CONTROL: delete the `if retired { return false; }` early exit in
    /// `check_transpiler_staleness` and the F* case here fails.
    #[test]
    fn retired_lanes_are_exempt_from_transpiler_freshness() {
        // Mirrors the shape of the real website/public/metrics.json.
        let metrics = r#"{
            "quality": { "leanCompiled": false, "isabelleCompiled": false,
                         "fstarStatus": "retired", "smtStatus": "mechanized",
                         "tlaplusStatus": "generated" },
            "claimLevels": { "lean": "generated", "isabelle": "retired",
                             "fstar": "retired", "smt": "mechanized",
                             "tlaplus": "generated" }
        }"#;

        // THE ASSERTION THAT CARRIES THE FIX: the whole decision, not just the
        // predicate. `fstarStatus` here is `"retired"` — under the old rule the
        // F* arm asked `!(generated || stub)`, which is TRUE for "retired", so
        // the lane was required to keep pace with a Coq tree it is no longer
        // built from.
        assert!(
            !lane_requires_freshness(Some(metrics), "F*"),
            "F* is retired by owner decision 2026-08-06 and must not be held to \
             freshness"
        );
        assert!(
            !lane_requires_freshness(Some(metrics), "Isabelle"),
            "Isabelle is retired too — it must be exempt BY RETIREMENT, not by the \
             accident of isabelleCompiled being false"
        );
        assert!(
            lane_requires_freshness(Some(metrics), "SMT"),
            "SMT is mechanized and must STILL be held to freshness — an exemption \
             that swallowed a live lane would be worse than the bug it replaced"
        );
        assert!(
            !lane_requires_freshness(Some(metrics), "TLA+"),
            "a merely `generated` lane is exempt by its OWN rule, unchanged here"
        );
        assert!(
            lane_requires_freshness(None, "F*"),
            "with no metrics to read, every lane stays conservative — the exemption \
             must never be the fallback"
        );

        assert!(!lane_is_retired(metrics, "Lean"), "Lean is `generated`, not retired");
        assert!(
            !lane_is_retired(metrics, "NoSuchLane"),
            "an unknown lane name must never be treated as retired"
        );

        // The REAL metrics file, not a fixture: the exemption is only worth
        // anything if it fires on what the repository actually publishes.
        let repo = Path::new(env!("CARGO_MANIFEST_DIR"))
            .ancestors()
            .nth(3)
            .expect("repo root");
        let live = fs::read_to_string(repo.join("website/public/metrics.json"))
            .expect("website/public/metrics.json must exist");
        assert!(
            !lane_requires_freshness(Some(&live), "F*"),
            "live metrics.json no longer exempts F* — if the owner un-retired it, \
             this exemption must be revisited, not silently kept"
        );
        assert!(
            lane_requires_freshness(Some(&live), "SMT"),
            "live metrics.json stopped requiring freshness of SMT, a mechanized lane"
        );
    }

    /// An ARCHIVED proof must not drive the freshness verdict.
    ///
    /// `newest_mtime` walked every subdirectory, so `_archive_deprecated/` — which
    /// held the newest `.v` in the tree, 14 days ahead of any active file — set
    /// the bar that every transpiled lane was measured against.
    ///
    /// NEGATIVE CONTROL: remove the `is_archived_dir` guard in `newest_mtime` and
    /// this fails, because the archived file is deliberately made the newest.
    #[test]
    fn archived_proofs_do_not_drive_freshness() {
        let dir = std::env::temp_dir().join(format!("riina_arch_{}", std::process::id()));
        let _ = fs::remove_dir_all(&dir);
        let active = dir.join("active");
        let archived = dir.join("_archive_deprecated");
        fs::create_dir_all(&active).unwrap();
        fs::create_dir_all(&archived).unwrap();

        fs::write(active.join("Live.v"), "(* active *)").unwrap();
        // Written second, so its mtime is newer than the active file's.
        std::thread::sleep(std::time::Duration::from_millis(20));
        fs::write(archived.join("Retired.v"), "(* archived *)").unwrap();

        let newest = newest_mtime(&dir, "v").expect("a .v file exists");
        let active_mt = fs::metadata(active.join("Live.v")).unwrap().modified().unwrap();
        let archived_mt = fs::metadata(archived.join("Retired.v")).unwrap().modified().unwrap();

        assert!(
            archived_mt > active_mt,
            "test setup is wrong: the archived file must be the newer one, or this \
             proves nothing"
        );
        assert_eq!(
            newest, active_mt,
            "the freshness scan picked up an archived proof. Every transpiled lane \
             would then be measured against a file that is retired on purpose."
        );

        assert!(is_archived_dir(&archived), "_archive_deprecated must be recognised");
        assert!(!is_archived_dir(&active), "an ordinary directory must not be");

        let _ = fs::remove_dir_all(&dir);
    }
}
