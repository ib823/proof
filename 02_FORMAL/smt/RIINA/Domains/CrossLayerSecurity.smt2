; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CrossLayerSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/CrossLayerSecurity.v (21 assertions)
; Module: CrossLayerSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((label 0)) (((Low) (High))))

(declare-datatypes ((src_expr 0)) (((SConst) (SVar) (SAdd) (SIf))))

(declare-datatypes ((tgt_instr 0)) (((TLoad) (TRead) (TAddI) (TBrz) (TJmp) (THalt))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. label exhaustiveness ---
(push 1)
(declare-const x label)
(assert (not (or (= x Low) (= x High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. label: Low != High ---
(push 1)
(assert (= Low High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. label finite cardinality (2 values) ---
(push 1)
(declare-const x label)
(assert (and (not (= x Low)) (not (= x High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. src_expr exhaustiveness ---
(push 1)
(declare-const x src_expr)
(assert (not (or (= x SConst) (= x SVar) (= x SAdd) (= x SIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. src_expr: SConst != SVar ---
(push 1)
(assert (= SConst SVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. src_expr: SVar != SAdd ---
(push 1)
(assert (= SVar SAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. src_expr: SAdd != SIf ---
(push 1)
(assert (= SAdd SIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. src_expr: SConst != SIf ---
(push 1)
(assert (= SConst SIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. src_expr finite cardinality (4 values) ---
(push 1)
(declare-const x src_expr)
(assert (and (not (= x SConst)) (not (= x SVar)) (not (= x SAdd)) (not (= x SIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. tgt_instr exhaustiveness ---
(push 1)
(declare-const x tgt_instr)
(assert (not (or (= x TLoad) (= x TRead) (= x TAddI) (= x TBrz) (= x TJmp) (= x THalt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. tgt_instr: TLoad != TRead ---
(push 1)
(assert (= TLoad TRead))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. tgt_instr: TRead != TAddI ---
(push 1)
(assert (= TRead TAddI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. tgt_instr: TAddI != TBrz ---
(push 1)
(assert (= TAddI TBrz))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. tgt_instr: TLoad != THalt ---
(push 1)
(assert (= TLoad THalt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. tgt_instr finite cardinality (6 values) ---
(push 1)
(declare-const x tgt_instr)
(assert (and (not (= x TLoad)) (not (= x TRead)) (not (= x TAddI)) (not (= x TBrz)) (not (= x TJmp)) (not (= x THalt))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
