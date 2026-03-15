# WORKER V2: F* Verification Build

**Mission:** Run full F* compilation across all 265 files, fix any errors, dequarantine the lane.

**Use an 8-core (or higher) GitHub Codespace for this work.**

---

## SETUP

```bash
# 1. Provision F*
bash scripts/provision-smoke-toolchains.sh

# 2. Set environment
export FSTAR_HOME="/workspaces/proof/05_TOOLING/tools/fstar/current"
export PATH="$FSTAR_HOME/bin:$PATH"

# 3. Verify installation
fstar.exe --version   # Should show: F* 2025.12.15
```

---

## BUILD

F* compiles files individually. Run each through fstar.exe:

```bash
# Full lane build — compile every .fst file
pass=0; fail=0; fail_list=""
for f in $(find 02_FORMAL/fstar/RIINA -name "*.fst" -type f | sort); do
  result=$(timeout 120 fstar.exe --include 02_FORMAL/fstar/RIINA "$f" 2>&1)
  if [ $? -eq 0 ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    fail_list="$fail_list\n$f"
    echo "FAIL: $f"
    echo "$result" | tail -5
  fi
done
echo "F* build: pass=$pass fail=$fail total=$((pass+fail))"
echo -e "Failing files:$fail_list"
```

---

## FIX-VERIFY LOOP

If files fail:

1. Read the failing `.fst` file and the error message
2. Fix the error — common patterns:
   - `assume val` or `assume type`: replace with real definition (e.g., `type store = list (nat * nat)`)
   - Module not found: check `open` statements reference real F* modules (`FStar.All`, `FStar.List`, etc.)
   - Type mismatch: F* nat is not Coq nat. Use `int` or appropriate F* types
   - Pattern match on nat: F* doesn't destructure nat like Coq. Use `if n = 0 then ... else ...`
   - `Tot` vs `Lemma`: proofs are `let lemma_name () : Lemma (...) = ()`
3. Rebuild the fixed file
4. Repeat until all 265 pass

**NEVER add `assume val` or `assume type`** — these are axiom holes equivalent to `sorry`.

---

## DEQUARANTINE

Once all files compile:

```bash
# 1. Remove quarantine
rm 02_FORMAL/fstar/.STUB_QUARANTINED

# 2. Verify zero assume val/type
grep -rl 'assume val\|assume type' 02_FORMAL/fstar/RIINA --include="*.fst" | wc -l
# Must output: 0

# 3. Regenerate noncoq report
PATH="$HOME/.elan/bin:$PATH" bash scripts/check-noncoq-mechanized.sh 2>&1 | grep "F\*"
# Should show: F* mechanized : 1

# 4. Fix JSON
python3 -c "
import json
with open('reports/noncoq_mechanized_status.json') as f:
    d = json.loads(f.read(), strict=False)
with open('reports/noncoq_mechanized_status.json', 'w') as f:
    json.dump(d, f, indent=2)
    f.write('\n')
"

# 5. Commit
git add 02_FORMAL/fstar/ reports/noncoq_mechanized_status.json
git commit -m "[TRACK_A] PROOF: Dequarantine F* — full compilation verified (265 files)

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
git push origin main
```

---

## FILE OWNERSHIP

You ONLY touch: `02_FORMAL/fstar/`

Do NOT touch any other `02_FORMAL/` subdirectory or `03_PROTO/`.

---

## DETAILS

- 265 `.fst` files across Foundations/, TypeSystem/, Effects/, Properties/, Domains/, Industries/, Termination/, Active/
- Currently 0 `assume val` / `assume type` holes
- F* version: 2025.12.15
- Active smoke module `CryptographicSecurityActive.fst` already compiles
- F* has `--include` for specifying search paths — use `--include 02_FORMAL/fstar/RIINA`
- Some files may need `--lax` initially to identify issues, but final build must NOT use `--lax`

## SUCCESS CRITERIA

All 265 `.fst` files compile with `fstar.exe` (exit code 0, no `--lax`).
Zero `assume val` / `assume type` in any file.
