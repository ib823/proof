// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The real `riinac` binary on truncated and on long, flat input.
//!
//! # Hangs (truncated input)
//!
//! The lexer yields `Eof` forever, and three parser loops skipped tokens until
//! a `;`/`}` or `None` — never `Eof`. `jenis t=`, `guna std::teks` without a
//! `;`, and an unclosed `modul m {` therefore spun at 100% CPU in `check`,
//! `fmt`, the LSP (a `didOpen` was never answered) and MCP.
//!
//! # Stack overflows (long flat input)
//!
//! Flat source becomes a deep tree — n statements are an n-deep `Let` chain,
//! `1 + 1 + …` an n-deep `BinOp` chain — and the parser, typechecker,
//! interpreter, lowering and formatter all recursed over it. 2,000 `biar`
//! lines or a 2,000-term sum aborted with "has overflowed its stack" even in
//! a release build; a debug build died at 100 nested parentheses. The driver
//! now runs on a large dedicated stack, the parser and interpreter iterate
//! over flat chains, and a program past `MAX_AST_DEPTH` gets a clean error.
//!
//! Everything runs through the binary in a subprocess with a wall-clock
//! limit: a stack overflow is then an observed failure (a signal) and a hang
//! a timeout — neither can take down the test runner itself.

use std::io::{BufRead, BufReader, Read, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::sync::mpsc;
use std::time::{Duration, Instant};

struct Sandbox {
    dir: PathBuf,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let dir = std::env::temp_dir().join(format!(
            "riina_flat_input_{tag}_{}",
            std::process::id()
        ));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self { dir }
    }

    fn file(&self, name: &str, source: &str) -> PathBuf {
        let p = self.dir.join(name);
        std::fs::write(&p, source).expect("write program");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

struct Run {
    code: Option<i32>,
    stdout: String,
    stderr: String,
}

/// Run `riinac <args>` with a wall-clock `limit`. A process still running at
/// the limit is killed and the test fails as a HANG; one killed by a signal
/// (stack overflow → SIGABRT/SIGSEGV) is reported by `expect_*` below.
fn riinac(args: &[&str], cwd: &Path, limit: Duration) -> Run {
    let mut child = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(args)
        .current_dir(cwd)
        .stdin(Stdio::null())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("spawn riinac");
    let mut out = child.stdout.take().expect("stdout");
    let mut err = child.stderr.take().expect("stderr");
    let out_reader = std::thread::spawn(move || {
        let mut s = Vec::new();
        let _ = out.read_to_end(&mut s);
        s
    });
    let err_reader = std::thread::spawn(move || {
        let mut s = Vec::new();
        let _ = err.read_to_end(&mut s);
        s
    });
    let start = Instant::now();
    let status = loop {
        if let Some(status) = child.try_wait().expect("wait") {
            break status;
        }
        if start.elapsed() > limit {
            let _ = child.kill();
            let _ = child.wait();
            panic!("`riinac {}` did not finish within {limit:?} (hang)", args.join(" "));
        }
        std::thread::sleep(Duration::from_millis(20));
    };
    Run {
        code: status.code(),
        stdout: String::from_utf8_lossy(&out_reader.join().unwrap()).into_owned(),
        stderr: String::from_utf8_lossy(&err_reader.join().unwrap()).into_owned(),
    }
}

fn expect_success(run: &Run, what: &str) {
    assert_eq!(
        run.code,
        Some(0),
        "{what}: expected success, got exit {:?} (None = killed by a signal, e.g. a \
         stack overflow)\nstderr: {}",
        run.code,
        run.stderr.chars().take(2000).collect::<String>()
    );
}

fn expect_clean_error(run: &Run, what: &str) {
    assert_eq!(
        run.code,
        Some(1),
        "{what}: expected a clean error (exit 1), got exit {:?} (None = killed by a \
         signal)\nstderr: {}",
        run.code,
        run.stderr.chars().take(2000).collect::<String>()
    );
}

const QUICK: Duration = Duration::from_secs(30);

#[test]
fn truncated_input_is_an_error_not_a_hang() {
    let sb = Sandbox::new("trunc");
    for (i, src) in [
        "jenis t=",
        "jenis T = ",
        "guna std::teks",
        "modul m {",
        "modul m { fungsi f() -> Nombor kesan Bersih { 1 }",
    ]
    .iter()
    .enumerate()
    {
        let f = sb.file(&format!("t{i}.rii"), src);
        let f = f.to_str().unwrap();
        for cmd in ["check", "fmt", "doc"] {
            let run = riinac(&[cmd, f], &sb.dir, QUICK);
            expect_clean_error(&run, &format!("riinac {cmd} on {src:?}"));
        }
    }
}

/// Frame `msg` as an LSP/JSON-RPC message.
fn lsp_frame(msg: &str) -> String {
    format!("Content-Length: {}\r\n\r\n{msg}", msg.len())
}

/// The LSP answers a `didOpen` of the audit's hanging document with
/// diagnostics instead of spinning forever.
#[test]
fn lsp_publishes_diagnostics_for_truncated_documents() {
    let mut child = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("lsp")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::null())
        .spawn()
        .expect("spawn riinac lsp");
    let mut stdin = child.stdin.take().expect("stdin");
    let stdout = child.stdout.take().expect("stdout");
    let (tx, rx) = mpsc::channel();
    std::thread::spawn(move || {
        let mut reader = BufReader::new(stdout);
        loop {
            let mut len = 0usize;
            loop {
                let mut line = String::new();
                if reader.read_line(&mut line).unwrap_or(0) == 0 {
                    return;
                }
                let line = line.trim();
                if line.is_empty() {
                    break;
                }
                if let Some(n) = line.strip_prefix("Content-Length: ") {
                    len = n.parse().unwrap_or(0);
                }
            }
            let mut body = vec![0u8; len];
            if reader.read_exact(&mut body).is_err() {
                return;
            }
            if tx.send(String::from_utf8_lossy(&body).into_owned()).is_err() {
                return;
            }
        }
    });

    let send = |stdin: &mut std::process::ChildStdin, msg: &str| {
        stdin.write_all(lsp_frame(msg).as_bytes()).expect("write to lsp");
        stdin.flush().expect("flush");
    };
    send(
        &mut stdin,
        r#"{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}"#,
    );
    for (i, text) in ["jenis T =", "guna std::teks", "modul m {"].iter().enumerate() {
        let uri = format!("file:///t{i}.rii");
        send(
            &mut stdin,
            &format!(
                r#"{{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{{"textDocument":{{"uri":"{uri}","languageId":"riina","version":1,"text":"{text}"}}}}}}"#
            ),
        );
        let deadline = Instant::now() + QUICK;
        loop {
            let left = deadline.saturating_duration_since(Instant::now());
            let msg = rx.recv_timeout(left).unwrap_or_else(|_| {
                let _ = child.kill();
                panic!("LSP never answered didOpen of {text:?} (hang)")
            });
            if msg.contains("publishDiagnostics") && msg.contains(&uri) {
                assert!(msg.contains("\"severity\""), "expected a diagnostic: {msg}");
                break;
            }
        }
    }
    send(&mut stdin, r#"{"jsonrpc":"2.0","id":2,"method":"shutdown"}"#);
    send(&mut stdin, r#"{"jsonrpc":"2.0","method":"exit"}"#);
    drop(stdin);
    let start = Instant::now();
    while child.try_wait().expect("wait").is_none() {
        if start.elapsed() > QUICK {
            let _ = child.kill();
            panic!("LSP did not exit");
        }
        std::thread::sleep(Duration::from_millis(20));
    }
}

/// The audit's sizes and beyond: a 10,000-term sum and 5,000 sequential
/// `biar` statements through `check`, `run`, `fmt` (and, for the sum,
/// `emit-c` + a native build — lowering used to be EXPONENTIAL in the length
/// of an operator chain, so 25 terms took seconds and 40 hours).
///
/// One test, run sequentially: the 5,000-binding program costs the
/// typechecker ~3 GB (its context is cloned per binding — quadratic, and
/// outside this suite's scope), and two of those at once would be needless.
#[test]
fn long_flat_programs_check_run_and_format() {
    let sb = Sandbox::new("long");
    let slow = Duration::from_secs(600);

    let sum = sb.file(
        "jumlah.rii",
        &format!(
            "fungsi utama() -> Kosong kesan Tulis {{\n    cetakln(ke_teks({}));\n}}\n",
            vec!["1"; 10_000].join(" + ")
        ),
    );
    let mut biar = String::from("fungsi utama() -> Kosong kesan Tulis {\n    biar x0 = 0;\n");
    for i in 1..5_000 {
        biar.push_str(&format!("    biar x{i} = x{} + 1;\n", i - 1));
    }
    biar.push_str("    cetakln(ke_teks(x4999));\n}\n");
    let lets = sb.file("biar.rii", &biar);

    for (file, value) in [(&sum, "10000"), (&lets, "4999")] {
        let f = file.to_str().unwrap();
        expect_success(&riinac(&["check", f], &sb.dir, slow), &format!("check {f}"));
        let run = riinac(&["run", f], &sb.dir, slow);
        expect_success(&run, &format!("run {f}"));
        assert_eq!(run.stdout.lines().next(), Some(value), "run {f}");
        let fmt = riinac(&["fmt", f], &sb.dir, slow);
        expect_success(&fmt, &format!("fmt {f}"));
        assert!(fmt.stdout.contains("cetakln"), "fmt {f} printed the program");
    }

    let f = sum.to_str().unwrap();
    let start = Instant::now();
    let emit = riinac(&["emit-c", f], &sb.dir, slow);
    expect_success(&emit, "emit-c of the 10,000-term sum");
    assert!(
        start.elapsed() < Duration::from_secs(120),
        "emit-c took {:?}: lowering is no longer linear",
        start.elapsed()
    );
    if Command::new("cc").arg("--version").output().is_ok() {
        let built = riinac(&["build", f, "--run"], &sb.dir, slow);
        expect_success(&built, "build --run of the 10,000-term sum");
        assert!(built.stdout.contains("10000"), "native output: {}", built.stdout);
    } else if std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_err() {
        panic!("`cc` is required for the native half of this test");
    }
}

/// Past the depth limit the answer is a clean, coded parse error — never a
/// crash — for statements, operator chains and declarations alike.
#[test]
fn pathologically_deep_programs_fail_cleanly() {
    let sb = Sandbox::new("deep");
    let n = 30_000;
    let cases = [
        (
            "stmts.rii",
            format!(
                "fungsi utama() -> Nombor kesan Bersih {{ {}0 }}",
                "biar x = 1; ".repeat(n)
            ),
        ),
        (
            "sum.rii",
            format!(
                "fungsi utama() -> Nombor kesan Bersih {{ {} }}",
                vec!["1"; n].join(" + ")
            ),
        ),
        (
            "decls.rii",
            "fungsi g() -> Nombor kesan Bersih { 0 }\n".repeat(n),
        ),
    ];
    for (name, src) in cases {
        let f = sb.file(name, &src);
        let f = f.to_str().unwrap();
        for cmd in ["check", "run", "fmt"] {
            let run = riinac(&[cmd, f], &sb.dir, Duration::from_secs(300));
            expect_clean_error(&run, &format!("riinac {cmd} {name}"));
            assert!(
                run.stderr.contains("too deeply nested"),
                "{cmd} {name}: {}",
                run.stderr.chars().take(500).collect::<String>()
            );
        }
        let json = riinac(&["check", "--json", f], &sb.dir, Duration::from_secs(300));
        assert!(json.stdout.contains("\"code\":\"P0014\""), "{}", json.stdout);
    }
}

/// A debug build overflowed its 8 MiB main-thread stack on 100 nested
/// parentheses (the typechecker's unoptimised frames are ~90 KiB each).
#[test]
fn nesting_at_the_parser_limit_type_checks() {
    let sb = Sandbox::new("parens");
    let f = sb.file(
        "p.rii",
        &format!(
            "fungsi utama() -> Nombor kesan Bersih {{ {}1{} }}",
            "(".repeat(95),
            ")".repeat(95)
        ),
    );
    let run = riinac(&["run", f.to_str().unwrap()], &sb.dir, QUICK);
    expect_success(&run, "run with 95 nested parentheses");
}
