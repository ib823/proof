(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.ContainerSecurity

open FStar.All

type container_guard = {
  image_signed: bool;
  rootless_runtime: bool;
  seccomp_enabled: bool;
  namespace_isolated: bool;
}

let container_secure (g: container_guard) : Tot bool =
  g.image_signed
  && g.rootless_runtime
  && g.seccomp_enabled
  && g.namespace_isolated

let prod_container_guard : container_guard = {
  image_signed = true;
  rootless_runtime = true;
  seccomp_enabled = true;
  namespace_isolated = true;
}

let prod_container_secure =
  container_secure prod_container_guard
