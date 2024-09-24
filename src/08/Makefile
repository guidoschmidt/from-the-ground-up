#### Library
sources := count-chars.s error-exit.s record-def.s record-read.s record-write.s write-newline.s

default: prepare compile link compile-bin link-bin

prepare:
	mkdir -p o/
	mkdir -p bin/
	mkdir -p build/

clean:
	rm -rf o/*
	rm -rf bin/
	rm -rf build/*

compile:
		for src in $(sources); do \
				as ./lib/$${src} -v -32 -g -o o/$$(basename $$src .s).o; \
		done

link:
	ld -m elf_i386 -shared o/record-read.o o/record-write.o -o build/librecord.so


#### Binary
compile-bin:
	as write-records.s -v -32 -g -o o/write-records.o

link-bin:
	ld -m elf_i386 -L ./build/ -dynamic-linker /lib/ld-linux.so.2 -lrecord o/write-records.o -o bin/write-records

run:
	LD_LIBRARY_PATH=./build
	export LD_LIBRARY_PATH
	./bin/write-records
