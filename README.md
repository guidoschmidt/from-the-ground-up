# Programming From The Ground Up
> Learn 32 Bit Assembly

## Project Setup
### Qemu

Download Debian image
```
curl -Lo debian.amd64.qcow2 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2
```

Resize to desired disk size
```
qemu-img resize debian.qcow2 16G
```

Run the machine
```
./start.sh
```

On the virtual machine guest, add virtual drive via:
```
vim /etc/fstab
```
then add the following line
```
Project /root/ground-up 9p _netdev,trans=virtio,version=9p2000.u,msize=104857600 0 0
```

Install development toolchains
```
apt update
apt install -y build-essential gdb vim
```

Exit the virtual machine
```
Crtl-A x
```

Login: `root`


### Makefile

The `Makefile` allows building the examples, e.g:
```
make build src=00_exit.s
```

`make build` unites the following build process:

1. Assemble/complie with `as` (using `-32` option to build 32 bit assembler,
since *Programming from the ground up* covers 32 bit assembly) to `object`
(`.o`) file in `o/` directory.
2. Link with `ld` (using `-m elf_i386` option to use the 32 bit emulation
toolchain) to create a runnable binary in `bin/` folder

---

## Registers

- General Purpose Registers: `%eax, %ebx, %ecx, %edx, %edi, %esi`
- Special Purpose Registers: `%ebp, %esp, %eip, %eflags`
1. `%ebp`: base pointer, you access specific data in memory by offsetting this
   base pointer address, e.g. `-4(%ebp)`
2. `%esp`: always contains a pointer to the top of the stack

---

## Debugging
Using [gdb](https://sourceware.org/gdb/) you can step through the program after
building it by running, e.g:
```
gdb bin/00_exit
```

**Helpful commands**
- `list $line_number`, e.g. `list 20` to show the source code (shortcut `l`)
- `breakpoint $line_number`, e.g. `breakpoint 20` to set a breakpoint (shortcut `b`)
- `run` to start the program (shortcut `r`)
- `continue` to continue after halt on a breakpoint (shortcut `c`)
- `step` to step through line by line after halt on a breakpoint (shortcut `s`)
- `info register $register`, e.g. `info register eax` to list registers and
  their values (shortcut `i r`) - you can add more than one register, e.g. `i r
  eax ebx esi`
- `info frame` shows the stack frame info (shortcut `i f`)
- `p $sp` print stack pointer
- `x/10d $sp` display 10 memory blocks (as decimal) at stack pointer, see [x
  command](https://visualgdb.com/gdbreference/commands/x)
- `backtrace` shows the call stack (shortcut `bt`)

---

## Sources
- [0] https://archive.org/details/programming-from-the-ground-up
- [1] https://gist.github.com/gsf/c7bb24178700ffcaeab9c100c63264bb
- [2] https://blachniet.com/posts/create-a-minimal-local-debian-vm-with-qemu/
