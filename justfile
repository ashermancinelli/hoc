default := "all"
job := "hoc"
latex := "lualatex --shell-escape --jobname=" + job + " main.tex"
publish-name := "History of Compilers"
publish-pdf := publish-name + ".pdf"

default: all

biber-clear-cache:
    rm -rf `biber --cache`

all:
    {{latex}}
    biber {{job}}
    {{latex}}
    {{latex}}

quick:
    {{latex}}

q: quick

clean:
    latexmk -C
    rm *.bbl *.upa *.upb *-SAVE-ERROR || true

cleanfirst: clean all

publish: cleanfirst
    cp "{{job}}.pdf" "publish/{{publish-pdf}}"
    git add "publish/{{publish-pdf}}"
    git commit -m publish

pub: publish
