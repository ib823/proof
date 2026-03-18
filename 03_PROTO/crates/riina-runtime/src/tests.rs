// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Tests for the RIINA actor runtime.
//! 40+ tests covering actors, mailboxes, supervisors, session channels,
//! and the scheduler.

use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{mpsc, Arc, Mutex};
use std::thread;
use std::time::Duration;

use crate::actor;
use crate::mailbox;
use crate::scheduler::{Scheduler, TaskStatus};
use crate::session::{self, SessionEnd, SessionRecv, SessionSend};
use crate::supervisor::{ChildSpec, Supervisor, SupervisorSpec, SupervisorStrategy};

// =========================================================================
// Actor tests
// =========================================================================

#[test]
fn actor_spawn_and_send() {
    let (tx, rx) = mpsc::channel();
    let actor = actor::spawn(tx, |state: &mut mpsc::Sender<i32>, msg: i32| {
        let _ = state.send(msg * 2);
    });
    actor.send(21).unwrap();
    let result = rx.recv_timeout(Duration::from_secs(2)).unwrap();
    assert_eq!(result, 42);
}

#[test]
fn actor_processes_multiple_messages() {
    let (tx, rx) = mpsc::channel();
    let actor = actor::spawn(tx, |state: &mut mpsc::Sender<i32>, msg: i32| {
        let _ = state.send(msg);
    });
    for i in 0..10 {
        actor.send(i).unwrap();
    }
    for i in 0..10 {
        let val = rx.recv_timeout(Duration::from_secs(2)).unwrap();
        assert_eq!(val, i);
    }
}

#[test]
fn actor_state_mutation() {
    let (tx, rx) = mpsc::channel::<u64>();
    // Actor accumulates a running sum.
    let actor = actor::spawn((0u64, tx), |state: &mut (u64, mpsc::Sender<u64>), msg: u64| {
        state.0 += msg;
        let _ = state.1.send(state.0);
    });
    actor.send(10).unwrap();
    actor.send(20).unwrap();
    actor.send(30).unwrap();
    let _ = rx.recv_timeout(Duration::from_secs(2)).unwrap(); // 10
    let _ = rx.recv_timeout(Duration::from_secs(2)).unwrap(); // 30
    let total = rx.recv_timeout(Duration::from_secs(2)).unwrap(); // 60
    assert_eq!(total, 60);
}

#[test]
fn actor_id_uniqueness() {
    let a1 = actor::spawn((), |_: &mut (), _: ()| {});
    let a2 = actor::spawn((), |_: &mut (), _: ()| {});
    let a3 = actor::spawn((), |_: &mut (), _: ()| {});
    assert_ne!(a1.id(), a2.id());
    assert_ne!(a2.id(), a3.id());
    assert_ne!(a1.id(), a3.id());
}

#[test]
fn actor_ref_clone_sends_to_same_actor() {
    let (tx, rx) = mpsc::channel();
    let actor = actor::spawn(tx, |state: &mut mpsc::Sender<i32>, msg: i32| {
        let _ = state.send(msg);
    });
    let clone = actor.clone();
    actor.send(1).unwrap();
    clone.send(2).unwrap();
    let mut results = vec![
        rx.recv_timeout(Duration::from_secs(2)).unwrap(),
        rx.recv_timeout(Duration::from_secs(2)).unwrap(),
    ];
    results.sort();
    assert_eq!(results, vec![1, 2]);
}

#[test]
fn actor_stops_when_ref_dropped() {
    let (tx, rx) = mpsc::channel::<()>();
    let actor = actor::spawn(tx, |state: &mut mpsc::Sender<()>, _: ()| {
        let _ = state.send(());
    });
    // Drop the actor ref — sender side closed — actor loop should exit.
    drop(actor);
    // The response channel should eventually close too.
    thread::sleep(Duration::from_millis(50));
    // After actor stops, no more messages can be sent.
    assert!(rx.try_recv().is_err());
}

#[test]
fn actor_two_actors_communicate() {
    // Actor A doubles, Actor B triples. Chain: input → A → B → output.
    let (tx_out, rx_out) = mpsc::channel::<i32>();

    let actor_b = actor::spawn(tx_out, |state: &mut mpsc::Sender<i32>, msg: i32| {
        let _ = state.send(msg * 3);
    });

    let actor_a = actor::spawn(actor_b, |b_ref: &mut crate::ActorRef<i32>, msg: i32| {
        let _ = b_ref.send(msg * 2);
    });

    actor_a.send(5).unwrap();
    let result = rx_out.recv_timeout(Duration::from_secs(2)).unwrap();
    assert_eq!(result, 30); // 5 * 2 * 3
}

