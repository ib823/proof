// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! riina.lock file parsing and serialization.
//!
//! Format:
//! ```text
//! # riina.lock — auto-generated, do not edit
//!
//! [[package]]
//! nama = "foo"
//! versi = "1.2.3"
//! checksum = "abc123..."
//!
//! [[package]]
//! nama = "bar"
//! versi = "0.1.0"
//! checksum = "def456..."
//! penandatangan = "ed25519:<64 hex>"
//! kebergantungan = ["foo ^1.0.0"]
//! ```
//!
//! `penandatangan` (signer) is present for packages from a REMOTE registry:
//! the publisher key id whose signature was accepted, or `"unsigned"` for a
//! package accepted under `--insecure-allow-unsigned`. A locked build fails
//! closed when a package's current signer differs from the pinned one (see
//! [`crate::signing`]). Packages from the local filesystem registry carry no
//! signer.

use crate::error::{PkgError, Result};
use crate::version::Version;
use std::path::Path;

#[derive(Debug, Clone)]
pub struct Lockfile {
    pub packages: Vec<LockedPackage>,
}

#[derive(Debug, Clone)]
pub struct LockedPackage {
    pub name: String,
    pub version: Version,
    pub checksum: String,
    pub dependencies: Vec<String>,
    /// Pinned publisher (`ed25519:<hex>` or `unsigned`); `None` for a package
    /// from the local filesystem registry.
    pub signer: Option<String>,
}

impl Lockfile {
    pub fn new() -> Self {
        Self {
            packages: Vec::new(),
        }
    }

    /// Serialize to string.
    pub fn serialize(&self) -> String {
        let mut out = String::from("# riina.lock — auto-generated, do not edit\n");
        for pkg in &self.packages {
            out.push_str("\n[[package]]\n");
            out.push_str(&format!("nama = \"{}\"\n", pkg.name));
            out.push_str(&format!("versi = \"{}\"\n", pkg.version));
            out.push_str(&format!("checksum = \"{}\"\n", pkg.checksum));
            if let Some(signer) = &pkg.signer {
                out.push_str(&format!("penandatangan = \"{signer}\"\n"));
            }
            if !pkg.dependencies.is_empty() {
                let deps: Vec<String> = pkg
                    .dependencies
                    .iter()
                    .map(|d| format!("\"{d}\""))
                    .collect();
                out.push_str(&format!("kebergantungan = [{}]\n", deps.join(", ")));
            }
        }
        out
    }

    /// Parse from string.
    pub fn parse(source: &str) -> Result<Self> {
        let mut packages = Vec::new();
        let mut current: Option<LockedPackageBuilder> = None;

        for line in source.lines() {
            let trimmed = line.trim();
            if trimmed.is_empty() || trimmed.starts_with('#') {
                continue;
            }
            if trimmed == "[[package]]" {
                if let Some(builder) = current.take() {
                    packages.push(builder.build()?);
                }
                current = Some(LockedPackageBuilder::default());
                continue;
            }
            if let Some(ref mut builder) = current {
                if let Some(eq) = trimmed.find('=') {
                    let key = trimmed[..eq].trim();
                    let val = trimmed[eq + 1..].trim();
                    match key {
                        "nama" => builder.name = Some(unquote(val)),
                        "versi" => builder.version = Some(unquote(val)),
                        "checksum" => builder.checksum = Some(unquote(val)),
                        "penandatangan" => {
                            if builder.signer.replace(unquote(val)).is_some() {
                                return Err(PkgError::Other(
                                    "lockfile: duplicate penandatangan".into(),
                                ));
                            }
                        }
                        "kebergantungan" => {
                            builder.dependencies = parse_string_array(val);
                        }
                        _ => {}
                    }
                }
            }
        }
        if let Some(builder) = current {
            packages.push(builder.build()?);
        }

        Ok(Self { packages })
    }

    /// Read from file.
    pub fn from_file(path: &Path) -> Result<Self> {
        let source = std::fs::read_to_string(path).map_err(|e| PkgError::io(path, e))?;
        Self::parse(&source)
    }

    /// Write to file.
    pub fn write_to(&self, path: &Path) -> Result<()> {
        std::fs::write(path, self.serialize()).map_err(|e| PkgError::io(path, e))
    }

