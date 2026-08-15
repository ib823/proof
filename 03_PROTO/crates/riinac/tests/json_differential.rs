// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the `json_*` family (master plan REQ-70
//! family routing).
//!
//! # What this family's routing exposed
//!
//! The five `riina_builtin_json_*` helpers already existed in `emit.rs`, but
//! `lower::builtin_canonical` had no `json` arm, so nothing could ever reach
//! them: the C implementation was unreachable dead code that had never once
//! executed. Adding the routing arm ran it for the first time and three
//! disagreements with the interpreter fell out immediately.
//!
//! 1. **Map iteration order.** The interpreter backs `Value::Map` with a
//!    `BTreeMap` (sorted by key); the C runtime appended each new key at the
//!    tail (insertion order). `json_ke_teks` therefore serialised one object
//!    into two different strings, and — because the same map runtime backs
//!    `peta_*` — `peta_kunci` already returned a different sequence under
//!    `riinac run` than compiled. That was a live bug in a family REQ-79 had
//!    recorded as verified interp==C; its differential never inserted keys out
//!    of order, so nothing caught it. Every map-producing C builtin now goes
//!    through one `riina_map_put_sorted` helper.
//!
//! 2. **`\uXXXX` escapes were dropped.** The C string parser's `default:` arm
//!    emitted the escape character literally, so `"ab"` parsed as the
//!    six characters `au0001b` — silent data corruption, not an error.
//!
//! 3. **Control characters and pairs.** The C stringifier passed `c < 0x20`
//!    through raw where the interpreter escapes `\u00xx`, and rendered a
//!    `Pair` as `null` where the interpreter renders `[a,b]`.
//!
//! # Why a differential rather than expected-output assertions
//!
//! Same reason as `collection_differential.rs`: comparing the two backends
//! against EACH OTHER catches a wrong shared assumption that a hand-written
//! expected value would simply encode twice. Every case below is one that
//! actually diverged, or one that guards an ordering/duplicate rule the fix
//! depends on.

use std::path::PathBuf;
use std::process::Command;

