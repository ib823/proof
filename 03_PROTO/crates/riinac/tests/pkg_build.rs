// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `riinac pkg build` really compiles (master plan REQ-72).
//!
//! Before REQ-72, `riina_pkg::build::execute_build` carried the comment
//! `// Copy source to output (placeholder for actual compilation)` and did
//! exactly that. It printed `Built: <name>` / `Build complete.` and exited 0
//! for a package whose only source called an **undefined function**, and left
//! copied `.rii` files in `sasaran/` instead of an artifact.
//!
//! The load-bearing test here is [`package_with_type_error_fails_to_build`]:
//! a build system that cannot fail is not a build system. The rest pin that it
//! also SUCCEEDS correctly — a real binary that runs and prints the right
//! answer, including a multi-file package (REQ-71).
//!
//! These drive the real `riinac` binary against real packages on disk, because
//! the injected-compiler wiring is exactly what could regress.

use std::path::{Path, PathBuf};
use std::process::Command;

/// A throwaway package directory that cleans itself up.
struct Pkg(PathBuf);

impl Pkg {
    /// Create a package via `riinac pkg init`, so the test exercises the real
    /// scaffold rather than a hand-written manifest.
    fn new(tag: &str) -> Self {
        let dir = std::env::temp_dir().join(format!("riina_req72_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create package dir");
        let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
            .args(["pkg", "init", "ujian"])
            .current_dir(&dir)
            .output()
            .expect("run pkg init");
        assert!(
            out.status.success(),
            "pkg init failed: {}",
            String::from_utf8_lossy(&out.stderr)
        );
        Self(dir)
    }

    fn src(&self, name: &str, contents: &str) {
        let p = self.0.join("src").join(name);
        std::fs::write(&p, contents).expect("write source");
    }

    fn rm_src(&self, name: &str) {
        let _ = std::fs::remove_file(self.0.join("src").join(name));
    }

    /// Run `riinac pkg build`; returns (success, stdout+stderr).
    fn build(&self) -> (bool, String) {
        let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
            .args(["pkg", "build"])
            .current_dir(&self.0)
            .output()
            .expect("run pkg build");
        let mut s = String::from_utf8_lossy(&out.stdout).into_owned();
        s.push_str(&String::from_utf8_lossy(&out.stderr));
        (out.status.success(), s)
    }

    fn target(&self) -> PathBuf {
        self.0.join("sasaran")
    }
}

impl Drop for Pkg {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}

/// Collect every file under a directory (empty when it does not exist).
fn files_under(dir: &Path) -> Vec<PathBuf> {
    let mut out = Vec::new();
    let Ok(entries) = std::fs::read_dir(dir) else {
        return out;
    };
    for e in entries.flatten() {
        let p = e.path();
        if p.is_dir() {
            out.extend(files_under(&p));
        } else {
            out.push(p);
        }
    }
    out
}

/// THE REQ-72 regression: a package that does not compile must not report
/// success. This is the exact source that made the old placeholder print
/// `Built: ujian` and exit 0.
#[test]
fn package_with_type_error_fails_to_build() {
    let pkg = Pkg::new("typeerr");
    pkg.src(
        "lib.rii",
        "fungsi utama() -> Nombor kesan Bersih { INI_TIDAK_WUJUD() }\n",
    );

    let (ok, out) = pkg.build();
    assert!(!ok, "a package with a type error must NOT build: {out}");
    assert!(
        out.contains("failed to compile"),
        "error should name the failure: {out}"
    );
    assert!(
        !out.contains("Build complete"),
        "must not claim success: {out}"
    );
}

/// A genuine type mismatch (not just an unbound name) also fails.
#[test]
fn package_with_wrong_return_type_fails_to_build() {
    let pkg = Pkg::new("rettype");
    pkg.src(
        "lib.rii",
        "fungsi utama() -> Nombor kesan Bersih { \"bukan nombor\" }\n",
    );
    let (ok, out) = pkg.build();
    assert!(!ok, "type mismatch must fail the build: {out}");
    assert!(out.contains("failed to compile"), "wrong error: {out}");
}

/// A package using an interpreter-only builtin (REQ-70) fails at lowering
/// rather than emitting a binary that cannot exist.
///
/// The example used to be `jaring_dengar`. It is not any more, because that
/// builtin now compiles — `fail_baca` is one of the families still unrouted, so
/// it is what still exercises the boundary. Update this again when `fail_*`
/// lands; the test is about the boundary existing, not about which side any
/// particular builtin is on.
#[test]
fn package_using_interpreter_only_builtin_fails_at_codegen() {
    let pkg = Pkg::new("interponly");
    pkg.rm_src("lib.rii");
    pkg.src(
        "utama.rii",
        "fungsi utama() -> Nombor kesan (SistemFail | Tulis) {\n\
         \x20   cetakln(fail_baca(\"nota.txt\"));\n\
         \x20   0\n\
         }\n",
    );
    let (ok, out) = pkg.build();
    assert!(!ok, "interpreter-only builtin must fail the build: {out}");
    assert!(
        out.contains("unbound variable"),
        "should surface the codegen boundary: {out}"
    );
}

/// A binary package produces a REAL executable that runs and prints the right
/// answer — and the package spans two files, so this also proves `pkg build`
/// goes through the REQ-71 module resolver.
#[test]
fn multi_file_binary_package_produces_a_working_executable() {
    let pkg = Pkg::new("bin");
    pkg.rm_src("lib.rii");
    pkg.src(
        "kira.rii",
        "awam fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih { x + y }\n",
    );
    pkg.src(
        "utama.rii",
        "guna kira;\n\
         fungsi utama() -> Nombor kesan Tulis { cetakln(ke_teks(kira::tambah(20, 22))); 0 }\n",
    );

    let (ok, out) = pkg.build();
    assert!(ok, "valid package failed to build: {out}");

    let binary = pkg.target().join("ujian").join("ujian");
    assert!(
        binary.is_file(),
        "no artifact at {}; produced: {:?}",
        binary.display(),
        files_under(&pkg.target())
    );

    let run = Command::new(&binary).output().expect("run built binary");
    let stdout = String::from_utf8_lossy(&run.stdout);
    assert!(
        run.status.success() && stdout.contains("42"),
        "built binary misbehaved: status={:?} stdout={stdout}",
        run.status
    );
}

/// The old placeholder left copied `.rii` sources in `sasaran/`. A real build
/// emits artifacts, never source.
#[test]
fn target_dir_holds_artifacts_not_copied_sources() {
    let pkg = Pkg::new("noscopy");
    pkg.rm_src("lib.rii");
    pkg.src(
        "utama.rii",
        "fungsi utama() -> Nombor kesan Tulis { cetakln(\"hai\"); 0 }\n",
    );
    let (ok, out) = pkg.build();
    assert!(ok, "build failed: {out}");

    let copied: Vec<_> = files_under(&pkg.target())
        .into_iter()
        .filter(|p| p.extension().is_some_and(|e| e == "rii"))
        .collect();
    assert!(
        copied.is_empty(),
        "sasaran/ contains copied source: {copied:?}"
    );
}

/// A library package (`lib.rii`) is type-checked but emits no binary — and a
/// broken library still fails, so "no binary" is never a silent pass.
#[test]
fn library_package_is_checked_without_emitting_a_binary() {
    let pkg = Pkg::new("lib");
    pkg.src(
        "lib.rii",
        "awam fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih { x + y }\n",
    );
    let (ok, out) = pkg.build();
    assert!(ok, "valid library failed to build: {out}");
    assert!(out.contains("library"), "should say it emitted no binary: {out}");
    assert!(
        !pkg.target().join("ujian").join("ujian").exists(),
        "library must not emit a binary"
    );
}

/// A package with a `src/` but no entry module is an error naming both
/// candidates, not a silent success.
#[test]
fn package_without_entry_module_is_an_error() {
    let pkg = Pkg::new("noentry");
    pkg.rm_src("lib.rii");
    let (ok, out) = pkg.build();
    assert!(!ok, "missing entry module must fail: {out}");
    assert!(out.contains("no entry module"), "wrong error: {out}");
    assert!(
        out.contains("utama.rii") && out.contains("lib.rii"),
        "error should name both candidates: {out}"
    );
}

/// Module visibility (REQ-71) is enforced inside a package too.
#[test]
fn private_cross_module_access_fails_package_build() {
    let pkg = Pkg::new("private");
    pkg.rm_src("lib.rii");
    pkg.src(
        "kira.rii",
        "fungsi tersembunyi() -> Nombor kesan Bersih { 1 }\n",
    );
    pkg.src(
        "utama.rii",
        "guna kira;\nfungsi utama() -> Nombor kesan Bersih { kira::tersembunyi() }\n",
    );
    let (ok, out) = pkg.build();
    assert!(!ok, "private access must fail the package build: {out}");
    assert!(out.contains("private"), "wrong error: {out}");
}
