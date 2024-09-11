  .include "../utils/linux.s"
  .include "./imports/record-def.s"

  .section .data

record1:
  .ascii "Guido\0"
  .rept 31 #Padding to 40 bytes
  .byte 0
  .endr

  .ascii "Schmidt\0"
  .rept 31 #Padding to 40 bytes
  .byte 0
  .endr

  .ascii "Assembly Lane 42\n777 Memory City\0"
  .rept 209 #Padding to 240 bytes
  .byte 0
  .endr

  .long 37

file_name:
  .ascii "./data/test.dat\0"

  .equ ST_FILE_DESCRIPTOR, -4

  .globl _start

_start:
  # Copy stack pointer to %ebp
  movl %esp, %ebp
  # Allocate space to hold the file descriptor
  subl $4, %esp

  # Open the file
  movl $SYS_OPEN, %eax
  movl $file_name, %ebx
  movl $0101, %ecx # create if non existant, open for write
  movl $0666, %edx
  int $LINUX_SYSCALL

  # Store file descriptor
  movl %eax, ST_FILE_DESCRIPTOR(%ebp)

  # Write the record
  pushl ST_FILE_DESCRIPTOR(%ebp)
  pushl $record1
  call write_record
  addl $8, %esp

  # Exit
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
