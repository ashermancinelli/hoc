#import "../../macros.typ": *
#import "../../glossaries.typ": *


== GNU

 <sec:gnu>

In the 1980s, business models centered on software had grown substantially
and the Unix programming environment began permeating the industry,
bringing the C programming language along with it.
The commercialization of software has obvious advantages and disadvantages:
it is convenient that people can make a living off of writing software,
but it often stifles the collaborative environment that compilers
and programming languages grew out of.
The reaction to the commercialization of software was strong and
wiped out many companies and teams within companies dedicated to
compiler development while centering the industry around a standard,
free set of tools.


=== Richard Stallman


Richard Stallman attended Harvard in 1970, pursuing a bachelor's degree in physics.
At the end of his first year there, he began attending the MIT Artificial Intelligence Lab,
where Lisp was developed (#xref(<sec:lisp>, capital: false)).
After graduating from Harvard in 1974, he joined the MIT lab as a graduate student.
This only lasted for a year, at which point he dropped out and began
working at the lab full-time #cite(<gross_stallman_interview_1999>, form: "normal").

Shortly after he began working full-time, many of the original hackers that
drew him to MIT began starting their own companies
and hiring away the other hackers at MIT.
The two most significant companies were Symbolics and #emph[Lisp Machines, Inc.] (LMI),
both set out to build #gls("lisp-machine")s and Lisp-based operating systems
based on their founder's experience working with Lisp at MIT.

Both companies attempted some level of collaboration with MIT,
to the extent that Symbolics and LMI both #emph[continued to use MIT's machines
	and source code], which led to intellectual property disagreements.
Symbolics eventually reached an agreement with MIT such that MIT would continue
to benefit from Symbolic's Lisp machine developments #emph[only as users],
and members of MIT were not allowed to view Symbolic's source code.

In an effort to maintain MIT's hacking culture, Stallman sought to replicate
#footnote[Initially, Stallman read Symbolics' source code instead of
	replicating their features from scratch;
	#cite(<weinreb_symbolics_history_2020>, form: "author") understood Stallman's prior
	statements to mean that he did not read Symbolics' source code,
	which he pointed out in #cite(<weinreb_symbolics_history_2020>, form: "normal"),
	and Stallman left a footnote in
	#cite(<stallman_my_lisp_experiences_2002>, form: "normal", supplement: [footnote 7])
	noting that Symbolics' source code was made available to MIT and he re-implemented
	their features before eventually deciding against even reading it.]
Symbolics' Lisp machine developments as they came out, such that the software
available to MIT would keep feature parity with that of the commercial products.
This benefited LMI, since they were allowed to see and use MIT's Lisp code.
Stallman #footnote[Again, this is Stallman's word against Weinreb's.
	There are many conflicting accounts.] kept LMI in business out of spite
for Symbolics, because he percieved them to have taken away his community.


=== Birth of GNU and GCC


Stallman tired of attempting to punish Symbolics and began considering
what he should do next.
By mid-1983, Stallman had considered building a new community around
a free operating system similar to Unix, GNU, for #emph[GNU's Not Unix].
He no longer worked for MIT, but he was still able to use their systems.

While the first and primary program he worked on for GNU
was the GNU Emacs editor (which he rewrote after developing the original Emacs
at MIT, which he took over from Guy Steele
#cite(<stallman_my_lisp_experiences_2002>, form: "normal", supplement: [footnote 1])),
the GNU C compiler followed quickly.

#cite(<von_hagen_definitive_guide_gcc_2011>, form: "author") notes that the idea for GCC
actually predates the wider GNU project:

#quote(block: true)[
In late 1983, just before he started
	the GNU Project, Richard M. Stallman, president of the Free Software Foundation and originator of the
	GNU Project, heard about a compiler named the Free University Compiler Kit (known as VUCK) that
	was designed to compile multiple languages, including C, and to support multiple target CPUs. Stallman
	realized that he needed to be able to bootstrap the GNU system and that a compiler was the first
	strap he needed to boot. So he wrote to VUCK’s author asking if GNU could use it. Evidently, VUCK’s
	developer was uncooperative, responding that the university was free but that the compiler was not.
	As a result, Stallman concluded that his first program for the GNU Project would be a multilanguage,
	cross-platform compiler.
	#cite(<von_hagen_definitive_guide_gcc_2011>, form: "normal")
]


