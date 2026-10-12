#!/usr/bin/env bash
# Negative controls for the non-Coq claim path of scripts/generate-metrics.sh.
#
# Regression for the fast-mode fallback that, with a stale
# reports/noncoq_mechanized_status.json, rebuilt lane claims from the previous
# metrics.json claimLevels and smoke passes, publishing smoke-only lanes as
# "compiled" (and re-reading them as evidence on every later run). It runs the
# generator in a throwaway clone, never touching this checkout:
#
#   1. stale report + inflated cached metrics -> every non-Coq claim stays
#      generated/retired, and a second run does not re-promote anything;
#   2. a smoke check this run observed failing beats a cached smoke pass;
#   3. the generator's freshness rule matches scripts/public-quality-gates.sh:
#      markdown-only lane changes keep the report fresh, code changes do not.
#
# Usage: bash scripts/test-generate-metrics-fallback.sh [path/to/generate-metrics.sh]
# (defaults to this checkout's working-tree copy). Takes ~3 minutes.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GENERATOR="${1:-$REPO_ROOT/scripts/generate-metrics.sh}"
for tool in git jq python3; do
    command -v "$tool" >/dev/null 2>&1 || { echo "FAIL: $tool is required" >&2; exit 1; }
done

WORK="$(mktemp -d "${TMPDIR:-/tmp}/riina-metrics-fallback.XXXXXX")"
trap 'rm -rf "${WORK:?}"' EXIT
CLONE="$WORK/repo"
git clone -q --shared "$REPO_ROOT" "$CLONE"
cp "$GENERATOR" "$CLONE/scripts/generate-metrics.sh"

METRICS="$CLONE/website/public/metrics.json"
REPORT="$CLONE/reports/noncoq_mechanized_status.json"
FAILURES=0

fail() { echo "  FAIL: $*"; FAILURES=$((FAILURES + 1)); }

generate() {
    # No smoke tool is reachable unless a scenario provides one explicitly.
    (cd "$CLONE" && env -u TLA2TOOLS_JAR -u ALLOY_JAR "$@" \
        bash scripts/generate-metrics.sh --fast >"$WORK/generate.log" 2>&1) \
        || { cat "$WORK/generate.log"; echo "FAIL: generate-metrics.sh exited non-zero" >&2; exit 1; }
}

reset_clone() {
    git -C "$CLONE" checkout -q -- website/public/metrics.json reports/noncoq_mechanized_status.json
}

make_report_stale() {
    # A commit that does not exist: the report cannot vouch for this tree.
    jq '.repo_head = "0000000000000000000000000000000000000000"' "$REPORT" >"$WORK/report.json"
    mv "$WORK/report.json" "$REPORT"
}

inflate_cached_metrics() {
    # The worst cached state: every lane claimed mechanized, quality flags set,
    # SMT "nothing pending", and smoke passes recorded for every smoke lane.
    python3 - "$METRICS" <<'PY'
import json, sys
path = sys.argv[1]
d = json.load(open(path))
lanes = ("lean", "isabelle", "fstar", "tlaplus", "alloy", "smt", "verus", "kani", "tv")
for lane in lanes:
    d["claimLevels"][lane] = "mechanized"
for lane in lanes[2:]:
    d["quality"][f"{lane}Status"] = "mechanized"
d["quality"]["leanCompiled"] = True
d["quality"]["isabelleCompiled"] = True
nm = d["quality"]["nonCoqMechanization"]
nm["overallMechanized"] = True
nm["pending"]["smt"] = "none"
d["isabelle"].update(smokeBuildOk=True, compiledTheories=3, compiledLemmas=9)
d["fstar"].update(smokeBuildOk=True, compiledLemmas=3)
d["tlaplus"].update(smokeBuildOk=True, compiledTheorems=5)
d["alloy"].update(smokeBuildOk=True, compiledAssertions=6)
json.dump(d, open(path, "w"), indent=2)
PY
}

