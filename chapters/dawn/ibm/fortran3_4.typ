#import "../../../macros.typ": *
#import "../../../glossaries.typ": *


=== SHARE

 <subsec:share>

At this point in FORTRAN's history, there was such significant adoption of
many of IBM's innovations that a volunteer user's group, SHARE, had grown to
significant membership.
SHARE was founded in 1955 and gained traction shortly after #cite(<akera_voluntarism_ibm_share_2001>, form: "normal"),
made up of IBM customers managing installations of the 704,
and collectively aimed to deduplicate the effort of managing the system
#cite(<armer_share_eulogy_1980>, form: "normal").

This group was an early precursor to the open-source movement.
Prior to this period, most machines were used for accounting and were for
highly specialized machines that constituted hardly more than a calculator.
Once more advanced machines were introduced, the task of writing software
and maintaining the hardware became increasingly difficult.

Out of this difficulty, organized user groups like SHARE emerged alongside
ad-hoc collaboration, like Grace Hopper's collaboration with
#todo[some air force group I think? where they would send her fixes and enhancements
	to the compilers.]


=== FORTRAN III


While Lois was carrying out Ziller, Backus and Nelson's design for FORTRAN II,
Ziller was already working on a more advanced version of FORTRAN, FORTRAN III.
Ziller's design incorporated a form of #gls("inline-assembly") that allowed
704 instructions to take the addresses of FORTRAN variables as arguments.
Modern forms of inline assembly allow the user to write assembly as #emph[text]
in the host program, which the compiler then embeds in the corresponding
part of the surrounding program--Ziller made the unfortunate decision of making IBM 704
instructions available #emph[at the language level], which, as Backus remarked
#cite(<hopl_backus_history_of_fortran>, form: "normal"), doomed FORTRAN III to die roughly as soon
as the IBM 704 was replaced. Some subsequent versions of IBM's scientific
computing machines (like the 709) were partially backwards-compatible
and capable of running 704 instructions,
but Backus's evaluation of the situation was more true than it was not.

Ziller and the team also introduced boolean expressions and the capability to
pass functions and subroutines as arguments and FORMAT codes for printing
alphanumeric strings.
This version of FORTRAN was never widely used and was only distributed to
20 or so installations in the winter of 1958.
It was in operation until the 1960s using the IBM 709's compatibility mode,
which kept FORTRAN III's machine-specific IBM 704 features alive for a bit longer
than the 704 itself.


=== FORTRAN IV


By 1958, most of the original FORTRAN team had moved on to other work and
some members of the original team, especially John Backus, were unhappy with
the direction they took.
The following edition, FORTRAN IV, was more of a successor to FORTRAN II than
it was FORTRAN III given the latter's machine-specific features and
lack of adoption.

The IBM user's group SHARE in 1961 declared their desire for a new FORTRAN with
new features and lacking all the bagage of FORTRAN II.
This appeard in the #cite(<allen_share_translator_datamation_1963>, form: "year")
edition of #emph[Datamation] where the SHARE group discussed their automatic
translator, discussed above in #xref(<subsec:share>, capital: false).

FORTRAN's adoption had grown so large and the set of features so restrictive
that in 1961 the team at IBM decided to create a new compiler conceptually
based on the FORTRAN II compiler, but completely rewritten, as SHARE had requested.
They used the opportunity not only to introduce new features but also to
correct some design decisions made in the FORTRAN II compiler.
This compiler would go on to run on the IBM 7090/94.
Among the larger features they introduced, there were many small changes that
cleaned up the language and made it suitable for future machines,
such as the deprecation of the #mono-text("PUNCH") and #mono-text("TAPE")
instructions in favor of a proper I/O library and runtime system.

To address the long compilation times that users of FORTRAN II dealt with,
the team Programming Research Department responsible for FORTRAN IV
tried to deliver the best of both worlds by introducing a new compiler
that was both faster and generated more efficient code, instead of adding
different compilation modes. Modern compilers let the user choose to enable
optimizations via command-line flags. For example, most C, C++ and FORTRAN compilers
provide the #mono-text("-ON") flag, where #mono-text("N") is a number
between 0 and 3 specifying how aggressive the compiler ought to be.

