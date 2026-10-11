// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! CLI subcommand dispatch for `riinac pkg <command>`.

use crate::effects::EffectPermissions;
use crate::error::{PkgError, Result};
use crate::integrity::package_checksum;
use crate::layout::{self, Layout};
use crate::lockfile::{LockedPackage, Lockfile};
use crate::manifest::Manifest;
use crate::registry::{FsRegistry, HttpRegistry, Registry};
use crate::resolve;
use crate::workspace::Workspace;
use std::path::{Path, PathBuf};

/// Run a pkg subcommand. Args should be everything after `riinac pkg`.
///
/// `compile` is the RIINA compiler, injected by the caller so that `pkg build`
/// and `riinac build` share one pipeline instead of two that can diverge
/// (REQ-72). Every other subcommand ignores it.
pub fn run(args: &[String], compile: crate::build::CompileFn<'_>) -> Result<()> {
    if args.is_empty() {
        return Err(PkgError::Other(usage_string()));
    }

    // Parse global --registry <url> flag
    let mut registry_url: Option<String> = None;
    let mut filtered: Vec<&String> = Vec::new();
    let mut i = 0;
    while i < args.len() {
        if args[i] == "--registry" {
            i += 1;
            if i < args.len() {
                registry_url = Some(args[i].clone());
            } else {
                return Err(PkgError::Other("--registry requires a URL argument".into()));
            }
        } else {
            filtered.push(&args[i]);
        }
        i += 1;
    }

    if filtered.is_empty() {
        return Err(PkgError::Other(usage_string()));
    }

    match filtered[0].as_str() {
        "init" => cmd_init(filtered.get(1).map(|s| s.as_str())),
        "add" => {
            let name = filtered
                .get(1)
                .ok_or_else(|| PkgError::Other("usage: riinac pkg add <dep> [version]".into()))?;
            let version = filtered.get(2).map(|s| s.as_str()).unwrap_or("*");
            cmd_add(name, version)
        }
        "remove" => {
            let name = filtered
                .get(1)
                .ok_or_else(|| PkgError::Other("usage: riinac pkg remove <dep>".into()))?;
            cmd_remove(name)
        }
        "update" => cmd_update(filtered.get(1).map(|s| s.as_str()), registry_url.as_deref()),
        "lock" => cmd_lock(registry_url.as_deref()),
        "build" => cmd_build(registry_url.as_deref(), compile),
        "publish" => cmd_publish(registry_url.as_deref()),
        "list" => cmd_list(),
        "tree" => cmd_tree(registry_url.as_deref()),
        "clean" => cmd_clean(),
        other => Err(PkgError::Other(format!(
            "unknown pkg command: {other}\n{}",
            usage_string()
        ))),
    }
}

fn usage_string() -> String {
    "Usage: riinac pkg [--registry <url>] <command>\n\n\
     Commands:\n\
     \x20 init [name]       Create riina.toml + scaffold\n\
     \x20 add <dep> [ver]   Add dependency\n\
     \x20 remove <dep>      Remove dependency\n\
     \x20 update [dep]      Update dependencies\n\
     \x20 lock              Resolve and write riina.lock\n\
     \x20 build             Build package + deps\n\
     \x20 publish           Publish to registry\n\
     \x20 list              List dependencies\n\
     \x20 tree              Print dependency tree\n\
     \x20 clean             Clean cache and build artifacts\n\n\
     Options:\n\
     \x20 --registry <url>  Use HTTP registry at URL instead of local filesystem"
        .to_string()
}

/// The HTTP registry URL in effect, if any: CLI flag first, then the
/// manifest's `[registry]` section. `None` means the local filesystem registry.
fn remote_registry_url(cli_url: Option<&str>, manifest: Option<&Manifest>) -> Option<String> {
    cli_url
        .map(str::to_string)
        .or_else(|| manifest.and_then(|m| m.registry.as_ref().map(|r| r.url.clone())))
}

