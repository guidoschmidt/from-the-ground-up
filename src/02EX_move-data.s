  .section .data
data_items:
  .long 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

  .section .text

  .globl _start
_start:
  movl $13, %edi                  # put 13 into %edi
  movl data_items(,%edi,4), %eax  # use %edi to get the value from data_items and
                                  # put it into %eax
  movl %eax, %ebx
  movl $1, %eax                   # exit() syscall
  int $0x80

  
