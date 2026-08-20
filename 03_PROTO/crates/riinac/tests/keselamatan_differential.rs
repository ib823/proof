// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the security (`keselamatan`) family — master
//! plan REQ-70 family routing.
//!
//! # What this family needed that the others did not
//!
//! Every previous family had its C helpers already written and merely
//! unrouted. This one had **none** — all 25 routed here are new C. So unlike
//! `json` or `masa`, routing could not *reveal* a pre-existing divergence; it
//! could only introduce one. That inverts the job: the differential is not
//! archaeology, it is the thing keeping a fresh transcription honest.
//!
//! # The taint source is routed with them, deliberately
//!
//! The sanitizers take `Tercemar<Teks, UserInput>`, and that type has exactly
//! ONE producer: `baca_baris`. Routing the sanitizers alone would have marked
//! them `native-only` in the Backend column while leaving them unreachable
//! from any compiled program — the REQ-79 "lowers to C but aborts on contact"
//! trap wearing a new costume. `baca_baris` is therefore routed too, and every
//! case below feeds input through it, which is also what makes the compiled
//! side genuinely exercised rather than constant-folded.
//!
//! # Cases chosen where a transcription would plausibly drift
//!
//! Not the happy path. The interpreter has two deliberate inconsistencies that
//! a C author would "fix" by accident, and both are pinned here:
//!
//! - `sanitize_url` iterates **bytes** while every other transform iterates
//!   **codepoints**, so a non-ASCII input percent-encodes each UTF-8 byte
//!   separately. Writing the C the obvious way (decode codepoints) gives a
//!   different answer.
//! - `sanitize_css` emits a **trailing space** after each hex escape. It looks
//!   like a bug; it is the CSS escape terminator, and dropping it changes the
//!   output.
//!
//! Plus the cases where C and Rust genuinely differ in machinery: UTF-16
//! surrogate pairs above the BMP (`sanitize_js`), and Unicode-aware trimming
//! (`sanitize_email` uses Rust's `str::trim`, which is *not* ASCII-only).

use std::io::Write;
use std::path::PathBuf;
use std::process::{Command, Stdio};

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
        eprintln!("!!! SKIPPED (cc missing) — keselamatan differential NOT exercised.");
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
        let stem = format!("req70_ks_{tag}");
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

