  .section .data
  .section .text
  .global _start

_start:
  movl $42, %eax
  pushl %eax
  movl (%esp), %ebx
  int $0x80
