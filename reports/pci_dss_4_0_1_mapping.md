# PCI-DSS 4.0.1 mapping note (REQ-46)

**Purpose.** REQ-46's DONE-when requires a written note recording which PCI-DSS 4.0.1
future-dated controls map to RIINA's existing `PciDss` rules. This is that note. It is a
**mapping of the compiler-checkable slice**, not an attestation: most PCI-DSS requirements
are procedural (network segmentation, physical access, personnel, quarterly scans) and lie
entirely outside a language/type system.

**Version.** RIINA's `PciDss` profile (56 rules) already uses **4.0 requirement numbering**
(e.g. `PCI-DSS-4.2.1` = TLS-in-transit, the 4.0 renumber of the old 3.2.1 §4.1). 4.0.1
(released June 2024) is an **errata/clarification** release of 4.0: it changes no requirement
numbers and adds no new requirements — it corrects wording and formatting. So the profile's
ids are already 4.0.1-current; nothing needs renumbering.

## The 4.0 future-dated controls (mandatory since 31 March 2025)

4.0 introduced ~51 requirements that were "best practice" until **31 March 2025**, when they
became mandatory. Of those, the ones with a **compiler-checkable** surface, and RIINA's
mapping:

| 4.0.1 future-dated control | Intent | RIINA rule(s) | Coverage |
|---|---|---|---|
| **6.4.3** Payment-page scripts managed/integrity-checked | Script integrity | `PCI-DSS-6.5.*` (injection/XSS family) partially; script-inventory is procedural | Partial |
| **8.3.6** Min. password length ≥12 | Credential strength | `PCI-DSS-8.3.1` (auth data Secret-typed) — checks TYPING, not length; length is runtime | Adjacent, not equivalent |
| **8.4.2 / 8.5.1** MFA for all access into the CDE | Multi-factor | `PCI-DSS-8.3.1`, `PCI-DSS-8.5.1` — presence/typing of auth, not factor count | Partial |
| **8.6.1–8.6.3** System/application accounts, no hardcoded secrets | No hardcoded creds | `hardcoded_credential_rule` family incl. `PCI-DSS-8.x` | **Direct** |
| **6.3.2** Inventory of bespoke & custom software (SBOM) | Component inventory | `sbom/riina-proto.cdx.json` + `riina-tooling.cdx.json` (deterministic CycloneDX, REQ-31) | **Direct (artifact)** |
| **12.10.x** Incident response | Detection/response | `audit_trail_rule` (`PCI-DSS-10.x`) for the logging precondition; IR plan is procedural | Precondition only |
| **A3 / 11.6.1** Change-and-tamper detection on payment pages | Tamper detection | not modelled | None (out of scope) |

## Honest scope statement

- RIINA's PCI-DSS profile checks **code-level preconditions** for a subset of requirements:
  no plaintext transport (§4.2.1), no weak crypto (§6.5.3), no hardcoded credentials, secret
  typing of cardholder/auth data (§3.x, §8.3.1), injection/XSS rejection (§6.5.x), audit-trail
  presence (§10.x), least-privilege grants (§7.x, §11.3).
- It does **not** and cannot check: network segmentation (§1), physical security (§9),
  personnel/policy (§12 beyond logging preconditions), ASV scans (§11.3.1 external), or the
  MFA *factor count* and password *length* that §8 future-dated controls specify at runtime.
- Passing `riinac … --profiles pci-dss` is therefore evidence toward, never a substitute for,
  a QSA assessment.

## Action taken / not taken

- **No renumbering needed**: 4.0.1 keeps 4.0 ids, which the profile already uses.
- **SBOM (§6.3.2) is satisfied by an artifact** already in the repo, now also feeding the CRA
  VEX (REQ-45).
- The `Dora` profile (REQ-46) deliberately does **not** duplicate PCI-DSS card-data controls —
  DORA governs operational resilience of the financial entity, PCI-DSS governs card data; they
  compose, they do not overlap. A program handling card data in an EU financial entity would
  run `--profiles pci-dss,dora`.

*Recorded 2026-08-05. Confirm the 4.0.1 errata scope and the 31 March 2025 mandatory date with
a QSA before relying on this for an assessment.*
