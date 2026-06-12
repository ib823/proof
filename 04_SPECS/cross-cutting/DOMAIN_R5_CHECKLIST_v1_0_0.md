# RIINA Domain R5 Checklist

## Version 1.0.0

Status: cross-cutting execution standard

Purpose: provide a reusable, non-marketing, non-inflated method for grading any RIINA domain to `R0-R5` and determining whether a domain is honestly `R5`.

Authority boundary:
- This document does not replace `RIINA_MASTER_PLAN.md`.
- This document does not grant planning authority.
- This document defines an audit and evidence standard that can be applied to any existing or future domain folder.

Core rule:
- A domain is `R5` only if it survives hostile review without relying on unstated assumptions, inflated proof counts, generated artifacts disguised as independent evidence, or syntax-only implementations.

## 1. Domain Maturity Levels

| Level | Name | What it means | Maximum safe claim |
|------|------|----------------|--------------------|
| `R0` | Concept | Idea exists, but scope, artifacts, and evidence are not yet stable | "research topic" |
| `R1` | Canonicalized | Scope, assumptions, and canonical sources exist, but enforcement is missing or shallow | "specified" |
| `R2` | Formally Modeled | Formal model and nontrivial local proofs exist, but live enforcement is incomplete | "formally modeled" |
| `R3` | Enforced Subsystem | Compiler/runtime enforcement exists for a bounded subset of workflows | "enforced for covered workflows" |
| `R4` | Workflow-Complete | Covered workflows are end-to-end, adversarially tested, and mechanically enforced for stated scope | "workflow-complete for stated scope" |
| `R5` | Audit-Grade | Externally reproducible, regression-gated, assumption-explicit, and honest under hostile review | "independent-audit-grade for stated scope and assumptions" |

## 2. Hard Caps

These caps apply even if a domain looks impressive.

| Condition | Highest possible rating |
|-----------|-------------------------|
| Only research documents exist | `R1` |
| Formal proofs exist, but no compiler/runtime binding | `R2` |
| Compiler/runtime binding exists, but only happy-path examples exist | `R3` |
| Negative tests exist, but workflows are partial or assumptions are hidden | `R4` |
| Claims depend on generated, stale, or vacuous evidence | Not `R5` |
| Public wording overstates actual scope | Not `R5` |

## 3. Universal R5 Gates

A domain is `R5` only if every gate below passes.

### Gate G1: Canonical Identity

Required:
- One domain name.
- One domain identifier.
- One canonical scope statement.
- One canonical assumptions block.
- One canonical "not in scope" block.

Fail if:
- Multiple research documents compete for authority.
- `OLD_RESEARCH` is still acting as live authority.
- The domain name refers to multiple different things across repo layers.

### Gate G2: Boundary Precision

Required:
- Domain entry criteria.
- Domain exit criteria.
- Covered actors, assets, and trust boundaries.
- Covered lifecycle phases.
- Covered jurisdictions or standards, where applicable.

Fail if:
- The domain claim is broad but the lifecycle is partial.
- Important exclusions are implied rather than written.

### Gate G3: Workflow Inventory

Required:
- Enumerated valid workflows.
- Enumerated invalid or forbidden workflows.
- State transitions for each workflow.
- Preconditions and postconditions.

Fail if:
- Theorems only talk about objects and never about real workflows.
- The runtime/compiler only handles toy examples.

### Gate G4: Threat and Failure Model

Required:
- Adversary model.
- Failure model.
- Abuse cases.
- Residual risks.

Fail if:
- Only positive-case properties are listed.
- Business logic, state machine abuse, and invalid sequencing are ignored.

### Gate G5: Property Set

Required:
- Safety properties.
- Liveness or progress properties where relevant.
- Conservation or accounting invariants where relevant.
- Confidentiality/integrity properties where relevant.
- Domain-specific compliance constraints where relevant.

Fail if:
- Properties are generic and not domain-shaped.
- Domain-critical properties are absent.

### Gate G6: Formal Model Depth

Required:
- Active formal artifacts linked to the domain.
- Definitions aligned with workflows and threat model.
- Nontrivial theorem set tied to domain properties.
- No `Admitted` in active Coq files.

Fail if:
- Proofs are mostly definition unfolding.
- Proofs cover the wrong abstraction layer.
- Domain folder exists but formal coverage is cosmetic.

### Gate G7: Toolchain Enforcement

Required, when RIINA claims domain support:
- Parser/AST support where syntax is claimed.
- Typechecker or effect checker enforcement where compile-time control is claimed.
- Runtime enforcement or receipts where static proof is insufficient.
- Reject-invalid behavior through the live toolchain.

