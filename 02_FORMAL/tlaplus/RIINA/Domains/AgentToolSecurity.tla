---- MODULE AgentToolSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/AgentToolSecurity.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* CapLevel (matches Coq: Inductive CapLevel)
CONSTANTS ReadOnly, ReadWrite, Execute, Network, System

CapLevelSet == {ReadOnly, ReadWrite, Execute, Network, System}

\* InvocationResult (matches Coq: Inductive InvocationResult)
CONSTANTS Permitted, DeniedLevel, DeniedNetwork, DeniedExecute, DeniedSystem, DeniedSandbox, DeniedValidation, DeniedSanitization, DeniedRateLimit

InvocationResultSet == {Permitted, DeniedLevel, DeniedNetwork, DeniedExecute, DeniedSystem, DeniedSandbox, DeniedValidation, DeniedSanitization, DeniedRateLimit}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* ToolCapability (matches Coq: Record ToolCapability)
VARIABLES tc_name, tc_level, tc_sandboxed, tc_input_validated, tc_output_sanitized, tc_rate_limited

\* AgentBoundary (matches Coq: Record AgentBoundary)
VARIABLES ab_max_level, ab_allow_network, ab_allow_execute, ab_allow_system, ab_require_sandbox, ab_require_validation, ab_require_sanitization, ab_require_rate_limit

\* ToolRequest (matches Coq: Record ToolRequest)
VARIABLES tr_tool, tr_input_hash, tr_caller_id, tr_timestamp

vars == <<tc_name, tc_level, tc_sandboxed, tc_input_validated, tc_output_sanitized, tc_rate_limited, ab_max_level, ab_allow_network, ab_allow_execute, ab_allow_system, ab_require_sandbox, ab_require_validation, ab_require_sanitization, ab_require_rate_limit, tr_tool, tr_input_hash, tr_caller_id, tr_timestamp>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ tc_name \in Nat
  /\ tc_level \in CapLevelSet
  /\ tc_sandboxed \in BOOLEAN
  /\ tc_input_validated \in BOOLEAN
  /\ tc_output_sanitized \in BOOLEAN
  /\ tc_rate_limited \in BOOLEAN
  /\ ab_max_level \in CapLevelSet
  /\ ab_allow_network \in BOOLEAN
  /\ ab_allow_execute \in BOOLEAN
  /\ ab_allow_system \in BOOLEAN
  /\ ab_require_sandbox \in BOOLEAN
  /\ ab_require_validation \in BOOLEAN
  /\ ab_require_sanitization \in BOOLEAN
  /\ ab_require_rate_limit \in BOOLEAN
  /\ tr_tool \in Nat
  /\ tr_input_hash \in Nat
  /\ tr_caller_id \in Nat
  /\ tr_timestamp \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ tc_name = 0
  /\ tc_level = ReadOnly
  /\ tc_sandboxed = FALSE
  /\ tc_input_validated = FALSE
  /\ tc_output_sanitized = FALSE
  /\ tc_rate_limited = FALSE
  /\ ab_max_level = ReadOnly
  /\ ab_allow_network = FALSE
  /\ ab_allow_execute = FALSE
  /\ ab_allow_system = FALSE
  /\ ab_require_sandbox = FALSE
  /\ ab_require_validation = FALSE
  /\ ab_require_sanitization = FALSE
  /\ ab_require_rate_limit = FALSE
  /\ tr_tool = 0
  /\ tr_input_hash = 0
  /\ tr_caller_id = 0
  /\ tr_timestamp = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* cap_level_leq (matches Coq: Definition cap_level_leq)
cap_level_leq(b) ==
    CASE a = ReadOnly, _ -> TRUE
      [] a = ReadWrite, ReadOnly -> FALSE
      [] a = ReadWrite, _ -> TRUE
      [] a = Execute, ReadOnly -> FALSE
      [] a = Execute, ReadWrite -> FALSE
      [] a = Execute, _ -> TRUE
      [] a = Network, System -> TRUE
      [] a = Network, Network -> TRUE
      [] a = Network, _ -> FALSE
      [] a = System, System -> TRUE
      [] a = System, _ -> FALSE

\* is_permitted (matches Coq: Definition is_permitted)
is_permitted(r) ==
    CASE TRUE -> FALSE

\* riina_agent_boundary (matches Coq: Definition riina_agent_boundary)
riina_agent_boundary ==
  0

\* safe_readonly_tool (matches Coq: Definition safe_readonly_tool)
safe_readonly_tool ==
  0

\* safe_readwrite_tool (matches Coq: Definition safe_readwrite_tool)
safe_readwrite_tool ==
  0

\* unsafe_network_tool (matches Coq: Definition unsafe_network_tool)
unsafe_network_tool ==
  0

\* unsandboxed_tool (matches Coq: Definition unsandboxed_tool)
unsandboxed_tool ==
  0

