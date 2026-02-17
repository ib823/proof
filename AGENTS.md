# AGENTS.md — RIINA Repository Instructions for AI Agents

**For Codex, Devin, and any autonomous AI agent entering this codebase.**

## Before ANY Action

1. Read `RIINA_MASTER_PLAN.md` — the ONLY planning authority
2. Read `CLAUDE.md` — operational instructions (tools, paths, build commands)
3. Run `git status` — must be on `main` branch, check for dirty files

## Mandatory Session Protocol

**Follow `RIINA_MASTER_PLAN.md` Part 8 exactly.** It defines 8 mandatory steps:

1. **ORIENT** — Read master plan + CLAUDE.md + git status
2. **ASSESS** — Read Part 2 (verified metrics), Part 3 (requirements), Part 4 (phases)
3. **DECIDE** — User task OR highest-priority TODO in current phase. No skipping phases.
4. **VERIFY BEFORE** — Run baseline checks (Coq make, Rust tests, Lean build)
5. **EXECUTE** — Work on `main` branch only. Commit with `[TRACK_X] TYPE:` format.
6. **VERIFY AFTER** — Same checks. No regressions. No metric may decrease.
7. **UPDATE** — Update master plan Part 2/3 if metrics or status changed
8. **HANDOFF** — Clean tree, `git push origin main`, sync if requested

**Skipping any step is a violation.**

## Branch Policy (Absolute)

- **ALL work on `main` branch.** No feature branches. No exceptions.
- **NEVER commit to `public`** — managed by `scripts/sync-public.sh` only
- **NEVER commit to `gh-pages`** — managed by `scripts/deploy-website.sh` only
- If you're on any other branch: `git checkout main` immediately.

## Commit-Push-Deploy Chain

```bash
# 1. Verify hooks: ls -la .git/hooks/pre-commit .git/hooks/pre-push
# 2. Stage SPECIFIC files: git add <file1> <file2> (NEVER git add -A blindly)
# 3. Commit: git commit -m "[TRACK_X] TYPE: Description"
#    → pre-commit hook runs riinac verify --fast
# 4. Push: git push origin main (NEVER --no-verify)
#    → pre-push hook runs riinac verify --full
# 5. Sync public: bash scripts/sync-public.sh (when ready)
# 6. Sync metrics: bash scripts/generate-metrics.sh && bash scripts/sync-metrics.sh
# 7. Deploy website: bash scripts/deploy-website.sh (when metrics/content changed)
```

**Numbers flow ONE direction:**
```
Actual commands → metrics.json → all docs → website → master plan Part 2
```
Never the reverse.

## Prime Directives (Root Authority)

1. ALL status verified by running actual commands, NEVER copied from docs
2. No stubs, no inflated metrics, no shortcuts
3. `RIINA_MASTER_PLAN.md` is the ONLY planning document — do NOT create new ones
4. Zero trust on documentation claims — compiler output and grep counts only

## Forbidden Actions

- **Do NOT create** new planning/roadmap/audit/strategy markdown files
- **Do NOT commit** Coq proofs with `Admitted`
- **Do NOT count** stub prover files (Isabelle, F*, TLA+, Alloy, etc.) as proofs
- **Do NOT copy** metrics from docs — re-derive from verification commands
- **Do NOT create** feature branches — all work on `main`
- **Do NOT push** with `--no-verify` — the hooks ARE the CI/CD
- **Do NOT commit** to `public` or `gh-pages` directly

## Quick Reference

- **Language:** RIINA (Bahasa Melayu keywords, `.rii` files)
- **Coq proofs:** `02_FORMAL/coq/` (primary, 8,946 Qed active, 0 Admitted)
- **Rust prototype:** `03_PROTO/` (905 tests, 15 crates)
- **Lean 4:** `02_FORMAL/lean/` (33 compiled theorems, toolchain v4.16.0)
- **Specs:** `04_SPECS/`
- **Examples:** `07_EXAMPLES/` (130 .rii files)

## Build Commands

```bash
# Coq
cd 02_FORMAL/coq && make

# Lean
cd 02_FORMAL/lean && PATH="$HOME/.elan/bin:$PATH" lake build RIINA

# Rust
export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
cargo test --all --manifest-path 03_PROTO/Cargo.toml
cargo test --all --manifest-path 05_TOOLING/Cargo.toml
```