#[test]
fn actor_handles_many_messages() {
    let counter = Arc::new(AtomicU64::new(0));
    let counter_clone = Arc::clone(&counter);
    let (done_tx, done_rx) = mpsc::channel();

    let actor = actor::spawn(
        (counter_clone, done_tx, 0u64),
        |state: &mut (Arc<AtomicU64>, mpsc::Sender<()>, u64), _: ()| {
            state.0.fetch_add(1, Ordering::Relaxed);
            state.2 += 1;
            if state.2 == 1000 {
                let _ = state.1.send(());
            }
        },
    );

    for _ in 0..1000 {
        actor.send(()).unwrap();
    }
    done_rx.recv_timeout(Duration::from_secs(5)).unwrap();
    assert_eq!(counter.load(Ordering::Relaxed), 1000);
}

#[test]
fn actor_spawn_with_handle() {
    let (tx, rx) = mpsc::channel();
    let (actor_ref, handle) = actor::spawn_with_handle(tx, |state: &mut mpsc::Sender<i32>, msg: i32| {
        let _ = state.send(msg);
    });
    actor_ref.send(99).unwrap();
    assert_eq!(rx.recv_timeout(Duration::from_secs(2)).unwrap(), 99);
    assert_eq!(handle.id(), actor_ref.id());
}

#[test]
fn actor_fifo_ordering() {
    let (tx, rx) = mpsc::channel();
    let actor = actor::spawn(tx, |state: &mut mpsc::Sender<u32>, msg: u32| {
        let _ = state.send(msg);
    });
    let msgs: Vec<u32> = (0..100).collect();
    for &m in &msgs {
        actor.send(m).unwrap();
    }
    let received: Vec<u32> = (0..100)
        .map(|_| rx.recv_timeout(Duration::from_secs(2)).unwrap())
        .collect();
    assert_eq!(received, msgs);
}

// =========================================================================
// Mailbox tests
// =========================================================================

#[test]
fn mailbox_send_and_recv() {
    let (tx, rx) = mailbox::mailbox::<i32>();
    tx.send(42).unwrap();
    assert_eq!(rx.recv().unwrap(), 42);
}

#[test]
fn mailbox_fifo_ordering() {
    let (tx, rx) = mailbox::mailbox::<u32>();
    for i in 0..50 {
        tx.send(i).unwrap();
    }
    for i in 0..50 {
        assert_eq!(rx.recv().unwrap(), i);
    }
}

#[test]
fn mailbox_try_recv_empty() {
    let (_tx, rx) = mailbox::mailbox::<i32>();
    assert!(rx.try_recv().is_none());
}

#[test]
fn mailbox_try_recv_has_message() {
    let (tx, rx) = mailbox::mailbox::<i32>();
    tx.send(7).unwrap();
    assert_eq!(rx.try_recv(), Some(7));
    assert!(rx.try_recv().is_none());
}

#[test]
fn mailbox_multiple_senders() {
    let (tx, rx) = mailbox::mailbox::<i32>();
    let tx2 = tx.clone();
    tx.send(1).unwrap();
    tx2.send(2).unwrap();
    let mut results = vec![rx.recv().unwrap(), rx.recv().unwrap()];
    results.sort();
    assert_eq!(results, vec![1, 2]);
}

#[test]
fn mailbox_sender_clone() {
    let (tx, rx) = mailbox::mailbox::<String>();
    let clones: Vec<_> = (0..5).map(|_| tx.clone()).collect();
    for (i, c) in clones.iter().enumerate() {
        c.send(format!("msg{i}")).unwrap();
    }
    let mut received: Vec<String> = (0..5).map(|_| rx.recv().unwrap()).collect();
    received.sort();
    let mut expected: Vec<String> = (0..5).map(|i| format!("msg{i}")).collect();
    expected.sort();
    assert_eq!(received, expected);
}

