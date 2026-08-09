# Getting Started with RIINA — in 10 minutes

> **Every example on this page was run against the shipped compiler before
> publishing** (`riinac` from this repository, verified 2026-06-10). If a
> snippet here ever stops compiling, that is a regression — please report it.
> For the broader picture of what is proven vs. enforced vs. planned, see
> `RIINA_MASTER_PLAN.md` Part 2.

RIINA is a programming language with Bahasa Melayu keywords, a machine-checked
Coq proof corpus behind its core type/effect system, and a security-oriented
compiler. File extension: `.rii`.

---

## 1. Build the compiler (~3 minutes)

You need a Rust toolchain (1.94+) and a C compiler (`cc`) for native builds.
There are **zero external dependencies** — everything builds from source:

```bash
git clone https://github.com/ib823/riina.git
cd riina/03_PROTO
cargo build --release
```

The compiler is now at `03_PROTO/target/release/riinac`. Put it on your PATH
or call it directly.

## 2. Hello world (~2 minutes)

Create `hello.rii`:

```riina
fungsi utama() -> Teks kesan Sistem {
    biar mesej = "Selamat datang ke RIINA!";
    cetak(mesej);
    mesej
}
```

Three ways to use it:

```bash
riinac check hello.rii    # parse + typecheck only
riinac run hello.rii      # interpret directly
riinac build hello.rii    # compile to a native binary via C (./hello)
```

Reading the program:

- `fungsi` declares a function; `utama` is the entry point (like `main`).
- `-> Teks` is the return type (`Teks` = string, `Nombor` = integer,
  `Unit` = nothing).
- `kesan Sistem` declares the function's **effect** — what it is allowed to
  do besides compute. Printing needs at least the `Tulis` (write) effect;
  `Sistem` covers it.
- `biar` binds a value (immutable by default).
- The trailing expression is the return value (no `pulang` needed; `pulang e;`
  also exists for early returns in `padan`-style code).

## 3. Functions, effects, and why they matter (~1 minute)

```riina
fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    x + y
}

fungsi utama() -> Nombor kesan Tulis {
    biar hasil = tambah(3, 4);
    cetak(hasil);
    hasil
}
```

`kesan Bersih` means **pure** — `tambah` is not allowed to print, touch files,
or do anything observable. This is enforced, not advisory. If you try:

```riina
fungsi senyap() -> Unit kesan Bersih {
    cetak("bocor")        // COMPILE ERROR
}
```

```
error: Effect violation: allowed Pure, found Write
```

The effect vocabulary you will use most: `Bersih` (pure), `Baca` (read),
`Tulis` (write/print), `SistemFail` (file system), `Rangkaian` (network),
`Kripto` (crypto), `Rawak` (random), `Masa` (time), `Sistem` (system calls).

## 4. Pattern matching and recursion (~1 minute)

```riina
fungsi faktorial(n: Nombor) -> Nombor kesan Bersih {
    padan n {
        0 -> 1,
        _ -> n * faktorial(n - 1),
    }
}

fungsi utama() -> Unit kesan Tulis {
    cetak(faktorial(10))      // 3628800
}
```

`padan` is `match`. Arms are `pattern -> expression`, comma-separated, `_` is
the wildcard.

## 5. Money that does not lose sen (~1 minute)

RIINA has no floating point. For money there is `wang` — exact, fixed-scale
decimal with banker's rounding (the rounding behaviour is modeled in Coq,
`foundations/FixedPointModel.v`):

```riina
fungsi utama() -> Unit kesan Tulis {
    biar harga  = wang("19.99");
    biar jumlah = harga * wang("3");          // 59.97 — exact
    cetak(jumlah);
    biar sorang = wang("100.00") / wang("3"); // 33.33 — rounded to the sen
    cetak(sorang)
}
```

Note `harga * wang("3")`, not `harga * 3`: money is a **distinct numeric
domain** and the typechecker rejects mixing it with plain integers — you
convert explicitly or you don't cross the boundary. The same discipline
applies to `perpuluhan` (arbitrary-precision decimal) and `besar` (BigInt).
See `07_EXAMPLES/03_applications/belah_bil.rii` for a bill-splitting app that
shows why this matters.

