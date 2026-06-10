// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! C ⇄ WASM differential tests.
//!
//! For each program, compile it through BOTH backends and assert the stdout is
//! byte-for-byte identical:
//!   - C:    `riinac emit-c` -> `cc` -> run native binary
//!   - WASM: `riinac build --target wasm32` -> `wasmtime run`
//!
//! These require `cc` and `wasmtime` on PATH. When either is missing (e.g. in a
//! minimal CI image) the tests skip rather than fail.

use std::fs;
use std::path::PathBuf;
use std::process::Command;

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

fn workdir() -> PathBuf {
    let dir = std::env::temp_dir().join("riina_wasm_c_diff");
    fs::create_dir_all(&dir).unwrap();
    dir
}

/// Run `source` through the C backend; return native stdout.
fn run_c(name: &str, source: &str) -> Vec<u8> {
    let dir = workdir();
    let rii = dir.join(format!("{name}.rii"));
    let c = dir.join(format!("{name}.c"));
    let bin = dir.join(format!("{name}_c"));
    fs::write(&rii, source).unwrap();

    let emit = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["emit-c", &rii.to_string_lossy()])
        .output()
        .expect("emit-c");
    assert!(
        emit.status.success(),
        "emit-c failed: {}",
        String::from_utf8_lossy(&emit.stderr)
    );
    fs::write(&c, &emit.stdout).unwrap();

    let cc = Command::new("cc")
        .args([
            "-o",
            &bin.to_string_lossy(),
            &c.to_string_lossy(),
            "-lm",
        ])
        .output()
        .expect("cc");
    assert!(
        cc.status.success(),
        "cc failed: {}",
        String::from_utf8_lossy(&cc.stderr)
    );

    Command::new(&bin).output().expect("run C binary").stdout
}

/// Run `source` through the WASM backend; return wasmtime stdout.
fn run_wasm(name: &str, source: &str) -> Vec<u8> {
    let dir = workdir();
    let rii = dir.join(format!("{name}.rii"));
    let wasm = dir.join(format!("{name}.wasm"));
    fs::write(&rii, source).unwrap();

    let build = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .args(["build", "--target", "wasm32", &rii.to_string_lossy()])
        .output()
        .expect("build wasm");
    assert!(
        build.status.success(),
        "build wasm failed: {}",
        String::from_utf8_lossy(&build.stderr)
    );

    Command::new("wasmtime")
        .args(["run", &wasm.to_string_lossy()])
        .output()
        .expect("wasmtime run")
        .stdout
}

fn assert_byte_equal(name: &str, source: &str) {
    if !tool_available("cc") || !tool_available("wasmtime") {
        eprintln!("skipping {name}: cc/wasmtime not available");
        return;
    }
    let c = run_c(name, source);
    let w = run_wasm(name, source);
    assert_eq!(
        c,
        w,
        "C/WASM differ for {name}: C={:?} WASM={:?}",
        String::from_utf8_lossy(&c),
        String::from_utf8_lossy(&w)
    );
}

#[test]
fn diff_cetak_int() {
    assert_byte_equal(
        "cetak_int",
        "fungsi utama() -> Nombor kesan Sistem { cetak(42); pulang 0 }",
    );
}

#[test]
fn diff_cetak_string() {
    assert_byte_equal(
        "cetak_string",
        "fungsi utama() -> Nombor kesan Sistem { cetak(\"Selamat\"); pulang 0 }",
    );
}

#[test]
fn diff_cetak_arithmetic() {
    assert_byte_equal(
        "cetak_arith",
        "fungsi utama() -> Nombor kesan Sistem { cetak(3 + 4); pulang 0 }",
    );
}

#[test]
fn diff_cetak_multiple() {
    assert_byte_equal(
        "cetak_multi",
        "fungsi utama() -> Nombor kesan Sistem { cetak(1); cetak(2); cetak(3); pulang 0 }",
    );
}

#[test]
fn diff_bare_int() {
    assert_byte_equal("bare_int", "42");
}

#[test]
fn diff_bare_arithmetic() {
    assert_byte_equal("bare_arith", "100 * 100 * 100");
}

#[test]
fn diff_bare_zero() {
    assert_byte_equal("bare_zero", "0");
}

#[test]
fn diff_bare_bool() {
    assert_byte_equal("bare_bool", "betul");
}

// ── W1: true 64-bit values (>= 2^32) ────────────────────────────────────────
// Before W1 the wasm32 backend held a 32-bit value cell, so these were a clean
// compile error there. With the uniform i64 cell they must print byte-identically
// to the C backend (which has always used a 64-bit integer).

