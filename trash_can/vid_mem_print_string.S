vid_mem_print_string:
  movl $0xb8000,%edx

vid_mem_print_string.loop:
  movb (%ebx),%al
  orb %al,%al
  jz vid_mem_print_string.done
  movb $0x3,%ah
  mov %eax,(%edx)
  add $1,%ebx
  add $2,%edx
  jmp vid_mem_print_string.loop

vid_mem_print_string:
  ret
