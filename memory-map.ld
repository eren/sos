ENTRY(_start)

/* rammap */
MEMORY
{
    ram : ORIGIN = 0x80200000, LENGTH = 0x10000
}
 
SECTIONS
{
    .text : { *(.text) *(.rodata*) } > ram
    .data : { *(.data) } > ram
    .bss : { *(.bss) } > ram
}
