// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// RIINA Playground — In-Browser Compiler
// Zero external dependencies (no Monaco, no CodeMirror).

import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';

// Pre-loaded examples
const EXAMPLES = [
  {
    name: 'Hello Dunia',
    code: `// Hello World in RIINA (Bahasa Melayu)
biar nama = "Dunia";
biar mesej = "Selamat datang, " + nama + "!";
mesej`
  },
  {
    name: 'Arithmetic',
    code: `// Arithmetic with variables
biar x = 5;
biar y = 10;
biar hasil = x + y * 2;
hasil`
  },
  {
    name: 'Functions',
    code: `// Multi-parameter functions (curried)
fungsi tambah(x: Nombor, y: Nombor) -> Nombor {
  x + y
}
fungsi ganda(x: Nombor) -> Nombor {
  x * 2
}
biar h = tambah(3, 4);
ganda h`
  },
  {
    name: 'Conditionals',
    code: `// Conditional expressions (kalau / lain)
biar umur = 20;
kalau umur >= 18 {
  "Dewasa"
} lain {
  "Kanak-kanak"
}`
  },
  {
    name: 'Effects',
    code: `// RIINA tracks side effects with kesan:
//   kesan Bersih  = pure (no side effects)
//   kesan Tulis   = can write output
//   kesan Kripto  = cryptographic operations
//   kesan Baca    = can read input
//
// The compiler proves functions only do
// what they declare. No hidden side effects.

// Pure function — guaranteed no I/O
fungsi tambah(x: Nombor, y: Nombor) -> Nombor {
  x + y
}

biar a = tambah(10, 20);
biar b = tambah(a, 5);
b`
  },
  {
    name: 'Recursion',
    code: `// Recursive functions
fungsi faktorial(n: Nombor) -> Nombor {
  kalau n == 0 { 1 }
  lain { n * faktorial(n - 1) }
}

fungsi fibonacci(n: Nombor) -> Nombor {
  kalau n <= 1 { n }
  lain { fibonacci(n - 1) + fibonacci(n - 2) }
}

biar f = faktorial(6);
biar g = fibonacci(10);
f + g`
  },
  {
    name: 'Composition',
    code: `// Function composition
fungsi ganda(x: Nombor) -> Nombor {
  x * 2
}
fungsi tambah_satu(x: Nombor) -> Nombor {
  x + 1
}
fungsi kuadrat(x: Nombor) -> Nombor {
  x * x
}

// Compose: (5 * 2 + 1)^2 = 121
biar a = ganda(5);
biar b = tambah_satu(a);
biar c = kuadrat(b);
c`
  },
  {
    name: 'Tail Recursion',
    code: `// Tail-recursive power function
fungsi kuasa_akum(asas: Nombor, n: Nombor, hasil: Nombor) -> Nombor {
  kalau n == 0 { hasil }
  lain { kuasa_akum(asas, n - 1, hasil * asas) }
}

fungsi kuasa(asas: Nombor, eksponen: Nombor) -> Nombor {
  kuasa_akum(asas, eksponen, 1)
}

biar h = kuasa(2, 10);
h`
  },
  {
    name: 'Actors',
    code: `// JALINAN: Actor-based concurrency
// Define, spawn, send, receive

pelakon Pembilang {
    keadaan: Nombor
    kendalikan Tambah(n) {
        n + 1
    }
}

biar k = lahir Pembilang(0);
hantar(k, 5);
terima(k)`
  },
  {
    name: 'Security',
    code: `// RIINA security types prevent data leaks
// Rahsia<T> = Secret, kesan = effect
//
// The compiler proves:
//   - Secrets can't flow to public outputs
//   - Effects are tracked and declared
//   - Constant-time for crypto operations
//
// Try: change the function and see the
// type checker verify security properties

fungsi kira_selamat(x: Nombor, y: Nombor) -> Nombor {
  biar hasil = x + y;
  hasil * 2
}

kira_selamat(21, 21)`
  },
  {
    name: 'Builtins',
    code: `// Built-in functions (bilingual)
biar nama = "RIINA";
biar p = panjang(nama);
biar mesej = ke_teks(p) + " aksara";
mesej`
  }
];

// ============================================================================
// SYNTAX HIGHLIGHTING
// ============================================================================

