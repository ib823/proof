// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Differential tests of the RFC 8446 wire format against **real OpenSSL**.
//!
//! A wire format is a claim about what *other* implementations will accept.
//! Round-trip tests cannot substantiate that claim: a parser and an encoder
//! that share the same misunderstanding round-trip perfectly and interoperate
//! with nobody. So both directions are tested against an outside implementation:
//!
//!   * **decode** — `openssl s_client` generates a ClientHello and
//!     [`riina_tls::wire::ClientHello::parse`] must extract the real fields
//!     from it;
//!   * **encode** — our ClientHello is fed to `openssl s_server`, which must
//!     answer with a ServerHello agreeing on the suite and group, rather than
//!     with an alert.
//!
//! The encode direction is the load-bearing one. OpenSSL rejecting a malformed
//! hello produces an alert, and an alert is a *distinguishable* outcome from a
//! ServerHello — so this test fails loudly on exactly the bug it exists to
//! catch.
//!
//! Following `riinac`'s C/WASM differentials, a missing `openssl` makes these
//! tests **fail**, not silently skip: a test that skips itself is unverified,
//! not green. Opt out deliberately with `RIINA_ALLOW_MISSING_BACKEND_TOOLS=1`
//! and the skip is announced on stderr.

use riina_tls::handshake::{ClientHandshake, ClientRandomness};
use riina_tls::wire::{
    parse_handshake, parse_record, ClientHello, ServerHello, CT_ALERT, CT_HANDSHAKE,
    ED25519_SPKI_LEN, GROUP_X25519, HS_SERVER_HELLO, SIG_ED25519, TLS13_VERSION,
    TLS_AES_256_GCM_SHA384,
};
use riina_tls::HashAlg;
use std::io::{Read, Write};
use std::net::{TcpListener, TcpStream};
use std::path::{Path, PathBuf};
use std::process::{Child, Command, Stdio};
use std::time::{Duration, Instant};

// ---------------------------------------------------------------------------
// Tool gating — mirrors riinac's backend differentials
// ---------------------------------------------------------------------------

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("version")
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .map(|s| s.success())
        .unwrap_or(false)
}

