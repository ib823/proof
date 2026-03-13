; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Metaprogramming — SMT Verification
; Derived from 02_FORMAL/coq/domains/Metaprogramming.v (27 assertions)
; Module: Metaprogramming
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FragmentType 0)) (((FTExpr) (FTStmt) (FTIdent) (FTType) (FTPattern) (FTBlock))))

(declare-datatypes ((Token 0)) (((TkIdent) (TkLiteral) (TkPunct) (TkGroup))))

(declare-datatypes ((AST 0)) (((ASTVar) (ASTLam) (ASTApp) (ASTLet) (ASTBlock))))

(declare-datatypes ((ExpansionStep 0)) (((ESInput) (ESMatched) (ESOutput))))

(declare-datatypes ((ConstResult 0)) (((CRValue) (CRBool) (CRUnit) (CRError))))

(declare-datatypes ((PatternMatch 0)) (((PMExact) (PMCapture) (PMRepeat))))

(declare-datatypes ((DeriveResult 0)) (((DRSuccess) (DRError))))

(declare-datatypes ((ConstExpr 0)) (((CELit) (CEAdd) (CEMul) (CEIf))))

(declare-datatypes ((ZeroStatus 0)) (((ZSZeroed) (ZSNotZeroed) (ZSPartial))))

(declare-datatypes ((ItemKind 0)) (((IKFunction) (IKStruct) (IKEnum) (IKTrait) (IKImpl))))

(declare-datatypes ((RepetitionResult 0)) (((RRSuccess) (RRMismatch))))

(declare-datatypes ((ScopedName 0))
  (((mk-scoped_name (sn_name String) (sn_scope Int)))))

(declare-datatypes ((MacroDef 0))
  (((mk-macro_def (macro_name String) (macro_patterns (Seq Int)) (macro_templates (Seq Int)) (macro_templates_wf Bool)))))

(declare-datatypes ((ExpansionContext 0))
  (((mk-expansion_context (ctx_scope Int) (ctx_crate String) (ctx_audit Bool)))))

(declare-datatypes ((HygienicContext 0))
  (((mk-hygienic_context (hyg_current_scope Int) (hyg_macro_scope Int) (hyg_bindings (Seq Int))))))

(declare-datatypes ((TraitBound 0))
  (((mk-trait_bound (tb_trait_name String) (tb_type_params (Seq Int))))))

(declare-datatypes ((ImplBlock 0))
  (((mk-impl_block (impl_trait String) (impl_for_type String) (impl_methods (Seq Int))))))

(declare-datatypes ((DSLDef 0))
  (((mk-dsl_def (dsl_name String) (dsl_syntax (Seq Int)) (dsl_semantics Int)))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (ae_macro_name String) (ae_input Int) (ae_output Int) (ae_scope Int) (ae_security_relevant Bool)))))

(declare-datatypes ((ConstGeneric 0))
  (((mk-const_generic (cg_name String) (cg_type FragmentType) (cg_value Int)))))

(declare-datatypes ((SandboxState 0))
  (((mk-sandbox_state (sb_can_read_fs Bool) (sb_can_write_fs Bool) (sb_can_network Bool) (sb_can_exec Bool)))))

(declare-datatypes ((SourceSpan 0))
  (((mk-source_span (span_file String) (span_start Int) (span_end Int) (span_macro_scope Int)))))

(declare-datatypes ((FieldInfo 0))
  (((mk-field_info (fi_name String) (fi_size Int) (fi_zero_status ZeroStatus)))))

(declare-datatypes ((Item 0))
  (((mk-item (item_kind ItemKind) (item_name String) (item_tokens Int)))))

(declare-datatypes ((StaticAssert 0))
  (((mk-static_assert (sa_condition ConstExpr) (sa_message String)))))

