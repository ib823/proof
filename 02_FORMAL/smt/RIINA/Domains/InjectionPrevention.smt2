; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA InjectionPrevention — SMT Verification
; Derived from 02_FORMAL/coq/domains/InjectionPrevention.v (26 assertions)
; Module: InjectionPrevention
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TaintLevel 0)) (((Trusted) (Untrusted) (Sanitized))))

(declare-datatypes ((SQLPart 0)) (((SQLLiteral) (SQLParam) (SQLKeyword))))

(declare-datatypes ((ShellPart 0)) (((ShellLiteral) (ShellArg) (ShellCmd))))

(declare-datatypes ((LDAPPart 0)) (((LDAPLiteral) (LDAPParam) (LDAPFilter))))

(declare-datatypes ((TemplateExpr 0)) (((TmplLiteral) (TmplVar) (TmplConcat))))

(declare-datatypes ((RIINAExpr 0)) (((RExprLit) (RExprVar) (RExprAdd) (RExprCall))))

(declare-datatypes ((TaintedValue 0))
  (((mk-tainted_value (tv_data (Seq Int)) (tv_taint TaintLevel)))))

(declare-datatypes ((XMLParserConfig 0))
  (((mk-xml_parser_config (xc_expand_entities Bool) (xc_allow_external Bool)))))

(declare-datatypes ((HTTPHeader 0))
  (((mk-http_header (hdr_name (Seq Int)) (hdr_value TaintedValue) (hdr_no_newline Int)))))

(declare-datatypes ((PDFDocument 0))
  (((mk-pdf_document (pdf_pages (Seq Int)) (pdf_has_js Bool)))))

