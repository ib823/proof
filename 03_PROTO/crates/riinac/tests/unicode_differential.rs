// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the Unicode builtins — `nfc`/`ke_nfc`
//! (UAX #15), `skeleton`/`rangka` and `adalah_keliru`/`is_confusable` (UTS #39).
//! Master plan REQ-70, the last routed group.
//!
//! # Why these needed the emitter's first conditional prelude block
//!
//! Every other builtin's C is a few dozen lines. These need ~250 KB of vendored
//! UCD tables — canonical combining classes, decompositions, composition pairs,
//! and the confusable prototype map. The emitted prelude is already ~228 KB for
//! a hello-world and is otherwise entirely unconditional, so emitting the tables
//! always would MORE THAN DOUBLE every compiled binary to serve three builtins
//! most programs never call. `emit.rs` therefore scans the program for a call to
//! one of them and emits the block only then; [`hello_world_carries_no_ucd_tables`]
//! is what keeps that promise honest.
//!
//! # The tables are generated, not transcribed
//!
//! The C arrays are written out from the same `unicode_nfc_data` /
//! `unicode_confusables_data` statics the interpreter reads. That is deliberate:
//! a hand-copied 250 KB table is a drift source no differential could
//! realistically cover, whereas generating it means the two backends cannot
//! disagree about the DATA at all — only about the ALGORITHM, which is ~150
//! lines and is what the cases below actually test.
//!
//! # Cases chosen where the algorithm, not the data, decides
//!
//! - **Hangul** composes and decomposes ARITHMETICALLY (UAX #15 §16) and so
//!   appears in no table. A C port that only did table lookups would leave
//!   Hangul decomposed.
//! - **Canonical ordering must be STABLE.** Two combining marks of equal class
//!   must keep their relative order; an unstable sort silently reorders them.
//! - **Composition must respect BLOCKING.** A starter may only combine with a
//!   following mark when no intervening character has a combining class at
//!   least as high. Dropping that check composes across a blocker.
//! - **`skeleton` ends in NFD, not NFC** — it is a comparison key, not a display
//!   form. Ending it in NFC would still make the homograph cases below pass
//!   while producing the wrong string.

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
        eprintln!("!!! SKIPPED (cc missing) — Unicode differential NOT exercised.");
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
        let stem = format!("req70_uni_{tag}");
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

