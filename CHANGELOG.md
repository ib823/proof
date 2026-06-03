# Changelog

**Verification:** 12,386 Coq Qed (compiled, 0 Admitted, 0 active axioms) | 10 prover lanes tracked with claim levels | 2662 Rust tests

All notable changes to RIINA™ will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] — 2026-06-02 — Gate B CLOSED → Gate C opened (crypto-audit prep)

### Added (Gate C stdlib hardening)
- **Effect-set on function declarations → sound multi-capability gating**:
  `TopLevelDecl::Function` now carries `effect_set: Vec<Effect>` — the *components*
  of a compound `kesan (A, B, C)` (the lattice `effect` field is the lossy max-join).
  `check_program` grants **every** component in the body, so a compound-effect
  function authorizes all its declared ambient ops. This makes the opt-in
  capability gate **sound for compound effects**, so it is now extended from
  Network/Process to also cover **Crypto/Random/System** (the earlier `crypto_ops.rii`
  false-positive is resolved; differential restored 30/30). Codegen-transparent
  (typecheck-only; the lowered IR is unchanged). +6 tests (network ×3, random ×2,
  compound-grants-all-components ×1). Parser threads the components through
  `parse_effect_annotation` → `(Effect, Vec<Effect>)`.
- **Single-path file ops — precise result types**: `file_exists`→`Bool`,
  `file_delete`→`Unit`, `file_size`→`Int` (`file_list_dir` stays `Any`), atop the
  `String`-path hardening. +1 test; differential 30/30.
- **Single-path file ops hardened to `String` paths**: `file_exists`/`file_delete`/
  `file_size`/`file_list_dir` retyped `Any → Any` ⇒ `String → …`, so a `Tainted`
  untrusted path is rejected (path-traversal prevention), consistent with
  `file_read`. +1 test; differential 30/30.
- **Capability-gating scope finding** (no code change beyond Network/Process):
  extending the opt-in capability gate to `Crypto`/`Random`/`System` is *unsound*
  under the current model — a function's declared effect is a single (lossy)
  `Effect`, so a compound `kesan (Kripto, Tulis, Rawak)` only auto-grants one
  component, producing false positives on legitimate compound-effect functions
  (caught via the differential `both_ran` count dropping 30→29 on `crypto_ops.rii`).
  The gate stays Network/Process; sound multi-capability gating needs an effect-set
  `granted` representation (documented in code + the Gate C network row).
- **Network/Process capability gating (hybrid POLA)**: once a program opts into
  the capability discipline (some `grant` in scope), a `Network`/`NetworkSecure`/
  `Process` operation now requires the matching capability granted, else
  `CapabilityViolation`. Mirrors the opt-in `T_Require` rule (no grants anywhere
  ⇒ permissive, so existing programs are unaffected — 0 breakage, differential
  30/30). A function declaring `kesan Rangkaian`/`kesan Proses` auto-grants it in
  its body, so effect-honest code keeps working. +3 tests (ungated network op
  rejected; granted accepted; no-capability permissive). File I/O stays at
  effect+taint (not capability-gated) per the hybrid policy.
- **Numeric tower, first slice — typed integer-literal suffixes**: the lexer now
  recognizes decimal width suffixes (`u8/u16/u32/u64/i8/i16/i32/i64`) and
  **range-validates them at lex time** — `256u8`, `300i8`, `4294967296u32` are
  compile errors (`InvalidNumericLiteral`). A non-width trailing run (`255abc`) is
  left for normal tokenization, so no existing program changes. +5 lexer tests.
  (Distinct sized-integer *types* in `Ty`, width-aware arithmetic, codegen, and a
  Coq numeric model are the next slices — the full tower is multi-session.)
- **File-content reads are taint-typed**: `file_read`/`file_read_lines`
  (`fail_baca`/`fail_baca_baris`) retyped `Any → Any` ⇒ `String → Tainted<String,
  FileSystem>`. An untrusted (`Tainted`) path is now rejected at the I/O boundary
  (path-traversal prevention, Coq `path_traversal_impossible`), and file contents
  are `Tainted<_, FileSystem>` — an untrusted source that must be sanitized before
  reaching any sink (Coq taint safety). +3 tests (tainted-path rejected; literal
  path ⇒ tainted contents; contents rejected at a SQL sink unsanitized). Full
  suite 2646 → 2649; differential unchanged 30/30.

