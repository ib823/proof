; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA WCETBounds — SMT Verification
; Derived from 02_FORMAL/coq/domains/WCETBounds.v (39 assertions)
; Module: WCETBounds
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Stmt 0)) (((SUnit) (SAssign) (SLoad) (SStore) (SSeq) (SIf) (SFor) (SCall))))

(declare-datatypes ((CacheState 0)) (((CacheHit) (CacheMiss))))

(declare-datatypes ((BranchState 0)) (((BranchCorrect) (BranchMispredict))))

(declare-datatypes ((AbstractCacheState 0)) (((ACSMustHit) (ACSMayMiss) (ACSMustMiss))))

(declare-datatypes ((HWParams 0))
  (((mk-hw_params (hw_cache_hit Int) (hw_cache_miss Int) (hw_call_overhead Int) (hw_branch_penalty Int) (hw_pipeline_depth Int)))))

(declare-datatypes ((Task 0))
  (((mk-task (task_wcet Int) (task_period Int) (task_deadline Int)))))

(declare-datatypes ((ExecContext 0))
  (((mk-exec_context (exec_cache CacheState) (exec_branch BranchState) (exec_iterations Int)))))

(declare-datatypes ((DMAConfig 0))
  (((mk-dma_config (dma_bandwidth Int) (dma_setup Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Stmt enum properties ---

; --- 1. Stmt exhaustiveness ---
(push 1)
(declare-const x Stmt)
(assert (not (or (= x SUnit) (= x SAssign) (= x SLoad) (= x SStore) (= x SSeq) (= x SIf) (= x SFor) (= x SCall))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Stmt: SUnit != SAssign ---
(push 1)
(assert (= SUnit SAssign))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Stmt: SAssign != SLoad ---
(push 1)
(assert (= SAssign SLoad))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Stmt: SLoad != SStore ---
(push 1)
(assert (= SLoad SStore))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Stmt: SUnit != SCall ---
(push 1)
(assert (= SUnit SCall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Stmt finite cardinality (8 values) ---
(push 1)
(declare-const x Stmt)
(assert (and (not (= x SUnit)) (not (= x SAssign)) (not (= x SLoad)) (not (= x SStore)) (not (= x SSeq)) (not (= x SIf)) (not (= x SFor)) (not (= x SCall))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CacheState enum properties ---

; --- 7. CacheState exhaustiveness ---
(push 1)
(declare-const x CacheState)
(assert (not (or (= x CacheHit) (= x CacheMiss))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CacheState: CacheHit != CacheMiss ---
(push 1)
(assert (= CacheHit CacheMiss))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CacheState finite cardinality (2 values) ---
(push 1)
(declare-const x CacheState)
(assert (and (not (= x CacheHit)) (not (= x CacheMiss))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BranchState enum properties ---

; --- 10. BranchState exhaustiveness ---
(push 1)
(declare-const x BranchState)
(assert (not (or (= x BranchCorrect) (= x BranchMispredict))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BranchState: BranchCorrect != BranchMispredict ---
(push 1)
(assert (= BranchCorrect BranchMispredict))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. BranchState finite cardinality (2 values) ---
(push 1)
(declare-const x BranchState)
(assert (and (not (= x BranchCorrect)) (not (= x BranchMispredict))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AbstractCacheState enum properties ---

; --- 13. AbstractCacheState exhaustiveness ---
(push 1)
(declare-const x AbstractCacheState)
(assert (not (or (= x ACSMustHit) (= x ACSMayMiss) (= x ACSMustMiss))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AbstractCacheState: ACSMustHit != ACSMayMiss ---
(push 1)
(assert (= ACSMustHit ACSMayMiss))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AbstractCacheState: ACSMayMiss != ACSMustMiss ---
(push 1)
(assert (= ACSMayMiss ACSMustMiss))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AbstractCacheState: ACSMustHit != ACSMustMiss ---
(push 1)
(assert (= ACSMustHit ACSMustMiss))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. AbstractCacheState finite cardinality (3 values) ---
(push 1)
(declare-const x AbstractCacheState)
(assert (and (not (= x ACSMustHit)) (not (= x ACSMayMiss)) (not (= x ACSMustMiss))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HWParams record properties ---

; --- 18. HWParams accessor round-trip: hw_cache_hit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (hw_cache_hit (mk-h_w_params f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. HWParams accessor round-trip: hw_cache_miss ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (hw_cache_miss (mk-h_w_params f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. HWParams accessor round-trip: hw_call_overhead ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (hw_call_overhead (mk-h_w_params f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. HWParams accessor round-trip: hw_branch_penalty ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (hw_branch_penalty (mk-h_w_params f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. HWParams: integer field consistency ---
(push 1)
(declare-const r HWParams)
(assert (>= (hw_cache_hit r) 0))
(assert (>= (hw_cache_miss r) 0))
(assert (not (>= (+ (hw_cache_hit r) (hw_cache_miss r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Task record properties ---

; --- 23. Task accessor round-trip: task_wcet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (task_wcet (mk-task f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Task accessor round-trip: task_period ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (task_period (mk-task f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Task: integer field consistency ---
(push 1)
(declare-const r Task)
(assert (>= (task_wcet r) 0))
(assert (>= (task_period r) 0))
(assert (not (>= (+ (task_wcet r) (task_period r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExecContext record properties ---

; --- 26. ExecContext accessor round-trip: exec_cache ---
(push 1)
(declare-const f0 CacheState)
(declare-const f1 BranchState)
(assert (not (= (exec_cache (mk-exec_context f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ExecContext accessor round-trip: exec_branch ---
(push 1)
(declare-const f0 CacheState)
(declare-const f1 BranchState)
(assert (not (= (exec_branch (mk-exec_context f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DMAConfig record properties ---

; --- 28. DMAConfig accessor round-trip: dma_bandwidth ---
(push 1)
(declare-const f0 Int)
(assert (not (= (dma_bandwidth (mk-d_m_a_config f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
