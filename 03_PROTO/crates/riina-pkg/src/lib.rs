// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! riina-pkg — RIINA Package Manager
//!
//! Provides dependency resolution, integrity checking, effect escalation
//! validation, and build orchestration for RIINA packages.
//!
//! # Supply-chain protections
//!
//! * Packages from a REMOTE registry must carry an Ed25519 publisher
//!   signature by a trusted key, or they are refused before being unpacked
//!   ([`signing`] — formats, trust configuration, `--insecure-allow-unsigned`).
//! * `riina.lock` pins each package's whole-tree SHA-256 and its signer; a
//!   locked build fails closed if either changes ([`lockfile`]).
//! * Plain-http registries are refused unless loopback.
//!
//! Publishers create a key with `riinac pkg keygen` and sign with
//! `riinac pkg publish [--key <file.priv>]`; consumers list trusted key ids
//! under `[registry] trusted-publishers` in `riina.toml` or in
//! `~/.riina/trusted-publishers`.
//!
//! # Bahasa Melayu terminology
//!
//! | Bahasa | English | Context |
//! |--------|---------|---------|
//! | pakej | package | Manifest section |
//! | kebergantungan | dependency | Dependencies section |
//! | kesan-dibenarkan | allowed effects | Effect permissions |
//! | nama | name | Package name |
//! | versi | version | Package version |
//! | pengarang | author | Package author |
//! | sasaran | target | Build output dir |
//! | ujian | test | Test directory |
//! | contoh | example | Examples directory |

#![forbid(unsafe_code)]

pub mod build;
pub mod cache;
pub mod cli;
pub mod effects;
pub mod error;
pub(crate) mod http;
pub mod integrity;
pub mod layout;
pub mod lockfile;
pub mod manifest;
pub mod registry;
pub mod resolve;
pub mod signing;
pub(crate) mod tarball;
pub mod version;
pub mod workspace;

pub use error::{PkgError, Result};
pub use manifest::Manifest;
pub use version::{Version, VersionReq};
