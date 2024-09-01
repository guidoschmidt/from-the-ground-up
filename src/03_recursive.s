  .section .data

  .section .text

  .globl _start
  .globl factorial   # this is not needed until you want to share this function among
                     # other programs / multiple files

_start:
  pushl $4           # the factorial takes one argument - the number we
                     # want the factorial of. push it to the statk

  call factorial

  addl $4, %esp      # Clean up the stack pointer

  movl %eax, %ebx    # Store return value of 'factorial' (%eax) into %ebx
                     # to use as return value of the exit syscall
  
  movl $1, %eax      # syscall to exit()
  int $0x80


  # Actual function definition
  .type factorial,@function

factorial:
  pushl %ebp         # store %ebp state to be able to restore before returning

  movl %esp, %ebp    # don't modif the stack pointer, instead we use %ebp

  movl 8(%ebp), %eax # move first argument to %eax
                     # 4(%ebp) holds the return address
                     # 8(%ebp) holds the first parameter

  cmpl $1, %eax      # Number is 1, return (base case)
  je end_factorial

  decl %eax          # otherwise decrease the value
  pushl %eax         # push it for our call to factorial
  call factorial
  movl 8(%ebp), %ebx # %eax has the return value. so we
                     # reload our parameter into %ebx
  imull %ebx, %eax   # multiply by the result of the last factorial call
                     # which is in %eax

end_factorial:
  movl %ebp, %esp
  popl %ebp
  ret
