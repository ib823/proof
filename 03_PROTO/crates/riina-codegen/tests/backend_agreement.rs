// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! C-backend correctness fixes found while working REQ-80 (part of REQ-70's
//! family routing).
//!
//! Each test pins a case where the C backend disagreed with the interpreter.
//! Two of them were **silent wrong answers**, which is the worst failure mode:
//! the program ran, produced a plausible value, and was wrong.
//!
//! | bug | interpreter | C before | C after |
//! |---|---|---|---|
//! | list/bigint tag collision | type error | **SIGSEGV** | clean abort |
//! | `+` on two lists | concatenates | SIGSEGV | concatenates |
//! | user function shadowing a builtin | user's function | **the builtin** | user's function |
//! | `x.f()` method syntax | type error | evaluated `x`, then aborted | refused at compile time |
//!
//! These run the emitter directly rather than the `riinac` binary, so they stay
//! fast and are unaffected by process/temp-file concerns.

use riina_codegen::{backend_for_target, Target};
use riina_parser::Parser;
use riina_typechecker::check_program;

/// Lower and emit `source` for the native target; `Err` carries the diagnostic.
fn emit_native(source: &str) -> Result<String, String> {
    let mut parser = Parser::new(source);
    let program = parser.parse_program().map_err(|e| e.to_string())?;
    let (expr, _, _) = check_program(&program).map_err(|e| e.to_string())?;
    let ir = riina_codegen::compile(&expr).map_err(|e| e.to_string())?;
    let out = backend_for_target(Target::Native)
        .emit(&ir)
        .map_err(|e| e.to_string())?;
    String::from_utf8(out.primary).map_err(|e| e.to_string())
}

/// Lower `source` to IR and render it; `Err` carries the diagnostic.
///
/// Call routing has to be read off the IR, not the C: the emitted prelude
/// DEFINES every builtin unconditionally, so `riina_builtin_kuasa(` appears in
/// the output whether or not anything calls it.
fn lower_to_ir(source: &str) -> Result<String, String> {
    let mut parser = Parser::new(source);
    let program = parser.parse_program().map_err(|e| e.to_string())?;
    let (expr, _, _) = check_program(&program).map_err(|e| e.to_string())?;
    riina_codegen::compile(&expr)
        .map(|ir| ir.to_string())
        .map_err(|e| e.to_string())
}

/// REQ-80: the collection tags must not collide with `riina_tag_t`.
///
/// `RIINA_TAG_LIST` was 12, exactly `RIINA_TAG_BIGINT` (and MAP/DECIMAL,
/// SET/FIXED). A list therefore reached `riina_bigint_add`, which read it
/// through the bigint union member and SEGFAULTED; `senarai_panjang(besar(…))`
/// segfaulted the other way. Both now fail cleanly instead.
#[test]
fn collection_tags_do_not_collide_with_the_tag_enum() {
    let c = emit_native("fungsi utama() -> Nombor kesan Tulis { cetak(1); 0 }\n")
        .expect("emits");

    // The enum tops out at FIXEDBIN = 15; collection tags must start above it.
    assert!(
        c.contains("RIINA_TAG_FIXEDBIN = 15"),
        "tag enum shape changed; re-check the collection tag range"
    );
    assert!(
        c.contains("#define RIINA_TAG_LIST 16"),
        "RIINA_TAG_LIST must not collide with the tag enum"
    );
    assert!(
        c.contains("#define RIINA_TAG_MAP 17") && c.contains("#define RIINA_TAG_SET 18"),
        "MAP/SET tags must not collide with DECIMAL/FIXED"
    );
    // And the emitted C carries a compile-time guard so this cannot regress.
    assert!(
        c.contains("_Static_assert(RIINA_TAG_FIXEDBIN < RIINA_TAG_LIST"),
        "the emitted C should statically assert the tag ranges stay disjoint"
    );
}

