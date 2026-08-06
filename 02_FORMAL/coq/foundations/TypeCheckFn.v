(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Executable Type Checker (REQ-54, slice S2)

    The typing judgment [has_type] (foundations/Typing.v) is a 27-rule
    inductive Prop. This file provides its EXECUTABLE counterpart:

        type_check_fn : type_env -> store_ty -> security_level -> expr
                        -> option (ty * effect)

    together with the soundness theorem

        type_check_fn_sound :
          type_check_fn Γ Σ Δ e = Some (T, ε) -> has_type Γ Σ Δ e T ε.

    The judgment is SYNTAX-DIRECTED (no subsumption rule; [type_uniqueness]
    in Typing.v), so the checker is a direct structural recursion: at every
    node it computes the unique candidate type and effect, comparing
    subterm types with the full-fidelity [ty_eqb] from
    foundations/StepFn.v (REQ-54 S1) whose soundness is already proven.

    Effect-join ORDER in each case mirrors the corresponding rule exactly,
    so the computed effect is definitionally the rule's effect — soundness
    needs no join-algebra reasoning.

    Boolean guards are used only in the sound direction (guard = true ->
    premise); a missing case fails CLOSED (the checker refuses, it never
    mis-types). Completeness is deliberately out of S1/S2 scope and would
    follow from [type_uniqueness]; the golden examples below pin that the
    checker actually ACCEPTS representative well-typed programs, so a
    vacuous always-None checker cannot pass this file.
*)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.Arith.
From Stdlib Require Import Bool.Bool.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.foundations.StepFn.
Import ListNotations.
Local Open Scope string_scope.

(** ** Decidable guard for the declassification rule

    [T_Declassify] demands [declass_ok e1 e2]: the secret operand is
    syntactically [EClassify v] for a VALUE [v] and the proof term is
    syntactically [EProve (EClassify v)] for the SAME [v]. *)

Definition declass_okb (e1 e2 : expr) : bool :=
  match e1 with
  | EClassify v => is_value v && expr_beq e2 (EProve (EClassify v))
  | _ => false
  end.

Lemma declass_okb_sound : forall e1 e2,
  declass_okb e1 e2 = true -> declass_ok e1 e2.
Proof.
  intros e1 e2 H. unfold declass_okb in H.
  destruct e1; try discriminate.
  apply andb_prop in H as [Hv Hb].
  apply is_value_sound in Hv.
  apply expr_beq_sound in Hb.
  exists e1. auto.
Qed.

(** ** Boolean effect equality (transparent sumbool bridge) *)

Definition effect_eqb (a b : effect) : bool := db effect_eq_dec a b.

Lemma effect_eqb_sound : forall a b, effect_eqb a b = true -> a = b.
Proof. intros a b H. apply db_sound in H. exact H. Qed.

(** ** The executable type checker *)