/// Create a registry from CLI flag, manifest config, or fall back to FsRegistry.
///
/// An HTTP registry URL is validated up front: plain http is refused unless
/// the host is loopback (see `http::parse_url`).
fn make_registry(cli_url: Option<&str>, manifest: Option<&Manifest>) -> Result<Box<dyn Registry>> {
    if let Some(url) = remote_registry_url(cli_url, manifest) {
        crate::http::validate_registry_url(&url)?;
        let cache = crate::tarball::cache_dir_for_url(&url);
        return Ok(Box::new(HttpRegistry::new(&url, cache)));
    }
    // Default: filesystem registry
    Ok(Box::new(FsRegistry::new(registry_root())))
}

fn find_project_root() -> Result<PathBuf> {
    let cwd = std::env::current_dir().map_err(|e| PkgError::io(".", e))?;
    let manifest = cwd.join("riina.toml");
    if manifest.is_file() {
        Ok(cwd)
    } else {
        Err(PkgError::Other(
            "no riina.toml found in current directory".into(),
        ))
    }
}

fn registry_root() -> PathBuf {
    std::env::var("RIINA_REGISTRY")
        .map(PathBuf::from)
        .unwrap_or_else(|_| {
            let home = std::env::var("HOME")
                .or_else(|_| std::env::var("USERPROFILE"))
                .unwrap_or_else(|_| ".".into());
            PathBuf::from(home).join(".riina").join("registry")
        })
}

fn cmd_init(name: Option<&str>) -> Result<()> {
    let cwd = std::env::current_dir().map_err(|e| PkgError::io(".", e))?;
    let pkg_name = name.unwrap_or_else(|| {
        cwd.file_name()
            .and_then(|s| s.to_str())
            .unwrap_or("pakej-baru")
    });
    layout::create_scaffold(&cwd, pkg_name)?;
    eprintln!("Created package '{}' in {}", pkg_name, cwd.display());
    Ok(())
}

fn cmd_add(name: &str, version: &str) -> Result<()> {
    let root = find_project_root()?;
    let manifest_path = root.join("riina.toml");
    let mut source =
        std::fs::read_to_string(&manifest_path).map_err(|e| PkgError::io(&manifest_path, e))?;

    // Find [kebergantungan] section and add entry
    if let Some(pos) = source.find("[kebergantungan]") {
        let insert_pos = source[pos..]
            .find('\n')
            .map(|p| pos + p + 1)
            .unwrap_or(source.len());
        let line = format!("{} = \"{}\"\n", name, version);
        source.insert_str(insert_pos, &line);
    } else {
        source.push_str(&format!("\n[kebergantungan]\n{} = \"{}\"\n", name, version));
    }

    std::fs::write(&manifest_path, &source).map_err(|e| PkgError::io(&manifest_path, e))?;
    eprintln!("Added {} = \"{}\"", name, version);
    Ok(())
}

fn cmd_remove(name: &str) -> Result<()> {
    let root = find_project_root()?;
    let manifest_path = root.join("riina.toml");
    let source =
        std::fs::read_to_string(&manifest_path).map_err(|e| PkgError::io(&manifest_path, e))?;

    let mut lines: Vec<&str> = source.lines().collect();
    let pattern = format!("{} = ", name);
    lines.retain(|line| !line.trim().starts_with(&pattern));

    let new_source = lines.join("\n") + "\n";
    std::fs::write(&manifest_path, &new_source).map_err(|e| PkgError::io(&manifest_path, e))?;
    eprintln!("Removed {}", name);
    Ok(())
}

fn cmd_update(_dep: Option<&str>, registry_url: Option<&str>) -> Result<()> {
    // Re-resolve: just run lock again (lockfile is regenerated)
    cmd_lock(registry_url)
}

