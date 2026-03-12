
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | PLUS
    | MINUS
    | INT of (
# 9 "fstar-guts/FStarC_Parser_WarnError.mly"
       (Z.t)
# 17 "fstar-guts/FStarC_Parser_WarnError.ml"
  )
    | EOF
    | DOT_DOT
    | AT
  
end

include MenhirBasics

# 1 "fstar-guts/FStarC_Parser_WarnError.mly"
  
(* This is just a simple parser for the arguments
to --warn_error. *)
open Prims
open FStarC_Errors_Codes


# 35 "fstar-guts/FStarC_Parser_WarnError.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_warn_error_list) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: warn_error_list. *)

  | MenhirState12 : (('s, _menhir_box_warn_error_list) _menhir_cell1_flag _menhir_cell0_range, _menhir_box_warn_error_list) _menhir_state
    (** State 12.
        Stack shape : flag range.
        Start symbol: warn_error_list. *)


and ('s, 'r) _menhir_cell1_flag = 
  | MenhirCell1_flag of 's * ('s, 'r) _menhir_state * (FStarC_Errors_Codes.error_flag)

and 's _menhir_cell0_range = 
  | MenhirCell0_range of 's * (Z.t * Z.t)

and _menhir_box_warn_error_list = 
  | MenhirBox_warn_error_list of ((FStarC_Errors_Codes.error_flag * (Z.t * Z.t)) list) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 29 "fstar-guts/FStarC_Parser_WarnError.mly"
          ( CAlwaysError )
# 63 "fstar-guts/FStarC_Parser_WarnError.ml"
     : (FStarC_Errors_Codes.error_flag))

let _menhir_action_02 =
  fun () ->
    (
# 30 "fstar-guts/FStarC_Parser_WarnError.mly"
          ( CWarning )
# 71 "fstar-guts/FStarC_Parser_WarnError.ml"
     : (FStarC_Errors_Codes.error_flag))

let _menhir_action_03 =
  fun () ->
    (
# 31 "fstar-guts/FStarC_Parser_WarnError.mly"
          ( CSilent )
# 79 "fstar-guts/FStarC_Parser_WarnError.ml"
     : (FStarC_Errors_Codes.error_flag))

let _menhir_action_04 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 87 "fstar-guts/FStarC_Parser_WarnError.ml"
     : ((FStarC_Errors_Codes.error_flag * (Z.t * Z.t)) list))

let _menhir_action_05 =
  fun _1 _2 xs ->
    let x = 
# 25 "fstar-guts/FStarC_Parser_WarnError.mly"
                      ( (_1, _2) )
# 95 "fstar-guts/FStarC_Parser_WarnError.ml"
     in
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 100 "fstar-guts/FStarC_Parser_WarnError.ml"
     : ((FStarC_Errors_Codes.error_flag * (Z.t * Z.t)) list))

let _menhir_action_06 =
  fun i1 i2 ->
    (
# 35 "fstar-guts/FStarC_Parser_WarnError.mly"
    ( (i1, i2) )
# 108 "fstar-guts/FStarC_Parser_WarnError.ml"
     : (Z.t * Z.t))

let _menhir_action_07 =
  fun i ->
    (
# 37 "fstar-guts/FStarC_Parser_WarnError.mly"
    ( (i, i) )
# 116 "fstar-guts/FStarC_Parser_WarnError.ml"
     : (Z.t * Z.t))

let _menhir_action_08 =
  fun l ->
    (
# 26 "fstar-guts/FStarC_Parser_WarnError.mly"
    ( l )
# 124 "fstar-guts/FStarC_Parser_WarnError.ml"
     : ((FStarC_Errors_Codes.error_flag * (Z.t * Z.t)) list))

let _menhir_action_09 =
  fun e ->
    (
# 22 "fstar-guts/FStarC_Parser_WarnError.mly"
                     ( e )
# 132 "fstar-guts/FStarC_Parser_WarnError.ml"
     : ((FStarC_Errors_Codes.error_flag * (Z.t * Z.t)) list))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | AT ->
        "AT"
    | DOT_DOT ->
        "DOT_DOT"
    | EOF ->
        "EOF"
    | INT _ ->
        "INT"
    | MINUS ->
        "MINUS"
    | PLUS ->
        "PLUS"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_07 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_warn_error_list =
    fun _menhir_stack _v ->
      let l = _v in
      let _v = _menhir_action_08 l in
      let e = _v in
      let _v = _menhir_action_09 e in
      MenhirBox_warn_error_list _v
  
  let rec _menhir_run_13 : type  ttv_stack. (ttv_stack, _menhir_box_warn_error_list) _menhir_cell1_flag _menhir_cell0_range -> _ -> _menhir_box_warn_error_list =
    fun _menhir_stack _v ->
      let MenhirCell0_range (_menhir_stack, _2) = _menhir_stack in
      let MenhirCell1_flag (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_05 _1 _2 xs in
      _menhir_goto_list___anonymous_0_ _menhir_stack _v _menhir_s
  
  and _menhir_goto_list___anonymous_0_ : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_warn_error_list) _menhir_state -> _menhir_box_warn_error_list =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState12 ->
          _menhir_run_13 _menhir_stack _v
      | MenhirState00 ->
          _menhir_run_07 _menhir_stack _v
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_warn_error_list) _menhir_state -> _menhir_box_warn_error_list =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_02 () in
      _menhir_goto_flag _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_flag : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_warn_error_list) _menhir_state -> _ -> _menhir_box_warn_error_list =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_flag (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | INT _v_0 ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | DOT_DOT ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | INT _v_1 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let (i2, i1) = (_v_1, _v_0) in
                  let _v = _menhir_action_06 i1 i2 in
                  _menhir_goto_range _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
              | _ ->
                  _eRR ())
          | AT | EOF | MINUS | PLUS ->
              let i = _v_0 in
              let _v = _menhir_action_07 i in
              _menhir_goto_range _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_range : type  ttv_stack. (ttv_stack, _menhir_box_warn_error_list) _menhir_cell1_flag -> _ -> _ -> _ -> _ -> _menhir_box_warn_error_list =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_range (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState12
      | MINUS ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState12
      | AT ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState12
      | EOF ->
          let _v_0 = _menhir_action_04 () in
          _menhir_run_13 _menhir_stack _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_02 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_warn_error_list) _menhir_state -> _menhir_box_warn_error_list =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_03 () in
      _menhir_goto_flag _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_warn_error_list) _menhir_state -> _menhir_box_warn_error_list =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_01 () in
      _menhir_goto_flag _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_warn_error_list =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | MINUS ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | AT ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | EOF ->
          let _v = _menhir_action_04 () in
          _menhir_run_07 _menhir_stack _v
      | _ ->
          _eRR ()
  
end

let warn_error_list =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_warn_error_list v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
