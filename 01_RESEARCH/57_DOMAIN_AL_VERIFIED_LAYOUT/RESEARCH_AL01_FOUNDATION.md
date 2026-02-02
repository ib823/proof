# RESEARCH_AL01_FOUNDATION.md
# RIINA Verified Layout: Compile-Time UI/UX Correctness
# Version: 1.0.0 | Status: FOUNDATIONAL SPECIFICATION
# Date: 2026-02-02
# Track: AL-01 (Verified Layout)
# Layer: L7 (User Interface — Layout & Visual Correctness)
# Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE

---

## THE THESIS

**"If it compiles, the UI/UX is perfect."**

RIINA already guarantees: *if it compiles, secret data cannot leak*. This track extends that principle to the visual layer: if RIINA code compiles, the resulting UI is mathematically proven to be pixel-perfect on every screen, accessible to every human, responsive at every viewport, and visually consistent across every platform. No runtime testing. No manual QA. No "it works on my machine." Proven correct by construction.

**No programming language in existence offers this.** Not Swift, not Kotlin, not Dart, not TypeScript, not Flutter, not SwiftUI. The closest academic work — Cassius/VizAssert from UW — is a post-hoc external verifier, not a language-integrated guarantee. RIINA will be the first to embed layout correctness into the type system itself.

---

## 1. PRIOR ART ANALYSIS

### 1.1 Academic Prior Art

#### 1.1.1 Cassius (OOPSLA 2016)

**Source:** Panchekha, Torlak, et al. "Automated Reasoning for Web Page Layout." OOPSLA 2016.
**Repository:** https://github.com/uwplse/Cassius

**What it does:**
- Formalizes a substantial fragment of CSS 2.1 box model in Racket
- Encodes layout computation as a function from DOM + styles → positions/sizes
- Uses Z3 SMT solver (QFLRA — quantifier-free linear real arithmetic) to verify assertions
- Can answer: "Does this CSS ever produce horizontal overflow?" for ALL viewport widths

**What it covers:**
- Cascading stylesheets (specificity, inheritance)
- Box generation from HTML elements
- Layout: used values, margin collapsing, text alignment
- Float positioning (partial)
- Rich enough to handle fragments of Wikipedia, Google, Amazon

**Limitations:**
- External tool — not integrated into any language
- CSS 2.1 only — no flexbox, no grid, no modern layout
- Performance: minutes per page for complex layouts
- No accessibility verification in the original paper
- No cross-platform rendering model

#### 1.1.2 VizAssert (PLDI 2018)

**Source:** Panchekha, Geller, Ernst, Tatlock, Kamil. "Verifying that web pages have accessible layout." PLDI 2018.

**What it does:**
- Introduces "visual logic" — a specification language for layout properties
- Properties like: "no text is smaller than 10px at any viewport width"
- Reduces verification to QFLRA satisfiability via novel finitization
- Verified 14 assertions across 60 real-world pages

**Key insight:** Layout properties can be expressed as quantified statements over continuous viewport dimensions, and finitized into finite SMT problems.

**Visual logic examples:**
```
∀ viewport ∈ [320, ∞). ∀ elem ∈ interactive_elements.
  elem.width ≥ 48dp ∧ elem.height ≥ 48dp

∀ viewport ∈ [320, ∞). ¬∃ elem.
  elem.right > viewport.width  // no horizontal scroll

∀ (text, bg) ∈ text_bg_pairs.
  contrast_ratio(text.color, bg.color) ≥ 4.5
```

#### 1.1.3 Troika (OOPSLA 2019)

**Source:** Panchekha, Ernst, Tatlock, Kamil. "Modular verification of web page layout." OOPSLA 2019.

**What it does:**
- Extends VizAssert with modular proofs
- Components can be verified independently, then composed
- Reduces verification time from minutes to seconds
- Enables incremental re-verification on code changes

**Key insight for RIINA:** Modular verification maps directly to RIINA's component-based UI model. Each `Komponen<T>` carries its own proof obligations, and composition is verified by the type checker.

#### 1.1.4 Other Related Work

| Work | Year | Contribution | Gap |
|------|------|-------------|-----|
| CSS Selectors formalization (Geneves et al.) | 2012 | Tree logic for selector reasoning | No layout |
| Chlipala's Ur/Web | 2015 | Type-safe web programming | No visual correctness |
| Hazel (Cyrus Omar) | 2017+ | Typed holes, live programming | No layout proofs |
| Elm Architecture | 2016 | Predictable UI via pure functions | No formal guarantees |
| Jetpack Compose type safety | 2020 | Composable type checking | No layout proofs |
| SwiftUI type-level DSL | 2019 | View builder protocol | No formal verification |
| Flutter layout protocol | 2018 | Constraint-based layout | No formal proofs |
| Servo CSS engine (Mozilla) | 2016 | Parallel CSS in Rust | Memory safety, not layout correctness |
| WebGPU spec formalization | 2023 | GPU API formalization | Graphics pipeline, not layout |

### 1.2 Industry State of the Art

| Platform | Layout System | Correctness Guarantee | Gap |
|----------|--------------|----------------------|-----|
| **Web (CSS)** | Box model + flexbox + grid | None — tested manually | No formal model |
| **iOS (SwiftUI)** | Declarative views | Type-checked composition | No layout proofs |
| **iOS (UIKit)** | Auto Layout (Cassowary solver) | Constraint satisfaction | No accessibility proofs |
| **Android (Compose)** | Modifier chains | Type-checked | No responsive proofs |
| **Android (XML)** | ConstraintLayout | Constraint satisfaction | No formal model |
| **Flutter** | RenderObject tree | Widget type checking | No layout correctness |
| **React Native** | Yoga (flexbox) | None | No formal anything |
| **Qt/QML** | Anchor-based + layouts | Property bindings | No proofs |
| **Electron** | Web (Chromium) | None | Inherits all CSS problems |

**Every single platform relies on testing, not proof.** The gap is total.

### 1.3 The Fundamental Problem

Current UI development workflow:

```
Developer writes layout → Renders on ONE device → Manual check →
  "Looks good" → Ship → User on different device → BROKEN
```

Why this fails:
1. **Viewport space is continuous** — you cannot test every width from 320px to 3840px
2. **Font rendering varies** — system fonts, user preferences, dynamic type
3. **DPI varies** — 1x, 2x, 3x, fractional scaling
4. **Platform rendering differs** — WebKit vs Blink vs Gecko vs native
5. **User preferences vary** — large text, reduced motion, high contrast, RTL
6. **Content is dynamic** — user-generated text lengths break fixed layouts

Testing covers a finite subset of an infinite space. Only formal verification covers all cases.

---

## 2. RIINA VERIFIED LAYOUT ARCHITECTURE

### 2.1 Core Principle: Layout Types Carry Proofs

