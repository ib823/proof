//! Dependency-free micro-benchmarks for the verified RIINA standard library.
//!
//! Gate C (stdlib hardening) / Gate E (benchmarks). Per **Law 8 — Zero
//! third-party deps** this is a hand-written timing harness: no `criterion`,
//! no external crates, fully auditable. It exercises the *running*
//! implementations that sit behind the Coq-verified algorithms
//! (`foundations/VerifiedList.v`, `VerifiedMapSet.v`, `VerifiedString.v`,
//! `SizedInt.v`) through the public `apply_builtin` dispatcher and
//! `Interpreter::eval`.
//!
//! Run with: `cargo bench -p riina-codegen`  (or `--bench stdlib_bench`).
//!
//! Each row auto-scales its iteration count until a stable wall-clock window
//! (>= 50 ms) is reached, then reports nanoseconds/op and operations/sec.
//! Inputs come from a fixed LCG seed (the same one the stdlib property tests
//! use), so the numbers are reproducible run to run.
//!
//! Measurement honesty: the public `apply_builtin` consumes its argument by
//! value, so the collection/string timings *include one input clone*. The
//! "(clone baseline)" rows make that overhead explicit so it can be subtracted.

use riina_codegen::builtins::apply_builtin;
use riina_codegen::{Interpreter, Value};
use riina_types::{BinOp, Expr};
use std::collections::BTreeMap;
use std::hint::black_box;
use std::time::{Duration, Instant};

/// Deterministic LCG matching the stdlib property-test seed.
fn lcg(state: &mut u64) -> u64 {
    *state = state
        .wrapping_mul(6_364_136_223_846_793_005)
        .wrapping_add(1_442_695_040_888_963_407);
    *state >> 33
}

/// Run `f` repeatedly, doubling the iteration count until at least 50 ms have
/// elapsed, then return the mean nanoseconds per call.
fn measure(mut f: impl FnMut()) -> f64 {
    for _ in 0..8 {
        f();
    }
    let budget = Duration::from_millis(50);
    let mut iters: u64 = 1;
    loop {
        let start = Instant::now();
        for _ in 0..iters {
            f();
        }
        let elapsed = start.elapsed();
        if elapsed >= budget || iters >= (1u64 << 32) {
            return elapsed.as_nanos() as f64 / iters as f64;
        }
        iters = iters.saturating_mul(2);
    }
}

fn row(label: &str, n: usize, ns: f64) {
    let ops_per_sec = 1.0e9 / ns;
    println!("  {label:<32} n={n:<6} {ns:>13.1} ns/op  {ops_per_sec:>15.0} ops/s");
}

/// Benchmark a builtin reached through the public `apply_builtin` dispatcher.
/// The input is cloned each call because the dispatcher consumes it by value.
fn bench_apply(label: &str, n: usize, name: &'static str, input: &Value) {
    let ns = measure(|| {
        let r = apply_builtin(name, black_box(input.clone()));
        let _ = black_box(r);
    });
    row(label, n, ns);
}

fn int_list(n: usize, state: &mut u64) -> Value {
    Value::List((0..n).map(|_| Value::Int(lcg(state) % 1000)).collect())
}

fn dup_list(n: usize, state: &mut u64) -> Value {
    // Values in 0..100 → guaranteed duplicates once n > 100 (exercises de-dup).
    Value::List((0..n).map(|_| Value::Int(lcg(state) % 100)).collect())
}

fn string_map(n: usize) -> Value {
    let mut m: BTreeMap<String, Value> = BTreeMap::new();
    for i in 0..n {
        m.insert(format!("k{i}"), Value::Int(i as u64));
    }
    Value::Map(m)
}

fn pair(a: Value, b: Value) -> Value {
    Value::Pair(Box::new(a), Box::new(b))
}

