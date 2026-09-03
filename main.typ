#import "prelude.typ": *
#import "macros.typ": *
#import "glossaries.typ": *

#show: book

#let revision = sys.inputs.at("revision", default: "working tree")

#align(center)[
  #v(18%)
  #text(size: 30pt, weight: "bold")[A Brief History of Compilers]
  #v(1.5em)
  #text(size: 16pt)[Asher Mancinelli]
  #v(1em)
  #datetime.today().display("[month repr:long] [day], [year]") \
  Revision: #revision
]

#pagebreak()
#outline(title: [Contents], depth: 5)
#pagebreak()

#include "chapters/preface.typ"
#include "chapters/read-instead.typ"
#include "chapters/intro.typ"
#include "chapters/dawn.typ"
#include "chapters/software.typ"
#include "chapters/freedom.typ"
#include "chapters/codesign.typ"
#include "chapters/quotes.typ"

#bibliography(
  "refs.bib",
  title: [Bibliography],
  style: "chicago-author-date",
  full: true,
)

#print-glossaries()

