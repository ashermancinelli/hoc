default := "build"

revision := `git rev-parse HEAD`
revision_short := `git rev-parse HEAD|cut -c 6`
flang_dot := "chapters/codesign/flang.dot"
flang_diagram := "chapters/codesign/flang.png"
tag := `date 2>&1 | perl -ne 'chomp; s#([[:space:]]|:)#-#g; print; print "\n"'`
latest_publish := `ls publish/*.pdf|tail -1`

mod chapters './chapters/justfile'

link:
    @printf "https://cdn.jsdelivr.net/gh/ashermancinelli/hoc@{{revision}}/publish/{{latest_publish}}\n"

build output="hoc.pdf": gen
    typst compile --root . --input revision={{ revision_short }} main.typ {{output}}

watch: gen
    watchexec -e typ,py,cls,txt -- bash -c 'just gen && just build'

gen: flang-diagram chapters::gen

flang-diagram:
    @if ! command -v dot >/dev/null 2>&1; then echo "error: Graphviz 'dot' is required (macOS: brew install graphviz)" >&2; exit 127; fi
    @if [ ! -f "{{ flang_diagram }}" ] || [ "{{ flang_dot }}" -nt "{{ flang_diagram }}" ]; then \
      echo "Rendering {{ flang_diagram }}"; \
      dot -Tpng -Gdpi=180 "{{ flang_dot }}" -o "{{ flang_diagram }}"; \
    fi

publish:
    just build "publish/{{tag}}.pdf"

open: build
    open hoc.pdf

clean:
    rm -f hoc.pdf "{{ flang_diagram }}"