As a result, IBM's FORTRAN IV compiler was slower than other fast FORTRAN compilers
like the #emph[WATFOR] and #emph[WATFIV] compilers developed at the University of Waterloo
(the #strong[WAT]erloo #strong[FOR]tran compiler#cite(<cress_dirksen_graham_watfor_fortran_iv_1970>, form: "normal")),
and in general it did not produce machine code as fast as IBM's FORTRAN II compiler.

The team introduced the labeled COMMON block in FORTRAN IV, which allowed
separably compiled modules to share data with each other,
and required that each module agree on the size and layout of the data.
#footnote[Sammet notes that COMMON blocks were introduced in FORTRAN II
	#cite(<sammet_programming_languages_history_and_fundamentals_1969>, form: "normal", supplement: [Section IV.3.1.]),
	so this might need a fact-check. Or was it only #emph[labeled] COMMON blocks?
	I specify #emph[labeled] COMMON blocks here since I'm not sure.]
Programmers found this useful because they could share data between modules
without needing to recompile the entire program after every change
(unless the layout of the common block changed!),
but there are lots of mistakes that are hard to avoid with COMMON blocks.

For example, take the following subroutines, and assume they are
defined in different files (and thus different #gls("translation-unit")s):

#code-block("! f.F\nsubroutine f()\n  real n\n  real A(10)\n  common /lab/ A, n\n  ! uses of A and n...\nend subroutine\n\n! g.F\nsubroutine g()\n  real n\n  real A(5)\n  common /lab/ n, A\n  ! uses of A and n...\nend subroutine", lang: "fortran")


Notice how the declarations of #mono-text("A") and #mono-text("n") differ between the two
subroutines. The array #mono-text("A") is declared with a different size in each subroutine,
and the order of the variables is different!
If the programmer of the subroutine #mono-text("g") assigns to #mono-text("n"), they
will be assigning to the same memory referred to by the first element of #mono-text("A")
in the subroutine #mono-text("f").

The team went to great lengths to make FORTRAN IV a superset of FORTRAN II
so all the existing users could keep compiling their code with the newest
compilers, but there were some features they just couldn't support.
The IBM user's group #emph[SHARE]#xref(<subsec:share>, capital: false) came up with a
translation program #emph[SIFT], or
#emph[S]HARE #emph[I]nternal #emph[F]ORTRAN #emph[T]ranslator,
to help users upgrade their FORTRAN II code to FORTRAN IV.
#footnote[
	Jean Sammet discusses this in #cite-title(<sammet_programming_languages_history_and_fundamentals_1969>)
	and cites the article #emph[SHARE Internal FORTRAN Translator] in
	Volume 9 of #emph[Datamation] in 1963, but I'm unable to track this
	edition down myself, so we take Sammet's word for it.]
The term #gls("sift") grew to become a more general term for this sort of
translation--there were many efforts in this direction in the Python 2 to
3 upgrading process.

The first instance of this process was before the term #gls("sift")
existed or was used to mean translation more generally, with
the ALTAC to FORTRAN II translator #cite(<olsen_altac_fortranii_translator_1965>, form: "normal").


=== Standardization of FORTRAN IV


FORTRAN IV was unique among the early versions of the language in that
several teams outside IBM developed compilers for it.
#cite(<backus_heising_fortran_1964>, form: "author") noted that while a large number
of computer manufacturers distributed compilers for FORTRAN IV with
their hardware by 1963, a majority of the FORTRAN code in existence
was probably still written in FORTRAN II#cite(<backus_heising_fortran_1964>, form: "normal").

A few companies wrote FORTRAN compilers in the early 1960s,
thought not always under the name #emph[FORTRAN].
In 1960, #todo[who?] developed a compiler for
an altered version of FORTRAN II called the ALTAC system
for the Philco 2000 machine#cite(<sammet_programming_languages_history_and_fundamentals_1969>, form: "normal")--
this was the first FORTRAN compiler outside IBM.

In 1961, as detailed by #cite(<rosen_altac_fortran_1961>, form: "author"),
the team responsible for Philco 2000 successfully automatically
ported an existing FORTRAN program from the IBM 704 to their Philco 2000
machine, and claimed the performance improvements were entirely consistent with
the differences between the two machines: "there is an improvement in speed which is consistent
with the extent to which the 2000 is faster than the 704"#cite(<rosen_altac_fortran_1961>, form: "normal").
Now, roughly a year earlier, a single COBOL program ran on two different
machines as well, as discussed in #xref(<subsec:cobol-comes-into-focus>, capital: false),
but the purpose in that case was to demonstrate the portability of the COBOL
language and not necessarily to facilitate the needs of a programmer with
a real existing program--the work with ALTAC as described by Rosen
appears to be the first such case.

The first one
#emph[to call itself a FORTRAN compiler] was for FORTRAN I
on the UNIVAC Solid State 80, which was running by January 1961
#cite(<sammet_programming_languages_history_and_fundamentals_1969>, form: "normal"),
and later that year Remington Rand developed a compiler
for a slightly altered FORTRAN II.

In the #cite(<oswald_various_fortrans_datamation_1964>, form: "year") edition of #emph[Datamation],
#cite(<oswald_various_fortrans_datamation_1964>, form: "author")
constructed a nearly-exhaustive table comparing the features and (mis)behaviors of
16 different FORTRAN compilers of the 43 he was aware of at the time.
He also provided readers with some of the potential reasons for the
differences between the compilers
#cite(<oswald_various_fortrans_datamation_1964>, form: "normal"):

#quote(block: true)[
One is tempted to ask: Why these differences? There
	is no single cause. Certainly the basic hardware differences make
	their contribution. Some compilers differ from
	others because of misinterpretation or a desire to improve upon what exists.

	Noncompatibility is also a potential sales tool. Given a class
	of machines, one competitor can write language specifications
	that would permit the proper compilation of
	programs from the competing machines but effectively
	prevent reverse compatibility.
	This can be done by adding
	one or more features that the competitors do not have…

	The "universal" programming language, FORTRAN,
	is indeed universal but not all dialects are the same. We
	have presented some of the differences in the language
	and their effect on compatibility of FORTRAN programs.
	To those engaged in writing codes intended to be
	compatible with another machine now or in the future,
	caution is suggested. Such "compatible" programming
	requires great care and foresight.
]


As Oswald pointed out, the value of a new FORTRAN compiler was that
the different compiler would allow organizations to buy that company's
computers if they were used to using IBM equipment (and most were).
So, if the competing company provided a compiler capable of handling
all their customers' existing code, they could take IBM's customers.
Once they had already taken IBM's customers however, the temptation would
be to introduce new #emph[features] that their customers would like and
adopt, thereby locking them into their platforms.

The gamut of new compilers for the language prompted its standardization.
If the language is handled by several different compilers with potentially
divergent interests and customers, who is to determine the proper behavior
of FORTRAN programs where the language's specification is ambiguous?
Much of the value of the language is derived from its user's ability
to take their programs and run them on another device rather than
rewriting them--and rewriting them for a vendor's bespoke FORTRAN
compiler is hardly better than rewriting them in a new instruction set
for a new machine.
Thus FORTRAN IV served as the basis of the first FORTRAN standards,
which the American Standards Association (ASA) began developing in 1962
in the first FORTRAN standards committee, entitled the ASA X3.4.3.

The ASA's development of the first FORTRAN standard constituted the
first standardization of a programming language by the ASA,
and in the end #emph[two] FORTRAN standards were produced:
standard FORTRAN and standard Basic FORTRAN.
These roughly corresponded to FORTRAN IV and FORTRAN II, though
Basic FORTRAN #emph[actually was] a perfect subset of FORTRAN,
while IBM's actual FORTRAN IV compiler did not support a proper
superset of their FORTRAN II compiler's notion of FORTRAN.
