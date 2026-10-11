// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `riinac build --run`, the build's temporary files, `test --update` and
//! `doc`, as found by the 2026-10 compiler audit.
//!
//! * `build x.rii --run` executed the output through `Command::new("x")`,
//!   a `$PATH` lookup: `build id.rii --run` ran `/usr/bin/id`.
//! * The intermediate C went to the predictable `$TMPDIR/riina_<stem>.c` via
//!   `fs::write`, which follows symlinks: a planted link's target was
//!   overwritten with the generated C.
//! * `test --update` replaced the first matching quoted string ANYWHERE in the
//!   file, rewriting an unrelated function's literal.
//! * `doc` pasted test names, doc comments and the title into HTML raw.

use std::path::{Path, PathBuf};
use std::process::Command;

struct Sandbox {
    dir: PathBuf,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let dir = std::env::temp_dir().join(format!("riina_cli_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self { dir }
    }

    fn file(&self, name: &str, contents: &str) -> PathBuf {
        let p = self.dir.join(name);
        std::fs::write(&p, contents).expect("write");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

fn cc_available() -> bool {
    let ok = Command::new("cc")
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false);
    if !ok && std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_err() {
        panic!("`cc` is required (set RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately)");
    }
    ok
}

/// A `PATH` whose first entry holds an executable named `name` that prints
/// `IMPOSTOR`, followed by the real `PATH` (so `cc` is still found).
fn path_with_impostor(sb: &Sandbox, name: &str) -> String {
    let bin = sb.dir.join("impostor-bin");
    std::fs::create_dir_all(&bin).unwrap();
    let exe = bin.join(name);
    std::fs::write(&exe, "#!/bin/sh\necho IMPOSTOR\n").unwrap();
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        std::fs::set_permissions(&exe, std::fs::Permissions::from_mode(0o755)).unwrap();
    }
    format!(
        "{}:{}",
        bin.display(),
        std::env::var("PATH").unwrap_or_default()
    )
}

/// `riinac build <stem>.rii --run`, from inside the sandbox, must run the
/// program it just built — never a same-named command found on `$PATH`.
#[test]
fn build_run_executes_the_built_artifact_not_a_path_lookup() {
    if !cc_available() {
        return;
    }
    let sb = Sandbox::new("run");
    // `id` is the audit's reproducer (/usr/bin/id); the impostor makes the
    // test independent of what the host's PATH happens to contain.
    sb.file(
        "id.rii",
        "fungsi utama() -> Unit kesan Tulis { cetak(\"RIINA PROGRAM RAN\") }\n",
    );
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "id.rii", "--run"])
        .current_dir(&sb.dir)
        .env("PATH", path_with_impostor(&sb, "id"))
        .output()
        .expect("riinac build --run");
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(out.status.success(), "{}", String::from_utf8_lossy(&out.stderr));
    assert!(stdout.contains("RIINA PROGRAM RAN"), "ran the wrong thing: {stdout:?}");
    assert!(!stdout.contains("IMPOSTOR"), "a $PATH lookup ran {stdout:?}");
}

/// Symlinks planted where the old build put its C file — and an attacker
/// cannot predict the new private directory — leave their targets untouched;
/// the build still succeeds and leaves nothing behind in `$TMPDIR`.
#[test]
fn build_temp_files_are_private_and_never_follow_symlinks() {
    if !cc_available() {
        return;
    }
    let sb = Sandbox::new("tmp");
    let tmpdir = sb.dir.join("tmp");
    std::fs::create_dir_all(&tmpdir).unwrap();
    let victim = sb.file("victim.txt", "precious\n");
    let src = sb.file(
        "korban.rii",
        "fungsi utama() -> Unit kesan Tulis { cetak(\"ok\") }\n",
    );
    #[cfg(unix)]
    {
        std::os::unix::fs::symlink(&victim, tmpdir.join("riina_korban.c")).unwrap();
        std::os::unix::fs::symlink(&victim, tmpdir.join("korban.c")).unwrap();
    }
    let before: Vec<_> = list(&tmpdir);
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&src)
        .env("TMPDIR", &tmpdir)
        .output()
        .expect("riinac build");
    assert!(out.status.success(), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(std::fs::read_to_string(&victim).unwrap(), "precious\n");
    assert_eq!(list(&tmpdir), before, "the build must clean up after itself");
    let run = Command::new(sb.dir.join("korban")).output().expect("run");
    assert_eq!(String::from_utf8_lossy(&run.stdout), "ok");
}

fn list(dir: &Path) -> Vec<String> {
    let mut names: Vec<String> = std::fs::read_dir(dir)
        .unwrap()
        .map(|e| e.unwrap().file_name().to_string_lossy().into_owned())
        .collect();
    names.sort();
    names
}

/// `test --update` rewrites only the failing assertion's expected literal.
#[test]
fn test_update_rewrites_only_the_failing_assertion() {
    let sb = Sandbox::new("update");
    let original = "fungsi kata_laluan_lalai() -> Teks kesan Bersih { \"rahsia\" }\n\
                    fungsi sapa(x: Nombor) -> Teks kesan Bersih { \"hai\" }\n\
                    ujian \"sapa\" { jangkakan((sapa(1), \"rahsia\")) }\n";
    let f = sb.file("upd.rii", original);
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["test", "--update"])
        .arg(&f)
        .output()
        .expect("riinac test --update");
    assert!(out.status.success(), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        std::fs::read_to_string(&f).unwrap(),
        "fungsi kata_laluan_lalai() -> Teks kesan Bersih { \"rahsia\" }\n\
         fungsi sapa(x: Nombor) -> Teks kesan Bersih { \"hai\" }\n\
         ujian \"sapa\" { jangkakan((sapa(1), \"hai\")) }\n"
    );
    // And the updated file now passes.
    let again = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("test")
        .arg(&f)
        .output()
        .expect("riinac test");
    assert!(again.status.success(), "{}", String::from_utf8_lossy(&again.stderr));
}

/// `doc` output carries no live markup from the program.
#[test]
fn doc_output_escapes_program_text() {
    let sb = Sandbox::new("doc");
    let f = sb.file(
        "t_doc.rii",
        "/// Fungsi biasa <img src=x onerror=alert(document.domain)>\n\
         fungsi f(x: Nombor) -> Nombor kesan Bersih { x }\n\
         ujian \"<script>alert(1)</script>\" { tegaskan(betul) }\n",
    );
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("doc")
        .arg(&f)
        .output()
        .expect("riinac doc");
    assert!(out.status.success(), "{}", String::from_utf8_lossy(&out.stderr));
    let html = String::from_utf8_lossy(&out.stdout);
    assert!(!html.contains("<script>"), "{html}");
    assert!(!html.contains("<img"), "{html}");
    assert!(html.contains("&lt;script&gt;alert(1)&lt;/script&gt;"), "{html}");
    // Anchors use a safe alphabet only.
    for href in html.split("href=\"#").skip(1) {
        let id = href.split('"').next().unwrap();
        assert!(
            id.chars().all(|c| c.is_ascii_alphanumeric() || c == '-' || c == '_'),
            "unsafe anchor {id:?}"
        );
    }
}
