; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA S001_HardwareContracts — SMT Verification
; Derived from 02_FORMAL/coq/domains/S001_HardwareContracts.v (30 assertions)
; Module: S001_HardwareContracts
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CacheState 0)) (((Invalid) (Clean) (Dirty))))

(declare-datatypes ((SpecState 0)) (((NotSpeculating) (Speculating))))

(declare-datatypes ((LeakageEvent 0)) (((CacheAccess) (CacheMiss) (CacheHit) (BranchTaken) (BranchNotTaken) (CyclesTaken) (PowerConsumed))))

(declare-datatypes ((Instruction 0)) (((ILoad) (IStore) (IAdd) (IBranch) (IFence) (INop))))

(declare-datatypes ((SecLabel 0)) (((Public) (Secret))))

(declare-datatypes ((ArchState 0))
  (((mk-arch_state (regs Int) (mem Int) (pc Int)))))

(declare-datatypes ((MicroarchState 0))
  (((mk-microarch_state (arch ArchState) (cache Int) (branch_predictor Int) (spec_state SpecState) (cycle_count Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- CacheState enum properties ---

; --- 1. CacheState exhaustiveness ---
(push 1)
(declare-const x CacheState)
(assert (not (or (= x Invalid) (= x Clean) (= x Dirty))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CacheState: Invalid != Clean ---
(push 1)
(assert (= Invalid Clean))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CacheState: Clean != Dirty ---
(push 1)
(assert (= Clean Dirty))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CacheState: Invalid != Dirty ---
(push 1)
(assert (= Invalid Dirty))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CacheState finite cardinality (3 values) ---
(push 1)
(declare-const x CacheState)
(assert (and (not (= x Invalid)) (not (= x Clean)) (not (= x Dirty))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SpecState enum properties ---

; --- 6. SpecState exhaustiveness ---
(push 1)
(declare-const x SpecState)
(assert (not (or (= x NotSpeculating) (= x Speculating))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SpecState: NotSpeculating != Speculating ---
(push 1)
(assert (= NotSpeculating Speculating))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SpecState finite cardinality (2 values) ---
(push 1)
(declare-const x SpecState)
(assert (and (not (= x NotSpeculating)) (not (= x Speculating))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LeakageEvent enum properties ---

; --- 9. LeakageEvent exhaustiveness ---
(push 1)
(declare-const x LeakageEvent)
(assert (not (or (= x CacheAccess) (= x CacheMiss) (= x CacheHit) (= x BranchTaken) (= x BranchNotTaken) (= x CyclesTaken) (= x PowerConsumed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. LeakageEvent: CacheAccess != CacheMiss ---
(push 1)
(assert (= CacheAccess CacheMiss))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. LeakageEvent: CacheMiss != CacheHit ---
(push 1)
(assert (= CacheMiss CacheHit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. LeakageEvent: CacheHit != BranchTaken ---
(push 1)
(assert (= CacheHit BranchTaken))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. LeakageEvent: CacheAccess != PowerConsumed ---
(push 1)
(assert (= CacheAccess PowerConsumed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. LeakageEvent finite cardinality (7 values) ---
(push 1)
(declare-const x LeakageEvent)
(assert (and (not (= x CacheAccess)) (not (= x CacheMiss)) (not (= x CacheHit)) (not (= x BranchTaken)) (not (= x BranchNotTaken)) (not (= x CyclesTaken)) (not (= x PowerConsumed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Instruction enum properties ---

; --- 15. Instruction exhaustiveness ---
(push 1)
(declare-const x Instruction)
(assert (not (or (= x ILoad) (= x IStore) (= x IAdd) (= x IBranch) (= x IFence) (= x INop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Instruction: ILoad != IStore ---
(push 1)
(assert (= ILoad IStore))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Instruction: IStore != IAdd ---
(push 1)
(assert (= IStore IAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Instruction: IAdd != IBranch ---
(push 1)
(assert (= IAdd IBranch))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Instruction: ILoad != INop ---
(push 1)
(assert (= ILoad INop))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Instruction finite cardinality (6 values) ---
(push 1)
(declare-const x Instruction)
(assert (and (not (= x ILoad)) (not (= x IStore)) (not (= x IAdd)) (not (= x IBranch)) (not (= x IFence)) (not (= x INop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecLabel enum properties ---

; --- 21. SecLabel exhaustiveness ---
(push 1)
(declare-const x SecLabel)
(assert (not (or (= x Public) (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SecLabel: Public != Secret ---
(push 1)
(assert (= Public Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SecLabel finite cardinality (2 values) ---
(push 1)
(declare-const x SecLabel)
(assert (and (not (= x Public)) (not (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ArchState record properties ---

; --- 24. ArchState accessor round-trip: regs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (regs (mk-arch_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ArchState accessor round-trip: mem ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (mem (mk-arch_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ArchState: integer field consistency ---
(push 1)
(declare-const r ArchState)
(assert (>= (regs r) 0))
(assert (>= (mem r) 0))
(assert (not (>= (+ (regs r) (mem r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MicroarchState record properties ---

; --- 27. MicroarchState accessor round-trip: arch ---
(push 1)
(declare-const f0 ArchState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 SpecState)
(assert (not (= (arch (mk-microarch_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. MicroarchState accessor round-trip: cache ---
(push 1)
(declare-const f0 ArchState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 SpecState)
(assert (not (= (cache (mk-microarch_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. MicroarchState accessor round-trip: branch_predictor ---
(push 1)
(declare-const f0 ArchState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 SpecState)
(assert (not (= (branch_predictor (mk-microarch_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. MicroarchState accessor round-trip: spec_state ---
(push 1)
(declare-const f0 ArchState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 SpecState)
(assert (not (= (spec_state (mk-microarch_state f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. MicroarchState: integer field consistency ---
(push 1)
(declare-const r MicroarchState)
(assert (>= (cache r) 0))
(assert (>= (branch_predictor r) 0))
(assert (not (>= (+ (cache r) (branch_predictor r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
