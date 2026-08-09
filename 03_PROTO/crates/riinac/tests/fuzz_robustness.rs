//! Fuzz-robustness harness for the untrusted-input pipeline (REQ-30).
//!
//! The lexer and parser are the surface that touches arbitrary user/agent input
//! (`riinac check --stdin`). The invariant under test: **they never panic and
//! never crash** on *any* input — they return `Ok` or a `ParseError`/`LexError`,
//! nothing else.
//!
//! Extended 2026-06-12 past the front end: every input that PARSES is driven
//! through `riina_typechecker::check_program` (the exact entry `riinac check`
//! uses) in-process, and every input that TYPECHECKS is then interpreted by
//! running the real `riinac run` binary in a KILLABLE SUBPROCESS with a CPU/
//! address-space rlimit. The subprocess isolation is load-bearing twice over:
//! a *well-typed* mutated program may legitimately not terminate or allocate
//! without bound (loops are a language feature — an in-process/in-thread eval
//! stage OOM-killed the whole test run), and a subprocess also surfaces
//! crashes `catch_unwind` cannot see (SIGSEGV/SIGABRT). Invariants: the
//! frontend always terminates and never panics; the interpreter never
//! panics/crashes — a killed-on-timeout or rlimit-killed run of a well-typed
//! program is a skip, a panic (exit 101) or crash signal is a failure.
//!
//! This is a stable-Rust, dependency-free harness (a hand-rolled XorShift PRNG,
//! matching the repo's existing differential tests), so it runs under the pinned
//! 1.94.1 toolchain in plain `cargo test` / CI — unlike `cargo-fuzz`/libFuzzer,
//! which require nightly.
//!
//! **Continuous fuzz (REQ-30).** The randomized passes take their iteration
//! budget from `RIINA_FUZZ_ITERS` (default 2000 — the fast per-PR/local figure)
//! and a per-run seed offset from `RIINA_FUZZ_SEED` (default 0 — the fixed,
//! reproducible sequence). The scheduled workflow
//! `.github/workflows/fuzz-continuous.yml` runs this suite nightly with a large
//! budget and a run-unique seed (logged for reproduction), so fuzzing is
//! continuous rather than only per-PR at a fixed depth. Coverage-gated
//! (`frontend-coverage`, >=80%) is already wired; OSS-Fuzz remains the larger
//! REQ-30 goal.
//!
//! It found and fixed two real denial-of-service bugs in the parser:
//!   1. Stack overflow (SIGABRT) on deeply nested input (`((((…`) — the
//!      recursive-descent parser had no depth limit. Fixed with a depth guard
//!      returning `ParseErrorKind::NestingTooDeep`; regression:
//!      `parser_rejects_deep_nesting_without_crash`.
//!   2. Infinite loop on an unclosed generic (`fungsi x<`) — the `<...>`-skip
//!      loops only terminated on `None`, but the lexer repeats `Eof` forever,
//!      so the `_` arm spun. Fixed by terminating those loops at `Eof`;
//!      regression: `parser_terminates_on_unclosed_generic`.

use riina_lexer::{Lexer, TokenKind};
use riina_parser::Parser;
use std::panic::{catch_unwind, AssertUnwindSafe};
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::mpsc;
use std::time::Duration;

/// Unique suffix for interp-stage temp files (tests run in parallel).
static INTERP_FILE_SEQ: AtomicU64 = AtomicU64::new(0);

/// Dependency-free PRNG (xorshift64*), same idiom as the codegen differential
/// tests. Deterministic seed ⇒ reproducible runs.
struct XorShift(u64);
impl XorShift {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.0 = x;
        x.wrapping_mul(0x2545_F491_4F6C_DD1D)
    }
    fn below(&mut self, n: usize) -> usize {
        (self.next() % n as u64) as usize
    }
}

