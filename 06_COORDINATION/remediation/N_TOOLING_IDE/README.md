# Remediation Package: N_TOOLING_IDE

- Domain ID: `N_TOOLING_IDE`
- Current: `R1` | Target: `R2`
- Hostile review: reject (downgrade from R2 to R1)

## Why R1
Coq is 100% vacuous (proves f(x)=f(x)). Real implementation exists (riina-lsp 28 tests, riina-fmt 6 tests) but R2 requires nontrivial formal model.

## To R2
1. Rewrite ToolingIDE.v with nontrivial properties (LSP correctness, formatter preservation)
2. Add more LSP adversarial tests

## To R3
3. Add enforcement of tooling contracts (formatter idempotence, LSP response type safety)
4. Wire .rii examples into LSP integration tests
