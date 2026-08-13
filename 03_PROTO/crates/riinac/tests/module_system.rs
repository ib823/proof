// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Module system end-to-end tests (master plan REQ-71).
//!
//! Before REQ-71 every RIINA program had to be a single file: `guna kira;`
//! parsed and was discarded, so a two-file program died with
//! `Variable not found`. These tests drive the REAL `riinac` binary over real
//! files on disk — not the resolver in isolation — because the thing REQ-71
//! promises is that a multi-file program *checks, runs, and compiles*.
//!
//! Each test builds its own temporary directory, so they are order-independent
//! and parallel-safe.

use std::path::PathBuf;
use std::process::Command;

/// A throwaway directory that cleans itself up.
struct Sandbox(PathBuf);

impl Sandbox {
    fn new(tag: &str) -> Self {
        // Unique per test name + pid: no cross-test interference, and no
        // dependency on an external temp-dir crate (Law 8: no external deps).
        let dir = std::env::temp_dir().join(format!("riina_req71_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self(dir)
    }

    fn write(&self, name: &str, contents: &str) -> PathBuf {
        let p = self.0.join(name);
        std::fs::write(&p, contents).expect("write module");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}

/// Run `riinac <command> <file>`; returns (success, stdout+stderr).
fn riinac(command: &str, file: &PathBuf, extra: &[&str]) -> (bool, String) {
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg(command)
        .args(extra)
        .arg(file)
        .output()
        .expect("run riinac");
    let mut s = String::from_utf8_lossy(&out.stdout).into_owned();
    s.push_str(&String::from_utf8_lossy(&out.stderr));
    (out.status.success(), s)
}

const KIRA: &str = "\
awam fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih { x + y }
awam fungsi dua_kali(x: Nombor) -> Nombor kesan Bersih { tambah(x, x) }
fungsi rahsia_dalaman(x: Nombor) -> Nombor kesan Bersih { x * 99 }
";

/// The headline REQ-71 promise: a two-file program type-checks, RUNS, and
/// COMPILES to a native binary that prints the right answer.
#[test]
fn two_file_program_checks_runs_and_compiles() {
    let sb = Sandbox::new("two_file");
    sb.write("kira.rii", KIRA);
    let main = sb.write(
        "main.rii",
        "guna kira;
fungsi utama() -> Nombor kesan Tulis {
    biar a = kira::tambah(3, 4);
    cetakln(ke_teks(kira::dua_kali(a)));
    0
}
",
    );

    let (ok, out) = riinac("check", &main, &[]);
    assert!(ok, "check failed: {out}");

    let (ok, out) = riinac("run", &main, &[]);
    assert!(ok, "run failed: {out}");
    assert!(out.contains("14"), "wrong result from run: {out}");

    // The part that distinguishes a module system from file inclusion done by
    // the interpreter: it must survive lowering to C and linking.
    let (ok, out) = riinac("build", &main, &["--run"]);
    assert!(ok, "build failed: {out}");
    assert!(out.contains("14"), "wrong result from compiled binary: {out}");
}

/// A module's internal call to its OWN helper keeps working after the linker
/// renames every top-level name (`tambah` -> `kira_tambah`). This is the
/// regression that a rename pass without reference rewriting would cause.
#[test]
fn module_internal_calls_survive_renaming() {
    let sb = Sandbox::new("internal");
    sb.write("kira.rii", KIRA);
    let main = sb.write(
        "main.rii",
        "guna kira;
fungsi utama() -> Nombor kesan Tulis { cetakln(ke_teks(kira::dua_kali(5))); 0 }
",
    );
    let (ok, out) = riinac("run", &main, &[]);
    assert!(ok, "run failed: {out}");
    assert!(out.contains("10"), "internal call broke: {out}");
}

/// A non-`awam` function is module-private even though linking puts every name
/// in one flat namespace.
#[test]
fn private_function_is_not_reachable_across_modules() {
    let sb = Sandbox::new("private");
    sb.write("kira.rii", KIRA);
    let main = sb.write(
        "main.rii",
        "guna kira;
fungsi utama() -> Nombor kesan Bersih { kira::rahsia_dalaman(2) }
",
    );
    let (ok, out) = riinac("check", &main, &[]);
    assert!(!ok, "private access should fail, got: {out}");
    assert!(out.contains("private"), "unhelpful message: {out}");
    assert!(out.contains("awam"), "message should say how to fix: {out}");
}

/// An import cycle reports the chain instead of recursing to death.
#[test]
fn circular_import_is_reported_not_stack_overflow() {
    let sb = Sandbox::new("cycle");
    sb.write(
        "a.rii",
        "guna b;\nawam fungsi fa() -> Nombor kesan Bersih { b::fb() }\n",
    );
    sb.write(
        "b.rii",
        "guna a;\nawam fungsi fb() -> Nombor kesan Bersih { a::fa() }\n",
    );
    let main = sb.write(
        "main.rii",
        "guna a;\nfungsi utama() -> Nombor kesan Bersih { a::fa() }\n",
    );
    let (ok, out) = riinac("check", &main, &[]);
    assert!(!ok, "cycle should fail, got: {out}");
    assert!(out.contains("circular import"), "wrong error: {out}");
}

/// A missing module names the file it looked for, and points at the builtin
/// syntax — the mistake this error is most often hiding.
#[test]
fn missing_module_names_the_expected_file() {
    let sb = Sandbox::new("missing");
    let main = sb.write(
        "main.rii",
        "guna tiada_ini;\nfungsi utama() -> Nombor kesan Bersih { 0 }\n",
    );
    let (ok, out) = riinac("check", &main, &[]);
    assert!(!ok, "missing module should fail, got: {out}");
    assert!(out.contains("tiada_ini.rii"), "wrong error: {out}");
}

/// Two modules producing the same linked name is an error, never silent
/// shadowing. Root `kira_tambah` collides with module `kira`'s `tambah`.
#[test]
fn name_collision_is_rejected() {
    let sb = Sandbox::new("collide");
    sb.write("kira.rii", KIRA);
    let main = sb.write(
        "main.rii",
        "guna kira;
fungsi kira_tambah(x: Nombor) -> Nombor kesan Bersih { x }
fungsi utama() -> Nombor kesan Bersih { kira::tambah(1, 2) }
",
    );
    let (ok, out) = riinac("check", &main, &[]);
    assert!(!ok, "collision should fail, got: {out}");
    assert!(out.contains("collision"), "wrong error: {out}");
}

/// A transitively-loaded module is present in the linked program but is NOT
/// silently in scope — naming it requires importing it.
#[test]
fn transitive_module_requires_direct_import() {
    let sb = Sandbox::new("transitive");
    sb.write("deep.rii", "awam fungsi jauh() -> Nombor kesan Bersih { 7 }\n");
    sb.write(
        "mid.rii",
        "guna deep;\nawam fungsi pertengahan() -> Nombor kesan Bersih { deep::jauh() }\n",
    );

    // Reaching THROUGH mid into deep is rejected...
    let bad = sb.write(
        "bad.rii",
        "guna mid;\nfungsi utama() -> Nombor kesan Bersih { deep::jauh() }\n",
    );
    let (ok, out) = riinac("check", &bad, &[]);
    assert!(!ok, "un-imported access should fail, got: {out}");
    assert!(out.contains("without importing"), "wrong error: {out}");

    // ...while the legitimate chain root -> mid -> deep still works.
    let good = sb.write(
        "good.rii",
        "guna mid;\nfungsi utama() -> Nombor kesan Tulis { cetakln(ke_teks(mid::pertengahan())); 0 }\n",
    );
    let (ok, out) = riinac("run", &good, &[]);
    assert!(ok, "legit transitive chain failed: {out}");
    assert!(out.contains('7'), "wrong result: {out}");
}

/// A diamond (root -> x, y; both -> shared) loads `shared` once and links.
#[test]
fn diamond_import_links_shared_module_once() {
    let sb = Sandbox::new("diamond");
    sb.write("shared.rii", "awam fungsi asas() -> Nombor kesan Bersih { 5 }\n");
    sb.write(
        "x.rii",
        "guna shared;\nawam fungsi fx() -> Nombor kesan Bersih { shared::asas() + 1 }\n",
    );
    sb.write(
        "y.rii",
        "guna shared;\nawam fungsi fy() -> Nombor kesan Bersih { shared::asas() + 2 }\n",
    );
    let main = sb.write(
        "main.rii",
        "guna x;\nguna y;\nfungsi utama() -> Nombor kesan Tulis { cetakln(ke_teks(x::fx() + y::fy())); 0 }\n",
    );
    let (ok, out) = riinac("run", &main, &[]);
    assert!(ok, "diamond failed: {out}");
    assert!(out.contains("13"), "wrong result: {out}");
}

/// A local binding that shadows an imported module's function name must win
/// locally without breaking the qualified call.
#[test]
fn local_binding_shadows_without_breaking_qualified_call() {
    let sb = Sandbox::new("shadow");
    sb.write("kira.rii", KIRA);
    let main = sb.write(
        "main.rii",
        "guna kira;
fungsi utama() -> Nombor kesan Tulis {
    biar tambah = 100;
    cetakln(ke_teks(tambah));
    cetakln(ke_teks(kira::tambah(1, 2)));
    0
}
",
    );
    let (ok, out) = riinac("run", &main, &[]);
    assert!(ok, "run failed: {out}");
    assert!(out.contains("100"), "local binding lost: {out}");
    assert!(out.contains('3'), "qualified call broke: {out}");
}

/// `guna std::teks;` names the BUILTIN namespace, has no file behind it, and
/// must not be treated as a missing module. This is what keeps every
/// pre-REQ-71 example compiling.
#[test]
fn qualified_builtin_import_is_not_a_file_import() {
    let sb = Sandbox::new("builtin_use");
    let main = sb.write(
        "main.rii",
        "guna std::teks;
guna std::senarai;
fungsi utama() -> Nombor kesan Tulis { cetakln(gabung_teks((\"a\", \"b\"))); 0 }
",
    );
    let (ok, out) = riinac("run", &main, &[]);
    assert!(ok, "builtin-namespace import broke: {out}");
    assert!(out.contains("ab"), "wrong result: {out}");
}

/// An imported module may not carry top-level code — only the root file has a
/// program body, and silently dropping a module's body would lose work.
#[test]
fn top_level_code_in_imported_module_is_rejected() {
    let sb = Sandbox::new("modbody");
    sb.write(
        "berkesan.rii",
        "awam fungsi f() -> Nombor kesan Bersih { 1 }\ncetakln(\"kesan sampingan\");\n",
    );
    let main = sb.write(
        "main.rii",
        "guna berkesan;\nfungsi utama() -> Nombor kesan Bersih { berkesan::f() }\n",
    );
    let (ok, out) = riinac("check", &main, &[]);
    assert!(!ok, "module body should be rejected, got: {out}");
    assert!(out.contains("top-level code"), "wrong error: {out}");
}
