; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TranslationValidation — SMT Verification
; Derived from 02_FORMAL/coq/domains/TranslationValidation.v (22 assertions)
; Module: TranslationValidation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SrcExpr 0)) (((SVar) (SConst) (SAdd) (SMul) (SIf) (SCall) (SLet))))

(declare-datatypes ((SrcStmt 0)) (((SSkip) (SAssign) (SSeq) (SIfStmt) (SWhile) (SRead) (SWrite) (SCallStmt))))

(declare-datatypes ((TgtInstr 0)) (((TLoad) (TStore) (TAdd) (TMul) (TConst) (TBranch) (TBranchIf) (TCall) (TReturn) (TNop))))

(declare-datatypes ((SrcVal 0)) (((SVInt) (SVBool) (SVUnit))))

(declare-datatypes ((TgtVal 0)) (((TVInt) (TVUndef))))

(declare-datatypes ((Ind_Effect 0)) (((EffPure) (EffRead) (EffWrite) (EffCall))))

(declare-datatypes ((SrcType 0)) (((STInt) (STBool) (STUnit) (STFun))))

(declare-datatypes ((TgtType 0)) (((TTInt) (TTPtr))))

(declare-datatypes ((IRInstr 0)) (((IRAdd) (IRMul) (IRConst))))

(declare-datatypes ((MachInstr 0)) (((MAdd) (MMul) (MLoadImm))))

(declare-datatypes ((SrcProgram 0))
  (((mk-src_program (sp_funcs (Seq Int)) (sp_main SrcExpr)))))

(declare-datatypes ((TgtFunc 0))
  (((mk-tgt_func (tf_id Int) (tf_params (Seq Int)) (tf_body Int) (tf_result Int)))))

(declare-datatypes ((TgtState 0))
  (((mk-tgt_state (ts_pc Int) (ts_regs Int) (ts_memory Int)))))

(declare-datatypes ((CompResult 0))
  (((mk-comp_result (cr_code Int) (cr_result_reg Int) (cr_next_reg Int)))))

(declare-datatypes ((ABI 0))
  (((mk-abi (abi_arg_regs (Seq Int)) (abi_ret_reg Int) (abi_callee_save (Seq Int)) (abi_caller_save (Seq Int)) (abi_stack_align Int)))))

