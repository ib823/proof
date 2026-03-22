# N_TOOLING_IDE Remediation Plan v1.0.0

## Purpose
Elevate the Tooling and IDE domain from R1 to R2+ by replacing vacuous Coq proofs with nontrivial properties about LSP and formatter correctness.

## Current Truth
- Rating: R1 (specified)
- Coq: 21 Qed, all vacuous (N_001_01 proves f(x)=f(x))
- Implementation: riina-lsp (28 tests), riina-fmt (6 tests) — real but uncounted for R2
- Hostile review: Gemini rejected R2, citing R2 requires nontrivial formal model

## Required Changes
1. Replace identity/reflexivity proofs with properties about tool composition, LSP completeness correctness, formatter round-trip preservation
2. Add adversarial LSP tests (malformed requests, oversized payloads, invalid JSON-RPC)
3. Test formatter idempotence (format(format(x)) = format(x))
