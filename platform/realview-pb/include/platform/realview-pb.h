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

#ifndef PLATFORM_H
#define PLATFORM_H

/* 
 * These memory addresses are documented in the following manuals:
 *      - PrimeCell UART (PL011) Technical Reference Manual
 *      - RealView Cortex-A8 User Guide
 * 
 * Please refer to these documents for further information
 *
 */

/* hardware base registers */
#define UART0 (0x10009000)

/* offsets */
#define UART0_DR 0x0     // data register
#define UART0_FR 0x18    // flag register

/* uart flags */
#define UART0_RX_FIFO_EMPTY (1<<4)
#define UART0_CLEAR_TO_SEND (1<<0)

/*
 * Generic Interrupt Controller registers
 */

#define GIC0  (0x1e000000)

/* Main CPU registers */
#define CONTROL  (0x00)
#define PRIMASK  (0x04)
#define BINPOINT (0x08)
#define INTACK   (0x0c)
#define EOI      (0x10)
#define RUNNING  (0x14)
#define HIGHPEND (0x18)

/*
 * Distribution registers
 *
 * Registers apart from DISTCONTROL are offsets. They are prefixed with
 * distcontrol to be easily accessed with GICREG macro defined in interrupt.c.
 *
 */
#define DISTCONTROL (0x1000)
#define SETENABLE0  (0x1100)
#define SETENABLE1  (0x1104)
#define SETENABLE2  (0x1108)
#define CLRENABLE0  (0x1180)
#define CLRENABLE1  (0x1184)
#define CLRENABLE2  (0x1188)
#define SETPEND0    (0x1200)
#define SETPEND1    (0x1204)
#define SETPEND2    (0x1208)
#define CLRPEND0    (0x1280)
#define CLRPEND1    (0x1284)
#define CLRPEND2    (0x1288)
#define ACTIVE0     (0x1300)
#define ACTIVE1     (0x1304)
#define ACTIVE2     (0x1308)

/* Interrupt numbers */
#define TIMER01_INT 36


#endif /* PLATFORM_H */
