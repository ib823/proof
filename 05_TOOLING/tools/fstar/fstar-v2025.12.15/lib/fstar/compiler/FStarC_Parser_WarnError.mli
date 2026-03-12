
(* The type of tokens. *)

type token = 
  | PLUS
  | MINUS
  | INT of (Z.t)
  | EOF
  | DOT_DOT
  | AT

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val warn_error_list: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> ((FStarC_Errors_Codes.error_flag * (Z.t * Z.t)) list)