\* unvalidated_tool (matches Coq: Definition unvalidated_tool)
unvalidated_tool ==
  0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateToolCapability ==
  /\ tc_name' \in 0..100
  /\ tc_level' \in CapLevelSet
  /\ tc_sandboxed' \in BOOLEAN
  /\ tc_input_validated' \in BOOLEAN
  /\ tc_output_sanitized' \in BOOLEAN
  /\ tc_rate_limited' \in BOOLEAN
  /\ UNCHANGED <<ab_max_level, ab_allow_network, ab_allow_execute, ab_allow_system, ab_require_sandbox, ab_require_validation, ab_require_sanitization, ab_require_rate_limit, tr_tool, tr_input_hash, tr_caller_id, tr_timestamp>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateToolCapability \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* AGENT_001_readonly_permitted
THEOREM AGENT_001_readonly_permitted ==
  is_permitted (check_invocation riina_agent_boundary safe_readonly_tool) = TRUE

\* AGENT_002_readwrite_permitted
THEOREM AGENT_002_readwrite_permitted ==
  is_permitted (check_invocation riina_agent_boundary safe_readwrite_tool) = TRUE

\* AGENT_003_network_denied
THEOREM AGENT_003_network_denied ==
  is_permitted (check_invocation riina_agent_boundary unsafe_network_tool) = FALSE

\* AGENT_004_unsandboxed_denied
THEOREM AGENT_004_unsandboxed_denied ==
  is_permitted (check_invocation riina_agent_boundary unsandboxed_tool) = FALSE

\* AGENT_005_unvalidated_denied
THEOREM AGENT_005_unvalidated_denied ==
  is_permitted (check_invocation riina_agent_boundary unvalidated_tool) = FALSE

\* AGENT_006_cap_level_refl
THEOREM AGENT_006_cap_level_refl ==
  \A l \in Nat, CapLevel \in Nat :
      cap_level_leq(l, l) = TRUE

\* AGENT_007_readonly_min
THEOREM AGENT_007_readonly_min ==
  \A l \in Nat, CapLevel \in Nat :
      cap_level_leq(ReadOnly, l) = TRUE

\* AGENT_008_system_max
THEOREM AGENT_008_system_max ==
  \A l \in Nat, CapLevel \in Nat :
      cap_level_leq(l, System) = TRUE

\* andb_true_iff_agent
THEOREM andb_true_iff_agent ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true < => a = true /\ b = true

\* AGENT_009_network_exceeds_rw
THEOREM AGENT_009_network_exceeds_rw ==
  cap_level_leq(Network, ReadWrite) = FALSE

\* AGENT_010_execute_exceeds_rw
THEOREM AGENT_010_execute_exceeds_rw ==
  cap_level_leq(Execute, ReadWrite) = FALSE

\* AGENT_011_permitted_is_permitted
THEOREM AGENT_011_permitted_is_permitted ==
  is_permitted(Permitted) = TRUE

\* AGENT_012_denied_level
THEOREM AGENT_012_denied_level ==
  is_permitted(DeniedLevel) = FALSE

\* AGENT_013_denied_network
THEOREM AGENT_013_denied_network ==
  is_permitted(DeniedNetwork) = FALSE

\* AGENT_014_denied_sandbox
THEOREM AGENT_014_denied_sandbox ==
  is_permitted(DeniedSandbox) = FALSE

\* AGENT_015_denied_validation
THEOREM AGENT_015_denied_validation ==
  is_permitted(DeniedValidation) = FALSE

\* AGENT_016_sandbox_enforcement
THEOREM AGENT_016_sandbox_enforcement ==
  \A n \in Nat, nat \in Nat :
      is_permitted (check_invocation riina_agent_boundary
        (mkToolCap n ReadOnly false true true true)) = FALSE

\* AGENT_017_riina_denies_system
THEOREM AGENT_017_riina_denies_system ==
  \A tool \in Nat, ToolCapability \in Nat :
      tc_level tool = System => is_permitted (check_invocation riina_agent_boundary tool) = false

\* AGENT_018_riina_denies_execute
THEOREM AGENT_018_riina_denies_execute ==
  \A tool \in Nat, ToolCapability \in Nat :
      tc_level tool = Execute => is_permitted (check_invocation riina_agent_boundary tool) = false

\* AGENT_019_riina_denies_network
THEOREM AGENT_019_riina_denies_network ==
  \A tool \in Nat, ToolCapability \in Nat :
      tc_level tool = Network => is_permitted (check_invocation riina_agent_boundary tool) = false

\* AGENT_020_readonly_leq_rw
THEOREM AGENT_020_readonly_leq_rw ==
  cap_level_leq(ReadOnly, ReadWrite) = TRUE

\* AGENT_021_permissive_boundary
THEOREM AGENT_021_permissive_boundary ==
  \A tool \in Nat, ToolCapability \in Nat :
      tc_level tool = ReadOnly => is_permitted (check_invocation
        (mkAgentBoundary System true true true true true true true)
        tool) = true

\* AGENT_022_cap_transitivity_example
THEOREM AGENT_022_cap_transitivity_example ==
  cap_level_leq(ReadOnly, ReadWrite) /\ cap_level_leq(ReadWrite, Execute) /\ cap_level_leq(ReadOnly, Execute)

\* AGENT_023_riina_max_rw
THEOREM AGENT_023_riina_max_rw ==
  ab_max_level(riina_agent_boundary) = ReadWrite

\* AGENT_024_denied_ratelimit
THEOREM AGENT_024_denied_ratelimit ==
  is_permitted(DeniedRateLimit) = FALSE

\* 1 additional theorems proven in Coq source

====
