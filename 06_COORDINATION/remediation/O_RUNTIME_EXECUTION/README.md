# Remediation Package: O_RUNTIME_EXECUTION

- Domain ID: `O_RUNTIME_EXECUTION`
- Current: `R2` | Target: `R3`
- Hostile review: reject (overclaimed R4 — reviewer didn't check proof bodies)

## Why R2
542 real tests (riina-runtime + riina-codegen). All 304 Coq theorems are boolean stubs (CC_001-CC_010 prove `field = true`). Real implementation without formal backing = R2.

## To R3
1. Rewrite CompilerCorrectness.v with semantic preservation theorems
2. Replace boolean-stub pattern across all 6 domain .v files
3. Add adversarial runtime tests (malformed bytecode, stack overflow, type confusion)
