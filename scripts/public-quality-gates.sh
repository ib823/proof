#!/usr/bin/env bash
# ============================================================================
# public-quality-gates.sh
#
# Gold-standard public repo checks for RIINA.
#
# Usage:
#   bash scripts/public-quality-gates.sh
#
# Exit codes:
#   0 - pass
#   1 - fail
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPORT_PATH="$REPO_ROOT/reports/public_quality_status.json"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

OVERALL="PASS"

ARTIFACT_STATUS="PASS"
ARTIFACT_DETAIL=""
GITIGNORE_STATUS="PASS"
GITIGNORE_DETAIL=""
DOCS_STATUS="PASS"
DOCS_DETAIL=""
DOC_DRIFT_STATUS="PASS"
DOC_DRIFT_DETAIL=""
LEDGER_STATUS="PASS"
LEDGER_DETAIL=""
HYGIENE_STATUS="PASS"
HYGIENE_DETAIL=""
METRICS_STATUS="PASS"
METRICS_DETAIL=""
VERSION_STATUS="PASS"
VERSION_DETAIL=""
CLAIM_INTEGRITY_STATUS="PASS"
CLAIM_INTEGRITY_DETAIL=""
AUDIT_READINESS_STATUS="PASS"
AUDIT_READINESS_DETAIL=""

escape_json() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

echo ""
echo "================================================================"
echo "  RIINA PUBLIC QUALITY GATES"
echo "================================================================"

# ---------------------------------------------------------------------------
# 1) No tracked build artifacts
# ---------------------------------------------------------------------------

artifact_hits="$(git ls-files | grep -E '\.aux$|\.glob$|\.vo$|\.vos$|\.vok$|\.lia\.cache$|\.nia\.cache$|\.crashcoqide$' || true)"
artifact_count="$(printf '%s\n' "$artifact_hits" | sed '/^$/d' | wc -l | tr -d ' ')"
if [ "$artifact_count" -gt 0 ]; then
  ARTIFACT_STATUS="FAIL"
  ARTIFACT_DETAIL="tracked_artifacts=$artifact_count"
  OVERALL="FAIL"
else
  ARTIFACT_STATUS="PASS"
  ARTIFACT_DETAIL="tracked_artifacts=0"
fi

# ---------------------------------------------------------------------------
# 2) .gitignore contains critical Coq artifact patterns
# ---------------------------------------------------------------------------

missing_gitignore=0
for pattern in '*.aux' '*.glob' '*.vo' '*.vos' '*.vok' '.lia.cache' '.nia.cache' '*.crashcoqide'; do
  if ! grep -Fq "$pattern" "$REPO_ROOT/.gitignore"; then
    missing_gitignore=$((missing_gitignore + 1))
  fi
done
if [ "$missing_gitignore" -gt 0 ]; then
  GITIGNORE_STATUS="FAIL"
  GITIGNORE_DETAIL="missing_patterns=$missing_gitignore"
  OVERALL="FAIL"
else
  GITIGNORE_STATUS="PASS"
  GITIGNORE_DETAIL="missing_patterns=0"
fi

# ---------------------------------------------------------------------------
# 3) Required public trust docs exist
# ---------------------------------------------------------------------------

missing_docs=0
for f in README.md SECURITY.md AXIOMS.md PROOF_STATUS.md VERSION; do
  if [ ! -f "$REPO_ROOT/$f" ]; then
    missing_docs=$((missing_docs + 1))
  fi
done
if [ "$missing_docs" -gt 0 ]; then
  DOCS_STATUS="FAIL"
  DOCS_DETAIL="missing_docs=$missing_docs"
  OVERALL="FAIL"
else
  DOCS_STATUS="PASS"
  DOCS_DETAIL="missing_docs=0"
fi

# ---------------------------------------------------------------------------
# 3b) Public-doc drift guards (high-visibility active-build claims)
# ---------------------------------------------------------------------------

