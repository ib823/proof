// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Publisher signatures for packages fetched from a REMOTE registry.
//!
//! # Threat model
//!
//! Before signatures, a remote registry was trusted on first use: `pkg lock`
//! pinned whatever tree the registry served the first time. A compromised
//! registry (or anyone able to substitute its responses) could therefore
//! serve any code to a project that had not locked yet. Now every package
//! fetched from a remote registry must carry an **Ed25519 publisher
//! signature** (from the first-party `riina-core`) by a key the user has
//! listed as trusted, or it is refused.
//!
//! Packages from the local filesystem registry (`~/.riina/registry` or
//! `$RIINA_REGISTRY`) are the user's own files and are not signature-checked.
//!
//! # What is signed
//!
//! ```text
//! message   = lp("RIINA-PKG-SIGNATURE-v1") ‖ lp(utf8(name))
//!             ‖ lp(utf8(version)) ‖ lp(SHA-256(archive bytes))
//! signature = Ed25519(publisher secret key, message)        (RFC 8032)
//! lp(x)     = u64_be(len x) ‖ x
//! ```
//!
//! `archive` is the exact ustar archive the registry serves for
//! `name`/`version`. The verifier builds the message from the name and version
//! it ASKED for and the digest it COMPUTED, never from fields in the signature
//! document, so a signature cannot be replayed onto another name, version or
//! archive.
//!
//! # Signature document
//!
//! Served by the registry at `GET /api/v1/crates/{name}/{version}/signature`
//! (`404` = unsigned). Strictly parsed, at most 4 KiB, every key exactly once:
//!
//! ```text
//! riina-pkg-signature v1
//! nama = "foo"
//! versi = "1.2.3"
//! arkib-sha256 = "<64 lowercase hex>"
//! penandatangan = "ed25519:<64 lowercase hex public key>"
//! tandatangan = "<128 lowercase hex signature>"
//! ```
//!
//! # Key ids and key files
//!
//! A publisher key id is `ed25519:` followed by the 32-byte public key in
//! lowercase hex — the key itself, so ids cannot collide. Key files use the
//! same text format as `riina-artifact-sign` (Ed25519 keys are
//! interchangeable): `-----BEGIN RIINA PRIVATE KEY-----`, `Algorithm: Ed25519`,
//! the 32-byte seed in hex. `riinac pkg keygen` creates the private key with
//! mode 0600 at `open(2)` time and never overwrites a key without `--force`;
//! a private key readable by group or others is refused when loaded.
//!
//! # Trust configuration
//!
//! The trusted publisher keys are the union of:
//!
//! * the project's `riina.toml` (the ROOT manifest only — never a
//!   dependency's):
//!   ```toml
//!   [registry]
//!   url = "http://127.0.0.1:8080"
//!   trusted-publishers = ["ed25519:<hex>", "ed25519:<hex>"]
//!   ```
//! * the user file `~/.riina/trusted-publishers`: one key id per line, `#`
//!   comments allowed. Refused if group- or world-writable.
//!
//! A malformed entry in either place is an error, not ignored. Trust is not
//! scoped per package name: any trusted key may sign any package. `riina.lock`
//! records each package's signer (`penandatangan`), and a later build fails
//! closed if the signer changes.
//!
//! # Insecure opt-out
//!
//! `--insecure-allow-unsigned` accepts packages that are unsigned or signed by
//! an untrusted key, printing a loud warning for every such package on every
//! use, and records `penandatangan = "unsigned"` / the untrusted key id in the
//! lock. A signature that is present but malformed or does NOT verify is
//! refused even then: it is positive evidence that the archive is not what the
//! publisher signed.

use crate::error::{PkgError, Result};
use crate::integrity::hex_encode;
use crate::manifest::Manifest;
use crate::version::Version;
use riina_core::constant_time::ConstantTimeEq;
use riina_core::crypto::ed25519::{
    Ed25519SigningKey, Ed25519VerifyingKey, PUBLIC_KEY_SIZE, SECRET_KEY_SIZE, SIGNATURE_SIZE,
};
use riina_core::crypto::sha2::Sha256;
use riina_core::zeroize::Zeroize;
use std::collections::BTreeSet;
use std::fmt;
use std::io::Write;
use std::path::{Path, PathBuf};

/// Domain separator of the signed message.
pub const SIGNATURE_DOMAIN: &[u8] = b"RIINA-PKG-SIGNATURE-v1";
/// Prefix of a publisher key id.
pub const KEY_ID_PREFIX: &str = "ed25519:";
/// First line of a signature document.
pub const SIGNATURE_HEADER: &str = "riina-pkg-signature v1";
/// Lockfile / cache marker for a remote package accepted without a signature.
pub const UNSIGNED_MARKER: &str = "unsigned";
/// Largest signature document accepted from a registry.
pub const MAX_SIGNATURE_DOC_LEN: usize = 4096;
/// File name of the user-level trust list, under `~/.riina/`.
pub const USER_TRUST_FILE: &str = "trusted-publishers";

const PRIVATE_HEADER: &str = "RIINA PRIVATE KEY";
const PUBLIC_HEADER: &str = "RIINA PUBLIC KEY";
const ALGORITHM: &str = "Ed25519";

fn reject(name: &str, version: &Version, reason: impl Into<String>) -> PkgError {
    PkgError::SignatureRejected {
        name: name.to_string(),
        version: version.to_string(),
        reason: reason.into(),
    }
}

fn hex_decode_exact<const N: usize>(text: &str) -> Option<[u8; N]> {
    let bytes = text.as_bytes();
    if bytes.len() != 2 * N {
        return None;
    }
    let nibble = |c: u8| match c {
        b'0'..=b'9' => Some(c - b'0'),
        b'a'..=b'f' => Some(c - b'a' + 10),
        _ => None,
    };
    let mut out = [0u8; N];
    for (i, pair) in bytes.chunks_exact(2).enumerate() {
        out[i] = (nibble(pair[0])? << 4) | nibble(pair[1])?;
    }
    Some(out)
}

