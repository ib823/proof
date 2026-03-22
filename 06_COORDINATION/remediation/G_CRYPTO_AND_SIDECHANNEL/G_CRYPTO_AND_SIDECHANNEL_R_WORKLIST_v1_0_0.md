# G_CRYPTO_AND_SIDECHANNEL — Remediation Worklist v1.0.0

**Current:** R2 | **Target:** R3
**Created:** 2026-03-21

---

## R2 → R3 Tasks

### Critical (Blocks R3)

- [ ] **G-R3-01:** Scope-split document — Write `G_SCOPE_SPLIT.md` defining G-CT (CT discipline) vs G-CRYPTO (ZK/PQ/broader) sub-scopes with separate rating tracks
- [ ] **G-R3-02:** Vacuous file triage — For each of CryptographicSecurity.v, TimingSecurity.v, ZKSNARKSecurity.v, ZKSTARKSecurity.v, PostQuantumSignatures.v, PostQuantumKEM.v: mark as REWRITE or ARCHIVE
- [ ] **G-R3-03:** Archive or rewrite — Execute the triage. Archived files go to `99_ARCHIVE/coq/crypto/`. Rewritten files must pass vacuity check (no `reflexivity.` on boolean records)
- [ ] **G-R3-04:** Nontrivial CT Coq proof — Write at least one proof with real content. Candidates:
  - `ct_select` returns correct branch without timing variation (model constant-time as absence of secret-dependent branching)
  - CT propagation: if inputs are CT-typed, arithmetic on them preserves CT

### High Priority

- [ ] **G-R3-05:** Verify crypto test count — Run `cargo test -p riina-core` and record exact count of crypto-related tests. Update audit evidence.
- [ ] **G-R3-06:** CT threat model — Document: what timing attacks RIINA CT prevents, what it does not prevent (e.g., cache-line attacks, speculative execution)

### Medium Priority

- [ ] **G-R3-07:** Wire .rii CT examples into integration tests — Examples in 07_EXAMPLES/ that use `kesan Bersih` with crypto operations should have corresponding test assertions
- [ ] **G-R3-08:** Spectre litmus test documentation — Existing litmus tests need threat model linkage

---

## R3 → R4 Tasks (Future)

- [ ] **G-R4-01:** Formal PQ security model — Lattice-based hardness assumptions in Coq (MLWE, MLWR)
- [ ] **G-R4-02:** Formal ZK soundness — Simulation-based security definitions, not boolean fields
- [ ] **G-R4-03:** ct_oracle CI integration — Automated timing regression detection
- [ ] **G-R4-04:** Side-channel coverage metrics — Measure what percentage of crypto code paths are ct_oracle-tested
- [ ] **G-R4-05:** AES/Ed25519 implementation correctness proofs — Link Coq models to actual Rust implementations

---

## Verification Commands

```bash
# Check vacuous Coq files
grep -c "reflexivity\." 02_FORMAL/coq/security/CryptographicSecurity.v
grep -c "reflexivity\." 02_FORMAL/coq/security/TimingSecurity.v

# Count crypto tests
cargo test -p riina-core 2>&1 | grep "test result"

# Check CT enforcement tests
cargo test -p riina-typechecker -- ct 2>&1 | grep "test result"
```