GCC originally stood for the GNU C Compiler, but as the GNU project grew,
new frontends were added for other languages, thus GCC now stands for the GNU Compiler Collection.
There were two primary software projects that Stallman based the original GCC on:
the Pastel compiler, and the Portable Optimizer.


==== The Pastel Compiler


Stallman recalls in #cite(<stallman_the_gnu_project>, form: "normal") that he thereafter obtained
the code for a cross-platform compiler from Lawrence Livermore National Laboratory (LLNL)
called #emph[Pastel], because it compiled (and was written in) an "off-color Pascal,"
as the authors described it to Stallman #cite(<stallman_kth_transcript_1986>, form: "normal").

Pastel was the compiler and programming language of choice for the Amber
operating system (a competitor to Multics)
being developed at LLNL for the S-1 computer (a competitor to the Cray-1).
This OS was originally written in PL/1, but the language was found to be
inadequate; the Amber developers originally extended PL/1 with macros
to improve the type definition system, but after struggling for about 6 months
with the limitations
of PL/1's type system and module system, and the high financial cost
of the G PL/1 compiler, LLNL decided to use another language
#cite(<frankston_amber_os_bach_thesis_pastel_compiler_mit_1984>, form: "normal").

Jeff Broughton, the leader of the Amber project, wrote two compilers
for Pascal, extending the language as he saw fit. The first of these
compilers was completed in a few months, and targetted PL/1 instead of
S-1 machine code so the compiler could be used while the native backend
was still being developed.
The existing PL/1 codebase was ported to Pastel over the course of a few months.
It was around this time that Stallman visited LLNL and learned of the Pastel compiler.
A historical note from 1998 in #cite(<frankston_amber_os_bach_thesis_pastel_compiler_mit_1984>, form: "author")'s
Bachelor's thesis makes note of this interaction
#cite(<frankston_amber_os_bach_thesis_pastel_compiler_mit_1984>, form: "normal"):

#quote(block: true)[
[A]t one point in the project Richard Stallman visited, and
	had the Pastel compiler explained to him.
	He left with a copy of the source, and used it to produce the Gnu C compiler.
	Most of the techniques that gave the Gnu C compiler its reputation
	for good code generation came from the Amber Pastel compiler.
]


Pastel was an interesting language and compiler in its own right;
the compiler supported parameterized types and complicated features
that would be handled by template metaprogramming in the equivalent C++ program.
Stallman points to the example of strings: in Pastel, a programmer
could specify a #mono-text("string") if they wanted a dynamically sized string,
or #mono-text("string(n)") if they knew the length ahead of time.
The compiler could then store the string in static memory and reuse it
with each function call, saving an allocation and deallocation.

He began to add a C frontend and a Motorola 68000 backend to this compiler,
but he ran into some issues stemming from the extended Pascal it was
written in.
This version of Pascal did not require users to forward-declare functions,
meaning the compiler had to process the entire file to find the declarations
for every function all at once, consuming an amount of memory proportional
to the size of the file being compiled.
Stallman was working on what he called "a horrible version of Unix"
#cite(<stallman_kth_transcript_1986>, form: "normal") with
needlessly limited stack space, which further complicated the use of this compiler.
When he attempted to perform liveness analysis of temporary values
(where the compiler determines which values are used by the program in a given region)
he needed a quadratic matrix of bits, which took up to several hundred kilobytes
for large functions, which ran up against the onerous memory limits imposed
by this version of Unix.


==== The Portable Optimizer

 <sec:software-gnu-portable-optimizer>

Stallman also took inspiration from the University of Arizona
Portable Optimizer
especially in store-to-load #gls("forward")ing and #gls("strength-reduction").
This optimizer was also called PO, which stands for #emph[peephole optimizer]
and not #emph[portable optimizer].

This optimizer was interesting in large part because it operated on #emph[object code],
and was designed to be portable across different architectures.
The machine description for each architecture supported by the compiler was
a Lex program that recognized instructions and their properties,
and the rest of the compiler would use that information in a relatively
machine-independent way.
As of #cite(<davidson_fraser_retargetable_peephole_optimizer_po_1980>, form: "year"),
PO was written in only five pages of SNOBOL--a curious language discussed in
#xref(<sec:software-unix-snobol>, capital: false).

