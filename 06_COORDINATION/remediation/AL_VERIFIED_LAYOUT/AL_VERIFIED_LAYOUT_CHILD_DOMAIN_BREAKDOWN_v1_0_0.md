# AL_VERIFIED_LAYOUT Child-Domain Breakdown v1.0.0

This is a likely decomposition, not yet a confirmed queue expansion.

## Probable Child Domains

1. `AL_LAYOUT_CORE`
   - row/column placement
   - no-overlap and bounds invariants
   - deterministic placement

2. `AL_ACCESSIBILITY_CORE`
   - color contrast
   - focus order
   - text/ARIA/accessibility constraints

3. `AL_RENDER_BACKENDS`
   - terminal renderer
   - HTML renderer
   - backend target integration into `riinac`

4. `AL_UI_INTERACTION`
   - buttons and handlers
   - input events
   - canonical CAHAYA interaction flows

5. `AL_RESPONSIVE_AND_ADVANCED_LAYOUT`
   - flexbox/grid claims
   - viewport and responsive guarantees
   - advanced cross-platform layout properties

6. `AL_LAYOUT_INTEGRATION`
   - end-to-end example suite
   - compiler/runtime/formal alignment
   - public claim discipline

## Why a Split Is Likely

- the current umbrella bundles basic layout invariants, accessibility, renderer backends, interaction semantics, and advanced responsive-layout ambitions
- the live implementation is strongest in the narrow CAHAYA/core-layout slice and weakest in advanced layout and compiler integration
- a child-domain split will likely be required before the umbrella can honestly move beyond `R2`