Fixpoint type_check_fn (Γ : type_env) (Σ : store_ty) (Δ : security_level)
                       (e : expr) {struct e} : option (ty * effect) :=
  match e with
  (* Values *)
  | EUnit => Some (TUnit, EffectPure)
  | EBool _ => Some (TBool, EffectPure)
  | EInt _ => Some (TInt, EffectPure)
  | EString _ => Some (TString, EffectPure)
  | ELoc l =>
      match store_ty_lookup l Σ with
      | Some (T, sl) => Some (TRef T sl, EffectPure)
      | None => None
      end
  | EVar x =>
      match lookup x Γ with
      | Some T => Some (T, EffectPure)
      | None => None
      end

  (* Functions *)
  | ELam x T1 body =>
      match type_check_fn ((x, T1) :: Γ) Σ Δ body with
      | Some (T2, ε) => Some (TFn T1 T2 ε, EffectPure)
      | None => None
      end
  | EApp e1 e2 =>
      match type_check_fn Γ Σ Δ e1 with
      | Some (TFn T1 T2 ε, ε1) =>
          match type_check_fn Γ Σ Δ e2 with
          | Some (T1', ε2) =>
              if ty_eqb T1' T1
              then Some (T2, effect_join ε (effect_join ε1 ε2))
              else None
          | None => None
          end
      | _ => None
      end

  (* Products *)
  | EPair e1 e2 =>
      match type_check_fn Γ Σ Δ e1, type_check_fn Γ Σ Δ e2 with
      | Some (T1, ε1), Some (T2, ε2) =>
          Some (TProd T1 T2, effect_join ε1 ε2)
      | _, _ => None
      end
  | EFst e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (TProd T1 _, ε) => Some (T1, ε)
      | _ => None
      end
  | ESnd e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (TProd _ T2, ε) => Some (T2, ε)
      | _ => None
      end

  (* Sums *)
  | EInl e0 T2 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T1, ε) => Some (TSum T1 T2, ε)
      | None => None
      end
  | EInr e0 T1 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T2, ε) => Some (TSum T1 T2, ε)
      | None => None
      end
  | ECase e0 x1 e1 x2 e2 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (TSum T1 T2, ε) =>
          match type_check_fn ((x1, T1) :: Γ) Σ Δ e1,
                type_check_fn ((x2, T2) :: Γ) Σ Δ e2 with
          | Some (T, ε1), Some (T', ε2) =>
              if ty_eqb T' T
              then Some (T, effect_join ε (effect_join ε1 ε2))
              else None
          | _, _ => None
          end
      | _ => None
      end

  (* Control *)
  | EIf e1 e2 e3 =>
      match type_check_fn Γ Σ Δ e1 with
      | Some (TBool, ε1) =>
          match type_check_fn Γ Σ Δ e2, type_check_fn Γ Σ Δ e3 with
          | Some (T, ε2), Some (T', ε3) =>
              if ty_eqb T' T
              then Some (T, effect_join ε1 (effect_join ε2 ε3))
              else None
          | _, _ => None
          end
      | _ => None
      end
  | ELet x e1 e2 =>
      match type_check_fn Γ Σ Δ e1 with
      | Some (T1, ε1) =>
          match type_check_fn ((x, T1) :: Γ) Σ Δ e2 with
          | Some (T2, ε2) => Some (T2, effect_join ε1 ε2)
          | None => None
          end
      | None => None
      end

  (* Effects *)
  | EPerform eff e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T, ε) => Some (T, effect_join ε eff)
      | None => None
      end
  | EHandle e0 x h =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T1, ε1) =>
          match type_check_fn ((x, T1) :: Γ) Σ Δ h with
          | Some (T2, ε2) => Some (T2, effect_join ε1 ε2)
          | None => None
          end
      | None => None
      end

  (* References *)
  | ERef e0 l =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T, ε) => Some (TRef T l, effect_join ε EffectWrite)
      | None => None
      end
  | EDeref e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (TRef T l, ε) =>
          if sec_leq_dec l Δ
          then Some (T, effect_join ε EffectRead)
          else None
      | _ => None
      end
  | EAssign e1 e2 =>
      match type_check_fn Γ Σ Δ e1 with
      | Some (TRef T l, ε1) =>
          match type_check_fn Γ Σ Δ e2 with
          | Some (T', ε2) =>
              if ty_eqb T' T && sec_leq_dec Δ l
              then Some (TUnit, effect_join ε1 (effect_join ε2 EffectWrite))
              else None
          | None => None
          end
      | _ => None
      end

  (* Security *)
  | EClassify e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T, ε) => Some (TSecret T, ε)
      | None => None
      end
  | EDeclassify e1 e2 =>
      match type_check_fn Γ Σ Δ e1 with
      | Some (TSecret T, ε1) =>
          match type_check_fn Γ Σ Δ e2 with
          | Some (TProof (TSecret T'), ε2) =>
              if ty_eqb T' T && declass_okb e1 e2
              then Some (T, effect_join ε1 ε2)
              else None
          | _ => None
          end
      | _ => None
      end
  | EProve e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T, ε) => Some (TProof T, ε)
      | None => None
      end

  (* General recursion: T_Fix demands e : (A -[εb]-> B) -[Pure]-> (A -[εb]-> B)
     with a PURE derivation effect, yielding fix e : A -[εb]-> B. *)
  | EFix e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (TFn (TFn A B eb) T2 ec, εe) =>
          if ty_eqb T2 (TFn A B eb)
             && effect_eqb ec EffectPure
             && effect_eqb εe EffectPure
          then Some (TFn A B eb, EffectPure)
          else None
      | _ => None
      end

  (* Capabilities *)
  | ERequire eff e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T, ε) => Some (T, effect_join ε eff)
      | None => None
      end
  | EGrant eff e0 =>
      match type_check_fn Γ Σ Δ e0 with
      | Some (T, ε) => Some (T, ε)
      | None => None
      end
  end.

(** ** Soundness: everything the checker accepts, the judgment derives *)