In this USENET discussion, #cite(<fraser_register_transfer_language_gcc_usenet_1990>, form: "author")
responds to a question about why GCC uses #acr-full("rtl") for an intermediate representation
instead of simple Lisp tuples, connecting GCC to its history with PO:

#quote(block: true)[
GCC is based in part on PO, a retargetable peephole optimizer that Jack
	Davidson and I developed at the University of Arizona starting in 1978…

	Most peephole optimizers operate on machine instructions, and they need to
	know what the instructions do. A machine-specific peephole optimizer can
	use a machine-specific representation for instructions, and the programmer
	can burn into the optimizer machine-specific information about the effects
	of instructions. A retargetable peephole optimizer, however, needs a
	machine-independent way to represent the effects of machine-specific
	instructions. (If that sounds like a contradiction, consider C: one can
	write machine-specific C programs, but the language itself is machine
	independent.) Register transfers are such a representation.
	#cite(<fraser_register_transfer_language_gcc_usenet_1990>, form: "normal")
]


#acr-short("rtl") is discussed at length in #cite(<davidson_regalloc_peephole_ops_rtl_1984>, form: "normal").
GCC continues to use #acr-short("rtl") in its backend, as well as machine-specific
peephole optimizations initially developed by Jack Davidson and Chris Fraser.
PO represented instructions symbolically; for example, #mono-text("r[4]=r[4]+1")
increments the value in register 4 by 1.
Stallman used #gls("sexpr")s to represent the same information.
The previous example would be #mono-text("(set (reg 4) (+ (reg 4) (int 1)))") in
Stallman's representation.

This new representation also had an infinite number of pseudo-registers
which get converted to real registers and stack slots by a legalization phase.
The part of the compiler generating the #acr-short("ir") does not have to
concern itself with register allocation.
This legalization phase also performs liveness analysis to determine which
pseudo-registers are in use in the same region, implying that they cannot
go in the same physical register.

Many other issues needed to be addressed in cleanup passes too,
especially when dealing with machine-specific details.
For example, on the 68000, you cannot make the output of an operation a
memory location, so to add two values stored in memory, you must first store
one of them to a register, then perform the addition, and finally store the
result back to memory.

Many of these issues were solved or being solved by other teams in the
same time period #todo[graph coloring algorithm, ask Sanjin].

PO also performed some rudimentary #acr-long("cfg") simplification and
#acr-long("dce") by identifying and simplifying redundant nodes in the #acr-short("cfg"),
particularly branch chains #todo[could expand on this...].
These optimizations are critical in modern compilers because many
optimizations rely on the #acr-short("ir") being in a #gls("normal-form")
to be maximally effective.


=== The Kernel


Linux was started by Linus Torvalds after Stallman began work on GNU,
so as far as Stallman knew, he still needed to come up with a kernel
to provide a complete, free operating system capable of competing with Unix.
The GNU community considered two existing projects for the GNU operating system kernel
before arriving at Linux:
in #cite(<stallman_kth_transcript_1986>, form: "year"), Stallman planned on using Trix,
which was a research project from MIT; by 1990, he planned to build a Unix-compatible
OS layer called GNU Hurd
#footnote[Initially called #emph[Alix]
	after Stallman's then-girlfriend, a system administrator at MIT.]
on top of the Mach microkernel,
designed at Carnegie Mellon University (and later at the University of Utah)
#cite(<stallman_the_gnu_project>, form: "normal").

Linux Torvalds fortunately started developing Linux in 1991,
and released it as free software in 1992, permitting the combination
of GNU and Linux.
Linux, compiled with GCC and paired with the other GNU utilities
formed the Unix-compatible free operating system
(and the community around it) that Stallman had sought after.


=== Cygnus and GCC


In #cite(<stallman_kth_transcript_1986>, form: "year"), Stallman finally decided to throw
out this Pastel compiler and start over, using his experience with Pastel
and the University of Arizona's optimizer to build a new C compiler
(though he did re-use the C frontend from his modified Pastel compiler).

