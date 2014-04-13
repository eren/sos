ARM Versions and Architectures
===============================

    013-04-25 11:21:09 geist   there are ARM<N> cores, and archiecture
    versions ARMv<N>
    2013-04-25 11:21:17 geist   so, ARM7 == ARMv4
    2013-04-25 11:21:22 geist   ARM9 == ARMv5
    2013-04-25 11:21:26 geist   ARM11 == ARMv7

Registers
=========
In Application Programmer interface, r0-r13 are general purpose.

    r14 - Link register (used in branching, bl and blx instructions)
    r15 - Program counter

Saved Program Status Register:
------------------------------
In privileged modes, another register, the Saved Program Status Register
(SPSR), is accessible. This contains the condition code flags, status
bits, and current mode bits saved as a result of the exception that
caused entry to the current mode.

Returning from exception
========================
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0471c/Bgbcjggh.html

If the exception handler entry code uses the stack to store registers
that must be preserved while it handles the exception, it can return
using a load multiple instruction with the ^ qualifier. For example, an
exception handler can return in one instruction using:

    LDMFD sp!,{R0-R12,pc}^

To do this, the exception handler must save the following onto the
stack:
* all the work registers in use when the handler is invoked
* the link register, modified to produce the same effect as the data processing instructions.

The __^__ qualifier specifies that the __CPSR__ is restored from the __SPSR__. It
must be used only from a privileged mode.

Additional info for ^ from LDM/STM instruction page:
----------------------------------------------------
If op is LDM and reglist contains the pc (r15), in addition to the
normal multiple register transfer, the SPSR is copied into the CPSR.
This is for returning from exception handlers. Use this only from
exception modes.

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0068b/CIHCADDA.html

Gcc built-in defines
====================
For beagleboard, this command outputs built-in definitions

    echo | arm-linux-gnueabi-gcc -mcpu=cortex-a8 -mthumb-interwork -E -dM -
    cpp --std=c89 -dM < /dev/null

RealView-PB Emulation
=====================
RealView-PB is a generic ARM development board. If UART and Timer is needed, it
is easy to implement. LK has some code for it for stealing :)

    geist | look in platform/realview-pb and target/realview-pb
    geist | i run it with 'qemu-system-arm -machine realview-pb-a8 -kernel
    build-realview-pb-test/lk.elf -nographic

When working with QEMU, the VM state can be inspected with monitor. It would be
useful to see what's going on with registers, pc, current instruction, the
layout of memory when an exception occurs, etc.

http://wiki.qemu.org/download/qemu-doc.html#pcsys_005fmonitor

LK Build System
===============

    geist | start at project/<project>.mk.
    geist | it says what target there is
    geist | then target/<target>/rules.mk says what
    geist | and you'll start seeing MODULE_DEPS show
    geist | the build system then recurses and solves its own deps. each
    module's rules.mk file can say it depends on another module
    geist | and it'll recurse until all the deps are resolved
    geist | the trick also is that each module sets its own files to
    compile, its own CFLAGS, etc
    geist | via the MODULE_* vars, then includes build/module.mk
    geist | module.mk genreates all the build rules for that module, then
    clears the vars

Booting. arch/arm/arm/start.S
=============================
While trying to understand stack_setup, line 62:

    geist | sure. anyway, that's tricky. te oly trick you need to remember
    that isn't obvious is when you read pc it's always 2 instructions ahead
    geist | so the mov r0, pc should be reading the address of the .Laddr
    label, since it's 2 instrctions ahead

There are multiple stack pointers, one for every mode. In ARM technical
manual, this is written as "stack pointer(s) initialization". 

    geist | it switches to all of the cpu modes that have a banked register
    and puts what will become the interrupt stack in it

    geist | if it doesn't make sense, i highly recommend reading the arm
    arch manual on the topic
    geist | get super familiar with the way the arm modes work
    geist | and how the register banking works. it's overly
    complicated, one of the leftover previously-useful things from the
    early days of arm
    geist | basically lk undoes the multiple mode thing and just switches
    the cpu into SVC mode always, so that it looks like a more sane two mode
    system (user and supervisor)
    geist | armv6 and above have some helper instructions to make that
    easier
    geist | srs, cps, and rfe
    geist | since that's what everyone does anyway
    geist | armv8 removes all that nonsense and goes to a 2 mode system
    geist | as does armv7m

Programming
===========

Get the address in the kernel code
----------------------------------
Getting the address in the kernel code. Set markers in the linker script
and use these symbols as follows:

    mrvn | extern char _end; void *end = (void*)&_end;
    sortiecat | extern int /* the type doesn't matter! */ _end;
    uintptr_t kernel_end = (uintptr_t) &_end;

Creating Illegal Instruction
----------------------------
Create illegal instruction to test interrupt handlers.

    char illegal_inst[] = "\xff\xff\xff\xff";
    ((void (*)()) illegal_inst)();

Useful links
============
ARM Instruction reference:
http://infocenter.arm.com/help/topic/com.arm.doc.dui0068b/CIHEDHIF.html
