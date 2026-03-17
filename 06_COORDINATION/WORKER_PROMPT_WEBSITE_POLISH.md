# WORKER: Website Polish & Playground UX (Claude Code App)

**Mission:** Polish the RIINA website and playground for public-facing quality. Make the playground actually usable and the website visually compelling.

## CURRENT STATE
- Website: `website/src/RiinaWebsite.jsx` (985 lines) — React SPA
- Playground: `website/src/playground/Playground.jsx` (270 lines) — textarea editor + output tabs
- WASM binary: `website/public/riina_wasm.wasm` (717KB) — in-browser compiler
- Worker: `website/src/playground/worker.js` (86 lines) — Web Worker for WASM
- Build: `cd website && npm install && npm run build`
- Deploy base: `/riina/` (vite.config.js)
- Metrics: reads from `website/public/metrics.json` at runtime

## IMPROVEMENTS NEEDED

### Playground UX (highest priority)

1. **Better examples** — current 5 examples are basic. Add:
   - Security example: classify/declassify with Secret types
   - Effect example: function with `kesan Tulis` effect declaration
   - Linear types: `biar sekali x = 42; x` (new feature!)
   - Pattern matching: `padan` expression
   - Multi-file: function definition + caller

2. **Syntax highlighting** — the textarea has no highlighting. Add a simple CSS-based highlighter:
   - Keywords: `fungsi`, `biar`, `kalau`, `lain`, `pulang`, `kesan`, `padan`, etc. → bold/colored
   - Types: `Nombor`, `Bool`, `Teks` → different color
   - Strings: `"..."` → green
   - Comments: `//` → gray
   - Numbers: → blue
   - Use a `<pre>` overlay or contenteditable div, NOT a heavy library

3. **Error display** — show parse/type errors inline with line numbers, not just raw text

4. **Output tabs** — add a "WASM" tab that shows the WASM binary size and section info

5. **Share button** — encode source in URL hash so users can share playground links

6. **Mobile responsive** — the split pane should stack vertically on mobile

### Website Content

7. **Hero section** — the numbers should be more prominent. Show:
   - "48,913 mathematical proofs" (big number)
   - "10 independent provers" (credibility)
   - "1,276 tests" (engineering quality)

8. **"How It Works" page** — update claim level descriptions to match current state (4 mechanized, 3 compiled, 3 generated)

9. **Feature comparison table** — make it clearer what RIINA offers vs Rust/Haskell/Ada

10. **Footer** — add version number, last deploy date, GitHub link

### Performance

11. **Lazy load WASM** — don't load the 717KB WASM until user navigates to playground
12. **Preconnect** — add `<link rel="preconnect">` for GitHub API if used

## FILE OWNERSHIP

ONLY touch files in `website/`:
- `website/src/RiinaWebsite.jsx`
- `website/src/playground/Playground.jsx`
- `website/src/playground/worker.js`
- `website/src/riina.css`
- `website/src/main.jsx`
- `website/index.html`
- `website/public/` (static assets only, NOT metrics.json)

Do NOT touch: `03_PROTO/`, `02_FORMAL/`, `05_TOOLING/`, `RIINA_MASTER_PLAN.md`

## BUILD & TEST

```bash
cd website
npm install
npm run build
# Check dist/ for correct output
ls -lh dist/
# Verify metrics.json is included
cat dist/metrics.json | python3 -c "import json,sys; d=json.load(sys.stdin); print('qed:', d['proofs']['qedActive'])"
```

## IMPORTANT CONSTRAINTS

- **No new npm dependencies** — zero external packages beyond React + Vite
- **No Monaco/CodeMirror** — keep the editor lightweight (textarea or contenteditable)
- **Metrics from metrics.json only** — never hardcode numbers
- **Base path `/riina/`** — all asset paths must work under this prefix
- **Dark theme** — the site uses dark background (#0a0a0b), don't change the color scheme

## COMMIT FORMAT
```
[TRACK_B] IMPL: Polish playground UX (syntax highlighting, examples, sharing)
[TRACK_B] IMPL: Update website hero section and How It Works page
```
