#!/usr/bin/env bash
# ============================================================================
# provision-coq.sh
#
# Deterministically provision the pinned Rocq toolchain — the PRIMARY verifier.
#
# This is the single source of truth for the Coq/Rocq pin. CI and local
# development both call it, so the two cannot silently diverge.
#
# Why this script exists (found 2026-08-04 by command):
#   1. Every other prover lane had a `provision-*.sh` (Isabelle, F*, TLA+,
#      Alloy) — but Coq, the ONLY lane that actually machine-checks anything,
#      had none. It was installed by hand from CLAUDE.md prose.
#   2. `.github/workflows/verify.yml` pinned `rocq-prover.9.1.1
#      rocq-stdlib.9.1.1` with an UNPINNED `|| opam install rocq-prover
#      rocq-stdlib` fallback. Neither pinned version exists (`rocq-prover`
#      publishes only 9.0.0; `rocq-stdlib` publishes 9.0.0/9.1.0/9.2.0), so the
#      pinned install ALWAYS failed and the unpinned fallback ALWAYS ran — under
#      a job named "Rocq 9.1.1". A pin that fails open is not a pin.
#   3. CI used OCaml 5.2 while the documented/working local toolchain is 4.14.2.
#
# The pin below is the one PROVEN to build the active corpus (328/328 .vo,
# 0 Admitted/Axiom/Abort). Note the versions differ between the two packages —
# rocq-core 9.1.1 ships with rocq-stdlib 9.1.0. That is correct, not a typo.
#
# Usage:
#   bash scripts/provision-coq.sh            # install/repair the pinned switch
#   bash scripts/provision-coq.sh --check    # verify only; exit 1 on mismatch
#
# Optional env overrides:
#   RIINA_COQ_SWITCH                 opam switch name (default: rocq)
#   RIINA_ROCQ_CORE_VERSION          default: 9.1.1
#   RIINA_ROCQ_STDLIB_VERSION        default: 9.1.0
#   RIINA_OCAML_COMPILER             default: ocaml-base-compiler.4.14.2
#   RIINA_COQ_USE_CURRENT_SWITCH=1   install into the ACTIVE switch instead of
#                                    creating one (used by CI, where
#                                    ocaml/setup-ocaml has already made a switch)
# ============================================================================

set -euo pipefail

# opam colourises its output when it thinks the terminal supports it — which it
# does on GitHub Actions runners but NOT in a plain local shell. That difference
# silently broke the exact-match version compare below: CI saw the escape-wrapped
# "\033[35m9.1.0\033[0m" instead of "9.1.0" and reported a pin mismatch even
# though the install was correct. Force colour off, and ALSO strip any residual
# escapes at the point of comparison (see strip_ansi) — belt and braces, because
# this failure mode is invisible locally.
# NOTE: `opam --color=never <subcmd>` breaks `-f` parsing; the env var is the
# correct lever.
export OPAMCOLOR=never

# Remove ANSI SGR escapes and surrounding whitespace from a captured value.
strip_ansi() { sed 's/\x1b\[[0-9;]*m//g' | tr -d '[:space:]'; }

SWITCH="${RIINA_COQ_SWITCH:-rocq}"
ROCQ_CORE_VERSION="${RIINA_ROCQ_CORE_VERSION:-9.1.1}"
ROCQ_STDLIB_VERSION="${RIINA_ROCQ_STDLIB_VERSION:-9.1.0}"
OCAML_COMPILER="${RIINA_OCAML_COMPILER:-ocaml-base-compiler.4.14.2}"
ROCQ_REPO_NAME="rocq-released"
ROCQ_REPO_URL="https://rocq-prover.org/opam/released"
USE_CURRENT="${RIINA_COQ_USE_CURRENT_SWITCH:-0}"

CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

fail() { echo -e "${RED}FAIL:${NC} $*" >&2; exit 1; }
info() { echo -e "  $*"; }
ok()   { echo -e "${GREEN}[OK]${NC} $*"; }

echo "================================================================"
echo "  RIINA Rocq toolchain — pinned provisioning"
echo "================================================================"
info "pin: rocq-core.${ROCQ_CORE_VERSION} + rocq-stdlib.${ROCQ_STDLIB_VERSION} on ${OCAML_COMPILER}"

# ── opam presence ────────────────────────────────────────────────────
if ! command -v opam >/dev/null 2>&1; then
  if [ "$CHECK_ONLY" -eq 1 ]; then
    fail "opam not found. Install it (Debian/Ubuntu: apt-get install -y opam libgmp-dev)"
  fi
  fail "opam not found. Install it first, e.g.:
    apt-get update && apt-get install -y opam libgmp-dev m4
  then re-run this script."
fi