/// REQ-80: `+` on two lists concatenates, matching the interpreter. The C
/// backend had no list case, so `[1] + [2,3]` fell through to the bigint branch
/// (see the tag collision above) and crashed.
#[test]
fn list_concatenation_is_emitted() {
    let c = emit_native(
        "fungsi utama() -> Nombor kesan Tulis { cetak(senarai_panjang([1] + [2, 3])); 0 }\n",
    )
    .expect("emits");
    assert!(
        c.contains("riina_list_concat"),
        "list `+` must route to the concatenation helper"
    );
    assert!(
        c.contains("if (a->tag == RIINA_TAG_LIST && b->tag == RIINA_TAG_LIST)"),
        "binop_add must dispatch lists before the numeric-tower branches"
    );
}

/// REQ-80: a user-defined function SHADOWS a builtin of the same name.
///
/// The `App` arm consulted `builtin_canonical` without checking the
/// environment, so a program defining its own `kuasa` had calls routed to the
/// builtin — which then failed with "kuasa expects pair". The `Var` arm always
/// checked the environment first; this makes `App` match.
#[test]
fn user_definition_shadows_a_builtin_of_the_same_name() {
    let ir = lower_to_ir(
        "fungsi kuasa(a: Nombor, b: Nombor) -> Nombor kesan Bersih { a + b }\n\
         fungsi utama() -> Nombor kesan Tulis { cetak(kuasa(2, 8)); 0 }\n",
    )
    .expect("lowers");
    assert!(
        !ir.contains("builtin_call \"kuasa\""),
        "the user's `kuasa` must be called, not the builtin:\n{ir}"
    );
}

/// A builtin that is NOT shadowed still routes to the builtin.
#[test]
fn unshadowed_builtin_still_routes_to_the_builtin() {
    let ir = lower_to_ir("fungsi utama() -> Nombor kesan Tulis { cetak(kuasa((2, 8))); 0 }\n")
        .expect("lowers");
    assert!(
        ir.contains("builtin_call \"kuasa\""),
        "an unshadowed builtin must still be used:\n{ir}"
    );
}

/// REQ-80: an unresolvable field access is REFUSED.
///
/// It used to lower to the BASE expression, silently turning `t.panjang()` into
/// `t`; the C backend then aborted with `RIINA: call on non-closure` when the
/// result was applied, while the interpreter gave a clean type error. RIINA has
/// no methods, so the error says so.
#[test]
fn method_call_syntax_is_refused_not_reinterpreted() {
    let err = emit_native(
        "fungsi utama() -> Nombor kesan Tulis { biar t = \"abc\"; cetak(t.panjang()); 0 }\n",
    )
    .expect_err("must be refused");
    assert!(err.contains("panjang"), "error should name the field: {err}");
    assert!(
        err.contains("REQ-80"),
        "error should point at the tracking REQ: {err}"
    );
    assert!(
        err.contains("no methods"),
        "error should explain why: {err}"
    );
}

/// A REAL record field access must still lower — the fix must not reject
/// legitimate `.field` projection on a known struct layout.
#[test]
fn record_field_access_still_lowers() {
    emit_native(
        "jenis Titik { x: Nombor, y: Nombor }\n\
         fungsi utama() -> Nombor kesan Tulis {\n\
         \x20   biar p = Titik { x: 3, y: 4 };\n\
         \x20   cetak(p.x + p.y);\n\
         \x20   0\n\
         }\n",
    )
    .expect("record field access must still compile");
}

/// REQ-80 REMAINING: early return is still lowered as a plain value, so this
/// program compiles but returns the WRONG answer under C (99 instead of 1).
///
/// This test documents the open defect rather than asserting the bug is fixed:
/// it fails the day someone implements early return, which is exactly when it
/// should be revisited. See the `Expr::Return` arm in `lower.rs` for why the
/// working implementation was reverted (it broke the WASM relooper).
#[test]
fn early_return_is_still_unimplemented_in_the_ir() {
    let c = emit_native(
        "fungsi f(n: Nombor) -> Nombor kesan Bersih { kalau n <= 1 { pulang 1; } pulang 99; }\n\
         fungsi utama() -> Nombor kesan Tulis { cetak(f(0)); 0 }\n",
    )
    .expect("emits today");
    // No early-exit terminator is generated: the function has a single return
    // path. When early return lands, this assertion should be REPLACED by a
    // behavioural check that `f(0) == 1`.
    assert!(
        !c.contains("/* early return */"),
        "early return appears implemented — replace this test with a behavioural \
         assertion that f(0) == 1 (REQ-80)"
    );
}
