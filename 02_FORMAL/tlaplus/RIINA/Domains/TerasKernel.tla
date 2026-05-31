\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE TerasKernel ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/TerasKernel.v (56 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* SyscallConfig (matches Coq: Record SyscallConfig)
VARIABLES tk_input_validated, tk_privilege_checked, tk_resource_bounded, tk_return_code_defined, tk_audit_logged, tk_idempotent

\* IPCConfig (matches Coq: Record IPCConfig)
VARIABLES tk_message_delivered, tk_message_ordered, tk_no_message_loss, tk_bounded_latency, tk_sender_authenticated, tk_typed_payload

\* MemoryMapConfig (matches Coq: Record MemoryMapConfig)
VARIABLES tk_page_aligned, tk_permission_enforced, tk_no_writable_executable, tk_kernel_space_protected, tk_mapping_audited

\* Type invariant
TypeOK ==
  /\ tk_input_validated \in BOOLEAN
  /\ tk_privilege_checked \in BOOLEAN
  /\ tk_resource_bounded \in BOOLEAN
  /\ tk_return_code_defined \in BOOLEAN
  /\ tk_audit_logged \in BOOLEAN
  /\ tk_idempotent \in BOOLEAN
  /\ tk_message_delivered \in BOOLEAN
  /\ tk_message_ordered \in BOOLEAN
  /\ tk_no_message_loss \in BOOLEAN
  /\ tk_bounded_latency \in BOOLEAN
  /\ tk_sender_authenticated \in BOOLEAN
  /\ tk_typed_payload \in BOOLEAN
  /\ tk_page_aligned \in BOOLEAN
  /\ tk_permission_enforced \in BOOLEAN
  /\ tk_no_writable_executable \in BOOLEAN
  /\ tk_kernel_space_protected \in BOOLEAN
  /\ tk_mapping_audited \in BOOLEAN

\* Initial state
Init ==
  /\ tk_input_validated = TRUE
  /\ tk_privilege_checked = TRUE
  /\ tk_resource_bounded = TRUE
  /\ tk_return_code_defined = TRUE
  /\ tk_audit_logged = TRUE
  /\ tk_idempotent = TRUE
  /\ tk_message_delivered = TRUE
  /\ tk_message_ordered = TRUE
  /\ tk_no_message_loss = TRUE
  /\ tk_bounded_latency = TRUE
  /\ tk_sender_authenticated = TRUE
  /\ tk_typed_payload = TRUE
  /\ tk_page_aligned = TRUE
  /\ tk_permission_enforced = TRUE
  /\ tk_no_writable_executable = TRUE
  /\ tk_kernel_space_protected = TRUE
  /\ tk_mapping_audited = TRUE

\* syscall_safe (matches Coq: Definition syscall_safe)
syscall_safe(c) == TRUE

\* riina_syscall (matches Coq: Definition riina_syscall)
riina_syscall == TRUE

\* bad_syscall (matches Coq: Definition bad_syscall)
bad_syscall == TRUE

\* ipc_safe (matches Coq: Definition ipc_safe)
ipc_safe(c) == TRUE

\* riina_ipc (matches Coq: Definition riina_ipc)
riina_ipc == TRUE

\* bad_ipc (matches Coq: Definition bad_ipc)
bad_ipc == TRUE

\* memory_map_safe (matches Coq: Definition memory_map_safe)
memory_map_safe(c) == TRUE

\* riina_memory_map (matches Coq: Definition riina_memory_map)
riina_memory_map == TRUE

\* bad_memory_map (matches Coq: Definition bad_memory_map)
bad_memory_map == TRUE

\* no_audit_memory_map (matches Coq: Definition no_audit_memory_map)
no_audit_memory_map == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* TK_001 (matches Coq: Theorem TK_001)
THEOREM TK_001 == Init => TypeOK

\* TK_002 (matches Coq: Theorem TK_002)
THEOREM TK_002 == Init => TypeOK

\* TK_003 (matches Coq: Theorem TK_003)
THEOREM TK_003 == Init => TypeOK

\* TK_004 (matches Coq: Theorem TK_004)
THEOREM TK_004 == Init => TypeOK

\* TK_005 (matches Coq: Theorem TK_005)
THEOREM TK_005 == Init => TypeOK

\* TK_006 (matches Coq: Theorem TK_006)
THEOREM TK_006 == Init => TypeOK

\* TK_007 (matches Coq: Theorem TK_007)
THEOREM TK_007 == Init => TypeOK

\* TK_008 (matches Coq: Theorem TK_008)
THEOREM TK_008 == Init => TypeOK

\* TK_009 (matches Coq: Theorem TK_009)
THEOREM TK_009 == Init => TypeOK

\* TK_010 (matches Coq: Theorem TK_010)
THEOREM TK_010 == Init => TypeOK

\* TK_011 (matches Coq: Theorem TK_011)
THEOREM TK_011 == Init => TypeOK

\* TK_012 (matches Coq: Theorem TK_012)
THEOREM TK_012 == Init => TypeOK

\* TK_013 (matches Coq: Theorem TK_013)
THEOREM TK_013 == Init => TypeOK

\* TK_014 (matches Coq: Theorem TK_014)
THEOREM TK_014 == Init => TypeOK

\* TK_015 (matches Coq: Theorem TK_015)
THEOREM TK_015 == Init => TypeOK

\* TK_016 (matches Coq: Theorem TK_016)
THEOREM TK_016 == Init => TypeOK

\* TK_017 (matches Coq: Theorem TK_017)
THEOREM TK_017 == Init => TypeOK

\* TK_018 (matches Coq: Theorem TK_018)
THEOREM TK_018 == Init => TypeOK

\* TK_019 (matches Coq: Theorem TK_019)
THEOREM TK_019 == Init => TypeOK

\* TK_020 (matches Coq: Theorem TK_020)
THEOREM TK_020 == Init => TypeOK

\* TK_021 (matches Coq: Theorem TK_021)
THEOREM TK_021 == Init => TypeOK

\* TK_022 (matches Coq: Theorem TK_022)
THEOREM TK_022 == Init => TypeOK

\* TK_023 (matches Coq: Theorem TK_023)
THEOREM TK_023 == Init => TypeOK

\* TK_024 (matches Coq: Theorem TK_024)
THEOREM TK_024 == Init => TypeOK

\* TK_025 (matches Coq: Theorem TK_025)
THEOREM TK_025 == Init => TypeOK

\* TK_026 (matches Coq: Theorem TK_026)
THEOREM TK_026 == Init => TypeOK

\* TK_027 (matches Coq: Theorem TK_027)
THEOREM TK_027 == Init => TypeOK

\* TK_028 (matches Coq: Theorem TK_028)
THEOREM TK_028 == Init => TypeOK

\* TK_029 (matches Coq: Theorem TK_029)
THEOREM TK_029 == Init => TypeOK

\* TK_030 (matches Coq: Theorem TK_030)
THEOREM TK_030 == Init => TypeOK

\* TK_031 (matches Coq: Theorem TK_031)
THEOREM TK_031 == Init => TypeOK

\* TK_032 (matches Coq: Theorem TK_032)
THEOREM TK_032 == Init => TypeOK

\* TK_033 (matches Coq: Theorem TK_033)
THEOREM TK_033 == Init => TypeOK

\* TK_034 (matches Coq: Theorem TK_034)
THEOREM TK_034 == Init => TypeOK

\* TK_035 (matches Coq: Theorem TK_035)
THEOREM TK_035 == Init => TypeOK

\* TK_036 (matches Coq: Theorem TK_036)
THEOREM TK_036 == Init => TypeOK

\* TK_037 (matches Coq: Theorem TK_037)
THEOREM TK_037 == Init => TypeOK

\* TK_038 (matches Coq: Theorem TK_038)
THEOREM TK_038 == Init => TypeOK

\* TK_039 (matches Coq: Theorem TK_039)
THEOREM TK_039 == Init => TypeOK

\* TK_040 (matches Coq: Theorem TK_040)
THEOREM TK_040 == Init => TypeOK

\* TK_041 (matches Coq: Theorem TK_041)
THEOREM TK_041 == Init => TypeOK

\* TK_042 (matches Coq: Theorem TK_042)
THEOREM TK_042 == Init => TypeOK

\* TK_043 (matches Coq: Theorem TK_043)
THEOREM TK_043 == Init => TypeOK

\* TK_044 (matches Coq: Theorem TK_044)
THEOREM TK_044 == Init => TypeOK

\* TK_045 (matches Coq: Theorem TK_045)
THEOREM TK_045 == Init => TypeOK

\* TK_046 (matches Coq: Theorem TK_046)
THEOREM TK_046 == Init => TypeOK

\* TK_047 (matches Coq: Theorem TK_047)
THEOREM TK_047 == Init => TypeOK

\* TK_048 (matches Coq: Theorem TK_048)
THEOREM TK_048 == Init => TypeOK

\* TK_049 (matches Coq: Theorem TK_049)
THEOREM TK_049 == Init => TypeOK

\* TK_050 (matches Coq: Theorem TK_050)
THEOREM TK_050 == Init => TypeOK

\* TK_051 (matches Coq: Theorem TK_051)
THEOREM TK_051 == Init => TypeOK

\* TK_052 (matches Coq: Theorem TK_052)
THEOREM TK_052 == Init => TypeOK

\* TK_053 (matches Coq: Theorem TK_053)
THEOREM TK_053 == Init => TypeOK

\* TK_054 (matches Coq: Theorem TK_054)
THEOREM TK_054 == Init => TypeOK

\* TK_055 (matches Coq: Theorem TK_055)
THEOREM TK_055 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<tk_input_validated, tk_privilege_checked, tk_resource_bounded, tk_return_code_defined, tk_audit_logged, tk_idempotent, tk_message_delivered, tk_message_ordered, tk_no_message_loss, tk_bounded_latency, tk_sender_authenticated, tk_typed_payload, tk_page_aligned, tk_permission_enforced, tk_no_writable_executable, tk_kernel_space_protected, tk_mapping_audited>>

\* Specification
Spec == Init /\ [][Next]_<<tk_input_validated, tk_privilege_checked, tk_resource_bounded, tk_return_code_defined, tk_audit_logged, tk_idempotent, tk_message_delivered, tk_message_ordered, tk_no_message_loss, tk_bounded_latency, tk_sender_authenticated, tk_typed_payload, tk_page_aligned, tk_permission_enforced, tk_no_writable_executable, tk_kernel_space_protected, tk_mapping_audited>>

====
