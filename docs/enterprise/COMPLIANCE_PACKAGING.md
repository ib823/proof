# Packaging RIINA Evidence for a Review

RIINA does not produce a certificate, and its compliance output is not a
conformity assessment. What it can give an assessor is **evidence**: a report of
heuristic checks over the exact source, plus the project's own ledgers of what is
proven, enforced and trusted. This page lists what to hand over and how a reviewer
can reproduce each part.

## 1. The program and its compliance report

```riina
fungsi simpan_rekod(laluan: Teks, rekod: Teks) -> Unit kesan SistemFail {
    fail_tulis((laluan, rekod))
}

fungsi utama() -> Unit kesan SistemFail {
    simpan_rekod("rekod.txt", "pesakit 42: temujanji")
}
```

```bash
riinac check --compliance hipaa --report-json --report-output report.json rekod.rii
```

`report.json` carries the source's SHA-256, the verdict and every rule that fired.
See [COMPLIANCE_GUIDE.md](COMPLIANCE_GUIDE.md) for the fields and what the rules
can and cannot see.

## 2. What the language guarantees, and at what level

- [PROPERTY_LEDGER.md](../../PROPERTY_LEDGER.md): every advertised property with its
  claim level. Most are *enforced by the compiler and tested*; a few are *proven
  in Coq for the language model*; none is yet proven about the shipped compiler.
- [HEADLINE_THEOREMS.md](../../HEADLINE_THEOREMS.md): the only theorems a public
  surface may cite, each with its fragment and kernel assumptions.
- [TRUSTED_BASE.md](../../TRUSTED_BASE.md): what those guarantees rely on without
  proof (the compiler itself, the C compiler, the OS and so on).

## 3. Supply chain

`sbom/` holds the CycloneDX SBOMs for both Rust workspaces, a cryptography BOM and
a VEX file.

## 4. Reproduction commands for the reviewer

```bash
cd 03_PROTO && cargo build --release && cargo test --all   # the compiler and its tests
riinac check --compliance hipaa --report rekod.rii           # same hash, same verdict
riinac verify --coq                                         # rebuild the Coq lane, attest the capstones
```

## What this evidence is not

- Not a certification against Common Criteria, DO-178C, ISO 26262, HIPAA, PCI-DSS
  or any other standard: that needs an accredited assessor and evidence about the
  whole system, not only its source.
- Not a replacement for code review.
- Not independently audited: no external audit of RIINA has been published, and
  its in-house cryptography is experimental.
