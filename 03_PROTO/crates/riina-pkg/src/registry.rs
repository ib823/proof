// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Package registry: trait + filesystem-based implementation.

use crate::error::{PkgError, Result};
use crate::manifest::Manifest;
use crate::signing::{Provenance, PublisherSigningKey, TrustPolicy};
use crate::version::Version;
use std::cell::RefCell;
use std::collections::BTreeMap;
use std::path::{Path, PathBuf};

/// A package registry that can list versions and retrieve packages.
pub trait Registry {
    /// List all available versions of a package, sorted ascending.
    fn list_versions(&self, name: &str) -> Result<Vec<Version>>;

    /// Get the manifest for a specific package version.
    fn get_manifest(&self, name: &str, version: &Version) -> Result<Manifest>;

    /// Get the root path for an installed package version.
    fn package_path(&self, name: &str, version: &Version) -> PathBuf;

    /// Fetch a complete package and report who vouches for its bytes.
    ///
    /// Deliberately has no default: a REMOTE implementation must enforce its
    /// publisher-signature policy here (see [`crate::signing`]) and must not
    /// inherit a local, unchecked fetch by accident.
    fn fetch_verified(&self, name: &str, version: &Version) -> Result<(PathBuf, Provenance)>;

    /// Fetch a complete package, propagating download, extraction and
    /// signature-policy failures.
    fn fetch_package(&self, name: &str, version: &Version) -> Result<PathBuf> {
        self.fetch_verified(name, version).map(|(path, _)| path)
    }

    /// Check if a package version exists.
    fn exists(&self, name: &str, version: &Version) -> bool;
}

pub(crate) fn validate_package_name(name: &str) -> Result<()> {
    if name.is_empty()
        || !name
            .chars()
            .all(|c| c.is_alphanumeric() || c == '-' || c == '_')
    {
        return Err(PkgError::Other(format!("invalid package name: {name}")));
    }
    Ok(())
}

/// Fetch from a registry whose packages are local files: check the name and
/// the manifest identity. No publisher signature applies.
fn fetch_local(
    registry: &dyn Registry,
    name: &str,
    version: &Version,
) -> Result<(PathBuf, Provenance)> {
    validate_package_name(name)?;
    let path = registry.package_path(name, version);
    let manifest = Manifest::from_file(&path.join("riina.toml"))?;
    validate_package_identity(&manifest, name, version)?;
    Ok((path, Provenance::Local))
}

pub(crate) fn validate_package_identity(
    manifest: &Manifest,
    name: &str,
    version: &Version,
) -> Result<()> {
    if manifest.package.name != name || &manifest.package.version != version {
        return Err(PkgError::Other(format!(
            "package manifest identity does not match {name} {version}"
        )));
    }
    Ok(())
}

/// Filesystem-based registry.
///
/// Layout: `<root>/<name>/<version>/riina.toml`
pub struct FsRegistry {
    root: PathBuf,
}

impl FsRegistry {
    pub fn new(root: impl Into<PathBuf>) -> Self {
        Self { root: root.into() }
    }

    pub fn root(&self) -> &Path {
        &self.root
    }

    /// Publish a package directory to the registry.
    pub fn publish(&self, name: &str, version: &Version, source_dir: &Path) -> Result<()> {
        validate_package_name(name)?;
        let dest = self.package_path(name, version);
        if dest.exists() {
            return Err(PkgError::AlreadyPublished {
                name: name.to_string(),
                version: version.to_string(),
            });
        }
        copy_dir_recursive(source_dir, &dest)?;
        Ok(())
    }
}

impl Registry for FsRegistry {
    fn list_versions(&self, name: &str) -> Result<Vec<Version>> {
        validate_package_name(name)?;
        let pkg_dir = self.root.join(name);
        if !pkg_dir.is_dir() {
            return Ok(Vec::new());
        }
        let mut versions = Vec::new();
        let entries = std::fs::read_dir(&pkg_dir).map_err(|e| PkgError::io(&pkg_dir, e))?;
        for entry in entries {
            let entry = entry.map_err(|e| PkgError::io(&pkg_dir, e))?;
            if entry.path().is_dir() {
                if let Some(name) = entry.file_name().to_str() {
                    if let Ok(v) = Version::parse(name) {
                        versions.push(v);
                    }
                }
            }
        }
        versions.sort();
        Ok(versions)
    }

    fn get_manifest(&self, name: &str, version: &Version) -> Result<Manifest> {
        validate_package_name(name)?;
        let path = self.package_path(name, version).join("riina.toml");
        Manifest::from_file(&path)
    }

    fn package_path(&self, name: &str, version: &Version) -> PathBuf {
        self.root.join(name).join(version.to_string())
    }

