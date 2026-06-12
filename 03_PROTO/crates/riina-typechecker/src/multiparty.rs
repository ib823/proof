//! Multiparty session types: N-party global types and projection.
//!
//! RIINA's runtime `SessionType` (`riina_types::SessionType`) is a *binary*
//! session type — its `Send`/`Recv` carry no peer role, so it cannot represent
//! an N-party (>2 role) local view. That is why `crate::project_choreography`
//! honestly returns `None` for more than two roles. This module supplies the
//! role-annotated multiparty core that closes the "full N-party multiparty
//! session global types" Gate B item, mirroring the mechanized Coq development:
//!
//! - [`GlobalType`] ⇔ Coq `GlobalType` (`domains/ChoreographyTypes.v:160`)
//! - [`LocalType`]  ⇔ Coq `LocalType`  (`domains/ChoreographyTypes.v:232`)
//! - [`project`]    ⇔ Coq `project`    (`domains/ChoreographyTypes.v:399`)
//! - [`mergeable`]  ⇔ Coq `mergeableb` (`domains/ChoreographyProjection.v:48`)
//!
//! Per-statement channel-operation *implementation* checking (matching a
//! projected local type against an actual sequence of channel sends/receives)
//! remains future work: RIINA has no session-channel surface operations yet, so
//! there is no operation sequence to check a projection against.

use riina_types::Ty;
use std::collections::BTreeSet;

/// A multiparty global protocol. Roles are identified by name.
///
/// Mirrors Coq `GlobalType` (`domains/ChoreographyTypes.v:160`).
#[derive(Debug, Clone, PartialEq)]
pub enum GlobalType {
    /// Protocol complete.
    End,
    /// Recursion variable.
    Var(String),
    /// `μX. G` — recursive protocol.
    Rec(String, Box<GlobalType>),
    /// `p → q : T . G` — `from` sends a value of type `T` to `to`, then `cont`.
    Msg {
        from: String,
        to: String,
        payload: Ty,
        cont: Box<GlobalType>,
    },
    /// `p → q : { l1: G1, l2: G2 }` — `from` chooses a labelled branch to `to`.
    Branch {
        from: String,
        to: String,
        left_label: String,
        left: Box<GlobalType>,
        right_label: String,
        right: Box<GlobalType>,
    },
}

/// A per-role local session type (the projection of a [`GlobalType`] onto one
/// role). Unlike the binary `riina_types::SessionType`, each communication
/// records the peer role.
///
/// Mirrors Coq `LocalType` (`domains/ChoreographyTypes.v:232`).
#[derive(Debug, Clone, PartialEq)]
pub enum LocalType {
    End,
    Var(String),
    Rec(String, Box<LocalType>),
    /// Send a `payload` to role `to`, then continue.
    Send {
        to: String,
        payload: Ty,
        cont: Box<LocalType>,
    },
    /// Receive a `payload` from role `from`, then continue.
    Recv {
        from: String,
        payload: Ty,
        cont: Box<LocalType>,
    },
    /// Internal choice: select a labelled branch towards role `to`.
    Select {
        to: String,
        left_label: String,
        left: Box<LocalType>,
        right_label: String,
        right: Box<LocalType>,
    },
    /// External choice: offer labelled branches from role `from`.
    Offer {
        from: String,
        left_label: String,
        left: Box<LocalType>,
        right_label: String,
        right: Box<LocalType>,
    },
}

/// Project a global type onto a single role, yielding that role's local view.
///
/// Mirrors Coq `project` (`domains/ChoreographyTypes.v:399`): in a message
/// `p → q : T`, the sender `p` performs a `Send` to `q`, the receiver `q` a
/// `Recv` from `p`, and any other role skips the interaction. A role that does
/// not participate in a branch projects through the (mergeable) branches — see
/// [`is_projectable`] for the well-formedness side-condition.
pub fn project(g: &GlobalType, role: &str) -> LocalType {
    match g {
        GlobalType::End => LocalType::End,
        GlobalType::Var(n) => LocalType::Var(n.clone()),
        GlobalType::Rec(n, g2) => LocalType::Rec(n.clone(), Box::new(project(g2, role))),
        GlobalType::Msg {
            from,
            to,
            payload,
            cont,
        } => {
            if role == from {
                LocalType::Send {
                    to: to.clone(),
                    payload: payload.clone(),
                    cont: Box::new(project(cont, role)),
                }
            } else if role == to {
                LocalType::Recv {
                    from: from.clone(),
                    payload: payload.clone(),
                    cont: Box::new(project(cont, role)),
                }
            } else {
                project(cont, role)
            }
        }
        GlobalType::Branch {
            from,
            to,
            left_label,
            left,
            right_label,
            right,
        } => {
            if role == from {
                LocalType::Select {
                    to: to.clone(),
                    left_label: left_label.clone(),
                    left: Box::new(project(left, role)),
                    right_label: right_label.clone(),
                    right: Box::new(project(right, role)),
                }
            } else if role == to {
                LocalType::Offer {
                    from: from.clone(),
                    left_label: left_label.clone(),
                    left: Box::new(project(left, role)),
                    right_label: right_label.clone(),
                    right: Box::new(project(right, role)),
                }
            } else {
                // Non-participant: both branches must look identical to `role`
                // (the mergeability side-condition, checked by `is_projectable`);
                // we take the left projection as the representative.
                project(left, role)
            }
        }
    }
}

