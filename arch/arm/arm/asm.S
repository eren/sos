/*
 * Copyright (c) 2008 Travis Geiselbrecht
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <asm.h>

FUNCTION(arm_save_mode_regs)
	mrs		r1, cpsr

	bic		r2, r1, #0x1f	/* clear the mode bits */

	orr     r3, r2, #0x11	/* fiq */
	msr     cpsr_c, r3
	str		r13, [r0], #4
	str		r14, [r0], #4

	orr     r3, r2, #0x12	/* irq */
	msr     cpsr_c, r3
	str		r13, [r0], #4
	str		r14, [r0], #4

	orr     r3, r2, #0x13	/* svc */
	msr     cpsr_c, r3
	str		r13, [r0], #4
	str		r14, [r0], #4

	orr     r3, r2, #0x17	/* abt */
	msr     cpsr_c, r3
	str		r13, [r0], #4
	str		r14, [r0], #4

	orr     r3, r2, #0x1b	/* und */
	msr     cpsr_c, r3
	str		r13, [r0], #4
	str		r14, [r0], #4

	orr     r3, r2, #0x1f	/* sys */
	msr     cpsr_c, r3
	str		r13, [r0], #4
	str		r14, [r0], #4

	msr		cpsr_c, r1

	bx		lr
