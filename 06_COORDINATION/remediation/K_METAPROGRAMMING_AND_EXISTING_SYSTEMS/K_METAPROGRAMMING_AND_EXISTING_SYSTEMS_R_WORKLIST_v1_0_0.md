# K_METAPROGRAMMING_AND_EXISTING_SYSTEMS — Remediation Worklist v1.0.0

**Current:** R1 | **Target:** R2
**Created:** 2026-03-21

---

## R1 → R2 Tasks

### Critical (Blocks R2)

- [ ] **K-R2-01:** Design decision — Choose macro form for initial implementation. Recommended: derive macros (`terbitan` keyword) for auto-generating trait implementations.
- [ ] **K-R2-02:** Parser support — Add macro invocation syntax to riina-parser. Minimum: `#[terbitan(NamaSifat)]` attribute on type declarations.
- [ ] **K-R2-03:** Macro expansion — Implement expansion pass that generates code from derive attributes before type checking.
- [ ] **K-R2-04:** Rewrite Metaprogramming.v — Replace reflexivity proofs with nontrivial content. Minimum: define macro expansion as a function on ASTs, prove at least one property (e.g., expansion preserves well-formedness).

### High Priority

- [ ] **K-R2-05:** AST types — Add macro-related variants to riina-types (DeriveAttr, MacroExpansion)
- [ ] **K-R2-06:** Tests — Positive: valid derive expands correctly. Negative: derive on incompatible type rejected. At least 5 tests.
- [ ] **K-R2-07:** Scope existing systems analysis — Document which "existing systems" interop is in scope (Rust FFI is L_FFI, not this domain)

### Medium Priority

- [ ] **K-R2-08:** .rii examples — Create macro usage examples in 07_EXAMPLES/

---

## R2 → R3 Tasks (Future)

- [ ] **K-R3-01:** Hygiene enforcement — Macro-generated bindings must not capture ambient variables
- [ ] **K-R3-02:** Syntax macros — Token-tree rewriting (e.g., `makro! { ... }`)
- [ ] **K-R3-03:** Hygiene Coq proof — Formal proof of variable capture prevention
- [ ] **K-R3-04:** Integration tests — .rii macro examples compile and run correctly
- [ ] **K-R3-05:** Error quality — Macro expansion errors point to original source location

---

## R3 → R4 Tasks (Future)

- [ ] **K-R4-01:** Type-preserving expansion proof — Macro expansion on well-typed input produces well-typed output
- [ ] **K-R4-02:** Termination proof — Macro expansion terminates for all inputs (no infinite recursion)
- [ ] **K-R4-03:** Compile-time computation — Constant evaluation during macro expansion with resource bounds
- [ ] **K-R4-04:** Procedural macros — Full compile-time Turing-complete code generation (with termination guarantees)

---

## Verification Commands

```bash
# Check for any existing macro support
grep -rn "terbitan\|makro\|derive\|macro" 03_PROTO/riina-parser/src/

# Check Metaprogramming.v vacuity
grep -c "reflexivity\." 02_FORMAL/coq/metaprogramming/Metaprogramming.v

# Run parser tests after implementation
cargo test -p riina-parser 2>&1 | grep "test result"
```