#[test]
fn diff_cetak_64bit_value() {
    // 5_000_000_000 > 2^32 (4_294_967_296).
    assert_byte_equal(
        "cetak_64bit",
        "fungsi utama() -> Nombor kesan Sistem { cetak(5000000000); pulang 0 }",
    );
}

#[test]
fn diff_cetak_64bit_add() {
    // 3e9 + 3e9 = 6e9 — a sum that overflows 32 bits.
    assert_byte_equal(
        "cetak_64bit_add",
        "fungsi utama() -> Nombor kesan Sistem { cetak(3000000000 + 3000000000); pulang 0 }",
    );
}

#[test]
fn diff_cetak_64bit_mul() {
    // 10^6 * 10^6 = 10^12 — a product that overflows 32 bits.
    assert_byte_equal(
        "cetak_64bit_mul",
        "fungsi utama() -> Nombor kesan Sistem { cetak(1000000 * 1000000); pulang 0 }",
    );
}

#[test]
fn diff_bare_64bit() {
    // A bare 64-bit expression echoed by the trampoline.
    assert_byte_equal("bare_64bit", "9000000000");
}

// ── W2.1: arbitrary-precision BigInt (`besar`) construction + display ─────────
// `besar` parses a base-10 literal of any length into a linear-memory bignum
// (base-2^32 limbs, matching bigint.rs / BigIntModel.v) and renders it back; the
// WASM output must be byte-identical to the C backend (which uses its own proven
// bignum runtime). BigInt arithmetic still fails closed on WASM (a follow-up).

#[test]
fn diff_besar_small() {
    assert_byte_equal(
        "besar_small",
        "fungsi utama() -> Nombor kesan Sistem { cetak(besar(\"7\")); pulang 0 }",
    );
}

#[test]
fn diff_besar_two_limb() {
    // 12345678901234567890 < 2^64 occupies exactly two base-2^32 limbs (the case
    // that exposed the bump-pointer-alignment bug).
    assert_byte_equal(
        "besar_two_limb",
        "fungsi utama() -> Nombor kesan Sistem { cetak(besar(\"12345678901234567890\")); pulang 0 }",
    );
}

#[test]
fn diff_besar_2pow64() {
    // 2^64 — the smallest three-limb value.
    assert_byte_equal(
        "besar_2p64",
        "fungsi utama() -> Nombor kesan Sistem { cetak(besar(\"18446744073709551616\")); pulang 0 }",
    );
}

#[test]
fn diff_besar_2pow128_cetakln() {
    // 2^128 (39 digits), via cetakln (trailing newline).
    assert_byte_equal(
        "besar_2p128",
        "fungsi utama() -> Nombor kesan Sistem { cetakln(besar(\"340282366920938463463374607431768211456\")); pulang 0 }",
    );
}

// ── W2.2a: BigInt comparison (bi_cmp) ────────────────────────────────────────
// The six relational operators on BigInt operands route through bi_cmp; results
// (used here as `kalau` conditions) must match the C backend exactly, across
// limb-count boundaries and equal values. (besar parses non-negative magnitudes;
// signed comparison is exercised once arithmetic yields negatives in W2.2b.)

