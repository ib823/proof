# Domain Audit Record

## 1. Identity

- Domain name: Memory Safety
- Domain identifier: `F_MEMORY_SAFETY`
- Folder(s): `01_RESEARCH/06_DOMAIN_F_MEMORY_SAFETY/`, `02_FORMAL/coq/domains/{MemorySafety,OwnershipTypes,LinearTypes,W001_VerifiedMemory,BufferOverflowPrevention,ROPDefense,DataRaceFreedom,IrisSeparationLogic}.v`, `02_FORMAL/coq/properties/{StoreSafety,StoreWfLemmas,StoreRelation}.v`, `03_PROTO/crates/riina-{types,parser,typechecker}/`, `07_EXAMPLES/01_security/{linear_types,linear_enforcement}.rii`
- Audit date: `2026-03-20`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq theorem count (command-derived):
  - `MemorySafety.v`: `139` Qed, `0` Admitted
  - `OwnershipTypes.v`: `20` Qed, `0` Admitted
  - `LinearTypes.v`: `25` Qed, `0` Admitted
  - `W001_VerifiedMemory.v`: `40` Qed, `0` Admitted
  - `BufferOverflowPrevention.v`: `22` Qed, `0` Admitted
  - `ROPDefense.v`: `89` Qed, `0` Admitted
  - `DataRaceFreedom.v`: `35` Qed, `0` Admitted
  - `IrisSeparationLogic.v`: `21` Qed, `0` Admitted
  - `StoreSafety.v`: `36` Qed, `0` Admitted
  - `StoreWfLemmas.v`: `31` Qed, `0` Admitted
  - `StoreRelation.v`: `174` Qed, `0` Admitted
  - **Total: 632 Qed, 0 Admitted**
- Proof nontriviality verified: MemorySafety.v uses `andb_true_iff` decomposition, 3-way case analysis with `discriminate`, `destruct` with `inversion` — NOT vacuous. OwnershipTypes.v uses helper lemma application and variable substitution. LinearTypes.v uses `get_update_same` lemma. 0 `trivial.`/`exact I.` in MemorySafety.v and OwnershipTypes.v; 1 in LinearTypes.v (25 Qed — one simple base case is acceptable).
- Rust test evidence: 14 linearity-specific formalized tests including negative rejection tests

## 2. Canonical Source Map

### Research
- `01_RESEARCH/06_DOMAIN_F_MEMORY_SAFETY/RESEARCH_DOMAIN_F_COMPLETE.md`
- `01_RESEARCH/06_DOMAIN_F_MEMORY_SAFETY/RESEARCH_F01_MEMORY_SAFETY_SURVEY.md`

### Formal (Coq) — 8 domain files + 3 property files
- Domain: MemorySafety.v (139), OwnershipTypes.v (20), LinearTypes.v (25), W001_VerifiedMemory.v (40), BufferOverflowPrevention.v (22), ROPDefense.v (89), DataRaceFreedom.v (35), IrisSeparationLogic.v (21)
- Properties: StoreSafety.v (36), StoreWfLemmas.v (31), StoreRelation.v (174)
- Non-Coq lanes: all auto-generated, not counted

### Implementation
- `riina-types/src/lib.rs` — Linearity enum (Linear/Affine/Relevant/Unrestricted), Usage enum
- `riina-parser/src/lib.rs` — parses `sekali`/`paling`/`mesti` keywords → Linearity
- `riina-typechecker/src/lib.rs` — `record_use()` tracks usage and rejects violations; `check_linearity_at_exit()` enforces at scope exit; LIN0001 error mapped to Coq LinearTypes.v:172

### Examples
- `07_EXAMPLES/01_security/linear_types.rii` (107 lines) — linear/affine/relevant examples
- `07_EXAMPLES/01_security/linear_enforcement.rii` (56 lines) — enforcement syntax
- NOT toolchain-tested

## 3. Scope

- Covered problem: memory safety via substructural types (linear, affine, relevant), ownership uniqueness, store safety properties
- Formally modeled but NOT enforced in toolchain: spatial safety (bounds checking), buffer overflow prevention, ROP defense, data race freedom, separation logic
- Enforced in toolchain: linearity checking (use-exactly-once, use-at-most-once, must-use)
- Residual risks: spatial safety (bounds checking) not implemented in typechecker; ROP/data race Coq proofs need nontriviality deep-audit; .rii examples not tested

## 4. Workflow Matrix

