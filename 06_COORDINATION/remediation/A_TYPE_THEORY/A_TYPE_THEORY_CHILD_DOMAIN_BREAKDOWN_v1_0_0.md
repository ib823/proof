# A_TYPE_THEORY Child-Domain Breakdown v1.0.0

This is a likely decomposition, not yet a confirmed queue expansion.

## Probable Child Domains

1. `A_TYPE_THEORY_CORE`
   - core syntax
   - typing
   - progress/preservation/type safety
   - live parser/typechecker enforcement

2. `A_TYPE_THEORY_LINEARITY_OWNERSHIP`
   - linearity qualifiers
   - ownership and usage tracking
   - bounded live enforcement

3. `A_TYPE_THEORY_SESSION_CAPABILITIES`
   - session types
   - capability kinds
   - capability-gated checking

4. `A_DEPENDENT_TYPES`
   - Π/Σ style formal modeling
   - live implementation gap tracking

5. `A_REFINEMENT_TYPES`
   - refinement typing
   - solver integration boundaries

6. `A_GRADUAL_AND_BOUNDARY_TYPES`
   - gradual typing
   - FFI/boundary checking

7. `A_REGION_AND_RESOURCE_TYPES`
   - region typing
   - memory/resource boundary semantics

8. `A_HIGHER_KIND_AND_TYPELEVEL`
   - higher-kinded types
   - type-level computation

9. `A_TYPE_THEORY_INTEGRATION`
   - canonical examples
   - formal/live alignment
   - public claim discipline

## Why a Split Is Likely

- the umbrella covers twenty research branches with different maturity levels
- the live compiler only enforces a bounded core subset
- the reviewer explicitly required re-scoping to `A_TYPE_THEORY_CORE`
- the example corpus and non-Coq lanes are not strong enough to sustain a single umbrella maturity claim
