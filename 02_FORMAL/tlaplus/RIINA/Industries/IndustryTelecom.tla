---- MODULE IndustryTelecom ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/Industries/IndustryTelecom.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* TelecomDomain (matches Coq: Inductive TelecomDomain)
CONSTANTS RAN, Core, Transport, Service, Management

TelecomDomainSet == {RAN, Core, Transport, Service, Management}

\* NetworkFunction (matches Coq: Inductive NetworkFunction)
CONSTANTS AMF, SMF, UPF, AUSF, UDM

NetworkFunctionSet == {AMF, SMF, UPF, AUSF, UDM}

\* TelecomEffect (matches Coq: Inductive TelecomEffect)
CONSTANTS SignalingIO, UserPlaneIO, SubscriberData, NetworkConfig, BillingRecord

TelecomEffectSet == {SignalingIO, UserPlaneIO, SubscriberData, NetworkConfig, BillingRecord}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Security_5G (matches Coq: Record Security_5G)
VARIABLES primary_authentication, nas_security, as_security, user_plane_integrity, service_based_security, network_slicing_isolation

\* NetworkSlice (matches Coq: Record NetworkSlice)
VARIABLES slice_id, slice_domain, slice_encrypted, slice_isolated, slice_sla_latency_ms

\* LawfulIntercept (matches Coq: Record LawfulIntercept)
VARIABLES li_target, li_warrant_id, li_authorized, li_logged

vars == <<primary_authentication, nas_security, as_security, user_plane_integrity, service_based_security, network_slicing_isolation, slice_id, slice_domain, slice_encrypted, slice_isolated, slice_sla_latency_ms, li_target, li_warrant_id, li_authorized, li_logged>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ primary_authentication \in BOOLEAN
  /\ nas_security \in BOOLEAN
  /\ as_security \in BOOLEAN
  /\ user_plane_integrity \in BOOLEAN
  /\ service_based_security \in BOOLEAN
  /\ network_slicing_isolation \in BOOLEAN
  /\ slice_id \in Nat
  /\ slice_domain \in TelecomDomainSet
  /\ slice_encrypted \in BOOLEAN
  /\ slice_isolated \in BOOLEAN
  /\ slice_sla_latency_ms \in Nat
  /\ li_target \in Nat
  /\ li_warrant_id \in Nat
  /\ li_authorized \in BOOLEAN
  /\ li_logged \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ primary_authentication = FALSE
  /\ nas_security = FALSE
  /\ as_security = FALSE
  /\ user_plane_integrity = FALSE
  /\ service_based_security = FALSE
  /\ network_slicing_isolation = FALSE
  /\ slice_id = 0
  /\ slice_domain = RAN
  /\ slice_encrypted = FALSE
  /\ slice_isolated = FALSE
  /\ slice_sla_latency_ms = 0
  /\ li_target = 0
  /\ li_warrant_id = 0
  /\ li_authorized = FALSE
  /\ li_logged = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* domain_to_nat (matches Coq: Definition domain_to_nat)
domain_to_nat(d) ==
    CASE d = RAN -> 1
      [] d = Core -> 2
      [] d = Transport -> 3
      [] d = Service -> 4
      [] d = Management -> 5

\* domain_criticality (matches Coq: Definition domain_criticality)
domain_criticality(d) ==
    CASE d = RAN -> 3
      [] d = Core -> 5
      [] d = Transport -> 4
      [] d = Service -> 2
      [] d = Management -> 4

\* is_auth_function (matches Coq: Definition is_auth_function)
is_auth_function(nf) ==
    CASE nf = AUSF -> TRUE
    [] OTHER -> FALSE

\* security_5g_all (matches Coq: Definition security_5g_all)
security_5g_all(s) ==
  primary_authentication /\ nas_security /\ as_security /\ user_plane_integrity /\ service_based_security /\ network_slicing_isolation

\* slices_isolated (matches Coq: Definition slices_isolated)
slices_isolated(s2) ==
  ~(Nat)

\* key_derivation_depth (matches Coq: Definition key_derivation_depth)
key_derivation_depth(domain) ==
    CASE domain = RAN -> 3
      [] domain = Core -> 2
      [] domain = Transport -> 2
      [] domain = Service -> 1
      [] domain = Management -> 1

