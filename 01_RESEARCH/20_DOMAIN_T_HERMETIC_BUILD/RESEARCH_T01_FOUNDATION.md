# T-01: Hermetic Build & Recursive Bootstrap — Trusting Nothing But Source

**Domain:** T — Hermetic Build
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Reproducible deterministic builds, bootstrap chain verification, binary transparency

---

## 1. Problem Statement

Modern software is built using compilers, linkers, and build tools that are themselves compiled binaries. This creates a circular trust problem: to compile a Rust compiler, you need a Rust compiler, and tracing back eventually reaches an opaque binary downloaded from the internet. Ken Thompson's 1984 "Reflections on Trusting Trust" demonstrated that a compromised compiler can inject backdoors that propagate through all future compiler versions, undetectable by source code auditing.

Recent supply chain attacks — SolarWinds (2020), Codecov (2021), and the XZ Utils backdoor (2024) — demonstrate that this threat model is not theoretical. Attackers compromise build infrastructure, CI/CD pipelines, and upstream dependencies to inject malicious code into trusted software.

RIINA's zero-trust philosophy demands that no binary is trusted. The hermetic build system must trace every binary artifact back to human-auditable source code through a reproducible bootstrap chain. If any step in the chain cannot be independently verified, the entire system's integrity guarantees are void.

## 2. State of the Art

### 2.1 Diverse Double-Compilation (DDC)

David A. Wheeler developed Diverse Double-Compilation as a practical defense against Thompson's "trusting trust" attack. The technique uses two independent compilers to compile the same source code, then compares the outputs. If both compilers produce functionally equivalent binaries (or one compiler compiles the other and the result matches), the probability of both being compromised with the same backdoor is negligible. Wheeler demonstrated DDC on GCC, showing that it can detect the specific class of self-reproducing compiler trojans Thompson described.

Wheeler, D. A., "Fully Countering Trusting Trust through Diverse Double-Compiling", PhD Dissertation, George Mason University, 2009.

### 2.2 Reproducible Builds

The Reproducible Builds project (reproducible-builds.org) establishes that software builds should be deterministic: given the same source code, build environment, and build instructions, any party should produce bit-for-bit identical binaries. Achieving this requires eliminating all sources of non-determinism: timestamps, file ordering, randomized memory layout, locale differences, and absolute path embedding. The Debian project has achieved over 95% reproducibility for its ~30,000 packages, and Arch Linux, NixOS, and F-Droid have adopted similar practices.

Lamb, C., Zacchiroli, S., "Reproducible Builds: Increasing the Integrity of Software Supply Chains", *IEEE Software*, 39(2):62-70, 2022.

### 2.3 Bootstrappable Builds and GNU Mes

The Bootstrappable Builds project (bootstrappable.org) aims to create a complete bootstrap path from a minimal, human-auditable seed to a full modern toolchain. GNU Mes, developed by Jan Nieuwenhuizen, is a key component: a tiny Scheme interpreter and C compiler written in a minimal subset of itself, small enough to be audited by hand. Combined with stage0/hex0 (a ~512-byte hex loader), the chain bootstraps from bare machine code through assembler, Scheme, C, and eventually to GCC and beyond.

The live-bootstrap project demonstrates a complete, automated bootstrap from hex0 to a modern Linux system including GCC 10, Python, and other tools. Each stage is small enough to audit and produces a deterministic output.

Nieuwenhuizen, J., "GNU Mes: A Scheme Interpreter and C Compiler for the Bootstrap", *GNU Project*, 2018.

### 2.4 Ken Thompson's Reflections on Trusting Trust

Thompson's Turing Award lecture described a self-reproducing compiler backdoor: a modified C compiler that (a) inserts a backdoor into the login program when compiling it, and (b) inserts both modifications (a) and (b) into any future compiler it compiles. The attack is undetectable by source code inspection because the backdoor exists only in the compiler binary, not in its source code. This established the fundamental principle that you cannot fully trust software that you did not build from scratch.