    fn fetch_verified(&self, name: &str, version: &Version) -> Result<(PathBuf, Provenance)> {
        fetch_local(self, name, version)
    }

    fn exists(&self, name: &str, version: &Version) -> bool {
        if validate_package_name(name).is_err() {
            return false;
        }
        self.package_path(name, version)
            .join("riina.toml")
            .is_file()
    }
}

fn copy_dir_recursive(src: &Path, dst: &Path) -> Result<()> {
    std::fs::create_dir_all(dst).map_err(|e| PkgError::io(dst, e))?;
    let entries = std::fs::read_dir(src).map_err(|e| PkgError::io(src, e))?;
    for entry in entries {
        let entry = entry.map_err(|e| PkgError::io(src, e))?;
        let ty = entry
            .file_type()
            .map_err(|e| PkgError::io(entry.path(), e))?;
        let dest_path = dst.join(entry.file_name());
        if ty.is_dir() {
            copy_dir_recursive(&entry.path(), &dest_path)?;
        } else {
            std::fs::copy(entry.path(), &dest_path).map_err(|e| PkgError::io(&dest_path, e))?;
        }
    }
    Ok(())
}

/// HTTP-based remote package registry.
///
/// Fetches packages from a remote server over plain HTTP.
/// **HTTPS is not supported** — deploy the registry server behind a
/// TLS-terminating reverse proxy for encrypted transport.
///
/// Every package fetched from it must pass the [`TrustPolicy`] (a valid
/// Ed25519 signature by a trusted publisher, see [`crate::signing`]). The
/// default policy trusts nothing, so an unconfigured `HttpRegistry` refuses
/// every package.
///
/// API endpoints:
/// - `GET  /api/v1/crates/{name}/versions`         → JSON version list
/// - `GET  /api/v1/crates/{name}/{version}/manifest` → TOML manifest
/// - `GET  /api/v1/crates/{name}/{version}/download`  → tar archive
/// - `GET  /api/v1/crates/{name}/{version}/signature` → signature document
///   (`404` = unsigned)
/// - `HEAD /api/v1/crates/{name}/{version}/manifest` → existence check
/// - `POST /api/v1/crates/new?name=&version=[&sha256=&signer=&signature=]`
///   → publish tarball; the optional parameters carry the publisher
///   signature (`sha256` and `signature` in lowercase hex, `signer` a key
///   id), from which the registry serves the signature document.
///
/// Cache layout: `<cache>/<name>/<version>/verified/{package/,provenance}`,
/// installed by one atomic rename, so a package is never visible without the
/// record of who signed it.
pub struct HttpRegistry {
    base_url: String,
    cache_dir: PathBuf,
    policy: TrustPolicy,
    warnings: RefCell<Vec<String>>,
}

impl HttpRegistry {
    pub fn new(base_url: impl Into<String>, cache_dir: impl Into<PathBuf>) -> Self {
        let mut url = base_url.into();
        // Strip trailing slash for consistent URL construction
        while url.ends_with('/') {
            url.pop();
        }
        Self {
            base_url: url,
            cache_dir: cache_dir.into(),
            policy: TrustPolicy::default(),
            warnings: RefCell::new(Vec::new()),
        }
    }

    /// Use `policy` to decide which packages to accept.
    #[must_use]
    pub fn with_trust_policy(mut self, policy: TrustPolicy) -> Self {
        self.policy = policy;
        self
    }

    /// Insecure-opt-out warnings issued so far (each is also printed to
    /// stderr when issued).
    pub fn warnings(&self) -> Vec<String> {
        self.warnings.borrow().clone()
    }

    /// Publish a package to the remote registry, signed with `key` when given
    /// (the CLI only publishes unsigned under `--insecure-allow-unsigned`).
    pub fn publish(
        &self,
        name: &str,
        version: &Version,
        source_dir: &Path,
        key: Option<&PublisherSigningKey>,
    ) -> Result<()> {
        validate_package_name(name)?;
        let archive = crate::tarball::pack(source_dir)?;
        let mut url = format!(
            "{}/api/v1/crates/new?name={}&version={}",
            self.base_url, name, version,
        );
        if let Some(key) = key {
            let signed = key.sign_archive(name, version, &archive);
            // Self-check before anything leaves the machine.
            signed.verify(name, version, &archive)?;
            url.push_str(&format!(
                "&sha256={}&signer={}&signature={}",
                crate::integrity::hex_encode(&signed.archive_sha256),
                signed.signer.id(),
                crate::integrity::hex_encode(&signed.signature),
            ));
        }
        let resp = crate::http::post(&url, "application/x-tar", &archive)?;

        if resp.status >= 400 {
            return Err(PkgError::Http {
                url,
                status: resp.status,
                message: String::from_utf8_lossy(&resp.body).into_owned(),
            });
        }
        Ok(())
    }
}

