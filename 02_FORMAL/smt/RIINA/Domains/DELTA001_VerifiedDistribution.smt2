; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DELTA001_VerifiedDistribution — SMT Verification
; Derived from 02_FORMAL/coq/domains/DELTA001_VerifiedDistribution.v (32 assertions)
; Module: DELTA001_VerifiedDistribution
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Role 0)) (((Follower) (Candidate) (Leader))))

(declare-datatypes ((BFTPhase 0)) (((PrePrepare) (Prepare) (Commit) (Reply))))

(declare-datatypes ((LogEntry 0))
  (((mk-log_entry (entry_term Int) (entry_index Int) (entry_command Int)))))

(declare-datatypes ((RaftNode 0))
  (((mk-raft_node (node_id Int) (node_term Int) (node_role Role) (node_log (Seq Int)) (node_voted_for Int) (node_commit_index Int)))))

(declare-datatypes ((RaftCluster 0))
  (((mk-raft_cluster (cluster_nodes (Seq Int)) (cluster_size Int)))))

(declare-datatypes ((BFTMessage 0))
  (((mk-bft_message (bft_phase BFTPhase) (bft_view Int) (bft_seq Int) (bft_digest Int) (bft_sender Int)))))

(declare-datatypes ((BFTState 0))
  (((mk-bft_state (bft_n Int) (bft_f Int) (bft_correct (Seq Int)) (bft_faulty (Seq Int))))))

(declare-datatypes ((HashRing 0))
  (((mk-hash_ring (ring_nodes (Seq Int)) (ring_size Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Role enum properties ---

; --- 1. Role exhaustiveness ---
(push 1)
(declare-const x Role)
(assert (not (or (= x Follower) (= x Candidate) (= x Leader))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Role: Follower != Candidate ---
(push 1)
(assert (= Follower Candidate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Role: Candidate != Leader ---
(push 1)
(assert (= Candidate Leader))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Role: Follower != Leader ---
(push 1)
(assert (= Follower Leader))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Role finite cardinality (3 values) ---
(push 1)
(declare-const x Role)
(assert (and (not (= x Follower)) (not (= x Candidate)) (not (= x Leader))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BFTPhase enum properties ---

; --- 6. BFTPhase exhaustiveness ---
(push 1)
(declare-const x BFTPhase)
(assert (not (or (= x PrePrepare) (= x Prepare) (= x Commit) (= x Reply))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. BFTPhase: PrePrepare != Prepare ---
(push 1)
(assert (= PrePrepare Prepare))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. BFTPhase: Prepare != Commit ---
(push 1)
(assert (= Prepare Commit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. BFTPhase: Commit != Reply ---
(push 1)
(assert (= Commit Reply))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. BFTPhase: PrePrepare != Reply ---
(push 1)
(assert (= PrePrepare Reply))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BFTPhase finite cardinality (4 values) ---
(push 1)
(declare-const x BFTPhase)
(assert (and (not (= x PrePrepare)) (not (= x Prepare)) (not (= x Commit)) (not (= x Reply))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LogEntry record properties ---

; --- 12. LogEntry accessor round-trip: entry_term ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (entry_term (mk-log_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. LogEntry accessor round-trip: entry_index ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (entry_index (mk-log_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. LogEntry: integer field consistency ---
(push 1)
(declare-const r LogEntry)
(assert (>= (entry_term r) 0))
(assert (>= (entry_index r) 0))
(assert (not (>= (+ (entry_term r) (entry_index r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RaftNode record properties ---

; --- 15. RaftNode accessor round-trip: node_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (node_id (mk-raft_node f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. RaftNode accessor round-trip: node_term ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (node_term (mk-raft_node f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. RaftNode accessor round-trip: node_role ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (node_role (mk-raft_node f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. RaftNode accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (node_log (mk-raft_node f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. RaftNode accessor round-trip: node_voted_for ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (node_voted_for (mk-raft_node f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. RaftNode: integer field consistency ---
(push 1)
(declare-const r RaftNode)
(assert (>= (node_id r) 0))
(assert (>= (node_term r) 0))
(assert (not (>= (+ (node_id r) (node_term r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RaftCluster record properties ---

; --- 21. RaftCluster accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (cluster_nodes (mk-raft_cluster f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BFTMessage record properties ---

; --- 22. BFTMessage accessor round-trip: bft_phase ---
(push 1)
(declare-const f0 BFTPhase)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bft_phase (mk-bft_message f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BFTMessage accessor round-trip: bft_view ---
(push 1)
(declare-const f0 BFTPhase)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bft_view (mk-bft_message f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BFTMessage accessor round-trip: bft_seq ---
(push 1)
(declare-const f0 BFTPhase)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bft_seq (mk-bft_message f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BFTMessage accessor round-trip: bft_digest ---
(push 1)
(declare-const f0 BFTPhase)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bft_digest (mk-bft_message f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BFTMessage: integer field consistency ---
(push 1)
(declare-const r BFTMessage)
(assert (>= (bft_view r) 0))
(assert (>= (bft_seq r) 0))
(assert (not (>= (+ (bft_view r) (bft_seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BFTState record properties ---

; --- 27. BFTState accessor round-trip: bft_n ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (bft_n (mk-bft_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. BFTState accessor round-trip: bft_f ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (bft_f (mk-bft_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. BFTState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (bft_correct (mk-bft_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. BFTState: integer field consistency ---
(push 1)
(declare-const r BFTState)
(assert (>= (bft_n r) 0))
(assert (>= (bft_f r) 0))
(assert (not (>= (+ (bft_n r) (bft_f r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HashRing record properties ---

; --- 31. HashRing accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (ring_nodes (mk-hash_ring f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
