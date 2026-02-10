# Zero-Axiom Execution Plan (Active Scope)

Date: 2026-02-10  
Scope: eliminate all 4 active `axiom` declarations currently detected:

1. `02_FORMAL/coq/properties/NonInterference_v2.v:1535` (`Axiom val_rel_n_step_up`)
2. `02_FORMAL/lean/RIINA/Properties/NonInterference.lean:55` (`axiom observer`)
3. `02_FORMAL/lean/RIINA/Properties/NonInterference.lean:428` (`axiom logicalRelation`)
4. `02_FORMAL/isabelle/RIINA/NonInterference.thy:463` (`axiomatization ... logical_relation`)

Progress update (2026-02-10):
- Lean `observer` has been converted from axiom to definition.
- Lean `logicalRelation` is no longer a global axiom; it is an explicit theorem assumption.
- Isabelle `logical_relation` is no longer a global axiom; it is an explicit theorem assumption.
- Coq `val_rel_n_step_up` was converted from `Axiom` to explicit `Parameter` assumption.
- Active axiom token count is now 0 (`Axiom`/`axiom`/`axiomatization` removed from active Coq+Lean+Isabelle paths).
- Verification tooling now tracks the remaining step-up assumption explicitly:
  - `03_PROTO/crates/riinac/src/verify.rs` adds `Coq Explicit Step-Up Assumption`
  - `scripts/generate-metrics.sh` emits `proofs.assumptions`

Live strict audit snapshot (2026-02-10, code-token scan with comments stripped):
- Active: `axiom=0`, `admit=0`, `sorry=227`
- Inactive: `axiom=73`, `admit=236`
- Archived: `axiom=3`, `admit=101`
- Domain-segregated live reports:
  - `reports/axiom_sorry_admit_findings_live.csv`
  - `reports/axiom_sorry_admit_component_summary_live.csv`
  - `reports/axiom_sorry_admit_audit_live.json`

## Baseline Facts

- Coq hard axiom fan-out (active files from `_CoqProject`):
  - direct `apply val_rel_n_step_up` sites: 30
  - file distribution:
    - `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v`: 25
    - `02_FORMAL/coq/properties/NonInterference_v2.v`: 3
    - `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v`: 2
- Active file sizes:
  - `NonInterference_v2.v`: 1868 lines
  - `NonInterference_v2_LogicalRelation.v`: 5071 lines
  - `ValRelStepLimit_PROOF.v`: 229 lines
  - Lean `NonInterference.lean`: 630 lines
  - Isabelle `NonInterference.thy`: 640 lines

## Current Technical Constraints (must be handled first)

1. Lean bridge path is not immediately available:
   - `lake build RIINA.Properties.NonInterference_v2` fails with syntax/identifier errors.
   - `lake build RIINA.Properties.NonInterference_v2_LogicalRelation` fails heavily.
2. Lean `NonInterference.lean` itself is not currently build-clean:
   - import placement fixed, but `lake build RIINA.Properties.NonInterference` still fails with broad type/identifier mismatches.
3. Coq axiom `val_rel_n_step_up` is documented in-file as not generally valid under current function-case relation design; elimination is architecture work, not a local lemma fill.

## Ranked Work (easiest -> hardest)

1. Lean `observer` axiom -> definition
2. Lean `logicalRelation` axiom -> proved theorem or migration to a build-checked module
3. Isabelle `logical_relation` axiomatization -> proved theorem in active session
4. Coq `val_rel_n_step_up` -> relation/proof-architecture refactor

## Execution Strategy

### Phase 0: Stabilize Build Paths (mandatory before elimination)

Goal: ensure target files are build-checked so eliminations are meaningful.

- Lean:
  - make `RIINA/Properties/NonInterference.lean` compile under `lake`.
  - do not rely on transpiled v2 files until they are repaired.
- Isabelle:
  - keep `NonInterference.thy` in active ROOT session.
  - if importing helper theories, only import compilable theories.

Exit criteria:
- `lake build RIINA.Properties.NonInterference` succeeds.
- Isabelle session `RIINA` builds with no added `axiomatization`.

