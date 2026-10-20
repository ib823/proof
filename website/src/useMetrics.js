import { useState, useEffect } from 'react';

// Fallback defaults (used while loading or on fetch error).
// Keep in sync with the *shape* of metrics.json — values here are stale-safe minimums.
const DEFAULTS = {
  version: '0.0.0',
  // countingPolicy holds the only Coq counts the site publishes (owner ruling
  // D9): core, model and excluded Qed. Never display the raw qedActive total.
  proofs: {
    admitted: 0, axioms: 0, assumptions: 0, parameters: 29,
    countingPolicy: { coreMechanizedQed: 1679, modelMechanizedQedNonvacuous: 9719, excludedQed: 1421 },
  },
  coq: { filesActive: 0, filesTotal: 0, prover: 'Rocq 9.1.1' },
  lean: { theorems: 0, files: 0, prover: 'Lean 4', sorry: 0, axioms: 0 },
  isabelle: { lemmas: 0, files: 0, prover: 'Isabelle/HOL', sorry: 0 },
  fstar: { lemmas: 0, files: 0, prover: 'F*' },
  tlaplus: { theorems: 0, files: 0, prover: 'TLA+' },
  alloy: { assertions: 0, files: 0, prover: 'Alloy 6' },
  smt: { assertions: 0, files: 0, prover: 'Z3/CVC5 (SMT-LIB)' },
  verus: { proofs: 0, files: 0, prover: 'Verus' },
  kani: { harnesses: 0, files: 0, prover: 'Kani' },
  tv: { validations: 0, files: 0, prover: 'Translation Validation' },
  // No cross-prover totals (owner ruling D6, 2026-10-20): never summed.
  multiProver: {
    status: 'IN_PROGRESS',
  },
  quality: {
    coqCompiled: false,
    leanCompiled: false,
    isabelleCompiled: false,
    fstarStatus: 'generated',
    tlaplusStatus: 'generated',
    alloyStatus: 'generated',
    smtStatus: 'generated',
    verusStatus: 'generated',
    kaniStatus: 'generated',
    tvStatus: 'generated',
    runtimeProofStatus: 'generated',
    nonCoqMechanization: {
      reportFresh: false,
      overallMechanized: false,
      source: 'missing_or_stale',
      pending: {
        lean: 'unknown',
        isabelle: 'unknown',
        fstar: 'unknown',
        tlaplus: 'unknown',
        alloy: 'unknown',
        smt: 'unknown',
        verus: 'unknown',
        kani: 'unknown',
        tv: 'unknown',
      },
      backlog: {
        leanSorry: 0,
        leanAxioms: 0,
        isabelleSorry: 0,
        fstarGeneratedFiles: 0,
        smtGeneratedFiles: 0,
        verusGeneratedFiles: 0,
        kaniGeneratedFiles: 0,
        tvGeneratedFiles: 0,
      },
    },
  },
  claimLevels: {
    legend: ['generated', 'compiled', 'mechanized', 'independently_audited'],
    overall: 'generated',
    independentlyAudited: false,
    coq: 'generated',
    lean: 'generated',
    isabelle: 'generated',
    fstar: 'generated',
    tlaplus: 'generated',
    alloy: 'generated',
    smt: 'generated',
    verus: 'generated',
    kani: 'generated',
    tv: 'generated',
    runtimeProofArchitecture: 'generated',
  },
  rust: { tests: 0, crates: 0 },
  examples: 0,
  status: { build: 'unknown', verifiedCommit: '', verifiedMode: '' },
};

export function useMetrics() {
  const [metrics, setMetrics] = useState(DEFAULTS);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(import.meta.env.BASE_URL + 'metrics.json')
      .then(r => r.json())
      .then(data => { setMetrics(data); setLoading(false); })
      .catch(() => setLoading(false));
  }, []);

  return { metrics, loading };
}

// Format a number with commas: 82982 → "82,982"
export const fmt = (n) => Number(n).toLocaleString('en-US');

// The labelled Coq counts (core / model / excluded Qed) plus the trust-base
// figures, falling back to DEFAULTS when a key is missing from metrics.json.
export function coqCounts(metrics) {
  const p = metrics?.proofs || {};
  const cp = p.countingPolicy || {};
  const d = DEFAULTS.proofs;
  return {
    core: cp.coreMechanizedQed ?? d.countingPolicy.coreMechanizedQed,
    model: cp.modelMechanizedQedNonvacuous ?? d.countingPolicy.modelMechanizedQedNonvacuous,
    excluded: cp.excludedQed ?? d.countingPolicy.excludedQed,
    admitted: p.admitted ?? d.admitted,
    axioms: p.axioms ?? d.axioms,
    parameters: p.parameters ?? d.parameters,
  };
}
