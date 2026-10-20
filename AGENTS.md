# AGENTS.md — RIINA™ Repository Instructions for AI Agents

**For Codex, Devin, and any autonomous AI agent entering this codebase.**

## Before ANY Action

1. Read `RIINA_MASTER_PLAN.md` — the ONLY planning authority
2. Read `CLAUDE.md` — operational instructions (tools, paths, build commands)
3. Run `git status` — must be on `main` branch (or your assigned feature branch), check for dirty files
4. Re-verify metrics by running the commands in `RIINA_MASTER_PLAN.md` Part 0 — do NOT trust the table below blindly

## Current State (2026-10-20, generated from `website/public/metrics.json`)

| Metric | Value |
|--------|-------|
| Version | 0.4.0 |
| Coq proofs | 1,679 core Qed, 9,719 model Qed, 1,443 excluded Qed (vacuous, example, counterexample or test). 0 Admitted, 0 Abort, 0 `Axiom`, 29 `Parameter`s (trusted hardware interface; no capstone theorem depends on them). 335 active files. Never quote a raw Qed total (mandate S2.7) |
| Lean theorems | 0 — the generated port was archived 2026-10-20 (D6, preserved at `fd23fbdb8`); REQ-67(b) re-proof not started |
| Isabelle lemmas | 0 — lane retired (REQ-67g), corpus archived |
| F* / TLA+ / Alloy / SMT | Hand-written artifacts only; SMT scoped set (37 properties) is mechanized; the rest are smoke-level (`metrics.json` is authoritative) |
| Cross-prover total | None. Counts from different provers are never added together (ruling D6) |
| Rust tests | 3,615 tests in `03_PROTO` (18 crates), all passing; `05_TOOLING` has its own suite |
| Examples | 172 .rii files; 82 pass `riinac check` |
| Claims | Coq mechanized; SMT mechanized at the REQ-67(a) scope (37 properties); TLA+/Alloy/Verus/Kani/TV generated (hand-written drafts, quarantined); F*/Isabelle retired; Lean empty |
| Ledgers | `HEADLINE_THEOREMS.md`, `PROPERTY_LEDGER.md`, `TRUSTED_BASE.md`, `PROOF_STATUS.md`, `AXIOMS.md`, `docs/api/STDLIB.md` (all generated) |

**Scope a new session must NOT forget:**
- Strong normalization, non-interference and constant time (reduction count) are proven only for the reference-free, `fix`-free core (REQ-89 is the extension). `well_typed_SN` for the full calculus is vacuous: its conclusion is false with higher-order references (REQ-84).
- The compiler is tested against the Coq model, not proven to implement it. The C backend is differential-tested only. In-house crypto is experimental and unaudited. No independent audit has been published.
- The generated non-Coq corpora were archived out of `main` on 2026-10-20 (owner ruling D6). They are preserved at commit `fd23fbdb8`; restore one lane with `git checkout fd23fbdb8 -- 02_FORMAL/<lane>`. Never count or cite them, and never run `scripts/generate-*.py` against `main` (they now refuse without an override).
- Public wording follows the hardening mandate's truth-in-claims table (`04_SPECS/governance/HARDENING_MANDATE.md` section 5, approved as ruling D9).
- See `PROOF_STATUS.md` for the live ledger.

## Next-Session Pickup (read this BEFORE picking a task)

1. Open `RIINA_MASTER_PLAN.md` Part 11: the §Active Gate Marker and the section
   "Hardening Mandate (owner-adopted 2026-10-19) — tracking". Read the current gate there;
   this file does not repeat it, so it cannot go stale.
2. From Part 3 (Requirements Registry), pick the highest-priority open REQ in the active
   gate, P0 before P1 before P2. P0 security and soundness fixes run whatever the gate.
3. Owner decisions are recorded in Part 11; anything still marked OWNER ACTION (repository
   visibility, a named human reviewer, counsel review of the licence drafts) is not yours
   to decide.
