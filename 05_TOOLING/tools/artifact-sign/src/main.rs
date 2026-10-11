// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Artifact Signing Tool
//! Signs build artifacts using real cryptographic primitives from riina-core:
//! - Ed25519 for classical signatures
//! - ML-DSA-65 (FIPS 204) for post-quantum security
//! - Hybrid (ML-DSA-65 + Ed25519) for defense-in-depth
//!
//! Also generates and verifies Software Bill of Materials (SBOM).

#![forbid(unsafe_code)]

use std::fs::{self, File};
use std::io::{self, BufReader, Read, Write};
use std::path::{Path, PathBuf};
use std::process::ExitCode;
use std::time::{SystemTime, UNIX_EPOCH};

use clap::{Parser, Subcommand, ValueEnum};
use sha2::Digest;

use riina_core::crypto::ed25519::{
    Ed25519SigningKey, Ed25519VerifyingKey,
    PUBLIC_KEY_SIZE as ED25519_PK_SIZE,
    SECRET_KEY_SIZE as ED25519_SK_SIZE,
    SIGNATURE_SIZE as ED25519_SIG_SIZE,
};
use riina_core::crypto::ml_dsa::{
    MlDsa65KeyPair, MlDsa65SigningKey, MlDsa65VerifyingKey,
    PUBLIC_KEY_SIZE as ML_DSA_PK_SIZE,
    SECRET_KEY_SIZE as ML_DSA_SK_SIZE,
    SIGNATURE_SIZE as ML_DSA_SIG_SIZE,
};
use riina_core::crypto::hybrid::{
    HybridSigningKey, HybridVerifyingKey,
    HYBRID_SIG_PUBLIC_KEY_SIZE,
    HYBRID_SIG_SIGNATURE_SIZE,
};
use riina_core::zeroize::Zeroize;
use serde_json::Value;

// ═══════════════════════════════════════════════════════════════════════════════
// CLI DEFINITION
// ═══════════════════════════════════════════════════════════════════════════════

#[derive(Parser)]
#[command(name = "riina-artifact-sign")]
#[command(version = "1.0.0")]
#[command(about = "RIINA Artifact Signing - Post-Quantum Secure Signatures")]
struct Cli {
    #[command(subcommand)]
    command: Commands,

    /// Verbose output
    #[arg(short, long, global = true)]
    verbose: bool,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate a new signing key pair
    Keygen {
        /// Algorithm (mldsa65/ed25519/hybrid)
        #[arg(short, long, default_value = "mldsa65")]
        algorithm: SigningAlgorithm,

        /// Output base path for keys (produces <path>.pub and <path>.priv)
        #[arg(short, long, default_value = "riina-key")]
        output: PathBuf,

        /// Replace existing key files (otherwise keygen refuses to overwrite)
        #[arg(long)]
        force: bool,
    },

    /// Sign an artifact
    Sign {
        /// File to sign
        file: PathBuf,

        /// Private key file
        #[arg(short, long)]
        key: PathBuf,

        /// Output signature file (default: `<file>.sig`)
        #[arg(short, long)]
        output: Option<PathBuf>,
    },

    /// Verify a signature
    Verify {
        /// File that was signed
        file: PathBuf,

        /// Signature file
        #[arg(short, long)]
        signature: PathBuf,

        /// Public key file
        #[arg(short, long)]
        key: PathBuf,
    },

    /// Generate SBOM for a project
    Sbom {
        /// Project root
        #[arg(short, long, default_value = ".")]
        project: PathBuf,

        /// Output file
        #[arg(short, long, default_value = "sbom.json")]
        output: PathBuf,

        /// SBOM format (cyclonedx/spdx)
        #[arg(long, default_value = "cyclonedx")]
        format: SbomFormat,
    },

    /// Sign a build manifest (riina-build-manifest JSON) after checking that
    /// every file it lists matches its SHA-256; refuses to sign a stale or
    /// empty manifest
    SignManifest {
        /// Manifest file
        manifest: PathBuf,

        /// Private key file
        #[arg(short, long)]
        key: PathBuf,

        /// Output signature file (default: `<manifest>.sig`)
        #[arg(short, long)]
        output: Option<PathBuf>,

        /// Directory the manifest's relative paths resolve against
        /// (default: the manifest's own directory)
        #[arg(long)]
        root: Option<PathBuf>,
    },

    /// Verify a manifest's signature AND every file it lists (exits non-zero
    /// on a bad signature, a mismatch, a missing file, or an empty manifest)
    VerifyManifest {
        /// Manifest file
        manifest: PathBuf,

        /// Public key file
        #[arg(short, long)]
        key: PathBuf,

        /// Signature file (default: `<manifest>.sig`)
        #[arg(short, long)]
        signature: Option<PathBuf>,

        /// Directory the manifest's relative paths resolve against
        /// (default: the manifest's own directory)
        #[arg(long)]
        root: Option<PathBuf>,
    },
}

#[derive(Clone, Copy, ValueEnum)]
enum SigningAlgorithm {
    /// ML-DSA-65 (FIPS 204) - Post-quantum secure
    Mldsa65,
    /// Ed25519 - Classical, fast
    Ed25519,
    /// Hybrid - Both ML-DSA and Ed25519
    Hybrid,
}

impl SigningAlgorithm {
    fn name(self) -> &'static str {
        match self {
            SigningAlgorithm::Mldsa65 => "ML-DSA-65",
            SigningAlgorithm::Ed25519 => "Ed25519",
            SigningAlgorithm::Hybrid => "Hybrid",
        }
    }
}