fn cmd_lock(registry_url: Option<&str>) -> Result<()> {
    let root = find_project_root()?;
    let manifest = Manifest::from_file(&root.join("riina.toml"))?;

    // Check for workspace
    let deps = if let Some(ws) = Workspace::discover(&root)? {
        ws.all_dependencies()?
    } else {
        manifest.dep_reqs()?
    };

    if deps.is_empty() {
        let lockfile = Lockfile::new();
        lockfile.write_to(&root.join("riina.lock"))?;
        eprintln!("No dependencies. Wrote riina.lock");
        return Ok(());
    }

    let reg = make_registry(registry_url, Some(&manifest))?;
    let graph = resolve::resolve(&deps, reg.as_ref())?;

    // Effect escalation check
    let root_perms = EffectPermissions::from_allowed(&manifest.allowed_effects);
    for (name, pkg) in &graph.packages {
        let dep_manifest = reg.get_manifest(name, &pkg.version)?;
        let dep_perms = EffectPermissions::from_allowed(&dep_manifest.allowed_effects);
        root_perms.check_escalation(name, &dep_perms)?;
    }

    // Build lockfile
    let mut lockfile = Lockfile::new();
    let order = graph.topological_order()?;
    for name in &order {
        let pkg = &graph.packages[name];
        let pkg_path = reg.fetch_package(name, &pkg.version)?;
        validate_resolved_dependencies(
            &Manifest::from_file(&pkg_path.join("riina.toml"))?,
            &graph,
        )?;
        let checksum = package_checksum(&pkg_path)?;
        let dep_strs: Vec<String> = pkg
            .deps
            .iter()
            .map(|d| {
                let dv = &graph.packages[d].version;
                format!("{d} {dv}")
            })
            .collect();
        lockfile.packages.push(LockedPackage {
            name: name.clone(),
            version: pkg.version.clone(),
            checksum,
            dependencies: dep_strs,
        });
    }

    lockfile.write_to(&root.join("riina.lock"))?;
    eprintln!(
        "Resolved {} packages. Wrote riina.lock",
        lockfile.packages.len()
    );
    Ok(())
}

fn cmd_build(registry_url: Option<&str>, compile: crate::build::CompileFn<'_>) -> Result<()> {
    let root = find_project_root()?;
    let manifest = Manifest::from_file(&root.join("riina.toml"))?;
    crate::registry::validate_package_name(&manifest.package.name)?;
    let deps = manifest.dep_reqs()?;

    if deps.is_empty() {
        // Just build root
        let config = crate::build::BuildConfig::new(&root);
        let mut graph_packages = std::collections::BTreeMap::new();
        graph_packages.insert(
            manifest.package.name.clone(),
            crate::resolve::ResolvedPackage {
                name: manifest.package.name.clone(),
                version: manifest.package.version.clone(),
                deps: vec![],
            },
        );
        let graph = crate::resolve::ResolvedGraph {
            packages: graph_packages,
        };
        let steps = crate::build::build_plan(&graph, &config, &manifest.package.name)?;
        crate::build::execute_build(&steps, compile)?;
    } else {
        let reg = make_registry(registry_url, Some(&manifest))?;
        let graph = resolve_build_graph(&root, &manifest, &deps, registry_url, reg.as_ref())?;
        if graph.packages.contains_key(&manifest.package.name) {
            return Err(PkgError::CycleDetected(vec![manifest.package.name.clone()]));
        }
        let config = crate::build::BuildConfig::new(&root).with_registry(registry_root());
        let mut steps = crate::build::build_plan(&graph, &config, &manifest.package.name)?;
        let root_perms = EffectPermissions::from_allowed(&manifest.allowed_effects);
        for step in &mut steps {
            if let Some(pkg) = graph.packages.get(&step.name) {
                step.source_dir = reg.fetch_package(&pkg.name, &pkg.version)?;
                let source_manifest = Manifest::from_file(&step.source_dir.join("riina.toml"))?;
                root_perms.check_escalation(
                    &pkg.name,
                    &EffectPermissions::from_allowed(&source_manifest.allowed_effects),
                )?;
                validate_resolved_dependencies(&source_manifest, &graph)?;
            }
        }
        crate::build::execute_build(&steps, compile)?;
    }

    eprintln!("Build complete.");
    Ok(())
}

