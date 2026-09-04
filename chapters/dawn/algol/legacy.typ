#import "../../../macros.typ": *
#import "../../../glossaries.typ": *



=== Legacy of ALGOL


It is difficult to overstate the impact of both ALGOL 60 and 68,
even though neither saw widespread adoption in the industry (outside depictions of
algorithms in academic papers).
When Dennis Ritchie extended Ken Thompson's B compiler with a type system, he drew heavy
inspiration from ALGOL 68:

#quote(block: true)[
The scheme of type composition adopted by C owes considerable debt to Algol 68,
	although it did not, perhaps, emerge in a form that Algol's adherents would
	approve of. The central notion I captured from Algol was a type structure based
	on atomic types (including structures), composed into arrays, pointers
	(references), and functions (procedures). Algol 68's concept of unions and
	casts also had an influence that appeared later.
	#cite(<development_of_c_language_chist_ritchie_1996>, form: "normal")
]


Lindsey points out a few others:

#quote(block: true)[
The type system of ALGOL 68 has been adopted, more or less faithfully, in many subsequent
	languages. In particular, the structs, the unions, the pointer types, and the parameter passing of C
	were influenced by ALGOL 68 [Ritchie 1993], although the syntactic sugar is bizarre and C is not so
	strongly typed. Another language with a related type system is SML [Milner 1990], particularly with
	regard to its use of ref types as its means of realizing variables, and C++ has also benefitted from the
	reftypes [Stroustrup 1996].
	#cite-title(<a_history_of_algol_68_1993>)
]


ALGOL 68 also had a notable influence in the Soviet Union, details of which can
be found in Andrey Terekhov's 2014 paper #cite(<algol_68_ussr_2014>, form: "normal").

#todo[Pascal, Ada]
#todo[Lindsey: "So here are my recommendations to people who essay to design programming languages."
	#cite(<a_history_of_algol_68_1993>, form: "normal")]

The influence of ALGOL was so wide that it is hard to point to compilers or programming
languages that are #emph[not] heavily influenced by it.
A few languages stand out as exceptions because their authors were involved in the
design of ALGOL and went on to develop new languages in light of those;
the languages most concretely derived from ALGOL were Pascal and SIMULA.
Pascal is discussed in detail in 
and SIMULA in #xref(<sec:simula>, capital: false).

#todo[Defined in Wijngaarden Grammar by Adriaan van Wijngaarden.
	Contains parsing and things which in other langauges are called semantics.]

#todo['68 critcized by Hoare and Dijkstra for abandoning simplicity of '60.
	In 1970, ALGOL 68-R became the first working compiler for ALGOL 68.]