/// `lp(f1) ‖ lp(f2) ‖ …`
fn encode_fields(fields: &[&[u8]]) -> Vec<u8> {
    let mut out = Vec::with_capacity(fields.iter().map(|f| 8 + f.len()).sum());
    for field in fields {
        out.extend_from_slice(&(field.len() as u64).to_be_bytes());
        out.extend_from_slice(field);
    }
    out
}

/// The exact bytes a publisher signs for `name`/`version`/archive digest.
pub fn signing_message(name: &str, version: &Version, archive_sha256: &[u8; 32]) -> Vec<u8> {
    encode_fields(&[
        SIGNATURE_DOMAIN,
        name.as_bytes(),
        version.to_string().as_bytes(),
        archive_sha256,
    ])
}

/// SHA-256 of an archive (riina-core implementation).
pub fn archive_sha256(archive: &[u8]) -> [u8; 32] {
    Sha256::hash(archive)
}

// ── Publisher keys ──────────────────────────────────────────────────────

/// A publisher's Ed25519 public key (a valid curve point).
#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct PublisherKey([u8; PUBLIC_KEY_SIZE]);

impl PublisherKey {
    /// Wrap raw public-key bytes, rejecting non-points.
    pub fn from_bytes(bytes: [u8; PUBLIC_KEY_SIZE]) -> Result<Self> {
        Ed25519VerifyingKey::from_bytes(&bytes)
            .map_err(|_| PkgError::Other("publisher key is not a valid Ed25519 point".into()))?;
        Ok(Self(bytes))
    }

    /// Parse a key id `ed25519:<64 lowercase hex>`.
    pub fn parse(id: &str) -> Result<Self> {
        let hex = id.strip_prefix(KEY_ID_PREFIX).ok_or_else(|| {
            PkgError::Other(format!(
                "invalid publisher key id `{id}`: expected `{KEY_ID_PREFIX}<64 lowercase hex>`"
            ))
        })?;
        let bytes = hex_decode_exact::<PUBLIC_KEY_SIZE>(hex).ok_or_else(|| {
            PkgError::Other(format!(
                "invalid publisher key id `{id}`: expected `{KEY_ID_PREFIX}<64 lowercase hex>`"
            ))
        })?;
        Self::from_bytes(bytes)
    }

    /// The key id, `ed25519:<hex>`.
    pub fn id(&self) -> String {
        format!("{KEY_ID_PREFIX}{}", hex_encode(&self.0))
    }

    /// Raw public-key bytes.
    pub fn as_bytes(&self) -> &[u8; PUBLIC_KEY_SIZE] {
        &self.0
    }

    fn verifies(&self, message: &[u8], signature: &[u8; SIGNATURE_SIZE]) -> bool {
        Ed25519VerifyingKey::from_bytes(&self.0)
            .and_then(|key| key.verify(message, signature))
            .is_ok()
    }
}

impl fmt::Display for PublisherKey {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.id())
    }
}

impl fmt::Debug for PublisherKey {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "PublisherKey({})", self.id())
    }
}

/// A publisher's Ed25519 signing key. Secret material is scrubbed on drop
/// (by `riina-core`'s `Ed25519SigningKey`).
pub struct PublisherSigningKey {
    inner: Ed25519SigningKey,
}

impl PublisherSigningKey {
    /// Derive the key from its 32-byte seed.
    pub fn from_seed(seed: &[u8; SECRET_KEY_SIZE]) -> Self {
        Self {
            inner: Ed25519SigningKey::from_seed(seed),
        }
    }

    /// The matching public key.
    pub fn public_key(&self) -> PublisherKey {
        PublisherKey(*self.inner.public_key_bytes())
    }

    /// Sign `archive` as `name` `version`.
    pub fn sign_archive(&self, name: &str, version: &Version, archive: &[u8]) -> PackageSignature {
        let digest = archive_sha256(archive);
        let signature = self.inner.sign(&signing_message(name, version, &digest));
        PackageSignature {
            name: name.to_string(),
            version: version.clone(),
            archive_sha256: digest,
            signer: self.public_key(),
            signature,
        }
    }

    /// Load a private key file (`riinac pkg keygen` / `riina-artifact-sign
    /// keygen -a ed25519` format). Refuses a file readable by group/others.
    pub fn load(path: &Path) -> Result<Self> {
        check_private_key_mode(path)?;
        let mut text = std::fs::read_to_string(path).map_err(|e| PkgError::io(path, e))?;
        let parsed = parse_key_file(&text, PRIVATE_HEADER, path);
        text.zeroize_string();
        let mut seed_hex = parsed?;
        let seed = hex_decode_exact::<SECRET_KEY_SIZE>(&seed_hex);
        seed_hex.zeroize_string();
        let mut seed = seed.ok_or_else(|| {
            PkgError::Other(format!(
                "{}: Ed25519 private key must be {SECRET_KEY_SIZE} bytes of lowercase hex",
                path.display()
            ))
        })?;
        let key = Self::from_seed(&seed);
        seed.zeroize();
        Ok(key)
    }
}

/// Scrub a `String`'s bytes (best effort: the allocation is overwritten
/// before it is freed).
trait ZeroizeString {
    fn zeroize_string(&mut self);
}

impl ZeroizeString for String {
    fn zeroize_string(&mut self) {
        let mut bytes = std::mem::take(self).into_bytes();
        bytes.zeroize();
    }
}

