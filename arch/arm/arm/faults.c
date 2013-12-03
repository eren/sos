/*
 * Copyright (C) 2013  Eren Türkay <turkay.eren@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#include <arch/arm.h>
#include <debug.h>

static void exception_die(struct arm_fault_frame *frame, int pc_offset,
                   const char *msg)
{
    dprintf(CRITICAL, msg);

    dprintf(CRITICAL, "Previous mode was: 0x%02x",
            (frame->spsr & MODE_MASK));

    // TODO: call arm_save_mode_regs and print saved mode registers
    // TODO: dump the stack frame, it would be good for debugging.
    
    // TODO: add platform dependant halt() function.
    for (;;);
}

/*
 * exception handler routines. PC offsets are defiend in ARM ARM. To get
 * the real value for PC, we need to subtract it.
 */
void arm_syscall_handler(struct arm_fault_frame *frame)
{
	exception_die(frame, -4, "unhandled syscall, halting\n");
}

void arm_undefined_handler(struct arm_fault_frame *frame)
{
	exception_die(frame, -4, "undefined abort, halting\n");
}

void arm_data_abort_handler(struct arm_fault_frame *frame)
{
	exception_die(frame, -8, "data abort, halting\n");
}

void arm_prefetch_abort_handler(struct arm_fault_frame *frame)
{
	exception_die(frame, -4, "prefetch abort, halting\n");
}