In RIINA's security system:
- `Rahsia<T>` carries a proof that data is secret
- The type system prevents leaking it without `dedah`

In RIINA's layout system:
- `Susun<T>` carries a proof that the layout is correct
- The type system prevents rendering it unless all constraints are satisfied

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        RIINA VERIFIED LAYOUT STACK                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  LAYER 5: APPLICATION UI                                                        │
│  ┌───────────────────────────────────────────────────────────────────────────┐  │
│  │ .rii source code with layout declarations                                │  │
│  │ fungsi paparan() -> Paparan kesan Lukis { ... }                          │  │
│  └───────────────────────┬───────────────────────────────────────────────────┘  │
│                          │ parsed into                                           │
│  LAYER 4: LAYOUT TYPE SYSTEM                                                    │
│  ┌───────────────────────▼───────────────────────────────────────────────────┐  │
│  │ Type checker generates proof obligations from layout types                │  │
│  │ • Containment: ∀ w. child.width ≤ parent.width                           │  │
│  │ • Visibility: ∀ w. interactive → visible ∧ clickable                     │  │
│  │ • Accessibility: contrast ≥ 4.5 ∧ touch_target ≥ 48dp                   │  │
│  │ • Responsiveness: ∀ w ∈ [320, ∞). no_overflow(layout, w)                │  │
│  └───────────────────────┬───────────────────────────────────────────────────┘  │
│                          │ discharged by                                         │
│  LAYER 3: CONSTRAINT SOLVER                                                     │
│  ┌───────────────────────▼───────────────────────────────────────────────────┐  │
│  │ SMT/arithmetic solver discharges layout obligations at compile time       │  │
│  │ • Linear arithmetic for sizing (lia/nia in Coq)                          │  │
│  │ • Interval arithmetic for viewport-parametric proofs                      │  │
│  │ • Finitization reductions (per VizAssert) for quantified properties      │  │
│  └───────────────────────┬───────────────────────────────────────────────────┘  │
│                          │ backed by                                             │
│  LAYER 2: COQ FORMALIZATION                                                     │
│  ┌───────────────────────▼───────────────────────────────────────────────────┐  │
│  │ Formal model of RIINA's layout primitives in Coq                         │  │
│  │ • Box model axiomatization                                                │  │
│  │ • Flexbox algorithm formalization                                         │  │
│  │ • Grid algorithm formalization                                            │  │
│  │ • Composition theorems                                                    │  │
│  └───────────────────────┬───────────────────────────────────────────────────┘  │
│                          │ produces                                              │
│  LAYER 1: RENDERING OUTPUT                                                      │
│  ┌───────────────────────▼───────────────────────────────────────────────────┐  │
│  │ Platform-specific rendering with proven equivalence                       │  │
│  │ • Web: CSS output (proven correct flexbox/grid)                           │  │
│  │ • iOS: SwiftUI output (proven constraint satisfaction)                    │  │
│  │ • Android: Compose output (proven modifier correctness)                   │  │
│  │ • WASM: Canvas output (proven pixel positioning)                          │  │
│  └───────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Layout Primitive Types

RIINA introduces verified layout primitives as first-class types:

```riina
/// === CORE LAYOUT TYPES ===

/// Susun (Layout) — base type for all layouts
/// Carries proof obligations that the compiler verifies
jenis Susun<Strategi> = {
    anak: Senarai<Elemen>,
    sifat: SifatSusun,
    bukti: BuktiSusun,      // compiler-generated proof certificate
}

/// Lentur (Flex) — verified flexbox
jenis Lentur = Susun<StrategiLentur>
biar susun: Lentur = lentur {
    arah: .mendatar,          // flex-direction: row
    jurang: 16.dp,            // gap: 16dp
    balut: .auto,             // flex-wrap: based on content
    jajar_utama: .tengah,     // justify-content: center
    jajar_silang: .mula,      // align-items: flex-start
    anak: [a, b, c],
}
// Compiler proves: ∀ w ∈ [320, ∞). a.width + b.width + c.width + 32 ≤ w ∨ wraps

/// Grid (Grid) — verified CSS grid
jenis Grid = Susun<StrategiGrid>
biar grid: Grid = grid {
    lajur: [1.fr, 1.fr, 1.fr],        // 3 equal columns
    baris: .auto,                       // auto rows
    jurang: (16.dp, 16.dp),            // row-gap, column-gap
    anak: items,
}
// Compiler proves: columns collapse to 1 on viewport < 768px

/// Tindanan (Stack) — verified z-axis stacking
jenis Tindanan = Susun<StrategiTindanan>
biar tindanan: Tindanan = tindanan {
    anak: [latar, kandungan, overlay],
    penjajaran: .tengah,
}
// Compiler proves: ∀ elem ∈ interactive. z_visible(elem) ∧ ¬obscured(elem)
```

### 2.3 Responsive Breakpoint Types

```riina
/// Responsif — type-level responsive declarations
/// Compiler proves correctness at ALL widths, not just breakpoints
jenis Responsif<T> = {
    asas: T,                        // base (mobile-first)
    tablet: Mungkin<T>,             // ≥ 768dp
    desktop: Mungkin<T>,            // ≥ 1024dp
    lebar: Mungkin<T>,              // ≥ 1440dp
}

/// Usage:
biar lajur: Responsif<Nombor> = responsif {
    asas: 1,        // 1 column on mobile
    tablet: 2,      // 2 columns on tablet
    desktop: 3,     // 3 columns on desktop
    lebar: 4,       // 4 columns on wide
}

// Compiler generates and proves:
// ∀ w ∈ [320, 768). grid_columns(layout, w) = 1
// ∀ w ∈ [768, 1024). grid_columns(layout, w) = 2
// ∀ w ∈ [1024, 1440). grid_columns(layout, w) = 3
// ∀ w ∈ [1440, ∞). grid_columns(layout, w) = 4
// ∀ w ∈ [320, ∞). no_overflow(layout, w) ∧ no_clipping(layout, w)
```

### 2.4 Accessibility Types

```riina
/// Warna (Color) — carries contrast proof obligations
jenis Warna = {
    r: U8, g: U8, b: U8, a: U8,
}

/// Gaya (Style) — verified styling
jenis Gaya = {
    warna_teks: Warna,
    warna_latar: Warna,
    saiz_fon: Saiz,
    tinggi_baris: Nisbah,
    // Compiler proves:
    // contrast_ratio(warna_teks, warna_latar) ≥ 4.5 (AA) or ≥ 7.0 (AAA)
    // saiz_fon ≥ 16sp (minimum readable)
    // tinggi_baris ≥ 1.5 (WCAG requirement)
}

/// Imej (Image) — MUST have alt text (enforced by type)
jenis Imej = {
    sumber: Teks,
    alt: Teks,                    // REQUIRED — compilation error if missing
    lebar: Saiz,
    tinggi: Saiz,
    // No Imej value can be constructed without alt
}

/// Butang (Button) — verified interactive element
jenis Butang = {
    label: Teks,                  // REQUIRED — screen reader label
    aksi: Fungsi<(), ()>,
    gaya: GayaButang,
    // Compiler proves:
    // width ≥ 48dp ∧ height ≥ 48dp (touch target)
    // has_focus_indicator = betul
    // label.length > 0
}

/// Borang (Form) — verified form
jenis Borang<T> = {
    medan: Senarai<Medan>,
    hantar: Fungsi<T, Keputusan<(), Ralat>>,
    // Compiler proves:
    // ∀ field ∈ medan. has_label(field) ∧ has_error_message(field)
    // tab_order_logical(medan)
    // all_inputs_reachable_by_keyboard(medan)
}
```

