\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE TypeSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/type_system/TypeSafety.v (6 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* stuck (matches Coq: Definition stuck)
stuck(cfg) == TRUE

\* type_safety (matches Coq: Theorem type_safety)
THEOREM type_safety == Init => TypeOK

\* multi_step_safety (matches Coq: Theorem multi_step_safety)
THEOREM multi_step_safety == Init => TypeOK

\* stuck_implies_not_value (matches Coq: Lemma stuck_implies_not_value)
THEOREM stuck_implies_not_value == Init => TypeOK

\* stuck_implies_not_stepping (matches Coq: Lemma stuck_implies_not_stepping)
THEOREM stuck_implies_not_stepping == Init => TypeOK

\* not_stuck_from_value_or_step (matches Coq: Lemma not_stuck_from_value_or_step)
THEOREM not_stuck_from_value_or_step == Init => TypeOK

\* stuck_complete (matches Coq: Lemma stuck_complete)
THEOREM stuck_complete == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
