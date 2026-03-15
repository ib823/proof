(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(*
 * CoqCompat - Compatibility definitions for Coq boolean functions
 *
 * Provides Isabelle definitions for Coq-specific boolean functions
 * used in transpiled domain files. These are needed because the
 * transpiler (generate-multiprover.py) may emit residual Coq names.
 *)

theory CoqCompat
  imports Main
begin

(* Coq boolean conjunction *)
definition andb :: "bool \<Rightarrow> bool \<Rightarrow> bool" where
  "andb x y \<equiv> x \<and> y"

(* Coq boolean disjunction *)
definition orb :: "bool \<Rightarrow> bool \<Rightarrow> bool" where
  "orb x y \<equiv> x \<or> y"

(* Coq boolean negation *)
definition negb :: "bool \<Rightarrow> bool" where
  "negb x \<equiv> \<not> x"

(* Coq natural number equality test *)
definition eqb :: "nat \<Rightarrow> nat \<Rightarrow> bool" where
  "eqb x y \<equiv> (x = y)"

(* Coq natural number less-or-equal test *)
definition leb :: "nat \<Rightarrow> nat \<Rightarrow> bool" where
  "leb x y \<equiv> (x \<le> y)"

(* Coq natural number less-than test *)
definition ltb :: "nat \<Rightarrow> nat \<Rightarrow> bool" where
  "ltb x y \<equiv> (x < y)"

(* Coq forallb on lists *)
fun forallb :: "('a \<Rightarrow> bool) \<Rightarrow> 'a list \<Rightarrow> bool" where
  "forallb f [] = True"
| "forallb f (x # xs) = (f x \<and> forallb f xs)"

(* Coq existsb on lists *)
fun existsb :: "('a \<Rightarrow> bool) \<Rightarrow> 'a list \<Rightarrow> bool" where
  "existsb f [] = False"
| "existsb f (x # xs) = (f x \<or> existsb f xs)"

(* Simplification lemmas for andb/orb/negb *)
lemma andb_simp [simp]: "andb x y = (x \<and> y)"
  by (simp add: andb_def)

lemma orb_simp [simp]: "orb x y = (x \<or> y)"
  by (simp add: orb_def)

lemma negb_simp [simp]: "negb x = (\<not> x)"
  by (simp add: negb_def)

lemma eqb_simp [simp]: "eqb x y = (x = y)"
  by (simp add: eqb_def)

lemma leb_simp [simp]: "leb x y = (x \<le> y)"
  by (simp add: leb_def)

lemma ltb_simp [simp]: "ltb x y = (x < y)"
  by (simp add: ltb_def)

(* andb_true_iff (commonly used in domain proofs) *)
lemma andb_true_iff: "(andb a b) = True \<longleftrightarrow> a = True \<and> b = True"
  by (simp add: andb_def)

(* Coq boolean implication *)
definition implb :: "bool \<Rightarrow> bool \<Rightarrow> bool" where
  "implb x y \<equiv> (x \<longrightarrow> y)"

lemma implb_simp [simp]: "implb x y = (x \<longrightarrow> y)"
  by (simp add: implb_def)

(* Coq nth_error — returns nth element as option *)
fun nth_error :: "'a list \<Rightarrow> nat \<Rightarrow> 'a option" where
  "nth_error [] _ = None"
| "nth_error (x # _) 0 = Some x"
| "nth_error (_ # xs) (Suc n) = nth_error xs n"

(* Coq Forall — list_all equivalent *)
definition Forall :: "('a \<Rightarrow> bool) \<Rightarrow> 'a list \<Rightarrow> bool" where
  "Forall P xs \<equiv> list_all P xs"

(* Coq pair_in_list — check if pair is in list *)
definition pair_in_list :: "('a \<times> 'b) \<Rightarrow> ('a \<times> 'b) list \<Rightarrow> bool" where
  "pair_in_list p xs \<equiv> p \<in> set xs"

(* Coq all_true — conjunction of bool list *)
definition all_true :: "bool list \<Rightarrow> bool" where
  "all_true xs \<equiv> list_all id xs"

(* Coq all_unique_ids — all first elements unique *)
definition all_unique_ids :: "('a \<times> 'b) list \<Rightarrow> bool" where
  "all_unique_ids xs \<equiv> distinct (map fst xs)"

end
