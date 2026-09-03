#let book(body) = {
  set page(
    paper: "us-letter",
    margin: 0.9in,
    numbering: "1",
    number-align: center,
  )
  set text(font: "Libertinus Serif", size: 12pt, lang: "en")
  set par(justify: true, leading: 0.7em)
  set heading(numbering: "1.1.1.1.1")
  set quote(block: true)
  // Typst keeps links visually neutral by default. Make URLs, citations, and
  // internal cross-references visibly interactive in both print and PDF views.
  show link: set text(fill: rgb("245b8a"))
  show link: underline
  show ref: set text(fill: rgb("245b8a"))
  show cite: set text(fill: rgb("245b8a"))
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    block(above: 0pt, below: 1.5em, inset: 0.7em, stroke: 0.8pt)[
      #align(center, text(size: 22pt, weight: "bold", it.body))
    ]
  }
  show figure.caption: set text(size: 10pt)
  body
}