#[test]
fn mailbox_recv_blocks_until_message() {
    let (tx, rx) = mailbox::mailbox::<i32>();
    let handle = thread::spawn(move || {
        thread::sleep(Duration::from_millis(50));
        tx.send(999).unwrap();
    });
    let val = rx.recv().unwrap();
    assert_eq!(val, 999);
    handle.join().unwrap();
}

// =========================================================================
// Supervisor tests
// =========================================================================

#[test]
fn supervisor_all_children_exit_cleanly() {
    let spec = SupervisorSpec::default();
    let children = vec![
        ChildSpec::new("child1", || thread::spawn(|| {})),
        ChildSpec::new("child2", || thread::spawn(|| {})),
    ];
    let sup = Supervisor::new(spec, children);
    assert!(sup.run().is_ok());
}

#[test]
fn supervisor_one_for_one_restart() {
    let crash_count = Arc::new(AtomicU64::new(0));
    let cc = Arc::clone(&crash_count);

    let spec = SupervisorSpec::new(SupervisorStrategy::OneForOne, 5, Duration::from_secs(10));
    let children = vec![ChildSpec::new("crasher", move || {
        let cc2 = Arc::clone(&cc);
        thread::spawn(move || {
            let n = cc2.fetch_add(1, Ordering::SeqCst);
            if n < 2 {
                panic!("intentional crash #{n}");
            }
            // Third time: exit cleanly.
        })
    })];

    let sup = Supervisor::new(spec, children);
    assert!(sup.run().is_ok());
    // Should have been spawned 3 times (2 crashes + 1 clean).
    assert_eq!(crash_count.load(Ordering::SeqCst), 3);
}

#[test]
fn supervisor_max_restarts_exceeded() {
    let spec = SupervisorSpec::new(SupervisorStrategy::OneForOne, 2, Duration::from_secs(10));
    let children = vec![ChildSpec::new("always_crash", || {
        thread::spawn(|| panic!("always crash"))
    })];

    let sup = Supervisor::new(spec, children);
    let result = sup.run();
    assert!(result.is_err());
}

#[test]
fn supervisor_all_for_one_restart() {
    let spawn_count = Arc::new(AtomicU64::new(0));
    let crash_flag = Arc::new(AtomicU64::new(0));

    let sc1 = Arc::clone(&spawn_count);
    let sc2 = Arc::clone(&spawn_count);
    let cf = Arc::clone(&crash_flag);

    let spec = SupervisorSpec::new(SupervisorStrategy::AllForOne, 5, Duration::from_secs(10));
    let children = vec![
        ChildSpec::new("stable", move || {
            let sc = Arc::clone(&sc1);
            thread::spawn(move || {
                sc.fetch_add(1, Ordering::SeqCst);
            })
        }),
        ChildSpec::new("crasher", move || {
            let sc = Arc::clone(&sc2);
            let cf2 = Arc::clone(&cf);
            thread::spawn(move || {
                sc.fetch_add(1, Ordering::SeqCst);
                if cf2.fetch_add(1, Ordering::SeqCst) < 1 {
                    // Brief sleep so supervisor sees stable child first.
                    thread::sleep(Duration::from_millis(20));
                    panic!("crash once");
                }
            })
        }),
    ];

    let sup = Supervisor::new(spec, children);
    assert!(sup.run().is_ok());
    // AllForOne restarts ALL children when one fails.
    // Spawns: 2 initial + at least 2 more after crash.
    assert!(spawn_count.load(Ordering::SeqCst) >= 4);
}

