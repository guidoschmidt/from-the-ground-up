  .section .data

data_items:
  .long 3,67,34,222,45,75,54,34,34,33,230,11,66,0

  .section .text

  .globl _start
_start:
  movl $0, %edi # move 0 inot the index register
  movl data_items(,%edi,4), %eax # load the first byte of data
  movl %eax, %ebx # since this is the first item, %eax is the biggest

start_loop:
  cmpl $0, %eax # check if current item is 0 → end of list 
  je loop_exit
  incl %edi # load next value
  movl data_items(,%edi,4), %eax
  cmpl %ebx, %eax
  jle start_loop # jump to loop start if the current list item is not bigger

  movl %eax, %ebx # move current value to %ebx as the largest item in the list
  jmp start_loop # jump to loop beginning

loop_exit:
  # %ebx is the status code for the exit system call
  # and it already has the maximum number
  movl $1, %eax # 1 is exit() syscall
  int $0x80