#[derive(Clone, Copy, ValueEnum)]
enum SbomFormat {
    CycloneDx,
    Spdx,
}

// ═══════════════════════════════════════════════════════════════════════════════
// RANDOM BYTES FROM /dev/urandom
// ═══════════════════════════════════════════════════════════════════════════════

fn read_random_bytes(buf: &mut [u8]) -> io::Result<()> {
    let mut f = File::open("/dev/urandom")?;
    f.read_exact(buf)
}

// ═══════════════════════════════════════════════════════════════════════════════
// KEY MANAGEMENT — REAL CRYPTO
// ═══════════════════════════════════════════════════════════════════════════════

struct KeyPair {
    public_key: Vec<u8>,
    private_key: Vec<u8>,
}

impl Drop for KeyPair {
    fn drop(&mut self) {
        // Law 4: the in-memory copy of the private key is scrubbed once the
        // key file has been written.
        self.private_key.zeroize();
    }
}

impl KeyPair {
    fn generate(algorithm: SigningAlgorithm) -> io::Result<Self> {
        match algorithm {
            SigningAlgorithm::Ed25519 => {
                let mut seed = [0u8; ED25519_SK_SIZE];
                read_random_bytes(&mut seed)?;
                let signing_key = Ed25519SigningKey::from_seed(&seed);
                let public_key = signing_key.public_key_bytes().to_vec();
                Ok(Self {
                    public_key,
                    private_key: seed.to_vec(),
                })
            }
            SigningAlgorithm::Mldsa65 => {
                let mut random = [0u8; 32];
                read_random_bytes(&mut random)?;
                let kp = MlDsa65KeyPair::generate(&random).map_err(|e| {
                    io::Error::other(format!("ML-DSA keygen failed: {e}"))
                })?;
                let public_key = kp.verifying_key().as_bytes().to_vec();
                let private_key = kp.signing_key().as_bytes().to_vec();
                Ok(Self {
                    public_key,
                    private_key,
                })
            }
            SigningAlgorithm::Hybrid => {
                let mut random = [0u8; 64];
                read_random_bytes(&mut random)?;
                let hsk = HybridSigningKey::generate(&random).map_err(|e| {
                    io::Error::other(format!("Hybrid keygen failed: {e}"))
                })?;
                let public_key = hsk.public_key().to_vec();
                // Store the seed so we can reconstruct later
                let private_key = random.to_vec();
                Ok(Self {
                    public_key,
                    private_key,
                })
            }
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SIGNATURE STRUCTURE
// ═══════════════════════════════════════════════════════════════════════════════

struct ArtifactSignature {
    algorithm: String,
    timestamp: u64,
    file_hash: String,
    signature: Vec<u8>,
}

impl ArtifactSignature {
    fn to_bytes(&self) -> Vec<u8> {
        let mut bytes = Vec::new();

        // Magic header
        bytes.extend(b"RIINA-SIG-V1");

        // Algorithm (32 bytes, null-padded)
        let mut algo = self.algorithm.as_bytes().to_vec();
        algo.resize(32, 0);
        bytes.extend(&algo);

        // Timestamp (8 bytes, big-endian)
        bytes.extend(&self.timestamp.to_be_bytes());

        // File hash (64 bytes, hex string)
        let mut hash = self.file_hash.as_bytes().to_vec();
        hash.resize(64, 0);
        bytes.extend(&hash);

        // Signature length (4 bytes)
        bytes.extend(&(self.signature.len() as u32).to_be_bytes());

        // Signature data
        bytes.extend(&self.signature);

        bytes
    }

    fn from_bytes(bytes: &[u8]) -> Option<Self> {
        if bytes.len() < 120 {
            return None;
        }

        // Check magic
        if &bytes[0..12] != b"RIINA-SIG-V1" {
            return None;
        }

        // Algorithm
        let algo_bytes = &bytes[12..44];
        let algo_end = algo_bytes.iter().position(|&b| b == 0).unwrap_or(32);
        let algorithm = String::from_utf8_lossy(&algo_bytes[..algo_end]).to_string();

        // Timestamp
        let timestamp = u64::from_be_bytes([
            bytes[44], bytes[45], bytes[46], bytes[47], bytes[48], bytes[49], bytes[50], bytes[51],
        ]);

        // File hash
        let hash_bytes = &bytes[52..116];
        let hash_end = hash_bytes.iter().position(|&b| b == 0).unwrap_or(64);
        let file_hash = String::from_utf8_lossy(&hash_bytes[..hash_end]).to_string();

        // Signature length
        let sig_len =
            u32::from_be_bytes([bytes[116], bytes[117], bytes[118], bytes[119]]) as usize;

        if bytes.len() < 120 + sig_len {
            return None;
        }

        let signature = bytes[120..120 + sig_len].to_vec();

        Some(Self {
            algorithm,
            timestamp,
            file_hash,
            signature,
        })
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HASHING — Real SHA-256
// ═══════════════════════════════════════════════════════════════════════════════

fn hash_file(path: &Path) -> io::Result<String> {
    let file = File::open(path)?;
    let mut reader = BufReader::new(file);
    let mut hasher = sha2::Sha256::new();
    let mut buf = [0u8; 8192];
    loop {
        let n = reader.read(&mut buf)?;
        if n == 0 {
            break;
        }
        hasher.update(&buf[..n]);
    }
    let digest = hasher.finalize();
    Ok(hex_encode(&digest))
}

#[allow(clippy::format_push_string)] // readable hex building in a loop
fn hex_encode(bytes: &[u8]) -> String {
    let mut s = String::with_capacity(bytes.len() * 2);
    for b in bytes {
        s.push_str(&format!("{b:02x}"));
    }
    s
}

fn hex_decode(s: &str) -> Option<Vec<u8>> {
    if !s.len().is_multiple_of(2) {
        return None;
    }
    let mut out = Vec::with_capacity(s.len() / 2);
    let mut chars = s.chars();
    while let Some(c) = chars.next() {
        let hi = c.to_digit(16)?;
        let lo = chars.next()?.to_digit(16)?;
        out.push((hi * 16 + lo) as u8);
    }
    Some(out)
}

// ═══════════════════════════════════════════════════════════════════════════════
// KEY FILE I/O
// ═══════════════════════════════════════════════════════════════════════════════

/// Who may read a key file once written.
#[derive(Clone, Copy, PartialEq, Eq)]
enum KeyVisibility {
    /// Owner read/write only (0600 on unix) — private keys.
    Private,
    /// World-readable (0644 on unix) — public keys.
    Public,
}

/// Create a NEW key file. Never truncates an existing file: `File::create`
/// would keep the old file's permissions (a 0644 file stays 0644 however the
/// new bytes are written), and silently clobbering a key is its own hazard.
/// The permission bits are applied at `open(2)` time, so a private key is
/// never readable by others, not even briefly.
fn create_key_file(path: &Path, visibility: KeyVisibility) -> io::Result<File> {
    let mut opts = fs::OpenOptions::new();
    opts.write(true).create_new(true);
    #[cfg(unix)]
    {
        use std::os::unix::fs::OpenOptionsExt;
        opts.mode(match visibility {
            KeyVisibility::Private => 0o600,
            KeyVisibility::Public => 0o644,
        });
    }
    opts.open(path).map_err(|e| {
        if e.kind() == io::ErrorKind::AlreadyExists {
            io::Error::new(
                io::ErrorKind::AlreadyExists,
                format!("{} already exists; refusing to overwrite (use --force)", path.display()),
            )
        } else {
            e
        }
    })
}

fn write_key_file(
    path: &Path,
    visibility: KeyVisibility,
    header: &str,
    algorithm: &str,
    key_bytes: &[u8],
) -> io::Result<()> {
    let mut f = create_key_file(path, visibility)?;
    writeln!(f, "-----BEGIN {header}-----")?;
    writeln!(f, "Algorithm: {algorithm}")?;
    writeln!(f)?;
    for chunk in key_bytes.chunks(48) {
        writeln!(f, "{}", hex_encode(chunk))?;
    }
    writeln!(f, "-----END {header}-----")?;
    Ok(())
}

fn read_key_file(path: &Path, expected_header: &str) -> io::Result<(String, Vec<u8>)> {
    let contents = fs::read_to_string(path)?;
    let begin_marker = format!("-----BEGIN {expected_header}-----");
    let end_marker = format!("-----END {expected_header}-----");

    if !contents.contains(&begin_marker) {
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            format!("Missing {begin_marker}"),
        ));
    }

    let mut algorithm = String::new();
    let mut hex_data = String::new();
    let mut in_body = false;

    for line in contents.lines() {
        let trimmed = line.trim();
        if trimmed.contains(&begin_marker) {
            in_body = true;
            continue;
        }
        if trimmed.contains(&end_marker) {
            break;
        }
        if !in_body {
            continue;
        }
        if let Some(algo) = trimmed.strip_prefix("Algorithm: ") {
            algorithm = algo.to_string();
            continue;
        }
        if trimmed.is_empty() {
            continue;
        }
        // Hex data line
        hex_data.push_str(trimmed);
    }

    let bytes = hex_decode(&hex_data).ok_or_else(|| {
        io::Error::new(io::ErrorKind::InvalidData, "Invalid hex encoding in key file")
    })?;

    Ok((algorithm, bytes))
}

// ═══════════════════════════════════════════════════════════════════════════════
// REAL SIGNING / VERIFICATION
// ═══════════════════════════════════════════════════════════════════════════════

fn sign_message_with_key(algorithm: &str, private_key: &[u8], message: &[u8]) -> io::Result<Vec<u8>> {
    match algorithm {
        "Ed25519" => {
            if private_key.len() != ED25519_SK_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("Ed25519 private key must be {ED25519_SK_SIZE} bytes, got {}", private_key.len()),
                ));
            }
            let seed: [u8; ED25519_SK_SIZE] = private_key
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad Ed25519 key length"))?;
            let sk = Ed25519SigningKey::from_seed(&seed);
            let sig = sk.sign(message);
            Ok(sig.to_vec())
        }
        "ML-DSA-65" => {
            if private_key.len() != ML_DSA_SK_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("ML-DSA-65 private key must be {ML_DSA_SK_SIZE} bytes, got {}", private_key.len()),
                ));
            }
            let sk_arr: &[u8; ML_DSA_SK_SIZE] = private_key
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad ML-DSA key length"))?;
            let sk = MlDsa65SigningKey::from_bytes(sk_arr).map_err(|e| {
                io::Error::new(io::ErrorKind::InvalidData, format!("ML-DSA key parse: {e}"))
            })?;
            let sig = sk.sign(message).map_err(|e| {
                io::Error::other(format!("ML-DSA sign failed: {e}"))
            })?;
            Ok(sig.to_vec())
        }
        "Hybrid" => {
            if private_key.len() != 64 {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    "Hybrid private key (seed) must be 64 bytes",
                ));
            }
            let hsk = HybridSigningKey::generate(private_key).map_err(|e| {
                io::Error::other(format!("Hybrid key reconstruct: {e}"))
            })?;
            let sig = hsk.sign(message).map_err(|e| {
                io::Error::other(format!("Hybrid sign failed: {e}"))
            })?;
            Ok(sig.to_vec())
        }
        other => Err(io::Error::new(
            io::ErrorKind::InvalidData,
            format!("Unknown algorithm: {other}"),
        )),
    }
}