Theorem type_check_fn_sound : forall e Γ Σ Δ T ε,
  type_check_fn Γ Σ Δ e = Some (T, ε) ->
  has_type Γ Σ Δ e T ε.
Proof.
  (* The judgment is syntax-directed, so every case is decided by the same
     script: peel the checker's matches/guards (name-agnostically), convert
     the boolean guards to propositions via their soundness lemmas, then the
     unique constructor for the head symbol closes the goal with the IHs. *)
  induction e; intros Γ Σ Δ T ε H; simpl in H;
    repeat (match type of H with
            | (match ?x with _ => _ end) = _ =>
                let E := fresh "E" in
                destruct x eqn:E; try discriminate H
            | (let (a, b) := ?x in _) = _ =>
                destruct x; try discriminate H
            | (if ?b then _ else _) = _ =>
                let E := fresh "E" in
                destruct b eqn:E; try discriminate H
            end);
    inversion H; subst;
    repeat match goal with
           | Hb : andb _ _ = true |- _ => apply andb_prop in Hb; destruct Hb
           end;
    repeat match goal with
           | Hb : ty_eqb _ _ = true |- _ => apply ty_eqb_sound in Hb; subst
           | Hb : effect_eqb _ _ = true |- _ =>
               apply effect_eqb_sound in Hb; subst
           end;
    try match goal with
        | Hb : declass_okb _ _ = true |- _ => apply declass_okb_sound in Hb
        end;
    econstructor; eauto.
Qed.

(** ** Golden examples (executable; the checker genuinely computes) *)

Example golden_tc_identity :
  type_check_fn [] [] Public (ELam "x" TInt (EVar "x"))
  = Some (TFn TInt TInt EffectPure, EffectPure).
Proof. vm_compute. reflexivity. Qed.

Example golden_tc_app :
  type_check_fn [] [] Public (EApp (ELam "x" TInt (EVar "x")) (EInt 7))
  = Some (TInt, EffectPure).
Proof. vm_compute. reflexivity. Qed.

Example golden_tc_perform_effect :
  type_check_fn [] [] Public (EPerform EffectWrite (EInt 1))
  = Some (TInt, EffectWrite).
Proof. vm_compute. reflexivity. Qed.

Example golden_tc_declassify :
  type_check_fn [] [] Public
    (EDeclassify (EClassify (EInt 42)) (EProve (EClassify (EInt 42))))
  = Some (TInt, EffectPure).
Proof. vm_compute. reflexivity. Qed.

Example golden_tc_fix :
  type_check_fn [] [] Public
    (EFix (ELam "f" (TFn TInt TInt EffectPure)
             (ELam "x" TInt (EVar "x"))))
  = Some (TFn TInt TInt EffectPure, EffectPure).
Proof. vm_compute. reflexivity. Qed.

(** Negative control: an ill-typed application is REJECTED. *)
Example golden_tc_ill_typed_app :
  type_check_fn [] [] Public (EApp (EInt 1) (EInt 2)) = None.
Proof. vm_compute. reflexivity. Qed.

(** Negative control: argument type mismatch is REJECTED. *)
Example golden_tc_arg_mismatch :
  type_check_fn [] [] Public
    (EApp (ELam "x" TInt (EVar "x")) (EBool true)) = None.
Proof. vm_compute. reflexivity. Qed.

(** Negative control (IFC no-read-up): dereferencing a Secret-labeled
    reference in a Public context is REJECTED — the executable checker
    enforces the same clearance guard as T_Deref. *)
Example golden_tc_no_read_up :
  type_check_fn [] [(0, TInt, LSecret)] LPublic (EDeref (ELoc 0)) = None.
Proof. vm_compute. reflexivity. Qed.

(** Positive counterpart: with Secret clearance the same deref is accepted. *)
Example golden_tc_read_with_clearance :
  type_check_fn [] [(0, TInt, LSecret)] LSecret (EDeref (ELoc 0))
  = Some (TInt, effect_join EffectPure EffectRead).
Proof. vm_compute. reflexivity. Qed.

(** Negative control: a declassification with the WRONG proof term is
    REJECTED by the checker, mirroring the step-level control in StepFn.v. *)
Example golden_tc_declassify_wrong_proof :
  type_check_fn [] [] Public
    (EDeclassify (EClassify (EInt 42)) (EProve (EClassify (EInt 43))))
  = None.
Proof. vm_compute. reflexivity. Qed.