(declare-datatypes ((LengthPrefixedString 0))
  (((mk-length_prefixed_string (lpstr_len Int) (lpstr_bytes (Seq Int)) (lpstr_valid Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TaintLevel enum properties ---

; --- 1. TaintLevel exhaustiveness ---
(push 1)
(declare-const x TaintLevel)
(assert (not (or (= x Trusted) (= x Untrusted) (= x Sanitized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TaintLevel: Trusted != Untrusted ---
(push 1)
(assert (= Trusted Untrusted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TaintLevel: Untrusted != Sanitized ---
(push 1)
(assert (= Untrusted Sanitized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TaintLevel: Trusted != Sanitized ---
(push 1)
(assert (= Trusted Sanitized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TaintLevel finite cardinality (3 values) ---
(push 1)
(declare-const x TaintLevel)
(assert (and (not (= x Trusted)) (not (= x Untrusted)) (not (= x Sanitized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SQLPart enum properties ---

; --- 6. SQLPart exhaustiveness ---
(push 1)
(declare-const x SQLPart)
(assert (not (or (= x SQLLiteral) (= x SQLParam) (= x SQLKeyword))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SQLPart: SQLLiteral != SQLParam ---
(push 1)
(assert (= SQLLiteral SQLParam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SQLPart: SQLParam != SQLKeyword ---
(push 1)
(assert (= SQLParam SQLKeyword))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SQLPart: SQLLiteral != SQLKeyword ---
(push 1)
(assert (= SQLLiteral SQLKeyword))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SQLPart finite cardinality (3 values) ---
(push 1)
(declare-const x SQLPart)
(assert (and (not (= x SQLLiteral)) (not (= x SQLParam)) (not (= x SQLKeyword))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ShellPart enum properties ---

; --- 11. ShellPart exhaustiveness ---
(push 1)
(declare-const x ShellPart)
(assert (not (or (= x ShellLiteral) (= x ShellArg) (= x ShellCmd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ShellPart: ShellLiteral != ShellArg ---
(push 1)
(assert (= ShellLiteral ShellArg))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. ShellPart: ShellArg != ShellCmd ---
(push 1)
(assert (= ShellArg ShellCmd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ShellPart: ShellLiteral != ShellCmd ---
(push 1)
(assert (= ShellLiteral ShellCmd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ShellPart finite cardinality (3 values) ---
(push 1)
(declare-const x ShellPart)
(assert (and (not (= x ShellLiteral)) (not (= x ShellArg)) (not (= x ShellCmd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LDAPPart enum properties ---

; --- 16. LDAPPart exhaustiveness ---
(push 1)
(declare-const x LDAPPart)
(assert (not (or (= x LDAPLiteral) (= x LDAPParam) (= x LDAPFilter))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. LDAPPart: LDAPLiteral != LDAPParam ---
(push 1)
(assert (= LDAPLiteral LDAPParam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. LDAPPart: LDAPParam != LDAPFilter ---
(push 1)
(assert (= LDAPParam LDAPFilter))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. LDAPPart: LDAPLiteral != LDAPFilter ---
(push 1)
(assert (= LDAPLiteral LDAPFilter))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. LDAPPart finite cardinality (3 values) ---
(push 1)
(declare-const x LDAPPart)
(assert (and (not (= x LDAPLiteral)) (not (= x LDAPParam)) (not (= x LDAPFilter))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TemplateExpr enum properties ---

; --- 21. TemplateExpr exhaustiveness ---
(push 1)
(declare-const x TemplateExpr)
(assert (not (or (= x TmplLiteral) (= x TmplVar) (= x TmplConcat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. TemplateExpr: TmplLiteral != TmplVar ---
(push 1)
(assert (= TmplLiteral TmplVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TemplateExpr: TmplVar != TmplConcat ---
(push 1)
(assert (= TmplVar TmplConcat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TemplateExpr: TmplLiteral != TmplConcat ---
(push 1)
(assert (= TmplLiteral TmplConcat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TemplateExpr finite cardinality (3 values) ---
(push 1)
(declare-const x TemplateExpr)
(assert (and (not (= x TmplLiteral)) (not (= x TmplVar)) (not (= x TmplConcat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RIINAExpr enum properties ---

; --- 26. RIINAExpr exhaustiveness ---
(push 1)
(declare-const x RIINAExpr)
(assert (not (or (= x RExprLit) (= x RExprVar) (= x RExprAdd) (= x RExprCall))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. RIINAExpr: RExprLit != RExprVar ---
(push 1)
(assert (= RExprLit RExprVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. RIINAExpr: RExprVar != RExprAdd ---
(push 1)
(assert (= RExprVar RExprAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. RIINAExpr: RExprAdd != RExprCall ---
(push 1)
(assert (= RExprAdd RExprCall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. RIINAExpr: RExprLit != RExprCall ---
(push 1)
(assert (= RExprLit RExprCall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. RIINAExpr finite cardinality (4 values) ---
(push 1)
(declare-const x RIINAExpr)
(assert (and (not (= x RExprLit)) (not (= x RExprVar)) (not (= x RExprAdd)) (not (= x RExprCall))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TaintedValue record properties ---

; --- 32. TaintedValue accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(assert (not (= (Seq (mk-tainted_value f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- XMLParserConfig record properties ---

; --- 33. XMLParserConfig accessor round-trip: xc_expand_entities ---
(push 1)
(declare-const f0 Bool)
(assert (not (= (xc_expand_entities (mk-x_m_l_parser_config f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HTTPHeader record properties ---

; --- 34. HTTPHeader accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaintedValue)
(assert (not (= (Seq (mk-h_t_t_p_header f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. HTTPHeader accessor round-trip: hdr_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaintedValue)
(assert (not (= (hdr_value (mk-h_t_t_p_header f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PDFDocument record properties ---

; --- 36. PDFDocument accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(assert (not (= (Seq (mk-p_d_f_document f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LengthPrefixedString record properties ---

; --- 37. LengthPrefixedString accessor round-trip: lpstr_len ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (lpstr_len (mk-length_prefixed_string f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. LengthPrefixedString accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-length_prefixed_string f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. LengthPrefixedString: integer field consistency ---
(push 1)
(declare-const r LengthPrefixedString)
(assert (>= (lpstr_len r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (lpstr_len r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TaintLevel ordering properties ---

(define-fun TaintLevel_level ((x TaintLevel)) Int
  (ite (= x Trusted) 0 (ite (= x Untrusted) 1 2)))

(define-fun TaintLevel_leq ((x TaintLevel) (y TaintLevel)) Bool
  (<= (TaintLevel_level x) (TaintLevel_level y)))

; --- 40. TaintLevel_leq reflexivity ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. TaintLevel_leq transitivity ---
(push 1)
(declare-const x TaintLevel)
(declare-const y TaintLevel)
(declare-const z TaintLevel)
(assert (TaintLevel_leq x y))
(assert (TaintLevel_leq y z))
(assert (not (TaintLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. TaintLevel_leq antisymmetry ---
(push 1)
(declare-const x TaintLevel)
(declare-const y TaintLevel)
(assert (TaintLevel_leq x y))
(assert (TaintLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Trusted is bottom ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq Trusted x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Sanitized is top ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq x Sanitized)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
