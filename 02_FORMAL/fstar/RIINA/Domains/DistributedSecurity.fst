(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.DistributedSecurity

open FStar.All

type cluster_guard = {
  node_count: nat;
  quorum_size: nat;
  authenticated_channels: bool;
  byzantine_tolerant: bool;
}

let cluster_secure (c: cluster_guard) : Tot bool =
  c.node_count >= 1
  && c.quorum_size >= 1
  && c.quorum_size <= c.node_count
  && c.authenticated_channels
  && c.byzantine_tolerant

let baseline_cluster_guard : cluster_guard = {
  node_count = 3;
  quorum_size = 2;
  authenticated_channels = true;
  byzantine_tolerant = true;
}

let production_cluster_guard : cluster_guard = {
  node_count = 7;
  quorum_size = 5;
  authenticated_channels = true;
  byzantine_tolerant = true;
}

let baseline_cluster_secure =
  cluster_secure baseline_cluster_guard

let production_cluster_secure =
  cluster_secure production_cluster_guard
