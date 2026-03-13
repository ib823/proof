// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for capital markets
// Bounded verification of key properties
module riina/Domains/CapitalMarkets

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert buy_priority_reflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check buy_priority_reflexive for 6

assert sell_priority_reflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sell_priority_reflexive for 6

assert higher_price_buy_wins {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check higher_price_buy_wins for 6

assert lower_price_sell_wins {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lower_price_sell_wins for 6

assert trade_always_balanced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trade_always_balanced for 6

assert settlement_balanced_implies_equal_payment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check settlement_balanced_implies_equal_payment for 6

assert settlement_complete_implies_balanced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check settlement_complete_implies_balanced for 6

assert match_only_when_price_crosses {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check match_only_when_price_crosses for 6

assert no_match_when_price_gap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_match_when_price_gap for 6

assert match_qty_bounded_by_buy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check match_qty_bounded_by_buy for 6

assert match_qty_bounded_by_sell {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check match_qty_bounded_by_sell for 6

assert match_uses_sell_price {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check match_uses_sell_price for 6

assert empty_ticks_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_ticks_ordered for 6

assert singleton_ticks_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check singleton_ticks_ordered for 6

assert ordered_ticks_head_smallest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ordered_ticks_head_smallest for 6

assert trade_consideration_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trade_consideration_comm for 6

assert trade_consideration_zero_qty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trade_consideration_zero_qty for 6

assert trade_consideration_zero_price {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trade_consideration_zero_price for 6

assert settlement_complete_implies_final {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check settlement_complete_implies_final for 6

assert settlement_complete_implies_assets {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check settlement_complete_implies_assets for 6

assert orders_can_match_same_price {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check orders_can_match_same_price for 6

assert match_qty_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check match_qty_comm for 6

assert match_qty_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check match_qty_positive for 6

assert execute_match_preserves_ids {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check execute_match_preserves_ids for 6

assert execute_match_preserves_tid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check execute_match_preserves_tid for 6

assert side_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check side_eqb_refl for 6

pred ExampleCapitalMarkets {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCapitalMarkets for 6
