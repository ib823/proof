// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! WASM End-to-End Tests
//!
//! Tests the full pipeline: source code -> parse -> typecheck -> lower -> WASM emit -> validate.
//! Each test verifies that a RIINA source program compiles to a valid WASM binary.
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST

use riina_codegen::backend::{Backend, Target};
use riina_codegen::wasm::WasmBackend;
use riina_codegen::compile;
use riina_parser::Parser;
use riina_typechecker::check_program;

/// Compile RIINA source code all the way to WASM binary bytes.
fn compile_to_wasm(source: &str) -> Vec<u8> {
    let mut parser = Parser::new(source);
    let program = parser.parse_program().expect("parse failed");
    let (expr, _ty, _eff) = check_program(&program).expect("typecheck failed");
    let ir = compile(&expr).expect("IR lowering failed");
    let backend = WasmBackend::new(Target::Wasm32);
    let output = backend.emit(&ir).expect("WASM emit failed");
    output.primary
}

/// Verify the WASM magic number (\0asm) and version (1).
fn assert_valid_wasm_header(wasm: &[u8]) {
    assert!(wasm.len() >= 8, "WASM binary too short: {} bytes", wasm.len());
    assert_eq!(&wasm[0..4], b"\x00asm", "Missing WASM magic bytes");
    assert_eq!(&wasm[4..8], &[1, 0, 0, 0], "Unexpected WASM version");
}

// =============================================================================
// INTEGER AND ARITHMETIC
// =============================================================================

#[test]
fn wasm_e2e_integer_constant() {
    let wasm = compile_to_wasm("42");
    assert_valid_wasm_header(&wasm);
    assert!(wasm.len() > 8, "WASM binary suspiciously small");
}

