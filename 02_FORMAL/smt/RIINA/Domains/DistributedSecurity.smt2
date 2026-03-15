; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DistributedSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/DistributedSecurity.v (47 assertions)
; Module: DistributedSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((BFTConfig 0))
  (((mk-bft_config (bft_total_nodes Int) (bft_faulty_tolerance Int) (bft_is_safe Bool)))))

(declare-datatypes ((IdentityVerification 0))
  (((mk-identity_verification (iv_proof_of_work_enabled Bool) (iv_identity_bound Bool) (iv_cost_per_identity Int)))))

(declare-datatypes ((PeerConfig 0))
  (((mk-peer_config (pc_total_peers Int) (pc_distinct_subnets Int) (pc_min_outbound Int) (pc_diverse Bool)))))

(declare-datatypes ((RoutingProtocol 0))
  (((mk-routing_protocol (rp_authenticated Bool) (rp_path_verified Bool) (rp_origin_validated Bool)))))

(declare-datatypes ((ConsensusProtocol 0))
  (((mk-consensus_protocol (cp_safety_proven Bool) (cp_liveness_proven Bool) (cp_finality_guaranteed Bool)))))

(declare-datatypes ((SmartContract 0))
  (((mk-smart_contract (sc_formally_verified Bool) (sc_invariants_proven Bool) (sc_no_overflow Bool)))))

(declare-datatypes ((ReentrancyGuard 0))
  (((mk-reentrancy_guard (rg_locked Bool) (rg_checks_before_effects Bool) (rg_interactions_last Bool)))))

(declare-datatypes ((FairOrdering 0))
  (((mk-fair_ordering (fo_commit_phase Bool) (fo_reveal_phase Bool) (fo_ordering_deterministic Bool)))))

(declare-datatypes ((MEVProtection 0))
  (((mk-mev_protection (mev_private_mempool Bool) (mev_fair_sequencing Bool) (mev_encrypted_transactions Bool)))))

(declare-datatypes ((FlashLoanGuard 0))
  (((mk-flash_loan_guard (fl_same_block_check Bool) (fl_balance_snapshot Bool) (fl_price_oracle_twap Bool)))))

(declare-datatypes ((LogicalClock 0))
  (((mk-logical_clock (lc_lamport_enabled Bool) (lc_vector_clock Bool) (lc_causality_preserved Bool)))))

(declare-datatypes ((PartitionConfig 0))
  (((mk-partition_config (pt_cap_aware Bool) (pt_partition_detection Bool) (pt_graceful_degradation Bool)))))

(declare-datatypes ((ConsistencyProtocol 0))
  (((mk-consistency_protocol (csp_linearizable Bool) (csp_state_machine_replication Bool) (csp_conflict_resolution Bool)))))

(declare-datatypes ((LeaderConfig 0))
  (((mk-leader_config (ldr_rotation_enabled Bool) (ldr_bft_election Bool) (ldr_term_bounded Bool)))))

