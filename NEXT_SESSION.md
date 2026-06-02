# NEXT_SESSION.md — Session Bootstrap (orientation only)

> **This is NOT a plan.** `RIINA_MASTER_PLAN.md` is the ONLY planning authority
> (CLAUDE.md Prime Directive #3). This file is a one-screen pointer to resume work
> seamlessly. It hard-codes **no metrics** — re-derive every number from commands
> and `website/public/metrics.json` (the single source of truth). Trust nothing
> here; verify everything (Paranoid-Absolute Verification).

Paste the block below into a fresh session, or just read it and begin.

---

```
You are resuming work on RIINA (formally-verified language, Bahasa Melayu syntax).
All prior work is merged to `main`. Do NOT trust this prompt — verify every status
by running commands (Prime Directive: Paranoid-Absolute Verification).

## STEP 1 — ORIENT (read, in order)
1. CLAUDE.md (operational), then RIINA_MASTER_PLAN.md (the ONLY plan).
2. `git status` (on main, clean), `git log --oneline -15`.
3. Fresh clone → first: `bash 00_SETUP/scripts/install_hooks.sh`.
4. Provision toolchains (NOT pre-installed in a fresh container):
   - Rocq 9.2 via opam: `eval $(opam env --switch=rocq)`
   - Rust 1.94.1 (pinned in rust-toolchain.toml)
   - Lean 4.16 via elan (NOTE: 4.30 install is blocked by the network policy —
     see the master plan Lean lane row), plus wasmtime / F* / Alloy / TLA2Tools as needed.

## STEP 2 — VERIFY BASELINE (run; capture real output)
- `bash scripts/audit-docs.sh`                         → exit 0, 0 discrepancies
- `bash scripts/public-quality-gates.sh`               → PASS
- `bash scripts/update-proof-ledger.sh --check`        → up to date
- `RUST_MIN_STACK=16777216 cargo test --all --manifest-path 03_PROTO/Cargo.toml`
- `cargo test --all --manifest-path 05_TOOLING/Cargo.toml`
- `cargo clippy --all-targets -- -D warnings` (both workspaces) → clean
- `make -C 02_FORMAL/coq -j$(nproc)`                   → green on Rocq 9.2
- `website/public/metrics.json` is the SINGLE source of truth for all counts and
  per-lane claim levels. Honest state: Coq = mechanized; ALL other lanes =
  generated/smoke. Confirm via PROOF_STATUS.md, do not copy numbers from docs.

## STEP 3 — ASSESS & PLAN (the task)
Read RIINA_MASTER_PLAN.md Part 11 (Active Gate Marker = B — Compiler Enforcement
Parity; Gate A CLOSED) and Part 3 (REQ registry). Produce a step-by-step plan for
the highest-priority open work:

- REQ-27 (P0, PARTIAL) — Compiler enforcement parity. Done: 6 pos+neg parity
  properties (riina-typechecker `gate_b_parity`); WASM/C differential mostly
  byte-equal (a few tracked-divergent). Open: full parse→project→impl session-type
  pipeline; full IFC side-channel/aliasing counterexample suite; per-program
  constant-time codegen; the remaining KNOWN_DIVERGENT WASM examples.

Carry forward the recorded research constraints (01_RESEARCH/29_REFRESH_2026H1/):
- Constant-time guarantee stated relative to a hardware-software LEAKAGE CONTRACT;
  excludes DMP/GoFetch-class leakage (Gate B CT row, REQ-32).
- Blockchain ZKP (REQ-19): default to zk-STARK (SNARK trusted setup violates
  "No Assumptions").
- Phase-10 LLM-for-RIINA depends on first FIXING LEAN ELABORATION (the open
  LLM-proving SOTA is Lean-4-only); a Lean version bump is the wrong lever.

## RULES
- Follow RIINA_MASTER_PLAN.md Part 8 (8-step protocol). Develop on a managed
  session branch; sync to main via merge when green.
- Forbidden: Admitted in Coq, failing tests, stub-as-proof, copied metrics, new
  planning docs (update RIINA_MASTER_PLAN.md only).
- Present the plan for approval BEFORE executing.

Begin with STEP 1 and report what you actually find (not what this prompt asserts).
```

---

*Maintenance: if the active gate or REQ priorities change, update this pointer from
`RIINA_MASTER_PLAN.md` Part 11 — or delete it; it is disposable, not authoritative.*
