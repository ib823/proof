\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE TransientSchedulerAttacks ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/TransientSchedulerAttacks.v (26 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* SchedulerGranularity (matches Coq: Inductive SchedulerGranularity)
CONSTANTS Tick, MicroTick, CyclePrecise

\* SchedPolicy (matches Coq: Inductive SchedPolicy)
CONSTANTS CFS, FIFO, RoundRobin, Deadline, Partitioned

\* TSAVariant (matches Coq: Inductive TSAVariant)
CONSTANTS TSA_SQ, TSA_L1, TSA_TLB, TSA_IPI, TSA_Freq

\* ExecContext (matches Coq: Record ExecContext)
VARIABLES ec_pid, ec_priority, ec_time_slice_us, ec_preemptible, ec_cache_partition

\* TSADefenseConfig (matches Coq: Record TSADefenseConfig)
VARIABLES tsa_constant_time_scheduling, tsa_cache_partitioning, tsa_preemption_hardening, tsa_tlb_isolation, tsa_ipi_constant_time, tsa_freq_pinning, tsa_timer_noise_injection, tsa_scheduler_queue_isolation

\* SchedulerFootprint (matches Coq: Record SchedulerFootprint)
VARIABLES sf_time_slice_consumed, sf_preemption_count, sf_cache_sets_touched, sf_tlb_entries_used

\* Type invariant
TypeOK ==
  /\ ec_pid \in BOOLEAN
  /\ ec_priority \in BOOLEAN
  /\ ec_time_slice_us \in BOOLEAN
  /\ ec_preemptible \in BOOLEAN
  /\ ec_cache_partition \in BOOLEAN
  /\ tsa_constant_time_scheduling \in BOOLEAN
  /\ tsa_cache_partitioning \in BOOLEAN
  /\ tsa_preemption_hardening \in BOOLEAN
  /\ tsa_tlb_isolation \in BOOLEAN
  /\ tsa_ipi_constant_time \in BOOLEAN
  /\ tsa_freq_pinning \in BOOLEAN
  /\ tsa_timer_noise_injection \in BOOLEAN
  /\ tsa_scheduler_queue_isolation \in BOOLEAN
  /\ sf_time_slice_consumed \in BOOLEAN
  /\ sf_preemption_count \in BOOLEAN
  /\ sf_cache_sets_touched \in BOOLEAN
  /\ sf_tlb_entries_used \in BOOLEAN

\* Initial state
Init ==
  /\ ec_pid = TRUE
  /\ ec_priority = TRUE
  /\ ec_time_slice_us = TRUE
  /\ ec_preemptible = TRUE
  /\ ec_cache_partition = TRUE
  /\ tsa_constant_time_scheduling = TRUE
  /\ tsa_cache_partitioning = TRUE
  /\ tsa_preemption_hardening = TRUE
  /\ tsa_tlb_isolation = TRUE
  /\ tsa_ipi_constant_time = TRUE
  /\ tsa_freq_pinning = TRUE
  /\ tsa_timer_noise_injection = TRUE
  /\ tsa_scheduler_queue_isolation = TRUE
  /\ sf_time_slice_consumed = TRUE
  /\ sf_preemption_count = TRUE
  /\ sf_cache_sets_touched = TRUE
  /\ sf_tlb_entries_used = TRUE

\* sq_defense_active (matches Coq: Definition sq_defense_active)
sq_defense_active(c) == TRUE

\* l1_defense_active (matches Coq: Definition l1_defense_active)
l1_defense_active(c) == TRUE

\* tlb_ipi_defense_active (matches Coq: Definition tlb_ipi_defense_active)
tlb_ipi_defense_active(c) == TRUE

\* freq_defense_active (matches Coq: Definition freq_defense_active)
freq_defense_active(c) == TRUE

\* all_tsa_defenses (matches Coq: Definition all_tsa_defenses)
all_tsa_defenses(c) == TRUE

\* riina_tsa_config (matches Coq: Definition riina_tsa_config)
riina_tsa_config == TRUE

\* scheduler_indistinguishable (matches Coq: Definition scheduler_indistinguishable)
scheduler_indistinguishable(f1, f2) == TRUE

\* constant_time_codegen (matches Coq: Definition constant_time_codegen)
constant_time_codegen(footprints) == TRUE

\* andb_true_iff_local (matches Coq: Lemma andb_true_iff_local)
THEOREM andb_true_iff_local == Init => TypeOK

\* TSA_001_sq_defense (matches Coq: Theorem TSA_001_sq_defense)
THEOREM TSA_001_sq_defense == Init => TypeOK

\* TSA_002_l1_defense (matches Coq: Theorem TSA_002_l1_defense)
THEOREM TSA_002_l1_defense == Init => TypeOK

\* TSA_003_tlb_ipi_defense (matches Coq: Theorem TSA_003_tlb_ipi_defense)
THEOREM TSA_003_tlb_ipi_defense == Init => TypeOK

\* TSA_004_freq_defense (matches Coq: Theorem TSA_004_freq_defense)
THEOREM TSA_004_freq_defense == Init => TypeOK

\* TSA_005_all_defenses (matches Coq: Theorem TSA_005_all_defenses)
THEOREM TSA_005_all_defenses == Init => TypeOK

\* TSA_006_sq_requires_ct (matches Coq: Theorem TSA_006_sq_requires_ct)
THEOREM TSA_006_sq_requires_ct == Init => TypeOK

\* TSA_007_sq_requires_isolation (matches Coq: Theorem TSA_007_sq_requires_isolation)
THEOREM TSA_007_sq_requires_isolation == Init => TypeOK

\* TSA_008_sq_requires_noise (matches Coq: Theorem TSA_008_sq_requires_noise)
THEOREM TSA_008_sq_requires_noise == Init => TypeOK

\* TSA_009_l1_requires_partition (matches Coq: Theorem TSA_009_l1_requires_partition)
THEOREM TSA_009_l1_requires_partition == Init => TypeOK

\* TSA_010_l1_requires_preemption (matches Coq: Theorem TSA_010_l1_requires_preemption)
THEOREM TSA_010_l1_requires_preemption == Init => TypeOK

\* TSA_011_tlb_requires_isolation (matches Coq: Theorem TSA_011_tlb_requires_isolation)
THEOREM TSA_011_tlb_requires_isolation == Init => TypeOK

\* TSA_012_tlb_requires_ipi (matches Coq: Theorem TSA_012_tlb_requires_ipi)
THEOREM TSA_012_tlb_requires_ipi == Init => TypeOK

\* TSA_013_all_implies_sq (matches Coq: Theorem TSA_013_all_implies_sq)
THEOREM TSA_013_all_implies_sq == Init => TypeOK

\* TSA_014_all_implies_l1 (matches Coq: Theorem TSA_014_all_implies_l1)
THEOREM TSA_014_all_implies_l1 == Init => TypeOK

\* TSA_015_all_implies_tlb (matches Coq: Theorem TSA_015_all_implies_tlb)
THEOREM TSA_015_all_implies_tlb == Init => TypeOK

\* TSA_016_all_implies_freq (matches Coq: Theorem TSA_016_all_implies_freq)
THEOREM TSA_016_all_implies_freq == Init => TypeOK

\* TSA_017_single_footprint_ct (matches Coq: Theorem TSA_017_single_footprint_ct)
THEOREM TSA_017_single_footprint_ct == Init => TypeOK

\* TSA_018_empty_footprint_ct (matches Coq: Theorem TSA_018_empty_footprint_ct)
THEOREM TSA_018_empty_footprint_ct == Init => TypeOK

\* TSA_019_identical_indistinguishable (matches Coq: Theorem TSA_019_identical_indistinguishable)
THEOREM TSA_019_identical_indistinguishable == Init => TypeOK

\* TSA_020_identical_pair_ct (matches Coq: Theorem TSA_020_identical_pair_ct)
THEOREM TSA_020_identical_pair_ct == Init => TypeOK

\* TSA_021_identical_triple_ct (matches Coq: Theorem TSA_021_identical_triple_ct)
THEOREM TSA_021_identical_triple_ct == Init => TypeOK

\* TSA_022_full_implies_ct_sched (matches Coq: Theorem TSA_022_full_implies_ct_sched)
THEOREM TSA_022_full_implies_ct_sched == Init => TypeOK

\* TSA_023_full_implies_partition (matches Coq: Theorem TSA_023_full_implies_partition)
THEOREM TSA_023_full_implies_partition == Init => TypeOK

\* TSA_024_full_implies_tlb_iso (matches Coq: Theorem TSA_024_full_implies_tlb_iso)
THEOREM TSA_024_full_implies_tlb_iso == Init => TypeOK

\* TSA_025_complete_defense (matches Coq: Theorem TSA_025_complete_defense)
THEOREM TSA_025_complete_defense == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<ec_pid, ec_priority, ec_time_slice_us, ec_preemptible, ec_cache_partition, tsa_constant_time_scheduling, tsa_cache_partitioning, tsa_preemption_hardening, tsa_tlb_isolation, tsa_ipi_constant_time, tsa_freq_pinning, tsa_timer_noise_injection, tsa_scheduler_queue_isolation, sf_time_slice_consumed, sf_preemption_count, sf_cache_sets_touched, sf_tlb_entries_used>>

\* Specification
Spec == Init /\ [][Next]_<<ec_pid, ec_priority, ec_time_slice_us, ec_preemptible, ec_cache_partition, tsa_constant_time_scheduling, tsa_cache_partitioning, tsa_preemption_hardening, tsa_tlb_isolation, tsa_ipi_constant_time, tsa_freq_pinning, tsa_timer_noise_injection, tsa_scheduler_queue_isolation, sf_time_slice_consumed, sf_preemption_count, sf_cache_sets_touched, sf_tlb_entries_used>>

====
