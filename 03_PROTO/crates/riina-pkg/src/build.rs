// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Build orchestration: topological order build of resolved packages.

use crate::error::{PkgError, Result};
use crate::resolve::ResolvedGraph;
use std::path::{Path, PathBuf};

/// Build plan entry.
#[derive(Debug, Clone)]
pub struct BuildStep {
    pub name: String,
    pub source_dir: PathBuf,
    pub output_dir: PathBuf,
}

/// Build configuration.
#[derive(Debug, Clone)]
pub struct BuildConfig {
    pub project_root: PathBuf,
    pub target_dir: PathBuf,
    pub registry_root: PathBuf,
}

impl BuildConfig {
    pub fn new(project_root: impl Into<PathBuf>) -> Self {
        let root: PathBuf = project_root.into();
        let target_dir = root.join("sasaran");
        Self {
            project_root: root,
            target_dir,
            registry_root: PathBuf::new(),
        }
    }

    pub fn with_registry(mut self, root: impl Into<PathBuf>) -> Self {
        self.registry_root = root.into();
        self
    }
}

/// Generate a build plan from a resolved graph.
pub fn build_plan(
    graph: &ResolvedGraph,
    config: &BuildConfig,
    root_package: &str,
) -> Result<Vec<BuildStep>> {
    let order = graph.topological_order()?;
    let mut steps = Vec::new();

    for name in &order {
        let pkg = graph
            .packages
            .get(name)
            .ok_or_else(|| PkgError::Other(format!("package '{name}' not in graph")))?;

        let source_dir = if name == root_package {
            config.project_root.clone()
        } else {
            config
                .registry_root
                .join(&pkg.name)
                .join(pkg.version.to_string())
        };

        let output_dir = config.target_dir.join(&pkg.name);

        steps.push(BuildStep {
            name: pkg.name.clone(),
            source_dir,
            output_dir,
        });
    }

    Ok(steps)
}

/// How a build step is compiled.
///
/// `riina-pkg` deliberately does NOT depend on the compiler crates. Instead the
/// caller (`riinac`) injects the real pipeline, so `pkg build` and
/// `riinac build` go through the SAME parser, module resolver, typechecker and
/// backend rather than two paths that can silently disagree.
///
/// Contract: given a package name, its entry module, and its output directory,
/// either produce the artifact or return the compiler's diagnostic verbatim.
pub type CompileFn<'a> = &'a dyn Fn(&str, &Path, &Path) -> std::result::Result<BuiltArtifact, String>;

/// What a compiled step produced, for reporting.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct BuiltArtifact {
    /// The entry module that was compiled.
    pub entry: PathBuf,
    /// The emitted artifact, when the step produced one (a binary entry). A
    /// library entry is type-checked but emits no binary, and is `None`.
    pub output: Option<PathBuf>,
}

/// Locate a package's entry module: `src/utama.rii` (binary) or `src/lib.rii`
/// (library), matching [`crate::layout`].
///
/// # Errors
/// [`PkgError::NoEntryPoint`] when neither exists.
pub fn entry_module(package: &str, source_dir: &Path) -> Result<PathBuf> {
    let src = source_dir.join("src");
    for candidate in ["utama.rii", "lib.rii"] {
        let p = src.join(candidate);
        if p.is_file() {
            return Ok(p);
        }
    }
    Err(PkgError::NoEntryPoint {
        package: package.to_string(),
        src_dir: src,
    })
}

/// Execute a build plan by actually COMPILING each step (REQ-72).
///
/// Before REQ-72 this function copied `src/*.rii` into the target directory and
/// printed `Built: <name>` — it reported success for a package whose only
/// source called an undefined function, and produced no artifact. It now runs
/// `compile` for every step and propagates the first failure, so a package that
/// does not compile can no longer report success.
///
/// # Errors
/// Returns the first step's [`PkgError::CompileFailed`], or an IO error if the
/// output directory cannot be created.
pub fn execute_build(steps: &[BuildStep], compile: CompileFn<'_>) -> Result<Vec<BuiltArtifact>> {
    let mut built = Vec::new();
    for step in steps {
        std::fs::create_dir_all(&step.output_dir).map_err(|e| PkgError::io(&step.output_dir, e))?;

        // A step with no src/ directory contributes nothing to build. This is
        // NOT a silent pass for a broken package: `entry_module` below is what
        // decides, and it errors when src/ exists but has no entry module.
        if !step.source_dir.join("src").is_dir() {
            continue;
        }

        let entry = entry_module(&step.name, &step.source_dir)?;
        let artifact = compile(&step.name, &entry, &step.output_dir)
            .map_err(|detail| PkgError::CompileFailed {
                package: step.name.clone(),
                detail,
            })?;
        match &artifact.output {
            Some(out) => eprintln!("  Built: {} -> {}", step.name, out.display()),
            None => eprintln!("  Checked: {} (library, no binary emitted)", step.name),
        }
        built.push(artifact);
    }
    Ok(built)
}