impl Registry for HttpRegistry {
    fn list_versions(&self, name: &str) -> Result<Vec<Version>> {
        validate_package_name(name)?;
        let url = format!("{}/api/v1/crates/{}/versions", self.base_url, name);
        let resp = crate::http::get(&url)?;

        if resp.status == 404 {
            return Ok(Vec::new());
        }
        if resp.status >= 400 {
            return Err(PkgError::Http {
                url,
                status: resp.status,
                message: String::from_utf8_lossy(&resp.body).into_owned(),
            });
        }

        let body = String::from_utf8_lossy(&resp.body);
        let version_strings = parse_json_version_list(&body)?;
        let mut versions = Vec::new();
        for s in version_strings {
            versions.push(Version::parse(&s)?);
        }
        versions.sort();
        Ok(versions)
    }

    fn get_manifest(&self, name: &str, version: &Version) -> Result<Manifest> {
        validate_package_name(name)?;
        let url = format!(
            "{}/api/v1/crates/{}/{}/manifest",
            self.base_url, name, version,
        );
        let resp = crate::http::get(&url)?;

        if resp.status >= 400 {
            return Err(PkgError::Http {
                url,
                status: resp.status,
                message: String::from_utf8_lossy(&resp.body).into_owned(),
            });
        }

        let toml = String::from_utf8_lossy(&resp.body);
        let virtual_path = PathBuf::from(format!("<http>/{name}/{version}/riina.toml"));
        Manifest::parse(&toml, &virtual_path)
    }

    fn package_path(&self, name: &str, version: &Version) -> PathBuf {
        self.entry_dir(name, version).join("package")
    }

    fn fetch_verified(&self, name: &str, version: &Version) -> Result<(PathBuf, Provenance)> {
        validate_package_name(name)?;
        let entry = self.entry_dir(name, version);
        let local = entry.join("package");
        let verdict = if local.exists() {
            // Verified when it was installed; re-apply today's policy (the
            // trust list or the opt-out may have changed since).
            let recorded = read_provenance(&entry.join("provenance"))?;
            self.policy.check_recorded(name, version, &recorded)?
        } else {
            let (archive, signature) = self.download(name, version)?;
            // The signature is checked BEFORE a single byte is unpacked.
            let verdict =
                self.policy
                    .check_download(name, version, &archive, signature.as_deref())?;
            self.install_archive(name, version, &archive, &verdict.provenance, &entry)?;
            verdict
        };
        if let Some(warning) = verdict.warning {
            eprintln!("{warning}");
            self.warnings.borrow_mut().push(warning);
        }
        let manifest = Manifest::from_file(&local.join("riina.toml"))?;
        validate_package_identity(&manifest, name, version)?;
        Ok((local, verdict.provenance))
    }

    fn exists(&self, name: &str, version: &Version) -> bool {
        // Check local cache first
        if validate_package_name(name).is_err() {
            return false;
        }
        let local = self.package_path(name, version);
        if local.join("riina.toml").is_file() {
            return true;
        }
        // HEAD request to remote
        let url = format!(
            "{}/api/v1/crates/{}/{}/manifest",
            self.base_url, name, version,
        );
        crate::http::head(&url)
            .map(|r| r.status == 200)
            .unwrap_or(false)
    }
}

impl HttpRegistry {
    /// Cache entry for one package version. The `verified` leaf distinguishes
    /// signature-checked installs from caches written by older clients
    /// (`.../package`), which are never trusted.
    fn entry_dir(&self, name: &str, version: &Version) -> PathBuf {
        self.cache_dir
            .join(name)
            .join(version.to_string())
            .join("verified")
    }

    /// Download a package archive and its signature document (`None` when the
    /// registry answers 404 for the signature).
    fn download(&self, name: &str, version: &Version) -> Result<(Vec<u8>, Option<Vec<u8>>)> {
        let url = format!(
            "{}/api/v1/crates/{}/{}/download",
            self.base_url, name, version,
        );
        let resp = crate::http::get(&url)?;
        if resp.status >= 400 {
            return Err(PkgError::Http {
                url,
                status: resp.status,
                message: String::from_utf8_lossy(&resp.body).into_owned(),
            });
        }
        let archive = resp.body;

        let url = format!(
            "{}/api/v1/crates/{}/{}/signature",
            self.base_url, name, version,
        );
        let resp = crate::http::get(&url)?;
        let signature = match resp.status {
            404 => None,
            200 => Some(resp.body),
            status => {
                // Not "unsigned": an error must not downgrade to the opt-out path.
                return Err(PkgError::Http {
                    url,
                    status,
                    message: String::from_utf8_lossy(&resp.body).into_owned(),
                });
            }
        };
        Ok((archive, signature))
    }