### 2.5 Platform Equivalence Types

```riina
/// Komponen<Platform> — platform-targeted component
jenis Komponen<P: Platform> = {
    paparan: Fungsi<(), Paparan>,
    gaya: Gaya,
    // When P = SemuaPlatform:
    // Compiler proves: ∀ p ∈ {Web, iOS, Android, WASM}.
    //   visual_equivalent(render(paparan, p), render(paparan, Web), ε=1dp)
}

/// SemuaPlatform — universal platform target
/// Components typed as Komponen<SemuaPlatform> are proven to render
/// equivalently (within ε tolerance) on all platforms
jenis SemuaPlatform = Web | iOS | Android | WASM
```

---

## 3. FORMAL MODEL IN COQ

### 3.1 Core Definitions (foundations/VerifiedLayout.v)

```coq
(** === RIINA Verified Layout Formalization === *)
(** Track: AL-01 | Layer: L7 | Date: 2026-02-02 *)

(** 3.1.1 Dimensional Types *)
Inductive Unit : Type :=
  | Px : nat -> Unit         (* absolute pixels *)
  | Dp : nat -> Unit         (* density-independent pixels *)
  | Sp : nat -> Unit         (* scale-independent pixels — text *)
  | Fr : nat -> Unit         (* fractional unit — grid *)
  | Pct : nat -> Unit        (* percentage of parent *)
  | Vw : nat -> Unit         (* viewport width percentage *)
  | Vh : nat -> Unit.        (* viewport height percentage *)

(** 3.1.2 Box Model *)
Record Box : Type := mkBox {
  box_x      : Z;    (* left edge position *)
  box_y      : Z;    (* top edge position *)
  box_width  : Z;    (* content width *)
  box_height : Z;    (* content height *)
  box_margin : Edges;
  box_border : Edges;
  box_padding: Edges;
}.

Record Edges : Type := mkEdges {
  edge_top    : Z;
  edge_right  : Z;
  edge_bottom : Z;
  edge_left   : Z;
}.

(** Total box width including margin/border/padding *)
Definition total_width (b : Box) : Z :=
  b.(box_margin).(edge_left) +
  b.(box_border).(edge_left) +
  b.(box_padding).(edge_left) +
  b.(box_width) +
  b.(box_padding).(edge_right) +
  b.(box_border).(edge_right) +
  b.(box_margin).(edge_right).

(** 3.1.3 Layout Tree *)
Inductive LayoutNode : Type :=
  | Leaf : Box -> LayoutNode
  | FlexRow : list LayoutNode -> FlexProps -> LayoutNode
  | FlexCol : list LayoutNode -> FlexProps -> LayoutNode
  | Grid : list LayoutNode -> GridProps -> LayoutNode
  | Stack : list LayoutNode -> LayoutNode
  | Responsive : list (Z * LayoutNode) -> LayoutNode.
    (* breakpoint → layout mapping *)

Record FlexProps : Type := mkFlexProps {
  flex_gap       : Z;
  flex_wrap      : bool;
  flex_justify   : Justify;
  flex_align     : Align;
}.

Record GridProps : Type := mkGridProps {
  grid_columns   : list TrackSize;
  grid_rows      : list TrackSize;
  grid_row_gap   : Z;
  grid_col_gap   : Z;
}.

(** 3.1.4 Viewport *)
Record Viewport : Type := mkViewport {
  vp_width  : Z;
  vp_height : Z;
  vp_dpi    : Z;
  vp_scale  : Z;   (* text scale factor × 100, e.g. 100 = 1.0x *)
}.

(** 3.1.5 Layout Function *)
(** Given a layout tree and viewport, compute concrete Box positions *)
Parameter layout_compute : LayoutNode -> Viewport -> list Box.
```

### 3.2 Core Properties to Prove