#[cfg(unix)]
fn check_private_key_mode(path: &Path) -> Result<()> {
    use std::os::unix::fs::PermissionsExt;
    let mode = std::fs::metadata(path)
        .map_err(|e| PkgError::io(path, e))?
        .permissions()
        .mode();
    if mode & 0o077 != 0 {
        return Err(PkgError::Other(format!(
            "{}: private key is accessible by group/others (mode {:o}); run `chmod 600` on it",
            path.display(),
            mode & 0o777
        )));
    }
    Ok(())
}

#[cfg(not(unix))]
fn check_private_key_mode(_path: &Path) -> Result<()> {
    Ok(())
}

/// Extract the hex body of a `-----BEGIN <header>-----` key file whose
/// `Algorithm:` is Ed25519.
fn parse_key_file(text: &str, header: &str, path: &Path) -> Result<String> {
    let begin = format!("-----BEGIN {header}-----");
    let end = format!("-----END {header}-----");
    let bad = |what: &str| PkgError::Other(format!("{}: {what}", path.display()));
    let mut lines = text.lines().map(str::trim);
    if !lines.by_ref().any(|line| line == begin) {
        return Err(bad(&format!("missing `{begin}`")));
    }
    let mut algorithm = None;
    // Sized up front so a secret body is never copied by a reallocation.
    let mut body = String::with_capacity(text.len());
    let mut closed = false;
    for line in lines {
        if line == end {
            closed = true;
            break;
        }
        if let Some(alg) = line.strip_prefix("Algorithm:") {
            algorithm = Some(alg.trim().to_string());
        } else if !line.is_empty() {
            body.push_str(line);
        }
    }
    if !closed {
        body.zeroize_string();
        return Err(bad(&format!("missing `{end}`")));
    }
    if algorithm.as_deref() != Some(ALGORITHM) {
        body.zeroize_string();
        return Err(bad(&format!(
            "publisher keys must be `Algorithm: {ALGORITHM}`, found {:?}",
            algorithm.unwrap_or_default()
        )));
    }
    Ok(body)
}

/// Read a public key from a `.pub` file, or derive it from a `.priv` file.
pub fn read_public_key_file(path: &Path) -> Result<PublisherKey> {
    let mut text = std::fs::read_to_string(path).map_err(|e| PkgError::io(path, e))?;
    if text.contains(&format!("-----BEGIN {PRIVATE_HEADER}-----")) {
        text.zeroize_string();
        return Ok(PublisherSigningKey::load(path)?.public_key());
    }
    let hex = parse_key_file(&text, PUBLIC_HEADER, path)?;
    let bytes = hex_decode_exact::<PUBLIC_KEY_SIZE>(&hex).ok_or_else(|| {
        PkgError::Other(format!(
            "{}: Ed25519 public key must be {PUBLIC_KEY_SIZE} bytes of lowercase hex",
            path.display()
        ))
    })?;
    PublisherKey::from_bytes(bytes)
}

/// Create a key file that must not exist yet, with `mode` applied at
/// `open(2)` time (so a private key is never readable by others, not even
/// briefly).
fn create_new_file(path: &Path, mode: u32) -> Result<std::fs::File> {
    let mut opts = std::fs::OpenOptions::new();
    opts.write(true).create_new(true);
    #[cfg(unix)]
    {
        use std::os::unix::fs::OpenOptionsExt;
        opts.mode(mode);
    }
    #[cfg(not(unix))]
    let _ = mode;
    opts.open(path).map_err(|e| {
        if e.kind() == std::io::ErrorKind::AlreadyExists {
            PkgError::Other(format!(
                "{} already exists; refusing to overwrite (use --force)",
                path.display()
            ))
        } else {
            PkgError::io(path, e)
        }
    })
}

fn write_key_file(path: &Path, mode: u32, header: &str, key: &[u8]) -> Result<()> {
    let mut file = create_new_file(path, mode)?;
    let mut hex = hex_encode(key);
    let mut text = format!(
        "-----BEGIN {header}-----\nAlgorithm: {ALGORITHM}\n\n{hex}\n-----END {header}-----\n"
    );
    hex.zeroize_string();
    let written = file
        .write_all(text.as_bytes())
        .and_then(|()| file.sync_all());
    text.zeroize_string();
    written.map_err(|e| PkgError::io(path, e))
}

fn os_random_seed() -> Result<[u8; SECRET_KEY_SIZE]> {
    use std::io::Read;
    let mut seed = [0u8; SECRET_KEY_SIZE];
    std::fs::File::open("/dev/urandom")
        .and_then(|mut f| f.read_exact(&mut seed))
        .map_err(|e| {
            PkgError::Other(format!(
                "cannot read the OS random source /dev/urandom for key generation: {e}"
            ))
        })?;
    if seed.iter().all(|&b| b == 0) {
        return Err(PkgError::Other(
            "OS random source returned all zeroes".into(),
        ));
    }
    Ok(seed)
}

/// Paths and key id produced by [`generate_keypair`].
#[derive(Debug)]
pub struct GeneratedKeypair {
    /// `<base>.priv`, mode 0600.
    pub private_path: PathBuf,
    /// `<base>.pub`, mode 0644.
    pub public_path: PathBuf,
    /// The new public key.
    pub key: PublisherKey,
}

