#import "../../../macros.typ": *
#import "../../../glossaries.typ": *


=== LCF at Stanford


LCF, standing for #emph[Logic for Computable Functions], was a proof assistant program
which attempted to translate the formalized logic for computable functions
from #cite(<scott_type_theory_iswim_cuch_1969>, form: "normal") into #gls("lambda-calculus", display: "λ"), originally
developed by #cite(<milner_implementation_of_lcf_1972>, form: "author")
at Stanford #cite(<milner_implementation_of_lcf_1972>, form: "normal").
This program, originally implemented in Lisp on the PDP-10, would continue to be developed
at the University of Edinburgh when Milner moved there to study in


=== The History of Standard ML


#cite(<hopl_history_of_ml_2020>, form: "normal") described the origins of the Meta Language in Landin's paper
like so:

#quote(block: true)[
The basic framework of the language design was inspired by Peter Landin’s ISWIM language
	from the mid 1960s, which was, in turn, a sugared syntax for Church’s lambda calculus. The
	ISWIM framework provided higher-order functions, which were used to express proof tactics and
	their composition. To ISWIM were added a static type system that could guarantee that programs
	that purport to produce theorems in the object language actually produce logically valid theorems
	and an exception mechanism for working with proof tactics that could fail. ML followed ISWIM in
	using strict evaluation and allowing impure features, such as assignment and exceptions.
]


=== Meta Language


"If you had to choose between a surgeon that was theoretically proven to
be perfect, or a surgeon that successfully performed 10,000 operations without
making a mistake, which one would you choose?"


=== Standard Meta Language of New Jersey


University of Endinburgh; David MacQueen.
#cite-title(<type_theory_for_all_david_macqueen_2025>).


=== Caml


Inria
