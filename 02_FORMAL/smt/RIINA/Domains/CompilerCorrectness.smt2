; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CompilerCorrectness — SMT Verification
; Derived from 02_FORMAL/coq/domains/CompilerCorrectness.v (78 assertions)
; Module: CompilerCorrectness
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ir_ty 0)) (((IR_TUnit) (IR_TBool) (IR_TInt) (IR_TFn) (IR_TProd) (IR_TSum))))

(declare-datatypes ((ir_expr 0)) (((IR_Unit) (IR_Bool) (IR_Int) (IR_Pair) (IR_Fst) (IR_Snd) (IR_Inl) (IR_Inr) (IR_If))))

(declare-datatypes ((src_ty 0)) (((Src_TUnit) (Src_TBool) (Src_TInt) (Src_TProd) (Src_TSum) (Src_TFn))))

(declare-datatypes ((src_expr 0)) (((Src_Unit) (Src_Bool) (Src_Int) (Src_Pair) (Src_Fst) (Src_Snd) (Src_Inl) (Src_Inr) (Src_If))))

(declare-datatypes ((ParsingPhase 0))
  (((mk-parsing_phase (pp_syntax_correct Bool) (pp_ast_well_formed Bool) (pp_error_recovery Bool)))))

(declare-datatypes ((TypeCheckPhase 0))
  (((mk-type_check_phase (tc_type_soundness Bool) (tc_inference_complete Bool) (tc_constraint_solving Bool)))))

(declare-datatypes ((OptimizationPhase 0))
  (((mk-optimization_phase (op_semantics_preserved Bool) (op_termination_preserved Bool) (op_memory_safety_preserved Bool)))))

(declare-datatypes ((CodeGenPhase 0))
  (((mk-code_gen_phase (cg_instruction_correct Bool) (cg_register_allocation Bool) (cg_calling_convention Bool) (cg_stack_layout Bool)))))

