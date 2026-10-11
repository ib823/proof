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
use crate::signing::{self, PublisherSigningKey, TrustPolicy};
use crate::version::VersionReq;
use crate::workspace::Workspace;
use std::collections::BTreeMap;
use std::path::{Path, PathBuf};

/// Flags that apply to every subcommand.
#[derive(Debug, Default)]
struct GlobalOptions {
    /// `--registry <url>`.
    registry_url: Option<String>,
    /// `--insecure-allow-unsigned`.
    insecure_allow_unsigned: bool,
}

/// Run a pkg subcommand. Args should be everything after `riinac pkg`.
///
/// `compile` is the RIINA compiler, injected by the caller so that `pkg build`
/// and `riinac build` share one pipeline instead of two that can diverge
/// (REQ-72). Every other subcommand ignores it.
pub fn run(args: &[String], compile: crate::build::CompileFn<'_>) -> Result<()> {
    if args.is_empty() {
        return Err(PkgError::Other(usage_string()));
    }

    // Parse the global flags: --registry <url>, --insecure-allow-unsigned.
    let mut opts = GlobalOptions::default();
    let mut filtered: Vec<&String> = Vec::new();
    let mut i = 0;
    while i < args.len() {
        if args[i] == "--registry" {
            i += 1;
            if i < args.len() {
                opts.registry_url = Some(args[i].clone());
            } else {
                return Err(PkgError::Other("--registry requires a URL argument".into()));
            }
        } else if args[i] == "--insecure-allow-unsigned" {
            opts.insecure_allow_unsigned = true;
        } else {
            filtered.push(&args[i]);
        }
        i += 1;
    }

    if filtered.is_empty() {
        return Err(PkgError::Other(usage_string()));
    }
    if opts.insecure_allow_unsigned {
        eprintln!("{}", signing::INSECURE_BANNER);
    }
    let registry_url = opts.registry_url.as_deref();

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
        "update" => cmd_update(filtered.get(1).map(|s| s.as_str()), &opts),
        "lock" => cmd_lock(&opts),
        "build" => cmd_build(&opts, compile),
        "publish" => cmd_publish(&opts, &filtered[1..]),
        "keygen" => cmd_keygen(&filtered[1..]),
        "key-id" => {
            let path = filtered.get(1).ok_or_else(|| {
                PkgError::Other("usage: riinac pkg key-id <key.pub|key.priv>".into())
            })?;
            cmd_key_id(Path::new(path.as_str()))
        }
        "list" => cmd_list(),
        "tree" => cmd_tree(registry_url, opts.insecure_allow_unsigned),
        "clean" => cmd_clean(),
        other => Err(PkgError::Other(format!(
            "unknown pkg command: {other}\n{}",
            usage_string()
        ))),
    }
}

