  .include "../utils/linux.s"
  .include "../05/imports/record-def.s"

  .section .data
file_name:
  .ascii "./data/test.dat\0"
record_buffer_ptr:
  .long 0

  .section .text

  .globl _start

_start:
  # Initialize memory manager
  call allocate_init

  
  # Allocate memory for record
  pushl $REC_SIZE
  call allocate
  movl %eax, record_buffer_ptr


  .equ ST_INPUT_DESCRIPTOR, -4
  .equ ST_OUTPUT_DESCRIPTOR, -8

  # Copy stack pointer to %ebp
  movl %esp, %ebp
  # Allocate space to hold file descriptors
  subl $8, %esp

  # Open file
  movl $SYS_OPEN, %eax
  movl $file_name, %ebx
  movl $0, %ecx # open read only
  movl $0666, %edx
  int $LINUX_SYSCALL

  # Save file descriptor
  movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

  movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
  pushl ST_INPUT_DESCRIPTOR(%ebp)
  pushl $record_buffer_ptr
  call read_record
  addl $8, %esp

  # Returns the number of bytes read
  # If this is not the same number
  # it's either end-of-file or errer → quit
  cmpl $REC_SIZE, %eax
  jne finished_reading

  
  # Otherwise print out the first name
  movl record_buffer_ptr, %eax
  addl $REC_FIRSTNAME, %eax
  pushl %eax

  call count_chars
  addl $4, %esp
  
  movl %eax, %edx
  movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
  movl $SYS_WRITE, %eax
  movl record_buffer_ptr, %ecx
  addl $REC_FIRSTNAME, %ecx
  int $LINUX_SYSCALL

  pushl ST_OUTPUT_DESCRIPTOR(%ebp)
  call write_newline
  addl $4, %esp

  
  # ... and the last name
  movl record_buffer_ptr, %eax
  addl $REC_LASTNAME, %eax
  call count_chars
  addl $4, %esp
  
  movl %eax, %edx
  movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
  movl $SYS_WRITE, %eax
  movl record_buffer_ptr, %ecx
  addl $REC_LASTNAME, %ecx
  int $LINUX_SYSCALL
  
  pushl ST_OUTPUT_DESCRIPTOR(%ebp)
  call write_newline
  addl $4, %esp


  # ... as well as the address
  movl record_buffer_ptr, %eax
  addl $REC_ADDRESS, %eax
  call count_chars
  addl $4, %esp
  
  movl %eax, %edx
  movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
  movl $SYS_WRITE, %eax
  movl record_buffer_ptr, %ecx
  addl $REC_ADDRESS, %ecx
  int $LINUX_SYSCALL
  
  pushl ST_OUTPUT_DESCRIPTOR(%ebp)
  call write_newline
  addl $4, %esp

  # ... and the age
  movl record_buffer_ptr, %eax
  addl $REC_AGE, %eax
  call count_chars
  addl $4, %esp
  
  movl %eax, %edx
  movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
  movl $SYS_WRITE, %eax
  movl record_buffer_ptr, %ecx
  addl $REC_AGE, %ecx
  int $LINUX_SYSCALL
  
  pushl ST_OUTPUT_DESCRIPTOR(%ebp)
  call write_newline
  addl $4, %esp

  
  jmp record_read_loop

finished_reading:
  pushl record_buffer_ptr
  call deallocate

  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
