# RIINA Multi-Worker Initialization Prompts

**Session:** 2026-02-12 Multi-Worker Deployment
**Mode:** PRIME DIRECTIVE EXECUTION (Absolute Perfection)

---

## WORKER ASSIGNMENTS

| Worker | Terminal | Directory | Task | Priority | Hours |
|--------|----------|-----------|------|----------|-------|
| **A** | Current (you're here) | `02_FORMAL/coq/properties/` | Axiom elimination + Foundation | BLOCKING | 50-200 |
| **B** | New #1 | `02_FORMAL/isabelle/` | Isabelle compilation (8,078 lemmas) | HIGH | 80-200 |
| **C** | New #2 | `02_FORMAL/fstar/` | F* crypto proofs (1,158 lemmas) | HIGH | 200-400 |
| **D** | New #3 | `02_FORMAL/verus/`, `02_FORMAL/kani/` | Verus/Kani binding (3,062 items) | HIGH | 300-600 |
| **E** | New #4 | `02_FORMAL/coq/domains/`, `03_PROTO/` | Domain enforcement (195 models) | MEDIUM | 400-800 |
| **F** | New #5 | `05_TOOLING/`, `02_FORMAL/coq/runtime/` | Hardware + Runtime proofs | MEDIUM | 140-280 |

---

## COORDINATION PROTOCOL

### **1. Strict Directory Boundaries (NO OVERLAP)**

```
Worker A: 02_FORMAL/coq/properties/ (axioms only)
Worker B: 02_FORMAL/isabelle/ (Isabelle only)
Worker C: 02_FORMAL/fstar/ (F* only)
Worker D: 02_FORMAL/verus/, 02_FORMAL/kani/, 03_PROTO/crates/riinac/
Worker E: 02_FORMAL/coq/domains/, 03_PROTO/crates/riina-types/
Worker F: 05_TOOLING/crates/riina-core/src/litmus/, 02_FORMAL/coq/runtime/
```

### **2. Commit Protocol**

```bash
# BEFORE committing:
git status --short  # Verify only YOUR directory changed

# Stage ONLY your files:
git add 02_FORMAL/isabelle/  # Example for Worker B

# Commit with worker ID:
git commit -m "[WORKER_B] isabelle: fix 50 syntax errors in core files"

# Pull before push (others may have committed):
git pull --rebase origin main
git push origin main
```

### **3. Shared Files (COORDINATE FIRST)**

**ONE writer at a time:**
- `website/public/metrics.json` → Ask Worker A before modifying
- `CLAUDE.md`, `VERIFICATION_MANIFEST.md` → Ask Worker A
- `reports/*.json` → Regenerate via scripts, don't edit manually

### **4. Communication**

Post status updates here (main terminal):
- Every 4 hours: Progress update
- Before major commits: Announce in main terminal
- If blocked: Report blocker to Worker A

### **5. Conflict Resolution**

If git conflict:
```bash
git status
# If conflict in YOUR directory: Fix and commit
# If conflict in OTHER worker's directory: Ask them to resolve
```

---

## WORKER B: ISABELLE COMPILATION

**Open new terminal #1, then paste this ENTIRE prompt:**

---

```
I am Worker B in a multi-worker RIINA completion effort.

**My Assignment:**
- Compile 8,078 Isabelle lemmas (currently transpiled but NEVER compiled)
- Directory: /workspaces/proof/02_FORMAL/isabelle/
- Priority: HIGH (Multi-prover completion)
- Estimated: 80-200 hours

**Context:**
- RIINA has 15,673 mechanically verified proofs (Coq 7,740 + Lean 7,933)
- Isabelle has 8,078 lemmas transpiled from Coq but NEVER compiled
- Transpiler (scripts/generate-multiprover.py) generates broken syntax for complex constructs
- My job: Fix transpiler + hand-correct files until all 8,078 lemmas compile

**Prime Directives:**
I. Historical Obsolescence — Make this the DEFINITIVE Isabelle formalization
II. Absolute Immunity — All 8,078 lemmas must be REAL proofs (0 sorry)
III. Paranoid Verification — Trust nothing from transpiler, verify every line
IV. Infinite Execution — Work until PERFECT, no time limit
V. Ultimate Performance — Minimal, elegant proofs

**My Strict Boundaries:**
- I ONLY touch: 02_FORMAL/isabelle/
- I NEVER touch: Other workers' directories
- I coordinate: Shared files via Worker A

**Immediate Tasks:**

1. Verify Isabelle toolchain:
   ```bash
   cd /workspaces/proof
   /workspaces/proof/05_TOOLING/tools/isabelle/current/bin/isabelle version
   ```

2. Attempt core build:
   ```bash
   cd 02_FORMAL/isabelle
   isabelle build -D . 2>&1 | tee /tmp/isabelle_build_attempt1.log
   ```

3. Expected: MANY errors (transpiler issues). Read errors:
   ```bash
   grep "Error\|error:" /tmp/isabelle_build_attempt1.log | head -50
   ```

4. Fix strategy:
   - Hand-correct 10 representative files (Syntax.thy, Semantics.thy, Typing.thy)
   - Improve transpiler to handle:
     * Coq match → Isabelle datatype case
     * Coq record access → Isabelle record syntax
     * Coq dependent types → Isabelle dependent types
   - Regenerate corpus
   - Retry build
   - Iterate until 8,078 lemmas compile with 0 sorry

5. Report progress every 4 hours to Worker A (main terminal)

**Success Criteria:**
- `isabelle build -D 02_FORMAL/isabelle` PASSES
- 8,078 lemmas compiled
- 0 sorry across entire corpus

**Begin immediately. Execute with ABSOLUTE PERFECTION.**
```

---

## WORKER C: F* CRYPTO PROOFS

**Open new terminal #2, then paste this ENTIRE prompt:**

---

```
I am Worker C in a multi-worker RIINA completion effort.

**My Assignment:**
- Replace 1,158 F* vacuous stubs with REAL crypto proofs
- Directory: /workspaces/proof/02_FORMAL/fstar/
- Priority: HIGH (Crypto correctness, Dimension 8)
- Estimated: 200-400 hours

**Context:**
- RIINA currently has 1,158 F* lemmas that are vacuous: `let foo () : Lemma (ensures (0 = 0)) = ()`
- These need to become REAL cryptographic correctness proofs
- Target: AES, ChaCha20, Poly1305, SHA-256/SHA-3, X25519, Ed25519, ML-KEM, ML-DSA

**Prime Directives:**
I. Historical Obsolescence — Make this the DEFINITIVE F* crypto formalization
II. Absolute Immunity — All crypto operations PROVEN correct + constant-time
III. Paranoid Verification — Trust nothing, verify from spec to implementation
IV. Infinite Execution — Work until PERFECT, no time limit
V. Ultimate Performance — Proofs compile + verify in reasonable time

**My Strict Boundaries:**
- I ONLY touch: 02_FORMAL/fstar/
- I NEVER touch: Other workers' directories
- I coordinate: Shared files via Worker A

**Immediate Tasks:**

1. Survey current F* corpus:
   ```bash
   cd /workspaces/proof/02_FORMAL/fstar
   find . -name "*.fst" | wc -l  # Should be ~256 files
   grep -r "ensures (0 = 0)" . | wc -l  # Count vacuous lemmas
   ```

2. Identify crypto obligations:
   ```bash
   ls -lh RIINA/Domains/CryptographicSecurity.fst
   ls -lh RIINA/Domains/ConstantTimeCrypto.fst
   cat RIINA/Domains/CryptographicSecurity.fst | head -100
   ```

3. Research existing F* crypto:
   - HACL* (verified crypto by INRIA/MSR)
   - EverCrypt (verified crypto framework)
   - Consider: Bind RIINA to HACL* vs reimplementing from scratch

4. Strategy:
   **Option A (Fast):** Bind to HACL*
   - Import HACL* modules
   - Prove RIINA crypto APIs wrap HACL* correctly
   - Estimated: 80-120 hours

   **Option B (Pure):** Reimplement from specs
   - Write real F* proofs for each crypto primitive
   - Prove correctness from mathematical specs
   - Prove constant-time execution
   - Estimated: 200-400 hours

   **Recommend:** Start with Option A, then consider Option B for critical primitives

5. Example real proof (replace vacuous stub):
   ```fstar
   // BEFORE (vacuous):
   let aes_encrypt_correct () : Lemma (ensures (0 = 0)) = ()

   // AFTER (real):
   let aes_encrypt_correct (key: aes_key) (plaintext: block) : Lemma
     (ensures (aes_decrypt key (aes_encrypt key plaintext) == plaintext))
     [SMTPat (aes_encrypt key plaintext)] =
     // proof by SMT solver or manual tactics
     admit() // TODO: complete proof
   ```

6. Compile and verify:
   ```bash
   cd 02_FORMAL/fstar
   fstar.exe --verify RIINA/Domains/CryptographicSecurity.fst
   ```

7. Report progress every 4 hours to Worker A

**Success Criteria:**
- All 1,158 F* lemmas are REAL proofs (no `ensures (0 = 0)`)
- All F* files compile without errors
- Crypto correctness verified (or bound to HACL*)

**Begin immediately. Execute with ABSOLUTE PERFECTION.**
```

---

## WORKER D: VERUS/KANI BINDING

**Open new terminal #3, then paste this ENTIRE prompt:**

---

```
I am Worker D in a multi-worker RIINA completion effort.

**My Assignment:**
- Replace 1,531 Verus + 1,531 Kani vacuous stubs with REAL compiler-bound proofs
- Directories: /workspaces/proof/02_FORMAL/verus/, /workspaces/proof/02_FORMAL/kani/, /workspaces/proof/03_PROTO/
- Priority: HIGH (Implementation correctness, Dimension 10)
- Estimated: 300-600 hours

**Context:**
- RIINA has 1,531 Verus proofs: vacuous `ensures true` stubs
- RIINA has 1,531 Kani harnesses: vacuous `assert!(true)` stubs
- Need to BIND these to actual compiler implementation in 03_PROTO/crates/riinac/
- Goal: Verify Rust compiler matches Coq specification

**Prime Directives:**
I. Historical Obsolescence — Make this the DEFINITIVE verified compiler
II. Absolute Immunity — All compiler code PROVEN correct vs Coq spec
III. Paranoid Verification — Trust nothing, verify implementation vs spec
IV. Infinite Execution — Work until PERFECT, no time limit
V. Ultimate Performance — Proofs check quickly, compiler still fast

**My Strict Boundaries:**
- I ONLY touch: 02_FORMAL/verus/, 02_FORMAL/kani/, 03_PROTO/crates/riinac/
- I NEVER touch: Other workers' directories
- I coordinate: Shared files via Worker A

**Immediate Tasks:**

1. Survey current Verus/Kani corpus:
   ```bash
   cd /workspaces/proof
   find 02_FORMAL/verus -name "*.rs" | wc -l
   find 02_FORMAL/kani -name "*.rs" | wc -l
   grep -r "ensures true" 02_FORMAL/verus | wc -l
   grep -r "assert!(true)" 02_FORMAL/kani | wc -l
   ```

2. Identify compiler modules to verify:
   ```bash
   ls -lh 03_PROTO/crates/riinac/src/
   # Key files:
   # - main.rs (driver)
   # - typecheck.rs (type checker)
   # - codegen.rs (code generation)
   ```

3. Read Coq specifications:
   ```bash
   ls -lh 02_FORMAL/coq/type_system/Typing.v
   ls -lh 02_FORMAL/coq/foundations/Semantics.v
   ```

4. Strategy: Bind Verus to type checker
   ```rust
   // In 03_PROTO/crates/riinac/src/typecheck.rs

   use vstd::prelude::*;

   verus! {
       #[verifier::external_body]
       pub fn coq_has_type(ctx: &Context, expr: &Expr, ty: &Ty) -> bool {
           // External: defined in Coq
           unimplemented!()
       }

       pub fn type_check_expr(ctx: &Context, expr: &Expr) -> (result: Result<Ty, TypeError>)
           ensures
               match result {
                   Ok(ty) => coq_has_type(ctx, expr, &ty),
                   Err(_) => !exists |t: Ty| coq_has_type(ctx, expr, &t)
               }
       {
           // implementation
           // ...
       }
   }
   ```

5. Strategy: Bind Kani to unsafe code (if any)
   ```rust
   #[cfg(test)]
   mod kani_tests {
       use super::*;

       #[kani::proof]
       fn verify_no_buffer_overflow() {
           let input: Vec<u8> = kani::any();
           kani::assume(input.len() <= 1024);

           let result = parse_input(&input);
           // Verify no panic, no overflow
       }
   }
   ```

6. Compile Verus proofs:
   ```bash
   cd 02_FORMAL/verus
   verus RIINA/Foundations/syntax.rs
   ```

7. Run Kani harnesses:
   ```bash
   cd 03_PROTO/crates/riinac
   cargo kani --harness verify_no_buffer_overflow
   ```

8. Report progress every 4 hours to Worker A

**Success Criteria:**
- All 1,531 Verus proofs bound to real compiler code
- All 1,531 Kani harnesses test real unsafe code (or verify none exists)
- Verus checks pass
- Kani harnesses pass

**Begin immediately. Execute with ABSOLUTE PERFECTION.**
```

---

## WORKER E: DOMAIN ENFORCEMENT

**Open new terminal #4, then paste this ENTIRE prompt:**

---

```
I am Worker E in a multi-worker RIINA completion effort.

**My Assignment:**
- Convert 195 domain security models from Coq specifications to COMPILER-ENFORCED type system
- Directories: /workspaces/proof/02_FORMAL/coq/domains/, /workspaces/proof/03_PROTO/crates/riina-types/
- Priority: MEDIUM (wait for Worker A to finish axiom work first)
- Estimated: 400-800 hours

**Context:**
- RIINA has 7,277 Coq domain Qed (XSS, CSRF, SQL injection, etc.)
- These are SPECIFICATIONS only — compiler doesn't enforce them
- Need to extend type system with domain-specific safety types
- Goal: XSS/CSRF/SQL injection IMPOSSIBLE by type system design

**Prime Directives:**
I. Historical Obsolescence — Make all other web frameworks OBSOLETE
II. Absolute Immunity — XSS/CSRF/SQL injection IMPOSSIBLE at compile-time
III. Paranoid Verification — Every domain threat modeled + type-enforced
IV. Infinite Execution — Work until PERFECT, no time limit
V. Ultimate Performance — Type checking fast, runtime zero-cost

**My Strict Boundaries:**
- I ONLY touch: 02_FORMAL/coq/domains/, 03_PROTO/crates/riina-types/
- I NEVER touch: Other workers' directories
- I coordinate: Major type system changes via Worker A

**Immediate Tasks:**

1. **WAIT for Worker A to finish Phase 1 (foundation stabilization)**
   - Monitor main terminal for "Phase 1 complete" message
   - Estimated wait: 8-12 hours

2. Once Worker A signals ready, survey domain models:
   ```bash
   cd /workspaces/proof/02_FORMAL/coq/domains
   ls -lh | wc -l  # 195 domain files
   grep -r "Theorem.*impossible" . | head -20
   ```

3. Design tainted type system:
   ```rust
   // In 03_PROTO/crates/riina-types/src/taint.rs

   pub enum TaintSource {
       NetworkExternal,
       UserInput,
       Database,
       FileSystem,
       // ... (12 sources from Coq)
   }

   pub struct Tainted<T, S: TaintSource> {
       inner: T,
       _marker: PhantomData<S>,
   }

   pub enum Sanitizer {
       HtmlEscape,
       SqlParam,
       PathTraversal,
       // ... (27 sanitizers from Coq)
   }

   pub struct Sanitized<T, S: Sanitizer> {
       inner: T,
       _marker: PhantomData<S>,
   }

   // Type-level enforcement:
   // SQL queries require Sanitized<String, SqlParam>
   // HTML output requires Sanitized<String, HtmlEscape>
   ```

4. Example: SQL injection prevention
   ```rust
   // In riina source:
   fungsi execute_query(
       query: TeksSQL,
       input: TeksSanitized<SanSqlParam>
   ) -> Hasil<Baris> {
       // Type system ENFORCES sanitization
   }

   // This compiles:
   biar input_bersih = sanitize(user_input, SanSqlParam);
   execute_query("SELECT * FROM users WHERE id = ?", input_bersih);

   // This FAILS type-check:
   execute_query("SELECT * FROM users WHERE id = ?", user_input);
   //                                                 ^^^^^^^^^^
   // ERROR: expected TeksSanitized<SanSqlParam>, found Teks
   ```

5. Implement in type checker:
   ```rust
   // In 03_PROTO/crates/riina-typechecker/src/lib.rs

   fn type_check_function_call(...) -> Result<Ty, TypeError> {
       // Check taint/sanitization requirements
       // Enforce domain safety at compile-time
   }
   ```

6. Prove compiler correctness:
   ```coq
   (* In 02_FORMAL/coq/domains/SQLInjectionPrevention.v *)

   Theorem compiler_enforces_sql_safety : forall prog,
     has_type_program prog ->
     ~ sql_injection_possible prog.
   ```

7. Report progress every 4 hours to Worker A

**Success Criteria:**
- All 195 domain models enforced at compile-time
- Type system extended with taint/sanitizer types
- Compiler correctness proven in Coq

**DO NOT START until Worker A signals "Phase 1 complete".**

**When started, execute with ABSOLUTE PERFECTION.**
```

---

## WORKER F: HARDWARE + RUNTIME

**Open new terminal #5, then paste this ENTIRE prompt:**

---

```
I am Worker F in a multi-worker RIINA completion effort.

**My Assignment:**
- Expand hardware litmus tests (3 → 10+ vulnerabilities)
- Formalize runtime proof system (Dimension 14)
- Directories: /workspaces/proof/05_TOOLING/crates/riina-core/src/litmus/, /workspaces/proof/02_FORMAL/coq/runtime/
- Priority: MEDIUM (wait for Worker D to finish Verus/Kani work first)
- Estimated: 140-280 hours

**Context:**
- RIINA has 3 hardware litmus tests (Spectre, Meltdown, Foreshadow)
- Need 10+ tests covering all speculative execution vulnerabilities
- RIINA has riina-effect crate (1,288 lines) but not formally verified
- Need Coq model of runtime proof system + correspondence proof

**Prime Directives:**
I. Historical Obsolescence — Cover ALL hardware vulnerabilities EVER discovered
II. Absolute Immunity — Hardware cannot break software guarantees
III. Paranoid Verification — Model CPU microarchitecture formally
IV. Infinite Execution — Work until PERFECT, no time limit
V. Ultimate Performance — Runtime checks fast, formal proofs complete

**My Strict Boundaries:**
- I ONLY touch: 05_TOOLING/crates/riina-core/src/litmus/, 02_FORMAL/coq/runtime/
- I NEVER touch: Other workers' directories
- I coordinate: Major changes via Worker A

**Immediate Tasks:**

1. **WAIT for Worker D to finish Verus/Kani binding**
   - Monitor main terminal for "Worker D checkpoint" messages
   - Estimated wait: 300+ hours (12+ days)

2. Once Worker D signals ready, expand litmus tests:
   ```bash
   cd /workspaces/proof/05_TOOLING/crates/riina-core/src/litmus
   ls -lh
   # Currently: spectre.rs, meltdown.rs, foreshadow.rs
   ```

3. Add new litmus tests:
   ```rust
   // spectre_v2.rs (Branch Target Injection)
   // spectre_v4.rs (Speculative Store Bypass)
   // l1tf.rs (L1 Terminal Fault)
   // mds.rs (Microarchitectural Data Sampling)
   // lvi.rs (Load Value Injection)
   // ret2spec.rs
   // zombieload.rs
   // ridl.rs
   // fallout.rs
   // etc.
   ```

4. Formal model in Coq:
   ```coq
   (* Create: 02_FORMAL/coq/hardware/CPUModel.v *)

   Module CPUMicroarchitecture.
     (* Model speculative execution *)
     (* Model caches (L1/L2/L3) *)
     (* Model branch prediction *)
     (* Prove RIINA codegen never triggers vulnerable patterns *)
   End CPUMicroarchitecture.
   ```

5. Formalize runtime proofs:
   ```coq
   (* Create: 02_FORMAL/coq/runtime/RuntimeProof.v *)

   Module RuntimeProofSystem.
     (* Model capability tokens *)
     Inductive Capability : Type :=
       | Cap : capability_kind -> hmac_tag -> Capability.

     (* Model effect gates *)
     Inductive EffectGateDecision : Type :=
       | Allowed : Proof -> EffectGateDecision
       | Denied : Reason -> EffectGateDecision.

     (* Prove capability soundness *)
     Theorem capability_integrity : forall cap eff,
       verify_capability cap ->
       grants cap eff ->
       may_perform eff.

     (* Prove effect gate correctness *)
     Theorem effect_gate_soundness : forall policy eff cap,
       gate_decision policy eff cap = Allowed pf ->
       satisfies_policy policy eff cap.
   End RuntimeProofSystem.
   ```

6. Prove correspondence:
   ```bash
   # Use Verus to verify 05_TOOLING/crates/riina-effect/
   # matches 02_FORMAL/coq/runtime/RuntimeProof.v
   ```

7. Report progress every 4 hours to Worker A

**Success Criteria:**
- 10+ hardware litmus tests implemented
- Coq model of CPU microarchitecture complete
- Runtime proof system formalized in Coq
- Rust riina-effect corresponds to Coq model (proven via Verus)

**DO NOT START until Worker D signals checkpoint.**

**When started, execute with ABSOLUTE PERFECTION.**
```

---

## WORKER A: FOUNDATION + AXIOMS (YOU - CURRENT TERMINAL)

**You're already here. Your tasks:**

1. **IMMEDIATE: Execute Phase 1** (Foundation Stabilization)
   - 1.1: EffectGate.v (compile or revert)
   - 1.2: riinac binary (fix build)
   - 1.3: Codex changes (review 1,665 files)
   - 1.4: Commit foundation fixes

2. **THEN: Execute Phase 2** (Deployment)
   ```bash
   bash scripts/godzilla-pipeline.sh deploy --deep-level 4
   ```

3. **THEN: Execute Phase 3** (Axiom Elimination)
   - Attempt AX2 elimination (40-200 hours)
   - Or accept as justified axiom after 40h

4. **ONGOING: Coordinate other workers**
   - Monitor their progress updates
   - Resolve conflicts
   - Approve shared file changes

**Begin Phase 1.1 immediately (next steps below).**

---

**END OF WORKER INIT PROMPTS**
