ARMGNU = arm-linux-gnueabi
 
AOPS = --warn --fatal-warnings
COPS = -Wall -Werror -O2 -nostdlib -nostartfiles -ffreestanding 
  
all: uart.o kernel.o boot.bin

boot.bin: boot.asm
	$(ARMGNU)-as boot.asm -o boot.o
	$(ARMGNU)-ld -T memory-map.ld boot.o uart.o kernel.o -o boot.elf
	$(ARMGNU)-objdump -D boot.elf > boot.list
	$(ARMGNU)-objcopy boot.elf -O srec boot.srec
	$(ARMGNU)-objcopy boot.elf -O binary boot.bin

kernel.o: uart.o
	$(ARMGNU)-gcc-4.6 -c $(COPS) kernel.c -o kernel.o

uart.o: uart.c
	$(ARMGNU)-gcc-4.6 -c $(COPS) uart.c -o uart.o


clean:
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
	rm -f *.list
	rm -f *.srec
