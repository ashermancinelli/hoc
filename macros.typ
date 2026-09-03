#let mono(body) = text(font: "DejaVu Sans Mono", size: 0.88em, body)
#let mono-text(body) = text(font: "DejaVu Sans Mono", size: 0.88em, body)
#let todo(body) = text(fill: red, font: "DejaVu Sans Mono", [TODO: #body])
#let unsupported(name, body) = text(fill: rgb("9c2f2f"), [#body])

#let code-file(path, lang: "text") = raw(read(path), block: true, lang: lang)

#let xref(target, capital: false) = ref(target)

// Typst's native citation forms cover author, year, prose, and parenthetical
// citations. A tiny CSL style supplies the title-only form used throughout the
// manuscript's source discussions and Quotes chapter.
#let cite-title(key) = cite(key, style: "styles/title-only.csl")
