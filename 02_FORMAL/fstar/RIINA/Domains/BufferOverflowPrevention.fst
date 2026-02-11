(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.BufferOverflowPrevention

open FStar.All

type buffer_guard = {
  capacity: nat;
  write_index: nat;
  bounds_checked: bool;
}

let write_safe (g: buffer_guard) : Tot bool =
  g.capacity > 0
  && g.bounds_checked
  && g.write_index < g.capacity

let baseline_buffer_guard : buffer_guard = {
  capacity = 1024;
  write_index = 0;
  bounds_checked = true;
}

let baseline_write_safe =
  write_safe baseline_buffer_guard
