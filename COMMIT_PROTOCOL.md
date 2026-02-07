# RIINA COMMIT PROTOCOL

## 0. BEFORE ANYTHING ELSE

**Every session, before any work:**

```bash
# 1. Verify hooks are installed
ls -la .git/hooks/pre-commit .git/hooks/pre-push

# If they don't exist or are wrong:
bash 00_SETUP/scripts/install_hooks.sh

# 2. Verify riinac exists and works
./03_PROTO/target/release/riinac verify --fast

# If riinac doesn't exist:
cd 03_PROTO && cargo build --release -p riinac && cd ..
```

**If hooks are not installed, stop. Install them first.**

---

## 1. DOCUMENTATION AUDIT (BEFORE COMMIT)

Before any commit, audit all relevant documentation files.

### 1.1 Core Documents

| File | What to Check | Update If |
|------|---------------|-----------|
| `README.md` | Hero metrics, comparison table | Metrics changed significantly |
| `VERSION` | Semver version | Release milestone |
| `CHANGELOG.md` | Release notes | Any user-facing change |
| `VERIFICATION_MANIFEST.md` | Auto-generated | Run `riinac verify --full` |

### 1.2 Website Documents

| File | What to Check | Update If |
|------|---------------|-----------|
| `website/src/RiinaWebsite.jsx` | Hero stats, release data | Metrics changed |
| `website/public/metrics.json` | Auto-generated | Run `scripts/generate-metrics.sh` |

### 1.3 Audit Script

Run this before every commit:

```bash
bash scripts/audit-docs.sh
```

This script will:
1. Count current Qed proofs, admits, axioms
2. Compare against documented values
3. Flag any discrepancies
4. Generate an audit report

---

## 2. COMMIT CHECKLIST

Before running `git commit`, verify all of the following:

```
[ ] Hooks installed (ls -la .git/hooks/pre-commit .git/hooks/pre-push)
[ ] riinac verify --fast passes
[ ] Documentation audit complete (bash scripts/audit-docs.sh)
[ ] All flagged documents updated OR explicitly marked "no change needed"
[ ] Commit message follows format: [TRACK_X] TYPE: Description
[ ] No secrets in staged files
[ ] No Admitted in active Coq build (unless justified and documented)
```

---

## 3. PUSH CHECKLIST

Before running `git push origin main`:

```
[ ] All commit checklist items verified
[ ] riinac verify --full passes (will run automatically via pre-push hook)
[ ] VERIFICATION_MANIFEST.md updated
[ ] GPG signing enabled (optional but recommended)
```

---

## 4. PUBLIC SYNC CHECKLIST

Before running `bash scripts/sync-public.sh`:

```
[ ] main branch is pushed and verified
[ ] No internal files will leak to public (script handles this)
[ ] Website metrics are current
```

---

## 5. WEBSITE DEPLOY CHECKLIST

Before running `npm run deploy` in website/:

```
[ ] Public branch is synced
[ ] metrics.json regenerated (scripts/generate-metrics.sh)
[ ] Website builds without errors (npm run build)
[ ] All hero stats match documented metrics
[ ] Release information is current
```

---

## 6. THE CARDINAL RULES

1. **Never commit without running the audit**
2. **Never push without verification passing**
3. **Never deploy without syncing public first**
4. **Never trust that hooks are installed — verify**
5. **Never trust that documentation is current — audit**
6. **Never skip steps because "it's a small change"**

---

## 7. ENFORCEMENT

This protocol is enforced by:

1. **Pre-commit hook** — Runs `riinac verify --fast`
2. **Pre-push hook** — Runs `riinac verify --full` + security scans
3. **sync-public.sh** — Verifies main is pushed before syncing
4. **deploy-website.sh** — Builds and deploys only if build succeeds

If any hook fails, the operation is blocked. Fix the issue — do not bypass the hook.

---

*This protocol is non-negotiable. Q.E.D.*
