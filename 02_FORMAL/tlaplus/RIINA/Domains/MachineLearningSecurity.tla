\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE MachineLearningSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/MachineLearningSecurity.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* MLModelConfig (matches Coq: Record MLModelConfig)
VARIABLES mls_poisoning_detection, mls_adversarial_robustness, mls_model_integrity, mls_gradient_masking, mls_input_validation, mls_output_sanitization

\* MLDataConfig (matches Coq: Record MLDataConfig)
VARIABLES mls_data_anonymization, mls_differential_privacy, mls_federated_learning, mls_training_isolation, mls_audit_trail

\* Type invariant
TypeOK ==
  /\ mls_poisoning_detection \in BOOLEAN
  /\ mls_adversarial_robustness \in BOOLEAN
  /\ mls_model_integrity \in BOOLEAN
  /\ mls_gradient_masking \in BOOLEAN
  /\ mls_input_validation \in BOOLEAN
  /\ mls_output_sanitization \in BOOLEAN
  /\ mls_data_anonymization \in BOOLEAN
  /\ mls_differential_privacy \in BOOLEAN
  /\ mls_federated_learning \in BOOLEAN
  /\ mls_training_isolation \in BOOLEAN
  /\ mls_audit_trail \in BOOLEAN

\* Initial state
Init ==
  /\ mls_poisoning_detection = TRUE
  /\ mls_adversarial_robustness = TRUE
  /\ mls_model_integrity = TRUE
  /\ mls_gradient_masking = TRUE
  /\ mls_input_validation = TRUE
  /\ mls_output_sanitization = TRUE
  /\ mls_data_anonymization = TRUE
  /\ mls_differential_privacy = TRUE
  /\ mls_federated_learning = TRUE
  /\ mls_training_isolation = TRUE
  /\ mls_audit_trail = TRUE

\* ml_model_secure (matches Coq: Definition ml_model_secure)
ml_model_secure(c) == TRUE

\* riina_ml_model (matches Coq: Definition riina_ml_model)
riina_ml_model == TRUE

\* ml_data_secure (matches Coq: Definition ml_data_secure)
ml_data_secure(c) == TRUE

\* riina_ml_data (matches Coq: Definition riina_ml_data)
riina_ml_data == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* MLS_001 (matches Coq: Theorem MLS_001)
THEOREM MLS_001 == Init => TypeOK

\* MLS_002 (matches Coq: Theorem MLS_002)
THEOREM MLS_002 == Init => TypeOK

\* MLS_003 (matches Coq: Theorem MLS_003)
THEOREM MLS_003 == Init => TypeOK

\* MLS_004 (matches Coq: Theorem MLS_004)
THEOREM MLS_004 == Init => TypeOK

\* MLS_005 (matches Coq: Theorem MLS_005)
THEOREM MLS_005 == Init => TypeOK

\* MLS_006 (matches Coq: Theorem MLS_006)
THEOREM MLS_006 == Init => TypeOK

\* MLS_007 (matches Coq: Theorem MLS_007)
THEOREM MLS_007 == Init => TypeOK

\* MLS_008 (matches Coq: Theorem MLS_008)
THEOREM MLS_008 == Init => TypeOK

\* MLS_009 (matches Coq: Theorem MLS_009)
THEOREM MLS_009 == Init => TypeOK

\* MLS_010 (matches Coq: Theorem MLS_010)
THEOREM MLS_010 == Init => TypeOK

\* MLS_011 (matches Coq: Theorem MLS_011)
THEOREM MLS_011 == Init => TypeOK

\* MLS_012 (matches Coq: Theorem MLS_012)
THEOREM MLS_012 == Init => TypeOK

\* MLS_013 (matches Coq: Theorem MLS_013)
THEOREM MLS_013 == Init => TypeOK

\* MLS_014 (matches Coq: Theorem MLS_014)
THEOREM MLS_014 == Init => TypeOK

\* MLS_015 (matches Coq: Theorem MLS_015)
THEOREM MLS_015 == Init => TypeOK

\* MLS_016 (matches Coq: Theorem MLS_016)
THEOREM MLS_016 == Init => TypeOK

\* MLS_017 (matches Coq: Theorem MLS_017)
THEOREM MLS_017 == Init => TypeOK

\* MLS_018 (matches Coq: Theorem MLS_018)
THEOREM MLS_018 == Init => TypeOK