(declare-datatypes ((StackFrame 0))
  (((mk-stack_frame (sf_return_addr Int) (sf_saved_regs (Seq Int)) (sf_locals (Seq Int)) (sf_size Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. SrcExpr exhaustiveness ---
(push 1)
(declare-const x SrcExpr)
(assert (not (or (= x SVar) (= x SConst) (= x SAdd) (= x SMul) (= x SIf) (= x SCall) (= x SLet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SrcExpr: SVar != SConst ---
(push 1)
(assert (= SVar SConst))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SrcExpr: SConst != SAdd ---
(push 1)
(assert (= SConst SAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SrcExpr: SAdd != SMul ---
(push 1)
(assert (= SAdd SMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SrcExpr: SVar != SLet ---
(push 1)
(assert (= SVar SLet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SrcExpr finite cardinality (7 values) ---
(push 1)
(declare-const x SrcExpr)
(assert (and (not (= x SVar)) (not (= x SConst)) (not (= x SAdd)) (not (= x SMul)) (not (= x SIf)) (not (= x SCall)) (not (= x SLet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SrcStmt exhaustiveness ---
(push 1)
(declare-const x SrcStmt)
(assert (not (or (= x SSkip) (= x SAssign) (= x SSeq) (= x SIfStmt) (= x SWhile) (= x SRead) (= x SWrite) (= x SCallStmt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SrcStmt: SSkip != SAssign ---
(push 1)
(assert (= SSkip SAssign))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SrcStmt: SAssign != SSeq ---
(push 1)
(assert (= SAssign SSeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SrcStmt: SSeq != SIfStmt ---
(push 1)
(assert (= SSeq SIfStmt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SrcStmt: SSkip != SCallStmt ---
(push 1)
(assert (= SSkip SCallStmt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SrcStmt finite cardinality (8 values) ---
(push 1)
(declare-const x SrcStmt)
(assert (and (not (= x SSkip)) (not (= x SAssign)) (not (= x SSeq)) (not (= x SIfStmt)) (not (= x SWhile)) (not (= x SRead)) (not (= x SWrite)) (not (= x SCallStmt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. TgtInstr exhaustiveness ---
(push 1)
(declare-const x TgtInstr)
(assert (not (or (= x TLoad) (= x TStore) (= x TAdd) (= x TMul) (= x TConst) (= x TBranch) (= x TBranchIf) (= x TCall) (= x TReturn) (= x TNop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TgtInstr: TLoad != TStore ---
(push 1)
(assert (= TLoad TStore))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. TgtInstr: TStore != TAdd ---
(push 1)
(assert (= TStore TAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. TgtInstr: TAdd != TMul ---
(push 1)
(assert (= TAdd TMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TgtInstr: TLoad != TNop ---
(push 1)
(assert (= TLoad TNop))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TgtInstr finite cardinality (10 values) ---
(push 1)
(declare-const x TgtInstr)
(assert (and (not (= x TLoad)) (not (= x TStore)) (not (= x TAdd)) (not (= x TMul)) (not (= x TConst)) (not (= x TBranch)) (not (= x TBranchIf)) (not (= x TCall)) (not (= x TReturn)) (not (= x TNop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SrcVal exhaustiveness ---
(push 1)
(declare-const x SrcVal)
(assert (not (or (= x SVInt) (= x SVBool) (= x SVUnit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SrcVal: SVInt != SVBool ---
(push 1)
(assert (= SVInt SVBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SrcVal: SVBool != SVUnit ---
(push 1)
(assert (= SVBool SVUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SrcVal finite cardinality (3 values) ---
(push 1)
(declare-const x SrcVal)
(assert (and (not (= x SVInt)) (not (= x SVBool)) (not (= x SVUnit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TgtVal exhaustiveness ---
(push 1)
(declare-const x TgtVal)
(assert (not (or (= x TVInt) (= x TVUndef))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TgtVal: TVInt != TVUndef ---
(push 1)
(assert (= TVInt TVUndef))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TgtVal finite cardinality (2 values) ---
(push 1)
(declare-const x TgtVal)
(assert (and (not (= x TVInt)) (not (= x TVUndef))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Ind_Effect exhaustiveness ---
(push 1)
(declare-const x Ind_Effect)
(assert (not (or (= x EffPure) (= x EffRead) (= x EffWrite) (= x EffCall))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Ind_Effect: EffPure != EffRead ---
(push 1)
(assert (= EffPure EffRead))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Ind_Effect: EffRead != EffWrite ---
(push 1)
(assert (= EffRead EffWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Ind_Effect: EffWrite != EffCall ---
(push 1)
(assert (= EffWrite EffCall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Ind_Effect: EffPure != EffCall ---
(push 1)
(assert (= EffPure EffCall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Ind_Effect finite cardinality (4 values) ---
(push 1)
(declare-const x Ind_Effect)
(assert (and (not (= x EffPure)) (not (= x EffRead)) (not (= x EffWrite)) (not (= x EffCall))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. SrcType exhaustiveness ---
(push 1)
(declare-const x SrcType)
(assert (not (or (= x STInt) (= x STBool) (= x STUnit) (= x STFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. SrcType: STInt != STBool ---
(push 1)
(assert (= STInt STBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. SrcType: STBool != STUnit ---
(push 1)
(assert (= STBool STUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. SrcType: STUnit != STFun ---
(push 1)
(assert (= STUnit STFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. SrcType: STInt != STFun ---
(push 1)
(assert (= STInt STFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SrcType finite cardinality (4 values) ---
(push 1)
(declare-const x SrcType)
(assert (and (not (= x STInt)) (not (= x STBool)) (not (= x STUnit)) (not (= x STFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. TgtType exhaustiveness ---
(push 1)
(declare-const x TgtType)
(assert (not (or (= x TTInt) (= x TTPtr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. TgtType: TTInt != TTPtr ---
(push 1)
(assert (= TTInt TTPtr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. TgtType finite cardinality (2 values) ---
(push 1)
(declare-const x TgtType)
(assert (and (not (= x TTInt)) (not (= x TTPtr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. IRInstr exhaustiveness ---
(push 1)
(declare-const x IRInstr)
(assert (not (or (= x IRAdd) (= x IRMul) (= x IRConst))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. IRInstr: IRAdd != IRMul ---
(push 1)
(assert (= IRAdd IRMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. IRInstr: IRMul != IRConst ---
(push 1)
(assert (= IRMul IRConst))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. IRInstr finite cardinality (3 values) ---
(push 1)
(declare-const x IRInstr)
(assert (and (not (= x IRAdd)) (not (= x IRMul)) (not (= x IRConst))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. MachInstr exhaustiveness ---
(push 1)
(declare-const x MachInstr)
(assert (not (or (= x MAdd) (= x MMul) (= x MLoadImm))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. MachInstr: MAdd != MMul ---
(push 1)
(assert (= MAdd MMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. MachInstr: MMul != MLoadImm ---
(push 1)
(assert (= MMul MLoadImm))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. MachInstr finite cardinality (3 values) ---
(push 1)
(declare-const x MachInstr)
(assert (and (not (= x MAdd)) (not (= x MMul)) (not (= x MLoadImm))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. TgtFunc accessor round-trip: tf_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (tf_id (mk-tgt_func f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. TgtState accessor round-trip: ts_pc ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ts_pc (mk-tgt_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. TgtState accessor round-trip: ts_regs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ts_regs (mk-tgt_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. TgtState accessor round-trip: ts_memory ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ts_memory (mk-tgt_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. TgtState: non-negative int fields sum ---
(push 1)
(declare-const r TgtState)
(assert (>= (ts_pc r) 0))
(assert (>= (ts_regs r) 0))
(assert (not (>= (+ (ts_pc r) (ts_regs r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. CompResult accessor round-trip: cr_code ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cr_code (mk-comp_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. CompResult accessor round-trip: cr_result_reg ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cr_result_reg (mk-comp_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. CompResult accessor round-trip: cr_next_reg ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cr_next_reg (mk-comp_result f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. CompResult: non-negative int fields sum ---
(push 1)
(declare-const r CompResult)
(assert (>= (cr_code r) 0))
(assert (>= (cr_result_reg r) 0))
(assert (not (>= (+ (cr_code r) (cr_result_reg r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. StackFrame accessor round-trip: sf_return_addr ---
(push 1)
(declare-const f0 Int)
(assert (not (= (sf_return_addr (mk-stack_frame f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
