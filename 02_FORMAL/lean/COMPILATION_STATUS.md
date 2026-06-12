# Lean 4 Compilation Status Report

**Generated:** 2026-06-01 (re-measured under Lean 4.16.0, the pinned toolchain)
**Method:** `lake env lean <file>` run on every `.lean` file; a file counts as
"elaborating" only if it produces **0** `error:` diagnostics.

## Executive Summary — measured, not estimated

- **Total Lean files:** 326
- **Files that elaborate cleanly (0 errors):** **7** (2.1%)
- **Files with elaboration errors:** **319** (97.9%)
- **Theorem/lemma declarations total:** ~12,576 (the headline count)
- **Theorem/lemma declarations in cleanly-elaborating files:** **215** (~1.7%)
- **Files still carrying the placeholder tactic `simp_all [Bool.and_eq_true]`:** 304
- **Literal `sorry` tokens:** 2 (both in `RIINA/Properties/_wip/NonInterference_v2_LogicalRelation.lean`)

**Claim level: `generated`, NOT mechanized.** Lean is a machine-generated port
of the Coq sources. The vast majority of declarations do not elaborate; the
`12,576` figure is a count of theorem *declarations*, not verified proofs.

## What `lake build RIINA` actually builds

`RIINA.lean` (the `@[default_target]`) imports **only** `RIINA.Domains.All`,
which is a **0-theorem compatibility shim** (`negb`, `andb`, list helpers).
So `lake build RIINA` succeeds but verifies **zero theorems**. Everything else
(`Foundations`, `TypeSystem`, `Effects`, `Properties`, `Termination`, the bulk
of `Domains`, `Industries`, `Compliance`) is commented out of the default target.

## The 7 files that elaborate (0 errors)

| File | Theorems | Notes |
|------|----------|-------|
| `RIINA/Domains/All.lean` | 0 | compatibility shim (the default build target) |
| `RIINA/Domains/HermeticBuild.lean` | 28 | self-contained; real tactics (no placeholder) |
| `RIINA/Domains/RuntimeGuardian.lean` | 35 | self-contained |
| `RIINA/Domains/VerifiedMemory.lean` | 40 | self-contained |
| `RIINA/Domains/VerifiedPerformance.lean` | 34 | self-contained |
| `RIINA/Domains/VerifiedStdlib.lean` | 40 | self-contained |
| `RIINA/Domains/VerifiedStorage.lean` | 38 | self-contained |

These 6 non-shim files do **not** depend on the broken core and contain 215
genuinely-elaborating declarations. They are not wired into `lake build RIINA`.

## What does NOT elaborate (representative measured error counts)

| File | `error:` count | Category |
|------|----------------|----------|
| `RIINA/Foundations/Syntax.lean` | 187 | core — parse/elaboration errors (`unknown identifier 'ident'`, `unexpected token ':='`) |
| `RIINA/Foundations/Semantics.lean` | 110 | core |
| `RIINA/TypeSystem/Typing.lean` | 1 | core — does not fully elaborate |
| `RIINA/Domains/AlgebraicEffects.lean` | 96 | cited elsewhere as the "mechanized strict lane" — it is not |
| `RIINA/Effects/EffectAlgebra.lean` | 1 | placeholder proofs |
| `RIINA/Domains/MemorySafety.lean` | 300 | placeholder proofs |
| `RIINA/Domains/ActorCalculus.lean` | 561 (+37 sorry-warnings) | placeholder proofs |

Note: an earlier (2026-02-12) version of this report claimed 3 hand-corrected
core files compiled (`Foundations/Syntax`, `Foundations/Semantics`,
`TypeSystem/Typing`). Under the current corpus + Lean 4.16.0 those three no
longer elaborate (187 / 110 / 1 errors respectively). The corpus drifted; this
re-measurement supersedes the earlier numbers.

## Honest path forward

Bringing Lean to a real "mechanized" claim is a Path-D1-scale effort
(hand-correcting ~12,500 declarations from the Coq originals — hundreds of
hours). Until then the lane is correctly labelled `generated` in
`website/public/metrics.json` (`claimLevels.lean = "generated"`), and the
headline "12,576 theorems" must always be read as *declarations*, with the
measured "215 elaborate across 7 files" as the real compiled figure.

## Reproduce

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd 02_FORMAL/lean
lake build RIINA                       # succeeds — builds only the 0-theorem shim
lake env lean RIINA/Domains/MemorySafety.lean 2>&1 | grep -c error:   # ~300
```