/// Iteration budget for the randomized fuzz passes (REQ-30 continuous fuzz).
///
/// Defaults to 2000 — the fast figure for the per-PR CI job and local
/// `cargo test`. The scheduled continuous-fuzz workflow
/// (`.github/workflows/fuzz-continuous.yml`) raises it via `RIINA_FUZZ_ITERS`
/// so an overnight run explores far more inputs than a pull-request run.
/// The harness-sanity gate (`fuzz_mutation_actually_reaches_deeper_stages`)
/// deliberately does NOT use this — it asserts exact stable counts and stays
/// pinned at its fixed budget.
fn fuzz_iters() -> usize {
    std::env::var("RIINA_FUZZ_ITERS")
        .ok()
        .and_then(|v| v.parse::<usize>().ok())
        .filter(|&n| n > 0)
        .unwrap_or(2000)
}

/// Per-run seed offset for the randomized passes. Defaults to 0 (the fixed,
/// reproducible per-PR sequence). The scheduled job sets `RIINA_FUZZ_SEED` to a
/// run-unique value so each night walks a FRESH region of the input space
/// rather than re-checking the identical deterministic stream. The effective
/// seed is logged (see `announce_fuzz_config`), so any crash a scheduled run
/// finds is reproducible by re-exporting the same `RIINA_FUZZ_SEED` +
/// `RIINA_FUZZ_ITERS`.
fn fuzz_seed(base: u64) -> u64 {
    let off = std::env::var("RIINA_FUZZ_SEED")
        .ok()
        .and_then(|v| v.parse::<u64>().ok())
        .unwrap_or(0);
    // Golden-ratio mix so a small integer offset (e.g. a CI run number) still
    // moves the whole 64-bit seed, not just its low bits.
    base ^ off.wrapping_mul(0x9E37_79B9_7F4A_7C15)
}

/// Record the effective budget/seed for a pass, but only when a scaling env var
/// is present — keeps ordinary `cargo test` output quiet while making every
/// scheduled continuous-fuzz run self-documenting for reproduction.
fn announce_fuzz_config(test: &str, base_seed: u64) {
    let iters = std::env::var("RIINA_FUZZ_ITERS").ok();
    let seed = std::env::var("RIINA_FUZZ_SEED").ok();
    if iters.is_some() || seed.is_some() {
        eprintln!(
            "[fuzz] {test}: iters={} seed_base={:#018x} seed_off={} -> seed={:#018x}",
            fuzz_iters(),
            base_seed,
            seed.as_deref().unwrap_or("0"),
            fuzz_seed(base_seed),
        );
    }
}

/// Drive the lexer to completion. Bounded so a (hypothetical) non-advancing
/// lexer becomes a clean stop rather than a hang.
fn lex_all(input: &str) {
    let mut lx = Lexer::new(input);
    let cap = input.len() * 4 + 64;
    for _ in 0..cap {
        match lx.next_token() {
            Ok(t) if t.kind == TokenKind::Eof => return,
            Ok(_) => continue,
            Err(_) => return,
        }
    }
}

/// THE frontend invariant: lexing, parsing, and (when parsing succeeds)
/// typechecking `input` must (1) terminate and (2) not panic/crash — every
/// stage returns `Ok`/`Err`, nothing else. Runs on a worker thread bounded by
/// a wall-clock timeout so a non-terminating input is reported as a HANG with
/// a reproducer. When the input typechecks, the interpreter stage runs too
/// (in a subprocess — see `interp_no_crash`).
fn assert_no_panic(input: &str) {
    let owned = input.to_string();
    let (tx, rx) = mpsc::channel();
    // 4 MiB worker stack: comfortably holds MAX_EXPR_DEPTH frames.
    std::thread::Builder::new()
        .stack_size(4 * 1024 * 1024)
        .spawn(move || {
            let result = catch_unwind(AssertUnwindSafe(|| {
                lex_all(&owned);
                // REQ-30 stage 2: anything that parses goes through the same
                // typechecker entry `riinac check` uses. Reports whether the
                // program is well-typed so stage 3 can interpret it.
                match Parser::new(&owned).parse_program() {
                    Ok(program) => riina_typechecker::check_program(&program).is_ok(),
                    Err(_) => false,
                }
            }))
            .ok();
            let _ = tx.send(result);
        })
        .expect("spawn fuzz worker");

    match rx.recv_timeout(Duration::from_secs(5)) {
        Ok(Some(well_typed)) => {
            if well_typed {
                interp_no_crash(input);
            }
        }
        Ok(None) => panic!(
            "lexer/parser/typechecker PANICKED on input ({} bytes): {:?}",
            input.len(),
            input.chars().take(200).collect::<String>()
        ),
        Err(_) => {
            // Dump the full reproducer so it can be minimized/triaged.
            let _ = std::fs::write("/tmp/fuzz_hang.rii", input);
            panic!(
                "lexer/parser/typechecker DID NOT TERMINATE (>5s) on input ({} bytes; full input → /tmp/fuzz_hang.rii): {:?}",
                input.len(),
                input.chars().take(200).collect::<String>()
            )
        }
    }
}

