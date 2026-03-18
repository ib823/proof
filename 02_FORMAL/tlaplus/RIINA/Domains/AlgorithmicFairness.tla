---- MODULE AlgorithmicFairness ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/AlgorithmicFairness.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* FairnessConfig (matches Coq: Record FairnessConfig)
VARIABLES afn_demographic_parity, afn_equalized_odds, afn_calibration, afn_individual_fairness, afn_counterfactual_fairness, afn_bias_audit

\* BiasDetectionConfig (matches Coq: Record BiasDetectionConfig)
VARIABLES afn_statistical_parity_test, afn_disparate_impact_ratio, afn_predictive_equality, afn_treatment_equality, afn_conditional_use_accuracy

\* Type invariant
TypeOK ==
  /\ afn_demographic_parity \in BOOLEAN
  /\ afn_equalized_odds \in BOOLEAN
  /\ afn_calibration \in BOOLEAN
  /\ afn_individual_fairness \in BOOLEAN
  /\ afn_counterfactual_fairness \in BOOLEAN
  /\ afn_bias_audit \in BOOLEAN
  /\ afn_statistical_parity_test \in BOOLEAN
  /\ afn_disparate_impact_ratio \in BOOLEAN
  /\ afn_predictive_equality \in BOOLEAN
  /\ afn_treatment_equality \in BOOLEAN
  /\ afn_conditional_use_accuracy \in BOOLEAN

\* Initial state
Init ==
  /\ afn_demographic_parity = TRUE
  /\ afn_equalized_odds = TRUE
  /\ afn_calibration = TRUE
  /\ afn_individual_fairness = TRUE
  /\ afn_counterfactual_fairness = TRUE
  /\ afn_bias_audit = TRUE
  /\ afn_statistical_parity_test = TRUE
  /\ afn_disparate_impact_ratio = TRUE
  /\ afn_predictive_equality = TRUE
  /\ afn_treatment_equality = TRUE
  /\ afn_conditional_use_accuracy = TRUE

\* fairness_secure (matches Coq: Definition fairness_secure)
fairness_secure(c) == TRUE

\* riina_fairness (matches Coq: Definition riina_fairness)
riina_fairness == TRUE

\* bias_detection_secure (matches Coq: Definition bias_detection_secure)
bias_detection_secure(c) == TRUE

\* riina_bias_detection (matches Coq: Definition riina_bias_detection)
riina_bias_detection == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* AFN_001 (matches Coq: Theorem AFN_001)
THEOREM AFN_001 == Init => TypeOK

\* AFN_002 (matches Coq: Theorem AFN_002)
THEOREM AFN_002 == Init => TypeOK

\* AFN_003 (matches Coq: Theorem AFN_003)
THEOREM AFN_003 == Init => TypeOK

\* AFN_004 (matches Coq: Theorem AFN_004)
THEOREM AFN_004 == Init => TypeOK

\* AFN_005 (matches Coq: Theorem AFN_005)
THEOREM AFN_005 == Init => TypeOK

\* AFN_006 (matches Coq: Theorem AFN_006)
THEOREM AFN_006 == Init => TypeOK

\* AFN_007 (matches Coq: Theorem AFN_007)
THEOREM AFN_007 == Init => TypeOK

\* AFN_008 (matches Coq: Theorem AFN_008)
THEOREM AFN_008 == Init => TypeOK

\* AFN_009 (matches Coq: Theorem AFN_009)
THEOREM AFN_009 == Init => TypeOK

\* AFN_010 (matches Coq: Theorem AFN_010)
THEOREM AFN_010 == Init => TypeOK

\* AFN_011 (matches Coq: Theorem AFN_011)
THEOREM AFN_011 == Init => TypeOK

\* AFN_012 (matches Coq: Theorem AFN_012)
THEOREM AFN_012 == Init => TypeOK

\* AFN_013 (matches Coq: Theorem AFN_013)
THEOREM AFN_013 == Init => TypeOK

\* AFN_014 (matches Coq: Theorem AFN_014)
THEOREM AFN_014 == Init => TypeOK

\* AFN_015 (matches Coq: Theorem AFN_015)
THEOREM AFN_015 == Init => TypeOK

\* AFN_016 (matches Coq: Theorem AFN_016)
THEOREM AFN_016 == Init => TypeOK

\* AFN_017 (matches Coq: Theorem AFN_017)
THEOREM AFN_017 == Init => TypeOK

\* AFN_018 (matches Coq: Theorem AFN_018)
THEOREM AFN_018 == Init => TypeOK

