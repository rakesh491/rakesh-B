#vbe information structure 512 bytes
vbe_information_structure:
.fill 768,1,0

#vbe mode information structure 256 bytes
vbe_mode_information_structure:
.fill 768,1,0

vbe_4f00:
  movw $0x4f00,%ax
  movw $vbe_information_structure,%di
  int $0x10
  #push vbe_information_structure address to stack for the C function
  pushl $vbe_information_structure
  pushw $0x0000
  call vbe_main_c
  ret


vbe_4f01:
  movw $0x4f01,%ax
  movw $0x103,%cx                # assuming the mode
  movw $vbe_mode_information_structure,%di
  int $0x10
  #push vbe_mode_information_structure address to stack for the C function
  pushl $vbe_mode_information_structure
  pushw $0x0000
  call vbe_main_c
  ret


vbe_4f02:
  mov $0x4F02,%ax       # Set VESA Video Mode
  mov $0x4103,%bx        # res
  int $0x10             # Video Interrupt (VBE)
  call vbe_main_c
  ret
