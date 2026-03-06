import Lake
open Lake DSL

-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- RIINA Formal Proofs - Lean 4 Port
-- Multi-prover verification port from Coq originals.

package RIINA where
  version := v!"0.2.0"
  leanOptions := #[
    ⟨`autoImplicit, false⟩,
    ⟨`pp.unicode.fun, true⟩
  ]

@[default_target]
lean_lib RIINA where
  roots := #[`RIINA]
