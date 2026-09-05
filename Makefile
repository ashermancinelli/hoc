ROOT := $(CURDIR)
PYTHON := $(ROOT)/.venv/bin/python

.DEFAULT_GOAL := hoc.pdf
.DELETE_ON_ERROR:

# MAKEFLAGS += --silent
REVISION := $(shell git rev-parse HEAD)
REVISION_SHORT := $(shell bash -c "git rev-parse HEAD|cut -c 1-6")

TAG := $(shell date '+%a-%b-%d-%H-%M-%S-%Z-%Y')
PUB := $(shell ls publish/*.pdf|tail -1)
SRC := $(shell find . -name '*.typ')
TYPST_FLAGS := \
		--diagnostic-format short \
		--root . \
		--input revision=$(REVISION_SHORT)
LINK := https://cdn.jsdelivr.net/gh/ashermancinelli/hoc@$(REVISION)/$(PUB)

.PHONY: config gen watch open publish
config:
	@echo rev: $(REVISION) $(REVISION_SHORT)
	@echo tag: $(TAG)
	@echo typst sources: $(words $(SRC))
	@echo lateset published version: $(PUB)
	@echo link: $(LINK)

D := chapters/codesign/tracing
TRACING_EXAMPLES := $(wildcard $(D)/example*.py)
TRACING_OUTPUTS := $(patsubst %.py,%_output.txt,$(TRACING_EXAMPLES))
$(D)/%_output.txt: $(D)/%.py $(D)/dsl.py $(D)/__init__.py Makefile
	cd $(@D) && $(PYTHON) $(<F) > $(@F)

chapters/codesign/flang.png: chapters/codesign/flang.dot
	dot -Tpng -Gdpi=180 $< -o $@

gen: chapters/codesign/flang.png $(TRACING_OUTPUTS)

watch:
	watchexec -N -f Makefile -e mk,dot,typ,py,cls,txt -- make -j8 hoc.pdf

%.pdf: gen $(SRC) Makefile
	typst compile $(TYPST_FLAGS) main.typ $@

open: hoc.pdf
	open $<

publish/$(TAG).pdf: hoc.pdf
	@cp hoc.pdf publish/$(TAG).pdf

publish: config publish/$(TAG).pdf
