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

use riina_fmt::format_ty;
use riina_typechecker::{register_builtin_types, Context};
use riina_types::{Effect, Ty};
use std::path::PathBuf;

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

    // Collect (name, rendered-signature, effect), sorted for determinism.
    let mut rows: Vec<(String, String, Effect)> = ctx
        .iter()
        .map(|(name, ty): (&String, &Ty)| (name.clone(), format_ty(ty), builtin_effect(ty)))
        .collect();
    rows.sort_by(|a, b| a.0.cmp(&b.0)); // by builtin name — unique, deterministic

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
         `03_PROTO/crates/riina-typechecker/src/lib.rs`) by the test \
         `03_PROTO/crates/riina-typechecker/tests/stdlib_doc.rs`, so it cannot \
         drift from what `riinac` actually accepts. Regenerate with \
         `REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc`.\n\n",
    );
    out.push_str(&format!(
        "Total registered builtins: **{}**. Grouped by the effect each performs \
         (`kesan` in a function signature). Types are shown in RIINA surface \
         form (`Teks` = string, `Nombor` = integer, `Tercemar`/`Tainted`, \
         `Rahsia`/`Secret`, …).\n\n",
        rows.len()
    ));
    out.push_str(
        "*Scope note:* this lists the language builtins the typechecker installs. \
         Crypto primitives in `05_TOOLING/crates/riina-core` (AES, SHA-2/3, \
         HMAC/HKDF, X25519, Ed25519, ML-KEM/ML-DSA) are documented with their \
         KAT vectors in that crate, not here.\n\n",
    );

    for eff in effect_order {
        let group: Vec<_> = rows.iter().filter(|(_, _, e)| *e == eff).collect();
        if group.is_empty() {
            continue;
        }
        out.push_str(&format!("## {}\n\n", effect_label(eff)));
        out.push_str("| Builtin | Type |\n|---|---|\n");
        for (name, sig, _) in group {
            out.push_str(&format!("| `{name}` | `{sig}` |\n"));
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
