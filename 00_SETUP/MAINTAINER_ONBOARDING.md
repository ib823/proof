# Maintainer Onboarding — Provision to Push (REQ-56)

**Audience:** maintainer candidate #2 (and every one after).
**Goal:** demonstrate *full provision-to-push capability* — the REQ-56 DONE
criterion is that a session run by you lands a **gate-green commit** on `main`.
**Authority:** `RIINA_MASTER_PLAN.md` is the ONLY planning document;
`CLAUDE.md` is the operational rulebook. This file adds nothing to either — it
is the walk-through of the path they already define, in the order a fresh
maintainer actually hits it.

Every command below was executed and verified in a real fresh-container
session (2026-08-08/09, the session that landed PR #56) before being written
here. If a step fails for you, that is a finding — record it, don't work
around it silently.

---

## 0. What you are maintaining

RIINA is a formally verified programming language (Bahasa Melayu syntax,
`.rii`). The repository's one non-negotiable: **every published claim is
re-derivable by command**. You never copy a metric from a document — you run
the command that produces it. The single source of truth for published counts
is `website/public/metrics.json`. When you finish reading this file, read in
order:

1. `CLAUDE.md` — prime directives, forbidden actions, build commands
2. `RIINA_MASTER_PLAN.md` Part 0–1 (identity), Part 8 (session protocol),
   Part 11 §Active Gate Marker (what is being worked on right now)
3. `NEXT_SESSION.md` — the disposable session-bootstrap pointer

## 1. Access you need (owner grants)

- GitHub: write access to the development repository (branch pushes; note that pushing
  **tags** and deleting refs may be blocked in managed environments — releases
  are cut by the owner).
- The website mirror `ib823/riina` (separate repo) only if you will run
  website deploys.
- No other credentials exist. There are no cloud services, no package
  registries, no secrets. (Law 8: zero third-party runtime dependencies —
  the toolchain below is everything.)

## 2. Provision a fresh machine (verified order)

```bash
# Rust — pinned by rust-toolchain.toml (do not upgrade it ad hoc)
cargo --version           # expect the pinned toolchain to auto-install

# Rocq (PRIMARY prover — required). The script IS the pin; CI runs the same
# script, so a hand-install can silently diverge — never hand-install.
apt-get update && apt-get install -y opam libgmp-dev m4
bash scripts/provision-coq.sh            # ~15 min (builds OCaml + Rocq)
bash scripts/provision-coq.sh --check    # exits 1 on any pin mismatch
eval $(opam env --switch=rocq); export COQBIN="$HOME/.opam/rocq/bin/"

# wasmtime — required by the C/WASM differential. INSTALL IT rather than
# setting RIINA_ALLOW_MISSING_BACKEND_TOOLS=1: that opt-out silences the
# exact check that caught a real codegen regression (2026-08-04) and a
# >=2^63 silent-wrong-result WASM bug (2026-08-08).
curl -sSfL -o /tmp/wasmtime.tar.xz https://github.com/bytecodealliance/wasmtime/releases/download/v27.0.0/wasmtime-v27.0.0-x86_64-linux.tar.xz
tar xf /tmp/wasmtime.tar.xz -C /tmp && cp /tmp/wasmtime-*/wasmtime /usr/local/bin/

# Git hooks — NOT tracked; a fresh clone has none. Without them your commits
# skip verification and will be rejected in review.
bash 00_SETUP/scripts/install_hooks.sh

# Optional lanes (Gate D work only): smoke toolchains, Lean, z3
# bash scripts/provision-smoke-toolchains.sh
```

## 3. Verify the baseline (before you change anything)

Run all of these; every one must pass before your first edit. This is Part 8
step 4 (VERIFY BEFORE) — the numbers they print are the baseline you must not
regress.

```bash
bash scripts/audit-docs.sh                      # 0 discrepancies required
bash scripts/update-proof-ledger.sh --check     # ledgers up to date
RUST_MIN_STACK=16777216 cargo test --all --manifest-path 03_PROTO/Cargo.toml
cargo test --all --manifest-path 05_TOOLING/Cargo.toml
(cd 03_PROTO && cargo clippy --all-targets -- -D warnings)   # --all-targets, not the narrower form
(cd 05_TOOLING && cargo clippy --all-targets -- -D warnings)
eval $(opam env --switch=rocq) && make -C 02_FORMAL/coq -j$(nproc)
```

Notes proven the hard way (each caught a real issue at least once):
- `RUST_MIN_STACK` is required — without it a bigint test overflows the stack.
- `cargo clippy -- -D warnings` (without `--all-targets`) does not lint test
  targets and has reported "clean" while the full form failed.
- Counting Coq admits: use `^\s*Admitted\.` / `^\s*Axiom\s` / `^\s*Abort\.`
  (with the period) — without it you match prose and invent hits.

## 4. The rules that are actually enforced

- **Branch:** develop on `main` or a managed-session branch; **never** commit
  to `public` or `gh-pages` (the public tree is a generated mirror — work
  merged only there is overwritten by the next reconcile).
- **Hooks are the law:** pre-commit runs docs audit + fast verify; pre-push
  runs `riinac verify --full` + strict security gates. `--no-verify` is
  forbidden — if a gate misfires, fix the gate with a verified, path-scoped,
  documented exemption (see the 2026-08-08 `security-gates.sh` precedent).
- **Forbidden, always:** `Admitted`/failing tests in a commit; stub-as-proof;
  copying metrics from docs; new planning documents (update
  `RIINA_MASTER_PLAN.md` instead); force-push to `main`.
- **Metrics flow:** change code → run the full suites → regenerate/patch
  `website/public/metrics.json` → `scripts/sync-metrics.sh` propagates
  banners → `scripts/audit-docs.sh` must return 0 discrepancies. In a
  container missing z3 / the noncoq report / the deprecated Coq tree,
  `generate-metrics.sh` silently DOWNGRADES canonical fields — restore the
  canonical values and patch only what you actually re-verified
  (`NEXT_SESSION.md` records this trap in detail).
- **Honesty over progress:** a claim level flips only when a real tool
  verified real content in this tree. When in doubt, claim less.

## 5. Your demonstration task (the DONE criterion)

Pick a small open item from `RIINA_MASTER_PLAN.md` Part 3 in the active gate
(Part 11 §Active Gate Marker) — a doc-consistency fix, a test-coverage
increment, or a `KNOWN_DIVERGENT` example repair are the right size. Then:

1. Baseline (§3) — record the numbers.
2. Make the change; add tests that fail without it.
3. Re-run §3 — zero regressions, no metric decrease.
4. Commit with the `[TRACK_X] TYPE:` format; let every hook run.
5. Push your branch; open a PR to `main`; land it.

When that commit is on `main` with all gates green, REQ-56's first deliverable
is met — by definition, not by anyone's say-so.

## 6. Candidate profile (for the owner's search)

Non-negotiable: reads Coq (can re-verify a proof, judge an `Admitted`);
competent in Rust; temperamentally suited to *paranoid verification* — the
kind of person who re-runs a green suite because the log looked odd.
Strongly preferred: Bahasa Melayu literacy (the language surface is BM-first);
formal-methods background (session types, IFC, or compiler verification);
prior open-source maintainership. The interview IS §5 — there is no better
signal than watching the demonstration task happen.

## 7. Custody (owner decision — options analyzed in REQ-56, Part 3)

Until an institutional custodian exists, the succession plan is this
repository itself: everything needed to continue the project is in-tree,
pinned, and hook-enforced (succession-as-code). Keep it that way — any
knowledge that exists only in someone's head is a REQ-56 regression.
