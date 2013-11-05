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

#include <platform/uart.h>

int foobar;

volatile static struct UART3_REGISTER_LIST *uart3 = (struct UART3_REGISTER_LIST *)
    UART3_BASE;

int uart3_tx(char data)
{
    /* wait until tx fifo is empty so that we do not overflow it */
    while ((uart3->lsr_reg & TX_FIFO_E) == 0)
        ;

    uart3->dll_reg = data;

    return 0;
}

char uart3_rx()
{
    /* wait until a character is present */
    while ((uart3->lsr_reg & RX_FIFO_E) == 0 )
        ;

    return uart3->dll_reg;
}

void uart3_print(const char *data)
{
    while (*data != 0) {
        uart3_tx(*data++);
    }
}

