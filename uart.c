#include "uart.h"

volatile unsigned char* UART_WRITE = (unsigned char *) UART3_BASE;

void uart3_send(unsigned short val) {
    *UART_WRITE = val;
}
