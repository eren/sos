#ifndef UART_H
#define UART_H

/**
 * UART address definitions
 */

#define UART3_BASE 0x49020000

struct UART3_REGISTERS {
    unsigned char thr_reg; // offset 0, 8bit
    unsigned short dummy1;
    unsigned char dlh_reg; // offset 4
    /* 
     * TODO: ADD OTHER REGISTERS HERE WHEN NEEDED
     */
};

void uart3_send(unsigned short val);

#endif /* UART_H */
