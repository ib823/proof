# RIINA™ Threat Model — Compiler & Runtime

**Status:** Gate G deliverable (REQ-32). Living document.
**Methodology:** STRIDE (per-element), framed against the **Microsoft SDL** threat-modelling
practice and the **NIST SP 800-218 (SSDF)** practices PW.1 (design review) and RV.1/RV.2
(vulnerability handling). This is a *self-assessment by the maintainers*, not an external
review; the external review is REQ-28 (crypto) / Gate G (compiler), which remain **OPEN**.

> **Scope discipline (Prime Directive: No Shortcuts).** This document models the *trusted
> computing base actually shipped today*: the `riinac` compiler, the `riina-core` crypto/util
> library, the emitted C and WASM, and the build/verification pipeline. It does **not** model
> components that are spec-only or unimplemented (JALINAN async runtime, TCP/TLS networking,
> self-hosting) — those acquire threat models when they acquire code. Claims here are bounded
> by what `riinac verify --full` actually checks.

---

## 0. Method & notation

For each trusted element we enumerate the six STRIDE categories — **S**poofing, **T**ampering,
**R**epudiation, **I**nformation disclosure, **D**enial of service, **E**levation of privilege —
and for each applicable threat record: the asset, the attacker, the current mitigation (with a
*verifiable* anchor: a test, a Coq theorem, a CI gate, or a code reference), and the residual
risk. Threats that do not apply to an element are marked **N/A** with a one-line reason so the
enumeration is exhaustive rather than cherry-picked.

**Risk rating** uses CVSS-style qualitative bands (Low / Medium / High / Critical) on *residual*
risk after the stated mitigation. Anything **Medium+** residual is listed in §7 (Open Risks) so it
cannot hide.

---

## 1. Trust boundaries & data-flow (DFD level 1)

```
            ┌─────────────────────────────────────────────────────────────┐
            │  TRUSTED COMPUTING BASE (TCB)                                 │
  .rii  ───►│  riinac: lexer → parser → typechecker → lower → {C, WASM}     │───► C source / .wasm
 source     │                         │                                    │      (untrusted output,
 (UNTRUSTED)│                         └── riina-core (crypto, zeroize, CT)  │       compiled by cc /
            │                                                              │       run by wasmtime)
            └─────────────────────────────────────────────────────────────┘
                         ▲                              ▲
                         │                              │
              Coq corpus (02_FORMAL) ───────► proof-anchored invariants
              Build/verify pipeline (scripts, CI) ──► supply chain
```

**Trust boundaries crossed:**

- **TB-1 — Source intake.** `.rii` input is fully attacker-controlled. The lexer/parser/typechecker
  must treat every byte as hostile.
- **TB-2 — Codegen output.** Emitted C / WASM crosses out of the TCB into `cc` / `wasmtime`. RIINA's
  guarantee ends at *what it emits*; the downstream toolchain is its own TCB (documented, not owned).
- **TB-3 — Crypto secrets.** Keys/nonces inside `riina-core` cross into microarchitectural state
  (caches, prefetchers, branch predictors) — the side-channel boundary (§6).
- **TB-4 — Supply chain.** Source → toolchain (Rocq 9.2 / Lean 4.16 / Rust 1.94.1) → published
  artifacts/metrics. Tampering here forges the verification claims themselves.

**Assets (what an attacker wants):**

| Asset | Where | Why it matters |
|---|---|---|
| A1 Compiler integrity (sound compilation) | `riinac` | A miscompile silently breaks every downstream guarantee. |
| A2 Type/effect/IFC soundness | typechecker + Coq corpus | The product *is* these guarantees. |
| A3 Cryptographic secrets | `riina-core` key/nonce material | Confidentiality of user data. |
| A4 Constant-time property | `riina-core` + `masa_tetap` codegen | Secret-independent timing/microarch behaviour. |
| A5 Verification-claim authenticity | metrics.json, banners, proofs | RIINA's entire value proposition is *honest* verification. |
| A6 Availability of the compiler | `riinac` process | A compiler that hangs/OOMs on input is a DoS on CI. |

