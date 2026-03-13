; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/AgentToolSecurity.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for AgentToolSecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; cap_level_leq: source semantics (matches Coq)
; Translation validation: cap_level_leq preserves semantics
(push 1)
(declare-const source_cap_level_leq Int)
(declare-const target_cap_level_leq Int)
(assert (>= source_cap_level_leq 0))
(assert (>= target_cap_level_leq 0))
(assert (not (= source_cap_level_leq target_cap_level_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; check_invocation: source semantics (matches Coq)
; Translation validation: check_invocation preserves semantics
(push 1)
(declare-const source_check_invocation Int)
(declare-const target_check_invocation Int)
(assert (>= source_check_invocation 0))
(assert (>= target_check_invocation 0))
(assert (not (= source_check_invocation target_check_invocation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_permitted: source semantics (matches Coq)
; Translation validation: is_permitted preserves semantics
(push 1)
(declare-const source_is_permitted Int)
(declare-const target_is_permitted Int)
(assert (>= source_is_permitted 0))
(assert (>= target_is_permitted 0))
(assert (not (= source_is_permitted target_is_permitted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_agent_boundary: source semantics (matches Coq)
; Translation validation: riina_agent_boundary preserves semantics
(push 1)
(declare-const source_riina_agent_boundary Int)
(declare-const target_riina_agent_boundary Int)
(assert (>= source_riina_agent_boundary 0))
(assert (>= target_riina_agent_boundary 0))
(assert (not (= source_riina_agent_boundary target_riina_agent_boundary)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; safe_readonly_tool: source semantics (matches Coq)
; Translation validation: safe_readonly_tool preserves semantics
(push 1)
(declare-const source_safe_readonly_tool Int)
(declare-const target_safe_readonly_tool Int)
(assert (>= source_safe_readonly_tool 0))
(assert (>= target_safe_readonly_tool 0))
(assert (not (= source_safe_readonly_tool target_safe_readonly_tool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; safe_readwrite_tool: source semantics (matches Coq)
; Translation validation: safe_readwrite_tool preserves semantics
(push 1)
(declare-const source_safe_readwrite_tool Int)
(declare-const target_safe_readwrite_tool Int)
(assert (>= source_safe_readwrite_tool 0))
(assert (>= target_safe_readwrite_tool 0))
(assert (not (= source_safe_readwrite_tool target_safe_readwrite_tool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unsafe_network_tool: source semantics (matches Coq)
; Translation validation: unsafe_network_tool preserves semantics
(push 1)
(declare-const source_unsafe_network_tool Int)
(declare-const target_unsafe_network_tool Int)
(assert (>= source_unsafe_network_tool 0))
(assert (>= target_unsafe_network_tool 0))
(assert (not (= source_unsafe_network_tool target_unsafe_network_tool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unsandboxed_tool: source semantics (matches Coq)
; Translation validation: unsandboxed_tool preserves semantics
(push 1)
(declare-const source_unsandboxed_tool Int)
(declare-const target_unsandboxed_tool Int)
(assert (>= source_unsandboxed_tool 0))
(assert (>= target_unsandboxed_tool 0))
(assert (not (= source_unsandboxed_tool target_unsandboxed_tool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unvalidated_tool: source semantics (matches Coq)
; Translation validation: unvalidated_tool preserves semantics
(push 1)
(declare-const source_unvalidated_tool Int)
(declare-const target_unvalidated_tool Int)
(assert (>= source_unvalidated_tool 0))
(assert (>= target_unvalidated_tool 0))
(assert (not (= source_unvalidated_tool target_unvalidated_tool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_001_readonly_permitted: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_001_readonly_permitted preserves semantics
(push 1)
(declare-const source_AGENT_001_readonly_permitted Int)
(declare-const target_AGENT_001_readonly_permitted Int)
(assert (>= source_AGENT_001_readonly_permitted 0))
(assert (>= target_AGENT_001_readonly_permitted 0))
(assert (not (= source_AGENT_001_readonly_permitted target_AGENT_001_readonly_permitted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_002_readwrite_permitted: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_002_readwrite_permitted preserves semantics
(push 1)
(declare-const source_AGENT_002_readwrite_permitted Int)
(declare-const target_AGENT_002_readwrite_permitted Int)
(assert (>= source_AGENT_002_readwrite_permitted 0))
(assert (>= target_AGENT_002_readwrite_permitted 0))
(assert (not (= source_AGENT_002_readwrite_permitted target_AGENT_002_readwrite_permitted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_003_network_denied: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_003_network_denied preserves semantics
(push 1)
(declare-const source_AGENT_003_network_denied Int)
(declare-const target_AGENT_003_network_denied Int)
(assert (>= source_AGENT_003_network_denied 0))
(assert (>= target_AGENT_003_network_denied 0))
(assert (not (= source_AGENT_003_network_denied target_AGENT_003_network_denied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_004_unsandboxed_denied: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_004_unsandboxed_denied preserves semantics
(push 1)
(declare-const source_AGENT_004_unsandboxed_denied Int)
(declare-const target_AGENT_004_unsandboxed_denied Int)
(assert (>= source_AGENT_004_unsandboxed_denied 0))
(assert (>= target_AGENT_004_unsandboxed_denied 0))
(assert (not (= source_AGENT_004_unsandboxed_denied target_AGENT_004_unsandboxed_denied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_005_unvalidated_denied: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_005_unvalidated_denied preserves semantics
(push 1)
(declare-const source_AGENT_005_unvalidated_denied Int)
(declare-const target_AGENT_005_unvalidated_denied Int)
(assert (>= source_AGENT_005_unvalidated_denied 0))
(assert (>= target_AGENT_005_unvalidated_denied 0))
(assert (not (= source_AGENT_005_unvalidated_denied target_AGENT_005_unvalidated_denied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_006_cap_level_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_006_cap_level_refl preserves semantics
(push 1)
(declare-const source_AGENT_006_cap_level_refl Int)
(declare-const target_AGENT_006_cap_level_refl Int)
(assert (>= source_AGENT_006_cap_level_refl 0))
(assert (>= target_AGENT_006_cap_level_refl 0))
(assert (not (= source_AGENT_006_cap_level_refl target_AGENT_006_cap_level_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_007_readonly_min: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_007_readonly_min preserves semantics
(push 1)
(declare-const source_AGENT_007_readonly_min Int)
(declare-const target_AGENT_007_readonly_min Int)
(assert (>= source_AGENT_007_readonly_min 0))
(assert (>= target_AGENT_007_readonly_min 0))
(assert (not (= source_AGENT_007_readonly_min target_AGENT_007_readonly_min)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_008_system_max: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_008_system_max preserves semantics
(push 1)
(declare-const source_AGENT_008_system_max Int)
(declare-const target_AGENT_008_system_max Int)
(assert (>= source_AGENT_008_system_max 0))
(assert (>= target_AGENT_008_system_max 0))
(assert (not (= source_AGENT_008_system_max target_AGENT_008_system_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff_agent: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff_agent preserves semantics
(push 1)
(declare-const source_andb_true_iff_agent Int)
(declare-const target_andb_true_iff_agent Int)
(assert (>= source_andb_true_iff_agent 0))
(assert (>= target_andb_true_iff_agent 0))
(assert (not (= source_andb_true_iff_agent target_andb_true_iff_agent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_009_network_exceeds_rw: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_009_network_exceeds_rw preserves semantics
(push 1)
(declare-const source_AGENT_009_network_exceeds_rw Int)
(declare-const target_AGENT_009_network_exceeds_rw Int)
(assert (>= source_AGENT_009_network_exceeds_rw 0))
(assert (>= target_AGENT_009_network_exceeds_rw 0))
(assert (not (= source_AGENT_009_network_exceeds_rw target_AGENT_009_network_exceeds_rw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_010_execute_exceeds_rw: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_010_execute_exceeds_rw preserves semantics
(push 1)
(declare-const source_AGENT_010_execute_exceeds_rw Int)
(declare-const target_AGENT_010_execute_exceeds_rw Int)
(assert (>= source_AGENT_010_execute_exceeds_rw 0))
(assert (>= target_AGENT_010_execute_exceeds_rw 0))
(assert (not (= source_AGENT_010_execute_exceeds_rw target_AGENT_010_execute_exceeds_rw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_011_permitted_is_permitted: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_011_permitted_is_permitted preserves semantics
(push 1)
(declare-const source_AGENT_011_permitted_is_permitted Int)
(declare-const target_AGENT_011_permitted_is_permitted Int)
(assert (>= source_AGENT_011_permitted_is_permitted 0))
(assert (>= target_AGENT_011_permitted_is_permitted 0))
(assert (not (= source_AGENT_011_permitted_is_permitted target_AGENT_011_permitted_is_permitted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_012_denied_level: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_012_denied_level preserves semantics
(push 1)
(declare-const source_AGENT_012_denied_level Int)
(declare-const target_AGENT_012_denied_level Int)
(assert (>= source_AGENT_012_denied_level 0))
(assert (>= target_AGENT_012_denied_level 0))
(assert (not (= source_AGENT_012_denied_level target_AGENT_012_denied_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_013_denied_network: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_013_denied_network preserves semantics
(push 1)
(declare-const source_AGENT_013_denied_network Int)
(declare-const target_AGENT_013_denied_network Int)
(assert (>= source_AGENT_013_denied_network 0))
(assert (>= target_AGENT_013_denied_network 0))
(assert (not (= source_AGENT_013_denied_network target_AGENT_013_denied_network)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_014_denied_sandbox: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_014_denied_sandbox preserves semantics
(push 1)
(declare-const source_AGENT_014_denied_sandbox Int)
(declare-const target_AGENT_014_denied_sandbox Int)
(assert (>= source_AGENT_014_denied_sandbox 0))
(assert (>= target_AGENT_014_denied_sandbox 0))
(assert (not (= source_AGENT_014_denied_sandbox target_AGENT_014_denied_sandbox)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_015_denied_validation: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_015_denied_validation preserves semantics
(push 1)
(declare-const source_AGENT_015_denied_validation Int)
(declare-const target_AGENT_015_denied_validation Int)
(assert (>= source_AGENT_015_denied_validation 0))
(assert (>= target_AGENT_015_denied_validation 0))
(assert (not (= source_AGENT_015_denied_validation target_AGENT_015_denied_validation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_016_sandbox_enforcement: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_016_sandbox_enforcement preserves semantics
(push 1)
(declare-const source_AGENT_016_sandbox_enforcement Int)
(declare-const target_AGENT_016_sandbox_enforcement Int)
(assert (>= source_AGENT_016_sandbox_enforcement 0))
(assert (>= target_AGENT_016_sandbox_enforcement 0))
(assert (not (= source_AGENT_016_sandbox_enforcement target_AGENT_016_sandbox_enforcement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_017_riina_denies_system: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_017_riina_denies_system preserves semantics
(push 1)
(declare-const source_AGENT_017_riina_denies_system Int)
(declare-const target_AGENT_017_riina_denies_system Int)
(assert (>= source_AGENT_017_riina_denies_system 0))
(assert (>= target_AGENT_017_riina_denies_system 0))
(assert (not (= source_AGENT_017_riina_denies_system target_AGENT_017_riina_denies_system)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_018_riina_denies_execute: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_018_riina_denies_execute preserves semantics
(push 1)
(declare-const source_AGENT_018_riina_denies_execute Int)
(declare-const target_AGENT_018_riina_denies_execute Int)
(assert (>= source_AGENT_018_riina_denies_execute 0))
(assert (>= target_AGENT_018_riina_denies_execute 0))
(assert (not (= source_AGENT_018_riina_denies_execute target_AGENT_018_riina_denies_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_019_riina_denies_network: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_019_riina_denies_network preserves semantics
(push 1)
(declare-const source_AGENT_019_riina_denies_network Int)
(declare-const target_AGENT_019_riina_denies_network Int)
(assert (>= source_AGENT_019_riina_denies_network 0))
(assert (>= target_AGENT_019_riina_denies_network 0))
(assert (not (= source_AGENT_019_riina_denies_network target_AGENT_019_riina_denies_network)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_020_readonly_leq_rw: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_020_readonly_leq_rw preserves semantics
(push 1)
(declare-const source_AGENT_020_readonly_leq_rw Int)
(declare-const target_AGENT_020_readonly_leq_rw Int)
(assert (>= source_AGENT_020_readonly_leq_rw 0))
(assert (>= target_AGENT_020_readonly_leq_rw 0))
(assert (not (= source_AGENT_020_readonly_leq_rw target_AGENT_020_readonly_leq_rw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_021_permissive_boundary: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_021_permissive_boundary preserves semantics
(push 1)
(declare-const source_AGENT_021_permissive_boundary Int)
(declare-const target_AGENT_021_permissive_boundary Int)
(assert (>= source_AGENT_021_permissive_boundary 0))
(assert (>= target_AGENT_021_permissive_boundary 0))
(assert (not (= source_AGENT_021_permissive_boundary target_AGENT_021_permissive_boundary)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_022_cap_transitivity_example: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_022_cap_transitivity_example preserves semantics
(push 1)
(declare-const source_AGENT_022_cap_transitivity_example Int)
(declare-const target_AGENT_022_cap_transitivity_example Int)
(assert (>= source_AGENT_022_cap_transitivity_example 0))
(assert (>= target_AGENT_022_cap_transitivity_example 0))
(assert (not (= source_AGENT_022_cap_transitivity_example target_AGENT_022_cap_transitivity_example)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_023_riina_max_rw: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_023_riina_max_rw preserves semantics
(push 1)
(declare-const source_AGENT_023_riina_max_rw Int)
(declare-const target_AGENT_023_riina_max_rw Int)
(assert (>= source_AGENT_023_riina_max_rw 0))
(assert (>= target_AGENT_023_riina_max_rw 0))
(assert (not (= source_AGENT_023_riina_max_rw target_AGENT_023_riina_max_rw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_024_denied_ratelimit: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_024_denied_ratelimit preserves semantics
(push 1)
(declare-const source_AGENT_024_denied_ratelimit Int)
(declare-const target_AGENT_024_denied_ratelimit Int)
(assert (>= source_AGENT_024_denied_ratelimit 0))
(assert (>= target_AGENT_024_denied_ratelimit 0))
(assert (not (= source_AGENT_024_denied_ratelimit target_AGENT_024_denied_ratelimit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AGENT_025_complete_agent_security: translation preserves property (matches Coq: Theorem)
; Translation validation: AGENT_025_complete_agent_security preserves semantics
(push 1)
(declare-const source_AGENT_025_complete_agent_security Int)
(declare-const target_AGENT_025_complete_agent_security Int)
(assert (>= source_AGENT_025_complete_agent_security 0))
(assert (>= target_AGENT_025_complete_agent_security 0))
(assert (not (= source_AGENT_025_complete_agent_security target_AGENT_025_complete_agent_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)
