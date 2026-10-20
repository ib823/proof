# Certification and RIINA

**RIINA issues no certificate.** There is no `--certificate` flag, and no output
of `riinac` certifies a program against any standard.

Earlier versions of this page made three claims, all withdrawn on 2026-10-20:

- a "proof certificate" mapping a program to proven regulatory controls (withdrawn: the feature does not exist);
- that this certificate could stand in for manual code review (withdrawn);
- that it met Common Criteria EAL5–7, DO-178C DAL A or ISO 26262 ASIL-D requirements (withdrawn).

## What exists instead

- **A compliance report** (`riinac check --compliance <profiles> --report`):
  heuristic rules over the exact source, identified by its SHA-256. It is evidence
  toward a standard, not a conformity assessment. See
  [COMPLIANCE_GUIDE.md](COMPLIANCE_GUIDE.md).
- **Ledgers of what is proven and trusted**:
  [HEADLINE_THEOREMS.md](../../HEADLINE_THEOREMS.md) (theorems about the formal
  model of the language, with their kernel assumptions),
  [PROPERTY_LEDGER.md](../../PROPERTY_LEDGER.md) (each property's claim level) and
  [TRUSTED_BASE.md](../../TRUSTED_BASE.md) (what the guarantees rely on).
- **Reproduction**: anyone can rebuild the compiler and the Coq lane and re-run the
  check; [COMPLIANCE_PACKAGING.md](COMPLIANCE_PACKAGING.md) lists the commands.

## Why a compiler cannot certify a program

Certification is a judgement by an accredited body about a whole system: its
requirements, design, process, testing and operation. A compiler sees only source
code. The theorems RIINA proves are about its language model; the shipped compiler
is tested against that model, not proven to implement it, and no independent audit
of RIINA has been published.
