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

#endif /* PLATFORM_H */
