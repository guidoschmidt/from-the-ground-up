build:
	as $(src) -v -32 -g -o o/$(basename $(src)).o
	ld -m elf_i386 o/$(basename $(src)).o -o bin/$(basename $(src))
