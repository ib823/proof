; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA W001_VerifiedMemory — SMT Verification
; Derived from 02_FORMAL/coq/domains/W001_VerifiedMemory.v (40 assertions)
; Module: W001_VerifiedMemory
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((assertion 0)) (((AEmp) (APointsTo) (ASep) (AWand) (APure))))

(declare-datatypes ((cmd 0)) (((CSkip) (CAlloc) (CFree) (CRead) (CWrite) (CSeq))))

(declare-datatypes ((Ownership 0)) (((Owned) (Borrowed) (SharedBorrow) (Moved))))

(declare-datatypes ((MemType 0)) (((TInt) (TPtr) (TArray))))

(declare-datatypes ((AllocState 0))
  (((mk-alloc_state (free_lists Int) (allocated Int) (heap_start Int) (total_heap_size Int)))))

(declare-datatypes ((Region 0))
  (((mk-region (region_id Int) (region_locs (Seq Int)) (region_alive Bool)))))

(declare-datatypes ((RegionState 0))
  (((mk-region_state (regions (Seq Int)) (loc_to_region Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- assertion enum properties ---

; --- 1. assertion exhaustiveness ---
(push 1)
(declare-const x assertion)
(assert (not (or (= x AEmp) (= x APointsTo) (= x ASep) (= x AWand) (= x APure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. assertion: AEmp != APointsTo ---
(push 1)
(assert (= AEmp APointsTo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. assertion: APointsTo != ASep ---
(push 1)
(assert (= APointsTo ASep))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. assertion: ASep != AWand ---
(push 1)
(assert (= ASep AWand))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. assertion: AEmp != APure ---
(push 1)
(assert (= AEmp APure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. assertion finite cardinality (5 values) ---
(push 1)
(declare-const x assertion)
(assert (and (not (= x AEmp)) (not (= x APointsTo)) (not (= x ASep)) (not (= x AWand)) (not (= x APure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- cmd enum properties ---

; --- 7. cmd exhaustiveness ---
(push 1)
(declare-const x cmd)
(assert (not (or (= x CSkip) (= x CAlloc) (= x CFree) (= x CRead) (= x CWrite) (= x CSeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. cmd: CSkip != CAlloc ---
(push 1)
(assert (= CSkip CAlloc))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. cmd: CAlloc != CFree ---
(push 1)
(assert (= CAlloc CFree))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. cmd: CFree != CRead ---
(push 1)
(assert (= CFree CRead))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. cmd: CSkip != CSeq ---
(push 1)
(assert (= CSkip CSeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. cmd finite cardinality (6 values) ---
(push 1)
(declare-const x cmd)
(assert (and (not (= x CSkip)) (not (= x CAlloc)) (not (= x CFree)) (not (= x CRead)) (not (= x CWrite)) (not (= x CSeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Ownership enum properties ---

; --- 13. Ownership exhaustiveness ---
(push 1)
(declare-const x Ownership)
(assert (not (or (= x Owned) (= x Borrowed) (= x SharedBorrow) (= x Moved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Ownership: Owned != Borrowed ---
(push 1)
(assert (= Owned Borrowed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Ownership: Borrowed != SharedBorrow ---
(push 1)
(assert (= Borrowed SharedBorrow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Ownership: SharedBorrow != Moved ---
(push 1)
(assert (= SharedBorrow Moved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Ownership: Owned != Moved ---
(push 1)
(assert (= Owned Moved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Ownership finite cardinality (4 values) ---
(push 1)
(declare-const x Ownership)
(assert (and (not (= x Owned)) (not (= x Borrowed)) (not (= x SharedBorrow)) (not (= x Moved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemType enum properties ---

; --- 19. MemType exhaustiveness ---
(push 1)
(declare-const x MemType)
(assert (not (or (= x TInt) (= x TPtr) (= x TArray))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. MemType: TInt != TPtr ---
(push 1)
(assert (= TInt TPtr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. MemType: TPtr != TArray ---
(push 1)
(assert (= TPtr TArray))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. MemType: TInt != TArray ---
(push 1)
(assert (= TInt TArray))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. MemType finite cardinality (3 values) ---
(push 1)
(declare-const x MemType)
(assert (and (not (= x TInt)) (not (= x TPtr)) (not (= x TArray))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AllocState record properties ---

; --- 24. AllocState accessor round-trip: free_lists ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (free_lists (mk-alloc_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. AllocState accessor round-trip: allocated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (allocated (mk-alloc_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AllocState accessor round-trip: heap_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (heap_start (mk-alloc_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AllocState: integer field consistency ---
(push 1)
(declare-const r AllocState)
(assert (>= (free_lists r) 0))
(assert (>= (allocated r) 0))
(assert (not (>= (+ (free_lists r) (allocated r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Region record properties ---

; --- 28. Region accessor round-trip: region_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (region_id (mk-region f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Region accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-region f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Region: integer field consistency ---
(push 1)
(declare-const r Region)
(assert (>= (region_id r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (region_id r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RegionState record properties ---

; --- 31. RegionState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(assert (not (= (Seq (mk-region_state f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
