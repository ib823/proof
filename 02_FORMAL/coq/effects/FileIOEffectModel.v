(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * FileIOEffectModel — the file-I/O builtin effect/taint discipline (Gate C)

    Models the shipped typechecker's file-builtin signature table
    (03_PROTO/crates/riina-typechecker/src/lib.rs, "File I/O builtins (fail)"
    block) over the SAME mechanized effect lattice the rest of the corpus uses
    (foundations/Syntax.v [effect]/[effect_join], effects/EffectAlgebra.v
    [effect_leq]), and proves the three disciplines that table enforces:

    (a) EFFECT — every file operation requires the FileSystem effect, and
        file I/O can never hide inside a Pure program (the file-I/O
        specialization of effect soundness);
    (b) PATH — every file operation takes a PLAIN string path, so a Tainted
        untrusted path is rejected at the type boundary (the typing-side
        counterpart of TaintSystemCorrectness.v
        [file_path_traversal_impossible]);
    (c) CONTENTS — data read from the filesystem is tainted at birth
        (file_read/file_read_lines return Tainted<String, FileSystem>), and in
        particular read contents cannot be re-used directly as a path.

    The op -> (effect, arg, ret) table below mirrors the Rust table 1:1 and is
    pinned to it by the parity test [file_builtin_table_matches_coq_model] in
    riina-typechecker/src/tests.rs: drift on either side fails that test.

    Scope note: access CONTROL (which principal may read/write which inode) is
    the separate, existing model domains/VerifiedFileSystem.v realized by
    riina-os/src/vfs.rs. This file is the effect/taint-discipline bridge for
    the surface builtins — the piece the Gate C File-I/O row still lacked. *)

Require Import RIINA.foundations.Syntax.
Require Import RIINA.effects.EffectAlgebra.

(** ** The eight file operations

    Each op is exposed under two surface names (Bahasa Melayu / English); the
    pair shares one signature, so one constructor models both. *)

Inductive file_op : Type :=
  | FOpRead       (* fail_baca       / file_read       *)
  | FOpReadLines  (* fail_baca_baris / file_read_lines *)
  | FOpExists     (* fail_ada        / file_exists     *)
  | FOpDelete     (* fail_buang      / file_delete     *)
  | FOpSize       (* fail_panjang    / file_size       *)
  | FOpListDir    (* fail_senarai    / file_list_dir   *)
  | FOpWrite      (* fail_tulis      / file_write      *)
  | FOpAppend.    (* fail_tambah     / file_append     *)

(** ** Signature shapes

    The discipline-relevant skeleton of the prototype's [Ty]: just enough
    structure to state where plain strings, tainted strings, and pairs sit. *)

Inductive io_shape : Type :=
  | ShString            (* plain String — a Tainted value does NOT inhabit it *)
  | ShTaintedString     (* Tainted<String, FileSystem>                        *)
  | ShPairStringString  (* (String, String) — (path, data) for write/append   *)
  | ShBool
  | ShUnit
  | ShInt
  | ShAny.

(** ** The table — mirrors riina-typechecker/src/lib.rs 1:1 *)

Definition file_op_effect (op : file_op) : effect := EffFileSystem.

Definition file_op_arg (op : file_op) : io_shape :=
  match op with
  | FOpWrite | FOpAppend => ShPairStringString
  | _ => ShString
  end.

Definition file_op_ret (op : file_op) : io_shape :=
  match op with
  | FOpRead | FOpReadLines => ShTaintedString
  | FOpExists => ShBool
  | FOpDelete | FOpWrite | FOpAppend => ShUnit
  | FOpSize => ShInt
  | FOpListDir => ShAny
  end.

(** ** (a) Effect discipline *)

(** Every file op requires exactly the FileSystem effect. *)
Theorem file_op_requires_filesystem :
  forall op, file_op_effect op = EffFileSystem.
Proof. intros op. reflexivity. Qed.

(** FileSystem sits in the IO category of the lattice. *)
Theorem filesystem_is_io_effect : effect_cat EffFileSystem = CatIO.
Proof. reflexivity. Qed.

(** No file op is Pure. *)
Theorem file_op_never_pure :
  forall op, file_op_effect op <> EffPure.
Proof. intros op. discriminate. Qed.

(** FileSystem is not absorbed by the lattice join: joining it into ANY effect
    can never yield Pure (join is max-by-level; FileSystem's level is 3 > 0). *)
Theorem filesystem_join_never_pure :
  forall e, effect_join EffFileSystem e <> EffPure.
Proof. intros e. destruct e; vm_compute; discriminate. Qed.

Theorem join_filesystem_never_pure :
  forall e, effect_join e EffFileSystem <> EffPure.
Proof. intros e. destruct e; vm_compute; discriminate. Qed.

(** ** A straight-line call-trace model over the real lattice

    A trace is a sequence of steps, each either a file-builtin call or some
    pure step; its effect is the fold of the called ops' effects under the
    lattice join — the same accumulation shape the shipped checker uses when
    it joins the effects of subterms. *)

Inductive trace : Type :=
  | TEnd  : trace
  | TPure : trace -> trace
  | TCall : file_op -> trace -> trace.

Fixpoint trace_effect (t : trace) : effect :=
  match t with
  | TEnd       => EffPure
  | TPure k    => trace_effect k
  | TCall op k => effect_join (file_op_effect op) (trace_effect k)
  end.

Fixpoint has_file_call (t : trace) : bool :=
  match t with
  | TEnd       => false
  | TPure k    => has_file_call k
  | TCall _ _  => true
  end.

(** HEADLINE — effect soundness, file-I/O specialization: a trace whose
    accumulated effect is Pure performs no file operation. File I/O cannot
    hide inside a Pure program. *)
Theorem pure_trace_has_no_file_io :
  forall t, trace_effect t = EffPure -> has_file_call t = false.
Proof.
  induction t as [| k IH | op k IH]; simpl; intros H.
  - reflexivity.
  - exact (IH H).
  - exfalso.
    rewrite (file_op_requires_filesystem op) in H.
    exact (filesystem_join_never_pure (trace_effect k) H).
Qed.

(** Conversely, a single file call forces the WHOLE trace's effect to dominate
    FileSystem in the lattice order. *)
Theorem file_call_forces_filesystem :
  forall t, has_file_call t = true ->
  effect_leq EffFileSystem (trace_effect t).
Proof.
  induction t as [| k IH | op k IH]; simpl; intros H.
  - discriminate.
  - exact (IH H).
  - rewrite (file_op_requires_filesystem op).
    apply effect_join_ub_l.
Qed.

(** ** (b) Path discipline *)

(** No file op accepts a tainted path: every path position is a PLAIN string,
    so an untrusted (Tainted) path is rejected at the type boundary. *)
Theorem no_file_op_accepts_tainted_path :
  forall op, file_op_arg op <> ShTaintedString.
Proof. intros op. destruct op; discriminate. Qed.

(** The write family takes (plain path, plain data): tainted content must be
    sanitized/declassified BEFORE it reaches the write sink. *)
Theorem write_ops_take_plain_pair :
  file_op_arg FOpWrite = ShPairStringString
  /\ file_op_arg FOpAppend = ShPairStringString.
Proof. split; reflexivity. Qed.

(** ** (c) Contents discipline *)

(** Everything read from the filesystem is tainted at birth. *)
Theorem file_reads_tainted_at_birth :
  file_op_ret FOpRead = ShTaintedString
  /\ file_op_ret FOpReadLines = ShTaintedString.
Proof. split; reflexivity. Qed.

(** Read contents cannot be re-used directly as a path: a tainted read result
    never matches any op's plain-string path position. *)
Theorem read_contents_cannot_be_path :
  forall op op',
    file_op_ret op = ShTaintedString ->
    file_op_arg op' <> file_op_ret op.
Proof.
  intros op op' H. rewrite H.
  apply no_file_op_accepts_tainted_path.
Qed.

(** ** Executable KATs — the exact rows the Rust parity test mirrors

    Each row pins (effect, arg shape, ret shape) for one op. The Rust test
    [file_builtin_table_matches_coq_model] asserts the typechecker's builtin
    context gives the same triple (as Ty/Effect values) for both surface
    names of each op. *)

Example kat_file_read :
  (file_op_effect FOpRead, file_op_arg FOpRead, file_op_ret FOpRead)
  = (EffFileSystem, ShString, ShTaintedString).
Proof. vm_compute. reflexivity. Qed.

Example kat_file_read_lines :
  (file_op_effect FOpReadLines, file_op_arg FOpReadLines, file_op_ret FOpReadLines)
  = (EffFileSystem, ShString, ShTaintedString).
Proof. vm_compute. reflexivity. Qed.

Example kat_file_exists :
  (file_op_effect FOpExists, file_op_arg FOpExists, file_op_ret FOpExists)
  = (EffFileSystem, ShString, ShBool).
Proof. vm_compute. reflexivity. Qed.

Example kat_file_delete :
  (file_op_effect FOpDelete, file_op_arg FOpDelete, file_op_ret FOpDelete)
  = (EffFileSystem, ShString, ShUnit).
Proof. vm_compute. reflexivity. Qed.

Example kat_file_size :
  (file_op_effect FOpSize, file_op_arg FOpSize, file_op_ret FOpSize)
  = (EffFileSystem, ShString, ShInt).
Proof. vm_compute. reflexivity. Qed.

Example kat_file_list_dir :
  (file_op_effect FOpListDir, file_op_arg FOpListDir, file_op_ret FOpListDir)
  = (EffFileSystem, ShString, ShAny).
Proof. vm_compute. reflexivity. Qed.

Example kat_file_write :
  (file_op_effect FOpWrite, file_op_arg FOpWrite, file_op_ret FOpWrite)
  = (EffFileSystem, ShPairStringString, ShUnit).
Proof. vm_compute. reflexivity. Qed.

Example kat_file_append :
  (file_op_effect FOpAppend, file_op_arg FOpAppend, file_op_ret FOpAppend)
  = (EffFileSystem, ShPairStringString, ShUnit).
Proof. vm_compute. reflexivity. Qed.
