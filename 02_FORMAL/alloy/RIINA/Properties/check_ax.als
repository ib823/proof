// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/check_ax.v
// Models: axiom consistency checking
module riina/Properties/check_ax

abstract sig Axiom {
  isConsistent: one Int,
  isUsed: one Int
}

sig TypeAxiom extends Axiom {}
sig EffectAxiom extends Axiom {}

fact AllConsistent {
  all a: Axiom | a.isConsistent = 1
}

sig ProofStep {
  usedAxioms: set Axiom,
  isValid: one Int
}

fact ValidSteps {
  all p: ProofStep |
    (all a: p.usedAxioms | a.isConsistent = 1) implies p.isValid = 1
}


pred ExampleCheckAx {
  some p: ProofStep | p.isValid = 1 and #p.usedAxioms > 0
}
run ExampleCheckAx for 6
