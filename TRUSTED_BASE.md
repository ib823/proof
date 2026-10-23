# Trusted base

> **Generated — do not edit by hand.** Regenerate with `python3 scripts/generate-ledgers.py`;
> sizes and tool versions measured by `--capture` at commit `8840b0a92`. REQ-103.

Everything a RIINA guarantee depends on that is not itself proven (mandate S1.11). Sizes
are non-blank lines of Rust source, excluding test files.

| Component | What | Size | Note |
|---|---|---|---|
| Rocq kernel | pinned 9.1.1 (`scripts/provision-coq.sh`); captured: The Rocq Prover, version 9.1.1 | external | Checks every Coq proof; trusted. |
| Rocq stdlib axioms | `FunctionalExtensionality.functional_extensionality_dep` (used by well_typed_SN) | external | From `Print Assumptions` on the capstones. |
| Trusted interface (`Parameter`) | 29 declarations in the active build (listed below) | — | Axioms in all but name; none is used by a capstone (see HEADLINE_THEOREMS.md). |
| Section premises | `well_typed_SN` | — | A CONDITIONAL capstone rests on premises; it is never a guarantee. |
| Extraction toolchain | none yet: no Coq code is extracted (REQ-54 S3) | — | Will join the trusted base with assured mode (REQ-100). |
| Rust toolchain | pinned 1.94.1 (`rust-toolchain.toml`); captured: rustc 1.94.1 (e408947bf 2026-03-25) | external | Compiles riinac. |
| Elaboration and checking (riinac frontend) | lexer, parser, type checker, types | 20583 | Not proven to implement the Coq model; differential conformance is REQ-111. |
| Interpreter | riina-codegen `interp.rs`, `value.rs`, builtins | 14516 | Reference for the backend differentials. |
| C backend and runtime prelude | riina-codegen `lower.rs`, `ir.rs`, `emit.rs`; a minimal program emits 5671 lines of C | 12993 | Not formally verified; differential-tested (REQ-59). |
| WASM backend | riina-codegen `wasm.rs`, `wasm_encode.rs` | 8723 | No runtime capability gate yet (REQ-114). |
| Builtins | 374 registered, 342 compile (`docs/api/STDLIB.md`) | in the interpreter and C backend rows | Builtin semantics are not modelled in Coq (REQ-99). |
| C compiler | the host `cc`; captured: cc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0 | external | Supported: gcc or clang on Linux and macOS; Windows only under WSL. MSVC is unsupported (the emitted C uses POSIX headers; owner ruling on REQ-102, option B). |
| Package manager | riina-pkg | 6400 | Enforces manifest effect permissions (tested). |
| Compliance checker | riina-compliance | 7750 | Heuristic rules; evidence, not certification. |
| Cryptography | riina-core (05_TOOLING) | 14704 | Experimental, not audited, not validated. |
| Compiler driver | riinac | 11367 | Includes `riinac verify`. |
| Operating system and hardware | the host OS, libc and CPU; captured host: Linux 6.18.44-fc-v153 x86_64 | external | No hardware-level guarantee; constant time holds only in the reduction-count model. |
| Development and CI tools (not shipped) | wasmtime (wasmtime 27.0.0 (8eefa236f 2024-11-20)), z3 (Z3 version 4.8.12 - 64 bit) | external | Used by tests and the SMT lane only. |

## Trusted interface: the `Parameter` declarations

- `synthesize` — `02_FORMAL/coq/domains/PhysicalSecurity.v:113`
- `synthesis_preserves_semantics` — `02_FORMAL/coq/domains/PhysicalSecurity.v:116`
- `extract_paths` — `02_FORMAL/coq/domains/PhysicalSecurity.v:129`
- `timing_analysis` — `02_FORMAL/coq/domains/PhysicalSecurity.v:136`
- `timing_analysis_correct` — `02_FORMAL/coq/domains/PhysicalSecurity.v:137`
- `trojan_scan` — `02_FORMAL/coq/domains/PhysicalSecurity.v:145`
- `trojan_scan_sound` — `02_FORMAL/coq/domains/PhysicalSecurity.v:146`
- `operation_cycles` — `02_FORMAL/coq/domains/PhysicalSecurity.v:157`
- `crypto_operation` — `02_FORMAL/coq/domains/PhysicalSecurity.v:162`
- `crypto_constant_time` — `02_FORMAL/coq/domains/PhysicalSecurity.v:163`
- `x_ray_compare` — `02_FORMAL/coq/domains/PhysicalSecurity.v:205`
- `x_ray_soundness` — `02_FORMAL/coq/domains/PhysicalSecurity.v:212`
- `chip_puf` — `02_FORMAL/coq/domains/PhysicalSecurity.v:216`
- `puf_physically_unique` — `02_FORMAL/coq/domains/PhysicalSecurity.v:219`
- `chip_puf_at_time` — `02_FORMAL/coq/domains/PhysicalSecurity.v:225`
- `puf_temperature_stable` — `02_FORMAL/coq/domains/PhysicalSecurity.v:227`
- `authenticate_chip` — `02_FORMAL/coq/domains/PhysicalSecurity.v:235`
- `authentication_sound` — `02_FORMAL/coq/domains/PhysicalSecurity.v:241`
- `fab_integrity_check` — `02_FORMAL/coq/domains/PhysicalSecurity.v:249`
- `fab_check_sound` — `02_FORMAL/coq/domains/PhysicalSecurity.v:251`
- `detect_probe` — `02_FORMAL/coq/domains/PhysicalSecurity.v:301`
- `mesh_detects_probing` — `02_FORMAL/coq/domains/PhysicalSecurity.v:303`
- `voltage_monitor` — `02_FORMAL/coq/domains/PhysicalSecurity.v:320`
- `voltage_monitor_correct` — `02_FORMAL/coq/domains/PhysicalSecurity.v:321`
- `temp_monitor` — `02_FORMAL/coq/domains/PhysicalSecurity.v:328`
- `temp_monitor_triggers_shutdown` — `02_FORMAL/coq/domains/PhysicalSecurity.v:329`
- `power_trace` — `02_FORMAL/coq/domains/PhysicalSecurity.v:343`
- `crypto_power_independent` — `02_FORMAL/coq/domains/PhysicalSecurity.v:350`
- `argon2id_hash` — `02_FORMAL/coq/domains/VerifiedIdentity.v:141`