## 6. Secrets cannot reach a print statement (~1 minute)

```riina
fungsi utama() -> Unit kesan Tulis {
    biar pin = sulit 1234;     // classify: pin is now Secret
    cetak(pin)                 // COMPILE ERROR
}
```

```
error: Security violation in print sink: declassify (dedah) the secret
       before printing it: level Secret does not flow to Public
```

The only way out is explicit, auditable declassification with a proof term:

```riina
fungsi utama() -> Unit kesan Tulis {
    cetak(dedah (sulit 1234) dengan bukti (sulit 1234))    // prints 1234
}
```

This mirrors the machine-checked declassification rules in the Coq corpus
(`properties/Declassification.v`). The full story — including what is and is
not enforced today — is in the [Writing Secure RIINA](WRITING_SECURE_RIINA.md)
guide.

## 7. Untrusted data is tracked (~1 minute)

Data read from the filesystem is **tainted at birth** and refuses to flow
into sensitive sinks until sanitized:

```riina
fungsi utama() -> Unit kesan SistemFail {
    biar kandungan = fail_baca("data.sql");
    sql_execute(kandungan)     // COMPILE ERROR
}
```

```
error: Taint violation in sink argument: FileSystem data requires
       SqlParam sanitization before use
```

Sanitize explicitly (and declare the wider effect the SQL builtin needs):

```riina
fungsi utama() -> Unit kesan Sistem {
    biar kandungan = fail_baca("data.sql");
    sql_execute(sanitasi_sql(kandungan))    // OK
}
```

## 8. Splitting a program across files (~1 minute)

`guna <name>;` imports the sibling file `<name>.rii`. Create `kira.rii`:

```riina
awam fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih { x + y }
awam fungsi dua_kali(x: Nombor) -> Nombor kesan Bersih { tambah(x, x) }

// No `awam` — private to this file.
fungsi pembantu(x: Nombor) -> Nombor kesan Bersih { x * 99 }
```

and `main.rii` beside it:

```riina
guna kira;

fungsi utama() -> Nombor kesan Tulis {
    biar a = kira::tambah(3, 4);
    cetakln(ke_teks(kira::dua_kali(a)));   // 14
    0
}
```

```bash
riinac run   main.rii    # 14
riinac build --run main.rii   # compiles both files into one binary, prints 14
```

`awam` is what makes a name importable. Calling `kira::pembantu(2)` from
`main.rii` is rejected:

```
error: `kira::pembantu` is private to module `kira` (referenced from `main`)
  note: mark it `awam fungsi pembantu` to export it
```

Import cycles, cross-module name collisions, and naming a module you did not
import are all errors too, each naming the problem rather than failing later or
silently picking a definition.

Two things to know:

- **`guna std::teks;` is not a file import.** A multi-segment path names the
  builtin namespace; builtins are always available and need no `std/` directory.
- **There is no `.rii` standard library yet**, and imports resolve only within
  the importing file's directory — no search path or package dependencies.
  (Master plan REQ-71 remainder / REQ-72.)

## 9. Where to go next

- **[Writing Secure RIINA](WRITING_SECURE_RIINA.md)** — the security features
  in depth, each labeled with what is enforced today.
- **[Standard Library API Reference](../api/STDLIB.md)** — every builtin and its
  type signature, generated from the compiler's own registry (so it can't drift).
- **[Proof Guide](PROOF_GUIDE.md)** — how to read, build, and extend the Coq lane.
- **`07_EXAMPLES/00_basics/` and `07_EXAMPLES/03_applications/`** — examples
  verified to run on the shipped compiler (`belah_bil.rii`, `invois.rii`,
  `gaji.rii`, …). *Honesty note:* other example directories include
  aspirational programs written against the full language design; not all of
  them compile on today's parser.
- **[llms.txt](../../llms.txt) / [llms-full.txt](../../llms-full.txt)** — the
  machine-readable language reference (also the fastest human cheat-sheet).
- **`RIINA_MASTER_PLAN.md` Part 2** — the verified status of every claim:
  what is proven in Coq, what the compiler enforces, and the gaps between.