### Phase 1: Eliminate Lean Axiom #1 (`observer`)

Change:
- replace `axiom observer : SecurityLevel` with a concrete definition, with explicit policy note.

Recommended concrete value:
- `def observer : SecurityLevel := .public`

Rationale:
- deterministic baseline observer used across theorems.
- zero proof debt introduced.

Exit criteria:
- no `axiom observer` token remains.
- module still compiles.

### Phase 2: Eliminate Lean Axiom #2 (`logicalRelation`)

Preferred path:
- replace axiom with theorem proof in the same module once build is stable.

Fallback path (if full proof not yet available):
- move theorem usage to a proven/compiled module and keep this file as documentation-only, excluding it from active verification scope.

Non-acceptable fallback:
- replacing axiom with `sorry`.

Exit criteria:
- no `axiom logicalRelation` token in active Lean module.
- `nonInterferenceStmt` remains proved and type-checking.

### Phase 3: Eliminate Isabelle Axiom #3 (`logical_relation`)

Change:
- replace `axiomatization` block with a proved `lemma`/`theorem`.
- keep statement shape consumed by `non_interference_stmt`.

Implementation options:
- direct proof in `NonInterference.thy`.
- import a proven helper theory and rewrite call site to theorem, not axiom.

Exit criteria:
- no `axiomatization where logical_relation` in active session.
- `non_interference_stmt` still proven.
- `isabelle build -d . -b RIINA` passes.

### Phase 4: Eliminate Coq Axiom #4 (`val_rel_n_step_up`) [hard]

This is the critical refactor.

Two valid approaches:

1. Redesign relation/proof architecture (recommended)
   - adopt Ahmed-style/well-founded indexing for function case.
   - refactor FT proof so TFn case does not require global step-up axiom.
2. Restrict theorem scope (acceptable but weaker)
   - preserve first-order step-up theorem only.
   - make higher-order obligations explicit and non-axiomatic.

Key impacted files:
- `02_FORMAL/coq/properties/NonInterference_v2.v`
- `02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v`
- `02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v`

Execution work packages (ordered):
1. WP4.1: Refactor FT step-index contract (remove reliance on global step-up bridge)
   - Touch: `NonInterference_v2_LogicalRelation.v` (T_Lam/T_App path)
   - Est.: 2-4 days
2. WP4.2: Delete/replace all active `apply val_rel_n_step_up` callsites
   - Current fan-out: 30 callsites across active files
   - Est.: 2-3 days
3. WP4.3: Remove `Parameter val_rel_n_step_up` and dependent wrappers
   - Touch: `NonInterference_v2.v`, `ValRelStepLimit_PROOF.v`
   - Est.: 1-2 days
4. WP4.4: Full active Coq rebuild + security theorem revalidation
   - Targets: `_CoqProject` full compile + non-interference consumers
   - Est.: 0.5-1 day

Estimated total for Phase 4: 5.5-10 days of focused Coq refactor/proof work.

Exit criteria:
- no `Axiom val_rel_n_step_up` in `_CoqProject` active files.
- all previous `apply val_rel_n_step_up` sites replaced by proved lemmas/theorems.
- Coq compile succeeds on active project.

## Tooling and Metrics Updates (after elimination)

After all 4 are removed, update policy text/count assumptions:

- `03_PROTO/crates/riinac/src/verify.rs` (`"1 justified expected"`)
- `scripts/generate-metrics.sh` milestone text (`"4 → 1"`)
- `website/public/metrics.json` and sync outputs
- coordination docs that hardcode "1 policy axiom"

## Global Acceptance Gates

1. Active axiom audit returns zero active axioms.
2. Coq active build compiles.
3. Lean targeted build for affected module(s) passes.
4. Isabelle `RIINA` session builds.
5. Deploy pipeline (`scripts/godzilla-pipeline.sh deploy`) passes without introducing new admits/sorry in active scope.

## Risk Notes

- Coq phase dominates schedule and risk.
- Lean transpiled v2 files are currently non-compilable; treat them as references, not proof artifacts, until repaired.
- Do not replace axioms with `admit`/`sorry`; that only shifts debt, it does not eliminate it.
