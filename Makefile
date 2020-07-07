BOOT := bootloader
OBJS := stage1.o stage2.o
OS := os

.PHONY: all clean qemu

all: clean $(BOOT).bin

$(OS).bin: $(OBJS)
	$(LD) -T linker.ld --oformat=binary -o $@ $<

qemu: $(OS).bin
	qemu-system-x86_64 -drive format=raw,file=./$<

clean:
	rm -f $(OBJS) $(BOOT).bin