Throughout the 1980s, progress on GCC was relatively slow because Stallman
prioritized developing Emacs.
In the 90s though, the GNU project piqued the interest of more developers
who began contributing to the compiler.
The company Cygnus Solutions made significant contributions and built
their entire organization around the GNU project.
Their business model was so innovative and impactful to the market for
compilers and compiler engineers that the company's history deserves
its own section.

At this point, there were loads of proprietary compilers from virtually
every hardware company.
The embedded systems market supported many small compiler companies
since the larger companies were primarily focused on compilers for
their flagship.
These smaller companies charged high markups for their compilers
and expensive "seats" that companies had to purchase for every single
developer that used their compilers (sometimes up to \$10,000 in 1990s dollars).
This environment was ripe for disruption--and that was exactly what Cygnus'
intended to do.

Cygnus Solutions was founded in 1989 by
#cite(<gilmore_tiemann_henkel_wallace_cygnus_history_2006>, form: "author")
in Palo Alto, California,
at which point GCC compiled itself and produced pretty good machine code
for the DEC Vax and the Motorola 68000.
Linux would not be created and joined with the GNU project until years later.
The founders thought they might be able to replace the compiler departments
at larger companies like Sun, SGI, and DEC in favor of paying Cygnus
for support contracts.
While the larger companies did not adopt GCC or purchase Cygnus' support contracts,
they did find product-market fit with companies working on embedded systems.

Cygnus put significant efforts into making GCC a robust cross-compiler
to better support these embedded systems.
Sony and Cisco were their first large customers.
For Sony, their support contract with Cygnus for cross-compilers and emulators
for their game consoles meant that game developers could start developing games
for an upcoming console long before the game hit the market, allowing their
customers to get more and better games, earlier than the competition.

For the customers, Cygnus' value proposition was favorable compared to the
proprietary compilers they could buy from the smaller compiler companies;
for instance, if Sony didn't like Cygnus' support after a couple years, they could
always take GCC and modify it to their liking. Cygnus had to earn their
keep every single development cycle.
Additionally, it lowered the bringup cost for new chips, since they didn't have to
throw away the compiler every time they wanted to significantly change the architecture.
They could simply send patches to the GNU project to add support for their new chips,
and the compilers and debuggers they were used to would continue to work.

With this business model, Cygnus obliterated many small compiler companies.
Many of them were bought out by their customers, and many of their customers
moved to open-source compilers even if they didn't purchase support contracts
from Cygnus.
This pattern was primarily restricted to the embedded market since the large companies
could afford to keep many compiler engineers in-house and produce compilers that
genuinely out-performed their open source alternatives, but this trend would
continue to grow.

Cygnus employees continued to contribute to the GNU project and put small
proprietary compiler companies out of business, and their influence
in the GNU project continued to grow.
They pioneered many features in GCC, including more complete support for C++
than existed in any other compiler at the time, including Bjarne's own
at Bell Labs.
In #cite(<gilmore_tiemann_henkel_wallace_cygnus_history_2006>, form: "normal"), Gilmore
claimed that Michael Tiemann's C++ compiler was the first true C++ compiler:

#quote(block: true)[
Our C++ compiler, g++, was the first true compiler for C++, producing assembler
	code rather than translating C++ into C. It implements all the features of AT&T C++ 2.0.
	It runs on any machine that gcc supports, and does the same optimizations.
	It also provides additional C++ specific optimizations…
	[Michael Tiemann] is the author of GNU C++, the first available native code C++ compiler.
]


In the 1990s, a subset of the GCC contributors (most of whom were employed by Cygnus)
began releasing #emph[EGCS], or the Experimental/Enhanced GNU Compiler Suite.
This was the first and last major fork of the GCC project to date
#footnote[The Pentium Compiler Group also had a fork, but while EGCS
	was separately maintained, PGCC (not to be confused with the #emph[Portland] Group C Compiler)
	closely tracked the EGCS code base, and development of the project seemed to have died
	out once EGCS was merged back into GCC.]:

