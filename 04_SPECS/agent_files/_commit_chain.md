```
Stage specific files → commit "[TRACK_X] TYPE: ..." → push (pre-push runs riinac verify --full; never --no-verify)
→ scripts/sync-public.sh → scripts/generate-metrics.sh + scripts/sync-metrics.sh (when counts change)
→ scripts/deploy-website.sh
```
Numbers flow ONE direction: actual commands → `website/public/metrics.json` → generated docs → website → master plan.
