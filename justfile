default := "quick"
job := "hoc"
latex := "lualatex --shell-escape --jobname=" + job + " main.tex"
publish-name := "History of Compilers"
publish-pdf := publish-name + ".pdf"

default: quick

biber-clear-cache:
    rm -rf `biber --cache`

full:
    {{latex}}
    biber {{job}}
    makeglossaries {{job}}
    {{latex}}
    {{latex}}

quick:
    {{latex}}

q: quick

clean:
    latexmk -C
    rm *.bbl *.upa *.upb *-SAVE-ERROR || true

cleanfirst: clean full

publish: cleanfirst
    cp "{{job}}.pdf" "publish/{{publish-pdf}}"
    git add "publish/{{publish-pdf}}"
    git commit -m publish

pub: publish

open:
    killall Preview||:
    open "{{job}}.pdf"

o: open

qo: q o
fo: full open