fn feed(cmd: &mut Command, stdin_text: &str) -> String {
    let mut child = cmd
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("spawn");
    child
        .stdin
        .as_mut()
        .expect("stdin")
        .write_all(format!("{stdin_text}\n").as_bytes())
        .expect("write stdin");
    let out = child.wait_with_output().expect("wait");
    assert!(
        out.status.success(),
        "process failed (exit {:?}): {}{}",
        out.status.code(),
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    String::from_utf8_lossy(&out.stdout).into_owned()
}

/// Feed `input` on stdin to a program that reads one tainted line, applies
/// `expr` to it, and prints the result. Assert both backends agree.
fn assert_agree(tag: &str, expr: &str, input: &str) {
    assert_agree_eff(tag, expr, input, "(Sistem | Tulis)");
}

/// As `assert_agree`, with an explicit effect annotation. The HTTP sinks carry
/// `Rangkaian`, and RIINA's capability discipline rejects the program outright
/// without it — a useful reminder that the effect system gates these before
/// either backend runs.
fn assert_agree_eff(tag: &str, expr: &str, input: &str, eff: &str) {
    if !require_cc() {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.dir.join(format!("{}.rii", sb.stem));
    std::fs::write(
        &src,
        format!(
            "fungsi utama() -> Nombor kesan {eff} {{\n\
             \x20   biar mentah = baca_baris(());\n\
             \x20   cetakln({expr});\n\
             \x20   0\n\
             }}\n"
        ),
    )
    .expect("write program");

    let mut interp_cmd = Command::new(env!("CARGO_BIN_EXE_riinac"));
    interp_cmd.arg("run").arg(&src);
    let interp_raw = feed(&mut interp_cmd, input);
    // `riinac run` appends the program's final value as a trailing line.
    let mut lines: Vec<&str> = interp_raw.lines().collect();
    lines.pop();
    let interp = if lines.is_empty() {
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
        "native build failed for {tag} — keselamatan must route, and so must its \
         taint source `baca_baris`: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );

    let mut native_cmd = Command::new(sb.dir.join(&sb.stem));
    let native = feed(&mut native_cmd, input);

    assert_eq!(
        interp, native,
        "interp/C divergence for {tag}\n  input:  {input:?}\n  interp: {interp:?}\n  C:      {native:?}"
    );
}

// ── Sanitizers ─────────────────────────────────────────────────────────────

#[test]
fn html_and_xml_escapes_agree() {
    assert_agree("html", "sanitasi_html(mentah)", "<a href='x'>&</a>/");
    // XML differs from HTML on the apostrophe (&apos; vs &#x27;) and does not
    // escape '/', so the same input separates the two.
    assert_agree("xml", "sanitasi_xml(mentah)", "<a href='x'>&</a>/");
}

#[test]
fn sql_escape_doubles_quotes_and_strips_nul() {
    assert_agree("sql", "sanitasi_sql(mentah)", "O'Brien \\ end");
}

/// Above the BMP, Rust's `encode_utf16` yields a SURROGATE PAIR, so one
/// codepoint becomes two `\uXXXX` escapes. C has no UTF-16 in sight and must
/// compute the pair explicitly.
#[test]
fn js_escape_emits_surrogate_pairs_above_the_bmp() {
    assert_agree("js_ascii", "sanitasi_js(mentah)", "a-b_c");
    assert_agree("js_latin", "sanitasi_js(mentah)", "café");
    assert_agree("js_astral", "sanitasi_js(mentah)", "x🔒y");
}

/// The trailing space after the hex escape is the CSS terminator, not a typo.
#[test]
fn css_escape_keeps_the_terminating_space() {
    assert_agree("css", "sanitasi_css(mentah)", "a b;c{}");
}

/// `url_encode` iterates BYTES, so a multi-byte codepoint becomes several
/// percent escapes. Writing the C over codepoints would diverge here and only
/// here.
#[test]
fn url_encode_is_byte_wise_not_codepoint_wise() {
    assert_agree("url_ascii", "sanitasi_url(mentah)", "a b/c~d-e._f");
    assert_agree("url_utf8", "sanitasi_url(mentah)", "café ☂");
}

#[test]
fn path_sanitize_drops_traversal_segments() {
    assert_agree("path", "sanitasi_laluan(mentah)", "/a/../b//c/./d");
    assert_agree("path_win", "sanitasi_laluan(mentah)", "..\\..\\etc\\passwd");
}

#[test]
fn shell_quote_wraps_and_escapes_single_quotes() {
    assert_agree("shell", "sanitasi_perintah(mentah)", "it's; rm -rf /");
}

#[test]
fn ldap_and_json_escapes_agree() {
    assert_agree("ldap", "sanitasi_ldap(mentah)", "a*b(c)d\\e");
    assert_agree("json", "sanitasi_json(mentah)", "a\"b\\c");
}

/// `str::trim` is Unicode-aware, so a NBSP-padded address must trim in both
/// backends. An ASCII-only trim in C would leave the NBSP behind.
#[test]
fn email_sanitize_trims_unicode_whitespace() {
    assert_agree("email", "sanitasi_emel(mentah)", "  user@example.test  ");
    assert_agree("email_nbsp", "sanitasi_emel(mentah)", "\u{00A0}user@x.test\u{2007}");
}

// ── Validators / normalizers ───────────────────────────────────────────────

#[test]
fn url_validate_allows_only_the_safe_schemes() {
    assert_agree("u_https", "sahkan_url(mentah)", "  HTTPS://x.test/p  ");
    assert_agree("u_js", "sahkan_url(mentah)", "javascript:alert(1)");
    assert_agree("u_rel", "sahkan_url(mentah)", "/relative/ok");
    // Protocol-relative `//evil` must NOT be treated as a safe relative path.
    assert_agree("u_proto_rel", "sahkan_url(mentah)", "//evil.test/x");
}

#[test]
fn normalize_unicode_strips_bidi_and_zero_width() {
    // RLO is the classic filename-spoofing character; ZWSP hides token breaks.
    assert_agree("norm", "normal_unicode(mentah)", "a\u{202E}b\u{200B}c\u{FEFF}d");
}

#[test]
fn strip_nulls_removes_nul_only() {
    assert_agree("nul", "buang_null(mentah)", "a b c");
}

// ── Modelled sinks ─────────────────────────────────────────────────────────

/// The sinks do not perform the dangerous operation in either backend. What is
/// pinned is that they agree on what they return, so a compiled program sees
/// the same values.
#[test]
fn modelled_sinks_agree() {
    assert_agree("sink_sql", "sql_laksana(sanitasi_sql(mentah))", "O'Brien");
    assert_agree("sink_html", "html_papar(sanitasi_html(mentah))", "<b>x</b>");
    assert_agree(
        "sink_shell",
        "ke_teks(shell_laksana(sanitasi_perintah(mentah)))",
        "ls -la",
    );
    assert_agree_eff(
        "sink_http",
        "http_dapat(sahkan_url(mentah))",
        "https://x.test",
        "(Sistem | Tulis | Rangkaian)",
    );
    // `badan_http` extracts the body of a modelled response, so it too is a
    // Network operation as far as the effect system is concerned.
    assert_agree_eff(
        "sink_body",
        "badan_http(sanitasi_html(mentah))",
        "<i>y</i>",
        "(Sistem | Tulis | Rangkaian)",
    );
}

/// The taint source itself: both backends must read the same line and strip
/// the trailing newline identically.
#[test]
fn taint_source_reads_the_same_line() {
    assert_agree("taint", "mentah", "plain line of input");
}

// ── Pair-taking members ────────────────────────────────────────────────────

/// Feed `input` on stdin to a program whose body is `body`, and assert both
/// backends agree. Unlike [`assert_agree_eff`] the caller writes the whole body,
/// which the pair-taking cases need because a single expression cannot show a
/// predicate answering differently on two inputs.
fn assert_body_agrees(tag: &str, body: &str, input: &str, eff: &str) {
    if !require_cc() {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.dir.join(format!("{}.rii", sb.stem));
    std::fs::write(
        &src,
        format!("fungsi utama() -> Nombor kesan {eff} {{\n{body}\n    0\n}}\n"),
    )
    .expect("write program");

    let mut interp_cmd = Command::new(env!("CARGO_BIN_EXE_riinac"));
    interp_cmd.arg("run").arg(&src);
    let interp_raw = feed(&mut interp_cmd, input);
    let mut lines: Vec<&str> = interp_raw.lines().collect();
    lines.pop();
    let interp = if lines.is_empty() {
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
        "native build failed for {tag}: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );

    let mut native_cmd = Command::new(sb.dir.join(&sb.stem));
    let native = feed(&mut native_cmd, input);

    assert_eq!(
        interp, native,
        "interp/C divergence for {tag}\n  interp: {interp:?}\n  C:      {native:?}"
    );
}

/// The pair-taking members are reached through an EXPLICIT tuple, never a
/// curried call. That is not a convention this test relies on — the typechecker
/// enforces it: each signature is `Ty::Prod(..) -> _`, so `f(a, b)` is a type
/// error in both backends and the interpreter's `BuiltinPartial` path is
/// unreachable from well-typed source.
///
/// This case exists because the previous increment deferred all eleven of them
/// on the belief that C would need partial-application machinery to match. It
/// does not, and the deferral was the wrong call.
#[test]
fn the_curried_form_is_a_type_error_not_a_divergence() {
    if !require_cc() {
        return;
    }
    let sb = Sandbox::new("curry");
    let src = sb.dir.join(format!("{}.rii", sb.stem));
    std::fs::write(
        &src,
        "fungsi utama() -> Nombor kesan Bersih {\n\
         \x20   biar x = csrf_sahkan(\"a\", \"a\");\n\
         \x20   0\n\
         }\n",
    )
    .expect("write program");

    for verb in ["run", "build"] {
        let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
            .arg(verb)
            .arg(&src)
            .output()
            .expect("riinac");
        let text = format!(
            "{}{}",
            String::from_utf8_lossy(&out.stdout),
            String::from_utf8_lossy(&out.stderr)
        );
        assert!(
            !out.status.success() && text.contains("Type mismatch"),
            "`riinac {verb}` accepted the curried form; the pair-only \
             assumption the C implementations rest on does not hold: {text}"
        );
    }
}

/// CSRF predicates. The EMPTY allowed-origin arms are the load-bearing ones: a
/// C implementation that reached for `strcmp`/`strncmp` alone would accept every
/// origin (and every referer) when the program forgot to configure one.
#[test]
fn csrf_predicates_agree_including_the_empty_allowed_origin() {
    assert_body_agrees(
        "csrf",
        "    cetakln(ke_teks(csrf_sahkan((\"tok\", \"tok\"))));\n\
         \x20   cetakln(ke_teks(csrf_sahkan((\"tok\", \"tox\"))));\n\
         \x20   cetakln(ke_teks(csrf_sahkan((\"tok\", \"tokk\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_origin((\"https://a.test\", \"https://a.test\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_origin((\"https://b.test\", \"https://a.test\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_origin((\"https://a.test\", \"\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_origin((\"\", \"\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_referer((\"https://a.test/p\", \"https://a.test\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_referer((\"https://b.test/p\", \"https://a.test\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_referer((\"https://a\", \"https://a.test\"))));\n\
         \x20   cetakln(ke_teks(csrf_semak_referer((\"anything\", \"\"))));",
        "unused",
        "(Sistem | Tulis)",
    );
}

/// `validate_length` counts UNICODE SCALAR VALUES, not bytes, so a multi-byte
/// input sits on the boundary differently in the two counting schemes. `café` is
/// 4 chars and 5 bytes: at a bound of 4 the interpreter admits it and a
/// byte-counting C would reject it.
#[test]
fn validate_length_counts_characters_not_bytes() {
    assert_body_agrees(
        "vlen",
        "    biar mentah = baca_baris(());\n\
         \x20   cetakln(ke_teks(sahkan_panjang((mentah, 4))));\n\
         \x20   cetakln(ke_teks(sahkan_panjang((mentah, 3))));",
        "café",
        "(Sistem | Tulis)",
    );
    assert_body_agrees(
        "vlen_astral",
        "    biar mentah = baca_baris(());\n\
         \x20   cetakln(ke_teks(sahkan_panjang((mentah, 3))));\n\
         \x20   cetakln(ke_teks(sahkan_panjang((mentah, 2))));",
        "a🔒b",
        "(Sistem | Tulis)",
    );
}

/// The remaining modelled sinks: DOM mutation, email, and the state-changing
/// HTTP methods. All carry a CSRF token in their type, which is the point of
/// their shape; what is pinned here is only that both backends return the same
/// value for it.
#[test]
fn pair_taking_modelled_sinks_agree() {
    assert_body_agrees(
        "pairsinks",
        "    biar mentah = baca_baris(());\n\
         \x20   cetakln(ke_teks(dom_tetap_html((\"#el\", sanitasi_html(mentah)))));\n\
         \x20   cetakln(ke_teks(emel_hantar((sanitasi_emel(mentah), \"subjek\"))));\n\
         \x20   cetakln(ke_teks(emel_tetap_kepala((\"X-H\", sanitasi_emel(mentah)))));\n\
         \x20   cetakln(ke_teks(http_hantar((\"https://x.test\", (\"body\", \"tok\")))));\n\
         \x20   cetakln(ke_teks(http_kemaskini((\"https://x.test\", (\"body\", \"tok\")))));\n\
         \x20   cetakln(ke_teks(http_padam((\"https://x.test\", \"tok\"))));",
        "user@example.test",
        "(Sistem | Tulis | Rangkaian)",
    );
}

// ── Safe file I/O ──────────────────────────────────────────────────────────

/// The `*_selamat` file ops share the verified gate with `fail_*` — the
/// interpreter calls the same `fail::gate_read`/`gate_write`/`gate_delete`, so
/// the emitted C must reach the same `riina_gate`. A "safe" file op that skipped
/// the access check would be the REQ-72 bypass wearing the word `selamat`.
///
/// The paths are relative because `sanitasi_laluan` — the only producer of a
/// `Disanitasi<Teks, PathTraversal>`, and so the only way to call these at all —
/// drops leading separators along with `..` segments. Each backend therefore
/// runs in its own working directory.
fn assert_safe_file_agrees(tag: &str, body: &str, filename: &str) {
    if !require_cc() {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.dir.join(format!("{}.rii", sb.stem));
    std::fs::write(
        &src,
        format!(
            "fungsi utama() -> Nombor kesan (Sistem | SistemFail | Tulis) {{\n{body}\n    0\n}}\n"
        ),
    )
    .expect("write program");

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "native build failed for {tag}: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );

    // Separate working directories: a shared one would let one backend read the
    // file the other wrote and make an agreement look real when it was leftover
    // state.
    let idir = sb.dir.join("wd_interp");
    let ndir = sb.dir.join("wd_native");
    std::fs::create_dir_all(&idir).expect("interp wd");
    std::fs::create_dir_all(&ndir).expect("native wd");

    // `drop_value_line` is true ONLY for the interpreter: `riinac run` appends
    // the program's final value as an extra line, and only when the program
    // completes. A compiled binary never prints it, so applying the same trim to
    // both would silently discard a real line of the native output.
    let run = |dir: &PathBuf, cmd: &mut Command, drop_value_line: bool| -> String {
        let mut child = cmd
            .current_dir(dir)
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .stderr(Stdio::piped())
            .spawn()
            .expect("spawn");
        child
            .stdin
            .as_mut()
            .expect("stdin")
            .write_all(format!("{filename}\n").as_bytes())
            .expect("write stdin");
        let out = child.wait_with_output().expect("wait");
        let s = String::from_utf8_lossy(&out.stdout).into_owned();
        let mut lines: Vec<&str> = s.lines().collect();
        // A denial is an expected outcome here, so a non-zero exit is not
        // asserted against; what is compared is the output up to that point.
        if drop_value_line && out.status.success() {
            lines.pop();
        }
        if lines.is_empty() {
            String::new()
        } else {
            format!("{}\n", lines.join("\n"))
        }
    };

    let mut interp_cmd = Command::new(env!("CARGO_BIN_EXE_riinac"));
    interp_cmd.arg("run").arg(&src);
    let interp = run(&idir, &mut interp_cmd, true);
    let mut native_cmd = Command::new(sb.dir.join(&sb.stem));
    let native = run(&ndir, &mut native_cmd, false);

    assert_eq!(
        interp, native,
        "interp/C divergence for {tag}\n  interp: {interp:?}\n  C:      {native:?}"
    );
}

#[test]
fn safe_file_round_trip_agrees_for_the_owner() {
    assert_safe_file_agrees(
        "sf_owner",
        "    biar p = sanitasi_laluan(baca_baris(()));\n\
         \x20   biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis_selamat((p, \"safe-content\"));\n\
         \x20   cetakln(fail_baca_selamat(p));\n\
         \x20   cetakln(ke_teks(fail_buang_selamat(p)));",
        "nota.txt",
    );
}

/// THE reason these could not be routed before the gate existed: a non-owner
/// write must be refused by the compiled binary exactly as `riinac run` refuses
/// it. Both stop before printing `after`.
#[test]
fn safe_file_write_is_denied_to_a_non_owner_in_both() {
    assert_safe_file_agrees(
        "sf_other",
        "    biar p = sanitasi_laluan(baca_baris(()));\n\
         \x20   biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis_selamat((p, \"owned-by-7\"));\n\
         \x20   cetakln(fail_baca_selamat(p));\n\
         \x20   biar d = vfs_jadi_pengguna(9);\n\
         \x20   cetakln(\"before\");\n\
         \x20   biar e = fail_tulis_selamat((p, \"intruder\"));\n\
         \x20   cetakln(\"after\");",
        "nota.txt",
    );
}

/// A non-owner may READ a 0644 file, so the safe read resolves through the same
/// owner ▷ group ▷ other arms as `fail_baca` rather than a blanket owner check.
#[test]
fn safe_file_read_is_allowed_to_a_non_owner_in_both() {
    assert_safe_file_agrees(
        "sf_otherread",
        "    biar p = sanitasi_laluan(baca_baris(()));\n\
         \x20   biar a = vfs_mula(100000);\n\
         \x20   biar b = vfs_jadi_pengguna(7);\n\
         \x20   biar c = fail_tulis_selamat((p, \"owned-by-7\"));\n\
         \x20   biar d = vfs_jadi_pengguna(9);\n\
         \x20   cetakln(fail_baca_selamat(p));",
        "nota.txt",
    );
}

// ── Safe parsers ───────────────────────────────────────────────────────────

/// `json_parse_safe`'s contract is that malformed input yields Unit rather than
/// stopping the program — which is why it could not be routed until the emitted
/// JSON parser could FAIL at all. The old one never did: it fell through to
/// `strtoll` and invented a value, so "malformed" had no meaning on the C side
/// and every one of these would have printed a number instead of `null`.
#[test]
fn safe_parsers_yield_unit_on_malformed_input_in_both() {
    for (tag, input) in [
        ("sp_word", "xyz"),
        ("sp_trail", "12abc"),
        ("sp_nul", "nul"),
        ("sp_arr", "[1,2"),
    ] {
        assert_body_agrees(
            tag,
            "    biar mentah = baca_baris(());\n\
             \x20   cetakln(json_ke_teks(json_urai_selamat(sanitasi_json(mentah))));\n\
             \x20   cetakln(json_ke_teks(nyahsiri_selamat(sanitasi_json(mentah))));",
            input,
            "(Sistem | Tulis)",
        );
    }
}

/// Well-formed input parses identically — and pins a STDLIB WART rather than a
/// codegen one, so that a future fix has to update this case deliberately.
///
/// `sanitasi_json` is the only producer of `Disanitasi<Teks, JsonValidation>`
/// and so the only way to reach `json_urai_selamat`. But it is a
/// string-EMBEDDING escaper: it turns `{"a":1}` into `{\"a\":1}`. Every JSON
/// object therefore arrives malformed and parses to Unit, because object keys
/// are quoted. Only quote-free documents — numbers, booleans, `null`, arrays of
/// those — survive the round trip, which is what the array case below shows.
/// Both backends agree on this, so it is a type-signature defect in the security
/// stdlib (the gate on a safe PARSER should be a validation, not an escape), not
/// a divergence between them.
#[test]
fn safe_parsers_agree_on_what_survives_the_sanitizer() {
    assert_body_agrees(
        "sp_arr_ok",
        "    biar mentah = baca_baris(());\n\
         \x20   cetakln(json_ke_teks(json_urai_selamat(sanitasi_json(mentah))));",
        "[1,2,3]",
        "(Sistem | Tulis)",
    );
    assert_body_agrees(
        "sp_obj_lost",
        "    biar mentah = baca_baris(());\n\
         \x20   cetakln(json_ke_teks(json_urai_selamat(sanitasi_json(mentah))));",
        "{\"a\":1}",
        "(Sistem | Tulis)",
    );
}

/// `xml_parse_safe` is identity on the document text in the interpreter — there
/// is no XML tree in-tree, and it deliberately does not resolve entities (no XXE
/// surface). Identity in C too; inventing a tree would be the overclaim.
#[test]
fn xml_parse_safe_is_identity_in_both() {
    assert_body_agrees(
        "xps",
        "    biar mentah = baca_baris(());\n\
         \x20   cetakln(xml_urai_selamat(sanitasi_xml(mentah)));",
        "<a href='x'>&</a>",
        "(Sistem | Tulis)",
    );
}
