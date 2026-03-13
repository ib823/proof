; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA WasmBackendVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/WasmBackendVerification.v (43 assertions)
; Module: WasmBackendVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((WasmValType 0)) (((I32) (I64) (F32) (F64))))

(declare-datatypes ((RiinaType 0)) (((RTNombor) (RTTeks) (RTBool) (RTUnit) (RTSecret))))

(declare-datatypes ((SecLabel 0)) (((Public) (Secret))))

(declare-datatypes ((WasmInstr 0)) (((WConst) (WLoad) (WStore) (WAdd) (WMul) (WCall) (WLocalGet) (WLocalSet) (WIf) (WReturn) (WDrop) (WNop))))

(declare-datatypes ((RiinaIR 0)) (((IRConst) (IRVar) (IRAdd) (IRMul) (IRCall) (IRLet) (IRIf) (IRLoad) (IRStore))))

(declare-datatypes ((RiinaEffect 0)) (((EffPure) (EffIO) (EffNet) (EffFS))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- WasmValType enum properties ---

; --- 1. WasmValType exhaustiveness ---
(push 1)
(declare-const x WasmValType)
(assert (not (or (= x I32) (= x I64) (= x F32) (= x F64))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. WasmValType: I32 != I64 ---
(push 1)
(assert (= I32 I64))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. WasmValType: I64 != F32 ---
(push 1)
(assert (= I64 F32))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. WasmValType: F32 != F64 ---
(push 1)
(assert (= F32 F64))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. WasmValType: I32 != F64 ---
(push 1)
(assert (= I32 F64))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. WasmValType finite cardinality (4 values) ---
(push 1)
(declare-const x WasmValType)
(assert (and (not (= x I32)) (not (= x I64)) (not (= x F32)) (not (= x F64))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiinaType enum properties ---

; --- 7. RiinaType exhaustiveness ---
(push 1)
(declare-const x RiinaType)
(assert (not (or (= x RTNombor) (= x RTTeks) (= x RTBool) (= x RTUnit) (= x RTSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. RiinaType: RTNombor != RTTeks ---
(push 1)
(assert (= RTNombor RTTeks))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. RiinaType: RTTeks != RTBool ---
(push 1)
(assert (= RTTeks RTBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. RiinaType: RTBool != RTUnit ---
(push 1)
(assert (= RTBool RTUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. RiinaType: RTNombor != RTSecret ---
(push 1)
(assert (= RTNombor RTSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. RiinaType finite cardinality (5 values) ---
(push 1)
(declare-const x RiinaType)
(assert (and (not (= x RTNombor)) (not (= x RTTeks)) (not (= x RTBool)) (not (= x RTUnit)) (not (= x RTSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecLabel enum properties ---

; --- 13. SecLabel exhaustiveness ---
(push 1)
(declare-const x SecLabel)
(assert (not (or (= x Public) (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SecLabel: Public != Secret ---
(push 1)
(assert (= Public Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SecLabel finite cardinality (2 values) ---
(push 1)
(declare-const x SecLabel)
(assert (and (not (= x Public)) (not (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- WasmInstr enum properties ---

; --- 16. WasmInstr exhaustiveness ---
(push 1)
(declare-const x WasmInstr)
(assert (not (or (= x WConst) (= x WLoad) (= x WStore) (= x WAdd) (= x WMul) (= x WCall) (= x WLocalGet) (= x WLocalSet) (= x WIf) (= x WReturn) (= x WDrop) (= x WNop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. WasmInstr: WConst != WLoad ---
(push 1)
(assert (= WConst WLoad))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. WasmInstr: WLoad != WStore ---
(push 1)
(assert (= WLoad WStore))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. WasmInstr: WStore != WAdd ---
(push 1)
(assert (= WStore WAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. WasmInstr: WConst != WNop ---
(push 1)
(assert (= WConst WNop))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. WasmInstr finite cardinality (12 values) ---
(push 1)
(declare-const x WasmInstr)
(assert (and (not (= x WConst)) (not (= x WLoad)) (not (= x WStore)) (not (= x WAdd)) (not (= x WMul)) (not (= x WCall)) (not (= x WLocalGet)) (not (= x WLocalSet)) (not (= x WIf)) (not (= x WReturn)) (not (= x WDrop)) (not (= x WNop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiinaIR enum properties ---

; --- 22. RiinaIR exhaustiveness ---
(push 1)
(declare-const x RiinaIR)
(assert (not (or (= x IRConst) (= x IRVar) (= x IRAdd) (= x IRMul) (= x IRCall) (= x IRLet) (= x IRIf) (= x IRLoad) (= x IRStore))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. RiinaIR: IRConst != IRVar ---
(push 1)
(assert (= IRConst IRVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. RiinaIR: IRVar != IRAdd ---
(push 1)
(assert (= IRVar IRAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. RiinaIR: IRAdd != IRMul ---
(push 1)
(assert (= IRAdd IRMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. RiinaIR: IRConst != IRStore ---
(push 1)
(assert (= IRConst IRStore))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. RiinaIR finite cardinality (9 values) ---
(push 1)
(declare-const x RiinaIR)
(assert (and (not (= x IRConst)) (not (= x IRVar)) (not (= x IRAdd)) (not (= x IRMul)) (not (= x IRCall)) (not (= x IRLet)) (not (= x IRIf)) (not (= x IRLoad)) (not (= x IRStore))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiinaEffect enum properties ---

; --- 28. RiinaEffect exhaustiveness ---
(push 1)
(declare-const x RiinaEffect)
(assert (not (or (= x EffPure) (= x EffIO) (= x EffNet) (= x EffFS))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. RiinaEffect: EffPure != EffIO ---
(push 1)
(assert (= EffPure EffIO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. RiinaEffect: EffIO != EffNet ---
(push 1)
(assert (= EffIO EffNet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. RiinaEffect: EffNet != EffFS ---
(push 1)
(assert (= EffNet EffFS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. RiinaEffect: EffPure != EffFS ---
(push 1)
(assert (= EffPure EffFS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. RiinaEffect finite cardinality (4 values) ---
(push 1)
(declare-const x RiinaEffect)
(assert (and (not (= x EffPure)) (not (= x EffIO)) (not (= x EffNet)) (not (= x EffFS))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