/// Resident set size of `pid` in bytes (Linux /proc; None elsewhere/on error).
fn child_rss_bytes(pid: u32) -> Option<u64> {
    let statm = std::fs::read_to_string(format!("/proc/{pid}/statm")).ok()?;
    let resident_pages: u64 = statm.split_whitespace().nth(1)?.parse().ok()?;
    Some(resident_pages * 4096)
}

/// REQ-30 stage 3: interpret a well-typed input by running the real
/// `riinac run` binary in a subprocess with a 5 s wall-clock kill and a 1 GiB
/// RSS watchdog (an address-space rlimit is unusable — riinac reserves ~16 GiB
/// of address space up front for its arena, so RLIMIT_AS aborts healthy runs).
/// A well-typed mutated program may legitimately loop or allocate forever
/// (timeout/watchdog kill is a SKIP, not a failure), but it must never make
/// the interpreter PANIC (exit 101) or CRASH (SIGSEGV/SIGABRT — which
/// `catch_unwind` could not even observe).
fn interp_no_crash(input: &str) {
    use std::process::{Command, Stdio};

    let path = std::env::temp_dir().join(format!(
        "riina_fuzz_interp_{}_{}.rii",
        std::process::id(),
        INTERP_FILE_SEQ.fetch_add(1, Ordering::Relaxed)
    ));
    std::fs::write(&path, input).expect("write interp fuzz input");

    let mut child = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&path)
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
        .expect("spawn riinac run subprocess");

    const RSS_LIMIT: u64 = 1 << 30; // 1 GiB: far above any legitimate fuzz run
    let deadline = std::time::Instant::now() + Duration::from_secs(5);
    let status = loop {
        match child.try_wait().expect("wait on riinac run") {
            Some(status) => break Some(status),
            None if std::time::Instant::now() >= deadline
                || child_rss_bytes(child.id()).is_some_and(|rss| rss > RSS_LIMIT) =>
            {
                let _ = child.kill();
                let _ = child.wait();
                break None; // legitimate non-termination/allocation — skip
            }
            None => std::thread::sleep(Duration::from_millis(10)),
        }
    };
    let _ = std::fs::remove_file(&path);

    if let Some(status) = status {
        match status.code() {
            // 101 is the Rust panic exit code; any other code (0 = ran,
            // non-zero = clean interpreter/CLI error) keeps the invariant.
            Some(101) => panic!(
                "interpreter PANICKED on well-typed input ({} bytes): {:?}",
                input.len(),
                input.chars().take(200).collect::<String>()
            ),
            Some(_) => {}
            // Killed by a signal: SIGKILL here means the rlimit fired on an
            // allocation-hungry-but-legitimate program (skip); SIGSEGV/SIGABRT
            // and friends are genuine crashes. std exposes no signal number
            // portably without unix-only APIs, so use them.
            None => {
                #[cfg(unix)]
                {
                    use std::os::unix::process::ExitStatusExt;
                    let sig = status.signal();
                    if sig != Some(9) {
                        let _ = std::fs::write("/tmp/fuzz_interp_crash.rii", input);
                        panic!(
                            "interpreter CRASHED (signal {sig:?}) on well-typed input ({} bytes; reproducer → /tmp/fuzz_interp_crash.rii): {:?}",
                            input.len(),
                            input.chars().take(200).collect::<String>()
                        );
                    }
                }
            }
        }
    }
}

