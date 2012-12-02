/*
Copyright (C) 2012  Eren Türkay

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

#ifndef __INTERRUPT_H
#define __INTERRUPT_H

#include "types.h"
#include "uart.h"

#define RAM_VECTOR_BASE 0x4020FFE4;

struct Vector_table {
    uint undefined;
    uint swi;
    uint prefetch_abort;
    uint data_abort;
    uint unused;
    uint irq;
    uint fiq;
};

void write_vector_table(void);
void handle_interrupt(void);

#endif /* __INTERRUPT_H */
