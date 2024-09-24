  .section .data
heap_begin:
  .long 0
current_break:
  .long 0

  # Size of spcae for memory region header
  .equ HEADER_SIZE, 8
  # Location of the "available" flag in the header
  .equ HDR_AVAIL_OFFSET, 0
  # Location of the size field in the header
  .equ HDR_SIZE_OFFSET, 4

  .equ UNAVAILABLE, 0 # marks memory space that has been given out
  .equ AVAILABLE, 1 # marks memory space that is free to use
  .equ SYS_BRK, 45 # system call number for 'break' system call
  .equ LINUX_SYSCALL, 0x80

  .section .text
  .global allocate_init
  .type allocate_init, @function
allocate_init:
  pushl %ebp
  movl %esp, %ebp

  # if the brk system call is called with 0 in %ebx
  # it returns the last valid usable address
  movl $SYS_BRK, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL

  incl %eax # %eax now has the last valid address

  movl %eax, current_break
  movl %eax, heap_begin

  movl %ebp, %esp # exit function
  popl %ebp
  ret


  .global allocate
  .type allocate, @function
  .equ ST_MEM_SIZE, 8 # stack position of the memory size to allocate

allocate:
  pushl %ebp
  movl %esp, %ebp

  movl ST_MEM_SIZE(%ebp), %ecx # %ecx will hold the size
  movl heap_begin, %eax        # %eax holds the current search location
  movl current_break, %ebx     # %ebx holds the current break

alloc_loop_begin:
  cmpl %ebx, %eax
  je move_break

  # Grab the size of this memory
  movl HDR_SIZE_OFFSET(%eax), %edx
  # If the space is unavailable, ...
  cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
  # ... go to the next location
  je next_location

  cmpl %edx, %eax
  je move_break

  # grab the size of this memory
  movl HDR_SIZE_OFFSET(%eax), %edx
  # If space is unavailable, go to next location
  cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
  je next_location

  cmpl %edx, %ecx   # If space is available, compare the size needed
  jle allocate_here # if it is big enough, allocate

  
next_location:
  # The total size of the memory region is the sum of the
  # size requested (stored in %edx), plus another 8 bytes
  # for the header (4 for the (UN)AVAILABLE flag and 4 for
  # the size of the region). Adding %edx and $8
  # to %eax will get the address of the next memory region
  addl $HEADER_SIZE, %eax
  addl %edx, %eax

  jmp alloc_loop_begin

  
allocate_here:
  # If this is reached:
  # region header of the region to allocate
  # is in %eax

  # Mark space unavailable
  movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
  addl $HEADER_SIZE, %eax # move %eax past the header to the usable memory

  movl %ebp, %esp
  popl %ebp
  ret


move_break:
  # If this is reached:
  # all addressable memory blocks are exhausted, ask
  # for more. %ebx holds the current endpoint of data
  # and %ecx holds its size

  # Increase %ebx to where memory should end. So add
  # space for header structure and space to the break
  # for the requested data
  addl $HEADER_SIZE, %ebx
  addl %ecx, %ebx

  # Ask Linux for more memory
  pushl %eax
  pushl %ecx
  pushl %ebx

  # Request the break (%ebx holds requested break point)
  movl $SYS_BRK, %eax
  int $LINUX_SYSCALL

  # This should return the new break in %eax
  # beeing either 0 if it failed or
  # equal to (or larger) than the asked
  # size.

  cmpl $0, %eax
  je error

  popl %ebx
  popl %ecx
  popl %eax

  # Set this memory as unavailable, since
  # its going to be given away
  movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
  # Set the memory size
  movl %ecx, HDR_SIZE_OFFSET(%eax)

  # Move %eax to actual start of the usable memory
  addl $HEADER_SIZE, %eax

  movl %ebx, current_break # save the break

  movl %ebp, %esp # return
  popl %ebp
  ret


error:
  movl $0, %eax # return 0 on error
  movl %ebp, %esp
  popl %ebp
  ret



  .globl deallocate
  .type deallocate, @function

  .equ ST_MEMORY_SEG, 4

deallocate:
  # Get the address of the memory to free
  # (usually 8(%ebp)) but since
  # %ebp wasn't pushed or %esp was not moved to
  # %ebp, you can just use 4(%esp)
  movl ST_MEMORY_SEG(%esp),  %eax

  # get the pointer to the real memory beginning
  subl $HEADER_SIZE, %eax
  # mark it as available
  movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
  ret
