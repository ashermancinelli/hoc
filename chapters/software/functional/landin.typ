#import "../../../macros.typ": *
#import "../../../glossaries.typ": *


=== Peter Landin's ISWIM


In #xref(<sec:intro-lambda-calc>, capital: false) we established the λ-calculus and its early
applications to compilers in Lisp, and in #xref(<sec:algol60>, capital: false) we discussed Landin's
use of λ to formalize the semantics of ALGOL 60.
Like many of the prominent British computer scientists of the time,
he was heavily involved in the development of ALGOL, and then
took that experience to further programming language design efforts.
Landin's work continued to be highly influential, in particular his
#cite(<landin_next_700_prog_langs_1966>, form: "normal").

In this paper, he describes a general framework for programming languages
called #emph[ISWIM], standing for
#emph[If You See What I Mean]
#footnote[ISWIM is sometimes pronounced #emph[eye-swim] #cite(<macqueen_history_lcf_ml_2025>, form: "normal").],
which conveyed the semantics of λ with
a particularly elegant syntax over λ constructs.
This language represented his vision for the future of programming languages
with an emphasis on expressing the programmer's intent uncluttered by
the details of the machine running the program.

#quote(block: true)[
Most programming languages are partly a way of
	expressing things in terms of other things and partly a
	basic set of given things. The ISWIM (If you See What I
	Mean) system is a byproduct of an attempt to disentangle
	these two aspects in some current languages.

	ISWIM is an attempt at a general purpose system for
	describing things in terms of other things, that can be
	problem-oriented by appropriate choice of "primitives."
	So it is not a language so much as a family of languages,
	of which each member is the result of choosing a set of
	primitives.
]


Landin described the grammar of ISWIM in informal English, which was perhaps
a step backwards from John Backus and Peter Naur's formal grammars #cite(<naur_backus_algol_1960>, form: "normal")
which were also being developed for the specification of ALGOL, though
the strict evaluation semantics and emphasis on expressivity
made the conception of λ as a programming language more concrete.

While ISWIM was not statically typed, Landin did describe an informal way to
describe data types in ISWIM, which he used for describing the data structures
used to represent the syntax of the language.
The only true implementation of ISWIM as it was in the paper
(aside from the prototype Landin #emph[mentioned] in #cite(<landin_next_700_prog_langs_1966>, form: "normal")) was
#cite(<evans_pal_language_designed_for_teaching_programming_linguistics_1968>, form: "normal")
developed by #cite(<evans_pal_language_designed_for_teaching_programming_linguistics_1968>, form: "author")
at MIT.

#todo[was dynamically typed, much like lisp but with semantics closer to λ.]
// He argued that the programmer ought to only consider their intent, and the compiler ought to
// consider the operations that would be needed to carry out their intent.


=== Christopher Strachey


Christopher Strachey, another British computer scientist, played a significant
role in the development of compiler and programming language theory.
In a series of lectures in 1967 #cite(<strachey_fundamental_concepts_2000>, form: "normal"),
he introduced the concepts of #gls("l-value")s and #gls("r-value")s.

When one reads of the history of ALGOL, the temptation is the anachronistically
assume the concepts modern students of compilers are familiar with
were also clear to the developers of the ALGOL standard.
Strachey points out how ill-defined many of these concepts were, and
attempts to define many of them more precisely in the aforementioned lectures.

#quote(block: true)[
The difficulty is that although we all use words such as ‘name’, ‘value’, ‘program’,
	‘expression’ or ‘command’ which we think we understand, it often turns out on closer
	investigation that in point of fact we all mean different things by these words,
	so that communication is at best precarious.
]


CPL, standing for #emph[Combined Programming Language], was like many of the programming
languages developed in the wake of ALGOL:
it was heavily based on the concepts therein, but sought to extend those concepts
and make the language more practical, in light of ALGOL's lack of adoption
and lack of a useful compiler or programming environment.

#quote(block: true)[
CPL is based on, and contains the concepts of, ALGOL 60…
	However, CPL is not just another proposal for the
	extension of ALGOL 60, but has been designed from first principles and has a logically coherent
	structure.
	#cite(<barron_strachey_main_features_of_cpl_1963>, form: "normal")
]


#cite(<barron_strachey_main_features_of_cpl_1963>, form: "normal").
#cite(<richards_strachey_and_cpl_compiler_2000>, form: "normal").
#cite(<strachey_fundamental_concepts_2000>, form: "normal").
#cite(<landin_my_years_w_strachey_2000>, form: "normal").
#cite(<scott_strachey_math_semantics_for_computer_languages_1971>, form: "normal").

#cite(<hopl_history_of_ml_2020>, form: "normal") notes how most of the characters in this story
were in part brought together by a shared interest and an interested amateur
who noticed them all reading similar materials in the library.
In this way, many of the early meetings formalizing the language were
informal and poorly recorded.

#quote(block: true)[
It is interesting to note that most of the central personalities first met through an unofficial reading group formed by an
	enthusiastic amateur named Mervin Pragnell, who recruited people he found reading about topics like logic at bookstores or
	libraries. The group included Strachey, Landin, Rod Burstall, and Milner, and they would read about topics like combinatory
	logic, category theory, and Markov algorithms at a borrowed seminar room at Birkbeck College, London. All were self-taught
	amateurs, although Burstall would later get a PhD in operations research at Birmingham University. Rod Burstall was
	introduced to the lambda calculus by Landin and would work for Strachey briefly before moving to Edinburgh in 1965.
	Milner had a position at Swansea University before spending time at Stanford and taking a position in Edinburgh in 1973.
]


=== Strachey and Landin Together


#cite(<landin_my_years_w_strachey_2000>, form: "normal").
#cite(<inria_history_of_ocaml_2019>, form: "normal").