### Changed
- **Active gate marker advanced B → C** (Part 11). Gate B (Compiler Enforcement
  Parity) exit criteria verified by command: 0 `todo!()`/`unimplemented!()` outside
  tests; every compiler-enforceable Coq security property has pos+neg Rust tests;
  `cargo test --all` (03_PROTO) = 2646/0; clippy 0; WASM/C differential 30/30; Coq
  309 `.vo`, 0 Admitted/0 Axiom (`verify --full`). REQ-27 depth (multiparty surface
  wiring, DMP/GoFetch CT) tracked as non-blocking follow-ups. Compiler-maturity
  pillar L2 → L3.

### Added
- **Crypto-audit-prep KAT manifest** (`05_TOOLING/crates/riina-core/tests/kat_audit.rs`),
  the first Gate C / REQ-28 deliverable: one reproducible auditor-facing entry point
  (`cargo test -p riina-core --test kat_audit`) that re-verifies each primitive against
  an *independently transcribed* canonical vector from its governing standard, plus
  AEAD/signature tamper-rejection — SHA-256/512 (FIPS 180-4), HMAC-SHA256 (RFC 4231),
  HKDF-SHA256 (RFC 5869), AES-256 (FIPS 197), AES-256-GCM (GCM spec TC13 + tag tamper),
  X25519 (RFC 7748), Ed25519 (sign/verify + forgery rejection). All 8 green;
  05_TOOLING suite 248 → 256. This is audit *preparation*, not a replacement for the
  external audit (REQ-28), which stays a P0 external-firm dependency.

## [Unreleased] — 2026-06-02 — Gate B: WASM/C parity closed, session pipeline, constant-time

Compiler enforcement-parity work (REQ-27, Gate B). All verified by command.

### Added
- **Session-type parse→project→check pipeline** (`riina-typechecker`): choreography
  protocols now parse **role-relative** to the first role, so the stored
  `SessionType` is that role's local view (`A->B:T` ⇒ `Send T` when A is the
  first role, `Recv T` when B is). New `project_choreography` (role ⇒ local
  session type; role[0] ⇒ protocol, role[1] ⇒ `session_dual`; >2 roles ⇒
  unsupported), `session_well_formed` (closed recursion), and
  `choreography_compatible` (distinct roles + closed protocol + 2-party
  projection duality ⇒ deadlock-free, per Coq `ST_020` / `CT_117`), wired into
  `type_check_full` — ill-formed choreographies are now rejected.
- **Per-program constant-time codegen pass** (`riina-codegen/src/ct_verify.rs`):
  `verify_constant_time` re-checks the lowered IR for a `CondBranch` on a
  `ConstantTime` condition or a `Div`/`Mod` on a `ConstantTime` operand
  (propagated through data-flow to a fixpoint), wired into
  `riina_codegen::compile` (new `Error::ConstantTimeViolation`).
- **CI `differential` job** (`.github/workflows/verify.yml`): installs
  `cc`+`wasmtime` so the WASM/C `corpus_differential` byte-equality test runs in
  CI instead of auto-skipping.
- **N-party multiparty session-type core** (`riina-typechecker/src/multiparty.rs`):
  role-annotated `GlobalType`/`LocalType` + `project(g, role)` + `mergeable` +
  `is_projectable`, mirroring the mechanized Coq development (`GlobalType`
  `ChoreographyTypes.v:160`, `LocalType` `:232`, `project` `:399`, `mergeableb`
  `ChoreographyProjection.v:48`). The binary `riina_types::SessionType` cannot
  carry peer roles, so >2-role projection needs this separate representation —
  this lifts the `project_choreography` >2-role `None` limitation. +9 tests incl.
  a genuine 3-party Buyer/Seller/Shipper protocol projected onto each role and
  branch-projectability accept/reject. (Per-statement channel-op impl checking
  and `koreografi`-surface wiring remain — RIINA has no session-channel surface
  ops yet.)

