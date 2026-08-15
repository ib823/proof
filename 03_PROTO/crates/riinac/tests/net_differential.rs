// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the network + HTTP (`jaring`, `http`)
//! family — master plan REQ-70 family routing.
//!
//! # What this family tests that the earlier ones could not
//!
//! `masa` was a clock (compared as properties, not bytes). `simpan` was a file
//! format (compared as bytes on disk). This family is a **protocol**, and a
//! protocol has a second party — so the load-bearing tests here are the ones
//! where the two backends talk **to each other**: an interpreted client against
//! a compiled server and the reverse. If the C codec framed a message even
//! slightly differently, those two tests are what notices; a single-backend
//! round trip would happily pass with both halves wrong in the same way.
//!
//! # Why the strict-parser refusals are checked, not just the happy path
//!
//! HTTP/1.1's real vulnerabilities are framing disagreements — two parsers
//! reading one byte stream differently. RIINA's `riina-os::http` therefore
//! refuses, rather than guesses, on `Content-Length` + `Transfer-Encoding`,
//! conflicting duplicate lengths, `Foo : bar`, and a missing `Host`. A C
//! backend that accepted any of those would reintroduce exactly the smuggling
//! class the strict parser exists to remove — and it would do so invisibly,
//! since the happy path would still agree. So each hostile message is required
//! to fail on **both** backends.
//!
//! # What is deliberately NOT here
//!
//! `jaring_tls_*`. That half is not routed: it rests on `riina-tls` over
//! `riina-core` (X25519, HKDF-SHA384, AES-256-GCM, the RFC 8446 key schedule,
//! raw-public-key authentication), and a C approximation of it would compile
//! programs that look negotiated while being weaker than the interpreter they
//! were tested against. `tls_builtins_fail_closed_when_compiled` pins that the
//! compiler refuses them rather than lowering something weaker.

use std::io::{BufRead, BufReader};
use std::path::{Path, PathBuf};
use std::process::{Child, Command, Stdio};

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// Guard for tests needing `cc`. A missing tool PANICS by default, because a
/// test that cannot run must never report `ok`; opt out deliberately with
/// `RIINA_ALLOW_MISSING_BACKEND_TOOLS=1`, which announces the lost coverage.
fn require_backend_tools(tools: &[&str]) -> bool {
    let missing: Vec<&str> = tools
        .iter()
        .copied()
        .filter(|t| !tool_available(t))
        .collect();
    if missing.is_empty() {
        return true;
    }
    if std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_ok() {
        eprintln!(
            "!!! SKIPPED (tools missing: {}) — jaring/http coverage NOT exercised.",
            missing.join(", ")
        );
        return false;
    }
    panic!(
        "required backend tool(s) missing: {}. This test cannot verify anything \
         without them, so it fails rather than reporting a false pass. Install \
         them, or set RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately.",
        missing.join(", ")
    );
}

