#!/usr/bin/env bash
# Constant-time TIMING certification driver (dudect / TVLA-style).
#
# Wraps `examples/dudect_ct.rs` into a turnkey, archivable certification run and,
# crucially, GRADES THE HOST: a meaningful timing-leakage verdict needs a quiet,
# fixed-frequency, isolated core. On a shared/virtualised vCPU the result is only
# INDICATIVE; on a properly configured bare-metal host it is CERTIFICATION-GRADE.
#
# This is the *timing* half of constant-time verification (data-independent
# timing). The *structural* half (no secret branch/memory — deterministic, host
# independent) is `scripts/ct-structural-check.sh`.
#
# Controlled-host setup (do this on the bare-metal box, then run this script):
#   1. Kernel cmdline:  isolcpus=<C> nohz_full=<C> rcu_nocbs=<C>   (isolate core C)
#   2. Governor:        cpupower frequency-set -g performance      (or per-core)
#   3. Turbo off:       echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
#                       (AMD: disable Core Performance Boost)
#   4. SMT off:         echo off > /sys/devices/system/cpu/smt/control
#   5. Pin to C:        CT_CORE=<C> bash scripts/ct-timing-certify.sh
#
# Usage:   [CT_CORE=0] [CT_SCALE=20] bash scripts/ct-timing-certify.sh
# Exit:    0 = PASS (detection validated AND no primitive flagged); 1 = a primitive
#          flagged OR detection control failed; 2 = tooling missing.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLING="$ROOT/05_TOOLING"
CORE="${CT_CORE:-0}"
SCALE="${CT_SCALE:-}"          # passed through to dudect_ct (sample scale)
THRESHOLD="4.5"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT_DIR="$ROOT/reports/ct_evidence"; mkdir -p "$OUT_DIR"
REPORT="$OUT_DIR/ct_timing_${STAMP}.txt"

command -v taskset >/dev/null 2>&1 || { echo "[ct-timing] taskset not found"; exit 2; }

# ── Host readiness grading ───────────────────────────────────────────────────
grade="CERTIFICATION-GRADE"; gaps=()
note() { gaps+=("$1"); grade="INDICATIVE"; }

# Virtualisation / steal time
virt="$(systemd-detect-virt 2>/dev/null || echo unknown)"
[ "$virt" != "none" ] && note "running under virtualisation ('$virt') — hypervisor steal-time perturbs timing"
grep -qi "hypervisor" /proc/cpuinfo 2>/dev/null && note "hypervisor CPU flag present (shared/virtual CPU)"

# Invariant / nonstop TSC (needed for a stable cycle counter)
if ! grep -qE "constant_tsc" /proc/cpuinfo 2>/dev/null; then note "no constant_tsc — cycle counter not invariant"; fi
if ! grep -qE "nonstop_tsc" /proc/cpuinfo 2>/dev/null; then note "no nonstop_tsc — TSC may stop in idle"; fi

# Governor
gov="$(cat /sys/devices/system/cpu/cpu${CORE}/cpufreq/scaling_governor 2>/dev/null || echo unknown)"
[ "$gov" != "performance" ] && note "cpu${CORE} governor='$gov' (want 'performance' for fixed frequency)"

# Turbo
if [ -r /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
  [ "$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)" = "1" ] || note "Intel turbo still ON (set no_turbo=1)"
fi

# SMT
smt="$(cat /sys/devices/system/cpu/smt/control 2>/dev/null || echo unknown)"
[ "$smt" != "off" ] && [ "$smt" != "notsupported" ] && note "SMT='$smt' (want 'off' — a sibling thread adds noise)"

# Core isolation
if ! grep -qE "isolcpus" /proc/cmdline 2>/dev/null; then note "no isolcpus on kernel cmdline (core ${CORE} not isolated from the scheduler)"; fi

# ── Build + run ──────────────────────────────────────────────────────────────
echo "[ct-timing] building dudect_ct (release)…"
( cd "$TOOLING" && cargo build --release --example dudect_ct -p riina-core ) >/dev/null 2>&1 \
  || { echo "[ct-timing] build failed"; exit 2; }
BIN="$TOOLING/target/release/examples/dudect_ct"

echo "[ct-timing] running pinned to core ${CORE}…  (report: ${REPORT#"$ROOT"/})"
# Always 'all' so the positive control runs (detection-power check); CT_SCALE
# sets the sample multiplier (use a high value, e.g. 50, for a real run).
RAW="$(taskset -c "$CORE" "$BIN" all "${SCALE:-1}" 2>&1)"

# ── Verdict ──────────────────────────────────────────────────────────────────
# POSCTRL line must be FLAGGED (detection power); no crypto line may be FLAGGED.
posctrl_flagged=0; primitive_flagged=0
while IFS= read -r line; do
  echo "$line" | grep -qiE "posctrl|positive control" && echo "$line" | grep -qi "FLAGGED" && posctrl_flagged=1
done <<< "$RAW"
# crypto primitives flagged (exclude the positive control line)
primitive_flagged=$(printf '%s\n' "$RAW" | grep -i "FLAGGED" | grep -ivE "posctrl|positive control" | wc -l)

{
  echo "RIINA constant-time TIMING certification"
  echo "  timestamp:   $STAMP"
  echo "  host grade:  $grade   (core ${CORE}, governor ${gov}, smt ${smt}, virt ${virt})"
  if [ "${#gaps[@]}" -gt 0 ]; then printf '  gap:         %s\n' "${gaps[@]}"; fi
  echo "  threshold:   |t| > $THRESHOLD ⇒ leak"
  echo "-----------------------------------------------------------------------"
  echo "$RAW"
  echo "-----------------------------------------------------------------------"
  echo "  detection control (POSCTRL flagged): $([ "$posctrl_flagged" = 1 ] && echo YES || echo NO)"
  echo "  crypto primitives flagged:           $primitive_flagged"
} | tee "$REPORT"

echo ""
if [ "$grade" = "INDICATIVE" ]; then
  echo "[ct-timing] HOST IS NOT CERTIFICATION-GRADE — result is INDICATIVE only."
  echo "            Re-run on a controlled host (see header) for REQ-28 evidence."
fi
if [ "$posctrl_flagged" != 1 ]; then
  echo "[ct-timing] FAIL: positive control did not flag — no detection power here."; exit 1
fi
if [ "$primitive_flagged" -ne 0 ]; then
  echo "[ct-timing] $primitive_flagged primitive(s) FLAGGED — investigate (real leak vs host artifact)."; exit 1
fi
echo "[ct-timing] PASS: detection validated; no primitive exceeded |t| > $THRESHOLD."
exit 0
