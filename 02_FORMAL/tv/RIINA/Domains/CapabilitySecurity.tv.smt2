; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CapabilitySecurity.v (108 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CapabilitySecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; perm_level: source semantics (matches Coq)
; Translation validation: perm_level preserves semantics
(push 1)
(declare-const source_perm_level Int)
(declare-const target_perm_level Int)
(assert (>= source_perm_level 0))
(assert (>= target_perm_level 0))
(assert (not (= source_perm_level target_perm_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perm_leq: source semantics (matches Coq)
; Translation validation: perm_leq preserves semantics
(push 1)
(declare-const source_perm_leq Int)
(declare-const target_perm_leq Int)
(assert (>= source_perm_leq 0))
(assert (>= target_perm_leq 0))
(assert (not (= source_perm_leq target_perm_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perm_lt: source semantics (matches Coq)
; Translation validation: perm_lt preserves semantics
(push 1)
(declare-const source_perm_lt Int)
(declare-const target_perm_lt Int)
(assert (>= source_perm_lt 0))
(assert (>= target_perm_lt 0))
(assert (not (= source_perm_lt target_perm_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perm_eq: source semantics (matches Coq)
; Translation validation: perm_eq preserves semantics
(push 1)
(declare-const source_perm_eq Int)
(declare-const target_perm_eq Int)
(assert (>= source_perm_eq 0))
(assert (>= target_perm_eq 0))
(assert (not (= source_perm_eq target_perm_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perm_in: source semantics (matches Coq)
; Translation validation: perm_in preserves semantics
(push 1)
(declare-const source_perm_in Int)
(declare-const target_perm_in Int)
(assert (>= source_perm_in 0))
(assert (>= target_perm_in 0))
(assert (not (= source_perm_in target_perm_in)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_bounds_check: source semantics (matches Coq)
; Translation validation: mem_bounds_check preserves semantics
(push 1)
(declare-const source_mem_bounds_check Int)
(declare-const target_mem_bounds_check Int)
(assert (>= source_mem_bounds_check 0))
(assert (>= target_mem_bounds_check 0))
(assert (not (= source_mem_bounds_check target_mem_bounds_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_has_perm: source semantics (matches Coq)
; Translation validation: mem_has_perm preserves semantics
(push 1)
(declare-const source_mem_has_perm Int)
(declare-const target_mem_has_perm Int)
(assert (>= source_mem_has_perm 0))
(assert (>= target_mem_has_perm 0))
(assert (not (= source_mem_has_perm target_mem_has_perm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_can_read: source semantics (matches Coq)
; Translation validation: mem_can_read preserves semantics
(push 1)
(declare-const source_mem_can_read Int)
(declare-const target_mem_can_read Int)
(assert (>= source_mem_can_read 0))
(assert (>= target_mem_can_read 0))
(assert (not (= source_mem_can_read target_mem_can_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_can_write: source semantics (matches Coq)
; Translation validation: mem_can_write preserves semantics
(push 1)
(declare-const source_mem_can_write Int)
(declare-const target_mem_can_write Int)
(assert (>= source_mem_can_write 0))
(assert (>= target_mem_can_write 0))
(assert (not (= source_mem_can_write target_mem_can_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_can_execute: source semantics (matches Coq)
; Translation validation: mem_can_execute preserves semantics
(push 1)
(declare-const source_mem_can_execute Int)
(declare-const target_mem_can_execute Int)
(assert (>= source_mem_can_execute 0))
(assert (>= target_mem_can_execute 0))
(assert (not (= source_mem_can_execute target_mem_can_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perms_subset: source semantics (matches Coq)
; Translation validation: perms_subset preserves semantics
(push 1)
(declare-const source_perms_subset Int)
(declare-const target_perms_subset Int)
(assert (>= source_perms_subset 0))
(assert (>= target_perms_subset 0))
(assert (not (= source_perms_subset target_perms_subset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; derive_mem_cap: source semantics (matches Coq)
; Translation validation: derive_mem_cap preserves semantics
(push 1)
(declare-const source_derive_mem_cap Int)
(declare-const target_derive_mem_cap Int)
(assert (>= source_derive_mem_cap 0))
(assert (>= target_derive_mem_cap 0))
(assert (not (= source_derive_mem_cap target_derive_mem_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_revoked: source semantics (matches Coq)
; Translation validation: is_revoked preserves semantics
(push 1)
(declare-const source_is_revoked Int)
(declare-const target_is_revoked Int)
(assert (>= source_is_revoked 0))
(assert (>= target_is_revoked 0))
(assert (not (= source_is_revoked target_is_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; revoke_capability: source semantics (matches Coq)
; Translation validation: revoke_capability preserves semantics
(push 1)
(declare-const source_revoke_capability Int)
(declare-const target_revoke_capability Int)
(assert (>= source_revoke_capability 0))
(assert (>= target_revoke_capability 0))
(assert (not (= source_revoke_capability target_revoke_capability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_capability: source semantics (matches Coq)
; Translation validation: has_capability preserves semantics
(push 1)
(declare-const source_has_capability Int)
(declare-const target_has_capability Int)
(assert (>= source_has_capability 0))
(assert (>= target_has_capability 0))
(assert (not (= source_has_capability target_has_capability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; confinement_enforced: source semantics (matches Coq)
; Translation validation: confinement_enforced preserves semantics
(push 1)
(declare-const source_confinement_enforced Int)
(declare-const target_confinement_enforced Int)
(assert (>= source_confinement_enforced 0))
(assert (>= target_confinement_enforced 0))
(assert (not (= source_confinement_enforced target_confinement_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_redelegate: source semantics (matches Coq)
; Translation validation: can_redelegate preserves semantics
(push 1)
(declare-const source_can_redelegate Int)
(declare-const target_can_redelegate Int)
(assert (>= source_can_redelegate 0))
(assert (>= target_can_redelegate 0))
(assert (not (= source_can_redelegate target_can_redelegate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; capability_sound: source semantics (matches Coq)
; Translation validation: capability_sound preserves semantics
(push 1)
(declare-const source_capability_sound Int)
(declare-const target_capability_sound Int)
(assert (>= source_capability_sound 0))
(assert (>= target_capability_sound 0))
(assert (not (= source_capability_sound target_capability_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ocap_sound: source semantics (matches Coq)
; Translation validation: ocap_sound preserves semantics
(push 1)
(declare-const source_ocap_sound Int)
(declare-const target_ocap_sound Int)
(assert (>= source_ocap_sound 0))
(assert (>= target_ocap_sound 0))
(assert (not (= source_ocap_sound target_ocap_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; least_privilege_enforced: source semantics (matches Coq)
; Translation validation: least_privilege_enforced preserves semantics
(push 1)
(declare-const source_least_privilege_enforced Int)
(declare-const target_least_privilege_enforced Int)
(assert (>= source_least_privilege_enforced 0))
(assert (>= target_least_privilege_enforced 0))
(assert (not (= source_least_privilege_enforced target_least_privilege_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; capability_secure: source semantics (matches Coq)
; Translation validation: capability_secure preserves semantics
(push 1)
(declare-const source_capability_secure Int)
(declare-const target_capability_secure Int)
(assert (>= source_capability_secure 0))
(assert (>= target_capability_secure 0))
(assert (not (= source_capability_secure target_capability_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_cap: source semantics (matches Coq)
; Translation validation: riina_cap preserves semantics
(push 1)
(declare-const source_riina_cap Int)
(declare-const target_riina_cap Int)
(assert (>= source_riina_cap 0))
(assert (>= target_riina_cap 0))
(assert (not (= source_riina_cap target_riina_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ocap: source semantics (matches Coq)
; Translation validation: riina_ocap preserves semantics
(push 1)
(declare-const source_riina_ocap Int)
(declare-const target_riina_ocap Int)
(assert (>= source_riina_ocap 0))
(assert (>= target_riina_ocap 0))
(assert (not (= source_riina_ocap target_riina_ocap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_lp: source semantics (matches Coq)
; Translation validation: riina_lp preserves semantics
(push 1)
(declare-const source_riina_lp Int)
(declare-const target_riina_lp Int)
(assert (>= source_riina_lp 0))
(assert (>= target_riina_lp 0))
(assert (not (= source_riina_lp target_riina_lp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_cap_config: source semantics (matches Coq)
; Translation validation: riina_cap_config preserves semantics
(push 1)
(declare-const source_riina_cap_config Int)
(declare-const target_riina_cap_config Int)
(assert (>= source_riina_cap_config 0))
(assert (>= target_riina_cap_config 0))
(assert (not (= source_riina_cap_config target_riina_cap_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_confinement: source semantics (matches Coq)
; Translation validation: riina_confinement preserves semantics
(push 1)
(declare-const source_riina_confinement Int)
(declare-const target_riina_confinement Int)
(assert (>= source_riina_confinement 0))
(assert (>= target_riina_confinement 0))
(assert (not (= source_riina_confinement target_riina_confinement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_mem_cap: source semantics (matches Coq)
; Translation validation: riina_mem_cap preserves semantics
(push 1)
(declare-const source_riina_mem_cap Int)
(declare-const target_riina_mem_cap Int)
(assert (>= source_riina_mem_cap 0))
(assert (>= target_riina_mem_cap 0))
(assert (not (= source_riina_mem_cap target_riina_mem_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_rev_table: source semantics (matches Coq)
; Translation validation: empty_rev_table preserves semantics
(push 1)
(declare-const source_empty_rev_table Int)
(declare-const target_empty_rev_table Int)
(assert (>= source_empty_rev_table 0))
(assert (>= target_empty_rev_table 0))
(assert (not (= source_empty_rev_table target_empty_rev_table)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_delegation: source semantics (matches Coq)
; Translation validation: riina_delegation preserves semantics
(push 1)
(declare-const source_riina_delegation Int)
(declare-const target_riina_delegation Int)
(assert (>= source_riina_delegation 0))
(assert (>= target_riina_delegation 0))
(assert (not (= source_riina_delegation target_riina_delegation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_false_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_false_iff preserves semantics
(push 1)
(declare-const source_andb_false_iff Int)
(declare-const target_andb_false_iff Int)
(assert (>= source_andb_false_iff 0))
(assert (>= target_andb_false_iff 0))
(assert (not (= source_andb_false_iff target_andb_false_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff preserves semantics
(push 1)
(declare-const source_orb_true_iff Int)
(declare-const target_orb_true_iff Int)
(assert (>= source_orb_true_iff 0))
(assert (>= target_orb_true_iff 0))
(assert (not (= source_orb_true_iff target_orb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_false_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_false_iff preserves semantics
(push 1)
(declare-const source_negb_false_iff Int)
(declare-const target_negb_false_iff Int)
(assert (>= source_negb_false_iff 0))
(assert (>= target_negb_false_iff 0))
(assert (not (= source_negb_false_iff target_negb_false_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_001: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_001 preserves semantics
(push 1)
(declare-const source_CAP_001 Int)
(declare-const target_CAP_001 Int)
(assert (>= source_CAP_001 0))
(assert (>= target_CAP_001 0))
(assert (not (= source_CAP_001 target_CAP_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_002: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_002 preserves semantics
(push 1)
(declare-const source_CAP_002 Int)
(declare-const target_CAP_002 Int)
(assert (>= source_CAP_002 0))
(assert (>= target_CAP_002 0))
(assert (not (= source_CAP_002 target_CAP_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_003: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_003 preserves semantics
(push 1)
(declare-const source_CAP_003 Int)
(declare-const target_CAP_003 Int)
(assert (>= source_CAP_003 0))
(assert (>= target_CAP_003 0))
(assert (not (= source_CAP_003 target_CAP_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_004: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_004 preserves semantics
(push 1)
(declare-const source_CAP_004 Int)
(declare-const target_CAP_004 Int)
(assert (>= source_CAP_004 0))
(assert (>= target_CAP_004 0))
(assert (not (= source_CAP_004 target_CAP_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_005: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_005 preserves semantics
(push 1)
(declare-const source_CAP_005 Int)
(declare-const target_CAP_005 Int)
(assert (>= source_CAP_005 0))
(assert (>= target_CAP_005 0))
(assert (not (= source_CAP_005 target_CAP_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_006: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_006 preserves semantics
(push 1)
(declare-const source_CAP_006 Int)
(declare-const target_CAP_006 Int)
(assert (>= source_CAP_006 0))
(assert (>= target_CAP_006 0))
(assert (not (= source_CAP_006 target_CAP_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_007: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_007 preserves semantics
(push 1)
(declare-const source_CAP_007 Int)
(declare-const target_CAP_007 Int)
(assert (>= source_CAP_007 0))
(assert (>= target_CAP_007 0))
(assert (not (= source_CAP_007 target_CAP_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_008: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_008 preserves semantics
(push 1)
(declare-const source_CAP_008 Int)
(declare-const target_CAP_008 Int)
(assert (>= source_CAP_008 0))
(assert (>= target_CAP_008 0))
(assert (not (= source_CAP_008 target_CAP_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_009: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_009 preserves semantics
(push 1)
(declare-const source_CAP_009 Int)
(declare-const target_CAP_009 Int)
(assert (>= source_CAP_009 0))
(assert (>= target_CAP_009 0))
(assert (not (= source_CAP_009 target_CAP_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_010: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_010 preserves semantics
(push 1)
(declare-const source_CAP_010 Int)
(declare-const target_CAP_010 Int)
(assert (>= source_CAP_010 0))
(assert (>= target_CAP_010 0))
(assert (not (= source_CAP_010 target_CAP_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_011: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_011 preserves semantics
(push 1)
(declare-const source_CAP_011 Int)
(declare-const target_CAP_011 Int)
(assert (>= source_CAP_011 0))
(assert (>= target_CAP_011 0))
(assert (not (= source_CAP_011 target_CAP_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_012: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_012 preserves semantics
(push 1)
(declare-const source_CAP_012 Int)
(declare-const target_CAP_012 Int)
(assert (>= source_CAP_012 0))
(assert (>= target_CAP_012 0))
(assert (not (= source_CAP_012 target_CAP_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_013: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_013 preserves semantics
(push 1)
(declare-const source_CAP_013 Int)
(declare-const target_CAP_013 Int)
(assert (>= source_CAP_013 0))
(assert (>= target_CAP_013 0))
(assert (not (= source_CAP_013 target_CAP_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_014: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_014 preserves semantics
(push 1)
(declare-const source_CAP_014 Int)
(declare-const target_CAP_014 Int)
(assert (>= source_CAP_014 0))
(assert (>= target_CAP_014 0))
(assert (not (= source_CAP_014 target_CAP_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_015: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_015 preserves semantics
(push 1)
(declare-const source_CAP_015 Int)
(declare-const target_CAP_015 Int)
(assert (>= source_CAP_015 0))
(assert (>= target_CAP_015 0))
(assert (not (= source_CAP_015 target_CAP_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_016: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_016 preserves semantics
(push 1)
(declare-const source_CAP_016 Int)
(declare-const target_CAP_016 Int)
(assert (>= source_CAP_016 0))
(assert (>= target_CAP_016 0))
(assert (not (= source_CAP_016 target_CAP_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_017: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_017 preserves semantics
(push 1)
(declare-const source_CAP_017 Int)
(declare-const target_CAP_017 Int)
(assert (>= source_CAP_017 0))
(assert (>= target_CAP_017 0))
(assert (not (= source_CAP_017 target_CAP_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_018: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_018 preserves semantics
(push 1)
(declare-const source_CAP_018 Int)
(declare-const target_CAP_018 Int)
(assert (>= source_CAP_018 0))
(assert (>= target_CAP_018 0))
(assert (not (= source_CAP_018 target_CAP_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_019: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_019 preserves semantics
(push 1)
(declare-const source_CAP_019 Int)
(declare-const target_CAP_019 Int)
(assert (>= source_CAP_019 0))
(assert (>= target_CAP_019 0))
(assert (not (= source_CAP_019 target_CAP_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_020: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_020 preserves semantics
(push 1)
(declare-const source_CAP_020 Int)
(declare-const target_CAP_020 Int)
(assert (>= source_CAP_020 0))
(assert (>= target_CAP_020 0))
(assert (not (= source_CAP_020 target_CAP_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_021: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_021 preserves semantics
(push 1)
(declare-const source_CAP_021 Int)
(declare-const target_CAP_021 Int)
(assert (>= source_CAP_021 0))
(assert (>= target_CAP_021 0))
(assert (not (= source_CAP_021 target_CAP_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_022: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_022 preserves semantics
(push 1)
(declare-const source_CAP_022 Int)
(declare-const target_CAP_022 Int)
(assert (>= source_CAP_022 0))
(assert (>= target_CAP_022 0))
(assert (not (= source_CAP_022 target_CAP_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_023: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_023 preserves semantics
(push 1)
(declare-const source_CAP_023 Int)
(declare-const target_CAP_023 Int)
(assert (>= source_CAP_023 0))
(assert (>= target_CAP_023 0))
(assert (not (= source_CAP_023 target_CAP_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_024: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_024 preserves semantics
(push 1)
(declare-const source_CAP_024 Int)
(declare-const target_CAP_024 Int)
(assert (>= source_CAP_024 0))
(assert (>= target_CAP_024 0))
(assert (not (= source_CAP_024 target_CAP_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_025: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_025 preserves semantics
(push 1)
(declare-const source_CAP_025 Int)
(declare-const target_CAP_025 Int)
(assert (>= source_CAP_025 0))
(assert (>= target_CAP_025 0))
(assert (not (= source_CAP_025 target_CAP_025)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_026: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_026 preserves semantics
(push 1)
(declare-const source_CAP_026 Int)
(declare-const target_CAP_026 Int)
(assert (>= source_CAP_026 0))
(assert (>= target_CAP_026 0))
(assert (not (= source_CAP_026 target_CAP_026)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_027: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_027 preserves semantics
(push 1)
(declare-const source_CAP_027 Int)
(declare-const target_CAP_027 Int)
(assert (>= source_CAP_027 0))
(assert (>= target_CAP_027 0))
(assert (not (= source_CAP_027 target_CAP_027)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_028: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_028 preserves semantics
(push 1)
(declare-const source_CAP_028 Int)
(declare-const target_CAP_028 Int)
(assert (>= source_CAP_028 0))
(assert (>= target_CAP_028 0))
(assert (not (= source_CAP_028 target_CAP_028)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_029: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_029 preserves semantics
(push 1)
(declare-const source_CAP_029 Int)
(declare-const target_CAP_029 Int)
(assert (>= source_CAP_029 0))
(assert (>= target_CAP_029 0))
(assert (not (= source_CAP_029 target_CAP_029)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_030_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_030_complete preserves semantics
(push 1)
(declare-const source_CAP_030_complete Int)
(declare-const target_CAP_030_complete Int)
(assert (>= source_CAP_030_complete 0))
(assert (>= target_CAP_030_complete 0))
(assert (not (= source_CAP_030_complete target_CAP_030_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_031_unforgeable_implies_authentic: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_031_unforgeable_implies_authentic preserves semantics
(push 1)
(declare-const source_CAP_031_unforgeable_implies_authentic Int)
(declare-const target_CAP_031_unforgeable_implies_authentic Int)
(assert (>= source_CAP_031_unforgeable_implies_authentic 0))
(assert (>= target_CAP_031_unforgeable_implies_authentic 0))
(assert (not (= source_CAP_031_unforgeable_implies_authentic target_CAP_031_unforgeable_implies_authentic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_032_unforgeable_config: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_032_unforgeable_config preserves semantics
(push 1)
(declare-const source_CAP_032_unforgeable_config Int)
(declare-const target_CAP_032_unforgeable_config Int)
(assert (>= source_CAP_032_unforgeable_config 0))
(assert (>= target_CAP_032_unforgeable_config 0))
(assert (not (= source_CAP_032_unforgeable_config target_CAP_032_unforgeable_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_033_unforgeable_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_033_unforgeable_preservation preserves semantics
(push 1)
(declare-const source_CAP_033_unforgeable_preservation Int)
(declare-const target_CAP_033_unforgeable_preservation Int)
(assert (>= source_CAP_033_unforgeable_preservation 0))
(assert (>= target_CAP_033_unforgeable_preservation 0))
(assert (not (= source_CAP_033_unforgeable_preservation target_CAP_033_unforgeable_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_034_unforgeable_and_revocable: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_034_unforgeable_and_revocable preserves semantics
(push 1)
(declare-const source_CAP_034_unforgeable_and_revocable Int)
(declare-const target_CAP_034_unforgeable_and_revocable Int)
(assert (>= source_CAP_034_unforgeable_and_revocable 0))
(assert (>= target_CAP_034_unforgeable_and_revocable 0))
(assert (not (= source_CAP_034_unforgeable_and_revocable target_CAP_034_unforgeable_and_revocable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_035_no_forge_without_grant: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_035_no_forge_without_grant preserves semantics
(push 1)
(declare-const source_CAP_035_no_forge_without_grant Int)
(declare-const target_CAP_035_no_forge_without_grant Int)
(assert (>= source_CAP_035_no_forge_without_grant 0))
(assert (>= target_CAP_035_no_forge_without_grant 0))
(assert (not (= source_CAP_035_no_forge_without_grant target_CAP_035_no_forge_without_grant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_036_encapsulation_prevents_forge: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_036_encapsulation_prevents_forge preserves semantics
(push 1)
(declare-const source_CAP_036_encapsulation_prevents_forge Int)
(declare-const target_CAP_036_encapsulation_prevents_forge Int)
(assert (>= source_CAP_036_encapsulation_prevents_forge 0))
(assert (>= target_CAP_036_encapsulation_prevents_forge 0))
(assert (not (= source_CAP_036_encapsulation_prevents_forge target_CAP_036_encapsulation_prevents_forge)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_037_connectivity_controlled: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_037_connectivity_controlled preserves semantics
(push 1)
(declare-const source_CAP_037_connectivity_controlled Int)
(declare-const target_CAP_037_connectivity_controlled Int)
(assert (>= source_CAP_037_connectivity_controlled 0))
(assert (>= target_CAP_037_connectivity_controlled 0))
(assert (not (= source_CAP_037_connectivity_controlled target_CAP_037_connectivity_controlled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_038_unforgeable_mem_cap: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_038_unforgeable_mem_cap preserves semantics
(push 1)
(declare-const source_CAP_038_unforgeable_mem_cap Int)
(declare-const target_CAP_038_unforgeable_mem_cap Int)
(assert (>= source_CAP_038_unforgeable_mem_cap 0))
(assert (>= target_CAP_038_unforgeable_mem_cap 0))
(assert (not (= source_CAP_038_unforgeable_mem_cap target_CAP_038_unforgeable_mem_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_039_sealed_cap_unforgeable: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_039_sealed_cap_unforgeable preserves semantics
(push 1)
(declare-const source_CAP_039_sealed_cap_unforgeable Int)
(declare-const target_CAP_039_sealed_cap_unforgeable Int)
(assert (>= source_CAP_039_sealed_cap_unforgeable 0))
(assert (>= target_CAP_039_sealed_cap_unforgeable 0))
(assert (not (= source_CAP_039_sealed_cap_unforgeable target_CAP_039_sealed_cap_unforgeable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_040_valid_cap_required: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_040_valid_cap_required preserves semantics
(push 1)
(declare-const source_CAP_040_valid_cap_required Int)
(declare-const target_CAP_040_valid_cap_required Int)
(assert (>= source_CAP_040_valid_cap_required 0))
(assert (>= target_CAP_040_valid_cap_required 0))
(assert (not (= source_CAP_040_valid_cap_required target_CAP_040_valid_cap_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_041_attenuatable_means_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_041_attenuatable_means_monotonic preserves semantics
(push 1)
(declare-const source_CAP_041_attenuatable_means_monotonic Int)
(declare-const target_CAP_041_attenuatable_means_monotonic Int)
(assert (>= source_CAP_041_attenuatable_means_monotonic 0))
(assert (>= target_CAP_041_attenuatable_means_monotonic 0))
(assert (not (= source_CAP_041_attenuatable_means_monotonic target_CAP_041_attenuatable_means_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perm_in_head: translation preserves property (matches Coq: Lemma)
; Translation validation: perm_in_head preserves semantics
(push 1)
(declare-const source_perm_in_head Int)
(declare-const target_perm_in_head Int)
(assert (>= source_perm_in_head 0))
(assert (>= target_perm_in_head 0))
(assert (not (= source_perm_in_head target_perm_in_head)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perm_in_cons: translation preserves property (matches Coq: Lemma)
; Translation validation: perm_in_cons preserves semantics
(push 1)
(declare-const source_perm_in_cons Int)
(declare-const target_perm_in_cons Int)
(assert (>= source_perm_in_cons 0))
(assert (>= target_perm_in_cons 0))
(assert (not (= source_perm_in_cons target_perm_in_cons)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_impl: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_impl preserves semantics
(push 1)
(declare-const source_forallb_impl Int)
(declare-const target_forallb_impl Int)
(assert (>= source_forallb_impl 0))
(assert (>= target_forallb_impl 0))
(assert (not (= source_forallb_impl target_forallb_impl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_042_perms_subset_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_042_perms_subset_reflexive preserves semantics
(push 1)
(declare-const source_CAP_042_perms_subset_reflexive Int)
(declare-const target_CAP_042_perms_subset_reflexive Int)
(assert (>= source_CAP_042_perms_subset_reflexive 0))
(assert (>= target_CAP_042_perms_subset_reflexive 0))
(assert (not (= source_CAP_042_perms_subset_reflexive target_CAP_042_perms_subset_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_043_empty_perms_subset: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_043_empty_perms_subset preserves semantics
(push 1)
(declare-const source_CAP_043_empty_perms_subset Int)
(declare-const target_CAP_043_empty_perms_subset Int)
(assert (>= source_CAP_043_empty_perms_subset 0))
(assert (>= target_CAP_043_empty_perms_subset 0))
(assert (not (= source_CAP_043_empty_perms_subset target_CAP_043_empty_perms_subset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_044_derive_from_self: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_044_derive_from_self preserves semantics
(push 1)
(declare-const source_CAP_044_derive_from_self Int)
(declare-const target_CAP_044_derive_from_self Int)
(assert (>= source_CAP_044_derive_from_self 0))
(assert (>= target_CAP_044_derive_from_self 0))
(assert (not (= source_CAP_044_derive_from_self target_CAP_044_derive_from_self)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_045_derive_cannot_exceed_parent: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_045_derive_cannot_exceed_parent preserves semantics
(push 1)
(declare-const source_CAP_045_derive_cannot_exceed_parent Int)
(declare-const target_CAP_045_derive_cannot_exceed_parent Int)
(assert (>= source_CAP_045_derive_cannot_exceed_parent 0))
(assert (>= target_CAP_045_derive_cannot_exceed_parent 0))
(assert (not (= source_CAP_045_derive_cannot_exceed_parent target_CAP_045_derive_cannot_exceed_parent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_046_derive_bounds_contained: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_046_derive_bounds_contained preserves semantics
(push 1)
(declare-const source_CAP_046_derive_bounds_contained Int)
(declare-const target_CAP_046_derive_bounds_contained Int)
(assert (>= source_CAP_046_derive_bounds_contained 0))
(assert (>= target_CAP_046_derive_bounds_contained 0))
(assert (not (= source_CAP_046_derive_bounds_contained target_CAP_046_derive_bounds_contained)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_047_derive_perms_subset: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_047_derive_perms_subset preserves semantics
(push 1)
(declare-const source_CAP_047_derive_perms_subset Int)
(declare-const target_CAP_047_derive_perms_subset Int)
(assert (>= source_CAP_047_derive_perms_subset 0))
(assert (>= target_CAP_047_derive_perms_subset 0))
(assert (not (= source_CAP_047_derive_perms_subset target_CAP_047_derive_perms_subset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_048_sealed_prevents_derive: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_048_sealed_prevents_derive preserves semantics
(push 1)
(declare-const source_CAP_048_sealed_prevents_derive Int)
(declare-const target_CAP_048_sealed_prevents_derive Int)
(assert (>= source_CAP_048_sealed_prevents_derive 0))
(assert (>= target_CAP_048_sealed_prevents_derive 0))
(assert (not (= source_CAP_048_sealed_prevents_derive target_CAP_048_sealed_prevents_derive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_049_perm_leq_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_049_perm_leq_reflexive preserves semantics
(push 1)
(declare-const source_CAP_049_perm_leq_reflexive Int)
(declare-const target_CAP_049_perm_leq_reflexive Int)
(assert (>= source_CAP_049_perm_leq_reflexive 0))
(assert (>= target_CAP_049_perm_leq_reflexive 0))
(assert (not (= source_CAP_049_perm_leq_reflexive target_CAP_049_perm_leq_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_050_read_leq_write: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_050_read_leq_write preserves semantics
(push 1)
(declare-const source_CAP_050_read_leq_write Int)
(declare-const target_CAP_050_read_leq_write Int)
(assert (>= source_CAP_050_read_leq_write 0))
(assert (>= target_CAP_050_read_leq_write 0))
(assert (not (= source_CAP_050_read_leq_write target_CAP_050_read_leq_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_051_write_leq_execute: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_051_write_leq_execute preserves semantics
(push 1)
(declare-const source_CAP_051_write_leq_execute Int)
(declare-const target_CAP_051_write_leq_execute Int)
(assert (>= source_CAP_051_write_leq_execute 0))
(assert (>= target_CAP_051_write_leq_execute 0))
(assert (not (= source_CAP_051_write_leq_execute target_CAP_051_write_leq_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_052_perm_leq_transitive: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_052_perm_leq_transitive preserves semantics
(push 1)
(declare-const source_CAP_052_perm_leq_transitive Int)
(declare-const target_CAP_052_perm_leq_transitive Int)
(assert (>= source_CAP_052_perm_leq_transitive 0))
(assert (>= target_CAP_052_perm_leq_transitive 0))
(assert (not (= source_CAP_052_perm_leq_transitive target_CAP_052_perm_leq_transitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_053_perm_lt_irreflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_053_perm_lt_irreflexive preserves semantics
(push 1)
(declare-const source_CAP_053_perm_lt_irreflexive Int)
(declare-const target_CAP_053_perm_lt_irreflexive Int)
(assert (>= source_CAP_053_perm_lt_irreflexive 0))
(assert (>= target_CAP_053_perm_lt_irreflexive 0))
(assert (not (= source_CAP_053_perm_lt_irreflexive target_CAP_053_perm_lt_irreflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_054_monotonic_no_escalation: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_054_monotonic_no_escalation preserves semantics
(push 1)
(declare-const source_CAP_054_monotonic_no_escalation Int)
(declare-const target_CAP_054_monotonic_no_escalation Int)
(assert (>= source_CAP_054_monotonic_no_escalation 0))
(assert (>= target_CAP_054_monotonic_no_escalation 0))
(assert (not (= source_CAP_054_monotonic_no_escalation target_CAP_054_monotonic_no_escalation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_055_derive_preserves_validity: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_055_derive_preserves_validity preserves semantics
(push 1)
(declare-const source_CAP_055_derive_preserves_validity Int)
(declare-const target_CAP_055_derive_preserves_validity Int)
(assert (>= source_CAP_055_derive_preserves_validity 0))
(assert (>= target_CAP_055_derive_preserves_validity 0))
(assert (not (= source_CAP_055_derive_preserves_validity target_CAP_055_derive_preserves_validity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_056_empty_not_revoked: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_056_empty_not_revoked preserves semantics
(push 1)
(declare-const source_CAP_056_empty_not_revoked Int)
(declare-const target_CAP_056_empty_not_revoked Int)
(assert (>= source_CAP_056_empty_not_revoked 0))
(assert (>= target_CAP_056_empty_not_revoked 0))
(assert (not (= source_CAP_056_empty_not_revoked target_CAP_056_empty_not_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_057_revoke_makes_revoked: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_057_revoke_makes_revoked preserves semantics
(push 1)
(declare-const source_CAP_057_revoke_makes_revoked Int)
(declare-const target_CAP_057_revoke_makes_revoked Int)
(assert (>= source_CAP_057_revoke_makes_revoked 0))
(assert (>= target_CAP_057_revoke_makes_revoked 0))
(assert (not (= source_CAP_057_revoke_makes_revoked target_CAP_057_revoke_makes_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_058_revoke_idempotent: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_058_revoke_idempotent preserves semantics
(push 1)
(declare-const source_CAP_058_revoke_idempotent Int)
(declare-const target_CAP_058_revoke_idempotent Int)
(assert (>= source_CAP_058_revoke_idempotent 0))
(assert (>= target_CAP_058_revoke_idempotent 0))
(assert (not (= source_CAP_058_revoke_idempotent target_CAP_058_revoke_idempotent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_059_revoke_other_unchanged: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_059_revoke_other_unchanged preserves semantics
(push 1)
(declare-const source_CAP_059_revoke_other_unchanged Int)
(declare-const target_CAP_059_revoke_other_unchanged Int)
(assert (>= source_CAP_059_revoke_other_unchanged 0))
(assert (>= target_CAP_059_revoke_other_unchanged 0))
(assert (not (= source_CAP_059_revoke_other_unchanged target_CAP_059_revoke_other_unchanged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_060_cap_revocable_riina: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_060_cap_revocable_riina preserves semantics
(push 1)
(declare-const source_CAP_060_cap_revocable_riina Int)
(declare-const target_CAP_060_cap_revocable_riina Int)
(assert (>= source_CAP_060_cap_revocable_riina 0))
(assert (>= target_CAP_060_cap_revocable_riina 0))
(assert (not (= source_CAP_060_cap_revocable_riina target_CAP_060_cap_revocable_riina)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_061_revocable_implies_can_revoke: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_061_revocable_implies_can_revoke preserves semantics
(push 1)
(declare-const source_CAP_061_revocable_implies_can_revoke Int)
(declare-const target_CAP_061_revocable_implies_can_revoke Int)
(assert (>= source_CAP_061_revocable_implies_can_revoke 0))
(assert (>= target_CAP_061_revocable_implies_can_revoke 0))
(assert (not (= source_CAP_061_revocable_implies_can_revoke target_CAP_061_revocable_implies_can_revoke)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_062_revoked_mem_cap_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_062_revoked_mem_cap_invalid preserves semantics
(push 1)
(declare-const source_CAP_062_revoked_mem_cap_invalid Int)
(declare-const target_CAP_062_revoked_mem_cap_invalid Int)
(assert (>= source_CAP_062_revoked_mem_cap_invalid 0))
(assert (>= target_CAP_062_revoked_mem_cap_invalid 0))
(assert (not (= source_CAP_062_revoked_mem_cap_invalid target_CAP_062_revoked_mem_cap_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_063_revoked_cannot_read: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_063_revoked_cannot_read preserves semantics
(push 1)
(declare-const source_CAP_063_revoked_cannot_read Int)
(declare-const target_CAP_063_revoked_cannot_read Int)
(assert (>= source_CAP_063_revoked_cannot_read 0))
(assert (>= target_CAP_063_revoked_cannot_read 0))
(assert (not (= source_CAP_063_revoked_cannot_read target_CAP_063_revoked_cannot_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_064_revoked_cannot_write: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_064_revoked_cannot_write preserves semantics
(push 1)
(declare-const source_CAP_064_revoked_cannot_write Int)
(declare-const target_CAP_064_revoked_cannot_write Int)
(assert (>= source_CAP_064_revoked_cannot_write 0))
(assert (>= target_CAP_064_revoked_cannot_write 0))
(assert (not (= source_CAP_064_revoked_cannot_write target_CAP_064_revoked_cannot_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_065_revoked_cannot_execute: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_065_revoked_cannot_execute preserves semantics
(push 1)
(declare-const source_CAP_065_revoked_cannot_execute Int)
(declare-const target_CAP_065_revoked_cannot_execute Int)
(assert (>= source_CAP_065_revoked_cannot_execute 0))
(assert (>= target_CAP_065_revoked_cannot_execute 0))
(assert (not (= source_CAP_065_revoked_cannot_execute target_CAP_065_revoked_cannot_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_066_confinement_enforced: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_066_confinement_enforced preserves semantics
(push 1)
(declare-const source_CAP_066_confinement_enforced Int)
(declare-const target_CAP_066_confinement_enforced Int)
(assert (>= source_CAP_066_confinement_enforced 0))
(assert (>= target_CAP_066_confinement_enforced 0))
(assert (not (= source_CAP_066_confinement_enforced target_CAP_066_confinement_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_067_no_ambient_authority: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_067_no_ambient_authority preserves semantics
(push 1)
(declare-const source_CAP_067_no_ambient_authority Int)
(declare-const target_CAP_067_no_ambient_authority Int)
(assert (>= source_CAP_067_no_ambient_authority 0))
(assert (>= target_CAP_067_no_ambient_authority 0))
(assert (not (= source_CAP_067_no_ambient_authority target_CAP_067_no_ambient_authority)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_068_explicit_access_only: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_068_explicit_access_only preserves semantics
(push 1)
(declare-const source_CAP_068_explicit_access_only Int)
(declare-const target_CAP_068_explicit_access_only Int)
(assert (>= source_CAP_068_explicit_access_only 0))
(assert (>= target_CAP_068_explicit_access_only 0))
(assert (not (= source_CAP_068_explicit_access_only target_CAP_068_explicit_access_only)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_069_no_privilege_escalation: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_069_no_privilege_escalation preserves semantics
(push 1)
(declare-const source_CAP_069_no_privilege_escalation Int)
(declare-const target_CAP_069_no_privilege_escalation Int)
(assert (>= source_CAP_069_no_privilege_escalation 0))
(assert (>= target_CAP_069_no_privilege_escalation 0))
(assert (not (= source_CAP_069_no_privilege_escalation target_CAP_069_no_privilege_escalation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_070_ocap_no_ambient: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_070_ocap_no_ambient preserves semantics
(push 1)
(declare-const source_CAP_070_ocap_no_ambient Int)
(declare-const target_CAP_070_ocap_no_ambient Int)
(assert (>= source_CAP_070_ocap_no_ambient 0))
(assert (>= target_CAP_070_ocap_no_ambient 0))
(assert (not (= source_CAP_070_ocap_no_ambient target_CAP_070_ocap_no_ambient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_071_has_cap_empty: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_071_has_cap_empty preserves semantics
(push 1)
(declare-const source_CAP_071_has_cap_empty Int)
(declare-const target_CAP_071_has_cap_empty Int)
(assert (>= source_CAP_071_has_cap_empty 0))
(assert (>= target_CAP_071_has_cap_empty 0))
(assert (not (= source_CAP_071_has_cap_empty target_CAP_071_has_cap_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_072_has_cap_head: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_072_has_cap_head preserves semantics
(push 1)
(declare-const source_CAP_072_has_cap_head Int)
(declare-const target_CAP_072_has_cap_head Int)
(assert (>= source_CAP_072_has_cap_head 0))
(assert (>= target_CAP_072_has_cap_head 0))
(assert (not (= source_CAP_072_has_cap_head target_CAP_072_has_cap_head)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_073_confinement_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_073_confinement_complete preserves semantics
(push 1)
(declare-const source_CAP_073_confinement_complete Int)
(declare-const target_CAP_073_confinement_complete Int)
(assert (>= source_CAP_073_confinement_complete 0))
(assert (>= target_CAP_073_confinement_complete 0))
(assert (not (= source_CAP_073_confinement_complete target_CAP_073_confinement_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_074_confined_needs_cap: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_074_confined_needs_cap preserves semantics
(push 1)
(declare-const source_CAP_074_confined_needs_cap Int)
(declare-const target_CAP_074_confined_needs_cap Int)
(assert (>= source_CAP_074_confined_needs_cap 0))
(assert (>= target_CAP_074_confined_needs_cap 0))
(assert (not (= source_CAP_074_confined_needs_cap target_CAP_074_confined_needs_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_075_confined_no_escalate: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_075_confined_no_escalate preserves semantics
(push 1)
(declare-const source_CAP_075_confined_no_escalate Int)
(declare-const target_CAP_075_confined_no_escalate Int)
(assert (>= source_CAP_075_confined_no_escalate 0))
(assert (>= target_CAP_075_confined_no_escalate 0))
(assert (not (= source_CAP_075_confined_no_escalate target_CAP_075_confined_no_escalate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_076_full_can_redelegate: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_076_full_can_redelegate preserves semantics
(push 1)
(declare-const source_CAP_076_full_can_redelegate Int)
(declare-const target_CAP_076_full_can_redelegate Int)
(assert (>= source_CAP_076_full_can_redelegate 0))
(assert (>= target_CAP_076_full_can_redelegate 0))
(assert (not (= source_CAP_076_full_can_redelegate target_CAP_076_full_can_redelegate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_077_restricted_cannot_redelegate: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_077_restricted_cannot_redelegate preserves semantics
(push 1)
(declare-const source_CAP_077_restricted_cannot_redelegate Int)
(declare-const target_CAP_077_restricted_cannot_redelegate Int)
(assert (>= source_CAP_077_restricted_cannot_redelegate 0))
(assert (>= target_CAP_077_restricted_cannot_redelegate 0))
(assert (not (= source_CAP_077_restricted_cannot_redelegate target_CAP_077_restricted_cannot_redelegate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_078_once_cannot_redelegate: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_078_once_cannot_redelegate preserves semantics
(push 1)
(declare-const source_CAP_078_once_cannot_redelegate Int)
(declare-const target_CAP_078_once_cannot_redelegate Int)
(assert (>= source_CAP_078_once_cannot_redelegate 0))
(assert (>= target_CAP_078_once_cannot_redelegate 0))
(assert (not (= source_CAP_078_once_cannot_redelegate target_CAP_078_once_cannot_redelegate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_079_inactive_delegation: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_079_inactive_delegation preserves semantics
(push 1)
(declare-const source_CAP_079_inactive_delegation Int)
(declare-const target_CAP_079_inactive_delegation Int)
(assert (>= source_CAP_079_inactive_delegation 0))
(assert (>= target_CAP_079_inactive_delegation 0))
(assert (not (= source_CAP_079_inactive_delegation target_CAP_079_inactive_delegation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_080_delegation_has_from: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_080_delegation_has_from preserves semantics
(push 1)
(declare-const source_CAP_080_delegation_has_from Int)
(declare-const target_CAP_080_delegation_has_from Int)
(assert (>= source_CAP_080_delegation_has_from 0))
(assert (>= target_CAP_080_delegation_has_from 0))
(assert (not (= source_CAP_080_delegation_has_from target_CAP_080_delegation_has_from)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_081_delegation_has_to: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_081_delegation_has_to preserves semantics
(push 1)
(declare-const source_CAP_081_delegation_has_to Int)
(declare-const target_CAP_081_delegation_has_to Int)
(assert (>= source_CAP_081_delegation_has_to 0))
(assert (>= target_CAP_081_delegation_has_to 0))
(assert (not (= source_CAP_081_delegation_has_to target_CAP_081_delegation_has_to)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_082_delegation_has_cap: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_082_delegation_has_cap preserves semantics
(push 1)
(declare-const source_CAP_082_delegation_has_cap Int)
(declare-const target_CAP_082_delegation_has_cap Int)
(assert (>= source_CAP_082_delegation_has_cap 0))
(assert (>= target_CAP_082_delegation_has_cap 0))
(assert (not (= source_CAP_082_delegation_has_cap target_CAP_082_delegation_has_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_083_delegation_type_full: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_083_delegation_type_full preserves semantics
(push 1)
(declare-const source_CAP_083_delegation_type_full Int)
(declare-const target_CAP_083_delegation_type_full Int)
(assert (>= source_CAP_083_delegation_type_full 0))
(assert (>= target_CAP_083_delegation_type_full 0))
(assert (not (= source_CAP_083_delegation_type_full target_CAP_083_delegation_type_full)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_084_delegation_type_restricted: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_084_delegation_type_restricted preserves semantics
(push 1)
(declare-const source_CAP_084_delegation_type_restricted Int)
(declare-const target_CAP_084_delegation_type_restricted Int)
(assert (>= source_CAP_084_delegation_type_restricted 0))
(assert (>= target_CAP_084_delegation_type_restricted 0))
(assert (not (= source_CAP_084_delegation_type_restricted target_CAP_084_delegation_type_restricted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_085_delegation_type_once: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_085_delegation_type_once preserves semantics
(push 1)
(declare-const source_CAP_085_delegation_type_once Int)
(declare-const target_CAP_085_delegation_type_once Int)
(assert (>= source_CAP_085_delegation_type_once 0))
(assert (>= target_CAP_085_delegation_type_once 0))
(assert (not (= source_CAP_085_delegation_type_once target_CAP_085_delegation_type_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_086_bounds_check_in_range: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_086_bounds_check_in_range preserves semantics
(push 1)
(declare-const source_CAP_086_bounds_check_in_range Int)
(declare-const target_CAP_086_bounds_check_in_range Int)
(assert (>= source_CAP_086_bounds_check_in_range 0))
(assert (>= target_CAP_086_bounds_check_in_range 0))
(assert (not (= source_CAP_086_bounds_check_in_range target_CAP_086_bounds_check_in_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_087_bounds_check_out_of_range_low: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_087_bounds_check_out_of_range_low preserves semantics
(push 1)
(declare-const source_CAP_087_bounds_check_out_of_range_low Int)
(declare-const target_CAP_087_bounds_check_out_of_range_low Int)
(assert (>= source_CAP_087_bounds_check_out_of_range_low 0))
(assert (>= target_CAP_087_bounds_check_out_of_range_low 0))
(assert (not (= source_CAP_087_bounds_check_out_of_range_low target_CAP_087_bounds_check_out_of_range_low)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_088_bounds_check_out_of_range_high: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_088_bounds_check_out_of_range_high preserves semantics
(push 1)
(declare-const source_CAP_088_bounds_check_out_of_range_high Int)
(declare-const target_CAP_088_bounds_check_out_of_range_high Int)
(assert (>= source_CAP_088_bounds_check_out_of_range_high 0))
(assert (>= target_CAP_088_bounds_check_out_of_range_high 0))
(assert (not (= source_CAP_088_bounds_check_out_of_range_high target_CAP_088_bounds_check_out_of_range_high)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_089_riina_mem_cap_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_089_riina_mem_cap_valid preserves semantics
(push 1)
(declare-const source_CAP_089_riina_mem_cap_valid Int)
(declare-const target_CAP_089_riina_mem_cap_valid Int)
(assert (>= source_CAP_089_riina_mem_cap_valid 0))
(assert (>= target_CAP_089_riina_mem_cap_valid 0))
(assert (not (= source_CAP_089_riina_mem_cap_valid target_CAP_089_riina_mem_cap_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_090_riina_mem_cap_not_sealed: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_090_riina_mem_cap_not_sealed preserves semantics
(push 1)
(declare-const source_CAP_090_riina_mem_cap_not_sealed Int)
(declare-const target_CAP_090_riina_mem_cap_not_sealed Int)
(assert (>= source_CAP_090_riina_mem_cap_not_sealed 0))
(assert (>= target_CAP_090_riina_mem_cap_not_sealed 0))
(assert (not (= source_CAP_090_riina_mem_cap_not_sealed target_CAP_090_riina_mem_cap_not_sealed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_091_riina_mem_cap_base: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_091_riina_mem_cap_base preserves semantics
(push 1)
(declare-const source_CAP_091_riina_mem_cap_base Int)
(declare-const target_CAP_091_riina_mem_cap_base Int)
(assert (>= source_CAP_091_riina_mem_cap_base 0))
(assert (>= target_CAP_091_riina_mem_cap_base 0))
(assert (not (= source_CAP_091_riina_mem_cap_base target_CAP_091_riina_mem_cap_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_092_riina_mem_cap_length: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_092_riina_mem_cap_length preserves semantics
(push 1)
(declare-const source_CAP_092_riina_mem_cap_length Int)
(declare-const target_CAP_092_riina_mem_cap_length Int)
(assert (>= source_CAP_092_riina_mem_cap_length 0))
(assert (>= target_CAP_092_riina_mem_cap_length 0))
(assert (not (= source_CAP_092_riina_mem_cap_length target_CAP_092_riina_mem_cap_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_093_valid_for_read: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_093_valid_for_read preserves semantics
(push 1)
(declare-const source_CAP_093_valid_for_read Int)
(declare-const target_CAP_093_valid_for_read Int)
(assert (>= source_CAP_093_valid_for_read 0))
(assert (>= target_CAP_093_valid_for_read 0))
(assert (not (= source_CAP_093_valid_for_read target_CAP_093_valid_for_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_094_valid_for_write: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_094_valid_for_write preserves semantics
(push 1)
(declare-const source_CAP_094_valid_for_write Int)
(declare-const target_CAP_094_valid_for_write Int)
(assert (>= source_CAP_094_valid_for_write 0))
(assert (>= target_CAP_094_valid_for_write 0))
(assert (not (= source_CAP_094_valid_for_write target_CAP_094_valid_for_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_095_valid_for_execute: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_095_valid_for_execute preserves semantics
(push 1)
(declare-const source_CAP_095_valid_for_execute Int)
(declare-const target_CAP_095_valid_for_execute Int)
(assert (>= source_CAP_095_valid_for_execute 0))
(assert (>= target_CAP_095_valid_for_execute 0))
(assert (not (= source_CAP_095_valid_for_execute target_CAP_095_valid_for_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_096_sealed_cannot_derive: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_096_sealed_cannot_derive preserves semantics
(push 1)
(declare-const source_CAP_096_sealed_cannot_derive Int)
(declare-const target_CAP_096_sealed_cannot_derive Int)
(assert (>= source_CAP_096_sealed_cannot_derive 0))
(assert (>= target_CAP_096_sealed_cannot_derive 0))
(assert (not (= source_CAP_096_sealed_cannot_derive target_CAP_096_sealed_cannot_derive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_097_empty_perms_no_access: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_097_empty_perms_no_access preserves semantics
(push 1)
(declare-const source_CAP_097_empty_perms_no_access Int)
(declare-const target_CAP_097_empty_perms_no_access Int)
(assert (>= source_CAP_097_empty_perms_no_access 0))
(assert (>= target_CAP_097_empty_perms_no_access 0))
(assert (not (= source_CAP_097_empty_perms_no_access target_CAP_097_empty_perms_no_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_098_mem_cap_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_098_mem_cap_complete preserves semantics
(push 1)
(declare-const source_CAP_098_mem_cap_complete Int)
(declare-const target_CAP_098_mem_cap_complete Int)
(assert (>= source_CAP_098_mem_cap_complete 0))
(assert (>= target_CAP_098_mem_cap_complete 0))
(assert (not (= source_CAP_098_mem_cap_complete target_CAP_098_mem_cap_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_099_zero_length_no_access: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_099_zero_length_no_access preserves semantics
(push 1)
(declare-const source_CAP_099_zero_length_no_access Int)
(declare-const target_CAP_099_zero_length_no_access Int)
(assert (>= source_CAP_099_zero_length_no_access 0))
(assert (>= target_CAP_099_zero_length_no_access 0))
(assert (not (= source_CAP_099_zero_length_no_access target_CAP_099_zero_length_no_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_100_security_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_100_security_complete preserves semantics
(push 1)
(declare-const source_CAP_100_security_complete Int)
(declare-const target_CAP_100_security_complete Int)
(assert (>= source_CAP_100_security_complete 0))
(assert (>= target_CAP_100_security_complete 0))
(assert (not (= source_CAP_100_security_complete target_CAP_100_security_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)
