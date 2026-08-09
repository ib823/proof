# RIINA Common Mistakes for AI Agents

> **Purpose:** LLM context injection. Top 21 errors AI agents make when generating RIINA code.
> Each entry: wrong code, error message, fixed code, explanation.

---

## 1. Using English keywords instead of Bahasa Melayu

```riina
// WRONG
fn add(x: int, y: int) -> int {
    return x + y;
}
```
```
E0001: Unknown keyword 'fn'. Did you mean 'fungsi'?
E0001: Unknown keyword 'return'. Did you mean 'pulang'?
```
```riina
// FIXED
fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    pulang x + y;
}
```
**Rule:** All keywords are Bahasa Melayu. `fn`->`fungsi`, `let`->`biar`, `if`->`kalau`, `else`->`lain`, `return`->`pulang`, `match`->`padan`, `for`->`untuk`, `while`->`selagi`, `true`->`betul`, `false`->`salah`, `const`->`tetap`, `mut`->`ubah`, `loop`->`ulang`.

---

## 2. Missing effect annotation

```riina
// WRONG
fungsi cetak_mesej(mesej: Teks) -> () {
    cetak_baris(mesej);
}
```
```
E0100: Function 'cetak_mesej' performs effect 'Tulis' but has no effect annotation.
       Add 'kesan Tulis' after the return type.
```
```riina
// FIXED
fungsi cetak_mesej(mesej: Teks) -> () kesan Tulis {
    cetak_baris(mesej);
}
```
**Rule:** Every function that performs side effects MUST declare them with `kesan`. Pure functions use `kesan Bersih`.

---

## 3. Assigning secret to public variable

```riina
// WRONG
biar kata_laluan: Rahsia<Teks> = Rahsia("abc123");
biar teks_awam: Teks = kata_laluan;
```
```
E0301: Cannot assign value of type 'Rahsia<Teks>' to variable of type 'Teks'.
       Security level violation: Rahsia > Awam.
       Use 'dedah' with proof to declassify.
```
```riina
// FIXED
biar kata_laluan: Rahsia<Teks> = Rahsia("abc123");
biar teks_awam: Teks = dedah(kata_laluan, bukti: "audit_dibenarkan");
```
**Rule:** `Rahsia<T>` cannot be implicitly converted to `T`. Use `dedah` with a `bukti` (proof) string.

---

## 4. Missing return type

```riina
// WRONG
fungsi tambah(x: Nombor, y: Nombor) kesan Bersih {
    pulang x + y;
}
```
```
E0200: Function 'tambah' is missing return type.
       Add '-> Nombor' before 'kesan'.
```
```riina
// FIXED
fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    pulang x + y;
}
```
**Rule:** Return type (`-> T`) comes BEFORE effect annotation (`kesan E`). Order: `fungsi name(params) -> ReturnType kesan Effect { body }`.

---

## 5. Using wrong type names

```riina
// WRONG
fungsi kira(x: int, nama: string) -> bool {
    pulang betul;
}
```
```
E0201: Unknown type 'int'. Did you mean 'Nombor'?
E0201: Unknown type 'string'. Did you mean 'Teks'?
E0201: Unknown type 'bool'. Did you mean 'Benar'?
```
```riina
// FIXED
fungsi kira(x: Nombor, nama: Teks) -> Benar kesan Bersih {
    pulang betul;
}
```
**Rule:** Type names: `Nombor` (int), `Teks` (string), `Benar` (bool), `Senarai<T>` (list), `Mungkin<T>` (option), `Hasil<T,E>` (result), `Rahsia<T>` (secret), `Ruj<T>` (ref).

---

## 6. Forgetting `kesan` keyword

```riina
// WRONG
fungsi baca_fail(laluan: Teks) -> Teks Baca {
    pulang "";
}
```
```
E0102: Expected 'kesan' before effect name 'Baca'.
```
```riina
// FIXED
fungsi baca_fail(laluan: Teks) -> Teks kesan Baca {
    pulang "";
}
```
**Rule:** The keyword `kesan` is required before effect names. Multiple effects: `kesan (Tulis, Baca)`.

---

## 7. Using `=` instead of `==` for comparison

