// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the file (`fail`) family — master plan
//! REQ-70 family routing.
//!
//! # What makes this family different from the others
//!
//! `json`, `masa`, `simpan` and `net` were routed to fix *correctness*
//! divergences. This family was held back because its divergence was a
//! **security** one: every `fail_*` builtin runs through
//! `gate_read`/`gate_write`/`gate_delete` in the interpreter — the Coq
//! `can_read`/`can_write` predicates over an inode model — and the emitted C
//! had none of it. Routing it before the gate existed would have made
//! `riinac build` a way around a check `riinac run` enforces.
//!
//! `file_gate_parity.rs` holds the invariant (a compiled binary must not
//! perform an access the interpreter refuses). This file checks that the two
//! implementations of the gate *agree in detail*, which is the discipline that
//! keeps them from drifting: the C gate mirrors
//! `domains/VerifiedFileSystem.v` / `riina-os/src/vfs.rs`, and they cannot
//! share code because the compile pipeline is `cc -o out one.c` with nothing
//! linked.
//!
//! # Cases chosen to pin the resolution order
//!
//! First touch registers a path owned by the current uid at mode 0644 — owner
//! `rw`, group and other `r`. So the interesting boundaries are: the owner may
//! write, a non-owner may read but NOT write, and a delete drops the mapping
//! so whoever re-creates the file owns it. Each is a different arm of
//! `get_permission`'s owner ▷ group ▷ other resolution, and a C gate that
//! collapsed them (say, by always consulting `perm_owner`) would pass a
//! naive same-uid test and fail these.

use std::path::PathBuf;
use std::process::Command;

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// A missing `cc` PANICS by default — a test that cannot run must never report
/// `ok`. Opt out deliberately with `RIINA_ALLOW_MISSING_BACKEND_TOOLS=1`.
fn require_cc() -> bool {
    if tool_available("cc") {
        return true;
    }
    if std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_ok() {
        eprintln!("!!! SKIPPED (cc missing) — file differential NOT exercised.");
        return false;
    }
    panic!(
        "cc is required: this test cannot compare the backends without it, so it \
         fails rather than reporting a false pass. Set \
         RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately."
    );
}

