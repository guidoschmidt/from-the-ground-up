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
	ld -m elf_i386 -L ./lib/ -dynamic-linker /lib/ld-linux.so.2 -lrecord ../08/o/write-newline.o ../08/o/count-chars.o o/memory-manager.o o/read-records.o -o bin/read-records

run:
	LD_LIBRARY_PATH=./lib/
	export LD_LIBRARY_PATH
	./bin/read-records