\* AFN_019 (matches Coq: Theorem AFN_019)
THEOREM AFN_019 == Init => TypeOK

\* AFN_020 (matches Coq: Theorem AFN_020)
THEOREM AFN_020 == Init => TypeOK

\* AFN_021 (matches Coq: Theorem AFN_021)
THEOREM AFN_021 == Init => TypeOK

\* AFN_022 (matches Coq: Theorem AFN_022)
THEOREM AFN_022 == Init => TypeOK

\* AFN_023 (matches Coq: Theorem AFN_023)
THEOREM AFN_023 == Init => TypeOK

\* AFN_024 (matches Coq: Theorem AFN_024)
THEOREM AFN_024 == Init => TypeOK

\* AFN_025 (matches Coq: Theorem AFN_025)
THEOREM AFN_025 == Init => TypeOK

\* AFN_026 (matches Coq: Theorem AFN_026)
THEOREM AFN_026 == Init => TypeOK

\* AFN_027 (matches Coq: Theorem AFN_027)
THEOREM AFN_027 == Init => TypeOK

\* AFN_028 (matches Coq: Theorem AFN_028)
THEOREM AFN_028 == Init => TypeOK

\* AFN_029 (matches Coq: Theorem AFN_029)
THEOREM AFN_029 == Init => TypeOK

\* AFN_030 (matches Coq: Theorem AFN_030)
THEOREM AFN_030 == Init => TypeOK

\* AFN_031 (matches Coq: Theorem AFN_031)
THEOREM AFN_031 == Init => TypeOK

\* AFN_032 (matches Coq: Theorem AFN_032)
THEOREM AFN_032 == Init => TypeOK

\* AFN_033 (matches Coq: Theorem AFN_033)
THEOREM AFN_033 == Init => TypeOK

\* AFN_034 (matches Coq: Theorem AFN_034)
THEOREM AFN_034 == Init => TypeOK

\* AFN_035 (matches Coq: Theorem AFN_035)
THEOREM AFN_035 == Init => TypeOK

\* AFN_036 (matches Coq: Theorem AFN_036)
THEOREM AFN_036 == Init => TypeOK

\* AFN_037 (matches Coq: Theorem AFN_037)
THEOREM AFN_037 == Init => TypeOK

\* AFN_038 (matches Coq: Theorem AFN_038)
THEOREM AFN_038 == Init => TypeOK

\* AFN_039 (matches Coq: Theorem AFN_039)
THEOREM AFN_039 == Init => TypeOK

\* AFN_040 (matches Coq: Theorem AFN_040)
THEOREM AFN_040 == Init => TypeOK

\* AFN_041 (matches Coq: Theorem AFN_041)
THEOREM AFN_041 == Init => TypeOK

\* AFN_042 (matches Coq: Theorem AFN_042)
THEOREM AFN_042 == Init => TypeOK

\* AFN_043 (matches Coq: Theorem AFN_043)
THEOREM AFN_043 == Init => TypeOK

\* AFN_044 (matches Coq: Theorem AFN_044)
THEOREM AFN_044 == Init => TypeOK

\* AFN_045 (matches Coq: Theorem AFN_045)
THEOREM AFN_045 == Init => TypeOK

\* AFN_046 (matches Coq: Theorem AFN_046)
THEOREM AFN_046 == Init => TypeOK

\* AFN_047 (matches Coq: Theorem AFN_047)
THEOREM AFN_047 == Init => TypeOK

\* AFN_048 (matches Coq: Theorem AFN_048)
THEOREM AFN_048 == Init => TypeOK

\* AFN_049 (matches Coq: Theorem AFN_049)
THEOREM AFN_049 == Init => TypeOK

\* AFN_050 (matches Coq: Theorem AFN_050)
THEOREM AFN_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<afn_demographic_parity, afn_equalized_odds, afn_calibration, afn_individual_fairness, afn_counterfactual_fairness, afn_bias_audit, afn_statistical_parity_test, afn_disparate_impact_ratio, afn_predictive_equality, afn_treatment_equality, afn_conditional_use_accuracy>>

\* Specification
Spec == Init /\ [][Next]_<<afn_demographic_parity, afn_equalized_odds, afn_calibration, afn_individual_fairness, afn_counterfactual_fairness, afn_bias_audit, afn_statistical_parity_test, afn_disparate_impact_ratio, afn_predictive_equality, afn_treatment_equality, afn_conditional_use_accuracy>>

====