```coq
(** === CONTAINMENT PROPERTIES === *)

(** Theorem: No child exceeds parent width *)
Theorem containment_width :
  forall (parent : LayoutNode) (vp : Viewport),
    vp.(vp_width) >= 320 ->
    let boxes := layout_compute parent vp in
    forall child_box parent_box,
      is_child child_box parent_box boxes ->
      total_width child_box <= total_width parent_box.

(** Theorem: No element extends beyond viewport *)
Theorem no_horizontal_overflow :
  forall (root : LayoutNode) (vp : Viewport),
    vp.(vp_width) >= 320 ->
    well_formed root ->
    let boxes := layout_compute root vp in
    forall b, In b boxes ->
      b.(box_x) >= 0 /\
      b.(box_x) + total_width b <= vp.(vp_width).

(** Theorem: No horizontal scrollbar needed *)
Theorem no_horizontal_scroll :
  forall (root : LayoutNode) (vp : Viewport),
    vp.(vp_width) >= 320 ->
    well_formed root ->
    max_right (layout_compute root vp) <= vp.(vp_width).

(** === VISIBILITY PROPERTIES === *)

(** Theorem: Interactive elements are never invisible *)
Theorem interactive_implies_visible :
  forall (root : LayoutNode) (vp : Viewport),
    well_formed root ->
    let boxes := layout_compute root vp in
    forall b, In b boxes ->
      is_interactive b ->
      visible b boxes /\ not_obscured b boxes.
(* Cross-reference: VerifiedUI.v interactivity_implies_visibility *)

(** Theorem: No text is clipped *)
Theorem no_text_clipping :
  forall (root : LayoutNode) (vp : Viewport),
    vp.(vp_width) >= 320 ->
    well_formed root ->
    let boxes := layout_compute root vp in
    forall b, In b boxes ->
      has_text b ->
      text_fully_visible b (parent_of b boxes).

(** === ACCESSIBILITY PROPERTIES === *)

(** Theorem: All text meets WCAG AA contrast *)
Theorem wcag_aa_contrast :
  forall (text_color bg_color : Color),
    styled_pair text_color bg_color ->
    contrast_ratio text_color bg_color >= 45 (* 4.5 × 10, integer *).

(** Theorem: All text meets WCAG AAA contrast *)
Theorem wcag_aaa_contrast :
  forall (text_color bg_color : Color),
    styled_pair text_color bg_color ->
    large_text = false ->
    contrast_ratio text_color bg_color >= 70 (* 7.0 × 10, integer *).

(** Theorem: Touch targets meet minimum size *)
Theorem touch_target_minimum :
  forall (root : LayoutNode) (vp : Viewport),
    well_formed root ->
    let boxes := layout_compute root vp in
    forall b, In b boxes ->
      is_interactive b ->
      b.(box_width) >= 48 /\ b.(box_height) >= 48.
(* 48dp minimum per WCAG 2.1 Target Size criterion *)

(** Theorem: All images have alt text *)
(** Enforced by type system — Imej type requires alt field *)
(** No theorem needed; construction prevents violation *)

(** Theorem: All form inputs have labels *)
Theorem form_labels_complete :
  forall (form : LayoutNode),
    is_form form ->
    forall input, is_input input form ->
      has_associated_label input.

(** Theorem: Tab order is logical *)
Theorem tab_order_logical :
  forall (root : LayoutNode) (vp : Viewport),
    well_formed root ->
    let boxes := layout_compute root vp in
    let focusable := filter is_focusable boxes in
    visual_order focusable = tab_order focusable.

(** === RESPONSIVE PROPERTIES === *)

(** Theorem: Layout is correct at ALL viewport widths *)
Theorem universal_viewport_correctness :
  forall (root : LayoutNode) (vp : Viewport),
    vp.(vp_width) >= 320 ->
    well_formed root ->
    no_horizontal_overflow root vp /\
    no_text_clipping root vp /\
    touch_target_minimum root vp /\
    interactive_implies_visible root vp.

(** Theorem: Breakpoint transitions are smooth *)
Theorem breakpoint_continuity :
  forall (root : LayoutNode) (bp : Z) (epsilon : Z),
    epsilon > 0 ->
    is_breakpoint bp root ->
    let layout_before := layout_compute root (mkViewport (bp - 1) 800 96 100) in
    let layout_at     := layout_compute root (mkViewport bp 800 96 100) in
    (* No element "jumps" more than epsilon pixels at breakpoint *)
    max_position_delta layout_before layout_at <= epsilon.

(** Theorem: Responsive layout degrades gracefully *)
Theorem graceful_degradation :
  forall (root : LayoutNode),
    well_formed root ->
    (* At minimum viewport (320px), all content is accessible *)
    let vp_min := mkViewport 320 568 96 100 in
    all_content_reachable (layout_compute root vp_min) /\
    all_text_readable (layout_compute root vp_min) /\
    all_interactions_possible (layout_compute root vp_min).

(** === PLATFORM EQUIVALENCE PROPERTIES === *)

(** Theorem: Cross-platform visual equivalence *)
Theorem platform_visual_equivalence :
  forall (root : LayoutNode) (vp : Viewport)
         (p1 p2 : Platform),
    well_formed root ->
    let boxes1 := platform_layout_compute p1 root vp in
    let boxes2 := platform_layout_compute p2 root vp in
    forall i, i < length boxes1 ->
      Z.abs (nth i boxes1 zero_box).(box_x) -
             (nth i boxes2 zero_box).(box_x) <= 1 /\
      Z.abs (nth i boxes1 zero_box).(box_y) -
             (nth i boxes2 zero_box).(box_y) <= 1 /\
      Z.abs (nth i boxes1 zero_box).(box_width) -
             (nth i boxes2 zero_box).(box_width) <= 1 /\
      Z.abs (nth i boxes1 zero_box).(box_height) -
             (nth i boxes2 zero_box).(box_height) <= 1.
(* Rendering differs by at most 1dp across platforms *)

(** === TYPOGRAPHY PROPERTIES === *)

(** Theorem: Text never exceeds container *)
Theorem text_containment :
  forall (text : TextNode) (container : Box) (vp : Viewport),
    text_in_container text container ->
    vp.(vp_width) >= 320 ->
    let text_box := compute_text_box text container vp in
    text_box.(box_width) <= container.(box_width) /\
    text_box.(box_height) <= container.(box_height).
(* Text wraps or truncates — never overflows *)

(** Theorem: Font size is always readable *)
Theorem minimum_font_size :
  forall (text : TextNode) (vp : Viewport),
    rendered text vp ->
    effective_font_size text vp >= 12.
(* 12sp minimum — accounts for user scale preferences *)

(** Theorem: Line height ensures readability *)
Theorem line_height_readable :
  forall (text : TextNode),
    multiline text ->
    line_height text >= 150.
(* 1.5× line height per WCAG *)

(** === COMPOSITION PROPERTIES === *)

(** Theorem: Verified components compose to verified layouts *)
Theorem composition_preserves_correctness :
  forall (components : list LayoutNode) (container : LayoutNode),
    Forall well_formed components ->
    well_formed container ->
    well_formed (compose container components).
(* If each component is verified, the composed layout is verified *)

(** Theorem: Modular verification is sound *)
(** Per Troika (OOPSLA 2019): verifying components independently
    and composing proofs is equivalent to verifying the whole *)
Theorem modular_verification_sound :
  forall (root : LayoutNode) (parts : list LayoutNode),
    decompose root = parts ->
    Forall (fun p => universal_viewport_correctness p) parts ->
    universal_viewport_correctness root.
```

### 3.3 Proof Obligations Generated by Compiler

When the RIINA compiler encounters layout code, it generates proof obligations:

```coq
(** For each layout declaration in .rii source code,
    riinac generates these obligation types: *)

Inductive LayoutObligation : Type :=
  | OblContainment : LayoutNode -> LayoutObligation
  | OblNoOverflow : LayoutNode -> Z -> LayoutObligation  (* min viewport *)
  | OblVisibility : LayoutNode -> LayoutObligation
  | OblContrast : Color -> Color -> Z -> LayoutObligation  (* min ratio *)
  | OblTouchTarget : LayoutNode -> Z -> Z -> LayoutObligation  (* min w, h *)
  | OblAltText : ImageNode -> LayoutObligation
  | OblFormLabels : FormNode -> LayoutObligation
  | OblTabOrder : LayoutNode -> LayoutObligation
  | OblFontSize : TextNode -> Z -> LayoutObligation  (* min size *)
  | OblLineHeight : TextNode -> Z -> LayoutObligation  (* min ratio *)
  | OblPlatformEquiv : LayoutNode -> Platform -> Platform -> Z -> LayoutObligation.

(** The compiler's layout checker discharges these obligations
    using arithmetic tactics (lia/nia) and the formal layout model.
    If any obligation cannot be discharged → COMPILATION ERROR *)
```

---

## 4. THREAT MODEL

### 4.1 UI/UX Threats Eliminated by Construction