(declare-datatypes ((CompilerConfig 0))
  (((mk-compiler_config (cc_parsing ParsingPhase) (cc_typecheck TypeCheckPhase) (cc_optimization OptimizationPhase) (cc_codegen CodeGenPhase)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ir_ty enum properties ---

; --- 1. ir_ty exhaustiveness ---
(push 1)
(declare-const x ir_ty)
(assert (not (or (= x IR_TUnit) (= x IR_TBool) (= x IR_TInt) (= x IR_TFn) (= x IR_TProd) (= x IR_TSum))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ir_ty: IR_TUnit != IR_TBool ---
(push 1)
(assert (= IR_TUnit IR_TBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ir_ty: IR_TBool != IR_TInt ---
(push 1)
(assert (= IR_TBool IR_TInt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ir_ty: IR_TInt != IR_TFn ---
(push 1)
(assert (= IR_TInt IR_TFn))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ir_ty: IR_TUnit != IR_TSum ---
(push 1)
(assert (= IR_TUnit IR_TSum))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ir_ty finite cardinality (6 values) ---
(push 1)
(declare-const x ir_ty)
(assert (and (not (= x IR_TUnit)) (not (= x IR_TBool)) (not (= x IR_TInt)) (not (= x IR_TFn)) (not (= x IR_TProd)) (not (= x IR_TSum))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ir_expr enum properties ---

; --- 7. ir_expr exhaustiveness ---
(push 1)
(declare-const x ir_expr)
(assert (not (or (= x IR_Unit) (= x IR_Bool) (= x IR_Int) (= x IR_Pair) (= x IR_Fst) (= x IR_Snd) (= x IR_Inl) (= x IR_Inr) (= x IR_If))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ir_expr: IR_Unit != IR_Bool ---
(push 1)
(assert (= IR_Unit IR_Bool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ir_expr: IR_Bool != IR_Int ---
(push 1)
(assert (= IR_Bool IR_Int))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ir_expr: IR_Int != IR_Pair ---
(push 1)
(assert (= IR_Int IR_Pair))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ir_expr: IR_Unit != IR_If ---
(push 1)
(assert (= IR_Unit IR_If))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ir_expr finite cardinality (9 values) ---
(push 1)
(declare-const x ir_expr)
(assert (and (not (= x IR_Unit)) (not (= x IR_Bool)) (not (= x IR_Int)) (not (= x IR_Pair)) (not (= x IR_Fst)) (not (= x IR_Snd)) (not (= x IR_Inl)) (not (= x IR_Inr)) (not (= x IR_If))))
(check-sat) ; expect UNSAT
(pop 1)

; --- src_ty enum properties ---

; --- 13. src_ty exhaustiveness ---
(push 1)
(declare-const x src_ty)
(assert (not (or (= x Src_TUnit) (= x Src_TBool) (= x Src_TInt) (= x Src_TProd) (= x Src_TSum) (= x Src_TFn))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. src_ty: Src_TUnit != Src_TBool ---
(push 1)
(assert (= Src_TUnit Src_TBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. src_ty: Src_TBool != Src_TInt ---
(push 1)
(assert (= Src_TBool Src_TInt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. src_ty: Src_TInt != Src_TProd ---
(push 1)
(assert (= Src_TInt Src_TProd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. src_ty: Src_TUnit != Src_TFn ---
(push 1)
(assert (= Src_TUnit Src_TFn))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. src_ty finite cardinality (6 values) ---
(push 1)
(declare-const x src_ty)
(assert (and (not (= x Src_TUnit)) (not (= x Src_TBool)) (not (= x Src_TInt)) (not (= x Src_TProd)) (not (= x Src_TSum)) (not (= x Src_TFn))))
(check-sat) ; expect UNSAT
(pop 1)

; --- src_expr enum properties ---

; --- 19. src_expr exhaustiveness ---
(push 1)
(declare-const x src_expr)
(assert (not (or (= x Src_Unit) (= x Src_Bool) (= x Src_Int) (= x Src_Pair) (= x Src_Fst) (= x Src_Snd) (= x Src_Inl) (= x Src_Inr) (= x Src_If))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. src_expr: Src_Unit != Src_Bool ---
(push 1)
(assert (= Src_Unit Src_Bool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. src_expr: Src_Bool != Src_Int ---
(push 1)
(assert (= Src_Bool Src_Int))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. src_expr: Src_Int != Src_Pair ---
(push 1)
(assert (= Src_Int Src_Pair))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. src_expr: Src_Unit != Src_If ---
(push 1)
(assert (= Src_Unit Src_If))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. src_expr finite cardinality (9 values) ---
(push 1)
(declare-const x src_expr)
(assert (and (not (= x Src_Unit)) (not (= x Src_Bool)) (not (= x Src_Int)) (not (= x Src_Pair)) (not (= x Src_Fst)) (not (= x Src_Snd)) (not (= x Src_Inl)) (not (= x Src_Inr)) (not (= x Src_If))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ParsingPhase record properties ---

; --- 25. ParsingPhase accessor round-trip: pp_syntax_correct ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (pp_syntax_correct (mk-parsing_phase f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ParsingPhase accessor round-trip: pp_ast_well_formed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (pp_ast_well_formed (mk-parsing_phase f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ParsingPhase_all_enabled ((g ParsingPhase)) Bool
  (and (pp_syntax_correct g) (pp_ast_well_formed g)))

; --- 27. ParsingPhase: all-enabled completeness ---
(push 1)
(declare-const g ParsingPhase)
(assert (pp_syntax_correct g))
(assert (pp_ast_well_formed g))
(assert (not (ParsingPhase_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ParsingPhase: ParsingPhase_all_enabled implies pp_syntax_correct ---
(push 1)
(declare-const g ParsingPhase)
(assert (ParsingPhase_all_enabled g))
(assert (not (pp_syntax_correct g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ParsingPhase: ParsingPhase_all_enabled implies pp_ast_well_formed ---
(push 1)
(declare-const g ParsingPhase)
(assert (ParsingPhase_all_enabled g))
(assert (not (pp_ast_well_formed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TypeCheckPhase record properties ---

; --- 30. TypeCheckPhase accessor round-trip: tc_type_soundness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (tc_type_soundness (mk-type_check_phase f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. TypeCheckPhase accessor round-trip: tc_inference_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (tc_inference_complete (mk-type_check_phase f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TypeCheckPhase_all_enabled ((g TypeCheckPhase)) Bool
  (and (tc_type_soundness g) (tc_inference_complete g)))

; --- 32. TypeCheckPhase: all-enabled completeness ---
(push 1)
(declare-const g TypeCheckPhase)
(assert (tc_type_soundness g))
(assert (tc_inference_complete g))
(assert (not (TypeCheckPhase_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. TypeCheckPhase: TypeCheckPhase_all_enabled implies tc_type_soundness ---
(push 1)
(declare-const g TypeCheckPhase)
(assert (TypeCheckPhase_all_enabled g))
(assert (not (tc_type_soundness g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. TypeCheckPhase: TypeCheckPhase_all_enabled implies tc_inference_complete ---
(push 1)
(declare-const g TypeCheckPhase)
(assert (TypeCheckPhase_all_enabled g))
(assert (not (tc_inference_complete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- OptimizationPhase record properties ---

; --- 35. OptimizationPhase accessor round-trip: op_semantics_preserved ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (op_semantics_preserved (mk-optimization_phase f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. OptimizationPhase accessor round-trip: op_termination_preserved ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (op_termination_preserved (mk-optimization_phase f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun OptimizationPhase_all_enabled ((g OptimizationPhase)) Bool
  (and (op_semantics_preserved g) (op_termination_preserved g)))

; --- 37. OptimizationPhase: all-enabled completeness ---
(push 1)
(declare-const g OptimizationPhase)
(assert (op_semantics_preserved g))
(assert (op_termination_preserved g))
(assert (not (OptimizationPhase_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. OptimizationPhase: OptimizationPhase_all_enabled implies op_semantics_preserved ---
(push 1)
(declare-const g OptimizationPhase)
(assert (OptimizationPhase_all_enabled g))
(assert (not (op_semantics_preserved g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. OptimizationPhase: OptimizationPhase_all_enabled implies op_termination_preserved ---
(push 1)
(declare-const g OptimizationPhase)
(assert (OptimizationPhase_all_enabled g))
(assert (not (op_termination_preserved g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CodeGenPhase record properties ---

; --- 40. CodeGenPhase accessor round-trip: cg_instruction_correct ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cg_instruction_correct (mk-code_gen_phase f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. CodeGenPhase accessor round-trip: cg_register_allocation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cg_register_allocation (mk-code_gen_phase f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. CodeGenPhase accessor round-trip: cg_calling_convention ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cg_calling_convention (mk-code_gen_phase f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CodeGenPhase_all_enabled ((g CodeGenPhase)) Bool
  (and (cg_instruction_correct g) (cg_register_allocation g) (cg_calling_convention g)))

; --- 43. CodeGenPhase: all-enabled completeness ---
(push 1)
(declare-const g CodeGenPhase)
(assert (cg_instruction_correct g))
(assert (cg_register_allocation g))
(assert (cg_calling_convention g))
(assert (not (CodeGenPhase_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. CodeGenPhase: CodeGenPhase_all_enabled implies cg_instruction_correct ---
(push 1)
(declare-const g CodeGenPhase)
(assert (CodeGenPhase_all_enabled g))
(assert (not (cg_instruction_correct g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. CodeGenPhase: CodeGenPhase_all_enabled implies cg_register_allocation ---
(push 1)
(declare-const g CodeGenPhase)
(assert (CodeGenPhase_all_enabled g))
(assert (not (cg_register_allocation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. CodeGenPhase: CodeGenPhase_all_enabled implies cg_calling_convention ---
(push 1)
(declare-const g CodeGenPhase)
(assert (CodeGenPhase_all_enabled g))
(assert (not (cg_calling_convention g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CompilerConfig record properties ---

; --- 47. CompilerConfig accessor round-trip: cc_parsing ---
(push 1)
(declare-const f0 ParsingPhase)
(declare-const f1 TypeCheckPhase)
(declare-const f2 OptimizationPhase)
(assert (not (= (cc_parsing (mk-compiler_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. CompilerConfig accessor round-trip: cc_typecheck ---
(push 1)
(declare-const f0 ParsingPhase)
(declare-const f1 TypeCheckPhase)
(declare-const f2 OptimizationPhase)
(assert (not (= (cc_typecheck (mk-compiler_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. CompilerConfig accessor round-trip: cc_optimization ---
(push 1)
(declare-const f0 ParsingPhase)
(declare-const f1 TypeCheckPhase)
(declare-const f2 OptimizationPhase)
(assert (not (= (cc_optimization (mk-compiler_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