Fail if:
- Keywords exist without downstream semantics.
- Types exist as wrappers with no rejection power.
- Runtime semantics are placeholders.

### Gate G8: Executable Evidence

Required:
- At least one end-to-end valid workflow example.
- At least one invalid workflow rejected by compiler or runtime.
- Reproducible commands to run both.

Fail if:
- All evidence is static.
- Examples are untested.

### Gate G9: Adversarial Coverage

Required:
- Negative tests.
- Boundary tests.
- Mutation or tamper tests where applicable.
- Attack-pattern tests where applicable.
- Regression tests for previously fixed weaknesses.

Fail if:
- Only golden-path tests exist.
- No test proves that a dangerous case is actually rejected.

### Gate G10: Evidence Honesty Across Prover Lanes

Required:
- Clear distinction between mechanized, compiled, and generated lanes.
- No generated lane counted as independent confirmation.
- No vacuous Alloy/SMT model counted as serious domain evidence.

Fail if:
- Auto-generated artifacts are presented as independent proof.
- Placeholder assertions or tautologies are counted as coverage.

### Gate G11: Observability and Auditability

Required:
- Trace from claim to artifact.
- Ability to inspect assumptions, proofs, tests, and runtime evidence.
- Receipts/logs/traceability where the domain involves execution or compliance.

Fail if:
- A reviewer cannot reconstruct why the domain is rated as it is.

### Gate G12: Freshness and Reproducibility

Required:
- Evidence is reproducible from commands.
- Metrics are command-derived, never manually invented.
- The current repo state is consistent with the claim.

Fail if:
- Counts are stale.
- Claim level depends on cached or contradictory metrics.

### Gate G13: Public Claim Discipline

Required:
- Public wording matches the weakest real link.
- Scope qualifiers are explicit.
- Limitations are visible, not buried.

Fail if:
- "verified", "compliant", "secure", "complete", "audit-ready", or "R5" are used beyond the evidence.

### Gate G14: Regression Immunity

Required:
- The domain rating can be re-checked.
- CI or repo checks can detect regression.
- Loss of proofs, tests, enforcement, or claim honesty drops the rating automatically.

Fail if:
- The rating depends on human memory or optimism.

## 4. Forbidden Shortcuts

Any of the following invalidates an `R5` claim.

- Counting syntax support as domain support.
- Counting definitions as if they were controls.
- Counting generated files as independent mechanization.
- Counting vacuous theorems or tautological SMT/Alloy assertions as meaningful depth.
- Counting proof volume without mapping proofs to workflows.
- Treating unbuilt or untested examples as evidence.
- Treating a type wrapper as enforcement when invalid programs still pass.
- Using stale metrics or copied numbers.
- Hiding non-goals, residual risks, or unsupported subcases.

## 5. Required Evidence Pack

Every audited domain must build an evidence pack with these sections.

1. Canonical sources
- Canonical research files
- Canonical formal files
- Canonical implementation files
- Canonical examples
- Canonical reports or metrics

2. Scope
- What is covered
- What is excluded
- Which actors are modeled
- Which jurisdictions or standards are modeled

3. Workflow matrix
- Valid workflows
- Invalid workflows
- Lifecycle stages
- Coverage status per workflow

4. Property matrix
- Property name
- Why it matters
- Formal artifact
- Enforcement artifact
- Tests covering it

5. Evidence matrix
- Research
- Coq
- Lean
- Isabelle
- SMT
- Alloy
- F*
- TLA+
- Rust compiler/runtime
- Examples
- Reports

6. Honesty notes
- Generated lanes
- Placeholder lanes
- Known vacuity
- Missing enforcement
- Missing tests

7. Public claim line
- Exact wording safe to publish now
- Exact wording not safe to publish now

## 6. R0 to R5 Promotion Checklist

### Promotion to R1

Must have:
- Canonical domain name and identifier.
- Canonical scope and assumptions.
- Canonical research source.
- Folder inventory across `01_RESEARCH`, `02_FORMAL`, `03_PROTO`, `04_SPECS`, `07_EXAMPLES`, and reports.

### Promotion to R2

Must have:
- Formal model exists.
- Theorems are nontrivial and domain-relevant.
- Mapped workflows and mapped properties.
- No active `Admitted`.
- No inflated claim that formalization equals enforcement.

### Promotion to R3

Must have:
- Real parser/typechecker/runtime binding for claimed features.
- Invalid cases actually rejected for covered subset.
- End-to-end happy-path example.
- Tests tied to the covered subset.

### Promotion to R4

Must have:
- Workflow matrix marked complete for stated scope.
- Negative and adversarial tests.
- Non-Coq lane honesty documented.
- Runtime evidence where needed.
- Clear residual risk statement.

### Promotion to R5

