ENTRY(_start)

/* rammap */
MEMORY
{
    ram : ORIGIN = 0x80200000, LENGTH = 0x10000
}
 
SECTIONS
{
    .text : { *(.text) } > ram
    .data : { *(.data) } > ram
    .bss : { *(.bss) } > ram
     . = . + 0x5000; /* 4kB of stack memory */
    stack_bottom = .;
}
