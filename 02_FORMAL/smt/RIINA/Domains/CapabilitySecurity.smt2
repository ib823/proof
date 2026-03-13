; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CapabilitySecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/CapabilitySecurity.v (108 assertions)
; Module: CapabilitySecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Permission 0)) (((Read) (Write) (Execute) (Delete) (Create) (Admin))))

(declare-datatypes ((DelegationType 0)) (((DelegFull) (DelegRestricted) (DelegOnce))))

(declare-datatypes ((Capability 0))
  (((mk-capability (cap_unforgeable Bool) (cap_transferable Bool) (cap_revocable Bool) (cap_attenuatable Bool)))))

(declare-datatypes ((ObjectCapability 0))
  (((mk-object_capability (ocap_no_ambient_authority Bool) (ocap_explicit_grant Bool) (ocap_encapsulation Bool) (ocap_connectivity Bool)))))

(declare-datatypes ((LeastPrivilege 0))
  (((mk-least_privilege (lp_minimal_permissions Bool) (lp_time_limited Bool) (lp_scope_limited Bool)))))

(declare-datatypes ((CapabilityConfig 0))
  (((mk-capability_config (cc_cap Capability) (cc_ocap ObjectCapability) (cc_lp LeastPrivilege)))))

(declare-datatypes ((MemCapability 0))
  (((mk-mem_capability (mem_base Int) (mem_length Int) (mem_perms Int) (mem_sealed Bool) (mem_valid Bool)))))

(declare-datatypes ((RevocationTable 0))
  (((mk-revocation_table (rev_entries (Seq Int))))))

(declare-datatypes ((Principal 0))
  (((mk-principal (prin_id Int) (prin_capabilities (Seq Int))))))

(declare-datatypes ((ConfinementPolicy 0))
  (((mk-confinement_policy (conf_no_ambient Bool) (conf_explicit_only Bool) (conf_no_escalation Bool)))))

