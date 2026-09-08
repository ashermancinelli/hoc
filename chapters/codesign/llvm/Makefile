D := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
LLVM_SRC := $(D)example0.cpp
LLVM_OUT := $(D)example0.ll

$(LLVM_OUT): $(LLVM_SRC) $(D)Makefile $(CE_MK) $(CE) $(CXX_COMPILERS)
	$(PYTHON) $(CE) compile \
		--language c++ \
		--library $(CE_LLVM) \
		--arguments='-O2 -std=c++17' \
		--format stdout \
		$(CE_CXX) $< $@

.PHONY: llvm-gen
llvm-gen: $(LLVM_OUT)