fn usage_string() -> String {
    "Usage: riinac pkg [--registry <url>] [--insecure-allow-unsigned] <command>\n\n\
     Commands:\n\
     \x20 init [name]       Create riina.toml + scaffold\n\
     \x20 add <dep> [ver]   Add dependency\n\
     \x20 remove <dep>      Remove dependency\n\
     \x20 update [dep]      Update dependencies\n\
     \x20 lock              Resolve and write riina.lock (pins checksum + signer)\n\
     \x20 build             Build package + deps\n\
     \x20 publish [--key <file.priv>]\n\
     \x20                   Publish to registry; signed with the key (default\n\
     \x20                   ~/.riina/keys/publisher.priv) for a remote registry\n\
     \x20 keygen [--output <base>] [--force]\n\
     \x20                   Create a publisher Ed25519 keypair <base>.priv (0600)\n\
     \x20                   + <base>.pub (default base ~/.riina/keys/publisher);\n\
     \x20                   never overwrites without --force\n\
     \x20 key-id <file>     Print the key id (ed25519:<hex>) of a .pub/.priv file\n\
     \x20 list              List dependencies\n\
     \x20 tree              Print dependency tree\n\
     \x20 clean             Clean cache and build artifacts\n\n\
     Options:\n\
     \x20 --registry <url>  Use HTTP registry at URL instead of local filesystem\n\
     \x20 --insecure-allow-unsigned\n\
     \x20                   INSECURE: accept remote packages that are unsigned or\n\
     \x20                   signed by an untrusted key (warns for each); publish\n\
     \x20                   without a key. Invalid signatures are still refused.\n\n\
     Remote-registry packages must carry an Ed25519 signature by a trusted\n\
     publisher. Trusted keys: `trusted-publishers = [\"ed25519:<hex>\", ...]`\n\
     under [registry] in riina.toml, plus ~/.riina/trusted-publishers (one key\n\
     id per line). Local filesystem registry packages are not signature-checked."
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
/// the host is loopback (see `http::parse_url`). An HTTP registry enforces
/// the publisher-signature [`TrustPolicy`] built from the ROOT manifest's
/// `[registry] trusted-publishers` and `~/.riina/trusted-publishers`.
fn make_registry(
    cli_url: Option<&str>,
    manifest: Option<&Manifest>,
    insecure_allow_unsigned: bool,
) -> Result<Box<dyn Registry>> {
    if let Some(url) = remote_registry_url(cli_url, manifest) {
        crate::http::validate_registry_url(&url)?;
        let policy = TrustPolicy::load(
            manifest,
            signing::user_trust_file().as_deref(),
            insecure_allow_unsigned,
        )?;
        let cache = crate::tarball::cache_dir_for_url(&url);
        return Ok(Box::new(
            HttpRegistry::new(&url, cache).with_trust_policy(policy),
        ));
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

fn cmd_update(_dep: Option<&str>, opts: &GlobalOptions) -> Result<()> {
    // Re-resolve: just run lock again (lockfile is regenerated)
    cmd_lock(opts)
}

fn cmd_lock(opts: &GlobalOptions) -> Result<()> {
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

    let reg = make_registry(
        opts.registry_url.as_deref(),
        Some(&manifest),
        opts.insecure_allow_unsigned,
    )?;
    let lockfile = lock_dependencies(&manifest, &deps, reg.as_ref())?;

    lockfile.write_to(&root.join("riina.lock"))?;
    eprintln!(
        "Resolved {} packages. Wrote riina.lock",
        lockfile.packages.len()
    );
    Ok(())
}

/// Resolve `deps`, fetch every package through the registry's signature
/// policy, and pin each one's tree checksum and signer.
fn lock_dependencies(
    manifest: &Manifest,
    deps: &BTreeMap<String, VersionReq>,
    reg: &dyn Registry,
) -> Result<Lockfile> {
    let graph = resolve::resolve(deps, reg)?;

    // Effect escalation check (registry metadata; repeated below against the
    // fetched, signature-checked package itself)
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
        let (pkg_path, provenance) = reg.fetch_verified(name, &pkg.version)?;
        let source_manifest = Manifest::from_file(&pkg_path.join("riina.toml"))?;
        validate_resolved_dependencies(&source_manifest, &graph)?;
        // The registry's `/manifest` endpoint is unsigned metadata; the
        // effects that count are the ones in the package actually fetched.
        root_perms.check_escalation(
            name,
            &EffectPermissions::from_allowed(&source_manifest.allowed_effects),
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
            signer: provenance.lock_value(),
        });
    }
    Ok(lockfile)
}

fn cmd_build(opts: &GlobalOptions, compile: crate::build::CompileFn<'_>) -> Result<()> {
    let registry_url = opts.registry_url.as_deref();
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
        let reg = make_registry(registry_url, Some(&manifest), opts.insecure_allow_unsigned)?;
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
/// not upgrade versions or silently trust an obsolete manifest-only checksum,
/// and must not accept a package whose signer differs from the pinned one.
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
        let (path, provenance) = registry.fetch_verified(&package.name, &package.version)?;
        let actual = package_checksum(&path)?;
        if actual != package.checksum {
            return Err(PkgError::IntegrityMismatch {
                name: package.name.clone(),
                expected: package.checksum.clone(),
                actual,
            });
        }
        let actual_signer = provenance.lock_value();
        if actual_signer != package.signer {
            return Err(PkgError::SignerMismatch {
                name: package.name.clone(),
                locked: package.signer.clone().unwrap_or_else(|| {
                    "no signer (a local-registry entry, or a riina.lock written before \
                     package signing)"
                        .into()
                }),
                actual: actual_signer
                    .unwrap_or_else(|| "nobody (the local filesystem registry)".into()),
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

/// `~/.riina/keys/publisher` — the default key base for `keygen`/`publish`.
fn default_publisher_key_base() -> Option<PathBuf> {
    std::env::var("HOME")
        .or_else(|_| std::env::var("USERPROFILE"))
        .ok()
        .map(|home| {
            PathBuf::from(home)
                .join(".riina")
                .join("keys")
                .join("publisher")
        })
}

/// Parse `--flag <value>` / `--switch` subcommand options; anything else is
/// an error rather than silently ignored.
fn parse_sub_options(
    command: &str,
    args: &[&String],
    valued: &[&str],
    switches: &[&str],
) -> Result<BTreeMap<String, Option<String>>> {
    let mut out = BTreeMap::new();
    let mut i = 0;
    while i < args.len() {
        let arg = args[i].as_str();
        if valued.contains(&arg) {
            let value = args
                .get(i + 1)
                .ok_or_else(|| PkgError::Other(format!("{arg} requires a value")))?;
            out.insert(arg.to_string(), Some(value.to_string()));
            i += 2;
        } else if switches.contains(&arg) {
            out.insert(arg.to_string(), None);
            i += 1;
        } else {
            return Err(PkgError::Other(format!(
                "unexpected argument to `pkg {command}`: {arg}\n{}",
                usage_string()
            )));
        }
    }
    Ok(out)
}

/// The signing key for a REMOTE publish: `--key`, else the default key if it
/// exists. With neither, refuse unless the insecure opt-out is set (then
/// `None`: publish unsigned). A key inside the package directory is refused:
/// it would be uploaded with the package.
fn remote_publish_key(
    key_arg: Option<&Path>,
    default_key: Option<&Path>,
    package_root: &Path,
    insecure_allow_unsigned: bool,
) -> Result<Option<PublisherSigningKey>> {
    let path = key_arg
        .map(Path::to_path_buf)
        .or_else(|| default_key.filter(|p| p.is_file()).map(Path::to_path_buf));
    let Some(path) = path else {
        if insecure_allow_unsigned {
            eprintln!(
                "WARNING: INSECURE: publishing an UNSIGNED package (--insecure-allow-unsigned); \
                 clients refuse it unless they also pass --insecure-allow-unsigned"
            );
            return Ok(None);
        }
        return Err(PkgError::Other(
            "publishing to a remote registry requires a publisher signing key: pass \
             --key <file.priv> (create one with `riinac pkg keygen`), or \
             --insecure-allow-unsigned to publish a package clients refuse by default"
                .into(),
        ));
    };
    let canonical_key = path.canonicalize().map_err(|e| PkgError::io(&path, e))?;
    let canonical_root = package_root
        .canonicalize()
        .map_err(|e| PkgError::io(package_root, e))?;
    if canonical_key.starts_with(&canonical_root) {
        return Err(PkgError::Other(format!(
            "refusing to publish: the private key {} is inside the package directory {} \
             and would be uploaded with it; move it out (e.g. to ~/.riina/keys/)",
            path.display(),
            package_root.display()
        )));
    }
    PublisherSigningKey::load(&path).map(Some)
}

fn cmd_publish(opts: &GlobalOptions, args: &[&String]) -> Result<()> {
    let sub = parse_sub_options("publish", args, &["--key"], &[])?;
    let key_arg = sub.get("--key").cloned().flatten().map(PathBuf::from);
    let root = find_project_root()?;
    let manifest = Manifest::from_file(&root.join("riina.toml"))?;

    if let Some(url) = remote_registry_url(opts.registry_url.as_deref(), Some(&manifest)) {
        crate::http::validate_registry_url(&url)?;
        let default_key = default_publisher_key_base()
            .map(|base| PathBuf::from(format!("{}.priv", base.display())));
        let key = remote_publish_key(
            key_arg.as_deref(),
            default_key.as_deref(),
            &root,
            opts.insecure_allow_unsigned,
        )?;
        let cache = crate::tarball::cache_dir_for_url(&url);
        let reg = HttpRegistry::new(&url, cache);
        reg.publish(
            &manifest.package.name,
            &manifest.package.version,
            &root,
            key.as_ref(),
        )?;
        if let Some(key) = &key {
            eprintln!("Signed by {}", key.public_key());
        }
    } else {
        if key_arg.is_some() {
            eprintln!(
                "note: the local filesystem registry does not use package signatures; --key ignored"
            );
        }
        let reg = FsRegistry::new(registry_root());
        reg.publish(&manifest.package.name, &manifest.package.version, &root)?;
    }

    eprintln!(
        "Published {} v{}",
        manifest.package.name, manifest.package.version
    );
    Ok(())
}

fn cmd_keygen(args: &[&String]) -> Result<()> {
    let sub = parse_sub_options("keygen", args, &["--output"], &["--force"])?;
    let force = sub.contains_key("--force");
    let base = match sub.get("--output").cloned().flatten() {
        Some(base) => PathBuf::from(base),
        None => default_publisher_key_base().ok_or_else(|| {
            PkgError::Other("cannot determine home directory; pass --output".into())
        })?,
    };
    if let Some(parent) = base.parent().filter(|p| !p.as_os_str().is_empty()) {
        if !parent.exists() {
            let mut builder = std::fs::DirBuilder::new();
            builder.recursive(true);
            #[cfg(unix)]
            {
                use std::os::unix::fs::DirBuilderExt;
                builder.mode(0o700);
            }
            builder
                .create(parent)
                .map_err(|e| PkgError::io(parent, e))?;
        }
    }
    let generated = signing::generate_keypair(&base, force)?;
    eprintln!(
        "Private key: {} (mode 0600 — keep it secret, never commit or publish it)",
        generated.private_path.display()
    );
    eprintln!("Public key:  {}", generated.public_path.display());
    eprintln!(
        "Consumers trust it by adding the key id below to `trusted-publishers` under \
         [registry] in their riina.toml, or to ~/.riina/{}:",
        signing::USER_TRUST_FILE
    );
    println!("{}", generated.key);
    Ok(())
}

fn cmd_key_id(path: &Path) -> Result<()> {
    println!("{}", signing::read_public_key_file(path)?);
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

fn cmd_tree(registry_url: Option<&str>, insecure_allow_unsigned: bool) -> Result<()> {
    let root = find_project_root()?;
    let manifest = Manifest::from_file(&root.join("riina.toml"))?;
    let deps = manifest.dep_reqs()?;

    eprintln!("{} v{}", manifest.package.name, manifest.package.version);

    if deps.is_empty() {
        return Ok(());
    }

    let reg = make_registry(registry_url, Some(&manifest), insecure_allow_unsigned)?;
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
                signer: None,
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
                signer: None,
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

    // ── Publisher signatures through lock and locked build ──────────────

    use crate::registry::tests::{routes, serve, Fixture};
    use crate::signing::{PublisherSigningKey, TrustPolicy};

    fn app_with_foo() -> (Manifest, BTreeMap<String, VersionReq>) {
        let manifest = Manifest::parse(
            "[pakej]\nnama = \"app\"\nversi = \"0.1.0\"\n\n[kebergantungan]\nfoo = \"^1.0.0\"\n",
            Path::new("riina.toml"),
        )
        .unwrap();
        let deps = manifest.dep_reqs().unwrap();
        (manifest, deps)
    }

    #[test]
    fn lock_pins_signer_and_locked_build_fails_closed_when_it_changes() {
        let fx = Fixture::new("cli_signer");
        let publisher = PublisherSigningKey::from_seed(&[1; 32]);
        let rotated = PublisherSigningKey::from_seed(&[2; 32]);
        let archive = fx.archive("foo", 1);
        let v1 = Version::new(1, 0, 0);
        let signed_by = |key: &PublisherSigningKey| {
            serve(routes(
                "foo",
                archive.clone(),
                Some((
                    200,
                    key.sign_archive("foo", &v1, &archive).render().into_bytes(),
                )),
            ))
        };
        let url_a = signed_by(&publisher);
        let url_b = signed_by(&rotated);
        // BOTH keys trusted: the lock still pins which one signed `foo`.
        let trust = TrustPolicy::new([publisher.public_key(), rotated.public_key()], false);
        let (manifest, deps) = app_with_foo();

        let reg_a = fx.registry(&url_a, "cache-a", trust.clone());
        let lock = lock_dependencies(&manifest, &deps, &reg_a).unwrap();
        assert_eq!(lock.packages[0].signer, Some(publisher.public_key().id()));
        assert!(resolve_locked(&deps, &lock, &reg_a).is_ok());

        // Same bytes, now signed by a different (also trusted) key.
        let reg_b = fx.registry(&url_b, "cache-b", trust.clone());
        assert!(matches!(
            resolve_locked(&deps, &lock, &reg_b),
            Err(PkgError::SignerMismatch { .. })
        ));

        // A riina.lock written before signing pins no signer: refused for a
        // remote package instead of silently adopting today's signer.
        let mut legacy = lock.clone();
        legacy.packages[0].signer = None;
        assert!(matches!(
            resolve_locked(&deps, &legacy, &reg_a),
            Err(PkgError::SignerMismatch { .. })
        ));

        // The same tree from the local filesystem registry has no signer.
        let fs_root = fx.tmp.join("fsreg");
        crate::tarball::unpack(&archive, &fs_root.join("foo/1.0.0")).unwrap();
        assert!(matches!(
            resolve_locked(&deps, &lock, &FsRegistry::new(&fs_root)),
            Err(PkgError::SignerMismatch { .. })
        ));
        assert!(resolve_locked(&deps, &legacy, &FsRegistry::new(&fs_root)).is_ok());
    }

    #[test]
    fn lock_refuses_unsigned_remote_packages_unless_opted_out() {
        let fx = Fixture::new("cli_unsigned");
        let url = serve(routes("foo", fx.archive("foo", 1), None));
        let (manifest, deps) = app_with_foo();

        let strict = fx.registry(&url, "strict", TrustPolicy::default());
        assert!(matches!(
            lock_dependencies(&manifest, &deps, &strict),
            Err(PkgError::SignatureRejected { .. })
        ));

        let insecure = fx.registry(&url, "insecure", TrustPolicy::new([], true));
        let lock = lock_dependencies(&manifest, &deps, &insecure).unwrap();
        assert_eq!(lock.packages[0].signer.as_deref(), Some("unsigned"));
        assert!(!insecure.warnings().is_empty());
        // The locked build needs the opt-out again.
        assert!(resolve_locked(&deps, &lock, &insecure).is_ok());
        let strict_cached = fx.registry(&url, "insecure", TrustPolicy::default());
        assert!(matches!(
            resolve_locked(&deps, &lock, &strict_cached),
            Err(PkgError::SignatureRejected { .. })
        ));
    }

    #[test]
    fn remote_publish_requires_a_key_outside_the_package() {
        let fx = Fixture::new("cli_publish_key");
        let package = fx.tmp.join("pkg");
        std::fs::create_dir_all(&package).unwrap();
        let outside = crate::signing::generate_keypair(&fx.tmp.join("keys"), false).unwrap();
        let inside = crate::signing::generate_keypair(&package.join("oops"), false).unwrap();

        let res = remote_publish_key(None, None, &package, false);
        assert!(
            matches!(&res, Err(PkgError::Other(m)) if m.contains("requires a publisher signing key"))
        );
        assert!(remote_publish_key(None, None, &package, true)
            .unwrap()
            .is_none());

        let res = remote_publish_key(Some(&inside.private_path), None, &package, false);
        assert!(
            matches!(&res, Err(PkgError::Other(m)) if m.contains("inside the package directory"))
        );

        let key = remote_publish_key(Some(&outside.private_path), None, &package, false)
            .unwrap()
            .unwrap();
        assert_eq!(key.public_key(), outside.key);
        // The default key is used when present ...
        let key = remote_publish_key(None, Some(&outside.private_path), &package, false)
            .unwrap()
            .unwrap();
        assert_eq!(key.public_key(), outside.key);
        // ... and ignored when absent.
        assert!(
            remote_publish_key(None, Some(&fx.tmp.join("absent.priv")), &package, false).is_err()
        );
    }

    #[test]
    fn subcommand_options_reject_unknown_arguments() {
        let args: Vec<String> = vec!["--key".into(), "k.priv".into()];
        let refs: Vec<&String> = args.iter().collect();
        let parsed = parse_sub_options("publish", &refs, &["--key"], &[]).unwrap();
        assert_eq!(parsed["--key"].as_deref(), Some("k.priv"));
        let args: Vec<String> = vec!["--kye".into(), "k.priv".into()];
        let refs: Vec<&String> = args.iter().collect();
        assert!(parse_sub_options("publish", &refs, &["--key"], &[]).is_err());
        let args: Vec<String> = vec!["--key".into()];
        let refs: Vec<&String> = args.iter().collect();
        assert!(parse_sub_options("publish", &refs, &["--key"], &[]).is_err());
    }

    /// Audit L6: a non-loopback http registry is refused before any request,
    /// whether it comes from `--registry` or the manifest; the filesystem
    /// registry and loopback http stay available.
    #[test]
    fn make_registry_refuses_remote_plain_http() {
        assert!(make_registry(Some("http://registry.example/api"), None, false).is_err());
        assert!(make_registry(Some("http://127.0.0.1:9/api"), None, false).is_ok());
        assert!(make_registry(None, None, false).is_ok());
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
