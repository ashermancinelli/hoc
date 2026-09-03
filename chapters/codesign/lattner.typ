#import "../../macros.typ": *
#import "../../glossaries.typ": *


== Chris Lattner


Chris Lattner's impact on the landscape of compiler technology in the 21#super[st]
century can't be overstated. His work on LLVM has more or less beat out every other
compiler technology.
We will now discuss the stories of the technologies that Chris developed contiguously,
with soliloquies for uses of those technologies that Chris was not involved in.


=== Low-Level Virtual Machine

 <sec:lattner-llvm>

In December of 2000, Chris began work on LLVM with his advisor Vikram Adve
as part of his PhD research at the University of Illinois at Urbana-Champaign.
LLVM stood for Low-Level Virtual Machine
at the time but is no longer an acronym and is simply the name of the project.
At the time of the publication of his thesis #cite(<lattner_phd_thesis_pointer_intensive_programs_2005>, form: "normal"),
the umbrella project initially contained only an #acr-long("ir"), an optimizer for that #acr-short("ir"),
#acr-short("ir")-level linking, and both #gls("offline-compilation") and #gls("online-compilation") for code
generation.
Today, these components are all part of the LLVM #emph[subproject] within the
LLVM #emph[umbrella project], which contains other compiler libraries and tools.

#quote(block: true)[
This chapter describes LLVM — Low-Level Virtual Machine — a compiler framework that
	aims to make lifelong program analysis and transformation available for arbitrary software, and
	in a manner that is transparent to programmers. LLVM achieves this through two parts: (a) a
	code representation with several novel features that serves as a common representation for analysis,
	transformation, and code distribution; and (b) a compiler design that exploits this representation
	to provide a combination of capabilities that is not available in any previous compilation approach
	we know of. #cite(<lattner_phd_thesis_pointer_intensive_programs_2005>, form: "normal")
]


While LLVM is perhaps best-known for some of the specific technologies contained
in the umbrella project, its most novel features lie in the compiler architecture.
The #acr-short("ir") was more flexible and language-agnostic than the other contemporary
#acr-short("ir")s, but the nature of LLVM as a set of #emph[libraries] that can
roughly be used independently of each other.
The tools developers know LLVM for (like Clang, LLD, and LLDB) are really thin main
programs that simply call into the libraries for parsing C code, optimizing a chunk of
LLVM IR, or generating machine code for that LLVM IR.
No prior art provided this level of flexibility, and LLVM's IR,
terminology, and interfaces have become the lingua-franca of the compiler world.

#quote(block: true)[
While LLVM provides some unique capabilities, and is known for
	some of its great tools (e.g., the Clang compiler, a C/C++/Objective-C compiler
	which provides a number of benefits over the GCC compiler), the main thing that
	sets LLVM apart from other compilers is its internal
	architecture.
	#cite(<brown_wilson_lattner_aosa_vol1_2011>, form: "normal", supplement: [Section 11. LLVM])
]


Here we continue discussion of Chris's career and discuss
LLVM itself in greater detail in #xref(<sec:llvm-in-detail>, capital: false).


=== Chris and LLVM at Apple

 <sec:llvm-at-apple>


==== Clang

 <sec:llvm-at-apple-clang>


==== Swift


#include "lattner-career-timeline-table.typ"


=== Chris and MLIR at Google


=== Mojo