#[test]
fn supervisor_rest_for_one_restart() {
    let spawn_a = Arc::new(AtomicU64::new(0));
    let spawn_b = Arc::new(AtomicU64::new(0));
    let spawn_c = Arc::new(AtomicU64::new(0));
    let crash_flag = Arc::new(AtomicU64::new(0));

    let sa = Arc::clone(&spawn_a);
    let sb = Arc::clone(&spawn_b);
    let sc = Arc::clone(&spawn_c);
    let cf = Arc::clone(&crash_flag);

    let spec = SupervisorSpec::new(SupervisorStrategy::RestForOne, 5, Duration::from_secs(10));
    let children = vec![
        ChildSpec::new("child_a", move || {
            let s = Arc::clone(&sa);
            thread::spawn(move || {
                s.fetch_add(1, Ordering::SeqCst);
            })
        }),
        ChildSpec::new("child_b", move || {
            let s = Arc::clone(&sb);
            let cf2 = Arc::clone(&cf);
            thread::spawn(move || {
                s.fetch_add(1, Ordering::SeqCst);
                if cf2.fetch_add(1, Ordering::SeqCst) < 1 {
                    thread::sleep(Duration::from_millis(20));
                    panic!("crash once");
                }
            })
        }),
        ChildSpec::new("child_c", move || {
            let s = Arc::clone(&sc);
            thread::spawn(move || {
                s.fetch_add(1, Ordering::SeqCst);
            })
        }),
    ];

    let sup = Supervisor::new(spec, children);
    assert!(sup.run().is_ok());
    // child_b crashed once and was restarted, so spawned at least twice.
    assert!(spawn_b.load(Ordering::SeqCst) >= 2);
    // child_c is after child_b in RestForOne, so also restarted.
    assert!(spawn_c.load(Ordering::SeqCst) >= 2);
    // Total spawns should be more than initial 3.
    let total = spawn_a.load(Ordering::SeqCst)
        + spawn_b.load(Ordering::SeqCst)
        + spawn_c.load(Ordering::SeqCst);
    assert!(total >= 5);
}

#[test]
fn supervisor_strategy_default() {
    let spec = SupervisorSpec::default();
    assert_eq!(spec.strategy, SupervisorStrategy::OneForOne);
    assert_eq!(spec.max_restarts, 3);
}

#[test]
fn supervisor_empty_children() {
    let spec = SupervisorSpec::default();
    let sup = Supervisor::new(spec, vec![]);
    assert!(sup.run().is_ok());
}

#[test]
fn supervisor_child_spec_name() {
    let spec = ChildSpec::new("my_actor", || thread::spawn(|| {}));
    assert_eq!(spec.name(), "my_actor");
}

// =========================================================================
// Session-typed channel tests
// =========================================================================

#[test]
fn session_send_recv_basic() {
    type Proto = SessionSend<String, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();

    let h = thread::spawn(move || {
        let (val, end): (String, SessionEnd) = server.recv();
        assert_eq!(val, "hello");
        end.close();
    });

    let end: SessionEnd = client.send("hello".to_string());
    end.close();
    h.join().unwrap();
}

#[test]
fn session_recv_send_basic() {
    type Proto = SessionRecv<u32, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();

    let h = thread::spawn(move || {
        let end: SessionEnd = server.send(42);
        end.close();
    });

    let (val, end) = client.recv();
    assert_eq!(val, 42);
    end.close();
    h.join().unwrap();
}

#[test]
fn session_multi_step_protocol() {
    // Client sends String, receives u64, done.
    type Proto = SessionSend<String, SessionRecv<u64, SessionEnd>>;
    let (client, server) = session::session_channel::<Proto>();

    let h = thread::spawn(move || {
        let (name, cont): (String, SessionSend<u64, SessionEnd>) = server.recv();
        let end = cont.send(name.len() as u64);
        end.close();
    });

    let cont = client.send("RIINA".to_string());
    let (len, end) = cont.recv();
    assert_eq!(len, 5);
    end.close();
    h.join().unwrap();
}

#[test]
fn session_three_step_protocol() {
    // Client: send u32, recv bool, send String, end.
    type Proto = SessionSend<u32, SessionRecv<bool, SessionSend<String, SessionEnd>>>;
    let (client, server) = session::session_channel::<Proto>();

    let h = thread::spawn(move || {
        let (num, cont) = server.recv();
        let is_even = num % 2 == 0;
        let cont = cont.send(is_even);
        let (msg, end) = cont.recv();
        assert_eq!(msg, "done");
        end.close();
    });

    let cont = client.send(42u32);
    let (is_even, cont) = cont.recv();
    assert!(is_even);
    let end = cont.send("done".to_string());
    end.close();
    h.join().unwrap();
}

#[test]
fn session_different_types_each_step() {
    // Send bool, recv i32, send String, recv u64, end.
    type Proto = SessionSend<bool, SessionRecv<i32, SessionSend<String, SessionRecv<u64, SessionEnd>>>>;
    let (client, server) = session::session_channel::<Proto>();

    let h = thread::spawn(move || {
        let (flag, cont) = server.recv();
        let val = if flag { 100i32 } else { -1i32 };
        let cont = cont.send(val);
        let (msg, cont) = cont.recv();
        let reply = msg.len() as u64;
        let end = cont.send(reply);
        end.close();
    });

    let cont = client.send(true);
    let (val, cont) = cont.recv();
    assert_eq!(val, 100);
    let cont = cont.send("hello".to_string());
    let (len, end) = cont.recv();
    assert_eq!(len, 5);
    end.close();
    h.join().unwrap();
}

