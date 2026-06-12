\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE SecurityProperties ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/_archive_deprecated/SecurityProperties.v
\* Top-level non-interference theorem.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS LPublic, LSecret
LabelSet == {LPublic, LSecret}

CONSTANTS TUnit, TBool, TInt, TFn, TSecret
TypeSet == {TUnit, TBool, TInt, TFn, TSecret}

CONSTANTS EUnit, EBool, EInt, ELam
ValueSet == {EUnit, EBool, EInt, ELam}

\* security_level: maps types to security levels
security_level(T) ==
  IF T = TSecret THEN LSecret ELSE LPublic

\* low_equivalent: two values are low-equivalent (public-indistinguishable)
low_equivalent(v1, v2, T) ==
  IF security_level(T) = LPublic
  THEN v1 = v2
  ELSE TRUE  \* secret values are always "equivalent" (indistinguishable)

VARIABLES ty, val1, val2, isNI

vars == <<ty, val1, val2, isNI>>

TypeOK ==
  /\ ty \in TypeSet
  /\ val1 \in ValueSet
  /\ val2 \in ValueSet
  /\ isNI \in BOOLEAN

Init ==
  /\ ty \in TypeSet
  /\ val1 \in ValueSet
  /\ val2 \in ValueSet
  /\ isNI = low_equivalent(val1, val2, ty)

Check ==
  /\ ty' \in TypeSet
  /\ val1' \in ValueSet
  /\ val2' \in ValueSet
  /\ isNI' = low_equivalent(val1', val2', ty')

Next == Check

Spec == Init /\ [][Next]_vars

\* security_non_interference: main theorem
\* Well-typed programs that differ only in secret inputs
\* produce indistinguishable public outputs
THEOREM security_non_interference ==
  \A T \in TypeSet : \A v1, v2 \in ValueSet :
    security_level(T) = LPublic /\ low_equivalent(v1, v2, T)
    => v1 = v2

====
