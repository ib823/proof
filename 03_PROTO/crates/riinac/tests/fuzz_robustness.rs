//! Fuzz-robustness harness for the untrusted-input front end (REQ-30).
//!
//! The lexer and parser are the surface that touches arbitrary user/agent input
//! (`riinac check --stdin`). The invariant under test: **they never panic and
//! never crash** on *any* input — they return `Ok` or a `ParseError`/`LexError`,
//! nothing else.
//!
//! This is a stable-Rust, dependency-free harness (a hand-rolled XorShift PRNG,
//! matching the repo's existing differential tests), so it runs under the pinned
//! 1.94.1 toolchain in plain `cargo test` / CI — unlike `cargo-fuzz`/libFuzzer,
//! which require nightly. The full continuous-fuzz + coverage-gated + OSS-Fuzz
//! program remains the larger REQ-30 goal; this is the in-tree first line.
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
use std::sync::mpsc;
use std::time::Duration;

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

/// THE invariant: lexing and parsing `input` must (1) terminate and (2) not
/// panic/crash — it returns `Ok`/`Err`, nothing else. Runs the work on a worker
/// thread and bounds it with a wall-clock timeout, so a non-terminating input
/// (parser infinite loop) is reported as a HANG with a reproducer instead of
/// spinning the test forever. On panic or hang, fails with the offending input.
fn assert_no_panic(input: &str) {
    let owned = input.to_string();
    let (tx, rx) = mpsc::channel();
    // 4 MiB worker stack: comfortably holds MAX_EXPR_DEPTH frames.
    std::thread::Builder::new()
        .stack_size(4 * 1024 * 1024)
        .spawn(move || {
            let ok = catch_unwind(AssertUnwindSafe(|| {
                lex_all(&owned);
                let _ = Parser::new(&owned).parse_program();
            }))
            .is_ok();
            let _ = tx.send(ok);
        })
        .expect("spawn fuzz worker");

    match rx.recv_timeout(Duration::from_secs(5)) {
        Ok(true) => {}
        Ok(false) => panic!(
            "lexer/parser PANICKED on input ({} bytes): {:?}",
            input.len(),
            input.chars().take(200).collect::<String>()
        ),
        Err(_) => {
            // Dump the full reproducer so it can be minimized/triaged.
            let _ = std::fs::write("/tmp/fuzz_hang.rii", input);
            panic!(
                "lexer/parser DID NOT TERMINATE (>5s) on input ({} bytes; full input → /tmp/fuzz_hang.rii): {:?}",
                input.len(),
                input.chars().take(200).collect::<String>()
            )
        }
    }
}

/// Vocabulary for structure-aware "token salad" — keywords, symbols, and a few
/// literals/identifiers. Reaching deep parser paths needs plausible tokens, not
/// just random bytes.
const VOCAB: &[&str] = &[
    "fungsi", "biar", "pulang", "kalau", "kalau_tidak", "padan", "kesan", "Bersih", "Tulis",
    "Nombor", "Teks", "Benar", "sulit", "dedah", "dengan", "bukti", "pelakon", "hantar", "terima",
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
                bytes[i] = (0x20 + rng.below(0x5f) as u8) as u8;
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
    let mut rng = XorShift(0x1234_5678_9ABC_DEF0);
    for _ in 0..2000 {
        let len = rng.below(256);
        assert_no_panic(&gen_random_ascii(&mut rng, len));
    }
}

#[test]
fn fuzz_token_salad_no_panic() {
    let mut rng = XorShift(0xCAFE_BABE_F00D_1357);
    for _ in 0..2000 {
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

    let mut rng = XorShift(0x0BAD_C0DE_DEAD_BEEF);
    for _ in 0..2000 {
        let seed = &seeds[rng.below(seeds.len())];
        assert_no_panic(&mutate(&mut rng, seed));
    }
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
