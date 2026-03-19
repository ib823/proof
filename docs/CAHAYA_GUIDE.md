# CAHAYA Guide

CAHAYA (Ciri Aksesibiliti, Harmoni Antara Yunit Antaramuka) is RIINA's type-safe UI framework with built-in accessibility enforcement.

## What is CAHAYA?

CAHAYA enforces UI correctness at the type level:

- **Accessibility** — WCAG contrast ratios checked at compile time
- **Layout safety** — Type-checked layout composition
- **Aesthetic enforcement** — 7-layer aesthetic rules grounded in empirical research
- **Honest scope** — ~60-70% of aesthetic quality is enforceable; human judgment remains essential

## Quick Start

### Display and Text

```riina
paparan {
    tulisan("Selamat datang ke RIINA!", warna(255, 255, 255));
}
```

- `paparan` — root display container
- `tulisan(text, color)` — text element with color
- `warna(r, g, b)` — RGB color constructor

### Buttons

```riina
paparan {
    butang("Klik saya", fungsi() { 42 });
}
```

- `butang(label, handler)` — interactive button with click handler

## WCAG Contrast Checking

CAHAYA enforces WCAG AA contrast ratios (minimum 4.5:1 for normal text).

```riina
biar putih = warna(255, 255, 255);
biar hitam = warna(0, 0, 0);

biar lulus = kontras(putih, hitam);   // true (21:1 ratio)
```

- `kontras(fg, bg)` — returns whether foreground/background meet WCAG AA
- Compile-time error if contrast ratio is provably insufficient

## Layout

### Rows and Columns

```riina
paparan {
    baris {
        tulisan("Kiri", warna(200, 200, 200));
        tulisan("Tengah", warna(200, 200, 200));
        tulisan("Kanan", warna(200, 200, 200));
    }
}
```

- `baris` — horizontal layout (row)
- `lajur` — vertical layout (column)

### Nested Layout

```riina
paparan {
    lajur {
        baris {
            tulisan("Atas Kiri", warna(255, 255, 255));
            tulisan("Atas Kanan", warna(255, 255, 255));
        }
        baris {
            tulisan("Bawah Kiri", warna(200, 200, 200));
            tulisan("Bawah Kanan", warna(200, 200, 200));
        }
    }
}
```

## Examples

See `07_EXAMPLES/09_cahaya/` for complete working examples:

- `hello_ui.rii` — Hello world UI
- `contrast_check.rii` — WCAG contrast verification
- `layout_example.rii` — Row/column layout
