sources := conversion.s int2str.s

default: prepare compile link

prepare:
	mkdir -p o/
	mkdir -p bin/

clean:
	rm -rf o/*
	rm -rf bin/

compile:
		for src in $(sources); do \
				as ./$${src} -v -32 -g -o o/$$(basename $$src .s).o; \
		done

link:
	ld -m elf_i386 ../08/o/count-chars.o ../08/o/write-newline.o o/int2str.o o/conversion.o -o bin/conversion