fn verify_message_with_key(
    algorithm: &str,
    public_key: &[u8],
    message: &[u8],
    signature: &[u8],
) -> io::Result<bool> {
    match algorithm {
        "Ed25519" => {
            if public_key.len() != ED25519_PK_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("Ed25519 public key must be {ED25519_PK_SIZE} bytes"),
                ));
            }
            if signature.len() != ED25519_SIG_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("Ed25519 signature must be {ED25519_SIG_SIZE} bytes"),
                ));
            }
            let pk: &[u8; ED25519_PK_SIZE] = public_key
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad Ed25519 pk length"))?;
            let sig: &[u8; ED25519_SIG_SIZE] = signature
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad Ed25519 sig length"))?;
            let vk = Ed25519VerifyingKey::from_bytes(pk).map_err(|e| {
                io::Error::new(io::ErrorKind::InvalidData, format!("Ed25519 pk parse: {e}"))
            })?;
            match vk.verify(message, sig) {
                Ok(()) => Ok(true),
                Err(_) => Ok(false),
            }
        }
        "ML-DSA-65" => {
            if public_key.len() != ML_DSA_PK_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("ML-DSA-65 public key must be {ML_DSA_PK_SIZE} bytes"),
                ));
            }
            if signature.len() != ML_DSA_SIG_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("ML-DSA-65 signature must be {ML_DSA_SIG_SIZE} bytes"),
                ));
            }
            let pk: &[u8; ML_DSA_PK_SIZE] = public_key
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad ML-DSA pk length"))?;
            let sig: &[u8; ML_DSA_SIG_SIZE] = signature
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad ML-DSA sig length"))?;
            let vk = MlDsa65VerifyingKey::from_bytes(pk).map_err(|e| {
                io::Error::new(io::ErrorKind::InvalidData, format!("ML-DSA pk parse: {e}"))
            })?;
            match vk.verify(message, sig) {
                Ok(()) => Ok(true),
                Err(_) => Ok(false),
            }
        }
        "Hybrid" => {
            if public_key.len() != HYBRID_SIG_PUBLIC_KEY_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("Hybrid public key must be {HYBRID_SIG_PUBLIC_KEY_SIZE} bytes"),
                ));
            }
            if signature.len() != HYBRID_SIG_SIGNATURE_SIZE {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("Hybrid signature must be {HYBRID_SIG_SIGNATURE_SIZE} bytes"),
                ));
            }
            let pk: &[u8; HYBRID_SIG_PUBLIC_KEY_SIZE] = public_key
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad Hybrid pk length"))?;
            let sig: &[u8; HYBRID_SIG_SIGNATURE_SIZE] = signature
                .try_into()
                .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "Bad Hybrid sig length"))?;
            let vk = HybridVerifyingKey::from_bytes(pk).map_err(|e| {
                io::Error::new(io::ErrorKind::InvalidData, format!("Hybrid pk parse: {e}"))
            })?;
            match vk.verify(message, sig) {
                Ok(()) => Ok(true),
                Err(_) => Ok(false),
            }
        }
        other => Err(io::Error::new(
            io::ErrorKind::InvalidData,
            format!("Unknown algorithm: {other}"),
        )),
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMMANDS
// ═══════════════════════════════════════════════════════════════════════════════

