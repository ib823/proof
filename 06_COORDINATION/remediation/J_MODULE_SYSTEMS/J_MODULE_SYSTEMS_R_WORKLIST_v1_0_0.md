# J_MODULE_SYSTEMS — Remediation Worklist v1.0.0

**Current:** R1 | **Target:** R2
**Created:** 2026-03-21

---

## R1 → R2 Tasks

### Critical (Blocks R2)

- [ ] **J-R2-01:** Implement `modul` parsing — Add `modul NamaMod { ... }` to riina-parser. Must produce a ModuleDecl AST node with name, visibility, and body items.
- [ ] **J-R2-02:** Implement `guna` parsing — Add `guna NamaMod;` import statement. Must produce an Import AST node.
- [ ] **J-R2-03:** Parser tests — At minimum: (a) parse valid module declaration, (b) parse valid import, (c) reject malformed module syntax, (d) reject import of nonexistent module (if resolvable at parse time)
- [ ] **J-R2-04:** Rewrite ModuleSystems.v — Replace definitional unfolding with nontrivial content. Minimum: define module well-formedness, prove at least one property (e.g., no duplicate exports)

### High Priority

- [ ] **J-R2-05:** Module AST types — Add ModuleDecl and Import variants to riina-types
- [ ] **J-R2-06:** Basic typechecker support — Module declarations create a namespace scope; `guna` brings names into scope
- [ ] **J-R2-07:** Scope clarification doc — Document that riina-pkg (package manager) is distinct from language module system

### Medium Priority

- [ ] **J-R2-08:** .rii module examples — Create example files demonstrating `modul`/`guna` usage in 07_EXAMPLES/

---

## R2 → R3 Tasks (Future)

- [ ] **J-R3-01:** Visibility enforcement — `awam` (public) vs `peribadi` (private) module members, with rejection tests
- [ ] **J-R3-02:** Circular import detection — Detect and reject circular `guna` chains
- [ ] **J-R3-03:** Integration tests — .rii module examples produce expected compilation results
- [ ] **J-R3-04:** Qualified name resolution — `NamaMod.fungsi_name` access syntax
- [ ] **J-R3-05:** Module-aware effect checking — Effects declared at module boundary

---

## R3 → R4 Tasks (Future)

- [ ] **J-R4-01:** Module composition soundness proof — Coq proof that well-typed modules compose safely
- [ ] **J-R4-02:** Separate compilation model — Prove interface/implementation separation correctness
- [ ] **J-R4-03:** Module-level effect tracking — Formal model of effect aggregation across module boundaries

---

## Verification Commands

```bash
# Check parser for modul/guna support
grep -rn "modul\|guna" 03_PROTO/riina-parser/src/

# Run parser tests
cargo test -p riina-parser 2>&1 | grep "test result"

# Check ModuleSystems.v
grep -c "Qed\." 02_FORMAL/coq/modules/ModuleSystems.v
```
