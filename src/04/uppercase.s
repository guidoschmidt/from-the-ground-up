.section .data

  ##### CONSTANTS #####

  # system calls abbrevs
  .equ SYS_OPEN, 5
  .equ SYS_WRITE, 4
  .equ SYS_READ, 3
  .equ SYS_CLOSE, 6
  .equ SYS_EXIT, 1

  # options for open (look at
  # /usr/include/asm/fnctl.h for
  # various values. You can combine them
  # by adding them or OR).
  .equ O_RDONLY, 0
  .equ O_CREATE_WRONLY_TRUNC, 03101

  # standard file descriptors
  .equ STDIN, 0
  .equ STDOUT, 1
  .equ STDERR, 2

  # System call interrupt
  .equ LINUX_SYSCALL, 0x80
  .equ END_OF_FILE, 0
  .equ NUMBER_ARGUMENTS, 2

  
.section .bss
  .equ BUFFER_SIZE, 500
  .lcomm BUFFER_DATA, BUFFER_SIZE

  
  .section .text

  .equ ST_SIZE_RESERVE, 8
  .equ ST_FD_IN, -4
  .equ ST_FD_OUT, -8
  .equ ST_ARGC, 0 # Number of arguments
  .equ ST_ARGV_0, 4 # Name of the program
  .equ ST_ARGV_1, 8 # Input file name
  .equ ST_ARGV_2, 12 # Output file name

  .globl _start

_start: 
  # Save stack pointer
  movl %esp, %ebp

  # Allocate space for file descriptors on the stack
  subl $ST_SIZE_RESERVE, %esp

open_files:
open_fn_in:
  # Open input file
  # open syscall
  movl $SYS_OPEN, %eax
  # input filename into %ebx
  movl ST_ARGV_1(%ebp), %ebx
  # read only flag
  movl $O_RDONLY, %ecx
  movl $0666, %edx
  # Syscall
  int $LINUX_SYSCALL

store_fd_in:
  # sav#e given file descriptor
  movl %eax, ST_FD_IN(%ebp)

open_fd_out:
  # Open output file
  movl $SYS_OPEN, %eax
  # output filename to %ebx
  movl ST_ARGV_2(%ebp), %ebx
  # File flags
  movl $O_CREATE_WRONLY_TRUNC, %ecx
  # Mode for new file (if created)
  movl $0666, %edx
  # Syscall
  int $LINUX_SYSCALL

store_fd_out:
  # The the file descriptor
  movl %eax, ST_FD_OUT(%ebp)

  ##### MAIN LOOP #####
read_loop_begin:
  # Read in a block from the input file
  movl $SYS_READ, %eax
  # get input file descriptor
  movl ST_FD_IN(%ebp), %ebx
  # location to read into
  movl $BUFFER_DATA, %ecx
  # Size of the buffer
  movl $BUFFER_SIZE, %edx
  # Syscall
  int $LINUX_SYSCALL

  ### Exit if end is reached
  cmpl $END_OF_FILE, %eax
  # if found or error
  jle end_loop

continue_read_loop:
  pushl $BUFFER_DATA
  pushl %eax
  call convert_to_upper
  pop %eax
  addl $4, %esp
  ### Write block to output
  # size of the buffer
  movl %eax, %edx
  movl $SYS_WRITE, %eax
  # file to use
  movl ST_FD_OUT(%ebp), %ebx
  # buffer location
  movl $BUFFER_DATA, %ecx
  int $LINUX_SYSCALL

  jmp read_loop_begin

end_loop:
  ### Close files
  movl $SYS_CLOSE, %eax
  movl ST_FD_OUT(%ebp), %ebx
  int $LINUX_SYSCALL

  movl $SYS_CLOSE, %eax
  movl ST_FD_IN(%ebp), %ebx
  int $LINUX_SYSCALL

  ### Exit
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL



  ### CONSTANTS ###
  # Lower search boundary
  .equ LOWERCASE_A, 'a'
  .equ LOWERCASE_Z, 'z'
  .equ UPPER_CONVERSION, 'A' - 'a'

  ### STACK STUFF ###
  .equ ST_BUFFER_LEN, 8 # Buffer length
  .equ ST_BUFFER, 12 # actual buffer

convert_to_upper:
  pushl %ebp
  movl %esp, %ebp

  movl ST_BUFFER(%ebp), %eax
  movl ST_BUFFER_LEN(%ebp), %ebx
  movl $0, %edi

  # Leave on empty buffer
  cmpl $0, %ebx
  je end_convert_loop

convert_loop:
  # Get current byte
  movb (%eax,%edi,1), %cl

  # Go to next byte unless it is between
  # 'a' and 'z'
  cmpb $LOWERCASE_A, %cl
  jl next_byte
  cmpb $LOWERCASE_Z, %cl
  jg next_byte

  # Otherwise convert the byte to uppercase
  addb $UPPER_CONVERSION, %cl
  movb %cl, (%eax,%edi,1)

next_byte:
  incl %edi # next byte
  cmpl %edi, %ebx # continue unless end is reached
  jne convert_loop

end_convert_loop:
  movl %ebp, %esp
  popl %ebp
  ret
