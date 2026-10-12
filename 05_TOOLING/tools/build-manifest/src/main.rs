// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Build Manifest Generator
//! ═══════════════════════════════════════════════════════════════════════════════
//! Track F Deliverable: TRACK_F-TOOL-BUILD_v1_0_0
//! ═══════════════════════════════════════════════════════════════════════════════
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS
//!
//! Generates comprehensive build manifests for reproducibility verification.
//! The manifest captures:
//! - All input files with SHA-256 hashes (riina-core's FIPS 180-4 SHA-256)
//! - Build environment configuration
//! - Tool versions
//! - Output artifacts with hashes
//! - Verification results
//!
//! `verify` recomputes every listed file's SHA-256 and size under the project
//! root and exits NON-ZERO on any mismatch, missing file, malformed entry, or
//! an empty manifest. (Until 2026-10 the "sha256" fields were a 64-bit
//! `DefaultHasher` value printed four times and `verify` was a stub that always
//! reported success.)
//!
//! What `verify` does NOT establish: who produced the manifest. It is an
//! unauthenticated list of hashes; sign it (`riina-artifact-sign
//! sign-manifest`) and verify the signature to get authenticity.

#![forbid(unsafe_code)]
#![allow(
    clippy::all,
    clippy::pedantic,
    clippy::nursery,
    clippy::unwrap_used,
    clippy::expect_used,
    clippy::panic,
    unused_variables,
    dead_code
)]
// Lints configured at workspace level in Cargo.toml

use std::collections::BTreeMap;
use std::env;
use std::fs::{self, File};
use std::io::{self, BufReader, Read};
use std::path::{Component, Path, PathBuf};
use std::process::{Command, ExitCode};
use std::time::{SystemTime, UNIX_EPOCH};

use clap::{Parser, Subcommand};
use riina_core::crypto::sha2::Sha256;
use serde_json::{json, Value};

// ═══════════════════════════════════════════════════════════════════════════════
// CLI DEFINITION
// ═══════════════════════════════════════════════════════════════════════════════

#[derive(Parser)]
#[command(name = "riina-build-manifest")]
#[command(version = "1.0.0")]
#[command(about = "RIINA Build Manifest Generator - Reproducibility Tracking")]
struct Cli {
    #[command(subcommand)]
    command: Commands,

    /// Verbose output
    #[arg(short, long, global = true)]
    verbose: bool,

    /// Project root
    #[arg(long, global = true)]
    root: Option<PathBuf>,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate a new manifest
    Generate {
        /// Output file
        #[arg(short, long, default_value = "build-manifest.json")]
        output: PathBuf,

        /// Build profile (debug/release)
        #[arg(short, long, default_value = "release")]
        profile: String,

        /// Include source hashes
        #[arg(long)]
        include_sources: bool,
    },

    /// Verify the project tree against an existing manifest (exits non-zero
    /// on any mismatch, missing file, or malformed/empty manifest)
    Verify {
        /// Manifest file to verify against
        manifest: PathBuf,

        /// Strict mode: tool-version differences are failures, not warnings
        #[arg(long)]
        strict: bool,
    },

    /// Show manifest contents
    Show {
        /// Manifest file to display
        manifest: PathBuf,

        /// Output format (json/text)
        #[arg(short, long, default_value = "text")]
        format: String,
    },

    /// Compare two manifests (exits non-zero if they differ)
    Diff {
        /// First manifest
        manifest1: PathBuf,

        /// Second manifest
        manifest2: PathBuf,
    },
}

// ═══════════════════════════════════════════════════════════════════════════════
// MANIFEST STRUCTURE
// ═══════════════════════════════════════════════════════════════════════════════