---

## 2. Element: Lexer / Parser (TB-1, untrusted input)

| STRIDE | Threat | Mitigation (anchor) | Residual |
|---|---|---|---|
| **S** | N/A | The parser has no identity/principal concept — there is nothing to spoof at this layer. | — |
| **T** | Malformed/adversarial source corrupts internal state → miscompile | Total functions over `Result`; **no `unsafe` in `riina-lexer`/`riina-parser` shipped paths** other than the lexer's `forbid(unsafe_code)`-exempt fast path (see §5). Lexer integer-suffix ranges are *validated at lex time* (`256u8` is a compile error, not UB). | Low |
| **R** | N/A | No persistent audit log is produced at parse time; nothing to repudiate. | — |
| **I** | Error messages echo source context | Diagnostics are derived from the user's own input; no cross-tenant data. | Low |
| **D** | Pathological input (deep nesting, huge tokens) → stack overflow / OOM / quadratic blowup | **Gap.** Recursion is native-stack (the W2 session raised `RUST_MIN_STACK` to 64 MiB for deep-recursion *tests*, but the parser has no explicit depth cap). Fuzzing (Gate E, REQ-30) is the planned control. | **Medium → §7 OR-1** |
| **E** | N/A | Parser runs at the same privilege as `riinac`; no boundary to elevate across. | — |

---

## 3. Element: Typechecker / Effect & IFC system (A2)

This is the element whose correctness *is* the product, so its threats are anchored to **Coq
theorems**, not just tests.

| STRIDE | Threat | Mitigation (anchor) | Residual |
|---|---|---|---|
| **S** | A `Secret`/`Rahsia` value is laundered into a public sink (label spoofing) | Non-interference is **machine-checked in Coq** (active corpus, REQ-11 DONE); the shipped checker enforces a subset (REQ-12 DONE, **REQ-27 PARTIAL** — full IFC enforcement parity is open). | **Medium → §7 OR-2** (proof ahead of enforcement) |
| **T** | Ill-typed program accepted (soundness hole) → downstream guarantee void | Type-safety theorems machine-checked in Coq; `cargo test` exercises the checker; `audit-docs.sh` pins 0 `Admitted`/0 axioms in the active corpus. | Low (within proven fragment); Medium for unproven fragments |
| **R** | N/A | No principal/audit concept at this layer. | — |
| **I** | Effect inference leaks via timing of checking | Checking time depends on program structure, not on any runtime secret. | Low |
| **D** | Inference loops / exponential unification on crafted types | Bounded by program size; no fixpoint without decreasing measure. Fuzzing is the planned assurance (Gate E). | Medium → §7 OR-1 |
| **E** | A capability/effect is acquired without the granting construct | Capabilities are compile-time; `Effect` is tracked on every builtin (File-I/O `Effect::FileSystem`, Network `Effect::Network`, Time precise-typed). Enforcement parity is **REQ-27 PARTIAL**. | Medium → §7 OR-2 |

---

## 4. Element: Code generation — emitted C & WASM (A1, TB-2)

| STRIDE | Threat | Mitigation (anchor) | Residual |
|---|---|---|---|
| **S** | N/A | Codegen emits text/bytecode; no identities. | — |
| **T** | **Miscompile** — emitted code computes something other than the source means | **Differential testing**: every numeric-tower + corpus example is asserted **byte-identical across interpreter, C, and WASM** (`riinac/tests/wasm_c_differential.rs`, corpus 37/37). The numeric tower additionally has **Coq equivalence models** (`BigIntModel.v`, `DecimalModel.v`, `FixedPointModel.v`, `SizedInt.v`) proving the algorithms are ring/field homomorphisms. The WASM backend **fails closed** (emits a compile error) on any construct it cannot yet compile — never a silent stub. | Low (covered constructs); Medium (uncovered constructs — mitigated by fail-closed) |
| **R** | N/A | — | — |
| **I** | Emitted code leaks secrets via layout/timing | For `masa_tetap`/CT code this is the side-channel surface (§6). Non-CT code makes no CT claim. | See §6 |
| **D** | Codegen OOM/blowup on huge programs | Linear in IR size; the bignum runtime is emitted **once per module and only when used** (no per-call bloat). | Low |
| **E** | Emitted C invokes UB that escalates in the *downstream* process | RIINA's boundary ends at emission (TB-2). The emitted C uses a fixed, audited runtime prelude; UB-freedom of `cc` output is a downstream-TCB property, documented not owned. | Medium → §7 OR-3 |

