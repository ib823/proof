---- MODULE IOMMUProtection ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/IOMMUProtection.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* DeviceId (matches Coq: Inductive DeviceId)
CONSTANTS DevId

DeviceIdSet == {DevId}

\* VMId (matches Coq: Inductive VMId)
CONSTANTS VM

VMIdSet == {VM}

\* Address (matches Coq: Inductive Address)
CONSTANTS Addr

AddressSet == {Addr}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Device (matches Coq: Record Device)
VARIABLES dev_id, dev_bus, dev_function

\* VirtualMachine (matches Coq: Record VirtualMachine)
VARIABLES vm_id, vm_dma_base, vm_dma_size

\* IOMMUConfig (matches Coq: Record IOMMUConfig)
VARIABLES config_device, config_allowed_base, config_allowed_size, config_locked

\* IOMMU (matches Coq: Record IOMMU)
VARIABLES iommu_id, iommu_configs, iommu_enabled

vars == <<dev_id, dev_bus, dev_function, vm_id, vm_dma_base, vm_dma_size, config_device, config_allowed_base, config_allowed_size, config_locked, iommu_id, iommu_configs, iommu_enabled>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ dev_id \in DeviceIdSet
  /\ dev_bus \in Nat
  /\ dev_function \in Nat
  /\ vm_id \in VMIdSet
  /\ vm_dma_base \in Nat
  /\ vm_dma_size \in Nat
  /\ config_device \in DeviceIdSet
  /\ config_allowed_base \in Nat
  /\ config_allowed_size \in Nat
  /\ config_locked \in BOOLEAN
  /\ iommu_id \in Nat
  /\ iommu_configs \in Seq(Nat)
  /\ iommu_enabled \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ dev_id = DevId
  /\ dev_bus = 0
  /\ dev_function = 0
  /\ vm_id = VM
  /\ vm_dma_base = 0
  /\ vm_dma_size = 0
  /\ config_device = DevId
  /\ config_allowed_base = 0
  /\ config_allowed_size = 0
  /\ config_locked = FALSE
  /\ iommu_id = 0
  /\ iommu_configs = <<>>
  /\ iommu_enabled = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* iommu_config (matches Coq: Definition iommu_config)
iommu_config(iommu) ==
  iommu >= 0

\* kernel_region_base (matches Coq: Definition kernel_region_base)
kernel_region_base ==
  0

\* kernel_region_size (matches Coq: Definition kernel_region_size)
kernel_region_size ==
  4096

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateDevice ==
  /\ dev_id' \in DeviceIdSet
  /\ dev_bus' \in 0..100
  /\ dev_function' \in 0..100
  /\ UNCHANGED <<vm_id, vm_dma_base, vm_dma_size, config_device, config_allowed_base, config_allowed_size, config_locked, iommu_id, iommu_configs, iommu_enabled>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateDevice \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* dma_isolation
THEOREM dma_isolation ==
  \A dev \in Nat, addr \in AddressSet, iommu \in Nat :
      ~ iommu_permits_dma iommu dev addr => ~ can_dma_access dev addr iommu

\* iommu_config_protected
THEOREM iommu_config_protected ==
  \A guest \in Nat, cfg \in Nat :
      ~ can_modify_config guest cfg

\* iommu_config_protected_v2
THEOREM iommu_config_protected_v2 ==
  \A guest \in Nat, iommu \in Nat :
      forall cfg, In cfg (iommu_config iommu) => ~ can_modify_config guest cfg

\* dma_requires_iommu_enabled
THEOREM dma_requires_iommu_enabled ==
  \A dev \in Nat, addr \in AddressSet, iommu \in Nat :
      ~iommu_enabled(iommu) => ~ iommu_permits_dma iommu dev addr

\* unconfigured_device_no_dma
THEOREM unconfigured_device_no_dma ==
  \A dev \in Nat, addr \in AddressSet, iommu \in Nat :
      find_device_config (dev_id dev) (iommu_configs iommu) = None => ~ iommu_permits_dma iommu dev addr

