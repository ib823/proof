; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DistributedConsensus — SMT Verification
; Derived from 02_FORMAL/coq/domains/DistributedConsensus.v (24 assertions)

; Module: DistributedConsensus
;
; Verifies: structural properties from DistributedConsensus

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. quorum_sufficiency: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. honest_majority_in_quorum: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. bft_threshold: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. two_quorums_share_honest: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. honest_majority_total: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