/// A throwaway directory per test, so programs and binaries never collide.
struct Sandbox {
    dir: PathBuf,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let dir =
            std::env::temp_dir().join(format!("riina_req70_net_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self { dir }
    }

    /// Write a whole program; `stem` must be unique because `riinac build`
    /// derives its intermediate C path from it.
    fn program(&self, stem: &str, src: &str) -> PathBuf {
        let p = self.dir.join(format!("{stem}.rii"));
        std::fs::write(&p, src).expect("write program");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

fn riinac() -> Command {
    Command::new(env!("CARGO_BIN_EXE_riinac"))
}

/// Interpreter stdout, without the trailing line `riinac run` adds for the
/// program's final value.
fn run_interp(src: &Path) -> String {
    let out = riinac().arg("run").arg(src).output().expect("riinac run");
    assert!(
        out.status.success(),
        "interpreter failed: {}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    // Drop ONLY the final value line. Splitting into `lines()` and rejoining
    // with "\n" — which is how the earlier family differentials do it — would
    // also silently delete every CR, and CRLF framing is precisely what this
    // family has to get right.
    let s = String::from_utf8_lossy(&out.stdout).into_owned();
    let body = s.strip_suffix('\n').unwrap_or(&s);
    match body.rsplit_once('\n') {
        Some((head, _value_line)) => format!("{head}\n"),
        None => String::new(),
    }
}

fn build(src: &Path) -> PathBuf {
    let out = riinac().arg("build").arg(src).output().expect("riinac build");
    assert!(
        out.status.success(),
        "native build failed — the jaring/http family must ROUTE to codegen: {}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    src.with_extension("")
}

fn run_native(src: &Path) -> String {
    let bin = build(src);
    let run = Command::new(&bin).output().expect("run native binary");
    assert!(
        run.status.success(),
        "native binary failed (exit {:?}): {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    String::from_utf8_lossy(&run.stdout).into_owned()
}

// ── the pure surface: byte equality ────────────────────────────────────────

/// A program exercising every pure builtin in the family. Deliberately printed
/// rather than asserted internally: the comparison is of BYTES, so a divergence
/// in header case, field order, or the computed `Content-Length` shows up.
const CODEC_PROGRAM: &str = r#"fungsi utama() -> Nombor kesan Tulis {
    biar r = "POST /api/v1?x=1 HTTP/1.1\r\nHost: contoh.test\r\nX-Ujian: nilai\r\nContent-Length: 5\r\n\r\nhalo!";
    cetakln(http_hurai_kaedah(r));
    cetakln(http_hurai_laluan(r));
    cetakln(http_hurai_jasad(r));
    cetakln(http_hurai_kepala((r, "x-ujian")));
    cetakln(http_hurai_kepala((r, "X-UJIAN")));
    cetakln(http_hurai_kepala((r, "tiada")));
    cetakln(http_hurai_kepala((r, "host")));
    cetakln(http_balas((200, "<h1>Salam</h1>")));
    cetakln(http_balas((404, "hilang")));
    cetakln(http_balas((599, "")));
    biar dua = "GET / HTTP/1.1\r\nHost: a.test\r\nX-Dua: satu\r\nX-Dua: dua\r\n\r\n";
    cetakln(http_hurai_kepala((dua, "x-dua")));
    biar sepuluh = "GET / HTTP/1.0\r\n\r\n";
    cetakln(http_hurai_kaedah(sepuluh));
    0
}
"#;

/// The pure HTTP codec must agree byte for byte. This is the cheap half of the
/// contract; the socket tests below are the expensive half.
#[test]
fn http_codec_is_byte_equal_across_backends() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("codec");
    let p = sb.program("codec", CODEC_PROGRAM);
    let interp = run_interp(&p);
    let native = run_native(&p);
    assert_eq!(
        interp, native,
        "the HTTP codec must produce identical bytes on both backends"
    );
    // And it must actually be the RIGHT bytes, not merely equal ones: two
    // implementations can agree while both being wrong.
    assert!(
        interp.starts_with("POST\n/api/v1?x=1\nhalo!\nnilai\nnilai\n\ncontoh.test\n"),
        "unexpected parse output:\n{interp}"
    );
    assert!(
        interp.contains("HTTP/1.1 200 OK\r\ncontent-type: text/html; charset=utf-8\r\nContent-Length: 14\r\nConnection: close\r\n\r\n<h1>Salam</h1>"),
        "unexpected response encoding:\n{interp}"
    );
    // RFC 9112 §5.2: repeated fields are joined with ", ".
    assert!(interp.contains("satu, dua\n"), "duplicate join:\n{interp}");
}

/// The TLS acceptance policy (NET_001_03 no-downgrade + NET_001_08 cipher
/// strength) is a pure function of two strings, so both backends compute the
/// whole table and must agree on every cell — including the unparseable inputs,
/// which are `salah` rather than an error.
#[test]
fn tls_policy_table_is_byte_equal_across_backends() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let versions = ["1.0", "1.1", "1.2", "1.3", "TLSv1.3", "TLS1.3", "9.9"];
    let ciphers = [
        "TLS_AES_128_GCM_SHA256",
        "TLS_AES_256_GCM_SHA384",
        "TLS_CHACHA20_POLY1305_SHA256",
        "TLS_RSA_WITH_RC4_128_SHA",
    ];
    let mut body = String::new();
    for v in versions {
        for c in ciphers {
            body.push_str(&format!(
                "    cetakln(ke_teks(tls_dasar_ok((\"{v}\", \"{c}\"))));\n"
            ));
        }
    }
    let src = format!("fungsi utama() -> Nombor kesan Tulis {{\n{body}    0\n}}\n");
    let sb = Sandbox::new("tlspolicy");
    let p = sb.program("tlspolicy", &src);
    let interp = run_interp(&p);
    assert_eq!(interp, run_native(&p), "TLS policy table must agree");

    // The policy is "TLS 1.3 and a representable strong suite" — so exactly the
    // three 1.3 spellings × the three known suites accept, and nothing else.
    let cells: Vec<&str> = interp.lines().collect();
    assert_eq!(cells.len(), versions.len() * ciphers.len());
    for (i, cell) in cells.iter().enumerate() {
        let v = versions[i / ciphers.len()];
        let c = ciphers[i % ciphers.len()];
        let expect = if v.ends_with("1.3") && c.starts_with("TLS_AES") || v.ends_with("1.3") && c.starts_with("TLS_CHACHA") {
            "betul"
        } else {
            "salah"
        };
        assert_eq!(*cell, expect, "policy at ({v}, {c})");
    }
}

// ── the strict parser: both backends must REFUSE ───────────────────────────

/// Messages that must be rejected, and why. Every one is a documented
/// smuggling or injection vector, not a stylistic preference.
const HOSTILE: &[(&str, &str)] = &[
    (
        "cl_and_te",
        "POST / HTTP/1.1\\r\\nHost: a.test\\r\\nContent-Length: 5\\r\\nTransfer-Encoding: chunked\\r\\n\\r\\nhalo!",
    ),
    (
        "conflicting_cl",
        "POST / HTTP/1.1\\r\\nHost: a.test\\r\\nContent-Length: 5\\r\\nContent-Length: 6\\r\\n\\r\\nhalo!",
    ),
    (
        "conflicting_cl_list",
        "POST / HTTP/1.1\\r\\nHost: a.test\\r\\nContent-Length: 5, 6\\r\\n\\r\\nhalo!",
    ),
    (
        "space_before_colon",
        "GET / HTTP/1.1\\r\\nHost: a.test\\r\\nX-Ujian : nilai\\r\\n\\r\\n",
    ),
    ("missing_host", "GET / HTTP/1.1\\r\\n\\r\\n"),
    ("bad_version", "GET / HTTP/2.0\\r\\nHost: a.test\\r\\n\\r\\n"),
    ("bad_method", "G3T / HTTP/1.1\\r\\nHost: a.test\\r\\n\\r\\n"),
    ("no_terminator", "GET / HTTP/1.1\\r\\nHost: a.test\\r\\n"),
    (
        "chunked",
        "POST / HTTP/1.1\\r\\nHost: a.test\\r\\nTransfer-Encoding: chunked\\r\\n\\r\\n0\\r\\n\\r\\n",
    ),
    (
        "truncated_body",
        "POST / HTTP/1.1\\r\\nHost: a.test\\r\\nContent-Length: 99\\r\\n\\r\\npendek",
    ),
    (
        "bad_content_length",
        "POST / HTTP/1.1\\r\\nHost: a.test\\r\\nContent-Length: 0x10\\r\\n\\r\\n",
    ),
];

/// THE security-relevant test for this family. A message that frames two ways
/// must be an error on BOTH backends; a C parser that accepted any of these
/// would silently reintroduce request smuggling into compiled programs while
/// the happy-path differential stayed green.
#[test]
fn strict_parser_refuses_the_same_messages_on_both_backends() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("hostile");
    for (tag, msg) in HOSTILE {
        let src = format!(
            "fungsi utama() -> Nombor kesan Tulis {{\n\
             \x20   cetakln(http_hurai_laluan(\"{msg}\"));\n\
             \x20   0\n}}\n"
        );
        let p = sb.program(tag, &src);

        let interp = riinac().arg("run").arg(&p).output().expect("riinac run");
        assert!(
            !interp.status.success(),
            "interpreter ACCEPTED the {tag} message — it must refuse: {}",
            String::from_utf8_lossy(&interp.stdout)
        );

        let bin = build(&p);
        let native = Command::new(&bin).output().expect("run native");
        assert!(
            !native.status.success(),
            "compiled binary ACCEPTED the {tag} message — the C parser must be \
             exactly as strict, or compiled programs are smuggling-vulnerable \
             while the interpreter is not: {}",
            String::from_utf8_lossy(&native.stdout)
        );
    }
}

// ── the verified RFC 793 machine: both backends must gate ──────────────────

/// Sending after `jaring_tutup` must be refused by the state machine, not by
/// whatever the OS happens to do with a closed descriptor. The entry stays
/// registered in CLOSED precisely so the refusal comes from the model.
#[test]
fn send_after_close_is_refused_by_both_backends() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("closedsend");
    let src = "fungsi utama() -> Nombor kesan (Tulis, Rangkaian) {\n\
               \x20   biar d = jaring_dengar(\"127.0.0.1:0\");\n\
               \x20   biar a = jaring_alamat(d);\n\
               \x20   biar c = jaring_sambung(a);\n\
               \x20   jaring_tutup(c);\n\
               \x20   jaring_hantar((c, \"selepas tutup\"));\n\
               \x20   0\n}\n";
    let p = sb.program("closedsend", src);

    let interp = riinac().arg("run").arg(&p).output().expect("riinac run");
    assert!(
        !interp.status.success(),
        "interpreter allowed a send on a CLOSED connection"
    );
    let bin = build(&p);
    let native = Command::new(&bin).output().expect("run native");
    assert!(
        !native.status.success(),
        "compiled binary allowed a send on a CLOSED connection — the C backend \
         must enforce the same verified machine, or it is weaker than the \
         language it compiles"
    );
}

/// LISTEN --Close--> CLOSED is a real RFC 793 edge; CLOSED has no Close edge,
/// so the second close is refused. Both backends must agree on that asymmetry.
#[test]
fn double_listener_close_is_refused_by_both_backends() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("doubleclose");
    let src = "fungsi utama() -> Nombor kesan (Tulis, Rangkaian) {\n\
               \x20   biar d = jaring_dengar(\"127.0.0.1:0\");\n\
               \x20   jaring_tutup_dengar(d);\n\
               \x20   jaring_tutup_dengar(d);\n\
               \x20   0\n}\n";
    let p = sb.program("doubleclose", src);

