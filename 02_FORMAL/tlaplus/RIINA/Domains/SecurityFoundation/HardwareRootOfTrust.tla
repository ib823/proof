---- MODULE HardwareRootOfTrust ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/HardwareRootOfTrust.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* HSMType (matches Coq: Inductive HSMType)
CONSTANTS TPM, SecureEnclave, TitanM, AppleSEP

HSMTypeSet == {TPM, SecureEnclave, TitanM, AppleSEP}

\* KeyId (matches Coq: Inductive KeyId)
CONSTANTS RootKey, AttestationKey, SealingKey, SigningKey

KeyIdSet == {RootKey, AttestationKey, SealingKey, SigningKey}

\* BootComponentId (matches Coq: Inductive BootComponentId)
CONSTANTS BootComp

BootComponentIdSet == {BootComp}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Measurement (matches Coq: Record Measurement)
VARIABLES measured_component, measurement_value, measurement_algorithm

\* TrustChainEntry (matches Coq: Record TrustChainEntry)
VARIABLES entry_component, entry_verified_by, entry_measurement, entry_trusted

\* HWRootState (matches Coq: Record HWRootState)
VARIABLES hsm_type, root_key_present, attestation_key_present, trust_chain, pcr_values, hardware_initialized

vars == <<measured_component, measurement_value, measurement_algorithm, entry_component, entry_verified_by, entry_measurement, entry_trusted, hsm_type, root_key_present, attestation_key_present, trust_chain, pcr_values, hardware_initialized>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ measured_component \in BootComponentIdSet
  /\ measurement_value \in Nat
  /\ measurement_algorithm \in Nat
  /\ entry_component \in BootComponentIdSet
  /\ entry_verified_by \in BootComponentIdSet
  /\ entry_measurement \in Nat
  /\ entry_trusted \in BOOLEAN
  /\ hsm_type \in HSMTypeSet
  /\ root_key_present \in BOOLEAN
  /\ attestation_key_present \in BOOLEAN
  /\ trust_chain \in Seq(Nat)
  /\ pcr_values \in Seq(Nat)
  /\ hardware_initialized \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ measured_component = BootComp
  /\ measurement_value = 0
  /\ measurement_algorithm = 0
  /\ entry_component = BootComp
  /\ entry_verified_by = BootComp
  /\ entry_measurement = 0
  /\ entry_trusted = FALSE
  /\ hsm_type = TPM
  /\ root_key_present = FALSE
  /\ attestation_key_present = FALSE
  /\ trust_chain = <<>>
  /\ pcr_values = <<>>
  /\ hardware_initialized = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* hw_root_component (matches Coq: Definition hw_root_component)
hw_root_component ==
  0

\* initial_hw_state (matches Coq: Definition initial_hw_state)
initial_hw_state(hsm) ==
  hsm >= 0

\* root_key_protected (matches Coq: Definition root_key_protected)
root_key_protected(st) ==
  root_key_present(st) /\ hardware_initialized(st)

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateMeasurement ==
  /\ measured_component' \in BootComponentIdSet
  /\ measurement_value' \in 0..100
  /\ measurement_algorithm' \in 0..100
  /\ UNCHANGED <<entry_component, entry_verified_by, entry_measurement, entry_trusted, hsm_type, root_key_present, attestation_key_present, trust_chain, pcr_values, hardware_initialized>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateMeasurement \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* root_of_trust_hardware
THEOREM root_of_trust_hardware ==
  \A hsm \in HSMTypeSet :
      let st : = initial_hw_state hsm in
      hw_root_verified st hw_root_component

\* trust_extension_preserves_root
THEOREM trust_extension_preserves_root ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      hw_root_verified(st, hw_root_component) => let st' := extend_trust_chain st verifier comp measurement in
      hw_root_verified st' hw_root_component

\* extended_component_trusted
THEOREM extended_component_trusted ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      in_trust_chain(st, verifier) => let st' := extend_trust_chain st verifier comp measurement in
      component_trusted st' comp

