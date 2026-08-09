# RIINA Examples

This directory contains 147 `.rii` example files across 18 category directories.

## ⚠️ Parser-support status (honest)

These examples document the **intended** RIINA language surface. The *shipped*
compiler (`03_PROTO/target/release/riinac`) accepts a narrower grammar than many
of the examples assume. As of this writing, **92 of the 167 examples pass
`riinac check`** end-to-end (re-measured 2026-08-09; and all of `00_basics/`), and closing the
remaining gap is active work (`RIINA_MASTER_PLAN.md` Gate B).

Separately, passing `riinac check` does **not** imply the example can be
compiled: every `jaring_*`/`fail_*`/`vfs_*`/`json_*`/`masa_*` and security
builtin is **interpreter-only**, so `riinac build` on a program using them
fails closed with `unbound variable` (master plan REQ-70). The parser is
being extended incrementally; the forms below are **now accepted** but some
example files stack several advanced constructs and need all of them supported
before they pass.

Recently added grammar support:

- **`biar x: T = e` type annotations** (in-function and top-level). Accepted and
  inferred.
- **Trailing `;` before a block close**, including a final `pulang x;` — now
  returns `x`.
- **True early return.** `pulang e;` unwinds to the enclosing function boundary.
- **Pattern matching** in `padan`: literals, tuples, `Ada`/`Tidak`,
  `Ok`/`Ralat`, list patterns (`[]`, `[x]`, `[x, ..rest]`), reference patterns
  (`ruj(p)`), and named nominal-enum constructors (`Bulatan(r)`, `Tidak`).
- **List literals `[e1, e2, ...]`** and list `+` concatenation; record literals
  and field access.
- **Guard clauses** (`pastikan cond lain { ... };`) and the `|>` pipe operator.
- **Loop control** — `putus` (break) and `lanjut` (continue) inside
  `selagi` / `ulang` / `untuk`.
- **`!` as logical-not** on booleans (in addition to its deref meaning on refs).
- **Top-level `jenis` declarations** — record (`jenis Name { ... }`), generic
  (`jenis Name<T> { ... }`), alias (`jenis Name = T;`), and marker (`jenis Name`)
  forms parse (no nominal-type semantics yet; skipped like `bentuk`/`pilihan`).

Still **not** accepted (the remaining Gate B work):

- **Effect names.** Valid effect names today are Bahasa Melayu:
  `Bersih, Ubah, Baca, Tulis, SistemFail, Rangkaian, Kripto, Rawak, Sistem, Masa,
  Proses`. Names like `IO` or `Crypto` (used in some examples and older docs) are
  **not** recognized.
- **Builtins.** Use `cetak(...)` (or `cetakln(...)`) to print; the print builtins
  carry the `Tulis` (Write) effect, so a function that prints must declare at
  least `kesan Tulis`.
- **`|` (alternation) match arms** and generics in expression position are not
  yet parsed.

## What a currently-compiling program looks like

```riina
// Type-checks and runs on the shipped compiler.
fungsi utama() -> Teks kesan Tulis {
    biar mesej = "Selamat datang ke RIINA!";
    cetak(mesej);   // print; 'cetak' carries the 'Tulis' (Write) effect
    mesej           // trailing expression = return value
}
```

```bash
riinac check examples.rii   # type + effect check
riinac run   examples.rii   # interpret
```

## Examples that currently pass `riinac check`

The whole `00_basics/` directory (20 files) now type- and effect-checks, so those
are the best starting points. Many files in `01_security/`, `02_effects/`,
`04_compliance/`, and `08_jalinan/` also pass. The exact set moves as the parser
is extended, so regenerate it rather than trusting a hand-maintained list:

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
