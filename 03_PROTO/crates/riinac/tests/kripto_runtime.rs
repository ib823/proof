// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! End-to-end tests for the crypto-agility runtime (Wave B.3): the eight
//! selection builtins `guna_kripto`/`use_crypto`, `pilih_algo`/
//! `select_algorithm`, `sifer`/`cipher`, `hash_dengan`/`hash_with`, driven
//! through the real `riinac` binary on real `.rii` source.
//!
//! The load-bearing test is `computed_algorithm_name_is_refused_at_runtime`:
//! the static REQ-48 gate only sees string LITERALS, so a program that builds
//! the algorithm name at runtime passes `riinac check` — and before this
//! runtime existed it then failed with `unbound variable`, which is not a
//! policy decision. Now it is refused at the selection site, with the policy's
//! own rationale, by the same table the checker consults.

use std::path::PathBuf;
use std::process::{Command, Output};

struct Sandbox {
    dir: PathBuf,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let dir = std::env::temp_dir().join(format!("riina_kripto_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Sandbox { dir }
    }
    fn write(&self, name: &str, body: &str) -> PathBuf {
        let p = self.dir.join(name);
        std::fs::write(&p, body).expect("write program");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

fn riinac(args: &[&str], src: &PathBuf) -> Output {
    Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(args)
        .arg(src)
        .output()
        .expect("spawn riinac")
}

fn text(o: &Output) -> String {
    format!(
        "{}{}",
        String::from_utf8_lossy(&o.stdout),
        String::from_utf8_lossy(&o.stderr)
    )
}

/// `riinac run` prints the program's output followed by its final value; the
/// program's own `cetakln` lines are what a test inspects.
fn run_lines(src: &PathBuf) -> (bool, Vec<String>) {
    let o = riinac(&["run"], src);
    let out = String::from_utf8_lossy(&o.stdout).to_string();
    (o.status.success(), out.lines().map(str::to_string).collect())
}

fn program(body: &str) -> String {
    format!("fungsi utama() -> Nombor kesan Kripto {{\n{body}\n    0\n}}\n")
}

// ── The gate the checker cannot run ────────────────────────────────────────

#[test]
fn computed_algorithm_name_is_refused_at_runtime() {
    let sb = Sandbox::new("computed");
    // The name is assembled at runtime, so `deprecated_algorithm_at_selection`
    // (which pattern-matches a string LITERAL) never sees "md5".
    let src = sb.write(
        "computed.rii",
        &program(
            "    biar nama = gabung_teks((\"md\", \"5\"));\n\
             \x20   biar h = guna_kripto(nama);\n\
             \x20   cetakln(\"unreachable\");",
        ),
    );
    let check = riinac(&["check"], &src);
    assert!(
        check.status.success(),
        "the STATIC gate cannot see a computed name — this must typecheck (that is the \
         limitation the runtime closes): {}",
        text(&check)
    );
    let run = riinac(&["run"], &src);
    assert!(!run.status.success(), "the RUNTIME gate must refuse it");
    let err = text(&run);
    assert!(
        err.contains("deprecated by policy") && err.contains("collisions"),
        "refusal must carry the policy's own rationale (the same table the checker uses); got: {err}"
    );
    assert!(
        !err.contains("unbound variable"),
        "before Wave B.3 this failed for the WRONG reason (no runtime at all); got: {err}"
    );
    assert!(!err.contains("unreachable"), "nothing after the refused selection may run");
}

#[test]
fn literal_deprecated_name_is_still_refused_statically_negative_control() {
    // NEGATIVE CONTROL for the test above: with a literal, the static gate
    // fires FIRST — the runtime is a second line, not a replacement.
    let sb = Sandbox::new("literal");
    let src = sb.write("literal.rii", &program("    biar h = guna_kripto(\"md5\");"));
    let check = riinac(&["check"], &src);
    assert!(!check.status.success(), "a literal md5 must fail `riinac check`");
    assert!(text(&check).contains("md5"), "the checker names the algorithm");
}

// ── Handles do real work, interpreter-only ─────────────────────────────────

#[test]
fn hash_handle_hashes_and_the_result_is_a_published_vector() {
    let sb = Sandbox::new("hash");
    let src = sb.write(
        "hash.rii",
        &program(
            "    biar h = hash_dengan(\"SHA-256\");\n\
             \x20   cetakln(h(\"abc\"));\n\
             \x20   biar h3 = hash_with(\"sha3-256\");\n\
             \x20   cetakln(h3(\"abc\"));",
        ),
    );
    let (ok, lines) = run_lines(&src);
    assert!(ok, "run must succeed: {lines:?}");
    assert_eq!(
        lines[0],
        "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
        "SHA-256(\"abc\"), FIPS 180-4 example"
    );
    assert_eq!(
        lines[1],
        "3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532",
        "SHA3-256(\"abc\"), FIPS 202 example"
    );
}

#[test]
fn cipher_handle_round_trips_and_a_tampered_ciphertext_opens_to_tiada() {
    let sb = Sandbox::new("aead");
    let key = "00".repeat(32);
    let nonce = "00".repeat(12);
    let src = sb.write(
        "aead.rii",
        &program(&format!(
            // (`ct` is the constant-time keyword — hence `teks_sifer`.)
            "    biar c = sifer(\"AES-256-GCM\");\n\
             \x20   biar kunci = (\"{key}\", \"{nonce}\");\n\
             \x20   biar teks_sifer = c((\"sulit\", (kunci, \"rahsia besar\")));\n\
             \x20   cetakln(teks_sifer);\n\
             \x20   cetakln(c((\"buka\", (kunci, teks_sifer))));\n\
             \x20   cetakln(c((\"buka\", (kunci, gabung_teks((\"00\", teks_sifer))))));"
        )),
    );
    let (ok, lines) = run_lines(&src);
    assert!(ok, "run must succeed: {lines:?}");
    // 12 bytes of plaintext + 16-byte tag = 28 bytes = 56 hex chars.
    assert_eq!(lines[0].len(), 56, "ciphertext ‖ tag: {}", lines[0]);
    assert!(lines[0].chars().all(|c| c.is_ascii_hexdigit()));
    // A sum renders through `Value`'s Display (quoted payload) — the §4.7
    // rendering divergence noted in the master plan, pinned here as-is.
    assert_eq!(lines[1], "inl \"rahsia besar\"", "opens to Ada(plaintext)");
    assert_eq!(lines[2], "inr ()", "a corrupted ciphertext opens to Tiada, not a crash");
}

#[test]
fn kem_and_signature_handles_agree_with_themselves() {
    let sb = Sandbox::new("pqc");
    let seed64 = (0u8..64).map(|b| format!("{b:02x}")).collect::<String>();
    let seed32 = "42".repeat(32);
    let rnd32 = "ab".repeat(32);
    let src = sb.write(
        "pqc.rii",
        &program(&format!(
            "    biar kem = pilih_algo(\"ML-KEM-768\");\n\
             \x20   biar kk = kem((\"jana\", \"{seed64}\"));\n\
             \x20   biar ek = pertama(kk);\n\
             \x20   biar dk = kedua(kk);\n\
             \x20   biar cs = kem((\"kapsul\", (ek, \"{rnd32}\")));\n\
             \x20   biar ss1 = kedua(cs);\n\
             \x20   biar ss2 = kem((\"nyahkapsul\", (dk, pertama(cs))));\n\
             \x20   cetakln(ss1 == ss2);\n\
             \x20   biar sig = use_crypto(\"ML-DSA-65\");\n\
             \x20   biar sk = sig((\"jana\", \"{seed32}\"));\n\
             \x20   biar tt = sig((\"tandatangan\", (kedua(sk), \"mesej\")));\n\
             \x20   cetakln(sig((\"sahkan\", (pertama(sk), (\"mesej\", tt)))));\n\
             \x20   cetakln(sig((\"sahkan\", (pertama(sk), (\"mesej!\", tt)))));"
        )),
    );
    let (ok, lines) = run_lines(&src);
    assert!(ok, "run must succeed: {lines:?}");
    assert_eq!(lines[0], "betul", "decapsulation recovers the encapsulated secret");
    assert_eq!(lines[1], "betul", "a genuine signature verifies");
    assert_eq!(lines[2], "salah", "the same signature on another message does not");
}

#[test]
fn accepted_but_unbound_algorithm_is_a_named_runtime_error() {
    // ChaCha20 is `Current` under the policy and a constructor of the Coq
    // model, but no primitive exists in-tree: the program typechecks and the
    // runtime says so by name — it does not silently substitute AES.
    let sb = Sandbox::new("unbound");
    let src = sb.write(
        "unbound.rii",
        &program("    biar c = sifer(\"chacha20-poly1305\");\n    cetakln(\"unreachable\");"),
    );
    assert!(riinac(&["check"], &src).status.success(), "policy accepts it");
    let run = riinac(&["run"], &src);
    assert!(!run.status.success());
    let err = text(&run);
    assert!(err.contains("no runtime primitive") && err.contains("chacha20"), "{err}");
    assert!(!err.contains("deprecated"), "not a policy rejection: {err}");
}

#[test]
fn the_handles_are_interpreter_only_and_the_native_build_fails_closed() {
    // No C AES-GCM/ML-KEM in-tree: `riinac build` must refuse, not miscompile.
    let sb = Sandbox::new("native");
    let src = sb.write(
        "native.rii",
        &program("    biar h = hash_dengan(\"sha256\");\n    cetakln(h(\"abc\"));"),
    );
    let build = riinac(&["build"], &src);
    assert!(
        !build.status.success(),
        "a crypto-agility handle must not compile to C (interpreter-only by design)"
    );
}