---

## 5. Element: `unsafe` code inventory (A1/A3 — the memory-safety TCB)

RIINA is **`#![forbid(unsafe_code)]` across 11 of 19 proto crates** (incl. `riinac`, lexer, runtime,
codegen-adjacent). All remaining `unsafe` is confined to **three locations**, each justified below.
This is the per-block audit log REQ-32 requires; the count is **re-derived from the tree
(2026-06-10)** — the plan's prose said "7", the tree has **8 blocks in 2 proto crates + 4 in
`riina-core`** (the discrepancy is corrected here per the Zero-Trust directive: trust the compiler,
not the doc).

### 5.1 `riina-arena` (5 blocks) — bump-allocated AST arena

| Site | Operation | Invariant that makes it sound |
|---|---|---|
| `lib.rs:148`, `:204` | `ptr.add(capacity)` to compute a chunk's end pointer | `capacity` is the `Vec`'s own allocation length; `add` stays within (or one-past) the allocation, which is the defined range for `pointer::add`. |
| `lib.rs:193` | `new_ptr.add(len)` to bump the cursor | `len` ≤ the current chunk's `storage.len()`, which is ≤ its capacity; the cursor never passes one-past-end (checked against `end` before each alloc). |
| `lib.rs:230` | `&*ptr.add(local_index)` to hand out an element ref | A chunk's `Vec` is **only ever pushed to, never reallocated or removed** (chunks are append-only; growth allocates a *new* chunk). So a reference into an existing chunk stays valid for the arena's lifetime — the standard typed-arena invariant. Bounds are checked (`index < offset + len`) before the deref; out-of-range panics. |
| `lib.rs:270` | `unsafe impl<T: Send> Send for TypedArena<T>` | Interior mutability is via `RefCell`/`Cell` (so **not `Sync`**), but moving the whole arena across threads is sound when `T: Send` — the bound is required and correct. |

**Residual:** Low. The arena is single-threaded in practice (compiler is not parallel), append-only,
and the references it vends are provably stable. 6 unit tests in-crate.

### 5.2 `riina-wasm` (3 blocks) — the browser-playground FFI shim

This crate is the `extern "C"` bridge for the in-browser playground (a Web Worker calls it); it is
**not** in the `riinac` compile path.

| Site | Operation | Invariant |
|---|---|---|
| `lib.rs:40` | `alloc(layout)` in `riina_alloc` | `layout` built from a non-zero `size` (zero returns null early); standard global-allocator contract. |
| `lib.rs:49` | `pub unsafe extern "C" fn riina_free` | Marked `unsafe` *in its signature* (correct — the caller must pass a `(ptr,size)` previously returned by `riina_alloc`). The safety contract is documented in the `# Safety` doc-comment; the JS worker honours it. |
| `lib.rs:66` | `slice::from_raw_parts(ptr, len)` to read worker-provided input | Null-checked first; the JS side guarantees `(ptr,len)` describes a buffer it just wrote via `riina_alloc`. UTF-8 is then *validated* (`str::from_utf8`), so malformed bytes become an `Err`, not UB. |
| `lib.rs:82` | `copy_nonoverlapping` to write the length-prefixed output | `total = 4 + bytes.len()`; the destination was just `riina_alloc(total)` and null-checked; source/dest do not overlap (fresh allocation). |

