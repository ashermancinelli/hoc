CE_MK := $(abspath $(lastword $(MAKEFILE_LIST)))
CE := $(ROOT)/tools/compiler_explorer.py
CE_CACHE := $(ROOT)/build/compiler-explorer
CXX_COMPILERS := $(CE_CACHE)/c++.json
CE_CXX ?= g153
CE_LLVM ?= llvm:2210

$(CXX_COMPILERS): $(CE)
	$(PYTHON) $(CE) compilers c++ $@
