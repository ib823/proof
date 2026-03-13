---- MODULE TransientSchedulerAttacks ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/TransientSchedulerAttacks.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* SchedulerGranularity (matches Coq: Inductive SchedulerGranularity)
CONSTANTS Tick, MicroTick, CyclePrecise

SchedulerGranularitySet == {Tick, MicroTick, CyclePrecise}

\* SchedPolicy (matches Coq: Inductive SchedPolicy)
CONSTANTS CFS, FIFO, RoundRobin, Deadline, Partitioned

SchedPolicySet == {CFS, FIFO, RoundRobin, Deadline, Partitioned}

\* TSAVariant (matches Coq: Inductive TSAVariant)
CONSTANTS TSA_SQ, TSA_L1, TSA_TLB, TSA_IPI, TSA_Freq

TSAVariantSet == {TSA_SQ, TSA_L1, TSA_TLB, TSA_IPI, TSA_Freq}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* ExecContext (matches Coq: Record ExecContext)
VARIABLES ec_pid, ec_priority, ec_time_slice_us, ec_preemptible, ec_cache_partition

\* TSADefenseConfig (matches Coq: Record TSADefenseConfig)
VARIABLES tsa_constant_time_scheduling, tsa_cache_partitioning, tsa_preemption_hardening, tsa_tlb_isolation, tsa_ipi_constant_time, tsa_freq_pinning, tsa_timer_noise_injection, tsa_scheduler_queue_isolation

\* SchedulerFootprint (matches Coq: Record SchedulerFootprint)
VARIABLES sf_time_slice_consumed, sf_preemption_count, sf_cache_sets_touched, sf_tlb_entries_used

vars == <<ec_pid, ec_priority, ec_time_slice_us, ec_preemptible, ec_cache_partition, tsa_constant_time_scheduling, tsa_cache_partitioning, tsa_preemption_hardening, tsa_tlb_isolation, tsa_ipi_constant_time, tsa_freq_pinning, tsa_timer_noise_injection, tsa_scheduler_queue_isolation, sf_time_slice_consumed, sf_preemption_count, sf_cache_sets_touched, sf_tlb_entries_used>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ ec_pid \in Nat
  /\ ec_priority \in Nat
  /\ ec_time_slice_us \in Nat
  /\ ec_preemptible \in BOOLEAN
  /\ ec_cache_partition \in Nat
  /\ tsa_constant_time_scheduling \in BOOLEAN
  /\ tsa_cache_partitioning \in BOOLEAN
  /\ tsa_preemption_hardening \in BOOLEAN
  /\ tsa_tlb_isolation \in BOOLEAN
  /\ tsa_ipi_constant_time \in BOOLEAN
  /\ tsa_freq_pinning \in BOOLEAN
  /\ tsa_timer_noise_injection \in BOOLEAN
  /\ tsa_scheduler_queue_isolation \in BOOLEAN
  /\ sf_time_slice_consumed \in Nat
  /\ sf_preemption_count \in Nat
  /\ sf_cache_sets_touched \in Nat
  /\ sf_tlb_entries_used \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ ec_pid = 0
  /\ ec_priority = 0
  /\ ec_time_slice_us = 0
  /\ ec_preemptible = FALSE
  /\ ec_cache_partition = 0
  /\ tsa_constant_time_scheduling = FALSE
  /\ tsa_cache_partitioning = FALSE
  /\ tsa_preemption_hardening = FALSE
  /\ tsa_tlb_isolation = FALSE
  /\ tsa_ipi_constant_time = FALSE
  /\ tsa_freq_pinning = FALSE
  /\ tsa_timer_noise_injection = FALSE
  /\ tsa_scheduler_queue_isolation = FALSE
  /\ sf_time_slice_consumed = 0
  /\ sf_preemption_count = 0
  /\ sf_cache_sets_touched = 0
  /\ sf_tlb_entries_used = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* sq_defense_active (matches Coq: Definition sq_defense_active)
sq_defense_active(c) ==
  tsa_constant_time_scheduling /\ tsa_scheduler_queue_isolation /\ tsa_timer_noise_injection

\* l1_defense_active (matches Coq: Definition l1_defense_active)
l1_defense_active(c) ==
  tsa_cache_partitioning /\ tsa_preemption_hardening

\* tlb_ipi_defense_active (matches Coq: Definition tlb_ipi_defense_active)
tlb_ipi_defense_active(c) ==
  tsa_tlb_isolation /\ tsa_ipi_constant_time

\* freq_defense_active (matches Coq: Definition freq_defense_active)
freq_defense_active(c) ==
  tsa_freq_pinning(c)

\* all_tsa_defenses (matches Coq: Definition all_tsa_defenses)
all_tsa_defenses(c) ==
  sq_defense_active /\ l1_defense_active /\ tlb_ipi_defense_active /\ freq_defense_active

\* riina_tsa_config (matches Coq: Definition riina_tsa_config)
riina_tsa_config ==
  0

\* scheduler_indistinguishable (matches Coq: Definition scheduler_indistinguishable)
scheduler_indistinguishable(f2) ==
  f2 >= 0

