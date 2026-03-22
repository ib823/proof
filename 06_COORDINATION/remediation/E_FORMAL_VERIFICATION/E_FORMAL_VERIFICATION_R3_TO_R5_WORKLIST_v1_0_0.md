# E_FORMAL_VERIFICATION R3 To R5 Worklist v1.0.0

This worklist is gate-driven. `E_FORMAL_VERIFICATION` has real proof depth but moves upward only when vacuity detection exists, pipeline documentation is written, and pipeline threats are modeled.

## Current Baseline

- Conservative rating: `R3`
- Blocker gates: G3, G4, G9

## R3 -> R4

### Task E-R4-1: Build vacuity detection tool (CROSS-PROGRAM PRIORITY)
- **Gate:** G9
- **Priority:** Critical — affects every future domain audit
- **Action:** Create `scripts/detect-vacuous-proofs.sh` (or Python equivalent) that scans all `.v` files and flags:
  1. Theorems with conclusion `True`
  2. Proofs consisting solely of `trivial.` or `exact I.`
  3. Theorems proving `true = true` or `reflexivity` on hardcoded boolean fields
  4. Theorems where the conclusion does not reference any hypothesis variable
- **Validation:**
  - Against `02_FORMAL/coq/domains/HardwareSecurity.v`: must flag all 34 theorems
  - Against `02_FORMAL/coq/domains/CapabilitySecurity.v`: must flag all 108 theorems
  - Against `02_FORMAL/coq/foundations/TypeSystem.v`: must flag zero theorems
- **Acceptance:** Tool runs cleanly, has known-good and known-bad validation, and is documented.
- **Estimated effort:** Medium (1-2 sessions)

### Task E-R4-2: Document transpiler validation workflow
- **Gate:** G3
- **Priority:** Medium
- **Action:** Create `04_SPECS/cross-cutting/PROVER_PIPELINE_WORKFLOW.md` documenting:
  - How `generate-multiprover.py` validates its input Coq files
  - How `generate-full-stack.py` validates output structure
  - How correspondence between Coq source and generated lanes is checked
  - What happens when Coq source changes (regeneration protocol)
- **Acceptance:** A new contributor can understand and reproduce the pipeline from the document alone.
- **Estimated effort:** Small (1 session)

### Task E-R4-3: Write pipeline threat model
- **Gate:** G4
- **Priority:** Medium
- **Action:** Create `04_SPECS/cross-cutting/PROVER_PIPELINE_THREAT_MODEL.md` covering:
  1. Corrupted transpiler (script produces syntactically valid but semantically wrong output)
  2. Stale generation (Coq source updated, generated lanes not regenerated)
  3. Proof drift (generated lane passes but proves different property than Coq source)
  4. Silent regression (pipeline change breaks a lane without detection)
  5. Dependency confusion (wrong version of external prover used)
- **Acceptance:** Each threat has an explicit mitigation and detection mechanism.
- **Estimated effort:** Small (1 session)

Do not claim R4 if:
- Vacuity detection tool does not exist or is not validated
- Pipeline workflow documentation is missing
- Pipeline threat model is missing

## R4 -> R5

### Task E-R5-1: CI pipeline enforcement
- **Gate:** G14
- **Action:** Integrate vacuity detection into automated pipeline so new vacuous proofs are caught before merge.
- **Acceptance:** Vacuity check runs on every commit affecting `.v` files.

### Task E-R5-2: Cross-lane correspondence verification
- **Gate:** G10
- **Action:** Automate checking that generated prover lanes correspond to Coq source theorems.
- **Acceptance:** Automated correspondence report; no silent drift.

### Task E-R5-3: Public claim audit
- **Gate:** G13
- **Action:** Ensure public claims about formal verification match audited evidence.
- **Acceptance:** No claim exceeds audited state.

Do not claim R5 if:
- Vacuity detection is not in CI
- Cross-lane correspondence is not automated
- Public claims exceed audited state

## Execution Order

1. E-R4-1 (vacuity detection) — highest priority, do first
2. E-R4-2 (workflow docs) and E-R4-3 (threat model) — parallel, after E-R4-1
3. Re-audit for R4
4. E-R5-1 through E-R5-3 — sequential after R4
5. Re-audit for R5
