# RIINA Examples

This directory contains 155 `.rii` example files across 18 category directories.

## ⚠️ Parser-support status (honest)

These examples document the **intended** RIINA language surface. The *shipped*
compiler (`03_PROTO/target/release/riinac`) accepts a narrower grammar than many
of the examples assume. As of this writing, **only ~19 of the 155 examples pass
`riinac check`**.

The most common reasons an example does not yet parse:

- **Multi-statement block bodies.** The parser is expression-oriented. A function
  body may contain `biar … ;` bindings followed by a **single trailing
  expression** (the return value). The `pulang x;` form followed by more tokens,
  and several statement-sequencing patterns used in the examples, are not yet
  accepted.
- **Effect names.** Valid effect names today are Bahasa Melayu:
  `Bersih, Ubah, Baca, Tulis, SistemFail, Rangkaian, Kripto, Rawak, Sistem, Masa,
  Proses`. Names like `IO` or `Crypto` (used in some examples and older docs) are
  **not** recognized.
- **Builtins.** Use `cetak(...)` (or `cetakln(...)`) to print; the print builtins
  carry the `Sistem` (System) effect, so a function that prints must declare
  `kesan Sistem`.
- **List literals, `Some(...)`, guard clauses, and `|` match arms** in some
  advanced examples are not yet parsed.

## What a currently-compiling program looks like

```riina
// Type-checks and runs on the shipped compiler.
fungsi utama() -> Teks kesan Sistem {
    biar mesej = "Selamat datang ke RIINA!";
    cetak(mesej);   // print; 'cetak' carries the 'Sistem' (System) effect
    mesej           // trailing expression = return value
}
```

```bash
riinac check examples.rii   # type + effect check
riinac run   examples.rii   # interpret
```

## Examples that currently pass `riinac check`

These are good starting points because they use the supported expression-style
syntax:

- `01_security/rahsia.rii`
- `03_advanced/closures.rii`
- `08_jalinan/choreography_simple.rii`, `08_jalinan/demo_jalinan.rii`, `08_jalinan/jalinan_demo.rii`
- `demos/hello.rii`, `demos/closures.rii`, `demos/effects.rii`, `demos/generics.rii`,
  `demos/pattern.rii`, `demos/showcase.rii`, `demos/security.rii`, `demos/structs.rii`,
  `demos/records.rii`, `demos/test_effects.rii`, `demos/effects_test.rii`,
  `demos/closures_test.rii`

To regenerate this list:

```bash
for f in $(git ls-files '07_EXAMPLES/**/*.rii'); do
  03_PROTO/target/release/riinac check "$f" >/dev/null 2>&1 && echo "PASS $f"
done
```

## Roadmap

Closing the gap between the documented examples and the shipped parser is tracked
in `RIINA_MASTER_PLAN.md` (Gate B — Compiler Enforcement Parity). Until then, the
examples in other directories should be read as **specifications of intent**, not
as programs guaranteed to compile today.
