\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ProbabilisticVerification ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ProbabilisticVerification.v (20 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* negligible (matches Coq: Definition negligible)
negligible(f) == TRUE

\* comp_indist (matches Coq: Definition comp_indist)
comp_indist(f, g) == TRUE

\* xor_nat (matches Coq: Definition xor_nat)
xor_nat(a, b) == TRUE

\* uniform_nonneg (matches Coq: Theorem uniform_nonneg)
THEOREM uniform_nonneg == Init => TypeOK

\* zero_negligible (matches Coq: Theorem zero_negligible)
THEOREM zero_negligible == Init => TypeOK

\* Qplus_lt_compat2 (matches Coq: Lemma Qplus_lt_compat2)
THEOREM Qplus_lt_compat2 == Init => TypeOK

\* two_over_nSc_le_one_over_nc (matches Coq: Lemma two_over_nSc_le_one_over_nc)
THEOREM two_over_nSc_le_one_over_nc == Init => TypeOK

\* negligible_sum (matches Coq: Theorem negligible_sum)
THEOREM negligible_sum == Init => TypeOK

\* Qabs_Qminus_self (matches Coq: Lemma Qabs_Qminus_self)
THEOREM Qabs_Qminus_self == Init => TypeOK

\* fold_combine_self_gen (matches Coq: Lemma fold_combine_self_gen)
THEOREM fold_combine_self_gen == Init => TypeOK

\* fold_combine_self (matches Coq: Lemma fold_combine_self)
THEOREM fold_combine_self == Init => TypeOK

\* identical_indist (matches Coq: Theorem identical_indist)
THEOREM identical_indist == Init => TypeOK

\* comp_indist_refl (matches Coq: Theorem comp_indist_refl)
THEOREM comp_indist_refl == Init => TypeOK

\* xor_self_inverse (matches Coq: Theorem xor_self_inverse)
THEOREM xor_self_inverse == Init => TypeOK

\* xor_comm (matches Coq: Theorem xor_comm)
THEOREM xor_comm == Init => TypeOK

\* xor_zero_id (matches Coq: Theorem xor_zero_id)
THEOREM xor_zero_id == Init => TypeOK

\* xor_assoc (matches Coq: Theorem xor_assoc)
THEOREM xor_assoc == Init => TypeOK

\* xor_self_zero (matches Coq: Theorem xor_self_zero)
THEOREM xor_self_zero == Init => TypeOK

\* otp_roundtrip (matches Coq: Theorem otp_roundtrip)
THEOREM otp_roundtrip == Init => TypeOK

\* xor_deterministic (matches Coq: Theorem xor_deterministic)
THEOREM xor_deterministic == Init => TypeOK

\* uniform_length (matches Coq: Theorem uniform_length)
THEOREM uniform_length == Init => TypeOK

\* qabs_nonneg (matches Coq: Theorem qabs_nonneg)
THEOREM qabs_nonneg == Init => TypeOK

\* qabs_zero (matches Coq: Theorem qabs_zero)
THEOREM qabs_zero == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