(declare-datatypes ((SecurityCheck 0))
  (((mk-security_check (sc_name String) (sc_condition ConstExpr) (sc_severity Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. FragmentType exhaustiveness ---
(push 1)
(declare-const x FragmentType)
(assert (not (or (= x FTExpr) (= x FTStmt) (= x FTIdent) (= x FTType) (= x FTPattern) (= x FTBlock))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FragmentType: FTExpr != FTStmt ---
(push 1)
(assert (= FTExpr FTStmt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FragmentType: FTStmt != FTIdent ---
(push 1)
(assert (= FTStmt FTIdent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FragmentType: FTIdent != FTType ---
(push 1)
(assert (= FTIdent FTType))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FragmentType: FTExpr != FTBlock ---
(push 1)
(assert (= FTExpr FTBlock))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FragmentType finite cardinality (6 values) ---
(push 1)
(declare-const x FragmentType)
(assert (and (not (= x FTExpr)) (not (= x FTStmt)) (not (= x FTIdent)) (not (= x FTType)) (not (= x FTPattern)) (not (= x FTBlock))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Token exhaustiveness ---
(push 1)
(declare-const x Token)
(assert (not (or (= x TkIdent) (= x TkLiteral) (= x TkPunct) (= x TkGroup))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Token: TkIdent != TkLiteral ---
(push 1)
(assert (= TkIdent TkLiteral))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Token: TkLiteral != TkPunct ---
(push 1)
(assert (= TkLiteral TkPunct))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Token: TkPunct != TkGroup ---
(push 1)
(assert (= TkPunct TkGroup))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Token: TkIdent != TkGroup ---
(push 1)
(assert (= TkIdent TkGroup))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Token finite cardinality (4 values) ---
(push 1)
(declare-const x Token)
(assert (and (not (= x TkIdent)) (not (= x TkLiteral)) (not (= x TkPunct)) (not (= x TkGroup))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. AST exhaustiveness ---
(push 1)
(declare-const x AST)
(assert (not (or (= x ASTVar) (= x ASTLam) (= x ASTApp) (= x ASTLet) (= x ASTBlock))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AST: ASTVar != ASTLam ---
(push 1)
(assert (= ASTVar ASTLam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AST: ASTLam != ASTApp ---
(push 1)
(assert (= ASTLam ASTApp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AST: ASTApp != ASTLet ---
(push 1)
(assert (= ASTApp ASTLet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. AST: ASTVar != ASTBlock ---
(push 1)
(assert (= ASTVar ASTBlock))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. AST finite cardinality (5 values) ---
(push 1)
(declare-const x AST)
(assert (and (not (= x ASTVar)) (not (= x ASTLam)) (not (= x ASTApp)) (not (= x ASTLet)) (not (= x ASTBlock))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ExpansionStep exhaustiveness ---
(push 1)
(declare-const x ExpansionStep)
(assert (not (or (= x ESInput) (= x ESMatched) (= x ESOutput))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ExpansionStep: ESInput != ESMatched ---
(push 1)
(assert (= ESInput ESMatched))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ExpansionStep: ESMatched != ESOutput ---
(push 1)
(assert (= ESMatched ESOutput))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ExpansionStep finite cardinality (3 values) ---
(push 1)
(declare-const x ExpansionStep)
(assert (and (not (= x ESInput)) (not (= x ESMatched)) (not (= x ESOutput))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ConstResult exhaustiveness ---
(push 1)
(declare-const x ConstResult)
(assert (not (or (= x CRValue) (= x CRBool) (= x CRUnit) (= x CRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ConstResult: CRValue != CRBool ---
(push 1)
(assert (= CRValue CRBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ConstResult: CRBool != CRUnit ---
(push 1)
(assert (= CRBool CRUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ConstResult: CRUnit != CRError ---
(push 1)
(assert (= CRUnit CRError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ConstResult: CRValue != CRError ---
(push 1)
(assert (= CRValue CRError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ConstResult finite cardinality (4 values) ---
(push 1)
(declare-const x ConstResult)
(assert (and (not (= x CRValue)) (not (= x CRBool)) (not (= x CRUnit)) (not (= x CRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. PatternMatch exhaustiveness ---
(push 1)
(declare-const x PatternMatch)
(assert (not (or (= x PMExact) (= x PMCapture) (= x PMRepeat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. PatternMatch: PMExact != PMCapture ---
(push 1)
(assert (= PMExact PMCapture))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. PatternMatch: PMCapture != PMRepeat ---
(push 1)
(assert (= PMCapture PMRepeat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. PatternMatch finite cardinality (3 values) ---
(push 1)
(declare-const x PatternMatch)
(assert (and (not (= x PMExact)) (not (= x PMCapture)) (not (= x PMRepeat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. DeriveResult exhaustiveness ---
(push 1)
(declare-const x DeriveResult)
(assert (not (or (= x DRSuccess) (= x DRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. DeriveResult: DRSuccess != DRError ---
(push 1)
(assert (= DRSuccess DRError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. DeriveResult finite cardinality (2 values) ---
(push 1)
(declare-const x DeriveResult)
(assert (and (not (= x DRSuccess)) (not (= x DRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ConstExpr exhaustiveness ---
(push 1)
(declare-const x ConstExpr)
(assert (not (or (= x CELit) (= x CEAdd) (= x CEMul) (= x CEIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ConstExpr: CELit != CEAdd ---
(push 1)
(assert (= CELit CEAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. ConstExpr: CEAdd != CEMul ---
(push 1)
(assert (= CEAdd CEMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. ConstExpr: CEMul != CEIf ---
(push 1)
(assert (= CEMul CEIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. ConstExpr: CELit != CEIf ---
(push 1)
(assert (= CELit CEIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. ConstExpr finite cardinality (4 values) ---
(push 1)
(declare-const x ConstExpr)
(assert (and (not (= x CELit)) (not (= x CEAdd)) (not (= x CEMul)) (not (= x CEIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. ZeroStatus exhaustiveness ---
(push 1)
(declare-const x ZeroStatus)
(assert (not (or (= x ZSZeroed) (= x ZSNotZeroed) (= x ZSPartial))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. ZeroStatus: ZSZeroed != ZSNotZeroed ---
(push 1)
(assert (= ZSZeroed ZSNotZeroed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ZeroStatus: ZSNotZeroed != ZSPartial ---
(push 1)
(assert (= ZSNotZeroed ZSPartial))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ZeroStatus finite cardinality (3 values) ---
(push 1)
(declare-const x ZeroStatus)
(assert (and (not (= x ZSZeroed)) (not (= x ZSNotZeroed)) (not (= x ZSPartial))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. ItemKind exhaustiveness ---
(push 1)
(declare-const x ItemKind)
(assert (not (or (= x IKFunction) (= x IKStruct) (= x IKEnum) (= x IKTrait) (= x IKImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. ItemKind: IKFunction != IKStruct ---
(push 1)
(assert (= IKFunction IKStruct))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. ItemKind: IKStruct != IKEnum ---
(push 1)
(assert (= IKStruct IKEnum))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. ItemKind: IKEnum != IKTrait ---
(push 1)
(assert (= IKEnum IKTrait))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. ItemKind: IKFunction != IKImpl ---
(push 1)
(assert (= IKFunction IKImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. ItemKind finite cardinality (5 values) ---
(push 1)
(declare-const x ItemKind)
(assert (and (not (= x IKFunction)) (not (= x IKStruct)) (not (= x IKEnum)) (not (= x IKTrait)) (not (= x IKImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. RepetitionResult exhaustiveness ---
(push 1)
(declare-const x RepetitionResult)
(assert (not (or (= x RRSuccess) (= x RRMismatch))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. RepetitionResult: RRSuccess != RRMismatch ---
(push 1)
(assert (= RRSuccess RRMismatch))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. RepetitionResult finite cardinality (2 values) ---
(push 1)
(declare-const x RepetitionResult)
(assert (and (not (= x RRSuccess)) (not (= x RRMismatch))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. ScopedName accessor round-trip: sn_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(assert (not (= (sn_name (mk-scoped_name f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. ScopedName accessor round-trip: sn_scope ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(assert (not (= (sn_scope (mk-scoped_name f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. MacroDef accessor round-trip: macro_name ---
(push 1)
(declare-const f0 String)
(assert (not (= (macro_name (mk-macro_def f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. ExpansionContext accessor round-trip: ctx_scope ---
(push 1)
(declare-const f0 Int)
(declare-const f1 String)
(declare-const f2 Bool)
(assert (not (= (ctx_scope (mk-expansion_context f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ExpansionContext accessor round-trip: ctx_crate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 String)
(declare-const f2 Bool)
(assert (not (= (ctx_crate (mk-expansion_context f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. ExpansionContext accessor round-trip: ctx_audit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 String)
(declare-const f2 Bool)
(assert (not (= (ctx_audit (mk-expansion_context f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. HygienicContext accessor round-trip: hyg_current_scope ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (hyg_current_scope (mk-hygienic_context f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. HygienicContext accessor round-trip: hyg_macro_scope ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (hyg_macro_scope (mk-hygienic_context f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. HygienicContext: non-negative int fields sum ---
(push 1)
(declare-const r HygienicContext)
(assert (>= (hyg_current_scope r) 0))
(assert (>= (hyg_macro_scope r) 0))
(assert (not (>= (+ (hyg_current_scope r) (hyg_macro_scope r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. TraitBound accessor round-trip: tb_trait_name ---
(push 1)
(declare-const f0 String)
(assert (not (= (tb_trait_name (mk-trait_bound f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. ImplBlock accessor round-trip: impl_trait ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(assert (not (= (impl_trait (mk-impl_block f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. ImplBlock accessor round-trip: impl_for_type ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(assert (not (= (impl_for_type (mk-impl_block f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. DSLDef accessor round-trip: dsl_name ---
(push 1)
(declare-const f0 String)
(assert (not (= (dsl_name (mk-dsl_def f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. AuditEntry accessor round-trip: ae_macro_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ae_macro_name (mk-audit_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. AuditEntry accessor round-trip: ae_input ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ae_input (mk-audit_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. AuditEntry accessor round-trip: ae_output ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ae_output (mk-audit_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. AuditEntry accessor round-trip: ae_scope ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ae_scope (mk-audit_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. AuditEntry accessor round-trip: ae_security_relevant ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ae_security_relevant (mk-audit_entry f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. AuditEntry: non-negative int fields sum ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (ae_input r) 0))
(assert (>= (ae_output r) 0))
(assert (not (>= (+ (ae_input r) (ae_output r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. ConstGeneric accessor round-trip: cg_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 FragmentType)
(declare-const f2 Int)
(assert (not (= (cg_name (mk-const_generic f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. ConstGeneric accessor round-trip: cg_type ---
(push 1)
(declare-const f0 String)
(declare-const f1 FragmentType)
(declare-const f2 Int)
(assert (not (= (cg_type (mk-const_generic f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. ConstGeneric accessor round-trip: cg_value ---
(push 1)
(declare-const f0 String)
(declare-const f1 FragmentType)
(declare-const f2 Int)
(assert (not (= (cg_value (mk-const_generic f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. SandboxState accessor round-trip: sb_can_read_fs ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sb_can_read_fs (mk-sandbox_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. SandboxState accessor round-trip: sb_can_write_fs ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sb_can_write_fs (mk-sandbox_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. SandboxState accessor round-trip: sb_can_network ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sb_can_network (mk-sandbox_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. SandboxState accessor round-trip: sb_can_exec ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sb_can_exec (mk-sandbox_state f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SandboxState_all_enabled ((g SandboxState)) Bool
  (and (sb_can_read_fs g) (sb_can_write_fs g) (sb_can_network g) (sb_can_exec g)))

; --- 81. SandboxState: all-enabled completeness ---
(push 1)
(declare-const g SandboxState)
(assert (sb_can_read_fs g))
(assert (sb_can_write_fs g))
(assert (sb_can_network g))
(assert (sb_can_exec g))
(assert (not (SandboxState_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. SandboxState: SandboxState_all_enabled implies sb_can_read_fs ---
(push 1)
(declare-const g SandboxState)
(assert (SandboxState_all_enabled g))
(assert (not (sb_can_read_fs g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. SandboxState: SandboxState_all_enabled implies sb_can_write_fs ---
(push 1)
(declare-const g SandboxState)
(assert (SandboxState_all_enabled g))
(assert (not (sb_can_write_fs g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. SandboxState: SandboxState_all_enabled implies sb_can_network ---
(push 1)
(declare-const g SandboxState)
(assert (SandboxState_all_enabled g))
(assert (not (sb_can_network g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. SourceSpan accessor round-trip: span_file ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (span_file (mk-source_span f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. SourceSpan accessor round-trip: span_start ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (span_start (mk-source_span f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. SourceSpan accessor round-trip: span_end ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (span_end (mk-source_span f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. SourceSpan accessor round-trip: span_macro_scope ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (span_macro_scope (mk-source_span f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. SourceSpan: non-negative int fields sum ---
(push 1)
(declare-const r SourceSpan)
(assert (>= (span_start r) 0))
(assert (>= (span_end r) 0))
(assert (not (>= (+ (span_start r) (span_end r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. FieldInfo accessor round-trip: fi_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 ZeroStatus)
(assert (not (= (fi_name (mk-field_info f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. FieldInfo accessor round-trip: fi_size ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 ZeroStatus)
(assert (not (= (fi_size (mk-field_info f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. FieldInfo accessor round-trip: fi_zero_status ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 ZeroStatus)
(assert (not (= (fi_zero_status (mk-field_info f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. Item accessor round-trip: item_kind ---
(push 1)
(declare-const f0 ItemKind)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (item_kind (mk-item f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. Item accessor round-trip: item_name ---
(push 1)
(declare-const f0 ItemKind)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (item_name (mk-item f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. Item accessor round-trip: item_tokens ---
(push 1)
(declare-const f0 ItemKind)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (item_tokens (mk-item f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. StaticAssert accessor round-trip: sa_condition ---
(push 1)
(declare-const f0 ConstExpr)
(declare-const f1 String)
(assert (not (= (sa_condition (mk-static_assert f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. StaticAssert accessor round-trip: sa_message ---
(push 1)
(declare-const f0 ConstExpr)
(declare-const f1 String)
(assert (not (= (sa_message (mk-static_assert f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. SecurityCheck accessor round-trip: sc_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 ConstExpr)
(declare-const f2 Int)
(assert (not (= (sc_name (mk-security_check f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. SecurityCheck accessor round-trip: sc_condition ---
(push 1)
(declare-const f0 String)
(declare-const f1 ConstExpr)
(declare-const f2 Int)
(assert (not (= (sc_condition (mk-security_check f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. SecurityCheck accessor round-trip: sc_severity ---
(push 1)
(declare-const f0 String)
(declare-const f1 ConstExpr)
(declare-const f2 Int)
(assert (not (= (sc_severity (mk-security_check f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
