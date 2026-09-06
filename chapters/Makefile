D := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: chapters-gen
chapters-gen: codesign-gen

include $(D)codesign/Makefile
