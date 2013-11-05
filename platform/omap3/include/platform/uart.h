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

#ifndef __UART_H
#define __UART_H

#define UART3_BASE 0x49020000

/*
 * Variables used to mask LSR_REG to know the state of the FIFO while
 * sending or receiving the data
 */
#define TX_FIFO_E    (1<<5)
#define RX_FIFO_E    (1<<0)

/*
 * There are different registers that point to the same address in the
 * technical manual of TI OMAP. Only one of these names is used and other
 * registers are commented.
 */
struct UART3_REGISTER_LIST {
    /* {dll, rhr, thr}_reg */
    unsigned char dll_reg;      /* offset 0x0 */
    unsigned char dummy1[3];

    /* {dlh, ier} */
    unsigned char dlh_reg;      /* offset 0x4 */
    unsigned char dummy2[3];

    /* {iir, fcr, efr} */
    unsigned char iir_reg;      /* offset 0x8 */
    unsigned char dummy3[3];

    unsigned char lcr_reg;      /* offset 0xc */
    unsigned char dummy4[3];

    /* {mcr, xon1_addr1} */
    unsigned char mcr_reg;      /* offset 0x10 */
    unsigned char dummy5[3];

    /* {lsr, xon2_addr2} */
    unsigned char lsr_reg;      /* offset 0x14 */
    unsigned char dummy6[3];

    /* {msr, tcr, xoff1} */
    unsigned char msr_reg;      /* offset 0x18 */
    unsigned char dummy7[3];

    /* {spr, tlr, xoff2 */
    unsigned char spr_reg;      /* offset 0x1c */
    unsigned char dummy8[3];

    unsigned char mdr1_reg;     /* offset 0x20 */
    unsigned char dummy9[3];

    unsigned char mdr2_reg;     /* offset 0x24 */
    unsigned char dummy10[3];

    /*
     * TODO: Add remaning registers here when needed. Right know, these
     * registers are enough.
     */
};


/* 
 * Procedure definitons
 */
int uart3_tx(char data);
char uart3_rx(void);

void uart3_print(const char *data);


#endif /* __UART_H */
