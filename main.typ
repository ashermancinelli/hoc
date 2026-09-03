#import "prelude.typ": *
#import "macros.typ": *
#import "glossaries.typ": *
#import "@preview/retrofit:0.2.0": backrefs

#show: backrefs.with(
  format: links => text(fill: rgb("666666"), size: 0.85em)[
    (Cited on #if links.len() == 1 { [p.] } else { [pp.] }
    #links.join(", ", last: " and "))
  ],
  read: path => read(path),
)
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
  style: "chicago-author-date",
  full: true,
)

#print-glossaries()
