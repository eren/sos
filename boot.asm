# Allocate related segments in asm file instead of linker script
.text

# We need to be in ARM mode - we may branch to Thumb mode later if desired.
.arm

.global _start
_start:
    ldr sp, =stack_top
    bl kernel_main
    b .

.data
.bss

.align 8
stack_bottom:
    .skip 4096

stack_top:
