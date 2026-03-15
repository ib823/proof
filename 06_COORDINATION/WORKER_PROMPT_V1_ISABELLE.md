# WORKER V1: Isabelle Verification Build

**Mission:** Run full Isabelle build, fix any errors, dequarantine the lane.

**Use an 8-core (or higher) GitHub Codespace for this work.**

---

## SETUP

```bash
# 1. Provision Isabelle
bash scripts/provision-smoke-toolchains.sh

# 2. Set environment
export ISABELLE_HOME="/workspaces/proof/05_TOOLING/tools/isabelle/current"
export PATH="$ISABELLE_HOME/bin:$PATH"

# 3. Verify installation
isabelle version   # Should show: Isabelle2024
```

---

## BUILD

Run both sessions in order. The RIINA session must pass before RIINA_Domains.

```bash
# Session 1: Core foundations (Syntax, Semantics, Typing, Effects, etc.)
# ~10-20 minutes on 8-core
isabelle build -d 02_FORMAL/isabelle/RIINA -b RIINA 2>&1 | tee /tmp/isabelle_core.log

# Session 2: All domains, industries, properties, termination (~30-60 min on 8-core)
isabelle build -d 02_FORMAL/isabelle/RIINA -b RIINA_Domains 2>&1 | tee /tmp/isabelle_domains.log
```

---

## FIX-VERIFY LOOP

If builds fail:

1. Get errors: `isabelle build_log -H Error RIINA` or `isabelle build_log -H Error RIINA_Domains`
2. Read the failing `.thy` file
3. Fix the error — common patterns:
   - Missing `imports`: add `imports Main` or specific theory imports
   - Type errors in proofs: change `by auto` to `by simp` or `by blast` or `by (auto simp add: ...)`
   - Undefined constants: check that definitions match the imports
   - `sorry`/`oops` found: replace with actual proof (`by auto`, `by simp`, etc.)
4. Rebuild
5. Repeat until both sessions pass

**NEVER add `sorry` or `oops`** — simplify the lemma statement instead if unprovable.

---

## DEQUARANTINE

Once both sessions build clean:

```bash
# 1. Remove quarantine marker
rm 02_FORMAL/isabelle/.STUB_QUARANTINED

# 2. Verify sorry count is 0
grep -rl '\bsorry\b\|\boops\b' 02_FORMAL/isabelle/RIINA --include="*.thy" | wc -l
# Must output: 0

# 3. Regenerate noncoq report
PATH="$HOME/.elan/bin:$PATH" bash scripts/check-noncoq-mechanized.sh 2>&1 | grep Isabelle
# Should show: Isabelle mechanized : 1

# 4. Fix JSON (newlines in error strings)
python3 -c "
import json
with open('reports/noncoq_mechanized_status.json') as f:
    d = json.loads(f.read(), strict=False)
with open('reports/noncoq_mechanized_status.json', 'w') as f:
    json.dump(d, f, indent=2)
    f.write('\n')
"

# 5. Commit
git add 02_FORMAL/isabelle/ reports/noncoq_mechanized_status.json
git commit -m "[TRACK_A] PROOF: Dequarantine Isabelle — full build verified (275 theories)

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
git push origin main
```

---

## FILE OWNERSHIP

You ONLY touch: `02_FORMAL/isabelle/`

Do NOT touch: `02_FORMAL/coq/`, `02_FORMAL/lean/`, `02_FORMAL/smt/`, `02_FORMAL/fstar/`, `02_FORMAL/tlaplus/`, `02_FORMAL/alloy/`, `03_PROTO/`

---

## DETAILS

- 275 `.thy` files across Foundations/, TypeSystem/, Effects/, Properties/, Domains/, Industries/, Compliance/, Termination/
- 2 ROOT sessions: `RIINA` (10 core theories) and `RIINA_Domains` (265 domain/industry/properties theories)
- The `RIINA_Domains` session depends on `RIINA` — build RIINA first
- Currently 0 sorry, 0 oops in source
- Isabelle 2024 uses `quick_and_dirty = false` (no cheating)
- Session ROOT files are at `02_FORMAL/isabelle/RIINA/ROOT` and `02_FORMAL/isabelle/RIINA/Core/ROOT`

## SUCCESS CRITERIA

`isabelle build -d 02_FORMAL/isabelle/RIINA -b RIINA_Domains` exits 0.
