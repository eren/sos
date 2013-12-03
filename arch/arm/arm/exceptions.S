/*
Copyright (C) 2013  Eren Türkay <turkay.eren@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.
 */

#include <asm.h>

.macro save, offset
    /*
	 * save spsr and r14 onto the svc stack
     *
     * offset is subtracted from lr because of the fact that (PC +
     * exception-dependent offset) is saved in the link register. To get the
     * real PC value, we need to subtract. Please see B1.6.3 Exception
     * Entry in ARM ARM DBI0406B_10_10.
     */
	sub		lr, #\offset
	srsdb	#0x13!

	/* switch to svc mode, interrupts disabled */
	cpsid	i,#0x13

	/* save callee trashed regs and lr */
	push	{ r0-r3, r12, lr }

	/* save user space sp/lr */
	sub		sp, #8
	stmia	sp, { r13, r14 }^
.endm

.macro restore
	/* restore user space sp/lr */
	ldmia	sp, { r13, r14 }^
	add		sp, #8

	pop		{ r0-r3, r12, lr }

	/* return to whence we came from */
	rfeia	sp!
.endm

FUNCTION(arm_undefined)
    /*
     * store multiple in full decreasing stack. Lower numbered registers
     * are put in the lower part of the memory. So, from low to high, the
     * register order is: r0...r13, r14. SP points to r14.
     */
	stmfd 	sp!, { r0-r12, r14 }

    /* subtract 3 bytes from sp, now sp points to an empty location. */
	sub		sp, sp, #12
	mov		r0, sp

    /* move to register from system, read spsr */
	mrs		r1, spsr

    /*
     * store multiple increment after. we had 3 extra bytes, which sp
     * points to an empty location in lower address. Now, we are filling
     * these locations with stmia. Be aware that SP is not updated. We are
     * in supervisor mode, so ^ character is used in order to get register
     * information from user mode.  At the end of this sequence, the
     * ordering of the registers are as follows.  This is an
     * arm_fault_frame defined in arm.h:
     * 
     * <lower address>
     * r1 // spsr
     * r13 // user link register
     * r14 // user stack po
     * r0
     * ..
     * ..
     * r12
     * r14
     */
	stmia	r0, { r1, r13-r14 }^
	b		arm_undefined_handler
	b		.

FUNCTION(arm_syscall)
	stmfd 	sp!, { r0-r12, r14 }
	sub		sp, sp, #12
	mov		r0, sp
	mrs		r1, spsr
	stmia	r0, { r1, r13-r14 }^
	b		arm_syscall_handler
	b		.

FUNCTION(arm_prefetch_abort)
	stmfd 	sp!, { r0-r12, r14 }
	sub		sp, sp, #12
	mov		r0, sp
	mrs		r1, spsr
	stmia	r0, { r1, r13-r14 }^
	b		arm_prefetch_abort_handler
	b		.

FUNCTION(arm_data_abort)
	stmfd 	sp!, { r0-r12, r14 }
	sub		sp, sp, #12
	mov		r0, sp
	mrs		r1, spsr
	stmia	r0, { r1, r13-r14 }^
	b		arm_data_abort_handler
	b		.

FUNCTION(arm_reserved)
	b	.

FUNCTION(arm_irq)
    /*
     * not implemented yet
     * TODO: implement arm_irq
     */
    b .

.text
FUNCTION(arm_fiq)
    /*
     * not implemented yet
     * TODO: implement arm_fiq
     */
    b .

.bss
.align 2
DATA(irq_save_spot)
	.word	0	/* r4 */
	.word	0	/* r5 */
	.word	0	/* r6 */

.ltorg
