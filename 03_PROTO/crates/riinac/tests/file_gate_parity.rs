// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The compiled backend must never be a way around the verified file gate
//! (master plan REQ-70 family routing; REQ-27 enforcement parity).
//!
//! # The gap this guards
//!
//! `builtins::fail` does not call the host filesystem directly. Every one of
//! its eight builtins first calls `gate_read` / `gate_write` / `gate_delete`,
//! which evaluate the Coq-modeled `can_read` / `can_write` predicates against
//! an inode model (owner uid/gid, mode 0644 on first touch) and the current
//! `AccessContext` set by `vfs_jadi_pengguna`. Twelve call sites in that file
//! enforce it.
//!
//! The eight `riina_builtin_fail_*` functions in `emit.rs` contain **no
//! gating whatsoever** — `fail_baca` is a bare `fopen`, `fail_tulis` a bare
//! `fwrite`. They were written before the gate existed and, like the `json`
//! helpers before REQ-70 routed them, have never executed: `builtin_canonical`
//! does not route the family, so nothing can reach them.
//!
//! That makes routing this family different in kind from `json`, `masa`,
//! `simpan` or `net`. Those exposed *correctness* divergences — a wrong string,
//! a wrong order. Adding a `fail`/`vfs` arm to `builtin_canonical` as it stands
//! would instead mean **`riinac run` denies an access that `riinac build`
//! permits**: a compiled binary that silently drops a security check the
//! interpreter enforces. Measured on the interpreter today:
//!
//! ```text
//! uid 1 writes /tmp/owned.txt          -> ok, file contains "alice-data"
//! uid 2 writes the same 0644 file      -> Runtime Error: permission denied
//!                                         (verified can_write is false for the
//!                                         current uid), file unchanged
//! ```
//!
//! # Why this test is shaped as an invariant, not a "stays unrouted" pin
//!
//! It asserts the property that must hold in every future state, not the
//! present one: *whatever the routing table says, a compiled binary must not
//! perform an access the interpreter refuses.*
//!
//! - Today the family is unrouted, so `riinac build` fails and the invariant
//!   holds because there is no compiled binary to bypass anything.
//! - After the gate is ported to C, the build succeeds and the compiled binary
//!   must refuse the write just as the interpreter does — still passing.
//! - If someone routes the family WITHOUT porting the gate, the build succeeds
//!   and the binary overwrites the file. Only then does this fail, which is
//!   exactly when someone needs to be stopped.
//!
//! So it does not have to be deleted to make progress, unlike a pin on the
//! current routing state.
//!
//! # Limitation, stated because it affects how much this test proves today
//!
//! The `SECURITY REGRESSION` branch below has NOT been executed. Reaching it
//! needs a compiled binary that switches uid and then writes, and that cannot
//! be built at present: `emit.rs` contains no `riina_builtin_vfs_*` functions
//! at all, so routing `vfs` emits C that does not compile. Two controls were
//! run instead, and both correctly held vacuously — routing `fail` alone (no
//! way to switch uid, so no bypass is expressible) and routing `fail` + `vfs`
//! (fails in the C compiler). The assertion is therefore verified in its
//! vacuous arm and reviewed but unexecuted in its active arm; it acquires
//! teeth exactly when someone writes the `vfs` C helpers, which is the moment
//! the bypass becomes shippable.

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
        eprintln!("!!! SKIPPED (cc missing) — file-gate parity NOT exercised.");
        return false;
    }
    panic!(
        "cc is required: this test cannot verify the compiled backend without it, \
         so it fails rather than reporting a false pass. Set \
         RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately."
    );
}

const OWNER_CONTENT: &str = "alice-data";
const INTRUDER_CONTENT: &str = "mallory-overwrote-this";

/// uid 1 creates the file; uid 2 then tries to overwrite it. The inode is mode
/// 0644 on first touch, so `can_write` is false for a non-owner.
fn program(target: &std::path::Path) -> String {
    format!(
        "fungsi utama() -> Nombor kesan SistemFail {{\n\
         \x20   biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(1);\n\
         \x20   biar c = fail_tulis((\"{p}\", \"{owner}\"));\n\
         \x20   biar d = vfs_jadi_pengguna(2);\n\
         \x20   biar e = fail_tulis((\"{p}\", \"{intruder}\"));\n\
         \x20   0\n\
         }}\n",
        p = target.display(),
        owner = OWNER_CONTENT,
        intruder = INTRUDER_CONTENT,
    )
}

#[test]
fn compiled_backend_must_not_bypass_the_verified_file_gate() {
    if !require_cc() {
        return;
    }
    let dir = std::env::temp_dir().join(format!("riina_req70_filegate_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    std::fs::create_dir_all(&dir).expect("create sandbox");

    // ── The interpreter refuses, and leaves the file alone. ────────────────
    let interp_target = dir.join("owned_interp.txt");
    let interp_src: PathBuf = dir.join("gate_interp.rii");
    std::fs::write(&interp_src, program(&interp_target)).expect("write program");

    let interp = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&interp_src)
        .output()
        .expect("riinac run");
    let interp_err = String::from_utf8_lossy(&interp.stderr).into_owned()
        + &String::from_utf8_lossy(&interp.stdout);
    assert!(
        interp_err.contains("permission denied"),
        "the interpreter is expected to DENY a non-owner write via the verified \
         gate. If this changed, the gate moved and this test's premise needs \
         revisiting before the compiled side is judged against it. Output:\n{interp_err}"
    );
    assert_eq!(
        std::fs::read_to_string(&interp_target).unwrap_or_default(),
        OWNER_CONTENT,
        "the interpreter denied the write but the file changed anyway"
    );

    // ── The compiled backend must not do better than the interpreter. ──────
    let native_target = dir.join("owned_native.txt");
    let stem = "gate_native";
    let native_src: PathBuf = dir.join(format!("{stem}.rii"));
    std::fs::write(&native_src, program(&native_target)).expect("write program");

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&native_src)
        .output()
        .expect("riinac build");

    if !build.status.success() {
        // No compiled binary was produced, so the invariant holds vacuously:
        // there is nothing that could bypass the gate. The reason does not
        // matter to the property and deliberately is not asserted — today it is
        // `unbound variable` (the family is unrouted), but routing `vfs_*`
        // without writing its C helpers fails later, in the C compiler, and
        // that is equally safe. Printed for diagnosis only.
        eprintln!(
            "file-gate parity holds vacuously — no binary was produced:\n{}{}",
            String::from_utf8_lossy(&build.stdout),
            String::from_utf8_lossy(&build.stderr)
        );
        let _ = std::fs::remove_dir_all(&dir);
        return;
    }

    // Routed: the binary MUST refuse the non-owner write, exactly as the
    // interpreter does.
    let run = Command::new(dir.join(stem)).output().expect("run binary");
    let after = std::fs::read_to_string(&native_target).unwrap_or_default();
    assert_eq!(
        after, OWNER_CONTENT,
        "SECURITY REGRESSION: the compiled binary performed a write the \
         interpreter refuses. `fail_*` is routed to codegen, but the emitted C \
         helpers carry no gate — the Coq-modeled can_write check is enforced by \
         `riinac run` and absent from the compiled artifact, so the compiler is \
         a way around it. Port gate_read/gate_write/gate_delete (the inode model \
         and the vfs_jadi_pengguna context) into the emitted runtime before \
         routing this family. Binary exit: {:?}",
        run.status.code()
    );

    let _ = std::fs::remove_dir_all(&dir);
}
