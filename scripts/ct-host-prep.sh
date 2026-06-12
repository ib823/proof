#!/usr/bin/env bash
# Prepare a host for CONSTANT-TIME TIMING certification (scripts/ct-timing-certify.sh).
#
# Applies the runtime-revertible quiescence settings (CPU governor, turbo, SMT)
# and prints the one persistent change that needs a reboot (`isolcpus`). Run as
# root on a NON-virtualised box (a spare laptop/desktop, or a bare-metal cloud
# instance — AWS *.metal / Equinix Metal / Hetzner|OVH dedicated; a normal
# virtualised VM can never be CERTIFICATION-GRADE because of hypervisor steal-time).
#
#   sudo CT_CORE=2 bash scripts/ct-host-prep.sh     # prep core 2
#   # (add the printed isolcpus line to GRUB, reboot, then:)
#   CT_CORE=2 bash scripts/ct-timing-certify.sh
#
# Everything here resets on reboot except the GRUB edit you make by hand, so it is
# safe: it does not touch the bootloader or make any persistent change itself.
set -uo pipefail

CORE="${CT_CORE:-2}"
note() { printf '  %-7s %s\n' "$1" "$2"; }

echo "[ct-host-prep] target core: ${CORE}"

if [ "$(id -u)" -ne 0 ]; then
  echo "[ct-host-prep] NOTE: not root — governor/turbo/SMT changes will be skipped."
  echo "               Re-run with sudo to apply them; the isolcpus advice below still prints."
  ROOT=0
else
  ROOT=1
fi

# --- 0. Refuse to pretend a VM can certify ---------------------------------
virt="$(systemd-detect-virt 2>/dev/null || echo unknown)"
if [ "$virt" != "none" ] || grep -qi hypervisor /proc/cpuinfo 2>/dev/null; then
  note "WARN" "virtualisation detected ('${virt}') — this host can only ever be INDICATIVE."
  note "" "Use real metal (own box / *.metal / dedicated) for CERTIFICATION-GRADE."
fi

# --- 1. CPU frequency governor -> performance (fixed frequency) -------------
if [ "$ROOT" = 1 ]; then
  if command -v cpupower >/dev/null 2>&1; then
    cpupower frequency-set -g performance >/dev/null 2>&1 && note "OK" "governor -> performance (cpupower)"
  else
    for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
      [ -w "$g" ] && echo performance > "$g" 2>/dev/null
    done
    note "OK" "governor -> performance (sysfs)"
  fi
fi
gov="$(cat /sys/devices/system/cpu/cpu${CORE}/cpufreq/scaling_governor 2>/dev/null || echo unknown)"
note "gov" "cpu${CORE} = ${gov}"

# --- 2. Turbo / boost off (stops opportunistic frequency drift) -------------
if [ "$ROOT" = 1 ]; then
  if [ -w /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
    echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo && note "OK" "Intel turbo OFF (no_turbo=1)"
  elif [ -w /sys/devices/system/cpu/cpufreq/boost ]; then
    echo 0 > /sys/devices/system/cpu/cpufreq/boost && note "OK" "AMD/cpufreq boost OFF"
  else
    note "skip" "no turbo/boost knob found (may be firmware-controlled)"
  fi
fi

# --- 3. SMT off (a sibling hyperthread shares the core and adds noise) ------
if [ "$ROOT" = 1 ] && [ -w /sys/devices/system/cpu/smt/control ]; then
  echo off > /sys/devices/system/cpu/smt/control 2>/dev/null && note "OK" "SMT -> off"
fi
smt="$(cat /sys/devices/system/cpu/smt/control 2>/dev/null || echo unknown)"
note "smt" "${smt}"

# --- 4. Core isolation (needs a reboot — we only advise, never edit GRUB) ---
echo ""
if grep -qE "isolcpus" /proc/cmdline 2>/dev/null; then
  note "OK" "isolcpus already on the kernel cmdline: $(grep -oE 'isolcpus=[^ ]*' /proc/cmdline)"
else
  echo "[ct-host-prep] isolcpus is NOT set. To isolate core ${CORE} from the scheduler, add"
  echo "  to GRUB_CMDLINE_LINUX in /etc/default/grub, then \`update-grub\` (or grub2-mkconfig) + reboot:"
  echo ""
  echo "      isolcpus=${CORE} nohz_full=${CORE} rcu_nocbs=${CORE}"
  echo ""
fi

echo "[ct-host-prep] done. Verify + certify with:  CT_CORE=${CORE} bash scripts/ct-timing-certify.sh"
echo "               (it re-checks all of the above and grades the host before measuring.)"
