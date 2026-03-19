# AE_VERIFIED_AUDIT Child-Domain Breakdown v1.0.0

This is a likely decomposition, not yet a confirmed queue expansion.

## Probable Child Domains

1. `AE_AUDIT_EFFECTS`
   - first-class `Audit` effect
   - propagation and rejection rules

2. `AE_APPEND_ONLY_LOG_CORE`
   - runtime append-only log data structure
   - storage and mutation invariants

3. `AE_TAMPER_VERIFICATION`
   - inclusion proofs
   - consistency proofs
   - tamper/truncation detection

4. `AE_WITNESS_AND_CHECKPOINTS`
   - witness sufficiency
   - checkpoint integrity
   - timestamp / sequence validation

5. `AE_AUDIT_INTEGRATION`
   - compliance-report integration
   - example workflows
   - public claim discipline

## Why a Split Is Likely

- the research scope bundles language effects, runtime structures, cryptographic verification, and observability
- the live implementation today only covers a small subset of that surface
- a child-domain split will likely be required before the umbrella can honestly move beyond `R1`
