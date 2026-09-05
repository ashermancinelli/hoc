# $@   target name
# $%   target member name (for archive members)
# $<   first prerequisite
# $?   prerequisites newer than the target
# $^   all prerequisites, duplicates removed
# $+   all prerequisites, duplicates preserved
# $*   stem matched by a pattern rule
# $(@D)   directory part of $@
# $(@F)   filename part of $@
# $(<D)   directory part of $<
# $(<F)   filename part of $<
# $(^D)   directory parts of $^
# $(^F)   filename parts of $^
# $(@)    same as $@
# $(^)    same as $^

PYTHON := $(ROOT)/.venv/bin/python
penultimate = $(word $(shell expr $(words $(1)) - 1),$(1))
D := $(dir $(abspath $(call penultimate,$(MAKEFILE_LIST))))

%.png: %.dot
	dot -Tpng -Gdpi=180 $< -o $@