### Changed
- **WASM backend reaches byte-for-byte parity with C** across the dual-backend
  example corpus — `corpus_differential` is now **30/30 byte-equal**
  (`KNOWN_DIVERGENT` empty), up from 26. Fixes this session: (a) nested-if/else
  merge-`Phi` pushed from each branch region's exit block (fixes `padan`
  integer/tuple matches → `pattern_match`); (b) struct `FieldAccess` lowered to
  the real positional projection `Fst(Snd^i(base))` over the struct's product
  layout (fixes `compiler/main` → `v0.1.0`); (c) WASM string-`Add` heap concat +
  `ke_teks` string pass-through (fixes the CAHAYA UI `paparan`/`tulisan`/`butang`
  examples).
- **Constant-time typecheck rule extended**: a `ConstantTime` operand in integer
  **division/modulo** is now rejected (data-dependent latency); `Add`/`Sub`/`Mul`
  stay constant-time and keep the CT tag. The lowerer's `infer_type` propagates
  the CT tag through `BinOp` (guarded on CT operands — non-CT programs are
  byte-identical).
- **Sum-elimination payload types in lowering** (`riina-codegen/src/lower.rs`):
  `Expr::Case` now derives each branch's payload type from `infer_type(scrutinee)`,
  mirroring the typechecker's `T_Case` normalization (`Sum(l,r) ⇒ (l,r)`;
  `Option(t) ⇒ (t,Unit)`; `Unit` fallback). The `UnwrapLeft`/`UnwrapRight` IR
  values **and** the branch bindings now carry the real payload type instead of a
  hardcoded `Unit` — closing 2 of the 4 remaining feature-gated Gate B `// TODO`s
  (now **3/5** done), via the same `infer_type` idiom `Fst`/`Snd` already use.
  +2 tests; differential unchanged at 30/30 byte-equal.
- **LDAP injection enforcement-parity test** closing a Gate B audit gap: a
  command-verified cross-check of every Coq `*_impossible` theorem in
  `domains/TaintSystemCorrectness.v` against the Rust taint tests found that
  `ldap_injection_impossible` had the enforcement (`ldap_search` sink requiring
  `Sanitized<String, LdapEscape>`, `sanitize_ldap`) but **no test**. Added
  `test_ldap_{injection_prevented,safe_with_sanitization,sanitizer_mismatch}`
  (positive + negative + wrong-sanitizer), matching the SQL/XML/path surface.
  (CSRF is modeled via the `csrf_generate`/method layer, not a taint sanitizer —
  documented as a deliberate modeling difference.)
- **Effect-Gate top-level-binding-purity tests** closing a second Gate B parity
  gap found by a per-`TypeError`-variant coverage audit: `EffectViolation` has two
  enforcement sites and only the function effect-discipline one was tested. Added
  `check_program_{rejects_effectful_top_level_binding,allows_pure_top_level_binding}`
  (a module-level `biar` initialized with an effectful expression is rejected;
  pure bindings accepted) — Coq effect-soundness parity.
- **Perform-payload TODO resolved** (`riina-typechecker`): a per-`TypeError`-variant
  audit showed the long-standing "validate payload type matches effect definition?"
  TODO was a *false gap* — Coq `T_Perform` (Typing.v:168) is
  `e:T!ε ⊢ perform eff e : T!(ε⊔eff)` with no payload-vs-signature premise, and the
  Rust arm already matches it exactly. Adding a check would be a Rust rule with no
  Coq counterpart (a parity violation). Reworded to a design note + 2 `gate_b_parity`
  tests locking the rule.
- **Lexer int-suffix TODO resolved** as a documented deferral: typed integer
  suffixes (`0xFFu8`, `42i64`) need sized integer types, which RIINA lacks (single
  `Nombor`/`Ty::Int`) — they belong to the numeric tower (Gate C). Lexing a suffix
  no later stage can consume would be a stub, so the bare `// TODO: Suffix` was
  replaced with that rationale. This resolves the last of the 5 documented
  lexer/parser/codegen TODOs (now **5/5**).
- **Taint-sink diagnostics wired live**: `TaintViolation`/`SanitizerMismatch` were
  declared (with help text + error codes) but never raised — taint at a sink was a
  generic `TypeMismatch`. The App rule now routes an incompatible `Sanitized<_,
  required>` argument through `sink_argument_error` (`Tainted` ⇒ `TaintViolation`,
  wrong sanitizer ⇒ `SanitizerMismatch`). The 20 injection tests now assert these
  precise variants — a stronger parity surface for the Coq `*_impossible` theorems.

