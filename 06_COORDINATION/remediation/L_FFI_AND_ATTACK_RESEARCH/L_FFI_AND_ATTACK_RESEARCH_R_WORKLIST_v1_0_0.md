# L_FFI_AND_ATTACK_RESEARCH — Remediation Worklist v1.0.0

**Current:** R2 | **Target:** R3
**Created:** 2026-03-21

---

## R2 → R3 Tasks

### Critical (Blocks R3)

- [ ] **L-R3-01:** Rewrite RustFFISecurity.v — Replace reflexivity proofs with real FFI safety properties. Minimum content:
  - Define FFI call boundary as a typed interface
  - Prove type marshaling preserves value semantics for base types
  - Prove no-alias property for raw pointers passed across FFI
- [ ] **L-R3-02:** FFI boundary attack tests — Write at least 10 negative tests:
  - Buffer overflow via extern call (rejected)
  - Use-after-free across FFI boundary (rejected)
  - Type confusion: pass wrong type to extern function (rejected)
  - Double-free across boundary (rejected)
  - Null pointer dereference through FFI (rejected)
  - Callback use after scope exit (rejected)
  - Integer overflow in size parameters (rejected)
  - String encoding mismatch (rejected)
  - Struct layout mismatch (rejected)
  - Aliased mutable pointers across FFI (rejected)

### High Priority

- [ ] **L-R3-03:** FFI threat model — Document:
  - Attack surface: every extern block is an unverified trust boundary
  - What RIINA prevents: type confusion at call site, lifetime violations
  - What RIINA does NOT prevent: bugs inside extern implementations
- [ ] **L-R3-04:** Wire .rii FFI examples into integration tests — Existing examples should compile and produce correct codegen output

### Medium Priority

- [ ] **L-R3-05:** Per-target safety analysis — Document safety guarantees per codegen target (C, WASM, JNI, Swift) since each has different memory models
- [ ] **L-R3-06:** Unsafe audit — Inventory all `unsafe` blocks in FFI-related crates with justification

---

## R3 → R4 Tasks (Future)

- [ ] **L-R4-01:** Full FFI soundness proof — If RIINA code is well-typed and extern implementation satisfies its contract, composition is memory-safe
- [ ] **L-R4-02:** Verified marshaling — Coq proofs for type marshaling correctness per target
- [ ] **L-R4-03:** FFI fuzzer — Fuzz the FFI boundary with AFL/libFuzzer, track coverage
- [ ] **L-R4-04:** Callback safety model — Formal model proving RIINA closures passed to extern code remain valid
- [ ] **L-R4-05:** Cross-language ownership tracking — Formal model for ownership transfer across FFI boundary

---

## Verification Commands

```bash
# Check RustFFISecurity.v vacuity
grep -c "reflexivity\." 02_FORMAL/coq/ffi/RustFFISecurity.v

# Run FFI codegen tests
cargo test -p riina-codegen 2>&1 | grep "test result"

# Count existing FFI tests
cargo test -p riina-codegen 2>&1 | grep "test " | wc -l

# Check for unsafe blocks
grep -rn "unsafe" 03_PROTO/riina-codegen/src/
```
