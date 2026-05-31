\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ThreatModeling ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ThreatModeling.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* ThreatClassConfig (matches Coq: Record ThreatClassConfig)
VARIABLES thm_stride_analysis, thm_attack_surface_map, thm_risk_scoring, thm_threat_categorization, thm_asset_inventory, thm_vulnerability_ranking

\* AttackTreeConfig (matches Coq: Record AttackTreeConfig)
VARIABLES thm_tree_decomposition, thm_leaf_node_validation, thm_probability_scoring, thm_countermeasure_mapping, thm_path_enumeration

\* Type invariant
TypeOK ==
  /\ thm_stride_analysis \in BOOLEAN
  /\ thm_attack_surface_map \in BOOLEAN
  /\ thm_risk_scoring \in BOOLEAN
  /\ thm_threat_categorization \in BOOLEAN
  /\ thm_asset_inventory \in BOOLEAN
  /\ thm_vulnerability_ranking \in BOOLEAN
  /\ thm_tree_decomposition \in BOOLEAN
  /\ thm_leaf_node_validation \in BOOLEAN
  /\ thm_probability_scoring \in BOOLEAN
  /\ thm_countermeasure_mapping \in BOOLEAN
  /\ thm_path_enumeration \in BOOLEAN

\* Initial state
Init ==
  /\ thm_stride_analysis = TRUE
  /\ thm_attack_surface_map = TRUE
  /\ thm_risk_scoring = TRUE
  /\ thm_threat_categorization = TRUE
  /\ thm_asset_inventory = TRUE
  /\ thm_vulnerability_ranking = TRUE
  /\ thm_tree_decomposition = TRUE
  /\ thm_leaf_node_validation = TRUE
  /\ thm_probability_scoring = TRUE
  /\ thm_countermeasure_mapping = TRUE
  /\ thm_path_enumeration = TRUE

\* threat_class_secure (matches Coq: Definition threat_class_secure)
threat_class_secure(c) == TRUE

\* riina_threat_class (matches Coq: Definition riina_threat_class)
riina_threat_class == TRUE

\* attack_tree_secure (matches Coq: Definition attack_tree_secure)
attack_tree_secure(c) == TRUE

\* riina_attack_tree (matches Coq: Definition riina_attack_tree)
riina_attack_tree == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* THM_001 (matches Coq: Theorem THM_001)
THEOREM THM_001 == Init => TypeOK

\* THM_002 (matches Coq: Theorem THM_002)
THEOREM THM_002 == Init => TypeOK

\* THM_003 (matches Coq: Theorem THM_003)
THEOREM THM_003 == Init => TypeOK

\* THM_004 (matches Coq: Theorem THM_004)
THEOREM THM_004 == Init => TypeOK

\* THM_005 (matches Coq: Theorem THM_005)
THEOREM THM_005 == Init => TypeOK

\* THM_006 (matches Coq: Theorem THM_006)
THEOREM THM_006 == Init => TypeOK

\* THM_007 (matches Coq: Theorem THM_007)
THEOREM THM_007 == Init => TypeOK

\* THM_008 (matches Coq: Theorem THM_008)
THEOREM THM_008 == Init => TypeOK

\* THM_009 (matches Coq: Theorem THM_009)
THEOREM THM_009 == Init => TypeOK

\* THM_010 (matches Coq: Theorem THM_010)
THEOREM THM_010 == Init => TypeOK

\* THM_011 (matches Coq: Theorem THM_011)
THEOREM THM_011 == Init => TypeOK

\* THM_012 (matches Coq: Theorem THM_012)
THEOREM THM_012 == Init => TypeOK

\* THM_013 (matches Coq: Theorem THM_013)
THEOREM THM_013 == Init => TypeOK

\* THM_014 (matches Coq: Theorem THM_014)
THEOREM THM_014 == Init => TypeOK

\* THM_015 (matches Coq: Theorem THM_015)
THEOREM THM_015 == Init => TypeOK

\* THM_016 (matches Coq: Theorem THM_016)
THEOREM THM_016 == Init => TypeOK

\* THM_017 (matches Coq: Theorem THM_017)
THEOREM THM_017 == Init => TypeOK

\* THM_018 (matches Coq: Theorem THM_018)
THEOREM THM_018 == Init => TypeOK