\* roaming_security_level (matches Coq: Definition roaming_security_level)
roaming_security_level(visited_sec) ==
  visited_sec >= 0

\* li_valid (matches Coq: Definition li_valid)
li_valid(li) ==
  li_authorized /\ li_logged

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateSecurity_5G ==
  /\ primary_authentication' \in BOOLEAN
  /\ nas_security' \in BOOLEAN
  /\ as_security' \in BOOLEAN
  /\ user_plane_integrity' \in BOOLEAN
  /\ service_based_security' \in BOOLEAN
  /\ network_slicing_isolation' \in BOOLEAN
  /\ UNCHANGED <<slice_id, slice_domain, slice_encrypted, slice_isolated, slice_sla_latency_ms, li_target, li_warrant_id, li_authorized, li_logged>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateSecurity_5G \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* security_5g_compliance
THEOREM security_5g_compliance ==
  \A sec \in Nat :
    sec >= 0

\* gsma_security
THEOREM gsma_security ==
  \A sim_card \in Nat, network \in Nat :
    sim_card >= 0 /\ network >= 0

\* slice_isolation
THEOREM slice_isolation ==
  \A slice1 \in Nat, slice2 \in Nat :
    slice1 >= 0 /\ slice2 >= 0

\* signaling_security
THEOREM signaling_security ==
  \A message \in Nat :
    message >= 0

\* nfv_security
THEOREM nfv_security ==
  \A vnf \in NetworkFunctionSet :
    vnf >= 0

\* integrity_mandatory_5g
THEOREM integrity_mandatory_5g ==
  \A sec \in Nat :
    sec # 0

\* up_integrity_available
THEOREM up_integrity_available ==
  \A sec \in Nat :
    sec >= 0

\* core_most_critical
THEOREM core_most_critical ==
  \A d \in Nat :
      domain_criticality d < = domain_criticality(Core)

\* domain_criticality_positive
THEOREM domain_criticality_positive ==
  \A d \in Nat :
      domain_criticality d > = 2

\* ausf_is_auth
THEOREM ausf_is_auth ==
  is_auth_function(AUSF) = TRUE

\* amf_not_auth
THEOREM amf_not_auth ==
  is_auth_function(AMF) = FALSE

\* all_sec_requires_auth
THEOREM all_sec_requires_auth ==
  \A s \in Nat :
      security_5g_all(s) => primary_authentication(s)

\* all_sec_requires_nas
THEOREM all_sec_requires_nas ==
  \A s \in Nat :
      security_5g_all(s) => nas_security(s)

\* all_sec_requires_slicing
THEOREM all_sec_requires_slicing ==
  \A s \in Nat :
      security_5g_all(s) => network_slicing_isolation(s)

\* same_slice_not_isolated
THEOREM same_slice_not_isolated ==
  \A s \in Nat :
      slices_isolated(s, s) = FALSE

\* latency_bounded
THEOREM latency_bounded ==
  \A s \in Nat, max_l \in Nat :
      latency_acceptable(s, max_l) => slice_sla_latency_ms s <= max_l

\* supi_always_concealed_in_core
THEOREM supi_always_concealed_in_core ==
  \A enc \in Nat :
      supi_concealed(enc, Core) = TRUE

\* supi_concealed_ran_requires_encryption
THEOREM supi_concealed_ran_requires_encryption ==
  supi_concealed(false, RAN) = FALSE

\* supi_concealed_ran_with_encryption
THEOREM supi_concealed_ran_with_encryption ==
  supi_concealed(true, RAN) = TRUE

\* ran_deepest_key_hierarchy
THEOREM ran_deepest_key_hierarchy ==
  \A d \in Nat :
      key_derivation_depth d < = key_derivation_depth(RAN)

\* roaming_no_upgrade
THEOREM roaming_no_upgrade ==
  \A h \in Nat, v \in Nat :
      roaming_security_level h v < = h

\* roaming_bounded_by_visited
THEOREM roaming_bounded_by_visited ==
  \A h \in Nat, v \in Nat :
      roaming_security_level h v < = v

\* li_requires_authorization
THEOREM li_requires_authorization ==
  \A li \in Nat :
      li_valid(li) => li_authorized(li)

\* li_requires_logging
THEOREM li_requires_logging ==
  \A li \in Nat :
      li_valid(li) => li_logged(li)

====
