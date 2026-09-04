examples = example0 example1 example2 example3
outputs = $(addsuffix _output.txt,$(examples))
python = ../../../.venv/bin/python
cwd = $(shell pwd)

%_output.txt: %.py example_dsl.py Makefile __init__.py
	cd $(cwd) && $(python) $*.py 2>&1 | tee $@ || :

.PHONY: gen
gen: $(outputs)
	@:
