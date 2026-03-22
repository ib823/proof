# I_ERROR_HANDLING_AND_OS_SECURITY — Remediation Worklist v1.0.0

**Current:** R2 | **Target:** R3
**Created:** 2026-03-21

---

## R2 → R3 Tasks

### Critical (Blocks R3)

- [ ] **I-R3-01:** Archive TerasSecurity.v — Move to `99_ARCHIVE/coq/security/` and remove from evidence counts (boolean record stubs, not rewritable to real content without OS model)
- [ ] **I-R3-02:** Archive SQLInjectionPrevention.v — Same treatment. Boolean record stubs.
- [ ] **I-R3-03:** Rewrite or scope-exclude InjectionPrevention.v — Options:
  - (a) Rewrite using AST types that mirror riina-types Expr/Stmt, proving injection-free by construction
  - (b) Scope-exclude with documented rationale; count only CrossLayerSecurity.v and VerifiedMicrokernel.v as formal evidence

### High Priority

- [ ] **I-R3-04:** Recount formal evidence — After vacuous files removed, count remaining legitimate Qed theorems in CrossLayerSecurity.v and VerifiedMicrokernel.v
- [ ] **I-R3-05:** Error handling Coq proof — Write at least one nontrivial proof about RIINA's Keputusan/Ralat error model (e.g., exhaustive error handling, no unhandled Ralat propagation)
- [ ] **I-R3-06:** Threat model — Document injection attack vectors RIINA prevents (SQL, XSS, path traversal, command injection) and what remains out of scope

### Medium Priority

- [ ] **I-R3-07:** Wire .rii examples into integration tests — Error handling and injection prevention examples need test assertions
- [ ] **I-R3-08:** Negative test inventory — Document the 44 injection tests, categorize by attack type

---

## R3 → R4 Tasks (Future)

- [ ] **I-R4-01:** Injection completeness proof — Formal proof that RIINA's type system prevents all injection classes in scope
- [ ] **I-R4-02:** Error propagation soundness — Prove that Keputusan types correctly propagate through function composition
- [ ] **I-R4-03:** OS capability model — Formal model of RIINA's capability-based OS security
- [ ] **I-R4-04:** Teras (stack) security — Replace archived TerasSecurity.v with real stack safety model
- [ ] **I-R4-05:** Fuzzing integration — Fuzz injection prevention with coverage tracking

---

## Verification Commands

```bash
# Check vacuous files
grep -c "reflexivity\." 02_FORMAL/coq/security/TerasSecurity.v
grep -c "reflexivity\." 02_FORMAL/coq/security/SQLInjectionPrevention.v

# Count legitimate proofs
grep -c "Qed\." 02_FORMAL/coq/security/CrossLayerSecurity.v
grep -c "Qed\." 02_FORMAL/coq/security/VerifiedMicrokernel.v

# Run injection tests
cargo test -p riina-typechecker -- injection 2>&1 | grep "test result"
```
