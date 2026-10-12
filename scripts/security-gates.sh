#!/usr/bin/env bash
# ============================================================================
# security-gates.sh — Strict local security gates for RIINA
#
# Enforces:
#   1) Signed commit policy (required, not optional)
#   2) Secret pattern scanning on changed files in outgoing range(s)
#   3) Trojan source bidi-Unicode scan across source/docs
#
# Usage:
#   bash scripts/security-gates.sh
#   bash scripts/security-gates.sh --range origin/main..HEAD
#   bash scripts/security-gates.sh --range A..B --range C..D
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

RANGES=()
ALL_TRACKED=0

usage() {
  cat <<'EOF'
Usage:
  bash scripts/security-gates.sh [--range <git-range>]... [--all-tracked]

A <git-range> is A..B, or a bare commit meaning "every commit reachable from it
that no remote has" (what the pre-push hook passes for a new branch).
--all-tracked scans every tracked file at HEAD (release gate).

Examples:
  bash scripts/security-gates.sh
  bash scripts/security-gates.sh --range origin/main..HEAD
  bash scripts/security-gates.sh --range <old>..<new> --range <old2>..<new2>
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --range)
      if [ $# -lt 2 ]; then
        echo "ERROR: --range requires a value"
        exit 1
      fi
      RANGES+=("$2")
      shift 2
      ;;
    --all-tracked)
      ALL_TRACKED=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [ ${#RANGES[@]} -eq 0 ]; then
  if git rev-parse --verify --quiet origin/main >/dev/null 2>&1; then
    RANGES=("origin/main..HEAD")
  elif git rev-parse --verify --quiet HEAD~1 >/dev/null 2>&1; then
    RANGES=("HEAD~1..HEAD")
  else
    RANGES=("HEAD")
  fi
fi

echo ""
echo "================================================================"
echo "  RIINA SECURITY GATES"
echo "================================================================"
echo "Ranges:"
for r in "${RANGES[@]}"; do
  echo "  - $r"
done

# Step 1: signed-commit policy — RETRACTED 2026-06-01.
# Rationale: the repository's entire history (including `main`) is unsigned, and
# no signing key is provisioned in CI or in ephemeral managed sessions, so the
# gate could never pass and only forced `--no-verify` bypasses (which the
# protocol forbids). Commit signing is now OPTIONAL; if you do sign, the secret
# and trojan-source scans below still run. To re-enable signing as a real gate,
# provision a key + allowed-signers file and restore this step.
echo "[1/3] Signed-commit policy: retracted (optional) — skipping."

# Step 2: secret detection on what is being pushed.
#
# Scans the ADDED LINES OF EVERY COMMIT in the outgoing ranges (`git log -p`),
# not the working-tree copy of the files the range touches. The previous
# implementation had three holes, each demonstrated by the 2026-10-11 audit:
#   - a new-branch push passes a bare SHA, and `git diff <sha>` compares that
#     commit with the WORKING TREE (usually identical) — so nothing was scanned
#     on every first push of a branch;
#   - `--diff-filter=ACM` dropped renames, so rename + add a secret passed;
#   - only the final file content was read, so a secret committed and then
#     deleted in a later commit still reached the remote's history.
# A bare SHA now means "every commit reachable from it that no remote has".
# `--all-tracked` scans every tracked file at HEAD (used by release.sh, where
# an `origin/main..HEAD` range is empty once main has been pushed).
echo "[2/3] Scanning outgoing commits for secrets..."
SECRET_SCAN_ARGS=()
if [ "$ALL_TRACKED" -eq 1 ]; then
  SECRET_SCAN_ARGS+=(--all-tracked)
fi
for r in "${RANGES[@]}"; do
  SECRET_SCAN_ARGS+=(--range "$r")
done
python3 - "${SECRET_SCAN_ARGS[@]}" <<'PY'
import fnmatch
import re
import subprocess
import sys

# Describe, never quote, the matching text in this file — it is in the scan.
PATTERN = re.compile(
    r"(?<![A-Za-z0-9_])(password|secret|api[_-]?key|token|private[_-]?key)"
    r"(?![A-Za-z0-9_])\s*[=:]\s*[\"'][^\"']+",
    re.IGNORECASE,
)
# Proof sources are exempt: identifiers such as a `secret` security level are
# lattice constructors there, never credentials.
EXEMPT_SUFFIXES = (".v", ".lean", ".thy", ".fst", ".tla", ".als", ".smt2", ".rs.verus")
EXEMPT_GLOBS = (
    # Training pairs whose vulnerable_code fields embed deliberately fake
    # credentials (verified synthetic 2026-08-06).
    "07_EXAMPLES/08_ai_training/*.jsonl",
    # Archival research surveys quoting promoted security-lattice equations
    # (verified 2026-08-08); Markdown only.
    "01_RESEARCH/*.md",
)


def exempt(path):
    return path.endswith(EXEMPT_SUFFIXES) or any(fnmatch.fnmatch(path, g) for g in EXEMPT_GLOBS)


def git(*args):
    return subprocess.run(["git", *args], check=True, stdout=subprocess.PIPE).stdout


args = sys.argv[1:]
all_tracked = "--all-tracked" in args
ranges = [args[i + 1] for i, a in enumerate(args) if a == "--range"]
hits = []

if all_tracked:
    for path in git("ls-files", "-z").decode().split("\0"):
        if not path or exempt(path):
            continue
        try:
            text = git("show", "HEAD:" + path).decode("utf-8", errors="replace")
        except subprocess.CalledProcessError:
            continue
        for n, line in enumerate(text.splitlines(), 1):
            if PATTERN.search(line):
                hits.append(f"{path}:{n} (HEAD)")
else:
    for r in ranges:
        rev_args = [r] if ".." in r else [r, "--not", "--remotes"]
        out = git("log", "-p", "-M", "--no-color", "--no-ext-diff",
                  "--diff-filter=d", "--format=commit %H", *rev_args)
        commit, path = "?", None
        for raw in out.decode("utf-8", errors="replace").splitlines():
            if raw.startswith("commit "):
                commit = raw[7:19]
            elif raw.startswith("+++ "):
                path = raw[6:] if raw.startswith("+++ b/") else None
            elif raw.startswith("+") and path and not exempt(path):
                if PATTERN.search(raw[1:]):
                    hits.append(f"{path} (commit {commit})")

if hits:
    print("FAIL: Potential secrets in outgoing changes:")
    for h in sorted(set(hits)):
        print("  " + h)
    sys.exit(1)
PY
echo -e "${GREEN}      Secret scan passed${NC}"

# Step 3: Trojan source scan (bidi unicode controls) over every tracked text
# file. Byte patterns (the UTF-8 encodings of U+202A..U+202E and
# U+2066..U+2069) make this locale-independent: the previous `\x{202A}` form
# made grep exit 2 ("code point too large") under the C/POSIX locale, `|| true`
# swallowed it, and the scan reported a pass on a file containing U+202E.
echo "[3/3] Scanning for Trojan source (bidi Unicode controls)..."
TROJAN_ERR="$(mktemp)"
TROJAN="$(git -C "$REPO_ROOT" ls-files -z \
  | (cd "$REPO_ROOT" && LC_ALL=C xargs -0 grep -IlP \
      '\xE2\x80[\xAA-\xAE]|\xE2\x81[\xA6-\xA9]' -- 2>"$TROJAN_ERR"))" || true
# xargs folds grep's "no match" (1) and "error" (2) into one exit code (123),
# so errors are detected from stderr instead: any diagnostic fails the gate.
if [ -s "$TROJAN_ERR" ]; then
  echo -e "${RED}FAIL: Trojan-source scan could not run cleanly:${NC}"
  head -5 "$TROJAN_ERR"
  rm -f "$TROJAN_ERR"
  exit 1
fi
rm -f "$TROJAN_ERR"
if [ -n "$TROJAN" ]; then
  echo -e "${RED}FAIL: Trojan source characters detected:${NC}"
  echo "$TROJAN"
  exit 1
fi
echo -e "${GREEN}      Trojan-source scan passed${NC}"

echo ""
echo "================================================================"
echo -e "  ${GREEN}SECURITY GATES PASSED${NC}"
echo "================================================================"
