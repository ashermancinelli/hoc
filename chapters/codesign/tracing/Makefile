D := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

TRACING_EXAMPLES := $(wildcard $(D)example*.py)
TRACING_OUTPUTS := $(patsubst %.py,%_output.txt,$(TRACING_EXAMPLES))
LISP_TRACING_EX := $(wildcard $(D)example*.lisp)
LISP_TRACING_OUT := $(patsubst %.lisp,%_output.txt,$(LISP_TRACING_EX))

$(D)%_output.txt: $(D)%.py $(D)dsl.py $(D)__init__.py $(D)Makefile $(PYTHON)
	cd $(@D) && $(PYTHON) $(<F) > $(@F)

$(D)%_output.txt: $(D)%.lisp $(D)Makefile $(SBCL)
	cd $(@D) && $(SBCL) --script $(<F) > $(@F)

.PHONY: tracing-gen
tracing-gen: $(TRACING_OUTPUTS) $(LISP_TRACING_OUT)