### Verified (by command, not copied)
- `03_PROTO` test suite: **2,646 pass / 0 fail** (`cargo test --all`; 2,628 + 2
  sum-unwrap payload-type tests + 3 LDAP injection-parity tests + 2 Effect-Gate
  binding-purity tests + 2 `T_Perform` parity tests + 9 multiparty
  global-type/projection tests); `cargo clippy` 0 warnings.
  WASM/C differential 30/30 byte-equal under wasmtime 45.0.0.
  Coq active build 309 `.vo`, 0 `Admitted` / 0 `Axiom` (pre-push `riinac verify
  --full`). `gate_b_parity` deepened to 18 enforcement tests (added IFC
  reference-aliasing and nested-call-site capability), plus session-projection
  and constant-time div/mod tests.

### Still open (honestly scoped)
- **Multiparty** per-statement channel-operation impl checking + `koreografi`-surface
  wiring (the global-type + projection core now exists in `multiparty.rs`, but RIINA
  has no session-channel surface ops yet, so only the projected local *type* is
  checked — there is no operation sequence to check it against).
- **DMP/GoFetch-class** microarchitectural constant-time channels (out of scope
  until the CHERI/hardware-contract era, Phase 7/9).

## [Unreleased] — 2026-06-01 — Prototype: loop control, logical-not, example corpus

### Added
- **Loop control keywords** `putus` (break) and `lanjut` (continue), parsed in
  `selagi` / `ulang` / `untuk` bodies (with an optional ignored loop label). The
  spellings match the example corpus; `keluar` / `terus` are no longer reserved
  and are usable as ordinary identifiers (e.g. loop-flag variables).
- **`baca_garisan`** (read-line) builtin, typed as a `Teks` thunk.
- `03_PROTO/.cargo/config.toml` sets `RUST_MIN_STACK=16 MiB` so `cargo test
  --all` is green by default. In debug builds the large interpreter
  `eval_with_env` match has a big stack frame, and the `letrec` countdown tests
  overflowed the default 2 MiB spawned-thread stack; the release `riinac`
  binary (8 MiB main thread) was never affected. No semantic change.

### Changed
- **`!` is now overloaded** as logical-not on `Bool`/`Any` (it keeps its deref
  meaning on references), matching the language reference which already
  documented `!` / `bukan` as the `not` operator.
- Documentation aligned to the implemented loop-control vocabulary
  (`04_SPECS/language/RIINA_LANGUAGE_REFERENCE_AI.md`,
  `SYNTAX_IMPROVEMENT_SPEC_v2_0_0.md`, `RIINA_MASTER_PLAN.md` Part 9,
  `07_EXAMPLES/06_ai_context/` cheatsheet + common-mistakes); corpus status
  refreshed in `07_EXAMPLES/README.md`.

### Verified (by command, not copied)
- `07_EXAMPLES/00_basics/` passes `riinac check` 20/20; full corpus 47/147
  git-tracked (51/155 on disk). `03_PROTO` test suite: 2,607 pass / 0 fail;
  `cargo clippy --all` reports 0 warnings.

## [Unreleased] — 2026-05-17 — Lean active-lane axiom restoration

### Fixed
- Lean 4 active lane: replaced 15 generator-fallback `axiom` declarations
  ("fallback: unresolved match translation") in `02_FORMAL/lean/RIINA/Domains/` and
  `Industries/IndustryFinancial.lean` with concrete `def`/`partial def` ports of the
  matching Coq sources. Affected: `netperm_eq`, `action_to_perm`, `action_target`
  (NetworkDefense), `valid_transition` (FullstackSecurity), `dual` (SessionTypes +
  X001_ConcurrencyModel), `ast_dual` (ActorCalculus), `interaction_dual`,
  `can_communicate` (ChoreographyTypes), `assignment_active` (EnterpriseERP),
  `time_010_check_timeout` (TimingSecurity), `project` (X001_ConcurrencyModel),
  `exec_txn` (SIGMA001_VerifiedStorage), `all_typed` (MobileOS/ConcurrencyFramework),
  `tx_final` (IndustryFinancial). Active-lane axiom grep returns 0; `lake build RIINA`
  still passes (commit `41b85893`).

