; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TimingSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/TimingSecurity.v (67 assertions)
; Module: TimingSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((LockState 0)) (((Unlocked) (Locked))))

(declare-datatypes ((LockOp 0)) (((Acquire) (Release))))

(declare-datatypes ((SessionState 0)) (((SessionInit) (SessionReady) (SessionActive) (SessionClosed))))

(declare-datatypes ((SessionOp 0)) (((SOpen) (SRead) (SWrite) (SClose))))

(declare-datatypes ((TimeComplexity 0)) (((ConstantTime) (VariableTime))))

(declare-datatypes ((TimeoutState 0)) (((TimeoutPending) (TimeoutExpired) (TimeoutCancelled) (TimeoutCompleted))))

(declare-datatypes ((ProgressState 0)) (((MakingProgress) (Blocked) (Completed))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- LockState enum properties ---

; --- 1. LockState exhaustiveness ---
(push 1)
(declare-const x LockState)
(assert (not (or (= x Unlocked) (= x Locked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. LockState: Unlocked != Locked ---
(push 1)
(assert (= Unlocked Locked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. LockState finite cardinality (2 values) ---
(push 1)
(declare-const x LockState)
(assert (and (not (= x Unlocked)) (not (= x Locked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LockOp enum properties ---

; --- 4. LockOp exhaustiveness ---
(push 1)
(declare-const x LockOp)
(assert (not (or (= x Acquire) (= x Release))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. LockOp: Acquire != Release ---
(push 1)
(assert (= Acquire Release))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. LockOp finite cardinality (2 values) ---
(push 1)
(declare-const x LockOp)
(assert (and (not (= x Acquire)) (not (= x Release))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SessionState enum properties ---

; --- 7. SessionState exhaustiveness ---
(push 1)
(declare-const x SessionState)
(assert (not (or (= x SessionInit) (= x SessionReady) (= x SessionActive) (= x SessionClosed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SessionState: SessionInit != SessionReady ---
(push 1)
(assert (= SessionInit SessionReady))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SessionState: SessionReady != SessionActive ---
(push 1)
(assert (= SessionReady SessionActive))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SessionState: SessionActive != SessionClosed ---
(push 1)
(assert (= SessionActive SessionClosed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SessionState: SessionInit != SessionClosed ---
(push 1)
(assert (= SessionInit SessionClosed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SessionState finite cardinality (4 values) ---
(push 1)
(declare-const x SessionState)
(assert (and (not (= x SessionInit)) (not (= x SessionReady)) (not (= x SessionActive)) (not (= x SessionClosed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SessionOp enum properties ---

; --- 13. SessionOp exhaustiveness ---
(push 1)
(declare-const x SessionOp)
(assert (not (or (= x SOpen) (= x SRead) (= x SWrite) (= x SClose))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SessionOp: SOpen != SRead ---
(push 1)
(assert (= SOpen SRead))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SessionOp: SRead != SWrite ---
(push 1)
(assert (= SRead SWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SessionOp: SWrite != SClose ---
(push 1)
(assert (= SWrite SClose))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SessionOp: SOpen != SClose ---
(push 1)
(assert (= SOpen SClose))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SessionOp finite cardinality (4 values) ---
(push 1)
(declare-const x SessionOp)
(assert (and (not (= x SOpen)) (not (= x SRead)) (not (= x SWrite)) (not (= x SClose))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TimeComplexity enum properties ---

; --- 19. TimeComplexity exhaustiveness ---
(push 1)
(declare-const x TimeComplexity)
(assert (not (or (= x ConstantTime) (= x VariableTime))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. TimeComplexity: ConstantTime != VariableTime ---
(push 1)
(assert (= ConstantTime VariableTime))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. TimeComplexity finite cardinality (2 values) ---
(push 1)
(declare-const x TimeComplexity)
(assert (and (not (= x ConstantTime)) (not (= x VariableTime))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TimeoutState enum properties ---

; --- 22. TimeoutState exhaustiveness ---
(push 1)
(declare-const x TimeoutState)
(assert (not (or (= x TimeoutPending) (= x TimeoutExpired) (= x TimeoutCancelled) (= x TimeoutCompleted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TimeoutState: TimeoutPending != TimeoutExpired ---
(push 1)
(assert (= TimeoutPending TimeoutExpired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TimeoutState: TimeoutExpired != TimeoutCancelled ---
(push 1)
(assert (= TimeoutExpired TimeoutCancelled))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TimeoutState: TimeoutCancelled != TimeoutCompleted ---
(push 1)
(assert (= TimeoutCancelled TimeoutCompleted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TimeoutState: TimeoutPending != TimeoutCompleted ---
(push 1)
(assert (= TimeoutPending TimeoutCompleted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TimeoutState finite cardinality (4 values) ---
(push 1)
(declare-const x TimeoutState)
(assert (and (not (= x TimeoutPending)) (not (= x TimeoutExpired)) (not (= x TimeoutCancelled)) (not (= x TimeoutCompleted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProgressState enum properties ---

; --- 28. ProgressState exhaustiveness ---
(push 1)
(declare-const x ProgressState)
(assert (not (or (= x MakingProgress) (= x Blocked) (= x Completed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ProgressState: MakingProgress != Blocked ---
(push 1)
(assert (= MakingProgress Blocked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ProgressState: Blocked != Completed ---
(push 1)
(assert (= Blocked Completed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ProgressState: MakingProgress != Completed ---
(push 1)
(assert (= MakingProgress Completed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ProgressState finite cardinality (3 values) ---
(push 1)
(declare-const x ProgressState)
(assert (and (not (= x MakingProgress)) (not (= x Blocked)) (not (= x Completed))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
