# disable default rules
.SUFFIXES:

.PHONY: run
.DEFAULT: run

run: clean generate_output_files

clean:
	rm -rf bootloader_files
	rm -rf object_files
	mkdir bootloader_files
	mkdir object_files

generate_output_files: generate_object_files generate_bootloader_files
generate_object_files:  object_files/boot1.o object_files/vbe_structure_c.o object_files/Kernel.o
generate_bootloader_files: bootloader_files/bootloader.bin

qemu-boot-hdd:bootloader_files/bootloader.bin
	qemu-system-x86_64 -drive file=$<,media=disk,format=raw

qemu-boot-cd:bootloader_files/mk2018.iso
	qemu-system-x86_64 -cdrom bootloader_files/mk2018.iso

OBJS:= ./object_files/boot1.o ./object_files/vbe_structure_c.o ./object_files/Kernel.o
ALLFLAGS:= -nostdlib -ffreestanding -std=gnu99 -mno-red-zone -fno-exceptions -nostdlib -Wall -Wextra
INC:= ./include_files/



object_files/boot1.o: source_files/boot1.S
	/home/rakesh/Desktop/cross-compiler/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-as -I $(INC) $< -o $@

object_files/vbe_structure_c.o: include_files/vbe_structure_c.c
	/home/rakesh/Desktop/cross-compiler/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-gcc -m16 -I $(INC) -c $< -o $@ -e 0x0 $(ALLFLAGS)

object_files/Kernel.o: source_files/Kernel.c
	/home/rakesh/Desktop/cross-compiler/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-gcc -m32 -I $(INC) -c $< -o $@ -e boot_main $(ALLFLAGS)

bootloader_files/bootloader.bin: $(OBJS)
	/home/rakesh/Desktop/cross-compiler/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-ld $(OBJS) -o $@ -T linker_files/linker.ld
