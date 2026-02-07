import Lake
open Lake DSL

package RIINA where
  leanOptions := #[
    ⟨`autoImplicit, false⟩
  ]

@[default_target]
lean_lib RIINA where
  roots := #[`RIINA]