fn assert_backends_agree(tag: &str, body: &str) {
    if !require_cc() {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.dir.join(format!("{}.rii", sb.stem));
    std::fs::write(
        &src,
        format!("fungsi utama() -> Nombor kesan Tulis {{\n{body}\n    0\n}}\n"),
    )
    .expect("write program");

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
    let raw = String::from_utf8_lossy(&interp.stdout).into_owned();
    let mut lines: Vec<&str> = raw.lines().collect();
    lines.pop(); // `riinac run` appends the program's final value
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
    let run = Command::new(sb.dir.join(&sb.stem))
        .output()
        .expect("run binary");
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
}

/// Precomposed and decomposed spellings must normalise to the same bytes, and
/// the LENGTH is asserted alongside the text so a backend that silently returned
/// its input unchanged is caught (both spellings print identically otherwise).
#[test]
fn nfc_composes_combining_marks() {
    assert_backends_agree(
        "compose",
        "    cetakln(nfc(\"e\u{0301}\"));\n\
         \x20   cetakln(ke_teks(panjang(nfc(\"e\u{0301}\"))));\n\
         \x20   cetakln(ke_teks(panjang(\"e\u{0301}\")));\n\
         \x20   cetakln(ke_nfc(\"A\u{030A}\"));\n\
         \x20   cetakln(ke_teks(panjang(ke_nfc(\"A\u{030A}\"))));",
    );
}

/// Hangul is composed and decomposed by ARITHMETIC, not by table, so a C port
/// that only consulted the decomposition data would leave these apart.
#[test]
fn hangul_composes_arithmetically() {
    assert_backends_agree(
        "hangul",
        "    cetakln(nfc(\"\u{1100}\u{1161}\"));\n\
         \x20   cetakln(ke_teks(panjang(nfc(\"\u{1100}\u{1161}\"))));\n\
         \x20   cetakln(nfc(\"\u{1100}\u{1161}\u{11A8}\"));\n\
         \x20   cetakln(ke_teks(panjang(nfc(\"각\"))));",
    );
}

/// Canonical ordering sorts combining marks by class and must be STABLE. The
/// first string has marks OUT of class order (dot-below 220 after acute 230), so
/// NFC must reorder them; the second already has them in order, and both must
/// normalise to the same bytes.
#[test]
fn canonical_ordering_is_stable_and_agrees() {
    assert_backends_agree(
        "order",
        "    cetakln(ke_teks(nfc(\"q\u{0301}\u{0323}\") == nfc(\"q\u{0323}\u{0301}\")));\n\
         \x20   cetakln(ke_teks(panjang(nfc(\"q\u{0301}\u{0323}\"))));\n\
         \x20   cetakln(ke_teks(panjang(nfc(\"q\u{0323}\u{0301}\"))));",
    );
}

/// A BLOCKED starter must not compose.
///
/// `a` + U+0305 overline + U+0301 acute. Both marks have combining class 230,
/// and the overline does not compose with `a`, so the acute is BLOCKED — equal
/// classes do not let it reach the starter. The result stays five bytes
/// (a + overline + acute); dropping the blocking check composes `a`+acute into
/// `á` across the overline and gives FOUR.
///
/// The obvious case — `a` + dot-below + acute — does NOT test this, which a
/// negative control caught: there both marks compose into the starter in turn,
/// so blocking never applies and removing the check changes nothing. This input
/// was chosen after verifying by experiment that deleting the blocking
/// condition from the emitted C actually makes this test fail.
#[test]
fn blocked_composition_is_refused_by_both() {
    assert_backends_agree(
        "blocked",
        "    cetakln(ke_teks(panjang(nfc(\"a\u{0305}\u{0301}\"))));\n\
         \x20   cetakln(ke_teks(panjang(nfc(\"a\u{0301}\"))));\n\
         \x20   cetakln(nfc(\"a\u{0305}\u{0301}\"));\n\
         \x20   cetakln(ke_teks(nfc(\"a\u{0305}\u{0301}\") == nfc(\"a\u{0301}\")));",
    );
}

/// The homograph defence itself: Cyrillic look-alikes must collapse to the same
/// skeleton, and genuinely different names must not.
#[test]
fn confusable_detection_agrees() {
    assert_backends_agree(
        "confuse",
        "    cetakln(skeleton(\"paypal\"));\n\
         \x20   cetakln(ke_teks(adalah_keliru((\"a\", \"\u{0430}\"))));\n\
         \x20   cetakln(ke_teks(adalah_keliru((\"paypal\", \"pa\u{0443}pal\"))));\n\
         \x20   cetakln(ke_teks(is_confusable((\"case\", \"\u{0441}\u{0430}\u{0455}\u{0435}\"))));\n\
         \x20   cetakln(ke_teks(adalah_keliru((\"microsoft\", \"paypal\"))));\n\
         \x20   cetakln(rangka(\"\u{0430}\"));",
    );
}

/// Empty and ASCII-only inputs take the early-exit paths on both sides.
#[test]
fn degenerate_inputs_agree() {
    assert_backends_agree(
        "degen",
        "    cetakln(nfc(\"\"));\n\
         \x20   cetakln(nfc(\"plain ascii\"));\n\
         \x20   cetakln(skeleton(\"\"));\n\
         \x20   cetakln(ke_teks(adalah_keliru((\"\", \"\"))));\n\
         \x20   cetakln(ke_teks(panjang(nfc(\"\"))));",
    );
}

/// The conditional-emission promise: a program that does NOT call a Unicode
/// builtin must not carry the ~250 KB of UCD tables. Without this the block
/// would silently become unconditional again the first time someone moved the
/// call, and nothing else would notice — the binaries would just get bigger.
#[test]
fn hello_world_carries_no_ucd_tables() {
    let sb = Sandbox::new("nogate");
    let plain = sb.dir.join("plain.rii");
    std::fs::write(
        &plain,
        "fungsi utama() -> Nombor kesan Tulis { cetakln(\"hai\"); 0 }\n",
    )
    .expect("write plain");
    let uni = sb.dir.join("uni.rii");
    std::fs::write(
        &uni,
        "fungsi utama() -> Nombor kesan Tulis { cetakln(nfc(\"hai\")); 0 }\n",
    )
    .expect("write uni");

    let emit = |p: &PathBuf| -> String {
        let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
            .arg("emit-c")
            .arg(p)
            .output()
            .expect("riinac emit-c");
        assert!(out.status.success(), "emit-c failed for {}", p.display());
        String::from_utf8_lossy(&out.stdout).into_owned()
    };

    let plain_c = emit(&plain);
    let uni_c = emit(&uni);

    assert!(
        !plain_c.contains("riina_ucd_ccc"),
        "a program with no Unicode call carried the UCD tables ({} bytes of C)",
        plain_c.len()
    );
    assert!(
        uni_c.contains("riina_ucd_ccc"),
        "a program that calls nfc did NOT get the UCD tables — the gate is \
         inverted, and every Unicode program would abort on contact"
    );
    assert!(
        uni_c.len() > plain_c.len() + 100_000,
        "the tables look absent from the Unicode build: plain={} uni={}",
        plain_c.len(),
        uni_c.len()
    );
}
