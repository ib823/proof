// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for worst-case execution time
// Bounded verification of WCETTypes properties
module riina/Domains/WCETTypes

sig CodeBlock {
  wcet: one Int,
  measured: one Int,
  withinBound: one Int
}

// Invariant: wcet_positive
fact wcet_positive_fact {
  all b: CodeBlock | b.wcet > 0
}

// Invariant: measured_within_wcet
fact measured_within_wcet_fact {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}

assert 1 {
  all b: CodeBlock | b.wcet > 0
}
check 1 for 6

assert 2 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 2 for 6

assert 3 {
  all b: CodeBlock | b.wcet > 0
}
check 3 for 6

assert 4 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 4 for 6

assert 5 {
  all b: CodeBlock | b.wcet > 0
}
check 5 for 6

assert 6 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 6 for 6

assert 7 {
  all b: CodeBlock | b.wcet > 0
}
check 7 for 6

assert 8 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 8 for 6

assert 9 {
  all b: CodeBlock | b.wcet > 0
}
check 9 for 6

assert 10 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 10 for 6

assert 11 {
  all b: CodeBlock | b.wcet > 0
}
check 11 for 6

assert 12 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 12 for 6

assert 13 {
  all b: CodeBlock | b.wcet > 0
}
check 13 for 6

assert 14 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 14 for 6

assert 15 {
  all b: CodeBlock | b.wcet > 0
}
check 15 for 6

assert 16 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 16 for 6

assert 17 {
  all b: CodeBlock | b.wcet > 0
}
check 17 for 6

assert 18 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 18 for 6

assert 19 {
  all b: CodeBlock | b.wcet > 0
}
check 19 for 6

assert 20 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 20 for 6

assert 21 {
  all b: CodeBlock | b.wcet > 0
}
check 21 for 6

assert 22 {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check 22 for 6

pred ExampleWCETTypes {
  some CodeBlock
}
run ExampleWCETTypes for 6