### Tracked but not changed
- Per-file `lake env lean RIINA/Domains/<X>.lean` runs reveal pre-existing
  elaboration-time sorries (60+ in `ActorCalculus.lean` alone) caused by
  upstream transpiler-output mistypes. These are NOT literal `sorry` tokens
  (grep stays at 0), but Lean inserts them when proofs fail to elaborate.
  Default `lake build RIINA` target routes through the near-empty `Domains/All`
  shim and does not exercise individual domain files. Recorded in
  RIINA_MASTER_PLAN.md Part 2 Lean caveat for follow-up.

## [Unreleased] — 2026-05-16 — Documentation drift correction

### Fixed
- `RIINA_MASTER_PLAN.md` Part 2: corrected Coq active `.v` files (292 → 309), Lean files (155 → 325), Lean axiom count (0 → 15), Isabelle files (307 → 368), and extended-prover file counts to match `metrics.json`
- `AGENTS.md`, `llms.txt`, `README.md`: refreshed verified-state tables; previous values were a session out of date
- `VERIFICATION_MANIFEST.md`: refreshed SHA + tooling test count; clarified Coq/Lean build status as "not re-verified in ephemeral container"

### Added
- `PROOF_STATUS.md` (regenerated via `scripts/update-proof-ledger.sh`): new `Abort (active, incomplete proof attempts)` ledger surfacing 4 gaps in `domains/X001_ConcurrencyModel.v`, `V001_TerminationGuarantees.v`, `W001_VerifiedMemory.v`, `domains/mobile_os/LocationServices.v`
- `scripts/audit-docs.sh`: added drift checks for AGENTS.md + llms.txt so the next session detects rot automatically

### Removed
- 4 stub crates in `05_TOOLING/crates/`: `riina-lang-{lexer,parser,types,codegen}` (each was a 4-LOC `forbid(unsafe_code)` header duplicating the real `03_PROTO/crates/riina-{lexer,parser,types,codegen}`). Workspace + dependency entries cleaned up; only consumer (also-stub `05_TOOLING/crates/riinac`) had its deps pruned without behavioral change.

## [0.3.0] — 2026-03-19

### JALINAN Phase J1 — Session-Typed Actors
- **Actor system**: `pelakon` (actor), `lahir` (spawn), `hantar` (send), `terima` (recv) — full pipeline from parse to run to emit-c
- **Choreography types**: `koreografi` (choreography), `peranan` (role) — global multiparty session protocols
- **Content-addressed values**: `cincang` (hash) — FNV-1a hash with deterministic output
- **CRDT merge**: `gabung` (merge) — conflict-free replicated data with GCounter semantics
- **Actor runtime**: `riina-runtime` crate (16th crate) — mailbox, supervisor, session-typed channels
- **C backend**: pthread-based actor runtime — real mutex/cond mailbox for native execution
- **WASM backend**: actor instruction stubs for browser playground
- **Interpreter**: synchronous message processing — Spawn stores state, Send applies handler, Recv returns state

### Proofs & Verification
- 11,905 Coq Qed (0 Admitted, 0 axioms, 301 active files)
- 71,351 total proof artifacts across 10 provers
- New Coq domains: ActorCalculus, ActorSupervision, ChoreographyTypes, ChoreographyProjection, CRDTFoundations, CRDTComposition, MerkleDAG, ContentAddressedState, AccessibilityVerification
- 5 mechanized (Coq, Lean, Isabelle, TLA+, SMT), 2 compiled (F*, Alloy), 3 generated

### Compiler & Tooling
- 2,294 Rust tests (up from 1,282)
- 500+ compliance rules across 15 profiles
- HTTP package registry client (riina-pkg)
- Session type checker (56 tests)
- BinOp type checker uses types_compatible() for Any compatibility
- Parser: multi-line actor syntax, koreografi/pelakon/lahir/hantar/terima blocks

### Website & Documentation
- RIINA™ trademark asserted across all public documents
- Website: JALINAN section on How It Works page, actor example in playground
- Claim level explainer (mechanized/compiled/generated)
- GPG signing permanently configured for deployments

## [Unreleased]