\* untrusted_cannot_extend
THEOREM untrusted_cannot_extend ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      in_trust_chain st verifier = false => extend_trust_chain st verifier comp measurement = st

\* root_key_is_protected
THEOREM root_key_is_protected ==
  \A hsm \in HSMTypeSet :
      let st : = initial_hw_state hsm in
      root_key_protected st

\* pcr_record_preserved
THEOREM pcr_record_preserved ==
  \A st \in Nat, comp \in BootComponentIdSet, value \in Nat, algo \in Nat :
      let st' : = record_pcr st comp value algo in
      In (mkMeasurement comp value algo) (pcr_values st')

\* hw_root_always_trusted
THEOREM hw_root_always_trusted ==
  \A hsm \in HSMTypeSet :
      component_trusted(initial_hw_state(hsm), hw_root_component)

\* attestation_key_present_initial
THEOREM attestation_key_present_initial ==
  \A hsm \in HSMTypeSet :
      attestation_key_present (initial_hw_state hsm) = TRUE

\* hardware_initialized_initial
THEOREM hardware_initialized_initial ==
  \A hsm \in HSMTypeSet :
      hardware_initialized (initial_hw_state hsm) = TRUE

\* trust_extension_preserves_attestation
THEOREM trust_extension_preserves_attestation ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      attestation_key_present(st) => attestation_key_present (extend_trust_chain st verifier comp measurement) = true

\* trust_extension_preserves_root_key
THEOREM trust_extension_preserves_root_key ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      root_key_present(st) => root_key_present (extend_trust_chain st verifier comp measurement) = true

\* trust_extension_preserves_init
THEOREM trust_extension_preserves_init ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      hardware_initialized(st) => hardware_initialized (extend_trust_chain st verifier comp measurement) = true

\* pcr_preserves_trust_chain
THEOREM pcr_preserves_trust_chain ==
  \A st \in Nat, comp \in BootComponentIdSet, value \in Nat, algo \in Nat :
      trust_chain (record_pcr st comp value algo) = trust_chain(st)

\* pcr_preserves_root_key
THEOREM pcr_preserves_root_key ==
  \A st \in Nat, comp \in BootComponentIdSet, value \in Nat, algo \in Nat :
      root_key_present (record_pcr st comp value algo) = root_key_present(st)

\* pcr_values_grow
THEOREM pcr_values_grow ==
  \A st \in Nat, comp \in BootComponentIdSet, value \in Nat, algo \in Nat, m \in Nat :
      In(m, pcr_values(st)) => In m (pcr_values (record_pcr st comp value algo))

\* trust_chain_grows
THEOREM trust_chain_grows ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat, entry \in Nat :
      in_trust_chain(st, verifier) => In entry (trust_chain (extend_trust_chain st verifier comp measurement))

\* extended_chain_has_component
THEOREM extended_chain_has_component ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      in_trust_chain(st, verifier) => In (mkTrustEntry comp verifier measurement true)
         (trust_chain (extend_trust_chain st verifier comp measurement))

\* hsm_type_invariant_extend
THEOREM hsm_type_invariant_extend ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      hsm_type (extend_trust_chain st verifier comp measurement) = hsm_type(st)

\* hsm_type_invariant_pcr
THEOREM hsm_type_invariant_pcr ==
  \A st \in Nat, comp \in BootComponentIdSet, value \in Nat, algo \in Nat :
      hsm_type (record_pcr st comp value algo) = hsm_type(st)

\* root_key_protection_preserved
THEOREM root_key_protection_preserved ==
  \A st \in Nat, verifier \in BootComponentIdSet, comp \in BootComponentIdSet, measurement \in Nat :
      root_key_protected(st) => root_key_protected (extend_trust_chain st verifier comp measurement)

\* root_key_protection_preserved_pcr
THEOREM root_key_protection_preserved_pcr ==
  \A st \in Nat, comp \in BootComponentIdSet, value \in Nat, algo \in Nat :
      root_key_protected(st) => root_key_protected (record_pcr st comp value algo)

====
