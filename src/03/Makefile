src = power.s

default: prepare compile link

prepare:
	mkdir -p o/
	mkdir -p bin/

compile:
	as $(src) -v -32 -g -o o/$(basename $(src)).o

link:
	ld -m elf_i386 o/$(basename $(src)).o -o bin/$(basename $(src))

run:
	./bin/$(basename $(src))
