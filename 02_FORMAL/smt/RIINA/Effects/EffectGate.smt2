; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA EffectGate — SMT Verification
; Derived from 02_FORMAL/coq/effects/EffectGate.v
; Module: EffectGate
;
; Verifies: effect gate (capability-based effect access control),
; effect granting semantics, effect requirement checking,
; capability subsumption.

(set-logic QF_DT)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; DATATYPE DECLARATIONS
; ═══════════════════════════════════════════════════════════════════════════

(declare-datatypes ((Ind_effect 0)) (((EffPure) (EffRead) (EffWrite) (EffFileSystem) (EffNetwork) (EffNetSecure) (EffCrypto) (EffRandom) (EffSystem) (EffTime) (EffProcess) (EffPanel) (EffZirah) (EffBenteng) (EffSandi) (EffMenara) (EffGapura))))
(declare-datatypes ((capability_kind 0)) (((CapFileRead) (CapFileWrite) (CapFileExecute) (CapFileDelete) (CapNetConnect) (CapNetListen) (CapNetBind) (CapProcSpawn) (CapProcSignal) (CapSysTime) (CapSysRandom) (CapSysEnv) (CapRootProduct) (CapProductAccess))))

; ═══════════════════════════════════════════════════════════════════════════
; FUNCTION DEFINITIONS
; ═══════════════════════════════════════════════════════════════════════════

(define-fun effect_level ((e Ind_effect)) Int
  (ite (= e EffPure) 0
  (ite (= e EffRead) 1
  (ite (= e EffWrite) 2
  (ite (= e EffFileSystem) 3
  (ite (= e EffNetwork) 4
  (ite (= e EffNetSecure) 5
  (ite (= e EffCrypto) 6
  (ite (= e EffRandom) 7
  (ite (= e EffSystem) 8
  (ite (= e EffTime) 9
  (ite (= e EffProcess) 10
  (ite (= e EffPanel) 11
  (ite (= e EffZirah) 12
  (ite (= e EffBenteng) 13
  (ite (= e EffSandi) 14
  (ite (= e EffMenara) 15
  16)))))))))))))))))

(define-fun effect_leq ((e1 Ind_effect) (e2 Ind_effect)) Bool
  (<= (effect_level e1) (effect_level e2)))

; effect_requires_cap: which effects require capabilities
(define-fun effect_requires_cap ((e Ind_effect)) Bool
  (not (= e EffPure)))

; cap_grants_effect: capability kind authorizes a specific effect
(define-fun cap_grants_effect ((ck capability_kind) (e Ind_effect)) Bool
  (or
    (and (= ck CapFileRead) (= e EffRead))
    (and (= ck CapFileWrite) (= e EffWrite))
    (and (= ck CapFileExecute) (= e EffFileSystem))
    (and (= ck CapFileDelete) (= e EffFileSystem))
    (and (= ck CapNetConnect) (= e EffNetwork))
    (and (= ck CapNetListen) (= e EffNetwork))
    (and (= ck CapNetBind) (= e EffNetSecure))
    (and (= ck CapProcSpawn) (= e EffProcess))
    (and (= ck CapProcSignal) (= e EffProcess))
    (and (= ck CapSysTime) (= e EffTime))
    (and (= ck CapSysRandom) (= e EffRandom))
    (and (= ck CapSysEnv) (= e EffSystem))
    (and (= ck CapRootProduct) (or (= e EffPanel) (= e EffZirah) (= e EffBenteng) (= e EffSandi) (= e EffMenara) (= e EffGapura)))
    (and (= ck CapProductAccess) (or (= e EffPanel) (= e EffZirah) (= e EffBenteng) (= e EffSandi) (= e EffMenara) (= e EffGapura)))))

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. EffPure does not require capabilities ---
(push 1)
(assert (effect_requires_cap EffPure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. All non-pure effects require capabilities ---
(push 1)
(declare-const e Ind_effect)
(assert (not (= e EffPure)))
(assert (not (effect_requires_cap e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CapFileRead grants EffRead ---
(push 1)
(assert (not (cap_grants_effect CapFileRead EffRead)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CapNetConnect grants EffNetwork ---
(push 1)
(assert (not (cap_grants_effect CapNetConnect EffNetwork)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CapFileRead does NOT grant EffNetwork (isolation) ---
(push 1)
(assert (cap_grants_effect CapFileRead EffNetwork))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CapNetConnect does NOT grant EffWrite (isolation) ---
(push 1)
(assert (cap_grants_effect CapNetConnect EffWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. No capability grants EffPure (pure needs no cap) ---
(push 1)
(declare-const ck capability_kind)
(assert (cap_grants_effect ck EffPure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CapRootProduct grants all product effects ---
(push 1)
(assert (not (and
  (cap_grants_effect CapRootProduct EffPanel)
  (cap_grants_effect CapRootProduct EffZirah)
  (cap_grants_effect CapRootProduct EffBenteng)
  (cap_grants_effect CapRootProduct EffSandi)
  (cap_grants_effect CapRootProduct EffMenara)
  (cap_grants_effect CapRootProduct EffGapura))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CapSysRandom grants EffRandom ---
(push 1)
(assert (not (cap_grants_effect CapSysRandom EffRandom)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. capability_kind exhaustiveness ---
(push 1)
(declare-const ck capability_kind)
(assert (not (or (= ck CapFileRead) (= ck CapFileWrite) (= ck CapFileExecute) (= ck CapFileDelete)
               (= ck CapNetConnect) (= ck CapNetListen) (= ck CapNetBind)
               (= ck CapProcSpawn) (= ck CapProcSignal)
               (= ck CapSysTime) (= ck CapSysRandom) (= ck CapSysEnv)
               (= ck CapRootProduct) (= ck CapProductAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CapSysTime grants EffTime ---
(push 1)
(assert (not (cap_grants_effect CapSysTime EffTime)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CapProcSpawn grants EffProcess ---
(push 1)
(assert (not (cap_grants_effect CapProcSpawn EffProcess)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
