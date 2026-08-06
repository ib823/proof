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
- Rocq (PRIMARY, required) — do NOT hand-install; the script IS the pin, and CI
  calls the same one so the two cannot silently diverge:
    apt-get update && apt-get install -y opam libgmp-dev m4
    bash scripts/provision-coq.sh            # ~15 min (builds the OCaml compiler)
    bash scripts/provision-coq.sh --check    # exits 1 on mismatch
    eval $(opam env --switch=rocq); export COQBIN="$HOME/.opam/rocq/bin/"
  Pin: rocq-core.9.1.1 + rocq-stdlib.9.1.0 on ocaml-base-compiler.4.14.2.
  Rocq 9.x ships the `rocq` binary (NOT `coqc`); the Makefile is rocq-native
  (`$(COQBIN)rocq compile`) and `riinac verify` detects `rocq`. `rocq compile`
  runs with only COQBIN+PATH set — that is what the pre-push hook relies on.
- `wasmtime` (needed by the C/WASM differential) — NOT preinstalled, but it does
  install; GitHub release downloads work through the proxy:
    curl -sSfL -o /tmp/wasmtime.tar.xz https://github.com/bytecodealliance/wasmtime/releases/download/v27.0.0/wasmtime-v27.0.0-x86_64-linux.tar.xz
    tar xf /tmp/wasmtime.tar.xz -C /tmp && cp /tmp/wasmtime-*/wasmtime /usr/local/bin/
  INSTALL IT rather than setting RIINA_ALLOW_MISSING_BACKEND_TOOLS=1. That opt-out
  makes `corpus_c_wasm_differential` execute NOTHING — and that differential is the
  check that caught the last regression to reach main. Use the opt-out only if the
  install genuinely fails, and say so when you do.
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
  (RUST_MIN_STACK is required — without it `test_bigint_factorial_via_letrec`
  overflows the stack when riina-codegen is tested on its own)
- `cargo test --all --manifest-path 05_TOOLING/Cargo.toml`
- `cargo clippy --all-targets -- -D warnings` (both workspaces) → clean.
  Note `--all-targets`: the narrower `cargo clippy -- -D warnings` in CLAUDE.md
  does not lint test targets and has read "clean" while this form did not.
- `eval $(opam env --switch=rocq) && make -C 02_FORMAL/coq -j$(nproc)` → green
- Counting admits: use `^\s*Admitted\.`, `^\s*Axiom\s`, `^\s*Abort\.` (with the
  period). Dropping it matches comment lines reading "Axioms: 0" and invents
  hits that are not there.
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
Website deploy IS possible in-session (done 2026-08-05) — `ib823/riina` is a SEPARATE repo, so
attach it (`add_repo` with push access), `git remote add riina https://github.com/ib823/riina.git`,
then `bash scripts/deploy-website.sh`. It force-pushes `gh-pages`, which is a branch push and
therefore allowed.
Cannot do in-session: external crypto audit (REQ-28/Gate G), certifications (Gate H),
public-branch reconciliation, and **pushing git TAGS or deleting refs** — the proxy returns
`403 Forbidden` on the `git-receive-pack` POST for those (branch creates/updates are fine), so a
release's `git push origin vX.Y.Z` must be done by the owner. See Part 11 §v0.4.0 RELEASE.

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
