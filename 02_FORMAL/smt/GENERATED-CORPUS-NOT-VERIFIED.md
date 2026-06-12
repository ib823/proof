# GENERATED CORPUS — NOT INDEPENDENTLY VERIFIED

**This directory's SMT / Z3 corpus is machine-generated; it is not an independent
verification of RIINA's security properties.**

The bulk of these files were produced by `scripts/generate-full-stack.py` /
`scripts/generate-multiprover.py`, which fan the mechanized **Coq** development
out into SMT / Z3 syntax. They inflate file and lemma/assertion counts but are
stubbed (`admit`/placeholder/tautology) or are small smoke artifacts — they are
**NOT** additional independent proofs.

- **The only fully mechanized prover lane is Coq** (`02_FORMAL/coq/`,
  machine-checked, 0 Admitted / 0 Axiom in the active build).
- This lane's honest claim level is **`generated`** — see
  `website/public/metrics.json` (`claimLevels`), the single source of truth.
- Any manually-maintained subset under `RIINA/Active/` is a *smoke* artifact,
  not a full verification.

Do not cite these files as independent verification. Earning that status is
RIINA_MASTER_PLAN.md **Gate D, Path D1** (industrialize the smoke artifacts).
