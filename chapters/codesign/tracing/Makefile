D := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

TRACING_EXAMPLES := $(wildcard $(D)example*.py)
TRACING_OUTPUTS := $(patsubst %.py,%_output.txt,$(TRACING_EXAMPLES))

$(D)%_output.txt: $(D)%.py $(D)dsl.py $(D)__init__.py $(D)Makefile $(PYTHON)
	cd $(@D) && $(PYTHON) $(<F) > $(@F)

.PHONY: tracing-gen
tracing-gen: $(TRACING_OUTPUTS)