    /// Unpack `archive` and record `provenance` in a private staging
    /// directory, then publish both with one rename to `entry`.
    fn install_archive(
        &self,
        name: &str,
        version: &Version,
        archive: &[u8],
        provenance: &Provenance,
        entry: &Path,
    ) -> Result<()> {
        static NEXT: std::sync::atomic::AtomicU64 = std::sync::atomic::AtomicU64::new(0);
        let recorded = provenance.lock_value().ok_or_else(|| {
            PkgError::Other("a remote package must have a recorded provenance".into())
        })?;
        let parent = entry
            .parent()
            .ok_or_else(|| PkgError::Other("cache destination has no parent".into()))?;
        std::fs::create_dir_all(parent).map_err(|e| PkgError::io(parent, e))?;
        let stage = loop {
            let candidate = parent.join(format!(
                ".partial-{}-{}",
                std::process::id(),
                NEXT.fetch_add(1, std::sync::atomic::Ordering::Relaxed)
            ));
            match std::fs::create_dir(&candidate) {
                Ok(()) => break candidate,
                Err(e) if e.kind() == std::io::ErrorKind::AlreadyExists => continue,
                Err(e) => return Err(PkgError::io(&candidate, e)),
            }
        };
        let installed = (|| {
            let package = stage.join("package");
            crate::tarball::unpack(archive, &package)?;
            let manifest = Manifest::from_file(&package.join("riina.toml"))?;
            validate_package_identity(&manifest, name, version)?;
            let record = stage.join("provenance");
            std::fs::write(&record, format!("{recorded}\n"))
                .map_err(|e| PkgError::io(&record, e))?;
            std::fs::rename(&stage, entry).map_err(|e| PkgError::io(entry, e))
        })();
        if installed.is_err() {
            // This directory was just created exclusively by this invocation.
            let _ = std::fs::remove_dir_all(&stage);
        }
        installed
    }
}

/// Read the provenance recorded beside a cached remote package.
fn read_provenance(path: &Path) -> Result<Provenance> {
    let text = std::fs::read_to_string(path).map_err(|e| PkgError::io(path, e))?;
    Provenance::from_recorded(text.trim_end_matches('\n')).map_err(|e| {
        PkgError::Other(format!(
            "{}: corrupt cache provenance ({e}); run `riinac pkg clean`",
            path.display()
        ))
    })
}

/// Parse a minimal JSON response of the form `{"versions":["1.0.0","1.1.0"]}`.
fn parse_json_version_list(json: &str) -> Result<Vec<String>> {
    // Find the array after "versions"
    let versions_key = json.find("\"versions\"").ok_or_else(|| {
        PkgError::Other("invalid version list response: missing \"versions\" key".to_string())
    })?;
    let after_key = &json[versions_key + "\"versions\"".len()..];
    // Skip colon and whitespace
    let after_colon = after_key
        .trim_start()
        .strip_prefix(':')
        .ok_or_else(|| PkgError::Other("invalid version list JSON: expected ':'".to_string()))?
        .trim_start();

    let arr_start = after_colon
        .strip_prefix('[')
        .ok_or_else(|| PkgError::Other("invalid version list JSON: expected '['".to_string()))?;

    let arr_end_pos = arr_start
        .find(']')
        .ok_or_else(|| PkgError::Other("invalid version list JSON: missing ']'".to_string()))?;

    let arr_content = &arr_start[..arr_end_pos];
    let mut result = Vec::new();
    for item in arr_content.split(',') {
        let item = item.trim();
        if item.is_empty() {
            continue;
        }
        // Strip quotes
        if item.starts_with('"') && item.ends_with('"') && item.len() >= 2 {
            result.push(item[1..item.len() - 1].to_string());
        } else {
            return Err(PkgError::Other(format!(
                "invalid version in JSON array: {item}"
            )));
        }
    }
    Ok(result)
}

/// In-memory registry for testing.
#[derive(Default)]
pub struct MemRegistry {
    packages: BTreeMap<String, BTreeMap<Version, Manifest>>,
}

impl MemRegistry {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn add(&mut self, manifest: Manifest) {
        let name = manifest.package.name.clone();
        let version = manifest.package.version.clone();
        self.packages
            .entry(name)
            .or_default()
            .insert(version, manifest);
    }
}

impl Registry for MemRegistry {
    fn list_versions(&self, name: &str) -> Result<Vec<Version>> {
        Ok(self
            .packages
            .get(name)
            .map(|m| m.keys().cloned().collect())
            .unwrap_or_default())
    }

    fn get_manifest(&self, name: &str, version: &Version) -> Result<Manifest> {
        self.packages
            .get(name)
            .and_then(|m| m.get(version))
            .cloned()
            .ok_or_else(|| PkgError::DependencyNotFound {
                name: name.to_string(),
                req: version.to_string(),
            })
    }