**Residual:** Medium → §7 OR-4. The FFI boundary trusts the JS caller to honour the `(ptr,size)`
contract; a buggy/hostile worker could pass a bad pair. This is inherent to a C-ABI playground shim
and is *outside the compiler TCB*, but it is the one place RIINA's own code dereferences
caller-supplied pointers.

### 5.3 `riina-core` (4 blocks) — crypto library

| Site | Operation | Invariant |
|---|---|---|
| `zeroize.rs:50`, `:88` | `ptr::write_volatile(_, 0)` | Writing a valid `0u8` to valid, initialised, uniquely-borrowed memory (`&mut`). Volatile + `compiler_fence(SeqCst)` is the *point* — it prevents the optimiser from eliding the secret-wipe (a defensive-security requirement, not a hazard). |
| `hmac.rs:93` | `ManuallyDrop::take(&mut self.inner_hash)` in `finalize(self)` | `finalize` takes `self` by value; `inner_hash` is taken exactly once and the `Drop` impl is written to *not* drop it again (it only zeroizes keys). No double-free, no use-after-take. |
| `ed25519.rs:1082` | `&*(ptr as *const Ed25519VerifyingKey)` | **Verified this session:** `Ed25519VerifyingKey` is `#[repr(transparent)]` over the `[u8; 32]` public key, so the reinterpret-cast is layout-sound. The SAFETY comment's claim is *true*. |

**Residual:** Low. All four are standard, narrowly-scoped crypto-hygiene patterns; `riina-core` is the
subject of the deepest assurance in the repo (9 Coq formal-equivalence proofs + CT lanes + ACVP KATs).

> **Note on `overflow-checks = false` for `riina-core` (release+test profile).** This is **not** an
> `unsafe` block but is a deliberate, security-motivated profile override: overflow checks insert
> `jo`/`jc`→panic *branches on the overflow flag of secret-derived limb arithmetic*, i.e. a
> secret-dependent branch (flagged by `ct-structural-check.sh`). The arithmetic is wrapping **by
> design** and proven correct by KATs + the Coq equivalence models, so the checks are removed *for
> this crate only*; they remain ON for the rest of the workspace. Recorded here so the override is
> auditable rather than surprising.

---

## 6. Side channels (A4, TB-3) — the GoFetch / transient-execution surface

REQ-32 explicitly requires this section to cover the **DMP/prefetcher class (GoFetch, 2024)** and the
**transient-execution families (Downfall, Inception)**, per `01_RESEARCH/29_REFRESH_2026H1/`.

### 6.0 Formal CT-scope: the leakage-contract framing (Guarnieri et al., S&P 2021) — REQ-39

The subsections below are easier to reason about — and RIINA's claims easier to
falsify — when the constant-time promise is stated as a **hardware-software
leakage contract** in the sense of Guarnieri, Köpf, Reineke & Vila,
*Hardware-Software Contracts for Secure Speculation* (IEEE S&P 2021). This is
RIINA's **official CT-scope statement**; §§6.1–6.4 are its consequences.

- **The contract RIINA targets is `ct` (constant-time observer) under
  sequential execution — `[[·]]^seq_ct`.** Under this contract the microarchitectural
  attacker observes, per executed instruction, only the **program-counter trace
  (control flow)** and the **addresses of memory loads/stores** — never the
  *values* at those addresses, and never operand-dependent instruction latency.
  A program is contract-satisfying iff any two executions that agree on public
  (non-secret) inputs produce **identical `ct` traces**.

- **RIINA discharges the SOFTWARE side of that contract.** The CT discipline
  (`masa_tetap`/`ct`, the `riina-core` primitives) is exactly the set of
  source-level obligations that make the `ct` trace secret-independent: no
  secret-dependent branch (equal pc-trace), no secret-dependent memory index
  (equal address-trace), branchless selects and operand-independent primitives
  (no secret-dependent latency). §6.4's structural-CT gate (ctgrind
  secret-poisoning) and the dudect timing probe are the *evidence* that the
  shipped primitives meet this obligation; the Coq CT lanes model it.