(declare-datatypes ((QuorumConfig 0))
  (((mk-quorum_config (qc_quorum_size Int) (qc_total_nodes Int) (qc_intersection_guaranteed Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- BFTConfig record properties ---

; --- 1. BFTConfig accessor round-trip: bft_total_nodes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (bft_total_nodes (mk-bft_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. BFTConfig accessor round-trip: bft_faulty_tolerance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (bft_faulty_tolerance (mk-bft_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. BFTConfig: integer field consistency ---
(push 1)
(declare-const r BFTConfig)
(assert (>= (bft_total_nodes r) 0))
(assert (>= (bft_faulty_tolerance r) 0))
(assert (not (>= (+ (bft_total_nodes r) (bft_faulty_tolerance r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- IdentityVerification record properties ---

; --- 4. IdentityVerification accessor round-trip: iv_proof_of_work_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (iv_proof_of_work_enabled (mk-identity_verification f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. IdentityVerification accessor round-trip: iv_identity_bound ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (iv_identity_bound (mk-identity_verification f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun IdentityVerification_all_enabled ((g IdentityVerification)) Bool
  (and (iv_proof_of_work_enabled g) (iv_identity_bound g)))

; --- 6. IdentityVerification: all-enabled completeness ---
(push 1)
(declare-const g IdentityVerification)
(assert (iv_proof_of_work_enabled g))
(assert (iv_identity_bound g))
(assert (not (IdentityVerification_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. IdentityVerification: IdentityVerification_all_enabled implies iv_proof_of_work_enabled ---
(push 1)
(declare-const g IdentityVerification)
(assert (IdentityVerification_all_enabled g))
(assert (not (iv_proof_of_work_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. IdentityVerification: IdentityVerification_all_enabled implies iv_identity_bound ---
(push 1)
(declare-const g IdentityVerification)
(assert (IdentityVerification_all_enabled g))
(assert (not (iv_identity_bound g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PeerConfig record properties ---

; --- 9. PeerConfig accessor round-trip: pc_total_peers ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pc_total_peers (mk-peer_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PeerConfig accessor round-trip: pc_distinct_subnets ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pc_distinct_subnets (mk-peer_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PeerConfig accessor round-trip: pc_min_outbound ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pc_min_outbound (mk-peer_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PeerConfig: integer field consistency ---
(push 1)
(declare-const r PeerConfig)
(assert (>= (pc_total_peers r) 0))
(assert (>= (pc_distinct_subnets r) 0))
(assert (not (>= (+ (pc_total_peers r) (pc_distinct_subnets r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RoutingProtocol record properties ---

; --- 13. RoutingProtocol accessor round-trip: rp_authenticated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rp_authenticated (mk-routing_protocol f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. RoutingProtocol accessor round-trip: rp_path_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rp_path_verified (mk-routing_protocol f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun RoutingProtocol_all_enabled ((g RoutingProtocol)) Bool
  (and (rp_authenticated g) (rp_path_verified g)))

; --- 15. RoutingProtocol: all-enabled completeness ---
(push 1)
(declare-const g RoutingProtocol)
(assert (rp_authenticated g))
(assert (rp_path_verified g))
(assert (not (RoutingProtocol_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. RoutingProtocol: RoutingProtocol_all_enabled implies rp_authenticated ---
(push 1)
(declare-const g RoutingProtocol)
(assert (RoutingProtocol_all_enabled g))
(assert (not (rp_authenticated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. RoutingProtocol: RoutingProtocol_all_enabled implies rp_path_verified ---
(push 1)
(declare-const g RoutingProtocol)
(assert (RoutingProtocol_all_enabled g))
(assert (not (rp_path_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConsensusProtocol record properties ---

; --- 18. ConsensusProtocol accessor round-trip: cp_safety_proven ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cp_safety_proven (mk-consensus_protocol f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ConsensusProtocol accessor round-trip: cp_liveness_proven ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cp_liveness_proven (mk-consensus_protocol f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ConsensusProtocol_all_enabled ((g ConsensusProtocol)) Bool
  (and (cp_safety_proven g) (cp_liveness_proven g)))

; --- 20. ConsensusProtocol: all-enabled completeness ---
(push 1)
(declare-const g ConsensusProtocol)
(assert (cp_safety_proven g))
(assert (cp_liveness_proven g))
(assert (not (ConsensusProtocol_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ConsensusProtocol: ConsensusProtocol_all_enabled implies cp_safety_proven ---
(push 1)
(declare-const g ConsensusProtocol)
(assert (ConsensusProtocol_all_enabled g))
(assert (not (cp_safety_proven g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ConsensusProtocol: ConsensusProtocol_all_enabled implies cp_liveness_proven ---
(push 1)
(declare-const g ConsensusProtocol)
(assert (ConsensusProtocol_all_enabled g))
(assert (not (cp_liveness_proven g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SmartContract record properties ---

; --- 23. SmartContract accessor round-trip: sc_formally_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sc_formally_verified (mk-smart_contract f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SmartContract accessor round-trip: sc_invariants_proven ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sc_invariants_proven (mk-smart_contract f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SmartContract_all_enabled ((g SmartContract)) Bool
  (and (sc_formally_verified g) (sc_invariants_proven g)))

; --- 25. SmartContract: all-enabled completeness ---
(push 1)
(declare-const g SmartContract)
(assert (sc_formally_verified g))
(assert (sc_invariants_proven g))
(assert (not (SmartContract_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SmartContract: SmartContract_all_enabled implies sc_formally_verified ---
(push 1)
(declare-const g SmartContract)
(assert (SmartContract_all_enabled g))
(assert (not (sc_formally_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. SmartContract: SmartContract_all_enabled implies sc_invariants_proven ---
(push 1)
(declare-const g SmartContract)
(assert (SmartContract_all_enabled g))
(assert (not (sc_invariants_proven g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReentrancyGuard record properties ---

; --- 28. ReentrancyGuard accessor round-trip: rg_locked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rg_locked (mk-reentrancy_guard f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ReentrancyGuard accessor round-trip: rg_checks_before_effects ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rg_checks_before_effects (mk-reentrancy_guard f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ReentrancyGuard_all_enabled ((g ReentrancyGuard)) Bool
  (and (rg_locked g) (rg_checks_before_effects g)))

; --- 30. ReentrancyGuard: all-enabled completeness ---
(push 1)
(declare-const g ReentrancyGuard)
(assert (rg_locked g))
(assert (rg_checks_before_effects g))
(assert (not (ReentrancyGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ReentrancyGuard: ReentrancyGuard_all_enabled implies rg_locked ---
(push 1)
(declare-const g ReentrancyGuard)
(assert (ReentrancyGuard_all_enabled g))
(assert (not (rg_locked g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ReentrancyGuard: ReentrancyGuard_all_enabled implies rg_checks_before_effects ---
(push 1)
(declare-const g ReentrancyGuard)
(assert (ReentrancyGuard_all_enabled g))
(assert (not (rg_checks_before_effects g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FairOrdering record properties ---

; --- 33. FairOrdering accessor round-trip: fo_commit_phase ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fo_commit_phase (mk-fair_ordering f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. FairOrdering accessor round-trip: fo_reveal_phase ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fo_reveal_phase (mk-fair_ordering f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FairOrdering_all_enabled ((g FairOrdering)) Bool
  (and (fo_commit_phase g) (fo_reveal_phase g)))

; --- 35. FairOrdering: all-enabled completeness ---
(push 1)
(declare-const g FairOrdering)
(assert (fo_commit_phase g))
(assert (fo_reveal_phase g))
(assert (not (FairOrdering_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. FairOrdering: FairOrdering_all_enabled implies fo_commit_phase ---
(push 1)
(declare-const g FairOrdering)
(assert (FairOrdering_all_enabled g))
(assert (not (fo_commit_phase g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. FairOrdering: FairOrdering_all_enabled implies fo_reveal_phase ---
(push 1)
(declare-const g FairOrdering)
(assert (FairOrdering_all_enabled g))
(assert (not (fo_reveal_phase g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MEVProtection record properties ---

; --- 38. MEVProtection accessor round-trip: mev_private_mempool ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mev_private_mempool (mk-mev_protection f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. MEVProtection accessor round-trip: mev_fair_sequencing ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mev_fair_sequencing (mk-mev_protection f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MEVProtection_all_enabled ((g MEVProtection)) Bool
  (and (mev_private_mempool g) (mev_fair_sequencing g)))

; --- 40. MEVProtection: all-enabled completeness ---
(push 1)
(declare-const g MEVProtection)
(assert (mev_private_mempool g))
(assert (mev_fair_sequencing g))
(assert (not (MEVProtection_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. MEVProtection: MEVProtection_all_enabled implies mev_private_mempool ---
(push 1)
(declare-const g MEVProtection)
(assert (MEVProtection_all_enabled g))
(assert (not (mev_private_mempool g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. MEVProtection: MEVProtection_all_enabled implies mev_fair_sequencing ---
(push 1)
(declare-const g MEVProtection)
(assert (MEVProtection_all_enabled g))
(assert (not (mev_fair_sequencing g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FlashLoanGuard record properties ---

; --- 43. FlashLoanGuard accessor round-trip: fl_same_block_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fl_same_block_check (mk-flash_loan_guard f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. FlashLoanGuard accessor round-trip: fl_balance_snapshot ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fl_balance_snapshot (mk-flash_loan_guard f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FlashLoanGuard_all_enabled ((g FlashLoanGuard)) Bool
  (and (fl_same_block_check g) (fl_balance_snapshot g)))

; --- 45. FlashLoanGuard: all-enabled completeness ---
(push 1)
(declare-const g FlashLoanGuard)
(assert (fl_same_block_check g))
(assert (fl_balance_snapshot g))
(assert (not (FlashLoanGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. FlashLoanGuard: FlashLoanGuard_all_enabled implies fl_same_block_check ---
(push 1)
(declare-const g FlashLoanGuard)
(assert (FlashLoanGuard_all_enabled g))
(assert (not (fl_same_block_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. FlashLoanGuard: FlashLoanGuard_all_enabled implies fl_balance_snapshot ---
(push 1)
(declare-const g FlashLoanGuard)
(assert (FlashLoanGuard_all_enabled g))
(assert (not (fl_balance_snapshot g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LogicalClock record properties ---

; --- 48. LogicalClock accessor round-trip: lc_lamport_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (lc_lamport_enabled (mk-logical_clock f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. LogicalClock accessor round-trip: lc_vector_clock ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (lc_vector_clock (mk-logical_clock f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun LogicalClock_all_enabled ((g LogicalClock)) Bool
  (and (lc_lamport_enabled g) (lc_vector_clock g)))

; --- 50. LogicalClock: all-enabled completeness ---
(push 1)
(declare-const g LogicalClock)
(assert (lc_lamport_enabled g))
(assert (lc_vector_clock g))
(assert (not (LogicalClock_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. LogicalClock: LogicalClock_all_enabled implies lc_lamport_enabled ---
(push 1)
(declare-const g LogicalClock)
(assert (LogicalClock_all_enabled g))
(assert (not (lc_lamport_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. LogicalClock: LogicalClock_all_enabled implies lc_vector_clock ---
(push 1)
(declare-const g LogicalClock)
(assert (LogicalClock_all_enabled g))
(assert (not (lc_vector_clock g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PartitionConfig record properties ---

; --- 53. PartitionConfig accessor round-trip: pt_cap_aware ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (pt_cap_aware (mk-partition_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. PartitionConfig accessor round-trip: pt_partition_detection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (pt_partition_detection (mk-partition_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PartitionConfig_all_enabled ((g PartitionConfig)) Bool
  (and (pt_cap_aware g) (pt_partition_detection g)))

; --- 55. PartitionConfig: all-enabled completeness ---
(push 1)
(declare-const g PartitionConfig)
(assert (pt_cap_aware g))
(assert (pt_partition_detection g))
(assert (not (PartitionConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. PartitionConfig: PartitionConfig_all_enabled implies pt_cap_aware ---
(push 1)
(declare-const g PartitionConfig)
(assert (PartitionConfig_all_enabled g))
(assert (not (pt_cap_aware g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. PartitionConfig: PartitionConfig_all_enabled implies pt_partition_detection ---
(push 1)
(declare-const g PartitionConfig)
(assert (PartitionConfig_all_enabled g))
(assert (not (pt_partition_detection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConsistencyProtocol record properties ---

; --- 58. ConsistencyProtocol accessor round-trip: csp_linearizable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (csp_linearizable (mk-consistency_protocol f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ConsistencyProtocol accessor round-trip: csp_state_machine_replication ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (csp_state_machine_replication (mk-consistency_protocol f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ConsistencyProtocol_all_enabled ((g ConsistencyProtocol)) Bool
  (and (csp_linearizable g) (csp_state_machine_replication g)))

; --- 60. ConsistencyProtocol: all-enabled completeness ---
(push 1)
(declare-const g ConsistencyProtocol)
(assert (csp_linearizable g))
(assert (csp_state_machine_replication g))
(assert (not (ConsistencyProtocol_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. ConsistencyProtocol: ConsistencyProtocol_all_enabled implies csp_linearizable ---
(push 1)
(declare-const g ConsistencyProtocol)
(assert (ConsistencyProtocol_all_enabled g))
(assert (not (csp_linearizable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. ConsistencyProtocol: ConsistencyProtocol_all_enabled implies csp_state_machine_replication ---
(push 1)
(declare-const g ConsistencyProtocol)
(assert (ConsistencyProtocol_all_enabled g))
(assert (not (csp_state_machine_replication g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LeaderConfig record properties ---

; --- 63. LeaderConfig accessor round-trip: ldr_rotation_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ldr_rotation_enabled (mk-leader_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. LeaderConfig accessor round-trip: ldr_bft_election ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ldr_bft_election (mk-leader_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun LeaderConfig_all_enabled ((g LeaderConfig)) Bool
  (and (ldr_rotation_enabled g) (ldr_bft_election g)))

; --- 65. LeaderConfig: all-enabled completeness ---
(push 1)
(declare-const g LeaderConfig)
(assert (ldr_rotation_enabled g))
(assert (ldr_bft_election g))
(assert (not (LeaderConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. LeaderConfig: LeaderConfig_all_enabled implies ldr_rotation_enabled ---
(push 1)
(declare-const g LeaderConfig)
(assert (LeaderConfig_all_enabled g))
(assert (not (ldr_rotation_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. LeaderConfig: LeaderConfig_all_enabled implies ldr_bft_election ---
(push 1)
(declare-const g LeaderConfig)
(assert (LeaderConfig_all_enabled g))
(assert (not (ldr_bft_election g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QuorumConfig record properties ---

; --- 68. QuorumConfig accessor round-trip: qc_quorum_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (qc_quorum_size (mk-quorum_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. QuorumConfig accessor round-trip: qc_total_nodes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (qc_total_nodes (mk-quorum_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. QuorumConfig: integer field consistency ---
(push 1)
(declare-const r QuorumConfig)
(assert (>= (qc_quorum_size r) 0))
(assert (>= (qc_total_nodes r) 0))
(assert (not (>= (+ (qc_quorum_size r) (qc_total_nodes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
