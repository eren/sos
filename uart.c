#include "uart.h"

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

