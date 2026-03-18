-- Domain files (bulk of theorems — compile independently)
import RIINA.Domains.All
-- MobileOS, Industries, Compliance excluded: transpiler .mk constructor bug
-- import RIINA.Domains.MobileOS
-- import RIINA.Industries
-- import RIINA.Compliance
-- Core files depend on Foundations.Syntax/Semantics which need hand-written Lean port.
-- Excluded until transpiler generates valid Lean for core Coq definitions.
-- import RIINA.Foundations.Syntax
-- import RIINA.Foundations.Semantics
-- import RIINA.TypeSystem.Typing
-- import RIINA.Properties.* (depend on Foundations)
-- import RIINA.Termination.* (depend on Foundations)
-- import RIINA.Effects.* (depend on Foundations)

/-!
# RIINA Formal Proofs - Main Library

Multi-prover verification port from Coq 8.20.1 originals.
1 in-build proof gap (NI_v2).
-/
