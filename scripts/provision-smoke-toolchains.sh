#!/usr/bin/env bash
# Provision the pinned local smoke tooling used by RIINA's partial
# Isabelle, F*, and TLA+/Alloy executable lanes.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
VERIFY="${RIINA_SMOKE_TOOLCHAIN_VERIFY:-1}"
RUN_ISABELLE="${RIINA_PROVISION_ISABELLE:-1}"
RUN_FSTAR="${RIINA_PROVISION_FSTAR:-1}"
RUN_FORMAL="${RIINA_PROVISION_FORMAL:-1}"

for flag_name in VERIFY RUN_ISABELLE RUN_FSTAR RUN_FORMAL; do
  flag_value="${!flag_name}"
  case "$flag_value" in
    0|1) ;;
    *)
      echo "ERROR: ${flag_name} must be 0 or 1 (got '$flag_value')." >&2
      exit 1
      ;;
  esac
done

echo ""
echo "================================================================"
echo "  RIINA SMOKE TOOLCHAIN PROVISIONING"
echo "================================================================"
echo "verify-after-install: $VERIFY"
echo "isabelle:            $RUN_ISABELLE"
echo "fstar:               $RUN_FSTAR"
echo "formal jars:         $RUN_FORMAL"

if [ "$RUN_ISABELLE" -eq 1 ]; then
  echo ""
  echo "[1/3] Provisioning Isabelle smoke toolchain"
  if [ "$VERIFY" -eq 1 ]; then
    RIINA_ISABELLE_VERIFY_RIINA_CORE=1 bash "$REPO_ROOT/scripts/provision-isabelle.sh"
  else
    bash "$REPO_ROOT/scripts/provision-isabelle.sh"
  fi
fi

if [ "$RUN_FSTAR" -eq 1 ]; then
  echo ""
  echo "[2/3] Provisioning F* smoke toolchain"
  if [ "$VERIFY" -eq 1 ]; then
    RIINA_FSTAR_VERIFY_ACTIVE=1 bash "$REPO_ROOT/scripts/provision-fstar.sh"
  else
    bash "$REPO_ROOT/scripts/provision-fstar.sh"
  fi
fi

if [ "$RUN_FORMAL" -eq 1 ]; then
  echo ""
  echo "[3/3] Provisioning formal model-checking jars"
  bash "$REPO_ROOT/scripts/provision-formal-tools.sh"
fi

if [ "$RUN_ISABELLE" -eq 0 ] && [ "$RUN_FSTAR" -eq 0 ] && [ "$RUN_FORMAL" -eq 0 ]; then
  echo ""
  echo "No toolchains selected; nothing to do."
  exit 0
fi

echo ""
echo "Pinned smoke toolchains are ready."
echo "Recommended next step:"
echo "  bash scripts/check-noncoq-mechanized.sh"
