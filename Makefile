BOOT := bootloader
OBJS := stage1.o stage2.o kernel.o kernel_jmp.o
OS := os
ASFLAGS := --32

.PHONY: all clean qemu

all: clean $(BOOT).bin

$(OS).bin: $(OBJS)
	$(LD) -m elf_i386 -T linker.ld -o $@

kernel.o: kernel.c
	gcc -ffreestanding -m32 -fno-pie -c $< -o $@

qemu: $(OS).bin
	qemu-system-x86_64 -drive format=raw,file=./$<

debug: $(OS).bin
	qemu-system-x86_64 -drive format=raw,file=./$< -s -S

clean:
	rm -f $(OBJS) $(BOOT).bin
