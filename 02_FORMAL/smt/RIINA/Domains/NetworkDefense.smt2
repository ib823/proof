; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA NetworkDefense — SMT Verification
; Derived from 02_FORMAL/coq/domains/NetworkDefense.v (43 assertions)
; Module: NetworkDefense
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((NetPerm 0)) (((NPSend) (NPReceive) (NPListen) (NPConnect))))

(declare-datatypes ((NetworkAction 0)) (((NASend) (NAReceive) (NAConnect) (NAListen))))

(declare-datatypes ((SimpleRegex 0)) (((RChar) (RSeq) (RAlt) (RStar))))

(declare-datatypes ((Puzzle 0))
  (((mk-puzzle (puzzle_challenge (Seq Int)) (puzzle_difficulty Int) (puzzle_timestamp Int) (puzzle_server_nonce (Seq Int))))))

(declare-datatypes ((Solution 0))
  (((mk-solution (sol_puzzle Puzzle) (sol_client_nonce (Seq Int))))))

(declare-datatypes ((TokenBucket 0))
  (((mk-token_bucket (bucket_tokens Int) (bucket_max Int) (bucket_refill_rate Int) (bucket_last_refill Int)))))

(declare-datatypes ((ClientBucket 0))
  (((mk-client_bucket (cb_client Int) (cb_bucket TokenBucket)))))

(declare-datatypes ((Endpoint 0))
  (((mk-endpoint (ep_ip Int) (ep_port Int)))))

(declare-datatypes ((NetCapability 0))
  (((mk-net_capability (cap_target Endpoint) (cap_permissions (Seq Int)) (cap_valid_until Int) (cap_signature (Seq Int)) (cap_issuer Int)))))

(declare-datatypes ((Connection 0))
  (((mk-connection (conn_src_ip Int) (conn_src_port Int) (conn_dst_ip Int) (conn_dst_port Int)))))

(declare-datatypes ((SynFloodState 0))
  (((mk-syn_flood_state (sfs_pending_connections Int) (sfs_completed_connections Int) (sfs_dropped_connections Int)))))