    assert!(
        !riinac()
            .arg("run")
            .arg(&p)
            .output()
            .expect("riinac run")
            .status
            .success(),
        "interpreter allowed a double listener close"
    );
    let bin = build(&p);
    assert!(
        !Command::new(&bin)
            .output()
            .expect("run native")
            .status
            .success(),
        "compiled binary allowed a double listener close"
    );
}

/// `jaring_alamat` must render the way Rust's `SocketAddr` Display does, or a
/// program that feeds the address straight back into `jaring_sambung` works on
/// one backend and not the other. The port is ephemeral, so the SHAPE is what
/// is compared — and it is compared by actually reconnecting to it.
#[test]
fn listener_address_round_trips_on_both_backends() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("addr");
    let src = "fungsi utama() -> Nombor kesan (Tulis, Rangkaian) {\n\
               \x20   biar d = jaring_dengar(\"127.0.0.1:0\");\n\
               \x20   biar a = jaring_alamat(d);\n\
               \x20   biar c = jaring_sambung(a);\n\
               \x20   biar s = jaring_terima_sambungan(d);\n\
               \x20   jaring_hantar((c, \"ping\"));\n\
               \x20   cetakln(jaring_terima((s, 16)));\n\
               \x20   jaring_tutup(c);\n\
               \x20   jaring_tutup(s);\n\
               \x20   jaring_tutup_dengar(d);\n\
               \x20   0\n}\n";
    let p = sb.program("addr", src);
    assert_eq!(run_interp(&p), "ping\n");
    assert_eq!(run_native(&p), "ping\n");
}

