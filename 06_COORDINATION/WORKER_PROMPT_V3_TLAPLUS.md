# WORKER V3: TLA+ Verification Build

**Mission:** Run TLC model checker on all 267 TLA+ specs, fix any errors, dequarantine the lane.

**Use an 8-core (or higher) GitHub Codespace for this work.**

---

## SETUP

```bash
# 1. Provision TLA2Tools
bash scripts/provision-smoke-toolchains.sh

# 2. Set environment
TLA2TOOLS="/workspaces/proof/05_TOOLING/tools/formal/tla2tools.jar"

# 3. Verify installation
java -jar "$TLA2TOOLS" -h 2>&1 | head -3   # Should show TLC usage
```

---

## BUILD

TLA+ verification has two levels:

### Level 1: Parse check (all files)

```bash
# SANY parse check — verifies syntax and module structure
pass=0; fail=0
for f in $(find 02_FORMAL/tlaplus/RIINA -name "*.tla" -type f | sort); do
  result=$(timeout 30 java -cp "$TLA2TOOLS" tla2sany.SANY "$f" 2>&1)
  if echo "$result" | grep -q "error\|Error\|Abort"; then
    fail=$((fail + 1))
    echo "FAIL: $(basename $f): $(echo "$result" | grep -m1 'error\|Error' | head -c 100)"
  else
    pass=$((pass + 1))
  fi
done
echo "SANY parse: pass=$pass fail=$fail"
```

### Level 2: TLC model check (files with .cfg)

```bash
# TLC model check — only for specs that have a .cfg file
for cfg in $(find 02_FORMAL/tlaplus/RIINA -name "*.cfg" -type f | sort); do
  tla="${cfg%.cfg}.tla"
  if [ -f "$tla" ]; then
    dir=$(dirname "$tla")
    base=$(basename "$tla" .tla)
    echo "Checking: $base"
    result=$(cd "$dir" && timeout 300 java -jar "$TLA2TOOLS" -workers auto -config "$(basename $cfg)" "$base" 2>&1)
    if echo "$result" | grep -q "Error\|error\|violation"; then
      echo "  FAIL: $(echo "$result" | grep -m1 'Error\|error\|violation')"
    else
      echo "  PASS"
    fi
  fi
done
```

---

## FIX-VERIFY LOOP

If files fail:

1. Read the failing `.tla` file and error message
2. Fix the error — common patterns:
   - Missing `====` at end of file
   - Missing `---- MODULE Name ----` header
   - Wrong `EXTENDS` (reference nonexistent modules)
   - Operator defined with `=` instead of `==`
   - `THEOREM` without `PROOF` clause — add `OBVIOUS` or `BY DEF ...`
   - `CONSTANT` referenced but not declared
   - Syntax: `\A x \in S : P(x)` not `forall x in S, P(x)`
3. Rebuild
4. Repeat until all pass SANY parse check

**NEVER** delete theorems to make files pass — fix them instead.

---

## DEQUARANTINE

Once all files pass SANY and active specs pass TLC:

```bash
# 1. Remove quarantine
rm 02_FORMAL/tlaplus/.STUB_QUARANTINED

# 2. Regenerate noncoq report
PATH="$HOME/.elan/bin:$PATH" bash scripts/check-noncoq-mechanized.sh 2>&1 | grep TLA
# Should show: TLA+ mechanized : 1

# 3. Fix JSON
python3 -c "
import json
with open('reports/noncoq_mechanized_status.json') as f:
    d = json.loads(f.read(), strict=False)
with open('reports/noncoq_mechanized_status.json', 'w') as f:
    json.dump(d, f, indent=2)
    f.write('\n')
"

# 4. Commit
git add 02_FORMAL/tlaplus/ reports/noncoq_mechanized_status.json
git commit -m "[TRACK_A] PROOF: Dequarantine TLA+ — full SANY+TLC verification (267 specs)

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
git push origin main
```

---

## FILE OWNERSHIP

You ONLY touch: `02_FORMAL/tlaplus/`

Do NOT touch any other `02_FORMAL/` subdirectory or `03_PROTO/`.

---

## DETAILS

- 267 `.tla` files across Foundations/, TypeSystem/, Effects/, Properties/, Domains/, Industries/, Termination/, Active/
- 6 active specs with `.cfg` files in `Active/`: RIINAEffectTracking, RIINATypeSafety, TelusProcurementProtocol
- SANY = Syntactic Analyzer (parse check). TLC = Temporal Logic Checker (model check)
- TLA2Tools JAR version: 1.7.4
- `EXTENDS Naturals, FiniteSets, Sequences` are standard modules
- Module name must match filename: `---- MODULE Typing ----` for `Typing.tla`

## SUCCESS CRITERIA

All 267 `.tla` files pass SANY parse check.
All 6 active specs (with `.cfg`) pass TLC model check.
