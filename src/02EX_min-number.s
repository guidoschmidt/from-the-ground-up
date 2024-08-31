  .section .data

data_items:
  .long 3,67,34,128,72,12,9,99,5,1,0

  .section .text

  .globl _start
_start:
  movl $0, %edi                  # move 0 inot the index register
  movl data_items(,%edi,4), %eax # load the first byte of data
  movl %eax, %ebx                # since this is the first item, %eax is the biggest

start_loop:
  incl %edi       # load next value
  movl data_items(,%edi,4), %eax

  cmpl $0, %eax   # check if current item is 0 → end of list 
  je loop_exit

  cmpl %eax, %ebx
  jle start_loop  # jump to loop start if the current list item is not smaller

  movl %eax, %ebx # move current value to %ebx as the smallest item in the list
  jmp start_loop  # jump to loop beginning

loop_exit:
                  # %ebx is the status code for the exit system call
                  # and it already has the maximum number
  movl $1, %eax   # 1 is exit() syscall
  int $0x80