fn generate_keypair(
    algorithm: SigningAlgorithm,
    output: &Path,
    force: bool,
    _verbose: bool,
) -> io::Result<()> {
    println!("Generating {} key pair...", algorithm.name());

    let public_path = PathBuf::from(format!("{}.pub", output.display()));
    let private_path = PathBuf::from(format!("{}.priv", output.display()));

    // Decide about BOTH files before writing either, so a refusal never
    // leaves a half-replaced key pair behind.
    for path in [&private_path, &public_path] {
        if fs::symlink_metadata(path).is_ok() {
            if !force {
                return Err(io::Error::new(
                    io::ErrorKind::AlreadyExists,
                    format!("{} already exists; refusing to overwrite (use --force)", path.display()),
                ));
            }
            // Remove rather than truncate: a new inode gets the new mode.
            fs::remove_file(path)?;
        }
    }

    let keypair = KeyPair::generate(algorithm)?;

    write_key_file(
        &private_path,
        KeyVisibility::Private,
        "RIINA PRIVATE KEY",
        algorithm.name(),
        &keypair.private_key,
    )?;
    write_key_file(
        &public_path,
        KeyVisibility::Public,
        "RIINA PUBLIC KEY",
        algorithm.name(),
        &keypair.public_key,
    )?;

    println!("Public key:  {}", public_path.display());
    println!("Private key: {}", private_path.display());
    println!();
    println!("SECURITY: Keep the private key secure!");
    println!("  - Store in hardware security module if possible");
    println!("  - Never commit to version control");
    println!("  - Use separate keys for development and production");

    Ok(())
}

