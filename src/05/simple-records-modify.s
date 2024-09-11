  .include "../utils/linux.s"
  .include "./imports/record-def.s"

  .section .data
input_filename:
  .ascii "./data/test.dat\0"
output_filename:  
  .ascii "./data/modified.dat\0"

  .section .bbs
  .lcomm record_buffer, REC_SIZE

  # Stack offsets of local variables
  .equ ST_INPUT_DESCRIPTOR, -4
  .equ ST_OUTPUT_DESCRIPTOR, -8

  .section .text
  .globl _start

_start:
  # Copy stack pointer and make room for local variabels
  movl %esp, %ebp
  subl $8, %esp

  # Open file for reading
  movl $SYS_OPEN, %eax
  movl $input_filename, %ebx
  movl $0, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL

  movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

  # Open file for writing
  movl $SYS_OPEN, %eax
  movl $output_filename, %ebx
  movl $0101, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL

  movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
  pushl ST_INPUT_DESCRIPTOR(%ebp)
  pushl $record_buffer
  call read_record
  addl $8, %esp

  # Returns the number of bytes read
  # if it isn't the same as requested
  # it's either end-of-file or error
  # → quit
  cmpl $REC_SIZE, %eax
  jne loop_end

  # Increment age
  incl record_buffer + REC_AGE

  # Write the changed record to outfile
  pushl ST_OUTPUT_DESCRIPTOR(%ebp)
  pushl $record_buffer
  call write_record
  addl $8, %esp

  jmp loop_begin

loop_end:
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