| Threat ID | Threat | Elimination Mechanism | Proof |
|-----------|--------|----------------------|-------|
| AL-T001 | Horizontal overflow/scroll | `no_horizontal_overflow` theorem | Containment proof ∀ viewport |
| AL-T002 | Text clipping/truncation | `no_text_clipping` theorem | Text containment proof |
| AL-T003 | Invisible interactive elements | `interactive_implies_visible` | Z-order + opacity proof |
| AL-T004 | Insufficient contrast | `wcag_aa_contrast` / `wcag_aaa_contrast` | Color arithmetic proof |
| AL-T005 | Touch targets too small | `touch_target_minimum` | Size bound proof |
| AL-T006 | Missing alt text | Type system: `Imej` requires `alt` | Construction prevents violation |
| AL-T007 | Missing form labels | `form_labels_complete` | Structural proof |
| AL-T008 | Broken tab order | `tab_order_logical` | Order equivalence proof |
| AL-T009 | Unreadable font size | `minimum_font_size` | Size bound proof |
| AL-T010 | Cramped line height | `line_height_readable` | Ratio bound proof |
| AL-T011 | Broken responsive layout | `universal_viewport_correctness` | ∀-viewport proof |
| AL-T012 | Content unreachable on mobile | `graceful_degradation` | Minimum viewport proof |
| AL-T013 | Breakpoint visual jumps | `breakpoint_continuity` | Delta bound proof |
| AL-T014 | Cross-platform rendering diff | `platform_visual_equivalence` | ε-equivalence proof |
| AL-T015 | Clickjacking via overlays | `not_obscured` in visibility | Z-order proof |
| AL-T016 | UI redressing attacks | `interactive_implies_visible` | Opacity + position proof |
| AL-T017 | Dark patterns (hidden buttons) | Visibility obligation on all interactive | Construction proof |
| AL-T018 | Inaccessible images | `Imej` type requires `alt: Teks` | Type construction |
| AL-T019 | Keyboard-unreachable elements | `all_interactions_possible` | Reachability proof |
| AL-T020 | Color-blind inaccessible UI | `color_blindness_safe` | Perceptual distance proof |
| AL-T021 | Motion sickness triggers | `reduced_motion_safe` | Animation bound proof |
| AL-T022 | Epilepsy-triggering flashes | `no_seizure_triggers` | Flash frequency proof |
| AL-T023 | Layout shift (CLS) | `layout_stability` | Position delta proof |
| AL-T024 | Orphaned headings | `heading_hierarchy` | Structural proof |
| AL-T025 | Missing skip navigation | `skip_nav_present` | Structural proof |
| AL-T026 | Inconsistent spacing | `spacing_harmonic` | Scale adherence proof |
| AL-T027 | Overlapping elements | `no_overlap` for non-stack | Bounding box proof |
| AL-T028 | Right-to-left (RTL) broken | `bidi_correctness` | Mirror proof |
| AL-T029 | Text direction mismatch | `text_direction_consistent` | Unicode bidi proof |
| AL-T030 | Scrolling jank | `frame_budget` ≤ 8333μs | Performance bound proof |

### 4.2 Threats Requiring Runtime Monitoring

| Threat ID | Threat | Why Not Compile-Time | Mitigation |
|-----------|--------|---------------------|------------|
| AL-T031 | Dynamic content overflow | Content length unknown at compile time | Runtime overflow handler with graceful fallback |
| AL-T032 | Network image loading failure | External dependency | Fallback image + error state |
| AL-T033 | Font loading failure | External dependency | Fallback font stack proven compatible |
| AL-T034 | User-generated content XSS | Dynamic content | Sanitization effect gate |
| AL-T035 | Device-specific rendering bugs | Hardware/driver bugs | Tested per-device + ε tolerance |

### 4.3 Gap Analysis vs. Existing Proofs

| Existing Proof (Current) | Verified Layout Extension | Status |
|--------------------------|--------------------------|--------|
| `VerifiedUI.v` — clickjacking (22 Qed) | Subsumed by AL-T015, AL-T016 | Extend |
| `VisualAccessibility.v` — WCAG (10 Qed) | Subsumed by AL-T004, AL-T005, AL-T020 | Extend |
| `MotorAccessibility.v` — input (9 Qed) | Subsumed by AL-T019 | Extend |
| `CognitiveAccessibility.v` (11 Qed) | Subsumed by AL-T021, AL-T022 | Extend |
| `AnimationEngine.v` — 120fps (5 Qed) | Extended by AL-T030 | Compatible |
| `PlatformStdlibVerification.v` | Extended by AL-T014 | Compatible |
| **NEW: Layout containment** | AL-T001 through AL-T003 | To build |
| **NEW: Responsive proofs** | AL-T011 through AL-T013 | To build |
| **NEW: Typography proofs** | AL-T009, AL-T010 | To build |
| **NEW: Form accessibility** | AL-T007, AL-T008 | To build |

---

## 5. IMPLEMENTATION ROADMAP

### Phase AL-1: Formal Layout Model (Foundation)

**Goal:** Formalize RIINA's layout primitives in Coq.

| Deliverable | File | Proofs | Description |
|-------------|------|--------|-------------|
| Box model | `foundations/layout/BoxModel.v` | ~15 | Box sizing, margin collapsing, containment |
| Flexbox model | `foundations/layout/Flexbox.v` | ~25 | Single-axis flex, wrapping, alignment |
| Grid model | `foundations/layout/Grid.v` | ~20 | Track sizing, cell placement, spanning |
| Viewport model | `foundations/layout/Viewport.v` | ~10 | Parametric viewport, breakpoints, DPI |
| Composition | `foundations/layout/Composition.v` | ~15 | Modular layout composition, nesting |

**Dependencies:** None — pure formalization work.
**Prior art to adapt:** Cassius CSS formalization (Racket → Coq port).

### Phase AL-2: Accessibility Proofs (Extension)

**Goal:** Extend existing accessibility proofs to cover layout properties.

| Deliverable | File | Proofs | Description |
|-------------|------|--------|-------------|
| Contrast | `properties/layout/Contrast.v` | ~10 | WCAG AA/AAA contrast ratio proofs |
| Touch targets | `properties/layout/TouchTarget.v` | ~8 | Minimum 48dp interactive elements |
| Typography | `properties/layout/Typography.v` | ~12 | Font size, line height, text containment |
| Form access | `properties/layout/FormAccessibility.v` | ~10 | Labels, tab order, keyboard access |
| Motion safety | `properties/layout/MotionSafety.v` | ~8 | Reduced motion, flash prevention |

**Dependencies:** Phase AL-1 (box model types).
**Extends:** `VisualAccessibility.v`, `MotorAccessibility.v`, `CognitiveAccessibility.v`.

### Phase AL-3: Responsive Proofs (Novel)

**Goal:** Prove layout correctness across ALL viewport dimensions.

