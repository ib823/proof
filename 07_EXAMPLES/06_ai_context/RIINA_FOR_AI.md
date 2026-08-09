# RIINA for AI Assistants

**Verification:** 12,678 Coq Qed (compiled, 0 Admitted, 0 active axioms) — Coq is the only mechanized lane | 3024 Rust tests | the other prover trees are machine-generated (claim-level tracked, not independent verification)

## What is RIINA?

RIINA (Rigorous Immutable Invariant — Normalized Axiom) is a formally verified programming language with:

1. **Bahasa Melayu syntax** — Native Malaysian language keywords
2. **Mathematical security guarantees** — All security properties proven in Coq
3. **Effect system** — Track all side effects at the type level
4. **Information flow control** — 6-level security lattice
5. **Capability-based security** — Fine-grained access control
6. **Taint tracking** — Track untrusted data through the system
7. **Zero-trust architecture** — Compiler, hardware, and supply chain untrusted

## File Extension

- `.rii` — RIINA source files
- `.riih` — RIINA header/interface files

## Language Design

RIINA is a typed, expression-oriented language. Every construct is an expression that returns a value. Functions are first-class. Security properties are enforced by the type system.

### Core Syntax

```riina
// Variable binding
biar nama = "Ahmad";
biar umur: Nombor = 25;

// Function declaration
fungsi tambah(x: Nombor, y: Nombor) -> Nombor {
    x + y
}

// Function with effect
fungsi cetak_mesej(mesej: Teks) -> () kesan Tulis {
    laku Tulis cetak(mesej);
}

// If-else
kalau umur >= 18 {
    "dewasa"
} lain {
    "kanak"
}

// Pattern match
padan status {
    0 => "berjaya",
    1 => "gagal",
    _ => "tidak diketahui",
}

// For loop
untuk item dalam senarai {
    proses(item);
}

// Pipe operator
data |> transform |> validate |> process
```

### Security Types

```riina
// Secret data — cannot be leaked to lower security levels
biar kata_laluan: Rahsia<Teks> = sulit "abc123";

// Declassify with proof
biar log_safe = dedah kata_laluan dengan bukti audit_proof;

// Labeled data at specific security level
biar data: Berlabel<Teks, Pengguna> = label("sensitive");

// Tainted data from untrusted source
biar input: Tercemar<Teks, UserInput> = baca_input();

// Sanitized data
biar clean: Disanitasi<Teks, HtmlEscape> = sanitize(input);

// Capability-gated operations
biar fail_cap: Keupayaan<FileRead> = perlukan FileRead;
biar data = baca_fail(fail_cap, "config.txt");
```

### Effect System

Every function declares its effects. Pure functions have no effects. The effect system tracks:

- `Bersih` (Pure) — No side effects
- `Baca` (Read) — Memory/state read
- `Tulis` (Write) — Memory/state write
- `SistemFail` (FileSystem) — File I/O
- `Rangkaian` (Network) — Network I/O
- `Kripto` (Crypto) — Cryptographic operations
- `Rawak` (Random) — Random number generation
- `Masa` (Time) — Clock/time access
- `Proses` (Process) — Process management

Effects compose: if a function calls another function with `Tulis` effect, the caller must also declare `Tulis` (or a superset).

### Security Levels

The security lattice has 6 levels (ascending):
```
Awam (Public) ⊑ Dalaman (Internal) ⊑ Sesi (Session) ⊑ Pengguna (User) ⊑ Sistem (System) ⊑ Rahsia (Secret)
```

Information can flow up (from Public to Secret) but not down. Declassification requires explicit proof.

## Standard Library Modules

**Counts and the Backend column below are command-derived (2026-08-09) from the
builtin tables in `03_PROTO/crates/riina-codegen/src/builtins/` and the
compiled-backend boundary `riina_codegen::codegen_supports_builtin`.** The
authoritative per-builtin list is the generated `docs/api/STDLIB.md` (329
registered builtins, each with its own Backend marker).

| Module | BM Name | Builtins | Backend | Description |
|--------|---------|----------|---------|-------------|
| teks | Teks | 16 | all compiled | String operations |
| senarai | Senarai | 18 | all compiled | List operations |
| peta | Peta | 8 | all compiled | Hash maps |
| set | Set | 7 | all compiled | Hash sets |
| matematik | Matematik | 10 | 7 of 10 | Math functions (`baki`, `log2`, `rawak` are interpreter-only) |
| ujian | Ujian | 6 | 5 of 6 | Test assertions (`jangkakan` is interpreter-only) |
| masa | Masa | 7 | **none** | Time operations |
| fail | Fail | 8 | **none** | File I/O |
| json | Json | 5 | **none** | JSON parsing |
| net | Jaring | 9 | **none** | TCP sockets (real I/O, verified RFC 793 state machine) |
| vfs | Vfs | 5 | **none** | Virtual filesystem (verified access-control model) |
| keselamatan | Keselamatan | 42 | **none** | Taint sanitizers + sinks (`sanitasi_*`, `sql_*`, `http_*`, `csrf_*`) |

Conversions (`ke_teks`, `ke_nombor`, …), printing (`cetak`, `cetakln`), and the
numeric-tower constructors (`besar`, `perpuluhan`, `wang`, `titik_tetap`, `qmn`)
are registered directly rather than in a module table; all of them compile.

### ⚠ Type-checking does not imply compiling

**148 of the 329 builtins compile. The other 181 are interpreter-only.** A
program using any interpreter-only builtin type-checks and runs, but cannot be
built for native or WASM — lowering fails closed rather than miscompiling:

```bash
riinac check pelayan.rii   # Success!  Effect: Network
riinac run   pelayan.rii   # works — serves a real HTTP/1.1 200
riinac build pelayan.rii   # Codegen Error: unbound variable: jaring_dengar
```

If you are generating RIINA code that must be **compiled**, restrict yourself to
the `all compiled` modules above plus printing, conversions, and the numeric
tower. Anything touching the network, filesystem, JSON, time, or the security
sinks is `riinac run` only. Closing this gap is master plan **REQ-70** (Gate C).

## Formal Verification

RIINA's security properties are proven in Coq:
- **Type safety** (progress + preservation)
- **Non-interference** (secrets don't leak)
- **Effect soundness** (effects correctly tracked)
- **Capability safety** (capabilities cannot be forged)
- **Taint tracking correctness** (tainted data properly tracked)

The proofs are in `02_FORMAL/coq/` with 4,885 Qed proofs (active build) and 0 admits.

## Compiler

The RIINA compiler (`riinac`) supports:
- `riinac check <file.rii>` — Parse and typecheck (accepts all 329 builtins)
- `riinac run <file.rii>` — Interpret (runs all 329 builtins)
- `riinac build <file.rii>` — Compile to native via C (**only the 148 compiled
  builtins**; fails closed on the rest — see the warning above)
- `riinac emit-c <file.rii>` — Emit C code (same 148-builtin limit)
- `riinac fmt <file.rii>` — Format source
- `riinac doc <file.rii>` — Generate HTML docs
- `riinac lsp` — Start LSP server
- `riinac repl` — Interactive REPL

## When Writing RIINA Code

1. Use Bahasa Melayu keywords (fungsi, biar, kalau, etc.)
2. Annotate effects on all impure functions
3. Use `Rahsia<T>` for sensitive data
4. Use capabilities for resource access
5. Sanitize tainted data before use
6. Provide proofs for declassification
7. Keep functions pure when possible
