examples = example0 example1 example2 example3
example_scripts = $(addsuffix .py,$(examples))
outputs = $(addsuffix _output.txt,$(examples))
include common.mk
cwd = $(shell pwd)

%_output.txt: %.py example_dsl.py Makefile __init__.py $(example_scripts)
	$(PYTHON) $*.py | tee $@

.DEFAULT_GOAL := gen
.PHONY: gen
gen: $(outputs)
	@:
