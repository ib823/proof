# RIINA_MOBILE_OS Child-Domain Breakdown v1.0.0

This is a likely decomposition, not yet a confirmed queue expansion.

## Probable Child Domains

1. `RIINA_MOBILE_OS_MOBILE_BRIDGES`
   - JNI/Swift bridge generation
   - marshaling correctness
   - capability-gated boundary crossing

2. `RIINA_MOBILE_OS_OS_PRIMITIVES`
   - capability objects
   - IPC channels
   - memory/page-table primitives
   - syscall model

3. `RIINA_MOBILE_OS_ANDROID_TARGET`
   - Android target selection
   - bridge artifact generation
   - bounded executable Android workflows

4. `RIINA_MOBILE_OS_IOS_TARGET`
   - iOS target selection
   - Swift bridge generation
   - bounded executable iOS workflows

5. `RIINA_MOBILE_OS_TERAS_KERNEL_CORE`
   - TERAS kernel and security theorems
   - capability confinement
   - explicit kernel-scope boundaries

6. `RIINA_MOBILE_OS_CAPABILITY_AND_IPC`
   - end-to-end language integration of OS capabilities and IPC
   - rejection and auditability for invalid use

7. `RIINA_MOBILE_OS_INTEGRATION`
   - canonical examples
   - language/runtime/formal alignment
   - public claim discipline

## Why a Split Is Likely

- the current umbrella bundles bridge correctness, OS primitives, mobile targets, and a future TERAS operating system into one claim
- the live repo only has bounded slices of those concerns
- the bridge lane is the strongest evidence-to-scope candidate today
- a child-domain split is required before the umbrella can honestly move beyond `R2`