assert_no_noncoq_claims() {
    # Mirrors the claim-integrity rule of scripts/public-quality-gates.sh:
    # without a fresh non-Coq report, no non-Coq claim may exceed "generated".
    local label="$1" out
    if ! out="$(python3 - "$METRICS" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
q, cl = d["quality"], d["claimLevels"]
nm = q["nonCoqMechanization"]
low = {"generated", "retired"}
errors = []
for lane in ("lean", "isabelle", "fstar", "tlaplus", "alloy", "smt", "verus", "kani", "tv"):
    if cl.get(lane) not in low:
        errors.append(f"claimLevels.{lane}={cl.get(lane)}")
for lane in ("fstar", "tlaplus", "alloy", "smt", "verus", "kani", "tv"):
    if q.get(f"{lane}Status") not in low:
        errors.append(f"quality.{lane}Status={q.get(lane + 'Status')}")
for flag in ("leanCompiled", "isabelleCompiled"):
    if q.get(flag) is not False:
        errors.append(f"quality.{flag}={q.get(flag)}")
if cl.get("overall") != "generated":
    errors.append(f"claimLevels.overall={cl.get('overall')}")
if nm.get("reportFresh") is not False or nm.get("overallMechanized") is not False:
    errors.append(f"reportFresh={nm.get('reportFresh')} overallMechanized={nm.get('overallMechanized')}")
if nm.get("source") != "cached_metrics":
    errors.append(f"source={nm.get('source')}")
if nm["pending"].get("smt") == "none":
    errors.append("pending.smt=none for a lane with no fresh report")
print("\n".join(errors))
sys.exit(1 if errors else 0)
PY
    )"; then
        while IFS= read -r line; do fail "$label: $line"; done <<<"$out"
    fi
}

echo "1. Stale report + inflated cached metrics: no claim survives"
reset_clone
make_report_stale
inflate_cached_metrics
generate
assert_no_noncoq_claims "first fast run"
# Unobserved smoke results stay as descriptive data, never as claims.
[ "$(jq -r '.alloy.smokeBuildOk' "$METRICS")" = true ] \
    || fail "unobserved Alloy smoke result was not carried forward"
generate
assert_no_noncoq_claims "second fast run (self-reinforcement)"

echo "2. A smoke check observed failing beats a cached smoke pass"
reset_clone
make_report_stale
inflate_cached_metrics
mkdir -p "$WORK/fakebin"
printf '#!/bin/sh\nexit 1\n' >"$WORK/fakebin/java"
chmod +x "$WORK/fakebin/java"
: >"$WORK/alloy.jar"
generate ALLOY_JAR="$WORK/alloy.jar" PATH="$WORK/fakebin:$PATH"
assert_no_noncoq_claims "observed smoke failure"
[ "$(jq -r '.alloy.smokeBuildOk' "$METRICS")" = false ] \
    || fail "cached Alloy smoke pass masked an observed failure"
[ "$(jq -r '.alloy.compiledAssertions' "$METRICS")" = 0 ] \
    || fail "cached Alloy compiledAssertions masked an observed failure"

echo "3. Freshness rule matches the public gate"
reset_clone
lane_commit() {
    git -C "$CLONE" add -- "$1"
    git -C "$CLONE" -c user.name=riina-test -c user.email=riina-test@invalid \
        commit -q -m "test: $1" -- "$1"
}
# Stamp the report at this HEAD, then add two commits so the report head is
# neither HEAD nor HEAD^ and the content comparison decides.
jq --arg head "$(git -C "$CLONE" rev-parse HEAD)" '.repo_head = $head' "$REPORT" >"$WORK/report.json"
mv "$WORK/report.json" "$REPORT"
echo "note" >"$CLONE/02_FORMAL/alloy/FALLBACK_TEST.md"; lane_commit 02_FORMAL/alloy/FALLBACK_TEST.md
echo "note 2" >>"$CLONE/02_FORMAL/alloy/FALLBACK_TEST.md"; lane_commit 02_FORMAL/alloy/FALLBACK_TEST.md
generate
expected_smt="$(jq -r 'if .lanes.smt.mechanized_ready == true then "mechanized" elif .lanes.smt.full_exec_ok == true then "compiled" else "generated" end' "$REPORT")"
[ "$(jq -r '.quality.nonCoqMechanization.source' "$METRICS")" = strict_report ] \
    || fail "markdown-only lane change made the report stale (gate calls it fresh)"
[ "$(jq -r '.claimLevels.smt' "$METRICS")" = "$expected_smt" ] \
    || fail "strict report verdict for SMT not published (expected $expected_smt)"
echo "x" >"$CLONE/02_FORMAL/alloy/FALLBACK_TEST.als"; lane_commit 02_FORMAL/alloy/FALLBACK_TEST.als
generate
[ "$(jq -r '.quality.nonCoqMechanization.reportFresh' "$METRICS")" = false ] \
    || fail "a lane code change left the report fresh"
assert_no_noncoq_claims "lane code change after the report"

if [ "$FAILURES" -gt 0 ]; then
    echo "FAILED: $FAILURES assertion(s)"
    exit 1
fi
echo "PASS: generate-metrics non-Coq claim path"
