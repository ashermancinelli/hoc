CE := $(ROOT)/tools/compiler_explorer.py
CE_CACHE := $(ROOT)/build/compiler-explorer
CXX_COMPILERS := $(CE_CACHE)/c++.json
CE_CXX := g153

$(CXX_COMPILERS): $(CE)
	$(PYTHON) $(CE) compilers c++ $@

$(CE_CACHE)/example.s: example.cpp $(CE) $(CXX_COMPILERS)
	$(PYTHON) $(CE) compile \
		--arguments=-O2 \
		--format asm \
		$(CE_CXX) $< $@
