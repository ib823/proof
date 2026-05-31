\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ExecutionReceipts ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ExecutionReceipts.v (56 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* ReceiptChain (matches Coq: Inductive ReceiptChain)
CONSTANTS ChainEmpty, ChainLink

\* ReceiptConfig (matches Coq: Record ReceiptConfig)
VARIABLES er_hash_valid, er_signature_valid, er_timestamp_monotonic, er_inputs_recorded, er_outputs_recorded

\* DeterminismConfig (matches Coq: Record DeterminismConfig)
VARIABLES er_same_input_same_output, er_no_nondeterminism, er_reproducible

\* Type invariant
TypeOK ==
  /\ er_hash_valid \in BOOLEAN
  /\ er_signature_valid \in BOOLEAN
  /\ er_timestamp_monotonic \in BOOLEAN
  /\ er_inputs_recorded \in BOOLEAN
  /\ er_outputs_recorded \in BOOLEAN
  /\ er_same_input_same_output \in BOOLEAN
  /\ er_no_nondeterminism \in BOOLEAN
  /\ er_reproducible \in BOOLEAN

\* Initial state
Init ==
  /\ er_hash_valid = TRUE
  /\ er_signature_valid = TRUE
  /\ er_timestamp_monotonic = TRUE
  /\ er_inputs_recorded = TRUE
  /\ er_outputs_recorded = TRUE
  /\ er_same_input_same_output = TRUE
  /\ er_no_nondeterminism = TRUE
  /\ er_reproducible = TRUE

\* receipt_valid (matches Coq: Definition receipt_valid)
receipt_valid(c) == TRUE

\* riina_receipt (matches Coq: Definition riina_receipt)
riina_receipt == TRUE

\* bad_receipt (matches Coq: Definition bad_receipt)
bad_receipt == TRUE

\* chain_valid (matches Coq: Definition chain_valid)
chain_valid(c) == TRUE

\* chain_length (matches Coq: Definition chain_length)
chain_length(c) == TRUE

\* deterministic (matches Coq: Definition deterministic)
deterministic(c) == TRUE

\* riina_determinism (matches Coq: Definition riina_determinism)
riina_determinism == TRUE

\* bad_determinism (matches Coq: Definition bad_determinism)
bad_determinism == TRUE

\* append_receipt (matches Coq: Definition append_receipt)
append_receipt(c, rv, phm) == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* ER_001 (matches Coq: Theorem ER_001)
THEOREM ER_001 == Init => TypeOK

\* ER_002 (matches Coq: Theorem ER_002)
THEOREM ER_002 == Init => TypeOK

\* ER_003 (matches Coq: Theorem ER_003)
THEOREM ER_003 == Init => TypeOK

\* ER_004 (matches Coq: Theorem ER_004)
THEOREM ER_004 == Init => TypeOK

\* ER_005 (matches Coq: Theorem ER_005)
THEOREM ER_005 == Init => TypeOK

\* ER_006 (matches Coq: Theorem ER_006)
THEOREM ER_006 == Init => TypeOK

\* ER_007 (matches Coq: Theorem ER_007)
THEOREM ER_007 == Init => TypeOK

\* ER_008 (matches Coq: Theorem ER_008)
THEOREM ER_008 == Init => TypeOK

\* ER_009 (matches Coq: Theorem ER_009)
THEOREM ER_009 == Init => TypeOK

\* ER_010 (matches Coq: Theorem ER_010)
THEOREM ER_010 == Init => TypeOK

\* ER_011 (matches Coq: Theorem ER_011)
THEOREM ER_011 == Init => TypeOK

\* ER_012 (matches Coq: Theorem ER_012)
THEOREM ER_012 == Init => TypeOK

\* ER_013 (matches Coq: Theorem ER_013)
THEOREM ER_013 == Init => TypeOK

\* ER_014 (matches Coq: Theorem ER_014)
THEOREM ER_014 == Init => TypeOK

\* ER_015 (matches Coq: Theorem ER_015)
THEOREM ER_015 == Init => TypeOK

\* ER_016 (matches Coq: Theorem ER_016)
THEOREM ER_016 == Init => TypeOK

\* ER_017 (matches Coq: Theorem ER_017)
THEOREM ER_017 == Init => TypeOK

\* ER_018 (matches Coq: Theorem ER_018)
THEOREM ER_018 == Init => TypeOK

\* ER_019 (matches Coq: Theorem ER_019)
THEOREM ER_019 == Init => TypeOK

\* ER_020 (matches Coq: Theorem ER_020)
THEOREM ER_020 == Init => TypeOK

\* ER_021 (matches Coq: Theorem ER_021)
THEOREM ER_021 == Init => TypeOK

\* ER_022 (matches Coq: Theorem ER_022)
THEOREM ER_022 == Init => TypeOK

\* ER_023 (matches Coq: Theorem ER_023)
THEOREM ER_023 == Init => TypeOK

\* ER_024 (matches Coq: Theorem ER_024)
THEOREM ER_024 == Init => TypeOK

\* ER_025 (matches Coq: Theorem ER_025)
THEOREM ER_025 == Init => TypeOK

\* ER_026 (matches Coq: Theorem ER_026)
THEOREM ER_026 == Init => TypeOK

\* ER_027 (matches Coq: Theorem ER_027)
THEOREM ER_027 == Init => TypeOK

\* ER_028 (matches Coq: Theorem ER_028)
THEOREM ER_028 == Init => TypeOK

\* ER_029 (matches Coq: Theorem ER_029)
THEOREM ER_029 == Init => TypeOK

\* ER_030 (matches Coq: Theorem ER_030)
THEOREM ER_030 == Init => TypeOK

\* ER_031 (matches Coq: Theorem ER_031)
THEOREM ER_031 == Init => TypeOK

\* ER_032 (matches Coq: Theorem ER_032)
THEOREM ER_032 == Init => TypeOK

\* ER_033 (matches Coq: Theorem ER_033)
THEOREM ER_033 == Init => TypeOK

\* ER_034 (matches Coq: Theorem ER_034)
THEOREM ER_034 == Init => TypeOK

\* ER_035 (matches Coq: Theorem ER_035)
THEOREM ER_035 == Init => TypeOK

\* ER_036 (matches Coq: Theorem ER_036)
THEOREM ER_036 == Init => TypeOK

\* ER_037 (matches Coq: Theorem ER_037)
THEOREM ER_037 == Init => TypeOK

\* ER_038 (matches Coq: Theorem ER_038)
THEOREM ER_038 == Init => TypeOK

\* ER_039 (matches Coq: Theorem ER_039)
THEOREM ER_039 == Init => TypeOK

\* ER_040 (matches Coq: Theorem ER_040)
THEOREM ER_040 == Init => TypeOK

\* ER_041 (matches Coq: Theorem ER_041)
THEOREM ER_041 == Init => TypeOK

\* ER_042 (matches Coq: Theorem ER_042)
THEOREM ER_042 == Init => TypeOK

\* ER_043 (matches Coq: Theorem ER_043)
THEOREM ER_043 == Init => TypeOK

\* ER_044 (matches Coq: Theorem ER_044)
THEOREM ER_044 == Init => TypeOK

\* ER_045 (matches Coq: Theorem ER_045)
THEOREM ER_045 == Init => TypeOK

\* ER_046 (matches Coq: Theorem ER_046)
THEOREM ER_046 == Init => TypeOK

\* ER_047 (matches Coq: Theorem ER_047)
THEOREM ER_047 == Init => TypeOK

\* ER_048 (matches Coq: Theorem ER_048)
THEOREM ER_048 == Init => TypeOK

\* ER_049 (matches Coq: Theorem ER_049)
THEOREM ER_049 == Init => TypeOK

\* ER_050 (matches Coq: Theorem ER_050)
THEOREM ER_050 == Init => TypeOK

\* ER_051 (matches Coq: Theorem ER_051)
THEOREM ER_051 == Init => TypeOK

\* ER_052 (matches Coq: Theorem ER_052)
THEOREM ER_052 == Init => TypeOK

\* ER_053 (matches Coq: Theorem ER_053)
THEOREM ER_053 == Init => TypeOK

\* ER_054 (matches Coq: Theorem ER_054)
THEOREM ER_054 == Init => TypeOK

\* ER_055 (matches Coq: Theorem ER_055)
THEOREM ER_055 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<er_hash_valid, er_signature_valid, er_timestamp_monotonic, er_inputs_recorded, er_outputs_recorded, er_same_input_same_output, er_no_nondeterminism, er_reproducible>>

\* Specification
Spec == Init /\ [][Next]_<<er_hash_valid, er_signature_valid, er_timestamp_monotonic, er_inputs_recorded, er_outputs_recorded, er_same_input_same_output, er_no_nondeterminism, er_reproducible>>

====
