# RIINA Parallel Execution Plan

> **SUPERSEDED (2026-10-20).** Historical planning document, kept for the record only. It
> is not a plan and its content is not current: `RIINA_MASTER_PLAN.md` is the only
> planning authority (mandate S5.6, REQ-109).

## Version: 1.0.0
## Created: 2026-01-17
## Status: ACTIVE

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║     ██████╗ ██╗██╗███╗   ██╗ █████╗                                              ║
║     ██╔══██╗██║██║████╗  ██║██╔══██╗                                             ║
║     ██████╔╝██║██║██╔██╗ ██║███████║                                             ║
║     ██╔══██╗██║██║██║╚██╗██║██╔══██║                                             ║
║     ██║  ██║██║██║██║ ╚████║██║  ██║                                             ║
║     ╚═╝  ╚═╝╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝                                             ║
║                                                                                  ║
║     PARALLEL EXECUTION STRATEGY                                                  ║
║     Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE        ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

---

## 1. CURRENT STATE ASSESSMENT

### 1.1 Verification Baseline (2026-01-17)

| Component | Status | Metric | Grade |
|-----------|--------|--------|-------|
| **Coq Proofs (Track A)** | ✅ COMPILES | 7,509 lines, 0 Admitted, 19 Axioms | A- |
| **Rust Prototype (Track B)** | ✅ PASSING | 222 tests passing, 0 warnings | A |
| **Tooling/Crypto (Track F)** | 🟡 PARTIAL | 137 tests (134 pass, 3 fail AES) | B+ |
| **Zero-Trust (R-U)** | ⚪ DEFINED | Research complete, 0% implemented | F |
| **Completeness (V-Z)** | ⚪ DEFINED | Research complete, 0% implemented | F |

**Overall Grade: B+ (78%)**

### 1.2 Detailed Metrics

#### Track A: Formal Proofs
```
02_FORMAL/coq/
├── foundations/    [3 files, ~2,000 lines] ✅ COMPLETE
├── type_system/    [3 files, ~1,600 lines] ✅ COMPLETE
├── effects/        [3 files, ~1,400 lines] ✅ COMPLETE
└── properties/     [3 files, ~2,500 lines] 🟡 19 AXIOMS

Axiom Categories (19 total):
├── Higher-order Kripke (3): val_rel_n_weaken, val_rel_n_mono_store, val_rel_n_to_val_rel
├── Step-1 termination (7): exp_rel_step1_{fst,snd,case,if,let,handle,app}
├── Application (1): tapp_step0_complete
├── Step-up (3): val_rel_n_step_up, store_rel_n_step_up, val_rel_n_lam_cumulative
├── Higher-order conversion (1): val_rel_at_type_to_val_rel_ho
└── Semantic typing (4): logical_relation_{ref,deref,assign,declassify}
```

#### Track B: Prototype
```
03_PROTO/
├── riina-arena/     [1 file]    6 tests  ✅
├── riina-codegen/   [6 files]  172 tests ✅
├── riina-lexer/     [2 files]   12 tests ✅
├── riina-parser/    [2 files]   12 tests ✅
├── riina-span/      [2 files]    9 tests ✅
├── riina-symbols/   [2 files]    6 tests ✅
├── riina-typechecker/ [2 files]  5 tests ✅
└── riina-types/     [2 files]    0 tests (shared definitions)

Total: 222 tests, ALL PASSING
```

#### Track F: Tooling & Crypto
```
05_TOOLING/crates/riina-core/src/crypto/
├── aes.rs        ❌ 3 FAILING (roundtrip, FIPS-197, ct_lookup)
├── ed25519.rs    ✅ 12 passing (COMPLETE)
├── field25519.rs ✅ 8 passing
├── gcm.rs        ✅ 9 passing
├── ghash.rs      ✅ 7 passing
├── hkdf.rs       ✅ 7 passing
├── hmac.rs       ✅ 10 passing
├── keccak.rs     ✅ 17 passing (SHA-3, SHAKE)
├── ml_dsa.rs     🟡 6 passing, 1 ignored (NTT working, sign/verify pending)
├── ml_kem.rs     ✅ 5 passing (COMPLETE)
├── montgomery.rs ✅ Working (X25519 ladder)
└── x25519.rs     ✅ Working (DH complete)

Total: 137 tests (134 pass, 3 fail)
```