    fn package_path(&self, name: &str, version: &Version) -> PathBuf {
        PathBuf::from(format!("/mem/{name}/{version}"))
    }

    fn fetch_verified(&self, name: &str, version: &Version) -> Result<(PathBuf, Provenance)> {
        fetch_local(self, name, version)
    }

    fn exists(&self, name: &str, version: &Version) -> bool {
        self.packages
            .get(name)
            .is_some_and(|m| m.contains_key(version))
    }
}

#[cfg(test)]
pub(crate) mod tests {
    use super::*;
    use crate::manifest::{AllowedEffects, PackageMeta};
    use crate::signing::{PackageSignature, Provenance, PublisherSigningKey, TrustPolicy};

    fn dummy_manifest(name: &str, ver: &str) -> Manifest {
        Manifest {
            package: PackageMeta {
                name: name.to_string(),
                version: Version::parse(ver).unwrap(),
                authors: vec![],
                license: None,
                description: None,
                homepage: None,
                repository: None,
            },
            dependencies: BTreeMap::new(),
            dev_dependencies: BTreeMap::new(),
            allowed_effects: AllowedEffects::default(),
            workspace: None,
            registry: None,
            trusted_publishers: vec![],
        }
    }

    #[test]
    fn mem_registry() {
        let mut reg = MemRegistry::new();
        reg.add(dummy_manifest("foo", "1.0.0"));
        reg.add(dummy_manifest("foo", "1.1.0"));
        reg.add(dummy_manifest("bar", "0.1.0"));

        let vers = reg.list_versions("foo").unwrap();
        assert_eq!(vers.len(), 2);
        assert!(reg.exists("foo", &Version::parse("1.0.0").unwrap()));
        assert!(!reg.exists("baz", &Version::parse("1.0.0").unwrap()));
    }

    #[test]
    fn parse_json_versions() {
        let json = r#"{"versions":["0.1.0","1.0.0","1.2.3"]}"#;
        let versions = parse_json_version_list(json).unwrap();
        assert_eq!(versions, vec!["0.1.0", "1.0.0", "1.2.3"]);
    }

    #[test]
    fn parse_json_versions_with_whitespace() {
        let json = r#"{ "versions" : [ "0.1.0" , "2.0.0" ] }"#;
        let versions = parse_json_version_list(json).unwrap();
        assert_eq!(versions, vec!["0.1.0", "2.0.0"]);
    }

    #[test]
    fn parse_json_versions_empty() {
        let json = r#"{"versions":[]}"#;
        let versions = parse_json_version_list(json).unwrap();
        assert!(versions.is_empty());
    }

    #[test]
    fn parse_json_versions_missing_key() {
        let json = r#"{"crates":[]}"#;
        assert!(parse_json_version_list(json).is_err());
    }

    #[test]
    fn http_registry_cache_path() {
        let reg = HttpRegistry::new("http://localhost:8080/registry", "/tmp/test_cache");
        let v = Version::parse("1.0.0").unwrap();
        let p = reg.cache_dir.join("foo").join(v.to_string());
        assert_eq!(p, PathBuf::from("/tmp/test_cache/foo/1.0.0"));
    }

    #[test]
    fn failed_extraction_never_publishes_a_partial_cache() {
        let tmp = std::env::temp_dir().join(format!("riina_atomic_cache_{}", std::process::id()));
        std::fs::create_dir_all(tmp.join("source/src")).unwrap();
        std::fs::write(
            tmp.join("source/riina.toml"),
            "[pakej]\nnama = \"foo\"\nversi = \"1.0.0\"\n",
        )
        .unwrap();
        std::fs::write(tmp.join("source/src/lib.rii"), "pulang 0;").unwrap();
        let key = PublisherSigningKey::from_seed(&[1; 32]);
        let signed = Provenance::Signed(key.public_key());
        let reg = HttpRegistry::new("http://127.0.0.1:1", tmp.join("cache"))
            .with_trust_policy(TrustPolicy::new([key.public_key()], false));
        let version = Version::new(1, 0, 0);
        let entry = reg.entry_dir("foo", &version);
        let dest = reg.package_path("foo", &version);
        let archive = crate::tarball::pack(&tmp.join("source")).unwrap();
        let wrong_identity = entry.with_file_name("wrong-identity");
        assert!(reg
            .install_archive("other", &version, &archive, &signed, &wrong_identity)
            .is_err());
        assert!(!wrong_identity.exists());
        let truncated = &archive[..archive.len() - 1024];
        assert!(reg
            .install_archive("foo", &version, truncated, &signed, &entry)
            .is_err());
        assert!(!entry.exists());
        // A remote install must record who vouched for it.
        assert!(reg
            .install_archive("foo", &version, &archive, &Provenance::Local, &entry)
            .is_err());
        assert_eq!(
            std::fs::read_dir(entry.parent().unwrap()).unwrap().count(),
            0
        );
        reg.install_archive("foo", &version, &archive, &signed, &entry)
            .unwrap();
        assert_eq!(
            reg.fetch_verified("foo", &version).unwrap(),
            (dest.clone(), signed)
        );
        assert!(dest.join("src/lib.rii").is_file());
        std::fs::remove_dir_all(tmp).unwrap();
    }

