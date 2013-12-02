/*
Copyright (C) 2012  Eren Türkay

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.
*/

OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

ENTRY(_start)
SECTIONS
{
	. = %MEMBASE%;

    .text : {
        KEEP(*(.text.boot))
        *(.text*) 
    }

    .rodata : ALIGN(4) {
        __rodata_start = .;
        *(.rodata .rodata.*)
        . = ALIGN(4);
        __rodata_end = .;
    }

    .data : ALIGN(4) {
        __data_start = .;

        *(.data .data.* .gnu.linkonce.d.*)
        . = ALIGN(4);

        __data_end = .;
    }

    .bss : ALIGN(4) {
        __bss_start = .;

        *(.bss*)
		*(.gnu.linkonce.b.*)
		*(COMMON)

		. = ALIGN(4);
		__bss_end = .;
    }

	_end = .;

	. = %MEMBASE% + %MEMSIZE%;
	_end_of_ram = .;

	/* Strip unnecessary stuff */
	/DISCARD/ : { *(.comment .note .eh_frame) }
}
