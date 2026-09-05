examples = $(wildcard example*.py)
outputs = $(patsubst %.py,%_output.txt,$(examples))
include common.mk

%_output.txt: %.py dsl.py Makefile __init__.py $(examples)
	cd $(D) && $(PYTHON) $*.py | tee $@

.DEFAULT_GOAL := gen
.PHONY: gen
gen: $(outputs)
	@:
