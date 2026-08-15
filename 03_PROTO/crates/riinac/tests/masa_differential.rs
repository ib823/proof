// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the time family (master plan REQ-70 family
//! routing).
//!
//! # Why these tests assert properties, not values
//!
//! REQ-70 asks each family to land "with a byte-equal interp/C differential".
//! For clocks that is impossible by construction: `riinac run` and the compiled
//! binary read the clock at different instants, so `masa_sekarang` MUST return
//! different numbers in the two runs. Comparing raw output would either fail
//! always or be weakened into asserting nothing.
//!
//! What can be compared byte-for-byte is what the two backends CONCLUDE. Each
//! program below computes a property — monotonicity, the seconds/millis
//! relationship, that a sleep actually elapsed — and prints the resulting
//! boolean. Both backends must print the same verdict. A backend whose clock
//! ran backwards, whose millisecond clock disagreed with its second clock, or
//! whose sleep returned early would print `salah` where the other printed
//! `betul`, and the comparison fails.
//!
//! # Scope: two of the seven are deliberately NOT routed
//!
//! `masa_format` and `masa_urai` are excluded because the backends disagree on
//! what they mean: the interpreter ignores the format string entirely
//! (`masa_format((0, "%Y"))` is `"0"`) while the C helpers implement real
//! strftime/strptime (the same call is `"1970"`). Settling that by routing
//! whichever backend happens to be reachable would decide a language-semantics
//! question by accident, so `format_family_is_not_routed` pins the exclusion
//! until it is decided deliberately.

use std::path::PathBuf;
use std::process::Command;

fn write_program(dir: &std::path::Path, stem: &str, body: &str) -> PathBuf {
    std::fs::create_dir_all(dir).expect("create dir");
    let src = dir.join(format!("{stem}.rii"));
    std::fs::write(
        &src,
        format!("fungsi utama() -> Nombor kesan Masa {{\n{body}\n    0\n}}\n"),
    )
    .expect("write program");
    src
}

/// Run one program under `riinac run` and as a compiled binary; assert both
/// reach the same verdict.
fn assert_backends_agree(tag: &str, body: &str) {
    let dir = std::env::temp_dir().join(format!("riina_req70_masa_{tag}_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    let stem = format!("ujian_masa_{tag}");
    let src = write_program(&dir, &stem, body);

    let interp = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&src)
        .output()
        .expect("riinac run");
    assert!(
        interp.status.success(),
        "interpreter failed for {tag}: {}{}",
        String::from_utf8_lossy(&interp.stdout),
        String::from_utf8_lossy(&interp.stderr)
    );
    let interp_out = String::from_utf8_lossy(&interp.stdout).into_owned();

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "compile failed for {tag} — before REQ-70 routed the clocks this was \
         `Codegen Error: unbound variable`: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );

    let run = Command::new(dir.join(&stem))
        .output()
        .expect("run compiled binary");
    assert!(
        run.status.success(),
        "compiled binary failed for {tag} (exit {:?}): {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    let c_out = String::from_utf8_lossy(&run.stdout).into_owned();

    // `riinac run` prints the program's final value as a trailing LINE; drop it.
    let mut lines: Vec<&str> = interp_out.lines().collect();
    lines.pop();
    let interp_prog_out = if lines.is_empty() {
        String::new()
    } else {
        format!("{}\n", lines.join("\n"))
    };

    assert_eq!(
        interp_prog_out, c_out,
        "interp/C divergence for {tag}\n  interp: {interp_prog_out:?}\n  C:      {c_out:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// The wall clock reports a plausible present. Pins that neither backend
/// returns 0 or a garbage value — the failure mode if the builtin were stubbed.
#[test]
fn wall_clock_is_plausible() {
    assert_backends_agree(
        "wall",
        "    cetakln(ke_teks(masa_sekarang(()) > 1700000000));",
    );
}

/// `masa_unix` is an alias of `masa_sekarang` and must route to the same
/// canonical builtin, not fall through to `unbound variable`.
#[test]
fn unix_alias_agrees() {
    assert_backends_agree("alias", "    cetakln(ke_teks(masa_unix(()) > 1700000000));");
}

/// The monotonic clock does not run backwards.
#[test]
fn monotonic_clock_does_not_regress() {
    assert_backends_agree(
        "mono",
        "    biar a = masa_jam(());\n\
         \x20   biar b = masa_jam(());\n\
         \x20   cetakln(ke_teks(b >= a));",
    );
}

/// The millisecond clock agrees with the second clock. Catches a unit error in
/// either backend — C builds this one from clock_gettime rather than time().
#[test]
fn millisecond_clock_agrees_with_seconds() {
    assert_backends_agree(
        "ms",
        "    biar s = masa_sekarang(());\n\
         \x20   biar ms = masa_sekarang_ms(());\n\
         \x20   cetakln(ke_teks(ms / 1000 >= s));",
    );
}

/// A sleep actually elapses: at least 50ms of monotonic time passes across a
/// `masa_tidur(50)`. Pins that neither backend returns immediately.
#[test]
fn sleep_elapses_at_least_the_requested_time() {
    assert_backends_agree(
        "sleep",
        "    biar t0 = masa_jam(());\n\
         \x20   masa_tidur(50);\n\
         \x20   biar t1 = masa_jam(());\n\
         \x20   cetakln(ke_teks(t1 - t0 >= 50000000));",
    );
}

/// `masa_format`/`masa_urai` are NOT routed, deliberately, because the two
/// backends disagree on their meaning (see the module docs). This test pins the
/// exclusion: if someone routes them without settling the semantics, the build
/// starts succeeding and this fails, prompting the decision rather than letting
/// whichever backend was wired up silently become the definition.
#[test]
fn format_family_is_not_routed() {
    let dir = std::env::temp_dir().join(format!("riina_req70_masa_fmt_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    let src = write_program(
        &dir,
        "ujian_masa_fmt",
        "    cetakln(masa_format((0, \"%Y\")));",
    );

    // The interpreter accepts it — and returns "0", ignoring the "%Y".
    let interp = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&src)
        .output()
        .expect("riinac run");
    assert!(interp.status.success(), "interpreter should still run it");
    assert!(
        String::from_utf8_lossy(&interp.stdout).starts_with("0"),
        "the interpreter is expected to IGNORE the format string and print the \
         raw timestamp; if this changed, the semantics question was settled and \
         the routing exclusion should be revisited: {}",
        String::from_utf8_lossy(&interp.stdout)
    );

    // The compiler must refuse rather than silently use the divergent C helper.
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&src)
        .output()
        .expect("riinac build");
    assert!(
        !build.status.success(),
        "masa_format compiled — it must stay unrouted until the interpreter's \
         ignore-the-format behaviour and the C backend's strftime behaviour are \
         reconciled (master plan REQ-70)"
    );

    let _ = std::fs::remove_dir_all(&dir);
}