### 1.3 Critical Blockers

| Priority | Blocker | Impact | Effort |
|----------|---------|--------|--------|
| P0 | 19 Axioms in NonInterference.v | Blocks formal verification claims | 80-120 hrs |
| P0 | AES 3 failing tests | Blocks symmetric crypto | 10-20 hrs |
| P1 | ML-DSA sign/verify incomplete | Blocks post-quantum signatures | 30-50 hrs |
| P2 | Zero-Trust tracks not implemented | Blocks zero-trust claims | 500+ hrs |

---

## 2. PARALLEL WORKER ARCHITECTURE

### 2.1 Worker Domains (Non-Conflicting)

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           RIINA WORKER DOMAINS                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   WORKER α (Alpha)          WORKER β (Beta)          WORKER γ (Gamma)          │
│   ─────────────────         ──────────────           ──────────────            │
│   Track A: Proofs           Track B: Compiler        Track F: Crypto           │
│                                                                                 │
│   Files:                    Files:                   Files:                    │
│   02_FORMAL/coq/**          03_PROTO/**              05_TOOLING/**             │
│                                                                                 │
│   Tasks:                    Tasks:                   Tasks:                    │
│   • Axiom elimination       • Add unit tests         • Fix AES                 │
│   • Proof completion        • Parser improvements    • Complete ML-DSA         │
│   • New lemmas              • Codegen optimization   • Security audit          │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   WORKER δ (Delta)          WORKER ε (Epsilon)       WORKER ζ (Zeta)           │
│   ─────────────────         ────────────────         ──────────────            │
│   Track R: TransVal         Track V-Z: Complete      Documentation             │
│                                                                                 │
│   Files:                    Files:                   Files:                    │
│   01_RESEARCH/18_*/         01_RESEARCH/22-26_**/    PROGRESS.md               │
│   (NEW: 02_FORMAL/coq/      (NEW: 02_FORMAL/coq/     SESSION_LOG.md            │
│    translation/)             termination/)            06_COORDINATION/**       │
│                                                                                 │
│   Tasks:                    Tasks:                   Tasks:                    │
│   • Begin CompCert study    • Begin termination      • Status updates          │
│   • Define validation       • Begin session types    • Coordination            │
│   • Prototype validator     • Begin separation       • Conflict resolution     │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 File Ownership Rules

**ABSOLUTE RULE: Each file has ONE owner at any time.**

| Directory | Owner | Notes |
|-----------|-------|-------|
| `02_FORMAL/coq/foundations/` | α | Core definitions (stable) |
| `02_FORMAL/coq/type_system/` | α | Type safety (stable) |
| `02_FORMAL/coq/effects/` | α | Effect system (stable) |
| `02_FORMAL/coq/properties/` | α | NonInterference (ACTIVE) |
| `03_PROTO/crates/riina-lexer/` | β | Lexer (stable) |
| `03_PROTO/crates/riina-parser/` | β | Parser (active) |
| `03_PROTO/crates/riina-codegen/` | β | Codegen (active) |
| `03_PROTO/crates/riina-typechecker/` | β | Type checker (active) |
| `05_TOOLING/crates/riina-core/` | γ | Crypto (active) |
| `05_TOOLING/tools/` | γ | Build tools (stable) |
| `PROGRESS.md` | ζ | Status tracker |
| `SESSION_LOG.md` | ζ | Session log |
| `06_COORDINATION/**` | ζ | Coordination |

### 2.3 Inter-Worker Dependencies

```
α (Proofs) ──────────────────────────────────────────────────────────────►
     │
     │ Syntax.v types
     ▼
β (Compiler) ────────────────────────────────────────────────────────────►
     │
     │ AST definitions
     ▼
γ (Crypto) ──────────────────────────────────────────────────────────────►
     │
     │ Crypto primitives
     ▼
δ (TransVal) ────────────────────────────────────────────────────────────►
     │
     │ Validation specs
     ▼
ε (Completeness) ────────────────────────────────────────────────────────►
```

---

## 3. GIT COORDINATION PROTOCOL

### 3.1 Commit Rules

**MANDATORY: Commit and push every 5 minutes OR after each milestone.**

```bash
# Standard commit pattern
git add -A
git commit -m "[WORKER_X] [TRACK_Y] [TYPE] Brief description"
git push origin main
```

**Commit Types:**
- `PROOF` - Coq proof progress
- `IMPL` - Implementation code
- `TEST` - Test additions/fixes
- `FIX` - Bug fixes
- `DOCS` - Documentation
- `COORD` - Coordination updates

**Examples:**
```
[WORKER_α] [TRACK_A] PROOF: Prove val_rel_n_step_up_fo lemma
[WORKER_β] [TRACK_B] TEST: Add 15 parser unit tests
[WORKER_γ] [TRACK_F] FIX: Correct AES S-box lookup indexing
[WORKER_ζ] [COORD] DOCS: Update progress tracker
```

### 3.2 Conflict Prevention

1. **Before starting work:**
   ```bash
   git pull origin main --rebase
   ```

2. **Before each commit:**
   ```bash
   git pull origin main --rebase
   # Resolve any conflicts
   git push origin main
   ```

3. **If conflict detected:**
   - STOP immediately
   - Check `06_COORDINATION/CONFLICT_LOG.md`
   - Notify via commit message: `[CONFLICT] Worker X blocked on file Y`
   - Wait for resolution

### 3.3 Merge Strategy

- **Main branch only** - No feature branches
- **Fast-forward merges only** - Rebase before push
- **Atomic commits** - Each commit must compile and pass tests

---

## 4. SESSION RECOVERY MECHANISM

### 4.1 Session State File

Each worker maintains: `06_COORDINATION/WORKER_STATE_<X>.md`

```markdown
# Worker α State

## Last Checkpoint: 2026-01-17T14:30:00Z
## Last Commit: abc1234

### Current Task
- File: 02_FORMAL/coq/properties/NonInterference.v
- Line: 1847
- Task: Proving val_rel_n_step_up lemma
- Status: IN_PROGRESS

### Context
- Working on step-index monotonicity
- Previous lemma: val_rel_n_weaken_fo (DONE)
- Next: store_rel_n_step_up

### Blockers
- None

### Notes
- Using induction on type structure
- TFn case requires careful contravariance handling
```

### 4.2 Recovery Procedure

On session restart:

```bash
# 1. Pull latest
cd /workspaces/proof
git pull origin main

# 2. Read worker state
cat 06_COORDINATION/WORKER_STATE_<X>.md

# 3. Verify environment
source ~/.cargo/env
coqc -v

# 4. Navigate to checkpoint
# (based on state file)

# 5. Resume work
# 6. Update state file immediately
```

### 4.3 Heartbeat Protocol

Every 5 minutes, update worker state:

```markdown
## Heartbeat: 2026-01-17T14:35:00Z
- Status: ACTIVE
- Current file: NonInterference.v
- Current line: 1892
- Progress: 45% of current lemma
```

---

## 5. ATTACK PLAN

### 5.1 Phase 1: Critical Fixes (Week 1)

| Worker | Task | Target | Metric |
|--------|------|--------|--------|
| α | Eliminate 10 axioms | Week 1 | 19 → 9 axioms |
| β | Add 50 unit tests | Week 1 | 222 → 272 tests |
| γ | Fix AES (3 tests) | Day 1-2 | 134 → 137 passing |
| γ | Complete ML-DSA | Week 1 | Sign/verify working |
| ζ | Coordination | Ongoing | 0 conflicts |

### 5.2 Phase 2: Proof Completion (Weeks 2-4)

| Worker | Task | Target | Metric |
|--------|------|--------|--------|
| α | Eliminate remaining axioms | Week 4 | 9 → 5 semantic axioms |
| α | Document all axioms | Week 3 | 100% documented |
| β | Parser error recovery | Week 2 | Better diagnostics |
| β | Codegen optimization | Week 3 | 2x faster emission |
| γ | Security audit | Week 4 | 0 vulnerabilities |

### 5.3 Phase 3: Zero-Trust Foundation (Months 2-3)

| Worker | Task | Target | Metric |
|--------|------|--------|--------|
| δ | Translation validation POC | Month 2 | Working prototype |
| ε | Termination in Coq | Month 2 | Basic sized types |
| ε | Session types in Coq | Month 3 | Binary sessions |
| all | Integration testing | Month 3 | Full pipeline |

### 5.4 Priority Task Queue

**P0 (Today):**
1. [γ] Fix AES S-box constant-time lookup
2. [α] Prove exp_rel_step1_fst lemma
3. [β] Add lexer edge case tests

**P1 (This Week):**
1. [α] Eliminate Step-1 termination axioms (7)
2. [γ] Complete ML-DSA NTT + polynomial operations
3. [β] Add parser error messages

**P2 (This Month):**
1. [α] Eliminate Higher-order Kripke axioms (3)
2. [δ] Begin CompCert integration study
3. [ε] Define sized types in Coq

---

## 6. WORKER ASSIGNMENT MATRIX

### Current Session Allocation

| Worker | Assigned | Current Task | ETA |
|--------|----------|--------------|-----|
| α | **ACTIVE** | Axiom elimination | Ongoing |
| β | AVAILABLE | - | - |
| γ | **ACTIVE** | Fix AES | 2 hours |
| δ | AVAILABLE | - | - |
| ε | AVAILABLE | - | - |
| ζ | **ACTIVE** | Coordination | Ongoing |

### Task Assignment (Recommended)

```
Session Start: 2026-01-17

Worker α: Axiom Elimination
├── Task 1: Prove exp_rel_step1_fst (uses Progress lemma)
├── Task 2: Prove exp_rel_step1_snd (similar structure)
├── Task 3: Prove exp_rel_step1_case (sum decomposition)
└── Checkpoint: Every lemma completion

Worker β: Test Coverage
├── Task 1: Add 10 lexer edge case tests
├── Task 2: Add 10 parser error case tests
├── Task 3: Add 10 typechecker unit tests
└── Checkpoint: Every 10 tests

Worker γ: Crypto Fixes
├── Task 1: Debug AES S-box (constant-time issue)
├── Task 2: Verify AES key expansion
├── Task 3: Test against FIPS-197 vectors
└── Checkpoint: Each test fixed

Worker ζ: Coordination
├── Task 1: Monitor all workers
├── Task 2: Update PROGRESS.md
├── Task 3: Resolve conflicts
└── Checkpoint: Every 5 minutes
```

---

## 7. SUCCESS CRITERIA

### Week 1
- [ ] 0 failing tests (AES fixed)
- [ ] 15 axioms or fewer (4 eliminated)
- [ ] 250+ tests in prototype
- [ ] 0 git conflicts

### Week 2
- [ ] 10 axioms or fewer (9 eliminated)
- [ ] ML-DSA complete
- [ ] 300+ tests in prototype
- [ ] Documentation 100% current

### Month 1
- [ ] 5-7 semantic axioms only
- [ ] Full crypto suite passing
- [ ] 400+ tests total
- [ ] Translation validation POC started

---

## 8. ESCALATION PROCEDURES

### If Worker Blocked
1. Document in `06_COORDINATION/BLOCKERS.md`
2. Commit with `[BLOCKED]` prefix
3. Switch to secondary task
4. Notify via state file update

### If Conflict Detected
1. STOP immediately
2. Do NOT force push
3. Document in `06_COORDINATION/CONFLICT_LOG.md`
4. Wait for ζ (coordinator) resolution

### If Session Disconnects
1. On reconnect: `git pull origin main`
2. Read own state file
3. Verify last commit landed
4. Resume from checkpoint

---

## APPENDIX A: Quick Reference

### Worker α (Proofs)
```bash
cd /workspaces/proof/02_FORMAL/coq
make  # Build all proofs
grep -r "Axiom" properties/NonInterference.v  # Check axioms
```

### Worker β (Compiler)
```bash
source ~/.cargo/env
cd /workspaces/proof/03_PROTO
cargo test --all  # Run all tests
cargo clippy -- -D warnings  # Lint
```

### Worker γ (Crypto)
```bash
source ~/.cargo/env
cd /workspaces/proof/05_TOOLING
cargo test -p riina-core  # Run crypto tests
```

### Worker ζ (Coordinator)
```bash
cd /workspaces/proof
git log --oneline -20  # Recent commits
cat PROGRESS.md  # Current status
```

---

*Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE*
*RIINA: Rigorous Immutable Invariant — Normalized Axiom*