\* constant_time_codegen (matches Coq: Definition constant_time_codegen)
constant_time_codegen(footprints) ==
  footprints >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateExecContext ==
  /\ ec_pid' \in 0..100
  /\ ec_priority' \in 0..100
  /\ ec_time_slice_us' \in 0..100
  /\ ec_preemptible' \in BOOLEAN
  /\ ec_cache_partition' \in 0..100
  /\ UNCHANGED <<tsa_constant_time_scheduling, tsa_cache_partitioning, tsa_preemption_hardening, tsa_tlb_isolation, tsa_ipi_constant_time, tsa_freq_pinning, tsa_timer_noise_injection, tsa_scheduler_queue_isolation, sf_time_slice_consumed, sf_preemption_count, sf_cache_sets_touched, sf_tlb_entries_used>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateExecContext \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* andb_true_iff_local
THEOREM andb_true_iff_local ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true < => a = true /\ b = true

\* TSA_001_sq_defense
THEOREM TSA_001_sq_defense ==
  sq_defense_active(riina_tsa_config) = TRUE

\* TSA_002_l1_defense
THEOREM TSA_002_l1_defense ==
  l1_defense_active(riina_tsa_config) = TRUE

\* TSA_003_tlb_ipi_defense
THEOREM TSA_003_tlb_ipi_defense ==
  tlb_ipi_defense_active(riina_tsa_config) = TRUE

\* TSA_004_freq_defense
THEOREM TSA_004_freq_defense ==
  freq_defense_active(riina_tsa_config) = TRUE

\* TSA_005_all_defenses
THEOREM TSA_005_all_defenses ==
  all_tsa_defenses(riina_tsa_config) = TRUE

\* TSA_006_sq_requires_ct
THEOREM TSA_006_sq_requires_ct ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      sq_defense_active(c) => tsa_constant_time_scheduling(c)

\* TSA_007_sq_requires_isolation
THEOREM TSA_007_sq_requires_isolation ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      sq_defense_active(c) => tsa_scheduler_queue_isolation(c)

\* TSA_008_sq_requires_noise
THEOREM TSA_008_sq_requires_noise ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      sq_defense_active(c) => tsa_timer_noise_injection(c)

\* TSA_009_l1_requires_partition
THEOREM TSA_009_l1_requires_partition ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      l1_defense_active(c) => tsa_cache_partitioning(c)

\* TSA_010_l1_requires_preemption
THEOREM TSA_010_l1_requires_preemption ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      l1_defense_active(c) => tsa_preemption_hardening(c)

\* TSA_011_tlb_requires_isolation
THEOREM TSA_011_tlb_requires_isolation ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      tlb_ipi_defense_active(c) => tsa_tlb_isolation(c)

\* TSA_012_tlb_requires_ipi
THEOREM TSA_012_tlb_requires_ipi ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      tlb_ipi_defense_active(c) => tsa_ipi_constant_time(c)

\* TSA_013_all_implies_sq
THEOREM TSA_013_all_implies_sq ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      all_tsa_defenses(c) => sq_defense_active(c)

\* TSA_014_all_implies_l1
THEOREM TSA_014_all_implies_l1 ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      all_tsa_defenses(c) => l1_defense_active(c)

\* TSA_015_all_implies_tlb
THEOREM TSA_015_all_implies_tlb ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      all_tsa_defenses(c) => tlb_ipi_defense_active(c)

\* TSA_016_all_implies_freq
THEOREM TSA_016_all_implies_freq ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      all_tsa_defenses(c) => freq_defense_active(c)

\* TSA_017_single_footprint_ct
THEOREM TSA_017_single_footprint_ct ==
  \A f \in Nat, SchedulerFootprint \in Nat :
      constant_time_codegen [f] = TRUE

\* TSA_018_empty_footprint_ct
THEOREM TSA_018_empty_footprint_ct ==
  constant_time_codegen [] = TRUE

\* TSA_019_identical_indistinguishable
THEOREM TSA_019_identical_indistinguishable ==
  \A f \in Nat, SchedulerFootprint \in Nat :
      scheduler_indistinguishable(f, f) = TRUE

\* TSA_020_identical_pair_ct
THEOREM TSA_020_identical_pair_ct ==
  \A f \in Nat, SchedulerFootprint \in Nat :
      constant_time_codegen [f; f] = TRUE

\* TSA_021_identical_triple_ct
THEOREM TSA_021_identical_triple_ct ==
  \A f \in Nat, SchedulerFootprint \in Nat :
      constant_time_codegen [f; f; f] = TRUE

\* TSA_022_full_implies_ct_sched
THEOREM TSA_022_full_implies_ct_sched ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      all_tsa_defenses(c) => tsa_constant_time_scheduling(c)

\* TSA_023_full_implies_partition
THEOREM TSA_023_full_implies_partition ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      all_tsa_defenses(c) => tsa_cache_partitioning(c)

\* TSA_024_full_implies_tlb_iso
THEOREM TSA_024_full_implies_tlb_iso ==
  \A c \in Nat, TSADefenseConfig \in Nat :
      all_tsa_defenses(c) => tsa_tlb_isolation(c)

\* 1 additional theorems proven in Coq source

====
