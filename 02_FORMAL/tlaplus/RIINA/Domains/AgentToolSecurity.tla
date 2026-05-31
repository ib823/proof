\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE AgentToolSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/AgentToolSecurity.v (26 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* CapLevel (matches Coq: Inductive CapLevel)
CONSTANTS ReadOnly, ReadWrite, Execute, Network, System

\* InvocationResult (matches Coq: Inductive InvocationResult)
CONSTANTS Permitted, DeniedLevel, DeniedNetwork, DeniedExecute, DeniedSystem, DeniedSandbox, DeniedValidation, DeniedSanitization, DeniedRateLimit

\* ToolCapability (matches Coq: Record ToolCapability)
VARIABLES tc_name, tc_level, tc_sandboxed, tc_input_validated, tc_output_sanitized, tc_rate_limited

\* AgentBoundary (matches Coq: Record AgentBoundary)
VARIABLES ab_max_level, ab_allow_network, ab_allow_execute, ab_allow_system, ab_require_sandbox, ab_require_validation, ab_require_sanitization, ab_require_rate_limit

\* ToolRequest (matches Coq: Record ToolRequest)
VARIABLES tr_tool, tr_input_hash, tr_caller_id, tr_timestamp

\* Type invariant
TypeOK ==
  /\ tc_name \in BOOLEAN
  /\ tc_level \in BOOLEAN
  /\ tc_sandboxed \in BOOLEAN
  /\ tc_input_validated \in BOOLEAN
  /\ tc_output_sanitized \in BOOLEAN
  /\ tc_rate_limited \in BOOLEAN
  /\ ab_max_level \in BOOLEAN
  /\ ab_allow_network \in BOOLEAN
  /\ ab_allow_execute \in BOOLEAN
  /\ ab_allow_system \in BOOLEAN
  /\ ab_require_sandbox \in BOOLEAN
  /\ ab_require_validation \in BOOLEAN
  /\ ab_require_sanitization \in BOOLEAN
  /\ ab_require_rate_limit \in BOOLEAN
  /\ tr_tool \in BOOLEAN
  /\ tr_input_hash \in BOOLEAN
  /\ tr_caller_id \in BOOLEAN
  /\ tr_timestamp \in BOOLEAN

\* Initial state
Init ==
  /\ tc_name = TRUE
  /\ tc_level = TRUE
  /\ tc_sandboxed = TRUE
  /\ tc_input_validated = TRUE
  /\ tc_output_sanitized = TRUE
  /\ tc_rate_limited = TRUE
  /\ ab_max_level = TRUE
  /\ ab_allow_network = TRUE
  /\ ab_allow_execute = TRUE
  /\ ab_allow_system = TRUE
  /\ ab_require_sandbox = TRUE
  /\ ab_require_validation = TRUE
  /\ ab_require_sanitization = TRUE
  /\ ab_require_rate_limit = TRUE
  /\ tr_tool = TRUE
  /\ tr_input_hash = TRUE
  /\ tr_caller_id = TRUE
  /\ tr_timestamp = TRUE

\* cap_level_leq (matches Coq: Definition cap_level_leq)
cap_level_leq(a, b) == TRUE

\* check_invocation (matches Coq: Definition check_invocation)
check_invocation(boundary, tool) == TRUE

\* is_permitted (matches Coq: Definition is_permitted)
is_permitted(r) == TRUE

\* riina_agent_boundary (matches Coq: Definition riina_agent_boundary)
riina_agent_boundary == TRUE

\* safe_readonly_tool (matches Coq: Definition safe_readonly_tool)
safe_readonly_tool == TRUE

\* safe_readwrite_tool (matches Coq: Definition safe_readwrite_tool)
safe_readwrite_tool == TRUE

\* unsafe_network_tool (matches Coq: Definition unsafe_network_tool)
unsafe_network_tool == TRUE

\* unsandboxed_tool (matches Coq: Definition unsandboxed_tool)
unsandboxed_tool == TRUE

\* unvalidated_tool (matches Coq: Definition unvalidated_tool)
unvalidated_tool == TRUE

\* AGENT_001_readonly_permitted (matches Coq: Theorem AGENT_001_readonly_permitted)
THEOREM AGENT_001_readonly_permitted == Init => TypeOK

\* AGENT_002_readwrite_permitted (matches Coq: Theorem AGENT_002_readwrite_permitted)
THEOREM AGENT_002_readwrite_permitted == Init => TypeOK

\* AGENT_003_network_denied (matches Coq: Theorem AGENT_003_network_denied)
THEOREM AGENT_003_network_denied == Init => TypeOK

\* AGENT_004_unsandboxed_denied (matches Coq: Theorem AGENT_004_unsandboxed_denied)
THEOREM AGENT_004_unsandboxed_denied == Init => TypeOK

\* AGENT_005_unvalidated_denied (matches Coq: Theorem AGENT_005_unvalidated_denied)
THEOREM AGENT_005_unvalidated_denied == Init => TypeOK

\* AGENT_006_cap_level_refl (matches Coq: Theorem AGENT_006_cap_level_refl)
THEOREM AGENT_006_cap_level_refl == Init => TypeOK

\* AGENT_007_readonly_min (matches Coq: Theorem AGENT_007_readonly_min)
THEOREM AGENT_007_readonly_min == Init => TypeOK

\* AGENT_008_system_max (matches Coq: Theorem AGENT_008_system_max)
THEOREM AGENT_008_system_max == Init => TypeOK

\* andb_true_iff_agent (matches Coq: Lemma andb_true_iff_agent)
THEOREM andb_true_iff_agent == Init => TypeOK

\* AGENT_009_network_exceeds_rw (matches Coq: Theorem AGENT_009_network_exceeds_rw)
THEOREM AGENT_009_network_exceeds_rw == Init => TypeOK

\* AGENT_010_execute_exceeds_rw (matches Coq: Theorem AGENT_010_execute_exceeds_rw)
THEOREM AGENT_010_execute_exceeds_rw == Init => TypeOK

\* AGENT_011_permitted_is_permitted (matches Coq: Theorem AGENT_011_permitted_is_permitted)
THEOREM AGENT_011_permitted_is_permitted == Init => TypeOK

\* AGENT_012_denied_level (matches Coq: Theorem AGENT_012_denied_level)
THEOREM AGENT_012_denied_level == Init => TypeOK

\* AGENT_013_denied_network (matches Coq: Theorem AGENT_013_denied_network)
THEOREM AGENT_013_denied_network == Init => TypeOK

\* AGENT_014_denied_sandbox (matches Coq: Theorem AGENT_014_denied_sandbox)
THEOREM AGENT_014_denied_sandbox == Init => TypeOK

\* AGENT_015_denied_validation (matches Coq: Theorem AGENT_015_denied_validation)
THEOREM AGENT_015_denied_validation == Init => TypeOK

\* AGENT_016_sandbox_enforcement (matches Coq: Theorem AGENT_016_sandbox_enforcement)
THEOREM AGENT_016_sandbox_enforcement == Init => TypeOK

\* AGENT_017_riina_denies_system (matches Coq: Theorem AGENT_017_riina_denies_system)
THEOREM AGENT_017_riina_denies_system == Init => TypeOK

\* AGENT_018_riina_denies_execute (matches Coq: Theorem AGENT_018_riina_denies_execute)
THEOREM AGENT_018_riina_denies_execute == Init => TypeOK

\* AGENT_019_riina_denies_network (matches Coq: Theorem AGENT_019_riina_denies_network)
THEOREM AGENT_019_riina_denies_network == Init => TypeOK

\* AGENT_020_readonly_leq_rw (matches Coq: Theorem AGENT_020_readonly_leq_rw)
THEOREM AGENT_020_readonly_leq_rw == Init => TypeOK

\* AGENT_021_permissive_boundary (matches Coq: Theorem AGENT_021_permissive_boundary)
THEOREM AGENT_021_permissive_boundary == Init => TypeOK

\* AGENT_022_cap_transitivity_example (matches Coq: Theorem AGENT_022_cap_transitivity_example)
THEOREM AGENT_022_cap_transitivity_example == Init => TypeOK

\* AGENT_023_riina_max_rw (matches Coq: Theorem AGENT_023_riina_max_rw)
THEOREM AGENT_023_riina_max_rw == Init => TypeOK

\* AGENT_024_denied_ratelimit (matches Coq: Theorem AGENT_024_denied_ratelimit)
THEOREM AGENT_024_denied_ratelimit == Init => TypeOK

\* AGENT_025_complete_agent_security (matches Coq: Theorem AGENT_025_complete_agent_security)
THEOREM AGENT_025_complete_agent_security == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<tc_name, tc_level, tc_sandboxed, tc_input_validated, tc_output_sanitized, tc_rate_limited, ab_max_level, ab_allow_network, ab_allow_execute, ab_allow_system, ab_require_sandbox, ab_require_validation, ab_require_sanitization, ab_require_rate_limit, tr_tool, tr_input_hash, tr_caller_id, tr_timestamp>>

\* Specification
Spec == Init /\ [][Next]_<<tc_name, tc_level, tc_sandboxed, tc_input_validated, tc_output_sanitized, tc_rate_limited, ab_max_level, ab_allow_network, ab_allow_execute, ab_allow_system, ab_require_sandbox, ab_require_validation, ab_require_sanitization, ab_require_rate_limit, tr_tool, tr_input_hash, tr_caller_id, tr_timestamp>>

====