fn sign_file(file: &Path, key: &Path, output: Option<&Path>, verbose: bool) -> io::Result<()> {
    println!("Signing: {}", file.display());
    let file_contents = fs::read(file)?;
    let output_path = output
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from(format!("{}.sig", file.display())));
    sign_bytes(&file_contents, key, &output_path, verbose)
}

/// Sign exactly `file_contents` (read once by the caller, so the bytes that
/// were checked are the bytes that get signed).
fn sign_bytes(file_contents: &[u8], key: &Path, output_path: &Path, verbose: bool) -> io::Result<()> {
    // SHA-256 of the signed bytes (recorded in the header, re-checked on verify)
    let file_hash = hex_encode(&sha2::Sha256::digest(file_contents));
    if verbose {
        println!("File hash: {file_hash}");
    }

    // Read private key
    let (algorithm, mut private_key_bytes) = read_key_file(key, "RIINA PRIVATE KEY")?;

    // Sign the file contents
    let signed = sign_message_with_key(&algorithm, &private_key_bytes, file_contents);
    private_key_bytes.zeroize();
    let signature_data = signed?;

    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_secs())
        .unwrap_or(0);

    let sig = ArtifactSignature {
        algorithm,
        timestamp,
        file_hash,
        signature: signature_data,
    };

    fs::write(output_path, sig.to_bytes())?;

    println!("Signature written to {}", output_path.display());

    Ok(())
}

fn verify_signature(file: &Path, sig_path: &Path, key: &Path, verbose: bool) -> io::Result<bool> {
    println!("Verifying: {}", file.display());
    let file_contents = fs::read(file)?;
    verify_bytes(&file_contents, sig_path, key, verbose)
}

/// Verify a signature over exactly `file_contents` (read once by the caller).
fn verify_bytes(file_contents: &[u8], sig_path: &Path, key: &Path, verbose: bool) -> io::Result<bool> {
    // Read signature
    let sig_bytes = fs::read(sig_path)?;
    let sig = ArtifactSignature::from_bytes(&sig_bytes)
        .ok_or_else(|| io::Error::new(io::ErrorKind::InvalidData, "Invalid signature format"))?;

    if verbose {
        println!("Algorithm:   {}", sig.algorithm);
        println!("Timestamp:   {}", sig.timestamp);
        println!("File hash:   {}", sig.file_hash);
    }

    // Read public key
    let (algorithm, public_key_bytes) = read_key_file(key, "RIINA PUBLIC KEY")?;

    if algorithm != sig.algorithm {
        println!("Algorithm mismatch: key is {algorithm}, signature is {}", sig.algorithm);
        return Ok(false);
    }

    // Verify file hash first
    let current_hash = hex_encode(&sha2::Sha256::digest(file_contents));
    if current_hash != sig.file_hash {
        println!("Hash mismatch!");
        println!("  Expected: {}", sig.file_hash);
        println!("  Actual:   {current_hash}");
        return Ok(false);
    }

    // Verify cryptographic signature
    let valid = verify_message_with_key(&algorithm, &public_key_bytes, file_contents, &sig.signature)?;

    if valid {
        println!("Signature valid");
    } else {
        println!("Signature INVALID — cryptographic verification failed");
    }

    Ok(valid)
}

// ═══════════════════════════════════════════════════════════════════════════════
// MANIFEST SIGNING — riina-build-manifest JSON
// ═══════════════════════════════════════════════════════════════════════════════
//
// A signature over the manifest bytes, plus a re-check of every file it lists.
// The manifest's SHA-256 entries bind the artifacts; the signature binds the
// manifest. Both halves fail closed: `sign-manifest` refuses to sign a manifest
// that does not match the tree (or lists nothing), and `verify-manifest` exits
// non-zero on a bad signature, a mismatch, or a missing file. (Until 2026-10
// both subcommands printed "Not yet implemented" and exited 0.)

/// One file listed by a manifest.
struct ManifestEntry {
    path: String,
    sha256: String,
    size: u64,
}

fn invalid_data(msg: impl Into<String>) -> io::Error {
    io::Error::new(io::ErrorKind::InvalidData, msg.into())
}

/// Parse the `inputs`/`outputs` file lists of a riina-build-manifest manifest.
/// An empty list is an error: a manifest that lists nothing verifies nothing.
fn parse_manifest_entries(contents: &[u8]) -> io::Result<Vec<ManifestEntry>> {
    let doc: Value = serde_json::from_slice(contents)
        .map_err(|e| invalid_data(format!("manifest is not valid JSON: {e}")))?;
    let mut entries = Vec::new();
    for key in ["inputs", "outputs"] {
        let list = doc
            .get(key)
            .and_then(Value::as_array)
            .ok_or_else(|| invalid_data(format!("manifest has no \"{key}\" array")))?;
        for (i, e) in list.iter().enumerate() {
            let field = |name: &str| {
                e.get(name)
                    .ok_or_else(|| invalid_data(format!("{key}[{i}]: missing \"{name}\"")))
            };
            entries.push(ManifestEntry {
                path: field("path")?
                    .as_str()
                    .ok_or_else(|| invalid_data(format!("{key}[{i}]: bad \"path\"")))?
                    .to_string(),
                sha256: field("sha256")?
                    .as_str()
                    .ok_or_else(|| invalid_data(format!("{key}[{i}]: bad \"sha256\"")))?
                    .to_string(),
                size: field("size")?
                    .as_u64()
                    .ok_or_else(|| invalid_data(format!("{key}[{i}]: bad \"size\"")))?,
            });
        }
    }
    if entries.is_empty() {
        return Err(invalid_data("manifest lists no files — nothing would be verified"));
    }
    Ok(entries)
}

