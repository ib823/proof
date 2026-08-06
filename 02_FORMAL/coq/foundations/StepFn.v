(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Executable Small-Step Semantics (REQ-54, slice S1)

    The core [step] relation (foundations/Semantics.v) is a 40-rule inductive
    Prop — nothing executable can be extracted from it. This file provides the
    EXECUTABLE counterpart [step_fn] together with its soundness theorem:

        step_fn_sound : step_fn e st ctx = Some (e', st', ctx') ->
                        (e, st, ctx) --> (e', st', ctx')

    Slice map (RIINA_MASTER_PLAN.md Part 11, REQ-54):
      S1 (this file): step_fn + step_fn_sound, all Qed, plus executable golden
         examples pinned by [vm_compute] (the seed of the S4 byte-comparison).
      S2: type_check_fn + soundness against [has_type].
      S3: Extraction to OCaml.  S4/S5: differential harness + CI.

    Design notes:
    - [step_fn] follows the same left-to-right evaluation strategy the
      relation's congruence rules encode: reduce the leftmost reducible
      subterm; only when a required subterm is a value do the head rules fire.
    - The [ST_DeclassifyValue] guard [declass_ok] demands the proof term be
      SYNTACTICALLY [EProve (EClassify v)] for the same [v]. Deciding it
      requires full-fidelity structural equality on expressions — including
      the types embedded in lambdas/sums — so this file builds total boolean
      equality for the whole [ty]/[session_type] mutual family and for [expr].
      (properties/FirstOrderComplete.v has an [expr_eqb], but it deliberately
      omits type comparison, which would be UNSOUND here.)
    - Boolean checks are only ever used in the sound direction
      (check = true -> property), so a missing case in an equality function
      fails CLOSED (step_fn refuses to step, it never mis-steps).
*)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.Arith.
From Stdlib Require Import Bool.Bool.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Import ListNotations.
Local Open Scope string_scope.

(** ** Sumbool-to-boolean bridge *)

Definition db {A : Type} (d : forall a b : A, {a = b} + {a <> b}) (a b : A)
  : bool := if d a b then true else false.

Lemma db_sound : forall (A : Type) (d : forall a b : A, {a = b} + {a <> b})
                        (a b : A),
  db d a b = true -> a = b.
Proof.
  intros A d a b H. unfold db in H. destruct (d a b); [assumption | discriminate].
Qed.

(** ** Decidable equality for the type-annotation components *)

Lemma taint_eq_dec : forall (a b : taint_source), {a = b} + {a <> b}.
Proof. decide equality. Defined.

Lemma san_eq_dec : forall (a b : sanitizer), {a = b} + {a <> b}.
Proof.
  decide equality;
    first [ apply Nat.eq_dec
          | apply string_dec
          | (apply list_eq_dec; apply string_dec) ].
Defined.

Lemma capkind_eq_dec : forall (a b : capability_kind), {a = b} + {a <> b}.
Proof. decide equality. Defined.

Lemma cap_eq_dec : forall (a b : capability), {a = b} + {a <> b}.
Proof.
  decide equality;
    first [ apply capkind_eq_dec | apply Nat.eq_dec | apply string_dec ].
Defined.

(** ** Boolean equality for the mutual [ty] / [session_type] family *)

Fixpoint ty_eqb (a b : ty) {struct a} : bool :=
  match a, b with
  | TUnit, TUnit => true
  | TBool, TBool => true
  | TInt, TInt => true
  | TString, TString => true
  | TBytes, TBytes => true
  | TFn a1 a2 e1, TFn b1 b2 e2 =>
      ty_eqb a1 b1 && ty_eqb a2 b2 && db effect_eq_dec e1 e2
  | TProd a1 a2, TProd b1 b2 => ty_eqb a1 b1 && ty_eqb a2 b2
  | TSum a1 a2, TSum b1 b2 => ty_eqb a1 b1 && ty_eqb a2 b2
  | TList t1, TList t2 => ty_eqb t1 t2
  | TOption t1, TOption t2 => ty_eqb t1 t2
  | TRef t1 l1, TRef t2 l2 => ty_eqb t1 t2 && db sec_level_eq_dec l1 l2
  | TSecret t1, TSecret t2 => ty_eqb t1 t2
  | TLabeled t1 l1, TLabeled t2 l2 => ty_eqb t1 t2 && db sec_level_eq_dec l1 l2
  | TTainted t1 s1, TTainted t2 s2 => ty_eqb t1 t2 && db taint_eq_dec s1 s2
  | TSanitized t1 s1, TSanitized t2 s2 => ty_eqb t1 t2 && db san_eq_dec s1 s2
  | TProof t1, TProof t2 => ty_eqb t1 t2
  | TCapability k1, TCapability k2 => db capkind_eq_dec k1 k2
  | TCapabilityFull c1, TCapabilityFull c2 => db cap_eq_dec c1 c2
  | TChan s1, TChan s2 => session_eqb s1 s2
  | TSecureChan s1 l1, TSecureChan s2 l2 =>
      session_eqb s1 s2 && db sec_level_eq_dec l1 l2
  | TConstantTime t1, TConstantTime t2 => ty_eqb t1 t2
  | TZeroizing t1, TZeroizing t2 => ty_eqb t1 t2
  | _, _ => false
  end
with session_eqb (a b : session_type) {struct a} : bool :=
  match a, b with
  | SessEnd, SessEnd => true
  | SessSend t1 s1, SessSend t2 s2 => ty_eqb t1 t2 && session_eqb s1 s2
  | SessRecv t1 s1, SessRecv t2 s2 => ty_eqb t1 t2 && session_eqb s1 s2
  | SessSelect a1 a2, SessSelect b1 b2 => session_eqb a1 b1 && session_eqb a2 b2
  | SessBranch a1 a2, SessBranch b1 b2 => session_eqb a1 b1 && session_eqb a2 b2
  | SessRec x1 s1, SessRec x2 s2 => String.eqb x1 x2 && session_eqb s1 s2
  | SessVar x1, SessVar x2 => String.eqb x1 x2
  | _, _ => false
  end.

Scheme ty_mutind := Induction for ty Sort Prop
  with session_mutind := Induction for session_type Sort Prop.
Combined Scheme ty_session_mutind from ty_mutind, session_mutind.

(** ** Full-fidelity boolean equality for expressions

    Compares EVERYTHING, including the [ty] annotations and effect labels the
    lossy [expr_eqb] of properties/FirstOrderComplete.v omits. *)

Fixpoint expr_beq (a b : expr) {struct a} : bool :=
  match a, b with
  | EUnit, EUnit => true
  | EBool b1, EBool b2 => Bool.eqb b1 b2
  | EInt n1, EInt n2 => Nat.eqb n1 n2
  | EString s1, EString s2 => String.eqb s1 s2
  | ELoc l1, ELoc l2 => Nat.eqb l1 l2
  | EVar x1, EVar x2 => String.eqb x1 x2
  | ELam x1 T1 e1, ELam x2 T2 e2 =>
      String.eqb x1 x2 && ty_eqb T1 T2 && expr_beq e1 e2
  | EApp a1 a2, EApp b1 b2 => expr_beq a1 b1 && expr_beq a2 b2
  | EPair a1 a2, EPair b1 b2 => expr_beq a1 b1 && expr_beq a2 b2
  | EFst e1, EFst e2 => expr_beq e1 e2
  | ESnd e1, ESnd e2 => expr_beq e1 e2
  | EInl e1 T1, EInl e2 T2 => expr_beq e1 e2 && ty_eqb T1 T2
  | EInr e1 T1, EInr e2 T2 => expr_beq e1 e2 && ty_eqb T1 T2
  | ECase s1 x1 e1 y1 f1, ECase s2 x2 e2 y2 f2 =>
      expr_beq s1 s2 && String.eqb x1 x2 && expr_beq e1 e2
      && String.eqb y1 y2 && expr_beq f1 f2
  | EIf c1 t1 f1, EIf c2 t2 f2 =>
      expr_beq c1 c2 && expr_beq t1 t2 && expr_beq f1 f2
  | ELet x1 a1 b1, ELet x2 a2 b2 =>
      String.eqb x1 x2 && expr_beq a1 a2 && expr_beq b1 b2
  | EPerform f1 e1, EPerform f2 e2 => db effect_eq_dec f1 f2 && expr_beq e1 e2
  | EHandle e1 x1 h1, EHandle e2 x2 h2 =>
      expr_beq e1 e2 && String.eqb x1 x2 && expr_beq h1 h2
  | ERef e1 l1, ERef e2 l2 => expr_beq e1 e2 && db sec_level_eq_dec l1 l2
  | EDeref e1, EDeref e2 => expr_beq e1 e2
  | EAssign a1 a2, EAssign b1 b2 => expr_beq a1 b1 && expr_beq a2 b2
  | EClassify e1, EClassify e2 => expr_beq e1 e2
  | EDeclassify a1 a2, EDeclassify b1 b2 => expr_beq a1 b1 && expr_beq a2 b2
  | EProve e1, EProve e2 => expr_beq e1 e2
  | EFix e1, EFix e2 => expr_beq e1 e2
  | ERequire f1 e1, ERequire f2 e2 => db effect_eq_dec f1 f2 && expr_beq e1 e2
  | EGrant f1 e1, EGrant f2 e2 => db effect_eq_dec f1 f2 && expr_beq e1 e2
  | _, _ => false
  end.

(** Case tactic for the equality soundness proofs: introduce everything,
    destruct the compared term, kill impossible cases, decompose the boolean
    conjunctions, convert component checks to equalities. *)
Ltac eqb_core :=
  intros;
  match goal with
  | H : ty_eqb _ ?z = true |- _ => destruct z; simpl in H; try discriminate H
  | H : session_eqb _ ?z = true |- _ => destruct z; simpl in H; try discriminate H
  | H : expr_beq _ ?z = true |- _ => destruct z; simpl in H; try discriminate H
  end;
  repeat match goal with
         | Hb : andb _ _ = true |- _ => apply andb_prop in Hb; destruct Hb
         end;
  repeat match goal with
         | Hb : db _ _ _ = true |- _ => apply db_sound in Hb
         end;
  repeat match goal with
         | Hb : String.eqb _ _ = true |- _ => apply String.eqb_eq in Hb
         | Hb : Bool.eqb _ _ = true |- _ => apply eqb_prop in Hb
         | Hb : Nat.eqb _ _ = true |- _ => apply Nat.eqb_eq in Hb
         end.

Ltac eqb_finish := subst; f_equal; auto.

Lemma ty_session_eqb_sound :
  (forall a b, ty_eqb a b = true -> a = b) /\
  (forall a b, session_eqb a b = true -> a = b).
Proof.
  apply (ty_session_mutind
           (fun a => forall b, ty_eqb a b = true -> a = b)
           (fun a => forall b, session_eqb a b = true -> a = b));
    (eqb_core; eqb_finish).
Qed.

Lemma ty_eqb_sound : forall a b, ty_eqb a b = true -> a = b.
Proof. exact (proj1 ty_session_eqb_sound). Qed.

Lemma expr_beq_sound : forall a b, expr_beq a b = true -> a = b.
Proof.
  induction a;
    (eqb_core;
     repeat match goal with
            | Hb : ty_eqb _ _ = true |- _ => apply ty_eqb_sound in Hb
            end;
     eqb_finish).
Qed.

(** ** Boolean value test *)

Fixpoint is_value (e : expr) : bool :=
  match e with
  | EUnit => true
  | EBool _ => true
  | EInt _ => true
  | EString _ => true
  | ELoc _ => true
  | ELam _ _ _ => true
  | EFix _ => true
  | EPair v1 v2 => is_value v1 && is_value v2
  | EInl v _ => is_value v
  | EInr v _ => is_value v
  | EClassify v => is_value v
  | EProve v => is_value v
  (* Everything below is never a value — listed explicitly (no wildcard) so a
     future constructor addition fails to compile instead of silently
     defaulting (the repo's no-silent-gap discipline). *)
  | EVar _ => false
  | EApp _ _ => false
  | EFst _ => false
  | ESnd _ => false
  | ECase _ _ _ _ _ => false
  | EIf _ _ _ => false
  | ELet _ _ _ => false
  | EPerform _ _ => false
  | EHandle _ _ _ => false
  | ERef _ _ => false
  | EDeref _ => false
  | EAssign _ _ => false
  | EDeclassify _ _ => false
  | ERequire _ _ => false
  | EGrant _ _ => false
  end.

Lemma is_value_sound : forall e, is_value e = true -> value e.
Proof.
  induction e; intros H; simpl in H; try discriminate H;
    try (constructor; auto; fail).
  - (* EPair *) apply andb_prop in H as [H1 H2]. constructor; auto.
Qed.

(** ** The executable step function

    One call = at most one step of the [step] relation, following the same
    strategy the congruence rules encode. Returns [None] when the input is a
    value or a stuck term. *)

Fixpoint step_fn (e : expr) (st : store) (ctx : effect_ctx)
  {struct e} : option (expr * store * effect_ctx) :=
  match e with
  (* Atoms and value-only forms never step. *)
  | EUnit => None
  | EBool _ => None
  | EInt _ => None
  | EString _ => None
  | ELoc _ => None
  | EVar _ => None
  | ELam _ _ _ => None
  | EFix _ => None

  | EApp e1 e2 =>
      match step_fn e1 st ctx with
      | Some (e1', st', ctx') => Some (EApp e1' e2, st', ctx')
      | None =>
          if is_value e1 then
            match step_fn e2 st ctx with
            | Some (e2', st', ctx') => Some (EApp e1 e2', st', ctx')
            | None =>
                if is_value e2 then
                  match e1 with
                  | ELam x _ body => Some (subst[x := e2] body, st, ctx)
                  | EFix w => Some (EApp (EApp w (EFix w)) e2, st, ctx)
                  | _ => None
                  end
                else None
            end
          else None
      end

  | EPair e1 e2 =>
      match step_fn e1 st ctx with
      | Some (e1', st', ctx') => Some (EPair e1' e2, st', ctx')
      | None =>
          if is_value e1 then
            match step_fn e2 st ctx with
            | Some (e2', st', ctx') => Some (EPair e1 e2', st', ctx')
            | None => None
            end
          else None
      end

  | EFst e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EFst e0', st', ctx')
      | None =>
          if is_value e0 then
            match e0 with
            | EPair v1 _ => Some (v1, st, ctx)
            | _ => None
            end
          else None
      end

  | ESnd e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (ESnd e0', st', ctx')
      | None =>
          if is_value e0 then
            match e0 with
            | EPair _ v2 => Some (v2, st, ctx)
            | _ => None
            end
          else None
      end

  | EInl e0 T =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EInl e0' T, st', ctx')
      | None => None
      end

  | EInr e0 T =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EInr e0' T, st', ctx')
      | None => None
      end

  | ECase e0 x1 e1 x2 e2 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (ECase e0' x1 e1 x2 e2, st', ctx')
      | None =>
          if is_value e0 then
            match e0 with
            | EInl v _ => Some (subst[x1 := v] e1, st, ctx)
            | EInr v _ => Some (subst[x2 := v] e2, st, ctx)
            | _ => None
            end
          else None
      end

  | EIf e1 e2 e3 =>
      match step_fn e1 st ctx with
      | Some (e1', st', ctx') => Some (EIf e1' e2 e3, st', ctx')
      | None =>
          match e1 with
          | EBool true => Some (e2, st, ctx)
          | EBool false => Some (e3, st, ctx)
          | _ => None
          end
      end

  | ELet x e1 e2 =>
      match step_fn e1 st ctx with
      | Some (e1', st', ctx') => Some (ELet x e1' e2, st', ctx')
      | None =>
          if is_value e1 then Some (subst[x := e1] e2, st, ctx) else None
      end

  | EPerform eff e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EPerform eff e0', st', ctx')
      | None =>
          if is_value e0 then Some (e0, st, ctx) else None
      end

  | EHandle e0 x h =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EHandle e0' x h, st', ctx')
      | None =>
          if is_value e0 then Some (subst[x := e0] h, st, ctx) else None
      end

  | ERef e0 sl =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (ERef e0' sl, st', ctx')
      | None =>
          if is_value e0 then
            Some (ELoc (fresh_loc st), store_update (fresh_loc st) e0 st, ctx)
          else None
      end

  | EDeref e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EDeref e0', st', ctx')
      | None =>
          match e0 with
          | ELoc l =>
              match store_lookup l st with
              | Some v => Some (v, st, ctx)
              | None => None
              end
          | _ => None
          end
      end

  | EAssign e1 e2 =>
      match step_fn e1 st ctx with
      | Some (e1', st', ctx') => Some (EAssign e1' e2, st', ctx')
      | None =>
          if is_value e1 then
            match step_fn e2 st ctx with
            | Some (e2', st', ctx') => Some (EAssign e1 e2', st', ctx')
            | None =>
                if is_value e2 then
                  match e1 with
                  | ELoc l =>
                      match store_lookup l st with
                      | Some _ => Some (EUnit, store_update l e2 st, ctx)
                      | None => None
                      end
                  | _ => None
                  end
                else None
            end
          else None
      end

  | EClassify e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EClassify e0', st', ctx')
      | None => None
      end

  | EDeclassify e1 e2 =>
      match step_fn e1 st ctx with
      | Some (e1', st', ctx') => Some (EDeclassify e1' e2, st', ctx')
      | None =>
          if is_value e1 then
            match step_fn e2 st ctx with
            | Some (e2', st', ctx') => Some (EDeclassify e1 e2', st', ctx')
            | None =>
                if is_value e2 then
                  match e1 with
                  | EClassify v =>
                      if expr_beq e2 (EProve (EClassify v))
                      then Some (v, st, ctx)
                      else None
                  | _ => None
                  end
                else None
            end
          else None
      end

  | EProve e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EProve e0', st', ctx')
      | None => None
      end

  | ERequire eff e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (ERequire eff e0', st', ctx')
      | None =>
          if is_value e0 then Some (e0, st, ctx) else None
      end

  | EGrant eff e0 =>
      match step_fn e0 st ctx with
      | Some (e0', st', ctx') => Some (EGrant eff e0', st', ctx')
      | None =>
          if is_value e0 then Some (e0, st, ctx) else None
      end
  end.

(** ** Soundness: every step the function takes is a step of the relation *)

(** Explicit destruct pattern for all 27 [expr] constructors, with fixed
    argument names — the case scripts below never depend on auto-naming. *)
Ltac destruct_expr27 z :=
  destruct z as [ | b0 | n0 | s0 | l0 | x0
                | x0 T0 body0 | a0 c0 | a0 c0 | a0 | a0 | a0 T0 | a0 T0
                | a0 x0 c0 y0 d0 | a0 c0 d0 | x0 a0 c0 | f0 a0 | a0 x0 h0
                | a0 sl0 | a0 | a0 c0 | v0 | a0 c0 | a0 | w0 | f0 a0 | f0 a0 ].

Theorem step_fn_sound : forall e st ctx e' st' ctx',
  step_fn e st ctx = Some (e', st', ctx') ->
  (e, st, ctx) --> (e', st', ctx').
Proof.
  induction e as [ | b | n | s | l | x
                 | x T body IHbody
                 | e1 IHe1 e2 IHe2      (* EApp *)
                 | e1 IHe1 e2 IHe2      (* EPair *)
                 | e0 IHe0              (* EFst *)
                 | e0 IHe0              (* ESnd *)
                 | e0 IHe0 T            (* EInl *)
                 | e0 IHe0 T            (* EInr *)
                 | e0 IHe0 x1 e1 IHe1 x2 e2 IHe2  (* ECase *)
                 | e1 IHe1 e2 IHe2 e3 IHe3        (* EIf *)
                 | x e1 IHe1 e2 IHe2    (* ELet *)
                 | eff e0 IHe0          (* EPerform *)
                 | e0 IHe0 x h IHh      (* EHandle *)
                 | e0 IHe0 sl           (* ERef *)
                 | e0 IHe0              (* EDeref *)
                 | e1 IHe1 e2 IHe2      (* EAssign *)
                 | e0 IHe0              (* EClassify *)
                 | e1 IHe1 e2 IHe2      (* EDeclassify *)
                 | e0 IHe0              (* EProve *)
                 | e0 IHe0              (* EFix *)
                 | eff e0 IHe0          (* ERequire *)
                 | eff e0 IHe0 ];       (* EGrant *)
    intros st ctx e' st' ctx' H; simpl in H; try discriminate H.

  - (* EApp *)
    destruct (step_fn e1 st ctx) as [[[a b] c]|] eqn:E1.
    + inversion H; subst. apply ST_App1. apply IHe1; assumption.
    + destruct (is_value e1) eqn:V1; [| discriminate].
      destruct (step_fn e2 st ctx) as [[[a b] c]|] eqn:E2.
      * inversion H; subst.
        apply ST_App2; [apply is_value_sound; assumption | apply IHe2; assumption].
      * destruct (is_value e2) eqn:V2; [| discriminate].
        destruct_expr27 e1; try discriminate H.
        -- (* ELam *) inversion H; subst.
           apply ST_AppAbs. apply is_value_sound; assumption.
        -- (* EFix *) inversion H; subst.
           apply ST_AppFix. apply is_value_sound; assumption.

  - (* EPair *)
    destruct (step_fn e1 st ctx) as [[[a b] c]|] eqn:E1.
    + inversion H; subst. apply ST_Pair1. apply IHe1; assumption.
    + destruct (is_value e1) eqn:V1; [| discriminate].
      destruct (step_fn e2 st ctx) as [[[a b] c]|] eqn:E2; [| discriminate].
      inversion H; subst.
      apply ST_Pair2; [apply is_value_sound; assumption | apply IHe2; assumption].

  - (* EFst *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_FstStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      destruct_expr27 e0; try discriminate H.
      (* EPair *) inversion H; subst.
      simpl in V0. apply andb_prop in V0 as [Va Vb].
      apply ST_Fst; apply is_value_sound; assumption.

  - (* ESnd *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_SndStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      destruct_expr27 e0; try discriminate H.
      (* EPair *) inversion H; subst.
      simpl in V0. apply andb_prop in V0 as [Va Vb].
      apply ST_Snd; apply is_value_sound; assumption.

  - (* EInl *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0; [| discriminate].
    inversion H; subst. apply ST_InlStep. apply IHe0; assumption.

  - (* EInr *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0; [| discriminate].
    inversion H; subst. apply ST_InrStep. apply IHe0; assumption.

  - (* ECase *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_CaseStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      destruct_expr27 e0; try discriminate H.
      * (* EInl *) inversion H; subst. simpl in V0.
        apply ST_CaseInl. apply is_value_sound; assumption.
      * (* EInr *) inversion H; subst. simpl in V0.
        apply ST_CaseInr. apply is_value_sound; assumption.

  - (* EIf *)
    destruct (step_fn e1 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_IfStep. apply IHe1; assumption.
    + destruct_expr27 e1; try discriminate H.
      destruct b0.
      * inversion H; subst. apply ST_IfTrue.
      * inversion H; subst. apply ST_IfFalse.

  - (* ELet *)
    destruct (step_fn e1 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_LetStep. apply IHe1; assumption.
    + destruct (is_value e1) eqn:V0; [| discriminate].
      inversion H; subst.
      apply ST_LetValue. apply is_value_sound; assumption.

  - (* EPerform *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_PerformStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      inversion H; subst.
      apply ST_PerformValue. apply is_value_sound; assumption.

  - (* EHandle *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_HandleStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      inversion H; subst.
      apply ST_HandleValue. apply is_value_sound; assumption.

  - (* ERef *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_RefStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      inversion H; subst.
      apply ST_RefValue; [apply is_value_sound; assumption | reflexivity].

  - (* EDeref *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_DerefStep. apply IHe0; assumption.
    + destruct_expr27 e0; try discriminate H.
      (* ELoc *)
      destruct (store_lookup l0 st) eqn:L; [| discriminate].
      inversion H; subst. apply ST_DerefLoc; assumption.

  - (* EAssign *)
    destruct (step_fn e1 st ctx) as [[[a b] c]|] eqn:E1.
    + inversion H; subst. apply ST_Assign1. apply IHe1; assumption.
    + destruct (is_value e1) eqn:V1; [| discriminate].
      destruct (step_fn e2 st ctx) as [[[a b] c]|] eqn:E2.
      * inversion H; subst.
        apply ST_Assign2; [apply is_value_sound; assumption | apply IHe2; assumption].
      * destruct (is_value e2) eqn:V2; [| discriminate].
        destruct_expr27 e1; try discriminate H.
        (* ELoc *)
        destruct (store_lookup l0 st) as [v1|] eqn:L; [| discriminate].
        inversion H; subst.
        apply ST_AssignLoc with (v1 := v1); [assumption |].
        apply is_value_sound; assumption.

  - (* EClassify *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0; [| discriminate].
    inversion H; subst. apply ST_ClassifyStep. apply IHe0; assumption.

  - (* EDeclassify *)
    destruct (step_fn e1 st ctx) as [[[a b] c]|] eqn:E1.
    + inversion H; subst. apply ST_Declassify1. apply IHe1; assumption.
    + destruct (is_value e1) eqn:V1; [| discriminate].
      destruct (step_fn e2 st ctx) as [[[a b] c]|] eqn:E2.
      * inversion H; subst.
        apply ST_Declassify2; [apply is_value_sound; assumption | apply IHe2; assumption].
      * destruct (is_value e2) eqn:V2; [| discriminate].
        destruct_expr27 e1; try discriminate H.
        (* EClassify v0 *)
        destruct (expr_beq e2 (EProve (EClassify v0))) eqn:B; [| discriminate].
        inversion H; subst.
        simpl in V1.
        apply ST_DeclassifyValue.
        -- apply is_value_sound; assumption.
        -- eexists. split; [apply is_value_sound; exact V1 |].
           split; [reflexivity |].
           apply expr_beq_sound in B. exact B.

  - (* EProve *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0; [| discriminate].
    inversion H; subst. apply ST_ProveStep. apply IHe0; assumption.

  - (* ERequire *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_RequireStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      inversion H; subst.
      apply ST_RequireValue. apply is_value_sound; assumption.

  - (* EGrant *)
    destruct (step_fn e0 st ctx) as [[[a b] c]|] eqn:E0.
    + inversion H; subst. apply ST_GrantStep. apply IHe0; assumption.
    + destruct (is_value e0) eqn:V0; [| discriminate].
      inversion H; subst.
      apply ST_GrantValue. apply is_value_sound; assumption.
Qed.

(** ** Fueled multi-step driver (for extraction and the S4 differential) *)

Fixpoint run_fn (fuel : nat) (e : expr) (st : store) (ctx : effect_ctx)
  : expr * store * effect_ctx :=
  match fuel with
  | O => (e, st, ctx)
  | S fuel' =>
      match step_fn e st ctx with
      | Some (e', st', ctx') => run_fn fuel' e' st' ctx'
      | None => (e, st, ctx)
      end
  end.

Theorem run_fn_sound : forall fuel e st ctx e' st' ctx',
  run_fn fuel e st ctx = (e', st', ctx') ->
  (e, st, ctx) -->* (e', st', ctx').
Proof.
  induction fuel; intros e st ctx e' st' ctx' H; simpl in H.
  - inversion H; subst. apply MS_Refl.
  - destruct (step_fn e st ctx) as [[[a b] c]|] eqn:E.
    + eapply MS_Step.
      * apply step_fn_sound. exact E.
      * apply IHfuel. exact H.
    + inversion H; subst. apply MS_Refl.
Qed.

(** ** Golden examples (executable — the seed of the REQ-54 S4 differential)

    Each is checked by [vm_compute]: the function genuinely COMPUTES these
    steps; a [step_fn] that vacuously returned [None] everywhere would be
    sound but would fail every example below. *)

Example golden_beta :
  step_fn (EApp (ELam "x" TUnit (EVar "x")) EUnit) [] []
  = Some (EUnit, [], []).
Proof. vm_compute. reflexivity. Qed.

Example golden_if_true :
  step_fn (EIf (EBool true) (EInt 1) (EInt 2)) [] []
  = Some (EInt 1, [], []).
Proof. vm_compute. reflexivity. Qed.

Example golden_let :
  step_fn (ELet "x" (EInt 7) (EVar "x")) [] []
  = Some (EInt 7, [], []).
Proof. vm_compute. reflexivity. Qed.

Example golden_ref_alloc :
  step_fn (ERef (EInt 7) LPublic) [] []
  = Some (ELoc 1, [(1, EInt 7)], []).
Proof. vm_compute. reflexivity. Qed.

Example golden_deref :
  step_fn (EDeref (ELoc 1)) [(1, EInt 7)] []
  = Some (EInt 7, [(1, EInt 7)], []).
Proof. vm_compute. reflexivity. Qed.

Example golden_assign :
  step_fn (EAssign (ELoc 1) (EInt 9)) [(1, EInt 7)] []
  = Some (EUnit, [(1, EInt 9)], []).
Proof. vm_compute. reflexivity. Qed.

Example golden_declassify :
  step_fn (EDeclassify (EClassify (EInt 42)) (EProve (EClassify (EInt 42)))) [] []
  = Some (EInt 42, [], []).
Proof. vm_compute. reflexivity. Qed.

(** Negative control: a WRONG declassification proof must NOT step (the
    boolean equality is doing real work — the proof names 43, the secret 42). *)
Example golden_declassify_wrong_proof_stuck :
  step_fn (EDeclassify (EClassify (EInt 42)) (EProve (EClassify (EInt 43)))) [] []
  = None.
Proof. vm_compute. reflexivity. Qed.

(** Negative control: stuck terms do not step. *)
Example golden_stuck :
  step_fn (EDeref EUnit) [] [] = None.
Proof. vm_compute. reflexivity. Qed.

(** Negative control: values do not step. *)
Example golden_value_no_step :
  step_fn (EPair EUnit (EInt 3)) [] [] = None.
Proof. vm_compute. reflexivity. Qed.

(** Fix unrolling at the application site (ST_AppFix). *)
Example golden_fix_unroll :
  step_fn (EApp (EFix (ELam "f" TUnit (ELam "x" TUnit (EVar "x")))) EUnit) [] []
  = Some (EApp (EApp (ELam "f" TUnit (ELam "x" TUnit (EVar "x")))
                     (EFix (ELam "f" TUnit (ELam "x" TUnit (EVar "x")))))
               EUnit, [], []).
Proof. vm_compute. reflexivity. Qed.

(** Multi-step: the fix application runs to the argument in 3 steps. *)
Example golden_run_fix :
  run_fn 5 (EApp (EFix (ELam "f" TUnit (ELam "x" TUnit (EVar "x")))) EUnit) [] []
  = (EUnit, [], []).
Proof. vm_compute. reflexivity. Qed.
