// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! # Actor
//!
//! Core actor primitives: `ActorId`, `ActorRef`, `ActorHandle`, and `spawn`.
//! Each actor runs on its own OS thread with a dedicated mailbox.

use std::sync::atomic::{AtomicU64, Ordering};
use std::thread;

use crate::mailbox::{self, MailboxReceiver, MailboxSender};

/// Global actor ID counter.
static NEXT_ACTOR_ID: AtomicU64 = AtomicU64::new(1);

/// Unique identifier for an actor.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct ActorId(u64);

impl ActorId {
    /// Generate a fresh, globally unique actor ID.
    fn next() -> Self {
        ActorId(NEXT_ACTOR_ID.fetch_add(1, Ordering::Relaxed))
    }

    /// Return the raw numeric ID.
    pub fn as_u64(&self) -> u64 {
        self.0
    }
}

/// A handle to send messages to a running actor.
///
/// `ActorRef` is `Clone` + `Send` + `Sync` (when `M: Send`), so it can be
/// freely shared across threads.
pub struct ActorRef<M> {
    id: ActorId,
    sender: MailboxSender<M>,
}

impl<M> Clone for ActorRef<M> {
    fn clone(&self) -> Self {
        ActorRef {
            id: self.id,
            sender: self.sender.clone(),
        }
    }
}

impl<M> ActorRef<M> {
    /// The actor's unique ID.
    pub fn id(&self) -> ActorId {
        self.id
    }

    /// Send a message to this actor's mailbox.
    ///
    /// Returns `Err` if the actor has stopped (receiver dropped).
    pub fn send(&self, msg: M) -> Result<(), std::sync::mpsc::SendError<M>> {
        self.sender.send(msg)
    }
}

/// A join handle for a running actor thread. Used by supervisors.
pub struct ActorHandle {
    id: ActorId,
    join: Option<thread::JoinHandle<()>>,
}

impl ActorHandle {
    /// The actor's unique ID.
    pub fn id(&self) -> ActorId {
        self.id
    }

    /// Wait for the actor thread to finish. Returns `true` if it exited
    /// cleanly, `false` if it panicked.
    pub fn join(&mut self) -> bool {
        if let Some(h) = self.join.take() {
            h.join().is_ok()
        } else {
            true
        }
    }

    /// Check if the actor thread has finished (non-blocking).
    pub fn is_finished(&self) -> bool {
        self.join.as_ref().is_none_or(|h| h.is_finished())
    }
}

/// Spawn a new actor on a dedicated thread.
///
/// - `init`: the actor's initial state
/// - `handler`: called for each message received
///
/// Returns an `ActorRef` that can be used to send messages.
/// The actor runs until all `ActorRef` clones are dropped (senders closed)
/// or the handler panics.
pub fn spawn<S, M>(init: S, handler: fn(&mut S, M)) -> ActorRef<M>
where
    S: Send + 'static,
    M: Send + 'static,
{
    let id = ActorId::next();
    let (sender, receiver) = mailbox::mailbox::<M>();

    thread::spawn(move || {
        actor_loop(init, receiver, handler);
    });

    ActorRef { id, sender }
}

/// Spawn a new actor and return both the `ActorRef` and an `ActorHandle`
/// (for supervision / join).
pub fn spawn_with_handle<S, M>(init: S, handler: fn(&mut S, M)) -> (ActorRef<M>, ActorHandle)
where
    S: Send + 'static,
    M: Send + 'static,
{
    let id = ActorId::next();
    let (sender, receiver) = mailbox::mailbox::<M>();

    let join = thread::spawn(move || {
        actor_loop(init, receiver, handler);
    });

    let actor_ref = ActorRef { id, sender };
    let handle = ActorHandle {
        id,
        join: Some(join),
    };
    (actor_ref, handle)
}

/// The core receive loop. Runs until the channel is closed.
fn actor_loop<S, M>(mut state: S, receiver: MailboxReceiver<M>, handler: fn(&mut S, M)) {
    while let Ok(msg) = receiver.recv() {
        handler(&mut state, msg);
    }
}