/// Structural mergeability of two local types.
///
/// Mirrors Coq `mergeableb` (`domains/ChoreographyProjection.v:48`): two local
/// views are mergeable iff they describe identical observable behaviour. Used to
/// validate that a role not participating in a branch sees the same protocol
/// regardless of which branch is taken.
pub fn mergeable(l1: &LocalType, l2: &LocalType) -> bool {
    use LocalType::*;
    match (l1, l2) {
        (End, End) => true,
        (Var(a), Var(b)) => a == b,
        (Rec(a, x), Rec(b, y)) => a == b && mergeable(x, y),
        (
            Send {
                to: a,
                payload: ta,
                cont: xa,
            },
            Send {
                to: b,
                payload: tb,
                cont: xb,
            },
        ) => a == b && ta == tb && mergeable(xa, xb),
        (
            Recv {
                from: a,
                payload: ta,
                cont: xa,
            },
            Recv {
                from: b,
                payload: tb,
                cont: xb,
            },
        ) => a == b && ta == tb && mergeable(xa, xb),
        (
            Select {
                to: a,
                left_label: la,
                left: l1a,
                right_label: ra,
                right: r1a,
            },
            Select {
                to: b,
                left_label: lb,
                left: l2a,
                right_label: rb,
                right: r2a,
            },
        )
        | (
            Offer {
                from: a,
                left_label: la,
                left: l1a,
                right_label: ra,
                right: r1a,
            },
            Offer {
                from: b,
                left_label: lb,
                left: l2a,
                right_label: rb,
                right: r2a,
            },
        ) => a == b && la == lb && ra == rb && mergeable(l1a, l2a) && mergeable(r1a, r2a),
        _ => false,
    }
}

/// All roles mentioned in a global type.
pub fn roles(g: &GlobalType) -> BTreeSet<String> {
    let mut acc = BTreeSet::new();
    fn go(g: &GlobalType, acc: &mut BTreeSet<String>) {
        match g {
            GlobalType::End | GlobalType::Var(_) => {}
            GlobalType::Rec(_, g2) => go(g2, acc),
            GlobalType::Msg { from, to, cont, .. } => {
                acc.insert(from.clone());
                acc.insert(to.clone());
                go(cont, acc);
            }
            GlobalType::Branch {
                from,
                to,
                left,
                right,
                ..
            } => {
                acc.insert(from.clone());
                acc.insert(to.clone());
                go(left, acc);
                go(right, acc);
            }
        }
    }
    go(g, &mut acc);
    acc
}

