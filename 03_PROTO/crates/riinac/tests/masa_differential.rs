// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the time (`masa`) family — master plan
//! REQ-70 family routing, item (1.0).
//!
//! # Why this family first
//!
//! REQ-70's six unrouted families are one architectural question asked six
//! times: the interpreter implementations are Rust calling `riina-os`, and
//! emitted C cannot call Rust. `masa` is the smallest surface that asks it, so
//! it goes first — it is far cheaper to discover the answer is wrong on seven
//! clock builtins than on thirty networking ones.
//!
//! # What routing it actually exposed
//!
//! The C emitter already contained all six `masa` functions; the family was
//! interpreter-only purely because `builtin_canonical` did not route it. Wiring
//! it up therefore did not *introduce* the divergences below — it **revealed**
//! them, which is the point of doing this one first. All three were measured:
//!
//! | builtin | interpreter (before) | C (before) |
//! |---|---|---|
//! | `masa_format` | ignored the format: `1700000000` | real `strftime`: `2023-11-14` |
//! | `masa_urai` | parsed a decimal only | real `strptime` |
//! | `masa_jam` | wall nanos since epoch (~1.79e18) | `CLOCK_MONOTONIC` (~1.9e11) |
//!
//! The first two are the worst kind: a **silent wrong answer** from a program
//! that ran fine. The fix is not to make the interpreter call libc — it cannot,
//! under Law 8 — but to stop letting libc define the contract at all. Both
//! sides now implement the SAME documented specifier subset and the same civil
//! calendar, and this differential is what keeps them from drifting.
//!
//! # Clocks cannot be byte-compared
//!
//! Two processes read a clock at different instants, so `masa_sekarang` can
//! never be byte-equal across backends. Those are checked as **properties**
//! (agreement to within a tolerance, monotonicity, plausible range); only the
//! pure functions of their inputs — `masa_format`/`masa_urai` — are compared
//! byte-for-byte. Asserting equality on a clock would be a test that fails at
//! midnight rather than one that means something.

use std::path::PathBuf;
use std::process::Command;

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
            "!!! SKIPPED (tools missing: {}) — masa coverage NOT exercised.",
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

