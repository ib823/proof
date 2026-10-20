// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The compiler `riinac pkg build` injects into `riina-pkg` (master plan REQ-72).
//!
//! Before REQ-72, `riina_pkg::build::execute_build` carried the comment
//! `// Copy source to output (placeholder for actual compilation)` and did
//! exactly that: it `fs::copy`d `src/*.rii` into `sasaran/` and printed
//! `Built: <name>`. It reported success for a package whose only source called
//! an **undefined function**, and produced no artifact.
//!
//! # Why the compiler is injected rather than imported
//!
//! `riina-pkg` depends only on `riina-types`. Making it depend on the parser,
//! typechecker and backend would let a *second* compile path grow there and
//! silently diverge from `riinac build` — the failure mode this repository
//! keeps finding. Instead `riina-pkg` declares a [`CompileFn`] and `riinac`
//! passes this module, so both paths call the SAME four library entry points:
//!
//! 1. [`riina_parser::modules::resolve_program`] — parse + link `guna` imports
//!    (REQ-71), so a package whose `src/` spans several files builds;
//! 2. `check_program` — the shared Coq-matching frontend;
//! 3. [`riina_codegen::compile`] — lowering, which is also the
//!    compiled-vs-interpreter boundary (REQ-70): a package using an
//!    interpreter-only builtin fails **here**, loudly, instead of producing a
//!    binary that cannot exist;
//! 4. the target backend's `emit`.
//!
//! # Entry points
//!
//! `src/utama.rii` (binary) is preferred over `src/lib.rii` (library), matching
//! `riina_pkg::layout`. A library entry is fully parsed, linked and
//! type-checked but emits no binary — type errors still fail the build.
//!
//! # Effect permissions (`[kesan-dibenarkan]`)
//!
//! Every effect the package's code may exercise — the program's verified
//! effect set, plus every top-level function's and `luaran` declaration's
//! declared set — must fall in a category the package's own manifest allows,
//! or the build fails. Before this check the section was parsed and used only
//! to stop a DEPENDENCY from claiming more than its dependant; nothing compared
//! it with the code, so `IO = false, Network = false` built a networked server.
//! The native binary's runtime capability gate is then seeded with the
//! verified set (never "all capabilities").

use riina_pkg::build::BuiltArtifact;
use riina_pkg::effects::{EffectCategory, EffectPermissions};
use riina_types::{EffectSet, Program, TopLevelDecl};
use std::path::Path;

/// Every effect `program` may exercise: its verified effect set joined with
/// what each top-level function and extern (`luaran`) declaration DECLARES.
/// Declarations count even when uncalled — a package that ships a networked
/// function claims the network, whether or not its entry point calls it.
fn package_effects(program: &Program, verified: EffectSet) -> EffectSet {
    program.decls.iter().fold(verified, |acc, decl| match decl {
        TopLevelDecl::Function {
            effect, effect_set, ..
        } => acc.join(EffectSet::from_declaration(*effect, effect_set)),
        TopLevelDecl::ExternBlock { decls, .. } => decls
            .iter()
            .fold(acc, |acc, d| acc.join(EffectSet::single(d.effect))),
        _ => acc,
    })
}

/// Fail unless the manifest of the package whose entry is `entry`
/// (`<root>/src/<entry>.rii` ⇒ `<root>/riina.toml`) permits every effect in
/// `effects`. A missing or unreadable manifest fails closed.
fn check_manifest_permits(package: &str, entry: &Path, effects: EffectSet) -> Result<(), String> {
    let manifest_path = entry
        .parent()
        .and_then(Path::parent)
        .map(|root| root.join("riina.toml"))
        .ok_or_else(|| format!("cannot locate riina.toml for {}", entry.display()))?;
    let manifest = riina_pkg::manifest::Manifest::from_file(&manifest_path)
        .map_err(|e| format!("cannot read {}: {e}", manifest_path.display()))?;
    let permits = EffectPermissions::from_allowed(&manifest.allowed_effects);
    let denied: Vec<String> = effects
        .iter()
        .filter_map(|e| EffectCategory::from_effect(e).map(|cat| (e, cat)))
        .filter(|(_, cat)| !permits.permits(*cat))
        .map(|(e, cat)| format!("{e:?} (category {})", cat.name()))
        .collect();
    if denied.is_empty() {
        Ok(())
    } else {
        Err(format!(
            "package `{package}` uses effects its manifest does not allow: {}. \
             Set the category to `true` under [kesan-dibenarkan] in {} — or \
             remove the code that needs it.",
            denied.join(", "),
            manifest_path.display()
        ))
    }
}

