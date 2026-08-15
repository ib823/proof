//! Stdlib API reference generator + drift guard (Gate I).
//!
//! The reference at `docs/api/STDLIB.md` is GENERATED from the single source of
//! truth — the builtins `register_builtin_types` installs — so it cannot drift
//! from what the checker actually accepts. This test rebuilds the document in
//! memory and:
//!   * with `REGEN_STDLIB_DOC=1`, writes it to disk (the regenerate command);
//!   * otherwise, asserts the committed file is byte-identical (the drift guard
//!     that runs in CI / `cargo test`).
//!
//! Regenerate after changing the builtin table:
//!   REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc

use riina_codegen::{codegen_supports_builtin, wasm_supports_builtin};
use riina_fmt::format_ty;
use riina_typechecker::{register_builtin_types, Context};
use riina_types::{Effect, Ty};
use std::path::PathBuf;

/// Which backends implement a builtin (REQ-70 Backend column, REQ-78 split).
///
/// `codegen_supports_builtin` alone was not enough: it answers "does lowering
/// bind this?", which the C backend then implements — but the WASM backend
/// implements far fewer, and used to emit a silent stub for the rest. The doc
/// must not tell a reader that a native-only builtin runs on WASM.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Backend {
    /// Compiles to C and WASM.
    Wasm,
    /// Compiles to C; the WASM backend refuses it (fails closed).
    Native,
    /// Neither: `riinac run` only.
    Interp,
}

impl Backend {
    fn of(name: &str) -> Self {
        if wasm_supports_builtin(name) {
            Self::Wasm
        } else if codegen_supports_builtin(name) {
            Self::Native
        } else {
            Self::Interp
        }
    }

    fn cell(self) -> &'static str {
        match self {
            Self::Wasm => "compiled",
            Self::Native => "**native-only**",
            Self::Interp => "**interp-only**",
        }
    }
}

/// Effect label for grouping (Bahasa Melayu surface name + English).
fn effect_label(eff: Effect) -> &'static str {
    match eff {
        Effect::Pure => "Bersih (Pure)",
        Effect::Read => "Baca (Read)",
        Effect::Write => "Tulis (Write)",
        Effect::Mut => "Ubah (Mut)",
        Effect::Alloc => "Peruntuk (Alloc)",
        Effect::FileSystem => "SistemFail (FileSystem)",
        Effect::Network => "Rangkaian (Network)",
        Effect::NetworkSecure => "RangkaianSelamat (NetworkSecure)",
        Effect::Crypto => "Kripto (Crypto)",
        Effect::Random => "Rawak (Random)",
        Effect::System => "Sistem (System)",
        Effect::Time => "Masa (Time)",
        Effect::Process => "Proses (Process)",
        Effect::Panel => "Panel",
        Effect::Zirah => "Zirah",
        Effect::Benteng => "Benteng",
        Effect::Sandi => "Sandi",
        Effect::Menara => "Menara",
        Effect::Gapura => "Gapura",
    }
}

/// The effect a builtin performs (top-level `Fn` effect; non-functions are Pure
/// values/constants).
fn builtin_effect(ty: &Ty) -> Effect {
    match ty {
        Ty::Fn(_, _, eff) => *eff,
        _ => Effect::Pure,
    }
}