- **Every residual in §§6.2–6.3a is one thing: the DEPLOYED HARDWARE HONORS A
  STRONGER CONTRACT THAN `[[·]]^seq_ct`.** The contract framing makes each leak a
  precise *contract mismatch*, not a vague "CT isn't enough":
  - **DMP / GoFetch (§6.2)** — the CPU's true contract leaks a **value-dependent
    address** (the prefetcher dereferences data that looks like a pointer), i.e.
    it reveals loaded *values*, which `ct` explicitly excludes. Contract violated
    on the hardware side.
  - **Transient execution — Spectre/Downfall/Inception (§6.3), SLAP/FLOP
    (§6.3a)** — the CPU's true contract is **speculative** (`[[·]]^spec_ct` /
    predictor-specific variants such as `ct-pht`, `ct-stl`), which exposes the
    trace of *mispredicted* transient paths that `[[·]]^seq_ct` never contains.

- **Why this is honest, not a dodge.** A portable source-level compiler can only
  discharge the software half of a contract; it **cannot unilaterally guarantee
  the hardware half**. When the platform provides `[[·]]^seq_ct` (e.g. DMP
  disabled via **DIT**/the DMP MSR; the vendor microcode + OS mitigations that
  restore a sequential-`ct` contract), RIINA's proofs and CT evidence carry the
  end-to-end guarantee. When it does not, the gap is a **named hardware/OS
  obligation** (§§6.2–6.3a residuals, tracked in §7 OR-5/OR-6/OR-6a), not a
  silent hole. RIINA's contribution is to make the software side *provably*
  contract-satisfying so those deploy-time controls are meaningful.

### 6.1 What RIINA controls and what it does not

RIINA's CT discipline (`masa_tetap`/`ct`, and the `riina-core` primitives) targets the **classical
timing/cache channel**: no secret-dependent branches, no secret-dependent memory indices, branchless
selects, constant-time comparisons, verify-before-release AEAD. This is **necessary but, on modern
hardware, not sufficient** — and RIINA states so rather than over-claiming.

### 6.2 The DMP / GoFetch class (data-memory-dependent prefetcher)

- **Threat.** On Apple M1–M3 (and similar DMP designs), a *correct* constant-time implementation can
  still leak because the **prefetcher dereferences data that merely looks like a pointer**, turning a
  CT secret into an address-dependent memory access the attacker observes.
- **RIINA's position (honest).** This is **not defeatable in portable source code alone.** The
  documented mitigations are hardware/OS controls: Apple's **DIT** (Data-Independent Timing) flag /
  the DMP-disable MSR, or running affected crypto on cores/paths where the DMP is off. RIINA's
  source-level CT is a *prerequisite* for those controls to be meaningful, not a replacement.
- **Residual:** **High on affected hardware, source-level — accepted & disclosed (§7 OR-5).** The
  control is a deployment/runtime decision (set DIT) that a portable compiler cannot make for the
  user. Tracked as a known limitation, not a silent gap.

### 6.3 Transient execution (Downfall/GDS, Inception/SRSO, and the Spectre family)

- **Threat.** Speculative/transient execution can read across boundaries (Downfall = GATHER data
  sampling on Intel; Inception = return-stack/BTB poisoning on AMD Zen). These are **microarchitectural
  data-sampling / domain-crossing** leaks.
- **RIINA's position.** These are **CPU-microcode + OS-mitigation** territory (Intel/AMD microcode,
  KPTI-style isolation, `mitigations=` kernel flags). A language/compiler cannot close them from
  source. RIINA does not execute attacker code in the same address space as secrets at runtime (the
  compiler is batch, not a sandboxed multi-tenant JIT), which limits the *in-RIINA* exposure to the
  compile-time process — but the *emitted* program's runtime exposure is the deployer's platform
  responsibility.
- **Residual:** **High, platform-level — accepted & disclosed (§7 OR-6).**

