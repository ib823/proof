# AJ_VERIFIED_COMPLIANCE Child-Domain Breakdown v1.0.0

This is a likely decomposition, not yet a confirmed queue expansion.

## Probable Child Domains

1. `AJ_COMPLIANCE_EFFECTS_AND_TYPES`
   - first-class bounded compliance effect/type regime
   - parser and typechecker integration
   - invalid-case rejection in the core frontend

2. `AJ_PROFILE_RULEPACKS`
   - profile-pack honesty
   - enforced vs heuristic rule separation
   - report semantics and coverage truthfulness

3. `AJ_PRIVACY_REGIMES`
   - GDPR, PDPA, CCPA-style privacy workflows
   - consent, data rights, retention, portability

4. `AJ_HEALTHCARE_AND_RECORDS`
   - HIPAA, FDA-style healthcare record handling
   - access controls, audit controls, integrity/availability

5. `AJ_PAYMENTS_AND_FINANCE_CONTROLS`
   - PCI-DSS, SOX, BNM, MAS-style payment/control workflows
   - segmentation, encryption, control evidence

6. `AJ_CONTINUOUS_MONITORING_AND_EVIDENCE`
   - continuous monitoring
   - evidence refresh
   - proof/evidence chain binding

7. `AJ_MULTI_REGULATION_COMPOSITION`
   - overlapping controls
   - conflict handling
   - profile composition boundaries

8. `AJ_COMPLIANCE_INTEGRATION`
   - canonical examples
   - CI workflows
   - public claim discipline

## Why a Split Is Likely

- the research scope bundles frontend semantics, rule packs, evidence chains, continuous monitoring, and multiple regulatory families
- the live implementation today mainly covers a broad AST lint/report layer
- a child-domain split will likely be required before the umbrella can honestly move beyond `R1`