// ── the load-bearing tests: the backends talk to EACH OTHER ────────────────

/// Start a server child and read the address it announces on its first stdout
/// line. Requires that line to be flushed as it is written — which the C
/// backend only does because `cetak`/`cetakln` call `fflush(stdout)`; C's
/// stdout is block-buffered off a tty, so without it a compiled service that
/// prints and then blocks on accept announces nothing at all.
fn start_server(mut cmd: Command) -> (Child, String) {
    let mut child = cmd
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("spawn server");
    let stdout = child.stdout.take().expect("piped stdout");
    let mut reader = BufReader::new(stdout);
    let mut line = String::new();
    reader.read_line(&mut line).expect("read address line");
    let addr = line.trim().to_string();
    assert!(
        addr.contains(':'),
        "server did not announce an address (got {addr:?}) — if this is the \
         compiled server, stdout was not flushed"
    );
    // Put the reader back so the child's remaining output is not lost to a
    // closed pipe (the server writes nothing more, but a SIGPIPE would abort it).
    child.stdout = Some(reader.into_inner());
    (child, addr)
}

/// A server that reads one request, parses it with its own codec, and answers
/// with `<method> <target>` in the body.
const SERVER_SRC: &str = "fungsi utama() -> Nombor kesan (Tulis, Rangkaian) {\n\
    \x20   biar d = jaring_dengar(\"127.0.0.1:0\");\n\
    \x20   cetakln(jaring_alamat(d));\n\
    \x20   biar c = jaring_terima_sambungan(d);\n\
    \x20   biar r = jaring_terima((c, 4096));\n\
    \x20   biar badan = gabung_teks((gabung_teks((http_hurai_kaedah(r), \" \")), http_hurai_laluan(r)));\n\
    \x20   jaring_hantar((c, http_balas((200, badan))));\n\
    \x20   jaring_tutup(c);\n\
    \x20   jaring_tutup_dengar(d);\n\
    \x20   0\n}\n";

