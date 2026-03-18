// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! # Mailbox
//!
//! MPSC mailbox for actor message delivery using `std::sync::mpsc`.
//! Provides FIFO ordering guarantees and both blocking and non-blocking receive.

use std::sync::mpsc;

/// Sending half of a mailbox. Cloneable — multiple senders can feed one actor.
pub struct MailboxSender<M> {
    tx: mpsc::Sender<M>,
}

impl<M> Clone for MailboxSender<M> {
    fn clone(&self) -> Self {
        MailboxSender {
            tx: self.tx.clone(),
        }
    }
}

impl<M> MailboxSender<M> {
    /// Send a message into the mailbox. Returns `Err` if the receiver was dropped.
    pub fn send(&self, msg: M) -> Result<(), mpsc::SendError<M>> {
        self.tx.send(msg)
    }
}

/// Receiving half of a mailbox. Only one receiver exists per mailbox.
pub struct MailboxReceiver<M> {
    rx: mpsc::Receiver<M>,
}

impl<M> MailboxReceiver<M> {
    /// Blocking receive. Blocks until a message arrives or all senders are dropped.
    pub fn recv(&self) -> Result<M, mpsc::RecvError> {
        self.rx.recv()
    }

    /// Non-blocking receive. Returns `None` if no message is available.
    pub fn try_recv(&self) -> Option<M> {
        self.rx.try_recv().ok()
    }
}

/// Create a new mailbox pair (sender, receiver).
pub fn mailbox<M>() -> (MailboxSender<M>, MailboxReceiver<M>) {
    let (tx, rx) = mpsc::channel();
    (MailboxSender { tx }, MailboxReceiver { rx })
}