fn validate_resolved_dependencies(
    manifest: &Manifest,
    graph: &resolve::ResolvedGraph,
) -> Result<()> {
    let actual_names: Vec<_> = manifest.dependencies.keys().cloned().collect();
    if graph.packages[&manifest.package.name].deps != actual_names {
        return Err(PkgError::Other(format!(
            "registry metadata disagrees with source dependencies for {}",
            manifest.package.name
        )));
    }
    for (name, req) in manifest.dep_reqs()? {
        if !graph
            .packages
            .get(&name)
            .is_some_and(|pkg| req.matches(&pkg.version))
        {
            return Err(PkgError::VersionConflict {
                name,
                constraints: vec![req.to_string()],
            });
        }
    }
    Ok(())
}

/// The dependency graph a build uses. With a `riina.lock`, only the pinned,
/// checksum-verified packages ([`resolve_locked`]). Without one, a LOCAL
/// filesystem registry may be resolved directly, but a REMOTE registry is
/// refused: its packages are only ever built against checksums pinned in
/// `riina.lock` — resolving them unpinned would build whatever the registry
/// serves today (trust on every use).
fn resolve_build_graph(
    root: &Path,
    manifest: &Manifest,
    deps: &std::collections::BTreeMap<String, crate::version::VersionReq>,
    registry_url: Option<&str>,
    reg: &dyn Registry,
) -> Result<resolve::ResolvedGraph> {
    let lock_path = root.join("riina.lock");
    if lock_path.exists() {
        resolve_locked(deps, &Lockfile::from_file(&lock_path)?, reg)
    } else if remote_registry_url(registry_url, Some(manifest)).is_some() {
        Err(PkgError::Other(
            "dependencies from a remote registry require riina.lock (checksums are \
             mandatory); run `riinac pkg lock`, review it, and commit it"
                .into(),
        ))
    } else {
        resolve::resolve(deps, reg)
    }
}

/// Resolve exclusively from pinned, verified package contents. A build must
/// not upgrade versions or silently trust an obsolete manifest-only checksum.
fn resolve_locked(
    deps: &std::collections::BTreeMap<String, crate::version::VersionReq>,
    lock: &Lockfile,
    registry: &dyn Registry,
) -> Result<resolve::ResolvedGraph> {
    let mut pinned = crate::registry::MemRegistry::new();
    let mut names = std::collections::BTreeSet::new();
    for package in &lock.packages {
        if !names.insert(&package.name) {
            return Err(PkgError::Other(format!(
                "duplicate locked package: {}",
                package.name
            )));
        }
        if !package.checksum.starts_with("sha256-tree:") {
            return Err(PkgError::Other(format!(
                "package {} has a legacy or missing checksum; run `riinac pkg lock`",
                package.name
            )));
        }
        let path = registry.fetch_package(&package.name, &package.version)?;
        let actual = package_checksum(&path)?;
        if actual != package.checksum {
            return Err(PkgError::IntegrityMismatch {
                name: package.name.clone(),
                expected: package.checksum.clone(),
                actual,
            });
        }
        pinned.add(Manifest::from_file(&path.join("riina.toml"))?);
    }
    let graph = resolve::resolve(deps, &pinned)?;
    if graph.packages.len() != lock.packages.len() {
        return Err(PkgError::Other(
            "riina.lock is stale; run `riinac pkg lock`".into(),
        ));
    }
    for package in &lock.packages {
        let mut expected: Vec<_> = graph.packages[&package.name]
            .deps
            .iter()
            .map(|name| format!("{name} {}", graph.packages[name].version))
            .collect();
        let mut locked = package.dependencies.clone();
        expected.sort();
        locked.sort();
        if expected != locked {
            return Err(PkgError::Other(format!(
                "locked dependencies disagree for {}",
                package.name
            )));
        }
    }
    Ok(graph)
}

fn cmd_publish(registry_url: Option<&str>) -> Result<()> {
    let root = find_project_root()?;
    let manifest = Manifest::from_file(&root.join("riina.toml"))?;

    // Determine if we should use HTTP or filesystem registry
    let effective_url = registry_url
        .map(|s| s.to_string())
        .or_else(|| manifest.registry.as_ref().map(|r| r.url.clone()));

    if let Some(url) = effective_url {
        crate::http::validate_registry_url(&url)?;
        let cache = crate::tarball::cache_dir_for_url(&url);
        let reg = HttpRegistry::new(&url, cache);
        reg.publish(&manifest.package.name, &manifest.package.version, &root)?;
    } else {
        let reg = FsRegistry::new(registry_root());
        reg.publish(&manifest.package.name, &manifest.package.version, &root)?;
    }

    eprintln!(
        "Published {} v{}",
        manifest.package.name, manifest.package.version
    );
    Ok(())
}

