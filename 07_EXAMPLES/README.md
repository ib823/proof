# RIINA Examples

This directory contains 172 `.rii` example files across 20 category directories.

## ⚠️ Parser-support status (honest)

These examples document the **intended** RIINA language surface. The *shipped*
compiler (`03_PROTO/target/release/riinac`) accepts a narrower grammar than many
of the examples assume. As of this writing, **83 of the 172 examples pass
`riinac check`** end-to-end (re-measured 2026-10-20), and closing the
remaining gap is active work (`RIINA_MASTER_PLAN.md` REQ-55). The 2026-10-19 drop from 98 is
honest: 14 examples call methods on lists and strings (`senarai.panjang()`, `xs.peta(f)`) —
RIINA has no methods — and used to pass `check` only to fail when run (REQ-93). So is the
2026-10-20 drop from 84 to 82: an undeclared type name used to read as `Any`, and two examples
relied on it (REQ-93(c); `riinac/tests/end_to_end.rs` names them). One example came back the
same day, when a variable named after a keyword (`token`) became readable.

Separately, passing `riinac check` does **not** imply the example can be
compiled: some builtins run only on the interpreter, and `riinac build` refuses
a program that uses them with `unbound variable`. Which builtins those are is
stated in one place, the generated builtin matrix in
[docs/api/STDLIB.md](../docs/api/STDLIB.md).

`11_servis/` is the persistent-service reference: a package that is multi-file
(REQ-71), networked (REQ-73 HTTP/1.1) and durable (REQ-73 store), a guest book
whose visit counter survives a restart. `riinac pkg build` in that directory
produces a native binary (REQ-75). The parser is
being extended incrementally; the forms below are **now accepted** but some
example files stack several advanced constructs and need all of them supported
before they pass.

Recently added grammar support:

- **`biar x: T = e` type annotations** (in-function and top-level), and a
  lambda's `-> T`. Checked: the value must fit `T`, or the program is rejected
  (`Annotation mismatch`). Until 2026-10-20 they were parsed and ignored.
- **Trailing `;` before a block close**, including a final `pulang x;` — now
  returns `x`.
- **True early return.** `pulang e;` unwinds to the enclosing function boundary.
- **Pattern matching** in `padan`: literals, tuples, `Ada`/`Tidak`,
  `Ok`/`Ralat`, list patterns (`[]`, `[x]`, `[x, ..rest]`), reference patterns
  (`ruj(p)`), and named nominal-enum constructors (`Bulatan(r)`, `Tidak`).
- **List literals `[e1, e2, ...]`** and list `+` concatenation; record literals
  and field access.
- **Guard clauses** (`pastikan cond lain { ... };`) and the `|>` pipe operator.
- **Real loops.** `selagi` (while) and `ulang` (loop) iterate until their
  condition goes false or a `putus` leaves them; `putus` (break) and `lanjut`
  (continue) are real control flow. Both used to be sugar that ran the body at
  most ONCE (`selagi c { b }` became `if c { b; () }`) with `putus`/`lanjut`
  desugaring to `()`, so a loop type-checked, formatted and read like a loop
  while doing none of the iterating. `putus`/`lanjut` are accepted in
  `selagi`/`ulang` bodies; inside a `untuk` body they are a parse error (P0010)
  rather than a statement that silently disappears.
- **`biar ubah` is a real mutable binding.** A write is visible to every later
  read, including outside the block that made it — which is what makes a loop
  accumulator work. It carries NO effect (a slot cannot escape its binder), so a
  counting loop stays `kesan Bersih`. See
  [docs/guide/MUTABLE_STATE.md](../docs/guide/MUTABLE_STATE.md).
- **`!` as logical-not** on booleans (in addition to its deref meaning on refs).
- **Type names are checked.** A type must be built in, declared in the same
  file, or a generic parameter of the function (`fungsi f<T>(x: T)`); anything
  else is error P0020, with the nearest known name. `jenis Name = T;` is an
  alias for `T` (declare it above its first use). Record and variant types
  (`jenis Name { ... }`, `jenis Name<T> { ... }`, `bentuk`, `pilihan`) and
  markers (`jenis Name`) declare a name, but the checker has no record or
  variant types yet, so the name reads as `Any`. Types are not imported by
  `guna`. Until 2026-10-20 every unknown name, typos included, read as `Any`.

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

Most of `00_basics/` type- and effect-checks, so it is the best starting
point. Many files in `01_security/`, `02_effects/`,
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