#[test]
fn diff_besar_cmp_true_cases() {
    // >, <, ==, cross-limb >, >=, !=, <, <=  → all true → "11111111".
    assert_byte_equal(
        "besar_cmp_true",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            kalau besar(\"100\") > besar(\"99\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"99\") < besar(\"100\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"50\") == besar(\"50\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"18446744073709551616\") > besar(\"9999999999\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"99999999999999999999\") >= besar(\"99999999999999999999\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"7\") != besar(\"8\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"99999999999999999998\") < besar(\"99999999999999999999\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"12345678901234567890\") <= besar(\"12345678901234567890\") { cetak(1) } lain { cetak(0) }\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_besar_cmp_false_and_zero() {
    // false relations, zero, and cross-limb the other way → "001101".
    assert_byte_equal(
        "besar_cmp_false",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            kalau besar(\"99\") > besar(\"100\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"7\") == besar(\"8\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"0\") == besar(\"0\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"0\") < besar(\"1\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"9999999999\") > besar(\"18446744073709551616\") { cetak(1) } lain { cetak(0) }\n\
            kalau besar(\"5\") >= besar(\"5\") { cetak(1) } lain { cetak(0) }\n\
            pulang 0\n\
        }",
    );
}

// ── W2.2b: BigInt add/sub (bi_add_mag / bi_sub_mag / bi_addsub) ───────────────
// Signed +/- route through bi_addsub; results must match the C backend exactly,
// including carry/borrow across limb boundaries, normalization, zero, and the
// negative results (which also exercise bi_cmp's sign paths).

#[test]
fn diff_besar_add() {
    assert_byte_equal(
        "besar_add",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(besar(\"100\") + besar(\"200\"));\n\
            cetakln(besar(\"4294967295\") + besar(\"1\"));\n\
            cetakln(besar(\"99999999999999999999\") + besar(\"1\"));\n\
            cetakln(besar(\"123456789012345678901234567890\") + besar(\"987654321098765432109876543210\"));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_besar_sub() {
    // includes a negative result (-100), zero, and a 3-limb -> 2-limb borrow.
    assert_byte_equal(
        "besar_sub",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(besar(\"300\") - besar(\"100\"));\n\
            cetakln(besar(\"100\") - besar(\"200\"));\n\
            cetakln(besar(\"100\") - besar(\"100\"));\n\
            cetakln(besar(\"18446744073709551616\") - besar(\"1\"));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_besar_addsub_chain_and_negcmp() {
    // let-bound arithmetic propagates BigInt; negative intermediates feed both
    // add/sub and bi_cmp's signed paths.
    assert_byte_equal(
        "besar_chain",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            biar a = besar(\"99999999999999999999\");\n\
            biar b = a + a;\n\
            cetakln(b);\n\
            cetakln((besar(\"0\") - besar(\"500\")) + besar(\"200\"));\n\
            kalau (besar(\"0\") - besar(\"5\")) < besar(\"3\") { cetak(1) } lain { cetak(0) }\n\
            kalau (besar(\"0\") - besar(\"5\")) < (besar(\"0\") - besar(\"3\")) { cetak(1) } lain { cetak(0) }\n\
            kalau (besar(\"0\") - besar(\"5\")) > (besar(\"0\") - besar(\"3\")) { cetak(1) } lain { cetak(0) }\n\
            pulang 0\n\
        }",
    );
}

// ── W2.3: BigInt multiply (bi_mul) ───────────────────────────────────────────
// Schoolbook limb multiply; must match the C backend exactly, including the
// >64-bit headline square, max-limb carries, cross-size operands, sign (XOR),
// and zero (normalized to +0). Divide/modulo still fail closed.

#[test]
fn diff_besar_mul() {
    assert_byte_equal(
        "besar_mul",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(besar(\"12\") * besar(\"12\"));\n\
            cetakln(besar(\"99999999999999999999\") * besar(\"99999999999999999999\"));\n\
            cetakln(besar(\"4294967295\") * besar(\"4294967295\"));\n\
            cetakln(besar(\"7\") * besar(\"18446744073709551616\"));\n\
            cetakln((besar(\"0\") - besar(\"5\")) * besar(\"3\"));\n\
            cetakln((besar(\"0\") - besar(\"5\")) * (besar(\"0\") - besar(\"3\")));\n\
            cetakln(besar(\"0\") * besar(\"12345\"));\n\
            cetakln(besar(\"999999999999\") * besar(\"0\"));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_besar_mul_square_let() {
    // 30-digit squared (58-digit result) through a let binding.
    assert_byte_equal(
        "besar_mul_sq",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            biar a = besar(\"123456789012345678901234567890\");\n\
            cetakln(a * a);\n\
            pulang 0\n\
        }",
    );
}

// ── W2.4: BigInt truncating divmod (bi_divmod) ───────────────────────────────
// `/` and `%` route through bi_divmod; must match the C backend exactly —
// truncating toward zero, remainder taking the dividend's sign, the `a<b` short
// path, exact division, and large multi-limb quotients.
// (00_basics/bigint.rii also exercises a/b + a%b in the corpus differential.)

#[test]
fn diff_besar_divmod() {
    assert_byte_equal(
        "besar_divmod",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(besar(\"100\") / besar(\"7\"));\n\
            cetakln(besar(\"100\") % besar(\"7\"));\n\
            cetakln(besar(\"99999999999999999999\") / besar(\"12345678901234567890\"));\n\
            cetakln(besar(\"99999999999999999999\") % besar(\"12345678901234567890\"));\n\
            cetakln(besar(\"7\") / besar(\"100\"));\n\
            cetakln(besar(\"7\") % besar(\"100\"));\n\
            cetakln(besar(\"100\") / besar(\"4\"));\n\
            cetakln(besar(\"100\") % besar(\"4\"));\n\
            cetakln(besar(\"123456789012345678901234567890\") / besar(\"987654321\"));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_besar_divmod_negative() {
    // truncating toward zero; remainder takes the dividend's sign.
    assert_byte_equal(
        "besar_divmod_neg",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln((besar(\"0\") - besar(\"100\")) / besar(\"7\"));\n\
            cetakln((besar(\"0\") - besar(\"100\")) % besar(\"7\"));\n\
            cetakln(besar(\"100\") / (besar(\"0\") - besar(\"7\")));\n\
            cetakln((besar(\"0\") - besar(\"100\")) / (besar(\"0\") - besar(\"7\")));\n\
            pulang 0\n\
        }",
    );
}

// ── W3.1a: Decimal (perpuluhan) construction + display ───────────────────────
// `perpuluhan("...")` parses a decimal into a [scale][mantissa] record and
// renders it back, preserving scale (trailing zeros) and sign — byte-identical
// to the C backend. Decimal arithmetic still fails closed.

#[test]
fn diff_perpuluhan_display() {
    assert_byte_equal(
        "perpuluhan_display",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(perpuluhan(\"3.14\"));\n\
            cetakln(perpuluhan(\"0.001\"));\n\
            cetakln(perpuluhan(\"-3.14\"));\n\
            cetakln(perpuluhan(\"7\"));\n\
            cetakln(perpuluhan(\"3.140\"));\n\
            cetakln(perpuluhan(\"0.00\"));\n\
            cetakln(perpuluhan(\".5\"));\n\
            cetakln(perpuluhan(\"100.00\"));\n\
            cetakln(perpuluhan(\"-0.5\"));\n\
            cetakln(perpuluhan(\"12345.6789\"));\n\
            pulang 0\n\
        }",
    );
}

// ── W3.1b: Decimal arithmetic (dec_addsub / dec_mul / dec_div / dec_cmp) ─────
// Exact scale-aligned +/-, exact * (scales add), / rounded half-to-even to 34
// places then trailing-zero-stripped, and value-based comparison — all must
// match the C backend exactly. (00_basics/decimal.rii also exercises these in
// the corpus differential.)

#[test]
fn diff_perpuluhan_arith() {
    assert_byte_equal(
        "perpuluhan_arith",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(perpuluhan(\"0.1\") + perpuluhan(\"0.2\"));\n\
            cetakln(perpuluhan(\"19.99\") * perpuluhan(\"3\"));\n\
            cetakln(perpuluhan(\"5\") - perpuluhan(\"0.01\"));\n\
            cetakln(perpuluhan(\"0.1\") - perpuluhan(\"0.3\"));\n\
            cetakln(perpuluhan(\"1.5\") * perpuluhan(\"1.5\"));\n\
            biar a = perpuluhan(\"100.001\");\n\
            biar b = a + perpuluhan(\"0.999\");\n\
            cetakln(b * perpuluhan(\"2\"));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_perpuluhan_div() {
    // exact (0.25), repeating to 34 places (1/3), rounded last digit (2/3),
    // trailing-zero strip (10/4 = 2.5), negative quotient.
    assert_byte_equal(
        "perpuluhan_div",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(perpuluhan(\"1\") / perpuluhan(\"4\"));\n\
            cetakln(perpuluhan(\"1\") / perpuluhan(\"3\"));\n\
            cetakln(perpuluhan(\"2\") / perpuluhan(\"3\"));\n\
            cetakln(perpuluhan(\"10\") / perpuluhan(\"4\"));\n\
            cetakln((perpuluhan(\"0\") - perpuluhan(\"1\")) / perpuluhan(\"3\"));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_perpuluhan_cmp_and_ties() {
    // value-based compare (3.14 == 3.140) and half-to-even ties at the 34th
    // place: 5e-35 rounds to even (0); 15e-35 has an odd quotient and bumps.
    assert_byte_equal(
        "perpuluhan_cmp_ties",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            kalau perpuluhan(\"3.14\") == perpuluhan(\"3.140\") { cetak(1) } lain { cetak(0) }\n\
            kalau perpuluhan(\"0.5\") < perpuluhan(\"0.75\") { cetak(1) } lain { cetak(0) }\n\
            kalau (perpuluhan(\"0\") - perpuluhan(\"0.1\")) < perpuluhan(\"0.05\") { cetak(1) } lain { cetak(0) }\n\
            kalau perpuluhan(\"2.50\") >= perpuluhan(\"2.5\") { cetak(1) } lain { cetak(0) }\n\
            cetakln(perpuluhan(\"0.00000000000000000000000000000000005\") / perpuluhan(\"1\"));\n\
            cetakln(perpuluhan(\"0.00000000000000000000000000000000015\") / perpuluhan(\"1\"));\n\
            pulang 0\n\
        }",
    );
}

// ── W3.2: fixed-point wang/titik_tetap (fix_mul / fix_div / fix_titik_tetap) ─
// Fixed shares the Decimal record and reuses its parse/display/add/sub/compare;
// mul/div round half-to-even BACK to max(scale) (10.00/3 = 3.33, not 3.333…)
// and display preserves trailing zeros (the money contract). titik_tetap takes
// (literal, scale) and rescales half-to-even. All byte-identical to C.
// (00_basics/fixed.rii joins the corpus differential at W3.3 when qmn lands.)

#[test]
fn diff_wang_display_addsub() {
    assert_byte_equal(
        "wang_display_addsub",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(wang(\"19.99\"));\n\
            cetakln(wang(\"100.00\"));\n\
            cetakln(wang(\"1.10\") + wang(\"2.20\"));\n\
            cetakln(wang(\"5.00\") - wang(\"0.01\"));\n\
            cetakln(wang(\"0.00\") - wang(\"7.25\"));\n\
            kalau wang(\"3.30\") == wang(\"3.3\") { cetak(1) } lain { cetak(0) }\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_wang_mul_div_round_to_scale() {
    // mul: 1.55*1.55 = 2.4025 -> 2.40 (rounded back to scale 2);
    // div: 10.00/3 = 3.33 (scale preserved, not extended);
    // banker's at the kept digit: 0.5*0.5 = 0.25 -> 0.2 (round to even).
    assert_byte_equal(
        "wang_mul_div",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(wang(\"1.55\") * wang(\"1.55\"));\n\
            cetakln(wang(\"19.99\") * wang(\"3\"));\n\
            cetakln(wang(\"10.00\") / wang(\"3\"));\n\
            cetakln(wang(\"100.00\") / wang(\"3\"));\n\
            cetakln(wang(\"0.5\") * wang(\"0.5\"));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_titik_tetap_rescale() {
    // explicit-scale constructor: round half-to-even when shrinking
    // (3.145 -> 3.14, 3.155 -> 3.16), zero-pad when growing (5 -> 5.000).
    assert_byte_equal(
        "titik_tetap",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(titik_tetap((\"3.14159\", 2)));\n\
            cetakln(titik_tetap((\"3.145\", 2)));\n\
            cetakln(titik_tetap((\"3.155\", 2)));\n\
            cetakln(titik_tetap((\"5\", 3)));\n\
            pulang 0\n\
        }",
    );
}

// ── W3.3: Q-format qmn (qmn_parse / qmn_to_str / qmn_* arithmetic) ───────────
// A FixedBin is raw/2^frac_bits over a wrapping i64 word; construction/display
// convert decimal<->binary exactly (round half-to-even to the nearest
// representable), arithmetic is exact in BigInt then wrapped. All byte-identical
// to C. (00_basics/fixed.rii exercises wang+titik_tetap+qmn in the corpus.)

#[test]
fn diff_qmn_construct_display() {
    // exact binary fractions; 0.1 -> nearest representable at 8 bits
    // (0.1015625); integers; negatives; Q32 precision.
    assert_byte_equal(
        "qmn_construct",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(qmn((\"0.5\", 8)));\n\
            cetakln(qmn((\"0.1\", 8)));\n\
            cetakln(qmn((\"7\", 4)));\n\
            cetakln(qmn((\"-2.5\", 8)));\n\
            cetakln(qmn((\"3.14159265\", 32)));\n\
            pulang 0\n\
        }",
    );
}

#[test]
fn diff_qmn_arith_cmp() {
    // exact add (0.75), negative sub, round-he mul/div, mixed frac_bits
    // alignment, value-based compare across widths.
    assert_byte_equal(
        "qmn_arith",
        "fungsi utama() -> Nombor kesan Sistem {\n\
            cetakln(qmn((\"0.5\", 8)) + qmn((\"0.25\", 8)));\n\
            cetakln(qmn((\"0.25\", 8)) - qmn((\"0.5\", 8)));\n\
            cetakln(qmn((\"1.5\", 16)) * qmn((\"2.5\", 16)));\n\
            cetakln(qmn((\"1\", 16)) / qmn((\"3\", 16)));\n\
            cetakln(qmn((\"0.5\", 8)) + qmn((\"0.25\", 16)));\n\
            kalau qmn((\"0.5\", 8)) == qmn((\"0.5\", 16)) { cetak(1) } lain { cetak(0) }\n\
            kalau qmn((\"0.25\", 8)) < qmn((\"0.5\", 8)) { cetak(1) } lain { cetak(0) }\n\
            pulang 0\n\
        }",
    );
}