/// Compile one package. Returns the compiler's own diagnostic on failure, so
/// `pkg build` reports exactly what `riinac build` would.
///
/// `is_library` is decided by the entry file name, not by the manifest: a
/// `lib.rii` entry is checked but emits no binary.
pub fn compile_package(
    package: &str,
    entry: &Path,
    output_dir: &Path,
) -> Result<BuiltArtifact, String> {
    // 1. Parse + resolve modules (REQ-71). `resolve_program` reads the entry's
    //    siblings itself, so a multi-file `src/` links here.
    let source = std::fs::read_to_string(entry)
        .map_err(|e| format!("cannot read {}: {e}", entry.display()))?;
    let program = riina_parser::modules::resolve_program(entry, &source)
        .map_err(|e| format!("{e}"))?;

    // 2. Typecheck through the same frontend as `riinac check`.
    let (expr, _ty, eff) = crate::frontend::check_program(&program).map_err(|e| format!("{e}"))?;

    // 2b. The manifest must allow every effect the code may exercise — for a
    //     library as much as for a binary.
    check_manifest_permits(package, entry, package_effects(&program, eff))?;

    // A library entry is type-checked only. It is NOT a silent pass: any parse,
    // link or type error above has already failed the build.
    let is_library = entry.file_name().map(|f| f == "lib.rii").unwrap_or(false);
    if is_library {
        return Ok(BuiltArtifact {
            entry: entry.to_path_buf(),
            output: None,
        });
    }

    // 3. Lower. This is where an interpreter-only builtin (REQ-70) fails
    //    closed, rather than emitting something that cannot run.
    let ir = riina_codegen::compile(&expr)
        .map_err(|e| format!("Codegen Error: {e}"))?
        .with_capabilities(eff);

    // 4. Emit C and link a native binary with `cc`, exactly as `riinac build`
    //    does for the native target.
    let backend = riina_codegen::backend_for_target(riina_codegen::Target::Native);
    let output = backend.emit(&ir).map_err(|e| format!("Codegen Error: {e}"))?;

    std::fs::create_dir_all(output_dir)
        .map_err(|e| format!("cannot create {}: {e}", output_dir.display()))?;
    let binary = output_dir.join(package);
    let tmp_c = output_dir.join(format!("{package}.c"));
    std::fs::write(&tmp_c, &output.primary)
        .map_err(|e| format!("cannot write {}: {e}", tmp_c.display()))?;

    let status = std::process::Command::new(crate::c_toolchain::C_COMPILER)
        .args(["-o", &binary.to_string_lossy(), &tmp_c.to_string_lossy()])
        .status();
    // Keep the emitted C on failure so the error is diagnosable; remove it on
    // success so `sasaran/` holds artifacts, not scratch.
    match status {
        Ok(s) if s.success() => {
            let _ = std::fs::remove_file(&tmp_c);
            Ok(BuiltArtifact {
                entry: entry.to_path_buf(),
                output: Some(binary),
            })
        }
        Ok(s) => Err(format!(
            "cc exited with {s} (emitted C kept at {})",
            tmp_c.display()
        )),
        Err(e) => {
            let path = std::env::var_os("PATH");
            Err(crate::c_toolchain::invoke_error(&e, path.as_deref()))
        }
    }
}