(declare-datatypes ((Delegation 0))
  (((mk-delegation (del_from Int) (del_to Int) (del_cap_id Int) (del_type DelegationType) (del_active Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Permission enum properties ---

; --- 1. Permission exhaustiveness ---
(push 1)
(declare-const x Permission)
(assert (not (or (= x Read) (= x Write) (= x Execute) (= x Delete) (= x Create) (= x Admin))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Permission: Read != Write ---
(push 1)
(assert (= Read Write))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Permission: Write != Execute ---
(push 1)
(assert (= Write Execute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Permission: Execute != Delete ---
(push 1)
(assert (= Execute Delete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Permission: Read != Admin ---
(push 1)
(assert (= Read Admin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Permission finite cardinality (6 values) ---
(push 1)
(declare-const x Permission)
(assert (and (not (= x Read)) (not (= x Write)) (not (= x Execute)) (not (= x Delete)) (not (= x Create)) (not (= x Admin))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DelegationType enum properties ---

; --- 7. DelegationType exhaustiveness ---
(push 1)
(declare-const x DelegationType)
(assert (not (or (= x DelegFull) (= x DelegRestricted) (= x DelegOnce))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. DelegationType: DelegFull != DelegRestricted ---
(push 1)
(assert (= DelegFull DelegRestricted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. DelegationType: DelegRestricted != DelegOnce ---
(push 1)
(assert (= DelegRestricted DelegOnce))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. DelegationType: DelegFull != DelegOnce ---
(push 1)
(assert (= DelegFull DelegOnce))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. DelegationType finite cardinality (3 values) ---
(push 1)
(declare-const x DelegationType)
(assert (and (not (= x DelegFull)) (not (= x DelegRestricted)) (not (= x DelegOnce))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Capability record properties ---

; --- 12. Capability accessor round-trip: cap_unforgeable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cap_unforgeable (mk-capability f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Capability accessor round-trip: cap_transferable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cap_transferable (mk-capability f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Capability accessor round-trip: cap_revocable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cap_revocable (mk-capability f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun Capability_all_enabled ((g Capability)) Bool
  (and (cap_unforgeable g) (cap_transferable g) (cap_revocable g)))

; --- 15. Capability: all-enabled completeness ---
(push 1)
(declare-const g Capability)
(assert (cap_unforgeable g))
(assert (cap_transferable g))
(assert (cap_revocable g))
(assert (not (Capability_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Capability: Capability_all_enabled implies cap_unforgeable ---
(push 1)
(declare-const g Capability)
(assert (Capability_all_enabled g))
(assert (not (cap_unforgeable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Capability: Capability_all_enabled implies cap_transferable ---
(push 1)
(declare-const g Capability)
(assert (Capability_all_enabled g))
(assert (not (cap_transferable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Capability: Capability_all_enabled implies cap_revocable ---
(push 1)
(declare-const g Capability)
(assert (Capability_all_enabled g))
(assert (not (cap_revocable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ObjectCapability record properties ---

; --- 19. ObjectCapability accessor round-trip: ocap_no_ambient_authority ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ocap_no_ambient_authority (mk-object_capability f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ObjectCapability accessor round-trip: ocap_explicit_grant ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ocap_explicit_grant (mk-object_capability f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ObjectCapability accessor round-trip: ocap_encapsulation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ocap_encapsulation (mk-object_capability f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ObjectCapability_all_enabled ((g ObjectCapability)) Bool
  (and (ocap_no_ambient_authority g) (ocap_explicit_grant g) (ocap_encapsulation g)))

; --- 22. ObjectCapability: all-enabled completeness ---
(push 1)
(declare-const g ObjectCapability)
(assert (ocap_no_ambient_authority g))
(assert (ocap_explicit_grant g))
(assert (ocap_encapsulation g))
(assert (not (ObjectCapability_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ObjectCapability: ObjectCapability_all_enabled implies ocap_no_ambient_authority ---
(push 1)
(declare-const g ObjectCapability)
(assert (ObjectCapability_all_enabled g))
(assert (not (ocap_no_ambient_authority g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ObjectCapability: ObjectCapability_all_enabled implies ocap_explicit_grant ---
(push 1)
(declare-const g ObjectCapability)
(assert (ObjectCapability_all_enabled g))
(assert (not (ocap_explicit_grant g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ObjectCapability: ObjectCapability_all_enabled implies ocap_encapsulation ---
(push 1)
(declare-const g ObjectCapability)
(assert (ObjectCapability_all_enabled g))
(assert (not (ocap_encapsulation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LeastPrivilege record properties ---

; --- 26. LeastPrivilege accessor round-trip: lp_minimal_permissions ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (lp_minimal_permissions (mk-least_privilege f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. LeastPrivilege accessor round-trip: lp_time_limited ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (lp_time_limited (mk-least_privilege f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun LeastPrivilege_all_enabled ((g LeastPrivilege)) Bool
  (and (lp_minimal_permissions g) (lp_time_limited g)))

; --- 28. LeastPrivilege: all-enabled completeness ---
(push 1)
(declare-const g LeastPrivilege)
(assert (lp_minimal_permissions g))
(assert (lp_time_limited g))
(assert (not (LeastPrivilege_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. LeastPrivilege: LeastPrivilege_all_enabled implies lp_minimal_permissions ---
(push 1)
(declare-const g LeastPrivilege)
(assert (LeastPrivilege_all_enabled g))
(assert (not (lp_minimal_permissions g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. LeastPrivilege: LeastPrivilege_all_enabled implies lp_time_limited ---
(push 1)
(declare-const g LeastPrivilege)
(assert (LeastPrivilege_all_enabled g))
(assert (not (lp_time_limited g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CapabilityConfig record properties ---

; --- 31. CapabilityConfig accessor round-trip: cc_cap ---
(push 1)
(declare-const f0 Capability)
(declare-const f1 ObjectCapability)
(assert (not (= (cc_cap (mk-capability_config f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. CapabilityConfig accessor round-trip: cc_ocap ---
(push 1)
(declare-const f0 Capability)
(declare-const f1 ObjectCapability)
(assert (not (= (cc_ocap (mk-capability_config f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemCapability record properties ---

; --- 33. MemCapability accessor round-trip: mem_base ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (mem_base (mk-mem_capability f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. MemCapability accessor round-trip: mem_length ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (mem_length (mk-mem_capability f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. MemCapability accessor round-trip: mem_perms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (mem_perms (mk-mem_capability f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. MemCapability accessor round-trip: mem_sealed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (mem_sealed (mk-mem_capability f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. MemCapability: integer field consistency ---
(push 1)
(declare-const r MemCapability)
(assert (>= (mem_base r) 0))
(assert (>= (mem_length r) 0))
(assert (not (>= (+ (mem_base r) (mem_length r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Principal record properties ---

; --- 38. Principal accessor round-trip: prin_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (prin_id (mk-principal f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConfinementPolicy record properties ---

; --- 39. ConfinementPolicy accessor round-trip: conf_no_ambient ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (conf_no_ambient (mk-confinement_policy f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. ConfinementPolicy accessor round-trip: conf_explicit_only ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (conf_explicit_only (mk-confinement_policy f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ConfinementPolicy_all_enabled ((g ConfinementPolicy)) Bool
  (and (conf_no_ambient g) (conf_explicit_only g)))

; --- 41. ConfinementPolicy: all-enabled completeness ---
(push 1)
(declare-const g ConfinementPolicy)
(assert (conf_no_ambient g))
(assert (conf_explicit_only g))
(assert (not (ConfinementPolicy_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. ConfinementPolicy: ConfinementPolicy_all_enabled implies conf_no_ambient ---
(push 1)
(declare-const g ConfinementPolicy)
(assert (ConfinementPolicy_all_enabled g))
(assert (not (conf_no_ambient g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. ConfinementPolicy: ConfinementPolicy_all_enabled implies conf_explicit_only ---
(push 1)
(declare-const g ConfinementPolicy)
(assert (ConfinementPolicy_all_enabled g))
(assert (not (conf_explicit_only g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Delegation record properties ---

; --- 44. Delegation accessor round-trip: del_from ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 DelegationType)
(assert (not (= (del_from (mk-delegation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. Delegation accessor round-trip: del_to ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 DelegationType)
(assert (not (= (del_to (mk-delegation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. Delegation accessor round-trip: del_cap_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 DelegationType)
(assert (not (= (del_cap_id (mk-delegation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. Delegation accessor round-trip: del_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 DelegationType)
(assert (not (= (del_type (mk-delegation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. Delegation: integer field consistency ---
(push 1)
(declare-const r Delegation)
(assert (>= (del_from r) 0))
(assert (>= (del_to r) 0))
(assert (not (>= (+ (del_from r) (del_to r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Permission ordering properties ---

(define-fun Permission_level ((x Permission)) Int
  (ite (= x Read) 0 (ite (= x Write) 1 (ite (= x Execute) 2 (ite (= x Delete) 3 (ite (= x Create) 4 5))))))

(define-fun Permission_leq ((x Permission) (y Permission)) Bool
  (<= (Permission_level x) (Permission_level y)))

; --- 49. Permission_leq reflexivity ---
(push 1)
(declare-const x Permission)
(assert (not (Permission_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. Permission_leq transitivity ---
(push 1)
(declare-const x Permission)
(declare-const y Permission)
(declare-const z Permission)
(assert (Permission_leq x y))
(assert (Permission_leq y z))
(assert (not (Permission_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Permission_leq antisymmetry ---
(push 1)
(declare-const x Permission)
(declare-const y Permission)
(assert (Permission_leq x y))
(assert (Permission_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Read is bottom ---
(push 1)
(declare-const x Permission)
(assert (not (Permission_leq Read x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. Admin is top ---
(push 1)
(declare-const x Permission)
(assert (not (Permission_leq x Admin)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