/// The exact bytes the server must put on the wire for the request below. Both
/// directions of the pairing are compared against this literal, so the test
/// cannot pass by both backends being wrong together.
const EXPECTED_RESPONSE: &str = "HTTP/1.1 200 OK\r\n\
     content-type: text/html; charset=utf-8\r\n\
     Content-Length: 13\r\n\
     Connection: close\r\n\
     \r\n\
     GET /halo?a=1";

fn client_src(addr: &str) -> String {
    format!(
        "fungsi utama() -> Nombor kesan (Tulis, Rangkaian) {{\n\
         \x20   biar c = jaring_sambung(\"{addr}\");\n\
         \x20   jaring_hantar((c, \"GET /halo?a=1 HTTP/1.1\\r\\nHost: a.test\\r\\n\\r\\n\"));\n\
         \x20   cetakln(jaring_terima((c, 4096)));\n\
         \x20   jaring_tutup(c);\n\
         \x20   0\n}}\n"
    )
}

/// THE test for this family, half one: a COMPILED server parses a request from
/// an INTERPRETED client and frames a response the interpreter reads back
/// byte-for-byte. Nothing short of two live processes checks this.
#[test]
fn interpreted_client_talks_to_compiled_server() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("i2c");
    let server = sb.program("server", SERVER_SRC);
    let bin = build(&server);

    let (mut child, addr) = start_server(Command::new(&bin));
    let client = sb.program("client_i", &client_src(&addr));
    let got = run_interp(&client);
    let status = child.wait().expect("server exit");
    assert!(status.success(), "compiled server exited {status:?}");
    assert_eq!(got, format!("{EXPECTED_RESPONSE}\n"));
}

