LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

MODULE_DEPS := \
	platform \
	target \

MODULE_SRCS := \
	$(LOCAL_DIR)/main.c \

include make/module.mk
