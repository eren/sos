# Copyright (C) 2012  Eren Türkay
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.

ARMGNU = arm-linux-gnueabi
OUTPUT_FILE=boot
 
AOPS = --warn --fatal-warnings
COPS = -marm -Wall -Werror -O2 -nostdlib -nostartfiles -ffreestanding -fno-stack-protector
  
OBJS := boot.o uart.o kernel.o interrupt.o

all: $(OUTPUT_FILE).bin

boot.bin: $(OBJS)
	$(ARMGNU)-ld -T memory-map.ld $(OBJS) -o $(OUTPUT_FILE).elf
	$(ARMGNU)-objdump -D boot.elf > $(OUTPUT_FILE).elf.lst
	$(ARMGNU)-objcopy boot.elf -O srec $(OUTPUT_FILE).srec
	$(ARMGNU)-objcopy boot.elf -O binary $(OUTPUT_FILE).bin

%.o: %.c
	$(ARMGNU)-gcc-4.6 -c $(COPS) $< -o $@

%.o: %.asm
	$(ARMGNU)-as $< -o $@

clean:
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
	rm -f *.lst
	rm -f *.srec