/// Relative, and no `..`/root/prefix components: the manifest is untrusted
/// input and must not steer reads outside the project root.
fn safe_relative(path: &str) -> bool {
    !path.is_empty()
        && Path::new(path)
            .components()
            .all(|c| matches!(c, std::path::Component::Normal(_) | std::path::Component::CurDir))
}

/// Recompute every listed file under `root`; returns the failures.
fn check_manifest_files(root: &Path, entries: &[ManifestEntry]) -> Vec<String> {
    let mut failures = Vec::new();
    for e in entries {
        if !safe_relative(&e.path) {
            failures.push(format!("{}: unsafe path (must be relative, no '..')", e.path));
            continue;
        }
        let path = root.join(&e.path);
        match (hash_file(&path), fs::metadata(&path)) {
            (Ok(actual), Ok(meta)) => {
                if actual != e.sha256 {
                    failures.push(format!(
                        "{}: SHA-256 mismatch (manifest {}, actual {actual})",
                        e.path, e.sha256
                    ));
                } else if meta.len() != e.size {
                    failures.push(format!(
                        "{}: size mismatch (manifest {}, actual {})",
                        e.path,
                        e.size,
                        meta.len()
                    ));
                }
            }
            (Err(err), _) | (_, Err(err)) => {
                failures.push(format!("{}: missing or unreadable ({err})", e.path));
            }
        }
    }
    failures
}

/// The directory a manifest's relative paths resolve against.
fn manifest_root(manifest: &Path, root: Option<&Path>) -> PathBuf {
    root.map(Path::to_path_buf).unwrap_or_else(|| {
        manifest
            .parent()
            .filter(|p| !p.as_os_str().is_empty())
            .map_or_else(|| PathBuf::from("."), Path::to_path_buf)
    })
}

fn sign_manifest(
    manifest: &Path,
    key: &Path,
    output: Option<&Path>,
    root: Option<&Path>,
    verbose: bool,
) -> io::Result<()> {
    println!("Signing manifest: {}", manifest.display());
    let contents = fs::read(manifest)?;
    let entries = parse_manifest_entries(&contents)?;
    let root = manifest_root(manifest, root);
    let failures = check_manifest_files(&root, &entries);
    if !failures.is_empty() {
        for f in &failures {
            println!("  ✗ {f}");
        }
        return Err(invalid_data(format!(
            "manifest does not match the files under {} ({} failure(s)); refusing to sign",
            root.display(),
            failures.len()
        )));
    }
    println!("  {} listed file(s) match their SHA-256", entries.len());
    let output_path = output
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from(format!("{}.sig", manifest.display())));
    sign_bytes(&contents, key, &output_path, verbose)
}

fn verify_manifest(
    manifest: &Path,
    key: &Path,
    signature: Option<&Path>,
    root: Option<&Path>,
    verbose: bool,
) -> io::Result<bool> {
    println!("Verifying manifest: {}", manifest.display());
    // Read ONCE: the bytes whose signature is checked are the bytes parsed.
    let contents = fs::read(manifest)?;
    let sig_path = signature
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from(format!("{}.sig", manifest.display())));
    if !verify_bytes(&contents, &sig_path, key, verbose)? {
        println!("Manifest signature INVALID");
        return Ok(false);
    }
    let entries = parse_manifest_entries(&contents)?;
    let root = manifest_root(manifest, root);
    let failures = check_manifest_files(&root, &entries);
    for f in &failures {
        println!("  ✗ {f}");
    }
    if failures.is_empty() {
        println!("Manifest signature valid; {} listed file(s) match", entries.len());
        Ok(true)
    } else {
        println!("{} listed file(s) do NOT match", failures.len());
        Ok(false)
    }
}

fn generate_sbom(
    project: &Path,
    output: &Path,
    format: SbomFormat,
    _verbose: bool,
) -> io::Result<()> {
    println!("Generating SBOM for: {}", project.display());

    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_secs())
        .unwrap_or(0);

    // Parse Cargo.lock to get dependencies
    let cargo_lock = project.join("Cargo.lock");
    let mut components = Vec::new();

    if cargo_lock.exists() {
        let lock_contents = fs::read_to_string(&cargo_lock)?;

        for line in lock_contents.lines() {
            if line.starts_with("name = \"") {
                let name = line.trim_start_matches("name = \"").trim_end_matches('"');
                components.push(name.to_string());
            }
        }
    }

    let sbom = match format {
        SbomFormat::CycloneDx => generate_cyclonedx(&components, timestamp),
        SbomFormat::Spdx => generate_spdx(&components, timestamp),
    };

    fs::write(output, sbom)?;

    println!("SBOM written to {}", output.display());
    println!("  Components: {}", components.len());

    Ok(())
}

