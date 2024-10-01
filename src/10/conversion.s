  .include "../utils/linux.s"

  .section .data

  # Storage
tmp_buffer:
  .ascii "\0\0\0\0\0\0\0\0\0\0\0"

  .section .text

  .globl _start
_start:
  movl %esp, %ebp

  # Storage for the result
  pushl $tmp_buffer
  # Number to convert
  push $42
  call int2str
  addl $8, %esp

  # Get the character count for the system call
  pushl $tmp_buffer
  call count_chars
  addl $4, %esp

  # Count → %edx
  movl %eax, %edx

  # System call
  movl $SYS_WRITE, %eax
  movl $STDOUT, %ebx
  movl $tmp_buffer, %ecx

  int $LINUX_SYSCALL

  # Write a carriage return
  pushl $STDOUT
  call write_newline

  # Exit
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
