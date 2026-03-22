# Remediation Package: L_FFI_AND_ATTACK_RESEARCH

- Domain ID: `L_FFI_AND_ATTACK_RESEARCH`
- Current: `R2` | Target: `R3`
- Hostile review: accept with reductions at R2

## Why R2
Real FFI implementation (extern blocks, raw pointers, C/WASM/JNI/Swift codegen, 153 tests). Coq layer vacuous (79% reflexivity in RustFFISecurity.v). Implementation without formal backing = R2.

## To R3
1. Rewrite RustFFISecurity.v with nontrivial FFI safety properties
2. Add FFI boundary attack tests (memory corruption across FFI, type confusion)
3. Wire .rii FFI examples into integration tests
