#We need to be in ARM mode - we may branch to Thumb mode later if desired.
.arm
.global _start

_start:
    ldr sp, =stack_bottom
    bl kernel_main
    b .
