#import "macros.typ": mono, mono-text, todo, unsupported
#import "@preview/glossarium:0.5.10" as glossarium

#let glossary-ref(key, ..args) = glossarium.gls(
  key,
  first: false,
  update: false,
  ..args,
)

#let glossary-data = (
  "pallas": (
    name: "Pallas",
    description: [The kernel authoring language part of the #glossary-ref("jax") framework.]
  ),
  "jax": (
    name: "JAX",
    description: [Machine-learning focused GPU and TPU framework.]
  ),
  "cutedsl": (
    name: "CuTe DSL",
    description: [#glossary-ref("dsl") evolved out of #glossary-ref("cutlass").]
  ),
  "cutlass": (
    name: "CUTLASS",
    description: [
      CUDA C++ templates and Python #glossary-ref("dsl")s designed for high performance
      matrix multiplication NVIDIA GPU programs.
    ]
  ),
  "bytecode": (name: "bytecode", description: [A compiler intermediate representation for the purpose of interpretation or execution instead of optimization]),
  "sift": (name: "sift", description: [The process of automatically translating code in one high-level language to another, preserving semantics and pointing out components of the source code that must be manually translated]),
  "bootstrap": (name: "bootstrap", description: [The process of writing a compiler in the language that it compiles, such that an older version of the compiler can be used to compile a newer version of itself]),
  "stride1": (name: "stride 1", description: [An array access pattern where the innermost loop iterates over the array elements in contiguous memory locations]),
  "ub": (name: "undefined behavior", description: [Source code constructs that are illegal as per the language's specification. Typically, undefined behavior assumed never to happen in a well-formed program, is used by optimizers when certain compiler flags are enabled (such as #mono-text("-fstrict-aliasing"))]),
  "F77": (name: "Fortran 77", description: [The 1977 version of the Fortran programming language's standard]),
  "F90": (name: "Fortran 90", description: [The 1990 version of the Fortran programming language's standard]),
  "foss": (name: "FOSS", description: [Free and open-source software. This software is typically distributed under a license that allows users to modify and redistribute it freely, though different licenses imply different permissions. The two primary categories of open-source licenses are #emph[permissive] and #emph[copyleft]]),
  "ftn": (name: "Fortran", description: [The Fortran programming language, standing for #emph[FORmula TRANslator]. Most renditions of the name of the programming language have only the first letter capitalized (#emph[Fortran]), however early versions were rendered as #emph[FORTRAN]. We attempt to use the proper name for each time period. #emph[Fortran] came to be used after the 1990 edition of the standard, while the 1977 standard and all prior versions were rendered as #emph[FORTRAN]]),
  "inducvar": (name: "induction variable", description: [A variable changes by some constant in each iteration of a loop. In #mono-text("for (int i=0; i < n; i++)"), the variable #mono-text("i") is an induction variable]),
  "constant-folding": (name: "constant folding", description: [Optimization that replaces an expression with a constant value if the expression's value can be determined at compile time. For example, the expression #mono-text("2 + 3") can be replaced with #mono-text("5") by the compiler so it need not be calculated by the final program]),
  "loop-versioning": (name: "loop versioning", description: [TODO]),
  "translation-unit": (name: "translation unit", description: [A component of a program being compiled such that the compiler has access to all the information contained in the component during compilation. For C, C++ and Fortran code, a translation unit typically corresponds to a single source file which is compiled to an object file before being linked into a program or library. Some compilers always treat the entire program as a single translation unit, like the original FORTRAN compiler or the Zig compiler]),
  "tripcount": (name: "trip count", description: [The number of times a loop will execute]),
  "inline-assembly": (name: "inline assembly", description: [A programming language feature that allows a programmer to write assembly code directly within another programming language, reading from and writing to variables in the host programming language]),
  "separable-compilation": (name: "separable compilation", description: [A programming paradigm where a program is divided into multiple modules that can be compiled independently. For example, C source files can be compiled independently, and then linked together to form an executable.]),
  "basicblock": (name: "basic block", description: [In compiler theory, a basic block is typically a sequence of instructions that are executed in order and containing a single entry point and exit point]),
  "backedge": (name: "back-edge", description: [A back-edge is an edge in the CFG that returns execution from the end of a loop body back to the beginning of the loop, or the loop's header]),
  "header-cfg": (name: "header", description: [A header is the first node in a control-flow graph of a loop. Loops begin execution at the entry node, then to the header node, then through the loop body node(s), and finally they either take the back-edge back to the start of the loop, or they exit the loop]),
  "r-value": (name: "r-value", description: [An value that can be stored to an address. Read as "a value that may occur on the right-hand side of an assignment." In most programming languages, l-values may act as r-values, but not all r-values may act as l-values. The variable #mono-text("foo") may occur on either side of an assignment, but there is little sense in the number #mono-text("5") being assigned a value]),
  "l-value": (name: "l-value", description: [An addressable value that another value can be stored to. Read as "a value that may occur on the left-hand side of an assignment"]),
  "dynamic-binding": (name: "dynamic binding", description: [Variable scoping semantics where the value of a variable is determined by the value the variable name corresponds to in the program's environment when the value is used.]),
  "call-by-name": (name: "call-by-name", description: [Function calling semantics where the argument's expression is evaluated #emph[each time it is used] in the body of the function. Contrast this with call-by-value and dynamic binding]),
  "call-by-value": (name: "call-by-value", description: [Function calling semantics where the argument's expression is evaluated #emph[once, before it is passed] to the body of the function. Contrast this with call-by-name and dynamic binding. This is how most programming languages work]),
  "call-by-reference": (name: "call-by-reference", description: [Function calling semantics where the argument's address is passed in place of its value such that expressions and statements where the parameter occurs as an l-value result in assignements to the variable's storage in the caller's scope]),
  "offline-compilation": (name: "offline compilation", description: [todo]),
  "online-compilation": (name: "online compilation", description: [todo]),
  "forward": (name: "forward", description: [A compiler optimization where a load of a memory reference is replaced by the value last stored to it. Sometimes called forward substitution]),
  "strength-reduction": (name: "strength reduction", description: [A compiler optimization #todo[todo]]),
  "autovec": (name: "automatic vectorization", description: [A process for leveraging SIMD instructions where the compiler #emph[infers] the opportunities to exploit parallelism in the user's program. The user does not #emph[necessarily] have to change their program, but they can often benefit from it or provide compiler flags or preprocessor directives to explicitly request it]),
  "lisp-machine": (name: "Lisp machine", description: [A type of computer designed to run Lisp as the primary programming language, usually with some level of hardware support]),
  "sexpr": (name: "s-expression", description: [A data structure used to represent arbitrary lists in Lisp, such as #emph[(a b c)].
			Some tools and programming languages outside of Lisp use s-expressions to represent lists
			and list-like data structures]),
  "normal-form": (name: "normal form", description: [Many optimizations rely on the program being in the simplest possible form.
			Just as we expect fractions to be in their simplest form (it would be unusual to see
			$(5) / (10)$#super[ths]), optimizations often expect or require their input
			programs to be as reduced as possible form to be maximally effective.
			// See \href{https://llvm.org/docs/LoopTerminology.html#loop-simplify-form}{LLVM's loop simplify form}
			for an example]),
  "canonical-form": (name: "canonical form", description: [See normal form]),
  "peephole": (name: "peephole optimization", description: [Sometimes called a #emph[peep], this kind of transformation typically
			traverses the entire program searching for a small pattern that can be simplified or otherwise
			transformed in a beneficial way]),
  "pgo": (name: "profile-guided optimization", description: [Compiler optimizations that take advantage of statistics from the execution of a program to improve the compiler's heuristics. A user might compile and run a very program with special compiler flags such that loop hotness and trip counts are recorded, and then re-compile their program such that the compiler can use those statistics to drive its optimization decisions]),
  "licm": (name: "loop-invariant code motion", description: [Loop-invariant code motion is an optimization that moves code outside of a loop if it does not depend in any way on the loop's induction variables]),
  "lambda-calculus": (name: "λ-calculus", description: [A formal system introduced by Alonzo Church for expressing computation through function abstraction and application. The symbol λ is commonly used as an abbreviation.]),
)

#let acronym-data = (
  "dsl": (
    short: "DSL", long: "Domain-specific language", description: [
      A language with a specific (often narrow) purpose,
      often embedded in another language to make a particular
      subset of programs easier to write with syntax different from the embedded
      language.
    ]
  ),
  "hpc": (short: "HPC", long: "high-performance computing", description: [A subset of computing primarily concerned with scientific applications
	on very large-scale systems, often referred to as supercomputers or compute clusters]),
  "pgi": (short: "PGI", long: "The Portland Group", description: [A compiler company based in Portland, Oregon that specialized in
	HPC compilers]),
  "ir": (short: "IR", long: "intermediate representation", description: [The internal format of a program as it exists inside the compiler]),
  "fsf": (short: "FSF", long: "Free Software Foundation", description: [The software foundation started by Richard Stallman with the goal of supporting free software]),
  "cl": (short: "CL", long: "combinatory logic", description: []),
  "ast": (short: "AST", long: "abstract syntax tree", description: [A tree representation of the program after being parsed]),
  "jit": (short: "JIT", long: "just-in-time", description: [A compilation methodology where the program is compiled as it is needed by the program instead of ahead of time. See also online compilation]),
  "simd": (short: "SIMD", long: "single instruction, multiple data", description: [A methodology for performing the same operation on multiple pieces of data at the same time. With SIMD operations on a CPU data is usually stored in #emph[vectors] and entire vectors are processed at the same time via vector instructions. Often achieved with automatic vectorization or explicit use of SIMD instructions with compiler intrinsics or inline assembly]),
  "simt": (short: "SIMT", long: "single instruction, multiple thread", description: [A methodology for parallel computing where a set of identical instructions are dispatched to multiple threads to process the same data. This is how most GPUs are programmed at the lowest level (with CUDA for example). SIMT is akin to an advanced, predicated form of SIMD]),
  "spmd": (short: "SPMD", long: "single program, multiple data", description: [todo]),
  "ssa": (short: "SSA", long: "static single assignment", description: [A format for IRs where there are infinite registers, and each can be assigned to only once]),
  "risc": (short: "RISC", long: "reduced instruction set computer", description: [todo]),
  "cfg": (short: "CFG", long: "control-flow graph", description: [In compiler theory, the control-flow graph is a directed graph representing the possible paths of control flow through a program. Nodes of the graph are usually basic blocks]),
  "dce": (short: "DCE", long: "dead code elimination", description: [A compiler optimization that removes code that is never executed]),
  "rtl": (short: "RTL", long: "register transfer language", description: [A low-level intermediate representation used to symbolically represent machine instructions in a target-independent format]),
  "scev": (short: "SCEV", long: "scalar evolution", description: [A compiler analysis pass that determines how values change across iterations of a loop]),
)

#let glossary-entries = {
  let entries = ()
  let sort = 0
  for (key, entry) in glossary-data {
    entries.push((
      key: key,
      short: entry.name,
      description: entry.description,
      sort: sort,
    ))
    sort += 1
  }
  entries
}

#let acronym-entries = {
  let entries = ()
  let sort = 0
  for (key, entry) in acronym-data {
    entries.push((
      key: key,
      short: entry.short,
      long: entry.long,
      description: entry.description,
      sort: sort,
    ))
    sort += 1
  }
  entries
}

#let make-glossary = glossarium.make-glossary

#let register-glossaries() = {
  glossarium.register-glossary(acronym-entries + glossary-entries)
}

#let short-form(key) = if key in glossary-data {
  glossary-data.at(key).name
} else {
  acronym-data.at(key).short
}

// Preserve the manuscript's explicit choice of short, long, or expanded
// acronym forms while making every occurrence a linked glossary reference.
#let gls(key, ..args) = glossarium.gls(key, first: false, ..args)
#let Gls(key, ..args) = glossarium.Gls(key, first: false, ..args)
#let gls-upper(key) = glossarium.gls(key, first: false, display: upper(short-form(key)))
#let acr-short(key) = glossarium.gls(key, first: false)
#let acr-long(key) = glossarium.gls-long(key, link: true, update: true)
#let acr-full(key) = glossarium.gls(key, first: true)

// acr and gls entries i use a lot
#let ir = acr-short("ir")
#let ast = acr-short("ast")

#let print-glossaries() = {
  pagebreak()
  heading(level: 1, outlined: true)[Acronyms]
  glossarium.print-glossary(
    acronym-entries,
    show-all: true,
    deduplicate-back-references: true,
    shorthands: (),
  )

  pagebreak()
  heading(level: 1, outlined: true)[Glossary]
  glossarium.print-glossary(
    glossary-entries,
    show-all: true,
    deduplicate-back-references: true,
    shorthands: (),
  )
}