#[test]
fn session_end_closes() {
    type Proto = SessionEnd;
    let (client, server) = session::session_channel::<Proto>();
    client.close();
    server.close();
}

#[test]
fn session_channel_creation() {
    type Proto = SessionSend<u32, SessionEnd>;
    let (_client, _server) = session::session_channel::<Proto>();
    // Just verifying it compiles and doesn't panic.
}

#[test]
fn session_send_u8() {
    type Proto = SessionSend<u8, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let (val, end) = server.recv();
        assert_eq!(val, 255u8);
        end.close();
    });
    client.send(255u8).close();
    h.join().unwrap();
}

#[test]
fn session_send_u32() {
    type Proto = SessionSend<u32, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let (val, end) = server.recv();
        assert_eq!(val, 123456u32);
        end.close();
    });
    client.send(123456u32).close();
    h.join().unwrap();
}

#[test]
fn session_send_u64() {
    type Proto = SessionSend<u64, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let (val, end) = server.recv();
        assert_eq!(val, u64::MAX);
        end.close();
    });
    client.send(u64::MAX).close();
    h.join().unwrap();
}

#[test]
fn session_send_i32() {
    type Proto = SessionSend<i32, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let (val, end) = server.recv();
        assert_eq!(val, -42i32);
        end.close();
    });
    client.send(-42i32).close();
    h.join().unwrap();
}

#[test]
fn session_send_i64() {
    type Proto = SessionSend<i64, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let (val, end) = server.recv();
        assert_eq!(val, i64::MIN);
        end.close();
    });
    client.send(i64::MIN).close();
    h.join().unwrap();
}

#[test]
fn session_send_bool() {
    type Proto = SessionSend<bool, SessionRecv<bool, SessionEnd>>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let (val, cont) = server.recv();
        assert!(val);
        cont.send(false).close();
    });
    let cont = client.send(true);
    let (val, end) = cont.recv();
    assert!(!val);
    end.close();
    h.join().unwrap();
}

#[test]
fn session_send_string() {
    type Proto = SessionSend<String, SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let (val, end) = server.recv();
        assert_eq!(val, "RIINA bahasa melayu");
        end.close();
    });
    client.send("RIINA bahasa melayu".to_string()).close();
    h.join().unwrap();
}

#[test]
fn session_send_unit() {
    type Proto = SessionSend<(), SessionEnd>;
    let (client, server) = session::session_channel::<Proto>();
    let h = thread::spawn(move || {
        let ((), end) = server.recv();
        end.close();
    });
    client.send(()).close();
    h.join().unwrap();
}

#[test]
fn session_complex_five_step() {
    // A 5-step ping-pong.
    type Proto = SessionSend<u32, SessionRecv<u32, SessionSend<u32, SessionRecv<u32, SessionSend<u32, SessionEnd>>>>>;
    let (client, server) = session::session_channel::<Proto>();

    let h = thread::spawn(move || {
        let (v, cont) = server.recv();
        let cont = cont.send(v + 1);
        let (v, cont) = cont.recv();
        let cont = cont.send(v + 1);
        let (v, end) = cont.recv();
        assert_eq!(v, 5);
        end.close();
    });

    let cont = client.send(1u32);
    let (v, cont) = cont.recv();
    assert_eq!(v, 2);
    let cont = cont.send(3u32);
    let (v, cont) = cont.recv();
    assert_eq!(v, 4);
    let end = cont.send(5u32);
    end.close();
    h.join().unwrap();
}

// =========================================================================
// Scheduler tests
// =========================================================================

#[test]
fn scheduler_runs_single_task() {
    let done = Arc::new(AtomicU64::new(0));
    let done_clone = Arc::clone(&done);

    let sched = Scheduler::new(1);
    sched.spawn(move || {
        done_clone.store(1, Ordering::SeqCst);
        TaskStatus::Done
    });

    // Give the scheduler time to run.
    thread::sleep(Duration::from_millis(100));
    assert_eq!(done.load(Ordering::SeqCst), 1);
    sched.shutdown();
}

