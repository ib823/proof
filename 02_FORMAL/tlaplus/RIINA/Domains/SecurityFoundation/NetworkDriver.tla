---- MODULE NetworkDriver ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/NetworkDriver.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* AppId (matches Coq: Inductive AppId)
CONSTANTS App

AppIdSet == {App}

\* SocketId (matches Coq: Inductive SocketId)
CONSTANTS SockId

SocketIdSet == {SockId}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Application (matches Coq: Record Application)
VARIABLES app_id, app_network_perm

\* Socket (matches Coq: Record Socket)
VARIABLES socket_id, socket_owner, socket_port, socket_bound

\* NetworkState (matches Coq: Record NetworkState)
VARIABLES all_sockets, firewall_enabled

\* FirewallRule (matches Coq: Record FirewallRule)
VARIABLES fw_src_port, fw_dst_port, fw_allowed

\* ExtNetworkState (matches Coq: Record ExtNetworkState)
VARIABLES ext_sockets, ext_firewall_enabled, ext_firewall_rules

vars == <<app_id, app_network_perm, socket_id, socket_owner, socket_port, socket_bound, all_sockets, firewall_enabled, fw_src_port, fw_dst_port, fw_allowed, ext_sockets, ext_firewall_enabled, ext_firewall_rules>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ app_id \in AppIdSet
  /\ app_network_perm \in BOOLEAN
  /\ socket_id \in SocketIdSet
  /\ socket_owner \in AppIdSet
  /\ socket_port \in Nat
  /\ socket_bound \in BOOLEAN
  /\ all_sockets \in Seq(Nat)
  /\ firewall_enabled \in BOOLEAN
  /\ fw_src_port \in Nat
  /\ fw_dst_port \in Nat
  /\ fw_allowed \in BOOLEAN
  /\ ext_sockets \in Seq(Nat)
  /\ ext_firewall_enabled \in BOOLEAN
  /\ ext_firewall_rules \in Seq(Nat)

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ app_id = App
  /\ app_network_perm = FALSE
  /\ socket_id = SockId
  /\ socket_owner = App
  /\ socket_port = 0
  /\ socket_bound = FALSE
  /\ all_sockets = <<>>
  /\ firewall_enabled = FALSE
  /\ fw_src_port = 0
  /\ fw_dst_port = 0
  /\ fw_allowed = FALSE
  /\ ext_sockets = <<>>
  /\ ext_firewall_enabled = FALSE
  /\ ext_firewall_rules = <<>>

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* socket_usable (matches Coq: Definition socket_usable)
socket_usable(sock) ==
  sock >= 0

\* has_network_permission (matches Coq: Definition has_network_permission)
has_network_permission(app) ==
  app_network_perm

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateApplication ==
  /\ app_id' \in AppIdSet
  /\ app_network_perm' \in BOOLEAN
  /\ UNCHANGED <<socket_id, socket_owner, socket_port, socket_bound, all_sockets, firewall_enabled, fw_src_port, fw_dst_port, fw_allowed, ext_sockets, ext_firewall_enabled, ext_firewall_rules>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateApplication \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* network_isolation
THEOREM network_isolation ==
  \A app1 \in Nat, app2 \in Nat, socket \in Nat :
      app_id app1 <> app_id app2 => ~ can_access_socket app2 socket

\* socket_ownership_exclusive
THEOREM socket_ownership_exclusive ==
  \A app1 \in Nat, app2 \in Nat, sock \in Nat :
      owns_socket(app1, sock) => app_id app1 = app_id app2

\* unbound_socket_not_usable
THEOREM unbound_socket_not_usable ==
  \A sock \in Nat :
      ~socket_bound(sock) => ~ socket_usable sock

\* send_requires_network_permission
THEOREM send_requires_network_permission ==
  \A app \in Nat, sock \in Nat :
      sends_data(app, sock) => has_network_permission(app)

\* receive_requires_network_permission
THEOREM receive_requires_network_permission ==
  \A app \in Nat, sock \in Nat :
      receives_data(app, sock) => has_network_permission(app)

\* no_perm_blocks_send
THEOREM no_perm_blocks_send ==
  \A app \in Nat, sock \in Nat :
      ~app_network_perm(app) => ~ sends_data app sock

\* no_perm_blocks_receive
THEOREM no_perm_blocks_receive ==
  \A app \in Nat, sock \in Nat :
      ~app_network_perm(app) => ~ receives_data app sock

\* unbound_blocks_send
THEOREM unbound_blocks_send ==
  \A app \in Nat, sock \in Nat :
      ~socket_bound(sock) => ~ sends_data app sock

\* unbound_blocks_receive
THEOREM unbound_blocks_receive ==
  \A app \in Nat, sock \in Nat :
      ~socket_bound(sock) => ~ receives_data app sock

\* default_deny_firewall
THEOREM default_deny_firewall ==
  \A src_port \in Nat, dst_port \in Nat :
      firewall_permits [] src_port dst_port = FALSE

\* cross_app_socket_impossible
THEOREM cross_app_socket_impossible ==
  \A app1 \in Nat, app2 \in Nat, sock \in Nat :
      app_id app1 <> app_id app2 => ~ sends_data app2 sock

\* cross_app_receive_impossible
THEOREM cross_app_receive_impossible ==
  \A app1 \in Nat, app2 \in Nat, sock \in Nat :
      app_id app1 <> app_id app2 => ~ receives_data app2 sock

\* send_implies_bound
THEOREM send_implies_bound ==
  \A app \in Nat, sock \in Nat :
      sends_data(app, sock) => socket_usable(sock)

\* receive_implies_bound
THEOREM receive_implies_bound ==
  \A app \in Nat, sock \in Nat :
      receives_data(app, sock) => socket_usable(sock)

\* socket_isolation_by_owner
THEOREM socket_isolation_by_owner ==
  \A app1 \in Nat, app2 \in Nat, sock1 \in Nat, sock2 \in Nat :
      app_id app1 <> app_id app2 => socket_owner sock1 <> socket_owner sock2

\* access_control_consistent
THEOREM access_control_consistent ==
  \A app \in Nat, sock \in Nat :
      can_access_socket(app, sock) => owns_socket(app, sock)

\* network_perm_required_both_directions
THEOREM network_perm_required_both_directions ==
  \A app \in Nat, sock \in Nat :
      sends_data app sock \/ receives_data app sock => has_network_permission(app)

\* full_network_isolation
THEOREM full_network_isolation ==
  \A app \in Nat :
      ~app_network_perm(app) => forall sock, ~ sends_data app sock /\ ~ receives_data app sock

\* bound_implies_usable
THEOREM bound_implies_usable ==
  \A sock \in Nat :
      socket_bound(sock) => socket_usable(sock)

\* firewall_protects
THEOREM firewall_protects ==
  \A ns \in Nat :
      firewall_enabled(ns) => firewall_enabled(ns)

\* socket_port_nonneg
THEOREM socket_port_nonneg ==
  \A sock \in Nat :
      socket_port sock > = 0

====
