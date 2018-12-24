
include $(PACKAGES_DIR)/packages.mk

MK_INCLUDES += $(GOOGLETEST_HDL)/src/vl/googletest_hdl_vl.mk

TB_MODULES_HDL=fwuart_tx_tb_hdl

ifeq (vl,$(SIM))
DPI_OBJS_LIBS += libgoogletest-hdl-vl.o libgoogletest-hdl.o libgoogletest.o
endif


include $(PACKAGES_DIR)/simscripts/mkfiles/common_sim.mk

include $(PACKAGES_DIR)/packages.mk