/// Remove a build output directory.
///
/// # Errors
/// Returns an IO error if the directory exists but cannot be removed.
pub fn clean(target_dir: &Path) -> Result<()> {
    if target_dir.exists() {
        std::fs::remove_dir_all(target_dir).map_err(|e| PkgError::io(target_dir, e))?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::resolve::{ResolvedGraph, ResolvedPackage};
    use crate::version::Version;
    use std::collections::BTreeMap;

    #[test]
    fn build_plan_order() {
        let mut packages = BTreeMap::new();
        packages.insert(
            "leaf".to_string(),
            ResolvedPackage {
                name: "leaf".to_string(),
                version: Version::new(1, 0, 0),
                deps: vec![],
            },
        );
        packages.insert(
            "root".to_string(),
            ResolvedPackage {
                name: "root".to_string(),
                version: Version::new(0, 1, 0),
                deps: vec!["leaf".to_string()],
            },
        );

        let graph = ResolvedGraph { packages };
        let config = BuildConfig::new("/project").with_registry("/reg");
        let steps = build_plan(&graph, &config, "root").unwrap();

        assert_eq!(steps.len(), 2);
        assert_eq!(steps[0].name, "leaf");
        assert_eq!(steps[1].name, "root");
        assert_eq!(steps[1].source_dir, PathBuf::from("/project"));
    }

    /// Scratch package dir that cleans itself up.
    struct Tmp(PathBuf);
    impl Tmp {
        fn new(tag: &str) -> Self {
            let d = std::env::temp_dir().join(format!("riina_pkgbuild_{tag}_{}", std::process::id()));
            let _ = std::fs::remove_dir_all(&d);
            std::fs::create_dir_all(d.join("src")).unwrap();
            Self(d)
        }
    }
    impl Drop for Tmp {
        fn drop(&mut self) {
            let _ = std::fs::remove_dir_all(&self.0);
        }
    }

    fn step_for(dir: &Path) -> BuildStep {
        BuildStep {
            name: "ujian".into(),
            source_dir: dir.to_path_buf(),
            output_dir: dir.join("sasaran/ujian"),
        }
    }

    /// A failing compiler must fail the build. This is the REQ-72 contract at
    /// the crate boundary: `execute_build` has no path that reports success
    /// without the injected compiler agreeing.
    #[test]
    fn compiler_failure_fails_the_build() {
        let t = Tmp::new("fail");
        std::fs::write(t.0.join("src/lib.rii"), "fungsi utama() {}\n").unwrap();
        let steps = [step_for(&t.0)];

        let err = execute_build(&steps, &|_, _, _| Err("boom".to_string()))
            .expect_err("must propagate compiler failure");
        match err {
            PkgError::CompileFailed { package, detail } => {
                assert_eq!(package, "ujian");
                assert_eq!(detail, "boom");
            }
            other => panic!("wrong error: {other:?}"),
        }
    }

    /// The compiler is invoked once per step, with that step's entry module.
    #[test]
    fn compiler_is_invoked_with_the_entry_module() {
        let t = Tmp::new("entry");
        std::fs::write(t.0.join("src/utama.rii"), "fungsi utama() {}\n").unwrap();
        let steps = [step_for(&t.0)];

        let seen = std::cell::RefCell::new(Vec::new());
        let built = execute_build(&steps, &|_, entry, _| {
            seen.borrow_mut().push(entry.to_path_buf());
            Ok(BuiltArtifact {
                entry: entry.to_path_buf(),
                output: None,
            })
        })
        .expect("build");
        assert_eq!(built.len(), 1);
        assert_eq!(seen.borrow().len(), 1);
        assert!(seen.borrow()[0].ends_with("src/utama.rii"));
    }

    /// `src/utama.rii` (binary) wins over `src/lib.rii` (library).
    #[test]
    fn binary_entry_is_preferred_over_library_entry() {
        let t = Tmp::new("prefer");
        std::fs::write(t.0.join("src/lib.rii"), "").unwrap();
        std::fs::write(t.0.join("src/utama.rii"), "").unwrap();
        let entry = entry_module("ujian", &t.0).expect("entry");
        assert!(entry.ends_with("src/utama.rii"), "got {}", entry.display());
    }

    /// A `src/` with no entry module is an error, not an empty success.
    #[test]
    fn missing_entry_module_is_an_error() {
        let t = Tmp::new("noentry");
        let steps = [step_for(&t.0)];
        let err = execute_build(&steps, &|_, entry, _| {
            Ok(BuiltArtifact {
                entry: entry.to_path_buf(),
                output: None,
            })
        })
        .expect_err("must reject a package with no entry module");
        assert!(matches!(err, PkgError::NoEntryPoint { .. }), "got {err:?}");
    }
}