| Deliverable | File | Proofs | Description |
|-------------|------|--------|-------------|
| Universal correctness | `properties/layout/Responsive.v` | ~15 | ∀-viewport containment, overflow |
| Breakpoint continuity | `properties/layout/Breakpoints.v` | ~10 | Smooth transitions, no visual jumps |
| Graceful degradation | `properties/layout/Degradation.v` | ~10 | Mobile-minimum content accessibility |
| Finitization | `properties/layout/Finitization.v` | ~8 | Reduce ∀-viewport to finite checks (per VizAssert) |

**Dependencies:** Phase AL-1, Phase AL-2.
**Novel contribution:** No prior art for responsive layout proofs in a type system.

### Phase AL-4: Compiler Integration (Implementation)

**Goal:** Integrate layout verification into `riinac`.

| Deliverable | Crate | Description |
|-------------|-------|-------------|
| Layout types | `riina-types` | Add `Susun`, `Lentur`, `Grid`, `Tindanan` types |
| Layout parser | `riina-parser` | Parse layout declarations in `.rii` |
| Obligation gen | `riina-types` | Generate proof obligations from layout AST |
| Constraint solver | `riina-verify` | Arithmetic solver for layout constraints |
| Error messages | `riinac` | Layout-specific diagnostics with fix hints |

**Dependencies:** Phase AL-1 through AL-3 (proofs must exist before compiler enforces them).

### Phase AL-5: Platform Codegen (Output)

**Goal:** Generate platform-specific layout code from verified declarations.

| Deliverable | Backend | Description |
|-------------|---------|-------------|
| CSS emitter | Web | Verified flexbox/grid → CSS output |
| SwiftUI emitter | iOS | Verified layout → SwiftUI View code |
| Compose emitter | Android | Verified layout → Compose modifiers |
| Canvas emitter | WASM | Verified layout → Canvas drawing commands |
| Equivalence proofs | Coq | Prove all emitters produce equivalent visual output |

**Dependencies:** Phase AL-4, existing backend trait (`riina-codegen`).

---

## 6. COMPLETE PROPERTY ENUMERATION

### 6.1 Layout Properties (47 properties)

| # | Property | Category | Proof Type | WCAG |
|---|----------|----------|-----------|------|
| 1 | No horizontal overflow | Containment | ∀-viewport | — |
| 2 | No vertical content clipping | Containment | ∀-viewport | — |
| 3 | Child ≤ parent width | Containment | Structural | — |
| 4 | Child ≤ parent height (or scrolls) | Containment | Structural | — |
| 5 | No element at negative position | Containment | ∀-viewport | — |
| 6 | No overlapping non-stacked elements | Containment | Bounding box | — |
| 7 | Flex items wrap correctly | Flex | ∀-viewport | — |
| 8 | Flex gap maintained | Flex | Arithmetic | — |
| 9 | Flex alignment correct | Flex | Position | — |
| 10 | Grid tracks sized correctly | Grid | Arithmetic | — |
| 11 | Grid items placed in cells | Grid | Position | — |
| 12 | Grid spanning correct | Grid | Position | — |
| 13 | Responsive breakpoints activate | Responsive | Threshold | — |
| 14 | Breakpoint transition smooth | Responsive | Delta bound | — |
| 15 | Mobile-first degradation | Responsive | Minimum vp | — |
| 16 | Spacing follows harmonic scale | Visual | Ratio | — |
| 17 | Padding consistent | Visual | Equality | — |
| 18 | Margin collapsing correct | Visual | Box model | — |
| 19 | Z-order deterministic | Stacking | Order | — |
| 20 | No layout shift (CLS = 0) | Stability | Position delta | — |
| 21 | RTL layout mirrors correctly | Bidi | Mirror | — |
| 22 | Scrolling region bounded | Scroll | Containment | — |
| 23 | Sticky elements within bounds | Position | Constraint | — |
| 24 | Aspect ratio preserved | Media | Ratio | — |
| 25 | Min-width respected | Sizing | Bound | — |
| 26 | Max-width respected | Sizing | Bound | — |
| 27 | Min-height respected | Sizing | Bound | — |
| 28 | Max-height respected | Sizing | Bound | — |
| 29 | Content-based sizing correct | Sizing | Content | — |
| 30 | Percentage sizing correct | Sizing | Relative | — |
| 31 | Viewport units correct | Sizing | Viewport | — |
| 32 | Clamp units bounded | Sizing | Interval | — |
| 33 | No subpixel rendering artifacts | Rendering | Rounding | — |
| 34 | Border-box sizing consistent | Box model | Arithmetic | — |
| 35 | Overflow: scroll works | Scroll | Containment | — |
| 36 | Overflow: hidden clips correctly | Clipping | Bounding box | — |
| 37 | Position: absolute within nearest positioned ancestor | Position | Containment | — |
| 38 | Position: fixed within viewport | Position | Viewport | — |
| 39 | Float clearing correct | Float | Structural | — |
| 40 | Multi-column layout correct | Column | Flow | — |
| 41 | Writing-mode vertical correct | Bidi | Axis swap | — |
| 42 | Safe area insets respected (notch) | Platform | Device | — |
| 43 | Print layout correct | Media | @media | — |
| 44 | Reduced transparency supported | Accessibility | @media | WCAG |
| 45 | Forced colors supported | Accessibility | @media | WCAG |
| 46 | Prefers-contrast respected | Accessibility | @media | WCAG |
| 47 | Prefers-reduced-data respected | Performance | @media | — |

### 6.2 Accessibility Properties (38 properties)

