// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter vs C vs WASM on the miscompilations found by the 2026-10
//! compiler audit. Each case also pins the absolute expected output, because
//! two backends can agree and both be wrong.
//!
//! * String literals: the C backend escaped control bytes as `\xNN`, which C
//!   reads greedily — `"A\x00B|"` is `A`, 0x0B, `|` — and `\x01abc` did not
//!   compile. Now fixed-width octal; a literal containing NUL is a compile
//!   error for C (its runtime strings are NUL-terminated throughout).
//! * Secret booleans: `kalau`/`selagi` on a `sulit` boolean failed in the
//!   interpreter and, in C, tested the wrapper's pointer bits — both
//!   branches of `kalau sulit betul` / `kalau sulit salah` were the same.
//! * Signed division: `i64::MIN / -1` was SIGFPE in C and a trap in WASM
//!   (the interpreter wraps), `i64::MIN % -1` SIGFPE in C; and WASM printed
//!   every negative `i64` as its unsigned bit pattern.
//! * Unicode: C indexed `teks_sub`/`teks_aksara_di` by bytes (splitting
//!   UTF-8 sequences) and case-mapped ASCII only.
//! * Allocation: the C runtime's bigint helpers used `malloc` unchecked.

use std::path::PathBuf;
use std::process::Command;

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// A missing backend tool fails the test unless the skip is requested
/// deliberately (`RIINA_ALLOW_MISSING_BACKEND_TOOLS=1`), as in the other
/// differential suites — a test that cannot run must never report `ok`.
fn require_backend_tools(tools: &[&str]) -> bool {
    let missing: Vec<&str> = tools.iter().copied().filter(|t| !tool_available(t)).collect();
    if missing.is_empty() {
        return true;
    }
    if std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_ok() {
        eprintln!("!!! SKIPPED (tools missing: {}) — backend NOT verified.", missing.join(", "));
        return false;
    }
    panic!(
        "required backend tool(s) missing: {}; set RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to \
         skip deliberately",
        missing.join(", ")
    );
}