\* out_of_range_dma_blocked
THEOREM out_of_range_dma_blocked ==
  \A dev \in Nat, n \in Nat, iommu \in Nat, cfg \in Nat :
      find_device_config (dev_id dev) (iommu_configs iommu) = Some cfg => ~ iommu_permits_dma iommu dev (Addr n)

\* iommu_lockdown_effective
THEOREM iommu_lockdown_effective ==
  \A iommu \in Nat, guest \in Nat :
      guest_isolated_from_iommu(guest, iommu) => config_locked(cfg)

\* dma_isolation_enforced
THEOREM dma_isolation_enforced ==
  \A dev \in Nat, addr \in AddressSet, iommu \in Nat :
      can_dma_access dev addr iommu => iommu_enabled(iommu)

\* device_address_bounded
THEOREM device_address_bounded ==
  \A dev \in Nat, n \in Nat, iommu \in Nat, cfg \in Nat :
      iommu_permits_dma iommu dev (Addr n) => address_in_range(n, cfg)

\* mapping_table_consistent
THEOREM mapping_table_consistent ==
  \A dev \in DeviceIdSet, configs \in Nat, cfg1 \in Nat, cfg2 \in Nat :
      find_device_config dev configs = Some cfg1 => cfg1 = cfg2

\* no_dma_to_kernel
THEOREM no_dma_to_kernel ==
  \A dev \in Nat, addr \in Nat, iommu \in Nat, cfg \in Nat :
      find_device_config (dev_id dev) (iommu_configs iommu) = Some cfg => address_in_range addr cfg = false

\* iommu_bypass_impossible
THEOREM iommu_bypass_impossible ==
  \A dev \in Nat, addr \in AddressSet, iommu \in Nat :
      iommu_enabled(iommu) => ~ can_dma_access dev addr iommu

\* address_range_lower_bound
THEOREM address_range_lower_bound ==
  \A addr \in Nat, cfg \in Nat :
      address_in_range(addr, cfg) => config_allowed_base cfg <= addr

\* address_range_upper_bound
THEOREM address_range_upper_bound ==
  \A addr \in Nat, cfg \in Nat :
      address_in_range(addr, cfg) => addr < config_allowed_base cfg + config_allowed_size cfg

\* device_identity_verified
THEOREM device_identity_verified ==
  \A dev \in Nat, addr \in AddressSet, iommu \in Nat :
      can_dma_access dev addr iommu => exists cfg, find_device_config (dev_id dev) (iommu_configs iommu) = Some cfg

\* empty_config_denies_all
THEOREM empty_config_denies_all ==
  \A dev \in Nat, addr \in AddressSet :
      let iommu : = mkIOMMU 0 [] true in
      ~ can_dma_access dev addr iommu

\* disabled_iommu_denies_all
THEOREM disabled_iommu_denies_all ==
  \A dev \in Nat, addr \in AddressSet, iommu \in Nat :
      ~iommu_enabled(iommu) => ~ can_dma_access dev addr iommu

\* locked_config_invariant
THEOREM locked_config_invariant ==
  \A guest \in Nat, iommu \in Nat, cfg \in Nat :
      guest_isolated_from_iommu(guest, iommu) => config_locked(cfg)

\* zero_size_config_denies
THEOREM zero_size_config_denies ==
  \A addr \in Nat, cfg \in Nat :
      config_allowed_size cfg = 0 => address_in_range addr cfg = false

\* find_device_config_none_not_in
THEOREM find_device_config_none_not_in ==
  \A dev \in DeviceIdSet, configs \in Nat :
      find_device_config dev configs = None => config_device cfg <> dev

\* find_device_config_some_matches
THEOREM find_device_config_some_matches ==
  \A dev \in DeviceIdSet, configs \in Nat, cfg \in Nat :
      find_device_config dev configs = Some cfg => config_device cfg = dev

\* independent_device_configs
THEOREM independent_device_configs ==
  \A dev1 \in Nat, dev2 \in Nat, iommu \in Nat, cfg1 \in Nat, cfg2 \in Nat :
      dev_id dev1 <> dev_id dev2 => config_device cfg1 <> config_device cfg2

====