fn cmd_list() -> Result<()> {
    let root = find_project_root()?;
    let manifest = Manifest::from_file(&root.join("riina.toml"))?;

    if manifest.dependencies.is_empty() {
        eprintln!("No dependencies.");
        return Ok(());
    }

    eprintln!("{} v{}", manifest.package.name, manifest.package.version);
    for (name, req) in &manifest.dependencies {
        eprintln!("  {} = \"{}\"", name, req);
    }

    // Show locked versions if lockfile exists
    let lock_path = root.join("riina.lock");
    if lock_path.is_file() {
        let lockfile = Lockfile::from_file(&lock_path)?;
        if !lockfile.packages.is_empty() {
            eprintln!("\nLocked:");
            for pkg in &lockfile.packages {
                eprintln!("  {} v{}", pkg.name, pkg.version);
            }
        }
    }

    Ok(())
}

fn cmd_tree(registry_url: Option<&str>) -> Result<()> {
    let root = find_project_root()?;
    let manifest = Manifest::from_file(&root.join("riina.toml"))?;
    let deps = manifest.dep_reqs()?;

    eprintln!("{} v{}", manifest.package.name, manifest.package.version);

    if deps.is_empty() {
        return Ok(());
    }

    let reg = make_registry(registry_url, Some(&manifest))?;
    let graph = resolve::resolve(&deps, reg.as_ref())?;
    let root_deps: Vec<String> = manifest.dependencies.keys().cloned().collect();

    let stdout = std::io::stderr();
    let mut handle = stdout.lock();
    resolve::print_tree(&graph, &root_deps, &mut handle)
        .map_err(|e| PkgError::Other(e.to_string()))?;

    Ok(())
}