    // ── End-to-end signature enforcement against a loopback registry ─────

    /// Serve fixed `(path, status, body)` routes on 127.0.0.1; anything else
    /// is 404. The thread lives until the test process exits.
    pub(crate) fn serve(routes: Vec<(String, u16, Vec<u8>)>) -> String {
        use std::io::{BufRead, Write};
        let listener = std::net::TcpListener::bind("127.0.0.1:0").unwrap();
        let addr = listener.local_addr().unwrap();
        std::thread::spawn(move || {
            for stream in listener.incoming() {
                let Ok(mut stream) = stream else { continue };
                let Ok(clone) = stream.try_clone() else {
                    continue;
                };
                let mut reader = std::io::BufReader::new(clone);
                let mut request_line = String::new();
                if reader.read_line(&mut request_line).is_err() {
                    continue;
                }
                loop {
                    let mut line = String::new();
                    if reader.read_line(&mut line).unwrap_or(0) <= 2 {
                        break;
                    }
                }
                let path = request_line.split_whitespace().nth(1).unwrap_or("");
                let (status, body) = routes
                    .iter()
                    .find(|(p, _, _)| p == path)
                    .map(|(_, s, b)| (*s, b.clone()))
                    .unwrap_or((404, b"not found".to_vec()));
                let head = format!(
                    "HTTP/1.1 {status} X\r\nContent-Length: {}\r\nConnection: close\r\n\r\n",
                    body.len()
                );
                let _ = stream.write_all(head.as_bytes());
                let _ = stream.write_all(&body);
            }
        });
        format!("http://{addr}")
    }

    pub(crate) struct Fixture {
        pub(crate) tmp: PathBuf,
    }

    impl Fixture {
        pub(crate) fn new(tag: &str) -> Self {
            let tmp =
                std::env::temp_dir().join(format!("riina_sigreg_{tag}_{}", std::process::id()));
            let _ = std::fs::remove_dir_all(&tmp);
            std::fs::create_dir_all(&tmp).unwrap();
            Self { tmp }
        }

        /// A packed `name` 1.0.0 whose library returns `value`.
        pub(crate) fn archive(&self, name: &str, value: u32) -> Vec<u8> {
            let dir = self.tmp.join(format!("src-{name}-{value}"));
            std::fs::create_dir_all(dir.join("src")).unwrap();
            std::fs::write(
                dir.join("riina.toml"),
                format!("[pakej]\nnama = \"{name}\"\nversi = \"1.0.0\"\n"),
            )
            .unwrap();
            std::fs::write(
                dir.join("src/lib.rii"),
                format!("fungsi nilai() -> Nombor {{ pulang {value}; }}"),
            )
            .unwrap();
            crate::tarball::pack(&dir).unwrap()
        }

        pub(crate) fn registry(&self, url: &str, cache: &str, policy: TrustPolicy) -> HttpRegistry {
            HttpRegistry::new(url, self.tmp.join(cache)).with_trust_policy(policy)
        }
    }

    impl Drop for Fixture {
        fn drop(&mut self) {
            let _ = std::fs::remove_dir_all(&self.tmp);
        }
    }

    /// Registry routes for `name` 1.0.0: version list, manifest metadata,
    /// archive, and (optionally) a signature response.
    pub(crate) fn routes(
        name: &str,
        archive: Vec<u8>,
        signature: Option<(u16, Vec<u8>)>,
    ) -> Vec<(String, u16, Vec<u8>)> {
        let mut out = vec![
            (
                format!("/api/v1/crates/{name}/versions"),
                200,
                br#"{"versions":["1.0.0"]}"#.to_vec(),
            ),
            (
                format!("/api/v1/crates/{name}/1.0.0/manifest"),
                200,
                format!("[pakej]\nnama = \"{name}\"\nversi = \"1.0.0\"\n").into_bytes(),
            ),
            (
                format!("/api/v1/crates/{name}/1.0.0/download"),
                200,
                archive,
            ),
        ];
        if let Some((status, body)) = signature {
            out.push((
                format!("/api/v1/crates/{name}/1.0.0/signature"),
                status,
                body,
            ));
        }
        out
    }

