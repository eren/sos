#include "uart.h"

void kernel_main() {
    char c;

    uart3_print("\n\r");
    uart3_print("========\n\r");
    uart3_print("Hello from Simple Operating System!\n\r");
    uart3_print("httt://github.com/eren/sos\n\r");
    uart3_print("========\n\n\r");
    uart3_print("Now echoing what you type on serial port...\n\n\r");

    while (1) {
        c = uart3_rx();
        uart3_tx(c);
    }
    

}
