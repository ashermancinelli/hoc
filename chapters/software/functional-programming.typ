#import "../../macros.typ": *
#import "../../glossaries.typ": *


== Type Theory

 <sec:type-theory>

#cite(<cardone_hindley_history_of_lambda_calcl_2006>, form: "normal") summarizes the importance
of #gls("lambda-calculus") and #acr-short("cl") to compilers and programming langauges as follows:

#quote(block: true)[
#gls("lambda-calculus", display: "λ") and CL are used extensively in higher-order logic and computing.
	Rather like the chassis of a bus, which supports the vehicle but is unseen by its users,
	versions of #gls("lambda-calculus", display: "λ") or CL underpin several important logical systems and programming
	languages. Further, #gls("lambda-calculus", display: "λ") and CL gain most of their purpose at second hand from
	such systems, just as an isolated chassis has little purpose in itself.
]


In #xref(<sec:intro-lambda-calc>, capital: false), we discussed the early foundations, and in this section
we discuss the applications.

Building on the foundations laid by John McCarthy, Alonzo Church and Haskell Curry, functional programming
came into its own with the development of Meta Langauge.
In #xref(<chap:dawn>, capital: false), we covered John Backus's work on Fortran extensively; what we didn't cover was his
famous 1977 ACM Turing Award lecture, #cite-title(<backus_can_liberated_from_vn_style_1978>), in which
he tears down his own language's contributions to the field of programming languages, favouring
instead a functional and expression-oriented approach to writing programs.
He contrasts the way one must reason about programs written in procedural languages
like ALGOL and Fortran with those written in functional languages like APL, which we will explore in this section.
This paper contributed to the eventual zeitgeist of functional programming which would dominate
some areas of the field for many years to come, especially in academia.


=== Economic Model of Developments in Functional Programming

	One framework for understanding trends in programming language design
	goes like this:

	#enum(
  [Something happens in the world that results in lots of money being spent on
		      programming languages and software.],
  [Lots of academics use this money to think about how to design programming languages.],
  [They converge on mathematical (in particular, algebraic)
		      approaches to programming languages design,
		      and these ideas gain traction.],
  [That money dries up, and software developers generally move
		      away from algebraic approaches to programming languages design,
		      and sometimes go in the #emph[opposite] direction towards
		      practicality at all costs.],
)


	I don't necessarily believe this and macro trends are hard to prove one
	way or another, but sometimes it's a useful lens.

	Perhaps the first instance of this trend was Laning and Zierler's algebraic compiler
	which formed during and immediately after the Second World War, when computing was
	in its infancy and there was lots of government funding for research into programming languages.
	This culminated in the development of ALGOL with it's principle of orthogonality of language
	features.
	This line of thinking eventually gave way to more practical and less principled approaches to
	language design found in Fortran and C.

	Another example might be the development of ML… #todo[...]


#include "functional/landin.typ"

#include "functional/ml.typ"


== APL


APL, standing for #emph[A Programming Language], was developed by Kenneth E. Iverson in 1962
and partially implemented on the IBM System/360 as APL/360.
While this partial implementation was only an interpreter for a subset of the language Iverson
designed, it would spur on the development of a family of programming languages
called #emph[array programming languages] or #emph[Iversonian languages].
#cite-title(<sammet_programming_languages_history_and_fundamentals_1969>).

#todo[dig into ML languages #cite(<hopl_history_of_ml_2020>, form: "normal")].
#todo[type systems, type inference, Hindley Milner, SML.]
#todo[similar vein to Laning and Zierler's algebraic compiler.]
