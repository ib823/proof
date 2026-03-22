# Domain Audit Record

## 1. Identity

- Domain name: FFI and Attack Research
- Domain identifier: `L_FFI_AND_ATTACK_RESEARCH`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq:
  - `RustFFISecurity.v`: `34` Qed, `0` Admitted, **79% reflexivity — likely boolean stubs**
  - `FFIAttackResearch.v`: `20` Qed, `0` Admitted, **50% reflexivity — mixed**
- Implementation: extern block parsing (parser line 211), raw pointer types (parser line 1014), FFI C type support, WASM encode, JNI bridge, Swift bridge, Android build — **153 codegen tests**
- Research: `01_RESEARCH/12_DOMAIN_L_FFI_AND_ATTACK_RESEARCH/`

## 2. Vacuity Assessment

RustFFISecurity.v at 79% reflexivity is likely the boolean-stub pattern. FFIAttackResearch.v at 50% is borderline — may contain some real proofs mixed with stubs. Given the pattern seen in D_HARDWARE, G_CRYPTO, I_ERROR, the Coq layer is probably vacuous for the security properties but the implementation is substantial.

**Conservative assessment: Coq layer is probably vacuous (pending hostile review confirmation). Implementation layer is real.**

## 3. Implementation Evidence

- `riina-parser`: `parse_extern_block()` (line 299), raw pointer types `*T = RawPtr(T)` (line 1014), FFI C types (line 1146)
- `riina-codegen/emit.rs`: C code generation (FFI target)
- `riina-codegen/wasm_encode.rs`: WASM binary encoding
- `riina-codegen/jni.rs`: JNI bridge generation
- `riina-codegen/swift_bridge.rs`: Swift interop
- `riina-codegen/android_build.rs`: Android NDK integration
- `riina-codegen/platform.rs`: cross-platform targeting
- **153 codegen tests** covering emit, WASM, JNI, platform
- Parser tests: `test_parse_extern_block_english`, `test_parse_extern_block_multiple`, `test_parse_extern_block_single`, `test_parse_raw_ptr_type`

## 4. Gate Scores

| Gate | Pass / Partial / Fail | Evidence |
|------|-----------------------|----------|
| `G1` | Pass | One domain, research folder |
| `G2` | Partial | FFI + attack research combined — broad |
| `G3` | Partial | FFI workflows tested (extern parsing, codegen). Attack research formal-only |
| `G4` | Partial | No threat model doc |
| `G5` | Partial | Coq properties likely vacuous (79% reflexivity). Implementation properties exist in tests |
| `G6` | Fail (provisional) | RustFFISecurity.v likely boolean stubs (79% reflexivity). Pending hostile review |
| `G7` | Pass | Real extern block parsing, raw pointer types, C/WASM/JNI/Swift codegen |
| `G8` | Pass | 153 codegen tests + 4 parser FFI tests |
| `G9` | Partial | No explicit FFI boundary attack tests |
| `G10` | Pass | Coq vacuity flagged proactively |
| `G11` | Partial | Implementation evidence strong, Coq trace likely broken |
| `G12` | Pass | Command-derived |
| `G13` | Not audited | |
| `G14` | Partial | Hook-gated |

## 5. Rating

- Current rating: **R2** (provisional — Coq likely vacuous, but real FFI implementation exists)
- If hostile review confirms Coq is vacuous: R2 (implementation without formal model)
- If hostile review finds some nontrivial Coq: could be R2-R3
- Minimum to R3: nontrivial FFI safety proofs or scope-exclude Coq and strengthen test coverage

## 6. Safe Public Wording

- Safe claim: "FFI with extern block parsing, raw pointer types, and multi-target codegen (C, WASM, JNI, Swift) implemented and tested (153+ tests), with research-level attack taxonomy"
- Unsafe claim: "FFI formally verified", "FFI safety proven", "attack-resistant FFI"

## 7. Sign-Off

- Final verdict: **R2 — Formally modeled (implementation real, Coq layer provisionally vacuous)**
- Follow-up date: After nontrivial FFI safety Coq proofs or scope clarification

## 8. Hostile Review Reconciliation

- Hostile review: [L_FFI_AND_ATTACK_RESEARCH_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/L_FFI_AND_ATTACK_RESEARCH_R5_REVIEW.md)
- Hostile reviewer: Gemini CLI (v0.34.0, headings fixed)
- Hostile review verdict: **accept with reductions** — R2 confirmed. Coq 100% vacuous, implementation real.
- Final reconciled rating: **R2**
- Remediation package: [README.md](/workspaces/proof/06_COORDINATION/remediation/L_FFI_AND_ATTACK_RESEARCH/README.md)
- Domain status: **CLOSED** at R2