# ── verification helper: does the ACTIVE switch match the pin? ────────
verify_pin() {
  local env_out
  env_out="$(opam env ${SWITCH_FLAG:-} 2>/dev/null || true)"
  [ -n "$env_out" ] && eval "$env_out"

  command -v rocq >/dev/null 2>&1 || return 1

  local ver
  ver="$(rocq --version 2>/dev/null | head -1 || true)"
  case "$ver" in
    *"$ROCQ_CORE_VERSION"*) ;;
    *) return 1 ;;
  esac

  # rocq-stdlib is a separate package with its own version — check it too,
  # since a mismatched stdlib is exactly the CI/local divergence this fixes.
  # Query the package DB directly rather than parsing the `opam list` table:
  # that table's layout varies between opam versions and switch kinds, and it
  # silently failed to match on CI's local (_opam) switch even though the right
  # version was installed. `-f installed-version` prints just the version.
  FOUND_STDLIB="$(opam show -f installed-version rocq-stdlib 2>/dev/null | strip_ansi)"
  [ -n "$FOUND_STDLIB" ] || return 1
  [ "$FOUND_STDLIB" = "$ROCQ_STDLIB_VERSION" ] || return 1
  return 0
}

# Render everything we actually found, so a failure is diagnosable at a glance.
# The first version of this script printed only `rocq --version`, which hid the
# real cause (a stdlib mismatch) behind a line that looked correct.
found_summary() {
  local core stdlib
  core="$(command -v rocq >/dev/null 2>&1 && rocq --version 2>/dev/null | head -1 || echo 'rocq not on PATH')"
  stdlib="$(opam show -f installed-version rocq-stdlib 2>/dev/null | strip_ansi)"
  echo "    rocq:        ${core}"
  echo "    rocq-stdlib: ${stdlib:-<not installed>}"
}

if [ "$USE_CURRENT" = "1" ]; then
  SWITCH_FLAG=""
else
  SWITCH_FLAG="--switch=$SWITCH"
fi

# ── --check mode: verify and exit ────────────────────────────────────
if [ "$CHECK_ONLY" -eq 1 ]; then
  if verify_pin; then
    ok "Rocq toolchain matches the pin ($(rocq --version 2>/dev/null | head -1))"
    exit 0
  fi
  echo -e "${RED}FAIL:${NC} Rocq toolchain does NOT match the pin." >&2
  echo "  expected: rocq-core ${ROCQ_CORE_VERSION} + rocq-stdlib ${ROCQ_STDLIB_VERSION}" >&2
  echo "  found:" >&2
  found_summary >&2
  echo "  fix:      bash scripts/provision-coq.sh" >&2
  exit 1
fi

# ── already correct? then this is a no-op ────────────────────────────
if verify_pin; then
  ok "already provisioned ($(rocq --version 2>/dev/null | head -1)) — nothing to do"
  exit 0
fi

# ── provision ────────────────────────────────────────────────────────
export OPAMYES=1 OPAMCONFIRMLEVEL=unsafe-yes

if [ ! -d "${OPAMROOT:-$HOME/.opam}" ]; then
  info "initialising opam (bare, sandboxing disabled for container use)..."
  opam init --bare --disable-sandboxing
fi

if ! opam repo list --all 2>/dev/null | grep -q "$ROCQ_REPO_NAME"; then
  info "adding the official Rocq opam repository..."
  opam repo add "$ROCQ_REPO_NAME" "$ROCQ_REPO_URL" --all-switches --set-default || \
    opam repo add "$ROCQ_REPO_NAME" "$ROCQ_REPO_URL"
fi

if [ "$USE_CURRENT" = "1" ]; then
  info "installing into the ACTIVE switch (RIINA_COQ_USE_CURRENT_SWITCH=1)"
  opam repo add "$ROCQ_REPO_NAME" "$ROCQ_REPO_URL" 2>/dev/null || true
else
  if ! opam switch list --short 2>/dev/null | grep -qx "$SWITCH"; then
    info "creating switch '$SWITCH' on $OCAML_COMPILER (compiles OCaml; slow)..."
    opam switch create "$SWITCH" "$OCAML_COMPILER"
  fi
fi

opam update "$ROCQ_REPO_NAME" >/dev/null 2>&1 || opam update >/dev/null 2>&1 || true

info "installing the pinned prover (NO unpinned fallback — fails closed)..."
# Deliberately NO `|| opam install rocq-core rocq-stdlib`. An unpinned fallback
# is what let CI report green on an unknown toolchain; if the pin is
# unavailable, that is a real problem and must surface, not be papered over.
# shellcheck disable=SC2086
opam install -y $SWITCH_FLAG \
  "rocq-core.${ROCQ_CORE_VERSION}" \
  "rocq-stdlib.${ROCQ_STDLIB_VERSION}"

# ── verify what we actually got ──────────────────────────────────────
if verify_pin; then
  ok "provisioned: $(rocq --version 2>/dev/null | head -1)"
  echo ""
  echo "Activate it in this shell with:"
  if [ "$USE_CURRENT" = "1" ]; then
    echo "  eval \$(opam env)"
  else
    echo "  eval \$(opam env --switch=$SWITCH)"
  fi
  echo "  export COQBIN=\"\$(dirname \"\$(command -v rocq)\")/\""
  exit 0
fi

echo "  expected: rocq-core ${ROCQ_CORE_VERSION} + rocq-stdlib ${ROCQ_STDLIB_VERSION}" >&2
echo "  found:" >&2
found_summary >&2
fail "installation completed but verification did not match the pin (see above)"
