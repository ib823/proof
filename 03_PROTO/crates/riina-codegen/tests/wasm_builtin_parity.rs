// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The WASM backend must FAIL CLOSED on builtins it does not implement
//! (master plan REQ-78), and `WASM_SUPPORTED_BUILTINS` must stay in step with
//! what the emitter actually handles (REQ-70's Backend column depends on it).
//!
//! # The bug this pins
//!
//! The WASM emitter's builtin dispatch ended in:
//!
//! ```text
//! } else {
//!     // Other builtins: push 0 (stub)
//!     wasm_i64c(code, 0);
//! }
//! ```
//!
//! That did not fail — it silently produced a WRONG ANSWER, while the
//! interpreter and the C backend agreed on the right one:
//!
//! | call | interp | C | WASM (before) |
//! |---|---|---|---|
//! | `teks_huruf_besar("halo")` | `HALO` | `HALO` | `halo` |
//! | `teks_ulang(("ab", 3))` | `ababab` | `ababab` | `ab` |
//! | `panjang("abcd")` | `4` | `4` | `abcd` |
//!
//! A backend that quietly disagrees with the others is worse than one that
//! refuses, so it now refuses.

use riina_codegen::{
    backend_for_target, codegen_supports_builtin, wasm_supports_builtin, Target,
    WASM_SUPPORTED_BUILTINS,
};
use riina_parser::Parser;
use riina_typechecker::check_program;

/// Lower `source` and emit for `target`; `Err` carries the codegen diagnostic.
fn emit_for(source: &str, target: Target) -> Result<(), String> {
    let mut parser = Parser::new(source);
    let program = parser.parse_program().map_err(|e| e.to_string())?;
    let (expr, _, _) = check_program(&program).map_err(|e| e.to_string())?;
    let ir = riina_codegen::compile(&expr).map_err(|e| format!("{e:?}"))?;
    backend_for_target(target)
        .emit(&ir)
        .map(|_| ())
        .map_err(|e| format!("{e:?}"))
}

fn print_program(call: &str) -> String {
    format!("fungsi utama() -> Nombor kesan Tulis {{ cetakln({call}); 0 }}\n")
}

/// A builtin the WASM backend does not implement must be REFUSED, not stubbed.
#[test]
fn unsupported_builtin_fails_closed_on_wasm() {
    let src = print_program("teks_huruf_besar(\"halo\")");

    // It compiles natively — this is a backend gap, not a broken program.
    emit_for(&src, Target::Native).expect("native must still compile");

    let err = emit_for(&src, Target::Wasm32).expect_err("WASM must refuse, not stub");
    assert!(
        err.contains("teks_huruf_besar"),
        "error should name the builtin: {err}"
    );
    assert!(
        err.contains("REQ-78"),
        "error should point at the tracking REQ: {err}"
    );
}

/// Several string/list builtins that used to silently return their argument.
#[test]
fn previously_stubbed_builtins_all_fail_closed() {
    for call in [
        "teks_huruf_besar(\"halo\")",
        "teks_huruf_kecil(\"HALO\")",
        "teks_ulang((\"ab\", 3))",
        "teks_potong(\"  ab  \")",
        "ke_teks(panjang(\"abcd\"))",
    ] {
        let src = print_program(call);
        assert!(
            emit_for(&src, Target::Wasm32).is_err(),
            "WASM silently stubbed `{call}` instead of refusing"
        );
    }
}

/// Everything `WASM_SUPPORTED_BUILTINS` advertises must genuinely emit. This is
/// what keeps the list (and therefore STDLIB.md's Backend column) honest as the
/// emitter changes.
#[test]
fn wasm_supported_builtins_all_compile() {
    // One well-typed call per advertised builtin.
    let calls: &[(&str, &str)] = &[
        ("cetakln", "fungsi utama() -> Nombor kesan Tulis { cetakln(\"a\"); 0 }\n"),
        ("cetak", "fungsi utama() -> Nombor kesan Tulis { cetak(\"a\"); 0 }\n"),
        ("ke_teks", &print_program("ke_teks(42)")),
        ("nombor_ke_teks", &print_program("nombor_ke_teks(42)")),
        ("gabung_teks", &print_program("gabung_teks((\"a\", \"b\"))")),
        ("besar", &print_program("ke_teks(besar(\"123\"))")),
        ("perpuluhan", &print_program("ke_teks(perpuluhan(\"1.5\"))")),
        ("wang", &print_program("ke_teks(wang(\"1.50\"))")),
        ("titik_tetap", &print_program("ke_teks(titik_tetap((\"1.5\", 8)))")),
        ("qmn", &print_program("ke_teks(qmn((\"1.5\", 8)))")),
    ];

    // Every advertised name must be exercised here, so adding one to the list
    // without a case fails this test rather than going unchecked.
    for name in WASM_SUPPORTED_BUILTINS {
        assert!(
            calls.iter().any(|(n, _)| n == name),
            "`{name}` is advertised as WASM-supported but has no case here"
        );
    }

    for (name, src) in calls {
        emit_for(src, Target::Wasm32)
            .unwrap_or_else(|e| panic!("`{name}` is advertised as WASM-supported but failed: {e}"));
    }
}

/// The two queries must agree with the definitions they document: WASM support
/// implies C support, and neither claims anything about an unknown name.
#[test]
fn support_queries_are_consistent() {
    for name in WASM_SUPPORTED_BUILTINS {
        assert!(
            wasm_supports_builtin(name),
            "`{name}` is in the list but wasm_supports_builtin says no"
        );
        assert!(
            codegen_supports_builtin(name),
            "`{name}` runs on WASM but codegen_supports_builtin says it does not compile"
        );
    }

    // Native-only: compiles to C, refused by WASM.
    assert!(codegen_supports_builtin("teks_huruf_besar"));
    assert!(!wasm_supports_builtin("teks_huruf_besar"));

    // Interpreter-only: neither.
    assert!(!codegen_supports_builtin("jaring_dengar"));
    assert!(!wasm_supports_builtin("jaring_dengar"));

    // Unknown names are not claimed by either.
    assert!(!codegen_supports_builtin("bukan_builtin_langsung"));
    assert!(!wasm_supports_builtin("bukan_builtin_langsung"));
}

/// English spellings resolve to the same canonical builtin.
#[test]
fn english_spellings_resolve_identically() {
    assert!(wasm_supports_builtin("println"));
    assert!(wasm_supports_builtin("concat"));
    assert_eq!(
        wasm_supports_builtin("gabung_teks"),
        wasm_supports_builtin("concat")
    );
}