```riina
// WRONG
kalau x = 5 {
    cetak_baris("lima");
}
```
```
E0400: Assignment in condition context. Did you mean '=='?
       Use '==' for comparison, '=' for assignment.
```
```riina
// FIXED
kalau x == 5 {
    cetak_baris("lima");
}
```
**Rule:** `=` is assignment. `==` is comparison. `!=` is not-equal.

---

## 8. Missing semicolons

```riina
// WRONG
fungsi contoh() -> Nombor kesan Bersih {
    biar x = 5
    biar y = 10
    pulang x + y
}
```
```
E0500: Expected ';' after statement.
```
```riina
// FIXED
fungsi contoh() -> Nombor kesan Bersih {
    biar x = 5;
    biar y = 10;
    pulang x + y;
}
```
**Rule:** All statements end with `;`. The last expression in a block may omit `;` if used as the block's return value, but explicit `pulang` always needs `;`.

---

## 9. Wrong function call syntax

```riina
// WRONG
fungsi utama() kesan Tulis {
    cetak_baris "Hello"
}
```
```
E0501: Expected '(' for function call arguments.
```
```riina
// FIXED
fungsi utama() -> () kesan Tulis {
    cetak_baris("Hello");
}
```
**Rule:** Function calls always use parentheses: `fungsi_nama(arg1, arg2)`.

---

## 10. Not handling Mungkin/Hasil variants

```riina
// WRONG
fungsi dapatkan(id: Nombor) -> Teks kesan Bersih {
    biar hasil: Mungkin<Teks> = cari(id);
    pulang hasil;  // Type mismatch: Mungkin<Teks> vs Teks
}
```
```
E0202: Type mismatch: expected 'Teks', found 'Mungkin<Teks>'.
       Use 'padan' to handle Ada/Tiada variants.
```
```riina
// FIXED
fungsi dapatkan(id: Nombor) -> Teks kesan Bersih {
    biar hasil: Mungkin<Teks> = cari(id);
    padan hasil {
        Ada(nilai) => pulang nilai,
        Tiada => pulang "lalai",
    };
}
```
**Rule:** `Mungkin<T>` has variants `Ada(T)` and `Tiada`. `Hasil<T,E>` has `Ok(T)` and `Ralat(E)`. Always match exhaustively.

---

## 11. Leaking Rahsia through string interpolation

```riina
// WRONG
biar kunci: Rahsia<Teks> = Rahsia("kunci_api_123");
cetak_baris("Kunci: " + kunci);
```
```
E0302: Cannot concatenate 'Teks' with 'Rahsia<Teks>'.
       Secret values cannot be interpolated into strings.
       Use 'dedah' with proof for intentional declassification.
```
```riina
// FIXED — Option A: Redact
cetak_baris("Kunci: [DIREDAKSI]");

// FIXED — Option B: Declassify with proof
biar kunci_teks = dedah(kunci, bukti: "log_audit_dalaman");
cetak_baris("Kunci: " + kunci_teks);
```
**Rule:** `Rahsia<T>` has no `ToString`/concatenation. This is by design to prevent accidental leakage.

---

## 12. Effect escalation (calling IO from Bersih)

```riina
// WRONG
fungsi kira(x: Nombor) -> Nombor kesan Bersih {
    cetak_baris("Mengira...");  // cetak_baris requires Tulis!
    pulang x * 2;
}
```
```
E0103: Effect violation in function 'kira'.
       Cannot perform 'Tulis' in a 'Bersih' (pure) context.
       Either add 'kesan Tulis' or remove the side effect.
```
```riina
// FIXED
fungsi kira(x: Nombor) -> Nombor kesan Tulis {
    cetak_baris("Mengira...");
    pulang x * 2;
}
```
**Rule:** A function declared `kesan Bersih` cannot call functions with higher effects. Effect hierarchy: `Bersih < Baca < Tulis < IO < Rangkaian < Kripto`.

---

## 13. Wrong security level flow (high to low)

```riina
// WRONG
fungsi proses(data: Rahsia<Nombor>) -> Nombor kesan Bersih {
    biar nilai: Nombor = data.buka();  // No such method
    pulang nilai * 2;
}
```
```
E0303: 'Rahsia<Nombor>' has no method 'buka'.
       Cannot extract secret value without 'dedah' and proof.
       Information flow: high security -> low security is forbidden.
```
```riina
// FIXED — Process within secret context
fungsi proses(data: Rahsia<Nombor>) -> Rahsia<Nombor> kesan Bersih {
    /// Map over the secret without exposing it
    pulang peta_rahsia(data, fungsi(n: Nombor) -> Nombor { n * 2 });
}
```
**Rule:** Data flows upward (public to secret) freely. Downward flow (secret to public) requires explicit `dedah` with proof.

