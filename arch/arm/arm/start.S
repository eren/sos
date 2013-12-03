/*
Copyright (C) 2013  Eren Türkay

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

/* We need to be in ARM mode - we may branch to Thumb mode later if desired. */
.arm

.section ".text.boot"
.global _start
/*
 * We define vector table here. arm_* functions are defined in
 * exceptions.S file. These functions save the registers into the stack
 * and jump to the high-level C code.
 */
_start:
	b	reset
    b	arm_undefined
    b	arm_syscall
    b	arm_prefetch_abort
    b	arm_data_abort
    b	arm_reserved
    b	arm_irq
    b	arm_fiq

reset:
    /*
     * read System Control Register (SCTRL) into r0 for further
     * changing the attributes
     */
	mrc		p15, 0, r0, c1, c0, 0
    
    /*
     * set bit 15, 13, 12, 2, and 0 to 0.
     *
     * 15: RAZ/SBZP disabled
     * 13: V, Normal exception vectors, base address 0x0
     * 12: I, Instruction cache disabled
     * 2:  C, Data and unified caches disabled
     * 0:  M, MMU disabled
     */
	bic		r0, r0, #(1<<15 | 1<<13 | 1<<12)
	bic		r0, r0, #(1<<2 | 1<<0)

    /* Alignment fault checking enabled */
	orr		r0, r0, #(1<<1)

    /* Write back to System Control register */
	mcr		p15, 0, r0, c1, c0, 0

.Lstack_setup:
    /*
     * SP is a banked register in each ARM mode. We need to have a correct
     * stack pointer for each mode. Progressively change the execution mode
     * and set a stack pointer for each of them.
     */

	mrs     r0, cpsr
    /*
     * clear the execution mode field in Current Program Status Register.
     * it will be base for jumping into other modes
     */
	bic     r0, r0, #0x1f

	ldr		r2, =abort_stack_top
	orr     r1, r0, #0x12 // irq
	msr     cpsr_c, r1
    /* save a pointer to a temporary dumping spot used during irq delivery */
	/* ldr		r13, =irq_save_spot		 */
    ldr r13, =abort_stack_top

	orr     r1, r0, #0x11 // fiq
	msr     cpsr_c, r1
	mov		sp, r2
	            
	orr     r1, r0, #0x17 // abort
	msr     cpsr_c, r1
	mov		sp, r2
	    
	orr     r1, r0, #0x1b // undefined
	msr     cpsr_c, r1
	mov		sp, r2
	    
	orr     r1, r0, #0x1f // system
	msr     cpsr_c, r1
	mov		sp, r2

	orr		r1, r0, #0x13 // supervisor
	msr		cpsr_c, r1
	mov		sp, r2

    /* Clear out the bss section. Fill it with zeros */
	ldr		r0, =__bss_start
	ldr		r1, =__bss_end
	mov		r2, #0
.L__bss_loop:
	cmp		r0, r1
	strlt	r2, [r0], #4
	blt		.L__bss_loop

    /*
     * used for testing interrupt handler routines. generates unhandled
     * syscall.
     * svc #0x000000
     */

    bl kernel_main
    /* YOU SHALL NOT PASS!! \o/\o/ */
    b .

.ltorg

.bss
.align 4
/* used for unrecoverable errors */
LOCAL_DATA(abort_stack)
	.skip 4096
LOCAL_DATA(abort_stack_top)

.data
.align 2
