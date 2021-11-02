MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR:=$(dir $(MKDV_MK))
MKDV_TOOL ?= icarus

MKDV_TIMEOUT ?= 100ms

MKDV_VL_SRCS += $(TEST_DIR)/fwuart_back2back_uart.sv
TOP_MODULE = fwuart_back2back_uart

MKDV_PLUGINS += cocotb pybfms
PYBFMS_MODULES += uart_bfms rv_bfms

MKDV_COCOTB_MODULE ?= fwuart_tests.test_back2back_uart

include $(TEST_DIR)/../../common/defs_rules.mk
RULES := 1
include $(TEST_DIR)/../../common/defs_rules.mk

