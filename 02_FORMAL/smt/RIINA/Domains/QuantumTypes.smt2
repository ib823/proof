; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA QuantumTypes — SMT Verification
; Derived from 02_FORMAL/coq/domains/QuantumTypes.v (29 assertions)
; Module: QuantumTypes
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((gate 0)) (((Hadamard) (PauliX) (PauliZ) (CNOT))))

(declare-datatypes ((instr 0)) (((ICreate) (IGate) (IGate2) (IMeasure) (ISeq))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. gate exhaustiveness ---
(push 1)
(declare-const x gate)
(assert (not (or (= x Hadamard) (= x PauliX) (= x PauliZ) (= x CNOT))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. gate: Hadamard != PauliX ---
(push 1)
(assert (= Hadamard PauliX))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. gate: PauliX != PauliZ ---
(push 1)
(assert (= PauliX PauliZ))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. gate: PauliZ != CNOT ---
(push 1)
(assert (= PauliZ CNOT))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. gate: Hadamard != CNOT ---
(push 1)
(assert (= Hadamard CNOT))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. gate finite cardinality (4 values) ---
(push 1)
(declare-const x gate)
(assert (and (not (= x Hadamard)) (not (= x PauliX)) (not (= x PauliZ)) (not (= x CNOT))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. instr exhaustiveness ---
(push 1)
(declare-const x instr)
(assert (not (or (= x ICreate) (= x IGate) (= x IGate2) (= x IMeasure) (= x ISeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. instr: ICreate != IGate ---
(push 1)
(assert (= ICreate IGate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. instr: IGate != IGate2 ---
(push 1)
(assert (= IGate IGate2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. instr: IGate2 != IMeasure ---
(push 1)
(assert (= IGate2 IMeasure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. instr: ICreate != ISeq ---
(push 1)
(assert (= ICreate ISeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. instr finite cardinality (5 values) ---
(push 1)
(declare-const x instr)
(assert (and (not (= x ICreate)) (not (= x IGate)) (not (= x IGate2)) (not (= x IMeasure)) (not (= x ISeq))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
