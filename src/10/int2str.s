  .equ ST_VALUE, 8
  .equ ST_BUFFER, 12

  .globl int2str
  .type int2str, @function

int2str:
  pushl %ebp
  movl %esp, %ebp

  # Current char count
  movl $0, %ecx

  # Move the value into position
  movl ST_VALUE(%ebp), %eax

  # When divided by 10, 10
  # must be in a register or memory location
  movl $10, %edi

conversion_loop:
  # Division is performed on the combined %edx:%eax register,
  # so first clear out %dx
  movl $0, %edx

  # Divide %edx:%eax (which are implied) by 10.
  # Store the quotient in %eax and the remainder
  # in %dx (both of which are implied)
  divl %edi

  # Quotient is in the right place
  # %edx = remainder
  #       → needs to be converted to a number (0 - 9)

  # Index on the ASCII table:
  # '0' + 0 is still ASCII '0'
  # '0' + 1 is ASCII for '1'
  # etc.
  addl $'0', %edx

  # Push value on the stack.
  # When done, just pop off the characters
  # one-by-one which creates the right order
  pushl %edx

  # Increment digit count
  incl %ecx

  # Check if %eax is zero yet
  cmpl $0, %eax
  je end_conversion_loop

  jmp conversion_loop

end_conversion_loop:
  # string is now on the stack, pop it off
  # one-by-one and copy it into the buffer

  # Pointer to buffer in %edx
  movl ST_BUFFER(%ebp), %edx

copy_reversing_loop:
  # Pushed a whole register in line 44
  # but we only need the last byte
  popl %eax
  movb %al, (%edx)

  # Decreate %ecx (digit counter)
  decl %ecx
  # Increase %edx so it will point to the next byte
  incl %edx

  # Check to see if finished
  cmpl $0, %ecx
  # If so, jump to end
  je end_copy_reversing_loop
  # Otherwise, repeat loop
  jmp copy_reversing_loop

end_copy_reversing_loop:
  # Done copying. Write a null byte and return
  movb $0, (%edx)

  movl %ebp, %esp
  popl %ebp
  ret
