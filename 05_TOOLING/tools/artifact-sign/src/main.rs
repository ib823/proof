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

    /// Sign a manifest and its artifacts
    SignManifest {
        /// Manifest file
        manifest: PathBuf,

        /// Private key file
        #[arg(short, long)]
        key: PathBuf,
    },

    /// Verify manifest and all artifacts
    VerifyManifest {
        /// Manifest file
        manifest: PathBuf,

        /// Public key file
        #[arg(short, long)]
        key: PathBuf,
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

fn write_key_file(path: &Path, header: &str, algorithm: &str, key_bytes: &[u8]) -> io::Result<()> {
    let mut f = File::create(path)?;
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
    _verbose: bool,
) -> io::Result<()> {
    println!("Generating {} key pair...", algorithm.name());

    let keypair = KeyPair::generate(algorithm)?;

    let public_path = PathBuf::from(format!("{}.pub", output.display()));
    let private_path = PathBuf::from(format!("{}.priv", output.display()));

    write_key_file(&public_path, "RIINA PUBLIC KEY", algorithm.name(), &keypair.public_key)?;
    write_key_file(&private_path, "RIINA PRIVATE KEY", algorithm.name(), &keypair.private_key)?;

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

    // Compute SHA-256 file hash
    let file_hash = hash_file(file)?;
    if verbose {
        println!("File hash: {file_hash}");
    }

    // Read private key
    let (algorithm, private_key_bytes) = read_key_file(key, "RIINA PRIVATE KEY")?;

    // Read file contents to sign
    let file_contents = fs::read(file)?;

    // Sign the file contents
    let signature_data = sign_message_with_key(&algorithm, &private_key_bytes, &file_contents)?;

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

    let output_path = output
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from(format!("{}.sig", file.display())));

    fs::write(&output_path, sig.to_bytes())?;

    println!("Signature written to {}", output_path.display());

    Ok(())
}

fn verify_signature(file: &Path, sig_path: &Path, key: &Path, verbose: bool) -> io::Result<bool> {
    println!("Verifying: {}", file.display());

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
    let current_hash = hash_file(file)?;
    if current_hash != sig.file_hash {
        println!("Hash mismatch!");
        println!("  Expected: {}", sig.file_hash);
        println!("  Actual:   {current_hash}");
        return Ok(false);
    }

    // Verify cryptographic signature
    let file_contents = fs::read(file)?;
    let valid = verify_message_with_key(&algorithm, &public_key_bytes, &file_contents, &sig.signature)?;

    if valid {
        println!("Signature valid");
    } else {
        println!("Signature INVALID — cryptographic verification failed");
    }

    Ok(valid)
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
        } => generate_keypair(*algorithm, output, cli.verbose),
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
        Commands::SignManifest { manifest: _, key: _ } => {
            println!("Signing manifest and artifacts...");
            println!("Not yet implemented - would sign manifest + all referenced files");
            Ok(())
        }
        Commands::VerifyManifest { manifest: _, key: _ } => {
            println!("Verifying manifest and artifacts...");
            println!("Not yet implemented - would verify manifest + all referenced files");
            Ok(())
        }
    };

    match result {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            eprintln!("[ERROR] {e}");
            ExitCode::FAILURE
        }
    }
}
