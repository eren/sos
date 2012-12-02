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

#include "interrupt.h"

void write_vector_table(void)
{
    volatile static struct Vector_table *vtable = (struct Vector_table *) RAM_VECTOR_BASE;

    vtable->undefined       = (uint)&handle_interrupt;
    vtable->swi             = (uint)&handle_interrupt;
    vtable->prefetch_abort  = (uint)&handle_interrupt;
    vtable->data_abort      = (uint)&handle_interrupt;
    vtable->unused          = (uint)&handle_interrupt;
    vtable->irq             = (uint)&handle_interrupt;
    vtable->fiq             = (uint)&handle_interrupt;
    
}

void handle_interrupt(void)
{
    uart3_print("Some intterupt happened!\n\n\r");

}
