# AK_VERIFIED_PROCUREMENT Child Domain Breakdown v1.0.0

`AK_VERIFIED_PROCUREMENT` is too broad to become honest `R5` as one label. It must be split into child domains with separate audits and separate claims.

## Child Domains

| Child domain | Purpose | Why separate | Current reality | Dependency notes |
|-------------|---------|--------------|-----------------|------------------|
| `AK_PROCUREMENT_STATE_MACHINES` | Legal lifecycle states and transitions | Core procurement legality claim depends on this, and it is absent from the live toolchain | Research only | Best first live slice |
| `AK_PROCUREMENT_METHOD_SELECTION` | Choosing legal procurement methods under thresholds and exceptions | Different policy logic from lifecycle sequencing | Research only | Depends on explicit state and policy inputs |
| `AK_PROCUREMENT_STANDARDS_MAPPINGS` | Mapping UNCAC, ISO 37001, OCDS, and related standards to enforceable properties | Standards references are not the same as executable controls | Research only | Should follow a bounded live slice |
| `AK_PROCUREMENT_OCDS_INTEGRITY` | Procurement data completeness, schema integrity, and release consistency | Data integrity concerns differ from method legality | Research only | Can be built independently once schema exists |
| `AK_PROCUREMENT_ACCESS_CONTROL` | Identity, roles, separation of duties, and release permissions | Bounded Alloy model already hints at this slice | Alloy smoke model only | Strong candidate after state-machine slice |
| `AK_PROCUREMENT_PROTOCOLS` | Message/order guarantees for tender publication, bid handling, and award flow | Bounded TLA+ model already hints at this slice | TLA+ smoke model only | Strong candidate after state-machine slice |
| `AK_PROCUREMENT_INTEGRATION` | Composition of lifecycle, method, standards, data, and controls | Umbrella honesty depends on this composition | Not real yet | Last step before umbrella re-audit |

## Recommended Order

1. `AK_PROCUREMENT_STATE_MACHINES`
2. `AK_PROCUREMENT_ACCESS_CONTROL`
3. `AK_PROCUREMENT_PROTOCOLS`
4. `AK_PROCUREMENT_METHOD_SELECTION`
5. `AK_PROCUREMENT_OCDS_INTEGRITY`
6. `AK_PROCUREMENT_STANDARDS_MAPPINGS`
7. `AK_PROCUREMENT_INTEGRATION`

## Why This Order

- the strongest research-to-implementation bridge is the state-machine slice because it directly explains why the example currently fails and what the frontend needs first
- access control and protocol slices already have bounded smoke models, so they are the next best candidates
- standards mappings and OCDS integrity should not be claimed until there is a live bounded subsystem to map them onto
- umbrella integration is last because it is only honest once the claimed child domains are individually real

## What Must Not Be Bundled Again

Do not collapse these back into one public statement such as:
- "RIINA has verified procurement"
- "RIINA guarantees legal procurement flows at compile time"

unless the exact claimed child domains have individually survived hostile review.

## Safe Interim Umbrella Wording

Until child domains are re-audited and real:
- `AK_VERIFIED_PROCUREMENT` should be treated as a procurement research umbrella with bounded smoke models, not as a live compile-time procurement subsystem.
