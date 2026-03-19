# RIINA Domain R5 Worksheet Template

Use this template to audit one domain at a time.

Rules:
- Copy this template for each domain audit record.
- Do not rate a domain above the weakest failed mandatory gate.
- Keep evidence command-derived.
- Keep public wording conservative.

---

# Domain Audit Record

## 1. Identity

- Domain name:
- Domain identifier:
- Folder(s):
- Audit date:
- Auditor:
- Current repo commit:

## 2. Canonical Sources

### 2.1 Live authority files

| Layer | File(s) | Canonical? | Notes |
|------|---------|------------|-------|
| Research | | | |
| Formal | | | |
| Implementation | | | |
| Specs | | | |
| Examples | | | |
| Reports | | | |

### 2.2 Historical or non-authoritative files

| File | Why not authoritative |
|------|------------------------|
| | |

## 3. Scope

- Covered problem:
- Explicitly excluded problem:
- Covered actors:
- Covered assets:
- Covered trust boundaries:
- Covered lifecycle phases:
- Covered jurisdictions or standards:
- Assumptions:
- Residual risks:

## 4. Workflow Matrix

| Workflow | Valid or forbidden | Research | Formalized | Enforced | Tested | Receipted/observable | Notes |
|----------|--------------------|----------|------------|----------|--------|----------------------|-------|
| | | | | | | | |

## 5. Property Matrix

| Property | Why it matters | Formal artifact | Enforcement artifact | Tests/examples | Status |
|----------|----------------|-----------------|----------------------|----------------|--------|
| | | | | | |

## 6. Formal Evidence

### 6.1 Coq

| File | Key definitions | Key theorems | Nontrivial? | Notes |
|------|-----------------|--------------|-------------|-------|
| | | | | |

### 6.2 Other prover lanes

| Lane | Files | Independent or generated | Serious or cosmetic | Notes |
|------|-------|--------------------------|---------------------|-------|
| Lean | | | | |
| Isabelle | | | | |
| SMT | | | | |
| Alloy | | | | |
| F* | | | | |
| TLA+ | | | | |
| Verus | | | | |
| Kani | | | | |
| TV | | | | |

### 6.3 Vacuity audit

| Finding | File | Impact | Resolved? |
|---------|------|--------|-----------|
| | | | |

## 7. Implementation Evidence

| Layer | File(s) | What is real today | What is still placeholder |
|------|---------|--------------------|---------------------------|
| Lexer/parser | | | |
| Types/effects | | | |
| Typechecker | | | |
| Runtime | | | |
| Codegen | | | |
| Tooling | | | |

## 8. Executable Evidence

| Evidence | Command | Expected outcome | Last verified |
|----------|---------|------------------|---------------|
| Positive workflow | | | |
| Negative workflow | | | |
| Attack/tamper case | | | |
| Regression test | | | |

## 9. Gate Scores

| Gate | Pass / Partial / Fail | Evidence | Notes |
|------|-----------------------|----------|-------|
| `G1` Canonical Identity | | | |
| `G2` Boundary Precision | | | |
| `G3` Workflow Inventory | | | |
| `G4` Threat and Failure Model | | | |
| `G5` Property Set | | | |
| `G6` Formal Model Depth | | | |
| `G7` Toolchain Enforcement | | | |
| `G8` Executable Evidence | | | |
| `G9` Adversarial Coverage | | | |
| `G10` Evidence Honesty Across Prover Lanes | | | |
| `G11` Observability and Auditability | | | |
| `G12` Freshness and Reproducibility | | | |
| `G13` Public Claim Discipline | | | |
| `G14` Regression Immunity | | | |

## 10. Rating

- Current rating:
- Rating cap:
- Why this is not higher:
- Minimum work to reach next level:

## 11. Safe Public Wording

- Safe claim:
- Unsafe claim:

## 12. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| | | | | |

## 13. Promotion Checklist

### To reach `R1`

- [ ] Canonical scope exists
- [ ] Canonical source set exists
- [ ] Historical files demoted

### To reach `R2`

- [ ] Formal model exists
- [ ] Nontrivial theorems exist
- [ ] Workflow-to-proof mapping exists

### To reach `R3`

- [ ] Live enforcement exists
- [ ] Invalid covered case is rejected
- [ ] Executable positive path exists

### To reach `R4`

- [ ] Workflow coverage is complete for stated scope
- [ ] Negative and adversarial tests exist
- [ ] Residual risks are explicit

### To reach `R5`

- [ ] Every gate `G1-G14` passes
- [ ] Third-party reproduction is possible
- [ ] Public wording is conservative and exact
- [ ] Regression checks exist

## 14. Sign-Off

- Final verdict:
- Reviewer notes:
- Follow-up date:
