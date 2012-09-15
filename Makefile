ARMGNU = arm-linux-gnueabi
 
AOPS = --warn --fatal-warnings
COPS = -marm -Wall -Werror -O2 -nostdlib -nostartfiles -ffreestanding 
  
OBJS := boot.o uart.o kernel.o interrupt.o

all: boot.bin

boot.bin: $(OBJS)
	$(ARMGNU)-ld -T memory-map.ld $(OBJS) -o boot.elf
	$(ARMGNU)-objdump -D boot.elf > boot.list
	$(ARMGNU)-objcopy boot.elf -O srec boot.srec
	$(ARMGNU)-objcopy boot.elf -O binary boot.bin

%.o: %.c
	$(ARMGNU)-gcc-4.6 -c $(COPS) $< -o $@

%.o: %.asm
	$(ARMGNU)-as $< -o $@

clean:
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
	rm -f *.list
	rm -f *.srec
