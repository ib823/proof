import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing
import RIINA.Domains.All
import RIINA.Properties.AhmedStyleTest
import RIINA.Properties.CanonicalForms
import RIINA.Properties.Composition
import RIINA.Properties.CumulativeMonotone
import RIINA.Properties.LexOrder
import RIINA.Properties.NonInterference_v2_Monotone
import RIINA.Properties.SecurityProperties
import RIINA.Properties.TypeMeasure
import RIINA.Properties.ValRelMonotone
import RIINA.Properties.ValRelStepLimit_PROOF
import RIINA.Properties.Declassification
-- NOT YET COMPILABLE (pre-existing errors, 9 sorry):
-- import RIINA.Properties.NonInterference_v2            -- 12 errors, 6 sorry
-- import RIINA.Properties.NonInterference_v2_LogicalRelation -- 239 errors, 3 sorry

/-!
# RIINA Formal Proofs - Main Library

Multi-prover verification port from Coq 8.20.1 originals.
302 compiled theorems, 0 in-build sorry.

## Core Modules (compilation verified)
- `RIINA.Foundations.Syntax` - Core syntax definitions (port of Syntax.v)
- `RIINA.Foundations.Semantics` - Operational semantics (port of Semantics.v)
- `RIINA.TypeSystem.Typing` - Typing rules + canonical forms (port of Typing.v)

## Property Modules (compilation verified)
- `RIINA.Properties.AhmedStyleTest` - Ahmed-style step-indexed tests
- `RIINA.Properties.CanonicalForms` - Canonical forms lemmas
- `RIINA.Properties.Composition` - Composition properties
- `RIINA.Properties.CumulativeMonotone` - Cumulative monotonicity
- `RIINA.Properties.Declassification` - Declassification safety proofs (0 sorry)
- `RIINA.Properties.LexOrder` - Lexicographic ordering proofs
- `RIINA.Properties.NonInterference_v2_Monotone` - NI monotonicity
- `RIINA.Properties.SecurityProperties` - Security property theorems
- `RIINA.Properties.TypeMeasure` - Type measure proofs
- `RIINA.Properties.ValRelMonotone` - Value relation monotonicity
- `RIINA.Properties.ValRelStepLimit_PROOF` - Step-limit value relation

## Pending Modules (not yet compilable)
- `RIINA.Properties.NonInterference_v2` - 12 errors, 6 sorry
- `RIINA.Properties.NonInterference_v2_LogicalRelation` - 239 errors, 3 sorry
- ~15 other property files with transpilation errors
-/
