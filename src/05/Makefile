build-write: prepare compile-write link-write
build-read: prepare compile-read link-read

prepare:
	mkdir -p o/
	mkdir -p bin/

compile-write:
	as imports/record-write.s -v -32 -g -o o/record-write.o
	as simple-records-write.s -v -32 -g -o o/simple-records-write.o

link-write:
	ld -m elf_i386 o/record-write.o o/simple-records-write.o -o bin/simple-records-write

compile-read:
	as imports/record-read.s -v -32 -g -o o/record-read.o
	as imports/write-newline.s -v -32 -g -o o/write-newline.o
	as imports/count-chars.s -v -32 -g -o o/count-chars.o
	as simple-records-read.s -v -32 -g -o o/simple-records-read.o

link-read:
	ld -m elf_i386 o/record-read.o o/write-newline.o o/count-chars.o o/simple-records-read.o -o bin/simple-records-read