| Workflow | Valid or forbidden | Formalized | Enforced | Tested | Notes |
|----------|--------------------|------------|----------|--------|-------|
| Linear variable used exactly once | Valid | Yes (LinearTypes.v) | Yes (record_use + check_linearity_at_exit) | Yes (test_linear_variable_used_once_ok) | Core enforcement |
| Linear variable used twice | Forbidden | Yes | Yes (LinearityViolation) | Yes (test_linear_variable_used_twice_rejected) | Double-free prevention |
| Linear variable unused | Forbidden | Yes | Yes (LinearityViolation) | Yes (test_linear_variable_unused_rejected) | Resource leak detection |
| Affine variable used twice | Forbidden | Yes | Yes (LinearityViolation) | Yes (test_affine_variable_used_twice_rejected) | |
| Affine variable unused | Valid | Yes | Yes (allowed) | Yes (test_affine_variable_unused_ok) | Safe drop |
| Relevant variable unused | Forbidden | Yes | Yes (LinearityViolation) | Yes (test_relevant_variable_must_be_used) | |
| Channel used linearly | Valid | Yes | Yes | Yes (test_chan_linear_enforcement) | Session types |
| Buffer overflow | Forbidden | Yes (BufferOverflowPrevention.v) | **Not enforced** | **Not tested** | Formal only |
| Use-after-free (spatial) | Forbidden | Yes (MemorySafety.v) | **Not enforced** (beyond linearity) | **Not tested** | Formal only for non-linear paths |

## 5. Gate Scores

| Gate | Pass / Partial / Fail | Evidence | Notes |
|------|-----------------------|----------|-------|
| `G1` Canonical Identity | Pass | One domain, one folder, 2 research docs | |
| `G2` Boundary Precision | Partial | Scope covers linearity + spatial + temporal + bounds + ROP + data races — very broad. Enforced subset (linearity) vs formal-only subset not clearly bounded | |
| `G3` Workflow Inventory | Partial | Linearity workflows are well-tested (9 valid/forbidden workflows). Spatial/temporal workflows are formal-only | |
| `G4` Threat and Failure Model | Partial | Memory safety threats implicit in Coq (use-after-free, double-free, buffer overflow). No explicit threat model doc | |
| `G5` Property Set | Pass | 632 theorems: ownership uniqueness, linearity checking, store safety, bounds, separation logic | Comprehensive |
| `G6` Formal Model Depth | Pass | 632 Qed, 0 Admitted, nontrivial (sampled: case analysis, andb decomposition, lemma application) | |
| `G7` Toolchain Enforcement | Pass | Real linearity enforcement: record_use() rejects double use, check_linearity_at_exit() rejects unused linear/relevant, LIN0001 mapped to Coq | For linearity subset |
| `G8` Executable Evidence | Partial | 14 linearity tests with positive and negative cases. .rii examples untested | |
| `G9` Adversarial Coverage | Partial | 6 negative linearity tests (reject double linear, reject unused linear, reject double affine, reject unused relevant, reject unused sekali, reject unused mesti). No spatial/temporal adversarial tests | |
| `G10` Evidence Honesty | Pass | Non-Coq lanes not counted. Spatial enforcement gap acknowledged | |
| `G11` Observability | Pass | LIN0001 → Coq LinearTypes.v:172 mapping | |
| `G12` Freshness | Pass | Command-derived | |
| `G13` Public Claim | Not audited | | |
| `G14` Regression | Partial | Hook-gated | |

## 6. Rating

- Current rating: **R3**
- Rating cap: R3 — enforced for linearity workflows but not for spatial/temporal safety
- Minimum work to reach R4: wire .rii examples into tests, add spatial safety enforcement or scope-exclude it, document workflow inventory and threat model

## 7. Safe Public Wording

- Safe claim: "Memory safety with substructural types (linear, affine, relevant) formally modeled (632 Coq theorems) and enforced at compile time for linearity workflows including double-use prevention, resource leak detection, and channel linearity"
- Unsafe claim: "Complete memory safety", "spatial safety enforced", "buffer overflow prevented", "all memory safety properties enforced"

## 8. Blocking Gaps

| Gap | Severity | Concrete fix | Notes |
|-----|----------|--------------|-------|
| Spatial safety not enforced | Medium | Implement bounds checking or scope-exclude | Formal-only |
| .rii examples untested | Medium | Integration test | Common gap |
| No threat model doc | Medium | Write doc | |
| Broad scope not bounded | Medium | Split enforced vs formal-only | |

## 9. Sign-Off

- Final verdict: **R3 — Enforced for covered workflows (linearity)**
- Reviewer notes: Strong linearity enforcement (14 tests, 6 negative) with Coq-mapped errors. Formal model is broad (632 Qed) but enforcement is narrow (linearity only). Spatial and temporal safety beyond linearity are formal-only. The MemorySafety.v proofs (139 Qed) use real case analysis — not vacuous like D_HARDWARE.
- Follow-up date: After spatial enforcement or scope clarification

## 10. Hostile Review Reconciliation

- Hostile review: [F_MEMORY_SAFETY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/F_MEMORY_SAFETY_R5_REVIEW.md)
- Hostile reviewer: Gemini CLI (v0.34.0)
- Hostile review date: 2026-03-20
- Hostile review verdict: **accept** (no reductions)
- Hostile review maximum honest rating: **R3** (agrees)
- Findings: None. Reviewer noted the audit "successfully caught the major bait-and-switch (proving spatial safety in Coq but only enforcing linearity in the compiler)."
- Final reconciled rating: **R3**
- Remediation package: [README.md](/workspaces/proof/06_COORDINATION/remediation/F_MEMORY_SAFETY/README.md)
- Domain status: **CLOSED** at R3
