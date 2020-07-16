BOOT := bootloader
OBJS := stage1.o stage2.o kernel.o kernel_jmp.o
OS := os

.PHONY: all clean qemu

all: clean $(BOOT).bin

$(OS).bin: $(OBJS)
	$(LD) -T linker.ld -o $@

kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

qemu: $(OS).bin
	qemu-system-x86_64 -drive format=raw,file=./$<

clean:
	rm -f $(OBJS) $(BOOT).bin
