LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

# GLOBAL_INCLUDES += \
	# $(LOCAL_DIR)/include

MODULE_SRCS += \
	$(LOCAL_DIR)/print.c \
	$(LOCAL_DIR)/debug.c \

include make/module.mk
