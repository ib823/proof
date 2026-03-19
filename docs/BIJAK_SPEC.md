# RIINA Bijak — Interactive Learning Platform

**Bijak** (Malaysian: "wise/clever") is RIINA's progressive learning platform
that teaches formal verification concepts through hands-on coding in Bahasa Melayu.

---

## Lessons (Progressive)

### 1. Hello Dunia — First Program
- Write `fungsi utama()` and `cetak_baris()`
- Understand `modul`, `guna`, and `awam`
- Learn about effects: `kesan Tulis`

### 2. Pembolehubah dan Jenis — Variables and Types
- `biar` (immutable) vs `biar ubah` (mutable) vs `tetap` (constant)
- Primitive types: `Nombor`, `Teks`, `Benar`, `Kosong`
- Type annotations on variables and functions

### 3. Fungsi — Functions
- `fungsi` declarations with parameters and return types
- `pulang` (return) and expression-based returns
- `kesan` (effect) annotations: `Bersih`, `Tulis`, `Baca`
- Pure functions vs effectful functions

### 4. Kawalan Aliran — Conditionals
- `kalau` / `lain` (if/else)
- `padan` (match) with patterns and wildcard `_`
- `Mungkin<T>` (Option) with `Ada` / `Tiada`
- `Hasil<T,E>` (Result) with `Jadi` / `Gagal`

### 5. Gelung dan Koleksi — Loops and Collections
- `untuk` / `dalam` (for/in) loops
- `selagi` (while) loops
- `Senarai<T>` (List) operations
- Pipe operator `|>` with `tapis`, `peta`, `lipat`

### 6. Jenis Keselamatan — Security Types
- `Rahsia<T>` (Secret) — data that cannot leak
- `dedah` (declassify) with `Bukti` (proof) justification
- Security lattice: `Awam < Dalaman < Sesi < Pengguna < Sistem < Rahsia`
- `Berlabel<T, Level>` (Labeled) and `Tercemar<T, Source>` (Tainted)

### 7. Kesan — Effects
- Effect lattice: `Bersih` through `Masa`
- `laku` (perform) to trigger effects
- `kendali` (handle) to intercept effects
- Effect composition and subsumption

### 8. Jenis Linear — Linear Types
- `sekali` (use exactly once), `paling` (use at most once), `mesti` (must use)
- Resource management without garbage collection
- File handles, network connections as linear resources

### 9. Pelakon — Actors (JALINAN)
- `pelakon` (actor) with `keadaan` (state)
- `lahir` (spawn), `hantar` (send), `terima` (receive)
- `koreografi` (choreography) for multi-party protocols
- `penyelia` (supervisor) for fault tolerance

### 10. Antara-muka — UI (CAHAYA)
- `paparan` (view) declarations
- `tulisan` (text), `butang` (button), `medan_teks` (input)
- `warna` (color) with accessibility contrast checking
- `label` for screen reader compatibility

---

## Exercise Format

Each lesson includes:

1. **Penjelasan** (Explanation) — Concept introduction with bilingual comments
2. **Contoh** (Example) — Working code demonstrating the concept
3. **Latihan** (Exercise) — Fill-in-the-blank or write-from-scratch challenge
4. **Semakan** (Check) — Automatic verification of student solution
5. **Cabaran** (Challenge) — Optional harder problem for advanced learners

### Example Exercise (Lesson 3)

```
// Latihan: Tulis fungsi yang mengira faktorial
// Exercise: Write a function that computes factorial

fungsi faktorial(n: Nombor) -> Nombor kesan Bersih {
    // Tulis kod anda di sini / Write your code here
    ___
}

// Semakan / Check:
// faktorial(0) == 1
// faktorial(5) == 120
```

---

## Technical Architecture

### Frontend
- **Playground**: Already exists in `website/playground/`
- **Editor**: Monaco-based with RIINA syntax highlighting
- **Output panel**: Shows compilation result, effect analysis, security check

### Backend
- **riinac WASM**: Already compiled to WebAssembly
- **Type checker**: Runs in-browser via WASM
- **Effect checker**: Validates effect annotations client-side
- **No server needed**: Fully static deployment

### Progress Tracking
- **Storage**: `localStorage` for lesson completion state
- **Format**: JSON object mapping lesson ID to completion status
- **No account required**: Works offline, no server dependency

```json
{
  "bijak_progress": {
    "lesson_01": { "completed": true, "exercises": [true, true, true] },
    "lesson_02": { "completed": false, "exercises": [true, false, false] }
  }
}
```

### Deployment
- Static HTML/CSS/JS hosted on GitHub Pages
- WASM module loaded on demand per lesson
- Total bundle size target: < 5 MB (WASM + assets)
- Works on mobile browsers (responsive layout)

---

## Content Guidelines

- All code comments bilingual: Bahasa Melayu first, English second
- Error messages in Bahasa Melayu with English translation
- Culturally relevant examples (Malaysian names, local context)
- Progressive complexity — each lesson builds on previous ones
- No lesson requires external tools or dependencies
