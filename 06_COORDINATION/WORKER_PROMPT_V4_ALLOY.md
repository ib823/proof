# WORKER V4: Alloy Verification Build

**Mission:** Run Alloy analyzer on all 260 models, fix any errors, dequarantine the lane.

**Use an 8-core (or higher) GitHub Codespace for this work.**

---

## SETUP

```bash
# 1. Provision Alloy
bash scripts/provision-smoke-toolchains.sh

# 2. Set environment
ALLOY_JAR="/workspaces/proof/05_TOOLING/tools/formal/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar"

# 3. Verify installation
java -jar "$ALLOY_JAR" --help 2>&1 | head -3
```

---

## BUILD

Alloy verification runs in two levels:

### Level 1: Parse check (all files)

```bash
# Parse and typecheck all .als files
pass=0; fail=0
for f in $(find 02_FORMAL/alloy/RIINA -name "*.als" -type f | sort); do
  result=$(timeout 60 java -jar "$ALLOY_JAR" -c "$f" 2>&1)
  if echo "$result" | grep -q "error\|Error\|Exception"; then
    fail=$((fail + 1))
    echo "FAIL: $(basename $f)"
  else
    pass=$((pass + 1))
  fi
done
echo "Alloy parse: pass=$pass fail=$fail"
```

### Level 2: Assertion checking (active models)

```bash
# Check assertions in active models
for f in 02_FORMAL/alloy/RIINA/Active/*.als; do
  echo "Checking: $(basename $f)"
  result=$(timeout 300 java -jar "$ALLOY_JAR" -c "$f" 2>&1)
  echo "$result" | tail -5
done
```

---

## FIX-VERIFY LOOP

If files fail:

1. Read the failing `.als` file and error message
2. Fix the error — common patterns:
   - `module` path doesn't match file location
   - `sig` extends nonexistent parent
   - `assert` references undefined `pred` or `fun`
   - Quantifier syntax: `all x: Type | ...` not `forall x : Type, ...`
   - Alloy 6 uses `var` for mutable fields (not all models need this)
   - `check` scope too large — reduce to `for 5` or `for 3`
   - `one sig` vs `sig` — singletons need `one`
   - `fact` bodies must be first-order logic (no higher-order)
3. Rebuild
4. Repeat until all pass

**NEVER** delete assertions to make files pass — fix them instead.

---

## DEQUARANTINE

Once all files pass:

```bash
# 1. Remove quarantine
rm 02_FORMAL/alloy/.STUB_QUARANTINED

# 2. Regenerate noncoq report
PATH="$HOME/.elan/bin:$PATH" bash scripts/check-noncoq-mechanized.sh 2>&1 | grep Alloy
# Should show: Alloy mechanized : 1

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
git add 02_FORMAL/alloy/ reports/noncoq_mechanized_status.json
git commit -m "[TRACK_A] PROOF: Dequarantine Alloy — full verification (260 models)

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
git push origin main
```

---

## FILE OWNERSHIP

You ONLY touch: `02_FORMAL/alloy/`

Do NOT touch any other `02_FORMAL/` subdirectory or `03_PROTO/`.

---

## DETAILS

- 260 `.als` files across Foundations/, TypeSystem/, Properties/, Domains/, Industries/, Termination/, Active/
- 3 active models in `Active/`: RIINAEffectSystem, RIINASecurityLattice, TelusProcurementAccessControl
- Alloy 6.2.0 (supports `var` fields, temporal logic)
- All models have `check` commands with bounded scope
- `run` finds instances, `check` verifies assertions (finds counterexamples)
- A `check` that finds no counterexample within scope = assertion holds for that bound
- Module names use `/` not `.`: `module riina/foundations/Typing`

## SUCCESS CRITERIA

All 260 `.als` files parse and typecheck with Alloy analyzer.
All 3 active models pass assertion checks within bounded scope.
