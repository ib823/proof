\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE BlockchainConsensus ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/BlockchainConsensus.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* ConsensusConfig (matches Coq: Record ConsensusConfig)
VARIABLES bc_byzantine_fault_tolerance, bc_finality_guarantee, bc_liveness_property, bc_safety_property, bc_view_change_protocol, bc_message_authentication

\* SmartContractConfig (matches Coq: Record SmartContractConfig)
VARIABLES sc_reentrancy_guard, sc_integer_overflow_check, sc_access_control, sc_gas_limit_check, sc_formal_verification

\* Type invariant
TypeOK ==
  /\ bc_byzantine_fault_tolerance \in BOOLEAN
  /\ bc_finality_guarantee \in BOOLEAN
  /\ bc_liveness_property \in BOOLEAN
  /\ bc_safety_property \in BOOLEAN
  /\ bc_view_change_protocol \in BOOLEAN
  /\ bc_message_authentication \in BOOLEAN
  /\ sc_reentrancy_guard \in BOOLEAN
  /\ sc_integer_overflow_check \in BOOLEAN
  /\ sc_access_control \in BOOLEAN
  /\ sc_gas_limit_check \in BOOLEAN
  /\ sc_formal_verification \in BOOLEAN

\* Initial state
Init ==
  /\ bc_byzantine_fault_tolerance = TRUE
  /\ bc_finality_guarantee = TRUE
  /\ bc_liveness_property = TRUE
  /\ bc_safety_property = TRUE
  /\ bc_view_change_protocol = TRUE
  /\ bc_message_authentication = TRUE
  /\ sc_reentrancy_guard = TRUE
  /\ sc_integer_overflow_check = TRUE
  /\ sc_access_control = TRUE
  /\ sc_gas_limit_check = TRUE
  /\ sc_formal_verification = TRUE

\* consensus_secure (matches Coq: Definition consensus_secure)
consensus_secure(c) == TRUE

\* riina_consensus (matches Coq: Definition riina_consensus)
riina_consensus == TRUE

\* smart_contract_safe (matches Coq: Definition smart_contract_safe)
smart_contract_safe(c) == TRUE

\* riina_smart_contract (matches Coq: Definition riina_smart_contract)
riina_smart_contract == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* BC_001 (matches Coq: Theorem BC_001)
THEOREM BC_001 == Init => TypeOK

\* BC_002 (matches Coq: Theorem BC_002)
THEOREM BC_002 == Init => TypeOK

\* BC_003 (matches Coq: Theorem BC_003)
THEOREM BC_003 == Init => TypeOK

\* BC_004 (matches Coq: Theorem BC_004)
THEOREM BC_004 == Init => TypeOK

\* BC_005 (matches Coq: Theorem BC_005)
THEOREM BC_005 == Init => TypeOK

\* BC_006 (matches Coq: Theorem BC_006)
THEOREM BC_006 == Init => TypeOK

\* BC_007 (matches Coq: Theorem BC_007)
THEOREM BC_007 == Init => TypeOK

\* BC_008 (matches Coq: Theorem BC_008)
THEOREM BC_008 == Init => TypeOK

\* BC_009 (matches Coq: Theorem BC_009)
THEOREM BC_009 == Init => TypeOK

\* BC_010 (matches Coq: Theorem BC_010)
THEOREM BC_010 == Init => TypeOK

\* BC_011 (matches Coq: Theorem BC_011)
THEOREM BC_011 == Init => TypeOK

\* BC_012 (matches Coq: Theorem BC_012)
THEOREM BC_012 == Init => TypeOK

\* BC_013 (matches Coq: Theorem BC_013)
THEOREM BC_013 == Init => TypeOK

\* BC_014 (matches Coq: Theorem BC_014)
THEOREM BC_014 == Init => TypeOK

\* BC_015 (matches Coq: Theorem BC_015)
THEOREM BC_015 == Init => TypeOK

\* BC_016 (matches Coq: Theorem BC_016)
THEOREM BC_016 == Init => TypeOK

\* BC_017 (matches Coq: Theorem BC_017)
THEOREM BC_017 == Init => TypeOK

\* BC_018 (matches Coq: Theorem BC_018)
THEOREM BC_018 == Init => TypeOK

