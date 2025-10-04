job := "hoc"
default := "all"

all:
    latexmk -pdflatex=lualatex -pdf -jobname={{job}}

clean:
    latexmk -C
    rm *.bbl