const KEYWORDS = new Set([
  'fungsi', 'biar', 'ubah', 'tetap', 'bentuk', 'pilihan', 'jenis', 'sifat',
  'laksana', 'modul', 'guna', 'awam', 'kalau', 'lain', 'untuk', 'selagi',
  'ulang', 'pulang', 'padan', 'keluar', 'terus', 'kesan', 'masa_tetap',
  'sekali', 'benar', 'palsu', 'tiada',
  'pelakon', 'lahir', 'hantar', 'terima', 'kendalikan', 'keadaan',
  'paparan', 'tulisan', 'butang', 'warna', 'kontras', 'baris', 'lajur',
  'kontrak_pintar', 'token', 'konsensus', 'sukuk', 'mudarabah', 'zakat', 'wakaf',
]);

const TYPES = new Set([
  'Nombor', 'Bool', 'Teks', 'Bait', 'Rahsia', 'Senarai', 'Pilihan', 'Hasil',
  'Unit', 'Bersih', 'Baca', 'Tulis', 'Kripto',
]);

function highlightLine(line) {
  const parts = [];
  let i = 0;

  while (i < line.length) {
    // Comments
    if (line[i] === '/' && line[i + 1] === '/') {
      parts.push({ type: 'comment', text: line.slice(i) });
      return parts;
    }

    // Strings
    if (line[i] === '"') {
      let j = i + 1;
      while (j < line.length && line[j] !== '"') {
        if (line[j] === '\\') j++;
        j++;
      }
      parts.push({ type: 'string', text: line.slice(i, j + 1) });
      i = j + 1;
      continue;
    }

    // Numbers
    if (/[0-9]/.test(line[i]) && (i === 0 || /[\s(,=+\-*/<>!]/.test(line[i - 1]))) {
      let j = i;
      while (j < line.length && /[0-9.]/.test(line[j])) j++;
      parts.push({ type: 'number', text: line.slice(i, j) });
      i = j;
      continue;
    }

    // Words (keywords, types, identifiers)
    if (/[a-zA-Z_]/.test(line[i])) {
      let j = i;
      while (j < line.length && /[a-zA-Z0-9_]/.test(line[j])) j++;
      const word = line.slice(i, j);
      if (KEYWORDS.has(word)) {
        parts.push({ type: 'keyword', text: word });
      } else if (TYPES.has(word)) {
        parts.push({ type: 'type', text: word });
      } else {
        parts.push({ type: 'plain', text: word });
      }
      i = j;
      continue;
    }

    // Other characters
    parts.push({ type: 'plain', text: line[i] });
    i++;
  }

  return parts;
}

const TOKEN_COLORS = {
  keyword: 'var(--text-keyword)',
  type: 'var(--text-accent)',
  string: 'var(--text-string)',
  comment: 'var(--text-comment)',
  number: '#60a5fa',
  plain: 'var(--text-primary)',
};

function HighlightedCode({ source }) {
  const lines = source.split('\n');
  return (
    <>
      {lines.map((line, li) => (
        <React.Fragment key={li}>
          {li > 0 && '\n'}
          {highlightLine(line).map((tok, ti) => (
            <span key={ti} style={{ color: TOKEN_COLORS[tok.type] }}>{tok.text}</span>
          ))}
        </React.Fragment>
      ))}
    </>
  );
}

// ============================================================================
// ERROR FORMATTING
// ============================================================================

function formatDiagnostics(raw) {
  if (!raw || raw === 'OK') return { text: 'All checks passed.', isError: false };
  if (raw.startsWith('Error:') || raw.startsWith('Parse error') || raw.startsWith('Type error')) {
    return { text: raw, isError: true };
  }
  return { text: raw, isError: false };
}

// ============================================================================
// URL SHARING
// ============================================================================

function encodeSource(src) {
  try {
    return btoa(unescape(encodeURIComponent(src)));
  } catch {
    return '';
  }
}

function decodeSource(encoded) {
  try {
    return decodeURIComponent(escape(atob(encoded)));
  } catch {
    return null;
  }
}

function getSourceFromHash() {
  const hash = window.location.hash;
  if (hash && hash.startsWith('#code=')) {
    return decodeSource(hash.slice(6));
  }
  return null;
}

// ============================================================================
// PLAYGROUND COMPONENT
// ============================================================================

const PlaygroundPage = ({ onNavigate }) => {
  const initialSource = useMemo(() => getSourceFromHash() || EXAMPLES[0].code, []);
  const [source, setSource] = useState(initialSource);
  const [activeTab, setActiveTab] = useState('Type Check');
  const [diagnostics, setDiagnostics] = useState('');
  const [cOutput, setCOutput] = useState('');
  const [irOutput, setIrOutput] = useState('');
  const [wasmReady, setWasmReady] = useState(false);
  const [wasmError, setWasmError] = useState(null);
  const [shared, setShared] = useState(false);
  const [hasEdited, setHasEdited] = useState(false);
  const [splitRatio, setSplitRatio] = useState(0.5); // #55: Resizable split
  const workerRef = useRef(null);
  const debounceRef = useRef(null);
  const reqIdRef = useRef(0);
  const textareaRef = useRef(null);
  const highlightRef = useRef(null);
  const splitRef = useRef(null);
  const draggingRef = useRef(false);

  // #55: Resize handle drag logic
  const handleMouseDown = useCallback((e) => {
    e.preventDefault();
    draggingRef.current = true;
    const onMouseMove = (e) => {
      if (!draggingRef.current || !splitRef.current) return;
      const rect = splitRef.current.getBoundingClientRect();
      const ratio = (e.clientX - rect.left) / rect.width;
      setSplitRatio(Math.max(0.25, Math.min(0.75, ratio)));
    };
    const onMouseUp = () => {
      draggingRef.current = false;
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('mouseup', onMouseUp);
    };
    document.addEventListener('mousemove', onMouseMove);
    document.addEventListener('mouseup', onMouseUp);
  }, []);

  // Initialize Web Worker
  useEffect(() => {
    try {
      const worker = new Worker(new URL('./worker.js', import.meta.url));
      workerRef.current = worker;

      worker.onmessage = (e) => {
        const { type, result, error, id } = e.data;
        if (type === 'ready') {
          setWasmReady(true);
          return;
        }
        if (type === 'error') {
          setWasmError(error);
          return;
        }
        if (type === 'result') {
          if (error) {
            setDiagnostics('Error: ' + error);
            return;
          }
          if (result) {
            if (result.ok) {
              if (id && id.startsWith('chk_')) {
                setDiagnostics(result.diagnostics || 'OK');
              } else if (id && id.startsWith('c_')) {
                setCOutput(result.output || '');
              } else if (id && id.startsWith('ir_')) {
                setIrOutput(result.output || '');
              }
            } else {
              const errMsg = result.error || 'Unknown error';
              if (id && id.startsWith('chk_')) {
                setDiagnostics(errMsg);
              } else if (id && id.startsWith('c_')) {
                setCOutput(errMsg);
              } else if (id && id.startsWith('ir_')) {
                setIrOutput(errMsg);
              } else {
                setDiagnostics(errMsg);
              }
            }
          }
        }
      };

      return () => worker.terminate();
    } catch {
      setWasmError('Web Workers not supported in this environment');
    }
  }, []);

  // Compile on source change (debounced 300ms)
  const compile = useCallback((src) => {
    if (!workerRef.current || !wasmReady) return;
    const id = ++reqIdRef.current;
    workerRef.current.postMessage({ type: 'check', source: src, id: 'chk_' + id });
    workerRef.current.postMessage({ type: 'emitC', source: src, id: 'c_' + id });
    workerRef.current.postMessage({ type: 'emitIR', source: src, id: 'ir_' + id });
  }, [wasmReady]);

  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => compile(source), 300);
    return () => clearTimeout(debounceRef.current);
  }, [source, compile]);

  // Sync scroll between textarea and highlight overlay
  const syncScroll = useCallback(() => {
    if (textareaRef.current && highlightRef.current) {
      highlightRef.current.scrollTop = textareaRef.current.scrollTop;
      highlightRef.current.scrollLeft = textareaRef.current.scrollLeft;
    }
  }, []);

  const handleExampleChange = (e) => {
    const example = EXAMPLES.find(ex => ex.name === e.target.value);
    if (example) setSource(example.code);
  };

  const handleShare = () => {
    const encoded = encodeSource(source);
    if (encoded) {
      const url = window.location.origin + window.location.pathname + '#code=' + encoded;
      navigator.clipboard.writeText(url).then(() => {
        setShared(true);
        setTimeout(() => setShared(false), 2000);
      }).catch(() => {
        // Fallback: update URL hash
        window.location.hash = 'code=' + encoded;
        setShared(true);
        setTimeout(() => setShared(false), 2000);
      });
    }
  };

  const diag = formatDiagnostics(diagnostics);

  const tabContent = {
    'Type Check': diagnostics,
    'C Output': cOutput,
    'Verified IR': irOutput,
  };

  const tabs = ['Type Check', 'C Output', 'Verified IR'];

  // Shared font styles for textarea/overlay alignment
  const editorFont = {
    fontFamily: 'var(--font-mono)',
    fontSize: 14,
    lineHeight: '22.4px',
    tabSize: 2,
    letterSpacing: 'normal',
    wordSpacing: 'normal',
  };

  return (
    <div>
      <section className="section--sm">
        <div className="container--narrow">
          <h1 style={{ fontSize: 40, fontWeight: 300, marginBottom: 16 }}>Playground</h1>
          <p style={{ color: 'var(--text-secondary)' }}>
            Write RIINA code in your browser. Every program that type-checks inherits
            mathematically proven security guarantees.
          </p>
          <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginTop: 12 }}>
            <p style={{ fontSize: 13, color: 'var(--text-muted)', fontFamily: 'var(--font-mono)', margin: 0 }}>
              {wasmReady ? 'WASM compiler loaded' : wasmError ? wasmError : 'Loading WASM compiler...'}
            </p>
          </div>
        </div>
      </section>

      <div className="playground-container">
        {/* Toolbar */}
        <div className="playground-toolbar">
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <label style={{ fontSize: 13, color: 'var(--text-muted)', fontFamily: 'var(--font-mono)' }}>Example:</label>
            <select
              onChange={handleExampleChange}
              style={{
                fontFamily: 'var(--font-mono)',
                fontSize: 13,
                padding: '4px 8px',
                border: '1px solid var(--border)',
                borderRadius: 4,
                background: 'var(--bg-secondary)',
                color: 'var(--text-primary)',
              }}
            >
              {EXAMPLES.map(ex => (
                <option key={ex.name} value={ex.name}>{ex.name}</option>
              ))}
            </select>
          </div>
          <button
            onClick={handleShare}
            style={{
              fontFamily: 'var(--font-mono)',
              fontSize: 12,
              padding: '5px 14px',
              border: '1px solid var(--border)',
              borderRadius: 4,
              background: shared ? 'var(--bg-tertiary)' : 'var(--bg-secondary)',
              color: shared ? 'var(--text-string)' : 'var(--text-secondary)',
              cursor: 'pointer',
              transition: 'all 0.15s',
            }}
          >
            {shared ? 'Copied!' : 'Share'}
          </button>
        </div>

        {/* #23: Mobile notice */}
        <div className="playground-mobile-notice">
          <p>The playground editor works best on a larger screen.</p>
          <button onClick={() => onNavigate && onNavigate('docs')} className="btn btn--outline" style={{fontSize:14}}>
            View install instructions instead
          </button>
        </div>

        {/* #55: Split pane with resize handle */}
        <div className="playground-split" ref={splitRef}>
          {/* Editor with syntax highlighting overlay */}
          <div className="playground-editor-wrap" style={{flex: `0 0 ${splitRatio * 100}%`}}>
            <div className="playground-editor-label">Source</div>
            <div className="playground-editor-container">
              <pre
                ref={highlightRef}
                className="playground-highlight"
                style={editorFont}
                aria-hidden="true"
              >
                <HighlightedCode source={source} />
                {/* Extra newline so the highlight pre matches textarea scroll height */}
                {'\n'}
              </pre>
              <textarea
                ref={textareaRef}
                value={source}
                onChange={(e) => { setSource(e.target.value); if (!hasEdited) setHasEdited(true); }}
                onScroll={syncScroll}
                spellCheck={false}
                className="playground-textarea"
                style={editorFont}
              />
              {!hasEdited && <div className="playground-hint">Edit the code on the left. Results appear instantly on the right.</div>}
            </div>
          </div>

          {/* #55: Resize handle */}
          <div
            className={`playground-resizer${draggingRef.current ? ' active' : ''}`}
            onMouseDown={handleMouseDown}
            role="separator"
            aria-label="Resize editor panes"
          />

          {/* Output */}
          <div className="playground-output-wrap">
            <div className="playground-tabs">
              {tabs.map(tab => (
                <button
                  key={tab}
                  onClick={() => setActiveTab(tab)}
                  className={`playground-tab${activeTab === tab ? ' playground-tab--active' : ''}`}
                >
                  {tab}
                </button>
              ))}
            </div>
            <pre className={`playground-output${activeTab === 'Type Check' && diag.isError ? ' playground-output--error' : ''}`}>
              {tabContent[activeTab] || (wasmReady ? 'Compiling...' : 'Loading WASM...')}
            </pre>
          </div>
        </div>

        {/* Footer info */}
        <div style={{ marginTop: 16, fontSize: 12, color: 'var(--text-muted)', textAlign: 'center', fontFamily: 'var(--font-mono)' }}>
          RIINA Compiler v0.3.0 &middot; Proprietary
        </div>
      </div>
    </div>
  );
};

export default PlaygroundPage;
