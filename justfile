default := "build"

revision := `git -C ../hoc rev-parse --short HEAD 2>/dev/null || echo working-tree`
flang_dot := "chapters/codesign/flang.dot"
flang_diagram := "chapters/codesign/flang.png"

build: diagrams
    typst compile --root . --input revision={{ revision }} main.typ hoc.pdf

watch: diagrams
    typst watch --root . --input revision={{ revision }} main.typ hoc.pdf

diagrams: flang-diagram

flang-diagram:
    @if ! command -v dot >/dev/null 2>&1; then echo "error: Graphviz 'dot' is required (macOS: brew install graphviz)" >&2; exit 127; fi
    @if [ ! -f "{{ flang_diagram }}" ] || [ "{{ flang_dot }}" -nt "{{ flang_diagram }}" ]; then \
      echo "Rendering {{ flang_diagram }}"; \
      dot -Tpng -Gdpi=180 "{{ flang_dot }}" -o "{{ flang_diagram }}"; \
    fi

publish: build
    cp "hoc.pdf" "publish/hoc.pdf"

open: build
    open hoc.pdf

clean:
    rm -f hoc.pdf "{{ flang_diagram }}"
