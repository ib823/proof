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
Do NOT trust this prompt — verify every status by running commands (Prime Directive:
Paranoid-Absolute Verification). metrics.json is the ONLY source of truth for counts.

## STEP 1 — ORIENT (read, in order)
1. CLAUDE.md (operational), then RIINA_MASTER_PLAN.md Part 11 (Active Gate Marker)
   + Part 3 (REQ registry). Part 8 = the 8-step protocol.
2. `git status`, `git log --oneline -15`.
3. Fresh clone → first: `bash 00_SETUP/scripts/install_hooks.sh` (.git/hooks is
   not tracked; pre-push runs `riinac verify --full`, which builds Coq).

## STEP 2 — PROVISION (nothing is pre-installed in a fresh container)
- Rust 1.94.1 — pinned by rust-toolchain.toml; `cargo --version`.
- Rocq 9.2 (PRIMARY, required) via opam:
    sudo apt-get update && sudo apt-get install -y opam libgmp-dev   # libgmp-dev = zarith dep
    opam init --bare -y && opam switch create rocq --packages=ocaml-system.4.14.1 -y
    eval $(opam env --switch=rocq) && opam install rocq-core rocq-stdlib -y --assume-depexts
  NOTE: Rocq 9.2 ships the `rocq` binary (NOT `coqc`; `coqc` was removed). The
  Makefile is rocq-9.x-native (`$(COQBIN)rocq compile`) and `riinac verify`
  detects `rocq` (fixed this session). `rocq compile` runs with only COQBIN+PATH
  set (no full opam env needed) — that is what the pre-push hook relies on.
- Smoke/executable lanes (optional, unlock Gate D1): `bash scripts/provision-smoke-toolchains.sh`
  provisions F* 2025.12.15, TLA2Tools 1.7.4, Alloy 6.2.0, Isabelle — all verified
  this session (F* 3 lemmas / TLA 5 / Alloy 6 / Isabelle RIINA_CORE build pass).
  DO NOT commit a metrics.json regenerated WITH these provisioned — it flips the
  smoke-lane claim fields (smokeBuildOk=true) which overclaims vs the canonical
  build; keep the deliberate Gate-D "generated/smoke-only" values.
- Lean 4.16 (optional, NOT provisioned this session) via elan; needed for T2a.
  Do NOT bump to 4.30 (blocked by network policy AND the wrong lever).
- z3 (optional, NOT installed) — needed for SMT lane (T2f).

## STEP 3 — VERIFY BASELINE (run; capture real output; 0 regressions)
- `bash scripts/audit-docs.sh`                    → exit 0, 0 discrepancies
   (2 expected WARNs: Lean syntactic-sorry; Coq warning-status stale — see T4c)
- `bash scripts/update-proof-ledger.sh --check`   → up to date
- `RUST_MIN_STACK=16777216 cargo test --all --manifest-path 03_PROTO/Cargo.toml`
- `cargo test --all --manifest-path 05_TOOLING/Cargo.toml`
- `cargo clippy --all-targets -- -D warnings` (both workspaces) → clean
- `eval $(opam env --switch=rocq) && make -C 02_FORMAL/coq -j$(nproc)` → green
- Confirm metrics.json counts via grep, never by copying docs. Honest claim state:
  Coq = mechanized; the other 9 lanes = generated/smoke (not independent verification).

## STEP 4 — ASSESS & EXECUTE (active gate: C — Standard Library Hardening)
Gates A & B are CLOSED. Read Part 11 Gate C rows for what landed. Remaining tractable:
- Gate C: networking (real TCP/TLS + Coq network model); strings NFC/confusables
  (UAX#15/UTS#39); numeric tower BigInt/decimal/fixed-point; true 64-bit WASM
  (i32→i64 mixed-rep refactor — the owner previously chose the bounded ">=2^32
  error" path; CONFIRM before the full refactor); wiring the new `VirtualFs`
  (riina-os/src/vfs.rs) into the surface `file_*` builtins (needs path→inode→uid).
  Set `set_kesatuan`/`persilangan` are ~O(n^2) (benchmark finding, reports/stdlib_bench.md);
  a faster impl needs `Value: Eq+Hash` (Closure blocks it) — a larger refactor.
- Gate D1 (smoke lanes provisioned): grow F* (≥50)/TLA(≥5)/Alloy(≥10)/Isabelle(≥20);
  provision Lean + improve elaboration (T2a — Phase-10 LLM prerequisite); install z3
  for SMT-checking a Coq IFC theorem (T2f). Only flip a claimLevels entry when a real
  tool verifies real content; never count a stub as a proof.
- Gate E: refresh the Coq warning budget (clears the stale WARN, advances REQ-30):
  `python3 scripts/audit-coq-warnings.py --mode build --clean --enforce-budget`
  (run it as your LAST commit so status.repoHead stays fresh = HEAD or HEAD^);
  coverage ≥80% (needs tarpaulin/llvm-cov); a dependency-free fuzz sweep (cargo-fuzz
  would violate Law 8 — extend the LCG property-test pattern instead).
Cannot do in-session: external crypto audit (REQ-28/Gate G), certifications (Gate H),
website deploy (needs the `riina` remote), public-branch reconciliation.

## RULES
- Part 8 protocol. Develop on a managed-session branch; merge to main when green.
- Forbidden: Admitted in Coq; failing tests; stub-as-proof; inflated/copied metrics;
  new planning docs (update RIINA_MASTER_PLAN.md only); --no-verify; force-push main.
- 03_PROTO AND 05_TOOLING enforce Law 8 (zero third-party RUNTIME deps); 05_TOOLING
  permits dev-deps like criterion, 03_PROTO has none — keep benchmarks dep-free there.
- VERIFY AFTER every change (re-run STEP 3). No regressions, no metric decrease.

Begin with STEP 1 and report what you actually find (not what this prompt asserts).
```

---

*Maintenance: if the active gate or REQ priorities change, update this pointer from
`RIINA_MASTER_PLAN.md` Part 11 — or delete it; it is disposable, not authoritative.*