/// Generate a publisher keypair at `<base>.priv` (0600) and `<base>.pub`
/// (0644). Refuses to replace either file unless `force`; with `force` the old
/// files are removed and new inodes created (never truncated, which would keep
/// a lax old mode).
pub fn generate_keypair(base: &Path, force: bool) -> Result<GeneratedKeypair> {
    let private_path = PathBuf::from(format!("{}.priv", base.display()));
    let public_path = PathBuf::from(format!("{}.pub", base.display()));
    // Decide about BOTH files before writing either.
    for path in [&private_path, &public_path] {
        if std::fs::symlink_metadata(path).is_ok() {
            if !force {
                return Err(PkgError::Other(format!(
                    "{} already exists; refusing to overwrite (use --force)",
                    path.display()
                )));
            }
            std::fs::remove_file(path).map_err(|e| PkgError::io(path, e))?;
        }
    }
    let mut seed = os_random_seed()?;
    let signing = PublisherSigningKey::from_seed(&seed);
    let written = write_key_file(&private_path, 0o600, PRIVATE_HEADER, &seed);
    seed.zeroize();
    written?;
    let key = signing.public_key();
    write_key_file(&public_path, 0o644, PUBLIC_HEADER, key.as_bytes())?;
    Ok(GeneratedKeypair {
        private_path,
        public_path,
        key,
    })
}

// ── Signature documents ─────────────────────────────────────────────────

/// A publisher signature over one package archive.
#[derive(Clone, PartialEq, Eq)]
pub struct PackageSignature {
    /// Package name the publisher signed.
    pub name: String,
    /// Package version the publisher signed.
    pub version: Version,
    /// SHA-256 of the archive the publisher signed.
    pub archive_sha256: [u8; 32],
    /// The signing key.
    pub signer: PublisherKey,
    /// Ed25519 signature over [`signing_message`].
    pub signature: [u8; SIGNATURE_SIZE],
}

impl fmt::Debug for PackageSignature {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("PackageSignature")
            .field("name", &self.name)
            .field("version", &self.version.to_string())
            .field("archive_sha256", &hex_encode(&self.archive_sha256))
            .field("signer", &self.signer.id())
            .finish_non_exhaustive()
    }
}

impl PackageSignature {
    /// Render the signature document.
    pub fn render(&self) -> String {
        format!(
            "{SIGNATURE_HEADER}\nnama = \"{}\"\nversi = \"{}\"\narkib-sha256 = \"{}\"\n\
             penandatangan = \"{}\"\ntandatangan = \"{}\"\n",
            self.name,
            self.version,
            hex_encode(&self.archive_sha256),
            self.signer.id(),
            hex_encode(&self.signature),
        )
    }

    /// Strictly parse a signature document.
    pub fn parse(document: &[u8]) -> Result<Self> {
        let bad = |what: String| PkgError::Other(format!("malformed package signature: {what}"));
        if document.len() > MAX_SIGNATURE_DOC_LEN {
            return Err(bad(format!("larger than {MAX_SIGNATURE_DOC_LEN} bytes")));
        }
        let text = std::str::from_utf8(document).map_err(|_| bad("not UTF-8".into()))?;
        let mut lines = text
            .lines()
            .map(str::trim)
            .filter(|line| !line.is_empty() && !line.starts_with('#'));
        if lines.next() != Some(SIGNATURE_HEADER) {
            return Err(bad(format!("first line must be `{SIGNATURE_HEADER}`")));
        }
        const KEYS: [&str; 5] = [
            "nama",
            "versi",
            "arkib-sha256",
            "penandatangan",
            "tandatangan",
        ];
        let mut values: [Option<&str>; 5] = [None; 5];
        for line in lines {
            let (key, value) = line
                .split_once('=')
                .ok_or_else(|| bad(format!("expected `key = \"value\"`, got `{line}`")))?;
            let key = key.trim();
            let value = value.trim();
            let value = value
                .strip_prefix('"')
                .and_then(|v| v.strip_suffix('"'))
                .filter(|v| !v.contains('"'))
                .ok_or_else(|| bad(format!("value of `{key}` must be one quoted string")))?;
            let slot = KEYS
                .iter()
                .position(|k| *k == key)
                .ok_or_else(|| bad(format!("unknown key `{key}`")))?;
            if values[slot].replace(value).is_some() {
                return Err(bad(format!("duplicate key `{key}`")));
            }
        }
        let get = |i: usize| values[i].ok_or_else(|| bad(format!("missing key `{}`", KEYS[i])));
        let name = get(0)?.to_string();
        let version = Version::parse(get(1)?).map_err(|e| bad(e.to_string()))?;
        let archive_sha256 = hex_decode_exact::<32>(get(2)?)
            .ok_or_else(|| bad("`arkib-sha256` must be 64 lowercase hex digits".into()))?;
        let signer = PublisherKey::parse(get(3)?).map_err(|e| bad(e.to_string()))?;
        let signature = hex_decode_exact::<SIGNATURE_SIZE>(get(4)?)
            .ok_or_else(|| bad("`tandatangan` must be 128 lowercase hex digits".into()))?;
        Ok(Self {
            name,
            version,
            archive_sha256,
            signer,
            signature,
        })
    }

    /// Check that this signature is valid for `archive` served as `name`
    /// `version`. Does NOT consult the trust list.
    pub fn verify(&self, name: &str, version: &Version, archive: &[u8]) -> Result<()> {
        if self.name != name || &self.version != version {
            return Err(reject(
                name,
                version,
                format!(
                    "signature is for `{}` {}, not this package",
                    self.name, self.version
                ),
            ));
        }
        let digest = archive_sha256(archive);
        if !digest.ct_eq(&self.archive_sha256) {
            return Err(reject(
                name,
                version,
                "archive SHA-256 does not match the digest the publisher signed",
            ));
        }
        // Built from what we asked for and what we computed — never from the
        // document's own fields.
        if !self
            .signer
            .verifies(&signing_message(name, version, &digest), &self.signature)
        {
            return Err(reject(
                name,
                version,
                format!(
                    "publisher signature by {} does not verify; the archive is not \
                     what the publisher signed",
                    self.signer
                ),
            ));
        }
        Ok(())
    }
}

// ── Provenance and trust policy ─────────────────────────────────────────

