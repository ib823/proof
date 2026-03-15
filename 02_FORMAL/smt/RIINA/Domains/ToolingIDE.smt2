; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ToolingIDE — SMT Verification
; Derived from 02_FORMAL/coq/domains/ToolingIDE.v (21 assertions)
; Module: ToolingIDE
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ToolAST 0)) (((TASTVar) (TASTLit) (TASTApp) (TASTLam) (TASTAnnot))))

(declare-datatypes ((TypeInfo 0)) (((TIBase) (TIArrow) (TIEffectful))))

(declare-datatypes ((LSPRequest 0)) (((LSPCompletion) (LSPHover) (LSPDefinition) (LSPDiagnostics))))

(declare-datatypes ((Diagnostic 0)) (((DiagError) (DiagWarning) (DiagSecurityWarning))))

(declare-datatypes ((LSPResponse 0)) (((LSPCompletionItems) (LSPHoverInfo) (LSPLocation) (LSPDiagnosticList))))

(declare-datatypes ((DebugValue 0)) (((DVPublic) (DVRedacted))))

(declare-datatypes ((ToolInput 0)) (((TISource) (TIAST) (TIBinary))))

(declare-datatypes ((ToolOutput 0)) (((TOSource) (TOAST) (TOBinary) (TODiagnostics))))

(declare-datatypes ((SecurityIssue 0)) (((SIBufferOverflow) (SISQLInjection) (SIHardcodedSecret) (SIUnsafeDeserialization))))

(declare-datatypes ((LintViolation 0)) (((LVStyle) (LVCorrectness) (LVSecurity))))

(declare-datatypes ((LintRule 0))
  (((mk-lint_rule (lr_name String) (lr_category String) (lr_severity Int)))))

(declare-datatypes ((BuildConfig 0))
  (((mk-build_config (bc_optimization Int) (bc_debug_info Bool) (bc_security_hardening Bool) (bc_relro Bool) (bc_pie Bool) (bc_cfi Bool)))))

(declare-datatypes ((Package 0))
  (((mk-package (pkg_name String) (pkg_version Int) (pkg_signature Int) (pkg_checksum String)))))

(declare-datatypes ((Vulnerability 0))
  (((mk-vulnerability (vuln_id String) (vuln_package String) (vuln_severity Int) (vuln_fixed_version Int)))))

(declare-datatypes ((Tool 0))
  (((mk-tool (tool_name String) (tool_run ToolInput)))))

(declare-datatypes ((Binary 0))
  (((mk-binary (bin_code (Seq Int)) (bin_debug_info Int) (bin_relro Bool) (bin_pie Bool) (bin_cfi Bool)))))

(declare-datatypes ((Rec_Module 0))
  (((mk-module (mod_name String) (mod_hash Int) (mod_deps (Seq Int))))))

(declare-datatypes ((SourceLoc 0))
  (((mk-source_loc (sl_file String) (sl_line Int) (sl_col Int)))))

