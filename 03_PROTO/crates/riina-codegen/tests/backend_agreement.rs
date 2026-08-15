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

/// REQ-80: `pulang` inside a parameterised function really terminates its
/// block.
///
/// It used to lower to just the inner value, discarding the control flow, so
/// `kalau n <= 1 { pulang 1; } pulang 99;` fell through to 99 and a recursive
/// function never reached its base case (`recursion.rii` SIGSEGV'd on unbounded
/// recursion). Behaviour is pinned by the differential in
/// `riinac/tests/early_return_differential.rs`; this checks the IR shape that
/// makes it work, which is where a regression would first show up.
#[test]
fn early_return_terminates_its_block() {
    let ir = lower_to_ir(
        "fungsi f(n: Nombor) -> Nombor kesan Bersih { kalau n <= 1 { pulang 1; } pulang 99; }\n\
         fungsi utama() -> Nombor kesan Tulis { cetak(f(0)); 0 }\n",
    )
    .expect("lowers");
    // Two `ret` terminators inside `f`: the early one and the fall-through.
    // With the bug there was exactly one (the function's single exit).
    let rets = ir.matches("return ").count();
    assert!(
        rets >= 2,
        "early return did not terminate its own block ({rets} ret terminators):\n{ir}"
    );
}

/// REQ-68: a `pulang` in a ZERO-PARAMETER function is honoured too.
///
/// It was not, and could not be: `desugar_function` with no params returned the
/// body unchanged, so a zero-arg `fungsi` never became an IR function and its
/// body was spliced into the definition site — emitting a real return there
/// returned from the CALLER (measured: `pulang 42` in a zero-arg helper made
/// `utama` itself return 42 and skip its own output). Zero-parameter functions
/// now get a synthesised `()` parameter, so they are functions like any other.
#[test]
fn early_return_in_a_zero_arg_function_is_honoured() {
    let ir = lower_to_ir(
        "fungsi ambil() -> Nombor kesan Bersih { kalau 1 > 0 { pulang 42; } pulang 7; }\n\
         fungsi utama() -> Nombor kesan Tulis { cetak(ambil()); 0 }\n",
    )
    .expect("lowers");
    // `ambil` is its own function with two exits (the early one and the
    // fall-through). With the old thunk model there was no function at all.
    assert!(
        ir.matches("return ").count() >= 3,
        "a zero-arg function should have its own early + fall-through returns:\n{ir}"
    );
}

/// REQ-68: a zero-parameter function is a real `Unit -> T` closure, so calling
/// it twice runs it twice — and never calling it runs it not at all.
///
/// The old thunk model ran the body ONCE when its binding was evaluated,
/// whether it was called or not, and BEFORE `utama`; the behavioural proof is
/// in `riinac/tests/zero_arg_function.rs`. This pins the IR shape: the call is
/// an application of a closure, not a reference to a precomputed value.
#[test]
fn zero_arg_function_lowers_to_a_closure_and_a_call() {
    let ir = lower_to_ir(
        "fungsi ambil() -> Nombor kesan Bersih { 42 }\n\
         fungsi utama() -> Nombor kesan Tulis { cetak(ambil()); cetak(ambil()); 0 }\n",
    )
    .expect("lowers");
    assert!(
        ir.contains("closure"),
        "a zero-arg function must lower to a closure:\n{ir}"
    );
    assert!(
        ir.matches("call ").count() >= 2,
        "two call sites must produce two calls, not one shared value:\n{ir}"
    );
}

// ── REQ-70: the net family routes in HALVES, on purpose ────────────────────

/// The plain TCP half and the whole HTTP codec must ROUTE, so `riinac build`
/// produces a real networked binary rather than failing on an unbound name.
#[test]
fn net_plain_and_http_halves_are_routed() {
    for name in [
        "jaring_sambung",
        "jaring_hantar",
        "jaring_terima",
        "jaring_tutup",
        "jaring_dengar",
        "jaring_alamat",
        "jaring_terima_sambungan",
        "jaring_tutup_dengar",
        "tls_dasar_ok",
        "http_hurai_kaedah",
        "http_hurai_laluan",
        "http_hurai_jasad",
        "http_hurai_kepala",
        "http_balas",
        "http_minta",
        // The English spellings must route identically — they are the same
        // builtin, and a program written in either surface must compile.
        "net_connect",
        "net_accept",
        "http_build_response",
    ] {
        assert!(
            riina_codegen::codegen_supports_builtin(name),
            "{name} must be routed to the C backend (REQ-70 family routing)"
        );
    }
}

/// The `jaring_tls_*` half must NOT route, and this is the precise statement of
/// why the family is only half-compiled.
///
/// The C backend has no `riina-tls`: no X25519, no HKDF-SHA384, no AES-256-GCM,
/// no RFC 8446 §7.1 key schedule, no raw-public-key authentication. Emitting
/// something *nearly* that is the one outcome worse than refusing — a program
/// would compile, appear to negotiate, and be weaker than the interpreter it
/// was tested against, with nothing in the type signature to say so. So these
/// names stay unbound at lowering and `riinac build` fails closed (REQ-78).
#[test]
fn net_tls_half_is_not_routed() {
    for name in [
        "jaring_tls_jabat",
        "jaring_tls_jabat_sah",
        "jaring_tls_identiti",
        "jaring_tls_percaya",
        "jaring_tls_disahkan",
        "jaring_tls_kunci",
        "jaring_tls_hantar",
        "jaring_tls_terima",
        "net_tls_handshake",
        "net_tls_send",
    ] {
        assert!(
            !riina_codegen::codegen_supports_builtin(name),
            "{name} must NOT lower — a C TLS that is not really riina-tls would \
             compile programs that look negotiated and are weaker than the \
             interpreter they were tested against"
        );
    }
}

/// WASI preview 1 has no listening sockets, so nothing in this family is
/// WASM-supported: every routed name is `native-only`, and `docs/api/STDLIB.md`
/// must be able to say so rather than claiming C-compiled implies WASM.
#[test]
fn net_family_is_native_only_never_wasm() {
    for name in [
        "jaring_sambung",
        "jaring_dengar",
        "jaring_terima_sambungan",
        "tls_dasar_ok",
        "http_balas",
        "http_minta",
    ] {
        assert!(
            riina_codegen::codegen_supports_builtin(name),
            "{name} must compile natively"
        );
        assert!(
            !riina_codegen::wasm_supports_builtin(name),
            "{name} must not claim WASM support — WASI preview 1 has no sockets"
        );
    }
}
