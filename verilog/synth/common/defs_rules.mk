FWUART_VERILOG_SYNTH_COMMONDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
FWUART_DIR := $(abspath $(FWUART_VERILOG_SYNTH_COMMONDIR)/../../..)
PACKAGES_DIR := $(FWUART_DIR)/packages
DV_MK:=$(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)

ifneq (1,$(RULES))

MKDV_PYTHONPATH += $(FWUART_VERILOG_SYNTH_COMMONDIR)/python
include $(FWUART_DIR)/verilog/rtl/defs_rules.mk
include $(DV_MK)
else # Rules
include $(DV_MK)

endif