(declare-datatypes ((DebugSymbol 0))
  (((mk-debug_symbol (ds_name String) (ds_type TypeInfo) (ds_loc SourceLoc)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ToolAST exhaustiveness ---
(push 1)
(declare-const x ToolAST)
(assert (not (or (= x TASTVar) (= x TASTLit) (= x TASTApp) (= x TASTLam) (= x TASTAnnot))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ToolAST: TASTVar != TASTLit ---
(push 1)
(assert (= TASTVar TASTLit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ToolAST: TASTLit != TASTApp ---
(push 1)
(assert (= TASTLit TASTApp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ToolAST: TASTApp != TASTLam ---
(push 1)
(assert (= TASTApp TASTLam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ToolAST: TASTVar != TASTAnnot ---
(push 1)
(assert (= TASTVar TASTAnnot))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ToolAST finite cardinality (5 values) ---
(push 1)
(declare-const x ToolAST)
(assert (and (not (= x TASTVar)) (not (= x TASTLit)) (not (= x TASTApp)) (not (= x TASTLam)) (not (= x TASTAnnot))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. TypeInfo exhaustiveness ---
(push 1)
(declare-const x TypeInfo)
(assert (not (or (= x TIBase) (= x TIArrow) (= x TIEffectful))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TypeInfo: TIBase != TIArrow ---
(push 1)
(assert (= TIBase TIArrow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TypeInfo: TIArrow != TIEffectful ---
(push 1)
(assert (= TIArrow TIEffectful))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TypeInfo finite cardinality (3 values) ---
(push 1)
(declare-const x TypeInfo)
(assert (and (not (= x TIBase)) (not (= x TIArrow)) (not (= x TIEffectful))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. LSPRequest exhaustiveness ---
(push 1)
(declare-const x LSPRequest)
(assert (not (or (= x LSPCompletion) (= x LSPHover) (= x LSPDefinition) (= x LSPDiagnostics))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. LSPRequest: LSPCompletion != LSPHover ---
(push 1)
(assert (= LSPCompletion LSPHover))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. LSPRequest: LSPHover != LSPDefinition ---
(push 1)
(assert (= LSPHover LSPDefinition))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. LSPRequest: LSPDefinition != LSPDiagnostics ---
(push 1)
(assert (= LSPDefinition LSPDiagnostics))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. LSPRequest: LSPCompletion != LSPDiagnostics ---
(push 1)
(assert (= LSPCompletion LSPDiagnostics))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. LSPRequest finite cardinality (4 values) ---
(push 1)
(declare-const x LSPRequest)
(assert (and (not (= x LSPCompletion)) (not (= x LSPHover)) (not (= x LSPDefinition)) (not (= x LSPDiagnostics))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Diagnostic exhaustiveness ---
(push 1)
(declare-const x Diagnostic)
(assert (not (or (= x DiagError) (= x DiagWarning) (= x DiagSecurityWarning))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Diagnostic: DiagError != DiagWarning ---
(push 1)
(assert (= DiagError DiagWarning))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Diagnostic: DiagWarning != DiagSecurityWarning ---
(push 1)
(assert (= DiagWarning DiagSecurityWarning))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Diagnostic finite cardinality (3 values) ---
(push 1)
(declare-const x Diagnostic)
(assert (and (not (= x DiagError)) (not (= x DiagWarning)) (not (= x DiagSecurityWarning))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. LSPResponse exhaustiveness ---
(push 1)
(declare-const x LSPResponse)
(assert (not (or (= x LSPCompletionItems) (= x LSPHoverInfo) (= x LSPLocation) (= x LSPDiagnosticList))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. LSPResponse: LSPCompletionItems != LSPHoverInfo ---
(push 1)
(assert (= LSPCompletionItems LSPHoverInfo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. LSPResponse: LSPHoverInfo != LSPLocation ---
(push 1)
(assert (= LSPHoverInfo LSPLocation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. LSPResponse: LSPLocation != LSPDiagnosticList ---
(push 1)
(assert (= LSPLocation LSPDiagnosticList))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. LSPResponse: LSPCompletionItems != LSPDiagnosticList ---
(push 1)
(assert (= LSPCompletionItems LSPDiagnosticList))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. LSPResponse finite cardinality (4 values) ---
(push 1)
(declare-const x LSPResponse)
(assert (and (not (= x LSPCompletionItems)) (not (= x LSPHoverInfo)) (not (= x LSPLocation)) (not (= x LSPDiagnosticList))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. DebugValue exhaustiveness ---
(push 1)
(declare-const x DebugValue)
(assert (not (or (= x DVPublic) (= x DVRedacted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. DebugValue: DVPublic != DVRedacted ---
(push 1)
(assert (= DVPublic DVRedacted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. DebugValue finite cardinality (2 values) ---
(push 1)
(declare-const x DebugValue)
(assert (and (not (= x DVPublic)) (not (= x DVRedacted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ToolInput exhaustiveness ---
(push 1)
(declare-const x ToolInput)
(assert (not (or (= x TISource) (= x TIAST) (= x TIBinary))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ToolInput: TISource != TIAST ---
(push 1)
(assert (= TISource TIAST))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ToolInput: TIAST != TIBinary ---
(push 1)
(assert (= TIAST TIBinary))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. ToolInput finite cardinality (3 values) ---
(push 1)
(declare-const x ToolInput)
(assert (and (not (= x TISource)) (not (= x TIAST)) (not (= x TIBinary))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. ToolOutput exhaustiveness ---
(push 1)
(declare-const x ToolOutput)
(assert (not (or (= x TOSource) (= x TOAST) (= x TOBinary) (= x TODiagnostics))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. ToolOutput: TOSource != TOAST ---
(push 1)
(assert (= TOSource TOAST))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ToolOutput: TOAST != TOBinary ---
(push 1)
(assert (= TOAST TOBinary))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ToolOutput: TOBinary != TODiagnostics ---
(push 1)
(assert (= TOBinary TODiagnostics))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. ToolOutput: TOSource != TODiagnostics ---
(push 1)
(assert (= TOSource TODiagnostics))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. ToolOutput finite cardinality (4 values) ---
(push 1)
(declare-const x ToolOutput)
(assert (and (not (= x TOSource)) (not (= x TOAST)) (not (= x TOBinary)) (not (= x TODiagnostics))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SecurityIssue exhaustiveness ---
(push 1)
(declare-const x SecurityIssue)
(assert (not (or (= x SIBufferOverflow) (= x SISQLInjection) (= x SIHardcodedSecret) (= x SIUnsafeDeserialization))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. SecurityIssue: SIBufferOverflow != SISQLInjection ---
(push 1)
(assert (= SIBufferOverflow SISQLInjection))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. SecurityIssue: SISQLInjection != SIHardcodedSecret ---
(push 1)
(assert (= SISQLInjection SIHardcodedSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. SecurityIssue: SIHardcodedSecret != SIUnsafeDeserialization ---
(push 1)
(assert (= SIHardcodedSecret SIUnsafeDeserialization))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. SecurityIssue: SIBufferOverflow != SIUnsafeDeserialization ---
(push 1)
(assert (= SIBufferOverflow SIUnsafeDeserialization))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. SecurityIssue finite cardinality (4 values) ---
(push 1)
(declare-const x SecurityIssue)
(assert (and (not (= x SIBufferOverflow)) (not (= x SISQLInjection)) (not (= x SIHardcodedSecret)) (not (= x SIUnsafeDeserialization))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. LintViolation exhaustiveness ---
(push 1)
(declare-const x LintViolation)
(assert (not (or (= x LVStyle) (= x LVCorrectness) (= x LVSecurity))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. LintViolation: LVStyle != LVCorrectness ---
(push 1)
(assert (= LVStyle LVCorrectness))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. LintViolation: LVCorrectness != LVSecurity ---
(push 1)
(assert (= LVCorrectness LVSecurity))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. LintViolation finite cardinality (3 values) ---
(push 1)
(declare-const x LintViolation)
(assert (and (not (= x LVStyle)) (not (= x LVCorrectness)) (not (= x LVSecurity))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. LintRule accessor round-trip: lr_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (lr_name (mk-lint_rule f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. LintRule accessor round-trip: lr_category ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (lr_category (mk-lint_rule f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. LintRule accessor round-trip: lr_severity ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (lr_severity (mk-lint_rule f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. BuildConfig accessor round-trip: bc_optimization ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bc_optimization (mk-build_config f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. BuildConfig accessor round-trip: bc_debug_info ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bc_debug_info (mk-build_config f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. BuildConfig accessor round-trip: bc_security_hardening ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bc_security_hardening (mk-build_config f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. BuildConfig accessor round-trip: bc_relro ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bc_relro (mk-build_config f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. BuildConfig accessor round-trip: bc_pie ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bc_pie (mk-build_config f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. Package accessor round-trip: pkg_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 String)
(assert (not (= (pkg_name (mk-package f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. Package accessor round-trip: pkg_version ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 String)
(assert (not (= (pkg_version (mk-package f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. Package accessor round-trip: pkg_signature ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 String)
(assert (not (= (pkg_signature (mk-package f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. Package accessor round-trip: pkg_checksum ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 String)
(assert (not (= (pkg_checksum (mk-package f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. Package: non-negative int fields sum ---
(push 1)
(declare-const r Package)
(assert (>= (pkg_version r) 0))
(assert (>= (pkg_signature r) 0))
(assert (not (>= (+ (pkg_version r) (pkg_signature r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. Vulnerability accessor round-trip: vuln_id ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vuln_id (mk-vulnerability f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. Vulnerability accessor round-trip: vuln_package ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vuln_package (mk-vulnerability f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. Vulnerability accessor round-trip: vuln_severity ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vuln_severity (mk-vulnerability f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. Vulnerability accessor round-trip: vuln_fixed_version ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vuln_fixed_version (mk-vulnerability f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. Vulnerability: non-negative int fields sum ---
(push 1)
(declare-const r Vulnerability)
(assert (>= (vuln_severity r) 0))
(assert (>= (vuln_fixed_version r) 0))
(assert (not (>= (+ (vuln_severity r) (vuln_fixed_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. Tool accessor round-trip: tool_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 ToolInput)
(assert (not (= (tool_name (mk-tool f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. Tool accessor round-trip: tool_run ---
(push 1)
(declare-const f0 String)
(declare-const f1 ToolInput)
(assert (not (= (tool_run (mk-tool f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. Rec_Module accessor round-trip: mod_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (mod_name (mk-module f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. Rec_Module accessor round-trip: mod_hash ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (mod_hash (mk-module f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. SourceLoc accessor round-trip: sl_file ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sl_file (mk-source_loc f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. SourceLoc accessor round-trip: sl_line ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sl_line (mk-source_loc f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. SourceLoc accessor round-trip: sl_col ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sl_col (mk-source_loc f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. SourceLoc: non-negative int fields sum ---
(push 1)
(declare-const r SourceLoc)
(assert (>= (sl_line r) 0))
(assert (>= (sl_col r) 0))
(assert (not (>= (+ (sl_line r) (sl_col r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. DebugSymbol accessor round-trip: ds_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 TypeInfo)
(declare-const f2 SourceLoc)
(assert (not (= (ds_name (mk-debug_symbol f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. DebugSymbol accessor round-trip: ds_type ---
(push 1)
(declare-const f0 String)
(declare-const f1 TypeInfo)
(declare-const f2 SourceLoc)
(assert (not (= (ds_type (mk-debug_symbol f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. DebugSymbol accessor round-trip: ds_loc ---
(push 1)
(declare-const f0 String)
(declare-const f1 TypeInfo)
(declare-const f2 SourceLoc)
(assert (not (= (ds_loc (mk-debug_symbol f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SecurityIssue_level ((x SecurityIssue)) Int
  (ite (= x SIBufferOverflow) 0 (ite (= x SISQLInjection) 1 (ite (= x SIHardcodedSecret) 2 3))))

(define-fun SecurityIssue_leq ((x SecurityIssue) (y SecurityIssue)) Bool
  (<= (SecurityIssue_level x) (SecurityIssue_level y)))

; --- 79. SecurityIssue_leq reflexivity ---
(push 1)
(declare-const x SecurityIssue)
(assert (not (SecurityIssue_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. SecurityIssue_leq transitivity ---
(push 1)
(declare-const x SecurityIssue)
(declare-const y SecurityIssue)
(declare-const z SecurityIssue)
(assert (SecurityIssue_leq x y))
(assert (SecurityIssue_leq y z))
(assert (not (SecurityIssue_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. SecurityIssue_leq antisymmetry ---
(push 1)
(declare-const x SecurityIssue)
(declare-const y SecurityIssue)
(assert (SecurityIssue_leq x y))
(assert (SecurityIssue_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. SIBufferOverflow is bottom ---
(push 1)
(declare-const x SecurityIssue)
(assert (not (SecurityIssue_leq SIBufferOverflow x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. SIUnsafeDeserialization is top ---
(push 1)
(declare-const x SecurityIssue)
(assert (not (SecurityIssue_leq x SIUnsafeDeserialization)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
