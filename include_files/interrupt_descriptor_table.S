#interrupt descriptor table
set_idt:

idt_start:
.fill 256,8,0          # 256, 64 bits entries, undefined...Kernel's job actually.


idt_end:

idt_pointer:
  .word idt_end - idt_start
  .long idt_start

ret
