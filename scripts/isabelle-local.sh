#!/usr/bin/env bash
# Shared helpers for RIINA pinned local Isabelle enforcement.

riina_isabelle_sha256_file() {
  local path="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$path" | awk '{print $1}'
    return 0
  fi
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$path" | awk '{print $1}'
    return 0
  fi
  if command -v openssl >/dev/null 2>&1; then
    openssl dgst -sha256 "$path" | awk '{print $NF}'
    return 0
  fi
  return 1
}

riina_isabelle_realpath() {
  local path="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$path"
    return 0
  fi
  if command -v readlink >/dev/null 2>&1; then
    readlink -f "$path" 2>/dev/null && return 0
  fi
  printf '%s\n' "$path"
}

riina_isabelle_default_bin() {
  local repo_root="$1"
  printf '%s\n' "$repo_root/05_TOOLING/tools/isabelle/current/bin/isabelle"
}

riina_isabelle_resolve_bin() {
  local repo_root="$1"
  local default_bin
  default_bin="$(riina_isabelle_default_bin "$repo_root")"

  if [ -n "${RIINA_ISABELLE_BIN:-}" ] && [ -x "${RIINA_ISABELLE_BIN:-}" ]; then
    printf '%s\n' "$RIINA_ISABELLE_BIN"
    return 0
  fi
  if [ -n "${RIINA_ISABELLE_HOME:-}" ] && [ -x "${RIINA_ISABELLE_HOME:-}/bin/isabelle" ]; then
    printf '%s\n' "${RIINA_ISABELLE_HOME}/bin/isabelle"
    return 0
  fi
  if [ -n "${ISABELLE_HOME:-}" ] && [ -x "${ISABELLE_HOME:-}/bin/isabelle" ]; then
    printf '%s\n' "${ISABELLE_HOME}/bin/isabelle"
    return 0
  fi
  if [ -x "$default_bin" ]; then
    printf '%s\n' "$default_bin"
    return 0
  fi
  return 1
}

riina_isabelle_manifest_value() {
  local manifest="$1"
  local key="$2"
  python3 - "$manifest" "$key" <<'PY'
import json, sys
path, key = sys.argv[1], sys.argv[2]
try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    v = data.get(key, "")
    print("" if v is None else str(v))
except Exception:
    print("")
PY
}

riina_require_local_isabelle() {
  local repo_root="$1"
  local expected_version="${RIINA_ISABELLE_VERSION:-2024}"
  local manifest="$repo_root/05_TOOLING/tools/isabelle/INSTALL_MANIFEST.json"
  local default_bin
  default_bin="$(riina_isabelle_default_bin "$repo_root")"

  local bin
  if ! bin="$(riina_isabelle_resolve_bin "$repo_root")"; then
    echo "ERROR: pinned local Isabelle not found at $default_bin." >&2
    echo "Run: bash scripts/provision-smoke-toolchains.sh" >&2
    echo "     or: bash scripts/provision-isabelle.sh" >&2
    return 1
  fi

  if [ ! -x "$bin" ]; then
    echo "ERROR: Isabelle binary is not executable: $bin" >&2
    return 1
  fi

  local default_real bin_real
  default_real="$(riina_isabelle_realpath "$default_bin")"
  bin_real="$(riina_isabelle_realpath "$bin")"
  if [ "${RIINA_ALLOW_NONSTANDARD_ISABELLE_PATH:-0}" != "1" ] && [ "$bin_real" != "$default_real" ]; then
    echo "ERROR: Isabelle path must be pinned to $default_bin (resolved: $bin)." >&2
    echo "Set RIINA_ALLOW_NONSTANDARD_ISABELLE_PATH=1 only for controlled/manual recovery." >&2
    return 1
  fi

  if [ ! -f "$manifest" ]; then
    echo "ERROR: missing Isabelle install manifest: $manifest" >&2
    echo "Run: bash scripts/provision-smoke-toolchains.sh" >&2
    echo "     or: bash scripts/provision-isabelle.sh" >&2
    return 1
  fi

  local expected_sha actual_sha
  expected_sha="$(riina_isabelle_manifest_value "$manifest" "isabelle_bin_sha256")"
  if [ -z "$expected_sha" ]; then
    echo "ERROR: manifest missing isabelle_bin_sha256: $manifest" >&2
    return 1
  fi
  if ! actual_sha="$(riina_isabelle_sha256_file "$bin")"; then
    echo "ERROR: unable to compute SHA-256 for $bin" >&2
    return 1
  fi
  if [ "$expected_sha" != "$actual_sha" ]; then
    echo "ERROR: Isabelle binary checksum mismatch for $bin" >&2
    echo "Expected: $expected_sha" >&2
    echo "Actual  : $actual_sha" >&2
    echo "Run: bash scripts/provision-smoke-toolchains.sh" >&2
    echo "     or: bash scripts/provision-isabelle.sh" >&2
    return 1
  fi

  local version_line
  version_line="$("$bin" version 2>/dev/null | head -n 1 || true)"
  if [[ "$version_line" != *"Isabelle${expected_version}"* ]]; then
    echo "ERROR: unexpected Isabelle version: $version_line (expected Isabelle${expected_version})" >&2
    return 1
  fi

  printf '%s\n' "$bin"
}

riina_export_local_isabelle_env() {
  local bin="$1"
  local home
  home="$(cd "$(dirname "$bin")/.." && pwd)"
  export RIINA_ISABELLE_BIN="$bin"
  export RIINA_ISABELLE_HOME="$home"
  export ISABELLE_HOME="$home"
}