/// A throwaway directory, unique per test name and pid — `riinac build` derives
/// its intermediate C path from the source stem, so a shared stem would race.
struct Sandbox {
    dir: PathBuf,
    stem: String,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let stem = format!("req70_masa_{tag}");
        let dir = std::env::temp_dir().join(format!("riina_{stem}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self { dir, stem }
    }

    fn src(&self, body: &str) -> PathBuf {
        let p = self.dir.join(format!("{}.rii", self.stem));
        std::fs::write(
            &p,
            format!("fungsi utama() -> Nombor kesan Masa {{\n{body}\n    0\n}}\n"),
        )
        .expect("write program");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

/// Interpreter stdout, without the trailing line `riinac run` adds for the
/// program's final value.
fn run_interp(src: &PathBuf) -> String {
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(src)
        .output()
        .expect("riinac run");
    assert!(
        out.status.success(),
        "interpreter failed: {}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    let s = String::from_utf8_lossy(&out.stdout).into_owned();
    let mut lines: Vec<&str> = s.lines().collect();
    lines.pop();
    if lines.is_empty() {
        String::new()
    } else {
        format!("{}\n", lines.join("\n"))
    }
}

fn run_native(sb: &Sandbox, src: &PathBuf) -> String {
    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(src)
        .output()
        .expect("riinac build");
    assert!(
        build.status.success(),
        "native build failed — the masa family must ROUTE to codegen: {}{}",
        String::from_utf8_lossy(&build.stdout),
        String::from_utf8_lossy(&build.stderr)
    );
    let run = Command::new(sb.dir.join(&sb.stem))
        .output()
        .expect("run native binary");
    assert!(
        run.status.success(),
        "native binary failed (exit {:?}): {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    String::from_utf8_lossy(&run.stdout).into_owned()
}

/// Both backends produce `expected`, byte for byte.
///
/// The expected value is asserted as well as the agreement, because the old
/// `masa_format` behaviour was a wrong answer the interpreter gave *on its
/// own*; agreement alone would not have caught the format string being ignored.
fn assert_output(tag: &str, body: &str, expected: &str) {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.src(body);
    let interp = run_interp(&src);
    let native = run_native(&sb, &src);
    assert_eq!(interp, expected, "interpreter output wrong for {tag}");
    assert_eq!(
        native, expected,
        "C output wrong for {tag} (interp said {interp:?})"
    );
}

/// Run `body` on both backends and hand each stdout to `check`.
fn assert_property(tag: &str, body: &str, check: impl Fn(&str, &str)) {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new(tag);
    let src = sb.src(body);
    let interp = run_interp(&src);
    let native = run_native(&sb, &src);
    check(&interp, &native);
}

// ── Pure functions of their inputs: byte-equal ─────────────────────────────

/// THE REQ-70 regression. `masa_format` ignored its format string in the
/// interpreter and ran a real `strftime` in C.
#[test]
fn format_agrees_and_honours_the_format_string() {
    assert_output(
        "format",
        "    cetakln(masa_format((1700000000, \"%Y-%m-%d %H:%M:%S\")));",
        "2023-11-14 22:13:20\n",
    );
}

/// The epoch itself, and a leap day — the two dates a civil-calendar bug shows
/// up on first.
#[test]
fn format_agrees_on_epoch_and_leap_day() {
    assert_output("epoch", "    cetakln(masa_format((0, \"%Y-%m-%d\")));", "1970-01-01\n");
    // 2024-02-29 00:00:00Z
    assert_output(
        "leap",
        "    cetakln(masa_format((1709164800, \"%Y-%m-%d\")));",
        "2024-02-29\n",
    );
}

/// `%s`, `%%`, and an UNSUPPORTED specifier, which both backends must emit
/// literally rather than drop.
#[test]
fn format_agrees_on_escapes_and_unsupported_specifiers() {
    assert_output(
        "escapes",
        "    cetakln(masa_format((1700000000, \"epoch=%s 100%% %Q\")));",
        "epoch=1700000000 100% %Q\n",
    );
}

/// `masa_urai` is the inverse of `masa_format` over the same specifier set.
#[test]
fn parse_agrees_and_round_trips() {
    assert_output(
        "parse",
        "    cetakln(ke_teks(masa_urai((\"2023-11-14 22:13:20\", \"%Y-%m-%d %H:%M:%S\"))));\n\
         \x20   cetakln(ke_teks(masa_urai((\"1700000000\", \"%s\"))));\n\
         \x20   cetakln(masa_format((masa_urai((\"2024-02-29\", \"%Y-%m-%d\")), \"%Y-%m-%d\")));",
        "1700000000\n1700000000\n2024-02-29\n",
    );
}

// ── Clocks: properties, because equality is impossible ─────────────────────

/// Both backends read the same wall clock, so they agree to within the time it
/// takes to run them — but never exactly.
#[test]
fn wall_clock_agrees_within_tolerance() {
    assert_property(
        "wall",
        "    cetakln(ke_teks(masa_sekarang()));",
        |interp, native| {
            let a: i64 = interp.trim().parse().expect("interp int");
            let b: i64 = native.trim().parse().expect("C int");
            assert!(a > 1_700_000_000, "implausible interp timestamp: {a}");
            assert!(b > 1_700_000_000, "implausible C timestamp: {b}");
            assert!(
                (a - b).abs() < 300,
                "wall clocks disagree by {}s — different clocks, not scheduling",
                (a - b).abs()
            );
        },
    );
}

/// `masa_jam` is MONOTONIC — nanoseconds from an unspecified origin. It is not
/// comparable across processes at all; what must hold is that neither backend
/// returns a wall-clock-since-epoch value, which is what the interpreter used
/// to do (~1.79e18 against C's ~1.9e11).
#[test]
fn monotonic_clock_is_not_the_wall_clock_on_either_backend() {
    assert_property(
        "mono",
        "    cetakln(ke_teks(masa_jam()));",
        |interp, native| {
            let a: u64 = interp.trim().parse().expect("interp int");
            let b: u64 = native.trim().parse().expect("C int");
            // Nanos since the epoch are ~1.79e18 and climbing; a monotonic
            // clock rooted at process start or boot is many orders below that.
            const WALL_NANOS_FLOOR: u64 = 1_600_000_000_000_000_000;
            assert!(a < WALL_NANOS_FLOOR, "interpreter masa_jam looks like wall nanos: {a}");
            assert!(b < WALL_NANOS_FLOOR, "C masa_jam looks like wall nanos: {b}");
        },
    );
}

/// Successive reads never go backwards, on either backend.
#[test]
fn monotonic_clock_does_not_go_backwards() {
    assert_property(
        "mono_order",
        "    biar a = masa_jam();\n\
         \x20   biar b = masa_jam();\n\
         \x20   cetakln(ke_teks(a));\n\
         \x20   cetakln(ke_teks(b));",
        |interp, native| {
            for (which, out) in [("interp", interp), ("C", native)] {
                let v: Vec<u64> = out
                    .lines()
                    .map(|l| l.trim().parse().expect("int"))
                    .collect();
                assert_eq!(v.len(), 2, "{which}: expected two readings");
                assert!(v[1] >= v[0], "{which}: clock went backwards {} -> {}", v[0], v[1]);
            }
        },
    );
}

/// Milliseconds are milliseconds on both backends — a units mix-up here (s vs
/// ms vs ns) is the classic clock bug and would not show up in `masa_sekarang`.
#[test]
fn millisecond_clock_has_millisecond_magnitude() {
    assert_property(
        "ms",
        "    cetakln(ke_teks(masa_sekarang_ms()));",
        |interp, native| {
            for (which, out) in [("interp", interp), ("C", native)] {
                let v: u64 = out.trim().parse().expect("int");
                assert!(
                    (1_700_000_000_000..2_000_000_000_000).contains(&v),
                    "{which}: {v} is not a plausible unix millisecond timestamp"
                );
            }
        },
    );
}

/// `masa_tidur` actually sleeps, on both backends — measured with the family's
/// own monotonic clock rather than the host's.
#[test]
fn sleep_actually_sleeps() {
    assert_property(
        "sleep",
        "    biar a = masa_jam();\n\
         \x20   masa_tidur(50);\n\
         \x20   biar b = masa_jam();\n\
         \x20   cetakln(ke_teks(b - a));",
        |interp, native| {
            for (which, out) in [("interp", interp), ("C", native)] {
                let ns: u64 = out.trim().parse().expect("int");
                assert!(
                    ns >= 40_000_000,
                    "{which}: slept {ns}ns, expected >= ~50ms — did masa_tidur run?"
                );
            }
        },
    );
}