/// Whether a global type is *projectable*: every branch's two continuations
/// project to mergeable local types for each role that does not participate in
/// that branch (the standard MPST well-formedness condition — a bystander must
/// not be able to tell which branch was chosen). Sender/receiver roles need not
/// merge (they observe the choice directly).
pub fn is_projectable(g: &GlobalType) -> bool {
    match g {
        GlobalType::End | GlobalType::Var(_) => true,
        GlobalType::Rec(_, g2) => is_projectable(g2),
        GlobalType::Msg { cont, .. } => is_projectable(cont),
        GlobalType::Branch {
            from,
            to,
            left,
            right,
            ..
        } => {
            if !is_projectable(left) || !is_projectable(right) {
                return false;
            }
            let mut bystanders = roles(g);
            bystanders.remove(from);
            bystanders.remove(to);
            bystanders
                .iter()
                .all(|r| mergeable(&project(left, r), &project(right, r)))
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn msg(from: &str, to: &str, payload: Ty, cont: GlobalType) -> GlobalType {
        GlobalType::Msg {
            from: from.into(),
            to: to.into(),
            payload,
            cont: Box::new(cont),
        }
    }

    // A genuine 3-party protocol (the canonical two-buyer / ring example):
    //   Buyer → Seller : Int        (order id)
    //   Seller → Shipper : String   (address)
    //   Shipper → Buyer : Bool      (delivered?)
    fn three_party() -> GlobalType {
        msg(
            "Buyer",
            "Seller",
            Ty::Int,
            msg(
                "Seller",
                "Shipper",
                Ty::String,
                msg("Shipper", "Buyer", Ty::Bool, GlobalType::End),
            ),
        )
    }

    #[test]
    fn project_three_party_buyer() {
        // Buyer: send Int to Seller, then recv Bool from Shipper.
        let l = project(&three_party(), "Buyer");
        assert_eq!(
            l,
            LocalType::Send {
                to: "Seller".into(),
                payload: Ty::Int,
                cont: Box::new(LocalType::Recv {
                    from: "Shipper".into(),
                    payload: Ty::Bool,
                    cont: Box::new(LocalType::End),
                }),
            }
        );
    }

    #[test]
    fn project_three_party_seller() {
        // Seller: recv Int from Buyer, then send String to Shipper. (The final
        // Shipper→Buyer message does not involve Seller and is skipped.)
        let l = project(&three_party(), "Seller");
        assert_eq!(
            l,
            LocalType::Recv {
                from: "Buyer".into(),
                payload: Ty::Int,
                cont: Box::new(LocalType::Send {
                    to: "Shipper".into(),
                    payload: Ty::String,
                    cont: Box::new(LocalType::End),
                }),
            }
        );
    }

    #[test]
    fn project_three_party_shipper() {
        // Shipper: recv String from Seller, then send Bool to Buyer.
        let l = project(&three_party(), "Shipper");
        assert_eq!(
            l,
            LocalType::Recv {
                from: "Seller".into(),
                payload: Ty::String,
                cont: Box::new(LocalType::Send {
                    to: "Buyer".into(),
                    payload: Ty::Bool,
                    cont: Box::new(LocalType::End),
                }),
            }
        );
    }

    #[test]
    fn non_participant_skips_interaction() {
        // In Buyer → Seller : Int . End, the bystander "Carol" sees nothing.
        let g = msg("Buyer", "Seller", Ty::Int, GlobalType::End);
        assert_eq!(project(&g, "Carol"), LocalType::End);
    }

    #[test]
    fn binary_projection_yields_dual_send_recv() {
        // A 2-party global type projects to dual endpoints: sender Send, peer Recv.
        let g = msg("A", "B", Ty::Int, GlobalType::End);
        assert_eq!(
            project(&g, "A"),
            LocalType::Send {
                to: "B".into(),
                payload: Ty::Int,
                cont: Box::new(LocalType::End)
            }
        );
        assert_eq!(
            project(&g, "B"),
            LocalType::Recv {
                from: "A".into(),
                payload: Ty::Int,
                cont: Box::new(LocalType::End)
            }
        );
    }

    #[test]
    fn roles_collects_all_participants() {
        let rs = roles(&three_party());
        let expect: BTreeSet<String> = ["Buyer", "Seller", "Shipper"]
            .iter()
            .map(|s| s.to_string())
            .collect();
        assert_eq!(rs, expect);
    }

    #[test]
    fn mergeable_identical_is_true_distinct_is_false() {
        let a = LocalType::Recv {
            from: "P".into(),
            payload: Ty::Int,
            cont: Box::new(LocalType::End),
        };
        let b = a.clone();
        assert!(mergeable(&a, &b));
        let c = LocalType::Recv {
            from: "P".into(),
            payload: Ty::Bool, // different payload
            cont: Box::new(LocalType::End),
        };
        assert!(!mergeable(&a, &c));
    }

    #[test]
    fn projectable_branch_bystander_merges() {
        // C is a bystander to A's choice toward B, and both branches look
        // identical to C (C → A : Int in both) ⇒ projectable.
        let g = GlobalType::Branch {
            from: "A".into(),
            to: "B".into(),
            left_label: "l".into(),
            left: Box::new(msg("C", "A", Ty::Int, GlobalType::End)),
            right_label: "r".into(),
            right: Box::new(msg("C", "A", Ty::Int, GlobalType::End)),
        };
        assert!(is_projectable(&g));
    }

    #[test]
    fn non_projectable_branch_bystander_diverges() {
        // C is a bystander but the two branches give C different behaviour
        // (C → A : Int vs C → A : Bool) ⇒ NOT projectable.
        let g = GlobalType::Branch {
            from: "A".into(),
            to: "B".into(),
            left_label: "l".into(),
            left: Box::new(msg("C", "A", Ty::Int, GlobalType::End)),
            right_label: "r".into(),
            right: Box::new(msg("C", "A", Ty::Bool, GlobalType::End)),
        };
        assert!(!is_projectable(&g));
    }
}
