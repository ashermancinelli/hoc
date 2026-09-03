default := "build"

revision := `git -C ../hoc rev-parse --short HEAD 2>/dev/null || echo working-tree`

build:
    typst compile --root . --input revision={{revision}} main.typ hoc.pdf

watch:
    typst watch --root . --input revision={{revision}} main.typ hoc.pdf

publish: build
    cp "hoc.pdf" "publish/hoc.pdf"

open: build
    open hoc.pdf

clean:
    rm -f hoc.pdf

