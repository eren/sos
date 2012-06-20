#include "uart.h"

volatile unsigned char* UART_WRITE = (unsigned char *) UART1_BASE;

void uart1_send(unsigned short val) {
    *UART_WRITE = val;
}
