// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! # Supervisor
//!
//! Supervision trees with configurable restart strategies.
//! Monitors child actors and restarts them on failure (panic).

use std::thread;
use std::time::{Duration, Instant};

/// Restart strategy for a supervisor.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SupervisorStrategy {
    /// Restart only the failed child.
    OneForOne,
    /// Restart all children when any one fails.
    AllForOne,
    /// Restart the failed child and all children started after it.
    RestForOne,
}

/// Configuration for a supervisor.
#[derive(Debug, Clone)]
pub struct SupervisorSpec {
    /// Which restart strategy to use.
    pub strategy: SupervisorStrategy,
    /// Maximum number of restarts allowed within `restart_window`.
    pub max_restarts: u32,
    /// Time window for counting restarts.
    pub restart_window: Duration,
}

impl SupervisorSpec {
    /// Create a new supervisor spec.
    pub fn new(strategy: SupervisorStrategy, max_restarts: u32, restart_window: Duration) -> Self {
        SupervisorSpec {
            strategy,
            max_restarts,
            restart_window,
        }
    }
}

impl Default for SupervisorSpec {
    fn default() -> Self {
        SupervisorSpec {
            strategy: SupervisorStrategy::OneForOne,
            max_restarts: 3,
            restart_window: Duration::from_secs(5),
        }
    }
}

/// A child specification: a factory that can (re-)spawn a child actor thread.
pub struct ChildSpec {
    name: String,
    factory: Box<dyn Fn() -> thread::JoinHandle<()> + Send>,
}

impl ChildSpec {
    /// Create a new child spec.
    ///
    /// - `name`: human-readable name for logging
    /// - `factory`: closure that spawns and returns the child thread
    pub fn new<F>(name: impl Into<String>, factory: F) -> Self
    where
        F: Fn() -> thread::JoinHandle<()> + Send + 'static,
    {
        ChildSpec {
            name: name.into(),
            factory: Box::new(factory),
        }
    }

    /// The child's name.
    pub fn name(&self) -> &str {
        &self.name
    }
}

/// A running child tracked by the supervisor.
struct RunningChild {
    name: String,
    handle: thread::JoinHandle<()>,
}

/// A supervisor that monitors and restarts child actors.
pub struct Supervisor {
    spec: SupervisorSpec,
    child_specs: Vec<ChildSpec>,
}

impl Supervisor {
    /// Create a supervisor with the given spec and child specifications.
    pub fn new(spec: SupervisorSpec, children: Vec<ChildSpec>) -> Self {
        Supervisor {
            spec,
            child_specs: children,
        }
    }

    /// Run the supervisor loop. Spawns all children, monitors them, and
    /// applies the restart strategy when a child fails.
    ///
    /// Returns `Ok(())` if all children exit cleanly, or `Err(reason)` if
    /// the max restart intensity is exceeded.
    pub fn run(&self) -> Result<(), SupervisorError> {
        let mut running: Vec<RunningChild> = self.spawn_all();
        let mut restart_times: Vec<Instant> = Vec::new();

        loop {
            // Find a finished child
            let finished_idx = running.iter().position(|c| c.handle.is_finished());

            let idx = match finished_idx {
                Some(i) => i,
                None => {
                    if running.is_empty() {
                        return Ok(());
                    }
                    // Brief sleep to avoid busy-wait, then re-check.
                    thread::sleep(Duration::from_millis(10));
                    continue;
                }
            };

            // Remove the finished child and check if it panicked.
            let child = running.remove(idx);
            let panicked = child.handle.join().is_err();

            if !panicked {
                // Clean exit — don't restart.
                if running.is_empty() {
                    return Ok(());
                }
                continue;
            }

            // Check restart intensity.
            let now = Instant::now();
            restart_times.retain(|t| now.duration_since(*t) < self.spec.restart_window);
            restart_times.push(now);

            if restart_times.len() as u32 > self.spec.max_restarts {
                // Exceeded max restarts — shut down remaining children.
                drop(running);
                return Err(SupervisorError::MaxRestartsExceeded {
                    child_name: child.name,
                });
            }

            // Apply restart strategy.
            match self.spec.strategy {
                SupervisorStrategy::OneForOne => {
                    // Restart only the failed child.
                    if let Some(spec) = self.child_specs.iter().find(|s| s.name == child.name) {
                        let new_handle = (spec.factory)();
                        running.insert(
                            idx.min(running.len()),
                            RunningChild {
                                name: child.name,
                                handle: new_handle,
                            },
                        );
                    }
                }
                SupervisorStrategy::AllForOne => {
                    // Stop all remaining, then restart everything.
                    drop(running);
                    running = self.spawn_all();
                }
                SupervisorStrategy::RestForOne => {
                    // Stop children that were started after the failed one, restart from idx onward.
                    running.truncate(idx);
                    for spec in self.child_specs.iter().skip(idx) {
                        let handle = (spec.factory)();
                        running.push(RunningChild {
                            name: spec.name.clone(),
                            handle,
                        });
                    }
                }
            }
        }
    }

    /// Spawn all children and return their running handles.
    fn spawn_all(&self) -> Vec<RunningChild> {
        self.child_specs
            .iter()
            .map(|spec| RunningChild {
                name: spec.name.clone(),
                handle: (spec.factory)(),
            })
            .collect()
    }
}

/// Errors that can occur during supervision.
#[derive(Debug)]
pub enum SupervisorError {
    /// The maximum restart intensity was exceeded.
    MaxRestartsExceeded {
        /// Name of the child that triggered the limit.
        child_name: String,
    },
}

impl std::fmt::Display for SupervisorError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            SupervisorError::MaxRestartsExceeded { child_name } => {
                write!(
                    f,
                    "supervisor: max restarts exceeded for child '{child_name}'"
                )
            }
        }
    }
}

impl std::error::Error for SupervisorError {}