---

## 14. Using English booleans

```riina
// WRONG
biar aktif: Benar = true;
biar dipadam: Benar = false;
```
```
E0001: Unknown identifier 'true'. Did you mean 'betul'?
E0001: Unknown identifier 'false'. Did you mean 'salah'?
```
```riina
// FIXED
biar aktif: Benar = betul;
biar dipadam: Benar = salah;
```
**Rule:** Boolean literals are `betul` (true) and `salah` (false). Boolean type is `Benar`.

---

## 15. Missing type annotation on biar

```riina
// WRONG (in contexts where type cannot be inferred)
fungsi contoh() -> Nombor kesan Bersih {
    biar senarai = [];     // Cannot infer element type
    pulang panjang(senarai);
}
```
```
E0203: Cannot infer type of empty collection.
       Add type annotation: 'biar senarai: Senarai<Nombor> = [];'
```
```riina
// FIXED
fungsi contoh() -> Nombor kesan Bersih {
    biar senarai: Senarai<Nombor> = [];
    pulang panjang(senarai);
}
```
**Rule:** Type annotations are optional when the compiler can infer the type. Required for: empty collections, ambiguous literals, function arguments.

---

## 16. Incorrect padan (match) syntax

```riina
// WRONG — using `case` or `:`
padan keadaan {
    case "aktif": cetak_baris("Ya"),
    case "tamat": cetak_baris("Tidak"),
}
```
```
E0502: Expected '=>' in match arm, found ':'.
       Use 'padan value { pattern => expression, ... }'.
```
```riina
// FIXED
padan keadaan {
    "aktif" => cetak_baris("Ya"),
    "tamat" => cetak_baris("Tidak"),
    _ => cetak_baris("Tidak diketahui"),
};
```
**Rule:** Match syntax: `padan expr { pattern => body, ... };`. Use `_` for wildcard. Arms separated by `,`. Entire padan ends with `;`.

---

## 17. Forgetting to box recursive types

```riina
// WRONG
jenis Nod = {
    nilai: Nombor,
    seterusnya: Mungkin<Nod>,  // Infinite size!
};
```
```
E0204: Recursive type 'Nod' has infinite size.
       Use 'Kotak<Nod>' to heap-allocate the recursive field.
```
```riina
// FIXED
jenis Nod = {
    nilai: Nombor,
    seterusnya: Mungkin<Kotak<Nod>>,
};
```
**Rule:** Recursive types must use `Kotak<T>` (Box) for indirection to have a known size at compile time.

---

## 18. Using wrong pipe syntax

```riina
// WRONG — using | or -> instead of |>
biar hasil = 5 | tambah_satu | darab_dua;
biar hasil2 = 5 -> tambah_satu -> darab_dua;
```
```
E0503: Unexpected token '|'. Did you mean '|>' (pipe operator)?
```
```riina
// FIXED
biar hasil = 5
    |> tambah_satu
    |> darab_dua;
```
**Rule:** Pipe operator is `|>`. Reads left to right: `x |> f |> g` equals `g(f(x))`. Pipes into the first argument of the next function.

---

## 19. Incorrect ujian block syntax

```riina
// WRONG — using #[test] or test keyword
#[test]
fungsi ujian_tambah() {
    assert_eq!(tambah(1, 2), 3);
}
```
```
E0504: Unknown attribute '#[test]'. Use 'ujian "name" { ... }' for inline tests.
E0001: Unknown identifier 'assert_eq!'. Did you mean 'tegaskan_sama'?
```
```riina
// FIXED
ujian "tambah_dua_nombor" {
    tegaskan_sama(tambah(1, 2), 3);
    tegaskan(tambah(0, 0) == 0);
    tegaskan_beza(tambah(1, 2), 0);
}
```
**Rule:** Tests use `ujian "name" { body }`. Assertions: `tegaskan(bool)`, `tegaskan_sama(a, b)`, `tegaskan_beza(a, b)`. No function declaration needed — ujian blocks are top-level.

---

## 20. Missing dedah proof for declassification