    /// Get locked version for a package.
    pub fn get(&self, name: &str) -> Option<&LockedPackage> {
        self.packages.iter().find(|p| p.name == name)
    }
}

impl Default for Lockfile {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(Default)]
struct LockedPackageBuilder {
    name: Option<String>,
    version: Option<String>,
    checksum: Option<String>,
    dependencies: Vec<String>,
    signer: Option<String>,
}

impl LockedPackageBuilder {
    fn build(self) -> Result<LockedPackage> {
        let name = self
            .name
            .ok_or_else(|| PkgError::Other("lockfile: missing nama".into()))?;
        let version_str = self
            .version
            .ok_or_else(|| PkgError::Other("lockfile: missing versi".into()))?;
        let version = Version::parse(&version_str)?;
        let checksum = self.checksum.unwrap_or_default();
        if let Some(signer) = &self.signer {
            crate::signing::Provenance::from_recorded(signer).map_err(|e| {
                PkgError::Other(format!("lockfile: package {name}: penandatangan: {e}"))
            })?;
        }
        Ok(LockedPackage {
            name,
            version,
            checksum,
            dependencies: self.dependencies,
            signer: self.signer,
        })
    }
}

fn unquote(s: &str) -> String {
    let s = s.trim();
    if s.starts_with('"') && s.ends_with('"') && s.len() >= 2 {
        s[1..s.len() - 1].to_string()
    } else {
        s.to_string()
    }
}

fn parse_string_array(s: &str) -> Vec<String> {
    let s = s.trim();
    if !s.starts_with('[') || !s.ends_with(']') {
        return Vec::new();
    }
    let inner = &s[1..s.len() - 1];
    inner
        .split(',')
        .map(|item| unquote(item.trim()))
        .filter(|item| !item.is_empty())
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn roundtrip() {
        let lock = Lockfile {
            packages: vec![
                LockedPackage {
                    name: "foo".into(),
                    version: Version::new(1, 0, 0),
                    checksum: "abc123".into(),
                    dependencies: vec![],
                    signer: None,
                },
                LockedPackage {
                    name: "bar".into(),
                    version: Version::new(0, 1, 0),
                    checksum: "def456".into(),
                    dependencies: vec!["foo ^1.0.0".into()],
                    signer: Some("unsigned".into()),
                },
            ],
        };
        let serialized = lock.serialize();
        let parsed = Lockfile::parse(&serialized).unwrap();
        assert_eq!(parsed.packages.len(), 2);
        assert_eq!(parsed.packages[0].name, "foo");
        assert_eq!(parsed.packages[1].name, "bar");
        assert_eq!(parsed.packages[1].dependencies, vec!["foo ^1.0.0"]);
        assert_eq!(parsed.packages[0].signer, None);
        assert_eq!(parsed.packages[1].signer.as_deref(), Some("unsigned"));
    }

    #[test]
    fn signer_is_pinned_and_validated() {
        let key = "ed25519:ea4a6c63e29c520abef5507b132ec5f9954776aebebe7b92421eea691446d22c";
        let src = format!(
            "[[package]]\nnama = \"foo\"\nversi = \"1.0.0\"\nchecksum = \"x\"\npenandatangan = \"{key}\"\n"
        );
        let lock = Lockfile::parse(&src).unwrap();
        assert_eq!(lock.packages[0].signer.as_deref(), Some(key));
        assert_eq!(
            Lockfile::parse(&lock.serialize()).unwrap().packages[0].signer,
            lock.packages[0].signer
        );
        // Malformed or duplicated signer entries are errors, not ignored.
        assert!(Lockfile::parse(&src.replace(key, "ed25519:zz")).is_err());
        assert!(Lockfile::parse(&format!("{src}penandatangan = \"unsigned\"\n")).is_err());
    }

    #[test]
    fn get_package() {
        let lock = Lockfile {
            packages: vec![LockedPackage {
                name: "x".into(),
                version: Version::new(2, 0, 0),
                checksum: "aaa".into(),
                dependencies: vec![],
                signer: None,
            }],
        };
        assert!(lock.get("x").is_some());
        assert!(lock.get("y").is_none());
    }
}
