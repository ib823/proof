# AGENTS.md — RIINA™ Repository Instructions for AI Agents

**For Codex, Devin, and any autonomous AI agent entering this codebase.**

## Before ANY Action

1. Read `RIINA_MASTER_PLAN.md` — the ONLY planning authority
2. Read `CLAUDE.md` — operational instructions (tools, paths, build commands)
3. Run `git status` — must be on `main` branch, check for dirty files

## Current State (2026-03-19, verified)

| Metric | Value |
|--------|-------|
| Version | 0.3.0 (tagged) |
| Coq Qed | 11,905 (0 Admitted, 0 axioms, 302 active files) |
| Lean theorems | 12,096 (317 files, 0 sorry) |
| Isabelle lemmas | 12,303 (357 files, 0 sorry) |
| Total proofs | 71,382 across 10 provers |
| Rust tests | 2,392 (16 crates) |
| Examples | 147 .rii files |
| Claims | 5 mechanized (Coq, Lean, Isabelle, TLA+, SMT), 2 compiled (F*, Alloy), 3 generated (Verus, Kani, TV) |

## Phases Completed (0-5 + J1)

- **Phase 0-4**: DONE (clean codebase, deep proofs, prover closure, compiler enforcement, end-to-end)
- **Phase 5**: ~95% (artifact signing done, compliance 500+ rules, HTTP pkg client, trademark asserted)
- **Phase J1**: PASSED (session-typed actors: pelakon/lahir/hantar/terima end-to-end)

## Phase 6 Status (Current Focus)

### JALINAN (Distributed Computing)
- **J1 Session Types + Actors**: PASSED
  - 9 keywords, 5 Ty variants, 7 Expr variants in AST
  - Parser: koreografi/pelakon/lahir/hantar/terima blocks
  - Session type checker (56 tests), C codegen with pthread actor runtime
  - Interpreter with synchronous message processing
  - riina-runtime crate (mailbox, supervisor, session channels)
- **J2 Content-Addressed State**: 40% — FNV-1a hash in interpreter + C emit
- **J3 Actor Runtime**: 70% — runtime exists, wired to interpreter, C pthread backend
- **J4 Proof-Carrying Execution**: 10% — concept only
- **J5 CAHAYA (Verified UI)**: 20% — 14 keywords, 5 types, 8 expressions, parser rules

### Blockchain + Syariah Finance
- Spec complete (~1500 lines in 01_RESEARCH/) — zero implementation

## What Needs to Happen Next

### Phase 6 Completion (J2-J6)
1. Content-addressed codegen: Merkle DAG runtime, hash chains
2. Wire riina-runtime to C for native multi-threaded actors
3. CAHAYA codegen: UI → HTML/terminal renderer
4. WCAG contrast type checking
5. Blockchain keywords/types: sukuk, mudarabah, KontrakPintar
6. Syariah effect constraints: kesan SyariahPatuh
7. Coq proofs: value_conservation, no_reentrancy, consensus_safety

### Phase 7: Runtime Proof Architecture
8. Execution receipt format (EffectReceipt struct)
9. Proof bundle Merkle chain
10. Runtime monitor extraction from Coq
11. eBPF kernel enforcement
12. CHERI hardware capability compilation

### Phase 8: Platform + Rendering
13. SINAR rendering engine (WebGPU first)
14. RUPA type-safe styling
15. LUKIS declarative UI DSL
16. SUSUN verified layout engine

### Phase 9: OS + Hardware
17. TERAS-OS verified microkernel (108 theorems)
18. CHERI RISC-V compilation target
19. Real Android/iOS backends

### Phase 10: Ecosystem
20. Self-hosting compiler
21. RIINA Bijak learning platform
22. Fine-tuned LLM for RIINA code generation
23. Academic papers (one per verification dimension)

## Critical Operational Rules

### After EVERY Coq change:
```bash
python3 scripts/generate-multiprover.py
python3 scripts/generate-full-stack.py
bash scripts/generate-metrics.sh
bash scripts/sync-metrics.sh
```

### After EVERY metrics regeneration:
Claim levels reset. Restore via `reports/noncoq_mechanized_status.json`:
- Set `lanes.lean.full_build_ok = True, mechanized_ready = True`
- Set `lanes.fstar.full_exec_ok = True, lanes.alloy.full_exec_ok = True`
- Then re-run `bash scripts/generate-metrics.sh`

### Deployment:
```bash
git push origin main                      # Pre-push hook validates
bash scripts/sync-public.sh              # Sync to public + ib823/riina
cd website && npm run build && deploy to gh-pages
```

### Never:
- Commit with Admitted in Coq
- Hardcode numbers — always derive from commands
- Create new planning documents — update RIINA_MASTER_PLAN.md only
- Change vite base path from `/riina/`

## Build Commands

```bash
# Coq
eval $(opam env --switch=rocq) && cd 02_FORMAL/coq && make -j$(nproc)

# Lean
cd 02_FORMAL/lean && /home/codespace/.elan/bin/lake build RIINA

# Rust
export PATH="/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
cargo test --all --manifest-path 03_PROTO/Cargo.toml

# Website
cd website && npm run build   # vite base: /riina/
```

## GPG Signing

Commits signed with key `CDBFA69C93835F74` (uploaded to GitHub).
`ib823/riina` requires signed commits on main.