/// Who vouches for a fetched package's bytes.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Provenance {
    /// The local filesystem registry: no publisher signature applies.
    Local,
    /// A valid signature by this key (trusted, or untrusted under the
    /// insecure opt-out).
    Signed(PublisherKey),
    /// A remote package with no signature, accepted only under the opt-out.
    Unsigned,
}

impl Provenance {
    /// The value recorded as `penandatangan` in `riina.lock` (`None` for a
    /// local package).
    pub fn lock_value(&self) -> Option<String> {
        match self {
            Self::Local => None,
            Self::Signed(key) => Some(key.id()),
            Self::Unsigned => Some(UNSIGNED_MARKER.to_string()),
        }
    }

    /// Parse a recorded `penandatangan` value (`ed25519:<hex>` or `unsigned`).
    pub fn from_recorded(value: &str) -> Result<Self> {
        if value == UNSIGNED_MARKER {
            Ok(Self::Unsigned)
        } else {
            PublisherKey::parse(value).map(Self::Signed)
        }
    }
}

/// The outcome of applying a [`TrustPolicy`]: accepted provenance plus, when
/// it was accepted only because of the insecure opt-out, a loud warning.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Verdict {
    /// How the package is vouched for.
    pub provenance: Provenance,
    /// Set when the package was accepted ONLY because of
    /// `--insecure-allow-unsigned`.
    pub warning: Option<String>,
}

/// Which publisher keys are trusted, and whether the insecure opt-out is on.
/// The default trusts nothing and refuses every remote package.
#[derive(Clone, Debug, Default)]
pub struct TrustPolicy {
    trusted: BTreeSet<PublisherKey>,
    allow_insecure: bool,
}

/// Default user-level trust file: `~/.riina/trusted-publishers`.
pub fn user_trust_file() -> Option<PathBuf> {
    std::env::var("HOME")
        .or_else(|_| std::env::var("USERPROFILE"))
        .ok()
        .map(|home| PathBuf::from(home).join(".riina").join(USER_TRUST_FILE))
}

/// The banner printed once when `--insecure-allow-unsigned` is given.
pub const INSECURE_BANNER: &str = "WARNING: --insecure-allow-unsigned is set: packages from a \
remote registry will be accepted WITHOUT a trusted publisher signature. Their contents are NOT \
authenticated; a compromised registry or network path can substitute arbitrary code.";

impl TrustPolicy {
    /// A policy trusting exactly `trusted`.
    pub fn new(trusted: impl IntoIterator<Item = PublisherKey>, allow_insecure: bool) -> Self {
        Self {
            trusted: trusted.into_iter().collect(),
            allow_insecure,
        }
    }

    /// Load the trust list from the ROOT project manifest's
    /// `[registry] trusted-publishers` and the user file (if it exists).
    pub fn load(
        root_manifest: Option<&Manifest>,
        user_file: Option<&Path>,
        allow_insecure: bool,
    ) -> Result<Self> {
        let mut trusted = BTreeSet::new();
        if let Some(manifest) = root_manifest {
            for id in &manifest.trusted_publishers {
                let key = PublisherKey::parse(id).map_err(|e| {
                    PkgError::Other(format!("riina.toml [registry] trusted-publishers: {e}"))
                })?;
                trusted.insert(key);
            }
        }
        if let Some(path) = user_file {
            trusted.extend(read_trust_file(path)?);
        }
        Ok(Self {
            trusted,
            allow_insecure,
        })
    }

    /// Whether `key` is trusted.
    pub fn is_trusted(&self, key: &PublisherKey) -> bool {
        self.trusted.contains(key)
    }

    /// Whether the insecure opt-out is on.
    pub fn allows_insecure(&self) -> bool {
        self.allow_insecure
    }

    /// Decide on a freshly downloaded `archive` and the registry's signature
    /// document (`None` when the registry has none).
    pub fn check_download(
        &self,
        name: &str,
        version: &Version,
        archive: &[u8],
        signature_document: Option<&[u8]>,
    ) -> Result<Verdict> {
        match signature_document {
            None => self.check_unsigned(name, version),
            Some(document) => {
                // Malformed or invalid: refused even under the opt-out.
                let signature = PackageSignature::parse(document)
                    .map_err(|e| reject(name, version, e.to_string()))?;
                signature.verify(name, version, archive)?;
                self.check_signer(name, version, signature.signer)
            }
        }
    }

    /// Re-apply the policy to the provenance recorded when a package was
    /// cached (the trust list or the opt-out may have changed since).
    pub fn check_recorded(
        &self,
        name: &str,
        version: &Version,
        recorded: &Provenance,
    ) -> Result<Verdict> {
        match recorded {
            Provenance::Signed(key) => self.check_signer(name, version, *key),
            Provenance::Unsigned => self.check_unsigned(name, version),
            Provenance::Local => Err(reject(
                name,
                version,
                "cached remote package has no recorded signature; run `riinac pkg clean`",
            )),
        }
    }

    fn check_signer(&self, name: &str, version: &Version, key: PublisherKey) -> Result<Verdict> {
        if self.is_trusted(&key) {
            return Ok(Verdict {
                provenance: Provenance::Signed(key),
                warning: None,
            });
        }
        if self.allow_insecure {
            return Ok(Verdict {
                provenance: Provenance::Signed(key),
                warning: Some(format!(
                    "WARNING: INSECURE: accepting `{name}` {version} signed by UNTRUSTED key {key} \
                     because of --insecure-allow-unsigned; trust that key only after verifying it \
                     with the publisher out of band"
                )),
            });
        }
        Err(reject(
            name,
            version,
            format!(
                "signed by {key}, which is not a trusted publisher. If you have verified this \
                 key with the publisher out of band, add it to `trusted-publishers` under \
                 [registry] in riina.toml or to ~/.riina/{USER_TRUST_FILE}"
            ),
        ))
    }