/// Complete build manifest
#[derive(Debug, Clone)]
struct BuildManifest {
    /// Manifest format version
    version: String,
    /// Generation timestamp
    timestamp: u64,
    /// Build profile
    profile: String,
    /// Project root
    project_root: String,
    /// Environment variables
    environment: BTreeMap<String, String>,
    /// Tool versions
    tools: BTreeMap<String, String>,
    /// Input files with hashes
    inputs: Vec<FileEntry>,
    /// Output artifacts with hashes
    outputs: Vec<FileEntry>,
    /// Verification results
    verification: VerificationResults,
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct FileEntry {
    path: String,
    sha256: String,
    size: u64,
}

#[derive(Debug, Clone, Default)]
struct VerificationResults {
    level: u8,
    tests_passed: bool,
    coverage: Option<f64>,
    formal_verified: bool,
}

impl FileEntry {
    fn to_json(&self) -> Value {
        json!({ "path": self.path, "sha256": self.sha256, "size": self.size })
    }
}

impl BuildManifest {
    /// Serialise with a real JSON encoder — paths and environment values are
    /// escaped, so a file name containing `"` cannot corrupt the manifest.
    fn to_json(&self) -> String {
        let mut verification = json!({
            "level": self.verification.level,
            "tests_passed": self.verification.tests_passed,
            "formal_verified": self.verification.formal_verified,
        });
        if let Some(cov) = self.verification.coverage {
            verification["coverage"] = json!(cov);
        }
        let doc = json!({
            "version": self.version,
            "timestamp": self.timestamp,
            "profile": self.profile,
            "project_root": self.project_root,
            "environment": self.environment,
            "tools": self.tools,
            "inputs": self.inputs.iter().map(FileEntry::to_json).collect::<Vec<_>>(),
            "outputs": self.outputs.iter().map(FileEntry::to_json).collect::<Vec<_>>(),
            "verification": verification,
        });
        let mut out = serde_json::to_string_pretty(&doc).unwrap_or_default();
        out.push('\n');
        out
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HASHING
// ═══════════════════════════════════════════════════════════════════════════════

/// Compute the SHA-256 of a file (lowercase hex), streaming, with riina-core's
/// FIPS 180-4 implementation.
fn hash_file(path: &Path) -> io::Result<String> {
    let file = File::open(path)?;
    let mut reader = BufReader::new(file);
    let mut hasher = Sha256::new();
    let mut buf = [0u8; 8192];
    loop {
        let n = reader.read(&mut buf)?;
        if n == 0 {
            break;
        }
        hasher.update(&buf[..n]);
    }
    Ok(hex(&hasher.finalize()))
}

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

/// Get file size
fn file_size(path: &Path) -> io::Result<u64> {
    Ok(fs::metadata(path)?.len())
}

// ═══════════════════════════════════════════════════════════════════════════════
// TOOL VERSION DETECTION
// ═══════════════════════════════════════════════════════════════════════════════

fn get_tool_version(tool: &str, args: &[&str]) -> Option<String> {
    Command::new(tool)
        .args(args)
        .output()
        .ok()
        .and_then(|output| {
            String::from_utf8(output.stdout)
                .ok()
                .map(|s| s.lines().next().unwrap_or("").to_string())
        })
}

fn collect_tool_versions() -> BTreeMap<String, String> {
    let mut tools = BTreeMap::new();

    if let Some(v) = get_tool_version("rustc", &["--version"]) {
        tools.insert("rustc".to_string(), v);
    }

    if let Some(v) = get_tool_version("cargo", &["--version"]) {
        tools.insert("cargo".to_string(), v);
    }

    if let Some(v) = get_tool_version("clang", &["--version"]) {
        let first_line = v.lines().next().unwrap_or(&v).to_string();
        tools.insert("clang".to_string(), first_line);
    }

    if let Some(v) = get_tool_version("gnatprove", &["--version"]) {
        tools.insert("gnatprove".to_string(), v);
    }

    tools
}

// ═══════════════════════════════════════════════════════════════════════════════
// MANIFEST GENERATION
// ═══════════════════════════════════════════════════════════════════════════════

fn generate_manifest(
    root: &Path,
    profile: &str,
    include_sources: bool,
    verbose: bool,
) -> io::Result<BuildManifest> {
    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_secs())
        .unwrap_or(0);

    // Collect environment
    let mut environment = BTreeMap::new();
    environment.insert("SOURCE_DATE_EPOCH".to_string(), "0".to_string());
    environment.insert("CARGO_INCREMENTAL".to_string(), "0".to_string());
    if let Ok(flags) = env::var("RUSTFLAGS") {
        environment.insert("RUSTFLAGS".to_string(), flags);
    }

    // Collect tool versions
    let tools = collect_tool_versions();

    // Collect inputs (Cargo.toml, Cargo.lock, key source files)
    let mut inputs = Vec::new();

    for name in ["Cargo.toml", "Cargo.lock", "rust-toolchain.toml"] {
        let path = root.join(name);
        if path.exists() {
            if verbose {
                println!("Hashing: {}", path.display());
            }
            inputs.push(FileEntry {
                path: name.to_string(),
                sha256: hash_file(&path)?,
                size: file_size(&path)?,
            });
        }
    }

    // Optionally hash source files
    if include_sources {
        let src_dirs = ["crates", "tools"];
        for dir in src_dirs {
            let src_path = root.join(dir);
            if src_path.exists() {
                hash_directory(&src_path, root, &mut inputs, verbose)?;
            }
        }
    }

    // Collect outputs (binaries)
    let mut outputs = Vec::new();
    let target_dir = root.join("target").join(profile);

    if target_dir.exists() {
        let binaries = ["riinac", "riina-build", "riina-verify", "riina-hash-chain"];
        for binary in binaries {
            let bin_path = target_dir.join(binary);
            if bin_path.exists() {
                if verbose {
                    println!("Hashing output: {}", bin_path.display());
                }
                outputs.push(FileEntry {
                    path: format!("target/{profile}/{binary}"),
                    sha256: hash_file(&bin_path)?,
                    size: file_size(&bin_path)?,
                });
            }
        }
    }

    Ok(BuildManifest {
        version: "1.0.0".to_string(),
        timestamp,
        profile: profile.to_string(),
        project_root: root.display().to_string(),
        environment,
        tools,
        inputs,
        outputs,
        verification: VerificationResults::default(),
    })
}

fn hash_directory(
    dir: &Path,
    root: &Path,
    entries: &mut Vec<FileEntry>,
    verbose: bool,
) -> io::Result<()> {
    let mut children: Vec<PathBuf> = fs::read_dir(dir)?
        .map(|e| e.map(|e| e.path()))
        .collect::<io::Result<_>>()?;
    // Deterministic order, so two manifests of the same tree compare equal.
    children.sort();
    for path in children {
        if path.is_dir() {
            // Skip target directories
            if path.file_name().is_some_and(|n| n == "target") {
                continue;
            }
            hash_directory(&path, root, entries, verbose)?;
        } else if path
            .extension()
            .is_some_and(|ext| ext == "rs" || ext == "toml")
        {
            let relative = path
                .strip_prefix(root)
                .map(|p| p.display().to_string())
                .unwrap_or_else(|_| path.display().to_string());

            if verbose {
                println!("Hashing: {relative}");
            }

            entries.push(FileEntry {
                path: relative,
                sha256: hash_file(&path)?,
                size: file_size(&path)?,
            });
        }
    }
    Ok(())
}

// ═══════════════════════════════════════════════════════════════════════════════
// MANIFEST PARSING
// ═══════════════════════════════════════════════════════════════════════════════

/// The parts of a manifest that `verify`/`diff` check.
#[derive(Debug, Default)]
struct ParsedManifest {
    tools: BTreeMap<String, String>,
    inputs: Vec<FileEntry>,
    outputs: Vec<FileEntry>,
}

fn invalid(msg: impl Into<String>) -> io::Error {
    io::Error::new(io::ErrorKind::InvalidData, msg.into())
}

fn is_sha256_hex(s: &str) -> bool {
    s.len() == 64 && s.bytes().all(|b| b.is_ascii_digit() || (b'a'..=b'f').contains(&b))
}

/// A manifest path must stay inside the project root: relative, and with no
/// `..`/root/prefix components. A manifest is untrusted input to `verify`.
fn safe_relative(path: &str) -> bool {
    !path.is_empty()
        && Path::new(path)
            .components()
            .all(|c| matches!(c, Component::Normal(_) | Component::CurDir))
}

fn parse_entries(doc: &Value, key: &str) -> io::Result<Vec<FileEntry>> {
    let arr = doc
        .get(key)
        .and_then(Value::as_array)
        .ok_or_else(|| invalid(format!("manifest has no \"{key}\" array")))?;
    let mut out = Vec::with_capacity(arr.len());
    for (i, e) in arr.iter().enumerate() {
        let path = e
            .get("path")
            .and_then(Value::as_str)
            .ok_or_else(|| invalid(format!("{key}[{i}]: missing \"path\"")))?;
        let sha256 = e
            .get("sha256")
            .and_then(Value::as_str)
            .ok_or_else(|| invalid(format!("{key}[{i}]: missing \"sha256\"")))?;
        let size = e
            .get("size")
            .and_then(Value::as_u64)
            .ok_or_else(|| invalid(format!("{key}[{i}]: missing \"size\"")))?;
        out.push(FileEntry {
            path: path.to_string(),
            sha256: sha256.to_string(),
            size,
        });
    }
    Ok(out)
}

fn parse_manifest(contents: &str) -> io::Result<ParsedManifest> {
    let doc: Value = serde_json::from_str(contents)
        .map_err(|e| invalid(format!("manifest is not valid JSON: {e}")))?;
    if doc.get("version").and_then(Value::as_str).is_none() {
        return Err(invalid("manifest has no \"version\""));
    }
    let tools = doc
        .get("tools")
        .and_then(Value::as_object)
        .map(|m| {
            m.iter()
                .filter_map(|(k, v)| v.as_str().map(|v| (k.clone(), v.to_string())))
                .collect()
        })
        .unwrap_or_default();
    Ok(ParsedManifest {
        tools,
        inputs: parse_entries(&doc, "inputs")?,
        outputs: parse_entries(&doc, "outputs")?,
    })
}

fn load_manifest(path: &Path) -> io::Result<ParsedManifest> {
    parse_manifest(&fs::read_to_string(path)?)
}

// ═══════════════════════════════════════════════════════════════════════════════
// MANIFEST OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════

/// Recompute every listed file under `root` and compare. Returns the list of
/// failures (empty = verified). Fails closed: a missing/unreadable file, a
/// malformed hash, an unsafe path, or an EMPTY manifest is a failure.
fn check_manifest(root: &Path, manifest: &ParsedManifest, strict: bool) -> Vec<String> {
    let mut failures = Vec::new();
    if manifest.inputs.is_empty() && manifest.outputs.is_empty() {
        failures.push("manifest lists no files — nothing would be verified".to_string());
        return failures;
    }
    for entry in manifest.inputs.iter().chain(&manifest.outputs) {
        if !safe_relative(&entry.path) {
            failures.push(format!("{}: unsafe path (must be relative, no '..')", entry.path));
            continue;
        }
        if !is_sha256_hex(&entry.sha256) {
            failures.push(format!("{}: malformed sha256 {:?}", entry.path, entry.sha256));
            continue;
        }
        let path = root.join(&entry.path);
        match (hash_file(&path), file_size(&path)) {
            (Ok(actual), Ok(size)) => {
                if actual != entry.sha256 {
                    failures.push(format!(
                        "{}: SHA-256 mismatch (manifest {}, actual {actual})",
                        entry.path, entry.sha256
                    ));
                } else if size != entry.size {
                    failures.push(format!(
                        "{}: size mismatch (manifest {}, actual {size})",
                        entry.path, entry.size
                    ));
                }
            }
            (Err(e), _) | (_, Err(e)) => {
                failures.push(format!("{}: missing or unreadable ({e})", entry.path));
            }
        }
    }
    let current = collect_tool_versions();
    for (tool, version) in &manifest.tools {
        let now = current.get(tool).map(String::as_str).unwrap_or("<absent>");
        if now != version {
            let msg = format!("tool {tool}: manifest {version:?}, current {now:?}");
            if strict {
                failures.push(msg);
            } else {
                println!("  warning: {msg}");
            }
        }
    }
    failures
}

fn verify_manifest(
    root: &Path,
    manifest_path: &Path,
    strict: bool,
    verbose: bool,
) -> io::Result<bool> {
    println!("Verifying against manifest: {}", manifest_path.display());
    println!("Project root: {}", root.display());
    let manifest = load_manifest(manifest_path)?;
    let failures = check_manifest(root, &manifest, strict);
    let total = manifest.inputs.len() + manifest.outputs.len();
    if failures.is_empty() {
        println!("  {total} file(s) match (SHA-256 + size)");
        println!("  NOTE: integrity only — the manifest itself is unauthenticated;");
        println!("        verify its signature with `riina-artifact-sign verify-manifest`.");
        Ok(true)
    } else {
        for f in &failures {
            println!("  ✗ {f}");
        }
        println!("  {} failure(s) across {total} listed file(s)", failures.len());
        Ok(false)
    }
}

fn show_manifest(manifest_path: &Path, format: &str) -> io::Result<()> {
    let contents = fs::read_to_string(manifest_path)?;

    match format {
        "json" => {
            println!("{contents}");
        }
        _ => {
            // Text format
            println!("═══════════════════════════════════════════════════════════════");
            println!("                    BUILD MANIFEST");
            println!("═══════════════════════════════════════════════════════════════");
            println!();
            println!("{contents}");
        }
    }

    Ok(())
}

/// Differences between two manifests' file lists and tool versions.
fn manifest_differences(a: &ParsedManifest, b: &ParsedManifest) -> Vec<String> {
    let index = |m: &ParsedManifest| -> BTreeMap<String, FileEntry> {
        m.inputs
            .iter()
            .chain(&m.outputs)
            .map(|e| (e.path.clone(), e.clone()))
            .collect()
    };
    let (ia, ib) = (index(a), index(b));
    let mut diffs = Vec::new();
    for (path, ea) in &ia {
        match ib.get(path) {
            None => diffs.push(format!("- {path} (only in manifest 1)")),
            Some(eb) if eb != ea => diffs.push(format!(
                "~ {path}: {} ({} B) -> {} ({} B)",
                ea.sha256, ea.size, eb.sha256, eb.size
            )),
            Some(_) => {}
        }
    }
    for path in ib.keys().filter(|p| !ia.contains_key(*p)) {
        diffs.push(format!("+ {path} (only in manifest 2)"));
    }
    if a.tools != b.tools {
        diffs.push(format!("~ tools: {:?} -> {:?}", a.tools, b.tools));
    }
    diffs
}

fn diff_manifests(manifest1: &Path, manifest2: &Path) -> io::Result<bool> {
    println!("Comparing manifests:");
    println!("  1: {}", manifest1.display());
    println!("  2: {}", manifest2.display());
    println!();
    let diffs = manifest_differences(&load_manifest(manifest1)?, &load_manifest(manifest2)?);
    if diffs.is_empty() {
        println!("Manifests are identical (files, hashes, sizes, tools).");
        Ok(true)
    } else {
        for d in &diffs {
            println!("{d}");
        }
        Ok(false)
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN
// ═══════════════════════════════════════════════════════════════════════════════

fn main() -> ExitCode {
    let cli = Cli::parse();

    println!("═══════════════════════════════════════════════════════════════");
    println!("        RIINA BUILD MANIFEST GENERATOR v1.0.0");
    println!("  Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST");
    println!("═══════════════════════════════════════════════════════════════");
    println!();

    let root = cli
        .root
        .clone()
        .or_else(|| env::var("RIINA_ROOT").ok().map(PathBuf::from))
        .unwrap_or_else(|| env::current_dir().unwrap_or_else(|_| PathBuf::from(".")));

    let result = match &cli.command {
        Commands::Generate {
            output,
            profile,
            include_sources,
        } => match generate_manifest(&root, profile, *include_sources, cli.verbose) {
            Ok(manifest) => {
                let output_path = root.join(output);
                match fs::write(&output_path, manifest.to_json()) {
                    Ok(()) => {
                        println!("✓ Manifest written to {}", output_path.display());
                        println!();
                        println!("Inputs:  {} files", manifest.inputs.len());
                        println!("Outputs: {} files", manifest.outputs.len());
                        println!("Tools:   {} detected", manifest.tools.len());
                        Ok(true)
                    }
                    Err(e) => Err(e),
                }
            }
            Err(e) => Err(e),
        },
        Commands::Verify { manifest, strict } => {
            verify_manifest(&root, manifest, *strict, cli.verbose).map(|passed| {
                if passed {
                    println!("✓ Verification passed");
                } else {
                    println!("✗ Verification FAILED");
                }
                passed
            })
        }
        Commands::Show { manifest, format } => show_manifest(manifest, format).map(|()| true),
        Commands::Diff {
            manifest1,
            manifest2,
        } => diff_manifests(manifest1, manifest2),
    };

    match result {
        Ok(true) => ExitCode::SUCCESS,
        Ok(false) => ExitCode::FAILURE,
        Err(e) => {
            eprintln!("[ERROR] {e}");
            ExitCode::FAILURE
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// A fresh, empty scratch directory under the system temp dir.
    fn scratch(tag: &str) -> PathBuf {
        let dir = env::temp_dir().join(format!(
            "riina-build-manifest-{tag}-{}-{}",
            std::process::id(),
            SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_nanos()
        ));
        fs::create_dir_all(&dir).unwrap();
        dir
    }

    fn project(tag: &str) -> PathBuf {
        let root = scratch(tag);
        fs::write(root.join("Cargo.toml"), "[package]\nname = \"x\"\n").unwrap();
        fs::write(root.join("Cargo.lock"), "# lock\n").unwrap();
        fs::create_dir_all(root.join("crates/a/src")).unwrap();
        fs::write(root.join("crates/a/src/lib.rs"), "pub fn f() {}\n").unwrap();
        root
    }

    fn manifest_for(root: &Path) -> ParsedManifest {
        let m = generate_manifest(root, "release", true, false).unwrap();
        parse_manifest(&m.to_json()).unwrap()
    }

    #[test]
    fn hash_file_is_real_sha256() {
        let root = scratch("kat");
        let p = root.join("abc");
        fs::write(&p, "abc").unwrap();
        // FIPS 180-4 / NIST CAVP "abc" vector.
        assert_eq!(
            hash_file(&p).unwrap(),
            "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
        );
        fs::write(&p, "").unwrap();
        assert_eq!(
            hash_file(&p).unwrap(),
            "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        );
    }

    #[test]
    fn untouched_tree_verifies() {
        let root = project("ok");
        let m = manifest_for(&root);
        assert_eq!(m.inputs.len(), 3, "Cargo.toml, Cargo.lock, crates/a/src/lib.rs");
        assert!(check_manifest(&root, &m, false).is_empty());
    }

    /// Regression (audit H3): `verify` used to return Ok(true) unconditionally.
    #[test]
    fn modified_file_fails_verification() {
        let root = project("mod");
        let m = manifest_for(&root);
        fs::write(root.join("crates/a/src/lib.rs"), "pub fn f() { evil() }\n").unwrap();
        let failures = check_manifest(&root, &m, false);
        assert_eq!(failures.len(), 1, "{failures:?}");
        assert!(failures[0].contains("mismatch"), "{failures:?}");
    }

    #[test]
    fn missing_file_fails_verification() {
        let root = project("missing");
        let m = manifest_for(&root);
        fs::remove_file(root.join("Cargo.lock")).unwrap();
        let failures = check_manifest(&root, &m, false);
        assert!(failures.iter().any(|f| f.contains("Cargo.lock") && f.contains("missing")), "{failures:?}");
    }

    #[test]
    fn empty_or_malformed_manifests_fail_closed() {
        let root = project("empty");
        let empty = parse_manifest(r#"{"version":"1.0.0","inputs":[],"outputs":[]}"#).unwrap();
        assert!(!check_manifest(&root, &empty, false).is_empty(), "empty manifest must not pass");
        assert!(parse_manifest(r#"{"version":"1.0.0"}"#).is_err(), "no file lists");
        assert!(parse_manifest("not json").is_err());

        // The old placeholder format: a 64-bit value repeated four times is
        // well-formed hex but is not the file's SHA-256.
        let stub = format!(
            r#"{{"version":"1.0.0","inputs":[{{"path":"Cargo.toml","sha256":"{0}{0}{0}{0}","size":21}}],"outputs":[]}}"#,
            "0123456789abcdef"
        );
        let m = parse_manifest(&stub).unwrap();
        assert!(!check_manifest(&root, &m, false).is_empty());
    }

    #[test]
    fn traversal_paths_are_rejected() {
        let root = project("trav");
        for bad in ["../outside", "/etc/passwd", "crates/../../x"] {
            let doc = format!(
                r#"{{"version":"1.0.0","inputs":[{{"path":"{bad}","sha256":"{}","size":0}}],"outputs":[]}}"#,
                "0".repeat(64)
            );
            let m = parse_manifest(&doc).unwrap();
            let failures = check_manifest(&root, &m, false);
            assert!(failures.iter().any(|f| f.contains("unsafe path")), "{bad}: {failures:?}");
        }
    }

    #[test]
    fn json_output_escapes_paths() {
        let root = project("esc");
        fs::write(root.join("crates/a/src/q\"uote.rs"), "x").unwrap();
        let m = generate_manifest(&root, "release", true, false).unwrap();
        let parsed = parse_manifest(&m.to_json()).unwrap();
        assert!(parsed.inputs.iter().any(|e| e.path.ends_with("q\"uote.rs")));
        assert!(check_manifest(&root, &parsed, false).is_empty());
    }

    #[test]
    fn diff_detects_changes() {
        let root = project("diff");
        let a = manifest_for(&root);
        assert!(manifest_differences(&a, &manifest_for(&root)).is_empty());
        fs::write(root.join("Cargo.toml"), "[package]\nname = \"y\"\n").unwrap();
        let b = manifest_for(&root);
        let d = manifest_differences(&a, &b);
        assert_eq!(d.len(), 1, "{d:?}");
        assert!(d[0].contains("Cargo.toml"));
    }
}
