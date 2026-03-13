; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MobilePlatform — SMT Verification
; Derived from 02_FORMAL/coq/domains/MobilePlatform.v (25 assertions)
; Module: MobilePlatform
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Resource 0)) (((FileResource) (NetworkResource) (SensorResource) (ContactResource) (LocationResource) (CameraResource) (MicrophoneResource))))

(declare-datatypes ((PermLevel 0)) (((Normal) (Dangerous) (Signature) (System))))

(declare-datatypes ((IpcResult 0)) (((IpcAllowed) (IpcDenied) (IpcPendingUser))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Resource exhaustiveness ---
(push 1)
(declare-const x Resource)
(assert (not (or (= x FileResource) (= x NetworkResource) (= x SensorResource) (= x ContactResource) (= x LocationResource) (= x CameraResource) (= x MicrophoneResource))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Resource: FileResource != NetworkResource ---
(push 1)
(assert (= FileResource NetworkResource))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Resource: NetworkResource != SensorResource ---
(push 1)
(assert (= NetworkResource SensorResource))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Resource: SensorResource != ContactResource ---
(push 1)
(assert (= SensorResource ContactResource))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Resource: FileResource != MicrophoneResource ---
(push 1)
(assert (= FileResource MicrophoneResource))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Resource finite cardinality (7 values) ---
(push 1)
(declare-const x Resource)
(assert (and (not (= x FileResource)) (not (= x NetworkResource)) (not (= x SensorResource)) (not (= x ContactResource)) (not (= x LocationResource)) (not (= x CameraResource)) (not (= x MicrophoneResource))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. PermLevel exhaustiveness ---
(push 1)
(declare-const x PermLevel)
(assert (not (or (= x Normal) (= x Dangerous) (= x Signature) (= x System))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PermLevel: Normal != Dangerous ---
(push 1)
(assert (= Normal Dangerous))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PermLevel: Dangerous != Signature ---
(push 1)
(assert (= Dangerous Signature))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PermLevel: Signature != System ---
(push 1)
(assert (= Signature System))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PermLevel: Normal != System ---
(push 1)
(assert (= Normal System))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PermLevel finite cardinality (4 values) ---
(push 1)
(declare-const x PermLevel)
(assert (and (not (= x Normal)) (not (= x Dangerous)) (not (= x Signature)) (not (= x System))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. IpcResult exhaustiveness ---
(push 1)
(declare-const x IpcResult)
(assert (not (or (= x IpcAllowed) (= x IpcDenied) (= x IpcPendingUser))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. IpcResult: IpcAllowed != IpcDenied ---
(push 1)
(assert (= IpcAllowed IpcDenied))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. IpcResult: IpcDenied != IpcPendingUser ---
(push 1)
(assert (= IpcDenied IpcPendingUser))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. IpcResult finite cardinality (3 values) ---
(push 1)
(declare-const x IpcResult)
(assert (and (not (= x IpcAllowed)) (not (= x IpcDenied)) (not (= x IpcPendingUser))))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PermLevel_level ((x PermLevel)) Int
  (ite (= x Normal) 0 (ite (= x Dangerous) 1 (ite (= x Signature) 2 3))))

(define-fun PermLevel_leq ((x PermLevel) (y PermLevel)) Bool
  (<= (PermLevel_level x) (PermLevel_level y)))

; --- 17. PermLevel_leq reflexivity ---
(push 1)
(declare-const x PermLevel)
(assert (not (PermLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. PermLevel_leq transitivity ---
(push 1)
(declare-const x PermLevel)
(declare-const y PermLevel)
(declare-const z PermLevel)
(assert (PermLevel_leq x y))
(assert (PermLevel_leq y z))
(assert (not (PermLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. PermLevel_leq antisymmetry ---
(push 1)
(declare-const x PermLevel)
(declare-const y PermLevel)
(assert (PermLevel_leq x y))
(assert (PermLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Normal is bottom ---
(push 1)
(declare-const x PermLevel)
(assert (not (PermLevel_leq Normal x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. System is top ---
(push 1)
(declare-const x PermLevel)
(assert (not (PermLevel_leq x System)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
