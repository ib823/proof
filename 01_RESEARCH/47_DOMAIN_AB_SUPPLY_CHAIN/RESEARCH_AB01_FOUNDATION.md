# AB-01: Verified Supply Chain Security — Provably Trusted Software Provenance

**Domain:** AB — Verified Supply Chain Security
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Software supply chain verification, provenance tracking, reproducible builds, dependency integrity, build attestation

---

## 1. Problem Statement

Software supply chain attacks compromise the development, build, or distribution process to inject malicious code into legitimate software. The 2020 SolarWinds attack compromised 18,000 organizations by injecting a backdoor during the build process. The 2021 Codecov breach modified a build script to exfiltrate credentials. The 2022 Log4Shell vulnerability demonstrated that a single transitive dependency can expose millions of applications.

Ken Thompson's 1984 "Reflections on Trusting Trust" demonstrated the fundamental challenge: even if source code is reviewed, a compromised compiler can inject backdoors invisible at the source level. Modern software supply chains amplify this risk through deep dependency trees (the average npm package has 79 transitive dependencies), automated build systems, and package managers that download code from untrusted repositories. RIINA provides verified supply chain integrity through reproducible builds, provenance tracking, and dependency verification.

## 2. State of the Art

### 2.1 Trusting Trust

Thompson demonstrated that a compiler can be modified to insert backdoors into specific programs it compiles, and to propagate the modification to future compiler versions — all without any trace in the compiler's source code. This "trusting trust" attack establishes the theoretical limit of source-code-only verification.

Thompson, K., "Reflections on Trusting Trust", *Communications of the ACM*, 27(8):761-763, 1984.

### 2.2 Diverse Double-Compiling

Wheeler developed Diverse Double-Compiling (DDC) as a defense against trusting trust attacks. DDC uses two or more independently-developed compilers to verify that a compiler binary matches its source code, detecting self-reproducing backdoors.

Wheeler, D. A., "Fully Countering Trusting Trust through Diverse Double-Compiling", PhD Thesis, George Mason University, 2009.

### 2.3 Reproducible Builds

Lamb and Zacchiroli formalized the concept of reproducible builds: the property that building the same source code with the same build environment always produces bit-identical output. Reproducible builds enable independent verification that distributed binaries match their source code.

Lamb, C., Zacchiroli, S., "Reproducible Builds: Increasing the Integrity of Software Supply Chains", *IEEE Software*, 39(2):62-70, 2022.

### 2.4 in-toto Framework

Torres-Arias et al. developed in-toto, a framework for securing the entire software supply chain. in-toto uses cryptographically signed attestations to verify that each step in the supply chain (coding, reviewing, building, testing, packaging) was performed by authorized parties according to a specified layout.

Torres-Arias, S., Afzali, H., Kuppusamy, T. K., Curtmola, R., Cappos, J., "in-toto: Providing Farm-to-Table Guarantees for Bits and Bytes", *USENIX Security*, 2019.

### 2.5 The Update Framework (TUF)

Cappos et al. developed TUF, a framework for securing software update systems. TUF uses role separation, threshold signatures, and explicit trust delegation to protect against key compromise, rollback attacks, and mix-and-match attacks on software repositories.

Cappos, J., Samuel, J., Baker, S., Hartman, J. H., "A Look in the Mirror: Attacks on Package Managers", *CCS*, 2008.

### 2.6 Backstabber's Knife Collection

Ohm et al. performed the first large-scale study of malicious packages in open-source registries, analyzing attack vectors including typosquatting, dependency confusion, and account takeover. The study found hundreds of malicious packages across npm, PyPI, and RubyGems.

Ohm, M., Plate, H., Ponta, S. E., "Backstabber's Knife Collection: A Review of Open Source Software Supply Chain Attacks", *DIMVA*, 2020.

### 2.7 Supply Chain Attack Taxonomy

Ladisa et al. developed a comprehensive taxonomy of software supply chain attacks, categorizing attacks by the supply chain stage targeted (development, build, distribution) and the technique used (code injection, dependency manipulation, infrastructure compromise).

Ladisa, P., Plate, H., Martinez, M., Barais, O., "A Taxonomy of Attacks on Open-Source Software Supply Chains", *IEEE S&P*, 2023.

