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

end
