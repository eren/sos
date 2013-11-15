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

#include <register.h>
#include <sys/types.h>
#include <platform/realview-pb.h>

#define UARTREG(reg) (*REG32(UART0 + (reg)))

void platform_dputc(char c)
{
    UARTREG(UART0_DR) = c & 0xff;
}

void platform_dgetc(char *c)
{
    while (UARTREG(UART0_FR) & UART0_RX_FIFO_EMPTY)
        ;

    *c = UARTREG(UART0_DR) & 0xff;
}
