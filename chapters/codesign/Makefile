D := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

FLANG_DOT := $(D)flang.dot
FLANG_DIAGRAM := $(D)flang.png

$(FLANG_DIAGRAM): $(FLANG_DOT) $(D)Makefile
	dot -Tpng -Gdpi=180 $< -o $@

.PHONY: codesign-gen
codesign-gen: $(FLANG_DIAGRAM) tracing-gen

include $(D)tracing/Makefile
