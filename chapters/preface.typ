#import "../macros.typ": *
#import "../glossaries.typ": *


= Preface

// The history of compilers is rich and deeply connected to the broader history of
// computing, however, I believe that no comprehensive work has tied together the
// threads of this history with a specific focus on compilers.
The history of compilers is rich.
Unfortunately, I have not found a comprehensive work on the history of computing
with a specific focus on compilers.
It has only been told in a patchwork of isolated stories, but never told its own rite.

For example, there are wonderful
retellings of the very first compilers on Konrad Zuse's Z4 computer at the ETH
Zurichand and Grace Hopper's pioneering work on the A-series compilers for the
UNIVAC I, and John Backus' work on the first commercial compiler for #mono[FORTRAN]
at IBM, but these are often isolated stories. When they are woven together, they
are often not connected to the #emph[next]
developments in compiler technology at Bell Labs: Aho and Ullman's
#emph[Principles of Compiler Design], the development of Lex and Yacc, the C
programming language, Bjarne Stroustrup's first C++ compiler #mono-text("cfront")
(inspired by Alan Kay's vision of object-oriented programming). The subsequent
decades of open-source compiler development, advances in optimization
techniques, and the explosion of new programming languages and compilation
paradigms (e.g. just-in-time compilation) are then followed by the rise and
necessity of hardware-software codesign and domain-specific languages seen most
evidently in projects based on MLIR and LLVM. The threads between these points
in history offer a deeper understanding of each individual piece and context
that motivates modern compiler development.

There have been several
monumental works on the history of computing and a few on the history of
programming languages, but in the decades since the turn of the
century there have been monumental developments in compiler technology that no
comprehensive work has covered thus far.
This book aims to fill that gap to a
small degree; it is not exhaustive, but contextualizes many of the most
important recent developments in the larger narrative of compiler history.
// The introduction chapter contains a brief version of the entire book; the
// reader is encouraged to read it first. This work intends to weave these threads
// together.

Compiler technology builds on the work of generations
of computer scientists, engineers, mathematicians and philosophers;
while prior works have primarily focused
on individuals or companies or have covered computer history more generally, this
book follows the individuals as they develop compiler technology, and follows it
to the next generation, from the genesis of the first compilers to the present
day. My hope is that each chapter stands on its own, but that reading them in
order will give a more complete picture. The reader ought to be able to read a
particular chapter that suits their needs at the time.
// This book does not assume
// the reader is deeply familiar with compiler engineering or computer science.
// The book is structured as a chronological narrative of the history of
// compilers, intending to keep the focus on compiler technologies and the people
// behind them without focusing on any particular company or product.


== A Note on Structure


Consider two ways to organize this document.
Firstly, imagine I pick a topic and narrate its history from start to finish.
Alternatively, we could consider individual time periods, examining
developments in compiler technology in relation to their contemporaries.
I chose the latter format so the connections between the compiler efforts are clearer.

There are trade-offs to both approaches.
Each chapter represents an era compiler development.
When one compiler, language, or engineer cannot be fully considered in one
chapter, I attempt to extend the narrative outside the chapter's claimed time
period or link the content to other relevant sections.
I prioritized continuity and interesting interactions between narratives.

// into the time periods I've grouped the chapters and sections into.
// In these instances, I either extend the narrative outside the
// defined time period to preserve continuity, or attempt to cross-reference
// the content sufficiently such that readers that would rather continue
// with the particular history instead of continuing to the next topic
// are able to do so.
// In all cases, preserving continuity and the interactions between histories
// is prioritized.