    #[test]
    fn remote_fetch_enforces_publisher_signatures() {
        let fx = Fixture::new("enforce");
        let publisher = PublisherSigningKey::from_seed(&[1; 32]);
        let attacker = PublisherSigningKey::from_seed(&[2; 32]);
        let v1 = Version::new(1, 0, 0);
        let sign = |key: &PublisherSigningKey, name: &str, archive: &[u8]| {
            key.sign_archive(name, &v1, archive).render().into_bytes()
        };

        let good = fx.archive("good", 1);
        let tampered_orig = fx.archive("tampered", 1);
        let tampered = fx.archive("tampered", 666);
        let unsigned = fx.archive("unsigned", 1);
        let untrusted = fx.archive("untrusted", 1);
        let broken = fx.archive("broken", 1);
        let mut all = Vec::new();
        all.extend(routes(
            "good",
            good.clone(),
            Some((200, sign(&publisher, "good", &good))),
        ));
        // The registry serves different bytes than the publisher signed.
        all.extend(routes(
            "tampered",
            tampered,
            Some((200, sign(&publisher, "tampered", &tampered_orig))),
        ));
        all.extend(routes("unsigned", unsigned, None));
        all.extend(routes(
            "untrusted",
            untrusted.clone(),
            Some((200, sign(&attacker, "untrusted", &untrusted))),
        ));
        // A server error on the signature must not read as "unsigned".
        all.extend(routes("broken", broken, Some((500, b"oops".to_vec()))));
        let url = serve(all);
        let trust = || TrustPolicy::new([publisher.public_key()], false);

        // Valid signature by a trusted key: accepted, provenance recorded.
        let reg = fx.registry(&url, "strict", trust());
        let (path, provenance) = reg.fetch_verified("good", &v1).unwrap();
        assert_eq!(provenance, Provenance::Signed(publisher.public_key()));
        assert!(path.join("src/lib.rii").is_file());
        assert!(reg.warnings().is_empty());
        // Cached: the recorded signer is re-checked against today's policy.
        assert!(fx
            .registry(&url, "strict", TrustPolicy::default())
            .fetch_package("good", &v1)
            .is_err());
        assert!(reg.fetch_package("good", &v1).is_ok());

        // Tampered archive, untrusted key, missing signature, server error:
        // all refused, and nothing is cached.
        for name in ["tampered", "untrusted", "unsigned", "broken"] {
            let res = reg.fetch_verified(name, &v1);
            assert!(res.is_err(), "{name} must be refused");
            assert!(
                !reg.entry_dir(name, &v1).exists(),
                "{name} must not be cached"
            );
        }
        assert!(matches!(
            reg.fetch_verified("tampered", &v1),
            Err(PkgError::SignatureRejected { .. })
        ));
        assert!(matches!(
            reg.fetch_verified("broken", &v1),
            Err(PkgError::Http { status: 500, .. })
        ));

        // Opt-out: unsigned and untrusted are accepted WITH warnings; a
        // tampered archive and a server error are still refused.
        let insecure = fx.registry(
            &url,
            "insecure",
            TrustPolicy::new([publisher.public_key()], true),
        );
        let (_, provenance) = insecure.fetch_verified("unsigned", &v1).unwrap();
        assert_eq!(provenance, Provenance::Unsigned);
        let (_, provenance) = insecure.fetch_verified("untrusted", &v1).unwrap();
        assert_eq!(provenance, Provenance::Signed(attacker.public_key()));
        let warnings = insecure.warnings();
        assert_eq!(warnings.len(), 2, "{warnings:?}");
        assert!(warnings[0].contains("INSECURE") && warnings[0].contains("UNSIGNED"));
        assert!(warnings[1].contains("UNTRUSTED"));
        assert!(insecure.fetch_verified("tampered", &v1).is_err());
        assert!(insecure.fetch_verified("broken", &v1).is_err());
        // A package cached under the opt-out is refused without it.
        assert!(fx
            .registry(&url, "insecure", trust())
            .fetch_package("unsigned", &v1)
            .is_err());
        // ... and warns again on every use with it.
        insecure.fetch_package("unsigned", &v1).unwrap();
        assert_eq!(insecure.warnings().len(), 3);
    }