    fn check_unsigned(&self, name: &str, version: &Version) -> Result<Verdict> {
        if self.allow_insecure {
            return Ok(Verdict {
                provenance: Provenance::Unsigned,
                warning: Some(format!(
                    "WARNING: INSECURE: accepting UNSIGNED package `{name}` {version} from a \
                     remote registry because of --insecure-allow-unsigned; its contents are NOT \
                     authenticated"
                )),
            });
        }
        Err(reject(
            name,
            version,
            "the remote registry has no publisher signature for it; refusing unauthenticated \
             code. Ask the publisher to sign it (`riinac pkg publish --key <file.priv>`), or \
             pass --insecure-allow-unsigned to accept it anyway",
        ))
    }
}

/// Read a user trust file: one key id per line, `#` comments. A missing file
/// is an empty list; an unreadable, malformed or group/world-writable file is
/// an error.
pub fn read_trust_file(path: &Path) -> Result<Vec<PublisherKey>> {
    let text = match std::fs::read_to_string(path) {
        Ok(text) => text,
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => return Ok(Vec::new()),
        Err(e) => return Err(PkgError::io(path, e)),
    };
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let mode = std::fs::metadata(path)
            .map_err(|e| PkgError::io(path, e))?
            .permissions()
            .mode();
        if mode & 0o022 != 0 {
            return Err(PkgError::Other(format!(
                "{}: trust file is writable by group/others (mode {:o}); refusing it \
                 (run `chmod go-w` on it)",
                path.display(),
                mode & 0o777
            )));
        }
    }
    let mut keys = Vec::new();
    for (index, line) in text.lines().enumerate() {
        let entry = line.split('#').next().unwrap_or("").trim();
        if entry.is_empty() {
            continue;
        }
        keys.push(
            PublisherKey::parse(entry)
                .map_err(|e| PkgError::Other(format!("{}:{}: {e}", path.display(), index + 1)))?,
        );
    }
    Ok(keys)
}

#[cfg(test)]
mod tests {
    use super::*;

    pub(crate) fn test_key(byte: u8) -> PublisherSigningKey {
        PublisherSigningKey::from_seed(&[byte; SECRET_KEY_SIZE])
    }

    fn v(s: &str) -> Version {
        Version::parse(s).unwrap()
    }

    const ARCHIVE: &[u8] = b"pretend this is a ustar archive";

    fn trusting(key: &PublisherSigningKey) -> TrustPolicy {
        TrustPolicy::new([key.public_key()], false)
    }

    struct Scratch(PathBuf);
    impl Scratch {
        fn new(tag: &str) -> Self {
            let path =
                std::env::temp_dir().join(format!("riina_signing_{tag}_{}", std::process::id()));
            let _ = std::fs::remove_dir_all(&path);
            std::fs::create_dir_all(&path).unwrap();
            Self(path)
        }
    }
    impl Drop for Scratch {
        fn drop(&mut self) {
            let _ = std::fs::remove_dir_all(&self.0);
        }
    }

    #[test]
    fn valid_signature_from_trusted_key_is_accepted() {
        let key = test_key(1);
        let doc = key.sign_archive("foo", &v("1.0.0"), ARCHIVE).render();
        let verdict = trusting(&key)
            .check_download("foo", &v("1.0.0"), ARCHIVE, Some(doc.as_bytes()))
            .unwrap();
        assert_eq!(verdict.provenance, Provenance::Signed(key.public_key()));
        assert_eq!(verdict.warning, None);
    }

    #[test]
    fn tampered_archive_is_rejected_even_under_opt_out() {
        let key = test_key(1);
        let doc = key.sign_archive("foo", &v("1.0.0"), ARCHIVE).render();
        let mut tampered = ARCHIVE.to_vec();
        tampered[0] ^= 1;
        for policy in [trusting(&key), TrustPolicy::new([key.public_key()], true)] {
            let res = policy.check_download("foo", &v("1.0.0"), &tampered, Some(doc.as_bytes()));
            assert!(
                matches!(&res, Err(PkgError::SignatureRejected { reason, .. }) if reason.contains("SHA-256")),
                "{res:?}"
            );
        }
        // Also with the document's digest rewritten to match the tampered
        // archive: the Ed25519 signature no longer verifies.
        let mut forged = key.sign_archive("foo", &v("1.0.0"), ARCHIVE);
        forged.archive_sha256 = archive_sha256(&tampered);
        let res = trusting(&key).check_download(
            "foo",
            &v("1.0.0"),
            &tampered,
            Some(forged.render().as_bytes()),
        );
        assert!(
            matches!(&res, Err(PkgError::SignatureRejected { reason, .. }) if reason.contains("does not verify")),
            "{res:?}"
        );
    }

    #[test]
    fn signature_for_another_name_or_version_is_rejected() {
        let key = test_key(1);
        let policy = trusting(&key);
        let signed = key.sign_archive("foo", &v("1.0.0"), ARCHIVE);

        // Presented unchanged for a different version / name.
        let doc = signed.render();
        assert!(policy
            .check_download("foo", &v("1.0.1"), ARCHIVE, Some(doc.as_bytes()))
            .is_err());
        assert!(policy
            .check_download("bar", &v("1.0.0"), ARCHIVE, Some(doc.as_bytes()))
            .is_err());

        // Document fields rewritten to claim the other version / name: the
        // message is built from what was requested, so the signature fails.
        let mut relabelled = signed.clone();
        relabelled.version = v("1.0.1");
        let res = policy.check_download(
            "foo",
            &v("1.0.1"),
            ARCHIVE,
            Some(relabelled.render().as_bytes()),
        );
        assert!(
            matches!(&res, Err(PkgError::SignatureRejected { reason, .. }) if reason.contains("does not verify")),
            "{res:?}"
        );
        let mut renamed = signed;
        renamed.name = "bar".into();
        assert!(policy
            .check_download(
                "bar",
                &v("1.0.0"),
                ARCHIVE,
                Some(renamed.render().as_bytes())
            )
            .is_err());
    }