#[allow(clippy::format_push_string)] // readable JSON assembly
fn generate_cyclonedx(components: &[String], timestamp: u64) -> String {
    let mut json = String::from("{\n");
    json.push_str("  \"bomFormat\": \"CycloneDX\",\n");
    json.push_str("  \"specVersion\": \"1.5\",\n");
    json.push_str(&format!(
        "  \"serialNumber\": \"urn:uuid:riina-{timestamp}\",\n"
    ));
    json.push_str("  \"version\": 1,\n");
    json.push_str("  \"metadata\": {\n");
    json.push_str(&format!("    \"timestamp\": \"{timestamp}\",\n"));
    json.push_str("    \"tools\": [\n");
    json.push_str("      {\n");
    json.push_str("        \"vendor\": \"RIINA\",\n");
    json.push_str("        \"name\": \"riina-artifact-sign\",\n");
    json.push_str("        \"version\": \"1.0.0\"\n");
    json.push_str("      }\n");
    json.push_str("    ]\n");
    json.push_str("  },\n");
    json.push_str("  \"components\": [\n");

    for (i, component) in components.iter().enumerate() {
        let comma = if i < components.len() - 1 { "," } else { "" };
        json.push_str("    {\n");
        json.push_str("      \"type\": \"library\",\n");
        json.push_str(&format!("      \"name\": \"{component}\"\n"));
        json.push_str(&format!("    }}{comma}\n"));
    }

    json.push_str("  ]\n");
    json.push_str("}\n");
    json
}

#[allow(clippy::format_push_string)] // readable JSON assembly
fn generate_spdx(components: &[String], timestamp: u64) -> String {
    let mut json = String::from("{\n");
    json.push_str("  \"spdxVersion\": \"SPDX-2.3\",\n");
    json.push_str("  \"dataLicense\": \"CC0-1.0\",\n");
    json.push_str(&format!(
        "  \"SPDXID\": \"SPDXRef-DOCUMENT-riina-{timestamp}\",\n"
    ));
    json.push_str("  \"name\": \"RIINA SBOM\",\n");
    json.push_str("  \"documentNamespace\": \"https://riina.io/sbom\",\n");
    json.push_str("  \"creationInfo\": {\n");
    json.push_str("    \"creators\": [\"Tool: riina-artifact-sign-1.0.0\"]\n");
    json.push_str("  },\n");
    json.push_str("  \"packages\": [\n");

    for (i, component) in components.iter().enumerate() {
        let comma = if i < components.len() - 1 { "," } else { "" };
        json.push_str("    {\n");
        json.push_str(&format!("      \"SPDXID\": \"SPDXRef-Package-{i}\",\n"));
        json.push_str(&format!("      \"name\": \"{component}\",\n"));
        json.push_str("      \"downloadLocation\": \"NOASSERTION\"\n");
        json.push_str(&format!("    }}{comma}\n"));
    }

    json.push_str("  ]\n");
    json.push_str("}\n");
    json
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN
// ═══════════════════════════════════════════════════════════════════════════════

fn main() -> ExitCode {
    let cli = Cli::parse();

    println!("===================================================================");
    println!("        RIINA ARTIFACT SIGNING TOOL v1.0.0");
    println!("  Mode: ULTRA KIASU | ZERO TRUST");
    println!("===================================================================");
    println!();

    let result = match &cli.command {
        Commands::Keygen {
            algorithm,
            output,
            force,
        } => generate_keypair(*algorithm, output, *force, cli.verbose),
        Commands::Sign { file, key, output } => {
            sign_file(file, key, output.as_deref(), cli.verbose)
        }
        Commands::Verify {
            file,
            signature,
            key,
        } => verify_signature(file, signature, key, cli.verbose).map(|valid| {
            if !valid {
                std::process::exit(1);
            }
        }),
        Commands::Sbom {
            project,
            output,
            format,
        } => generate_sbom(project, output, *format, cli.verbose),
        Commands::SignManifest {
            manifest,
            key,
            output,
            root,
        } => sign_manifest(manifest, key, output.as_deref(), root.as_deref(), cli.verbose),
        Commands::VerifyManifest {
            manifest,
            key,
            signature,
            root,
        } => verify_manifest(manifest, key, signature.as_deref(), root.as_deref(), cli.verbose)
            .and_then(|valid| {
                if valid {
                    Ok(())
                } else {
                    Err(io::Error::new(
                        io::ErrorKind::InvalidData,
                        "manifest verification FAILED",
                    ))
                }
            }),
    };

    match result {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            eprintln!("[ERROR] {e}");
            ExitCode::FAILURE
        }
    }
}

#[cfg(test)]
#[allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]
mod tests {
    use super::*;

    fn scratch(tag: &str) -> PathBuf {
        let dir = std::env::temp_dir().join(format!(
            "riina-artifact-sign-{tag}-{}-{}",
            std::process::id(),
            SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_nanos()
        ));
        fs::create_dir_all(&dir).unwrap();
        dir
    }

