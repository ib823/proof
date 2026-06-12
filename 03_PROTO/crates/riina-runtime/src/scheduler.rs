// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! # Scheduler
//!
//! A cooperative round-robin scheduler for actor tasks.
//! Tasks yield after each step; the scheduler ensures fair interleaving.

use std::collections::VecDeque;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Arc, Condvar, Mutex};
use std::thread;

/// Global task ID counter.
static NEXT_TASK_ID: AtomicU64 = AtomicU64::new(1);

/// Unique identifier for a scheduled task.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct TaskId(u64);

impl TaskId {
    fn next() -> Self {
        TaskId(NEXT_TASK_ID.fetch_add(1, Ordering::Relaxed))
    }

    /// Return the raw numeric ID.
    pub fn as_u64(&self) -> u64 {
        self.0
    }
}

/// Status returned by a task after each step.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TaskStatus {
    /// The task has more work to do.
    Ready,
    /// The task is finished.
    Done,
}

/// Internal task representation.
struct Task {
    _id: TaskId,
    work: Box<dyn FnMut() -> TaskStatus + Send>,
}

/// Shared state for the scheduler's task queue.
struct SchedulerInner {
    queue: Mutex<VecDeque<Task>>,
    /// Signals workers when new tasks are enqueued or scheduler is shutting down.
    condvar: Condvar,
    /// Whether the scheduler has been told to shut down.
    shutdown: Mutex<bool>,
}

/// A cooperative round-robin scheduler.
///
/// Tasks are closures that return `TaskStatus::Ready` when they have more
/// work, or `TaskStatus::Done` when finished. The scheduler runs each task
/// once per round before giving any task a second turn.
pub struct Scheduler {
    inner: Arc<SchedulerInner>,
    workers: Vec<thread::JoinHandle<()>>,
}

impl Scheduler {
    /// Create a new scheduler with `num_threads` worker threads.
    ///
    /// Workers start immediately but idle until tasks are spawned.
    pub fn new(num_threads: usize) -> Self {
        let inner = Arc::new(SchedulerInner {
            queue: Mutex::new(VecDeque::new()),
            condvar: Condvar::new(),
            shutdown: Mutex::new(false),
        });

        let mut workers = Vec::with_capacity(num_threads);
        for _ in 0..num_threads {
            let inner_clone = Arc::clone(&inner);
            workers.push(thread::spawn(move || {
                worker_loop(&inner_clone);
            }));
        }

        Scheduler { inner, workers }
    }

    /// Spawn a new task onto the scheduler. Returns its `TaskId`.
    pub fn spawn<F>(&self, task: F) -> TaskId
    where
        F: FnMut() -> TaskStatus + Send + 'static,
    {
        let id = TaskId::next();
        let task = Task {
            _id: id,
            work: Box::new(task),
        };

        {
            let mut queue = self.inner.queue.lock().expect("scheduler: lock poisoned");
            queue.push_back(task);
        }
        self.inner.condvar.notify_one();
        id
    }

    /// Shut down the scheduler. Waits for all currently queued tasks to
    /// finish, then joins worker threads.
    pub fn shutdown(self) {
        // Signal shutdown.
        {
            let mut shutdown = self
                .inner
                .shutdown
                .lock()
                .expect("scheduler: lock poisoned");
            *shutdown = true;
        }
        self.inner.condvar.notify_all();

        // Join all worker threads.
        for w in self.workers {
            let _ = w.join();
        }
    }

    /// Check how many tasks are currently in the queue.
    pub fn pending_tasks(&self) -> usize {
        self.inner
            .queue
            .lock()
            .expect("scheduler: lock poisoned")
            .len()
    }
}

/// Worker loop: pull a task, run one step, re-enqueue if Ready.
fn worker_loop(inner: &SchedulerInner) {
    loop {
        let mut task = {
            let mut queue = inner.queue.lock().expect("scheduler: lock poisoned");

            loop {
                if let Some(task) = queue.pop_front() {
                    break task;
                }

                // Check if we should shut down.
                let shutdown = inner.shutdown.lock().expect("scheduler: lock poisoned");
                if *shutdown {
                    return;
                }
                drop(shutdown);

                // Wait for a task or shutdown signal.
                queue = inner.condvar.wait(queue).expect("scheduler: lock poisoned");
            }
        };

        // Run one step.
        let status = (task.work)();

        match status {
            TaskStatus::Ready => {
                // Re-enqueue at the back (round-robin fairness).
                let mut queue = inner.queue.lock().expect("scheduler: lock poisoned");
                queue.push_back(task);
                inner.condvar.notify_one();
            }
            TaskStatus::Done => {
                // Task finished; drop it.
            }
        }
    }
}