drift_hits=0
for check in \
  "README.md::policy axiom|1 \\(policy\\)|1 axiom|4 justified axioms|4,885|4885" \
  "docs/UNDERSTANDING_RIINA.md::4 justified axioms|4,885|4885|249 active proof files" \
  "docs/enterprise/COMPLIANCE_GUIDE.md::4,885|4885|4 justified axioms" \
  "docs/enterprise/COMPLIANCE_PACKAGING.md::4 justified axioms"; do
  file="${check%%::*}"
  pattern="${check##*::}"
  if [ -f "$REPO_ROOT/$file" ] && grep -Eq "$pattern" "$REPO_ROOT/$file"; then
    drift_hits=$((drift_hits + 1))
  fi
done

if [ "$drift_hits" -gt 0 ]; then
  DOC_DRIFT_STATUS="FAIL"
  DOC_DRIFT_DETAIL="stale_claim_files=$drift_hits"
  OVERALL="FAIL"
else
  DOC_DRIFT_STATUS="PASS"
  DOC_DRIFT_DETAIL="stale_claim_files=0"
fi

# ---------------------------------------------------------------------------
# 4) Proof ledgers up-to-date
# ---------------------------------------------------------------------------

if bash "$REPO_ROOT/scripts/update-proof-ledger.sh" --check >/dev/null 2>&1; then
  LEDGER_STATUS="PASS"
  LEDGER_DETAIL="ledger_status=up_to_date"
else
  LEDGER_STATUS="FAIL"
  LEDGER_DETAIL="ledger_status=stale"
  OVERALL="FAIL"
fi

# ---------------------------------------------------------------------------
# 5) Active-build proof hygiene from _CoqProject
# ---------------------------------------------------------------------------

COQ_DIR="$REPO_ROOT/02_FORMAL/coq"
COQ_PROJECT="$COQ_DIR/_CoqProject"

active_admitted=0
active_axioms=0
active_assumptions=0
active_qed=0
active_files=0

