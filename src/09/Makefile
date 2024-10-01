src = memory-manager.s

default: prepare compile compile-example link-example

prepare:
	mkdir -p o/
	mkdir -p bin/

compile:
	as $(src) -v -32 -g -o o/$(basename $(src)).o



compile-example:
	as read-records.s -v -32 -g -o o/read-records.o

link-example:
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 ../08/o/write-newline.o ../08/o/count-chars.o ../08/o/record-read.o o/memory-manager.o o/read-records.o -o bin/read-records

run:
	./bin/read-records
