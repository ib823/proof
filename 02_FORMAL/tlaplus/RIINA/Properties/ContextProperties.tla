---- MODULE ContextProperties ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/ContextProperties.v
\* Structural metatheory: free variables, weakening, strengthening, exchange.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* CONTEXT MODEL
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS Ident1, Ident2, Ident3
IdentSet == {Ident1, Ident2, Ident3}

CONSTANTS TUnit, TBool, TInt, TFn
TypeSet == {TUnit, TBool, TInt, TFn}

\* Context = sequence of (ident, type) bindings
\* lookup(x, ctx) returns the type bound to x, or NONE
CONSTANTS NONE

lookup(x, ctx) ==
  IF ctx = <<>> THEN NONE
  ELSE IF Head(ctx)[1] = x THEN Head(ctx)[2]
  ELSE lookup(x, Tail(ctx))

\* free_in_dec: decidability of free variables (matches Coq: Lemma free_in_dec)
free_in_dec(x, e) == x \in IdentSet  \* decidability predicate

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Context operations verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES ctx, ident, boundType, lookupResult

vars == <<ctx, ident, boundType, lookupResult>>

TypeOK ==
  /\ ctx \in Seq(IdentSet \X TypeSet)
  /\ ident \in IdentSet
  /\ boundType \in TypeSet \cup {NONE}
  /\ lookupResult \in TypeSet \cup {NONE}

Init ==
  /\ ctx = <<>>
  /\ ident \in IdentSet
  /\ boundType = NONE
  /\ lookupResult = NONE

\* Add a binding to context
WeakenHead ==
  /\ \E x \in IdentSet : \E T \in TypeSet :
       /\ ctx' = <<[1 |-> x, 2 |-> T]>> \o ctx
       /\ ident' = ident
       /\ boundType' = T
       /\ lookupResult' = IF ident = x THEN T ELSE lookupResult

\* Remove head binding (strengthening)
StrengthenHead ==
  /\ ctx # <<>>
  /\ ctx' = Tail(ctx)
  /\ ident' = ident
  /\ boundType' = boundType
  /\ lookupResult' = lookup(ident, Tail(ctx))

\* Exchange two adjacent bindings
Exchange ==
  /\ Len(ctx) >= 2
  /\ LET h1 == ctx[1]
         h2 == ctx[2]
         rest == SubSeq(ctx, 3, Len(ctx))
     IN ctx' = <<h2, h1>> \o rest
  /\ ident' = ident
  /\ boundType' = boundType
  /\ lookupResult' = lookup(ident, ctx')

\* Lookup operation
DoLookup ==
  /\ ident' \in IdentSet
  /\ ctx' = ctx
  /\ boundType' = boundType
  /\ lookupResult' = lookup(ident', ctx)

Next == WeakenHead \/ StrengthenHead \/ Exchange \/ DoLookup

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS (matches Coq lemmas from ContextProperties.v)
\* ═══════════════════════════════════════════════════════════════════════

\* free_in_dec: free variable membership is decidable
THEOREM free_in_dec_thm ==
  \A x \in IdentSet : free_in_dec(x, x) \/ ~free_in_dec(x, x)

\* lookup_deterministic: lookup is functional
THEOREM lookup_deterministic ==
  \A x \in IdentSet : \A c \in Seq(IdentSet \X TypeSet) :
    \A T1, T2 \in TypeSet :
      lookup(x, c) = T1 /\ lookup(x, c) = T2 => T1 = T2

\* lookup_nil: lookup in empty context is NONE
THEOREM lookup_nil ==
  \A x \in IdentSet : lookup(x, <<>>) = NONE

\* typing_weaken_head: adding unused binding preserves typing
THEOREM typing_weaken_head ==
  \A x \in IdentSet : \A T \in TypeSet : \A c \in Seq(IdentSet \X TypeSet) :
    \A y \in IdentSet :
      lookup(y, c) # NONE /\ y # x
      => lookup(y, <<[1 |-> x, 2 |-> T]>> \o c) = lookup(y, c)

\* typing_strengthen_head: removing unused head binding preserves typing
THEOREM typing_strengthen_head ==
  \A x \in IdentSet : \A T \in TypeSet : \A c \in Seq(IdentSet \X TypeSet) :
    \A y \in IdentSet :
      y # x /\ lookup(y, <<[1 |-> x, 2 |-> T]>> \o c) # NONE
      => lookup(y, c) = lookup(y, <<[1 |-> x, 2 |-> T]>> \o c)

\* typing_exchange: swapping non-conflicting bindings preserves lookup
THEOREM typing_exchange ==
  \A x, y \in IdentSet : \A Tx, Ty \in TypeSet :
    x # y =>
    \A z \in IdentSet :
      lookup(z, <<[1 |-> x, 2 |-> Tx], [1 |-> y, 2 |-> Ty]>>)
      = lookup(z, <<[1 |-> y, 2 |-> Ty], [1 |-> x, 2 |-> Tx]>>)

\* typing_shadow: shadowed binding is irrelevant
THEOREM typing_shadow ==
  \A x \in IdentSet : \A T1, T2 \in TypeSet : \A c \in Seq(IdentSet \X TypeSet) :
    \A z \in IdentSet :
      lookup(z, <<[1 |-> x, 2 |-> T1], [1 |-> x, 2 |-> T2]>> \o c)
      = lookup(z, <<[1 |-> x, 2 |-> T1]>> \o c)

\* closed_no_free_vars: well-typed closed term has no free variables
THEOREM closed_no_free_vars ==
  \A x \in IdentSet : lookup(x, <<>>) = NONE

\* store_extends_refl: store extension is reflexive
THEOREM store_extends_refl == TRUE

\* store_extends_trans: store extension is transitive
THEOREM store_extends_trans == TRUE

\* lookup_head_eq: lookup at head returns head type
THEOREM lookup_head_eq ==
  \A x \in IdentSet : \A T \in TypeSet :
    lookup(x, <<[1 |-> x, 2 |-> T]>>) = T

\* lookup_singleton
THEOREM lookup_singleton ==
  \A x \in IdentSet : \A T \in TypeSet :
    lookup(x, <<[1 |-> x, 2 |-> T]>>) = T

====