fn bench_sized(label: &str, op: BinOp) {
    // u8 wrapping arithmetic — the verified `SizedInt` residue ring.
    let expr = Expr::BinOp(
        op,
        Box::new(Expr::IntN {
            value: 200,
            bits: 8,
            signed: false,
        }),
        Box::new(Expr::IntN {
            value: 100,
            bits: 8,
            signed: false,
        }),
    );
    let mut interp = Interpreter::new();
    let ns = measure(|| {
        let r = interp.eval(black_box(&expr));
        let _ = black_box(r);
    });
    row(label, 0, ns);
}

fn main() {
    let sizes = [64usize, 1024, 8192];
    let mut state: u64 = 0x9E37_79B9_7F4A_7C15;

    println!("RIINA verified-stdlib micro-benchmarks (Law 8: zero third-party deps)");
    println!("Inputs: fixed LCG seed; timings include one input clone (see baselines).\n");

    println!("[collections — senarai.rs / VerifiedList.v]");
    for &n in &sizes {
        let list = int_list(n, &mut state);
        bench_apply("senarai_susun (sort)", n, "senarai_susun", &list);
    }
    for &n in &sizes {
        let list = dup_list(n, &mut state);
        bench_apply("senarai_unik (dedup)", n, "senarai_unik", &list);
    }
    for &n in &sizes {
        let list = int_list(n, &mut state);
        // Worst case: search for an absent element (full scan).
        let arg = pair(list, Value::Int(1_000_000));
        bench_apply("senarai_mengandungi (scan)", n, "senarai_mengandungi", &arg);
    }

    println!("\n[maps — peta.rs / VerifiedMapSet.v]");
    for &n in &sizes {
        let arg = pair(string_map(n), pair(Value::String("k0".into()), Value::Int(7)));
        bench_apply("peta_letak (insert)", n, "peta_letak", &arg);
    }
    for &n in &sizes {
        let arg = pair(string_map(n), Value::String("k0".into()));
        bench_apply("peta_dapat (get)", n, "peta_dapat", &arg);
    }

    println!("\n[sets — set.rs / VerifiedMapSet.v]");
    for &n in &sizes {
        let arg = pair(int_list(n, &mut state), Value::Int(1_000_000));
        bench_apply("set_letak (insert)", n, "set_letak", &arg);
    }
    for &n in &sizes {
        let arg = pair(int_list(n, &mut state), int_list(n, &mut state));
        bench_apply("set_kesatuan (union)", n, "set_kesatuan", &arg);
    }

    println!("\n[strings — teks.rs / VerifiedString.v]");
    for &n in &sizes {
        let s = vec!["a"; n].join(",");
        let arg = pair(Value::String(s), Value::String(",".into()));
        bench_apply("teks_belah (split)", n, "teks_belah", &arg);
    }
    for &n in &sizes {
        let list = Value::List((0..n).map(|_| Value::String("a".into())).collect());
        let arg = pair(Value::String(",".into()), list);
        bench_apply("teks_cantum (join)", n, "teks_cantum", &arg);
    }
    for &n in &sizes {
        let arg = pair(Value::String("ab".into()), Value::Int(n as u64));
        bench_apply("teks_ulang (repeat)", n, "teks_ulang", &arg);
    }

    println!("\n[numeric tower — IntN wrapping arithmetic / SizedInt.v]");
    bench_sized("sized_int_add (u8 wrap)", BinOp::Add);
    bench_sized("sized_int_mul (u8 wrap)", BinOp::Mul);

    println!("\n[clone baselines — overhead included in the rows above]");
    let mut s2: u64 = 1;
    let big_list = int_list(8192, &mut s2);
    let ns = measure(|| {
        let c = black_box(big_list.clone());
        let _ = black_box(c);
    });
    row("List<Int> clone", 8192, ns);
    let big_map = string_map(8192);
    let ns = measure(|| {
        let c = black_box(big_map.clone());
        let _ = black_box(c);
    });
    row("Map<String,Int> clone", 8192, ns);
}
