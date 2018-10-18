.global the_beginning

the_beginning:

.code16
xor %ax,%ax
ljmp $0x0000,$boot
#=====================================================================================
boot:
  mov %dl,disk
  #save the disk drive in dl
  cli
  #=======================================
  #set stack segment
  movw $0x0000,%ax
  movw %ax,%ss
  movw $0xffff,%ax
  movw %ax,%sp
  movw %ax,%bp
  #=======================================
  #set extended segment
  #movw $0x0,%ax
  #movw %ax,%es
  #=======================================
  sti
  pushw $0xabce

  movb $0x02,%ah           # load second stage to memory
  movb $12,%al             # numbers of sectors to read into memory
  movb disk,%dl            # sector read from fixed/usb disk ;0 for floppy; 0x80 for hd
  movb $0,%ch              # cylinder number
  movb $0,%dh              # head number
  movb $2,%cl              # sector number
  movw $0x7e00,%bx         # load into es:bx segment :offset of buffer
  int $0x13                # disk I/O interrupt

#  jmp second_sector
  jmp second_sector

.fill 510-(. - the_beginning),1,0
.fill 1,2,0xaa55
#end of first sec, no more boundaries...!!
#======================================================================================
.include "vbe.S"
second_sector:
  sti
  movw $0x2401,%ax
  int $0x15                 #enable A20 bit

  mov $0x03,%ax             #set display to text mode
  int $0x10

  call vbe_4f01

  cli

  lgdt gdt_pointer
  lidt idt_pointer

  mov %cr0, %eax
  or $0x1,%eax              #set the protected mode bit on special CPU reg cr0
  mov %eax, %cr0

  ljmp $0x8,$protected_mode #long jump to the code segment CS=CODE_SEG,IP=protected_mode

call set_gdt
call set_idt
#=========================================
#protected mode begings here
.code32
protected_mode:
  mov $DATA_SEG,%ax
  mov %ax,%ds
  mov %ax,%es
  mov %ax,%fs
  mov %ax,%gs
  xor %ax,%ax
  mov $STACK_SEG,%ax
  mov %ax,%ss

  .equ boot_stack_top, 0x90000
  mov $boot_stack_top,%esp
  jmp loop_forever

loop_forever:
  jmp loop_forever

cli
hlt

.include "global_descriptor_table.S"
.include "interrupt_descriptor_table.S"
