// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! # RIINA Actor Runtime
//!
//! Pure `std::sync` actor runtime for the RIINA language. Provides:
//!
//! - **Actors** — lightweight concurrent entities with typed mailboxes
//! - **Mailboxes** — MPSC channels with FIFO ordering
//! - **Supervisors** — fault-tolerant supervision trees
//! - **Session-typed channels** — compile-time protocol enforcement
//! - **Scheduler** — cooperative round-robin task scheduler
//!
//! ## Architecture
//!
//! ```text
//! ┌──────────────┐    MailboxSender     ┌──────────────┐
//! │   Actor A    │ ──────────────────→  │   Actor B    │
//! │  (thread)    │                      │  (thread)    │
//! └──────────────┘                      └──────────────┘
//!        ↑                                     ↑
//!        └──────── Supervisor ─────────────────┘
//!                  (monitors + restarts)
//! ```
//!
//! ## Zero Dependencies
//!
//! This crate uses only `std::sync`, `std::thread`, and `std::collections`.
//! No external dependencies (Law 8).

#![forbid(unsafe_code)]
#![warn(clippy::all)]

pub mod actor;
pub mod mailbox;
pub mod scheduler;
pub mod session;
pub mod supervisor;

// Re-export primary types for convenience.
pub use actor::{spawn, spawn_with_handle, ActorHandle, ActorId, ActorRef};
pub use mailbox::{mailbox, MailboxReceiver, MailboxSender};
pub use scheduler::{Scheduler, TaskId, TaskStatus};
pub use session::{
    session_channel, Encodable, HasDual, SessionEnd, SessionRecv, SessionSend, SessionType,
};
pub use supervisor::{ChildSpec, Supervisor, SupervisorError, SupervisorSpec, SupervisorStrategy};

#[cfg(test)]
mod tests;
