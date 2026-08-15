// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Real HTTP/1.1 from RIINA programs (master plan REQ-73).
//!
//! Before REQ-73 the only HTTP in RIINA was modelled: `http_get` returned the
//! constant `"200 OK"` with no socket opened, so a `.rii` program could not
//! speak HTTP at all. `jaring_*` gave real TCP, but everything above it had to
//! be hand-rolled string concatenation — which is how framing bugs are written.
//!
//! These tests drive the real `riinac` binary and are hermetic: every socket is
//! **127.0.0.1:0**, an ephemeral loopback port, so there is no external network
//! and no fixed port to collide on. The client test serves from a thread inside
//! the test process; the server test lets the RIINA program bind and PRINT its
//! own address via `jaring_alamat` (ephemeral-port discovery), which the test
//! reads back — rather than probing for a free port and racing to rebind it.

use std::io::{Read, Write};
use std::net::{TcpListener, TcpStream};
use std::path::PathBuf;
use std::process::Command;

/// Write a program to a temp file and run it through `riinac run`.
/// Returns (success, stdout+stderr).
fn run_riina(tag: &str, source: &str) -> (bool, String) {
    let path: PathBuf =
        std::env::temp_dir().join(format!("riina_req73_{tag}_{}.rii", std::process::id()));
    std::fs::write(&path, source).expect("write program");
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&path)
        .output()
        .expect("run riinac");
    let _ = std::fs::remove_file(&path);
    let mut s = String::from_utf8_lossy(&out.stdout).into_owned();
    s.push_str(&String::from_utf8_lossy(&out.stderr));
    (out.status.success(), s)
}

/// Serve exactly one HTTP response on an ephemeral loopback port.
/// Returns the bound port and the thread handle (joined for the request text).
fn serve_once(response: &'static str) -> (u16, std::thread::JoinHandle<String>) {
    let listener = TcpListener::bind("127.0.0.1:0").expect("bind loopback");
    let port = listener.local_addr().expect("addr").port();
    let handle = std::thread::spawn(move || {
        let (mut stream, _) = listener.accept().expect("accept");
        let mut buf = [0u8; 8192];
        let n = stream.read(&mut buf).unwrap_or(0);
        let request = String::from_utf8_lossy(&buf[..n]).into_owned();
        let _ = stream.write_all(response.as_bytes());
        let _ = stream.flush();
        request
    });
    (port, handle)
}

/// `http_minta` performs a REAL request and returns the response body.
#[test]
fn http_minta_performs_a_real_request() {
    let (port, server) = serve_once(
        "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 11\r\n\r\nhalo dunia!",
    );
    let (ok, out) = run_riina(
        "client",
        &format!(
            "fungsi utama() -> Teks kesan (Rangkaian | Tulis) {{\n\
             \x20   biar jasad = http_minta((\"GET\", \"http://127.0.0.1:{port}/ujian\"));\n\
             \x20   cetakln(jasad);\n\
             \x20   jasad\n\
             }}\n"
        ),
    );
    let request = server.join().expect("server thread");

    assert!(ok, "client run failed: {out}");
    assert!(out.contains("halo dunia!"), "body not returned: {out}");
    // The request the server actually saw must be well-formed HTTP/1.1.
    assert!(
        request.starts_with("GET /ujian HTTP/1.1\r\n"),
        "bad request line: {request:?}"
    );
    assert!(
        request.to_lowercase().contains("host: 127.0.0.1"),
        "missing Host header: {request:?}"
    );
    assert!(
        request.contains("Content-Length: 0\r\n"),
        "framing not computed: {request:?}"
    );
}