```riina
// WRONG — dedah without bukti
biar kunci: Rahsia<Teks> = Rahsia("supersecret");
biar nilai = dedah(kunci);
```
```
E0304: 'dedah' requires a 'bukti' (proof) parameter.
       Proof documents why declassification is safe.
       Usage: dedah(secret, bukti: "justification_string")
```
```riina
// FIXED
biar kunci: Rahsia<Teks> = Rahsia("supersecret");
biar nilai = dedah(kunci, bukti: "enkripsi_sah_untuk_penghantaran");
```
**Rule:** `dedah` (declassify) always requires `bukti: "reason"`. The proof string is logged for audit. The compiler tracks all declassification points.

---

## 21. Assuming `riinac check` passing means the program can be compiled

```riina
// WRONG — if the goal is a compiled binary
fungsi utama() -> Teks kesan Rangkaian {
    biar pendengar = jaring_dengar("127.0.0.1:8099");
    biar sambungan = jaring_terima_sambungan(pendengar);
    jaring_terima((sambungan, 1024))
}
```
```
$ riinac check pelayan.rii    # Success!  Effect: Network
$ riinac run   pelayan.rii    # works — serves a real HTTP/1.1 200
$ riinac build pelayan.rii
Codegen Error: unbound variable: jaring_dengar
```
```riina
// FIXED — for a program that must COMPILE, stay inside the compiled surface
fungsi utama() -> Nombor kesan Tulis {
    biar mesej = gabung_teks(("Selamat ", "datang"));
    cetakln(mesej);
    0
}
```
**Rule:** Type-checking does not imply compiling. **148 of the 329 builtins compile; 181 are interpreter-only.** Networking (`jaring_*`), filesystem (`fail_*`), VFS (`vfs_*`), JSON (`json_*`), time (`masa_*`), and every security sink (`sanitasi_*`, `sql_*`, `http_*`, `csrf_*`) run only under `riinac run` — `riinac build` and `emit-c` fail closed with `unbound variable` rather than miscompiling. The compiled surface is: printing, strings (`teks_*`), lists (`senarai_*`), maps (`peta_*`), sets (`set_*`), most math, conversions, the numeric tower, and test assertions. Check the `Backend` column in `docs/api/STDLIB.md` before generating code that must be built. Master plan REQ-70 tracks closing this gap.

---

## Quick Reference: Keyword Mapping

| English | RIINA (Bahasa Melayu) |
|---------|----------------------|
| `fn` / `function` | `fungsi` |
| `let` | `biar` |
| `mut` | `ubah` |
| `const` | `tetap` |
| `if` | `kalau` |
| `else` | `lain` |
| `for` | `untuk` |
| `while` | `selagi` |
| `loop` | `ulang` |
| `return` | `pulang` |
| `match` | `padan` |
| `true` | `betul` |
| `false` | `salah` |
| `break` | `putus` |
| `continue` | `lanjut` |
| `use` / `import` | `guna` |
| `module` | `modul` |
| `type` | `jenis` |
| `public` | `awam` |
| `effect` | `kesan` |
| `pure` | `Bersih` |
| `secret` | `Rahsia` |
| `declassify` | `dedah` |
| `proof` | `bukti` |
| `test` | `ujian` |
| `assert` | `tegaskan` |
| `assert_eq` | `tegaskan_sama` |

## Quick Reference: Type Mapping

| English | RIINA |
|---------|-------|
| `Int` / `Number` | `Nombor` |
| `String` / `Text` | `Teks` |
| `Bool` | `Benar` |
| `List<T>` | `Senarai<T>` |
| `Option<T>` | `Mungkin<T>` |
| `Some(v)` | `Ada(v)` |
| `None` | `Tiada` |
| `Result<T,E>` | `Hasil<T,E>` |
| `Ok(v)` | `Ok(v)` |
| `Err(e)` | `Ralat(e)` |
| `Secret<T>` | `Rahsia<T>` |
| `Ref<T>` | `Ruj<T>` |
| `Box<T>` | `Kotak<T>` |

## Quick Reference: Effect Mapping

| English | RIINA |
|---------|-------|
| `Pure` | `Bersih` |
| `Read` | `Baca` |
| `Write` | `Tulis` |
| `IO` | `IO` |
| `Network` | `Rangkaian` |
| `Crypto` | `Kripto` |
| `FileSystem` | `SistemFail` |
| `Random` | `Rawak` |
| `Time` | `Masa` |