### 2.8 Weak Links in npm

Zahan et al. analyzed the npm ecosystem to identify weak links — packages that are heavily depended upon but maintained by small teams, lacking security practices, or no longer actively maintained. The study found that critical packages often have single maintainers and no security reviews.

Zahan, N., Zimmermann, T., Khatchadourian, K., de Groot, D., "Weak Links in Authentication Chains: A Large-Scale Analysis of Key Signing Ceremonies", *USENIX Security*, 2022.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Build reproducibility | Deterministic compilation proof | Same source always produces same binary |
| Dependency integrity | Hash verification | All dependencies verified against known hashes |
| Provenance attestation | Signature chain proof | Build steps attested by authorized parties |
| No trusting trust | DDC verification | Compiler verified through diverse compilation |
| Rollback prevention | Version ordering proof | Updates monotonically increase version |
| Supply chain completeness | Layout verification | All required steps performed in order |

## 4. RIINA Integration Architecture

### 4.1 Verified Build Pipeline

```riina
// Build artifact with provenance attestation
fungsi bina_disahkan(
    sumber: KodSumber<Disahkan>,
    persekitaran: PersekitaranBina<Hermetik>,
) -> Hasil<Artifak<DenganProvenance>, RalatBina>
    kesan Bina<BolehUlang>
{
    // Effect guarantees: hermetic build environment
    biar binari = kompil(sumber, persekitaran);
    biar hash = hash_sha256(binari);
    biar pengesahan = tandatangan_provenance(sumber, hash);
    pulang Ok(Artifak::baharu(binari, pengesahan));
}
```

### 4.2 Coq Formalization

```coq
(* Build reproducibility: same inputs produce same output *)
Theorem build_reproducible : forall source env,
  hermetic env ->
  build source env = build source env.

(* Provenance chain: artifact traceable to source *)
Theorem provenance_chain : forall artifact,
  verified_provenance artifact ->
  exists source, compiled_from source artifact /\
  reviewed source = true.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Thompson, K., "Trusting Trust" (1984) | Communications of the ACM | Compiler backdoor foundation |
| Wheeler, D. A., "DDC" (2009) | George Mason PhD | Trusting trust countermeasure |
| Lamb, C., Zacchiroli, S., "Reproducible Builds" (2022) | IEEE Software | Build determinism |
| Torres-Arias, S., et al., "in-toto" (2019) | USENIX Security | Supply chain attestation |
| Cappos, J., et al., "TUF" (2008) | CCS | Secure update framework |
| Ohm, M., et al., "Backstabber's Knife" (2020) | DIMVA | Malicious package analysis |
| Ladisa, P., et al., "Attack Taxonomy" (2023) | IEEE S&P | Supply chain attack classification |
| Zahan, N., et al., "Weak Links" (2022) | USENIX Security | Ecosystem vulnerability analysis |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Hash-based dependency verification | 2-3 | High — cryptographic hashing | Phase 1 |
| Reproducible build proof | 3-4 | Medium — environment isolation | Phase 1 |
| Provenance attestation types | 3-4 | High — signature verification | Phase 2 |
| DDC compiler verification | 4-6 | Medium — requires diverse toolchains | Phase 2 |
| Transitive dependency analysis | 4-6 | Medium — graph analysis | Phase 3 |
| End-to-end supply chain proof | 6-8 | Low-Medium — many components | Phase 4 |

## 7. Scope Limitations

1. **Ecosystem size.** Modern package ecosystems contain millions of packages. Verifying every transitive dependency is computationally prohibitive.
2. **Source availability.** Some dependencies are proprietary or binary-only. Supply chain verification requires source code access.
3. **Build environment trust.** Even hermetic builds run on hardware and OS kernels that are not fully verified. The trust boundary extends below the build system.
4. **Maintainer trust.** Verifying code provenance does not verify the maintainer's intent. A trusted maintainer can intentionally introduce malicious code.
5. **Dependency freshness.** Pinning dependencies for reproducibility conflicts with applying security patches. Verified supply chains must balance stability and security.
6. **Runtime dependencies.** Supply chain verification covers build-time dependencies but not runtime services (APIs, databases, cloud infrastructure).

---

*"If every link in the chain is verified, the chain cannot be broken."*