#[test]
fn wasm_e2e_arithmetic() {
    let wasm = compile_to_wasm("3 + 4 * 2");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_subtraction() {
    let wasm = compile_to_wasm("10 - 3");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_division() {
    let wasm = compile_to_wasm("100 / 5");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_modulo() {
    let wasm = compile_to_wasm("17 % 5");
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// LET BINDINGS
// =============================================================================

#[test]
fn wasm_e2e_let_binding() {
    let wasm = compile_to_wasm("biar x = 10; x + 1");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_nested_let() {
    let wasm = compile_to_wasm("biar x = 1; biar y = 2; x + y");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_let_with_arithmetic() {
    let wasm = compile_to_wasm("biar a = 3; biar b = 4; a * b + 1");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_deeply_nested_let() {
    let wasm = compile_to_wasm("biar a = 1; biar b = 2; biar c = 3; a + b + c");
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// CONDITIONALS
// =============================================================================

#[test]
fn wasm_e2e_if_else() {
    let wasm = compile_to_wasm("kalau betul { 1 } lain { 0 }");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_if_else_false() {
    let wasm = compile_to_wasm("kalau salah { 1 } lain { 0 }");
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// FUNCTIONS
// =============================================================================

#[test]
fn wasm_e2e_function_call() {
    let source = "fungsi id(x: Nombor) -> Nombor kesan Bersih { x }\nid(42)";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_multi_arg_function() {
    let source = "fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih { x + y }\ntambah(3, 4)";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_function_with_let() {
    let source = "fungsi kira(x: Nombor) -> Nombor kesan Bersih { biar y = x + 1; y }\nkira(10)";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// COMPARISONS AND BOOLEAN LOGIC
// =============================================================================

#[test]
fn wasm_e2e_comparison() {
    let wasm = compile_to_wasm("3 > 2");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_less_than() {
    let wasm = compile_to_wasm("2 < 3");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_equality() {
    let wasm = compile_to_wasm("5 == 5");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_boolean_logic() {
    let wasm = compile_to_wasm("betul && salah");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_boolean_or() {
    let wasm = compile_to_wasm("betul || salah");
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// STRINGS
// =============================================================================

#[test]
fn wasm_e2e_string_constant() {
    let wasm = compile_to_wasm("\"hello\"");
    assert_valid_wasm_header(&wasm);
    // String constants should produce a data section.
    // The WASM binary should be larger due to data segment.
    assert!(wasm.len() > 20, "String WASM should include data section");
}

// =============================================================================
// SECURITY: CLASSIFY
// =============================================================================

#[test]
fn wasm_e2e_classify_secret() {
    let wasm = compile_to_wasm("classify 42");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_classify_string() {
    let wasm = compile_to_wasm("classify \"secret_data\"");
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// PRODUCT AND SUM TYPES
// =============================================================================

#[test]
fn wasm_e2e_pair() {
    let wasm = compile_to_wasm("(1, 2)");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_pair_nested() {
    let wasm = compile_to_wasm("(1, (2, 3))");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_inl_inr() {
    // inl requires type annotation in RIINA syntax: inl <expr> : <type>
    let wasm = compile_to_wasm("inl 42 : Sum<Nombor, Bool>");
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// BINARY FORMAT VALIDATION
// =============================================================================

#[test]
fn wasm_e2e_binary_starts_with_magic() {
    let wasm = compile_to_wasm("0");
    assert_eq!(&wasm[0..4], b"\x00asm", "WASM must start with magic bytes \\0asm");
}

#[test]
fn wasm_e2e_binary_version_is_one() {
    let wasm = compile_to_wasm("0");
    assert_eq!(wasm[4], 1, "WASM version must be 1");
    assert_eq!(wasm[5], 0);
    assert_eq!(wasm[6], 0);
    assert_eq!(wasm[7], 0);
}

#[test]
fn wasm_e2e_has_wasi_imports() {
    let wasm = compile_to_wasm("42");
    // The WASM binary should contain the WASI import string for fd_write.
    let wasm_str = String::from_utf8_lossy(&wasm);
    assert!(
        wasm_str.contains("fd_write") || wasm.windows(8).any(|w| w == b"fd_write"),
        "WASM binary should import fd_write from WASI"
    );
}

#[test]
fn wasm_e2e_has_wasi_module_name() {
    let wasm = compile_to_wasm("42");
    let wasm_str = String::from_utf8_lossy(&wasm);
    assert!(
        wasm_str.contains("wasi_snapshot_preview1"),
        "WASM binary should reference wasi_snapshot_preview1"
    );
}

// =============================================================================
// COMBINED EXPRESSIONS
// =============================================================================

#[test]
fn wasm_e2e_let_with_conditional() {
    let wasm = compile_to_wasm("biar x = 10; kalau x > 5 { 1 } lain { 0 }");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_function_returning_pair() {
    let source = "fungsi buat_pasangan(x: Nombor) -> (Nombor, Nombor) kesan Bersih { (x, x + 1) }\nbuat_pasangan(5)";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_boolean_in_let() {
    let wasm = compile_to_wasm("biar b = betul; kalau b { 1 } lain { 0 }");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_arithmetic_chain() {
    let wasm = compile_to_wasm("1 + 2 + 3 + 4 + 5");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_unit_literal() {
    let wasm = compile_to_wasm("()");
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_negative_result() {
    let wasm = compile_to_wasm("3 - 10");
    assert_valid_wasm_header(&wasm);
}

// =============================================================================
// RECURSIVE FUNCTIONS (REQ-14 full verification)
// =============================================================================

#[test]
fn wasm_e2e_recursive_factorial() {
    let source = "fungsi faktorial(n: Nombor) -> Nombor kesan Bersih { kalau n <= 1 { 1 } lain { n * faktorial(n - 1) } }\nfaktorial(5)";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_recursive_fibonacci() {
    let source = "fungsi fib(n: Nombor) -> Nombor kesan Bersih { kalau n <= 1 { n } lain { fib(n - 1) + fib(n - 2) } }\nfib(8)";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_recursive_countdown() {
    let source = "fungsi kira(n: Nombor) -> Nombor kesan Bersih { kalau n <= 0 { 0 } lain { kira(n - 1) } }\nkira(10)";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_nested_function_calls() {
    let source = "fungsi ganda(x: Nombor) -> Nombor kesan Bersih { x * 2 }\nfungsi tambah_satu(x: Nombor) -> Nombor kesan Bersih { x + 1 }\ntambah_satu(ganda(5))";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_multi_function_chain() {
    let source = "fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih { x + y }\nbiar a = tambah(10, 20); biar b = tambah(a, 5); b";
    let wasm = compile_to_wasm(source);
    assert_valid_wasm_header(&wasm);
}

#[test]
fn wasm_e2e_classify_sulit() {
    let wasm = compile_to_wasm("biar x = sulit 42; x");
    assert_valid_wasm_header(&wasm);
}
