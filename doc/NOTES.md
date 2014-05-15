ARM Versions and Architectures
===============================

    2013-04-25 11:21:09 geist   there are ARM<N> cores, and archiecture
    versions ARMv<N>
    2014-04-17 11:10:38     geist   ARM7 == armv4
    2014-04-17 11:10:47     geist   arm9 == armv4,armv5 (depending on the core)
    2014-04-17 11:10:51     geist   arm11 == armv6
    2014-04-17 11:11:04     geist   cortex-a* == armv7
    2014-04-17 11:11:11     geist   cortex-a5* == armv8

Registers
=========
In Application Programmer interface, r0-r13 are general purpose.

    r14 - Link register (used in branching, bl and blx instructions)
    r13 - Stack Pointer
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

IRQ and Timers
==============
IRQs will be used frequently overall the system, for example for disk
i/o or network. So it is better to implement it first when we have
vector tables working. In Realview-PB, Generic Interrupt Control (GIC)
need to be learned.

Timers are the best way to trigger an IRQ and test the code. So, working
with timer and IRQ code would be the most effective way. However, timers
are not solely for context switching (timers != context switching).

    2014-04-17 10:53:09     geist   virtually every newbie makes the mistake of timer == context switch
    2014-04-17 10:53:21     geist   remove that idea from your head. they are separate concepts, sometimes used together
    2014-04-17 10:53:25     geist   but not always (mostly not)
    2014-04-17 10:53:28     eren    okkie
    2014-04-17 10:53:47     geist   ie, a timer is just *one* of many ways you can trigger a context switch, but actually pretty rare
    2014-04-17 10:54:00     geist   most context switches are voluntary, or preemption from a piece of hardware (other than the timer)
    2014-04-17 10:54:48     geist   so, you'll want to be able to handle irqs. you'll need that code no matter what. may as well do it now
    2014-04-17 10:54:51     geist   timer is a nice way to do it
    2014-04-17 10:55:45     eren    right, like interrupts for disk i/o? "hey CPU, your data is ready at that address, maybe kernel should return to the app that requested this file"
    2014-04-17 10:55:55     geist   bingo
    2014-04-17 10:56:16     geist   a timer preemption timer is just a mechanism to guarantee that a single thread that doesn't yield (block on something, etc) doesn't hog the cpu
    2014-04-17 10:56:35     geist   it's more of a safety thing. you schedule a thread, set a timer for some point in the future that puts it back int he queue and lets another get a try
    2014-04-17 10:56:52     geist   but most of the time it blocks or yields and the timer doesn't need to fire
    2014-04-17 10:58:38     eren    yeah I see it. IRQ is the core part for interacting with different subsystems like network or io. But I don't still get what you mean by "timer is a nice way to
    do it"
    2014-04-17 10:58:59     geist   well, what other irq do you want to use for testing purposes?
    2014-04-17 10:59:01     eren    is it because the timer will tick (not necessarily used to context switch), generate IRQ, then we will handle
    2014-04-17 10:59:04     geist   pick one. make it go
    2014-04-17 10:59:09     geist   yep
    2014-04-17 10:59:13     eren    oh great
    2014-04-17 10:59:19     eren    thank you!

About the history of GIC:

    2014-04-17 11:03:56     geist   the GIC came into real use with cortex-a9 and cortex-a15
    2014-04-17 11:04:14     geist   prior to that it was just an optional piece of RTL you could buy from arm, and most SoC vendors used their own
    2014-04-17 11:04:33     geist   but with real SMP with the a9+ the core itself defined a built in interrupt controller, to handle SMP
    2014-04-17 11:04:41     geist   and thus the GIC became essentially part of the core
    2014-04-17 11:04:55     eren    btw, I'm taking notes on important stuff. It would be useful for ARM newbies. Do you think we should put it on some wiki or include it with lk?
    2014-04-17 11:05:04     geist   very similar to the way x86-pc had an external PIC but then it eventually got pulled into the cpu as local apic and ioapic
    2014-04-17 11:05:20     geist   i guess

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
