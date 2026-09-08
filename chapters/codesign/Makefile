codesign := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

FLANG_DOT := $(codesign)flang.dot
FLANG_DIAGRAM := $(codesign)flang.png

$(FLANG_DIAGRAM): $(FLANG_DOT) $(codesign)Makefile
	dot -Tpng -Gdpi=180 $< -o $@

.PHONY: codesign-gen
codesign-gen: $(FLANG_DIAGRAM) tracing-gen llvm-gen

include $(codesign)tracing/Makefile
include $(codesign)llvm/Makefile