### Added (Session 88 — 2026-03-16 — Linear Types, Multi-Prover Mechanization, WASM Backend)
- Linear type enforcement: `biar sekali` (affine), `biar paling` (relevant), `biar mesti` (linear) wired through lexer→parser→typechecker; Phase 3 gate PASSED
- WASM backend working end-to-end: .rii → WASM → wasmtime for integers, arithmetic, if/else, function calls, closures with captures, recursive functions (REQ-14 DONE)
- 19 Lean 4 domain files fixed — Lean upgraded to mechanized (4,458 theorems, 0 sorry)
- 267 SMT/Z3 files added — SMT dequarantined (generated corpus, 12,405 raw asserts). [Correction 2026-06-01: only the 1 smoke file (`SecurityLatticeVerification.smt2`) actually verifies — 25 Z3 unsat properties, not the "11,843 assertions" / "mechanized" originally stated here.]
- Isabelle 10 core theories compile — Isabelle upgraded to mechanized (9,092 lemmas, 0 sorry)
- F*, TLA+, Alloy dequarantined — Track B1 worker fixes merged
- Total proofs: 48,913 across 10 provers (4 mechanized, 3 compiled, 3 generated)
- 980 Rust tests passing, clippy clean

### Fixed (Session 88)
- `generate-metrics.sh`: `escape_json` fix for newlines in pending reasons

### Added (Session 87 — Phase 3 Compiler Enforcement Alignment)
- Declassification strict mode: `declassify(e)` now rejects non-Secret types (matches Coq T_Declassify)
- Handle effect join: `handle e with x → h` returns `eff_e ⊔ eff_h` (matches Coq T_Handle)
- Handle handler binding: handler variable `x` bound to body result type in handler scope
- Top-level binding purity enforcement: `biar x = e` at module level rejects effectful expressions
- Capability Grant/Require context tracking: `TypingContext.granted` set propagated through Grant/Require/LetRec
- Function body capability granting: declared function effects auto-granted in body scope
- Phase 3 and Phase 4 task tables updated with DONE/TODO status
- 968 Rust tests passing (up from 924), 0 failures

### Added (Session 86 — Core Deepening)
- `properties/TypingInversion.v`: 53 Qed — 22 typing inversion lemmas, value purity theorem, type/effect determinism, type constructor disjointness (12) and injectivity (6)
- `domains/TaintSystemCorrectness.v`: 47 Qed — compile-time taint tracking with typing uniqueness proving 9 injection attack categories impossible (SQL, XSS, command, path traversal, LDAP, XML, header, template, eval)
- Resolved 4 design decisions: D014 (fuel-based while loops), D019 (file-based modules), D020 (u64 core + signed library), D021 (infix operator desugaring)
- Active Coq build: 9,171 Qed across 259 files, 0 Admitted, 0 active axioms

### Added
- REQ-13: End-to-end .rii → C → executable pipeline verified
  - Fixed `riinac build` path handling for files outside working directory
  - Fixed C codegen `str_val` → `string_val.data` in `riina_binop_add` string concatenation
  - Fixed C codegen missing `_XOPEN_SOURCE` for `strptime`
  - Fixed IR lowering: `FixClosure` only emitted for genuinely recursive functions (was segfaulting non-recursive top-level functions)
  - 6 end-to-end integration tests: hello, arithmetic, conditionals, declassification, multi-function, non-trivial full pipeline
  - Non-trivial test exercises: multiple functions, arithmetic, if/else, Secret<T> classify/declassify with proof, System effect
- REQ-12: Compiler enforces information flow control (Bell-LaPadula model)
  - T_Assign: no-write-down (`Δ ⊑ sl`) prevents implicit flows through control structure
  - T_Deref: no-read-up (`sl ⊑ Δ`) prevents unauthorized reads
  - IFC-aware branching: If/Case elevate Δ in branches based on condition security level
  - New `ImplicitFlowViolation` error (S0003) with clear diagnostics
  - 7 new IFC enforcement tests (Bell-LaPadula, implicit flow prevention)
- Lean 4 active lane mechanized: 3,895 theorem/lemma declarations across 136 files, 0 sorry, 0 axioms
- AlgebraicEffects.lean: 48 axioms eliminated via first-order defunctionalization + step-indexed typing (Appel-McAllester 2001)
- Z3 security lattice verification: 25 properties verified (matching Coq Syntax.v lattice lemmas)
- Isabelle/HOL smoke session: 1 compiled theory (RIINA_CORE, Syntax.thy)
- Phase 2 prover closure gate passed for scoped provers (Lean, F*, TLA+, Alloy, Z3)

