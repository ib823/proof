// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The typing context must scale linearly with the length of a binding chain.
//!
//! The checker clones its context for every nested scope and keeps every clone
//! alive down the recursion. While each clone COPIED its maps (the ~600
//! builtins included) checking was quadratic. Release build, `riinac check`:
//! 5,000 sequential `biar` 2.7 GB / 18 s (now 36 MiB / 0.2 s), a 10,000-link
//! `lain kalau` chain 2.3 GB / 14 s (now 50 MiB / 0.2 s), 2,000 `ruj` 0.9 GB
//! and 2,000 closure bindings 1.0 GB (now under 21 MiB each). The contexts are
//! persistent now (`riina_types::persistent::PMap`).
//!
//! This file is its own test binary with ONE test, so the process's peak RSS
//! (`VmHWM`) belongs to it alone.

use riina_parser::Parser;
use riina_typechecker::check_program;
use std::time::{Duration, Instant};

/// Bindings per chain. A debug build recurses ~30 KiB of stack per nested
/// `biar`, hence the explicit worker stack below.
const N: usize = 3_000;

fn chain(first: &str, step: impl Fn(usize) -> String, last: &str) -> String {
    let mut src = format!("fungsi utama() -> Nombor kesan Tulis {{\n    {first}\n");
    for i in 1..N {
        src.push_str("    ");
        src.push_str(&step(i));
        src.push('\n');
    }
    src.push_str(&format!("    {last}\n}}\n"));
    src
}

fn programs() -> Vec<(&'static str, String)> {
    let mut kalau = String::from("fungsi f(x: Nombor) -> Nombor kesan Bersih {\n    kalau x == 0 { 0 }\n");
    for i in 1..N {
        kalau.push_str(&format!("    lain kalau x == {i} {{ {i} }}\n"));
    }
    kalau.push_str("    lain { 0 }\n}\nfungsi utama() -> Nombor kesan Bersih { f(3) }\n");
    vec![
        (
            "biar",
            chain("biar x0 = 0;", |i| format!("biar x{i} = x{} + 1;", i - 1), &format!("x{}", N - 1)),
        ),
        ("lain kalau", kalau),
        (
            "biar ubah",
            chain("biar ubah u0 = 0;", |i| format!("biar ubah u{i} = u{} + 1;", i - 1), &format!("u{}", N - 1)),
        ),
        ("ruj", chain("biar r0 = ruj 0 @ Awam;", |i| format!("biar r{i} = ruj {i} @ Awam;"), "0")),
        (
            "fungsi",
            chain(
                "biar f0 = fungsi(x: Nombor) { x };",
                |i| format!("biar f{i} = fungsi(x: Nombor) {{ f{}(x) }};", i - 1),
                &format!("f{}(1)", N - 1),
            ),
        ),
    ]
}

/// Peak resident set size of this process, in KiB (Linux only).
fn peak_rss_kib() -> Option<u64> {
    let status = std::fs::read_to_string("/proc/self/status").ok()?;
    let line = status.lines().find(|l| l.starts_with("VmHWM:"))?;
    line.split_whitespace().nth(1)?.parse().ok()
}

#[test]
fn long_binding_chains_check_in_bounded_memory_and_time() {
    let worker = std::thread::Builder::new()
        .name("context-scaling".into())
        .stack_size(1 << 30)
        .spawn(|| {
            for (shape, src) in programs() {
                let started = Instant::now();
                let program = Parser::new(&src)
                    .parse_program()
                    .unwrap_or_else(|e| panic!("{shape}: parse failed: {e:?}"));
                check_program(&program).unwrap_or_else(|e| panic!("{shape}: rejected: {e}"));
                let took = started.elapsed();
                eprintln!("{N} x {shape}: {took:?}, peak RSS {:?} KiB", peak_rss_kib());
                // Coarse. Measured in a debug build, copying context ->
                // persistent: biar 7.4 s -> 0.24 s, lain kalau 3.0 s -> 0.15 s,
                // biar ubah 12.1 s -> 0.27 s, ruj 10.4 s -> 0.15 s, fungsi
                // 41.1 s -> 0.28 s.
                assert!(took < Duration::from_secs(20), "{N} x {shape} took {took:?}");
            }
        })
        .expect("spawn worker");
    worker.join().expect("worker panicked");

    // Every chain above, checked in this process. Measured peak RSS in a
    // debug build: 2,061 MiB with the copying context (1,138 MiB after the
    // first chain alone), ~100 MiB with the persistent one — most of it the
    // debug-sized recursion stack.
    if let Some(kib) = peak_rss_kib() {
        assert!(kib < 512 * 1024, "peak RSS {} MiB for {N}-binding chains", kib / 1024);
    }
}
