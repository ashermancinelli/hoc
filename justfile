default := "all"

all:
    latexmk -pdflatex=lualatex -pdf

clean:
    latexmk -C
    rm *.bbl *-SAVE-ERROR || true

cleanfirst: clean all
