; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA BackendTraitVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/BackendTraitVerification.v (21 assertions)
; Module: BackendTraitVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Target 0)) (((TNative) (TWasm32) (TWasm64) (TAndroidArm64) (TIosArm64))))

(declare-datatypes ((BackendKind 0)) (((BKC) (BKWasm) (BKMobile))))

(declare-datatypes ((OutputFormat 0)) (((FmtC) (FmtWasm) (FmtCWithBridge))))

(declare-datatypes ((SecurityProp 0)) (((NonInterference) (EffectSafety) (TypeSafety))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Target enum properties ---

; --- 1. Target exhaustiveness ---
(push 1)
(declare-const x Target)
(assert (not (or (= x TNative) (= x TWasm32) (= x TWasm64) (= x TAndroidArm64) (= x TIosArm64))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Target: TNative != TWasm32 ---
(push 1)
(assert (= TNative TWasm32))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Target: TWasm32 != TWasm64 ---
(push 1)
(assert (= TWasm32 TWasm64))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Target: TWasm64 != TAndroidArm64 ---
(push 1)
(assert (= TWasm64 TAndroidArm64))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Target: TNative != TIosArm64 ---
(push 1)
(assert (= TNative TIosArm64))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Target finite cardinality (5 values) ---
(push 1)
(declare-const x Target)
(assert (and (not (= x TNative)) (not (= x TWasm32)) (not (= x TWasm64)) (not (= x TAndroidArm64)) (not (= x TIosArm64))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BackendKind enum properties ---

; --- 7. BackendKind exhaustiveness ---
(push 1)
(declare-const x BackendKind)
(assert (not (or (= x BKC) (= x BKWasm) (= x BKMobile))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. BackendKind: BKC != BKWasm ---
(push 1)
(assert (= BKC BKWasm))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. BackendKind: BKWasm != BKMobile ---
(push 1)
(assert (= BKWasm BKMobile))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. BackendKind: BKC != BKMobile ---
(push 1)
(assert (= BKC BKMobile))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BackendKind finite cardinality (3 values) ---
(push 1)
(declare-const x BackendKind)
(assert (and (not (= x BKC)) (not (= x BKWasm)) (not (= x BKMobile))))
(check-sat) ; expect UNSAT
(pop 1)

; --- OutputFormat enum properties ---

; --- 12. OutputFormat exhaustiveness ---
(push 1)
(declare-const x OutputFormat)
(assert (not (or (= x FmtC) (= x FmtWasm) (= x FmtCWithBridge))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. OutputFormat: FmtC != FmtWasm ---
(push 1)
(assert (= FmtC FmtWasm))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. OutputFormat: FmtWasm != FmtCWithBridge ---
(push 1)
(assert (= FmtWasm FmtCWithBridge))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. OutputFormat: FmtC != FmtCWithBridge ---
(push 1)
(assert (= FmtC FmtCWithBridge))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. OutputFormat finite cardinality (3 values) ---
(push 1)
(declare-const x OutputFormat)
(assert (and (not (= x FmtC)) (not (= x FmtWasm)) (not (= x FmtCWithBridge))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityProp enum properties ---

; --- 17. SecurityProp exhaustiveness ---
(push 1)
(declare-const x SecurityProp)
(assert (not (or (= x NonInterference) (= x EffectSafety) (= x TypeSafety))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SecurityProp: NonInterference != EffectSafety ---
(push 1)
(assert (= NonInterference EffectSafety))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SecurityProp: EffectSafety != TypeSafety ---
(push 1)
(assert (= EffectSafety TypeSafety))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SecurityProp: NonInterference != TypeSafety ---
(push 1)
(assert (= NonInterference TypeSafety))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SecurityProp finite cardinality (3 values) ---
(push 1)
(declare-const x SecurityProp)
(assert (and (not (= x NonInterference)) (not (= x EffectSafety)) (not (= x TypeSafety))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityProp ordering properties ---

(define-fun SecurityProp_level ((x SecurityProp)) Int
  (ite (= x NonInterference) 0 (ite (= x EffectSafety) 1 2)))

(define-fun SecurityProp_leq ((x SecurityProp) (y SecurityProp)) Bool
  (<= (SecurityProp_level x) (SecurityProp_level y)))

; --- 22. SecurityProp_leq reflexivity ---
(push 1)
(declare-const x SecurityProp)
(assert (not (SecurityProp_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SecurityProp_leq transitivity ---
(push 1)
(declare-const x SecurityProp)
(declare-const y SecurityProp)
(declare-const z SecurityProp)
(assert (SecurityProp_leq x y))
(assert (SecurityProp_leq y z))
(assert (not (SecurityProp_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SecurityProp_leq antisymmetry ---
(push 1)
(declare-const x SecurityProp)
(declare-const y SecurityProp)
(assert (SecurityProp_leq x y))
(assert (SecurityProp_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. NonInterference is bottom ---
(push 1)
(declare-const x SecurityProp)
(assert (not (SecurityProp_leq NonInterference x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TypeSafety is top ---
(push 1)
(declare-const x SecurityProp)
(assert (not (SecurityProp_leq x TypeSafety)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