struct Sandbox {
    dir: PathBuf,
    stem: String,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let stem = format!("req70_file_{tag}");
        let dir = std::env::temp_dir().join(format!("riina_{stem}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self { dir, stem }
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

/// Build the program with `{}` replaced by a backend-private target path, run
/// it under both backends, and return (interpreter stdout, native stdout).
///
/// Each backend gets its OWN target file: they run as separate processes and a
/// shared path would let one backend's writes be read by the other, which would
/// make an agreement look real when it was just leftover state.
fn run_both(tag: &str, body_tmpl: &str) -> (String, String) {
    let sb = Sandbox::new(tag);

    let interp_target = sb.dir.join("t_interp.txt");
    let interp_src = sb.dir.join(format!("{}_i.rii", sb.stem));
    std::fs::write(
        &interp_src,
        format!(
            "fungsi utama() -> Nombor kesan SistemFail {{\n{}\n    0\n}}\n",
            body_tmpl.replace("{}", &interp_target.display().to_string())
        ),
    )
    .expect("write interp program");

    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&interp_src)
        .output()
        .expect("riinac run");
    // A denial is an expected outcome here, so a non-zero exit is not asserted
    // against — what is compared is the observable output up to that point.
    let s = String::from_utf8_lossy(&out.stdout).into_owned();
    let mut lines: Vec<&str> = s.lines().collect();
    // `riinac run` appends the program's final value only on success.
    if out.status.success() {
        lines.pop();
    }
    let interp = if lines.is_empty() {
        String::new()
    } else {
        format!("{}\n", lines.join("\n"))
    };

    let native_target = sb.dir.join("t_native.txt");
    let native_src = sb.dir.join(format!("{}.rii", sb.stem));
    std::fs::write(
        &native_src,
        format!(
            "fungsi utama() -> Nombor kesan SistemFail {{\n{}\n    0\n}}\n",
            body_tmpl.replace("{}", &native_target.display().to_string())
        ),
    )
    .expect("write native program");

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&native_src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "native build failed for {tag} — the fail family must route to codegen: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );
    let run = Command::new(sb.dir.join(&sb.stem))
        .output()
        .expect("run native binary");
    let native = String::from_utf8_lossy(&run.stdout).into_owned();

    (interp, native)
}

fn assert_agree(tag: &str, body_tmpl: &str) {
    if !require_cc() {
        return;
    }
    let (interp, native) = run_both(tag, body_tmpl);
    assert_eq!(
        interp, native,
        "interp/C divergence for {tag}\n  interp: {interp:?}\n  C:      {native:?}"
    );
}

/// The owner may read back what it wrote. The baseline round trip.
#[test]
fn owner_round_trip_agrees() {
    assert_agree(
        "owner",
        "    biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis((\"{}\", \"hello\"));\n\
         \x20   cetakln(fail_baca(\"{}\"));",
    );
}

/// A NON-owner may read a 0644 file — the `perm_other.read` arm. If the C gate
/// consulted `perm_owner` for everyone this would still pass; the write case
/// below is what separates them.
#[test]
fn non_owner_read_is_allowed_and_agrees() {
    assert_agree(
        "otherread",
        "    biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis((\"{}\", \"owned-by-7\"));\n\
         \x20   biar d = vfs_jadi_pengguna(9);\n\
         \x20   cetakln(fail_baca(\"{}\"));",
    );
}

/// A non-owner may NOT write — `perm_other.write` is false at 0644. Both
/// backends must stop here, so neither prints the line after the write.
#[test]
fn non_owner_write_is_denied_by_both() {
    assert_agree(
        "otherwrite",
        "    biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis((\"{}\", \"owned-by-7\"));\n\
         \x20   cetakln(\"before\");\n\
         \x20   biar d = vfs_jadi_pengguna(9);\n\
         \x20   biar e = fail_tulis((\"{}\", \"intruder\"));\n\
         \x20   cetakln(\"after\");",
    );
}

/// Append is gated as a write, so a non-owner is refused there too. Pinned
/// separately because `fail_tambah` is a different call site from `fail_tulis`
/// and an unwired one would go unnoticed.
#[test]
fn non_owner_append_is_denied_by_both() {
    assert_agree(
        "otherappend",
        "    biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis((\"{}\", \"base\"));\n\
         \x20   cetakln(\"before\");\n\
         \x20   biar d = vfs_jadi_pengguna(9);\n\
         \x20   biar e = fail_tambah((\"{}\", \"-more\"));\n\
         \x20   cetakln(\"after\");",
    );
}

/// `fail_panjang` and `fail_baca_baris` are gated as reads; the owner passes.
#[test]
fn size_and_lines_agree_for_the_owner() {
    assert_agree(
        "sizelines",
        "    biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis((\"{}\", \"ab\\ncd\"));\n\
         \x20   cetakln(ke_teks(fail_panjang(\"{}\")));\n\
         \x20   cetakln(ke_teks(senarai_panjang(fail_baca_baris(\"{}\"))));",
    );
}

/// Delete drops the inode mapping, so the file may be re-created by a
/// DIFFERENT uid, which then owns it and may write again. This is the
/// `gate_delete` half — a C gate that merely checked the write bit without
/// clearing the mapping would deny the re-write and diverge here.
#[test]
fn delete_clears_ownership_and_agrees() {
    assert_agree(
        "delete",
        "    biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis((\"{}\", \"first\"));\n\
         \x20   biar d = fail_buang(\"{}\");\n\
         \x20   biar e = vfs_jadi_pengguna(9);\n\
         \x20   biar f = fail_tulis((\"{}\", \"second\"));\n\
         \x20   cetakln(fail_baca(\"{}\"));",
    );
}

/// `fail_ada` is UNGATED in the interpreter — an existence check is not an
/// access. The C side must be ungated too: adding a gate there would be a
/// divergence in the opposite direction, denying what the interpreter allows.
#[test]
fn existence_check_is_ungated_in_both() {
    assert_agree(
        "exists",
        "    biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis((\"{}\", \"x\"));\n\
         \x20   biar d = vfs_jadi_pengguna(9);\n\
         \x20   cetakln(ke_teks(fail_ada(\"{}\")));",
    );
}
