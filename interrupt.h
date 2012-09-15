#ifndef __INTERRUPT_H
#define __INTERRUPT_H

#include "types.h"
#include "uart.h"

#define RAM_VECTOR_BASE 0x4020FFE4;

struct Vector_table {
    uint undefined;
    uint swi;
    uint prefetch_abort;
    uint data_abort;
    uint unused;
    uint irq;
    uint fiq;
};

void write_vector_table(void);
void handle_interrupt(void);

#endif /* __INTERRUPT_H */
