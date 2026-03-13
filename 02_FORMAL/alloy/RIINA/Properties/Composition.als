// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/Composition.v
// Models: compositional verification properties
module riina/Properties/Composition

abstract sig Component {
  verified: one Int,
  composable: one Int
}

sig AtomicComponent extends Component {}

sig CompositeComponent extends Component {
  left: one Component,
  right: one Component
}

fact CompositionPreservesVerification {
  all c: CompositeComponent |
    (c.left.verified = 1 and c.right.verified = 1) implies c.verified = 1
}

fact Composability {
  all c: Component | c.verified = 1 implies c.composable = 1
}

assert val_rel_pair {
  all c: CompositeComponent |
    (c.left.verified = 1 and c.right.verified = 1) implies c.verified = 1
}
check val_rel_pair for 6

assert val_rel_inl {
  all c: CompositeComponent |
    (c.left.verified = 1 and c.right.verified = 1) implies c.verified = 1
}
check val_rel_inl for 6

assert val_rel_inr {
  all c: CompositeComponent |
    (c.left.verified = 1 and c.right.verified = 1) implies c.verified = 1
}
check val_rel_inr for 6

assert exp_rel_pair_values {
  all c: CompositeComponent |
    (c.left.verified = 1 and c.right.verified = 1) implies c.verified = 1
}
check exp_rel_pair_values for 6

assert exp_rel_inl_values {
  all c: CompositeComponent |
    (c.left.verified = 1 and c.right.verified = 1) implies c.verified = 1
}
check exp_rel_inl_values for 6

assert exp_rel_inr_values {
  all c: CompositeComponent |
    (c.left.verified = 1 and c.right.verified = 1) implies c.verified = 1
}
check exp_rel_inr_values for 6

pred ExampleComposition {
  some c: CompositeComponent | c.verified = 1
}
run ExampleComposition for 6