Must have:
- Every gate `G1-G14` passes.
- A third party can reproduce the evidence.
- Claim wording is exact and conservative.
- Regression checks exist and are regularly run.
- No domain-critical gap is silently deferred.

## 7. Public Claim Rules

Use only the strongest wording allowed by the current evidence.

| Rating | Safe wording | Unsafe wording |
|--------|--------------|----------------|
| `R0` | "research topic" | "supported" |
| `R1` | "specified" | "verified" |
| `R2` | "formally modeled" | "enforced" |
| `R3` | "enforced for covered workflows" | "complete" |
| `R4` | "workflow-complete for stated scope" | "universal" |
| `R5` | "independent-audit-grade for stated scope and assumptions" | "absolute", "all cases", "complete for every environment" |

Even at `R5`, never omit:
- stated scope
- assumptions
- excluded cases
- jurisdictional limits, if any

## 8. Audit Procedure For Any Domain Folder

Run this procedure in order.

1. Identify the domain.
- Record the domain folder name.
- Record its aliases in research, formal, runtime, and product layers.

2. Build the source map.
- Find all related files in `01_RESEARCH`.
- Find all related files in `02_FORMAL`.
- Find all related files in `03_PROTO`.
- Find all related files in `04_SPECS`.
- Find all related files in `07_EXAMPLES`.
- Find related reports in `reports/`, `website/public/metrics.json`, and `06_COORDINATION` when relevant.

3. Freeze the canonical source set.
- Choose the live authority files.
- Mark superseded or historical files as non-authoritative.

4. Build the workflow matrix.
- List every valid workflow.
- List every forbidden workflow.
- Mark each as modeled, enforced, tested, receipted, and documented.

5. Build the property matrix.
- List every required property.
- Map each property to proof files, implementation, tests, and examples.

6. Check for vacuity.
- Reject tautologies, placeholders, generated outputs, and syntax-only support as serious evidence.

7. Grade every gate `G1-G14`.
- Use `pass`, `partial`, or `fail`.
- Record reasons and file references.

8. Assign the rating.
- The rating is capped by the weakest failed or partial mandatory gate.

9. Write the safe public claim.
- One sentence.
- No inflated terms.
- No hidden scope.

10. Record blockers to the next level.
- Only concrete engineering or proof gaps.
- No vague aspirations.

## 9. Command Guide

Use command-derived evidence where possible.

Repository-wide baseline:

```bash
git status --short --branch
```

Domain source inventory:

```bash
find 01_RESEARCH -type f | grep -Ei '<DOMAIN_PATTERN>'
find 02_FORMAL -type f | grep -Ei '<DOMAIN_PATTERN>'
find 03_PROTO -type f | grep -Ei '<DOMAIN_PATTERN>'
find 04_SPECS -type f | grep -Ei '<DOMAIN_PATTERN>'
find 07_EXAMPLES -type f | grep -Ei '<DOMAIN_PATTERN>'
```

Active Coq hygiene:

```bash
grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
grep -rnP "^\\s*Admitted\\." 02_FORMAL/coq --include="*.v"
```

Generated or suspicious non-Coq evidence:

```bash
grep -RIn "Auto-generated from" 02_FORMAL
grep -RIn "= 0 0" 02_FORMAL/smt
grep -RIn "some st" 02_FORMAL/alloy
```

Rust executable evidence:

```bash
export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.94.1-x86_64-unknown-linux-gnu/bin:$PATH"
cargo test --all --manifest-path 03_PROTO/Cargo.toml
cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings
```

Proof lane refresh if Coq changed:

```bash
eval $(opam env --switch=rocq) && cd 02_FORMAL/coq && make -j$(nproc)
cd /workspaces/proof
python3 scripts/generate-multiprover.py
python3 scripts/generate-full-stack.py
bash scripts/generate-metrics.sh
bash scripts/sync-metrics.sh
```

Documentation consistency:

```bash
bash scripts/audit-docs.sh
```

## 10. Future Domain Intake Rule

Any new domain added later must start with this minimum package before it can claim more than `R0`.

- Canonical domain name and identifier.
- Scope and non-goals.
- Threat and failure model.
- Workflow list.
- Property list.
- Traceability placeholders for research, proofs, implementation, tests, and examples.

Any new domain that skips this intake step is capped at `R0`, regardless of hype or volume.

## 11. Exit Criterion For Honest R5

The final question is not "does this look impressive?"

The final question is:

"Can a hostile, detail-oriented reviewer inspect the current repo, run the documented commands, trace every claim to live evidence, and fail to find inflation, hidden assumptions, fake independence, or workflow-critical gaps?"

If the answer is not clearly "yes", the domain is not `R5`.
