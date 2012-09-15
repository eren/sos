#include "interrupt.h"

void write_vector_table(void)
{
    volatile static struct Vector_table *vtable = (struct Vector_table *) RAM_VECTOR_BASE;

    vtable->undefined       = (uint)&handle_interrupt;
    vtable->swi             = (uint)&handle_interrupt;
    vtable->prefetch_abort  = (uint)&handle_interrupt;
    vtable->data_abort      = (uint)&handle_interrupt;
    vtable->unused          = (uint)&handle_interrupt;
    vtable->irq             = (uint)&handle_interrupt;
    vtable->fiq             = (uint)&handle_interrupt;
    
}

void handle_interrupt(void)
{
    uart3_print("Some intterupt happened!\n\n\r");

}
