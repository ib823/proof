# RIINA_MOBILE_OS_MOBILE_BRIDGES R5 Target Spec v1.0.0

## Purpose

Take `RIINA_MOBILE_OS_MOBILE_BRIDGES` from the strongest current bounded slice in the umbrella to an honest `R5` child domain.

This is the first mobile/OS child domain because it has the best evidence-to-scope ratio today:
- a dedicated Coq bridge-verification file
- real JNI and Swift bridge generators
- live Android/iOS target selection in `riinac`

## Current Truth

Live source today:
- [MobileBridgeVerification.v](/workspaces/proof/02_FORMAL/coq/domains/MobileBridgeVerification.v)
- [mobile.rs](/workspaces/proof/03_PROTO/crates/riina-codegen/src/mobile.rs)
- [jni.rs](/workspaces/proof/03_PROTO/crates/riina-codegen/src/jni.rs)
- [swift_bridge.rs](/workspaces/proof/03_PROTO/crates/riina-codegen/src/swift_bridge.rs)
- [android_build.rs](/workspaces/proof/03_PROTO/crates/riina-codegen/src/android_build.rs)
- [ios_build.rs](/workspaces/proof/03_PROTO/crates/riina-codegen/src/ios_build.rs)

Current strengths:
- bridge generators are real
- Android/iOS targets are accepted by the compiler
- there is a dedicated Coq file for bridge-related correctness

Current weaknesses:
- bridge generation is not yet an audited end-to-end workflow with canonical example coverage
- Coq depth is bounded and not obviously tied to explicit invalid-case rejection in the toolchain
- there is no stable external bridge artifact contract or replay procedure
- public wording is still umbrella-heavy instead of bridge-specific

## Scope

### In scope

- bounded RIINA-to-JNI bridge generation
- bounded RIINA-to-Swift bridge generation
- marshaling correctness for the supported surface
- capability-gated crossing into the mobile bridge layer
- deterministic artifact generation for the covered scope
- rejection of unsupported or malformed covered cases

### Out of scope for the first `R5`

- a full mobile operating system
- TERAS kernel/runtime execution
- CHERI or hardware capability claims
- UI framework or graphics guarantees
- arbitrary mobile runtime behavior outside the covered bridge surface

## Required Workflows

| Workflow | Valid or forbidden | Must exist by `R5` |
|----------|--------------------|--------------------|
| Generate Android bridge for a covered RIINA program | Valid | Yes |
| Generate iOS bridge for a covered RIINA program | Valid | Yes |
| Deterministically regenerate the same bridge artifact | Valid | Yes |
| Reject unsupported bridged type/effect combination | Forbidden | Yes |
| Reject malformed boundary crossing in the covered scope | Forbidden | Yes |
| Replay artifact verification from saved output | Valid | Yes |

## Required Properties

1. Covered bridge generation is deterministic.
2. Supported marshaled values preserve the modeled structure.
3. Unsupported bridge cases fail closed.
4. Capability gates on the covered bridge boundary are enforced.
5. Saved bridge artifacts are replayable and auditable for the covered scope.

## Required Formal Artifacts

Minimum Coq targets:
- explicit bridge payload and boundary model
- marshaling preservation theorems for supported values
- unsupported-case invalidity theorems
- determinism theorem for the covered bridge-generation surface
- soundness statement linking generated bridge artifacts to the formal bridge model

Minimum standard:
- hostile review must not be able to dismiss the file as mostly config-validity or boolean unpacking

## Required Implementation Artifacts

1. Define the supported bridge surface explicitly.
2. Add canonical `.rii` examples for Android and iOS bridge generation.
3. Emit stable artifacts that can be inspected and replayed.
4. Reject unsupported covered cases at compile time where possible.
5. Add bridge-specific logs or receipts sufficient for third-party inspection.

## Required Tests

Positive:
- generate Android bridge for a covered program
- generate iOS bridge for a covered program
- regenerate identical artifacts for identical inputs

Negative:
- reject unsupported type
- reject unsupported effect
- reject malformed boundary declaration

Adversarial:
- mutate generated artifact and detect mismatch if artifact verification is in scope
- regression tests for previously accepted invalid bridge cases

## Required Observability

`RIINA_MOBILE_OS_MOBILE_BRIDGES` cannot be `R5` unless a third party can:
- run the bridge-generation command
- inspect the generated artifact
- verify what covered surface was assumed
- reproduce success and rejection cases

## Exit Criteria

`RIINA_MOBILE_OS_MOBILE_BRIDGES` is ready for re-audit when:
- scope is explicit
- the Coq model is nontrivial
- Android and iOS bridge workflows execute by command
- invalid covered cases are rejected
- artifact inspection and replay are reproducible
- public wording is exact
- regression checks exist

## Unsafe Shortcut List

Do not count the child domain as `R5` if:
- bridge generation still lacks canonical executable examples
- unsupported cases are undocumented or silently accepted
- the Coq file still proves only bounded config records
- wording implies a full mobile operating system rather than bridge correctness