#quote(block: true)[
EGCS was intended to be a more actively developed and more
	efficient compiler than GCC, but was otherwise effectively the same compiler because it closely
	tracked the GCC code base and EGCS enhancements were fed back into the GCC code base maintained
	by the GNU Project. Nonetheless, the two code bases were separately maintained. In April 1999, GCC’s
	maintainers, the GNU Project, and the EGCS steering committee formally merged. At the same time,
	GCC’s name was changed to the GNU Compiler Collection and the separately maintained (but, as
	noted, closely synchronized) code trees were formally combined, ending a long fork and
	incorporating the many bug fixes and enhancements made in EGCS into GCC. This is why EGCS is often
	mentioned, though it is officially defunct.
	#cite(<von_hagen_definitive_guide_gcc_2011>, form: "normal")
]


The timing could not have been much better for Cygnus and GCC, as just after
the company was started, Sun decided to break their compiler software out of the
their existing software bundle (thereby increasing the price).
This 1989 marketing document #cite(<sun_unbundle_sparc_c_compiler_1989>, form: "normal")
tries to put a positive spin on this decision:

#quote(block: true)[
Sun Offers New Unbundled C Compiler
	In addition, Sun introduced a new product, Sun C 1.0 — its first C compiler sold
	separately from SunOS , Sun's UNIX operating system. By unbundling the compiler,
	Sun can provide more frequent updates and enhancements independent of operating system releases.
	A version of the C compiler will continue to be bundled and supported with SunOS,
	but feature enhancements will be made to the unbundled version only.
]


At the time, Sun sold compilers for C, FORTRAN, Pascal, Modula-2 and C++, but only
C was sold separately from SunOS.
This left their users with an easy decision--start paying more (roughly \$2000 for each user
of each compiler), or start using and contributing to the new GCC compilers.
All that was needed was a Sparc backend for GCC--which it already had.
Recall that GCC first broke onto the scene by having great support for
cross-compilation and backends for exotic architectures; adding and
updating the backends would be straightforward for the users and well-received
by the GNU developers.

Peter Salus recalls in #cite(<salus_reed_daemon_gnu_penguin_2008>, form: "normal")
that the #acr-short("fsf") saw far more orders of CD copies of GCC after Sun's decision.
Their compilers cost only \$45 each.

#todo[sun had to sell their products internally too, that's why they charged for it (bryan cantril).]

In #cite(<stallman_kth_transcript_1986>, form: "year"), Stallman's compiler still generated
debugging information in the DBX debugger's format, but could also
use GDB's internal format.
There were numerous compiler tools developed in this era, beginning with
the #emph[lint] tool (discussed in #xref(<sec:software-c>, capital: false));
we discuss these compiler tools in detail in #xref(<sec:freedom-tools>, capital: false).


=== GIMPLE


#acr-short("rtl") was GCC's only #acr-short("ir") for many years,


=== GCC in C++


Bjarne's inital C++ compiler was a relatively slow and fragile macro-based compiler
called #mono-text("cfront"), which targeted C code instead of machine code directly.
C++'s reputation was not great in the 1990s, but was helped along by the GNU
C++ compiler #mono-text("g++"), which outperformed #mono-text("cfront"), generated native
code directly, and leveraged the optimizer and code generators of GCC.
This eventually (to much outrage) led to the incorporation of C++ features in
the GCC compilers themselves, which were originally written in C.

// There were loads of small companies that made money leasing out their compilers,
// and GNU put them all out of business essentially overnight.
// Every hardware company wrote their own compilers, but once it became clear
// that just adding a backend for the GNU compiler would be significantly easier
// than writing a new compiler from scratch, many of the hundreds of small compiler
// companies went out of business, and the compiler teams inside large companies
// began using and contributing to the GNU compilers.

// In \cref{chap:software}, we discussed how the C programming language permeated
// the software industry via Unix.
// Hardware vendors would then develop their own C compilers so their users
// could use the programming language they were familiar with, similar to how
// hardware vendors were expected to provide Fortran compilers.
// This led to a diverse ecosystem of C compilers from different vendors targeting
// their respective hardware with an unfortunately diverse set of supported language features.
// This meant users could not rely on a consistent experience with C compilers when
// developing software for different hardware platforms.

// The \textit{automake} and \textit{autoconf} tools were developed to address this
// issue with macros, but buy-and-large, this experience was unpleasant for users.