if [ -f "$COQ_PROJECT" ]; then
  mapfile -t active_coq_files < <(
    awk '
      {
        line=$0;
        sub(/^[ \t]+/, "", line);
        if (line ~ /^[#-]/ || line == "") next;
        split(line, tok, /[ \t]+/);
        if (tok[1] ~ /\.v$/) print tok[1];
      }
    ' "$COQ_PROJECT"
  )

  active_files="${#active_coq_files[@]}"
  for rel in "${active_coq_files[@]}"; do
    path="$COQ_DIR/$rel"
    [ -f "$path" ] || continue
    admitted_hits="$(grep -Ec '^[[:space:]]*Admitted\.' "$path" || true)"
    axiom_hits="$(grep -Ec '^[[:space:]]*Axiom[[:space:]]+' "$path" || true)"
    assumption_hits="$(grep -Ec '^[[:space:]]*Parameter[[:space:]]+val_rel_n_step_up[[:space:]]' "$path" || true)"
    qed_hits="$(grep -c 'Qed\.' "$path" || true)"
    active_admitted=$((active_admitted + admitted_hits))
    active_axioms=$((active_axioms + axiom_hits))
    active_assumptions=$((active_assumptions + assumption_hits))
    active_qed=$((active_qed + qed_hits))
  done
fi

if [ "$active_admitted" -eq 0 ] && [ "$active_axioms" -eq 0 ] && [ "$active_assumptions" -eq 0 ]; then
  HYGIENE_STATUS="PASS"
else
  HYGIENE_STATUS="FAIL"
  OVERALL="FAIL"
fi
HYGIENE_DETAIL="active_files=$active_files qed=$active_qed admitted=$active_admitted axioms=$active_axioms assumptions=$active_assumptions"

# ---------------------------------------------------------------------------
# 6) metrics.json alignment
# ---------------------------------------------------------------------------

metrics_admitted="NA"
metrics_axioms="NA"
metrics_assumptions="NA"
metrics_qed="NA"
metrics_active_files="NA"
metrics_file="$REPO_ROOT/website/public/metrics.json"
if [ -f "$metrics_file" ]; then
  metrics_admitted="$(grep -m1 -E '"admitted"[[:space:]]*:[[:space:]]*[0-9]+' "$metrics_file" | sed -E 's/[^0-9]*([0-9]+).*/\1/' || true)"
  metrics_axioms="$(grep -m1 -E '"axioms"[[:space:]]*:[[:space:]]*[0-9]+' "$metrics_file" | sed -E 's/[^0-9]*([0-9]+).*/\1/' || true)"
  metrics_assumptions="$(grep -m1 -E '"assumptions"[[:space:]]*:[[:space:]]*[0-9]+' "$metrics_file" | sed -E 's/[^0-9]*([0-9]+).*/\1/' || true)"
  metrics_qed="$(python3 -c "import json; print(json.load(open('$metrics_file'))['proofs']['qedActive'])" 2>/dev/null || echo "NA")"
  metrics_active_files="$(python3 -c "import json; print(json.load(open('$metrics_file'))['coq']['filesActive'])" 2>/dev/null || echo "NA")"
fi

if [ "$metrics_admitted" = "$active_admitted" ] \
  && [ "$metrics_axioms" = "$active_axioms" ] \
  && [ "$metrics_assumptions" = "$active_assumptions" ] \
  && [ "$metrics_qed" = "$active_qed" ] \
  && [ "$metrics_active_files" = "$active_files" ]; then
  METRICS_STATUS="PASS"
else
  METRICS_STATUS="FAIL"
  OVERALL="FAIL"
fi
METRICS_DETAIL="metrics_qed=$metrics_qed metrics_active_files=$metrics_active_files metrics_admitted=$metrics_admitted metrics_axioms=$metrics_axioms metrics_assumptions=$metrics_assumptions"

# ---------------------------------------------------------------------------
# 7) VERSION has a matching tag
# ---------------------------------------------------------------------------

version="$(tr -d ' \n' < "$REPO_ROOT/VERSION")"
if git rev-parse -q --verify "refs/tags/v$version" >/dev/null; then
  VERSION_STATUS="PASS"
  VERSION_DETAIL="version=$version tag=v$version"
else
  VERSION_STATUS="FAIL"
  VERSION_DETAIL="version=$version tag=v$version_missing"
  OVERALL="FAIL"
fi

# ---------------------------------------------------------------------------
# 8) Public claim integrity (website copy must match quality flags)
# ---------------------------------------------------------------------------

claim_bad_levels=0
claim_overclaim_ready="false"
claim_overall_level="generated"
claim_mismatch_count=0
claim_noncoq_report_fresh="false"
claim_phrase_hits=""

if [ -f "$metrics_file" ]; then
  claim_eval="$(
    python3 - "$metrics_file" "$REPO_ROOT/reports/noncoq_mechanized_status.json" "$(git -C "$REPO_ROOT" rev-parse HEAD 2>/dev/null || echo '')" "$(git -C "$REPO_ROOT" rev-parse HEAD^ 2>/dev/null || echo '')" "$REPO_ROOT" <<'PY'
import json
import subprocess
import sys

metrics_path = sys.argv[1]
report_path = sys.argv[2]
repo_head = sys.argv[3] if len(sys.argv) > 3 else ""
repo_parent_head = sys.argv[4] if len(sys.argv) > 4 else ""
repo_root = sys.argv[5] if len(sys.argv) > 5 else ""
d = json.load(open(metrics_path))
q = d.get("quality", {})
cl = d.get("claimLevels", {})
allowed = {"generated", "compiled", "mechanized", "independently_audited"}
keys = ["overall", "coq", "lean", "isabelle", "fstar", "tlaplus", "alloy", "smt", "verus", "kani", "tv"]
bad_levels = sum(1 for k in keys if cl.get(k, "generated") not in allowed)

rank = {"generated": 0, "compiled": 1, "mechanized": 2, "independently_audited": 3}

def norm(level):
    return level if level in rank else "generated"


def git_ok(*args):
    return subprocess.run(
        ["git", "-C", repo_root, *args],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    ).returncode == 0


def git_stdout(*args):
    proc = subprocess.run(
        ["git", "-C", repo_root, *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        return ""
    return proc.stdout


def report_head_matches_or_compatible(report_head, paths):
    if not report_head or not repo_head or not repo_root:
        return False
    if report_head == repo_head or (repo_parent_head and report_head == repo_parent_head):
        return True
    if not git_ok("merge-base", "--is-ancestor", report_head, repo_head):
        return False
    diff = git_stdout("diff", "--name-only", f"{report_head}..{repo_head}", "--", *paths)
    return not diff.strip()

quality_max = {
    "coq": "mechanized" if q.get("coqCompiled") is True else "generated",
    "lean": "compiled" if q.get("leanCompiled") is True else "generated",
    "isabelle": "compiled" if q.get("isabelleCompiled") is True else "generated",
    "fstar": norm(q.get("fstarStatus", "generated")),
    "tlaplus": norm(q.get("tlaplusStatus", "generated")),
    "alloy": norm(q.get("alloyStatus", "generated")),
    "smt": norm(q.get("smtStatus", "generated")),
    "verus": norm(q.get("verusStatus", "generated")),
    "kani": norm(q.get("kaniStatus", "generated")),
    "tv": norm(q.get("tvStatus", "generated")),
}
runtime_max = norm(q.get("runtimeProofStatus", "generated"))

report_fresh = False
report_max = {
    "lean": "generated",
    "isabelle": "generated",
    "fstar": "generated",
    "tlaplus": "generated",
    "alloy": "generated",
    "smt": "generated",
    "verus": "generated",
    "kani": "generated",
    "tv": "generated",
}
try:
    with open(report_path) as f:
        report = json.load(f)
    report_head = report.get("repo_head", "")
    report_fresh = report_head_matches_or_compatible(report_head, [
        "02_FORMAL/lean",
        "02_FORMAL/isabelle",
        "02_FORMAL/fstar",
        "02_FORMAL/tlaplus",
        "02_FORMAL/alloy",
        "02_FORMAL/smt",
        "02_FORMAL/verus",
        "02_FORMAL/kani",
        "02_FORMAL/tv",
        "05_TOOLING/tools/formal",
        "05_TOOLING/tools/isabelle",
        "05_TOOLING/tools/fstar",
        "scripts/check-noncoq-mechanized.sh",
        "scripts/check-heavy-closure.sh",
        "scripts/provision-formal-tools.sh",
        "scripts/provision-smoke-toolchains.sh",
        "scripts/provision-isabelle.sh",
        "scripts/provision-fstar.sh",
        "scripts/isabelle-local.sh",
        "scripts/fstar-local.sh",
    ])
    if report_fresh:
        lanes = report.get("lanes", {})
        for lane in ("lean", "isabelle"):
            lane_data = lanes.get(lane, {})
            lvl = "generated"
            if lane_data.get("full_build_ok") is True:
                lvl = "compiled"
            if lane_data.get("mechanized_ready") is True:
                lvl = "mechanized"
            report_max[lane] = lvl
        for lane in ("fstar", "tlaplus", "alloy", "smt", "verus", "kani", "tv"):
            lane_data = lanes.get(lane, {})
            lvl = "generated"
            if lane_data.get("full_exec_ok") is True:
                lvl = "compiled"
            if lane_data.get("mechanized_ready") is True:
                lvl = "mechanized"
            report_max[lane] = lvl
except Exception:
    report_fresh = False

mismatch_count = 0

for lane in ("coq", "lean", "isabelle", "fstar", "tlaplus", "alloy", "smt", "verus", "kani", "tv"):
    claim = norm(cl.get(lane, "generated"))
    if lane == "coq":
        max_level = quality_max.get("coq", "generated")
        if rank[claim] > rank[max_level]:
            mismatch_count += 1
    else:
        if report_fresh:
            if rank[claim] > rank[report_max.get(lane, "generated")]:
                mismatch_count += 1
        else:
            # Without a fresh non-Coq report, non-Coq claims must stay generated.
            if rank[claim] > rank["generated"]:
                mismatch_count += 1

claim_runtime = norm(cl.get("runtimeProofArchitecture", "generated"))
if rank[claim_runtime] > rank[runtime_max]:
    mismatch_count += 1

noncoq_lanes = ("lean", "isabelle", "fstar", "tlaplus", "alloy", "smt", "verus", "kani", "tv")
if report_fresh:
    all_noncoq_compiled = all(rank[report_max[l]] >= rank["compiled"] for l in noncoq_lanes)
    all_noncoq_mechanized = all(rank[report_max[l]] >= rank["mechanized"] for l in noncoq_lanes)
else:
    all_noncoq_compiled = False
    all_noncoq_mechanized = False
coq_mechanized = rank[quality_max["coq"]] >= rank["mechanized"]
runtime_compiled = rank[runtime_max] >= rank["compiled"]
runtime_mechanized = rank[runtime_max] >= rank["mechanized"]

overall_max = "generated"
if coq_mechanized and all_noncoq_mechanized and runtime_mechanized:
    overall_max = "mechanized"
elif coq_mechanized and all_noncoq_compiled and runtime_compiled:
    overall_max = "compiled"

claim_overall = norm(cl.get("overall", "generated"))
if rank[claim_overall] > rank[overall_max]:
    mismatch_count += 1

if bool(cl.get("independentlyAudited")):
    if claim_overall != "independently_audited":
        mismatch_count += 1
else:
    if claim_overall == "independently_audited":
        mismatch_count += 1

overclaim_ready = bool(cl.get("independentlyAudited")) and claim_overall == "independently_audited" and mismatch_count == 0

print(f"bad_levels={bad_levels}")
print(f"overclaim_ready={'true' if overclaim_ready else 'false'}")
print(f"overall={claim_overall}")
print(f"mismatch_count={mismatch_count}")
print(f"noncoq_report_fresh={'true' if report_fresh else 'false'}")
PY
  )"
  claim_bad_levels="$(printf '%s\n' "$claim_eval" | awk -F= '/^bad_levels=/{print $2}' | tail -1)"
  claim_overclaim_ready="$(printf '%s\n' "$claim_eval" | awk -F= '/^overclaim_ready=/{print $2}' | tail -1)"
  claim_overall_level="$(printf '%s\n' "$claim_eval" | awk -F= '/^overall=/{print $2}' | tail -1)"
  claim_mismatch_count="$(printf '%s\n' "$claim_eval" | awk -F= '/^mismatch_count=/{print $2}' | tail -1)"
  claim_noncoq_report_fresh="$(printf '%s\n' "$claim_eval" | awk -F= '/^noncoq_report_fresh=/{print $2}' | tail -1)"
fi

if [ "$claim_overclaim_ready" != "true" ]; then
  claim_phrase_hits="$(
    grep -RInE \
      'independently verified across|independently proved across|shared prover bug is virtually zero|compiler itself is verified|ALL COMPLETE|full stack verification|100% complete' \
      "$REPO_ROOT/website/src/RiinaWebsite.jsx" \
      "$REPO_ROOT/website/public/metrics.json" \
      "$REPO_ROOT/website/index.html" \
      2>/dev/null || true
  )"
fi

if [ "${claim_bad_levels:-0}" -gt 0 ] || [ "${claim_mismatch_count:-0}" -gt 0 ] || [ -n "$claim_phrase_hits" ]; then
  CLAIM_INTEGRITY_STATUS="FAIL"
  CLAIM_INTEGRITY_DETAIL="overall=$claim_overall_level bad_levels=${claim_bad_levels:-0} mismatches=${claim_mismatch_count:-0} report_fresh=${claim_noncoq_report_fresh:-false} overclaim_phrases=$([ -n "$claim_phrase_hits" ] && echo 1 || echo 0)"
  OVERALL="FAIL"
else
  CLAIM_INTEGRITY_STATUS="PASS"
  CLAIM_INTEGRITY_DETAIL="overall=$claim_overall_level bad_levels=${claim_bad_levels:-0} mismatches=0 report_fresh=${claim_noncoq_report_fresh:-false} overclaim_phrases=0"
fi

# ---------------------------------------------------------------------------
# 9) Independent-audit claim readiness (must be backed by heavy closure report)
# ---------------------------------------------------------------------------

independent_claim="false"
if [ -f "$metrics_file" ] && command -v jq >/dev/null 2>&1; then
  independent_claim="$(jq -r '.claimLevels.independentlyAudited // false' "$metrics_file" 2>/dev/null || echo "false")"
fi

if [ "$independent_claim" = "true" ]; then
  heavy_closure_report="$REPO_ROOT/reports/heavy_closure_status.json"
  heavy_ready="false"
  if [ -f "$heavy_closure_report" ] && command -v jq >/dev/null 2>&1; then
    if jq -e '.overall_closure_ready == true' "$heavy_closure_report" >/dev/null 2>&1; then
      heavy_ready="true"
    fi
  fi

  if [ "$heavy_ready" = "true" ]; then
    AUDIT_READINESS_STATUS="PASS"
    AUDIT_READINESS_DETAIL="independent_claim=true heavy_closure_ready=true"
  else
    AUDIT_READINESS_STATUS="FAIL"
    AUDIT_READINESS_DETAIL="independent_claim=true heavy_closure_ready=false"
    OVERALL="FAIL"
  fi
else
  AUDIT_READINESS_STATUS="PASS"
  AUDIT_READINESS_DETAIL="independent_claim=false"
fi

# ---------------------------------------------------------------------------
# Report and exit
# ---------------------------------------------------------------------------

mkdir -p "$REPO_ROOT/reports"
cat > "$REPORT_PATH" <<EOF
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "artifact_hygiene": { "status": "$ARTIFACT_STATUS", "detail": "$(escape_json "$ARTIFACT_DETAIL")" },
  "gitignore_coverage": { "status": "$GITIGNORE_STATUS", "detail": "$(escape_json "$GITIGNORE_DETAIL")" },
  "required_docs": { "status": "$DOCS_STATUS", "detail": "$(escape_json "$DOCS_DETAIL")" },
  "public_doc_drift": { "status": "$DOC_DRIFT_STATUS", "detail": "$(escape_json "$DOC_DRIFT_DETAIL")" },
  "proof_ledger_freshness": { "status": "$LEDGER_STATUS", "detail": "$(escape_json "$LEDGER_DETAIL")" },
  "active_build_hygiene": { "status": "$HYGIENE_STATUS", "detail": "$(escape_json "$HYGIENE_DETAIL")" },
  "metrics_alignment": { "status": "$METRICS_STATUS", "detail": "$(escape_json "$METRICS_DETAIL")" },
  "version_tag_alignment": { "status": "$VERSION_STATUS", "detail": "$(escape_json "$VERSION_DETAIL")" },
  "claim_integrity": { "status": "$CLAIM_INTEGRITY_STATUS", "detail": "$(escape_json "$CLAIM_INTEGRITY_DETAIL")" },
  "independent_audit_readiness": { "status": "$AUDIT_READINESS_STATUS", "detail": "$(escape_json "$AUDIT_READINESS_DETAIL")" },
  "overall": "$OVERALL"
}
EOF

echo ""
echo "Artifact hygiene      : $ARTIFACT_STATUS"
echo "Gitignore coverage    : $GITIGNORE_STATUS"
echo "Required docs         : $DOCS_STATUS"
echo "Public doc drift      : $DOC_DRIFT_STATUS"
echo "Proof ledger freshness: $LEDGER_STATUS"
echo "Active-build hygiene  : $HYGIENE_STATUS"
echo "Metrics alignment     : $METRICS_STATUS"
echo "Version/tag alignment : $VERSION_STATUS"
echo "Claim integrity       : $CLAIM_INTEGRITY_STATUS"
echo "Audit readiness       : $AUDIT_READINESS_STATUS"
echo "Report                : $REPORT_PATH"

if [ "$OVERALL" = "PASS" ]; then
  echo -e "${GREEN}Public quality gates passed.${NC}"
  exit 0
fi

echo -e "${RED}Public quality gates failed.${NC}"
echo -e "${YELLOW}Review $REPORT_PATH and resolve failures before public sync.${NC}"
exit 1
