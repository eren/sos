#include "uart.h"

void kernel_main() {
    while (1) {
        uart1_send('c');
    }
}