Thompson, K., "Reflections on Trusting Trust", *Communications of the ACM*, 27(8):761-763, 1984.

### 2.5 mrustc: Alternative Rust Compiler

mrustc (Mutabah's Rust Compiler) is an alternative Rust compiler written in C++ that can compile Rust 1.54 without requiring an existing Rust compiler. This breaks the Rust bootstrap circularity: instead of needing rustc to build rustc, mrustc provides an independent path from C++ to Rust. mrustc is critical for bootstrappable builds of Rust-based projects, including RIINA.

### 2.6 Binary Transparency and Sigstore

Binary transparency applies the principles of Certificate Transparency to software artifacts. By publishing build outputs to an append-only log (a transparency log), anyone can verify that a binary was produced by an authorized build process. Google's Sigstore project provides keyless signing for software artifacts, enabling verification without managing signing keys.

Newman, Z., Meyers, J. S., Torres-Arias, S., "Sigstore: Software Signing for Everybody", *IEEE S&P*, 2022 (Workshop on Technology and Consumer Protection).

### 2.7 NixOS and Guix: Functional Package Management

NixOS and GNU Guix implement functional package management, where packages are built in isolated environments with explicitly declared inputs. This approach naturally supports reproducible builds by construction: packages are identified by hashes of their inputs (source code + dependencies + build tools), and builds are hermetic by default. Guix additionally supports bootstrappable builds via GNU Mes.

Dolstra, E., "The Purely Functional Software Deployment Model", PhD Dissertation, Utrecht University, 2006.

### 2.8 Supply Chain Security Frameworks

Recent frameworks for software supply chain security include SLSA (Supply-chain Levels for Software Artifacts), in-toto, and Sigstore. SLSA defines four levels of supply chain integrity, from basic provenance tracking to hermetic, reproducible builds. The in-toto framework, developed by Torres-Arias et al., provides a way to cryptographically verify that every step in a software supply chain was performed as intended.

Torres-Arias, S., Ammula, A., Curtmola, R., Cappos, J., "in-toto: Providing Farm-to-Table Guarantees for Bits and Bytes", *USENIX Security*, 2019.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Bootstrap chain integrity | Hash verification at each stage | Build system verifies SHA-256 of each bootstrap output |
| Build reproducibility | Deterministic build environment | Hermetic sandbox with fixed clock, no network, deterministic CSPRNG |
| Source-binary correspondence | DDC + translation validation (Domain R) | Two independent compiler paths must produce equivalent binaries |
| No binary blobs | Static analysis of repository | Build system rejects non-source artifacts |
| Supply chain provenance | Cryptographic attestation | Each build step produces signed provenance metadata |
| Compiler independence | Multi-compiler verification | RIINA binary verified equivalent whether built via bootstrap or commercial compiler |

## 4. RIINA Integration Architecture

### 4.1 Bootstrap Chain

```
Stage 0: hex0 (~512 bytes, hand-auditable x86/RISC-V hex)
Stage 1: hex1 (self-hosting hex loader)
Stage 2: M2-Planet (C subset in assembly)
Stage 3: MesCC (C99 compiler from M2-Planet)
Stage 4: TinyCC/GCC 4.7 (standard C compiler from MesCC)
Stage 5: mrustc (Rust 1.54 from C++)
Stage 6: rustc 1.54 → rustc current (Rust version chain)
Stage 7: RIINA compiler (from verified Rust)
```

### 4.2 Hermetic Build Environment

```riina
// Build configuration enforces hermeticity
bina {
    rangkaian: tiada,           // No network access
    sistem_fail: baca_sahaja,   // Read-only filesystem (except output)
    masa: "1970-01-01T00:00:00Z", // Fixed timestamp
    rawak: deterministik(benih: 0), // Deterministic CSPRNG
    pembolehubah_persekitaran: tiada, // No environment variables
}
```

### 4.3 DDC Verification

```coq
(* Diverse Double-Compilation correctness *)
Theorem ddc_sound : forall src compA compB binA binB,
  compile compA src = binA ->
  compile compB src = binB ->
  semantics_equiv binA binB ->
  (* If two independent compilers produce equivalent binaries, *)
  (* neither contains a Thompson-style backdoor *)
  no_backdoor binA /\ no_backdoor binB.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Thompson, K., "Reflections on Trusting Trust" (1984) | Communications of the ACM | Foundational trust problem |
| Wheeler, D. A., "Fully Countering Trusting Trust through DDC" (2009) | PhD, George Mason University | Diverse double-compilation defense |
| Lamb, C., Zacchiroli, S., "Reproducible Builds" (2022) | IEEE Software | Reproducible builds methodology and adoption |
| Torres-Arias, S., et al., "in-toto" (2019) | USENIX Security | Supply chain verification framework |
| Dolstra, E., "The Purely Functional Software Deployment Model" (2006) | PhD, Utrecht University | Nix: functional package management |
| Newman, Z., et al., "Sigstore" (2022) | IEEE S&P (Workshop) | Keyless software signing |
| Nieuwenhuizen, J., "GNU Mes" (2018) | GNU Project | Minimal bootstrap compiler |
| Ohm, M., Plate, H., Sykosch, A., Meier, M., "Backstabber's Knife Collection: A Review of Open Source Software Supply Chain Attacks" (2020) | DIMVA | Survey of supply chain attacks |
| Ladisa, P., Plate, H., Martinez, M., Barais, O., "A Taxonomy of Attacks on Open-Source Software Supply Chains" (2023) | IEEE S&P | Comprehensive attack taxonomy |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| hex0 seed verification | 1-2 | High — small enough for manual audit | Phase 1 |
| Bootstrap chain hash verification | 2-3 | High — straightforward cryptographic proofs | Phase 1 |
| Hermetic build sandbox | 3-4 | High — Linux namespaces/seccomp | Phase 2 |
| DDC implementation | 2-3 | High — Wheeler's methodology well-documented | Phase 2 |
| mrustc integration | 4-6 | Medium — mrustc targets Rust 1.54, version gap to current | Phase 3 |
| Reproducibility verification | 2-3 | High — bit-for-bit comparison | Phase 3 |
| Binary transparency log | 3-4 | Medium — requires infrastructure | Phase 4 |
| Full bootstrap automation | 4-6 | Medium — complex multi-stage pipeline | Phase 4 |

## 7. Scope Limitations

1. **Bootstrap chain length.** The chain from hex0 to a modern Rust compiler spans 7+ stages and thousands of source files at intermediate stages (GCC). While each stage is individually auditable, the total audit effort is substantial, and bugs in intermediate compilers could propagate.

2. **mrustc version gap.** mrustc targets Rust 1.54, while current Rust is 1.80+. Bridging this gap requires compiling every intermediate Rust version, which is time-consuming and may encounter compatibility issues with older Rust code.

3. **Reproducibility across architectures.** Bit-for-bit reproducibility is architecture-specific. A binary built on x86-64 will differ from one built on ARM. Cross-architecture reproducibility requires additional verification effort.

4. **Hardware trust.** Even a perfect bootstrap chain assumes the hardware executing the bootstrap is not compromised. Verifying hardware is out of scope for Domain T (see Domain S for hardware trust).

5. **Build time.** A full bootstrap from hex0 to RIINA compiler takes many hours. This is acceptable for release builds but impractical for development iteration. Incremental builds that skip already-verified stages are necessary for practical use.

6. **Ecosystem dependencies.** RIINA programs may depend on external libraries that are not bootstrappable. The hermetic guarantee applies only to the RIINA compiler and its standard library, not to arbitrary third-party dependencies.

---

*"From dust we come, to dust we return. In between, we verify every bit."*
