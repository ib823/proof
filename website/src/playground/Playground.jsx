// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// RIINA Playground — the real compiler (riina_wasm.wasm) in a Web Worker.
//
// The three examples are validated against the shipped checker: the two
// "rejected" ones genuinely fail `riinac check` with the errors shown, and
// the accepted one is the repository example 00_basics/sulit_dedah.rii.

import React, { useState, useEffect, useRef, useCallback } from 'react';

const ACCENT = '#8b2321';

const EXAMPLES = [
  {
    key: 'leak',
    label: 'Rejected: secret leak',
    file: 'leak.rii',
    code: `// A secret reaching a print sink.
// The checker refuses this program.
fungsi utama() -> Unit kesan Tulis {
    biar pin = sulit 1234;
    cetak(pin);
}`,
  },
  {
    key: 'dedah',
    label: 'Accepted: declassified',
    file: 'sulit_dedah.rii',
    code: `// Secrets and sanctioned declassification.
// This is a repository example — it checks
// AND runs on the shipped compiler.
fungsi utama() -> Unit kesan Tulis {
    cetak(dedah (sulit 1234) dengan bukti (sulit 1234))
}`,
  },
  {
    key: 'effect',
    label: 'Rejected: undeclared effect',
    file: 'bersih.rii',
    code: `// A "pure" function that tries to print.
// Bersih (Pure) does not include Write.
fungsi utama() -> Unit kesan Bersih {
    cetak("hello");
}`,
  },
];

