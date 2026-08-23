// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the last unrouted PURE builtins — master plan
//! REQ-70 family routing.
//!
//! # These were not a family, they were three defects wearing a family's clothes
//!
//! REQ-70's remaining interpreter-only set was described as a backlog of
//! builtins nobody had looked at yet. Looking at them found that most were not
//! missing implementations at all:
//!
//! 1. **`cetak_baris` was a pure aliasing gap.** The interpreter binds
//!    `cetakln`, `println` AND `cetak_baris` to the same
//!    `Value::Builtin("cetakln")`. Only `lower::builtin_canonical` knew two of
//!    the three, so a program using the third ran and then failed to build.
//!
//! 2. **`baki`/`rem` were UNCALLABLE from any well-typed program.** They are
//!    binary and take a pair — the interpreter's `extract_pair_ints` and the
//!    emitted C's `RIINA_TAG_PAIR` check agree on that — but the typechecker
//!    declared them `Nombor -> Nombor`, because they shared a registration loop
//!    with the genuinely unary `log2`. So `baki(10, 3)` failed with "Expected
//!    function type, found Int" and `baki((10, 3))` failed with "expected Int,
//!    found Prod(Int, Int)". Two of the three components agreed and the type was
//!    the outlier, which is why the fix is to the type.
//!
//! 3. **`baki` and `log2` already had C.** `riina_builtin_baki` and
//!    `riina_builtin_log2` sat in `emit.rs` unreferenced, like the `json`
//!    helpers before them. Only the routing gate was missing.
//!
//! # The load-bearing case is [`nested_constructor_pattern_compiles`]
//!
//! `adalah_kiri`/`adalah_kanan`/`nilai_kiri`/`nilai_kanan` are not stdlib
//! functions a user calls. They are COMPILER INTERNALS: the parser's if-chain
//! pattern compiler emits them for a constructor pattern nested somewhere a
//! `Case` cannot go, such as `(Ada(a), Tiada)` inside a tuple pattern. Leaving
//! them unrouted meant that entire class of pattern ran under `riinac run` and
//! failed `riinac build` with `Codegen Error: unbound variable: nilai_kiri`.
//!
//! That is a LANGUAGE FEATURE that did not compile, surfacing in the Backend
//! column as four obscure `interp-only` builtins. It is the reason this file
//! exists, and the reason "unexamined builtins" was the wrong description.

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
        eprintln!("!!! SKIPPED (cc missing) — pure-builtin differential NOT exercised.");
        return false;
    }
    panic!(
        "cc is required: this test cannot compare the backends without it, so it \
         fails rather than reporting a false pass. Set \
         RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately."
    );
}

