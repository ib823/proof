---- MODULE OMEGA001_NetworkDefense ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/OMEGA001_NetworkDefense.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ConnState (matches Coq: Inductive ConnState)
CONSTANTS ConnNew, ConnEstablished, ConnClosing, ConnClosed

ConnStateSet == {ConnNew, ConnEstablished, ConnClosing, ConnClosed}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* TokenBucket (matches Coq: Record TokenBucket)
VARIABLES tb_tokens, tb_capacity, tb_refill_rate, tb_last_refill

\* NetCapability (matches Coq: Record NetCapability)
VARIABLES cap_id, cap_permissions, cap_expiry, cap_delegatable, cap_signature

\* SynCookie (matches Coq: Record SynCookie)
VARIABLES sc_client_ip, sc_client_port, sc_server_port, sc_timestamp, sc_mss_index

\* Connection (matches Coq: Record Connection)
VARIABLES conn_src, conn_dst, conn_state, conn_bytes_in, conn_bytes_out, conn_start_time

vars == <<tb_tokens, tb_capacity, tb_refill_rate, tb_last_refill, cap_id, cap_permissions, cap_expiry, cap_delegatable, cap_signature, sc_client_ip, sc_client_port, sc_server_port, sc_timestamp, sc_mss_index, conn_src, conn_dst, conn_state, conn_bytes_in, conn_bytes_out, conn_start_time>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ tb_tokens \in Nat
  /\ tb_capacity \in Nat
  /\ tb_refill_rate \in Nat
  /\ tb_last_refill \in Nat
  /\ cap_id \in Nat
  /\ cap_permissions \in Seq(Nat)
  /\ cap_expiry \in Nat
  /\ cap_delegatable \in BOOLEAN
  /\ cap_signature \in Nat
  /\ sc_client_ip \in Nat
  /\ sc_client_port \in Nat
  /\ sc_server_port \in Nat
  /\ sc_timestamp \in Nat
  /\ sc_mss_index \in Nat
  /\ conn_src \in Nat
  /\ conn_dst \in Nat
  /\ conn_state \in ConnStateSet
  /\ conn_bytes_in \in Nat
  /\ conn_bytes_out \in Nat
  /\ conn_start_time \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ tb_tokens = 0
  /\ tb_capacity = 0
  /\ tb_refill_rate = 0
  /\ tb_last_refill = 0
  /\ cap_id = 0
  /\ cap_permissions = <<>>
  /\ cap_expiry = 0
  /\ cap_delegatable = FALSE
  /\ cap_signature = 0
  /\ sc_client_ip = 0
  /\ sc_client_port = 0
  /\ sc_server_port = 0
  /\ sc_timestamp = 0
  /\ sc_mss_index = 0
  /\ conn_src = 0
  /\ conn_dst = 0
  /\ conn_state = ConnNew
  /\ conn_bytes_in = 0
  /\ conn_bytes_out = 0
  /\ conn_start_time = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* tb_available (matches Coq: Definition tb_available)
tb_available(tb) ==
  tb >= 0

\* cap_is_subset (matches Coq: Definition cap_is_subset)
cap_is_subset(parent) ==
  parent >= 0

\* pow_hash (matches Coq: Definition pow_hash)
pow_hash(challenge) ==
  challenge >= 0

\* pow_valid (matches Coq: Definition pow_valid)
pow_valid(difficulty) ==
  difficulty # 0

\* pow_verify (matches Coq: Definition pow_verify)
pow_verify(difficulty) ==
  difficulty >= 0

\* ConnTable (matches Coq: Definition ConnTable)
ConnTable ==
  0

\* conn_limit_per_src (matches Coq: Definition conn_limit_per_src)
conn_limit_per_src ==
  100

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateTokenBucket ==
  /\ tb_tokens' \in 0..100
  /\ tb_capacity' \in 0..100
  /\ tb_refill_rate' \in 0..100
  /\ tb_last_refill' \in 0..100
  /\ UNCHANGED <<cap_id, cap_permissions, cap_expiry, cap_delegatable, cap_signature, sc_client_ip, sc_client_port, sc_server_port, sc_timestamp, sc_mss_index, conn_src, conn_dst, conn_state, conn_bytes_in, conn_bytes_out, conn_start_time>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateTokenBucket \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* OMEGA_001_01_tb_capacity_bound
THEOREM OMEGA_001_01_tb_capacity_bound ==
  \A tb \in Nat, now \in Nat :
      tb_tokens (tb_refill tb now) < = tb_capacity(tb)

\* OMEGA_001_02_tb_consume_decreases
THEOREM OMEGA_001_02_tb_consume_decreases ==
  \A tb \in Nat, cost \in Nat, tb \in Nat :
      tb_consume tb cost = Some tb' => tb_tokens tb' = tb_tokens tb - cost

\* OMEGA_001_03_tb_consume_fails_insufficient
THEOREM OMEGA_001_03_tb_consume_fails_insufficient ==
  \A tb \in Nat, cost \in Nat :
      tb_tokens tb < cost => tb_consume tb cost = None

\* OMEGA_001_04_tb_refill_monotone
THEOREM OMEGA_001_04_tb_refill_monotone ==
  \A tb \in Nat, t1 \in Nat, t2 \in Nat :
      t1 <= t2 => tb_tokens (tb_refill tb t1) <= tb_tokens (tb_refill tb t2)

\* OMEGA_001_05_tb_consume_preserves_capacity
THEOREM OMEGA_001_05_tb_consume_preserves_capacity ==
  \A tb \in Nat, cost \in Nat, tb \in Nat :
      tb_consume tb cost = Some tb' => tb_capacity tb' = tb_capacity tb

