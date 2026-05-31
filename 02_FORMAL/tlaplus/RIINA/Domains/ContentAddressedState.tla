\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ContentAddressedState ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ContentAddressedState.v (68 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* StateChainConfig (matches Coq: Record StateChainConfig)
VARIABLES cas_hash_linked, cas_append_only, cas_genesis_valid, cas_parent_exists, cas_no_orphans, cas_monotonic_sequence

\* ForkDetectionConfig (matches Coq: Record ForkDetectionConfig)
VARIABLES cas_divergence_detected, cas_common_ancestor, cas_fork_point_identified, cas_branch_enumeration, cas_conflict_flagged

\* CRDTMergeConfig (matches Coq: Record CRDTMergeConfig)
VARIABLES cas_idempotent, cas_commutative, cas_associative, cas_monotonic, cas_convergent, cas_conflict_free

\* Type invariant
TypeOK ==
  /\ cas_hash_linked \in BOOLEAN
  /\ cas_append_only \in BOOLEAN
  /\ cas_genesis_valid \in BOOLEAN
  /\ cas_parent_exists \in BOOLEAN
  /\ cas_no_orphans \in BOOLEAN
  /\ cas_monotonic_sequence \in BOOLEAN
  /\ cas_divergence_detected \in BOOLEAN
  /\ cas_common_ancestor \in BOOLEAN
  /\ cas_fork_point_identified \in BOOLEAN
  /\ cas_branch_enumeration \in BOOLEAN
  /\ cas_conflict_flagged \in BOOLEAN
  /\ cas_idempotent \in BOOLEAN
  /\ cas_commutative \in BOOLEAN
  /\ cas_associative \in BOOLEAN
  /\ cas_monotonic \in BOOLEAN
  /\ cas_convergent \in BOOLEAN
  /\ cas_conflict_free \in BOOLEAN

\* Initial state
Init ==
  /\ cas_hash_linked = TRUE
  /\ cas_append_only = TRUE
  /\ cas_genesis_valid = TRUE
  /\ cas_parent_exists = TRUE
  /\ cas_no_orphans = TRUE
  /\ cas_monotonic_sequence = TRUE
  /\ cas_divergence_detected = TRUE
  /\ cas_common_ancestor = TRUE
  /\ cas_fork_point_identified = TRUE
  /\ cas_branch_enumeration = TRUE
  /\ cas_conflict_flagged = TRUE
  /\ cas_idempotent = TRUE
  /\ cas_commutative = TRUE
  /\ cas_associative = TRUE
  /\ cas_monotonic = TRUE
  /\ cas_convergent = TRUE
  /\ cas_conflict_free = TRUE

\* state_chain_valid (matches Coq: Definition state_chain_valid)
state_chain_valid(c) == TRUE

\* riina_state_chain (matches Coq: Definition riina_state_chain)
riina_state_chain == TRUE

\* fork_detection_valid (matches Coq: Definition fork_detection_valid)
fork_detection_valid(c) == TRUE

\* riina_fork_detection (matches Coq: Definition riina_fork_detection)
riina_fork_detection == TRUE

\* crdt_merge_valid (matches Coq: Definition crdt_merge_valid)
crdt_merge_valid(c) == TRUE

\* riina_crdt_merge (matches Coq: Definition riina_crdt_merge)
riina_crdt_merge == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* CAS_001 (matches Coq: Theorem CAS_001)
THEOREM CAS_001 == Init => TypeOK

\* CAS_002 (matches Coq: Theorem CAS_002)
THEOREM CAS_002 == Init => TypeOK

\* CAS_003 (matches Coq: Theorem CAS_003)
THEOREM CAS_003 == Init => TypeOK

\* CAS_004 (matches Coq: Theorem CAS_004)
THEOREM CAS_004 == Init => TypeOK

\* CAS_005 (matches Coq: Theorem CAS_005)
THEOREM CAS_005 == Init => TypeOK

\* CAS_006 (matches Coq: Theorem CAS_006)
THEOREM CAS_006 == Init => TypeOK

\* CAS_007 (matches Coq: Theorem CAS_007)
THEOREM CAS_007 == Init => TypeOK

\* CAS_008 (matches Coq: Theorem CAS_008)
THEOREM CAS_008 == Init => TypeOK

\* CAS_009 (matches Coq: Theorem CAS_009)
THEOREM CAS_009 == Init => TypeOK

\* CAS_010 (matches Coq: Theorem CAS_010)
THEOREM CAS_010 == Init => TypeOK

\* CAS_011 (matches Coq: Theorem CAS_011)
THEOREM CAS_011 == Init => TypeOK

\* CAS_012 (matches Coq: Theorem CAS_012)
THEOREM CAS_012 == Init => TypeOK

\* CAS_013 (matches Coq: Theorem CAS_013)
THEOREM CAS_013 == Init => TypeOK

\* CAS_014 (matches Coq: Theorem CAS_014)
THEOREM CAS_014 == Init => TypeOK

\* CAS_015 (matches Coq: Theorem CAS_015)
THEOREM CAS_015 == Init => TypeOK

\* CAS_016 (matches Coq: Theorem CAS_016)
THEOREM CAS_016 == Init => TypeOK

\* CAS_017 (matches Coq: Theorem CAS_017)
THEOREM CAS_017 == Init => TypeOK

\* CAS_018 (matches Coq: Theorem CAS_018)
THEOREM CAS_018 == Init => TypeOK

\* CAS_019 (matches Coq: Theorem CAS_019)
THEOREM CAS_019 == Init => TypeOK

\* CAS_020 (matches Coq: Theorem CAS_020)
THEOREM CAS_020 == Init => TypeOK

\* CAS_021 (matches Coq: Theorem CAS_021)
THEOREM CAS_021 == Init => TypeOK

\* CAS_022 (matches Coq: Theorem CAS_022)
THEOREM CAS_022 == Init => TypeOK

\* CAS_023 (matches Coq: Theorem CAS_023)
THEOREM CAS_023 == Init => TypeOK

\* CAS_024 (matches Coq: Theorem CAS_024)
THEOREM CAS_024 == Init => TypeOK

\* CAS_025 (matches Coq: Theorem CAS_025)
THEOREM CAS_025 == Init => TypeOK

\* CAS_026 (matches Coq: Theorem CAS_026)
THEOREM CAS_026 == Init => TypeOK

\* CAS_027 (matches Coq: Theorem CAS_027)
THEOREM CAS_027 == Init => TypeOK

\* CAS_028 (matches Coq: Theorem CAS_028)
THEOREM CAS_028 == Init => TypeOK

\* CAS_029 (matches Coq: Theorem CAS_029)
THEOREM CAS_029 == Init => TypeOK

\* CAS_030 (matches Coq: Theorem CAS_030)
THEOREM CAS_030 == Init => TypeOK

\* CAS_031 (matches Coq: Theorem CAS_031)
THEOREM CAS_031 == Init => TypeOK

\* CAS_032 (matches Coq: Theorem CAS_032)
THEOREM CAS_032 == Init => TypeOK

\* CAS_033 (matches Coq: Theorem CAS_033)
THEOREM CAS_033 == Init => TypeOK

\* CAS_034 (matches Coq: Theorem CAS_034)
THEOREM CAS_034 == Init => TypeOK

\* CAS_035 (matches Coq: Theorem CAS_035)
THEOREM CAS_035 == Init => TypeOK

\* CAS_036 (matches Coq: Theorem CAS_036)
THEOREM CAS_036 == Init => TypeOK

\* CAS_037 (matches Coq: Theorem CAS_037)
THEOREM CAS_037 == Init => TypeOK

\* CAS_038 (matches Coq: Theorem CAS_038)
THEOREM CAS_038 == Init => TypeOK

\* CAS_039 (matches Coq: Theorem CAS_039)
THEOREM CAS_039 == Init => TypeOK

\* CAS_040 (matches Coq: Theorem CAS_040)
THEOREM CAS_040 == Init => TypeOK

\* CAS_041 (matches Coq: Theorem CAS_041)
THEOREM CAS_041 == Init => TypeOK

\* CAS_042 (matches Coq: Theorem CAS_042)
THEOREM CAS_042 == Init => TypeOK

\* CAS_043 (matches Coq: Theorem CAS_043)
THEOREM CAS_043 == Init => TypeOK

\* CAS_044 (matches Coq: Theorem CAS_044)
THEOREM CAS_044 == Init => TypeOK

\* CAS_045 (matches Coq: Theorem CAS_045)
THEOREM CAS_045 == Init => TypeOK

\* CAS_046 (matches Coq: Theorem CAS_046)
THEOREM CAS_046 == Init => TypeOK

\* CAS_047 (matches Coq: Theorem CAS_047)
THEOREM CAS_047 == Init => TypeOK

\* CAS_048 (matches Coq: Theorem CAS_048)
THEOREM CAS_048 == Init => TypeOK

\* CAS_049 (matches Coq: Theorem CAS_049)
THEOREM CAS_049 == Init => TypeOK

\* CAS_050 (matches Coq: Theorem CAS_050)
THEOREM CAS_050 == Init => TypeOK

\* CAS_051 (matches Coq: Theorem CAS_051)
THEOREM CAS_051 == Init => TypeOK

\* CAS_052 (matches Coq: Theorem CAS_052)
THEOREM CAS_052 == Init => TypeOK

\* CAS_053 (matches Coq: Theorem CAS_053)
THEOREM CAS_053 == Init => TypeOK

\* CAS_054 (matches Coq: Theorem CAS_054)
THEOREM CAS_054 == Init => TypeOK

\* CAS_055 (matches Coq: Theorem CAS_055)
THEOREM CAS_055 == Init => TypeOK

\* CAS_056 (matches Coq: Theorem CAS_056)
THEOREM CAS_056 == Init => TypeOK

\* CAS_057 (matches Coq: Theorem CAS_057)
THEOREM CAS_057 == Init => TypeOK

\* CAS_058 (matches Coq: Theorem CAS_058)
THEOREM CAS_058 == Init => TypeOK

\* CAS_059 (matches Coq: Theorem CAS_059)
THEOREM CAS_059 == Init => TypeOK

\* CAS_060 (matches Coq: Theorem CAS_060)
THEOREM CAS_060 == Init => TypeOK

\* CAS_061 (matches Coq: Theorem CAS_061)
THEOREM CAS_061 == Init => TypeOK

\* CAS_062 (matches Coq: Theorem CAS_062)
THEOREM CAS_062 == Init => TypeOK

\* CAS_063 (matches Coq: Theorem CAS_063)
THEOREM CAS_063 == Init => TypeOK

\* CAS_064 (matches Coq: Theorem CAS_064)
THEOREM CAS_064 == Init => TypeOK

\* CAS_065 (matches Coq: Theorem CAS_065)
THEOREM CAS_065 == Init => TypeOK

\* CAS_066 (matches Coq: Theorem CAS_066)
THEOREM CAS_066 == Init => TypeOK

\* CAS_067 (matches Coq: Theorem CAS_067)
THEOREM CAS_067 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<cas_hash_linked, cas_append_only, cas_genesis_valid, cas_parent_exists, cas_no_orphans, cas_monotonic_sequence, cas_divergence_detected, cas_common_ancestor, cas_fork_point_identified, cas_branch_enumeration, cas_conflict_flagged, cas_idempotent, cas_commutative, cas_associative, cas_monotonic, cas_convergent, cas_conflict_free>>

\* Specification
Spec == Init /\ [][Next]_<<cas_hash_linked, cas_append_only, cas_genesis_valid, cas_parent_exists, cas_no_orphans, cas_monotonic_sequence, cas_divergence_detected, cas_common_ancestor, cas_fork_point_identified, cas_branch_enumeration, cas_conflict_flagged, cas_idempotent, cas_commutative, cas_associative, cas_monotonic, cas_convergent, cas_conflict_free>>

====