struct Sandbox {
    dir: PathBuf,
    stem: String,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let stem = format!("audit_{tag}");
        let dir = std::env::temp_dir().join(format!("riina_{stem}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self { dir, stem }
    }

    fn src(&self, source: &str) -> PathBuf {
        let p = self.dir.join(format!("{}.rii", self.stem));
        std::fs::write(&p, source).expect("write program");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

/// Interpreter stdout without the trailing echo of the program's value.
fn run_interp(src: &PathBuf) -> Vec<u8> {
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(src)
        .output()
        .expect("riinac run");
    assert!(
        out.status.success(),
        "interpreter failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let mut s = out.stdout;
    // Drop the final echoed value line ("Unit\n").
    assert!(s.ends_with(b"Unit\n"), "{:?}", String::from_utf8_lossy(&s));
    s.truncate(s.len() - b"Unit\n".len());
    s
}

fn run_native(sb: &Sandbox, src: &PathBuf) -> Vec<u8> {
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "native build failed: {}",
        String::from_utf8_lossy(&build.stderr)
    );
    let run = Command::new(sb.dir.join(&sb.stem)).output().expect("run native binary");
    assert!(
        run.status.success(),
        "native binary failed (exit {:?}, None = signal): {}",
        run.status.code(),
        String::from_utf8_lossy(&run.stderr)
    );
    run.stdout
}

fn run_wasm(sb: &Sandbox, src: &PathBuf) -> Vec<u8> {
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "--target", "wasm32"])
        .arg(src)
        .output()
        .expect("riinac build --target wasm32");
    assert!(
        build.status.success(),
        "wasm build failed: {}",
        String::from_utf8_lossy(&build.stderr)
    );
    let run = Command::new("wasmtime")
        .arg("run")
        .arg(sb.dir.join(format!("{}.wasm", sb.stem)))
        .output()
        .expect("wasmtime run");
    assert!(
        run.status.success(),
        "wasmtime trapped or rejected the module (exit {:?}): {}",
        run.status.code(),
        String::from_utf8_lossy(&run.stderr)
    );
    run.stdout
}

/// Run on every backend that implements the program and compare to `expected`.
fn assert_all_backends(tag: &str, source: &str, expected: &[u8], wasm: bool) {
    let sb = Sandbox::new(tag);
    let src = sb.src(source);
    let show = |b: &[u8]| String::from_utf8_lossy(b).into_owned();
    let interp = run_interp(&src);
    assert_eq!(show(&interp), show(expected), "{tag}: interpreter");
    assert_eq!(interp, expected, "{tag}: interpreter bytes");
    if require_backend_tools(&["cc"]) {
        let c = run_native(&sb, &src);
        assert_eq!(show(&c), show(expected), "{tag}: C backend");
        assert_eq!(c, expected, "{tag}: C backend bytes");
    }
    if wasm && require_backend_tools(&["wasmtime"]) {
        let w = run_wasm(&sb, &src);
        assert_eq!(show(&w), show(expected), "{tag}: WASM backend");
        assert_eq!(w, expected, "{tag}: WASM backend bytes");
    }
}

/// `s` as the body of a RIINA string literal: `"` and `\` escaped, every
/// other character (control bytes included) written raw.
fn riina_literal_body(s: &str) -> String {
    s.replace('\\', "\\\\").replace('"', "\\\"")
}

#[test]
fn string_literals_survive_c_escaping() {
    // Every byte class the C escaper must handle, and the greedy-escape
    // hazards: a control byte followed by hex/octal digit characters.
    let mut tricky: Vec<String> = vec![
        "\"quoted\"".into(),
        "back\\slash\\".into(),
        "*/ /* // */".into(),
        "??= ??/ ??( ??) ??' ??< ??> ??! ??-".into(),
        "new\nline\ttab\rcr".into(),
        "é € 𝄞 ﬀ".into(),
        "\u{1}abc".into(),
        "\u{1}7".into(),
        "\u{1f}99".into(),
        "\u{7f}F".into(),
        "A\u{b}B|".into(),
    ];
    let controls: String = (1u8..0x20)
        .chain(std::iter::once(0x7f))
        .map(char::from)
        .collect();
    tricky.push(controls);

    let mut src = String::from("fungsi utama() -> Kosong kesan Tulis {\n");
    let mut expected = Vec::new();
    for s in &tricky {
        src.push_str(&format!("    cetakln(\"{}\");\n", riina_literal_body(s)));
        expected.extend_from_slice(s.as_bytes());
        expected.push(b'\n');
    }
    src.push_str("}\n");
    assert_all_backends("literals", &src, &expected, true);
}

#[test]
fn a_nul_in_a_literal_is_a_c_compile_error_not_a_truncation() {
    let src = "fungsi utama() -> Kosong kesan Tulis {\n    cetakln(\"A\\0B|\");\n}\n";
    let sb = Sandbox::new("nul");
    let path = sb.src(src);
    // The interpreter (and WASM, whose strings are length-prefixed) keep it.
    assert_eq!(run_interp(&path), b"A\0B|\n");
    if require_backend_tools(&["wasmtime"]) {
        assert_eq!(run_wasm(&sb, &path), b"A\0B|\n");
    }
    // C refuses, clearly, at compile time.
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(&path)
        .output()
        .expect("riinac build");
    assert!(!build.status.success(), "a NUL literal must not compile for C");
    let err = String::from_utf8_lossy(&build.stderr);
    assert!(err.contains("NUL"), "the error must say why: {err}");
    assert!(!sb.dir.join(&sb.stem).exists(), "no binary may be produced");
}

/// What a branch on a SECRET boolean does, on every backend.
///
/// Built as a syntax tree and fed straight to the backends: by
/// noninterference a well-typed program's output cannot depend on a secret
/// condition, so a source-level test would have to lean on whatever implicit
/// flows the typechecker happens to admit (the audit's reproducer did). The
/// backends must agree regardless of what the typechecker admits.
#[test]
fn branching_on_a_secret_boolean_agrees() {
    use riina_types::Expr;
    let secret = |b| Box::new(Expr::Classify(Box::new(Expr::Bool(b))));
    let pick = |b| Expr::If(secret(b), Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
    let print = |e: Expr| {
        Expr::App(
            Box::new(Expr::Var("cetakln".into())),
            Box::new(Expr::App(Box::new(Expr::Var("ke_teks".into())), Box::new(e))),
        )
    };
    let seq = |a: Expr, b: Expr| Expr::Let("_".into(), None, Box::new(a), Box::new(b));
    // A loop on a secret condition that is false must not run (C used to
    // read the wrapper's pointer as `true` and spin forever).
    let looped = Expr::While(secret(false), Box::new(Expr::Unit));
    let program = seq(
        print(pick(true)),
        seq(print(pick(false)), seq(looped, print(Expr::Int(3)))),
    );

    // Interpreter: the branch values themselves.
    assert_eq!(
        riina_codegen::eval_with_builtins(&pick(true)).expect("interp"),
        riina_codegen::Value::Int(1)
    );
    assert_eq!(
        riina_codegen::eval_with_builtins(&pick(false)).expect("interp"),
        riina_codegen::Value::Int(2)
    );
    let ir = riina_codegen::compile(&program).expect("lower");
    let sb = Sandbox::new("secret_branch");
    let expected = "1\n2\n3\n";

    if require_backend_tools(&["cc"]) {
        let out = riina_codegen::backend_for_target(riina_codegen::Target::Native)
            .emit(&ir)
            .expect("emit C");
        let c = sb.dir.join("p.c");
        std::fs::write(&c, &out.primary).unwrap();
        let bin = sb.dir.join("p");
        let cc = Command::new("cc").arg("-o").arg(&bin).arg(&c).output().expect("cc");
        assert!(cc.status.success(), "{}", String::from_utf8_lossy(&cc.stderr));
        let run = run_with_timeout(Command::new(&bin));
        assert_eq!(run, expected, "C backend");
    }
    if require_backend_tools(&["wasmtime"]) {
        let out = riina_codegen::backend_for_target(riina_codegen::Target::Wasm32)
            .emit(&ir)
            .expect("emit WASM");
        let w = sb.dir.join("p.wasm");
        std::fs::write(&w, &out.primary).unwrap();
        let mut cmd = Command::new("wasmtime");
        cmd.arg("run").arg(&w);
        assert_eq!(run_with_timeout(cmd), expected, "WASM backend");
    }
}

/// Run to completion within 30 s (a wrongly-taken secret loop spins forever).
fn run_with_timeout(mut cmd: Command) -> String {
    use std::io::Read;
    let mut child = cmd
        .stdout(std::process::Stdio::piped())
        .spawn()
        .expect("spawn");
    let start = std::time::Instant::now();
    loop {
        if let Some(status) = child.try_wait().expect("wait") {
            assert!(status.success(), "exit {:?}", status.code());
            break;
        }
        if start.elapsed() > std::time::Duration::from_secs(30) {
            let _ = child.kill();
            panic!("program did not terminate (secret loop condition misread)");
        }
        std::thread::sleep(std::time::Duration::from_millis(20));
    }
    let mut s = String::new();
    child.stdout.take().unwrap().read_to_string(&mut s).unwrap();
    s
}

#[test]
fn signed_division_overflow_is_defined_and_agrees() {
    // Semantics: truncated division of the signed (two's-complement)
    // interpretation, wrapped to the width — SizedInt.v `toSigned`/`wrapU`,
    // the interpreter's `wrapping_div`/`wrapping_rem`. MIN / -1 = MIN,
    // MIN % -1 = 0, at every width.
    let src = r#"
fungsi utama() -> Kosong kesan Tulis {
    biar m8 = 0i8 - 127i8 - 1i8;
    biar m16 = 0i16 - 32767i16 - 1i16;
    biar m32 = 0i32 - 2147483647i32 - 1i32;
    biar m64 = 0i64 - 9223372036854775807i64 - 1i64;
    cetakln(m8 / (0i8 - 1i8));
    cetakln(m8 % (0i8 - 1i8));
    cetakln(m16 / (0i16 - 1i16));
    cetakln(m16 % (0i16 - 1i16));
    cetakln(m32 / (0i32 - 1i32));
    cetakln(m32 % (0i32 - 1i32));
    cetakln(m64 / (0i64 - 1i64));
    cetakln(m64 % (0i64 - 1i64));
    cetakln((0i64 - 7i64) / (0i64 - 1i64));
    cetakln(7i64 % (0i64 - 1i64));
    cetakln(m64 / 2i64);
    cetakln(m64 % 3i64);
    cetakln(0i64 - 5i64);
    cetakln(ke_teks(m64 / (0i64 - 1i64)));
}
"#;
    let expected = "-128\n0\n-32768\n0\n-2147483648\n0\n-9223372036854775808\n0\n7\n0\n\
                    -4611686018427387904\n-2\n-5\n-9223372036854775808\n";
    assert_all_backends("signed_div", src, expected.as_bytes(), true);
}

#[test]
fn unicode_string_builtins_agree() {
    // Scalar-value indexing and full Unicode case mapping (Rust
    // `str::to_uppercase`/`to_lowercase`, including the final-sigma rule —
    // the interpreter's definition, documented in VerifiedString.v). WASM
    // refuses these builtins outright (REQ-78), so C is compared to the
    // interpreter.
    let mut src = String::from(
        r#"fungsi utama() -> Kosong kesan Tulis {
    cetakln(teks_sub(("€uro", (0, 1))));
    cetakln(teks_sub(("héllo€", (1, 3))));
    cetakln(teks_sub(("a𝄞b", (1, 2))));
    cetakln(teks_sub(("abc", (2, 10))));
    cetakln(teks_sub(("abc", (5, 1))));
    cetakln(teks_aksara_di(("€uro", 0)));
    cetakln(teks_aksara_di(("a𝄞b", 2)));
"#,
    );
    let mut expected = String::from("€\nél\n𝄞\nc\n\n€\nb\n");
    // Case mapping: the expectation IS Rust's own function — the
    // interpreter's definition — so the test cannot drift from it.
    for s in ["ßé", "ﬀ ǆ ǅ ŉ ΐ straße", "hello, world"] {
        src.push_str(&format!("    cetakln(teks_huruf_besar(\"{s}\"));\n"));
        expected.push_str(&format!("{}\n", s.to_uppercase()));
    }
    for s in ["ÉÀ İ ΣΑΣ ΣΑΣ. ὈΔΥΣΣΕΎΣ Σ ΑΣ'Σ", "ǅ Ⅻ Ⓐ", "Σ\u{301}Α ΑΣ\u{301}"] {
        src.push_str(&format!("    cetakln(teks_huruf_kecil(\"{s}\"));\n"));
        expected.push_str(&format!("{}\n", s.to_lowercase()));
    }
    src.push_str("}\n");
    // The audit's literal findings, and the context-sensitive final sigma.
    assert!(expected.contains("\nSSÉ\n"), "{expected}");
    assert!(expected.contains("σας σας. ὀδυσσεύς σ ασ'ς"), "{expected}");
    assert_all_backends("unicode", &src, expected.as_bytes(), false);
}

#[test]
fn every_c_runtime_allocation_is_checked() {
    // Pull in the conditional runtimes too (bigint, case mapping, NFC). The
    // bigint operands are `besar("…")`: a bare `99999999999999999999999` has no
    // 64-bit value, and until REQ-97's literal fix it silently became `0`.
    let src = r#"
fungsi utama() -> Kosong kesan Tulis {
    cetakln(ke_teks(besar("99999999999999999999999") * besar("99999999999999999999999")));
    cetakln(teks_huruf_besar("a"));
    cetakln(nfc("é"));
}
"#;
    let sb = Sandbox::new("alloc");
    let path = sb.src(src);
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("emit-c")
        .arg(&path)
        .output()
        .expect("riinac emit-c");
    assert!(out.status.success(), "{}", String::from_utf8_lossy(&out.stderr));
    let c = String::from_utf8_lossy(&out.stdout);
    assert!(c.contains("riina_bigint"), "bigint runtime present");
    assert!(c.contains("riina_case_upper"), "case runtime present");

    let lines: Vec<&str> = c.lines().collect();
    let mut unchecked = Vec::new();
    for (i, line) in lines.iter().enumerate() {
        for f in ["malloc(", "calloc(", "realloc(", "strdup("] {
            let mut rest = *line;
            while let Some(at) = rest.find(f) {
                let before = &rest[..at];
                let preceded_by_ident = before
                    .chars()
                    .last()
                    .is_some_and(|ch| ch.is_ascii_alphanumeric() || ch == '_');
                if !preceded_by_ident {
                    // A raw call: only the checked wrappers themselves, or a
                    // call whose result is NULL-checked on the same/next line.
                    let in_wrapper = line.contains("void* p = ");
                    let checked = line.contains("if (!")
                        || lines.get(i + 1).is_some_and(|n| n.contains("if (!"));
                    if !in_wrapper && !checked {
                        unchecked.push(format!("{}: {}", i + 1, line.trim()));
                    }
                }
                rest = &rest[at + f.len()..];
            }
        }
    }
    assert!(
        unchecked.is_empty(),
        "unchecked allocations in the emitted C runtime:\n{}",
        unchecked.join("\n")
    );
}
