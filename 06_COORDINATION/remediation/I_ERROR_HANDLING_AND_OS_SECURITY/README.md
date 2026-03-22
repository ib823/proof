# Remediation Package: I_ERROR_HANDLING_AND_OS_SECURITY

## Domain
- Domain ID: `I_ERROR_HANDLING_AND_OS_SECURITY`
- Current honest rating: `R2`
- Hostile review verdict: **reject** (downgrade from R3 to R2)
- Created: 2026-03-21

## Why R2
Rust injection enforcement is real (44 tests, many negative). But `TerasSecurity.v` and `SQLInjectionPrevention.v` are boolean record stubs. `InjectionPrevention.v` uses toy `list nat` ASTs disconnected from actual compiler. `CrossLayerSecurity.v` and `VerifiedMicrokernel.v` have legitimate proofs but the overall formal layer is mixed.

## Remediation to R3

### R3-1: Rewrite or scope-exclude vacuous .v files
**Severity:** Critical
**What:** `TerasSecurity.v` and `SQLInjectionPrevention.v` are boolean stubs. Rewrite with real properties or remove from evidence count.

### R3-2: Link formal models to compiler AST
**Severity:** High
**What:** `InjectionPrevention.v` uses `list nat` toy ASTs. Link to actual riina-types or scope-exclude.

### R3-3: .rii examples into tests
**Severity:** Medium

### R3-4: Threat model document
**Severity:** Medium

## Re-audit Trigger
After vacuous files rewritten or scope-excluded.