/// Run one program under `riinac run` and as a compiled binary; assert the
/// program's own output matches byte for byte.
fn assert_backends_agree(tag: &str, body: &str) {
    let dir = std::env::temp_dir().join(format!("riina_req70_json_{tag}_{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    std::fs::create_dir_all(&dir).expect("create dir");
    // Unique stem per test: `riinac build` derives its intermediate C path from
    // the stem, so a shared name makes parallel tests race on the same file.
    let stem = format!("ujian_json_{tag}");
    let src: PathBuf = dir.join(format!("{stem}.rii"));
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
    let interp_out = String::from_utf8_lossy(&interp.stdout).into_owned();

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "compile failed for {tag} — before REQ-70 routed this family the \
         failure here was `Codegen Error: unbound variable`: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );

    let binary = dir.join(&stem);
    let run = Command::new(&binary).output().expect("run compiled binary");
    assert!(
        run.status.success(),
        "compiled binary failed for {tag} (exit {:?}): {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    let c_out = String::from_utf8_lossy(&run.stdout).into_owned();

    // `riinac run` prints the program's final value as a trailing LINE after
    // the program's own output; drop exactly that line before comparing.
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

/// THE ordering regression: keys are emitted sorted, not in insertion order.
/// Before the fix the interpreter printed `{"a":1,"b":2}` and C printed
/// `{"b":2,"a":1}`.
#[test]
fn object_key_order_agrees() {
    assert_backends_agree(
        "order",
        "    cetakln(json_ke_teks(json_urai(\"{\\\"b\\\":2,\\\"a\\\":1}\")));",
    );
}

/// The same ordering rule reached through `peta_*` rather than JSON — this is
/// the half that was already shipping as "verified interp==C".
#[test]
fn map_key_order_agrees_through_peta() {
    assert_backends_agree(
        "petaorder",
        "    biar m0 = peta_baru(());\n\
         \x20   biar m1 = peta_letak((m0, (\"zebra\", 1)));\n\
         \x20   biar m2 = peta_letak((m1, (\"apple\", 2)));\n\
         \x20   biar m3 = peta_letak((m2, (\"mango\", 3)));\n\
         \x20   cetakln(ke_teks(senarai_dapat((peta_kunci(m3), 0))));\n\
         \x20   cetakln(ke_teks(senarai_dapat((peta_kunci(m3), 1))));\n\
         \x20   cetakln(ke_teks(senarai_dapat((peta_kunci(m3), 2))));",
    );
}

/// `\uXXXX` used to parse as a literal `u` followed by the hex digits.
#[test]
fn unicode_escape_agrees() {
    assert_backends_agree(
        "uesc",
        "    cetakln(json_ke_teks(json_urai(\"{\\\"c\\\":\\\"a\\\\u0001b\\\"}\")));",
    );
}

/// Control characters below U+0020 are re-escaped as `\u00xx`, not passed raw.
#[test]
fn control_char_reescape_agrees() {
    assert_backends_agree(
        "ctrl",
        "    cetakln(json_ke_teks(json_urai(\"{\\\"t\\\":\\\"a\\\\tb\\\",\\\"n\\\":\\\"a\\\\nb\\\"}\")));",
    );
}

/// A `Pair` renders as a 2-element array; the C backend used to emit `null`.
#[test]
fn pair_stringify_agrees() {
    assert_backends_agree("pair", "    cetakln(json_ke_teks((\"x\", 1)));");
}

/// Quote and backslash escaping survives a parse/stringify round trip.
#[test]
fn quote_and_backslash_escapes_agree() {
    assert_backends_agree(
        "esc",
        "    cetakln(json_ke_teks(json_urai(\"{\\\"q\\\":\\\"a\\\\\\\"b\\\",\\\"bs\\\":\\\"a\\\\\\\\b\\\"}\")));",
    );
}

/// A duplicate key keeps the LAST value — the replace half of the sorted
/// insert, matching `BTreeMap::insert`.
#[test]
fn duplicate_key_keeps_last_value() {
    assert_backends_agree(
        "dup",
        "    cetakln(json_ke_teks(json_urai(\"{\\\"d\\\":1,\\\"d\\\":2}\")));",
    );
}

/// Scalars, arrays and nesting.
#[test]
fn scalars_arrays_and_nesting_agree() {
    assert_backends_agree("arr", "    cetakln(json_ke_teks(json_urai(\"[1,2,3]\")));");
    assert_backends_agree(
        "scalars",
        "    cetakln(json_ke_teks(json_urai(\"{\\\"n\\\":null,\\\"t\\\":true,\\\"f\\\":false}\")));",
    );
    assert_backends_agree(
        "nest",
        "    cetakln(json_ke_teks(json_urai(\"{\\\"o\\\":{\\\"z\\\":1,\\\"a\\\":[true,null]}}\")));",
    );
}

/// The accessor half of the family: `json_ada` / `json_dapat` / `json_letak`.
#[test]
fn accessors_agree() {
    assert_backends_agree(
        "has",
        "    cetakln(ke_teks(json_ada((json_urai(\"{\\\"k\\\":1}\"), \"k\"))));\n\
         \x20   cetakln(ke_teks(json_ada((json_urai(\"{\\\"k\\\":1}\"), \"nope\"))));",
    );
    assert_backends_agree(
        "get",
        "    cetakln(ke_teks(json_dapat((json_urai(\"{\\\"k\\\":42}\"), \"k\"))));",
    );
    // `json_letak` must also land the new key in sorted position.
    assert_backends_agree(
        "set",
        "    cetakln(json_ke_teks(json_letak((json_urai(\"{\\\"z\\\":1}\"), (\"a\", 9)))));",
    );
}