    /// Regression (audit M5): the private key is created 0600 (it used to be
    /// `File::create`, i.e. umask — typically 0644, world-readable).
    #[cfg(unix)]
    #[test]
    fn keygen_private_key_is_owner_only_and_never_overwritten() {
        use std::os::unix::fs::PermissionsExt;
        let dir = scratch("keygen");
        let base = dir.join("k");
        generate_keypair(SigningAlgorithm::Ed25519, &base, false, false).unwrap();
        let mode = |p: &str| fs::metadata(dir.join(p)).unwrap().permissions().mode() & 0o777;
        assert_eq!(mode("k.priv"), 0o600, "private key must be owner read/write only");
        assert_eq!(mode("k.pub") & 0o077 & !0o044, 0, "public key: no group/other write");
        let first = fs::read(dir.join("k.priv")).unwrap();

        // A second keygen without --force must refuse and leave both intact.
        let err = generate_keypair(SigningAlgorithm::Ed25519, &base, false, false).unwrap_err();
        assert_eq!(err.kind(), io::ErrorKind::AlreadyExists);
        assert_eq!(fs::read(dir.join("k.priv")).unwrap(), first);

        // --force replaces it — and a pre-existing world-readable file does
        // not keep its old mode (the file is recreated, not truncated).
        fs::set_permissions(dir.join("k.priv"), fs::Permissions::from_mode(0o644)).unwrap();
        generate_keypair(SigningAlgorithm::Ed25519, &base, true, false).unwrap();
        assert_eq!(mode("k.priv"), 0o600);
        assert_ne!(fs::read(dir.join("k.priv")).unwrap(), first, "a new key was generated");
    }

    fn write_manifest(dir: &Path, files: &[&str]) -> PathBuf {
        let entries: Vec<String> = files
            .iter()
            .map(|f| {
                let p = dir.join(f);
                format!(
                    r#"{{"path":"{f}","sha256":"{}","size":{}}}"#,
                    hash_file(&p).unwrap(),
                    fs::metadata(&p).unwrap().len()
                )
            })
            .collect();
        let m = dir.join("build-manifest.json");
        fs::write(
            &m,
            format!(r#"{{"version":"1.0.0","inputs":[{}],"outputs":[]}}"#, entries.join(",")),
        )
        .unwrap();
        m
    }

    /// Regression (audit H3): sign-manifest / verify-manifest used to print
    /// "Not yet implemented" and exit 0. Now: real signature over the
    /// manifest + recomputation of every listed file, failing closed.
    #[test]
    fn manifest_sign_verify_roundtrip_and_tamper_detection() {
        let dir = scratch("manifest");
        fs::write(dir.join("a.bin"), b"artifact a").unwrap();
        fs::create_dir_all(dir.join("sub")).unwrap();
        fs::write(dir.join("sub/b.bin"), b"artifact b").unwrap();
        let manifest = write_manifest(&dir, &["a.bin", "sub/b.bin"]);
        let key = dir.join("key");
        generate_keypair(SigningAlgorithm::Mldsa65, &key, false, false).unwrap();
        let priv_key = dir.join("key.priv");
        let pub_key = dir.join("key.pub");

        sign_manifest(&manifest, &priv_key, None, None, false).unwrap();
        assert!(verify_manifest(&manifest, &pub_key, None, None, false).unwrap());

        // An artifact changes after signing → verification fails.
        fs::write(dir.join("sub/b.bin"), b"artifact B").unwrap();
        assert!(!verify_manifest(&manifest, &pub_key, None, None, false).unwrap());
        // ...and sign-manifest refuses to sign the now-stale manifest.
        assert!(sign_manifest(&manifest, &priv_key, None, None, false).is_err());
        fs::write(dir.join("sub/b.bin"), b"artifact b").unwrap();

        // A deleted artifact fails.
        fs::remove_file(dir.join("a.bin")).unwrap();
        assert!(!verify_manifest(&manifest, &pub_key, None, None, false).unwrap());
        fs::write(dir.join("a.bin"), b"artifact a").unwrap();
        assert!(verify_manifest(&manifest, &pub_key, None, None, false).unwrap());

        // Rewriting the manifest (to match a malicious artifact) breaks the
        // signature even though every listed hash is then "correct".
        fs::write(dir.join("a.bin"), b"malicious").unwrap();
        write_manifest(&dir, &["a.bin", "sub/b.bin"]);
        assert!(!verify_manifest(&manifest, &pub_key, None, None, false).unwrap());
    }

    #[test]
    fn empty_or_traversing_manifests_are_refused() {
        let dir = scratch("empty");
        assert!(parse_manifest_entries(br#"{"version":"1.0.0","inputs":[],"outputs":[]}"#).is_err());
        assert!(parse_manifest_entries(b"{}").is_err());
        let traversal = format!(
            r#"{{"inputs":[{{"path":"../etc/passwd","sha256":"{}","size":1}}],"outputs":[]}}"#,
            "0".repeat(64)
        );
        let entries = parse_manifest_entries(traversal.as_bytes()).unwrap();
        let failures = check_manifest_files(&dir, &entries);
        assert!(failures.iter().any(|f| f.contains("unsafe path")), "{failures:?}");
    }

    /// Audit M1 at the tool level: an ML-DSA-65 artifact signature is a
    /// standard FIPS 204 (pure, empty-context) signature.
    #[test]
    fn mldsa_artifact_signatures_are_fips204_pure() {
        let kp = KeyPair::generate(SigningAlgorithm::Mldsa65).unwrap();
        let msg = b"artifact bytes";
        let sig = sign_message_with_key("ML-DSA-65", &kp.private_key, msg).unwrap();
        let pk: &[u8; ML_DSA_PK_SIZE] = kp.public_key.as_slice().try_into().unwrap();
        let sig_arr: &[u8; ML_DSA_SIG_SIZE] = sig.as_slice().try_into().unwrap();
        let vk = MlDsa65VerifyingKey::from_bytes(pk).unwrap();
        assert!(vk.verify_with_context(msg, b"", sig_arr).is_ok());
        assert!(vk.verify_internal(msg, sig_arr).is_err());
        assert!(verify_message_with_key("ML-DSA-65", &kp.public_key, msg, &sig).unwrap());
    }
}