/// Run `src_body` under both backends and assert the program's own output
/// matches byte for byte.
fn assert_backends_agree(tag: &str, program: &str) {
    if !require_cc() {
        return;
    }
    let dir = std::env::temp_dir().join(format!("riina_req70_pure_{tag}_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    std::fs::create_dir_all(&dir).expect("create dir");
    let stem = format!("req70_pure_{tag}");
    let src: PathBuf = dir.join(format!("{stem}.rii"));
    std::fs::write(&src, program).expect("write program");

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
    // `riinac run` appends the program's final value as a trailing LINE.
    let raw = String::from_utf8_lossy(&interp.stdout).into_owned();
    let mut lines: Vec<&str> = raw.lines().collect();
    lines.pop();
    let interp_out = if lines.is_empty() {
        String::new()
    } else {
        format!("{}\n", lines.join("\n"))
    };

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "compile failed for {tag}: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );
    let run = Command::new(dir.join(&stem)).output().expect("run binary");
    assert!(
        run.status.success(),
        "compiled binary failed for {tag} (exit {:?}): {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    let c_out = String::from_utf8_lossy(&run.stdout).into_owned();

    assert_eq!(
        interp_out, c_out,
        "interp/C divergence for {tag}\n  interp: {interp_out:?}\n  C:      {c_out:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// THE regression this increment exists for: a constructor pattern nested inside
/// a tuple pattern. Before the four sum helpers were routed this program ran
/// under `riinac run` and `riinac build` failed with
/// `Codegen Error: unbound variable: nilai_kiri`.
///
/// The arms are ordered so the SECOND one matches, which forces the generated
/// code to evaluate a failing `adalah_kanan` tag test and then a succeeding one
/// — exercising both tag helpers and the payload projection, not just the arm
/// that happens to win.
#[test]
fn nested_constructor_pattern_compiles() {
    assert_backends_agree(
        "nestedctor",
        "fungsi bungkus(n: Nombor) -> Mungkin<Nombor> kesan Bersih {\n\
         \x20   kalau n > 0 { Ada(n) } lain { Tiada }\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   biar pab = (bungkus(1), bungkus(2));\n\
         \x20   biar pa  = (bungkus(1), bungkus(0));\n\
         \x20   biar pnone = (bungkus(0), bungkus(0));\n\
         \x20   cetakln(padan pab { (Ada(a), Ada(b)) => \"kedua\", (Ada(a), Tiada) => \"pertama\", _ => \"tiada\" });\n\
         \x20   cetakln(padan pa { (Ada(a), Ada(b)) => \"kedua\", (Ada(a), Tiada) => \"pertama\", _ => \"tiada\" });\n\
         \x20   cetakln(padan pnone { (Ada(a), Ada(b)) => \"kedua\", (Ada(a), Tiada) => \"pertama\", _ => \"tiada\" });\n\
         \x20   0\n\
         }\n",
    );
}

/// The payload BOUND by a nested pattern must be the same value in both
/// backends, not merely the same arm. A `nilai_kiri` that returned the sum
/// rather than its contents would still pick the right arm and print the wrong
/// number.
#[test]
fn nested_constructor_pattern_binds_the_same_payload() {
    assert_backends_agree(
        "nestedbind",
        "fungsi bungkus(n: Nombor) -> Mungkin<Nombor> kesan Bersih {\n\
         \x20   kalau n > 0 { Ada(n) } lain { Tiada }\n\
         }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   biar p = (bungkus(7), bungkus(35));\n\
         \x20   cetakln(ke_teks(padan p { (Ada(a), Ada(b)) => b / a, _ => 0 }));\n\
         \x20   0\n\
         }\n",
    );
}

/// `baki`/`rem` after the type correction. The zero case is left out
/// deliberately: both backends abort on modulo-by-zero, which is agreement of a
/// different kind and belongs in a both-must-fail test, not here.
#[test]
fn modulo_and_log2_agree() {
    assert_backends_agree(
        "math",
        "fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(baki((10, 3))));\n\
         \x20   cetakln(ke_teks(baki((9, 3))));\n\
         \x20   cetakln(ke_teks(rem((255, 16))));\n\
         \x20   cetakln(ke_teks(log2(1)));\n\
         \x20   cetakln(ke_teks(log2(1024)));\n\
         \x20   cetakln(ke_teks(log2(1023)));\n\
         \x20   0\n\
         }\n",
    );
}

/// Ranges, including the two boundaries a naive C loop gets wrong: an EMPTY
/// range (`lo >= hi`) and the inclusive form's extra element.
#[test]
fn ranges_agree_including_the_empty_case() {
    assert_backends_agree(
        "range",
        "fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(ke_teks(julat((1, 5))));\n\
         \x20   cetakln(ke_teks(julat_inklusif((1, 5))));\n\
         \x20   cetakln(ke_teks(julat((5, 5))));\n\
         \x20   cetakln(ke_teks(julat_inklusif((5, 5))));\n\
         \x20   cetakln(ke_teks(julat((7, 3))));\n\
         \x20   cetakln(ke_teks(senarai_panjang(julat((0, 10)))));\n\
         \x20   0\n\
         }\n",
    );
}

/// `cetak_baris` is the third spelling of `cetakln`, and must be the same
/// function — including the newline — in both backends.
#[test]
fn cetak_baris_is_cetakln_in_both() {
    assert_backends_agree(
        "alias",
        "fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   cetakln(\"satu\");\n\
         \x20   cetak_baris(\"dua\");\n\
         \x20   println(\"tiga\");\n\
         \x20   0\n\
         }\n",
    );
}

/// `rawak`/`random` is the one routed member whose backends CANNOT be compared
/// by output: both are time-seeded, so equality would be a coin flip dressed as
/// a test. What is pinned instead is the invariant each must satisfy — every
/// draw lands in `[0, n)` — checked inside the program so both backends assert
/// it themselves, plus the fact that a compiled program can obtain randomness at
/// all, which before routing it could not.
///
/// Neither implementation is a CSPRNG and neither claims to be (the interpreter
/// hashes the clock; the emitted C runs an LCG). Anything needing cryptographic
/// randomness must come from `riina-core`.
#[test]
fn random_stays_in_range_in_both_backends() {
    assert_backends_agree(
        "rawak",
        "fungsi utama() -> Nombor kesan (Rawak | Tulis) {\n\
         \x20   biar a = rawak(10);\n\
         \x20   biar b = rawak(1);\n\
         \x20   cetakln(ke_teks(a < 10));\n\
         \x20   cetakln(ke_teks(b));\n\
         \x20   0\n\
         }\n",
    );
}
