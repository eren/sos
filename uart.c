#include "uart.h"

static struct UART3_REGISTERS *uart3 = (struct UART3_REGISTERS *) UART3_BASE;

void uart3_send(unsigned short val) {
    uart3->thr_reg = val;
}