\* THM_019 (matches Coq: Theorem THM_019)
THEOREM THM_019 == Init => TypeOK

\* THM_020 (matches Coq: Theorem THM_020)
THEOREM THM_020 == Init => TypeOK

\* THM_021 (matches Coq: Theorem THM_021)
THEOREM THM_021 == Init => TypeOK

\* THM_022 (matches Coq: Theorem THM_022)
THEOREM THM_022 == Init => TypeOK

\* THM_023 (matches Coq: Theorem THM_023)
THEOREM THM_023 == Init => TypeOK

\* THM_024 (matches Coq: Theorem THM_024)
THEOREM THM_024 == Init => TypeOK

\* THM_025 (matches Coq: Theorem THM_025)
THEOREM THM_025 == Init => TypeOK

\* THM_026 (matches Coq: Theorem THM_026)
THEOREM THM_026 == Init => TypeOK

\* THM_027 (matches Coq: Theorem THM_027)
THEOREM THM_027 == Init => TypeOK

\* THM_028 (matches Coq: Theorem THM_028)
THEOREM THM_028 == Init => TypeOK

\* THM_029 (matches Coq: Theorem THM_029)
THEOREM THM_029 == Init => TypeOK

\* THM_030 (matches Coq: Theorem THM_030)
THEOREM THM_030 == Init => TypeOK

\* THM_031 (matches Coq: Theorem THM_031)
THEOREM THM_031 == Init => TypeOK

\* THM_032 (matches Coq: Theorem THM_032)
THEOREM THM_032 == Init => TypeOK

\* THM_033 (matches Coq: Theorem THM_033)
THEOREM THM_033 == Init => TypeOK

\* THM_034 (matches Coq: Theorem THM_034)
THEOREM THM_034 == Init => TypeOK

\* THM_035 (matches Coq: Theorem THM_035)
THEOREM THM_035 == Init => TypeOK

\* THM_036 (matches Coq: Theorem THM_036)
THEOREM THM_036 == Init => TypeOK

\* THM_037 (matches Coq: Theorem THM_037)
THEOREM THM_037 == Init => TypeOK

\* THM_038 (matches Coq: Theorem THM_038)
THEOREM THM_038 == Init => TypeOK

\* THM_039 (matches Coq: Theorem THM_039)
THEOREM THM_039 == Init => TypeOK

\* THM_040 (matches Coq: Theorem THM_040)
THEOREM THM_040 == Init => TypeOK

\* THM_041 (matches Coq: Theorem THM_041)
THEOREM THM_041 == Init => TypeOK

\* THM_042 (matches Coq: Theorem THM_042)
THEOREM THM_042 == Init => TypeOK

\* THM_043 (matches Coq: Theorem THM_043)
THEOREM THM_043 == Init => TypeOK

\* THM_044 (matches Coq: Theorem THM_044)
THEOREM THM_044 == Init => TypeOK

\* THM_045 (matches Coq: Theorem THM_045)
THEOREM THM_045 == Init => TypeOK

\* THM_046 (matches Coq: Theorem THM_046)
THEOREM THM_046 == Init => TypeOK

\* THM_047 (matches Coq: Theorem THM_047)
THEOREM THM_047 == Init => TypeOK

\* THM_048 (matches Coq: Theorem THM_048)
THEOREM THM_048 == Init => TypeOK

\* THM_049 (matches Coq: Theorem THM_049)
THEOREM THM_049 == Init => TypeOK

\* THM_050 (matches Coq: Theorem THM_050)
THEOREM THM_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<thm_stride_analysis, thm_attack_surface_map, thm_risk_scoring, thm_threat_categorization, thm_asset_inventory, thm_vulnerability_ranking, thm_tree_decomposition, thm_leaf_node_validation, thm_probability_scoring, thm_countermeasure_mapping, thm_path_enumeration>>

\* Specification
Spec == Init /\ [][Next]_<<thm_stride_analysis, thm_attack_surface_map, thm_risk_scoring, thm_threat_categorization, thm_asset_inventory, thm_vulnerability_ranking, thm_tree_decomposition, thm_leaf_node_validation, thm_probability_scoring, thm_countermeasure_mapping, thm_path_enumeration>>

====
