LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

# can override this in local.mk
ENABLE_THUMB?=true

# default to the regular arm subarch
SUBARCH := arm

GLOBAL_DEFINES += \
	ARM_CPU_$(ARM_CPU)=1

# do set some options based on the cpu core
HANDLED_CORE := false

ifeq ($(ARM_CPU),cortex-a8)
GLOBAL_DEFINES += \
	ARM_WITH_CP15=1 \
	ARM_WITH_MMU=1 \
	ARM_ISA_ARMv7=1 \
	ARM_ISA_ARMv7A=1 \
	ARM_WITH_VFP=1 \
	ARM_WITH_NEON=1 \
	ARM_WITH_THUMB=1 \
	ARM_WITH_THUMB2=1 \
	ARM_WITH_CACHE=1 \
	ARM_WITH_L2=1
GLOBAL_COMPILEFLAGS += -mcpu=$(ARM_CPU)
HANDLED_CORE := true
#CFLAGS += -mfpu=neon -mfloat-abi=softfp
endif

ifneq ($(HANDLED_CORE),true)
$(error $(LOCAL_DIR)/rules.mk doesnt have logic for arm core $(ARM_CPU))
endif

THUMBCFLAGS :=
THUMBINTERWORK :=
ifeq ($(ENABLE_THUMB),true)
THUMBCFLAGS := -mthumb -D__thumb__
THUMBINTERWORK := -mthumb-interwork
endif

GLOBAL_INCLUDES += \
	$(LOCAL_DIR)/include \
	$(LOCAL_DIR)/$(SUBARCH)/include

ifeq ($(SUBARCH),arm)
MODULE_SRCS += \
	$(LOCAL_DIR)/arm/start.S \

#MODULE_ARM_OVERRIDE_SRCS := \
#	$(LOCAL_DIR)/arm/arch.c

GLOBAL_DEFINES += \
	ARCH_DEFAULT_STACK_SIZE=4096
endif

# try to find the toolchain
ifndef TOOLCHAIN_PREFIX
TOOLCHAIN_PREFIX := arm-eabi-
FOUNDTOOL=$(shell which $(TOOLCHAIN_PREFIX)gcc)
ifeq ($(FOUNDTOOL),)
TOOLCHAIN_PREFIX := arm-elf-
FOUNDTOOL=$(shell which $(TOOLCHAIN_PREFIX)gcc)
ifeq ($(FOUNDTOOL),)
TOOLCHAIN_PREFIX := arm-none-eabi-
FOUNDTOOL=$(shell which $(TOOLCHAIN_PREFIX)gcc)
ifeq ($(FOUNDTOOL),)
TOOLCHAIN_PREFIX := arm-linux-gnueabi-
FOUNDTOOL=$(shell which $(TOOLCHAIN_PREFIX)gcc)

# Set no stack protection if we found our gnueabi toolchain. We don't
# need it.
#
# Stack protection is default in this toolchain and we get such errors
# final linking stage:
#
# undefined reference to `__stack_chk_guard'
# undefined reference to `__stack_chk_fail'
# undefined reference to `__stack_chk_guard'
#
ifneq (,$(findstring arm-linux-gnueabi-,$(FOUNDTOOL)))
        GLOBAL_COMPILEFLAGS += -fno-stack-protector
endif

endif
endif
endif
ifeq ($(FOUNDTOOL),)
$(error cannot find toolchain, please set TOOLCHAIN_PREFIX or add it to your path)
endif
endif
$(info TOOLCHAIN_PREFIX = $(TOOLCHAIN_PREFIX))

GLOBAL_COMPILEFLAGS += $(THUMBINTERWORK)

# make sure some bits were set up
MEMVARS_SET := 0
ifneq ($(MEMBASE),)
MEMVARS_SET := 1
endif
ifneq ($(MEMSIZE),)
MEMVARS_SET := 1
endif
ifeq ($(MEMVARS_SET),0)
$(error missing MEMBASE or MEMSIZE variable, please set in target rules.mk)
endif

LIBGCC := $(shell $(TOOLCHAIN_PREFIX)gcc $(GLOBAL_COMPILEFLAGS) $(THUMBCFLAGS) -print-libgcc-file-name)
$(info LIBGCC = $(LIBGCC))

$(info GLOBAL_COMPILEFLAGS = $(GLOBAL_COMPILEFLAGS) $(THUMBCFLAGS))

# potentially generated files that should be cleaned out with clean make rule
GENERATED += \
	$(BUILDDIR)/system-onesegment.ld \

# rules for generating the linker scripts

$(BUILDDIR)/system-onesegment.ld: $(LOCAL_DIR)/system-onesegment.ld $(wildcard arch/*.ld)
	@echo generating $@
	@$(MKDIR)
	$(NOECHO)sed "s/%MEMBASE%/$(MEMBASE)/;s/%MEMSIZE%/$(MEMSIZE)/" < $< > $@

# arm specific script to try to guess stack usage
$(OUTELF).stack: LOCAL_DIR:=$(LOCAL_DIR)
$(OUTELF).stack: $(OUTELF).lst
	$(NOECHO)echo generating stack usage $@
	$(NOECHO)$(LOCAL_DIR)/stackusage < $< | sort -n -k 1 -r > $@

EXTRA_BUILDDEPS += $(OUTELF).stack

include make/module.mk
