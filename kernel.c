#include "uart.h"

void kernel_main() {
    while (1) {
        uart3_send('e');
    }
}
