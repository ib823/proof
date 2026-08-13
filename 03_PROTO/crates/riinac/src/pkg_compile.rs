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

use riina_pkg::build::BuiltArtifact;
use std::path::Path;

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
    let (expr, _ty, _eff) = crate::frontend::check_program(&program).map_err(|e| format!("{e}"))?;

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
    let ir = riina_codegen::compile(&expr).map_err(|e| format!("Codegen Error: {e}"))?;

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

    let status = std::process::Command::new("cc")
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
        Err(e) => Err(format!("failed to invoke cc: {e}")),
    }
}