### Fixed
- Coq 8.20.1 compatibility: migrated from Rocq 9.1, fixed all import paths (`Stdlib.*` → `Coq.*`), fixed API changes (`filter_length` → `filter_length_le`), fixed recursive definitions, updated proofs for new semantics
- Eliminated all 7 previously-tracked Admitted proofs (DELTA001, Platform/WASM/Mobile stubs, ValRelStepLimit)
- Eliminated remaining active proof assumptions; active Coq build is now `Axioms=0`, `Admitted=0`, explicit assumptions `=0`
- Active Coq build now at 12,386 Qed proofs

### Added (Phase 7)
- Phase 7: Platform Universality — modular backend trait architecture (`Backend` trait, `Target` enum)
- WebAssembly backend (`--target=wasm32`) with direct IR-to-WASM binary emission
- Platform-conditional standard library (`platform.rs`) for cross-platform compilation
- Mobile backend scaffolding: Android JNI bridge generation, iOS Swift bridge generation
- `--target` flag for `riinac build` and `riinac emit` commands
- `riina-wasm` crate: in-browser compiler via WASM (cdylib with `extern "C"` exports)
- WASM Playground page on website (split-pane editor, 5 examples, Web Worker compilation)
- 4 backend verification Coq proofs: WASM correctness, JNI/Swift bridge, platform stdlib, backend trait (63 Qed)
- Phase 7 complete (all M7.1–M7.6 milestones done)
- WASM backend production: bump allocator, string constants, pair/sum types, closures (table + call_indirect), refs, builtin imports
- WASM bug fixes: Mod (I32RemS), And/Or (I32And/I32Or), Call (function index resolution)
- Android JNI production: full C implementation (JNI_OnLoad, type marshaling, callback routing, permissions from effects)
- iOS Swift production: extended type conversion, C bridge routing, Info.plist generation, SPM Package.swift
- Playground build pipeline: build-wasm.sh, Vite WASM integration, deploy pipeline
- Backend composition Coq proofs: NI preservation through compiled backends (BackendComposition.v, 11 Qed)
- Extended WASM verification (+23 Qed: strings, closures, pairs, allocator, completeness)
- Extended mobile bridge verification (+17 Qed: JNI string roundtrip, Swift type safety, callback safety)

## [0.2.0] - 2026-02-01

### Added
- Compliance system user guide (`docs/enterprise/COMPLIANCE_GUIDE.md`)
- 15 industry compliance profiles with CLI integration (`--compliance`, `--report`, `--report-json`)
- Audit report generation (text + JSON formats with SHA-256 integrity)
- `riina-compliance` crate: PCI-DSS (3 rules), PDPA (2 rules), BNM RMiT (1 rule)

### Changed
- Version bump to 0.2.0 across all manifests

### Fixed
- CERTIFICATION.md: corrected axiom count (5 → 4) and file count (244 → 245)

## [0.1.0] - 2026-02-01

### Added
- RIINA compiler (`riinac`) with Bahasa Melayu syntax
- Lexer, parser, type checker, and C code generation
- Effect system with `kesan` (effect) and `bersih` (pure) annotations
- Security types: `Rahsia<T>` (secret) with `dedah` (declassify)
- Standard library: 88 builtins across 9 modules
- Developer tools: `riina-fmt`, `riina-lsp`, `riina-doc`
- VS Code extension (`riina-vscode`)
- Package manager (`riina-pkg`)
- 112 example `.rii` files across 9 categories
- Formal verification: 4,890 Qed proofs in Coq active build (0 admits, 4 justified axioms)
- Compliance system: 15 industry profiles with audit report generation
- C FFI support via `luaran "C" { ... }`
- REPL with `:jenis` (type) and `:kesan` (effect) commands
- Nix flake, Dockerfile, and install script
- Website with documentation

### Security
- Non-interference proven via logical relations in Coq
- Type safety (progress + preservation) formally verified
- Effect system soundness proven
- Zero third-party runtime dependencies

[Unreleased]: https://github.com/ib823/riina/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/ib823/riina/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/ib823/riina/releases/tag/v0.1.0
