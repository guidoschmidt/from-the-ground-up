default: build-mod

build-mod: prepare compile-mod link-mod

prepare:
	mkdir -p o/
	mkdir -p bin/

compile-mod:
	as imports/error-exit.s -v -32 -g -o o/error-exit.o
	as imports/record-read.s -v -32 -g -o o/record-read.o
	as imports/record-write.s -v -32 -g -o o/record-write.o
	as imports/write-newline.s -v -32 -g -o o/write-newline.o
	as imports/count-chars.s -v -32 -g -o o/count-chars.o
	as robust-records-modify.s -v -32 -g -o o/robust-records-modify.o

link-mod:
	ld -m elf_i386 o/record-read.o o/count-chars.o o/write-newline.o o/error-exit.o o/record-write.o o/robust-records-modify.o -o bin/modify
