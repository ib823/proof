# COPILOT.md — RIINA™ Repository Instructions for GitHub Copilot

## Before ANY Action

Read `RIINA_MASTER_PLAN.md` (the ONLY planning authority) and `CLAUDE.md` (operational instructions).

## Mandatory Session Protocol

**Follow `RIINA_MASTER_PLAN.md` Part 8 exactly.** 8 steps, no shortcuts:
ORIENT → ASSESS → DECIDE → VERIFY BEFORE → EXECUTE → VERIFY AFTER → UPDATE → HANDOFF

## Branch Policy

**Default branch is `main`.** Managed-session feature branches (`claude/*`) are permitted when assigned; they sync back to `main`. Never commit to `public` or `gh-pages`.

## Commit-Push-Deploy Chain

```
Stage specific files → commit [TRACK_X] TYPE: → push origin main → sync-public.sh → sync-metrics.sh → deploy-website.sh
```
Numbers flow ONE direction: actual commands → metrics.json → all docs → website → master plan.

## RIINA Language Basics

- RIINA uses Bahasa Melayu (Malaysian) keywords with English aliases
- File extension: `.rii`
- All functions MUST declare their effect: `kesan Bersih` (pure), `kesan Tulis` (write), etc.
- Security types prevent information leaks at compile time

## Key Syntax Rules

1. Functions: `fungsi name(param: Type) -> ReturnType kesan Effect { body }`
2. Bindings: `biar name = value;` (semicolons required)
3. Conditionals: `kalau condition { ... } lain { ... }` (else branch required)
4. Match: `padan value { pattern => result, _ => default }`
5. Effects: Always declare with `kesan`. Pure = `Bersih`, I/O = `Tulis`/`Baca`
6. Secrets: `Rahsia<T>` cannot be printed or leaked. Use `dedah` with proof.
7. Pipe: `value |> function1 |> function2`
8. Entry point: `fungsi utama() -> Nombor kesan Tulis { ... pulang 0; }`

## Types

- `Nombor` (Int), `Teks` (String), `Benar` (Bool), `Kosong` (Unit)
- `Rahsia<T>` (Secret), `Bukti<T>` (Proof), `Senarai<T>` (List)
- `Mungkin<T>` (Option), `Hasil<T,E>` (Result)

## Effects (declare with `kesan`)

Bersih (Pure) | Ubah (Mut) | Baca (Read) | Tulis (Write) | SistemFail (FileSystem) | Rangkaian (Network) | Kripto (Crypto) | Sistem (System) | Masa (Time)

## Style

- Function/variable names: snake_case (Bahasa Melayu preferred)
- Type names: PascalCase
- Constants: SCREAMING_SNAKE_CASE
- Indent: 4 spaces
- Always use Bahasa Melayu keywords over English alternatives

## Rules

- Do NOT create new planning documents. `RIINA_MASTER_PLAN.md` is the only plan.
- Do NOT commit Coq proofs with `Admitted`.
- Do NOT count stub prover files as real proofs.
- Work on `main` or your assigned managed-session branch (`claude/*`); do NOT create unrequested feature branches.
- Do NOT push with `--no-verify` — the in-repo hooks (`riinac verify` + `audit-docs.sh`) are the source of truth.
- Do NOT commit to `public` or `gh-pages` directly.
- `.github/workflows/verify.yml` is a thin wrapper that runs the same internal gates; CI is never the source of truth and must not diverge from them.

## Prover Maturity (be honest in generated docs/comments)

Only **Coq (Rocq 9.2)** is a fully mechanized lane. The Lean 4, Isabelle, F\*, TLA+,
Alloy, SMT, Verus, Kani, and TV trees are **generated or smoke-level** artifacts — do
NOT describe them as independently verifying RIINA. Per-lane claim levels live in
`website/public/metrics.json` (the single source of truth); all docs must agree with it.