| # | Property | WCAG Criterion | Level | Proof Type |
|---|----------|---------------|-------|-----------|
| 1 | Text contrast ≥ 4.5:1 | 1.4.3 | AA | Arithmetic |
| 2 | Text contrast ≥ 7.0:1 | 1.4.6 | AAA | Arithmetic |
| 3 | Large text contrast ≥ 3.0:1 | 1.4.3 | AA | Arithmetic |
| 4 | UI component contrast ≥ 3.0:1 | 1.4.11 | AA | Arithmetic |
| 5 | Focus indicator visible | 2.4.7 | AA | Visibility |
| 6 | Focus indicator contrast ≥ 3.0:1 | 2.4.11 | AAA | Arithmetic |
| 7 | Touch target ≥ 44×44 CSS px | 2.5.5 | AAA | Size bound |
| 8 | Touch target ≥ 24×24 CSS px | 2.5.8 | AA | Size bound |
| 9 | All images have alt text | 1.1.1 | A | Type construction |
| 10 | Decorative images alt="" | 1.1.1 | A | Type construction |
| 11 | Form inputs have labels | 1.3.1 | A | Structural |
| 12 | Error messages identify field | 3.3.1 | A | Structural |
| 13 | Error suggestions provided | 3.3.3 | AA | Structural |
| 14 | Heading hierarchy logical | 1.3.1 | A | Structural |
| 15 | Landmark regions present | 1.3.1 | A | Structural |
| 16 | Skip navigation link | 2.4.1 | A | Structural |
| 17 | Page title descriptive | 2.4.2 | A | Non-empty |
| 18 | Link purpose clear | 2.4.4 | A | Non-empty |
| 19 | Language attribute set | 3.1.1 | A | Non-empty |
| 20 | Tab order logical | 2.4.3 | A | Order equivalence |
| 21 | No keyboard trap | 2.1.2 | A | Reachability |
| 22 | All functionality keyboard accessible | 2.1.1 | A | Reachability |
| 23 | No flashing > 3/sec | 2.3.1 | A | Frequency bound |
| 24 | No flashing at all | 2.3.2 | AAA | Frequency bound |
| 25 | Reduced motion respected | 2.3.3 | AAA | @media check |
| 26 | Text resizable to 200% | 1.4.4 | AA | Responsive |
| 27 | Content reflows at 320px | 1.4.10 | AA | Responsive |
| 28 | Text spacing adjustable | 1.4.12 | AA | Override support |
| 29 | Color not sole indicator | 1.4.1 | A | Redundant cue |
| 30 | Audio control available | 1.4.2 | A | Control present |
| 31 | Captions provided | 1.2.2 | A | Media type |
| 32 | Live region announcements | 4.1.3 | AA | ARIA |
| 33 | Status messages programmatic | 4.1.3 | AA | ARIA |
| 34 | Consistent navigation | 3.2.3 | AA | Structural |
| 35 | Consistent identification | 3.2.4 | AA | Structural |
| 36 | Error prevention (legal) | 3.3.4 | AA | Confirmation |
| 37 | Drag alternatives | 2.5.7 | AA | Alternative input |
| 38 | Target spacing ≥ 24px | 2.5.8 | AA | Size + spacing |

### 6.3 Performance Properties (12 properties)

| # | Property | Bound | Proof Type |
|---|----------|-------|-----------|
| 1 | Layout computation < 16ms | Frame budget | WCET bound |
| 2 | No layout thrashing | Single pass | Structural |
| 3 | Paint within frame budget | 8333μs for 120Hz | Time bound |
| 4 | Compositing O(n) in elements | Linear | Complexity |
| 5 | Reflow minimized on update | Incremental | Change tracking |
| 6 | First Contentful Paint < 1.8s | LCP budget | Pipeline |
| 7 | Cumulative Layout Shift = 0 | Zero CLS | Position stability |
| 8 | Time to Interactive < 3.8s | TTI budget | Pipeline |
| 9 | Largest Contentful Paint < 2.5s | LCP budget | Pipeline |
| 10 | Total Blocking Time < 200ms | TBT budget | Pipeline |
| 11 | Scroll frame rate ≥ 60fps | 16.67ms budget | Time bound |
| 12 | Animation frame rate ≥ 120fps | 8.33ms budget | Time bound |

### 6.4 Cross-Platform Properties (8 properties)

| # | Property | Proof Type |
|---|----------|-----------|
| 1 | Web ≈ iOS rendering (ε ≤ 1dp) | Position delta |
| 2 | Web ≈ Android rendering (ε ≤ 1dp) | Position delta |
| 3 | iOS ≈ Android rendering (ε ≤ 1dp) | Position delta |
| 4 | All platforms same content | Content equality |
| 5 | All platforms same interaction | Behavior equivalence |
| 6 | All platforms same accessibility | Feature parity |
| 7 | Platform-specific UI idioms correct | Platform rules |
| 8 | Safe area handling per-platform | Device metadata |

---

## 7. BAHASA MELAYU KEYWORD REFERENCE (Layout System)

| Bahasa Melayu | English | Type/Usage |
|---------------|---------|-----------|
| `Susun` | Layout | Base layout type |
| `Lentur` | Flex | Flexbox layout |
| `Grid` | Grid | Grid layout |
| `Tindanan` | Stack | Z-axis stacking |
| `Paparan` | Display/View | Renderable output |
| `Elemen` | Element | UI element |
| `Komponen` | Component | Reusable component |
| `Gaya` | Style | Visual style |
| `Warna` | Color | Color type |
| `Saiz` | Size | Dimension type |
| `Butang` | Button | Button element |
| `Imej` | Image | Image element (requires alt) |
| `Borang` | Form | Form container |
| `Medan` | Field | Form field |
| `Teks` | Text | Text element |
| `Senarai` | List | List container |
| `Responsif` | Responsive | Responsive wrapper |
| `Lukis` | Draw/Render | Rendering effect |
| `susun_lentur` | flex_layout | Flex constructor |
| `arah` | direction | Flex/grid direction |
| `mendatar` | horizontal | Row direction |
| `menegak` | vertical | Column direction |
| `jurang` | gap | Spacing between items |
| `balut` | wrap | Flex wrap mode |
| `jajar_utama` | justify_main | Main axis alignment |
| `jajar_silang` | align_cross | Cross axis alignment |
| `tengah` | center | Center alignment |
| `mula` | start | Start alignment |
| `akhir` | end | End alignment |
| `antara` | space_between | Space-between |
| `sekeliling` | space_around | Space-around |
| `lajur` | column | Grid column |
| `baris` | row | Grid row |
| `lebar` | width | Width property |
| `tinggi` | height | Height property |
| `tepi` | margin | Margin |
| `pelapik` | padding | Padding |
| `sempadan` | border | Border |
| `dp` | dp | Density-independent pixel |
| `sp` | sp | Scale-independent pixel |
| `fr` | fr | Fractional unit |
| `pct` | percent | Percentage |
| `vw` | vw | Viewport width unit |
| `vh` | vh | Viewport height unit |
| `warna_teks` | text_color | Text color |
| `warna_latar` | bg_color | Background color |
| `saiz_fon` | font_size | Font size |
| `tinggi_baris` | line_height | Line height |
| `sumber` | source | Image/resource source |
| `alt` | alt | Alt text |
| `label` | label | Accessibility label |
| `aksi` | action | Event handler |

---

## 8. COMPARISON WITH ALL EXISTING APPROACHES

| Approach | Correctness | Scope | Automation | Runtime Cost | RIINA Advantage |
|----------|------------|-------|-----------|-------------|-----------------|
| Manual CSS | None | N/A | None | 0 | Proven correct |
| CSS Linters (Stylelint) | Heuristic | Syntax only | Partial | 0 | Semantic, not syntactic |
| Browser DevTools | Spot check | 1 viewport | Manual | 0 | All viewports |
| Visual regression testing | Screenshot diff | N viewpoints | Partial | Build time | ∀ viewports, not N |
| Storybook + Chromatic | Visual diff | N viewpoints | Good | Build time | Mathematical proof |
| Lighthouse/axe | Heuristic a11y | Runtime DOM | Good | Runtime | Compile-time, complete |
| TypeScript + React | Type-safe JSX | Component types | Good | 0 | Layout correctness, not just types |
| SwiftUI previews | Visual check | N devices | Partial | Build time | Proven, not checked |
| Flutter widget tests | Unit tests | Per-widget | Manual | Test time | Proven correct by construction |
| Cassius/VizAssert | Formal | CSS 2.1 | Automated | Verification time | Integrated in language, modern CSS |
| **RIINA Verified Layout** | **Formal proof** | **All layout** | **Automatic** | **0 (compile-time)** | **First language-integrated solution** |

