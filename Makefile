D := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ROOT := $(patsubst %/,%,$(D))
VENV := $(ROOT)/.venv
PYTHON := $(VENV)/bin/python
SBCL := $(VENV)/bin/sbcl

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

$(VENV):
	uv venv --seed --clear .venv

$(PYTHON): $(VENV)

$(SBCL): $(VENV)
	@if ! command -V sbcl; then \
		echo Need to install sbcl first; \
	fi
	ln -sf `which sbcl` $(SBCL)

gen: chapters-gen

watch:
	watchexec -N -f Makefile -e lisp,mk,dot,typ,py,cls,txt -- make -j8 hoc.pdf

%.pdf: gen $(SRC) Makefile
	typst compile $(TYPST_FLAGS) main.typ $@

open: hoc.pdf
	open $<

publish/$(TAG).pdf: hoc.pdf
	cp hoc.pdf publish/$(TAG).pdf

publish/latest.pdf: publish/$(TAG).pdf
	cd publish && ln -sf $(TAG).pdf latest.pdf

publish: config publish/latest.pdf

include $(D)chapters/Makefile
