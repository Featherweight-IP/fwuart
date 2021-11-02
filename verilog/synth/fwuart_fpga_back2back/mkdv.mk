MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
SYNTH_DIR:=$(dir $(MKDV_MK))
MKDV_TOOL ?= quartus

QUARTUS_FAMILY ?= "MAX 10"
QUARTUS_DEVICE ?= 10M50DAF484C6GES

TOP_MODULE = fwuart_fpga_back2back
MKDV_VL_SRCS += $(SYNTH_DIR)/fwuart_fpga_back2back.v

SDC_FILE=$(SYNTH_DIR)/$(TOP_MODULE).sdc
BRD_FILE=$(SYNTH_DIR)/board_config_deca.tcl


include $(SYNTH_DIR)/../common/defs_rules.mk
RULES := 1
include $(SYNTH_DIR)/../common/defs_rules.mk