export default function Playground() {
  const [example, setExample] = useState('leak');
  const [source, setSource] = useState(EXAMPLES[0].code);
  const [file, setFile] = useState(EXAMPLES[0].file);
  const [output, setOutput] = useState('');
  const [ran, setRan] = useState(false);
  const [ok, setOk] = useState(null);
  const [wasmReady, setWasmReady] = useState(false);
  const [wasmError, setWasmError] = useState(null);
  const workerRef = useRef(null);
  const idRef = useRef(0);

  useEffect(() => {
    const worker = new Worker(new URL('./worker.js', import.meta.url));
    workerRef.current = worker;
    worker.onmessage = (e) => {
      const { type, result, error } = e.data;
      if (type === 'ready') { setWasmReady(true); return; }
      if (type === 'error') { setWasmError(error); return; }
      if (type === 'result') {
        setRan(true);
        if (error) {
          setOk(false);
          setOutput('error: ' + error);
        } else if (result && result.ok) {
          setOk(true);
          setOutput('Success!\n' + (result.diagnostics || result.output || ''));
        } else {
          setOk(false);
          setOutput((result && (result.error || result.diagnostics)) || 'Unknown error');
        }
      }
    };
    worker.postMessage({ type: 'init' });
    return () => worker.terminate();
  }, []);

  const pick = useCallback((ex) => {
    setExample(ex.key);
    setSource(ex.code);
    setFile(ex.file);
    setRan(false);
    setOk(null);
    setOutput('');
  }, []);

  const runCheck = useCallback(() => {
    if (!workerRef.current || !wasmReady) return;
    idRef.current += 1;
    workerRef.current.postMessage({ type: 'check', source, id: idRef.current });
  }, [source, wasmReady]);

  const status = !ran ? 'idle' : ok ? 'all checks passed' : 'build failed';
  const statusFg = !ran ? '#6b6559' : ok ? '#8fbf9f' : '#c98484';

  return (
    <div className="rise">
      <div className="shell" style={{ paddingTop: 'clamp(40px, 5vw, 60px)', paddingBottom: 'clamp(22px, 2.6vw, 30px)' }}>
        <div className="mono-label" style={{ marginBottom: 18 }}>Playground &middot; the compiler runs in your browser</div>
        <h1 className="serif-h1" style={{ marginBottom: 14, fontSize: 'clamp(34px, 4.2vw, 52px)', maxWidth: 860 }}>Try to write something the checker will accept.</h1>
        <p style={{ margin: 0, fontSize: 'clamp(15.5px, 1.2vw, 17px)', lineHeight: 1.65, color: '#3a352d', maxWidth: 680 }}>
          The compiler is compiled to WebAssembly and runs locally in a worker. Nothing you type leaves the page.
        </p>
      </div>

      <div className="shell" style={{ paddingBottom: 'clamp(60px, 7vw, 90px)' }}>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 16 }}>
          {EXAMPLES.map(ex => {
            const active = example === ex.key;
            return (
              <button key={ex.key} onClick={() => pick(ex)}
                style={{ fontFamily: 'var(--font-mono)', fontSize: 11.5, letterSpacing: '0.08em', textTransform: 'uppercase', padding: '9px 14px', cursor: 'pointer',
                  border: `1px solid ${active ? '#14120f' : '#c9c3b4'}`, background: active ? '#14120f' : 'transparent', color: active ? '#f5f3ee' : '#4a453d' }}>
                {ex.label}
              </button>
            );
          })}
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(330px, 1fr))', gap: 1, background: '#14120f', border: '1px solid #14120f' }}>
          <div style={{ background: '#14120f', display: 'flex', flexDirection: 'column', minHeight: 380 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, padding: '12px 18px', borderBottom: '1px solid #2b2620' }}>
              <span style={{ fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase', color: '#8a8378' }}>{file}</span>
              <button onClick={runCheck} disabled={!wasmReady} className="hov-dark-btn"
                style={{ fontFamily: 'var(--font-mono)', fontSize: 11.5, letterSpacing: '0.1em', textTransform: 'uppercase', background: wasmReady ? '#e8e4da' : '#3a352d', color: wasmReady ? '#14120f' : '#8a8378', border: 'none', padding: '8px 15px', cursor: wasmReady ? 'pointer' : 'wait' }}>
                {ran ? 'Re-check' : wasmReady ? 'Check' : 'loading…'}
              </button>
            </div>
            <div style={{ flex: 1, display: 'flex', padding: 'clamp(14px, 2vw, 22px)' }}>
              <textarea value={source} onChange={e => { setSource(e.target.value); setRan(false); }} spellCheck={false} aria-label="RIINA source"
                style={{ flex: 1, width: '100%', minHeight: 300, background: 'none', border: 'none', outline: 'none', resize: 'none', padding: 0, color: '#e8e4da', caretColor: '#c9a0a0', fontFamily: 'var(--font-mono)', fontSize: 'clamp(12px, 1.05vw, 13.5px)', lineHeight: 1.85, tabSize: 4 }} />
            </div>
          </div>

          <div style={{ background: '#0f0d0b', display: 'flex', flexDirection: 'column', minHeight: 380 }}>
            <div style={{ padding: '12px 18px', borderBottom: '1px solid #2b2620', display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12 }}>
              <span style={{ fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase', color: '#8a8378' }}>riinac check</span>
              <span style={{ fontFamily: 'var(--font-mono)', fontSize: 11, color: statusFg }}>{status}</span>
            </div>
            <div className="noscroll" style={{ flex: 1, overflow: 'auto', padding: 'clamp(16px, 2vw, 24px)' }}>
              {wasmError ? (
                <div style={{ fontFamily: 'var(--font-mono)', fontSize: 13, lineHeight: 1.9, color: '#c98484' }}>
                  The WebAssembly build failed to load ({wasmError}). The playground needs a browser with WebAssembly enabled; the same checks run locally via <span style={{ color: '#b5aea1' }}>riinac check</span>.
                </div>
              ) : !ran ? (
                <div style={{ fontFamily: 'var(--font-mono)', fontSize: 13, lineHeight: 1.9, color: '#6b6559' }}>
                  Edit the source on the left, then press <span style={{ color: '#b5aea1' }}>Check</span> to run the type checker and the security rules over it.
                </div>
              ) : (
                <pre style={{ margin: 0, fontFamily: 'var(--font-mono)', fontSize: 'clamp(12px, 1.05vw, 13.5px)', lineHeight: 1.9, color: ok ? '#e8e4da' : '#c98484', whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>{output}</pre>
              )}
            </div>
          </div>
        </div>

        <div style={{ marginTop: 20, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: 14 }}>
          {[
            ['Read the failure, not just the pass', 'The rejected examples are the more useful ones. They show the exact rule the compiler could not discharge, in the compiler’s own words.'],
            ['This is the real checker', 'The same lexer, parser and typechecker that ship in riinac, compiled to WebAssembly and run in a worker — not a lookalike that pattern-matches your code.'],
            ['Nothing is transmitted', 'No server round-trip, no telemetry, no cookies. The page is static and the check runs on your machine.'],
          ].map(([t, d]) => (
            <div key={t} style={{ border: '1px solid #d8d3c7', background: '#fffdf8', padding: '20px 22px' }}>
              <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 6 }}>{t}</div>
              <div style={{ fontSize: 14, lineHeight: 1.62, color: '#4a453d' }}>{d}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
