#import "../../macros.typ": *
#import "../../glossaries.typ": *


== MLIR


=== An IR In Tension


In modern compilers, the #acr-short("ir") must be extremely flexible and generic
because every component of the compiler needs something different from it.

For example, the compiler's frontend typically cares very much about the
grammar of the source language, the semantic correctness of the #acr-short("ast"),
and perhaps some early optimizations that might be performed at a very high level.
However, after that, the frontend really only cares about communicating the information
it has to the optimizer. It does not necessarily care about the details of the
optimizer, and simply wants a textual representation of the program.
The frontend would ideally emit an #acr-short("ir") that is simple with a level of abstraction
roughly matching that of the source language, minimizing the amount of work required to generate it.
The frontend may record that the user requested a particular region of code to
be inlined, unrolled, or offloaded, but writ large, the frontend does not want to deal with
the details of actually performing those transformations.

The optimizer, on the other hand, cares very much about the semantics the IR
because it is searching for patterns in the program that can be optimized.
The optimizer will want #emph[normal forms] of programs that make pattern matching
more straightforward, and it needs to be able to represent the artifacts of
optimization.
For example, after vectorization, the IR produced by the optimizer may look dramatically
different from the user's source code, with loops versioned for different vector lengths
based on aliasing information, inlined function calls, dead code eliminated, and operations
with operands known at compile time folded away.
For this phase of the compiler (and for certain optimizations more than others),
an IR capable of representing #emph[optimized] code is necessary, including
operations that may not be representable in the source language.
The optimizer does not care about how many registers the target machine has
nearly as much as the backend does, and it does not mind making drastic changes
to the representation of the program.

The backend has another set of desires; it must have information about the
machine being targeted, and it needs to map the semantics represented by the IR
to the machine's capabilities. It cares about the number of registers available,
the legality of operations on a particular machine, and how to perform those operations efficiently.
The optimizer may have produced an IR using very wide vectors, but the
backend will have to decide how to perform those operations on a specific machine
that may or may not have hardware that corresponds to vector operations of that length.

For these reasons, the different components of a compiler are constantly pulling
the IR in different directions, because all of their needs and wants must be
representable in their common format.
Now, imagine we have an IR that allows each component of the compiler to express
the semantics in a format and with semantics that #emph[they dictate].
The frontend can define very high-level operations that are roughly equivalent
to the source language so the work it needs to do when converting the #acr-short("ast")
into the IR is minimal.
The vectorizer may define new operations on vectors, the semantics they
describe, and the process for converting them into another format.
The backend may define different operations for each machine it targets,
and it can progressively convert constructs from the frontend and optimizer
into operations suitable for the target machine, that it can convert into
machine code.
This is one of the key benefits of MLIR; each component can define its own
operations and semantics, the IR can be #emph[progressively] lowered from
one phase to the next, and each phase of the compiler can coexist with the others.

Prior to MLIR, most IRs primarily took a #emph[one size fits all] approach,
which, as we have just outlined, puts different parts of the compiler in tension with each other.
There have been numerous benefits though; LLVM's IR is roughly "C with vectors,"
which, for obvious reasons, is very easy for C and C++ compilers to target,
but other compilers have been able to adopt it as well.
Rust, Swift, Julia, Zig, some Fortran compilers, and many other complete programming languages
emit LLVM IR. Their respective projects focus on the language's
frontend and on high-level optimizations, and once the IR has been sufficient
optimized, those language's compilers simply convert #emph[their] IRs into
LLVM IR and let the LLVM toolchain handle lower-level optimizations and code generation.

LLVM IR does impose some serious constraints, however.
High-level and domain-specific analyses and optimizations remain difficult.


=== Explaining MLIR


MLIR#cite(<lattner_amini_mlir_og_paper_2021>, form: "normal") is a #emph[multi-level] IR;
similar to the #emph[nanopass] architecture#cite(<keep_dybvig_nanopass_2013>, form: "normal"),
it allows for very flexible construction of #emph[dialects], which is the MLIR
project's notion of an IR. The key feature of these dialects is that they can be
composed together--in the representation of a program, many dialects can be used
together to represent different aspects of the program at different points in
the compilation process.
This orthogonality reminds me of the ALGOL committee's orthogonality design principle.
They aimed to design programming language features that all composed with each other
on different axes.
Similarly, MLIR dialects can be composed together without knowledge of each other.

The original MLIR paper, #cite-title(<lattner_amini_mlir_og_paper_2021>),
points out the difficulty of higher-level analysis of C++ programs on LLVM IR;
the IR simply cannot represent all the complicated semantics of C++ programs,
and thus optimizations that take advantage of them must either occur in the
frontend, try to recover the high-level information from the IR itself,
or find a way to stuff that information into the IR in the form of metadata,
and perform the optimizations and analyses early enough in the compiler that
the information is not obfuscated by other optimizations first.

In the previous section, I pointed out a few compilers and interpreters that
target LLVM IR, such as Rust and Swift.
It is a testament to LLVM IR's flexibility that all those projects were able to
leverage it, but they also had to maintain a level of abstraction higher than that
of LLVM IR to represent constructs specific to their languages.
MLIR seeks to fill this gap as well.

One of the primary goals of MLIR as listed in #cite-title(<lattner_amini_mlir_og_paper_2021>)
was that of #emph[progressivity]:
#quote(block: true)[
Premature lowering is the root of all evil.
	Beyond representation layers, allow multiple transformation
	paths that lower individual regions on demand. Together with
	abstraction-independent principles and interfaces, this enables
	reuse across multiple domains.
]


MLIR allows each phase of the compiler to build an IR on its own terms,
and the transition from one phase to the next is #emph[continuous]
instead of #emph[discrete].
The compiler may perform optimizations that are suitable for #emph[just] after
code generation, when the frontend has passed the program to the optimizer,
or it may perform low level optimizations towards the end of the compilation
pipeline using dialects with machine-specific operations.
The progressive nature of the transition between phases of an MLIR-based compiler
allows all the phases of the compiler to coexist and interact seamlessly.

One of the programming languages we mentioned above was Fortran.
While Fortran was one of the first programming languages we discussed in this book,
we will come to find that the Flang Fortran compiler, also part of the LLVM project,
was one of the first projects to adopt MLIR, and one of the only compilers for a
general-purpose programming language to do so.


=== Flang


#figure(
  code-file("chapters/codesign/flang.dot", lang: "dot"),
  kind: image,
  caption: [MLIR Lowering in Flang],
) <fig:flang-mlir-lowering>


The figure given in #xref(<fig:flang-mlir-lowering>, capital: false) depicts a simplified version of
Flang's process lowering the AST to MLIR.
There are numerous optimizations better suited to different stages of this
process, and each is able to perform at the optimal level of abstraction.

#cite-title(<spickett_flang_levels_up_2025>).
