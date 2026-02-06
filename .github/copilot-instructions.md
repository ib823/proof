# RIINA Language — Copilot Instructions

## Language Basics
- RIINA uses Bahasa Melayu (Malaysian) keywords with English aliases
- File extension: `.rii`
- All functions MUST declare their effect: `kesan Bersih` (pure), `kesan Tulis` (write), etc.
- Security types prevent information leaks at compile time

## Key Syntax Rules
1. Functions: `fungsi name(param: Type) -> ReturnType kesan Effect { body }`
2. Bindings: `biar name = value;` (semicolons required between statements)
3. Conditionals: `kalau condition { ... } lain { ... }` (else branch required)
4. Match: `padan value { pattern => result, _ => default }` (use `=>` not `->`)
5. Effects: Always declare with `kesan`. Pure = `Bersih`, I/O = `Tulis`/`Baca`
6. Secrets: `Rahsia<T>` cannot be printed or leaked. Use `dedah` with proof.
7. Pipe: `value |> function1 |> function2`
8. Entry point: `fungsi utama() -> Nombor kesan Tulis { ... pulang 0; }`

## Style
- Function/variable names: snake_case (Bahasa Melayu preferred)
- Type names: PascalCase
- Constants: SCREAMING_SNAKE_CASE
- Indent: 4 spaces
- Always use Bahasa Melayu keywords over English alternatives

## Common Types
- `Nombor` (Int), `Teks` (String), `Benar` (Bool), `Kosong` (Unit)
- `Rahsia<T>` (Secret), `Bukti<T>` (Proof), `Ruj<T>@Level` (Reference)
- `Senarai<T>` (List), `Mungkin<T>` (Option), `Hasil<T,E>` (Result)

## Effects (declare with `kesan`)
Bersih (Pure) | Ubah (Mut) | Baca (Read) | Tulis (Write) | SistemFail (FileSystem) | Rangkaian (Network) | Kripto (Crypto) | Rawak (Random) | Sistem (System) | Masa (Time)
