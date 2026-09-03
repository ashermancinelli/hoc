#let highlight-links(body) = {
  // Typst keeps links visually neutral by default. Make URLs, citations, and
  // internal cross-references visibly interactive in both print and PDF views.
  show link: set text(fill: rgb("245b8a"))
  show link: underline
  show ref: set text(fill: rgb("245b8a"))
  show cite: set text(fill: rgb("245b8a"))
  show figure.caption: set text(size: 10pt)
  body
}
