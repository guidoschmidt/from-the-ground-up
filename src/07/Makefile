dfault: prepare compile-nolib link-nolib compile-lib link-lib compile-printf link-printf

prepare:
	mkdir -p o/
	mkdir -p bin/

compile-nolib:
	as helloworld-nolib.s -v -32 -g -o o/helloworld-nolib.o

link-nolib:
	ld -m elf_i386 o/helloworld-nolib.o -o bin/helloworld-nolib

compile-lib:
	as helloworld-lib.s -v -32 -g -o o/helloworld-lib.o

link-lib:
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 /lib32/libc.so.6 o/helloworld-lib.o -o bin/helloworld-lib


compile-printf:
	as printf-args.s -v -32 -g -o o/printf-args.o

link-printf:
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 /lib32/libc.so.6 o/printf-args.o -o bin/printf-args
