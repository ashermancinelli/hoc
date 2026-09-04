#let mono(body) = text(font: "DejaVu Sans Mono", size: 0.88em, body)
#let mono-text(body) = text(font: "DejaVu Sans Mono", size: 0.88em, body)
#let todo(body) = text(fill: red, font: "DejaVu Sans Mono", [TODO: #body])
#let unsupported(name, body) = text(fill: rgb("9c2f2f"), [#body])

#let code-file(source-path, lang: "text", region: none) = {
  let source = read(source-path)

  if region != none {
    let lines = source.split("\n")
    let start-marker = "START_" + str(region)
    let end-marker = "END_" + str(region)
    let start = lines.position(line => line.contains(start-marker))
    let end = lines.position(line => line.contains(end-marker))

    assert(start != none, message: "code region " + str(region) + " has no start marker")
    assert(end != none, message: "code region " + str(region) + " has no end marker")
    assert(end > start, message: "code region " + str(region) + " ends before it starts")

    source = lines.slice(start + 1, end).join("\n")
  }

  raw(source, block: true, lang: lang)
}

#let xref(target, capital: false) = ref(target)

// Typst's native citation forms cover author, year, prose, and parenthetical
// citations. A tiny CSL style supplies the title-only form used throughout the
// manuscript's source discussions and Quotes chapter.
#let cite-title(key) = cite(key, style: "styles/title-only.csl")
#let citen(key) = cite(key, form: "normal")