/// Vocabulary for structure-aware "token salad" — keywords, symbols, and a few
/// literals/identifiers. Reaching deep parser paths needs plausible tokens, not
/// just random bytes.
const VOCAB: &[&str] = &[
    "fungsi", "biar", "pulang", "kalau", "kalau_tidak", "padan", "kesan", "Bersih", "Tulis",
    "Nombor", "Teks", "Benar", "sulit", "dedah", "dengan", "bukti", "pelaku", "hantar", "terima",
    "(", ")", "{", "}", "[", "]", "<", ">", ",", ";", ":", "->", "=>", "=", "==", "+", "-", "*",
    "/", "%", "&&", "||", "!", ".", "::", "\"s\"", "42", "0xFF", "x", "utama", "_", "\n", " ",
];

fn gen_token_salad(rng: &mut XorShift, n: usize) -> String {
    let mut s = String::new();
    for _ in 0..n {
        s.push_str(VOCAB[rng.below(VOCAB.len())]);
        if rng.below(3) == 0 {
            s.push(' ');
        }
    }
    s
}

fn gen_random_ascii(rng: &mut XorShift, n: usize) -> String {
    // Printable ASCII + occasional control/brace bias to stress delimiters.
    (0..n)
        .map(|_| match rng.below(8) {
            0 => *b"(){}[]<>".get(rng.below(8)).unwrap() as char,
            _ => (0x20 + rng.below(0x5f) as u8) as char,
        })
        .collect()
}

/// Mutate a seed string with random byte flips/inserts/deletes — the classic
/// "valid-ish input nudged off the happy path" that finds parser crashes.
fn mutate(rng: &mut XorShift, seed: &[u8]) -> String {
    let mut bytes = seed.to_vec();
    let edits = 1 + rng.below(16);
    for _ in 0..edits {
        if bytes.is_empty() {
            bytes.push(b'(');
            continue;
        }
        match rng.below(3) {
            0 => {
                let i = rng.below(bytes.len());
                bytes[i] = 0x20 + rng.below(0x5f) as u8;
            }
            1 => {
                let i = rng.below(bytes.len() + 1);
                bytes.insert(i, *b"(){} \n".get(rng.below(6)).unwrap());
            }
            _ => {
                let i = rng.below(bytes.len());
                bytes.remove(i);
            }
        }
    }
    String::from_utf8_lossy(&bytes).into_owned()
}

#[test]
fn fuzz_random_ascii_no_panic() {
    let base = 0x1234_5678_9ABC_DEF0;
    announce_fuzz_config("fuzz_random_ascii_no_panic", base);
    let mut rng = XorShift(fuzz_seed(base));
    for _ in 0..fuzz_iters() {
        let len = rng.below(256);
        assert_no_panic(&gen_random_ascii(&mut rng, len));
    }
}

#[test]
fn fuzz_token_salad_no_panic() {
    let base = 0xCAFE_BABE_F00D_1357;
    announce_fuzz_config("fuzz_token_salad_no_panic", base);
    let mut rng = XorShift(fuzz_seed(base));
    for _ in 0..fuzz_iters() {
        let n = rng.below(120);
        assert_no_panic(&gen_token_salad(&mut rng, n));
    }
}

#[test]
fn fuzz_corpus_mutation_no_panic() {
    // Seed with the 00_basics examples (they parse), then mutate.
    let dir = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../../07_EXAMPLES/00_basics");
    let seeds: Vec<Vec<u8>> = std::fs::read_dir(&dir)
        .map(|rd| {
            rd.filter_map(|e| e.ok())
                .filter(|e| e.path().extension().is_some_and(|x| x == "rii"))
                .filter_map(|e| std::fs::read(e.path()).ok())
                .collect()
        })
        .unwrap_or_default();
    assert!(!seeds.is_empty(), "expected seed corpus in {}", dir.display());

    let base = 0x0BAD_C0DE_DEAD_BEEF;
    announce_fuzz_config("fuzz_corpus_mutation_no_panic", base);
    let mut rng = XorShift(fuzz_seed(base));
    for _ in 0..fuzz_iters() {
        let seed = &seeds[rng.below(seeds.len())];
        assert_no_panic(&mutate(&mut rng, seed));
    }
}