/// Build the Markdown reference from the live builtin registry.
fn generate() -> String {
    let ctx = register_builtin_types(&Context::new());

    // Collect (name, rendered-signature, effect, reaches-compiled-backends),
    // sorted for determinism. The 4th field is the REQ-70 Backend column: it
    // comes from `riina_codegen::codegen_supports_builtin`, i.e. from the same
    // `builtin_canonical` the lowering pass consults, so the doc cannot claim a
    // builtin compiles when `riinac build` would reject it.
    let mut rows: Vec<(String, String, Effect, Backend)> = ctx
        .iter()
        .map(|(name, ty): (&String, &Ty)| {
            (
                name.clone(),
                format_ty(ty),
                builtin_effect(ty),
                Backend::of(name),
            )
        })
        .collect();
    rows.sort_by(|a, b| a.0.cmp(&b.0)); // by builtin name — unique, deterministic

    let wasm_count = rows.iter().filter(|(_, _, _, b)| *b == Backend::Wasm).count();
    let native_count = rows.iter().filter(|(_, _, _, b)| *b == Backend::Native).count();
    let compiled_count = wasm_count + native_count;
    let interp_only_count = rows.len() - compiled_count;

    // Group by effect; render an effect section ordered by the effect enum.
    let effect_order = [
        Effect::Pure,
        Effect::Read,
        Effect::Write,
        Effect::FileSystem,
        Effect::Network,
        Effect::NetworkSecure,
        Effect::Crypto,
        Effect::Random,
        Effect::System,
        Effect::Time,
        Effect::Process,
        Effect::Mut,
        Effect::Alloc,
        Effect::Panel,
        Effect::Zirah,
        Effect::Benteng,
        Effect::Sandi,
        Effect::Menara,
        Effect::Gapura,
    ];

    let mut out = String::new();
    out.push_str("# RIINA Standard Library — Builtin API Reference\n\n");
    out.push_str(
        "> **Generated — do not edit by hand.** This file is produced from the \
         compiler's own builtin registry (`register_builtin_types` in \
         `03_PROTO/crates/riina-typechecker/src/lib.rs`) and the compiled-backend \
         boundary (`riina_codegen::codegen_supports_builtin`) by the test \
         `03_PROTO/crates/riina-typechecker/tests/stdlib_doc.rs`, so it cannot \
         drift from what `riinac` actually accepts or compiles. Regenerate with \
         `REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc`.\n\n",
    );
    out.push_str(&format!(
        "Total registered builtins: **{}**. Grouped by the effect each performs \
         (`kesan` in a function signature). Types are shown in RIINA surface \
         form (`Teks` = string, `Nombor` = integer, `Tercemar`/`Tainted`, \
         `Rahsia`/`Secret`, …).\n\n",
        rows.len()
    ));

    // ── REQ-70: the compiled-vs-interpreted boundary ────────────────────────
    // A type signature says nothing about whether a builtin can be COMPILED.
    // Reading this file without the warning below is the single most likely way
    // for a human or an AI agent to write a program that typechecks, runs, and
    // then cannot be built. State it before the tables, not after.
    out.push_str(&format!(
        "## ⚠ Read first: type-checking does not imply compiling\n\n\
         Every builtin below type-checks and runs under `riinac run` (the \
         interpreter). Only **{compiled}** of the {total} also compile, and they \
         do NOT all reach the same backends:\n\n\
         | Backend value | Meaning |\n|---|---|\n\
         | `compiled` | Lowers to C **and** WASM ({wasm} builtins). |\n\
         | `native-only` | Lowers to C. The WASM backend **refuses** it ({native} builtins). |\n\
         | `interp-only` | `riinac run` only ({interp} builtins). `riinac build` fails with `unbound variable`. |\n\n\
         ```\n\
         $ riinac check baca.rii     # Success!  Effect: FileSystem\n\
         $ riinac run   baca.rii     # works — reads the file\n\
         $ riinac build baca.rii     # Codegen Error: unbound variable: fail_baca\n\
         ```\n\n\
         The example used to be a `jaring_dengar` HTTP server. It is not any \
         more, because that program now COMPILES: as of 2026-08-15 the `jaring`, \
         `http`, `simpan`, `masa` and `json` families are routed, so a networked, \
         persistent service has a native deployment path (master plan REQ-70). \
         The families still interpreter-only are `fail_*`, `vfs_*`, the \
         `keselamatan` sinks, and the `jaring_tls_*` half.\n\n\
         Both refusals are deliberate: a backend that cannot implement a builtin \
         fails closed rather than miscompiling it. Until 2026-08-11 the WASM \
         backend did NOT do this — it emitted a silent stub, so \
         `teks_huruf_besar(\"halo\")` returned `halo` and `panjang(\"abcd\")` \
         returned `abcd`, while the interpreter and C both gave the right answer \
         (master plan REQ-78).\n\n\
         In practice: the WASM surface is printing, string concatenation, \
         `ke_teks` and the numeric-tower constructors. The wider C surface adds \
         strings, lists, maps, sets, math, conversions and test assertions. \
         **Networking, filesystem, VFS, JSON, time, the durable store and the \
         security/taint sinks are interpreter-only** — closing that is master \
         plan REQ-70.\n\n",
        compiled = compiled_count,
        wasm = wasm_count,
        native = native_count,
        total = rows.len(),
        interp = interp_only_count,
    ));
    out.push_str(
        "*Scope note:* this lists the language builtins the typechecker installs. \
         Crypto primitives in `05_TOOLING/crates/riina-core` (AES, SHA-2/3, \
         HMAC/HKDF, X25519, Ed25519, ML-KEM/ML-DSA) are documented with their \
         KAT vectors in that crate, not here.\n\n",
    );

    for eff in effect_order {
        let group: Vec<_> = rows.iter().filter(|(_, _, e, _)| *e == eff).collect();
        if group.is_empty() {
            continue;
        }
        out.push_str(&format!("## {}\n\n", effect_label(eff)));

        // Section-level verdict, so a wholly interpreter-only effect (Network,
        // FileSystem, Time, …) is visible without scanning every row.
        let sec_compiled = group
            .iter()
            .filter(|(_, _, _, b)| *b != Backend::Interp)
            .count();
        if sec_compiled == 0 {
            out.push_str(
                "> **Entirely interpreter-only.** No builtin in this section \
                 compiles — a program using any of them runs under `riinac run` \
                 but cannot be built for native or WASM (REQ-70).\n\n",
            );
        } else if sec_compiled < group.len() {
            out.push_str(&format!(
                "> **Mixed:** {sec_compiled} of {} compile; the rest are \
                 interpreter-only (REQ-70).\n\n",
                group.len()
            ));
        }

        out.push_str("| Builtin | Type | Backend |\n|---|---|---|\n");
        for (name, sig, _, backend) in group {
            out.push_str(&format!("| `{name}` | `{sig}` | {} |\n", backend.cell()));
        }
        out.push('\n');
    }
    out
}

fn doc_path() -> PathBuf {
    // CARGO_MANIFEST_DIR = .../03_PROTO/crates/riina-typechecker
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../../docs/api/STDLIB.md")
}

#[test]
fn stdlib_doc_is_up_to_date() {
    let generated = generate();
    let path = doc_path();

    if std::env::var("REGEN_STDLIB_DOC").is_ok() {
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(&path, &generated).unwrap();
        eprintln!("regenerated {}", path.display());
        return;
    }

    let committed = std::fs::read_to_string(&path).unwrap_or_else(|_| {
        panic!(
            "{} missing — generate it with \
             REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc",
            path.display()
        )
    });
    assert_eq!(
        committed, generated,
        "docs/api/STDLIB.md is stale — the builtin registry changed. Regenerate: \
         REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc"
    );
}