    #[test]
    fn untrusted_key_is_rejected_and_opt_out_warns() {
        let publisher = test_key(1);
        let attacker = test_key(2);
        let doc = attacker.sign_archive("foo", &v("1.0.0"), ARCHIVE).render();
        let res =
            trusting(&publisher).check_download("foo", &v("1.0.0"), ARCHIVE, Some(doc.as_bytes()));
        assert!(
            matches!(&res, Err(PkgError::SignatureRejected { reason, .. }) if reason.contains("not a trusted publisher")),
            "{res:?}"
        );
        // Nothing trusted at all (the default) also refuses.
        assert!(TrustPolicy::default()
            .check_download("foo", &v("1.0.0"), ARCHIVE, Some(doc.as_bytes()))
            .is_err());
        // The opt-out accepts it, records the key, and warns.
        let verdict = TrustPolicy::new([publisher.public_key()], true)
            .check_download("foo", &v("1.0.0"), ARCHIVE, Some(doc.as_bytes()))
            .unwrap();
        assert_eq!(
            verdict.provenance,
            Provenance::Signed(attacker.public_key())
        );
        assert!(verdict.warning.unwrap().contains("UNTRUSTED"));
    }

    #[test]
    fn missing_signature_is_rejected_and_opt_out_warns() {
        let key = test_key(1);
        let res = trusting(&key).check_download("foo", &v("1.0.0"), ARCHIVE, None);
        assert!(
            matches!(&res, Err(PkgError::SignatureRejected { reason, .. }) if reason.contains("no publisher signature")),
            "{res:?}"
        );
        let verdict = TrustPolicy::new([], true)
            .check_download("foo", &v("1.0.0"), ARCHIVE, None)
            .unwrap();
        assert_eq!(verdict.provenance, Provenance::Unsigned);
        assert_eq!(
            verdict.provenance.lock_value().as_deref(),
            Some(UNSIGNED_MARKER)
        );
        let warning = verdict.warning.unwrap();
        assert!(warning.contains("INSECURE") && warning.contains("UNSIGNED"));
    }

    #[test]
    fn recorded_provenance_is_rechecked_against_current_policy() {
        let key = test_key(1);
        let signed = Provenance::Signed(key.public_key());
        assert!(trusting(&key)
            .check_recorded("foo", &v("1.0.0"), &signed)
            .is_ok());
        // Key removed from the trust list since the package was cached.
        assert!(TrustPolicy::default()
            .check_recorded("foo", &v("1.0.0"), &signed)
            .is_err());
        // An unsigned cached package needs the opt-out on every use.
        assert!(trusting(&key)
            .check_recorded("foo", &v("1.0.0"), &Provenance::Unsigned)
            .is_err());
        assert!(TrustPolicy::new([], true)
            .check_recorded("foo", &v("1.0.0"), &Provenance::Unsigned)
            .unwrap()
            .warning
            .is_some());
    }

    #[test]
    fn malformed_signature_documents_are_rejected_even_under_opt_out() {
        let key = test_key(1);
        let good = key.sign_archive("foo", &v("1.0.0"), ARCHIVE).render();
        let policy = TrustPolicy::new([key.public_key()], true);
        let duplicate = good.replace("versi = \"1.0.0\"", "versi = \"1.0.0\"\nversi = \"1.0.0\"");
        let unknown = format!("{good}extra = \"1\"\n");
        let no_header = good.replacen(SIGNATURE_HEADER, "", 1);
        let upper = good.replace(
            &key.public_key().id(),
            &key.public_key().id().to_uppercase(),
        );
        let missing = good
            .lines()
            .filter(|l| !l.starts_with("tandatangan"))
            .collect::<Vec<_>>()
            .join("\n");
        let huge = format!("{good}#{}\n", "x".repeat(MAX_SIGNATURE_DOC_LEN));
        for doc in [
            duplicate,
            unknown,
            no_header,
            upper,
            missing,
            huge,
            "<html>".into(),
        ] {
            assert!(
                policy
                    .check_download("foo", &v("1.0.0"), ARCHIVE, Some(doc.as_bytes()))
                    .is_err(),
                "accepted malformed document:\n{doc}"
            );
        }
    }

    #[test]
    fn signature_document_roundtrips() {
        let signed = test_key(3).sign_archive("foo", &v("2.1.0"), ARCHIVE);
        assert_eq!(
            PackageSignature::parse(signed.render().as_bytes()).unwrap(),
            signed
        );
    }

    /// Pins the signed-message encoding and (Ed25519 being deterministic) a
    /// signature. Expected values from Python `cryptography` (OpenSSL)
    /// Ed25519 with seed = 32 x 0x07, independent of riina-core.
    #[test]
    fn known_answer_message_and_signature() {
        let digest = archive_sha256(b"abc");
        let msg = signing_message("foo", &v("1.2.3"), &digest);
        assert_eq!(
            hex_encode(&msg),
            concat!(
                "0000000000000016",
                "5249494e412d504b472d5349474e41545552452d7631",
                "0000000000000003",
                "666f6f",
                "0000000000000005",
                "312e322e33",
                "0000000000000020",
                "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
            )
        );
        let key = test_key(7);
        assert_eq!(key.public_key().id(), KAT_KEY_ID);
        let signed = key.sign_archive("foo", &v("1.2.3"), b"abc");
        assert_eq!(hex_encode(&signed.signature), KAT_SIGNATURE);
    }