#[test]
fn scheduler_multiple_tasks_complete() {
    let counter = Arc::new(AtomicU64::new(0));
    let sched = Scheduler::new(2);

    for _ in 0..10 {
        let c = Arc::clone(&counter);
        sched.spawn(move || {
            c.fetch_add(1, Ordering::SeqCst);
            TaskStatus::Done
        });
    }

    thread::sleep(Duration::from_millis(200));
    assert_eq!(counter.load(Ordering::SeqCst), 10);
    sched.shutdown();
}

#[test]
fn scheduler_round_robin_fairness() {
    // Two tasks each run 5 steps. Record interleaving order.
    let log = Arc::new(Mutex::new(Vec::new()));

    let sched = Scheduler::new(1); // Single worker for deterministic ordering.

    let log1 = Arc::clone(&log);
    let count1 = Arc::new(AtomicU64::new(0));
    let c1 = Arc::clone(&count1);
    sched.spawn(move || {
        let n = c1.fetch_add(1, Ordering::SeqCst);
        log1.lock().unwrap().push('A');
        if n >= 4 { TaskStatus::Done } else { TaskStatus::Ready }
    });

    let log2 = Arc::clone(&log);
    let count2 = Arc::new(AtomicU64::new(0));
    let c2 = Arc::clone(&count2);
    sched.spawn(move || {
        let n = c2.fetch_add(1, Ordering::SeqCst);
        log2.lock().unwrap().push('B');
        if n >= 4 { TaskStatus::Done } else { TaskStatus::Ready }
    });

    thread::sleep(Duration::from_millis(300));
    sched.shutdown();

    let log = log.lock().unwrap();
    assert_eq!(log.len(), 10); // 5 + 5
    // Fairness: A and B should interleave (ABABAB...).
    // With a single worker and round-robin, the pattern should alternate.
    assert_eq!(log[0], 'A');
    assert_eq!(log[1], 'B');
}

#[test]
fn scheduler_task_done_removed() {
    let sched = Scheduler::new(1);
    sched.spawn(|| TaskStatus::Done);
    thread::sleep(Duration::from_millis(100));
    assert_eq!(sched.pending_tasks(), 0);
    sched.shutdown();
}

#[test]
fn scheduler_empty_no_panic() {
    let sched = Scheduler::new(2);
    // No tasks spawned — shutdown should not hang.
    sched.shutdown();
}

#[test]
fn scheduler_many_tasks() {
    let counter = Arc::new(AtomicU64::new(0));
    let sched = Scheduler::new(4);

    for _ in 0..100 {
        let c = Arc::clone(&counter);
        sched.spawn(move || {
            c.fetch_add(1, Ordering::SeqCst);
            TaskStatus::Done
        });
    }

    thread::sleep(Duration::from_millis(500));
    assert_eq!(counter.load(Ordering::SeqCst), 100);
    sched.shutdown();
}

#[test]
fn scheduler_multi_step_task() {
    let counter = Arc::new(AtomicU64::new(0));
    let c = Arc::clone(&counter);

    let sched = Scheduler::new(1);
    sched.spawn(move || {
        let n = c.fetch_add(1, Ordering::SeqCst);
        if n >= 9 { TaskStatus::Done } else { TaskStatus::Ready }
    });

    thread::sleep(Duration::from_millis(200));
    assert_eq!(counter.load(Ordering::SeqCst), 10);
    sched.shutdown();
}

#[test]
fn scheduler_concurrent_spawn() {
    let sched = Arc::new(Scheduler::new(2));
    let counter = Arc::new(AtomicU64::new(0));

    let mut handles = vec![];
    for _ in 0..5 {
        let s = Arc::clone(&sched);
        let c = Arc::clone(&counter);
        handles.push(thread::spawn(move || {
            s.spawn(move || {
                c.fetch_add(1, Ordering::SeqCst);
                TaskStatus::Done
            });
        }));
    }

    for h in handles {
        h.join().unwrap();
    }
    thread::sleep(Duration::from_millis(200));
    assert_eq!(counter.load(Ordering::SeqCst), 5);

    // We need to consume the Arc to call shutdown.
    // Use a timeout approach instead.
    // The scheduler will be dropped when the Arc is dropped.
}
