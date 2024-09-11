  .type count_chars, @function
  .globl count_chars

  .equ ST_STRING_START_ADDRESS, 8

count_chars:
  pushl %ebp
  movl %esp, %ebp

  # Counter starts at 0
  movl $0, %ecx

  # Starting address of data
  movl ST_STRING_START_ADDRESS(%ebp), %edx

count_loop_begin:
  # Get current character
  movb (%edx), %al
  # Check if 0
  cmpb $0, %al
  je count_loop_end
  # Else increment counter and pointer
  incl %ecx # counter
  incl %edx # char pointer
  # start loop from beginning
  jmp count_loop_begin

count_loop_end:
  # Put count result to return value in %eax
  movl %ecx, %eax
  popl %ebp
  ret
  