/// A RIINA program can serve HTTP: parse a real request off a socket and reply
/// with a correctly framed response that an ordinary client accepts.
///
/// The server binds `127.0.0.1:0` and PRINTS the address it got
/// (`jaring_alamat` — ephemeral-port discovery, which is what that builtin
/// exists for). The test reads the port back from the child's stdout rather
/// than probing for a free port and racing to rebind it.
#[test]
fn riina_program_serves_a_real_http_response() {
    let source = "fungsi utama() -> Teks kesan (Rangkaian | Tulis) {\n\
         \x20   biar pendengar = jaring_dengar(\"127.0.0.1:0\");\n\
         \x20   cetakln(jaring_alamat(pendengar));\n\
         \x20   biar sambungan = jaring_terima_sambungan(pendengar);\n\
         \x20   biar mentah = jaring_terima((sambungan, 8192));\n\
         \x20   biar laluan = http_hurai_laluan(mentah);\n\
         \x20   biar balasan = http_balas((200, \"laluan=\" + laluan));\n\
         \x20   biar n = jaring_hantar((sambungan, balasan));\n\
         \x20   biar _t = jaring_tutup(sambungan);\n\
         \x20   biar _l = jaring_tutup_dengar(pendengar);\n\
         \x20   laluan\n\
         }\n";
    let path: PathBuf =
        std::env::temp_dir().join(format!("riina_req73_server_{}.rii", std::process::id()));
    std::fs::write(&path, source).expect("write program");

    let mut child = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&path)
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .spawn()
        .expect("spawn riinac server");

    // First stdout line is the bound address, printed once the listener is up.
    let stdout = child.stdout.take().expect("piped stdout");
    let mut reader = std::io::BufReader::new(stdout);
    let mut addr_line = String::new();
    std::io::BufRead::read_line(&mut reader, &mut addr_line).expect("read bound address");
    let addr = addr_line.trim().to_string();
    assert!(
        addr.starts_with("127.0.0.1:"),
        "server did not report its address, got {addr:?}"
    );

    let mut stream = TcpStream::connect(&addr).expect("connect to RIINA server");
    stream
        .write_all(b"GET /dari-ujian HTTP/1.1\r\nHost: 127.0.0.1\r\n\r\n")
        .expect("send request");

    let mut response = String::new();
    stream.read_to_string(&mut response).expect("read response");
    let _ = child.wait();
    let _ = std::fs::remove_file(&path);

    assert!(
        response.starts_with("HTTP/1.1 200 OK\r\n"),
        "bad status line: {response:?}"
    );
    assert!(
        response.contains("Content-Length: 18\r\n"),
        "framing not computed: {response:?}"
    );
    assert!(
        response.ends_with("laluan=/dari-ujian"),
        "wrong body: {response:?}"
    );
}

/// A request-smuggling attempt is an ERROR inside the RIINA program, not a
/// silently mis-framed message. This is the property that makes the codec worth
/// having over hand-rolled string parsing.
#[test]
fn smuggled_request_fails_the_program() {
    let (ok, out) = run_riina(
        "smuggle",
        "fungsi utama() -> Teks kesan Tulis {\n\
         \x20   biar jahat = \"POST / HTTP/1.1\\r\\nHost: a.test\\r\\nContent-Length: 4\\r\\nTransfer-Encoding: chunked\\r\\n\\r\\ndata\";\n\
         \x20   http_hurai_laluan(jahat)\n\
         }\n",
    );
    assert!(!ok, "smuggled request must fail the program: {out}");
    assert!(out.contains("smuggling"), "should name the attack: {out}");
}

/// `https://` is refused rather than silently downgraded to cleartext — there
/// is no TLS record layer yet (the open half of REQ-73).
#[test]
fn https_is_refused_not_downgraded() {
    let (ok, out) = run_riina(
        "https",
        "fungsi utama() -> Teks kesan Rangkaian {\n\
         \x20   http_minta((\"GET\", \"https://bank.test/\"))\n\
         }\n",
    );
    assert!(!ok, "https must not succeed: {out}");
    assert!(
        out.contains("REQ-73") && out.contains("not supported"),
        "refusal should explain itself: {out}"
    );
}

/// A response body carrying CRLF cannot forge a header: framing is computed and
/// the body is length-delimited, so the injected text stays in the body.
#[test]
fn response_body_cannot_forge_a_header() {
    let (ok, out) = run_riina(
        "inject",
        "fungsi utama() -> Teks kesan Tulis {\n\
         \x20   biar jahat = \"a\\r\\nSet-Cookie: pwned=1\";\n\
         \x20   cetakln(http_balas((200, jahat)));\n\
         \x20   jahat\n\
         }\n",
    );
    assert!(ok, "run failed: {out}");
    let head_end = out.find("\r\n\r\n").expect("response has a head");
    assert!(
        !out[..head_end].to_lowercase().contains("set-cookie"),
        "injected header reached the head: {out}"
    );
    assert!(
        out.contains("Content-Length: 22\r\n"),
        "body should be length-delimited: {out}"
    );
}

/// Header lookup is case-insensitive, and an absent field yields "" so a RIINA
/// program can branch without an option type.
#[test]
fn header_lookup_is_case_insensitive() {
    let (ok, out) = run_riina(
        "headers",
        "fungsi utama() -> Teks kesan Tulis {\n\
         \x20   biar r = \"GET / HTTP/1.1\\r\\nHost: a.test\\r\\nX-Ujian: nilai\\r\\n\\r\\n\";\n\
         \x20   cetakln(\"[\" + http_hurai_kepala((r, \"X-UJIAN\")) + \"]\");\n\
         \x20   cetakln(\"[\" + http_hurai_kepala((r, \"X-Tiada\")) + \"]\");\n\
         \x20   \"ok\"\n\
         }\n",
    );
    assert!(ok, "run failed: {out}");
    assert!(out.contains("[nilai]"), "case-insensitive lookup: {out}");
    assert!(out.contains("[]"), "absent header should be empty: {out}");
}
