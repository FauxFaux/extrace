all: maybe

maybe: maybe.s
	nasm -f elf64 maybe.s
	musl-gcc -s -Os -static -nostdlib maybe.o -o maybe
	strip --strip-all maybe