4. Follow `RIINA_MASTER_PLAN.md` Part 8 (universal session protocol) for the work itself.

## Scope freeze

The language surface is frozen (REQ-108, ruling D4): no new keywords, effects, types or
compliance profiles except work a hardening standard requires and the REQ-33 Syariah
track. `03_PROTO/crates/riinac/tests/scope_freeze.rs` enforces the pinned counts. The
phase roadmap in `RIINA_MASTER_PLAN.md` Part 4 is history and future direction, not the
current queue.

## Branch Policy

**Default branch is `main`.** Managed-session feature branches (`claude/*`, `codex/*`) are permitted when a session assigns one; they sync back to `main`.
- Never commit to `public` (managed by `scripts/sync-public.sh` only).
- Never commit to `gh-pages` (managed by `scripts/deploy-website.sh` only).

## Critical Operational Rules

### After EVERY Coq change:
```bash
bash scripts/generate-metrics.sh
bash scripts/sync-metrics.sh     # also regenerates this file (scripts/generate-agent-files.py)
bash scripts/audit-docs.sh
```

### Lane claim levels
`reports/noncoq_mechanized_status.json` is written only by
`scripts/check-noncoq-mechanized.sh`, from real tool runs. Never edit it by hand, and
never set a lane's `full_build_ok`, `full_exec_ok` or `mechanized_ready` yourself:
that would publish a claim no tool has checked.

### Commit, push, deploy:
```
Stage specific files → commit "[TRACK_X] TYPE: ..." → push (pre-push runs riinac verify --full; never --no-verify)
→ scripts/sync-public.sh → scripts/generate-metrics.sh + scripts/sync-metrics.sh (when counts change)
→ scripts/deploy-website.sh
```
Numbers flow ONE direction: actual commands → `website/public/metrics.json` → generated docs → website → master plan.

### Never:
- Do NOT create new planning/roadmap/audit documents. `RIINA_MASTER_PLAN.md` is the only plan.
- Do NOT commit Coq proofs with `Admitted`.
- Do NOT count stub prover files as proofs, and never add counts from different provers together.
- Do NOT hand-type numbers: derive them from commands (`website/public/metrics.json` is the source of truth).
- Do NOT edit generated files by hand (these instruction files, the ledgers, `PROOF_STATUS.md`, `AXIOMS.md`); edit their sources and regenerate.
- Do NOT push with `--no-verify`: the in-repo hooks (`riinac verify`, `scripts/audit-docs.sh`) are the source of truth.
- `.github/workflows/verify.yml` only wraps the internal gates; CI is never the source of truth and must not diverge from them.
- Change vite base path from `/riina/`

## Build Commands

```bash
# Coq
eval $(opam env --switch=rocq) && cd 02_FORMAL/coq && make -j$(nproc)

# SMT scoped set (the Lean lane is empty until the REQ-67(b) re-proof starts)
bash scripts/verify-smt.sh

# Rust
export PATH="$HOME/.rustup/toolchains/1.94.1-x86_64-unknown-linux-gnu/bin:$PATH"
cargo test --all --manifest-path 03_PROTO/Cargo.toml

# Website
cd website && npm run build   # vite base: /riina/
```

Native builds need gcc or clang as `cc` on Linux or macOS (Windows: WSL). MSVC is not
supported (owner ruling on REQ-102, option B).

## Commit Signing

Commit signing is **optional** (retracted as a hard gate 2026-06-01): the repo's
history is unsigned and no signing key is provisioned in CI or ephemeral sessions,
so the old "signed commits required" gate could never pass. If you sign, great;
the pre-push secret/trojan-source scans still run regardless. See
`scripts/security-gates.sh`.

<!-- Generated by scripts/generate-agent-files.py from 04_SPECS/agent_files/AGENTS.md.tmpl. Edit the template, not this file (mandate S5.6). -->