### 6.3a SLAP & FLOP — Apple M-series load predictors (2025; REQ-37)

- **Threat.** Disclosed Jan 2025 on Apple M-series: **SLAP** abuses the **Load
  Address Predictor** (speculate a load's *address*) and **FLOP** the **Load Value
  Predictor** (speculate a load's *value*); both open a Spectre-class transient
  window that computes on mispredicted data and leaks across boundaries (e.g.
  Safari process isolation). They are a sibling pair and are **distinct from the
  DMP/GoFetch prefetcher** (§6.2) — predictor-driven, not prefetcher-driven.
- **RIINA's position.** Same as the rest of §6: source-level constant-time covers
  instruction-timing and secret-branch/secret-memory channels; it does **NOT**
  defeat predictor-driven transient execution on affected microarchitectures.
  Mitigation is deploy-time (vendor microcode/OS controls; not co-locating secrets
  with attacker-controlled JS). A portable compiler cannot close it from source.
- **Residual:** **High, platform-level — accepted & disclosed (§7 OR-6a).**

### 6.4 What *is* verifiable today (so the section isn't all caveats)

- **Structural CT** (`scripts/ct-structural-check.sh`, ctgrind secret-poisoning) is a **CI gate**:
  AES, `ct_eq`, X25519, Ed25519, **and ML-KEM-768 decapsulation** (added 2026-06-13, REQ-43) are structurally CT-clean (0 memcheck errors; 5/5 primitives), after *real fixes,
  zero suppressions* (the `overflow-checks` change above; `black_box` barriers on selects LLVM had
  lowered to `js`; a genuine variable-time `while carry>0` loop in `ed25519::scalar_mul` fixed to a
  fixed trip count).
- **Timing CT** (`scripts/ct-timing-certify.sh`, dudect Welch t-test) is **host-graded**:
  in-container reads are *indicative* (shared vCPU); the certification-grade run on isolated metal
  (`isolcpus`/fixed-freq) is the REQ-28 step — **OPEN**.
- **No explicit SIMD/gather** in shipped `riina-core` source (verified 2026-06-10) — the
  Downfall-GATHER primitive is not directly invoked by RIINA's portable code.

---

## 7. Element: Supply chain & verification authenticity (A5, TB-4)

| STRIDE | Threat | Mitigation (anchor) | Residual |
|---|---|---|---|
| **S** | Forged "verified" artifact / spoofed metrics | Metrics are **re-derived by command** (`generate-metrics.sh`), pinned in `metrics.json`, and `audit-docs.sh` gates doc/metric parity; the verification banner is propagated, not hand-edited. | Medium → §7 OR-7 |
| **T** | Tampered toolchain/dep injects a backdoor | **Law 8 (zero third-party deps)** — verified: the proto workspace has *no* third-party crates — collapses the dep-tampering surface to the pinned toolchains (Rocq 9.2 / Lean 4.16 / Rust 1.94.1). | Low-Medium |
| **R** | Maintainer denies a change | Git history + signed-commit convention; **bus factor = 1 (REQ-36 OPEN)** weakens this. | Medium → §7 OR-8 |
| **I** | Build leaks secrets | No secrets in the build; public repo. | Low |
| **D** | Hostile dep yanks/breaks build | No third-party deps to yank (Law 8). | Low |
| **E** | CI runs untrusted code with repo privileges | CI is a *thin wrapper* over the repo's own gates (`verify.yml` runs `make`, `cargo test`, `audit-docs.sh`) and must never add divergent checks (CLAUDE.md Forbidden Action #6). | Low |

**Not yet met (Gate F, REQ-31):** hermetic Nix build, per-build SBOM, signed releases, hash-chain
attestation, SLSA-3. These are the supply-chain hardening backlog and are **explicitly out of scope
for this self-assessment** (multi-session infra work).

---

## 8. Open Risks register (residual Medium+)

Every Medium-or-higher residual from the tables above, consolidated so nothing hides:

| ID | Risk | Sev | Owner control / next step |
|---|---|---|---|
| **OR-1** | No explicit parser/typechecker depth/resource cap → crafted-input DoS | Medium | Gate E (REQ-30): enable the excluded fuzzing workspace; add depth/time caps if fuzzing finds blowups. |
| **OR-2** | IFC/effect **proof is ahead of enforcement** (REQ-27 PARTIAL) — the checker enforces a subset of what Coq proves | Medium | REQ-27: extend compiler enforcement to full IFC + linear + session parity. The *proof* exists; *enforcement parity* is the gap. |
| **OR-3** | Emitted-C UB-freedom is a downstream-TCB property, asserted by differential testing not proven | Medium | Long-term: a verified-compilation (CompCert-style) or translation-validation lane. Today: 37/37 byte-identical differential. |
| **OR-4** | `riina-wasm` FFI dereferences caller-supplied `(ptr,len)` | Medium | Playground shim, outside compiler TCB; documented contract. Could add a length/sanity guard. |
| **OR-5** | DMP/GoFetch leak on affected HW despite source-level CT | High (HW-specific) | **Accepted & disclosed** — requires DIT/DMP-disable at deploy time; a portable compiler cannot set it. |
| **OR-6** | Transient-execution (Downfall/Inception) leaks at the platform level | High (platform) | **Accepted & disclosed** — CPU-microcode + OS-mitigation territory. |
| **OR-6a** | SLAP/FLOP load-predictor transient leaks on Apple M-series (2025) | High (platform) | **Accepted & disclosed** (§6.3a) — predictor-driven; deploy-time vendor/OS controls, not a source-level fix. |
| **OR-7** | Verification-claim authenticity rests on self-run scripts, not third-party attestation | Medium | Gate F signed/attested releases; the external audit (REQ-28) independently re-derives. |
| **OR-8** | Bus factor = 1 (REQ-36) weakens non-repudiation & continuity | Medium | Gate J: recruit ≥2 maintainers. Owner decision. |
| **OR-9** | External compiler/crypto audit not yet performed (REQ-28/Gate G) | — (process) | **OPEN, owner-gated** — the pre-audit dossier is ready; engagement is a budget decision. |

---

## 9. Assumptions & non-goals (so the model is falsifiable)

1. **The downstream toolchain is trusted.** `cc`, `wasmtime`, the OS, and the CPU are each their own
   TCB. RIINA's guarantee is over *what it emits*, end at TB-2.
2. **The host hardware's microarchitectural mitigations are the deployer's responsibility** (DIT,
   microcode, kernel `mitigations=`). RIINA provides source-level CT as the prerequisite, not the
   whole defense.
3. **The compiler is batch, single-tenant.** RIINA does not (today) run untrusted code in the same
   address space as secrets, which bounds the transient-execution exposure to the compile process.
4. **Hardware root of trust is assumed, not provided (REQ-37).** RIINA's secure-boot / attestation
   story (REQ-31 SBOM + reproducible build) and this threat model assume a trustworthy silicon
   **root of trust** below the software — the named industry anchors are **Caliptra** (OCP/CHIPS-Alliance
   datacenter RoT) and **OpenTitan** (lowRISC discrete RoT). RIINA is a language + verified stdlib; the
   RoT is *out of the language boundary* — its measured-boot/attestation/key-storage guarantees are
   the hardware layer RIINA's software attestation chains to, not something RIINA implements.
5. **Non-goals:** RIINA does not claim to defeat physical attacks, fault injection, power/EM analysis
   (Collide+Power), or a malicious host OS. These are out of the language/compiler's reach.

---

## 10. Maintenance

This document is updated when (a) a new `unsafe` block is added (the §5 inventory is a gate — a new
block without an entry should fail review), (b) a new trust boundary appears (e.g. when networking or
the async runtime acquire code), or (c) an Open Risk changes state. The `unsafe` count in §5 is
**re-derived from the tree**, never copied — per the Paranoid-Absolute Verification directive.
