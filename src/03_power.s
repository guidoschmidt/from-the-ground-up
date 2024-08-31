  .section .data

  .section .text

  .globl _start

_start:
  pushl $5        # push second argument
  pushl $2        # push first argument
  call power      # call function by it's name (label)
  addl $8, %esp   # move the stack pointer
  pushl %eax      # save the first answer before calling the next function

  pushl $6        # push second argument
  pushl $2        # push first argument
  call power      # call function by name (label)
  addl $8, %esp   # move the stack pointer
  popl %ebx       # the second answer is already in %eax. Save the first
                  # answer on the stack, so now we can just pop it
                  # out into %ebx
  addl %eax, %ebx # add the results together into %ebx

  movl $1, %eax   # exit (%ebx is returned using exit syscall)
  int $0x80


  # PURPOSE: this function computes the power of a number
  #
  # INPUT: first arg - the base number
  #        second arg - the power
  #
  # OUTPUT: returns the result of (first arg)^(second arg)
  #
  # NOTES: power must be 1 or greater
  #
  # VARIABLES:
  #        %ebx - holds the base number
  #        %ecx - holds the power
  #        -4(%ebp) - holds the current result
  #        %eax is used for temporary storage
  .type power, @function
power:
  pushl %ebp # save the old base pointer
  movl %esp, %ebp # turn stack pointer into base pointer
  subl $4, %esp # create space for local storage

  movl 8(%ebp), %ebx # put first argument in %eax
  movl 12(%ebp), %ecx # put second argument in %ecx

  movl %ebx, -4(%ebp) # store current result

power_loop_start:
  cmpl $1, %ecx # if power is 1 → done
  je end_power
  movl -4(%ebp), %eax #move current result into %eax
  imull %ebx, %eax # multiply the current result by the base number

  movl %eax, -4(%ebp) # store the current result

  decl %ecx # decreae the power
  jmp power_loop_start # ron for the next power

end_power:
  movl -4(%ebp), %eax # return value goes into %eax
  movl %ebp, %esp # restore stack pointer
  popl %ebp # restore the base pointer
  ret
