.PHONY: default compile build run
default: compile build run


compile: 
	nasm -f bin boot.asm -o builds/boot.bin
	nasm -f bin game/main.asm -o builds/game.bin

build:
	dd if=builds/boot.bin of=disk.vhd bs=440 count=1 conv=notrunc
	dd if=builds/game.bin of=disk.vhd bs=1 seek=1024 conv=notrunc

run: 
	qemu-system-i386 -m 32 -drive format=raw,file=disk.vhd,media=disk
