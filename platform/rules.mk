LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

# shared platform code
MODULE_SRCS += \
	$(LOCAL_DIR)/debug.c

include make/module.mk
