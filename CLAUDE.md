# CLAUDE.md — RIINA™ Proof Repository

**READ `RIINA_MASTER_PLAN.md` FIRST. It is the ONLY planning authority.**
**This file contains operational instructions only. No planning, no metrics, no status tracking.**

---

## PRIME DIRECTIVES (Root Authority)

These override ALL other instructions on conflict:

1. **Paranoid-Absolute Verification** — ALL status verified by running actual commands, NEVER copied from docs
2. **No Shortcuts** — No stubs, no inflated metrics, no approximations
3. **One Plan** — `RIINA_MASTER_PLAN.md` is the ONLY planning document. Do not create others.
4. **Zero Trust** — Trust nothing. Verify everything. Compiler output and grep counts only.

---

## REPOSITORY STRUCTURE

```
/workspaces/proof/
├── RIINA_MASTER_PLAN.md         ← THE plan (read this first)
├── CLAUDE.md                    ← THIS FILE (operational instructions)
├── AGENTS.md                    ← Codex/agent instructions
├── COPILOT.md                   ← GitHub Copilot instructions
├── .cursorrules                 ← Cursor AI instructions
├── README.md                    ← Public README
├── CHANGELOG.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md
├── VERSION                      ← Semver (0.1.0)
├── LICENSE
│
├── 00_SETUP/                    ← Setup scripts
├── 01_RESEARCH/                 ← Research archive (READ-ONLY)
├── 02_FORMAL/                   ← Formal proofs
│   ├── coq/                     ← Coq (PRIMARY)
│   ├── lean/                    ← Lean 4 (secondary)
│   └── isabelle/                ← Isabelle (tertiary, stubs)
├── 03_PROTO/                    ← Rust prototype (15 crates)
├── 04_SPECS/                    ← Specifications
├── 05_TOOLING/                  ← Build tools
├── 06_COORDINATION/             ← Cross-track coordination
├── 07_EXAMPLES/                 ← Example .rii files
└── 99_ARCHIVE/                  ← Archived materials
```

---

## TOOL LOCATIONS & BUILD COMMANDS

### Coq/Rocq
```bash
# Requires Rocq 9.1.1 (not Coq 8.20 — files use `From Stdlib`)
eval $(opam env --switch=rocq)
cd /workspaces/proof/02_FORMAL/coq
make                              # Build all proofs
rocq compile -Q . RIINA foundations/Syntax.v   # Build one file
```

### Lean 4
```bash
cd /workspaces/proof/02_FORMAL/lean
PATH="$HOME/.elan/bin:$PATH" lake build RIINA
# Toolchain: leanprover/lean4:v4.16.0
```

### Rust
```bash
# PATH setup (required in background tasks):
export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cargo test --all --manifest-path /workspaces/proof/03_PROTO/Cargo.toml
cargo test --all --manifest-path /workspaces/proof/05_TOOLING/Cargo.toml
cargo clippy -- -D warnings
```

### Other Tools
```
Isabelle: /workspaces/proof/05_TOOLING/tools/isabelle/current/bin/isabelle
F*: /workspaces/proof/05_TOOLING/tools/fstar/current/bin/fstar.exe
TLA2tools: /workspaces/proof/05_TOOLING/tools/formal/tla2tools.jar
Alloy: /workspaces/proof/05_TOOLING/tools/formal/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar
```

Fresh clone smoke-tool bootstrap (Isabelle, F*, TLA2Tools, Alloy):
```bash
bash scripts/provision-smoke-toolchains.sh
```

---

## SESSION PROTOCOL

**Follow `RIINA_MASTER_PLAN.md` Part 8 exactly.** The 8-step protocol is mandatory:

1. **ORIENT** — Read master plan (Part 0, 1), read this file, `git status`
2. **ASSESS** — Read Part 2 (metrics), Part 3 (requirements), Part 4 (phases)
3. **DECIDE** — User task OR highest-priority TODO in current phase (no skipping phases)
4. **VERIFY BEFORE** — Run baseline checks (Coq make, Rust tests, etc.)
5. **EXECUTE** — Do the work, commit incrementally with `[TRACK_X] TYPE:` format
6. **VERIFY AFTER** — Same checks as step 4. No regressions. No metric decrease.
7. **UPDATE** — Update master plan Part 2/3 if metrics or status changed
8. **HANDOFF** — Clean tree, push to main, sync-public if requested

### Branch Policy

**All work on `main` branch. No exceptions.** Never commit to `public` or `gh-pages`.

### Commit-Push-Deploy Chain

```bash
# 1. Stage specific files (NEVER git add -A blindly)
git add <specific files>

# 2. Commit (pre-commit hook validates)
git commit -m "[TRACK_X] TYPE: Description"

# 3. Push (pre-push hook validates — NEVER --no-verify)
git push origin main

# 4. Sync to public (when ready for public visibility)
bash scripts/sync-public.sh

# 5. Sync metrics (when counts change)
bash scripts/generate-metrics.sh && bash scripts/sync-metrics.sh

# 6. Deploy website (when public content/metrics changed)
bash scripts/deploy-website.sh
```

### Commit Message Format

```
[TRACK_A] PROOF: Description     — Coq/Lean/Isabelle proof work
[TRACK_B] IMPL: Description      — Rust prototype work
[TRACK_F] FIX: Description       — Tooling fixes
[ALL] CHORE: Description         — Cross-cutting changes
[ALL] DOCS: Description          — Documentation updates
```

---

## FORBIDDEN ACTIONS

1. **NEVER** commit Coq proofs with `Admitted`
2. **NEVER** commit failing tests
3. **NEVER** use `unsafe` in Rust without documented justification
4. **NEVER** force push to main
5. **NEVER** create new planning/roadmap/audit/strategy documents (update `RIINA_MASTER_PLAN.md`)
6. **NEVER** suggest GitHub Actions or external CI — RIINA uses `riinac verify` internally
7. **NEVER** count stub prover files as proofs
8. **NEVER** copy metrics from docs — always re-derive from commands

---

## ABOUT RIINA

**RIINA** = Rigorous Immutable Invariant, No Assumptions

A formally verified programming language with Bahasa Melayu (Malaysian) syntax.
File extension: `.rii`

See `RIINA_MASTER_PLAN.md` Part 9 for the full Bahasa Melayu keyword reference.

### Key Syntax

```
fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    pulang x + y;
}

fungsi utama() -> Nombor kesan Tulis {
    biar hasil = tambah(3, 4);
    pulang 0;
}
```

---

## LEAN 4 BUILD NOTES

- Toolchain: `leanprover/lean4:v4.16.0`
- `mutual` keyword CANNOT be preceded by a doc comment in Lean 4.16.0
- Lean `import` MUST be the very first non-comment line in a file
- Always clean `.lake` cache when changing toolchain version
- Constructor names are PascalCase (EUnit, TBool, EffPure)
- `induction` tactic doesn't work on mutual inductives; use `match` with recursive calls

---

*For all planning, metrics, phases, and requirements: see `RIINA_MASTER_PLAN.md`.*
*This file is operational instructions only.*