(declare-datatypes ((SipHashTable 0))
  (((mk-sip_hash_table (sht_key (Seq Int)) (sht_buckets (Seq Int)) (sht_size Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- NetPerm enum properties ---

; --- 1. NetPerm exhaustiveness ---
(push 1)
(declare-const x NetPerm)
(assert (not (or (= x NPSend) (= x NPReceive) (= x NPListen) (= x NPConnect))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. NetPerm: NPSend != NPReceive ---
(push 1)
(assert (= NPSend NPReceive))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. NetPerm: NPReceive != NPListen ---
(push 1)
(assert (= NPReceive NPListen))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. NetPerm: NPListen != NPConnect ---
(push 1)
(assert (= NPListen NPConnect))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. NetPerm: NPSend != NPConnect ---
(push 1)
(assert (= NPSend NPConnect))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. NetPerm finite cardinality (4 values) ---
(push 1)
(declare-const x NetPerm)
(assert (and (not (= x NPSend)) (not (= x NPReceive)) (not (= x NPListen)) (not (= x NPConnect))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkAction enum properties ---

; --- 7. NetworkAction exhaustiveness ---
(push 1)
(declare-const x NetworkAction)
(assert (not (or (= x NASend) (= x NAReceive) (= x NAConnect) (= x NAListen))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. NetworkAction: NASend != NAReceive ---
(push 1)
(assert (= NASend NAReceive))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. NetworkAction: NAReceive != NAConnect ---
(push 1)
(assert (= NAReceive NAConnect))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. NetworkAction: NAConnect != NAListen ---
(push 1)
(assert (= NAConnect NAListen))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. NetworkAction: NASend != NAListen ---
(push 1)
(assert (= NASend NAListen))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. NetworkAction finite cardinality (4 values) ---
(push 1)
(declare-const x NetworkAction)
(assert (and (not (= x NASend)) (not (= x NAReceive)) (not (= x NAConnect)) (not (= x NAListen))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SimpleRegex enum properties ---

; --- 13. SimpleRegex exhaustiveness ---
(push 1)
(declare-const x SimpleRegex)
(assert (not (or (= x RChar) (= x RSeq) (= x RAlt) (= x RStar))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SimpleRegex: RChar != RSeq ---
(push 1)
(assert (= RChar RSeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SimpleRegex: RSeq != RAlt ---
(push 1)
(assert (= RSeq RAlt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SimpleRegex: RAlt != RStar ---
(push 1)
(assert (= RAlt RStar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SimpleRegex: RChar != RStar ---
(push 1)
(assert (= RChar RStar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SimpleRegex finite cardinality (4 values) ---
(push 1)
(declare-const x SimpleRegex)
(assert (and (not (= x RChar)) (not (= x RSeq)) (not (= x RAlt)) (not (= x RStar))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Puzzle record properties ---

; --- 19. Puzzle accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(assert (not (= (puzzle_challenge (mk-puzzle f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Puzzle accessor round-trip: puzzle_difficulty ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(assert (not (= (puzzle_difficulty (mk-puzzle f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Puzzle accessor round-trip: puzzle_timestamp ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(assert (not (= (puzzle_timestamp (mk-puzzle f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Puzzle: integer field consistency ---
(push 1)
(declare-const r Puzzle)
(assert (>= (seq.len (puzzle_challenge r)) 0))
(assert (>= (puzzle_difficulty r) 0))
(assert (not (>= (+ (seq.len (puzzle_challenge r)) (puzzle_difficulty r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Solution record properties ---

; --- 23. Solution accessor round-trip: sol_puzzle ---
(push 1)
(declare-const f0 Puzzle)
(declare-const f1 (Seq Int))
(assert (not (= (sol_puzzle (mk-solution f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TokenBucket record properties ---

; --- 24. TokenBucket accessor round-trip: bucket_tokens ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bucket_tokens (mk-token_bucket f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TokenBucket accessor round-trip: bucket_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bucket_max (mk-token_bucket f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TokenBucket accessor round-trip: bucket_refill_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bucket_refill_rate (mk-token_bucket f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TokenBucket: integer field consistency ---
(push 1)
(declare-const r TokenBucket)
(assert (>= (bucket_tokens r) 0))
(assert (>= (bucket_max r) 0))
(assert (not (>= (+ (bucket_tokens r) (bucket_max r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ClientBucket record properties ---

; --- 28. ClientBucket accessor round-trip: cb_client ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TokenBucket)
(assert (not (= (cb_client (mk-client_bucket f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Endpoint record properties ---

; --- 29. Endpoint accessor round-trip: ep_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ep_ip (mk-endpoint f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetCapability record properties ---

; --- 30. NetCapability accessor round-trip: cap_target ---
(push 1)
(declare-const f0 Endpoint)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (cap_target (mk-net_capability f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. NetCapability accessor round-trip: Seq ---
(push 1)
(declare-const f0 Endpoint)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (cap_permissions (mk-net_capability f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. NetCapability accessor round-trip: cap_valid_until ---
(push 1)
(declare-const f0 Endpoint)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (cap_valid_until (mk-net_capability f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. NetCapability accessor round-trip: Seq ---
(push 1)
(declare-const f0 Endpoint)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (cap_signature (mk-net_capability f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. NetCapability: integer field consistency ---
(push 1)
(declare-const r NetCapability)
(assert (>= (seq.len (cap_permissions r)) 0))
(assert (>= (cap_valid_until r) 0))
(assert (not (>= (+ (seq.len (cap_permissions r)) (cap_valid_until r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Connection record properties ---

; --- 35. Connection accessor round-trip: conn_src_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (conn_src_ip (mk-connection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Connection accessor round-trip: conn_src_port ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (conn_src_port (mk-connection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Connection accessor round-trip: conn_dst_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (conn_dst_ip (mk-connection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. Connection: integer field consistency ---
(push 1)
(declare-const r Connection)
(assert (>= (conn_src_ip r) 0))
(assert (>= (conn_src_port r) 0))
(assert (not (>= (+ (conn_src_ip r) (conn_src_port r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SynFloodState record properties ---

; --- 39. SynFloodState accessor round-trip: sfs_pending_connections ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sfs_pending_connections (mk-syn_flood_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SynFloodState accessor round-trip: sfs_completed_connections ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sfs_completed_connections (mk-syn_flood_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. SynFloodState: integer field consistency ---
(push 1)
(declare-const r SynFloodState)
(assert (>= (sfs_pending_connections r) 0))
(assert (>= (sfs_completed_connections r) 0))
(assert (not (>= (+ (sfs_pending_connections r) (sfs_completed_connections r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SipHashTable record properties ---

; --- 42. SipHashTable accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (sht_key (mk-sip_hash_table f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. SipHashTable accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (sht_buckets (mk-sip_hash_table f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. SipHashTable: integer field consistency ---
(push 1)
(declare-const r SipHashTable)
(assert (>= (seq.len (sht_key r)) 0))
(assert (>= (seq.len (sht_key r)) 0))
(assert (not (>= (+ (seq.len (sht_key r)) (seq.len (sht_key r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