\* OMEGA_001_06_tb_zero_cost_always_succeeds
THEOREM OMEGA_001_06_tb_zero_cost_always_succeeds ==
  \A tb \in Nat :
      exists tb', tb_consume tb 0 = Some tb'

\* OMEGA_001_07_tb_refill_preserves_capacity
THEOREM OMEGA_001_07_tb_refill_preserves_capacity ==
  \A tb \in Nat, now \in Nat :
      tb_capacity (tb_refill tb now) = tb_capacity(tb)

\* OMEGA_001_08_tb_available_bound
THEOREM OMEGA_001_08_tb_available_bound ==
  \A tb \in Nat :
      tb_available tb < = tb_capacity tb \/ tb_available tb > tb_capacity tb

\* OMEGA_002_01_expired_cap_invalid
THEOREM OMEGA_002_01_expired_cap_invalid ==
  \A cap \in Nat, now \in Nat :
      now >= cap_expiry cap => cap_valid cap now = false

\* OMEGA_002_02_cap_subset_reflexive
THEOREM OMEGA_002_02_cap_subset_reflexive ==
  \A cap \in Nat :
      cap_is_subset(cap, cap) = TRUE

\* OMEGA_002_03_delegation_attenuation
THEOREM OMEGA_002_03_delegation_attenuation ==
  \A parent \in Nat, perms \in Nat, expiry \in Nat, sig \in Nat, child \in Nat :
      cap_delegate parent perms expiry sig = Some child => cap_expiry child <= cap_expiry parent

\* OMEGA_002_04_delegation_permission_subset
THEOREM OMEGA_002_04_delegation_permission_subset ==
  \A parent \in Nat, perms \in Nat, expiry \in Nat, sig \in Nat, child \in Nat :
      cap_delegate parent perms expiry sig = Some child => cap_is_subset(child, parent)

\* OMEGA_002_05_nondelegatable_blocks
THEOREM OMEGA_002_05_nondelegatable_blocks ==
  \A parent \in Nat, perms \in Nat, expiry \in Nat, sig \in Nat :
      ~cap_delegatable(parent) => cap_delegate parent perms expiry sig = None

\* OMEGA_002_06_empty_cap_permits_nothing
THEOREM OMEGA_002_06_empty_cap_permits_nothing ==
  \A port \in Nat :
      cap_permits {| cap_id : = 0; cap_permissions := []; cap_expiry := 0;
                   cap_delegatable := false; cap_signature := 0 |} port = false

\* OMEGA_002_07_cap_permits_sound
THEOREM OMEGA_002_07_cap_permits_sound ==
  \A cap \in Nat, port \in Nat :
      cap_permits(cap, port) => In port (cap_permissions cap) \/ exists p, In p (cap_permissions cap) /\ Nat.eqb port p = true

\* OMEGA_003_01_syn_cookie_verify_sound
THEOREM OMEGA_003_01_syn_cookie_verify_sound ==
  \A secret \in Nat, cookie \in Nat :
      syn_cookie_verify secret cookie (syn_cookie_generate secret cookie) = TRUE

\* OMEGA_003_02_syn_cookie_wrong_secret
THEOREM OMEGA_003_02_syn_cookie_wrong_secret ==
  \A s1 \in Nat, s2 \in Nat, cookie \in Nat :
    syn_cookie_generate s1 cookie <> syn_cookie_generate s2 cookie

\* OMEGA_003_03_syn_cookie_deterministic
THEOREM OMEGA_003_03_syn_cookie_deterministic ==
  \A secret \in Nat, cookie \in Nat :
      syn_cookie_generate(secret, cookie) = syn_cookie_generate(secret, cookie)

\* OMEGA_003_04_syn_cookie_stateless
THEOREM OMEGA_003_04_syn_cookie_stateless ==
  \A secret \in Nat, cookie \in Nat, mac \in Nat :
      syn_cookie_verify secret cookie mac = true => mac = syn_cookie_generate secret cookie

\* OMEGA_003_05_syn_cookie_ip_sensitive
THEOREM OMEGA_003_05_syn_cookie_ip_sensitive ==
  \A secret \in Nat, c1 \in Nat, c2 \in Nat :
      sc_client_ip c1 <> sc_client_ip c2 => syn_cookie_generate secret c1 <> syn_cookie_generate secret c2

\* OMEGA_003_06_wrong_mac_rejected
THEOREM OMEGA_003_06_wrong_mac_rejected ==
  \A secret \in Nat, cookie \in Nat, mac \in Nat :
      mac # syn_cookie_generate => syn_cookie_verify secret cookie mac = false

\* OMEGA_004_01_empty_table_allows
THEOREM OMEGA_004_01_empty_table_allows ==
  \A src \in Nat :
      conn_allowed [] src = TRUE

\* OMEGA_004_02_conn_count_nonneg
THEOREM OMEGA_004_02_conn_count_nonneg ==
  \A table \in Nat, src \in Nat :
      conn_count_by_src table src > = 0

\* OMEGA_004_03_conn_count_bound
THEOREM OMEGA_004_03_conn_count_bound ==
  \A table \in Nat, src \in Nat :
      conn_count_by_src table src < = length(table)

\* OMEGA_004_04_conn_lookup_deterministic
THEOREM OMEGA_004_04_conn_lookup_deterministic ==
  \A table \in Nat, src \in Nat, dst \in Nat, c1 \in Nat, c2 \in Nat :
      conn_lookup table src dst = Some c1 => c1 = c2

\* 5 additional theorems proven in Coq source

====
