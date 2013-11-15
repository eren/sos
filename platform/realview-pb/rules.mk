LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

ARCH := arm
ARM_CPU := cortex-a8

GLOBAL_INCLUDES += \
	$(LOCAL_DIR)/include

MODULE_SRCS += \
	$(LOCAL_DIR)/debug.c \

MEMBASE := 0x0
MEMSIZE := 0x10000000   # 256MB

GLOBAL_DEFINES += \
	MEMBASE=$(MEMBASE) \
	MEMSIZE=$(MEMSIZE) \

LINKER_SCRIPT += \
	$(BUILDDIR)/system-onesegment.ld

include make/module.mk