---

## 9. RESEARCH QUESTIONS

### 9.1 Open Questions (Require Investigation)

| # | Question | Difficulty | Impact |
|---|----------|-----------|--------|
| 1 | Can flexbox wrapping be fully decidable in linear arithmetic? | Hard | Critical |
| 2 | How to handle content-dependent sizing (intrinsic sizes)? | Hard | Critical |
| 3 | Can grid auto-placement be formalized tractably? | Medium | High |
| 4 | What is the complexity of ∀-viewport proofs for nested layouts? | Hard | High |
| 5 | Can font metrics be reliably abstracted across platforms? | Medium | High |
| 6 | How to handle dynamic content (user text) in static proofs? | Hard | Critical |
| 7 | Can animations be verified for smoothness (C¹ continuity)? | Medium | Medium |
| 8 | How to encode platform-specific rendering differences? | Medium | High |
| 9 | Can Coq's `lia`/`nia` handle the arithmetic complexity? | Medium | Critical |
| 10 | What finitization reductions apply beyond VizAssert's? | Hard | High |

### 9.2 Key Insight: Content-Dependent Sizing

The hardest problem in verified layout is **content-dependent sizing** — a container's size depends on its content, but content layout depends on the container's size. This is the "shrink-to-fit" problem.

**Approach:** Model content-dependent sizing as a fixed-point computation and prove convergence. The CSS specification actually guarantees convergence for all standard layout modes (flex, grid, block). Formalizing this convergence proof in Coq gives RIINA a foundation that doesn't exist anywhere.

### 9.3 Key Insight: Finitization

VizAssert's key contribution is **finitization** — reducing "∀ viewport widths ∈ [320, ∞)" to a finite set of critical points where layout behavior changes (breakpoints, wrapping thresholds, intrinsic size boundaries). Between critical points, layout is a linear function of viewport width.

RIINA should adopt this: the compiler identifies critical points, verifies correctness at each, and proves linearity between them. This makes ∀-viewport proofs tractable.

---

## 10. FILE PLAN

### 10.1 Coq Files to Create

```
02_FORMAL/coq/
├── foundations/
│   └── layout/
│       ├── BoxModel.v              ← Box model formalization
│       ├── Flexbox.v               ← Flexbox algorithm
│       ├── Grid.v                  ← Grid algorithm
│       ├── Viewport.v              ← Viewport model + breakpoints
│       ├── Composition.v           ← Layout composition
│       └── Typography.v            ← Text metrics model
├── properties/
│   └── layout/
│       ├── Containment.v           ← No-overflow proofs
│       ├── Visibility.v            ← Element visibility proofs
│       ├── Contrast.v              ← WCAG contrast proofs
│       ├── TouchTarget.v           ← Touch target size proofs
│       ├── FormAccessibility.v     ← Form label/tab proofs
│       ├── MotionSafety.v          ← Reduced motion/flash proofs
│       ├── Responsive.v            ← ∀-viewport proofs
│       ├── Breakpoints.v           ← Breakpoint continuity proofs
│       ├── Degradation.v           ← Graceful degradation proofs
│       ├── Finitization.v          ← Finitization reductions
│       ├── Typography.v            ← Font size/line height proofs
│       └── PlatformEquivalence.v   ← Cross-platform proofs
└── domains/
    └── layout/
        └── VerifiedLayout.v        ← Master layout verification
```

### 10.2 Rust Files to Create/Modify

```
03_PROTO/crates/
├── riina-types/src/
│   └── layout.rs                   ← Layout type definitions
├── riina-parser/src/
│   └── layout.rs                   ← Layout syntax parsing
├── riina-codegen/src/
│   ├── layout_css.rs               ← CSS layout emitter
│   ├── layout_swiftui.rs           ← SwiftUI layout emitter
│   ├── layout_compose.rs           ← Compose layout emitter
│   └── layout_canvas.rs            ← Canvas layout emitter
└── riinac/src/
    └── layout_check.rs             ← Layout obligation checker
```

### 10.3 Estimated Totals

| Category | Files | Estimated Proofs | Estimated Lines |
|----------|-------|-----------------|-----------------|
| Coq foundations | 6 | ~85 | ~3,000 |
| Coq properties | 12 | ~120 | ~4,000 |
| Coq domains | 1 | ~20 | ~800 |
| Rust types/parser | 2 | N/A | ~1,500 |
| Rust codegen | 4 | N/A | ~2,000 |
| Rust checker | 1 | N/A | ~800 |
| **Total** | **26** | **~225** | **~12,100** |

---

## 11. RELATIONSHIP TO EXISTING TRACKS

| Track | Relationship | Integration Point |
|-------|-------------|-------------------|
| A (Formal Proofs) | AL extends A's proof framework | Same Coq project, shared foundations |
| B (Prototype) | AL adds layout types to compiler | `riina-types`, `riina-parser`, `riinac` |
| UX-01 (Verified UI) | AL subsumes and extends UX-01 | `VerifiedUI.v` becomes part of AL |
| MOBILEOS03 (UIUX Perfection) | AL formalizes MOBILEOS03's aspirations | Proofs for the 100 theorems |
| AL-T014-T015 (Clickjacking) | Already proven in `VerifiedUI.v` | Direct reuse |
| PlatformStdlib | AL extends platform verification to layout | `PlatformStdlibVerification.v` |
| AM (AI-First Language) | AI generates verified layouts | Compiler-in-the-loop for layout |

---

## 12. SUCCESS CRITERIA

**The Verified Layout track is complete when:**

1. A RIINA developer can write `fungsi paparan() -> Paparan kesan Lukis { ... }` with layout declarations
2. The compiler automatically verifies: no overflow, accessible, responsive, cross-platform
3. If the code compiles, the UI is **mathematically proven** correct on every screen from 320px to 3840px+
4. If the code has a layout bug, the compiler **rejects it** with a clear error and fix hint
5. Zero runtime testing is needed for layout correctness (testing is for behavior, not layout)
6. All 105 properties (47 layout + 38 accessibility + 12 performance + 8 cross-platform) are proven in Coq
7. The Coq proofs compile with 0 admits, 0 Admitted

**"If it compiles, the UI/UX is perfect."**

---

*Track AL-01: Verified Layout — FOUNDATIONAL SPECIFICATION*
*RIINA: Rigorous Immutable Invariant, No Assumptions*
*"Q.E.D. Aeternum."*
