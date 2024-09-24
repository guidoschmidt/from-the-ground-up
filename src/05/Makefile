default: build-write build-read build-mod

build-write: prepare compile-write link-write
build-read: prepare compile-read link-read
build-mod: prepare compile-mod link-mod

prepare:
	mkdir -p o/
	mkdir -p bin/

clean:
	rm -rf o/*
	rm -rf bin/*

compile-write:
	as imports/record-write.s -v -32 -g -o o/record-write.o
	as simple-records-write.s -v -32 -g -o o/simple-records-write.o

link-write:
	ld -m elf_i386 o/record-write.o o/simple-records-write.o -o bin/write

compile-read:
	as imports/record-read.s -v -32 -g -o o/record-read.o
	as imports/write-newline.s -v -32 -g -o o/write-newline.o
	as imports/count-chars.s -v -32 -g -o o/count-chars.o
	as simple-records-read.s -v -32 -g -o o/simple-records-read.o

link-read:
	ld -m elf_i386 o/record-read.o o/write-newline.o o/count-chars.o o/simple-records-read.o -o bin/read

compile-mod:
	as imports/record-read.s -v -32 -g -o o/record-read.o
	as imports/record-write.s -v -32 -g -o o/record-write.o
	as imports/write-newline.s -v -32 -g -o o/write-newline.o
	as imports/count-chars.s -v -32 -g -o o/count-chars.o
	as simple-records-modify.s -v -32 -g -o o/simple-records-modify.o

link-mod:
	ld -m elf_i386 o/record-read.o o/record-write.o o/simple-records-modify.o -o bin/modify