/// Half two: an INTERPRETED server against a COMPILED client. Together with
/// the test above this pins both framing directions — a codec that encoded
/// correctly but parsed loosely would pass one and fail the other.
#[test]
fn compiled_client_talks_to_interpreted_server() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("c2i");
    let server = sb.program("server", SERVER_SRC);
    let mut cmd = riinac();
    cmd.arg("run").arg(&server);
    let (mut child, addr) = start_server(cmd);

    let client = sb.program("client_c", &client_src(&addr));
    let got = run_native(&client);
    let status = child.wait().expect("server exit");
    assert!(status.success(), "interpreted server exited {status:?}");
    assert_eq!(got, format!("{EXPECTED_RESPONSE}\n"));
}

// ── what must NOT compile ──────────────────────────────────────────────────

/// The `jaring_tls_*` half is interpreter-only ON PURPOSE. `riinac emit-c`
/// must refuse it rather than lower something weaker — a compiled program that
/// appeared to negotiate TLS while doing less than `riina-tls` is the worst
/// available outcome, strictly worse than a build error (REQ-78).
///
/// The refusal is checked here end-to-end; that it comes from *lowering*
/// specifically (rather than from the capability checker, which also rejects
/// these programs) is pinned precisely by `net_tls_half_is_not_routed` in
/// `riina-codegen`, which asks `codegen_supports_builtin` directly.
#[test]
fn tls_builtins_fail_closed_when_compiled() {
    let sb = Sandbox::new("tlsclosed");
    for name in [
        "jaring_tls_jabat",
        "jaring_tls_jabat_sah",
        "jaring_tls_kunci",
        "jaring_tls_hantar",
        "jaring_tls_terima",
        "jaring_tls_identiti",
        "jaring_tls_percaya",
        "jaring_tls_disahkan",
    ] {
        let src = format!(
            "fungsi utama() -> Nombor kesan (Tulis, Rangkaian) {{\n\
             \x20   biar d = jaring_dengar(\"127.0.0.1:0\");\n\
             \x20   biar c = jaring_sambung(jaring_alamat(d));\n\
             \x20   cetakln(ke_teks({name}(c)));\n\
             \x20   0\n}}\n"
        );
        let p = sb.program(name, &src);
        let out = riinac()
            .arg("emit-c")
            .arg(&p)
            .output()
            .expect("riinac emit-c");
        assert!(
            !out.status.success(),
            "{name} lowered to C — it must fail closed until the crypto is \
             really ported, not emit a weaker handshake"
        );
    }
}

/// WASI preview 1 has no listening sockets, so the whole family is
/// `native-only`. `--target wasm32` must say so rather than emit a stub that
/// returns a plausible wrong value (REQ-78).
#[test]
fn net_family_fails_closed_on_wasm() {
    let sb = Sandbox::new("wasmclosed");
    let src = "fungsi utama() -> Nombor kesan (Tulis, Rangkaian) {\n\
               \x20   biar d = jaring_dengar(\"127.0.0.1:0\");\n\
               \x20   cetakln(jaring_alamat(d));\n\
               \x20   0\n}\n";
    let p = sb.program("wasmclosed", src);
    let out = riinac()
        .arg("build")
        .arg("--target")
        .arg("wasm32")
        .arg(&p)
        .output()
        .expect("riinac build --target wasm32");
    assert!(
        !out.status.success(),
        "the WASM backend must refuse jaring_* rather than stub it"
    );
}
