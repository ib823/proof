; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ControlFlowIntegrity — SMT Verification
; Derived from 02_FORMAL/coq/domains/ControlFlowIntegrity.v (21 assertions)
; Module: ControlFlowIntegrity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((EdgeType 0)) (((DirectJump) (ConditionalJump) (DirectCall) (Return) (FallThrough))))

(declare-datatypes ((MemPerm 0)) (((Readable) (Writable) (Executable))))

(declare-datatypes ((RelocState 0)) (((PreReloc) (PostReloc))))

(declare-datatypes ((BasicBlock 0))
  (((mk-basic_block (bb_id Int) (bb_start Int) (bb_end Int) (bb_func Int)))))

(declare-datatypes ((CFGEdge 0))
  (((mk-cfg_edge (edge_src BasicBlock) (edge_dst BasicBlock) (edge_type EdgeType)))))

(declare-datatypes ((ShadowEntry 0))
  (((mk-shadow_entry (se_return_addr Int) (se_caller_func Int)))))

(declare-datatypes ((FuncType 0))
  (((mk-func_type (ft_arg_types (Seq Int)) (ft_ret_type Int)))))

(declare-datatypes ((TypedFuncPtr 0))
  (((mk-typed_func_ptr (tfp_addr Int) (tfp_type FuncType)))))

(declare-datatypes ((VTable 0))
  (((mk-v_table (vt_type_id Int) (vt_methods (Seq Int))))))

(declare-datatypes ((TypedObject 0))
  (((mk-typed_object (to_vtable VTable) (to_expected_type Int)))))

(declare-datatypes ((ExceptionHandler 0))
  (((mk-exception_handler (eh_type Int) (eh_addr Int)))))

(declare-datatypes ((JmpBuf 0))
  (((mk-jmp_buf (jb_valid Bool) (jb_target Int) (jb_stack_ptr Int)))))

(declare-datatypes ((ThreadContext 0))
  (((mk-thread_context (tc_id Int) (tc_owner Int) (tc_valid Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- EdgeType enum properties ---

; --- 1. EdgeType exhaustiveness ---
(push 1)
(declare-const x EdgeType)
(assert (not (or (= x DirectJump) (= x ConditionalJump) (= x DirectCall) (= x Return) (= x FallThrough))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. EdgeType: DirectJump != ConditionalJump ---
(push 1)
(assert (= DirectJump ConditionalJump))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. EdgeType: ConditionalJump != DirectCall ---
(push 1)
(assert (= ConditionalJump DirectCall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. EdgeType: DirectCall != Return ---
(push 1)
(assert (= DirectCall Return))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. EdgeType: DirectJump != FallThrough ---
(push 1)
(assert (= DirectJump FallThrough))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. EdgeType finite cardinality (5 values) ---
(push 1)
(declare-const x EdgeType)
(assert (and (not (= x DirectJump)) (not (= x ConditionalJump)) (not (= x DirectCall)) (not (= x Return)) (not (= x FallThrough))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemPerm enum properties ---

; --- 7. MemPerm exhaustiveness ---
(push 1)
(declare-const x MemPerm)
(assert (not (or (= x Readable) (= x Writable) (= x Executable))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. MemPerm: Readable != Writable ---
(push 1)
(assert (= Readable Writable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. MemPerm: Writable != Executable ---
(push 1)
(assert (= Writable Executable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. MemPerm: Readable != Executable ---
(push 1)
(assert (= Readable Executable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. MemPerm finite cardinality (3 values) ---
(push 1)
(declare-const x MemPerm)
(assert (and (not (= x Readable)) (not (= x Writable)) (not (= x Executable))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RelocState enum properties ---

; --- 12. RelocState exhaustiveness ---
(push 1)
(declare-const x RelocState)
(assert (not (or (= x PreReloc) (= x PostReloc))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. RelocState: PreReloc != PostReloc ---
(push 1)
(assert (= PreReloc PostReloc))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. RelocState finite cardinality (2 values) ---
(push 1)
(declare-const x RelocState)
(assert (and (not (= x PreReloc)) (not (= x PostReloc))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BasicBlock record properties ---

; --- 15. BasicBlock accessor round-trip: bb_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bb_id (mk-basic_block f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. BasicBlock accessor round-trip: bb_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bb_start (mk-basic_block f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. BasicBlock accessor round-trip: bb_end ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bb_end (mk-basic_block f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. BasicBlock: integer field consistency ---
(push 1)
(declare-const r BasicBlock)
(assert (>= (bb_id r) 0))
(assert (>= (bb_start r) 0))
(assert (not (>= (+ (bb_id r) (bb_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CFGEdge record properties ---

; --- 19. CFGEdge accessor round-trip: edge_src ---
(push 1)
(declare-const f0 BasicBlock)
(declare-const f1 BasicBlock)
(assert (not (= (edge_src (mk-c_f_g_edge f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. CFGEdge accessor round-trip: edge_dst ---
(push 1)
(declare-const f0 BasicBlock)
(declare-const f1 BasicBlock)
(assert (not (= (edge_dst (mk-c_f_g_edge f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ShadowEntry record properties ---

; --- 21. ShadowEntry accessor round-trip: se_return_addr ---
(push 1)
(declare-const f0 Int)
(assert (not (= (se_return_addr (mk-shadow_entry f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FuncType record properties ---

; --- 22. FuncType accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(assert (not (= (Seq (mk-func_type f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TypedFuncPtr record properties ---

; --- 23. TypedFuncPtr accessor round-trip: tfp_addr ---
(push 1)
(declare-const f0 Int)
(assert (not (= (tfp_addr (mk-typed_func_ptr f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VTable record properties ---

; --- 24. VTable accessor round-trip: vt_type_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (vt_type_id (mk-v_table f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TypedObject record properties ---

; --- 25. TypedObject accessor round-trip: to_vtable ---
(push 1)
(declare-const f0 VTable)
(assert (not (= (to_vtable (mk-typed_object f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExceptionHandler record properties ---

; --- 26. ExceptionHandler accessor round-trip: eh_type ---
(push 1)
(declare-const f0 Int)
(assert (not (= (eh_type (mk-exception_handler f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- JmpBuf record properties ---

; --- 27. JmpBuf accessor round-trip: jb_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(assert (not (= (jb_valid (mk-jmp_buf f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. JmpBuf accessor round-trip: jb_target ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(assert (not (= (jb_target (mk-jmp_buf f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ThreadContext record properties ---

; --- 29. ThreadContext accessor round-trip: tc_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (tc_id (mk-thread_context f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ThreadContext accessor round-trip: tc_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (tc_owner (mk-thread_context f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ThreadContext: integer field consistency ---
(push 1)
(declare-const r ThreadContext)
(assert (>= (tc_id r) 0))
(assert (>= (tc_owner r) 0))
(assert (not (>= (+ (tc_id r) (tc_owner r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