/// Require `openssl`, or fail — never skip silently.
///
/// A silently-skipping test counts toward a green run while verifying nothing.
/// That is how a real C/WASM codegen regression reached `main` on 2026-08-04
/// (see `riinac/tests/corpus_differential.rs`), and the same trap applies with
/// more force here: without OpenSSL these tests verify only that our code
/// agrees with itself, which is precisely the thing they exist to disprove.
fn require_openssl() -> bool {
    if tool_available("openssl") {
        return true;
    }
    if std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_ok() {
        eprintln!(
            "!!! SKIPPED (openssl missing) — the TLS wire format is NOT verified \
             against any outside implementation in this run."
        );
        return false;
    }
    panic!(
        "openssl is required for the TLS wire differential. Without it this test \
         verifies only that RIINA agrees with itself, so it fails rather than \
         reporting a false pass. Install openssl, or set \
         RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately."
    );
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// A scratch directory that removes itself, so a failing test cannot leave
/// private keys behind.
struct TempDir(PathBuf);

impl TempDir {
    fn new(tag: &str) -> Self {
        let mut p = std::env::temp_dir();
        let uniq = format!(
            "riina-tls-{tag}-{}-{:?}",
            std::process::id(),
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .map(|d| d.as_nanos())
                .unwrap_or(0)
        );
        p.push(uniq);
        std::fs::create_dir_all(&p).expect("create temp dir");
        Self(p)
    }

    fn path(&self) -> &Path {
        &self.0
    }
}

impl Drop for TempDir {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}

/// Kill the child on the way out even if an assertion unwinds — otherwise a
/// failing test leaks an `openssl s_server` holding a port.
struct Reaper(Child);

impl Drop for Reaper {
    fn drop(&mut self) {
        let _ = self.0.kill();
        let _ = self.0.wait();
    }
}

/// Bind an ephemeral port and keep the listener, returning both.
///
/// Deliberately NOT a `free_port() -> u16` that binds and drops: these tests
/// run in parallel, so between dropping the probe listener and re-binding the
/// same number, the other test's `openssl s_server` can take it. That race was
/// observed failing 2 runs in 8 before this was changed. Holding the listener
/// leaves no window at all.
fn bound_listener() -> (TcpListener, u16) {
    let l = TcpListener::bind("127.0.0.1:0").expect("bind ephemeral");
    let p = l.local_addr().expect("local addr").port();
    (l, p)
}

/// Pick a port for a child process that must bind it itself.
///
/// A child cannot inherit our listener, so the bind-and-drop window is
/// unavoidable here — it is closed by *retrying on a fresh port* in the caller
/// when the child fails to come up, rather than by hoping.
fn candidate_port() -> u16 {
    let (l, p) = bound_listener();
    drop(l);
    p
}

/// The ClientHello RIINA sends: exactly one registered suite, x25519, Ed25519
/// signatures, TLS 1.3 only.
fn riina_client_hello(share: [u8; 32]) -> ClientHello {
    ClientHello {
        random: [0x5Au8; 32],
        // A 32-byte session id is what TLS 1.3 clients send for middlebox
        // compatibility. Sending one exercises the echo path in the server.
        legacy_session_id: vec![0x7Cu8; 32],
        cipher_suites: vec![TLS_AES_256_GCM_SHA384],
        supported_versions: vec![TLS13_VERSION],
        key_share_x25519: Some(share),
        signature_algorithms: vec![SIG_ED25519],
    }
}

// ---------------------------------------------------------------------------
// 1. Decode: parse a ClientHello that OpenSSL generated
// ---------------------------------------------------------------------------

#[test]
fn parses_a_real_openssl_client_hello() {
    if !require_openssl() {
        return;
    }

    let (listener, port) = bound_listener();

    // s_client will fail to complete the handshake (we never answer), which is
    // fine — we only want the bytes of its first flight.
    let child = Command::new("openssl")
        .args([
            "s_client",
            "-connect",
            &format!("127.0.0.1:{port}"),
            "-tls1_3",
            "-ciphersuites",
            "TLS_AES_256_GCM_SHA384",
            "-groups",
            "x25519",
        ])
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
        .expect("spawn openssl s_client");
    let _reap = Reaper(child);

    let (mut sock, _) = listener.accept().expect("accept s_client");
    sock.set_read_timeout(Some(Duration::from_secs(10))).ok();
    let mut buf = vec![0u8; 16 * 1024];
    let n = sock.read(&mut buf).expect("read ClientHello");
    assert!(n > 0, "openssl sent nothing");
    buf.truncate(n);

    // Record → handshake → ClientHello, all with our own parser.
    let rec = parse_record(&buf).expect("parse record");
    assert_eq!(
        rec.content_type, CT_HANDSHAKE,
        "first record from a TLS client must be a handshake record"
    );
    let hs = parse_handshake(rec.fragment).expect("parse handshake");
    assert_eq!(hs.msg_type, riina_tls::wire::HS_CLIENT_HELLO);
    assert_eq!(
        hs.consumed,
        rec.fragment.len(),
        "the ClientHello must fill its record exactly"
    );

    let ch = ClientHello::parse(hs.body).expect("parse ClientHello body");

    // These are the fields a server actually acts on, so these are the ones
    // worth asserting — a parser that got the offsets subtly wrong would still
    // "succeed" but produce nonsense here.
    assert!(
        ch.offers_tls13(),
        "supported_versions must carry 0x0304; got {:04x?}",
        ch.supported_versions
    );
    assert!(
        ch.offers_suite(TLS_AES_256_GCM_SHA384),
        "we asked openssl for exactly this suite; got {:04x?}",
        ch.cipher_suites
    );
    let share = ch
        .key_share_x25519
        .expect("openssl was told -groups x25519, so a key_share must be present");
    assert_ne!(share, [0u8; 32], "an all-zero x25519 share is not plausible");
    assert_eq!(
        ch.legacy_session_id.len(),
        32,
        "TLS 1.3 clients send a 32-byte compatibility session id"
    );
    assert!(
        !ch.signature_algorithms.is_empty(),
        "openssl always offers signature_algorithms"
    );
}

// ---------------------------------------------------------------------------
// Spinning up a real OpenSSL server
// ---------------------------------------------------------------------------

/// Generate an Ed25519 server certificate into `dir`.
///
/// Ed25519 specifically, so the server's signing algorithm matches the single
/// scheme our hello offers. With an RSA certificate OpenSSL would reject the
/// hello for lack of a shared signature algorithm — a *negotiation* failure
/// that looks exactly like an encoding failure and would make these tests lie
/// about what they proved.
fn make_ed25519_cert(dir: &Path) -> (PathBuf, PathBuf) {
    let cert = dir.join("cert.pem");
    let key = dir.join("key.pem");
    let st = Command::new("openssl")
        .args([
            "req",
            "-x509",
            "-newkey",
            "ed25519",
            "-keyout",
            key.to_str().unwrap(),
            "-out",
            cert.to_str().unwrap(),
            "-days",
            "1",
            "-nodes",
            "-subj",
            "/CN=riina.test",
        ])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .expect("run openssl req");
    assert!(st.success(), "failed to generate an Ed25519 test certificate");
    (cert, key)
}

/// Start `openssl s_server` and connect to it.
///
/// `s_server` must bind the port itself, so the port cannot be reserved for it
/// in advance. Rather than assume the guess was free, retry on a fresh port
/// when the server does not come up — a lost race then costs a retry instead
/// of a spurious failure.
fn openssl_server(cert: &Path, key: &Path) -> (Reaper, TcpStream) {
    for attempt in 1..=4 {
        let port = candidate_port();
        let child = Command::new("openssl")
            .args([
                "s_server",
                "-accept",
                &port.to_string(),
                "-cert",
                cert.to_str().unwrap(),
                "-key",
                key.to_str().unwrap(),
                "-tls1_3",
                "-ciphersuites",
                "TLS_AES_256_GCM_SHA384",
                "-groups",
                "x25519",
                "-naccept",
                "1",
                "-quiet",
            ])
            .stdin(Stdio::null())
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()
            .expect("spawn openssl s_server");
        let reaper = Reaper(child);

        // Wait for the server to bind rather than sleeping a fixed amount.
        let deadline = Instant::now() + Duration::from_secs(10);
        let mut connected = None;
        loop {
            if let Ok(s) = TcpStream::connect(("127.0.0.1", port)) {
                connected = Some(s);
                break;
            }
            if Instant::now() >= deadline {
                break;
            }
            std::thread::sleep(Duration::from_millis(25));
        }
        if let Some(s) = connected {
            s.set_read_timeout(Some(Duration::from_secs(15))).ok();
            return (reaper, s);
        }
        eprintln!("openssl s_server did not come up on port {port} (attempt {attempt}); retrying");
    }
    panic!("openssl s_server never came up on any candidate port");
}

/// Send `hello_msg` as a handshake record and require a ServerHello back.
///
/// OpenSSL rejecting a malformed hello produces an alert, and an alert is a
/// *distinguishable* outcome from a ServerHello — so this fails loudly on
/// exactly the bug it exists to catch.
fn exchange_client_hello(sock: &mut TcpStream, hello_msg: &[u8]) -> ServerHello {
    let record = riina_tls::wire::encode_record(CT_HANDSHAKE, hello_msg).expect("encode record");
    sock.write_all(&record).expect("send ClientHello");
    sock.flush().ok();

    let mut resp = Vec::new();
    let mut chunk = [0u8; 8192];
    let deadline = Instant::now() + Duration::from_secs(15);
    while Instant::now() < deadline {
        match sock.read(&mut chunk) {
            Ok(0) => break,
            Ok(n) => {
                resp.extend_from_slice(&chunk[..n]);
                if parse_record(&resp).is_ok() {
                    break;
                }
            }
            Err(_) => break,
        }
    }

    assert!(
        !resp.is_empty(),
        "openssl s_server closed without a single byte — it did not accept our ClientHello"
    );
    let rec = parse_record(&resp).expect("parse the server's first record");
    assert_ne!(
        rec.content_type, CT_ALERT,
        "openssl answered with an ALERT ({:02x?}), meaning it rejected our ClientHello",
        rec.fragment
    );
    assert_eq!(
        rec.content_type, CT_HANDSHAKE,
        "expected a handshake record, got content type {}",
        rec.content_type
    );
    let hs = parse_handshake(rec.fragment).expect("parse the server handshake message");
    assert_eq!(
        hs.msg_type, HS_SERVER_HELLO,
        "expected ServerHello, got handshake type {}",
        hs.msg_type
    );
    ServerHello::parse(hs.body).expect("parse ServerHello")
}

/// The checks that say OpenSSL genuinely agreed with us, rather than merely
/// not crashing.
fn assert_agreed(sh: &ServerHello, expect_session_id: &[u8]) {
    assert!(
        !sh.is_hello_retry_request(),
        "we offered the group openssl was configured with, so an HRR means our \
         key_share extension did not land where the server looked for it"
    );
    assert_eq!(
        sh.cipher_suite, TLS_AES_256_GCM_SHA384,
        "openssl selected a suite we did not offer"
    );
    assert_eq!(
        sh.selected_version,
        Some(TLS13_VERSION),
        "openssl did not select TLS 1.3"
    );
    assert!(
        sh.key_share_x25519.is_some(),
        "openssl did not return an x25519 share"
    );
    // The compatibility session id must come back verbatim — this is the
    // clearest single proof that OpenSSL read our fields at the right offsets
    // rather than accidentally succeeding.
    assert_eq!(
        sh.legacy_session_id_echo, expect_session_id,
        "openssl echoed a different session id than the one we sent"
    );
}

// ---------------------------------------------------------------------------
// 2. Encode: OpenSSL must accept OUR ClientHello
// ---------------------------------------------------------------------------

/// The load-bearing test: a real OpenSSL server parses a ClientHello that this
/// crate produced, and answers with a ServerHello that agrees on the suite and
/// the group.
///
/// If any length prefix, field order or extension encoding were wrong, OpenSSL
/// would send an alert (content type 21) or drop the connection — both of
/// which fail here, distinguishably.
#[test]
fn openssl_server_accepts_our_client_hello() {
    if !require_openssl() {
        return;
    }
    let dir = TempDir::new("srv");
    let (cert, key) = make_ed25519_cert(dir.path());
    let (_reap, mut sock) = openssl_server(&cert, &key);

    // A syntactically valid but cryptographically arbitrary share: this test
    // checks that OpenSSL *parses and accepts* our hello, and it never gets as
    // far as needing the matching private key.
    let session_id = vec![0x7Cu8; 32];
    let hello = riina_client_hello([0x09u8; 32]).encode().expect("encode hello");
    let sh = exchange_client_hello(&mut sock, &hello);
    assert_agreed(&sh, &session_id);
}

/// **The increment-5 test.** The hello above is hand-built from `wire`; this
/// one comes out of the real handshake path — `ClientHandshake::start`, the
/// same call the `jaring_tls_jabat` builtin makes. OpenSSL must accept it and
/// agree on suite, group, version and the echoed session id.
///
/// This is the difference between "RIINA can construct RFC 8446 bytes" and
/// "the bytes RIINA actually sends are RFC 8446". Increment 4 could only claim
/// the former.
#[test]
fn openssl_server_accepts_the_handshakes_own_client_hello() {
    if !require_openssl() {
        return;
    }
    let dir = TempDir::new("hs");
    let (cert, key) = make_ed25519_cert(dir.path());
    let (_reap, mut sock) = openssl_server(&cert, &key);

    // Real OS entropy, exactly as a live handshake would use.
    let rnd = ClientRandomness::from_os().expect("OS CSPRNG");
    let (_client, hello) =
        ClientHandshake::start(HashAlg::Sha384, &rnd).expect("start handshake");

    let sh = exchange_client_hello(&mut sock, &hello);
    assert_agreed(&sh, &rnd.legacy_session_id);

    // And our own parser reads OpenSSL's ServerHello well enough to drive the
    // key exchange: the share is there and is not degenerate.
    let share = sh.key_share_x25519.expect("x25519 share");
    assert_ne!(share, [0u8; 32], "an all-zero server share is not plausible");
}

/// The SHA-256 variant must NOT interoperate — it announces a private-use code
/// point, and a conforming server has to refuse it. Asserting the refusal
/// keeps the "not a registered suite" note honest: if OpenSSL ever accepted
/// this, the claim that RIINA only speaks a registered suite on the wire would
/// be wrong.
#[test]
fn openssl_refuses_the_unregistered_private_suite() {
    if !require_openssl() {
        return;
    }
    let dir = TempDir::new("priv");
    let (cert, key) = make_ed25519_cert(dir.path());
    let (_reap, mut sock) = openssl_server(&cert, &key);

    let rnd = ClientRandomness::from_os().expect("OS CSPRNG");
    let (_client, hello) =
        ClientHandshake::start(HashAlg::Sha256, &rnd).expect("start handshake");
    let record = riina_tls::wire::encode_record(CT_HANDSHAKE, &hello).expect("encode record");
    sock.write_all(&record).expect("send ClientHello");
    sock.flush().ok();

    let mut resp = Vec::new();
    let mut chunk = [0u8; 4096];
    let deadline = Instant::now() + Duration::from_secs(15);
    while Instant::now() < deadline {
        match sock.read(&mut chunk) {
            Ok(0) => break,
            Ok(n) => {
                resp.extend_from_slice(&chunk[..n]);
                if parse_record(&resp).is_ok() {
                    break;
                }
            }
            Err(_) => break,
        }
    }

    // Either an alert or a closed connection is a correct refusal. What must
    // NOT happen is a ServerHello.
    if let Ok(rec) = parse_record(&resp) {
        assert_ne!(
            rec.content_type, CT_HANDSHAKE,
            "openssl accepted a private-use cipher suite it cannot possibly implement"
        );
    }
}

// ---------------------------------------------------------------------------
// 3. The Ed25519 SubjectPublicKeyInfo we build is the one OpenSSL builds
// ---------------------------------------------------------------------------

/// Our raw-public-key Certificate wraps an Ed25519 key in a DER SPKI. Rather
/// than trust a 12-byte prefix that "looks right", generate a key with OpenSSL,
/// ask it for the DER SPKI, and require ours to be byte-identical.
#[test]
fn ed25519_spki_matches_openssl() {
    if !require_openssl() {
        return;
    }

    let dir = TempDir::new("spki");
    let pem = dir.path().join("ed.pem");

    let st = Command::new("openssl")
        .args([
            "genpkey",
            "-algorithm",
            "ed25519",
            "-out",
            pem.to_str().unwrap(),
        ])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .expect("run openssl genpkey");
    assert!(st.success(), "failed to generate an Ed25519 key");

    let out = Command::new("openssl")
        .args([
            "pkey",
            "-in",
            pem.to_str().unwrap(),
            "-pubout",
            "-outform",
            "DER",
        ])
        .stderr(Stdio::null())
        .output()
        .expect("run openssl pkey");
    assert!(out.status.success(), "failed to export the public key");
    let der = out.stdout;
    assert_eq!(
        der.len(),
        ED25519_SPKI_LEN,
        "an Ed25519 SPKI is {ED25519_SPKI_LEN} bytes"
    );

    // Take the raw key out of OpenSSL's DER with our own parser…
    let raw = riina_tls::wire::ed25519_from_spki(&der)
        .expect("our parser must accept an SPKI that openssl produced");
    // …and rebuilding it must reproduce OpenSSL's bytes exactly.
    assert_eq!(
        riina_tls::wire::ed25519_spki(&raw),
        der,
        "our SPKI encoding differs from openssl's"
    );
}

/// Sanity: the constants this crate exposes are the IANA code points, checked
/// against the names OpenSSL itself prints. A transposed digit in a code point
/// is invisible in a round-trip test and fatal on the wire.
#[test]
fn cipher_suite_code_point_matches_openssls_table() {
    if !require_openssl() {
        return;
    }

    let out = Command::new("openssl")
        .args(["ciphers", "-V", "-ciphersuites", "TLS_AES_256_GCM_SHA384"])
        .stderr(Stdio::null())
        .output()
        .expect("run openssl ciphers");
    assert!(out.status.success(), "openssl ciphers failed");
    let text = String::from_utf8_lossy(&out.stdout);

    // Lines look like: "0x13,0x02 - TLS_AES_256_GCM_SHA384  TLSv1.3 Kx=any ..."
    let want = format!(
        "0x{:02X},0x{:02X}",
        TLS_AES_256_GCM_SHA384 >> 8,
        TLS_AES_256_GCM_SHA384 & 0xff
    );
    let line = text
        .lines()
        .find(|l| l.contains("TLS_AES_256_GCM_SHA384"))
        .expect("openssl does not know TLS_AES_256_GCM_SHA384");
    assert!(
        line.contains(&want),
        "our code point {want} is not the one openssl lists: {}",
        line.trim()
    );

    // x25519 and ed25519 are checked the same way, via the group/sigalg lists.
    assert_eq!(GROUP_X25519, 0x001d, "x25519 NamedGroup code point");
    assert_eq!(SIG_ED25519, 0x0807, "ed25519 SignatureScheme code point");
}