fn cmd_clean() -> Result<()> {
    let root = find_project_root()?;
    let layout = Layout::new(&root);
    crate::build::clean(&layout.target_dir())?;

    // Also clean cache
    if let Ok(cache) = crate::cache::Cache::default_location() {
        cache.clean()?;
        eprintln!("Cleaned cache.");
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::version::{Version, VersionReq};
    use std::collections::BTreeMap;

    struct Scratch(PathBuf);
    impl Scratch {
        fn new(tag: &str) -> Self {
            let path =
                std::env::temp_dir().join(format!("riina_locked_{tag}_{}", std::process::id()));
            std::fs::create_dir_all(&path).unwrap();
            Self(path)
        }
        fn package(&self, version: &str) -> PathBuf {
            let path = self.0.join("foo").join(version);
            std::fs::create_dir_all(path.join("src")).unwrap();
            std::fs::write(
                path.join("riina.toml"),
                format!("[pakej]\nnama = \"foo\"\nversi = \"{version}\"\n"),
            )
            .unwrap();
            std::fs::write(
                path.join("src/lib.rii"),
                "fungsi nilai() -> Nombor { pulang 1; }",
            )
            .unwrap();
            path
        }
    }
    impl Drop for Scratch {
        fn drop(&mut self) {
            let _ = std::fs::remove_dir_all(&self.0);
        }
    }

    #[test]
    fn locked_build_uses_exact_version_and_checks_source_contents() {
        let tmp = Scratch::new("version_content");
        let path = tmp.package("1.0.0");
        tmp.package("1.1.0");
        let registry = FsRegistry::new(&tmp.0);
        let lock = Lockfile {
            packages: vec![LockedPackage {
                name: "foo".into(),
                version: Version::new(1, 0, 0),
                checksum: package_checksum(&path).unwrap(),
                dependencies: vec![],
            }],
        };
        let deps = BTreeMap::from([("foo".into(), VersionReq::parse("^1.0.0").unwrap())]);
        let graph = resolve_locked(&deps, &lock, &registry).unwrap();
        assert_eq!(graph.packages["foo"].version, Version::new(1, 0, 0));
        std::fs::write(
            path.join("src/lib.rii"),
            "fungsi nilai() -> Nombor { pulang 99; }",
        )
        .unwrap();
        assert!(matches!(
            resolve_locked(&deps, &lock, &registry),
            Err(PkgError::IntegrityMismatch { .. })
        ));
    }

    #[test]
    fn locked_build_rejects_stale_versions_missing_hashes_and_forged_edges() {
        let tmp = Scratch::new("stale");
        let path = tmp.package("1.0.0");
        let registry = FsRegistry::new(&tmp.0);
        let mut lock = Lockfile {
            packages: vec![LockedPackage {
                name: "foo".into(),
                version: Version::new(1, 0, 0),
                checksum: package_checksum(&path).unwrap(),
                dependencies: vec![],
            }],
        };
        let deps = BTreeMap::from([("foo".into(), VersionReq::parse("^2.0.0").unwrap())]);
        assert!(resolve_locked(&deps, &lock, &registry).is_err());
        let deps = BTreeMap::from([("foo".into(), VersionReq::parse("*").unwrap())]);
        lock.packages[0].dependencies = vec!["missing 1.0.0".into()];
        assert!(resolve_locked(&deps, &lock, &registry).is_err());
        lock.packages[0].dependencies.clear();
        lock.packages[0].checksum.clear();
        assert!(resolve_locked(&deps, &lock, &registry).is_err());
    }

    /// Audit L6: a non-loopback http registry is refused before any request,
    /// whether it comes from `--registry` or the manifest; the filesystem
    /// registry and loopback http stay available.
    #[test]
    fn make_registry_refuses_remote_plain_http() {
        assert!(make_registry(Some("http://registry.example/api"), None).is_err());
        assert!(make_registry(Some("http://127.0.0.1:9/api"), None).is_ok());
        assert!(make_registry(None, None).is_ok());
        assert_eq!(remote_registry_url(None, None), None);
        assert_eq!(
            remote_registry_url(Some("http://127.0.0.1:9"), None).as_deref(),
            Some("http://127.0.0.1:9")
        );
    }

    /// Audit L6: building remote-registry dependencies without `riina.lock`
    /// used to resolve whatever the registry served (no checksum at all).
    /// Now the lockfile — and so its mandatory `sha256-tree:` checksums — is
    /// required for a remote registry; a local filesystem registry may still
    /// be resolved directly.
    #[test]
    fn remote_registry_builds_require_a_lockfile() {
        let tmp = Scratch::new("remote_lock");
        tmp.package("1.0.0");
        let deps = BTreeMap::from([("foo".into(), VersionReq::parse("^1.0.0").unwrap())]);
        let fs_reg = FsRegistry::new(&tmp.0);
        let root = tmp.0.join("app");
        std::fs::create_dir_all(&root).unwrap();

        let remote = Manifest::parse(
            "[pakej]\nnama = \"app\"\nversi = \"0.1.0\"\n\n[registry]\nurl = \"http://127.0.0.1:9\"\n",
            &root.join("riina.toml"),
        )
        .unwrap();
        let res = resolve_build_graph(&root, &remote, &deps, None, &fs_reg);
        assert!(
            matches!(&res, Err(PkgError::Other(m)) if m.contains("require riina.lock")),
            "remote registry without a lockfile must be refused"
        );
        let res = resolve_build_graph(&root, &remote, &deps, Some("http://127.0.0.1:9"), &fs_reg);
        assert!(res.is_err());

        let local = Manifest::parse(
            "[pakej]\nnama = \"app\"\nversi = \"0.1.0\"\n",
            &root.join("riina.toml"),
        )
        .unwrap();
        let graph = resolve_build_graph(&root, &local, &deps, None, &fs_reg).unwrap();
        assert_eq!(graph.packages["foo"].version, Version::new(1, 0, 0));
    }
}
