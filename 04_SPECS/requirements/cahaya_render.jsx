import { useState } from "react";

const COLORS = {
  bg: "#0a0e17", surface: "#111827", surfaceAlt: "#1a2332",
  border: "#1e293b", borderActive: "#3b82f6",
  accent: "#3b82f6", accentGlow: "#60a5fa",
  gold: "#d4a843", green: "#10b981", red: "#ef4444",
  purple: "#a78bfa", cyan: "#22d3ee", orange: "#f59e0b",
  text: "#e2e8f0", textDim: "#94a3b8", textMuted: "#64748b",
  white: "#ffffff",
};

// ─── RENDERING PIPELINE VISUALIZATION ───
function PipelineView() {
  const [activeStage, setActiveStage] = useState(null);

  const stages = [
    {
      id: "source", label: "CAHAYA Source", icon: "📝", color: COLORS.purple,
      desc: "paparan, susun_atur, tingkahlaku declarations",
      detail: "Your .riina files with CAHAYA UI blocks. Typed models, session-typed interactions, constraint-based layouts, accessibility-typed styles. This is the ONLY input — everything below is generated.",
      output: "AST with UI proof obligations"
    },
    {
      id: "typecheck", label: "Type + Proof Check", icon: "🔒", color: COLORS.accent,
      desc: "RIINA compiler shared pipeline",
      detail: "The RIINA compiler type-checks everything together: IFC labels (Sulit/Awam), session types, capability types, refinement types for accessibility (contrast ratios computed here). Coq obligations extracted for behavior proofs. Z3 invoked for layout satisfiability.",
      output: "Typed IR + proof certificates"
    },
    {
      id: "layout", label: "Layout Resolution", icon: "📐", color: COLORS.cyan,
      desc: "Z3 constraint solving → lookup tables",
      detail: "Linear constraints extracted from susun_atur blocks. Z3 proves satisfiability for ALL screen sizes in declared range. For each breakpoint, concrete pixel values computed. Result: a pre-computed layout lookup table indexed by screen width. Runtime cost: O(1) array lookup.",
      output: "Layout lookup table (width → positions)"
    },
    {
      id: "scene", label: "Scene Graph Build", icon: "🌳", color: COLORS.green,
      desc: "Typed model → render tree",
      detail: "The paparan function maps typed model to a Scene Graph — a tree of render nodes (RectNode, TextNode, ImageNode, ClipNode, etc.). Each node carries its computed layout rect, style properties, and proof certificates. This is NOT a virtual DOM — it's a typed, immutable render description.",
      output: "Immutable Scene Graph"
    },
    {
      id: "diff", label: "Incremental Diff", icon: "⚡", color: COLORS.orange,
      desc: "Type-guided minimal diff (NOT virtual DOM)",
      detail: "Because the scene graph is typed, the compiler generates specialized diff functions per paparan. Only fields that CAN change (based on the type) are compared. Static content is never diffed. This is 10-100x faster than generic virtual DOM diffing because the diff function is compile-time specialized.",
      output: "Minimal change set"
    },
    {
      id: "commands", label: "GPU Command Gen", icon: "🎮", color: COLORS.red,
      desc: "Platform-specific GPU draw commands",
      detail: "Change set translated to GPU draw commands. Platform backends: WebGPU (browser), Vulkan (Android/Linux/Windows), Metal (iOS/macOS), OpenGL ES (fallback/Huawei). Draw commands use pre-allocated GPU buffers (linear types ensure no leaks). Shaders pre-compiled at build time (like Flutter Impeller).",
      output: "GPU command buffer"
    },
    {
      id: "render", label: "GPU Render", icon: "🖥️", color: COLORS.gold,
      desc: "Hardware-accelerated pixel output",
      detail: "GPU executes the command buffer. Text rendered via signed distance field (SDF) fonts for resolution independence. Animations evaluated on GPU via shader programs generated from tingkahlaku declarations. Zero CPU involvement for steady-state animation frames.",
      output: "Pixels on screen ✓"
    },
  ];

  return (
    <div style={{ padding: "24px 0" }}>
      <h3 style={{ color: COLORS.accent, fontSize: 16, fontWeight: 700, marginBottom: 16, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, textTransform: "uppercase" }}>
        Rendering Pipeline: Source → Pixels
      </h3>
      <div style={{ display: "flex", flexDirection: "column", gap: 2 }}>
        {stages.map((s, i) => (
          <div key={s.id} onClick={() => setActiveStage(activeStage === s.id ? null : s.id)}
            style={{ cursor: "pointer", transition: "all 0.2s" }}>
            <div style={{
              display: "flex", alignItems: "center", gap: 12,
              padding: "12px 16px", borderRadius: 8,
              background: activeStage === s.id ? `${s.color}15` : COLORS.surface,
              border: `1px solid ${activeStage === s.id ? s.color : COLORS.border}`,
            }}>
              <div style={{
                width: 36, height: 36, borderRadius: "50%", display: "flex", alignItems: "center", justifyContent: "center",
                background: `${s.color}20`, fontSize: 18, flexShrink: 0
              }}>{s.icon}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                  <span style={{ color: s.color, fontWeight: 700, fontSize: 13, fontFamily: "JetBrains Mono, monospace" }}>
                    PHASE {i}
                  </span>
                  <span style={{ color: COLORS.text, fontWeight: 600, fontSize: 14 }}>{s.label}</span>
                </div>
                <div style={{ color: COLORS.textDim, fontSize: 12, marginTop: 2 }}>{s.desc}</div>
              </div>
              <div style={{ color: COLORS.textMuted, fontSize: 11, transform: activeStage === s.id ? "rotate(180deg)" : "rotate(0)", transition: "transform 0.2s" }}>▼</div>
            </div>
            {activeStage === s.id && (
              <div style={{
                margin: "0 0 0 24px", padding: "12px 16px", borderLeft: `2px solid ${s.color}`,
                background: COLORS.surfaceAlt, borderRadius: "0 0 8px 8px",
              }}>
                <p style={{ color: COLORS.text, fontSize: 13, lineHeight: 1.6, margin: "0 0 8px 0" }}>{s.detail}</p>
                <div style={{
                  display: "inline-flex", alignItems: "center", gap: 6,
                  padding: "4px 10px", borderRadius: 4, background: `${s.color}15`,
                  fontSize: 11, color: s.color, fontFamily: "JetBrains Mono, monospace"
                }}>
                  OUTPUT → {s.output}
                </div>
              </div>
            )}
            {i < stages.length - 1 && (
              <div style={{ textAlign: "center", color: COLORS.textMuted, fontSize: 10, padding: "2px 0" }}>│</div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── PLATFORM BACKEND TABLE ───
function BackendTable() {
  const backends = [
    { platform: "Web (Browser)", gpu: "WebGPU", fallback: "Canvas 2D", text: "SDF + Canvas", delivery: "WASM module", perf: "<1ms frame" },
    { platform: "Android", gpu: "Vulkan", fallback: "OpenGL ES 3.1", text: "SDF + HarfBuzz", delivery: "Native .so", perf: "<0.5ms frame" },
    { platform: "iOS / macOS", gpu: "Metal", fallback: "—", text: "SDF + CoreText", delivery: "Native binary", perf: "<0.5ms frame" },
    { platform: "Huawei (HarmonyOS)", gpu: "Vulkan / Maleoon", fallback: "OpenGL ES", text: "SDF + HarfBuzz", delivery: "Native HAP", perf: "<0.5ms frame" },
    { platform: "Windows", gpu: "Vulkan / DX12", fallback: "DX11", text: "SDF + DirectWrite", delivery: "Native .exe", perf: "<0.5ms frame" },
    { platform: "Linux Desktop", gpu: "Vulkan", fallback: "OpenGL 4.5", text: "SDF + FreeType", delivery: "Native ELF", perf: "<0.5ms frame" },
    { platform: "watchOS / Wear OS", gpu: "Metal / Vulkan", fallback: "OpenGL ES 2.0", text: "Bitmap pre-rendered", delivery: "Native binary", perf: "<2ms frame" },
    { platform: "Huawei Watch", gpu: "OpenGL ES", fallback: "Software", text: "Bitmap pre-rendered", delivery: "Lite HAP", perf: "<2ms frame" },
    { platform: "Smart TV", gpu: "Vulkan / OpenGL", fallback: "OpenGL ES", text: "SDF + FreeType", delivery: "Native binary", perf: "<1ms frame" },
    { platform: "Terminal (CLI)", gpu: "—", fallback: "ANSI escape", text: "Character grid", delivery: "Native binary", perf: "<0.1ms" },
    { platform: "Embedded / Kiosk", gpu: "OpenGL ES / Vulkan", fallback: "Framebuffer", text: "Pre-rasterized", delivery: "Static binary", perf: "0ms (baked)" },
  ];

  return (
    <div style={{ padding: "24px 0" }}>
      <h3 style={{ color: COLORS.accent, fontSize: 16, fontWeight: 700, marginBottom: 16, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, textTransform: "uppercase" }}>
        Platform Rendering Backends
      </h3>
      <div style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
          <thead>
            <tr>{["Platform", "GPU API", "Fallback", "Text Engine", "Delivery", "Frame Time"].map(h => (
              <th key={h} style={{ padding: "10px 8px", textAlign: "left", color: COLORS.accent, fontWeight: 700, borderBottom: `2px solid ${COLORS.accent}`, fontFamily: "JetBrains Mono, monospace", fontSize: 11, whiteSpace: "nowrap" }}>{h}</th>
            ))}</tr>
          </thead>
          <tbody>
            {backends.map((b, i) => (
              <tr key={i} style={{ background: i % 2 === 0 ? COLORS.surface : "transparent" }}>
                <td style={{ padding: "8px", color: COLORS.text, fontWeight: 600, whiteSpace: "nowrap" }}>{b.platform}</td>
                <td style={{ padding: "8px", color: COLORS.green, fontFamily: "JetBrains Mono, monospace", fontSize: 11 }}>{b.gpu}</td>
                <td style={{ padding: "8px", color: COLORS.textDim, fontFamily: "JetBrains Mono, monospace", fontSize: 11 }}>{b.fallback}</td>
                <td style={{ padding: "8px", color: COLORS.textDim, fontSize: 11 }}>{b.text}</td>
                <td style={{ padding: "8px", color: COLORS.purple, fontFamily: "JetBrains Mono, monospace", fontSize: 11 }}>{b.delivery}</td>
                <td style={{ padding: "8px", color: COLORS.gold, fontWeight: 600, fontFamily: "JetBrains Mono, monospace", fontSize: 11 }}>{b.perf}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// ─── DEVICE PREVIEW: Renders the TELUS screen on each platform ───
function DeviceFrame({ type, children, label, specs }) {
  const frames = {
    phone: { w: 220, h: 420, radius: 28, notch: true, bezel: 12 },
    tablet: { w: 340, h: 240, radius: 18, notch: false, bezel: 10 },
    watch: { w: 120, h: 140, radius: 60, notch: false, bezel: 8 },
    tv: { w: 400, h: 240, radius: 8, notch: false, bezel: 6 },
    desktop: { w: 400, h: 270, radius: 8, notch: false, bezel: 6 },
    terminal: { w: 360, h: 220, radius: 8, notch: false, bezel: 6 },
  };
  const f = frames[type] || frames.phone;

  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 8 }}>
      <div style={{
        width: f.w + f.bezel * 2, padding: f.bezel,
        background: "#2a2a2e", borderRadius: f.radius,
        boxShadow: "0 8px 32px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.1)",
        position: "relative",
      }}>
        {f.notch && (
          <div style={{ position: "absolute", top: f.bezel, left: "50%", transform: "translateX(-50%)", width: 60, height: 6, background: "#1a1a1e", borderRadius: 3, zIndex: 2 }} />
        )}
        <div style={{
          width: f.w, height: f.h - (f.notch ? 30 : 0), marginTop: f.notch ? 18 : 0,
          borderRadius: Math.max(4, f.radius - f.bezel),
          overflow: "hidden", background: "#0f172a",
        }}>
          {children}
        </div>
      </div>
      <div style={{ textAlign: "center" }}>
        <div style={{ color: COLORS.text, fontSize: 12, fontWeight: 600 }}>{label}</div>
        <div style={{ color: COLORS.textMuted, fontSize: 10 }}>{specs}</div>
      </div>
    </div>
  );
}

// The actual TELUS screen content adapted per platform
function TelusScreen({ variant }) {
  const isCompact = variant === "watch";
  const isDark = true;
  const bg = "#0f172a";
  const cardBg = "#1e293b";
  const accent = "#3b82f6";

  const bids = [
    { co: "TechSys Sdn Bhd", amt: "RM 2.45M", tech: 87, fin: 92, status: "✓" },
    { co: "DataCorp MY", amt: "RM 3.12M", tech: 74, fin: 85, status: "✓" },
    { co: "InnoServ Bhd", amt: "[TERSEMBUNYI]", tech: 91, fin: null, status: "⏳" },
  ];

  if (isCompact) {
    return (
      <div style={{ padding: 8, background: bg, height: "100%", fontFamily: "system-ui, sans-serif" }}>
        <div style={{ color: accent, fontSize: 8, fontWeight: 700, marginBottom: 6 }}>TELUS BIDA</div>
        {bids.slice(0, 2).map((b, i) => (
          <div key={i} style={{ padding: "4px 6px", marginBottom: 3, borderRadius: 4, background: cardBg }}>
            <div style={{ color: "#e2e8f0", fontSize: 7, fontWeight: 600 }}>{b.co.split(" ")[0]}</div>
            <div style={{ display: "flex", justifyContent: "space-between", marginTop: 2 }}>
              <span style={{ color: "#10b981", fontSize: 6 }}>T:{b.tech}</span>
              <span style={{ color: b.fin ? "#10b981" : "#f59e0b", fontSize: 6 }}>{b.fin ? `F:${b.fin}` : "..."}</span>
            </div>
          </div>
        ))}
        <div style={{ marginTop: 6, padding: "3px 6px", background: accent, borderRadius: 4, textAlign: "center", color: "#fff", fontSize: 7, fontWeight: 600 }}>Luluskan</div>
      </div>
    );
  }

  const isTV = variant === "tv" || variant === "desktop";
  const fontSize = isTV ? 11 : 9;
  const pad = isTV ? 14 : 10;

  if (variant === "terminal") {
    return (
      <div style={{ padding: 10, background: "#000", height: "100%", fontFamily: "JetBrains Mono, Consolas, monospace", fontSize: 9, color: "#10b981", lineHeight: 1.5 }}>
        <div style={{ color: "#3b82f6" }}>┌─ TELUS Penilaian Bida ──────────────┐</div>
        <div style={{ color: "#e2e8f0" }}>│ Syarikat          │ Jumlah   │ T │ F │</div>
        <div style={{ color: "#64748b" }}>├───────────────────┼──────────┼───┼───┤</div>
        <div>│ TechSys Sdn Bhd   │ RM 2.45M │<span style={{color:"#10b981"}}>87</span> │<span style={{color:"#10b981"}}>92</span> │</div>
        <div>│ DataCorp MY        │ RM 3.12M │<span style={{color:"#f59e0b"}}>74</span> │<span style={{color:"#10b981"}}>85</span> │</div>
        <div>│ InnoServ Bhd       │ <span style={{color:"#ef4444"}}>[HIDDEN]</span> │<span style={{color:"#10b981"}}>91</span> │<span style={{color:"#64748b"}}>--</span> │</div>
        <div style={{ color: "#64748b" }}>└───────────────────┴──────────┴───┴───┘</div>
        <div style={{ marginTop: 8, color: "#3b82f6" }}> [L]uluskan  [T]olak  [K]eluar</div>
        <div style={{ marginTop: 4 }}>▌<span style={{ animation: "none", borderRight: "1px solid #10b981" }}> </span></div>
      </div>
    );
  }

  return (
    <div style={{ padding: pad, background: bg, height: "100%", fontFamily: "system-ui, -apple-system, sans-serif", overflow: "hidden" }}>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: pad }}>
        <div>
          <div style={{ color: accent, fontSize: fontSize + 3, fontWeight: 700 }}>Penilaian Bida</div>
          <div style={{ color: COLORS.textMuted, fontSize: fontSize - 2 }}>TELUS Procurement</div>
        </div>
        <div style={{ width: isTV ? 28 : 20, height: isTV ? 28 : 20, borderRadius: "50%", background: "#10b981", display: "flex", alignItems: "center", justifyContent: "center", color: "#fff", fontSize: fontSize - 2, fontWeight: 700 }}>IA</div>
      </div>

      {/* Table Header */}
      <div style={{ display: "grid", gridTemplateColumns: isTV ? "2fr 1.2fr 0.6fr 0.6fr 0.6fr" : "1.5fr 1fr 0.5fr 0.5fr", gap: 4, padding: "6px 8px", borderRadius: 6, background: "#0d1117", marginBottom: 4 }}>
        <div style={{ color: COLORS.textMuted, fontSize: fontSize - 2, fontWeight: 600 }}>Syarikat</div>
        {isTV && <div style={{ color: COLORS.textMuted, fontSize: fontSize - 2, fontWeight: 600 }}>Jumlah</div>}
        <div style={{ color: COLORS.textMuted, fontSize: fontSize - 2, fontWeight: 600, textAlign: "center" }}>Tek</div>
        <div style={{ color: COLORS.textMuted, fontSize: fontSize - 2, fontWeight: 600, textAlign: "center" }}>Kew</div>
        <div style={{ color: COLORS.textMuted, fontSize: fontSize - 2, fontWeight: 600, textAlign: "center" }}>⬤</div>
      </div>

      {/* Rows */}
      {bids.map((b, i) => (
        <div key={i} style={{
          display: "grid", gridTemplateColumns: isTV ? "2fr 1.2fr 0.6fr 0.6fr 0.6fr" : "1.5fr 1fr 0.5fr 0.5fr",
          gap: 4, padding: "8px", marginBottom: 3, borderRadius: 6,
          background: cardBg, border: `1px solid ${i === 2 ? "#f59e0b30" : "transparent"}`
        }}>
          <div style={{ color: COLORS.text, fontSize, fontWeight: 600, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{b.co}</div>
          {isTV && <div style={{ color: b.amt.includes("TERSEMBUNYI") ? "#ef4444" : "#10b981", fontSize, fontFamily: "JetBrains Mono, monospace" }}>{b.amt}</div>}
          <div style={{ color: b.tech >= 85 ? "#10b981" : "#f59e0b", fontSize, textAlign: "center", fontWeight: 700 }}>{b.tech}</div>
          <div style={{ color: b.fin ? (b.fin >= 85 ? "#10b981" : "#f59e0b") : "#64748b", fontSize, textAlign: "center", fontWeight: 700 }}>{b.fin || "—"}</div>
          <div style={{ fontSize, textAlign: "center" }}>{b.status}</div>
        </div>
      ))}

      {/* Action Button */}
      <div style={{
        marginTop: pad, padding: isTV ? "10px 0" : "8px 0", background: accent, borderRadius: 8,
        textAlign: "center", color: "#fff", fontSize, fontWeight: 700,
        opacity: 0.5
      }}>
        Luluskan Bida Terbaik
      </div>
      <div style={{ color: COLORS.textMuted, fontSize: fontSize - 3, textAlign: "center", marginTop: 4 }}>
        ⏳ Menunggu semua penilaian selesai
      </div>
    </div>
  );
}

// ─── VISUAL DETERMINATION SECTION ───
function VisualDeterminationView() {
  return (
    <div style={{ padding: "24px 0" }}>
      <h3 style={{ color: COLORS.accent, fontSize: 16, fontWeight: 700, marginBottom: 16, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, textTransform: "uppercase" }}>
        What Determines the Visual?
      </h3>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
        {[
          { icon: "🎨", title: "gaya (Theme)", desc: "Color palette, typography, spacing scale, shadows, border radii. Compiler-verified for WCAG contrast. You declare the design tokens — CAHAYA enforces they're accessible.", color: COLORS.purple },
          { icon: "📐", title: "susun_atur (Layout)", desc: "Constraint-based layout system. You declare relationships (A.left == B.right + 16dp). Z3 solves for every screen size. Result: pixel-perfect on all devices, proven at compile time.", color: COLORS.cyan },
          { icon: "🖼️", title: "paparan (View)", desc: "Declarative rendering function. Maps typed model → scene graph. Pure function: same input always produces same output. Compiler proves totality — no blank screens possible.", color: COLORS.green },
          { icon: "✨", title: "tingkahlaku (Behavior)", desc: "Animations and transitions as algebraic behaviors. Continuous time-varying values composed with standard algebra. GPU-evaluated for zero CPU cost. Compiler proves termination and bounds.", color: COLORS.orange },
          { icon: "📱", title: "Platform Adaptation", desc: "CAHAYA's rendering engine adapts to each platform's native conventions: status bars, safe areas, back gestures, scroll physics, text selection. One source, native feel everywhere.", color: COLORS.gold },
          { icon: "🔤", title: "Text Rendering", desc: "Signed Distance Field (SDF) font rendering for resolution independence. HarfBuzz for complex script shaping (Arabic, CJK, Devanagari). Native text APIs used where required (CoreText on Apple, DirectWrite on Windows).", color: COLORS.red },
        ].map((item, i) => (
          <div key={i} style={{ padding: 14, background: COLORS.surface, borderRadius: 10, border: `1px solid ${COLORS.border}` }}>
            <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
              <span style={{ fontSize: 20 }}>{item.icon}</span>
              <span style={{ color: item.color, fontWeight: 700, fontSize: 14, fontFamily: "JetBrains Mono, monospace" }}>{item.title}</span>
            </div>
            <p style={{ color: COLORS.textDim, fontSize: 12, lineHeight: 1.6, margin: 0 }}>{item.desc}</p>
          </div>
        ))}
      </div>

      {/* The key insight */}
      <div style={{ marginTop: 20, padding: 16, background: `${COLORS.accent}10`, border: `1px solid ${COLORS.accent}40`, borderRadius: 10 }}>
        <div style={{ color: COLORS.accent, fontWeight: 700, fontSize: 14, marginBottom: 8, fontFamily: "JetBrains Mono, monospace" }}>
          KEY ARCHITECTURAL DECISION: Own Rendering Engine
        </div>
        <p style={{ color: COLORS.text, fontSize: 13, lineHeight: 1.7, margin: "0 0 8px 0" }}>
          CAHAYA does <strong>NOT</strong> use the browser DOM, Android Views, UIKit, or any platform UI toolkit. Like Flutter (Impeller/Skia), CAHAYA owns the entire rendering pipeline from scene graph to GPU commands.
        </p>
        <p style={{ color: COLORS.text, fontSize: 13, lineHeight: 1.7, margin: "0 0 8px 0" }}>
          <strong>Why?</strong> Because platform UI toolkits are unverified. The DOM has no type safety. UIKit has no information flow control. Android Views have no session types. To prove that pixels are correct, CAHAYA must control every step from typed model to GPU draw call.
        </p>
        <p style={{ color: COLORS.textDim, fontSize: 12, lineHeight: 1.7, margin: 0 }}>
          The rendering engine is called <strong style={{ color: COLORS.gold }}>Sinar</strong> (Malay: "ray of light") — a retained-mode, tile-based GPU renderer with AOT shader compilation, SDF text, and linear-typed resource management. Think Flutter's Impeller, but with formal verification at every stage.
        </p>
      </div>
    </div>
  );
}

// ─── RENDERING ENGINE DIAGRAM ───
function EngineArchView() {
  return (
    <div style={{ padding: "24px 0" }}>
      <h3 style={{ color: COLORS.accent, fontSize: 16, fontWeight: 700, marginBottom: 16, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, textTransform: "uppercase" }}>
        Sinar Rendering Engine Architecture
      </h3>
      <div style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, borderRadius: 12, padding: 20, fontFamily: "JetBrains Mono, monospace", fontSize: 11, color: COLORS.textDim, lineHeight: 1.8, overflowX: "auto", whiteSpace: "pre" }}>
{`┌─────────────────────────────────────────────────────────┐
│                  CAHAYA Source (.riina)                  │
│   paparan + susun_atur + gaya + tingkahlaku + sesi      │
└───────────────────────┬─────────────────────────────────┘
                        │ RIINA Compiler
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Typed Scene Graph (immutable)               │
│  ┌─────────┐  ┌──────────┐  ┌─────────┐  ┌──────────┐  │
│  │RectNode │  │ TextNode │  │ImageNode│  │ ClipNode │  │
│  │ pos,size│  │ glyphs,  │  │ texture │  │ path,    │  │
│  │ color,  │  │ font,SDF │  │ linear  │  │ children │  │
│  │ radius  │  │ layout   │  │ handle  │  │          │  │
│  └─────────┘  └──────────┘  └─────────┘  └──────────┘  │
└───────────────────────┬─────────────────────────────────┘
                        │ Incremental Diff (type-specialized)
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Sinar Command Buffer                        │
│  ┌────────────────────────────────────────────────────┐  │
│  │ DrawRect(pos, size, color, radius)                 │  │
│  │ DrawGlyphs(font_atlas, positions, colors)          │  │
│  │ DrawTexture(handle, src_rect, dst_rect)            │  │
│  │ SetClip(path) → DrawChildren → ClearClip           │  │
│  │ SetShader(behavior_shader, time_uniform)           │  │
│  └────────────────────────────────────────────────────┘  │
└───────────────────────┬─────────────────────────────────┘
                        │ Platform Backend
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
   ┌────────────┐ ┌──────────┐ ┌──────────┐
   │  WebGPU    │ │  Vulkan  │ │  Metal   │
   │  (Browser) │ │ (Android │ │ (Apple)  │
   │  via WASM  │ │  Linux   │ │          │
   │            │ │  Huawei  │ │          │
   │            │ │  Windows)│ │          │
   └──────┬─────┘ └────┬─────┘ └────┬─────┘
          │             │             │
          ▼             ▼             ▼
   ┌──────────────────────────────────────┐
   │           GPU Hardware               │
   │   AOT shaders │ Linear buffers       │
   │   Tile-based  │ SDF text atlas       │
   │   rendering   │ Behavior shaders     │
   └──────────────────────────────────────┘`}
      </div>
    </div>
  );
}

// ─── MAIN APP ───
export default function CahayaRenderingArchitecture() {
  const [activeTab, setActiveTab] = useState("preview");

  const tabs = [
    { id: "preview", label: "Cross-Platform Preview", icon: "📱" },
    { id: "pipeline", label: "Rendering Pipeline", icon: "⚙️" },
    { id: "engine", label: "Sinar Engine", icon: "🔥" },
    { id: "visual", label: "Visual System", icon: "🎨" },
    { id: "backends", label: "Platform Backends", icon: "🌍" },
  ];

  return (
    <div style={{ background: COLORS.bg, minHeight: "100vh", color: COLORS.text, fontFamily: "system-ui, -apple-system, sans-serif" }}>
      {/* Header */}
      <div style={{ padding: "24px 24px 0", borderBottom: `1px solid ${COLORS.border}` }}>
        <div style={{ display: "flex", alignItems: "baseline", gap: 12, marginBottom: 4 }}>
          <h1 style={{ margin: 0, fontSize: 28, fontWeight: 800, color: COLORS.white, letterSpacing: -0.5 }}>CAHAYA</h1>
          <span style={{ color: COLORS.gold, fontSize: 13, fontWeight: 600, fontFamily: "JetBrains Mono, monospace" }}>Rendering Architecture</span>
        </div>
        <p style={{ color: COLORS.textDim, fontSize: 13, margin: "4px 0 16px" }}>
          How CAHAYA goes from typed source to GPU-rendered pixels on every platform
        </p>
        <div style={{ display: "flex", gap: 0, overflowX: "auto" }}>
          {tabs.map(t => (
            <button key={t.id} onClick={() => setActiveTab(t.id)}
              style={{
                padding: "10px 16px", border: "none", cursor: "pointer",
                background: activeTab === t.id ? COLORS.surface : "transparent",
                color: activeTab === t.id ? COLORS.accent : COLORS.textMuted,
                borderBottom: activeTab === t.id ? `2px solid ${COLORS.accent}` : "2px solid transparent",
                fontSize: 12, fontWeight: 600, display: "flex", alignItems: "center", gap: 6,
                whiteSpace: "nowrap", transition: "all 0.15s",
              }}>
              <span>{t.icon}</span> {t.label}
            </button>
          ))}
        </div>
      </div>

      {/* Content */}
      <div style={{ padding: "0 24px 40px", maxWidth: 1000, margin: "0 auto" }}>

        {activeTab === "preview" && (
          <div style={{ padding: "24px 0" }}>
            <h3 style={{ color: COLORS.accent, fontSize: 16, fontWeight: 700, marginBottom: 8, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, textTransform: "uppercase" }}>
              One Source → Every Screen
            </h3>
            <p style={{ color: COLORS.textDim, fontSize: 13, marginBottom: 24 }}>
              The same CAHAYA paparan renders on every platform. The rendering engine adapts layout, density, interaction patterns, and platform conventions automatically. Below: the TELUS bid evaluation screen on every target.
            </p>

            {/* Mobile Row */}
            <div style={{ marginBottom: 32 }}>
              <div style={{ color: COLORS.textMuted, fontSize: 11, fontWeight: 600, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, marginBottom: 16 }}>
                MOBILE NATIVE
              </div>
              <div style={{ display: "flex", gap: 24, flexWrap: "wrap", justifyContent: "center" }}>
                <DeviceFrame type="phone" label="Android" specs="Vulkan · Material You">
                  <TelusScreen variant="phone" />
                </DeviceFrame>
                <DeviceFrame type="phone" label="iOS / iPhone" specs="Metal · Human Interface">
                  <TelusScreen variant="phone" />
                </DeviceFrame>
                <DeviceFrame type="phone" label="HarmonyOS / Huawei" specs="Vulkan/Maleoon · ArkUI-compat">
                  <TelusScreen variant="phone" />
                </DeviceFrame>
              </div>
            </div>

            {/* Watch Row */}
            <div style={{ marginBottom: 32 }}>
              <div style={{ color: COLORS.textMuted, fontSize: 11, fontWeight: 600, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, marginBottom: 16 }}>
                WEARABLES
              </div>
              <div style={{ display: "flex", gap: 24, flexWrap: "wrap", justifyContent: "center" }}>
                <DeviceFrame type="watch" label="Apple Watch" specs="Metal · watchOS">
                  <TelusScreen variant="watch" />
                </DeviceFrame>
                <DeviceFrame type="watch" label="Wear OS" specs="Vulkan · Tiles API">
                  <TelusScreen variant="watch" />
                </DeviceFrame>
                <DeviceFrame type="watch" label="Huawei Watch" specs="OpenGL ES · Lite HAP">
                  <TelusScreen variant="watch" />
                </DeviceFrame>
              </div>
            </div>

            {/* Web Row */}
            <div style={{ marginBottom: 32 }}>
              <div style={{ color: COLORS.textMuted, fontSize: 11, fontWeight: 600, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, marginBottom: 16 }}>
                WEB (DESKTOP & MOBILE BROWSER)
              </div>
              <div style={{ display: "flex", gap: 24, flexWrap: "wrap", justifyContent: "center" }}>
                <DeviceFrame type="desktop" label="Web App (Desktop)" specs="WebGPU via WASM · Any browser">
                  <TelusScreen variant="desktop" />
                </DeviceFrame>
                <DeviceFrame type="phone" label="Mobile Web" specs="WebGPU/Canvas2D · Safari/Chrome">
                  <TelusScreen variant="phone" />
                </DeviceFrame>
              </div>
            </div>

            {/* Desktop + TV + Terminal */}
            <div style={{ marginBottom: 32 }}>
              <div style={{ color: COLORS.textMuted, fontSize: 11, fontWeight: 600, fontFamily: "JetBrains Mono, monospace", letterSpacing: 2, marginBottom: 16 }}>
                DESKTOP · TV · TERMINAL
              </div>
              <div style={{ display: "flex", gap: 24, flexWrap: "wrap", justifyContent: "center" }}>
                <DeviceFrame type="desktop" label="macOS / Windows / Linux" specs="Metal/Vulkan/DX12 · Native binary">
                  <TelusScreen variant="desktop" />
                </DeviceFrame>
                <DeviceFrame type="tv" label="Smart TV" specs="Vulkan/OpenGL · D-pad navigation">
                  <TelusScreen variant="tv" />
                </DeviceFrame>
                <DeviceFrame type="terminal" label="Terminal (TUI)" specs="ANSI · Character grid · SSH-able">
                  <TelusScreen variant="terminal" />
                </DeviceFrame>
              </div>
            </div>

            {/* The crucial explanation */}
            <div style={{ padding: 16, background: COLORS.surface, border: `1px solid ${COLORS.border}`, borderRadius: 12, marginTop: 16 }}>
              <div style={{ color: COLORS.gold, fontWeight: 700, fontSize: 14, marginBottom: 8, fontFamily: "JetBrains Mono, monospace" }}>
                HOW THE SAME SOURCE ADAPTS
              </div>
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 12 }}>
                {[
                  { title: "Layout Constraints", desc: "Z3 solves for each platform's screen dimensions. Watch: 40mm grid. Phone: 360-428dp. Tablet: 768-1024dp. Desktop: 960-2560dp. TV: 1920dp with overscan." },
                  { title: "Platform Conventions", desc: "Safe areas (iPhone notch), status bars (Android), Digital Crown (Watch), D-pad focus (TV), keyboard navigation (Desktop), scroll physics per platform." },
                  { title: "Density Independence", desc: "All measurements in dp (density-independent pixels). Sinar maps to physical pixels per device: 1dp = 1px at mdpi, 2px at xhdpi, 3px at xxhdpi. SDF fonts scale perfectly." },
                ].map((item, i) => (
                  <div key={i}>
                    <div style={{ color: COLORS.accent, fontSize: 11, fontWeight: 700, marginBottom: 4 }}>{item.title}</div>
                    <div style={{ color: COLORS.textDim, fontSize: 11, lineHeight: 1.5 }}>{item.desc}</div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {activeTab === "pipeline" && <PipelineView />}
        {activeTab === "engine" && <EngineArchView />}
        {activeTab === "visual" && <VisualDeterminationView />}
        {activeTab === "backends" && <BackendTable />}
      </div>
    </div>
  );
}
