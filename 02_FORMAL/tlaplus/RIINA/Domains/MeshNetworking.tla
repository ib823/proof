\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE MeshNetworking ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/MeshNetworking.v (28 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* RouteStatus (matches Coq: Inductive RouteStatus)
CONSTANTS ValidRoute, StaleRoute, LoopDetected, PartitionDetected

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* honest_path (matches Coq: Definition honest_path)
honest_path(path, byzantine) == TRUE

\* byzantine_tolerant (matches Coq: Definition byzantine_tolerant)
byzantine_tolerant(network) == TRUE

\* loop_free (matches Coq: Definition loop_free)
loop_free(route) == TRUE

\* seq_increasing (matches Coq: Definition seq_increasing)
seq_increasing(old_seq, new_seq) == TRUE

\* route_fresh (matches Coq: Definition route_fresh)
route_fresh(entry, current, max_age) == TRUE

\* paths_sufficient (matches Coq: Definition paths_sufficient)
paths_sufficient(mp, min_paths) == TRUE

\* metric_bounded (matches Coq: Definition metric_bounded)
metric_bounded(entry, max_metric) == TRUE

\* neighbor_authenticated (matches Coq: Definition neighbor_authenticated)
neighbor_authenticated(neighbor, trusted) == TRUE

\* hop_count_ok (matches Coq: Definition hop_count_ok)
hop_count_ok(route, max_hops) == TRUE

\* entry_valid (matches Coq: Definition entry_valid)
entry_valid(entry) == TRUE

\* partition_detected (matches Coq: Definition partition_detected)
partition_detected(reachable, total, threshold) == TRUE

\* healing_path_exists (matches Coq: Definition healing_path_exists)
healing_path_exists(paths) == TRUE

\* converged_in_time (matches Coq: Definition converged_in_time)
converged_in_time(elapsed, max_time) == TRUE

\* flood_bounded (matches Coq: Definition flood_bounded)
flood_bounded(ttl, max_ttl) == TRUE

\* msg_id_unique (matches Coq: Definition msg_id_unique)
msg_id_unique(msg_id, seen) == TRUE

\* link_quality_ok (matches Coq: Definition link_quality_ok)
link_quality_ok(quality, min_quality) == TRUE

\* reputation_sufficient (matches Coq: Definition reputation_sufficient)
reputation_sufficient(rep, min_rep) == TRUE

\* channel_secure (matches Coq: Definition channel_secure)
channel_secure(encrypted, authenticated) == TRUE

\* rate_ok (matches Coq: Definition rate_ok)
rate_ok(current, max_rate) == TRUE

\* geographically_diverse (matches Coq: Definition geographically_diverse)
geographically_diverse(regions, min_regions) == TRUE

\* store_timeout_ok (matches Coq: Definition store_timeout_ok)
store_timeout_ok(stored_time, current, timeout) == TRUE

\* delay_acceptable (matches Coq: Definition delay_acceptable)
delay_acceptable(delay, max_delay) == TRUE

\* cover_traffic_ratio (matches Coq: Definition cover_traffic_ratio)
cover_traffic_ratio(real, cover, min_ratio) == TRUE

\* mesh_layers (matches Coq: Definition mesh_layers)
mesh_layers(bft, loop, fresh, auth) == TRUE

\* existsb_In (matches Coq: Lemma existsb_In)
THEOREM existsb_In == Init => TypeOK

\* not_existsb_not_In (matches Coq: Lemma not_existsb_not_In)
THEOREM not_existsb_not_In == Init => TypeOK

\* NoDup_nodup_equiv (matches Coq: Lemma NoDup_nodup_equiv)
THEOREM NoDup_nodup_equiv == Init => TypeOK

\* mesh_001_byzantine_threshold (matches Coq: Theorem mesh_001_byzantine_threshold)
THEOREM mesh_001_byzantine_threshold == Init => TypeOK

\* mesh_002_honest_path (matches Coq: Theorem mesh_002_honest_path)
THEOREM mesh_002_honest_path == Init => TypeOK

\* mesh_003_loop_free (matches Coq: Theorem mesh_003_loop_free)
THEOREM mesh_003_loop_free == Init => TypeOK

\* mesh_004_seq_increasing (matches Coq: Theorem mesh_004_seq_increasing)
THEOREM mesh_004_seq_increasing == Init => TypeOK

\* mesh_005_route_fresh (matches Coq: Theorem mesh_005_route_fresh)
THEOREM mesh_005_route_fresh == Init => TypeOK

\* mesh_006_multi_path (matches Coq: Theorem mesh_006_multi_path)
THEOREM mesh_006_multi_path == Init => TypeOK

\* mesh_007_disjoint (matches Coq: Theorem mesh_007_disjoint)
THEOREM mesh_007_disjoint == Init => TypeOK

\* mesh_008_metric_bounded (matches Coq: Theorem mesh_008_metric_bounded)
THEOREM mesh_008_metric_bounded == Init => TypeOK

\* mesh_009_neighbor_auth (matches Coq: Theorem mesh_009_neighbor_auth)
THEOREM mesh_009_neighbor_auth == Init => TypeOK

\* mesh_010_hop_limit (matches Coq: Theorem mesh_010_hop_limit)
THEOREM mesh_010_hop_limit == Init => TypeOK

\* mesh_011_entry_valid (matches Coq: Theorem mesh_011_entry_valid)
THEOREM mesh_011_entry_valid == Init => TypeOK

\* mesh_012_partition (matches Coq: Theorem mesh_012_partition)
THEOREM mesh_012_partition == Init => TypeOK

\* mesh_013_healing (matches Coq: Theorem mesh_013_healing)
THEOREM mesh_013_healing == Init => TypeOK

\* mesh_014_convergence (matches Coq: Theorem mesh_014_convergence)
THEOREM mesh_014_convergence == Init => TypeOK

\* mesh_015_flood_bounded (matches Coq: Theorem mesh_015_flood_bounded)
THEOREM mesh_015_flood_bounded == Init => TypeOK

\* mesh_016_msg_unique (matches Coq: Theorem mesh_016_msg_unique)
THEOREM mesh_016_msg_unique == Init => TypeOK

\* mesh_017_link_quality (matches Coq: Theorem mesh_017_link_quality)
THEOREM mesh_017_link_quality == Init => TypeOK

\* mesh_018_reputation (matches Coq: Theorem mesh_018_reputation)
THEOREM mesh_018_reputation == Init => TypeOK

\* mesh_019_secure_channel (matches Coq: Theorem mesh_019_secure_channel)
THEOREM mesh_019_secure_channel == Init => TypeOK

\* mesh_020_rate_limited (matches Coq: Theorem mesh_020_rate_limited)
THEOREM mesh_020_rate_limited == Init => TypeOK

\* mesh_021_geo_diversity (matches Coq: Theorem mesh_021_geo_diversity)
THEOREM mesh_021_geo_diversity == Init => TypeOK

\* mesh_022_store_forward (matches Coq: Theorem mesh_022_store_forward)
THEOREM mesh_022_store_forward == Init => TypeOK

\* mesh_023_delay_tolerance (matches Coq: Theorem mesh_023_delay_tolerance)
THEOREM mesh_023_delay_tolerance == Init => TypeOK

\* mesh_024_traffic_analysis (matches Coq: Theorem mesh_024_traffic_analysis)
THEOREM mesh_024_traffic_analysis == Init => TypeOK

\* mesh_025_defense_in_depth (matches Coq: Theorem mesh_025_defense_in_depth)
THEOREM mesh_025_defense_in_depth == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