    const KAT_KEY_ID: &str =
        "ed25519:ea4a6c63e29c520abef5507b132ec5f9954776aebebe7b92421eea691446d22c";
    const KAT_SIGNATURE: &str = concat!(
        "aceb9cad05ac4718c477bb76dd1162969f39c6f7c52cb5dcc96a5918a6126235",
        "63f5582db2120b14a2feb3898568611dc2a7794f742efa8b316b8dab310e3708"
    );

    #[test]
    fn key_ids_parse_strictly() {
        let id = test_key(1).public_key().id();
        assert_eq!(PublisherKey::parse(&id).unwrap().id(), id);
        for bad in [
            id.trim_start_matches(KEY_ID_PREFIX).to_string(),
            format!("rsa:{}", &id[KEY_ID_PREFIX.len()..]),
            id[..id.len() - 2].to_string(),
            id.to_uppercase(),
            format!("{id} "),
        ] {
            assert!(PublisherKey::parse(&bad).is_err(), "accepted {bad:?}");
        }
    }

    #[cfg(unix)]
    #[test]
    fn keygen_creates_owner_only_private_key_and_never_overwrites() {
        use std::os::unix::fs::PermissionsExt;
        let tmp = Scratch::new("keygen");
        let base = tmp.0.join("publisher");
        let first = generate_keypair(&base, false).unwrap();
        let mode = |p: &Path| std::fs::metadata(p).unwrap().permissions().mode() & 0o777;
        assert_eq!(mode(&first.private_path), 0o600);
        assert_eq!(mode(&first.public_path), 0o644);
        assert_eq!(read_public_key_file(&first.public_path).unwrap(), first.key);
        assert_eq!(
            read_public_key_file(&first.private_path).unwrap(),
            first.key
        );
        let loaded = PublisherSigningKey::load(&first.private_path).unwrap();
        assert_eq!(loaded.public_key(), first.key);

        // No overwrite without --force; both files left intact.
        let before = std::fs::read(&first.private_path).unwrap();
        assert!(generate_keypair(&base, false).is_err());
        assert_eq!(std::fs::read(&first.private_path).unwrap(), before);

        // --force replaces a lax pre-existing file with a fresh 0600 inode.
        std::fs::set_permissions(&first.private_path, std::fs::Permissions::from_mode(0o644))
            .unwrap();
        // ... and a lax private key is refused when loaded.
        assert!(PublisherSigningKey::load(&first.private_path).is_err());
        let second = generate_keypair(&base, true).unwrap();
        assert_eq!(mode(&second.private_path), 0o600);
        assert_ne!(second.key, first.key);
    }

    #[test]
    fn artifact_sign_key_files_are_accepted() {
        // The exact layout `riina-artifact-sign keygen -a ed25519` writes.
        let tmp = Scratch::new("compat");
        let path = tmp.0.join("k.priv");
        let seed_hex = "07".repeat(32);
        std::fs::write(
            &path,
            format!(
                "-----BEGIN RIINA PRIVATE KEY-----\nAlgorithm: Ed25519\n\n{seed_hex}\n\
                 -----END RIINA PRIVATE KEY-----\n"
            ),
        )
        .unwrap();
        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            std::fs::set_permissions(&path, std::fs::Permissions::from_mode(0o600)).unwrap();
        }
        assert_eq!(
            PublisherSigningKey::load(&path).unwrap().public_key(),
            test_key(7).public_key()
        );
        // An ML-DSA key file is not a publisher key.
        let mldsa = tmp.0.join("m.pub");
        std::fs::write(
            &mldsa,
            "-----BEGIN RIINA PUBLIC KEY-----\nAlgorithm: ML-DSA-65\n\n00\n-----END RIINA PUBLIC KEY-----\n",
        )
        .unwrap();
        assert!(read_public_key_file(&mldsa).is_err());
    }

    #[test]
    fn trust_sources_are_merged_and_validated() {
        let tmp = Scratch::new("trust");
        let a = test_key(1).public_key();
        let b = test_key(2).public_key();
        let manifest = Manifest::parse(
            &format!(
                "[pakej]\nnama = \"app\"\nversi = \"0.1.0\"\n\n[registry]\n\
                 trusted-publishers = [\"{}\"]\n",
                a.id()
            ),
            Path::new("riina.toml"),
        )
        .unwrap();
        let user = tmp.0.join(USER_TRUST_FILE);
        std::fs::write(&user, format!("# team key\n{}  # laptop\n\n", b.id())).unwrap();
        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            std::fs::set_permissions(&user, std::fs::Permissions::from_mode(0o644)).unwrap();
        }
        let policy = TrustPolicy::load(Some(&manifest), Some(&user), false).unwrap();
        assert!(policy.is_trusted(&a) && policy.is_trusted(&b));
        assert!(!policy.is_trusted(&test_key(3).public_key()));
        // Missing user file: just the manifest's keys.
        let only = TrustPolicy::load(Some(&manifest), Some(&tmp.0.join("absent")), false).unwrap();
        assert!(only.is_trusted(&a) && !only.is_trusted(&b));

        // Malformed entries are errors, not silently ignored.
        std::fs::write(&user, "ed25519:nothex\n").unwrap();
        assert!(TrustPolicy::load(None, Some(&user), false).is_err());
        let bad_manifest = Manifest::parse(
            "[pakej]\nnama = \"app\"\nversi = \"0.1.0\"\n\n[registry]\ntrusted-publishers = [\"x\"]\n",
            Path::new("riina.toml"),
        )
        .unwrap();
        assert!(TrustPolicy::load(Some(&bad_manifest), None, false).is_err());

        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            std::fs::write(&user, format!("{}\n", b.id())).unwrap();
            std::fs::set_permissions(&user, std::fs::Permissions::from_mode(0o666)).unwrap();
            assert!(TrustPolicy::load(None, Some(&user), false).is_err());
        }
    }
}