\* MLS_019 (matches Coq: Theorem MLS_019)
THEOREM MLS_019 == Init => TypeOK

\* MLS_020 (matches Coq: Theorem MLS_020)
THEOREM MLS_020 == Init => TypeOK

\* MLS_021 (matches Coq: Theorem MLS_021)
THEOREM MLS_021 == Init => TypeOK

\* MLS_022 (matches Coq: Theorem MLS_022)
THEOREM MLS_022 == Init => TypeOK

\* MLS_023 (matches Coq: Theorem MLS_023)
THEOREM MLS_023 == Init => TypeOK

\* MLS_024 (matches Coq: Theorem MLS_024)
THEOREM MLS_024 == Init => TypeOK

\* MLS_025 (matches Coq: Theorem MLS_025)
THEOREM MLS_025 == Init => TypeOK

\* MLS_026 (matches Coq: Theorem MLS_026)
THEOREM MLS_026 == Init => TypeOK

\* MLS_027 (matches Coq: Theorem MLS_027)
THEOREM MLS_027 == Init => TypeOK

\* MLS_028 (matches Coq: Theorem MLS_028)
THEOREM MLS_028 == Init => TypeOK

\* MLS_029 (matches Coq: Theorem MLS_029)
THEOREM MLS_029 == Init => TypeOK

\* MLS_030 (matches Coq: Theorem MLS_030)
THEOREM MLS_030 == Init => TypeOK

\* MLS_031 (matches Coq: Theorem MLS_031)
THEOREM MLS_031 == Init => TypeOK

\* MLS_032 (matches Coq: Theorem MLS_032)
THEOREM MLS_032 == Init => TypeOK

\* MLS_033 (matches Coq: Theorem MLS_033)
THEOREM MLS_033 == Init => TypeOK

\* MLS_034 (matches Coq: Theorem MLS_034)
THEOREM MLS_034 == Init => TypeOK

\* MLS_035 (matches Coq: Theorem MLS_035)
THEOREM MLS_035 == Init => TypeOK

\* MLS_036 (matches Coq: Theorem MLS_036)
THEOREM MLS_036 == Init => TypeOK

\* MLS_037 (matches Coq: Theorem MLS_037)
THEOREM MLS_037 == Init => TypeOK

\* MLS_038 (matches Coq: Theorem MLS_038)
THEOREM MLS_038 == Init => TypeOK

\* MLS_039 (matches Coq: Theorem MLS_039)
THEOREM MLS_039 == Init => TypeOK

\* MLS_040 (matches Coq: Theorem MLS_040)
THEOREM MLS_040 == Init => TypeOK

\* MLS_041 (matches Coq: Theorem MLS_041)
THEOREM MLS_041 == Init => TypeOK

\* MLS_042 (matches Coq: Theorem MLS_042)
THEOREM MLS_042 == Init => TypeOK

\* MLS_043 (matches Coq: Theorem MLS_043)
THEOREM MLS_043 == Init => TypeOK

\* MLS_044 (matches Coq: Theorem MLS_044)
THEOREM MLS_044 == Init => TypeOK

\* MLS_045 (matches Coq: Theorem MLS_045)
THEOREM MLS_045 == Init => TypeOK

\* MLS_046 (matches Coq: Theorem MLS_046)
THEOREM MLS_046 == Init => TypeOK

\* MLS_047 (matches Coq: Theorem MLS_047)
THEOREM MLS_047 == Init => TypeOK

\* MLS_048 (matches Coq: Theorem MLS_048)
THEOREM MLS_048 == Init => TypeOK

\* MLS_049 (matches Coq: Theorem MLS_049)
THEOREM MLS_049 == Init => TypeOK

\* MLS_050 (matches Coq: Theorem MLS_050)
THEOREM MLS_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<mls_poisoning_detection, mls_adversarial_robustness, mls_model_integrity, mls_gradient_masking, mls_input_validation, mls_output_sanitization, mls_data_anonymization, mls_differential_privacy, mls_federated_learning, mls_training_isolation, mls_audit_trail>>

\* Specification
Spec == Init /\ [][Next]_<<mls_poisoning_detection, mls_adversarial_robustness, mls_model_integrity, mls_gradient_masking, mls_input_validation, mls_output_sanitization, mls_data_anonymization, mls_differential_privacy, mls_federated_learning, mls_training_isolation, mls_audit_trail>>

====
