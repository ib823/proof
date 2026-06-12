// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Package registry: trait + filesystem-based implementation.

use crate::error::{PkgError, Result};
use crate::manifest::Manifest;
use crate::version::Version;
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

    /// Check if a package version exists.
    fn exists(&self, name: &str, version: &Version) -> bool;
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
        let path = self.package_path(name, version).join("riina.toml");
        Manifest::from_file(&path)
    }

    fn package_path(&self, name: &str, version: &Version) -> PathBuf {
        self.root.join(name).join(version.to_string())
    }

    fn exists(&self, name: &str, version: &Version) -> bool {
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
/// API endpoints:
/// - `GET  /api/v1/crates/{name}/versions`         → JSON version list
/// - `GET  /api/v1/crates/{name}/{version}/manifest` → TOML manifest
/// - `GET  /api/v1/crates/{name}/{version}/download`  → tar archive
/// - `HEAD /api/v1/crates/{name}/{version}/manifest` → existence check
/// - `POST /api/v1/crates/new`                       → publish tarball
pub struct HttpRegistry {
    base_url: String,
    cache_dir: PathBuf,
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
        }
    }

    /// Publish a package to the remote registry.
    pub fn publish(&self, name: &str, version: &Version, source_dir: &Path) -> Result<()> {
        let archive = crate::tarball::pack(source_dir)?;
        let url = format!(
            "{}/api/v1/crates/new?name={}&version={}",
            self.base_url, name, version,
        );
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
        let local = self.cache_dir.join(name).join(version.to_string());
        if !local.exists() {
            // Attempt to download and cache
            if let Ok(()) = self.download_to_cache(name, version, &local) {
                // cached
            }
        }
        local
    }

    fn exists(&self, name: &str, version: &Version) -> bool {
        // Check local cache first
        let local = self.cache_dir.join(name).join(version.to_string());
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
    /// Download a package tarball and unpack it to the cache directory.
    fn download_to_cache(&self, name: &str, version: &Version, dest: &Path) -> Result<()> {
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

        crate::tarball::unpack(&resp.body, dest)
    }
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

    fn exists(&self, name: &str, version: &Version) -> bool {
        self.packages
            .get(name)
            .is_some_and(|m| m.contains_key(version))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::manifest::{AllowedEffects, PackageMeta};

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
}
