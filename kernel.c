#include "uart.h"

void kernel_main() {
    uart1_send((unsigned short) 0x1F);
}
