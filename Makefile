root := $(CURDIR)
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --include-dir=$(root)/tools
include tools/common.mk

.DEFAULT_GOAL := hoc.pdf
# MAKEFLAGS += --silent
revision := $(shell git rev-parse HEAD)
revision_short := $(shell bash -c "git rev-parse HEAD|cut -c 6")
flang_dot := chapters/codesign/flang.dot
flang_diagram := chapters/codesign/flang.png
tag := $(shell date '+%a-%b-%d-%H-%M-%S-%Z-%Y')
latest_publish := $(shell ls publish/*.pdf|tail -1)
typ := $(shell find . -name '*.typ')
mk := $(shell find . -name Makefile)
typst_flags := \
		--diagnostic-format short \
		--root . \
		--input revision=$(revision_short)

link:
	@printf "https://cdn.jsdelivr.net/gh/ashermancinelli/hoc@$(revision)/$(latest_publish)\n"

.PHONY: gen
gen:
	@$(MAKE) -C chapters

watch:
	watchexec -N -f Makefile -e dot,typ,py,cls,txt -- make hoc.pdf

%.pdf: gen $(typ) $(mk)
	typst compile $(typst_flags) main.typ $@

open: hoc.pdf
	open $<

publish: publish/$(tag).pdf
