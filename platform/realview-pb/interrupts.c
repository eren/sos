/*
 * Copyright (C) 2014  Eren Türkay <turkay.eren@gmail.com>
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

#ifndef __INTERRUPTS_C
#define __INTERRUPTS_C

#include <platform/realview-pb.h>  // GIC, TIMER interrupt definitions
#include <register.h>              // REG32 macro

#define GICREG(reg) (*REG32(GIC0 + (reg)))

void platform_init_interrupts(void)
{
	GICREG(CLRENABLE0) = 0xffffffff;
	GICREG(CLRENABLE1) = 0xffffffff;
	GICREG(CLRENABLE2) = 0xffffffff;
	GICREG(CLRPEND0) = 0xffffffff;
	GICREG(CLRPEND1) = 0xffffffff;
	GICREG(CLRPEND2) = 0xffffffff;
	GICREG(PRIMASK) = 0xf0;

	GICREG(CONTROL) = 1;      // enable GIC0 CPU Control register
	GICREG(DISTCONTROL) = 1;  // enable GIC0 distributor register
}

#endif /* __INTERRUPTS_C */