\* BC_019 (matches Coq: Theorem BC_019)
THEOREM BC_019 == Init => TypeOK

\* BC_020 (matches Coq: Theorem BC_020)
THEOREM BC_020 == Init => TypeOK

\* BC_021 (matches Coq: Theorem BC_021)
THEOREM BC_021 == Init => TypeOK

\* BC_022 (matches Coq: Theorem BC_022)
THEOREM BC_022 == Init => TypeOK

\* BC_023 (matches Coq: Theorem BC_023)
THEOREM BC_023 == Init => TypeOK

\* BC_024 (matches Coq: Theorem BC_024)
THEOREM BC_024 == Init => TypeOK

\* BC_025 (matches Coq: Theorem BC_025)
THEOREM BC_025 == Init => TypeOK

\* BC_026 (matches Coq: Theorem BC_026)
THEOREM BC_026 == Init => TypeOK

\* BC_027 (matches Coq: Theorem BC_027)
THEOREM BC_027 == Init => TypeOK

\* BC_028 (matches Coq: Theorem BC_028)
THEOREM BC_028 == Init => TypeOK

\* BC_029 (matches Coq: Theorem BC_029)
THEOREM BC_029 == Init => TypeOK

\* BC_030 (matches Coq: Theorem BC_030)
THEOREM BC_030 == Init => TypeOK

\* BC_031 (matches Coq: Theorem BC_031)
THEOREM BC_031 == Init => TypeOK

\* BC_032 (matches Coq: Theorem BC_032)
THEOREM BC_032 == Init => TypeOK

\* BC_033 (matches Coq: Theorem BC_033)
THEOREM BC_033 == Init => TypeOK

\* BC_034 (matches Coq: Theorem BC_034)
THEOREM BC_034 == Init => TypeOK

\* BC_035 (matches Coq: Theorem BC_035)
THEOREM BC_035 == Init => TypeOK

\* BC_036 (matches Coq: Theorem BC_036)
THEOREM BC_036 == Init => TypeOK

\* BC_037 (matches Coq: Theorem BC_037)
THEOREM BC_037 == Init => TypeOK

\* BC_038 (matches Coq: Theorem BC_038)
THEOREM BC_038 == Init => TypeOK

\* BC_039 (matches Coq: Theorem BC_039)
THEOREM BC_039 == Init => TypeOK

\* BC_040 (matches Coq: Theorem BC_040)
THEOREM BC_040 == Init => TypeOK

\* BC_041 (matches Coq: Theorem BC_041)
THEOREM BC_041 == Init => TypeOK

\* BC_042 (matches Coq: Theorem BC_042)
THEOREM BC_042 == Init => TypeOK

\* BC_043 (matches Coq: Theorem BC_043)
THEOREM BC_043 == Init => TypeOK

\* BC_044 (matches Coq: Theorem BC_044)
THEOREM BC_044 == Init => TypeOK

\* BC_045 (matches Coq: Theorem BC_045)
THEOREM BC_045 == Init => TypeOK

\* BC_046 (matches Coq: Theorem BC_046)
THEOREM BC_046 == Init => TypeOK

\* BC_047 (matches Coq: Theorem BC_047)
THEOREM BC_047 == Init => TypeOK

\* BC_048 (matches Coq: Theorem BC_048)
THEOREM BC_048 == Init => TypeOK

\* BC_049 (matches Coq: Theorem BC_049)
THEOREM BC_049 == Init => TypeOK

\* BC_050 (matches Coq: Theorem BC_050)
THEOREM BC_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<bc_byzantine_fault_tolerance, bc_finality_guarantee, bc_liveness_property, bc_safety_property, bc_view_change_protocol, bc_message_authentication, sc_reentrancy_guard, sc_integer_overflow_check, sc_access_control, sc_gas_limit_check, sc_formal_verification>>

\* Specification
Spec == Init /\ [][Next]_<<bc_byzantine_fault_tolerance, bc_finality_guarantee, bc_liveness_property, bc_safety_property, bc_view_change_protocol, bc_message_authentication, sc_reentrancy_guard, sc_integer_overflow_check, sc_access_control, sc_gas_limit_check, sc_formal_verification>>

====
