// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Constant-time runtime oracle primitives (Dim14 executable core).

/// Timing class for leakage testing.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SampleClass {
    /// Secret-dependent class.
    Secret,
    /// Public/control class.
    Public,
}

impl SampleClass {
    /// Stable wire encoding used in proof-chain payloads.
    #[must_use]
    pub const fn as_u8(self) -> u8 {
        match self {
            Self::Secret => 1,
            Self::Public => 2,
        }
    }
}

/// One timing observation.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct TimingObservation {
    /// Sample class.
    pub class: SampleClass,
    /// Duration in nanoseconds.
    pub duration_ns: u64,
}

impl TimingObservation {
    /// Canonical payload bytes for runtime proof chain.
    #[must_use]
    pub fn to_payload(self) -> Vec<u8> {
        let mut out = Vec::with_capacity(1 + 8);
        out.push(self.class.as_u8());
        out.extend_from_slice(&self.duration_ns.to_be_bytes());
        out
    }
}

/// Constant-time oracle config.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct CtOracleConfig {
    /// Minimum samples required for each class before evaluation.
    pub min_samples_per_class: usize,
    /// Absolute Welch t-score threshold for leakage alert.
    pub leakage_t_threshold: f64,
}

impl Default for CtOracleConfig {
    fn default() -> Self {
        Self {
            min_samples_per_class: 32,
            leakage_t_threshold: 4.5,
        }
    }
}

/// Constant-time oracle verdict.
#[derive(Debug, Clone, Copy, PartialEq)]
pub enum CtVerdict {
    /// Not enough samples yet.
    InsufficientData,
    /// No statistically significant difference at current threshold.
    Stable {
        /// Welch t-score for current sample populations.
        t_score: f64,
    },
    /// Potential timing leakage detected.
    PotentialLeakage {
        /// Welch t-score for current sample populations.
        t_score: f64,
    },
}

/// Streaming timing oracle with Welch t-test evaluation.
#[derive(Debug, Clone)]
pub struct CtOracle {
    cfg: CtOracleConfig,
    secret_samples: Vec<u64>,
    public_samples: Vec<u64>,
}

impl CtOracle {
    /// Construct a new oracle.
    #[must_use]
    pub const fn new(cfg: CtOracleConfig) -> Self {
        Self {
            cfg,
            secret_samples: Vec::new(),
            public_samples: Vec::new(),
        }
    }

    /// Record one timing observation.
    pub fn record(&mut self, observation: TimingObservation) {
        match observation.class {
            SampleClass::Secret => self.secret_samples.push(observation.duration_ns),
            SampleClass::Public => self.public_samples.push(observation.duration_ns),
        }
    }

    /// Evaluate current verdict using Welch t-test.
    #[must_use]
    #[allow(clippy::cast_precision_loss)]
    pub fn evaluate(&self) -> CtVerdict {
        if self.secret_samples.len() < self.cfg.min_samples_per_class
            || self.public_samples.len() < self.cfg.min_samples_per_class
        {
            return CtVerdict::InsufficientData;
        }

        let (mean_secret, var_secret) = mean_and_sample_variance(&self.secret_samples);
        let (mean_public, var_public) = mean_and_sample_variance(&self.public_samples);
        let n_secret = self.secret_samples.len() as f64;
        let n_public = self.public_samples.len() as f64;
        let denom = ((var_secret / n_secret) + (var_public / n_public)).sqrt();

        if denom == 0.0 {
            return CtVerdict::Stable { t_score: 0.0 };
        }

        let t_score = (mean_secret - mean_public) / denom;
        if t_score.abs() >= self.cfg.leakage_t_threshold {
            CtVerdict::PotentialLeakage { t_score }
        } else {
            CtVerdict::Stable { t_score }
        }
    }
}

#[allow(clippy::cast_precision_loss)]
fn mean_and_sample_variance(samples: &[u64]) -> (f64, f64) {
    let n = samples.len();
    if n == 0 {
        return (0.0, 0.0);
    }
    let sum: f64 = samples.iter().map(|x| *x as f64).sum();
    let mean = sum / (n as f64);
    if n < 2 {
        return (mean, 0.0);
    }
    let sq_sum: f64 = samples
        .iter()
        .map(|x| {
            let d = (*x as f64) - mean;
            d * d
        })
        .sum();
    let variance = sq_sum / ((n - 1) as f64);
    (mean, variance)
}

#[cfg(test)]
mod tests {
    use super::{CtOracle, CtOracleConfig, CtVerdict, SampleClass, TimingObservation};

    #[test]
    fn ct_oracle_detects_insufficient_data() {
        let oracle = CtOracle::new(CtOracleConfig {
            min_samples_per_class: 4,
            leakage_t_threshold: 4.5,
        });
        assert_eq!(oracle.evaluate(), CtVerdict::InsufficientData);
    }

    #[test]
    fn ct_oracle_reports_stable_for_similar_populations() {
        let mut oracle = CtOracle::new(CtOracleConfig {
            min_samples_per_class: 8,
            leakage_t_threshold: 4.5,
        });
        for i in 0..8u64 {
            oracle.record(TimingObservation {
                class: SampleClass::Public,
                duration_ns: 100 + (i % 2),
            });
            oracle.record(TimingObservation {
                class: SampleClass::Secret,
                duration_ns: 100 + (i % 2),
            });
        }
        let verdict = oracle.evaluate();
        assert!(matches!(verdict, CtVerdict::Stable { .. }));
    }

    #[test]
    fn ct_oracle_reports_potential_leakage_for_shifted_populations() {
        let mut oracle = CtOracle::new(CtOracleConfig {
            min_samples_per_class: 8,
            leakage_t_threshold: 4.5,
        });
        for i in 0..8u64 {
            oracle.record(TimingObservation {
                class: SampleClass::Public,
                duration_ns: 100 + (i % 3),
            });
            oracle.record(TimingObservation {
                class: SampleClass::Secret,
                duration_ns: 160 + (i % 3),
            });
        }
        let verdict = oracle.evaluate();
        assert!(matches!(verdict, CtVerdict::PotentialLeakage { .. }));
    }
}
