  .include "../utils/linux.s"
  .include "./imports/record-def.s"

  .section .data
file_name:
  .ascii "./data/test.dat\0"

  .section .bss
  .lcomm record_buffer, REC_SIZE

  .section .text

  .globl _start

_start:
  .equ ST_INPUT_DESCRIPTOR, -4
  .equ ST_OUTPUT_DESCRIPTOR, -8

  # Copy stack pointer to %ebp
  movl %esp, %ebp
  # Allocate space to hold file descriptors
  subl $8, %esp

  # Open file
  movl $SYS_OPEN, %eax
  movl $file_name, %ebx
  movl $0, %ecx # open read only
  movl $0666, %edx
  int $LINUX_SYSCALL

  # Save file descriptor
  movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

  movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
  pushl ST_INPUT_DESCRIPTOR(%ebp)
  pushl $record_buffer
  call read_record
  addl $8, %esp

  # Returns the number of bytes read
  # If this is not the same number
  # it's either end-of-file or errer → quit
  cmpl $REC_SIZE, %eax
  jne finished_reading

  # Otherwise print out the first name
  pushl $REC_FIRSTNAME + record_buffer
  call count_chars
  addl $4, %esp
  
  movl %eax, %edx
  movl ST_OUTPUT_DESCRIPTOR(%ebp), %edx
  movl $SYS_WRITE, %eax
  movl $REC_FIRSTNAME + record_buffer, %ecx
  int $LINUX_SYSCALL

  pushl ST_OUTPUT_DESCRIPTOR(%ebp)
  call write_newline
  addl $4, %esp

  jmp record_read_loop

finished_reading:
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
