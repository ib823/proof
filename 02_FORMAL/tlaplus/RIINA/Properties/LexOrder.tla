---- MODULE LexOrder ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/LexOrder.v
\* Lexicographic well-founded order for step-indexed proofs.

EXTENDS Naturals, FiniteSets, Sequences

\* lex_lt: (m1, m2) < (n1, n2) iff m1 < n1 or (m1 = n1 and m2 < n2)
lex_lt(m1, m2, n1, n2) ==
  m1 < n1 \/ (m1 = n1 /\ m2 < n2)

VARIABLES n1, n2, m1, m2, isLess

vars == <<n1, n2, m1, m2, isLess>>

TypeOK ==
  /\ n1 \in Nat /\ n2 \in Nat
  /\ m1 \in Nat /\ m2 \in Nat
  /\ isLess \in BOOLEAN

Init ==
  /\ n1 \in 0..5 /\ n2 \in 0..5
  /\ m1 \in 0..5 /\ m2 \in 0..5
  /\ isLess = lex_lt(m1, m2, n1, n2)

Compare ==
  /\ n1' \in 0..5 /\ n2' \in 0..5
  /\ m1' \in 0..5 /\ m2' \in 0..5
  /\ isLess' = lex_lt(m1', m2', n1', n2')

\* Decrease first component
DecFirst ==
  /\ n1 > 0
  /\ m1' = n1 - 1 /\ m2' \in 0..5
  /\ n1' = n1 /\ n2' = n2
  /\ isLess' = lex_lt(m1', m2', n1', n2')

\* Decrease second component (first stays same)
DecSecond ==
  /\ n2 > 0
  /\ m1' = n1 /\ m2' = n2 - 1
  /\ n1' = n1 /\ n2' = n2
  /\ isLess' = lex_lt(m1', m2', n1', n2')

Next == Compare \/ DecFirst \/ DecSecond

Spec == Init /\ [][Next]_vars

\* lex_lt_wf: lexicographic order is well-founded
THEOREM lex_lt_wf ==
  ~(\E n1x, n2x \in Nat :
      \A m1x, m2x \in Nat :
        lex_lt(m1x, m2x, n1x, n2x) => FALSE)

\* lex_lt_irrefl: lexicographic order is irreflexive
THEOREM lex_lt_irrefl ==
  \A a, b \in Nat : ~lex_lt(a, b, a, b)

\* lex_lt_trans: lexicographic order is transitive
THEOREM lex_lt_trans ==
  \A a1, a2, b1, b2, c1, c2 \in Nat :
    lex_lt(a1, a2, b1, b2) /\ lex_lt(b1, b2, c1, c2)
    => lex_lt(a1, a2, c1, c2)

\* lex_lt_dec_first: decreasing first component gives lex_lt
THEOREM lex_lt_dec_first ==
  \A n1x, n2x, m2x \in Nat :
    n1x > 0 => lex_lt(n1x - 1, m2x, n1x, n2x)

\* lex_lt_dec_second: keeping first, decreasing second gives lex_lt
THEOREM lex_lt_dec_second ==
  \A n1x, n2x \in Nat :
    n2x > 0 => lex_lt(n1x, n2x - 1, n1x, n2x)

\* lex_lt_step_type: (n, ty_size T1) < (n, ty_size (TFn T1 T2))
THEOREM lex_lt_step_type ==
  \A n \in Nat : \A s1, s2 \in Nat :
    s1 < s1 + s2 + 1 => lex_lt(n, s1, n, s1 + s2 + 1)

====
