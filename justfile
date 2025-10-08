default := "all"
job := "hoc"
latex := "lualatex --shell-escape --jobname=" + job + " main.tex"

default: all

biber-clear-cache:
    rm -rf `biber --cache`

all:
    {{latex}}
    biber {{job}}
    {{latex}}
    {{latex}}

clean:
    latexmk -C
    rm *.bbl *.upa *.upb *-SAVE-ERROR || true

cleanfirst: clean all