    /// `publish` with a key sends the archive plus a signature a client can
    /// verify; without a key it sends no signature parameters.
    #[test]
    fn publish_sends_a_verifiable_signature() {
        use std::io::{BufRead, Read, Write};
        let fx = Fixture::new("publish");
        let source = fx.tmp.join("pkg");
        std::fs::create_dir_all(source.join("src")).unwrap();
        std::fs::write(
            source.join("riina.toml"),
            "[pakej]\nnama = \"foo\"\nversi = \"1.2.3\"\n",
        )
        .unwrap();
        std::fs::write(source.join("src/lib.rii"), "pulang 0;").unwrap();

        let listener = std::net::TcpListener::bind("127.0.0.1:0").unwrap();
        let url = format!("http://{}", listener.local_addr().unwrap());
        let (tx, rx) = std::sync::mpsc::channel();
        std::thread::spawn(move || {
            for stream in listener.incoming().take(2) {
                let mut stream = stream.unwrap();
                let mut reader = std::io::BufReader::new(stream.try_clone().unwrap());
                let mut request_line = String::new();
                reader.read_line(&mut request_line).unwrap();
                let mut length = 0;
                loop {
                    let mut line = String::new();
                    reader.read_line(&mut line).unwrap();
                    if line.trim().is_empty() {
                        break;
                    }
                    if let Some(v) = line.to_ascii_lowercase().strip_prefix("content-length:") {
                        length = v.trim().parse().unwrap();
                    }
                }
                let mut body = vec![0; length];
                reader.read_exact(&mut body).unwrap();
                stream
                    .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 0\r\nConnection: close\r\n\r\n")
                    .unwrap();
                tx.send((request_line, body)).unwrap();
            }
        });

        let key = PublisherSigningKey::from_seed(&[5; 32]);
        let reg = HttpRegistry::new(&url, fx.tmp.join("cache"));
        let version = Version::new(1, 2, 3);
        reg.publish("foo", &version, &source, Some(&key)).unwrap();
        let (request_line, archive) = rx.recv().unwrap();
        let target = request_line.split_whitespace().nth(1).unwrap();
        let query: BTreeMap<&str, &str> = target
            .split_once('?')
            .unwrap()
            .1
            .split('&')
            .filter_map(|kv| kv.split_once('='))
            .collect();
        // Rebuild the signature document a registry would serve from the
        // parameters, and check it as a client would.
        let document = format!(
            "{}\nnama = \"foo\"\nversi = \"1.2.3\"\narkib-sha256 = \"{}\"\n\
             penandatangan = \"{}\"\ntandatangan = \"{}\"\n",
            crate::signing::SIGNATURE_HEADER,
            query["sha256"],
            query["signer"],
            query["signature"],
        );
        let signature = PackageSignature::parse(document.as_bytes()).unwrap();
        assert_eq!(signature.signer, key.public_key());
        signature.verify("foo", &version, &archive).unwrap();
        let verdict = TrustPolicy::new([key.public_key()], false)
            .check_download("foo", &version, &archive, Some(document.as_bytes()))
            .unwrap();
        assert_eq!(verdict.provenance, Provenance::Signed(key.public_key()));

        reg.publish("foo", &version, &source, None).unwrap();
        let (request_line, _) = rx.recv().unwrap();
        assert!(!request_line.contains("signature="), "{request_line}");
    }

    /// Caches written before signing (`<cache>/<name>/<version>/package`) or
    /// with a corrupt provenance record are never trusted.
    #[test]
    fn unverified_cache_entries_are_not_trusted() {
        let fx = Fixture::new("oldcache");
        let key = PublisherSigningKey::from_seed(&[1; 32]);
        let v1 = Version::new(1, 0, 0);
        // Unreachable registry: anything not trusted from cache must fail.
        let reg = fx.registry(
            "http://127.0.0.1:1",
            "cache",
            TrustPolicy::new([key.public_key()], true),
        );
        let old_leaf = fx.tmp.join("cache/foo/1.0.0/package");
        crate::tarball::unpack(&fx.archive("foo", 1), &old_leaf).unwrap();
        assert!(reg.fetch_package("foo", &v1).is_err());

        let entry = reg.entry_dir("foo", &v1);
        crate::tarball::unpack(&fx.archive("foo", 1), &entry.join("package")).unwrap();
        std::fs::write(entry.join("provenance"), "trust me\n").unwrap();
        assert!(reg.fetch_package("foo", &v1).is_err());
        std::fs::remove_file(entry.join("provenance")).unwrap();
        assert!(reg.fetch_package("foo", &v1).is_err());
    }

    #[test]
    fn fetch_propagates_download_failure_and_rejects_package_paths() {
        let reg = HttpRegistry::new(
            "https://unsupported.invalid",
            std::env::temp_dir().join("riina_missing_cache"),
        );
        assert!(reg.fetch_package("foo", &Version::new(1, 0, 0)).is_err());
        for name in ["../outside", "/absolute", "C:drive", "bad\\path"] {
            assert!(reg.fetch_package(name, &Version::new(1, 0, 0)).is_err());
        }
        for version in ["1.0.0-../../outside", "1.0.0-a/b", "1.0.0-a\\b"] {
            assert!(Version::parse(version).is_err());
        }
    }
}
