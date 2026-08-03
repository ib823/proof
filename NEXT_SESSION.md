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
- Rocq **9.1.1** (PRIMARY, required) via opam. This exact sequence was run and
  verified end-to-end on a fresh container 2026-08-02 (built all 328 files):
    sudo apt-get update && sudo apt-get install -y opam libgmp-dev   # libgmp-dev = zarith dep
    opam init --bare -y --disable-sandboxing    # bubblewrap fails in an unprivileged container
    opam switch create rocq ocaml-base-compiler.4.14.2 -y
    eval $(opam env --switch=rocq)
    opam install -y rocq-core.9.1.1 rocq-stdlib.9.1.0 --assume-depexts
  NOTE: **9.1.1, not 9.2.** The Coq Makefile header says "GNUMakefile for Rocq
  9.1.1", CLAUDE.md was corrected to 9.1.1 in the thirteenth session, and the CI
  job is named "Coq active build (Rocq 9.1.1)". `metrics.json` `coq.prover` still
  says "Rocq 9.2" — that field is stale (recorded as FINDING 3 in Part 11) and
  `audit-docs.sh` does not check the prover string.
  Rocq 9.x ships the `rocq` binary (NOT `coqc`; `coqc` was removed). The
  Makefile is rocq-9.x-native (`$(COQBIN)rocq compile`) and `riinac verify`
  detects `rocq`. `rocq compile` runs with only COQBIN+PATH set (no full opam env
  needed) — that is what the pre-push hook relies on.
  Cost: ~25 min wall-clock to provision. The build itself is only ~2m15s on 4 cores.
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
Expected values below were all measured on a fresh container at `a5ee2ce`
(2026-08-02). Re-derive them; do not copy them.
- `bash scripts/audit-docs.sh`                    → exit 0, 0 discrepancies
   (**4** expected WARNs: Lean syntactic-sorry; pre-commit AND pre-push hooks
   absent on a fresh clone; Coq warning-status stale — see T4c)
- `bash scripts/update-proof-ledger.sh --check`   → "Proof ledgers are up to date."
- `bash scripts/generate-sbom.sh --check`         → both SBOMs up to date
- `RUST_MIN_STACK=16777216 cargo test --all --manifest-path 03_PROTO/Cargo.toml`
  → **2912 passed / 0 failed / 3 ignored**
- `cargo test --all --manifest-path 05_TOOLING/Cargo.toml` → **304 / 0**
- `cargo clippy -- -D warnings` (both workspaces) → exit 0. Use THIS form — it is
  what CLAUDE.md, CONTRIBUTING.md and `verify.rs::run_clippy` enforce.
  **`--all-targets` is NOT clean** (4 lints in test code:
  `riinac/tests/fuzz_robustness.rs:257` unnecessary_cast;
  `riina-core/src/crypto/mod.rs:358/365/370` assert_eq-with-literal-bool).
  Recorded as FINDING 2 in Part 11 — fix the lints or drop the claim, but do not
  assume the stricter form passes.
- `eval $(opam env --switch=rocq) && make -C 02_FORMAL/coq -j$(nproc)` → exit 0,
  **328/328 files**, ~2m15s on 4 cores. Then re-derive from the compiled set:
  **Qed 12,626 / Admitted 0 / Abort 0 / Axiom 0 / Parameter 30**. The build emits
  **180 `Print Assumptions` reports, every one "Closed under the global context"**
  — that is the kernel-level axiom-freedom evidence, stronger than any grep.
- Corpus: `07_EXAMPLES` = 165 `.rii`, **64 pass `riinac check` / 101 fail**.
- Confirm metrics.json counts via grep, never by copying docs. Honest claim state:
  Coq = mechanized; the other 9 lanes = generated/smoke (not independent verification).
- **CI is green as of `a5ee2ce`** (first green `verify` run in 8+ pushes). It had
  been red because the workflow pinned `dtolnay/rust-toolchain@1.84.0` against a
  1.94.1 MSRV. No in-repo gate checks "is CI actually green" — check it yourself.

## STEP 4 — ASSESS & EXECUTE (active gate: C — Standard Library Hardening)

**START HERE — the 2026-08-02 audit's structural conclusion (Part 11 addendum).**
Gate C's only open exit criterion is REQ-28, the external crypto audit, which the
owner DEFERRED on 2026-06-10. Gate C is therefore budget-blocked, not work-blocked,
and no session can close it. The same is true of every other gate's remaining
blocker: certification (H), an offline signing key (F), maintainer recruitment (J),
a Nix-capable runner (F). **Do not plan around "closing gates" — you will stall on
day one.**

The highest-leverage work a session CAN finish is the corpus/language-surface gap.
Measured at `a5ee2ce`: 165 examples, 64 pass, **101 fail**, and the failures cluster
hard — 53 unexpected-token + 18 expected-identifier (**70% parse-level**), 15
variable-not-found (**15%, the REQ-44(b) forward-reference gap**), then 5 effect /
4 expected-type / 3 type-mismatch / 1 each linearity, session, CRDT. **Those two
lanes are 85% of the gap.** REQ-44(b) is independently reproduced: a helper defined
LATER fails `riinac check` with "Variable not found"; the byte-identical program
with it defined FIRST succeeds. Per REQ-44's own de-risking note the forward-ref
half is a **Rust-only** typechecker+evaluator change, NOT Coq-blocked — the core
Coq calculus has no recursion constructor to widen, and `foundations/RecursionSafety.v`
already mechanizes the rule the implementation uses.

Also unblocked and session-sized: Gate I's three missing documents (Language
Reference, compiler-internals doc, stability/migration policy) and Gate E's
continuous-fuzz tail.

Read Part 11 Gate C rows for what landed. Remaining tractable:
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