#[test]
fn fuzz_mutation_actually_reaches_deeper_stages() {
    // Sanity gate on the harness itself: the corpus-mutation mode must drive a
    // non-trivial share of inputs PAST the parser into the typechecker (and
    // some all the way through `check_program`) — otherwise the stage-2/3
    // extension is dead code and the "fuzzes the typechecker" claim is hollow.
    // Deterministic seed ⇒ stable counts.
    let dir = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../../07_EXAMPLES/00_basics");
    let seeds: Vec<Vec<u8>> = std::fs::read_dir(&dir)
        .map(|rd| {
            rd.filter_map(|e| e.ok())
                .filter(|e| e.path().extension().is_some_and(|x| x == "rii"))
                .filter_map(|e| std::fs::read(e.path()).ok())
                .collect()
        })
        .unwrap_or_default();
    assert!(!seeds.is_empty(), "expected seed corpus in {}", dir.display());

    let mut rng = XorShift(0x0BAD_C0DE_DEAD_BEEF);
    let (mut parsed, mut checked) = (0u32, 0u32);
    for _ in 0..2000 {
        let seed = &seeds[rng.below(seeds.len())];
        let input = mutate(&mut rng, seed);
        if let Ok(program) = Parser::new(&input).parse_program() {
            parsed += 1;
            if riina_typechecker::check_program(&program).is_ok() {
                checked += 1;
            }
        }
    }
    assert!(
        parsed > 50,
        "mutation mode should keep many inputs parseable (got {parsed}/2000)"
    );
    assert!(
        checked > 0,
        "at least some mutated programs must reach a successful typecheck (got {checked}; {parsed} parsed)"
    );
}

#[test]
fn fuzz_tricky_seeds_no_panic() {
    // A hand-picked battery of historically dangerous shapes.
    let seeds = [
        "",
        "(",
        "{",
        "<",
        "\"",
        "fungsi",
        "fungsi (",
        "biar x =",
        "kesan",
        "padan {",
        "1 + + + 1",
        "((((((((((((((((((((",
        "Senarai<Senarai<Senarai<Nombor",
        "\"unterminated",
        "0x",
        "999999999999999999999999999999",
        "fungsi 𝕦𝕥𝕒𝕞𝕒() {}",
        "\u{0}\u{1}\u{2}",
        "//",
        "/*",
    ];
    for s in seeds {
        assert_no_panic(s);
    }
}

#[test]
fn parser_terminates_on_unclosed_generic() {
    // Regression for the infinite loop this harness found: `fungsi x<` (an
    // unclosed generic-parameter `<`) spun `skip_type_argument_list` forever
    // because the lexer repeats `Eof` rather than yielding `None`. Must now
    // return a ParseError promptly. (Minimized from a mutated GUARD_CLAUSES.rii.)
    for src in ["fungsi x<", "fungsi f < g", "fungsi uta<a() -> Nombor kesan Tulis {"] {
        assert_no_panic(src); // assert_no_panic bounds with a 5s timeout
        let r = Parser::new(src).parse_program();
        assert!(r.is_err(), "unclosed generic must be a clean error: {src:?}");
    }
}

#[test]
fn parser_rejects_deep_nesting_without_crash() {
    // Regression for the crash this harness found: 50k-deep parens must be a
    // clean ParseError (NestingTooDeep), not a stack-overflow abort.
    let src = format!(
        "fungsi utama() -> Nombor kesan Bersih {{ {}1{} }}",
        "(".repeat(50_000),
        ")".repeat(50_000),
    );
    let err = Parser::new(&src)
        .parse_program()
        .expect_err("deep nesting must be rejected, not parsed");
    assert!(
        err.to_string().contains("nesting too deep"),
        "expected NestingTooDeep, got: {err}"
    );
}
