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
//!
//! And argument handling, as found by the 2026-10-19 assessment:
//!
//! * a second input file silently replaced the first, so `riinac check
//!   leaky.rii ok.rii` checked only `ok.rii` and exited 0;
//! * an unknown command fell through to `check` on the next argument, so
//!   `riinac emit-core x.rii` printed "Success!";
//! * `--version`/`--help` were "Unknown option" and every banner said v0.1.0.

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

const LEAKS_A_SECRET: &str = "fungsi utama() -> Unit kesan Tulis {\n    biar pin = sulit 1234;\n    cetak(pin)\n}\n";
const WELL_TYPED: &str = "fungsi utama() -> Unit kesan Tulis { cetak(\"hai\") }\n";

fn riinac(dir: &Path, args: &[&str]) -> std::process::Output {
    Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(args)
        .current_dir(dir)
        .output()
        .expect("riinac")
}

/// Every extra input file is refused, in either order and with or without an
/// explicit command — never resolved by checking only one of them.
#[test]
fn a_second_input_file_is_refused_not_silently_dropped() {
    let sb = Sandbox::new("twofiles");
    sb.file("leak.rii", LEAKS_A_SECRET);
    sb.file("ok.rii", WELL_TYPED);
    // Control: each file alone gives its own verdict.
    assert!(!riinac(&sb.dir, &["check", "leak.rii"]).status.success());
    assert!(riinac(&sb.dir, &["check", "ok.rii"]).status.success());
    for args in [
        &["check", "leak.rii", "ok.rii"][..],
        &["check", "ok.rii", "leak.rii"][..],
        &["leak.rii", "ok.rii"][..],
        &["run", "ok.rii", "leak.rii"][..],
        &["build", "ok.rii", "leak.rii"][..],
    ] {
        let out = riinac(&sb.dir, args);
        let stderr = String::from_utf8_lossy(&out.stderr);
        assert!(!out.status.success(), "{args:?} succeeded: {stderr}");
        assert!(stderr.contains("Only one input file"), "{args:?}: {stderr}");
    }
}

/// An unknown command is an error. The documented `riinac <file.rii>`
/// shorthand for `check` keeps working.
#[test]
fn an_unknown_command_is_an_error_not_a_silent_check() {
    let sb = Sandbox::new("unknowncmd");
    sb.file("ok.rii", WELL_TYPED);
    for cmd in ["emit-core", "chek", "totally-bogus"] {
        let out = riinac(&sb.dir, &[cmd, "ok.rii"]);
        let stderr = String::from_utf8_lossy(&out.stderr);
        assert!(!out.status.success(), "`riinac {cmd}` succeeded");
        assert!(stderr.contains("Unknown command"), "{cmd}: {stderr}");
        assert!(!stderr.contains("Success"), "{cmd}: {stderr}");
    }
    let out = riinac(&sb.dir, &["ok.rii"]);
    assert!(out.status.success(), "{}", String::from_utf8_lossy(&out.stderr));
}

/// `--version` and `--help` (and their short and bare-word forms) succeed and
/// print to stdout; banners carry the real crate version.
#[test]
fn version_and_help_work_and_banners_carry_the_crate_version() {
    let sb = Sandbox::new("version");
    let expected = format!("riinac {}", env!("CARGO_PKG_VERSION"));
    for flag in ["--version", "-V", "version"] {
        let out = riinac(&sb.dir, &[flag]);
        assert!(out.status.success(), "{flag}");
        assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), expected, "{flag}");
    }
    for flag in ["--help", "-h", "help"] {
        let out = riinac(&sb.dir, &[flag]);
        assert!(out.status.success(), "{flag}");
        let stdout = String::from_utf8_lossy(&out.stdout);
        assert!(stdout.contains("Usage: riinac"), "{flag}: {stdout}");
        assert!(stdout.contains("Exactly one input file"), "{flag}: {stdout}");
    }
    sb.file("ok.rii", WELL_TYPED);
    let out = riinac(&sb.dir, &["check", "ok.rii"]);
    let banner = format!("RIINA Compiler v{}", env!("CARGO_PKG_VERSION"));
    assert!(String::from_utf8_lossy(&out.stderr).contains(&banner));
}

/// A compliance run over a program that uses RIINA's crypto says the crypto
/// is experimental and not validated (owner ruling D8); one without crypto
/// does not.
#[test]
fn compliance_runs_flag_unvalidated_crypto() {
    let sb = Sandbox::new("cryptonotice");
    sb.file(
        "k.rii",
        "fungsi utama() -> Unit kesan Kripto { biar h = hash_dengan(\"sha3-256\"); () }\n",
    );
    sb.file("ok.rii", WELL_TYPED);
    let out = riinac(&sb.dir, &["check", "--compliance", "pci-dss", "k.rii"]);
    let stderr = String::from_utf8_lossy(&out.stderr);
    assert!(stderr.contains("not validated"), "{stderr}");
    let out = riinac(&sb.dir, &["check", "--compliance", "pci-dss", "ok.rii"]);
    assert!(!String::from_utf8_lossy(&out.stderr).contains("not validated"));
    let out = riinac(&sb.dir, &["check", "k.rii"]);
    assert!(
        !String::from_utf8_lossy(&out.stderr).contains("not validated"),
        "the notice belongs to compliance runs"
    );
}

/// MSVC is not a supported compiler (owner ruling on REQ-102, option B). A
/// machine with `cl` but no `cc` gets a message saying so and naming the
/// supported set, not just "No such file or directory"; the build fails.
#[test]
fn build_with_only_msvc_on_path_fails_closed_naming_the_supported_set() {
    let sb = Sandbox::new("msvc");
    sb.file(
        "hai.rii",
        "fungsi utama() -> Unit kesan Tulis { cetak(\"hai\") }\n",
    );
    let bin = sb.dir.join("msvc-bin");
    std::fs::create_dir_all(&bin).unwrap();
    let cl = bin.join("cl");
    std::fs::write(&cl, "#!/bin/sh\necho MSVC-RAN\n").unwrap();
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        std::fs::set_permissions(&cl, std::fs::Permissions::from_mode(0o755)).unwrap();
    }
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "hai.rii"])
        .current_dir(&sb.dir)
        .env("PATH", &bin)
        .output()
        .expect("riinac build");
    let stderr = String::from_utf8_lossy(&out.stderr);
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(!out.status.success(), "built without a supported compiler: {stderr}");
    assert!(stderr.contains("only MSVC") && stderr.contains("gcc or clang"), "{stderr}");
    assert!(!stdout.contains("MSVC-RAN"), "invoked cl: {stdout}");
    assert!(!sb.dir.join("hai").exists(), "left an artifact behind");
}
