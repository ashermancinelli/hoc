default := "all"

all:
    latexmk -pdflatex=lualatex -pdf

clean:
    latexmk -C
    rm *.bbl *.upa *.upb *-SAVE-ERROR || true

cleanfirst: clean all
